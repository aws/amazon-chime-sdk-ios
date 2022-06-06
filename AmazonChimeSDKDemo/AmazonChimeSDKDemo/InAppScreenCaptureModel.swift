//
//  InAppScreenCaptureModel.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import Foundation

class InAppScreenCaptureModel {
    let logger = ConsoleLogger(name: "InAppScreenCaptureModel")
    let contentShareController: ContentShareController
    var isSharingHandler: ((Bool) -> Void)?

    var isSharing = false {
        willSet(newValue) {
            if newValue == isSharing {
                return
            }
            if newValue {
                inAppScreenCaptureSource?.addCaptureSourceObserver(observer: self)
                inAppScreenCaptureSource?.start()
                isSharingHandler?(true)
            } else {
                inAppScreenCaptureSource?.stop()
                isSharingHandler?(false)
            }
        }
    }

    lazy var inAppScreenCaptureSource: VideoCaptureSource? = {
        if #available(iOS 11.0, *) {
            return InAppScreenCaptureSource(logger: logger)
        }
        return nil
    }()

    init(contentShareController: ContentShareController) {
        self.contentShareController = contentShareController
        self.contentShareController.addContentShareObserver(observer: self)
    }
}

extension InAppScreenCaptureModel: CaptureSourceObserver {
    func captureDidStart() {
        logger.info(msg: "InAppScreenCaptureSource did start")
        let contentShareSource = ContentShareSource()
        contentShareSource.videoSource = inAppScreenCaptureSource
        contentShareController.startContentShare(source: contentShareSource)
    }

    func captureDidStop() {
        logger.info(msg: "InAppScreenCaptureSource did stop")
        contentShareController.stopContentShare()
        inAppScreenCaptureSource?.removeCaptureSourceObserver(observer: self)
    }

    func captureDidFail(error: CaptureSourceError) {
        logger.error(msg: "InAppScreenCaptureSource did fail: \(error.description)")
        isSharing = false
        contentShareController.stopContentShare()
        inAppScreenCaptureSource?.removeCaptureSourceObserver(observer: self)
    }
}

extension InAppScreenCaptureModel: ContentShareObserver {
    func contentShareDidStart() {}

    func contentShareDidStop(status: ContentShareStatus) {
        if isSharing {
            isSharing = false
        }
    }
}
