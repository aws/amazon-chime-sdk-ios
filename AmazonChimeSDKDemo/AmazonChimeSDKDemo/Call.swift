//
//  Call.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

class Call {
    let uuid: UUID
    let handle: String
    let isOutgoing: Bool

    var isOnHold = false {
        didSet {
            isOnHoldHander?(isOnHold)
        }
    }
    var isMuted = false {
        didSet {
            isMutedHandler?(isMuted)
        }
    }

    var isConnectingHandler: (() -> Void)?
    var isConnectedHandler: (() -> Void)?
    var isReadytoConfigureHandler: (() -> Void)?
    var isAudioSessionActiveHandler: (() -> Void)?
    var isEndedHandler: (() -> Void)?
    var isOnHoldHander: ((Bool) -> Void)?
    var isMutedHandler: ((Bool) -> Void)?

    init(uuid: UUID, handle: String, isOutgoing: Bool) {
        self.uuid = uuid
        self.handle = handle
        self.isOutgoing = isOutgoing
    }
}
