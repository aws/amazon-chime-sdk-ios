//
//  IngestionPayload.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class IngestionPayload: NSObject, Codable {
    public let name: String
    public let ts: Int64
    public let id: String?
    public let maxVideoTileCount: Int?
    public let meetingStartDurationMs: Int64?
    public let meetingReconnectDurationMs: Int64?
    public let meetingDurationMs: Int64?
    public let meetingErrorMessage: String?
    public let meetingStatus: String?
    public let poorConnectionCount: Int?
    public let retryCount: Int?
    public let videoInputErrorMessage: String?
    public let audioInputErrorMessage: String?
    public let signalingDroppedErrorMessage: String?
    public let contentShareErrorMessage: String?
    public let appState: String?
    public let batteryLevel: Float?
    public let batteryState: String?
    public let voiceFocusErrorMessage: String?
    public let audioDeviceType: String?
    public let videoDeviceType: String?
    public let ttl: Int64?
    public let lowPowerModeEnabled: Bool?
    public let videoInterruptionReason: String?
    public let iceGatheringDurationMs: Int64?
    public let signalingOpenDurationMs: Int64?
    public let networkConnectionType: String?

    public init(name: String,
                ts: Int64,
                id: String? = nil,
                maxVideoTileCount: Int? = nil,
                meetingStartDurationMs: Int64? = nil,
                meetingReconnectDurationMs: Int64? = nil,
                meetingDurationMs: Int64? = nil,
                meetingErrorMessage: String? = nil,
                meetingStatus: String? = nil,
                poorConnectionCount: Int? = nil,
                retryCount: Int? = nil,
                videoInputErrorMessage: String? = nil,
                audioInputErrorMessage: String? = nil,
                signalingDroppedErrorMessage: String? = nil,
                contentShareErrorMessage: String? = nil,
                appState: String? = nil,
                batteryLevel: Float? = nil,
                batteryState: String? = nil,
                voiceFocusErrorMessage: String? = nil,
                audioDeviceType: String? = nil,
                videoDeviceType: String? = nil,
                lowPowerModeEnabled: Bool? = nil,
                videoInterruptionReason: String? = nil,
                iceGatheringDurationMs: Int64? = nil,
                signalingOpenDurationMs: Int64? = nil,
                networkConnectionType: String? = nil,
                ttl: Int64? = nil) {
        self.name = name
        self.ts = ts
        self.id = id
        self.maxVideoTileCount = maxVideoTileCount
        self.meetingStartDurationMs = meetingStartDurationMs
        self.meetingReconnectDurationMs = meetingReconnectDurationMs
        self.meetingDurationMs = meetingDurationMs
        self.meetingErrorMessage = meetingErrorMessage
        self.meetingStatus = meetingStatus
        self.poorConnectionCount = poorConnectionCount
        self.retryCount = retryCount
        self.videoInputErrorMessage = videoInputErrorMessage
        self.audioInputErrorMessage = audioInputErrorMessage
        self.signalingDroppedErrorMessage = signalingDroppedErrorMessage
        self.contentShareErrorMessage = contentShareErrorMessage
        self.appState = appState
        self.batteryLevel = batteryLevel
        self.batteryState = batteryState
        self.voiceFocusErrorMessage = voiceFocusErrorMessage
        self.audioDeviceType = audioDeviceType
        self.videoDeviceType = videoDeviceType
        self.lowPowerModeEnabled = lowPowerModeEnabled
        self.videoInterruptionReason = videoInterruptionReason
        self.iceGatheringDurationMs = iceGatheringDurationMs
        self.signalingOpenDurationMs = signalingOpenDurationMs
        self.networkConnectionType = networkConnectionType
        self.ttl = ttl
    }
}
