//
//  DataMessage.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import Foundation

/// Data message received from server.
@objcMembers public class DataMessage: NSObject {
    /// Monotonically increasing server ingest time
    public let timestampMs: Int64

    /// Topic this message was sent on
    public let topic: String

    /// Data payload
    public let data: Data

    /// Sender attendee
    public let senderAttendeeId: String

    /// Sender attendee external user Id
    public let senderExternalUserId: String

    /// true if server throttled or rejected message,
    /// false if server has posted the message to its recipients or it's not a sender receipt
    public let throttled: Bool

    /// Initiailize a DataMessage object
    /// - Parameters:
    ///     - topic: The topic of this data message belongs to
    ///     - data: Data payload
    ///     - senderAttendeeId: Attendee Id
    ///     - senderExternalUserId: Attendee external user ID
    ///     - timestampMs: Monotonically increasing server ingest time
    ///     - throttled: if server throttled or rejected message

    public init(topic: String,
                data: Data,
                senderAttendeeId: String,
                senderExternalUserId: String,
                timestampMs: Int64,
                throttled: Bool) {
        self.topic = topic
        self.data = data
        self.senderAttendeeId = senderAttendeeId
        self.senderExternalUserId = senderExternalUserId
        self.timestampMs = timestampMs
        self.throttled = throttled
    }

    /// Convenience way to initialize DataMessage object with Internal DataMessage
    /// - Parameters:
    ///     - message: A Internal datamessage object
    convenience init(message: DataMessageInternal) {
        self.init(topic: message.topic,
                  data: message.data,
                  senderAttendeeId: message.senderAttendeeId,
                  senderExternalUserId: message.senderExternalUserId,
                  timestampMs: message.timestampMs,
                  throttled: Bool(message.throttled))
    }

    /// Marshal data byte array to String
    /// - Returns: utf8 encoding string of data, null if data contains non utf8 characters
    public func text() -> String? {
        return String(data: self.data, encoding: .utf8)
    }

    /// Try deserialize data byte array to swift basic collection type
    /// - Returns: null if not deserializable, or swift basic collection type
    public func fromJSON() -> Any? {
        do {
            let json = try JSONSerialization.jsonObject(with: self.data)
            return json
        } catch {
            return nil
        }
    }
}
