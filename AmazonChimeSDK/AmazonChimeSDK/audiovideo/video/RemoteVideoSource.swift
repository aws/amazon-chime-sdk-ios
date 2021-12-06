//
//  RemoteVideoSource.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class RemoteVideoSource: NSObject {
    public var attendeeId: String
    
    public init(attendeeId: String) {
        self.attendeeId = attendeeId
    }
    
    static func ==(lhs: RemoteVideoSource, rhs: RemoteVideoSource) -> Bool {
       return lhs.attendeeId == rhs.attendeeId
    }
}
