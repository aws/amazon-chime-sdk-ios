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
    private let logger = ConsoleLogger(name: "RosterModel")

    private var activeSpeakerIds: [String] = []
    private var attendees = [RosterAttendee]()
    private var currentRoster = [String: RosterAttendee]()

    var rosterUpdatedHandler: (() -> Void)?

    static func convertAttendeeName(from info: AttendeeInfo) -> String {
        // The JS SDK Serverless demo will prepend a UUID to provided names followed by a hash to help uniqueness
        let externalUserIdArray = info.externalUserId.components(separatedBy: "#")
        if externalUserIdArray.isEmpty {
            return "<UNKNOWN>"
        }
        let rosterName: String = externalUserIdArray.count == 2 ? externalUserIdArray[1] : info.externalUserId
        return info.attendeeId.hasSuffix(contentDelimiter) ? "\(rosterName) \(contentSuffix)" : rosterName
    }

    func addAttendees(_ newAttendees: [RosterAttendee]) {
        if newAttendees.isEmpty {
            return
        }
        for attendee in newAttendees {
            currentRoster[attendee.attendeeId] = attendee
        }
        attendees.append(contentsOf: newAttendees)
        attendees.sort(by: attendeeSortPredicate)
    }

    func removeAttendees(_ attendeeIds: [String]) {
        for attendeeId in attendeeIds {
            currentRoster.removeValue(forKey: attendeeId)
        }
        attendees = currentRoster.values.sorted(by: attendeeSortPredicate)
    }

    func contains(attendeeId: String) -> Bool {
        return currentRoster[attendeeId] != nil
    }

    func getAttendeeName(for attendeeId: String) -> String? {
        if let attendee = currentRoster[attendeeId] {
            return attendee.attendeeName
        } else {
            return nil
        }
    }

    func getAttendee(at index: Int) -> RosterAttendee? {
        if index >= attendees.count {
            return nil
        }
        return attendees[index]
    }

    func updateVolume(attendeeId: String, volume: VolumeLevel) {
        guard let attendee = currentRoster[attendeeId] else {
            logger.error(msg: "Cannot find attendee with attendee id \(attendeeId)")
            return
        }
        if attendee.volume != volume {
            attendee.volume = volume
            if let name = attendee.attendeeName {
                logger.info(msg: "Volume changed for \(name): \(volume)")
            }
        }
    }

    func updateSignal(attendeeId: String, signal: SignalStrength) {
        guard let attendee = currentRoster[attendeeId] else {
            logger.error(msg: "Cannot find attendee with attendee id \(attendeeId)")
            return
        }
        if attendee.signal != signal {
            attendee.signal = signal
        }
    }

    func updateActiveSpeakers(_ activeSpeakerIds: [String]) {
        self.activeSpeakerIds = activeSpeakerIds
    }

    private func isActiveSpeaker(attendeeId: String) -> Bool {
        return activeSpeakerIds.contains(attendeeId)
    }

    private let attendeeSortPredicate: (RosterAttendee, RosterAttendee) -> Bool = {
        if let name0 = $0.attendeeName, let name1 = $1.attendeeName {
            return name0 < name1
        }
        return false
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension RosterModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return attendees.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentAttendee = getAttendee(at: indexPath.item) else {
            return UITableViewCell()
        }
        let isActiveSpeaker = self.isActiveSpeaker(attendeeId: currentAttendee.attendeeId)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: rosterTableCellReuseIdentifier) as? RosterTableCell else {
            return RosterTableCell(attendee: currentAttendee, isActiveSpeaker: isActiveSpeaker)
        }
        cell.updateCell(attendee: currentAttendee, isActiveSpeaker: isActiveSpeaker)

        return cell
    }
}
