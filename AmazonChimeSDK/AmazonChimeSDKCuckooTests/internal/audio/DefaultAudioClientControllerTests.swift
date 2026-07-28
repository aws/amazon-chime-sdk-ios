//
//  DefaultAudioClientControllerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDKMedia
@testable import AmazonChimeSDK
import AVFoundation
import Cuckoo
import XCTest

// swiftlint:disable:next type_body_length
class DefaultAudioClientControllerTests: CommonTestCase {
    let callKitEnabled = false
    private let reconnectTimeoutMs = 180 * 1000

    var audioClientMock: MockAudioClientProtocol!
    var audioClientObserverMock: MockAudioClientObserver!
    var audioSessionMock: MockAudioSession!
    var audioLockMock: MockAudioLock!
    var activeSpeakerMock: MockActiveSpeakerDetectorFacade!

    var eventAnalyticsControllerMock: MockEventAnalyticsController!
    var meetingStatsCollectorMock: MockMeetingStatsCollector!

    var defaultAudioClientController: DefaultAudioClientController!

    override func setUp() {
        super.setUp()

        audioClientMock = MockAudioClientProtocol().withEnabledDefaultImplementation(AudioClientProtocolStub())
        audioClientObserverMock = MockAudioClientObserver().withEnabledDefaultImplementation(AudioClientObserverStub())
        audioSessionMock = MockAudioSession().withEnabledDefaultImplementation(AudioSessionStub())
        audioLockMock = MockAudioLock().withEnabledDefaultImplementation(AudioLockStub())
        eventAnalyticsControllerMock = MockEventAnalyticsController().withEnabledDefaultImplementation(EventAnalyticsControllerStub())
        meetingStatsCollectorMock = MockMeetingStatsCollector().withEnabledDefaultImplementation(MeetingStatsCollectorStub())
        activeSpeakerMock = MockActiveSpeakerDetectorFacade().withEnabledDefaultImplementation(ActiveSpeakerDetectorFacadeStub())

        stub(meetingStatsCollectorMock) { stub in
            when(stub.getMeetingStats()).then { [AnyHashable: Any]() }
        }

        stub(audioSessionMock) { stub in
            when(stub.recordPermission.get).thenReturn(AVAudioSession.RecordPermission.granted)
        }
        stub(audioClientMock) { stub in
            when(stub.startSession(any(),
                                   basePort: any(),
                                   callId: any(),
                                   profileId: any(),
                                   microphoneMute: any(),
                                   speakerMute: any(),
                                   isPresenter: any(),
                                   sessionToken: any(),
                                   audioWsUrl: any(),
                                   callKitEnabled: any(),
                                   appInfo: any(),
                                   audioMode: any(),
                                   audioDeviceCapabilities: any(),
                                   enableAudioRedundancy: any(),
                                   reconnectTimeoutMs: any())).thenReturn(AUDIO_CLIENT_OK)
        }

        defaultAudioClientController = DefaultAudioClientController(audioClient: audioClientMock,
                                                                    audioClientObserver: audioClientObserverMock,
                                                                    audioSession: audioSessionMock,
                                                                    audioClientLock: audioLockMock,
                                                                    eventAnalyticsController: eventAnalyticsControllerMock,
                                                                    meetingStatsCollector: meetingStatsCollectorMock,
                                                                    activeSpeakerDetector: activeSpeakerMock,
                                                                    logger: loggerMock)
    }

    func testSetMute_stateInitialized() {
        DefaultAudioClientController.state = AudioClientState.initialized

        XCTAssertFalse(defaultAudioClientController.setMute(mute: true))
    }

    func testSetMute_stateStarted() {
        DefaultAudioClientController.state = AudioClientState.started
        stub(audioClientMock) { stub in
            when(stub.setMicrophoneMuted(any(Bool.self))).thenReturn(Int(AUDIO_CLIENT_OK.rawValue))
        }

        XCTAssertTrue(defaultAudioClientController.setMute(mute: true))
    }

