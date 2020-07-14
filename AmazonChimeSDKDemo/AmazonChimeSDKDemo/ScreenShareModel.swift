//
//  ScreenShareModel.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

class ScreenShareModel: NSObject {
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
}
