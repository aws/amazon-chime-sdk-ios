//
//  AudioVideoSpies.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Foundation

class AudioVideoObserverSpy: AudioVideoObserver {
    var audioSessionDidStartConnectingCalls: [Bool] = []
    var audioSessionDidStartCalls: [Bool] = []
    var audioSessionDidDropCallCount = 0
    var audioSessionDidStopWithStatusCalls: [MeetingSessionStatus] = []
    var audioSessionDidCancelReconnectCallCount = 0
    var connectionDidRecoverCallCount = 0
    var connectionDidBecomePoorCallCount = 0
    var videoSessionDidStartConnectingCallCount = 0
    var videoSessionDidStartWithStatusCalls: [MeetingSessionStatus] = []
    var videoSessionDidStopWithStatusCalls: [MeetingSessionStatus] = []
    var remoteVideoSourcesDidBecomeAvailableCalls: [[RemoteVideoSource]] = []
    var remoteVideoSourcesDidBecomeUnavailableCalls: [[RemoteVideoSource]] = []
    var cameraSendAvailabilityDidChangeCalls: [Bool] = []

    func audioSessionDidStartConnecting(reconnecting: Bool) {
        audioSessionDidStartConnectingCalls.append(reconnecting)
    }

    func audioSessionDidStart(reconnecting: Bool) {
        audioSessionDidStartCalls.append(reconnecting)
    }

    func audioSessionDidDrop() { audioSessionDidDropCallCount += 1 }

    func audioSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {
        audioSessionDidStopWithStatusCalls.append(sessionStatus)
    }

    func audioSessionDidCancelReconnect() { audioSessionDidCancelReconnectCallCount += 1 }
    func connectionDidRecover() { connectionDidRecoverCallCount += 1 }
    func connectionDidBecomePoor() { connectionDidBecomePoorCallCount += 1 }
    func videoSessionDidStartConnecting() { videoSessionDidStartConnectingCallCount += 1 }

    func videoSessionDidStartWithStatus(sessionStatus: MeetingSessionStatus) {
        videoSessionDidStartWithStatusCalls.append(sessionStatus)
    }

    func videoSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {
        videoSessionDidStopWithStatusCalls.append(sessionStatus)
    }

    func remoteVideoSourcesDidBecomeAvailable(sources: [RemoteVideoSource]) {
        remoteVideoSourcesDidBecomeAvailableCalls.append(sources)
    }

    func remoteVideoSourcesDidBecomeUnavailable(sources: [RemoteVideoSource]) {
        remoteVideoSourcesDidBecomeUnavailableCalls.append(sources)
    }

    func cameraSendAvailabilityDidChange(available: Bool) {
        cameraSendAvailabilityDidChangeCalls.append(available)
    }
}

class AudioVideoControllerFacadeSpy: AudioVideoControllerFacade {
    struct StartLocalVideoCall {
        let source: VideoSource?
        let config: LocalVideoConfiguration?
    }

    struct UpdateVideoSourceSubscriptionsCall {
        let addedOrUpdated: [RemoteVideoSource: VideoSubscriptionConfiguration]
        let removed: [RemoteVideoSource]
    }

    struct PromoteToPrimaryMeetingCall {
        let credentials: MeetingSessionCredentials
        let observer: PrimaryMeetingPromotionObserver
    }

    var configuration: MeetingSessionConfiguration
    var logger: Logger

    var startWithConfigurationCalls: [AudioVideoConfiguration] = []
    var startWithCallKitEnabledCalls: [Bool] = []
    var startCallCount = 0
    var startError: Error?
    var stopCallCount = 0
    var startLocalVideoCalls: [StartLocalVideoCall] = []
    var startLocalVideoError: Error?
    var stopLocalVideoCallCount = 0
    var startRemoteVideoCallCount = 0
    var stopRemoteVideoCallCount = 0
    var addAudioVideoObserverCalls: [AudioVideoObserver] = []
    var removeAudioVideoObserverCalls: [AudioVideoObserver] = []
    var addMetricsObserverCalls: [MetricsObserver] = []
    var removeMetricsObserverCalls: [MetricsObserver] = []
    var updateVideoSourceSubscriptionsCalls: [UpdateVideoSourceSubscriptionsCall] = []
    var promoteToPrimaryMeetingCalls: [PromoteToPrimaryMeetingCall] = []
    var demoteFromPrimaryMeetingCallCount = 0

