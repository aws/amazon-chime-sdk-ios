//
//  RosterTableCell.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import UIKit

let rosterTableCellReuseIdentifier: String = "rosterCell"

class RosterTableCell: UITableViewCell {
    @IBOutlet var attendeeName: UILabel!
    @IBOutlet var indicator: UIView!
    @IBOutlet var speakLevel: UIImageView!

    init(attendee: RosterAttendee, isActiveSpeaker: Bool) {
        super.init(style: .default, reuseIdentifier: rosterTableCellReuseIdentifier)

        updateCell(attendee: attendee, isActiveSpeaker: isActiveSpeaker)
    }

    func updateCell(attendee: RosterAttendee, isActiveSpeaker: Bool) {
        attendeeName.text = attendee.attendeeName
        attendeeName.accessibilityIdentifier = attendee.attendeeName

        if attendee.volume == .notSpeaking {
            accessibilityIdentifier = "\(attendee.attendeeName ?? "") Not Speaking"
        } else if attendee.volume == .muted {
            accessibilityIdentifier = "\(attendee.attendeeName ?? "") Muted"
        } else {
            accessibilityIdentifier = "\(attendee.attendeeName ?? "") Speaking"
        }

        indicator.isHidden = !isActiveSpeaker
        indicator.accessibilityIdentifier = isActiveSpeaker ? "\(attendee.attendeeName ?? "") Active" : ""
        indicator.layer.cornerRadius = indicator.frame.size.width / 2.0
        speakLevel.tintColor = .systemGray

        speakLevel.image = getSpeakLevelImage(signal: attendee.signal, volume: attendee.volume)
    }

    private func getSpeakLevelImage(signal: SignalStrength, volume: VolumeLevel) -> UIImage? {
        var image: UIImage?
        if signal != .high {
            if volume == .muted {
                image = UIImage(named: "signal-poor-muted")
            } else {
                image = UIImage(named: "signal-poor")
            }
        } else {
            switch volume {
            case .muted:
                image = UIImage(named: "volume-muted")
            case .notSpeaking:
                image = UIImage(named: "volume-0")
            case .low:
                image = UIImage(named: "volume-1")
            case .medium:
                image = UIImage(named: "volume-2")
            case .high:
                image = UIImage(named: "volume-3")
            @unknown default:
                break
            }
        }
        return image?.withRenderingMode(.alwaysTemplate)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
