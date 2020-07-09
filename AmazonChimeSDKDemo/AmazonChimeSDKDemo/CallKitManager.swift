//
//  CallKitManager.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import AVFoundation
import CallKit
import UIKit

class CallKitManager: NSObject {
    private static var sharedInstance: CallKitManager?

    private let logger = ConsoleLogger(name: "CallKitManager")
    private let callController = CXCallController()
    private let provider: CXProvider

    private(set) var calls: [Call] = []
    private(set) var activeCall: Call?

    static func shared() -> CallKitManager {
        if sharedInstance == nil {
            sharedInstance = CallKitManager()
        }
        return sharedInstance!
    }

    override init() {
        let configuration = CXProviderConfiguration(localizedName: "Chime SDK Demo")
        configuration.maximumCallGroups = 1
        configuration.maximumCallsPerCallGroup = 1
        configuration.supportsVideo = true
        configuration.supportedHandleTypes = [.generic]
        provider = CXProvider(configuration: configuration)
        super.init()
        provider.setDelegate(self, queue: nil)
    }

    deinit {
        provider.invalidate()
    }

    // Start an outging call
    func startOutgoingCall(with call: Call) {
        calls.append(call)
        let handle = CXHandle(type: .generic, value: call.handle)
        let startCallAction = CXStartCallAction(call: call.uuid, handle: handle)
        let transaction = CXTransaction(action: startCallAction)

        callController.request(transaction) { error in
            if let error = error {
                self.logger.error(msg: "Error requesting CXStartCallAction transaction: \(error)")
            } else {
                self.logger.info(msg: "Requested CXStartCallAction transaction successfully")
            }
        }
    }

    // This is normally called after receiving a VoIP Push Notification to handle incoming call
    func reportNewIncomingCall(with call: Call) {
        calls.append(call)
        let handle = CXHandle(type: .generic, value: call.handle)
        let update = CXCallUpdate()
        update.remoteHandle = handle
        update.supportsDTMF = false
        update.supportsHolding = true
        update.supportsGrouping = false
        update.supportsUngrouping = false
        update.hasVideo = false

        provider.reportNewIncomingCall(with: call.uuid, update: update, completion: { error in
            if let error = error {
                self.logger.error(msg: "Error reporting new incoming call: \(error.localizedDescription)")
            } else {
                self.logger.info(msg: "Report new incoming call successfully")
            }
        })

        call.isUnansweredHandler = { [weak self] in
            self?.endCallFromLocal(with: call)
            self?.logger.info(msg: "Incoming call not answered within \(Call.maxIncomingCallAnswerTime) sec")
        }
        call.isUnansweredCallTimerActive = true
    }

    // End the call from the app. This is not needed when user end the call from the native CallKit UI
    func endCallFromLocal(with call: Call) {
        let endCallAction = CXEndCallAction(call: call.uuid)
        let transaction = CXTransaction(action: endCallAction)
        callController.request(transaction, completion: { error in
            if let error = error {
                self.logger.error(msg: "Error requesting CXEndCallAction transaction: \(error)")
            } else {
                self.logger.info(msg: "Requested CXEndCallAction transaction successfully")
            }
        })
    }

    // Mute or unmute from the app. This is to sync the CallKit UI with app UI
    func setMuted(for call: Call, isMuted: Bool) {
        let setMutedAction = CXSetMutedCallAction(call: call.uuid, muted: isMuted)
        let transaction = CXTransaction(action: setMutedAction)
        callController.request(transaction, completion: { error in
            if let error = error {
                self.logger.error(msg: "Error requesting CXSetMutedCallAction transaction: \(error)")
            } else {
                self.logger.info(msg: "Requested CXSetMutedCallAction transaction successfully")
            }
        })
    }

    // This is to resume call from the app. When the interrupting call is ended from Remote,
    // provider::perform::CXSetMutedCallAction will not be called automatically
    func setHeld(with call: Call, isOnHold: Bool) {
        let setHeldCallAction = CXSetHeldCallAction(call: call.uuid, onHold: isOnHold)
        let transaction = CXTransaction(action: setHeldCallAction)
        callController.request(transaction, completion: { error in
            if let error = error {
                self.logger.error(msg: "Error requesting CXSetHeldCallAction transaction: \(error)")
            } else {
                self.logger.info(msg: "Requested CXSetHeldCallAction \(isOnHold) transaction successfully")
            }
        })
    }

    // Use this to notify CallKit the call is disconnected
    func reportCallEndedFromRemote(with call: Call, reason: CXCallEndedReason) {
        provider.reportCall(with: call.uuid, endedAt: Date(), reason: reason)
    }

    private func getCall(with uuid: UUID) -> Call? {
        return calls.first(where: { $0.uuid == uuid })
    }

    private func removeCall(_ call: Call) {
        calls.removeAll(where: { $0 === call })
    }

    private func clearCalls() {
        calls = []
    }
}

// MARK: CXProviderDelegate

extension CallKitManager: CXProviderDelegate {
    func providerDidReset(_: CXProvider) {
        for call in calls {
            call.isEndedHandler?()
        }
        clearCalls()
    }

    func providerDidBegin(_: CXProvider) {}

    func provider(_: CXProvider, perform action: CXStartCallAction) {
        if let call = getCall(with: action.callUUID) {
            call.isReadytoConfigureHandler?()
            activeCall = call

            // This is needed for CallKit to know the state of the outgoing call
            call.isConnectingHandler = { [weak self] in
                self?.provider.reportOutgoingCall(with: call.uuid, startedConnectingAt: Date())
            }
            // This is needed for CallKit to calculate outgoing call duration
            call.isConnectedHandler = { [weak self] in
                self?.provider.reportOutgoingCall(with: call.uuid, connectedAt: Date())
            }
            action.fulfill()
        } else {
            action.fail()
        }
    }

    func provider(_: CXProvider, perform action: CXAnswerCallAction) {
        if let call = getCall(with: action.callUUID) {
            call.isReadytoConfigureHandler?()
            activeCall = call
            call.isUnansweredCallTimerActive = false
            action.fulfill()
        } else {
            action.fail()
        }
    }

    func provider(_: CXProvider, perform action: CXEndCallAction) {
        if let call = getCall(with: action.callUUID) {
            call.isEndedHandler?()
            action.fulfill()
            removeCall(call)
        } else {
            action.fail()
        }
    }

    func provider(_: CXProvider, perform action: CXSetHeldCallAction) {
        if let call = getCall(with: action.callUUID) {
            call.isOnHold = action.isOnHold
            action.fulfill()
        } else {
            action.fail()
        }
    }

    func provider(_: CXProvider, perform action: CXSetMutedCallAction) {
        if let call = getCall(with: action.callUUID) {
            call.isMuted = action.isMuted
            action.fulfill()
        } else {
            action.fail()
        }
    }

    func provider(_: CXProvider, timedOutPerforming _: CXAction) {}

    func provider(_: CXProvider, didActivate _: AVAudioSession) {
        if let call = activeCall {
            call.isAudioSessionActiveHandler?()
        }
    }

    func provider(_: CXProvider, didDeactivate _: AVAudioSession) {}
}
