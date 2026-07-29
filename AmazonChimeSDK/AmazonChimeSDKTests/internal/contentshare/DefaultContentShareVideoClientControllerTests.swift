//
//  DefaultContentShareVideoClientControllerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import AmazonChimeSDKMedia
import Cuckoo
import XCTest

class DefaultContentShareVideoClientControllerTests: CommonTestCase {
    var videoClientMock: MockVideoClientProtocol!
    var videoSourceMock: MockVideoSource!
    var clientMetricsLollectorMock: MockClientMetricsCollector!
    var eventAnalyticsControllerMock: MockEventAnalyticsController!
    var defaultContentShareVideoClientController: DefaultContentShareVideoClientController!
    var defaultContentShareVideoClientControllerNone: DefaultContentShareVideoClientController!
    var defaultContentShareVideoClientControllerHigh: DefaultContentShareVideoClientController!

    override func setUp() {
        super.setUp()

        videoClientMock = MockVideoClientProtocol().withEnabledDefaultImplementation(VideoClientProtocolStub())
        videoSourceMock = MockVideoSource().withEnabledDefaultImplementation(VideoSourceStub())
        eventAnalyticsControllerMock = MockEventAnalyticsController().withEnabledDefaultImplementation(EventAnalyticsControllerStub())
        loggerMock = MockLogger().withEnabledDefaultImplementation(LoggerStub())
        clientMetricsLollectorMock = MockClientMetricsCollector().withEnabledDefaultImplementation(ClientMetricsCollectorStub())
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

        stub(videoSourceMock) { stub in
            when(stub.videoContentHint.get).thenReturn(VideoContentHint.text)
        }
    }

    func testStartVideoShareWithContentMaxResolutionNone() {
        defaultContentShareVideoClientControllerNone.startVideoShare(source: videoSourceMock)

        verify(videoClientMock, never()).start(self.meetingId,
                                               token: self.joinToken,
                                               sending: false,
                                               config: any(),
                                               appInfo: any(),
                                               signalingUrl: any())
        verify(videoClientMock, never()).setExternalVideoSource(any())
        verify(videoClientMock, never()).setSending(true)
    }

    func testStartVideoShareWithContentMaxResolutionUHD() {
        defaultContentShareVideoClientControllerHigh.startVideoShare(source: videoSourceMock)

        verify(videoClientMock).start(self.meetingId,
                                      token: self.joinToken,
                                      sending: false,
                                      config: any(),
                                      appInfo: any(),
                                      signalingUrl: any())
        verify(videoClientMock).setExternalVideoSource(any())
        verify(videoClientMock).setMaxBitRateKbps(VideoBitrateConstants().contentHighResolutionBitrateKbps)
        verify(videoClientMock).setContentMaxResolutionUHD(true)
        verify(videoClientMock).setSending(true)
    }

    func testStartVideoShareFirstTime() {
        defaultContentShareVideoClientController.startVideoShare(source: videoSourceMock)

        verify(videoClientMock).start(self.meetingId,
                                      token: self.joinToken,
                                      sending: false,
                                      config: any(),
                                      appInfo: any(),
                                      signalingUrl: any())
        verify(videoClientMock).setExternalVideoSource(any())
        verify(videoClientMock).setSending(true)
    }

    func testStartVideoShareWithConfig() {
        let config = LocalVideoConfiguration(maxBitRateKbps: 300)
        defaultContentShareVideoClientController.startVideoShare(source: videoSourceMock, config: config)

        verify(videoClientMock).setExternalVideoSource(any())
        verify(videoClientMock).setSending(true)
        verify(videoClientMock).setMaxBitRateKbps(UInt32(300))
    }

    func testStartVideoShareAfterStart() {
        stub(videoClientMock) { stub in
            when(stub.start(any(),
                            token: any(),
                            sending: any(),
                            config: any(),
                            appInfo: any(),
                            signalingUrl: any())).then {_, _, _, _, _, _ in
                self.defaultContentShareVideoClientController.videoClientDidConnect(nil, controlStatus: 1)
            }
            when(stub.stop()).then {
                self.defaultContentShareVideoClientController.videoClientDidStop(nil)
            }
        }

        defaultContentShareVideoClientController.startVideoShare(source: videoSourceMock)
        defaultContentShareVideoClientController.startVideoShare(source: videoSourceMock)

        verify(videoClientMock).start(self.meetingId,
                                      token: self.joinToken,
                                      sending: false,
                                      config: any(),
                                      appInfo: any(),
                                      signalingUrl: any())
        verify(videoClientMock, times(2)).setExternalVideoSource(any())
        verify(videoClientMock, times(2)).setSending(true)
    }

