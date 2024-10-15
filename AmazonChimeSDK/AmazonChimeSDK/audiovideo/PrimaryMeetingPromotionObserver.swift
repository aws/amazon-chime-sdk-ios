//
//  PrimaryMeetingPromotionObserver.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `PrimaryMeetingPromotionObserver` handles events related to Primary meeting promotion.
/// See `AudioVideoControllerFacade.promoteToPrimaryMeeting` for more information.
@objc public protocol PrimaryMeetingPromotionObserver {
    /// Called when the `AudioVideoControllerFacade.promoteToPrimaryMeeting` completes.
    ///
    /// `MeetingSessionStatus`  that will contain a `MeetingSessionStatusCode` of the following:
    ///
    /// * `MeetingSessionStatusCode.ok`: The promotion was successful (i.e. session token was valid,
    ///   there was room in the Primary meeting, etc.), audio will begin flowing
    ///   and the attendee can begin to send data messages, and content/video if the call is not already at limit.
    /// * `MeetingSessionStatusCode.audioAuthenticationRejected`: Credentials provided
    ///   were invalid when connection attempted to Primary meeting. There may be an issue
    ///   with your mechanism which allocates the Primary meeting attendee for the Replica
    ///   meeting proxied promotion.  This also may indicate that this API was called in a
    ///   non-Replica meeting.
    /// * `MeetingSessionStatusCode.audioCallAtCapacity`: Credentials provided were correct
    ///   but there was no room in the Primary meeting.  Promotions to Primary meeting attendee take up a slot, just like
    ///   regular Primary meeting attendee connections and are limited by the same mechanisms.
    /// * `MeetingSessionStatusCode.audioServiceUnavailable`: Media has not been connected yet so promotion is not yet possible.
    /// * `MeetingSessionStatusCode.audioInternalServerError`: Other failure, possibly due to disconnect
    ///   or timeout. These failures are likely retryable.
    ///
    /// Note: this callback will be called on main thread.
    ///
    /// - Parameter status: See notes above
    func didPromoteToPrimaryMeeting(status: MeetingSessionStatus)

    /// This observer callback will only be called for attendees in Replica meetings that have
    /// been promoted to the Primary meeting via `AudioVideoFacade.promoteToPrimaryMeeting`.
    ///
    /// Indicates that the client is no longer authenticated to the Primary meeting
    /// and can no longer share media. `status` will contain a `MeetingSessionStatusCode` of the following:
    ///
    /// * `MeetingSessionStatusCode.ok`: `AudioVideoFacade.demoteFromPrimaryMeeting` was used to remove the attendee.
    /// * `MeetingSessionStatusCode.audioAuthenticationRejected`: `chime::DeleteAttendee` was called on the Primary
    ///   meeting attendee used in `AudioVideoFacade.promoteToPrimaryMeeting`.
    /// * `MeetingSessionStatusCode.audioInternalServerError`: Other failure, possibly due to disconnect
    ///   or timeout. These failures are likely retryable. Any disconnection will trigger an automatic
    ///   demotion to avoid unexpected or unwanted promotion state on reconnection.
    ///
    /// Note: this callback will be called on main thread.
    ///
    /// - Parameter status: See notes above
    func didDemoteFromPrimaryMeeting(status: MeetingSessionStatus)
}