    init(configuration: MeetingSessionConfiguration, logger: Logger) {
        self.configuration = configuration
        self.logger = logger
    }

    func start(audioVideoConfiguration: AudioVideoConfiguration) throws {
        startWithConfigurationCalls.append(audioVideoConfiguration)
        if let error = startError { throw error }
    }

    func start(callKitEnabled: Bool) throws {
        startWithCallKitEnabledCalls.append(callKitEnabled)
        if let error = startError { throw error }
    }

    func start() throws {
        startCallCount += 1
        if let error = startError { throw error }
    }

    func stop() { stopCallCount += 1 }

    func startLocalVideo() throws {
        startLocalVideoCalls.append(StartLocalVideoCall(source: nil, config: nil))
        if let error = startLocalVideoError { throw error }
    }

    func startLocalVideo(config: LocalVideoConfiguration) throws {
        startLocalVideoCalls.append(StartLocalVideoCall(source: nil, config: config))
        if let error = startLocalVideoError { throw error }
    }

    func startLocalVideo(source: VideoSource) {
        startLocalVideoCalls.append(StartLocalVideoCall(source: source, config: nil))
    }

    func startLocalVideo(source: VideoSource, config: LocalVideoConfiguration) {
        startLocalVideoCalls.append(StartLocalVideoCall(source: source, config: config))
    }

    func stopLocalVideo() { stopLocalVideoCallCount += 1 }
    func startRemoteVideo() { startRemoteVideoCallCount += 1 }
    func stopRemoteVideo() { stopRemoteVideoCallCount += 1 }

    func addAudioVideoObserver(observer: AudioVideoObserver) { addAudioVideoObserverCalls.append(observer) }
    func removeAudioVideoObserver(observer: AudioVideoObserver) { removeAudioVideoObserverCalls.append(observer) }
    func addMetricsObserver(observer: MetricsObserver) { addMetricsObserverCalls.append(observer) }
    func removeMetricsObserver(observer: MetricsObserver) { removeMetricsObserverCalls.append(observer) }

    func updateVideoSourceSubscriptions(addedOrUpdated: [RemoteVideoSource: VideoSubscriptionConfiguration],
                                        removed: [RemoteVideoSource]) {
        updateVideoSourceSubscriptionsCalls.append(
            UpdateVideoSourceSubscriptionsCall(addedOrUpdated: addedOrUpdated, removed: removed))
    }

    func promoteToPrimaryMeeting(credentials: MeetingSessionCredentials,
                                 observer: PrimaryMeetingPromotionObserver) {
        promoteToPrimaryMeetingCalls.append(PromoteToPrimaryMeetingCall(credentials: credentials,
                                                                       observer: observer))
    }

    func demoteFromPrimaryMeeting() { demoteFromPrimaryMeetingCallCount += 1 }
}

class ActiveSpeakerDetectorFacadeSpy: ActiveSpeakerDetectorFacade {
    struct AddActiveSpeakerObserverCall {
        let policy: ActiveSpeakerPolicy
        let observer: ActiveSpeakerObserver
    }

    var addActiveSpeakerObserverCalls: [AddActiveSpeakerObserverCall] = []
    var removeActiveSpeakerObserverCalls: [ActiveSpeakerObserver] = []
    var hasBandwidthPriorityCallbackCalls: [Bool] = []

    func addActiveSpeakerObserver(policy: ActiveSpeakerPolicy, observer: ActiveSpeakerObserver) {
        addActiveSpeakerObserverCalls.append(AddActiveSpeakerObserverCall(policy: policy, observer: observer))
    }

    func removeActiveSpeakerObserver(observer: ActiveSpeakerObserver) {
        removeActiveSpeakerObserverCalls.append(observer)
    }

    func hasBandwidthPriorityCallback(hasBandwidthPriority: Bool) {
        hasBandwidthPriorityCallbackCalls.append(hasBandwidthPriority)
    }
}

class SchedulerSpy: Scheduler {
    var startCallCount = 0
    var stopCallCount = 0

    func start() { startCallCount += 1 }
    func stop() { stopCallCount += 1 }
}
