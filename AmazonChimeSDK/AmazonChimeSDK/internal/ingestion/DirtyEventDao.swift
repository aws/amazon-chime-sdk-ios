//
//  DirtyEventDao.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

protocol DirtyEventDao {

    /// Query dirty meeting events items which includes all the fields in the table
    /// - Parameter size: size to query
    func queryDirtyMeetingEventItems(size: Int) -> [DirtyMeetingEventItem]

    /// Delete dirty events by given ids
    /// - Parameter ids: ids of dirty events
    func deleteDirtyMeetingEventsByIds(ids: [String]) -> Bool

    /// Insert multiple dirty meeting events
    /// - Parameter dirtyEvents: list of DirtyMeetingEventItem
    func insertDirtyMeetingEventItems(dirtyEvents: [DirtyMeetingEventItem]) -> Bool
}
