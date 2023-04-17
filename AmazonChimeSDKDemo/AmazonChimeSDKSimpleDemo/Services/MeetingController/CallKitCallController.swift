//
//  CallKitMeetingController.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import CallKit
import UIKit
import AmazonChimeSDK

class CallKitMeetingController: NSObject, MeetingController {
    
    private let meetingManager = MeetingManager.shared
    private let callKitManager = CallKitManager.shared
    
    private let callKitController: CXCallController
    
    private var meetingId = ""
    private var attendeeName = ""
    private var succeeded: () -> Void = {}
    private var failed: (Error) -> Void = {_ in }
    
    var isMuted: Bool {
        get {
            return meetingManager.isMuted
        } set {
            guard newValue != isMuted else {
                return
            }
            let muteAction = CXSetMutedCallAction(call: self.callKitManager.callUuid,
                                                  muted: newValue)
            let transaction = CXTransaction(action: muteAction)
            self.callKitController.request(transaction) { _ in
                
            }
        }
    }
    
    override init() {
        self.callKitController = CXCallController()
        super.init()
        self.callKitManager.setCXProviderDelegate(delegate: self)
    }
    
    func joinMeeting(meetingId: String,
                     attendeeName: String,
                     succeeded: @escaping () -> Void,
                     failed: @escaping (Error) -> Void) {
        
        self.meetingId = meetingId
        self.attendeeName = attendeeName
        self.succeeded = succeeded
        self.failed = failed
        
        self.callKitManager.refreshUuid()
        
        let call = Call(uuid: self.callKitManager.callUuid,
                        handle: meetingId,
                        isOutgoing: true)
        self.callKitManager.startOutgoingCall(with: call)
    }
    
    func leaveMeeting() {
        let call = Call(uuid: self.callKitManager.callUuid,
                        handle: self.meetingManager.sessionStateStore.meetingId ?? "",
                        isOutgoing: true)
        self.callKitManager.endCallFromLocal(with: call)
    }
    
    func startLocalVideo() {
        self.meetingManager.startLocalVideo()
    }
    
    func stopLocalVideo() {
        self.meetingManager.stopLocalVideo()
    }
    
    func bindView(videoView: VideoRenderView, attendeeId: String) {
        self.meetingManager.bindVideo(videoView: videoView, attendeeId: attendeeId)
    }
}

extension CallKitMeetingController: CXProviderDelegate {
    
    func providerDidReset(_: CXProvider) {
        self.meetingManager.leaveMeeting()
    }

    func providerDidBegin(_: CXProvider) {}

    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        
        provider.reportOutgoingCall(with: self.callKitManager.callUuid,
                                    startedConnectingAt: Date())
        self.meetingManager.joinMeeting(meetingId: self.meetingId,
                                        attendeeName: self.attendeeName,
                                        enableCallKit: true,
                                        enableVoiceFocus: true) { [weak self] in
            self?.succeeded()
            action.fulfill()
        } failed: { [weak self] error in
            self?.failed(error)
            action.fail()
        }
    }

    func provider(_: CXProvider, perform action: CXEndCallAction) {
        self.meetingManager.leaveMeeting()
        action.fulfill()
    }
    
    func provider(_: CXProvider, perform action: CXSetMutedCallAction) {
        self.meetingManager.isMuted = action.isMuted
        action.fulfill()
    }
}
