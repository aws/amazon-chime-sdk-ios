//
//  SessionStateStore.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AmazonChimeSDK

class SessionStateStore {
    
    private let meetingNftCenter = MeetingNotificationCenter.shared
    
    var meetingId: String?
    
    var localAttendeeName: String?
    
    var localAttendeeId: String?
    
    var session: DefaultMeetingSession?
     
    // Use array to keep the order
    private(set) var attendees = [AttendeeInfo]() {
        didSet {
            meetingNftCenter.notifyAttendeesDidUpdate()
        }
    }
    
    // Storing the attendee IDs who enabled video
    private(set) var videoAttendess = [String]()
    
    // [AttendeeId: VideoTileState]
    private(set) var videoTileStates = [String: VideoTileState]() {
        didSet {
            meetingNftCenter.notifyVideoTileStatesDidUpdate()
        }
    }
    
    private(set) var muteStates = [String: Bool]() {
        didSet {
            self.meetingNftCenter.notifyMuteStatesUpdate()
        }
    }
    
    var isMuted: Bool {
        get {
            guard let attendeeId = self.localAttendeeId else {
                return false
            }
            return self.muteStates[attendeeId] ?? false
        }
    }
    
    func addAttendees(attendees: [AttendeeInfo]) {
        self.attendees.append(contentsOf: attendees)
    }
    
    func removeAttendees(attendeesToRemove: [AttendeeInfo]) {
        let attendeeIdsToRemove = Set(attendeesToRemove.map { $0.attendeeId })
        self.attendees.removeAll { currentAttendee in
            return attendeeIdsToRemove.contains(currentAttendee.attendeeId)
        }
    }
    
    func addVideoTileState(attendeeId: String, tileState: VideoTileState) {
        self.videoAttendess.append(attendeeId)
        self.videoTileStates[attendeeId] = tileState
    }
    
    func removeVideoTileState(attendeeId: String) {
        self.videoAttendess.removeAll { currentAttendee in
            return currentAttendee == attendeeId
        }
        self.videoTileStates.removeValue(forKey: attendeeId)
    }
    
    func setMuteState(attendeeId: String, isMuted: Bool) {
        self.muteStates[attendeeId] = isMuted
    }
    
    func clear() {
        self.meetingId = nil
        self.localAttendeeName = nil
        self.localAttendeeId = nil
        self.session = nil
        self.attendees.removeAll()
        self.videoTileStates.removeAll()
        self.muteStates.removeAll()
        self.videoAttendess.removeAll()
    }
}
