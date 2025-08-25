//
//  DefaultContentShareVideoClientControllerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import AmazonChimeSDKMedia
import Mockingbird
import XCTest

class DefaultContentShareVideoClientControllerTests: CommonTestCase {
    var videoClientMock: VideoClientProtocolMock!
    var videoSourceMock: VideoSourceMock!
    var clientMetricsLollectorMock: ClientMetricsCollectorMock!
    var eventAnalyticsControllerMock: EventAnalyticsControllerMock!
    var defaultContentShareVideoClientController: DefaultContentShareVideoClientController!
    var defaultContentShareVideoClientControllerNone: DefaultContentShareVideoClientController!
    var defaultContentShareVideoClientControllerHigh: DefaultContentShareVideoClientController!

    override func setUp() {
        super.setUp()

        videoClientMock = mock(VideoClientProtocol.self)
        videoSourceMock = mock(VideoSource.self)
        eventAnalyticsControllerMock = mock(EventAnalyticsController.self)
        loggerMock = mock(Logger.self)
        clientMetricsLollectorMock = mock(ClientMetricsCollector.self)
        defaultContentShareVideoClientController =
            DefaultContentShareVideoClientController(videoClient: videoClientMock,
                                                     configuration: meetingSessionConfigurationMock,
                                                     logger: loggerMock,
                                                     clientMetricsCollector: clientMetricsLollectorMock,
                                                     eventAnalyticsController: eventAnalyticsControllerMock)
        defaultContentShareVideoClientControllerNone =
            DefaultContentShareVideoClientController(videoClient: videoClientMock,
                                                     configuration: meetingSessionConfigurationMockNone,
                                                     logger: loggerMock,
                                                     clientMetricsCollector: clientMetricsLollectorMock,
                                                     eventAnalyticsController: eventAnalyticsControllerMock)
        defaultContentShareVideoClientControllerHigh =
            DefaultContentShareVideoClientController(videoClient: videoClientMock,
                                                     configuration: meetingSessionConfigurationMockHigh,
                                                     logger: loggerMock,
                                                     clientMetricsCollector: clientMetricsLollectorMock,
                                                     eventAnalyticsController: eventAnalyticsControllerMock)

        given(videoSourceMock.getVideoContentHint()).willReturn(VideoContentHint.text)
    }

    func testStartVideoShareWithContentMaxResolutionNone() {
        defaultContentShareVideoClientControllerNone.startVideoShare(source: videoSourceMock)

        verify(videoClientMock.start(self.meetingId,
                                     token: self.joinToken,
                                     sending: false,
                                     config: any(),
                                     appInfo: any(),
                                     signalingUrl: any())).wasNeverCalled()
        verify(videoClientMock.setExternalVideoSource(any())).wasNeverCalled()
        verify(videoClientMock.setSending(true)).wasNeverCalled()
    }

    func testStartVideoShareWithContentMaxResolutionUHD() {
        defaultContentShareVideoClientControllerHigh.startVideoShare(source: videoSourceMock)

        verify(videoClientMock.start(self.meetingId,
                                     token: self.joinToken,
                                     sending: false,
                                     config: any(),
                                     appInfo: any(),
                                     signalingUrl: any())).wasCalled()
        verify(videoClientMock.setExternalVideoSource(any())).wasCalled()
        verify(videoClientMock.setMaxBitRateKbps(VideoBitrateConstants().contentHighResolutionBitrateKbps)).wasCalled()
        verify(videoClientMock.setContentMaxResolutionUHD(true)).wasCalled()
        verify(videoClientMock.setSending(true)).wasCalled()
    }

    func testStartVideoShareFirstTime() {
        defaultContentShareVideoClientController.startVideoShare(source: videoSourceMock)

        verify(videoClientMock.start(self.meetingId,
                                     token: self.joinToken,
                                     sending: false,
                                     config: any(),
                                     appInfo: any(),
                                     signalingUrl: any())).wasCalled()
        verify(videoClientMock.setExternalVideoSource(any())).wasCalled()
        verify(videoClientMock.setSending(true)).wasCalled()
    }

    func testStartVideoShareWithConfig() {
        let config = LocalVideoConfiguration(maxBitRateKbps: 300)
        defaultContentShareVideoClientController.startVideoShare(source: videoSourceMock, config: config)

        verify(videoClientMock.setExternalVideoSource(any())).wasCalled()
        verify(videoClientMock.setSending(true)).wasCalled()
        verify(videoClientMock.setMaxBitRateKbps(300)).wasCalled()
    }

    func testStartVideoShareAfterStart() {
        given(videoClientMock.start(any(),
                                    token: any(),
                                    sending: any(),
                                    config: any(),
                                    appInfo: any(),
                                    signalingUrl: any())).will {_, _, _, _, _, _ in
            self.defaultContentShareVideoClientController.videoClientDidConnect(nil, controlStatus: 1)
        }
        given(videoClientMock.stop()).will {
            self.defaultContentShareVideoClientController.videoClientDidStop(nil)
        }

        defaultContentShareVideoClientController.startVideoShare(source: videoSourceMock)
        defaultContentShareVideoClientController.startVideoShare(source: videoSourceMock)

        verify(videoClientMock.start(self.meetingId,
                                     token: self.joinToken,
                                     sending: false,
                                     config: any(),
                                     appInfo: any(),
                                     signalingUrl: any())).wasCalled()
        verify(videoClientMock.setExternalVideoSource(any())).wasCalled(2)
        verify(videoClientMock.setSending(true)).wasCalled(2)
    }

    func testStopVideoShareAfterStart() {
        given(videoClientMock.start(any(),
                                    token: any(),
                                    sending: any(),
                                    config: any(),
                                    appInfo: any(),
                                    signalingUrl: any())).will {_, _, _, _, _, _ in
            self.defaultContentShareVideoClientController.videoClientDidConnect(nil, controlStatus: 1)
        }

        defaultContentShareVideoClientController.startVideoShare(source: videoSourceMock)
        defaultContentShareVideoClientController.stopVideoShare()

        verify(videoClientMock.setSending(false)).wasCalled()
        verify(videoClientMock.stop()).wasCalled()
    }

    func testStopVideoShareBeforeStart() {
        defaultContentShareVideoClientController.stopVideoShare()

        verify(videoClientMock.setSending(false)).wasNeverCalled()
        verify(videoClientMock.stop()).wasNeverCalled()
    }
    
    func testVideoClientDidReceiveEvent_ShouldPublishSignalingDroppedEvent_WhenEventTypeIsSignalingDropped() {
        let event: video_client_event = video_client_event(timestamp: 1,
                                                           event_type: VIDEO_CLIENT_EVENT_TYPE_SIGNALING_DROPPED,
                                                           signaling_dropped_error: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_INTERNAL_SERVER_ERROR)
        let captor = ArgumentCaptor<[AnyHashable: Any]>()
        
        let mediaVideoClientMock = mock(VideoClient.self)
        
        defaultContentShareVideoClientController.videoClient(mediaVideoClientMock, didReceive: event)
        
        verify(eventAnalyticsControllerMock.publishEvent(name: .contentShareSignalingDropped,
                                                         attributes: captor.any())).wasCalled()
        
        let error = captor.value?[EventAttributeName.signalingDroppedError] as? SignalingDroppedError
        XCTAssertEqual(error, SignalingDroppedError.internalServerError)
    }
}
