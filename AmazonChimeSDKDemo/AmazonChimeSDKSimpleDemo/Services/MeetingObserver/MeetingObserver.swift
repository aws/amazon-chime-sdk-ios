//
//  MeetingObserver.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

protocol MeetingObserver: AnyObject {
    
    func meetingEnded()
    
    func muteStatesDidUpdate()
    
    func attendeesDidUpdate()
    
    func videoTileStatesDidUpdate()
}
