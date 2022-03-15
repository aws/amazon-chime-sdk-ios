//
//  VideoClientProtocol.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//
// swiftlint:disable identifier_name

import AmazonChimeSDKMedia
import Foundation

@objc public protocol VideoClientProtocol {
    var delegate: VideoClientDelegate! { get set }

    static func globalInitialize()

    func start(_ callId: String!,
               token: String!,
               sending: Bool,
               config: VideoConfiguration!,
               appInfo: app_detailed_info_t,
               signalingUrl: String!)

    func start(_ callId: String!,
               token: String!,
               sending: Bool,
               config: VideoConfiguration!,
               appInfo: app_detailed_info_t)

    func stop()

    func setSending(_ sending: Bool)

    func setReceiving(_ receiving: Bool)

    func setExternalVideoSource(_ source: VideoSourceInternal!)

    func getServiceType() -> video_client_service_type_t

    func setRemotePause(_ video_id: UInt32, pause: Bool)

    func videoLogCallBack(_ logLevel: video_client_loglevel_t, msg: String!)

    func sendDataMessage(_ topic: String!, data: UnsafePointer<Int8>!, lifetimeMs: Int32)

    func updateVideoSourceSubscriptions(_ addedOrUpdated: [AnyHashable: Any]!,
                                        withRemoved: [Any]!)

    func promotePrimaryMeeting(_ attendeeId: String!, externalUserId: String!, joinToken: String!)

    func demoteFromPrimaryMeeting()
}

extension VideoClient: VideoClientProtocol {}
