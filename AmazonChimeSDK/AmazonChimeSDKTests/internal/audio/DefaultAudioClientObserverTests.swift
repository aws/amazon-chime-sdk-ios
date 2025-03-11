//
//  DefaultAudioClientObserverTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import AmazonChimeSDKMedia
import Mockingbird
import XCTest

class DefaultAudioClientObserverTests: XCTestCase {
    var config: MeetingSessionConfiguration!
    let externalMeetingId = "external-meeting-id"
    let audioFallbackUrl = "audioFallbackUrl"
    let audioHostUrl = "audioHostUrl"
    let signalingUrl = "signalingUrl"
    let turnControlUrl = "turnControlUrl"
    let mediaRegion = "us-east-1"
    let meetingId = "meeting-id"
    let attendeeId = "attendee-id"
    let externalUserId = "externalUserId"
    let joinToken = "join-token"
    let timestampMs: Int64 = 1632087029249
    let transcriptionRegion = "us-east-1"
    let transcriptionConfiguration = "transcription-configuration"
    let failedMessage = "Internal server error"
    var audioClientMock: AudioClientProtocolMock!
    var clientMetricsCollectorMock: ClientMetricsCollectorMock!
    var audioSessionMock: AudioSessionMock!
    var audioLockMock: AudioLockMock!
    var eventAnalyticsControllerMock: EventAnalyticsControllerMock!
    var loggerMock: LoggerMock!
    var defaultAudioClientObserver: DefaultAudioClientObserver!
    var mockAudioVideoObserver: AudioVideoObserverMock!
    var mockRealTimeObserver: RealtimeObserverMock!
    var meetingStatsCollectorMock: MeetingStatsCollectorMock!
    var transcriptEventObserverMock: TranscriptEventObserverMock!

    let defaultTimeout = 1.0

    override func setUp() {
        mockAudioVideoObserver = mock(AudioVideoObserver.self)
        mockRealTimeObserver = mock(RealtimeObserver.self)
        audioClientMock = mock(AudioClientProtocol.self)
        clientMetricsCollectorMock = mock(ClientMetricsCollector.self)
        eventAnalyticsControllerMock = mock(EventAnalyticsController.self)
        audioLockMock = mock(AudioLock.self)
        meetingStatsCollectorMock = mock(MeetingStatsCollector.self)
        transcriptEventObserverMock = mock(TranscriptEventObserver.self)
        loggerMock = mock(Logger.self)

        given(meetingStatsCollectorMock.getMeetingStats()).will { [AnyHashable: Any]() }

        let mediaPlacementMock: MediaPlacementMock = mock(MediaPlacement.self)
            .initialize(audioFallbackUrl: audioFallbackUrl,
                        audioHostUrl: audioHostUrl,
                        signalingUrl: signalingUrl,
                        turnControlUrl: turnControlUrl,
                        eventIngestionUrl: nil)
        let meetingFeaturesMock: MeetingFeaturesMock = mock(MeetingFeatures.self)
            .initialize(videoMaxResolution: VideoResolution.videoResolutionHD,
                        contentMaxResolution: VideoResolution.videoResolutionFHD)
        let meetingMock: MeetingMock = mock(Meeting.self).initialize(externalMeetingId: externalMeetingId,
                                                                     mediaPlacement: mediaPlacementMock,
                                                                     meetingFeatures: meetingFeaturesMock,
                                                                     mediaRegion: mediaRegion,
                                                                     meetingId: meetingId,
                                                                     primaryMeetingId: nil)
        let createMeetingResponseMock: CreateMeetingResponseMock = mock(CreateMeetingResponse.self)
            .initialize(meeting: meetingMock)

        let attendeeMock: AttendeeMock = mock(Attendee.self).initialize(attendeeId: attendeeId,
                                                                        externalUserId: externalUserId,
                                                                        joinToken: joinToken)
        let createAttendeeResponseMock: CreateAttendeeResponseMock = mock(CreateAttendeeResponse.self)
            .initialize(attendee: attendeeMock)
        let clientConfig = MeetingEventClientConfiguration(eventClientJoinToken: joinToken, meetingId: meetingId, attendeeId: attendeeId)

        config = mock(MeetingSessionConfiguration.self).initialize(createMeetingResponse: createMeetingResponseMock,
                                                                   createAttendeeResponse: createAttendeeResponseMock,
                                                                   urlRewriter: URLRewriterUtils.defaultUrlRewriter)
        defaultAudioClientObserver = DefaultAudioClientObserver(audioClient: audioClientMock,
                                                                clientMetricsCollector: clientMetricsCollectorMock,
                                                                audioClientLock: audioLockMock,
                                                                configuration: config,
                                                                logger: loggerMock,
                                                                eventAnalyticsController: eventAnalyticsControllerMock,
                                                                meetingStatsCollector: meetingStatsCollectorMock)
        defaultAudioClientObserver.subscribeToAudioClientStateChange(observer: mockAudioVideoObserver)
        defaultAudioClientObserver.subscribeToRealTimeEvents(observer: mockRealTimeObserver)
        defaultAudioClientObserver.subscribeToTranscriptEvent(observer: transcriptEventObserverMock)
        given(audioClientMock.stopSession()).willReturn(0)
        DefaultAudioClientController.state = .started
    }
    
    // MARK: - Audio Client State Changed Tests
    
    // Client state change tests -- Common sense tests

