//
//  CaptionCell.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit
import AmazonChimeSDK

let captionCellReuseIdentifier = "captionCell"
let lowItemConfidenceThreshold = 0.3
let filteredCaptionFirstIndex: Character = "["

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
        captionContentLabel.accessibilityIdentifier = "caption-\(indexPath.row)"
        // Highlight identified/redacted PIIs in green.
        let coloredString = NSMutableAttributedString.init(string: caption.content)
        caption.entities?.forEach { word in
            var firstOccurance = caption.content.startIndex
            while firstOccurance < caption.content.endIndex,
                  let range = (caption.content).range(of: word, range: firstOccurance..<caption.content.endIndex),
                  !range.isEmpty {
                let index = caption.content.distance(from: caption.content.startIndex, to: range.lowerBound)
                coloredString.addAttribute(
                    NSAttributedString.Key.foregroundColor,
                    value: UIColor.green,
                    range: NSRange(location: index, length: word.count))
                firstOccurance = range.upperBound
            }
        }
        // Underline low confidence words in red. 
        caption.items?.forEach { item in
            let word = item.content
            let hasLowConfidence = (item.confidence ?? 1.0) < lowItemConfidenceThreshold && item.confidence != 0
            let isCorrectContentType = word.first != filteredCaptionFirstIndex && item.type != TranscriptItemType.punctuation
            let range = (caption.content as NSString).range(of: word)
            if hasLowConfidence && isCorrectContentType && caption.content.contains(word) {
                coloredString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSNumber(value: 1), range: range)
                coloredString.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.red, range: range)
            }
        }
        captionContentLabel.attributedText = coloredString
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
