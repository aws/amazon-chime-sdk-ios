//
//  DebugSettingsModel.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit

class DebugSettingsModel: NSObject {
    var endpointUrl: String = ""
    var primaryExternalMeetingId: String = ""
    // When on, the join request asks the demo backend for FHD video / UHD content features
    var enableHigherDefinitionVideo: Bool = false
}