    func testAudioClientStateChanged_Connected() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTING,
                                                           status: audio_client_status_t.init(0))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(0))
        let expect = eventually {
            verify(mockAudioVideoObserver.audioSessionDidStart(reconnecting: false)).wasCalled()
        }

        wait(for: [expect], timeout: 1.0)
    }

    func testAudioClientStateChanged_Reconnected() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        let expect = eventually {
            verify(mockAudioVideoObserver.audioSessionDidStart(reconnecting: true)).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }

    func testAudioClientStateChanged_ConnectionRecover() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.networkBecomePoor.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        let expect = eventually {
            verify(mockAudioVideoObserver.connectionDidRecover()).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }

    func testAudioClientStateChanged_ConnectionBecomePoor() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.networkBecomePoor.rawValue))
        let expect = eventually {
            verify(mockAudioVideoObserver.connectionDidBecomePoor()).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }

    func testAudioClientStateChanged_ConnectionDrop() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        let expect = eventually {
            verify(mockAudioVideoObserver.audioSessionDidDrop()).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }

    func testAudioClientStateChanged_ConnectionCancelReconnect() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        let expect = eventually {
            verify(mockAudioVideoObserver.audioSessionDidCancelReconnect()).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }

    func testAudioClientStateChanged_ConnectionFailedFromConnecting() {
        
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioDisconnected.rawValue))

        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioDisconnected)
    }

    func testAudioClientStateChanged_ConnectionFailedFromConnected() {
        
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioDisconnected.rawValue))

        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioDisconnected)
    }
    
    func testAudioClientStateChanged_ConnectionFailedFromReconnecting() {
        
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioDisconnected.rawValue))
        let expect = eventually {
            verify(mockAudioVideoObserver.audioSessionDidCancelReconnect()).wasCalled()
            verify(eventAnalyticsControllerMock.publishEvent(name: .meetingFailed, attributes: any())).wasCalled()
            verify(mockAudioVideoObserver.audioSessionDidStopWithStatus(sessionStatus: any(MeetingSessionStatus.self,
                                                                        where: { $0.statusCode.rawValue == MeetingSessionStatusCode.audioDisconnected.rawValue}))).wasCalled()
            verify(meetingStatsCollectorMock.resetMeetingStats()).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }
    
    func testAudioClientStateChanged_FinishDisconnectingFromConnecting() {
        
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServerHungup.rawValue))
        verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode.audioServerHungup)
    }

    func testAudioClientStateChanged_FinishDisconnectingFromConnected() {
        
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServerHungup.rawValue))
        verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode.audioServerHungup)
    }
    
    func testAudioClientStateChanged_FinishDisconnectingFromReconnecting() {
        
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServerHungup.rawValue))
        let expect = eventually {
            verify(mockAudioVideoObserver.audioSessionDidCancelReconnect()).wasCalled()
            verify(eventAnalyticsControllerMock.publishEvent(name: .meetingEnded, attributes: any())).wasCalled()
            verify(meetingStatsCollectorMock.resetMeetingStats()).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }

    func testAudioClientStateChanged_FinishDisconnectingFromConnected_WhenJoinedFromAnotherDevice() {
        given(audioClientMock.stopSession()).willReturn(0)
         DefaultAudioClientController.state = .started
         defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                            status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
         defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                            status: audio_client_status_t.init(MeetingSessionStatusCode.audioJoinedFromAnotherDevice.rawValue))
        verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode.audioJoinedFromAnotherDevice)
     }
    
    func testAudioClientStateChanged_FinishDisconnectingFromConnecting_WhenJoinedFromAnotherDevice() {
        given(audioClientMock.stopSession()).willReturn(0)
         DefaultAudioClientController.state = .started
         defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTING,
                                                            status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
         defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                            status: audio_client_status_t.init(MeetingSessionStatusCode.audioJoinedFromAnotherDevice.rawValue))
        verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode.audioJoinedFromAnotherDevice)
     }
    
    func testAudioClientStateChanged_FinishDisconnectingFromReconnecting_WhenJoinedFromAnotherDevice() {
        given(audioClientMock.stopSession()).willReturn(0)
         DefaultAudioClientController.state = .started
         defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                            status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
         defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                            status: audio_client_status_t.init(MeetingSessionStatusCode.audioJoinedFromAnotherDevice.rawValue))
         let expect = eventually {
             verify(mockAudioVideoObserver.audioSessionDidStopWithStatus(sessionStatus: any(MeetingSessionStatus.self,
                                                                        where: { $0.statusCode.rawValue == MeetingSessionStatusCode.audioJoinedFromAnotherDevice.rawValue}))).wasCalled()
             verify(eventAnalyticsControllerMock.publishEvent(name: .meetingEnded, attributes: any())).wasCalled()
             verify(meetingStatsCollectorMock.resetMeetingStats()).wasCalled()
             verify(mockAudioVideoObserver.audioSessionDidCancelReconnect()).wasCalled()
         }
 
         wait(for: [expect], timeout: defaultTimeout)
     }

    func testAudioClientStateChanged_NotifiesOfInputDeviceFailure() {
        
        let statusCode = MeetingSessionStatusCode.audioInputDeviceNotResponding.rawValue
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(statusCode))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioInputDeviceNotResponding)
    }

    func testAudioClientStateChanged_NotifiesOfOutputDeviceFailure() {
        
        let statusCode = MeetingSessionStatusCode.audioOutputDeviceNotResponding.rawValue
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(statusCode))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioOutputDeviceNotResponding)
    }

    func testAudioClientStateChanged_ConnectionCancelledReconnect() {
        
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioDisconnected.rawValue))
        let expect = eventually {
            verify(mockAudioVideoObserver.audioSessionDidCancelReconnect()).wasCalled()
            verify(mockAudioVideoObserver.audioSessionDidStopWithStatus(sessionStatus: any(MeetingSessionStatus.self,
                                                                        where: { $0.statusCode.rawValue == MeetingSessionStatusCode.audioDisconnected.rawValue}))).wasCalled()
            verify(eventAnalyticsControllerMock.publishEvent(name: .meetingFailed, attributes: any())).wasCalled()
            verify(meetingStatsCollectorMock.resetMeetingStats()).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }
    
    func testAudioClientStateChanged_SameStateStatusNoop() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        verifyAudioClientStateNoop()
    }
    
    // Client state change tests -- Remaining combinations of state and status from connected state with ok status
    
    func testAudioClientStateChanged_ConnectedOkToUnknownOk() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_UNKNOWN,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToInitOk() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_INIT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToConnectingOk() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        verifyAudioClientStateNoop()
    }

    func testAudioClientStateChanged_ConnectedOkToFailedOk() {
        
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_FAILED_TO_CONNECT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.ok)
    }

    func testAudioClientStateChanged_ConnectedOkToDisconnectingOk() {
        
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedNormalOk() {
        
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedAbnormalOk() {
        
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.ok)
    }
    
    func testAudioClientStateChanged_ConnectedOkToServerHungupOk() {
        
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.ok)
    }
    
    func testAudioClientStateChanged_ConnectedOkToUnknownAudioDisconnected() {
        
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_UNKNOWN,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioDisconnected.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToInitAudioDisconnected() {
        
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_INIT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioDisconnected.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToConnectingAudioDisconnected() {
        
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioDisconnected.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToReconnectingAudioDisconnected() {
        
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioDisconnected.rawValue))
        verifyAudioClientStateChangedToReconnecting()
    }

    func testAudioClientStateChanged_ConnectedOkToFailedAudioDisconnected() {
        
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_FAILED_TO_CONNECT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioDisconnected.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioDisconnected)
    }

    func testAudioClientStateChanged_ConnectedOkToDisconnectingAudioDisconnected() {
        
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioDisconnected.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedNormalAudioDisconnected() {
        
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioDisconnected.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedAbnormalAudioDisconnected() {
        
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioDisconnected.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioDisconnected)
    }
    
    func testAudioClientStateChanged_ConnectedOkToServerHungupAudioDisconnected() {
        
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioDisconnected.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioDisconnected)
    }
    
    func testAudioClientStateChanged_ConnectedOkToUnknownConnectionHealthReconnect() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_UNKNOWN,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.connectionHealthReconnect.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToInitConnectionHealthReconnect() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_INIT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.connectionHealthReconnect.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToConnectingConnectionHealthReconnect() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.connectionHealthReconnect.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToReconnectingConnectionHealthReconnect() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.connectionHealthReconnect.rawValue))
        verifyAudioClientStateChangedToReconnecting()
    }

    func testAudioClientStateChanged_ConnectedOkToFailedConnectionHealthReconnect() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_FAILED_TO_CONNECT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.connectionHealthReconnect.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.connectionHealthReconnect)
    }

    func testAudioClientStateChanged_ConnectedOkToDisconnectingConnectionHealthReconnect() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.connectionHealthReconnect.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedNormalConnectionHealthReconnect() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.connectionHealthReconnect.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedAbnormalConnectionHealthReconnect() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.connectionHealthReconnect.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.connectionHealthReconnect)
    }
    
    func testAudioClientStateChanged_ConnectedOkToServerHungupConnectionHealthReconnect() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.connectionHealthReconnect.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.connectionHealthReconnect)
    }
    
    func testAudioClientStateChanged_ConnectedOkToUnknownNetworkBecomePoor() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_UNKNOWN,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.networkBecomePoor.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToInitNetworkBecomePoor() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_INIT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.networkBecomePoor.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToConnectingNetworkBecomePoor() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.networkBecomePoor.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToReconnectingNetworkBecomePoor() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.networkBecomePoor.rawValue))
        verifyAudioClientStateChangedToReconnecting()
    }

    func testAudioClientStateChanged_ConnectedOkToFailedNetworkBecomePoor() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_FAILED_TO_CONNECT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.networkBecomePoor.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.networkBecomePoor)
    }

    func testAudioClientStateChanged_ConnectedOkToDisconnectingNetworkBecomePoor() {
        
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.networkBecomePoor.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedNormalNetworkBecomePoor() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.networkBecomePoor.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedAbnormalNetworkBecomePoor() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.networkBecomePoor.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.networkBecomePoor)
    }
    
    func testAudioClientStateChanged_ConnectedOkToServerHungupNetworkBecomePoor() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.networkBecomePoor.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.networkBecomePoor)
    }
    
    func testAudioClientStateChanged_ConnectedOkToUnknownAudioServerHungup() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_UNKNOWN,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServerHungup.rawValue))
        verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode.audioServerHungup)
    }
    
    func testAudioClientStateChanged_ConnectedOkToInitAudioServerHungup() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_INIT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServerHungup.rawValue))
        verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode.audioServerHungup)
    }
    
    func testAudioClientStateChanged_ConnectedOkToConnectingAudioServerHungup() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServerHungup.rawValue))
        verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode.audioServerHungup)
    }
    
    func testAudioClientStateChanged_ConnectedOkToReconnectingAudioServerHungup() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServerHungup.rawValue))
        verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode.audioServerHungup)
    }

    func testAudioClientStateChanged_ConnectedOkToFailedAudioServerHungup() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_FAILED_TO_CONNECT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServerHungup.rawValue))
        verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode.audioServerHungup)
    }

    func testAudioClientStateChanged_ConnectedOkToDisconnectingAudioServerHungup() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServerHungup.rawValue))
        verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode.audioServerHungup)
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedNormalAudioServerHungup() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServerHungup.rawValue))
        verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode.audioServerHungup)
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedAbnormalAudioServerHungup() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServerHungup.rawValue))
        verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode.audioServerHungup)
    }
    
    func testAudioClientStateChanged_ConnectedOkToServerHungupAudioServerHungup() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServerHungup.rawValue))
        verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode.audioServerHungup)
    }
    
    func testAudioClientStateChanged_ConnectedOkToUnknownAudioJoinedFromAnotherDevice() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_UNKNOWN,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioJoinedFromAnotherDevice.rawValue))
        verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode.audioJoinedFromAnotherDevice)
    }
    
    func testAudioClientStateChanged_ConnectedOkToInitAudioJoinedFromAnotherDevice() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_INIT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioJoinedFromAnotherDevice.rawValue))
        verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode.audioJoinedFromAnotherDevice)
    }
    
    func testAudioClientStateChanged_ConnectedOkToConnectingAudioJoinedFromAnotherDevice() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioJoinedFromAnotherDevice.rawValue))
        verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode.audioJoinedFromAnotherDevice)
    }
    
    func testAudioClientStateChanged_ConnectedOkToReconnectingAudioJoinedFromAnotherDevice() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioJoinedFromAnotherDevice.rawValue))
        verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode.audioJoinedFromAnotherDevice)
    }

    func testAudioClientStateChanged_ConnectedOkToFailedAudioJoinedFromAnotherDevice() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_FAILED_TO_CONNECT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioJoinedFromAnotherDevice.rawValue))
        verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode.audioJoinedFromAnotherDevice)
    }

    func testAudioClientStateChanged_ConnectedOkToDisconnectingAudioJoinedFromAnotherDevice() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioJoinedFromAnotherDevice.rawValue))
        verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode.audioJoinedFromAnotherDevice)
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedNormalAudioJoinedFromAnotherDevice() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioJoinedFromAnotherDevice.rawValue))
        verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode.audioJoinedFromAnotherDevice)
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedAbnormalAudioJoinedFromAnotherDevice() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioJoinedFromAnotherDevice.rawValue))
        verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode.audioJoinedFromAnotherDevice)
    }
    
    func testAudioClientStateChanged_ConnectedOkToServerHungupAudioJoinedFromAnotherDevice() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioJoinedFromAnotherDevice.rawValue))
        verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode.audioJoinedFromAnotherDevice)
    }
    
    func testAudioClientStateChanged_ConnectedOkToUnknownAudioInternalServerError() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_UNKNOWN,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioInternalServerError.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToInitAudioInternalServerError() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_INIT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioInternalServerError.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToConnectingAudioInternalServerError() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioInternalServerError.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToReconnectingAudioInternalServerError() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioInternalServerError.rawValue))
        verifyAudioClientStateChangedToReconnecting()
    }

    func testAudioClientStateChanged_ConnectedOkToFailedAudioInternalServerError() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_FAILED_TO_CONNECT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioInternalServerError.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioInternalServerError)
    }

    func testAudioClientStateChanged_ConnectedOkToDisconnectingAudioInternalServerError() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioInternalServerError.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedNormalAudioInternalServerError() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioInternalServerError.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedAbnormalAudioInternalServerError() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioInternalServerError.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioInternalServerError)
    }
    
    func testAudioClientStateChanged_ConnectedOkToServerHungupAudioInternalServerError() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioInternalServerError.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioInternalServerError)
    }
    
    func testAudioClientStateChanged_ConnectedOkToUnknownAudioAuthenticationRejected() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_UNKNOWN,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioAuthenticationRejected.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToInitAudioAuthenticationRejected() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_INIT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioAuthenticationRejected.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToConnectingAudioAuthenticationRejected() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioAuthenticationRejected.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToReconnectingAudioAuthenticationRejected() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioAuthenticationRejected.rawValue))
        verifyAudioClientStateChangedToReconnecting()
    }

    func testAudioClientStateChanged_ConnectedOkToFailedAudioAuthenticationRejected() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_FAILED_TO_CONNECT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioAuthenticationRejected.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioAuthenticationRejected)
    }

    func testAudioClientStateChanged_ConnectedOkToDisconnectingAudioAuthenticationRejected() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioAuthenticationRejected.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedNormalAudioAuthenticationRejected() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioAuthenticationRejected.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedAbnormalAudioAuthenticationRejected() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioAuthenticationRejected.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioAuthenticationRejected)
    }
    
    func testAudioClientStateChanged_ConnectedOkToServerHungupAudioAuthenticationRejected() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioAuthenticationRejected.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioAuthenticationRejected)
    }
    
    func testAudioClientStateChanged_ConnectedOkToUnknownAudioCallAtCapacity() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_UNKNOWN,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioCallAtCapacity.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToInitAudioCallAtCapacity() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_INIT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioCallAtCapacity.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToConnectingAudioCallAtCapacity() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioCallAtCapacity.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToReconnectingAudioCallAtCapacity() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioCallAtCapacity.rawValue))
        verifyAudioClientStateChangedToReconnecting()
    }

    func testAudioClientStateChanged_ConnectedOkToFailedAudioCallAtCapacity() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_FAILED_TO_CONNECT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioCallAtCapacity.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioCallAtCapacity)
    }

    func testAudioClientStateChanged_ConnectedOkToDisconnectingAudioCallAtCapacity() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioCallAtCapacity.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedNormalAudioCallAtCapacity() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioCallAtCapacity.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedAbnormalAudioCallAtCapacity() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioCallAtCapacity.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioCallAtCapacity)
    }
    
    func testAudioClientStateChanged_ConnectedOkToServerHungupAudioCallAtCapacity() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioCallAtCapacity.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioCallAtCapacity)
    }
    
    func testAudioClientStateChanged_ConnectedOkToUnknownAudioServiceUnavailable() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_UNKNOWN,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServiceUnavailable.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToInitAudioServiceUnavailable() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_INIT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServiceUnavailable.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToConnectingAudioServiceUnavailable() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServiceUnavailable.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToReconnectingAudioServiceUnavailable() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServiceUnavailable.rawValue))
        verifyAudioClientStateChangedToReconnecting()
    }

    func testAudioClientStateChanged_ConnectedOkToFailedAudioServiceUnavailable() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_FAILED_TO_CONNECT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServiceUnavailable.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioServiceUnavailable)
    }

    func testAudioClientStateChanged_ConnectedOkToDisconnectingAudioServiceUnavailable() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServiceUnavailable.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedNormalAudioServiceUnavailable() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServiceUnavailable.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedAbnormalAudioServiceUnavailable() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServiceUnavailable.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioServiceUnavailable)
    }
    
    func testAudioClientStateChanged_ConnectedOkToServerHungupAudioServiceUnavailable() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServiceUnavailable.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioServiceUnavailable)
    }
    
    func testAudioClientStateChanged_ConnectedOkToUnknownAudioDisconnectAudio() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_UNKNOWN,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioDisconnectAudio.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToInitAudioDisconnectAudio() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_INIT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioDisconnectAudio.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToConnectingAudioDisconnectAudio() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioDisconnectAudio.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToReconnectingAudioDisconnectAudio() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioDisconnectAudio.rawValue))
        verifyAudioClientStateChangedToReconnecting()
    }

    func testAudioClientStateChanged_ConnectedOkToFailedAudioDisconnectAudio() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_FAILED_TO_CONNECT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioDisconnectAudio.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioDisconnectAudio)
    }

    func testAudioClientStateChanged_ConnectedOkToDisconnectingAudioDisconnectAudio() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioDisconnectAudio.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedNormalAudioDisconnectAudio() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioDisconnectAudio.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedAbnormalAudioDisconnectAudio() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioDisconnectAudio.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioDisconnectAudio)
    }
    
    func testAudioClientStateChanged_ConnectedOkToServerHungupAudioDisconnectAudio() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioDisconnectAudio.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioDisconnectAudio)
    }
    
    func testAudioClientStateChanged_ConnectedOkToUnknownAudioCallEnded() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_UNKNOWN,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioCallEnded.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToInitAudioCallEnded() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_INIT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioCallEnded.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToConnectingAudioCallEnded() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioCallEnded.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToReconnectingAudioCallEnded() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioCallEnded.rawValue))
        verifyAudioClientStateChangedToReconnecting()
    }

    func testAudioClientStateChanged_ConnectedOkToFailedAudioCallEnded() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_FAILED_TO_CONNECT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioCallEnded.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioCallEnded)
    }

    func testAudioClientStateChanged_ConnectedOkToDisconnectingAudioCallEnded() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioCallEnded.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedNormalAudioCallEnded() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioCallEnded.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedAbnormalAudioCallEnded() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioCallEnded.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioCallEnded)
    }
    
    func testAudioClientStateChanged_ConnectedOkToServerHungupAudioCallEnded() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioCallEnded.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioCallEnded)
    }
    
    func testAudioClientStateChanged_ConnectedOkToUnknownVideoServiceUnavailable() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_UNKNOWN,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.videoServiceUnavailable.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToInitVideoServiceUnavailable() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_INIT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.videoServiceUnavailable.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToConnectingVideoServiceUnavailable() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.videoServiceUnavailable.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToReconnectingVideoServiceUnavailable() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.videoServiceUnavailable.rawValue))
        verifyAudioClientStateChangedToReconnecting()
    }

    func testAudioClientStateChanged_ConnectedOkToFailedVideoServiceUnavailable() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_FAILED_TO_CONNECT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.videoServiceUnavailable.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.videoServiceUnavailable)
    }

    func testAudioClientStateChanged_ConnectedOkToDisconnectingVideoServiceUnavailable() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.videoServiceUnavailable.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedNormalVideoServiceUnavailable() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.videoServiceUnavailable.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedAbnormalVideoServiceUnavailable() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.videoServiceUnavailable.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.videoServiceUnavailable)
    }
    
    func testAudioClientStateChanged_ConnectedOkToServerHungupVideoServiceUnavailable() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.videoServiceUnavailable.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.videoServiceUnavailable)
    }
    
    func testAudioClientStateChanged_ConnectedOkToUnknownUnknown() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_UNKNOWN,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.unknown.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToInitUnknown() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_INIT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.unknown.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToConnectingUnknown() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.unknown.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToReconnectingUnknown() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.unknown.rawValue))
        verifyAudioClientStateChangedToReconnecting()
    }

    func testAudioClientStateChanged_ConnectedOkToFailedUnknown() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_FAILED_TO_CONNECT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.unknown.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.unknown)
    }

    func testAudioClientStateChanged_ConnectedOkToDisconnectingUnknown() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.unknown.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedNormalUnknown() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.unknown.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedAbnormalUnknown() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.unknown.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.unknown)
    }
    
    func testAudioClientStateChanged_ConnectedOkToServerHungupUnknown() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.unknown.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.unknown)
    }
    
    func testAudioClientStateChanged_ConnectedOkToUnknownVideoAtCapacityViewOnly() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_UNKNOWN,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.videoAtCapacityViewOnly.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToInitVideoAtCapacityViewOnly() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_INIT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.videoAtCapacityViewOnly.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToConnectingVideoAtCapacityViewOnly() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.videoAtCapacityViewOnly.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToReconnectingVideoAtCapacityViewOnly() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.videoAtCapacityViewOnly.rawValue))
        verifyAudioClientStateChangedToReconnecting()
    }

    func testAudioClientStateChanged_ConnectedOkToFailedVideoAtCapacityViewOnly() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_FAILED_TO_CONNECT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.videoAtCapacityViewOnly.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.videoAtCapacityViewOnly)
    }

    func testAudioClientStateChanged_ConnectedOkToDisconnectingVideoAtCapacityViewOnly() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.videoAtCapacityViewOnly.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedNormalVideoAtCapacityViewOnly() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.videoAtCapacityViewOnly.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedAbnormalVideoAtCapacityViewOnly() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.videoAtCapacityViewOnly.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.videoAtCapacityViewOnly)
    }
    
    func testAudioClientStateChanged_ConnectedOkToServerHungupVideoAtCapacityViewOnly() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.videoAtCapacityViewOnly.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.videoAtCapacityViewOnly)
    }
    
    func testAudioClientStateChanged_ConnectedOkToUnknownAudioInputDeviceNotResponding() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_UNKNOWN,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioInputDeviceNotResponding.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToInitAudioInputDeviceNotResponding() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_INIT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioInputDeviceNotResponding.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToConnectingAudioInputDeviceNotResponding() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioInputDeviceNotResponding.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToReconnectingAudioInputDeviceNotResponding() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioInputDeviceNotResponding.rawValue))
        verifyAudioClientStateChangedToReconnecting()
    }

    func testAudioClientStateChanged_ConnectedOkToFailedAudioInputDeviceNotResponding() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_FAILED_TO_CONNECT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioInputDeviceNotResponding.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioInputDeviceNotResponding)
    }

    func testAudioClientStateChanged_ConnectedOkToDisconnectingAudioInputDeviceNotResponding() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioInputDeviceNotResponding.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedNormalAudioInputDeviceNotResponding() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioInputDeviceNotResponding.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedAbnormalAudioInputDeviceNotResponding() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioInputDeviceNotResponding.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioInputDeviceNotResponding)
    }
    
    func testAudioClientStateChanged_ConnectedOkToServerHungupAudioInputDeviceNotResponding() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioInputDeviceNotResponding.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioInputDeviceNotResponding)
    }
    
    func testAudioClientStateChanged_ConnectedOkToUnknownAudioOutputDeviceNotResponding() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_UNKNOWN,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioOutputDeviceNotResponding.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToInitAudioOutputDeviceNotResponding() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_INIT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioOutputDeviceNotResponding.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToConnectingAudioOutputDeviceNotResponding() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioOutputDeviceNotResponding.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToReconnectingAudioOutputDeviceNotResponding() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioOutputDeviceNotResponding.rawValue))
        verifyAudioClientStateChangedToReconnecting()
    }

    func testAudioClientStateChanged_ConnectedOkToFailedAudioOutputDeviceNotResponding() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_FAILED_TO_CONNECT,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioOutputDeviceNotResponding.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioOutputDeviceNotResponding)
    }

    func testAudioClientStateChanged_ConnectedOkToDisconnectingAudioOutputDeviceNotResponding() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioOutputDeviceNotResponding.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedNormalAudioOutputDeviceNotResponding() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioOutputDeviceNotResponding.rawValue))
        verifyAudioClientStateNoop()
    }
    
    func testAudioClientStateChanged_ConnectedOkToDisconnectedAbnormalAudioOutputDeviceNotResponding() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioOutputDeviceNotResponding.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioOutputDeviceNotResponding)
    }
    
    func testAudioClientStateChanged_ConnectedOkToServerHungupAudioOutputDeviceNotResponding() {
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_SERVER_HUNGUP,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioOutputDeviceNotResponding.rawValue))
        verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode.audioOutputDeviceNotResponding)
    }
    
    func verifyAudioClientStateChangedToReconnecting() {
        verifyAudioClientStateNoop()
        let expect = eventually {
            verify(mockAudioVideoObserver.audioSessionDidDrop()).wasCalled()
        }
        wait(for: [expect], timeout: defaultTimeout)
    }
    
    func verifyAudioClientStateMeetingFailed(statusCode: MeetingSessionStatusCode) {
        let expect = eventually {
            verify(mockAudioVideoObserver.audioSessionDidStopWithStatus(sessionStatus: any(MeetingSessionStatus.self,
                                                                        where: { $0.statusCode.rawValue == statusCode.rawValue}))).wasCalled()
            verify(eventAnalyticsControllerMock.publishEvent(name: .meetingFailed, attributes: any())).wasCalled()
            verify(meetingStatsCollectorMock.resetMeetingStats()).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }
    
    func verifyAudioClientStateMeetingEnded(statusCode: MeetingSessionStatusCode) {
        let expect = eventually {
            verify(mockAudioVideoObserver.audioSessionDidStopWithStatus(sessionStatus: any(MeetingSessionStatus.self,
                                                                        where: { $0.statusCode.rawValue == statusCode.rawValue}))).wasCalled()
            verify(eventAnalyticsControllerMock.publishEvent(name: .meetingEnded, attributes: any())).wasCalled()
            verify(meetingStatsCollectorMock.resetMeetingStats()).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }
    
    func verifyAudioClientStateNoop() {
        verify(mockAudioVideoObserver.audioSessionDidStopWithStatus(sessionStatus: any())).wasNeverCalled()
        verify(eventAnalyticsControllerMock.publishEvent(name: any(), attributes: any())).wasNeverCalled()
        verify(meetingStatsCollectorMock.resetMeetingStats()).wasNeverCalled()
    }
    
    // MARK: - Audio Metric Changed Tests

    func testAudioMetricChanged_processAudioClientMetrics() {
        var metrics = [AnyHashable: Any]()
        metrics[ObservableMetric.audioSendPacketLossPercent] = 50
        defaultAudioClientObserver.audioMetricsChanged(metrics)
        verify(clientMetricsCollectorMock.processAudioClientMetrics(metrics: any())).wasCalled()
    }
}

// MARK: - Signal Strength Tests
extension DefaultAudioClientObserverTests{
    func testSignalStrengthChanged_signalStrengthDidChange() {
        let signals = [AttendeeUpdate(profileId: attendeeId, externalUserId: externalUserId, data: 0)]
        defaultAudioClientObserver.signalStrengthChanged(signals as [Any])
        let expect = eventually {
            verify(mockRealTimeObserver.signalStrengthDidChange(signalUpdates: any())).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }

    func testSignalStrengthChanged_signalStrengthDidChange_noDuplicate() {
        let signals = [AttendeeUpdate(profileId: attendeeId, externalUserId: externalUserId, data: 0)]
        defaultAudioClientObserver.signalStrengthChanged(signals as [Any])
        defaultAudioClientObserver.signalStrengthChanged(signals as [Any])
        let expect = eventually {
            verify(mockRealTimeObserver.signalStrengthDidChange(signalUpdates: any())).wasCalled(1)
        }

        wait(for: [expect], timeout: defaultTimeout)
    }

    func testSignalStrengthChanged_signalStrengthDidChange_differentSignalLevel() {
        let signals = [AttendeeUpdate(profileId: attendeeId, externalUserId: externalUserId, data: 0)]
        let signals2 = [AttendeeUpdate(profileId: attendeeId, externalUserId: externalUserId, data: 1)]
        defaultAudioClientObserver.signalStrengthChanged(signals as [Any])
        defaultAudioClientObserver.signalStrengthChanged(signals2 as [Any])
        let expect = eventually {
            verify(mockRealTimeObserver.signalStrengthDidChange(signalUpdates: any())).wasCalled(2)
        }

        wait(for: [expect], timeout: defaultTimeout)
    }
}

// MARK: - Volume State Tests
extension DefaultAudioClientObserverTests{
    func testVolumeStateChanged_volumeDidChange() {
        let volumes = [AttendeeUpdate(profileId: attendeeId, externalUserId: externalUserId, data: 2)]
        defaultAudioClientObserver.volumeStateChanged(volumes as [Any])
        let expect = eventually {
            verify(mockRealTimeObserver.volumeDidChange(volumeUpdates: any())).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }

    func testVolumeStateChanged_volumeDidChange_noDuplicate() {
        let volumes = [AttendeeUpdate(profileId: attendeeId, externalUserId: externalUserId, data: 2)]
        defaultAudioClientObserver.volumeStateChanged(volumes as [Any])
        defaultAudioClientObserver.volumeStateChanged(volumes as [Any])
        let expect = eventually {
            verify(mockRealTimeObserver.volumeDidChange(volumeUpdates: any())).wasCalled(1)
        }

        wait(for: [expect], timeout: defaultTimeout)
    }

    func testVolumeStateChanged_volumeDidChange_differentVolumeLevel() {
        let volumes = [AttendeeUpdate(profileId: attendeeId, externalUserId: externalUserId, data: 2)]
        let volumes2 = [AttendeeUpdate(profileId: attendeeId, externalUserId: externalUserId, data: 1)]
        defaultAudioClientObserver.volumeStateChanged(volumes as [Any])
        defaultAudioClientObserver.volumeStateChanged(volumes2 as [Any])
        let expect = eventually {
            verify(mockRealTimeObserver.volumeDidChange(volumeUpdates: any())).wasCalled(2)
        }

        wait(for: [expect], timeout: defaultTimeout)
    }

    func testVolumeStateChanged_attendeesDidMute() {
        let volumes = [AttendeeUpdate(profileId: attendeeId, externalUserId: externalUserId, data: -1)]
        defaultAudioClientObserver.volumeStateChanged(volumes as [Any])
        let expect = eventually {
            verify(mockRealTimeObserver.attendeesDidMute(attendeeInfo: any())).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }

    func testVolumeStateChanged_attendeesDidUnMute() {
        let volumes = [AttendeeUpdate(profileId: attendeeId, externalUserId: externalUserId, data: -1)]
        let volumes2 = [AttendeeUpdate(profileId: attendeeId, externalUserId: externalUserId, data: 2)]
        defaultAudioClientObserver.volumeStateChanged(volumes as [Any])
        defaultAudioClientObserver.volumeStateChanged(volumes2 as [Any])
        let expect = eventually {
            verify(mockRealTimeObserver.attendeesDidMute(attendeeInfo: any())).wasCalled()
            verify(mockRealTimeObserver.attendeesDidUnmute(attendeeInfo: any())).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }
}

// MARK: - Attendees Presence Tests
extension DefaultAudioClientObserverTests{
    func testAttendeesPresenceChanged_attendeesDidJoin() {
        let attendees = [AttendeeUpdate(profileId: attendeeId, externalUserId: externalUserId, data: 1)]
        defaultAudioClientObserver.attendeesPresenceChanged(attendees as [Any])
        let expect = eventually {
            verify(mockRealTimeObserver.attendeesDidJoin(attendeeInfo: any())).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }

    func testAttendeesPresenceChanged_attendeesDidJoinDuplicate() {
        let attendees = [AttendeeUpdate(profileId: attendeeId, externalUserId: externalUserId, data: 1)]
        defaultAudioClientObserver.attendeesPresenceChanged(attendees as [Any])
        defaultAudioClientObserver.attendeesPresenceChanged(attendees as [Any])
        let expect = eventually {
            verify(mockRealTimeObserver.attendeesDidJoin(attendeeInfo: any())).wasCalled(1)
        }

        wait(for: [expect], timeout: defaultTimeout)
    }

    func testAttendeesPresenceChanged_attendeesDidLeave() {
        let attendees = [AttendeeUpdate(profileId: attendeeId, externalUserId: externalUserId, data: 1)]
        let attendees2 = [AttendeeUpdate(profileId: attendeeId, externalUserId: externalUserId, data: 2)]
        defaultAudioClientObserver.attendeesPresenceChanged(attendees as [Any])
        defaultAudioClientObserver.attendeesPresenceChanged(attendees2 as [Any])
        let expect = eventually {
            verify(mockRealTimeObserver.attendeesDidJoin(attendeeInfo: any())).wasCalled()
            verify(mockRealTimeObserver.attendeesDidLeave(attendeeInfo: any())).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }

    func testAttendeesPresenceChanged_attendeesDidDrop() {
        let attendees = [AttendeeUpdate(profileId: attendeeId, externalUserId: externalUserId, data: 1)]
        let attendees2 = [AttendeeUpdate(profileId: attendeeId, externalUserId: externalUserId, data: 3)]
        defaultAudioClientObserver.attendeesPresenceChanged(attendees as [Any])
        defaultAudioClientObserver.attendeesPresenceChanged(attendees2 as [Any])
        let expect = eventually {
            verify(mockRealTimeObserver.attendeesDidJoin(attendeeInfo: any())).wasCalled()
            verify(mockRealTimeObserver.attendeesDidDrop(attendeeInfo: any())).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }
}

// MARK: - Transcript Event Tests
extension DefaultAudioClientObserverTests{
    func testTranscriptEventsReceived_receivedTranscriptionStatus() {
        let statusStarted = TranscriptionStatusInternal(type: TranscriptionStatusTypeInternal.started,
                                                        eventTimeMs: timestampMs,
                                                        transcriptionRegion: transcriptionRegion,
                                                        transcriptionConfiguration: transcriptionConfiguration,
                                                        message: "")
        let statusFailed = TranscriptionStatusInternal(type: TranscriptionStatusTypeInternal.failed,
                                                       eventTimeMs: timestampMs,
                                                       transcriptionRegion: transcriptionRegion,
                                                       transcriptionConfiguration: transcriptionConfiguration,
                                                       message: failedMessage)
        let events = [statusStarted, statusFailed]
        defaultAudioClientObserver.transcriptEventsReceived(events as [Any])
        let expect = eventually {
            verify(transcriptEventObserverMock.transcriptEventDidReceive(transcriptEvent: any())).wasCalled(2)
        }

        wait(for: [expect], timeout: defaultTimeout)
    }
    
    func testTranscriptEventsReceived_receivedTranscript() {
        let item = TranscriptItemInternal(type: TranscriptItemTypeInternal.pronunciation,
                                          startTimeMs: timestampMs,
                                          endTimeMs: timestampMs,
                                          attendee: AttendeeInfoInternal(attendeeId: "attendee-id",
                                                                         externalUserId: "external-user-id"),
                                          content: "test",
                                          vocabularyFilterMatch: true,
                                          stable: false,
                                          confidence: 0.0)!
        let alternative = TranscriptAlternativeInternal(items: [item], entities: [], transcript: "test")!
        let result = TranscriptResultInternal(resultId: "result-id",
                                              channelId: "",
                                              isPartial: true,
                                              startTimeMs: timestampMs,
                                              endTimeMs: timestampMs,
                                              alternatives: [alternative],
                                              languageCode: "en-US",
                                              languageIdentification: [])!
        let transcript = TranscriptInternal(results: [result])
        let events = [transcript]
        defaultAudioClientObserver.transcriptEventsReceived(events as [Any])
        let expect = eventually {
            verify(transcriptEventObserverMock.transcriptEventDidReceive(transcriptEvent: any())).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }

    func testTranscriptEventsReceived_receivedTranscriptWithNilEntities() {
        let item = TranscriptItemInternal(type: TranscriptItemTypeInternal.pronunciation,
                                          startTimeMs: timestampMs,
                                          endTimeMs: timestampMs,
                                          attendee: AttendeeInfoInternal(attendeeId: "attendee-id",
                                                                         externalUserId: "external-user-id"),
                                          content: "test",
                                          vocabularyFilterMatch: true,
                                          stable: false,
                                          confidence: 0.0)!
        let alternative = TranscriptAlternativeInternal(items: [item], entities: nil, transcript: "test") ?? TranscriptAlternativeInternal()
        let result = TranscriptResultInternal(resultId: "result-id",
                                              channelId: "",
                                              isPartial: true,
                                              startTimeMs: timestampMs,
                                              endTimeMs: timestampMs,
                                              alternatives: [alternative],
                                              languageCode: "en-US",
                                              languageIdentification: [])!
        let transcript = TranscriptInternal(results: [result])
        let events = [transcript]
        defaultAudioClientObserver.transcriptEventsReceived(events as [Any])
        let expect = eventually {
            verify(transcriptEventObserverMock.transcriptEventDidReceive(transcriptEvent: any())).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }

    func testTranscriptEventsReceived_receivedTranscriptWithNilLanguageIdentification() {
        let item = TranscriptItemInternal(type: TranscriptItemTypeInternal.pronunciation,
                                          startTimeMs: timestampMs,
                                          endTimeMs: timestampMs,
                                          attendee: AttendeeInfoInternal(attendeeId: "attendee-id",
                                                                         externalUserId: "external-user-id"),
                                          content: "test",
                                          vocabularyFilterMatch: true,
                                          stable: false,
                                          confidence: 0.0)!
        let alternative = TranscriptAlternativeInternal(items: [item], entities: [], transcript: "test")!
        let result = TranscriptResultInternal(resultId: "result-id",
                                              channelId: "",
                                              isPartial: true,
                                              startTimeMs: timestampMs,
                                              endTimeMs: timestampMs,
                                              alternatives: [alternative],
                                              languageCode: "en-US",
                                              languageIdentification: nil) ?? TranscriptResultInternal()
        let transcript = TranscriptInternal(results: [result])
        let events = [transcript]
        defaultAudioClientObserver.transcriptEventsReceived(events as [Any])
        let expect = eventually {
            verify(transcriptEventObserverMock.transcriptEventDidReceive(transcriptEvent: any())).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }
}
