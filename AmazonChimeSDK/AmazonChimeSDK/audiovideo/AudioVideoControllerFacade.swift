//
//  AudioVideoControllerFacade.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `AudioVideoControllerFacade` manages the signaling and peer connections.
@objc public protocol AudioVideoControllerFacade {
    var configuration: MeetingSessionConfiguration { get }
    var logger: Logger { get }

    /// Start AudioVideo Controller
    ///
    /// - Parameter audioVideoConfiguration: The configuration used for Audio & Video
    /// - Throws: `PermissionError.audioPermissionError` if `RecordPermission` is not given
    func start(audioVideoConfiguration: AudioVideoConfiguration) throws

    /// Start AudioVideo Controller
    ///
    /// - Parameter callKitEnabled: A Bool value to indicate whether the VoIP call to start has CallKit integration.
    /// This parameter is used to determine how audio session interruptions should be handled,
    /// in scenarios such as receving another phone call during the VoIP call.
    /// - Throws: `PermissionError.audioPermissionError` if `RecordPermission` is not given
    func start(callKitEnabled: Bool) throws

    /// Start AudioVideo Controller
    ///
    /// - Throws: `PermissionError.audioPermissionError` if `RecordPermission` is not given
    func start() throws

    /// Stop AudioVideo Controller. This will exit the meeting
    func stop()

    /// Start local video and begin transmitting frames from an internally held `DefaultCameraCaptureSource`.
    /// `stopLocalVideo` will stop the internal capture source if being used.
    ///
    /// Calling this after passing in a custom `VideoSource` will replace it with the internal capture source.
    ///
    /// This function will only have effect if `start` has already been called
    ///
    /// - Throws: `PermissionError.videoPermissionError` if video permission of `AVCaptureDevice` is not granted
    func startLocalVideo() throws

    /// Start local video with a provided custom `VideoSource` which can be used to provide custom
    /// `VideoFrame`s to be transmitted to remote clients. This will call `VideoSource.addVideoSink`
    /// on the provided source.
    ///
    /// Calling this function repeatedly will replace the previous `VideoSource` as the one being
    /// transmitted. It will also stop and replace the internal capture source if `startLocalVideo`
    /// was previously called with no arguments.
    ///
    /// This function will only have effect if `start` has already been called
    ///
    /// - Parameter source: The source of video frames to be sent to other clients
    func startLocalVideo(source: VideoSource)

    /// Stops sending video for local attendee. This will additionally stop the internal capture source if being used.
    /// If using a custom video source, this will call `VideoSource.removeVideoSink` on the previously provided source.
    func stopLocalVideo()

    /// Enable remote video to start receiving streams
    func startRemoteVideo()

    /// Disable remote video to stop receiving streams
    func stopRemoteVideo()

    /// Subscribe to audio, video, and connection events with an `AudioVideoObserver`.
    ///
    /// - Parameter observer: The observer to subscribe to events with
    func addAudioVideoObserver(observer: AudioVideoObserver)

    /// Unsubscribes from audio, video, and connection events by removing specified `AudioVideoObserver`.
    ///
    /// - Parameter observer: The observer to unsubscribe from events with
    func removeAudioVideoObserver(observer: AudioVideoObserver)

    /// Subscribe to metrics events with an `MetricsObserver`.
    ///
    /// - Parameter observer: The observer to subscribe to events with
    func addMetricsObserver(observer: MetricsObserver)

    /// Unsubscribes from metrics events by removing specified `MetricsObserver`.
    ///
    /// - Parameter observer: The observer to unsubscribe from events with
    func removeMetricsObserver(observer: MetricsObserver)
    
