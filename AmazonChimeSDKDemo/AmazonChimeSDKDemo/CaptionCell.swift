//
//  CaptionCell.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit

let captionCellReuseIdentifier = "captionCell"

class CaptionCell: UITableViewCell {
    @IBOutlet var speakerNameLabel: UILabel!
    @IBOutlet var captionContentLabel: UILabel!

    init(caption: Caption, indexPath: IndexPath) {
        super.init(style: .default, reuseIdentifier: captionCellReuseIdentifier)
        self.updateCell(caption: caption, indexPath: indexPath)
    }

    func updateCell(caption: Caption, indexPath: IndexPath) {
        self.contentView.backgroundColor = caption.speakerName.isEmpty ? .lightGray : .none
        speakerNameLabel.text = caption.speakerName
        speakerNameLabel.accessibilityIdentifier = caption.speakerName
        captionContentLabel.text = caption.content
        captionContentLabel.accessibilityIdentifier = "caption-\(indexPath.row)"
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
