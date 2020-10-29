//
//  DefaultAudioClient.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import Foundation

class DefaultAudioClient: AudioClient {
    private static var logger: Logger?
    private static var sharedInstance: DefaultAudioClient?

    static func shared(logger: Logger) -> DefaultAudioClient {
        DefaultAudioClient.logger = logger
        if sharedInstance == nil {
            sharedInstance = DefaultAudioClient()
        }
        return sharedInstance!
    }

    override func audioLogCallBack(_ logLevel: loglevel_t, msg: String?) {
        guard let msg = msg else { return }
        switch logLevel.rawValue {
        case Constants.errorLevel, Constants.fatalLevel:
            DefaultAudioClient.logger?.error(msg: msg)
        case Constants.warningLevel, Constants.infoLevel:
            DefaultAudioClient.logger?.debug(debugFunction: { () -> String in
                msg
            })
        default:
            DefaultAudioClient.logger?.default(msg: msg)
        }
    }
}
