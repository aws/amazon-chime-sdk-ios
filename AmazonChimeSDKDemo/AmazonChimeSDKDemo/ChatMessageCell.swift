//
//  ChatMessageCell.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import UIKit

let chatMessageCellReuseIdentifier: String = "chatMessageCell"

class ChatMessageCell: UITableViewCell {
    @IBOutlet var senderNameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!

    init(chatMessage: ChatMessage) {
        super.init(style: .default, reuseIdentifier: chatMessageCellReuseIdentifier)
        self.updateCell(chatMessage: chatMessage)
    }

    func updateCell(chatMessage: ChatMessage) {
        senderNameLabel.text = chatMessage.senderName
        senderNameLabel.accessibilityIdentifier = chatMessage.senderName
        messageLabel.text = chatMessage.message
        messageLabel.accessibilityIdentifier = chatMessage.message
        timestampLabel.text = chatMessage.timestamp
        messageLabel.textAlignment = chatMessage.isSelf ? NSTextAlignment.right : NSTextAlignment.left
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
