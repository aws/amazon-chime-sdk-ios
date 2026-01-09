//
//  CreateAttendeeResponse.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class CreateMeetingResponse: NSObject {
    let meeting: Meeting

    public init(meeting: Meeting) {
        self.meeting = meeting
    }
}

@objcMembers public class Meeting: NSObject {
    let externalMeetingId: String?
    let mediaPlacement: MediaPlacement
    let meetingFeatures: MeetingFeatures
    let mediaRegion: String
    let meetingId: String
    let primaryMeetingId: String?

    public convenience init(externalMeetingId: String?,
                            mediaPlacement: MediaPlacement,
                            mediaRegion: String,
                            meetingId: String) {
        self.init(
            externalMeetingId: externalMeetingId,
            mediaPlacement: mediaPlacement,
            meetingFeatures: MeetingFeatures(),
            mediaRegion: mediaRegion,
            meetingId: meetingId,
            primaryMeetingId: nil)
    }

    public init(externalMeetingId: String?,
                 mediaPlacement: MediaPlacement,
                 meetingFeatures: MeetingFeatures,
                 mediaRegion: String,
                 meetingId: String,
                 primaryMeetingId: String?) {
        self.externalMeetingId = externalMeetingId
        self.mediaPlacement = mediaPlacement
        self.meetingFeatures = meetingFeatures
        self.mediaRegion = mediaRegion
        self.meetingId = meetingId
        self.primaryMeetingId = primaryMeetingId
    }
}

// turnControlUrl is unused
@objcMembers public class MediaPlacement: NSObject {
    let audioFallbackUrl: String
    let audioHostUrl: String
    let signalingUrl: String
    let eventIngestionUrl: String?

    public convenience init(audioFallbackUrl: String, audioHostUrl: String, signalingUrl: String, turnControlUrl: String) {
        self.init(audioFallbackUrl: audioFallbackUrl,
                  audioHostUrl: audioHostUrl,
                  signalingUrl: signalingUrl,
                  turnControlUrl: turnControlUrl,
                  eventIngestionUrl: nil)
    }

    public init(audioFallbackUrl: String,
                audioHostUrl: String,
                signalingUrl: String,
                turnControlUrl: String,
                eventIngestionUrl: String?) {
        self.audioFallbackUrl = audioFallbackUrl
        self.audioHostUrl = audioHostUrl
        self.signalingUrl = signalingUrl
        self.eventIngestionUrl = eventIngestionUrl
    }
}

@objcMembers public class MeetingFeatures: NSObject {
    public let videoMaxResolution: VideoResolution
    public let contentMaxResolution: VideoResolution
    public override convenience init() {
        self.init(videoMaxResolution: VideoResolution.videoResolutionHD,
                  contentMaxResolution: VideoResolution.videoResolutionFHD)
    }
    public convenience init(video: String?,
                            content: String?) {
        let videoResolution = video ?? "hd"
        let contentResolution = content ?? "fhd"
        self.init(videoMaxResolution: parseMaxResolution(resolution: videoResolution),
                  contentMaxResolution: parseMaxResolution(resolution: contentResolution))
    }
    public init(videoMaxResolution: VideoResolution,
                contentMaxResolution: VideoResolution) {
        self.videoMaxResolution = videoMaxResolution
        self.contentMaxResolution = contentMaxResolution
    }
}

private func parseMaxResolution(resolution: String) -> VideoResolution {
    let maxResolution: VideoResolution
    let lowerCaseResolution = resolution.lowercased()
    if (lowerCaseResolution == "none") {
        maxResolution = VideoResolution.videoDisabled
    } else if (lowerCaseResolution == "hd") {
        maxResolution = VideoResolution.videoResolutionHD
    } else if (lowerCaseResolution == "fhd") {
        maxResolution = VideoResolution.videoResolutionFHD
    } else {
        maxResolution = VideoResolution.videoResolutionUHD
    }
    return maxResolution
}