    func testStart_recordPermissionNotGranted() {
        let eventAttributeCaptor = ArgumentCaptor<[AnyHashable: Any]>()
        
        stub(audioSessionMock) { stub in
            when(stub.recordPermission.get).thenReturn(AVAudioSession.RecordPermission.denied)
        }

        XCTAssertThrowsError(try defaultAudioClientController.start(audioFallbackUrl: audioFallbackUrl,
                                                                    audioHostUrl: audioHostUrlWithPort,
                                                                    meetingId: meetingId,
                                                                    attendeeId: attendeeId,
                                                                    joinToken: joinToken,
                                                                    callKitEnabled: callKitEnabled,
                                                                    audioMode: .stereo48K,
                                                                    audioDeviceCapabilities: .inputAndOutput,
                                                                    enableAudioRedundancy: true,
                                                                    reconnectTimeoutMs: reconnectTimeoutMs))
        verify(audioLockMock).lock()
        verify(audioLockMock).unlock()
        
        
        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: EventName.audioInputFailed), attributes: eventAttributeCaptor.capture())
        
        let error = eventAttributeCaptor.value?[EventAttributeName.audioInputError] as? PermissionError
        XCTAssertEqual(error, PermissionError.audioPermissionError)
    }
    
    func testStart_emptyAudioHostUrl() {
        DefaultAudioClientController.state = .stopped
        stub(audioSessionMock) { stub in
            when(stub.recordPermission.get).thenReturn(AVAudioSession.RecordPermission.granted)
        }

        XCTAssertThrowsError(try defaultAudioClientController.start(audioFallbackUrl: audioFallbackUrl,
                                                                    audioHostUrl: "",
                                                                    meetingId: meetingId,
                                                                    attendeeId: attendeeId,
                                                                    joinToken: joinToken,
                                                                    callKitEnabled: callKitEnabled,
                                                                    audioMode: .stereo48K,
                                                                    audioDeviceCapabilities: .inputAndOutput,
                                                                    enableAudioRedundancy: true,
                                                                    reconnectTimeoutMs: reconnectTimeoutMs),
                             MediaError.audioFailedToStart.description)
        
        verify(audioLockMock).lock()
        verify(audioLockMock).unlock()
    }
    
    func testStart_emptyAudioFallbackUrl() {
        DefaultAudioClientController.state = .stopped
        stub(audioSessionMock) { stub in
            when(stub.recordPermission.get).thenReturn(AVAudioSession.RecordPermission.granted)
        }

        XCTAssertThrowsError(try defaultAudioClientController.start(audioFallbackUrl: "",
                                                                    audioHostUrl: audioHostUrlWithPort,
                                                                    meetingId: meetingId,
                                                                    attendeeId: attendeeId,
                                                                    joinToken: joinToken,
                                                                    callKitEnabled: callKitEnabled,
                                                                    audioMode: .stereo48K,
                                                                    audioDeviceCapabilities: .inputAndOutput,
                                                                    enableAudioRedundancy: true,
                                                                    reconnectTimeoutMs: reconnectTimeoutMs),
                             MediaError.audioFailedToStart.description)
        verify(audioLockMock).lock()
        verify(audioLockMock).unlock()
    }

    func testStart_alreadyStarted() {
        DefaultAudioClientController.state = .started
        stub(audioSessionMock) { stub in
            when(stub.recordPermission.get).thenReturn(AVAudioSession.RecordPermission.granted)
        }

        XCTAssertThrowsError(try defaultAudioClientController.start(audioFallbackUrl: audioFallbackUrl,
                                                                    audioHostUrl: audioHostUrlWithPort,
                                                                    meetingId: meetingId,
                                                                    attendeeId: attendeeId,
                                                                    joinToken: joinToken,
                                                                    callKitEnabled: callKitEnabled,
                                                                    audioMode: .stereo48K,
                                                                    audioDeviceCapabilities: .inputAndOutput,
                                                                    enableAudioRedundancy: true,
                                                                    reconnectTimeoutMs: reconnectTimeoutMs))
        verify(audioLockMock).lock()
        verify(audioLockMock).unlock()
    }

    func testStop_stoppedOk() {
        DefaultAudioClientController.state = .started
        stub(audioClientMock) { stub in
            when(stub.stopSession()).thenReturn(Int(AUDIO_CLIENT_OK.rawValue))
        }

        defaultAudioClientController.stop()

        let expect = expectation(description: "eventually")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            verify(self.audioLockMock).lock()
            verify(self.audioLockMock).unlock()
            verify(self.eventAnalyticsControllerMock).publishEvent(name: equal(to: EventName.meetingEnded), attributes: any())
            verify(self.meetingStatsCollectorMock).resetMeetingStats()
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
    }

    func testStart_startedOk() {
        DefaultAudioClientController.state = .initialized

        XCTAssertNoThrow(try defaultAudioClientController.start(audioFallbackUrl: audioFallbackUrl,
                                                                audioHostUrl: audioHostUrlWithPort,
                                                                meetingId: meetingId,
                                                                attendeeId: attendeeId,
                                                                joinToken: joinToken,
                                                                callKitEnabled: callKitEnabled,
                                                                audioMode: .stereo48K,
                                                                audioDeviceCapabilities: .inputAndOutput,
                                                                enableAudioRedundancy: true,
                                                                reconnectTimeoutMs: self.reconnectTimeoutMs))
        verify(audioLockMock).lock()
        verify(audioClientObserverMock).notifyAudioClientObserver(observerFunction: any())
        verify(audioClientMock).startSession(self.audioHostUrl,
                                             basePort: 1820,
                                             callId: self.meetingId,
                                             profileId: self.attendeeId,
                                             microphoneMute: false,
                                             speakerMute: false,
                                             isPresenter: true,
                                             sessionToken: self.joinToken,
                                             audioWsUrl: self.audioFallbackUrl,
                                             callKitEnabled: false,
                                             appInfo: any(),
                                             audioMode: equal(to: AudioModeInternal.Stereo48K),
                                             audioDeviceCapabilities: equal(to: AudioDeviceCapabilitiesInternal.InputAndOutput),
                                             enableAudioRedundancy: true,
                                             reconnectTimeoutMs: self.reconnectTimeoutMs)
        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: EventName.meetingStartRequested))
        XCTAssertEqual(.started, DefaultAudioClientController.state)
        verify(audioLockMock).unlock()
    }

    func testStartWithMono48K_startedOk() {
        DefaultAudioClientController.state = .initialized

        XCTAssertNoThrow(try defaultAudioClientController.start(audioFallbackUrl: audioFallbackUrl,
                                                                audioHostUrl: audioHostUrlWithPort,
                                                                meetingId: meetingId,
                                                                attendeeId: attendeeId,
                                                                joinToken: joinToken,
                                                                callKitEnabled: callKitEnabled,
                                                                audioMode: .mono48K,
                                                                audioDeviceCapabilities: .inputAndOutput,
                                                                enableAudioRedundancy: true,
                                                                reconnectTimeoutMs: reconnectTimeoutMs))
        verify(audioLockMock).lock()
        verify(audioClientObserverMock).notifyAudioClientObserver(observerFunction: any())
        verify(audioClientMock).startSession(self.audioHostUrl,
                                             basePort: 1820,
                                             callId: self.meetingId,
                                             profileId: self.attendeeId,
                                             microphoneMute: false,
                                             speakerMute: false,
                                             isPresenter: true,
                                             sessionToken: self.joinToken,
                                             audioWsUrl: self.audioFallbackUrl,
                                             callKitEnabled: false,
                                             appInfo: any(),
                                             audioMode: equal(to: AudioModeInternal.Mono48K),
                                             audioDeviceCapabilities: equal(to: AudioDeviceCapabilitiesInternal.InputAndOutput),
                                             enableAudioRedundancy: true,
                                             reconnectTimeoutMs: self.reconnectTimeoutMs)
        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: EventName.meetingStartRequested))
        XCTAssertEqual(.started, DefaultAudioClientController.state)
        verify(audioLockMock).unlock()
    }

    func testStartWithMono16K_startedOk() {
        DefaultAudioClientController.state = .initialized

        XCTAssertNoThrow(try defaultAudioClientController.start(audioFallbackUrl: audioFallbackUrl,
                                                                audioHostUrl: audioHostUrlWithPort,
                                                                meetingId: meetingId,
                                                                attendeeId: attendeeId,
                                                                joinToken: joinToken,
                                                                callKitEnabled: callKitEnabled,
                                                                audioMode: .mono16K,
                                                                audioDeviceCapabilities: .inputAndOutput,
                                                                enableAudioRedundancy: true,
                                                                reconnectTimeoutMs: self.reconnectTimeoutMs))
        verify(audioLockMock).lock()
        verify(audioClientObserverMock).notifyAudioClientObserver(observerFunction: any())
        verify(audioClientMock).startSession(self.audioHostUrl,
                                             basePort: 1820,
                                             callId: self.meetingId,
                                             profileId: self.attendeeId,
                                             microphoneMute: false,
                                             speakerMute: false,
                                             isPresenter: true,
                                             sessionToken: self.joinToken,
                                             audioWsUrl: self.audioFallbackUrl,
                                             callKitEnabled: false,
                                             appInfo: any(),
                                             audioMode: equal(to: AudioModeInternal.Mono16K),
                                             audioDeviceCapabilities: equal(to: AudioDeviceCapabilitiesInternal.InputAndOutput),
                                             enableAudioRedundancy: true,
                                             reconnectTimeoutMs: self.reconnectTimeoutMs)
        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: EventName.meetingStartRequested))
        XCTAssertEqual(.started, DefaultAudioClientController.state)
        verify(audioLockMock).unlock()
    }

    func testStartWithAudioDeviceCapabilities_startedOk() {
        var count = 0
        for capabilities in AudioDeviceCapabilities.allCases {
            count += 1
            DefaultAudioClientController.state = .initialized
            XCTAssertNoThrow(try defaultAudioClientController.start(audioFallbackUrl: audioFallbackUrl,
                                                                    audioHostUrl: audioHostUrlWithPort,
                                                                    meetingId: meetingId,
                                                                    attendeeId: attendeeId,
                                                                    joinToken: joinToken,
                                                                    callKitEnabled: callKitEnabled,
                                                                    audioMode: .stereo48K,
                                                                    audioDeviceCapabilities: capabilities,
                                                                    enableAudioRedundancy: true,
                                                                    reconnectTimeoutMs: self.reconnectTimeoutMs))
            verify(audioLockMock, times(count)).lock()
            verify(audioClientObserverMock, times(count)).notifyAudioClientObserver(observerFunction: any())
            var capabilitiesInternal: AudioDeviceCapabilitiesInternal = .InputAndOutput
            if (capabilities == .none) {
                capabilitiesInternal = .None
            } else if (capabilities == .outputOnly) {
                capabilitiesInternal = .OutputOnly
            }
            verify(audioClientMock).startSession(self.audioHostUrl,
                                                 basePort: 1820,
                                                 callId: self.meetingId,
                                                 profileId: self.attendeeId,
                                                 microphoneMute: false,
                                                 speakerMute: false,
                                                 isPresenter: true,
                                                 sessionToken: self.joinToken,
                                                 audioWsUrl: self.audioFallbackUrl,
                                                 callKitEnabled: false,
                                                 appInfo: any(),
                                                 audioMode: equal(to: AudioModeInternal.Stereo48K),
                                                 audioDeviceCapabilities: equal(to: capabilitiesInternal),
                                                 enableAudioRedundancy: true,
                                                 reconnectTimeoutMs: self.reconnectTimeoutMs)
            verify(eventAnalyticsControllerMock, times(count)).publishEvent(name: equal(to: EventName.meetingStartRequested))
            XCTAssertEqual(.started, DefaultAudioClientController.state)
            verify(audioLockMock, times(count)).unlock()
        }
    }

    func testStart_failedToStart() {
        DefaultAudioClientController.state = .initialized
        stub(audioClientMock) { stub in
            when(stub.startSession(any(),
                                   basePort: any(),
                                   callId: any(),
                                   profileId: any(),
                                   microphoneMute: any(),
                                   speakerMute: any(),
                                   isPresenter: any(),
                                   sessionToken: any(),
                                   audioWsUrl: any(),
                                   callKitEnabled: any(),
                                   appInfo: any(),
                                   audioMode: any(),
                                   audioDeviceCapabilities: any(),
                                   enableAudioRedundancy: any(),
                                   reconnectTimeoutMs: any())).thenReturn(AUDIO_CLIENT_ERR)
        }
        stub(audioClientObserverMock) { stub in
            when(stub.audioStatus.get).thenReturn(.ok)
        }
        

        XCTAssertThrowsError(try defaultAudioClientController.start(audioFallbackUrl: audioFallbackUrl,
                                                                    audioHostUrl: audioHostUrlWithPort,
                                                                    meetingId: meetingId,
                                                                    attendeeId: attendeeId,
                                                                    joinToken: joinToken,
                                                                    callKitEnabled: callKitEnabled,
                                                                    audioMode: .stereo48K,
                                                                    audioDeviceCapabilities: .inputAndOutput,
                                                                    enableAudioRedundancy: true,
                                                                    reconnectTimeoutMs: self.reconnectTimeoutMs))
        verify(audioLockMock).lock()
        verify(audioClientObserverMock).notifyAudioClientObserver(observerFunction: any())
        verify(audioClientMock).startSession(self.audioHostUrl,
                                             basePort: 1820,
                                             callId: self.meetingId,
                                             profileId: self.attendeeId,
                                             microphoneMute: false,
                                             speakerMute: false,
                                             isPresenter: true,
                                             sessionToken: self.joinToken,
                                             audioWsUrl: self.audioFallbackUrl,
                                             callKitEnabled: false,
                                             appInfo: any(),
                                             audioMode: equal(to: AudioModeInternal.Stereo48K),
                                             audioDeviceCapabilities: equal(to: AudioDeviceCapabilitiesInternal.InputAndOutput),
                                             enableAudioRedundancy: true,
                                             reconnectTimeoutMs: self.reconnectTimeoutMs)
        XCTAssertEqual(.initialized, DefaultAudioClientController.state)
        verify(audioLockMock).unlock()
        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: EventName.meetingStartFailed), attributes: ParameterMatcher { $0[EventAttributeName.meetingStatus] != nil })
    }

    func testSetVoiceFocusEnabled_success() {
        DefaultAudioClientController.state = .started

        stub(audioClientMock) { stub in
            when(stub.setBliteNSSelected(any())).thenReturn(Int(AUDIO_CLIENT_OK.rawValue))
        }

        XCTAssertTrue(defaultAudioClientController.setVoiceFocusEnabled(enabled: true))
        verify(audioClientMock).setBliteNSSelected(true)

        XCTAssertTrue(defaultAudioClientController.setVoiceFocusEnabled(enabled: false))
        verify(audioClientMock).setBliteNSSelected(false)
        
        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: EventName.voiceFocusEnabled),
                                                          attributes: equal(to: [:], equalWhen: { NSDictionary(dictionary: $0).isEqual(to: $1) }),
                                                          notifyObservers: false)
    }

    func testSetVoiceFocusEnabled_failure_audioClientNotStarted() {
        DefaultAudioClientController.state = .initialized

        XCTAssertFalse(defaultAudioClientController.setVoiceFocusEnabled(enabled: true))
        verify(audioClientMock, never()).setBliteNSSelected(any())

        XCTAssertFalse(defaultAudioClientController.setVoiceFocusEnabled(enabled: false))
        verify(audioClientMock, never()).setBliteNSSelected(any())
        
        let eventAttributeCaptor = ArgumentCaptor<[AnyHashable: Any]>()
        
        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: EventName.voiceFocusEnableFailed),
                                                          attributes: eventAttributeCaptor.capture(),
                                                          notifyObservers: false)
        
        let error = eventAttributeCaptor.value?[EventAttributeName.voiceFocusError] as? VoiceFocusError
        XCTAssertEqual(error, VoiceFocusError.audioClientNotStarted)
    }

    func testSetVoiceFocusEnabled_failure_mediaFailure() {
        DefaultAudioClientController.state = .started

        stub(audioClientMock) { stub in
            when(stub.setBliteNSSelected(any())).thenReturn(Int(AUDIO_CLIENT_ERR.rawValue))
        }

        XCTAssertFalse(defaultAudioClientController.setVoiceFocusEnabled(enabled: true))
        verify(audioClientMock).setBliteNSSelected(true)

        XCTAssertFalse(defaultAudioClientController.setVoiceFocusEnabled(enabled: false))
        verify(audioClientMock).setBliteNSSelected(false)
        
        let eventAttributeCaptor = ArgumentCaptor<[AnyHashable: Any]>()
        
        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: EventName.voiceFocusEnableFailed),
                                                          attributes: eventAttributeCaptor.capture(),
                                                          notifyObservers: false)
        
        let error = eventAttributeCaptor.value?[EventAttributeName.voiceFocusError] as? VoiceFocusError
        XCTAssertEqual(error, VoiceFocusError.audioClientError)
    }

    func testIsVoiceFocusEnabled_success() {
        DefaultAudioClientController.state = .started

        stub(audioClientMock) { stub in
            when(stub.isBliteNSSelected()).thenReturn(true)
        }
        XCTAssertTrue(defaultAudioClientController.isVoiceFocusEnabled())
        verify(audioClientMock).isBliteNSSelected()

        stub(audioClientMock) { stub in
            when(stub.isBliteNSSelected()).thenReturn(false)
        }
        XCTAssertFalse(defaultAudioClientController.isVoiceFocusEnabled())
        verify(audioClientMock, times(2)).isBliteNSSelected()
    }

    func testIsVoiceFocusEnabled_failure_audioClientNotStarted() {
        DefaultAudioClientController.state = .initialized

        XCTAssertFalse(defaultAudioClientController.isVoiceFocusEnabled())
        verify(audioClientMock, never()).isBliteNSSelected()
    }
}
