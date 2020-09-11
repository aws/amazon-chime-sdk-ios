//
//  MockVideoClientController.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AmazonChimeSDK
import AmazonChimeSDKMedia

public final class MockVideoClientController: VideoClientController {
    init() {
    }

    public func start(turnControlUrl: String, signalingUrl: String, meetingId: String, joinToken: String) {
    }

    public func stopAndDestroy() {
    }

    public func startLocalVideo() throws {
    }

    public func stopLocalVideo() {
    }

    public func startRemoteVideo() {
    }

    public func stopRemoteVideo() {
    }

    public func switchCamera() {
    }

    public func getCurrentDevice() -> VideoDevice? {
        return nil
    }

    public func subscribeToVideoClientStateChange(observer: AudioVideoObserver) {
    }

    public func unsubscribeToVideoClientStateChange(observer: AudioVideoObserver) {
    }

    public func subscribeToVideoTileControllerObservers(observer: VideoTileController) {
    }

    public func unsubscribeToVideoTileControllerObservers(observer: VideoTileController) {
    }

    public func pauseResumeRemoteVideo(_ videoId: UInt32, pause: Bool) {
    }

    public func getConfiguration() -> MeetingSessionConfiguration {
        let mediaPlacement = MediaPlacementMock(
            audioFallbackUrl: "audioFallbackUrl",
            audioHostUrl: "audioHostUrl",
            signalingUrl: "signalingUrl",
            turnControlUrl: "turnControlUrl")
        let meeting = MeetingMock(
            externalMeetingId: "externalMeetingId",
            mediaPlacement: mediaPlacement,
            mediaRegion: "mediaRegion",
            meetingId: "meetingId")
        let attendee = AttendeeMock(attendeeId: "attendeeId", externalUserId: "externalUserId", joinToken: "joinToken")

        return MeetingSessionConfigurationMock(
            createMeetingResponse: CreateMeetingResponseMock(meeting: meeting),
            createAttendeeResponse: CreateAttendeeResponseMock(attendee: attendee))
    }

    public func subscribeToReceiveDataMessage(topic: String, observer: DataMessageObserver) {
    }

    public func unsubscribeFromReceiveDataMessageFromTopic(topic: String) {
    }

    public func sendDataMessage(topic: String, data: Any, lifetimeMs: Int32) throws {
    }
}