    func testStopVideoShareAfterStart() {
        stub(videoClientMock) { stub in
            when(stub.start(any(),
                            token: any(),
                            sending: any(),
                            config: any(),
                            appInfo: any(),
                            signalingUrl: any())).then {_, _, _, _, _, _ in
                self.defaultContentShareVideoClientController.videoClientDidConnect(nil, controlStatus: 1)
            }
            when(stub.stop()).then {
                self.defaultContentShareVideoClientController.videoClientDidStop(nil)
            }
        }

        defaultContentShareVideoClientController.startVideoShare(source: videoSourceMock)
        defaultContentShareVideoClientController.stopVideoShare()

        verify(videoClientMock).setSending(false)
        verify(videoClientMock).stop()
        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: .contentShareStopped))
    }

    func testStopVideoShareBeforeStart() {
        defaultContentShareVideoClientController.stopVideoShare()

        verify(videoClientMock, never()).setSending(false)
        verify(videoClientMock, never()).stop()
    }
    
    func testVideoClientDidReceiveEvent_ShouldPublishSignalingDroppedEvent_WhenEventTypeIsSignalingDropped() {
        let event: video_client_event = video_client_event(timestamp: 1,
                                                           event_type: VIDEO_CLIENT_EVENT_TYPE_SIGNALING_DROPPED,
                                                           signaling_dropped_error: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_INTERNAL_SERVER_ERROR,
                                                           signaling_open_duration_ms: 123,
                                                           ice_gathering_duration_ms: 0)
        let captor = ArgumentCaptor<[AnyHashable: Any]>()
        
        let mediaVideoClientMock = VideoClientMock()
        
        defaultContentShareVideoClientController.videoClient(mediaVideoClientMock, didReceive: event)
        
        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: .contentShareSignalingDropped),
                                                          attributes: captor.capture())
        
        let error = captor.value?[EventAttributeName.signalingDroppedError] as? SignalingDroppedError
        XCTAssertEqual(error, SignalingDroppedError.internalServerError)
    }
    
    func testVideoClientDidReceiveEvent_ShouldPublishSignalingOpenedEvent_WhenEventTypeIsSignalingOpened() {
        let event: video_client_event = video_client_event(timestamp: 1,
                                                           event_type: VIDEO_CLIENT_EVENT_TYPE_SIGNALING_OPENED,
                                                           signaling_dropped_error: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_INTERNAL_SERVER_ERROR,
                                                           signaling_open_duration_ms: 123,
                                                           ice_gathering_duration_ms: 0)
        let captor = ArgumentCaptor<[AnyHashable: Any]>()
        
        let mediaVideoClientMock = VideoClientMock()
        
        defaultContentShareVideoClientController.videoClient(mediaVideoClientMock, didReceive: event)
        
        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: .contentShareSignalingOpened),
                                                          attributes: captor.capture())
        
        let duration = captor.value?[EventAttributeName.signalingOpenDurationMs] as? Int64
        XCTAssertEqual(duration, 123)
    }
    
    func testVideoClientDidReceiveEvent_ShouldPublishIceGatheringCompleted_WhenEventTypeIsIceGatheringCompleted() {
        let event: video_client_event = video_client_event(timestamp: 1,
                                                           event_type: VIDEO_CLIENT_EVENT_TYPE_ICE_GATHERING_COMPLETED,
                                                           signaling_dropped_error: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_INTERNAL_SERVER_ERROR,
                                                           signaling_open_duration_ms: 123,
                                                           ice_gathering_duration_ms: 456)
        let captor = ArgumentCaptor<[AnyHashable: Any]>()
        
        let mediaVideoClientMock = VideoClientMock()
        
        defaultContentShareVideoClientController.videoClient(mediaVideoClientMock, didReceive: event)
        
        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: .contentShareIceGatheringCompleted),
                                                          attributes: captor.capture())
        
        let duration = captor.value?[EventAttributeName.iceGatheringDurationMs] as? Int64
        XCTAssertEqual(duration, 456)
    }
    
    func testStartVideoShare_ShouldPublishContentShareStartRequestedEvent() {
        defaultContentShareVideoClientController.startVideoShare(source: videoSourceMock)

        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: .contentShareStartRequested))
    }
    
    func testVideoClientDidConnect_ShouldPublishContentShareStartedEvent() {
        defaultContentShareVideoClientController.videoClientDidConnect(nil, controlStatus: 0)

        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: .contentShareStarted))
    }
    
    func testVideoClientDidFail_ShouldPublishContentShareFailedEvent() {
        let captor = ArgumentCaptor<[AnyHashable: Any]>()
        
        defaultContentShareVideoClientController.videoClientDidFail(nil,
                                                                    status: VIDEO_CLIENT_ERR_PROXY_AUTHENTICATION_FAILED,
                                                                    controlStatus: 0)
        
        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: .contentShareFailed),
                                                          attributes: captor.capture())
        
        let error = captor.value?[EventAttributeName.contentShareError] as? VideoClientFailedError
        XCTAssertEqual(error, VideoClientFailedError.authenticationFailed)
    }
    
    func testVideoClientDidStop_ShouldPublishContentShareStoppedEvent() {
        defaultContentShareVideoClientController.videoClientDidStop(nil)

        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: .contentShareStopped))
    }
}
