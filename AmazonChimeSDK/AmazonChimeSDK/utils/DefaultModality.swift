//
//  DefaultModality.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `DefaultModality` is a backwards compatible extension of the
/// attendee id (UUID string) and session token schemas (base 64 string).
/// It appends #<modality> to either string, which indicates the modality
/// of the participant.
///
/// For example,
/// `attendeeId`: "abcdefg"
/// `contentAttendeeId`: "abcdefg#content"
/// `DefaultModality(id: contentAttendeeId).base`: "abcdefg"
/// `DefaultModality(id: contentAttendeeId).modality`: "content"
/// `DefaultModality(id: contentAttendeeId).isOfType(type: .content)`: true
@objcMembers public class DefaultModality: NSObject {
    public let id: String
    public let base: String
    public let modality: String?
    public static let separator: Character = "#"

    public init(id: String) {
        self.id = id
        let substrings = id.split(separator: DefaultModality.separator)
        base = String(substrings[0])
        if substrings.count == 2 {
            modality = String(substrings[1])
        } else {
            modality = nil
        }
    }

    public func isOfType(type: ModalityType) -> Bool {
        return modality == type.description
    }
}
