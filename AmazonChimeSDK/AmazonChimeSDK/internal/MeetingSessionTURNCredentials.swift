//
//  MeetingSessionTURNCredentials.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import Foundation

struct MeetingSessionTURNCredentials: Codable {
    let username: String
    let password: String
    let ttl: Int
    let uris: [String]

    func toTURNSessionResponse(urlRewriter: URLRewriter, signalingUrl: String) -> turn_session_response_t {
        let uriSize = uris.count
        let turnDataUris = UnsafeMutablePointer<UnsafePointer<Int8>?>.allocate(capacity: uriSize)
        for index in 0 ..< uriSize {
            let uri = urlRewriter(uris[index])
            turnDataUris.advanced(by: index).pointee = (uri as NSString).utf8String
        }

        let turnResponse = turn_session_response_t(user_name: (username as NSString).utf8String,
                                                   password: (password as NSString).utf8String,
                                                   ttl: UInt64(ttl),
                                                   signaling_url: (signalingUrl as NSString).utf8String,
                                                   turn_data_uris: turnDataUris,
                                                   size: Int32(uriSize))
        return turnResponse
    }
}
