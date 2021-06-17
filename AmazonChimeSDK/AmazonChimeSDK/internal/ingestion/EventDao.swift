//
//  EventDao.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

protocol EventDao {

    /// Query meeting events items which includes all the fields in the table
    /// - Parameter size: size of list to return
    func queryMeetingEventItems(size: Int) -> [MeetingEventItem]

    /// Insert a meeting event item
    /// - Parameter event: event to insert
    func insertMeetingEvent(event: MeetingEventItem) -> Bool

    /// Delete meeting events by given uuids
    /// - Parameter ids: ids of meeting events to delete
    func deleteMeetingEventsByIds(ids: [String]) -> Bool
}
