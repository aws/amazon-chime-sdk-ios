//
//  DefaultVideoClient.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import Foundation

class DefaultVideoClient: VideoClient {
    private let logger: Logger

    init(logger: Logger) {
        self.logger = logger

        super.init()
    }

    override func videoLogCallBack(_ logLevel: video_client_loglevel_t, msg: String!) {
        switch logLevel.rawValue {
        case Constants.errorLevel, Constants.fatalLevel:
            logger.error(msg: msg)
        default:
            break
        }
    }
}
