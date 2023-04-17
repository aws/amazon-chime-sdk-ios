//
//  RosterModel.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import UIKit

class RosterModel: NSObject {
    private static let contentDelimiter = "#content"
    private static let contentSuffix = "<<Content>>"

    static func convertAttendeeName(from info: AttendeeInfo) -> String {
        // The JS SDK Serverless demo will prepend a UUID to provided names followed by a hash to help uniqueness
        let externalUserIdArray = info.externalUserId.components(separatedBy: "#")
        if externalUserIdArray.isEmpty {
            return "<UNKNOWN>"
        }
        let rosterName: String = externalUserIdArray.count == 2 ? externalUserIdArray[1] : info.externalUserId
        return info.attendeeId.hasSuffix(contentDelimiter) ? "\(rosterName) \(contentSuffix)" : rosterName
    }
}
