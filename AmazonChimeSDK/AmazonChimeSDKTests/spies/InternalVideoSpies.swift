//
//  InternalVideoSpies.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

// Parameter names mirror the ObjC Media interface, as VideoClientProtocol does.
// swiftlint:disable identifier_name

@testable import AmazonChimeSDK
import AmazonChimeSDKMedia
import Foundation

class VideoClientProtocolSpy: NSObject, VideoClientProtocol {
    struct StartCall {
        let callId: String?
        let token: String?
        let sending: Bool
        let config: VideoConfiguration?
        let signalingUrl: String?
    }

    struct SetRemotePauseCall {
        let videoId: UInt32
        let pause: Bool
    }

    struct SendDataMessageCall {
        let topic: String?
        let dataLen: UInt32
        let lifetimeMs: Int32
    }

    struct UpdateVideoSourceSubscriptionsCall {
        let addedOrUpdated: [AnyHashable: Any]?
        let withRemoved: [Any]?
    }

    struct PromotePrimaryMeetingCall {
        let attendeeId: String?
        let externalUserId: String?
        let joinToken: String?
    }

    var delegate: VideoClientDelegate!

    static var globalInitializeCallCount = 0

    var startCalls: [StartCall] = []
    /// Invoked after a `start` call is recorded, for tests that need side effects.
    var startHandler: (() -> Void)?
    var stopCallCount = 0
    /// Invoked after a `stop` call is recorded, for tests that need side effects.
    var stopHandler: (() -> Void)?
    var setSendingCalls: [Bool] = []
    var setReceivingCalls: [Bool] = []
    var setExternalVideoSourceCalls: [VideoSourceInternal?] = []
    var getServiceTypeCallCount = 0
    var getServiceTypeReturn: video_client_service_type_t = VIDEO_CLIENT_SERVICE_CAMERA_IDLE
    var setRemotePauseCalls: [SetRemotePauseCall] = []
    var videoLogCallBackCalls: [String?] = []
    var sendDataMessageCalls: [SendDataMessageCall] = []
    var updateVideoSourceSubscriptionsCalls: [UpdateVideoSourceSubscriptionsCall] = []
    var promotePrimaryMeetingCalls: [PromotePrimaryMeetingCall] = []
    var demoteFromPrimaryMeetingCallCount = 0
    var setMaxBitRateKbpsCalls: [UInt32] = []
    var setContentMaxResolutionUHDCalls: [Bool] = []

    static func globalInitialize() { globalInitializeCallCount += 1 }

    func start(_ callId: String!,
               token: String!,
               sending: Bool,
               config: VideoConfiguration!,
               appInfo: app_detailed_info_t,
               signalingUrl: String!) {
        startCalls.append(StartCall(callId: callId,
                                   token: token,
                                   sending: sending,
                                   config: config,
                                   signalingUrl: signalingUrl))
        startHandler?()
    }

    func start(_ callId: String!,
               token: String!,
               sending: Bool,
               config: VideoConfiguration!,
               appInfo: app_detailed_info_t) {
        startCalls.append(StartCall(callId: callId,
                                   token: token,
                                   sending: sending,
                                   config: config,
                                   signalingUrl: nil))
        startHandler?()
    }

    func stop() {
        stopCallCount += 1
        stopHandler?()
    }

    func setSending(_ sending: Bool) { setSendingCalls.append(sending) }
    func setReceiving(_ receiving: Bool) { setReceivingCalls.append(receiving) }

    func setExternalVideoSource(_ source: VideoSourceInternal!) {
        setExternalVideoSourceCalls.append(source)
    }

    func getServiceType() -> video_client_service_type_t {
        getServiceTypeCallCount += 1
        return getServiceTypeReturn
    }

    func setRemotePause(_ video_id: UInt32, pause: Bool) {
        setRemotePauseCalls.append(SetRemotePauseCall(videoId: video_id, pause: pause))
    }

    func videoLogCallBack(_ logLevel: video_client_loglevel_t, msg: String!) {
        videoLogCallBackCalls.append(msg)
    }

    func sendDataMessage(_ topic: String!, data: UnsafePointer<Int8>!, dataLen: UInt32, lifetimeMs: Int32) {
        sendDataMessageCalls.append(SendDataMessageCall(topic: topic,
                                                       dataLen: dataLen,
                                                       lifetimeMs: lifetimeMs))
    }

    func updateVideoSourceSubscriptions(_ addedOrUpdated: [AnyHashable: Any]!, withRemoved: [Any]!) {
        updateVideoSourceSubscriptionsCalls.append(
            UpdateVideoSourceSubscriptionsCall(addedOrUpdated: addedOrUpdated, withRemoved: withRemoved))
    }

    func promotePrimaryMeeting(_ attendeeId: String!, externalUserId: String!, joinToken: String!) {
        promotePrimaryMeetingCalls.append(PromotePrimaryMeetingCall(attendeeId: attendeeId,
                                                                   externalUserId: externalUserId,
                                                                   joinToken: joinToken))
    }

