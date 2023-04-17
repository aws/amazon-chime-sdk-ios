//
//  Call.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit

class Call {

    let uuid: UUID
    let handle: String
    let isOutgoing: Bool

    init(uuid: UUID, handle: String, isOutgoing: Bool) {
        self.uuid = uuid
        self.handle = handle
        self.isOutgoing = isOutgoing
    }
}