    /// Add, update, or remove subscriptions to remote video sources provided via `remoteVideoSourcesDidBecomeAvailable`.
    ///
    /// This function requires using the `RemoteVideoSource` provided by `remoteVideoSourcesDidBecomeAvailable`, otherwise it will not update properly.
    /// This is what allows to use the `RemoteVideoSource` objects as keys in a map.
    ///
    /// Including a `RemoteVideoSource` in `addedOrUpdated` which was not previously provided will result in the negotiation of media flow for that source. After negotiation has
    /// completed,`videoTileDidAdd` on the tile controller will be called with the `TileState` of the source, and applications
    /// can render the video via 'bindVideoTile'. Reincluding a `RemoteVideoSource` can be done to update the provided `VideoSubscriptionConfiguration`,
    /// but it is not necessary to continue receiving frames.
    ///
    /// Including a `RemoteVideoSource` in `removed` will stop the flow video from that source, and lead to a `videoTileDidRemove` call on the
    /// tile controller to indicate to the application that the tile should be unbound. To restart the flow of media, the source should be re-added by
    /// including in `addedOrUpdated`. Note that videos no longer available in a meeting (i.e. listed in
    /// `remoteVideoSourcesDidBecomeUnavailable` do not need to be removed, as they will be automatically unsubscribed from.
    ///
    /// Note that before this function is called for the first time, the client will automatically subscribe to all video sources.
    /// However this behavior will cease upon first call (e.g. if there are 10 videos in the meeting, the controller will subscribe to all 10, however if
    /// `updateVideoSourceSubscriptions` is called with a single video in `addedOrUpdated`, the client will unsubscribe from the other 9.
    /// This automatic subscription behavior may be removed in future major version updates, builders should avoid relying on the logic
    /// and instead explicitly call `updateVideoSourceSubscriptions` with the sources they want to receive.
    ///
    /// - Parameter addedOrUpdated: Dictionary of remote video sources to configurations to add or update
    /// - Parameter removed: Array of remote video sources to remove
    func updateVideoSourceSubscriptions(addedOrUpdated: Dictionary<RemoteVideoSource, VideoSubscriptionConfiguration>, removed: Array<RemoteVideoSource>)

    /// Allows an attendee in a Replica meeting to immediately transition to a Primary meeting attendee
    /// without need for reconnection.
    ///
    ///  `PrimaryMeetingPromotionObserver.didPromoteToPrimaryMeeting` will be called exactly once on `observer` for each call. If
    ///  the promotion is successful,  `PrimaryMeetingPromotionObserver.didDemoteFromPrimaryMeeting` will be called exactly once
    ///  if/when the attendee is demoted. See the observer documentation for possible status codes.
    ///
    /// Application code may also receive a callback on `AudioVideoObserver.videoSessionDidStartWithStatus` without
    /// `MeetingSessionStatusCode.VideoAtCapacityViewOnly` to indicate they can begin to share video.
    ///
    /// `chime::DeleteAttendee` on the Primary meeting attendee will result in `PrimaryMeetingPromotionObserver.didDemoteFromPrimaryMeeting`
    /// to indicate the attendee is no longer able to share.
    ///
    /// Any disconnection will trigger an automatic demotion to avoid unexpected or unwanted promotion state on reconnection.
    /// This will also call `PrimaryMeetingPromotionObserver.didDemoteFromPrimaryMeeting`;  if the attendee still needs to be
    /// an interactive participant in the Primary meeting, `promoteToPrimaryMeeting` should be called again with the same credentials.
    ///
    /// Note that given the asynchronous nature of this function, this should not be called a second time before
    /// `PrimaryMeetingPromotionObserver.didPromoteToPrimaryMeeting` is called for the first time. Doing so may result in unexpected
    /// behavior.
    ///
    /// - Parameter credentials: The credentials for the primary meeting.  This needs to be obtained out of band.
    /// - Parameter observer: Will be called with a session status for the request and possible demotion. See possible options above.
    func promoteToPrimaryMeeting(credentials: MeetingSessionCredentials, observer: PrimaryMeetingPromotionObserver)

    /// Remove the promoted attendee from the Primary meeting. This client will stop sharing audio, video, and data messages.
    /// This will revert the end-user to precisely the state they were before a call to `promoteToPrimaryMeeting`
    ///
    /// This will have no effect if there was no previous successful call to `promoteToPrimaryMeeting`. This
    /// may result in `PrimaryMeetingPromotionObserver.didPromoteToPrimaryMeeting` but there is no need to wait for that callback
    /// to revert UX, etc.
    func demoteFromPrimaryMeeting()
}
