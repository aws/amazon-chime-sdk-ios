//
//  ChatModel.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import UIKit

extension DataMessage {
    func chatMessage() -> ChatMessage? {
        let senderNameComponents = self.senderExternalUserId.components(separatedBy: "#")
        let senderName = senderNameComponents.count > 1 ? senderNameComponents[1] : self.senderExternalUserId
        let message = self.text()
        let timestamp = TimeStampConversion.formatTimestamp(timestamp: self.timestampMs)
        if let messageNotNull = message {
            let msg = ChatMessage(senderName: senderName, message: messageNotNull, timestamp: timestamp, isSelf: false)
            return msg
        }
        return nil
    }
}

struct ChatMessage {
    var senderName: String
    var message: String
    var timestamp: String
    var isSelf: Bool
}

class ChatModel: NSObject {
    private var chatMessages: [ChatMessage] = []
    private let logger = ConsoleLogger(name: "ChatModel")
    var refreshChatTableHandler: (() -> Void)?
    public func addDataMessage(dataMessage: DataMessage) {
        guard let message = dataMessage.chatMessage() else {
            return
        }

        if !dataMessage.throttled {
            self.addChatMessage(chatMessage: message)
        }
    }

    public func addChatMessage(chatMessage: ChatMessage) {
        self.chatMessages.append(chatMessage)
        refreshChatTableHandler?()
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension ChatModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return chatMessages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatMessage = chatMessages[indexPath.item]

        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: chatMessageCellReuseIdentifier) as? ChatMessageCell
        else {
            return ChatMessageCell(chatMessage: chatMessage)
        }
        cell.updateCell(chatMessage: chatMessage)
        return cell
    }
}
