//
//  RosterTableCell.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit

class RosterTableCell: UITableViewCell {
    @IBOutlet var attendeeName: UILabel!
    @IBOutlet var indicator: UIView!
    @IBOutlet var metricName: UILabel!
    @IBOutlet var metricValue: UILabel!
    @IBOutlet var speakLevel: UIImageView!
}