    func demoteFromPrimaryMeeting() { demoteFromPrimaryMeetingCallCount += 1 }
    func setMaxBitRateKbps(_ maxBitRate: UInt32) { setMaxBitRateKbpsCalls.append(maxBitRate) }

    func setContentMaxResolutionUHD(_ isContentMaxResolutionUHD: Bool) {
        setContentMaxResolutionUHDCalls.append(isContentMaxResolutionUHD)
    }
}

class VideoClientControllerSpy: VideoClientController {
    struct StartLocalVideoCall {
        let source: VideoSource?
        let config: LocalVideoConfiguration?
    }

    struct PauseResumeRemoteVideoCall {
        let videoId: UInt32
        let pause: Bool
    }

    struct SubscribeToReceiveDataMessageCall {
        let topic: String
        let observer: DataMessageObserver
    }

    struct SendDataMessageCall {
        let topic: String
        let data: Any
        let lifetimeMs: Int32
    }

    struct UpdateVideoSourceSubscriptionsCall {
        let addedOrUpdated: [RemoteVideoSource: VideoSubscriptionConfiguration]
        let removed: [RemoteVideoSource]
    }

    struct PromoteToPrimaryMeetingCall {
        let credentials: MeetingSessionCredentials
        let observer: PrimaryMeetingPromotionObserver
    }

    var startCallCount = 0
    var stopAndDestroyCallCount = 0
    var startLocalVideoCalls: [StartLocalVideoCall] = []
    var startLocalVideoError: Error?
    var stopLocalVideoCallCount = 0
    var startRemoteVideoCallCount = 0
    var stopRemoteVideoCallCount = 0
    var switchCameraCallCount = 0
    var getCurrentDeviceCallCount = 0
    var getCurrentDeviceReturn: MediaDevice?
    var getConfigurationCallCount = 0
    var getConfigurationReturn: MeetingSessionConfiguration!
    var subscribeToVideoClientStateChangeCalls: [AudioVideoObserver] = []
    var unsubscribeFromVideoClientStateChangeCalls: [AudioVideoObserver] = []
    var subscribeToVideoTileControllerObserversCalls: [VideoTileController] = []
    var unsubscribeFromVideoTileControllerObserversCalls: [VideoTileController] = []
    var pauseResumeRemoteVideoCalls: [PauseResumeRemoteVideoCall] = []
    var subscribeToReceiveDataMessageCalls: [SubscribeToReceiveDataMessageCall] = []
    var unsubscribeFromReceiveDataMessageFromTopicCalls: [String] = []
    var sendDataMessageCalls: [SendDataMessageCall] = []
    var sendDataMessageError: Error?
    var updateVideoSourceSubscriptionsCalls: [UpdateVideoSourceSubscriptionsCall] = []
    var promoteToPrimaryMeetingCalls: [PromoteToPrimaryMeetingCall] = []
    var demoteFromPrimaryMeetingCallCount = 0

    func start() { startCallCount += 1 }
    func stopAndDestroy() { stopAndDestroyCallCount += 1 }

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
    func switchCamera() { switchCameraCallCount += 1 }

    func getCurrentDevice() -> MediaDevice? {
        getCurrentDeviceCallCount += 1
        return getCurrentDeviceReturn
    }

    func getConfiguration() -> MeetingSessionConfiguration {
        getConfigurationCallCount += 1
        return getConfigurationReturn
    }

    func subscribeToVideoClientStateChange(observer: AudioVideoObserver) {
        subscribeToVideoClientStateChangeCalls.append(observer)
    }

    func unsubscribeFromVideoClientStateChange(observer: AudioVideoObserver) {
        unsubscribeFromVideoClientStateChangeCalls.append(observer)
    }

    func subscribeToVideoTileControllerObservers(observer: VideoTileController) {
        subscribeToVideoTileControllerObserversCalls.append(observer)
    }

    func unsubscribeFromVideoTileControllerObservers(observer: VideoTileController) {
        unsubscribeFromVideoTileControllerObserversCalls.append(observer)
    }

    func pauseResumeRemoteVideo(_ videoId: UInt32, pause: Bool) {
        pauseResumeRemoteVideoCalls.append(PauseResumeRemoteVideoCall(videoId: videoId, pause: pause))
    }

    func subscribeToReceiveDataMessage(topic: String, observer: DataMessageObserver) {
        subscribeToReceiveDataMessageCalls.append(
            SubscribeToReceiveDataMessageCall(topic: topic, observer: observer))
    }

    func unsubscribeFromReceiveDataMessageFromTopic(topic: String) {
        unsubscribeFromReceiveDataMessageFromTopicCalls.append(topic)
    }

    func sendDataMessage(topic: String, data: Any, lifetimeMs: Int32) throws {
        sendDataMessageCalls.append(SendDataMessageCall(topic: topic, data: data, lifetimeMs: lifetimeMs))
        if let error = sendDataMessageError { throw error }
    }

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
