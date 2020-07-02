//
//  MetricsTableCell.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit

let metricsTableCellReuseIdentifier = "metricsCell"

class MetricsTableCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!

    init(name: String, value: String) {
        super.init(style: .default, reuseIdentifier: metricsTableCellReuseIdentifier)

        updateCell(name: name, value: value)
    }

    func updateCell(name: String, value: String) {
        nameLabel.text = name
        nameLabel.accessibilityIdentifier = "\(name) metric"
        valueLabel.text = value
        valueLabel.accessibilityIdentifier = "\(name) value"
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
