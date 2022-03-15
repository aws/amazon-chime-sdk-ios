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

        given(meetingStatsCollectorMock.getMeetingStats()).will { return [AnyHashable: Any]() }

        let mediaPlacementMock: MediaPlacementMock = mock(MediaPlacement.self)
            .initialize(audioFallbackUrl: audioFallbackUrl,
                        audioHostUrl: audioHostUrl,
                        signalingUrl: signalingUrl,
                        turnControlUrl: turnControlUrl,
                        eventIngestionUrl: nil)
        let meetingMock: MeetingMock = mock(Meeting.self).initialize(externalMeetingId: externalMeetingId,
                                                                     mediaPlacement: mediaPlacementMock,
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
    }

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
        given(audioClientMock.stopSession()).willReturn(0)
        DefaultAudioClientController.state = .started
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServerHungup.rawValue))
        let expect = eventually {
            verify(eventAnalyticsControllerMock.publishEvent(name: .meetingFailed, attributes: any())).wasCalled()
            verify(mockAudioVideoObserver.audioSessionDidStopWithStatus(sessionStatus: any())).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }

    func testAudioClientStateChanged_ConnectionFailedFromConnected() {
        given(audioClientMock.stopSession()).willReturn(0)
        DefaultAudioClientController.state = .started
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_CONNECTED,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServerHungup.rawValue))
        let expect = eventually {
            verify(mockAudioVideoObserver.audioSessionDidStopWithStatus(sessionStatus: any())).wasCalled()
            verify(eventAnalyticsControllerMock.publishEvent(name: .meetingFailed, attributes: any())).wasCalled()
            verify(meetingStatsCollectorMock.resetMeetingStats()).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }

    func testAudioClientStateChanged_ConnectionCancelledReconnect() {
        given(audioClientMock.stopSession()).willReturn(0)
        DefaultAudioClientController.state = .started
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_RECONNECTING,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.ok.rawValue))
        defaultAudioClientObserver.audioClientStateChanged(AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
                                                           status: audio_client_status_t.init(MeetingSessionStatusCode.audioServerHungup.rawValue))
        let expect = eventually {
            verify(mockAudioVideoObserver.audioSessionDidCancelReconnect()).wasCalled()
            verify(mockAudioVideoObserver.audioSessionDidStopWithStatus(sessionStatus: any())).wasCalled()
            verify(eventAnalyticsControllerMock.publishEvent(name: .meetingFailed, attributes: any())).wasCalled()
            verify(meetingStatsCollectorMock.resetMeetingStats()).wasCalled()
        }

        wait(for: [expect], timeout: defaultTimeout)
    }

    func testAudioMetricChanged_processAudioClientMetrics() {
        var metrics = [AnyHashable: Any]()
        metrics[ObservableMetric.audioSendPacketLossPercent] = 50
        defaultAudioClientObserver.audioMetricsChanged(metrics)
        verify(clientMetricsCollectorMock.processAudioClientMetrics(metrics: any())).wasCalled()
    }

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
