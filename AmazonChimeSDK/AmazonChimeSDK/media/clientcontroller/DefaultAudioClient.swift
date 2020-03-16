//
//  DefaultAudioClient.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

class DefaultAudioClient: AudioClient {
    private let logger: Logger

    init(logger: Logger) {
        self.logger = logger

        super.init()
    }
    override func audioLogCallBack(_ logLevel: loglevel_t, msg: String!) {
        switch logLevel.rawValue {
        case Constants.errorLevel, Constants.fatalLevel:
            logger.error(msg: msg)
        default:
            break
        }
    }
}
