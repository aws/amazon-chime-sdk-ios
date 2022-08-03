//
//  DefaultContentShareVideoClientControllerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Mockingbird
import XCTest

class DefaultContentShareVideoClientControllerTests: CommonTestCase {
    var videoClientMock: VideoClientProtocolMock!
    var videoSourceMock: VideoSourceMock!
    var clientMetricsLollectorMock: ClientMetricsCollectorMock!
    var defaultContentShareVideoClientController: DefaultContentShareVideoClientController!

    override func setUp() {
        super.setUp()

        videoClientMock = mock(VideoClientProtocol.self)
        videoSourceMock = mock(VideoSource.self)
        loggerMock = mock(Logger.self)
        clientMetricsLollectorMock = mock(ClientMetricsCollector.self)
        defaultContentShareVideoClientController =
            DefaultContentShareVideoClientController(videoClient: videoClientMock,
                                                     configuration: meetingSessionConfigurationMock,
                                                     logger: loggerMock,
                                                     clientMetricsCollector: clientMetricsLollectorMock)

        given(videoSourceMock.getVideoContentHint()).willReturn(VideoContentHint.text)
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
}
