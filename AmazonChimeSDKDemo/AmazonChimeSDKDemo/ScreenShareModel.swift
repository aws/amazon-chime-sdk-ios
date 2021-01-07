//
//  ScreenShareModel.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import Foundation

class ScreenShareModel: NSObject {
    let inAppCaptureModel: InAppScreenCaptureModel
    let broadcastCaptureModel: BroadcastScreenCaptureModel

    var tileId: Int? {
        didSet {
            tileIdDidSetHandler?(tileId)
        }
    }

    var isAvailable: Bool {
        return tileId != nil
    }

    var tileIdDidSetHandler: ((Int?) -> Void)?
    var viewUpdateHandler: ((Bool) -> Void)?

    init(meetingSessionConfig: MeetingSessionConfiguration,
         contentShareController: ContentShareController) {
        self.broadcastCaptureModel = BroadcastScreenCaptureModel(meetingSessionConfig: meetingSessionConfig)
        self.inAppCaptureModel = InAppScreenCaptureModel(contentShareController: contentShareController)
        super.init()
        inAppCaptureModel.isSharingHandler = { [weak self] isSharing in
            if isSharing {
                self?.broadcastCaptureModel.isBlocked = true
            } else {
                self?.broadcastCaptureModel.isBlocked = false
            }
        }
    }

    func stopLocalSharing() {
        inAppCaptureModel.isSharing = false
        broadcastCaptureModel.isBlocked = true
    }
}
