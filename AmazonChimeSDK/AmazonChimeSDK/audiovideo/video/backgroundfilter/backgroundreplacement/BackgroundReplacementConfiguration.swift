//
//  BackgroundReplacementConfiguration.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import UIKit

@objcMembers public class BackgroundReplacementConfiguration: NSObject {
    let backgroundReplacementImage: UIImage
    let logger: Logger
    let backgroundFilterProcessor: BackgroundFilterProcessor

    public init(logger: Logger, backgroundReplacementImage: UIImage) {
        self.backgroundReplacementImage = backgroundReplacementImage
        self.logger = logger
        self.backgroundFilterProcessor = BackgroundFilterProcessor(logger: logger)
    }
}
