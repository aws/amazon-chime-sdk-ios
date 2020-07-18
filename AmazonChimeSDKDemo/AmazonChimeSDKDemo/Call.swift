//
//  Call.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit

class Call {
    static let maxIncomingCallAnswerTime = 10.0

    let uuid: UUID
    let handle: String
    let isOutgoing: Bool

    private var endCallBackgroundTaskId: UIBackgroundTaskIdentifier = .invalid

    var isOnHold = false {
        didSet {
            isOnHoldHandler?(isOnHold)
        }
    }

    var isMuted = false {
        didSet {
            isMutedHandler?(isMuted)
        }
    }

    var isUnansweredCallTimerActive = false {
        didSet {
            if isUnansweredCallTimerActive {
                endCallBackgroundTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + Call.maxIncomingCallAnswerTime) {
                    if self.endCallBackgroundTaskId != .invalid {
                        self.isUnansweredHandler?()
                        self.isUnansweredCallTimerActive = false
                    }
                }
            } else {
                UIApplication.shared.endBackgroundTask(endCallBackgroundTaskId)
                self.endCallBackgroundTaskId = .invalid
            }
        }
    }

    var isConnectingHandler: (() -> Void)?
    var isConnectedHandler: (() -> Void)?
    var isReadytoConfigureHandler: (() -> Void)?
    var isAudioSessionActiveHandler: (() -> Void)?
    var isEndedHandler: (() -> Void)?
    var isOnHoldHandler: ((Bool) -> Void)?
    var isMutedHandler: ((Bool) -> Void)?
    var isUnansweredHandler: (() -> Void)?

    init(uuid: UUID, handle: String, isOutgoing: Bool) {
        self.uuid = uuid
        self.handle = handle
        self.isOutgoing = isOutgoing
    }
}
