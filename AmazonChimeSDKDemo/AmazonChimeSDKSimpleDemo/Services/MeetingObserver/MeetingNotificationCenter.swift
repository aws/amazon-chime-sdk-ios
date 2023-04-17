//
//  MeetingNotificationCenter.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

class MeetingNotificationCenter {
    
    static var shared = MeetingNotificationCenter()
    
    private var meetingObservers = [MeetingObserverWeakReference]()
    
    private init() {}
    
    func addObserver(_ observer: MeetingObserver) {
        for currentObserver in meetingObservers where currentObserver.value === observer {
            return
        }
        let weakObserver = MeetingObserverWeakReference(observer)
        self.meetingObservers.append(weakObserver)
    }
    
    func removeObserver(_ observer: MeetingObserver) {
        self.meetingObservers.removeAll { $0.value === observer}
    }
    
    func notifyMuteStatesUpdate() {
        for observer in meetingObservers {
            observer.value?.muteStatesDidUpdate()
        }
    }
    
    func notifyAttendeesDidUpdate() {
        for observer in meetingObservers {
            observer.value?.attendeesDidUpdate()
        }
    }
    
    func notifyVideoTileStatesDidUpdate() {
        for observer in meetingObservers {
            observer.value?.videoTileStatesDidUpdate()
        }
    }
    
    func notifyMeetingEnded() {
        for observer in meetingObservers {
            observer.value?.meetingEnded()
        }
    }
}
