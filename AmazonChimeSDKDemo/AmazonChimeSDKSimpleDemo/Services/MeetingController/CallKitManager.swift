//
//  CallKitManager.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AmazonChimeSDK
import CallKit
import UIKit

class CallKitManager: NSObject {
    
    static let shared = CallKitManager()
    
    private let logger = ConsoleLogger(name: "CallKitManager")
    private let callController = CXCallController()
    private let provider: CXProvider
    private(set) var callUuid = UUID()

    override init() {
        let configuration = CXProviderConfiguration(localizedName: "Chime SDK Demo")
        configuration.maximumCallGroups = 1
        configuration.maximumCallsPerCallGroup = 1
        configuration.supportsVideo = true
        configuration.supportedHandleTypes = [.generic]
        configuration.iconTemplateImageData = UIImage(named: "callkit-icon")?.pngData()
        provider = CXProvider(configuration: configuration)
        super.init()
    }

    deinit {
        provider.invalidate()
    }
    
    func setCXProviderDelegate(delegate: CXProviderDelegate) {
        provider.setDelegate(delegate, queue: nil)
    }
    
    func refreshUuid() {
        self.callUuid = UUID()
    }

    // Start an outging call
    func startOutgoingCall(with call: Call) {
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
    
    func reportOutgoingCall(with uuid: UUID, startedConnectingAt: Date) {
        self.provider.reportOutgoingCall(with: uuid, startedConnectingAt: startedConnectingAt)
    }
}
