//
//  DefaultAudioClientControllerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDKMedia
@testable import AmazonChimeSDK
import Mockingbird
import XCTest

class DefaultAudioClientControllerTests: CommonTestCase {
    let callKitEnabled = false
    private let reconnectTimeoutMs = 180 * 1000

    var audioClientMock: AudioClientProtocolMock!
    var audioClientObserverMock: AudioClientObserverMock!
    var audioSessionMock: AudioSessionMock!
    var audioLockMock: AudioLockMock!
    var activeSpeakerMock: ActiveSpeakerDetectorFacadeMock!

    var eventAnalyticsControllerMock: EventAnalyticsControllerMock!
    var meetingStatsCollectorMock: MeetingStatsCollectorMock!

    var defaultAudioClientController: DefaultAudioClientController!

    override func setUp() {
        super.setUp()

        audioClientMock = mock(AudioClientProtocol.self)
        audioClientObserverMock = mock(AudioClientObserver.self)
        audioSessionMock = mock(AudioSession.self)
        audioLockMock = mock(AudioLock.self)
        eventAnalyticsControllerMock = mock(EventAnalyticsController.self)
        meetingStatsCollectorMock = mock(MeetingStatsCollector.self)
        activeSpeakerMock = mock(ActiveSpeakerDetectorFacade.self)

        given(meetingStatsCollectorMock.getMeetingStats()).will { [AnyHashable: Any]() }

        given(audioSessionMock.getRecordPermission()).willReturn(.granted)
        given(audioClientMock.startSession(any(),
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
                                           reconnectTimeoutMs: any())).willReturn(AUDIO_CLIENT_OK)

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
        given(audioClientMock.setMicrophoneMuted(any(Bool.self))).willReturn(Int(AUDIO_CLIENT_OK.rawValue))

        XCTAssertTrue(defaultAudioClientController.setMute(mute: true))
    }

    func testStart_recordPermissionNotGranted() {
        let eventAttributeCaptor = ArgumentCaptor<[AnyHashable: Any]>()
        
        given(audioSessionMock.getRecordPermission()).willReturn(.denied)

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
        verify(audioLockMock.lock()).wasCalled()
        verify(audioLockMock.unlock()).wasCalled()
        
        
        verify(eventAnalyticsControllerMock.publishEvent(name: .audioInputFailed, attributes: eventAttributeCaptor.any())).wasCalled()
        
        let error = eventAttributeCaptor.value?[EventAttributeName.audioInputError] as? PermissionError
        XCTAssertEqual(error, PermissionError.audioPermissionError)
    }
    
    func testStart_emptyAudioHostUrl() {
        DefaultAudioClientController.state = .stopped
        given(audioSessionMock.getRecordPermission()).willReturn(.granted)

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
        
        verify(audioLockMock.lock()).wasCalled()
        verify(audioLockMock.unlock()).wasCalled()
    }
    
    func testStart_emptyAudioFallbackUrl() {
        DefaultAudioClientController.state = .stopped
        given(audioSessionMock.getRecordPermission()).willReturn(.granted)

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
        verify(audioLockMock.lock()).wasCalled()
        verify(audioLockMock.unlock()).wasCalled()
    }

    func testStart_alreadyStarted() {
        DefaultAudioClientController.state = .started
        given(audioSessionMock.getRecordPermission()).willReturn(.granted)

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
        verify(audioLockMock.lock()).wasCalled()
        verify(audioLockMock.unlock()).wasCalled()
    }

    func testStop_stoppedOk() {
        DefaultAudioClientController.state = .started
        given(audioClientMock.stopSession()).willReturn(Int(AUDIO_CLIENT_OK.rawValue))

        defaultAudioClientController.stop()

        let expect = eventually {
            verify(audioLockMock.lock()).wasCalled()
            verify(audioLockMock.unlock()).wasCalled()
            verify(eventAnalyticsControllerMock.publishEvent(name: .meetingEnded, attributes: any())).wasCalled()
            verify(meetingStatsCollectorMock.resetMeetingStats()).wasCalled()
        }

        wait(for: [expect], timeout: 1.0)
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
        verify(audioLockMock.lock()).wasCalled()
        verify(audioClientObserverMock.notifyAudioClientObserver(observerFunction: any())).wasCalled()
        verify(audioClientMock.startSession(self.audioHostUrl,
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
                                            audioMode: .Stereo48K,
                                            audioDeviceCapabilities: .InputAndOutput,
                                            enableAudioRedundancy: true,
                                            reconnectTimeoutMs: self.reconnectTimeoutMs)).wasCalled()
        verify(eventAnalyticsControllerMock.publishEvent(name: .meetingStartRequested)).wasCalled()
        XCTAssertEqual(.started, DefaultAudioClientController.state)
        verify(audioLockMock.unlock()).wasCalled()
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
        verify(audioLockMock.lock()).wasCalled()
        verify(audioClientObserverMock.notifyAudioClientObserver(observerFunction: any())).wasCalled()
        verify(audioClientMock.startSession(self.audioHostUrl,
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
                                            audioMode: .Mono48K,
                                            audioDeviceCapabilities: .InputAndOutput,
                                            enableAudioRedundancy: true,
                                            reconnectTimeoutMs: self.reconnectTimeoutMs)).wasCalled()
        verify(eventAnalyticsControllerMock.publishEvent(name: .meetingStartRequested)).wasCalled()
        XCTAssertEqual(.started, DefaultAudioClientController.state)
        verify(audioLockMock.unlock()).wasCalled()
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
        verify(audioLockMock.lock()).wasCalled()
        verify(audioClientObserverMock.notifyAudioClientObserver(observerFunction: any())).wasCalled()
        verify(audioClientMock.startSession(self.audioHostUrl,
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
                                            audioMode: .Mono16K,
                                            audioDeviceCapabilities: .InputAndOutput,
                                            enableAudioRedundancy: true,
                                            reconnectTimeoutMs: self.reconnectTimeoutMs)).wasCalled()
        verify(eventAnalyticsControllerMock.publishEvent(name: .meetingStartRequested)).wasCalled()
        XCTAssertEqual(.started, DefaultAudioClientController.state)
        verify(audioLockMock.unlock()).wasCalled()
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
            verify(audioLockMock.lock()).wasCalled(count)
            verify(audioClientObserverMock.notifyAudioClientObserver(observerFunction: any())).wasCalled(count)
            var capabilitiesInternal: AudioDeviceCapabilitiesInternal = .InputAndOutput
            if (capabilities == .none) {
                capabilitiesInternal = .None
            } else if (capabilities == .outputOnly) {
                capabilitiesInternal = .OutputOnly
            }
            verify(audioClientMock.startSession(self.audioHostUrl,
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
                                                audioMode: .Stereo48K,
                                                audioDeviceCapabilities: capabilitiesInternal,
                                                enableAudioRedundancy: true,
                                                reconnectTimeoutMs: self.reconnectTimeoutMs)).wasCalled()
            verify(eventAnalyticsControllerMock.publishEvent(name: .meetingStartRequested)).wasCalled(count)
            XCTAssertEqual(.started, DefaultAudioClientController.state)
            verify(audioLockMock.unlock()).wasCalled(count)
        }
    }

    func testStart_failedToStart() {
        DefaultAudioClientController.state = .initialized
        given(audioClientMock.startSession(any(),
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
                                           reconnectTimeoutMs: any())).willReturn(AUDIO_CLIENT_ERR)
        given(audioClientObserverMock.audioStatus).willReturn(.ok)
        

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
        verify(audioLockMock.lock()).wasCalled()
        verify(audioClientObserverMock.notifyAudioClientObserver(observerFunction: any())).wasCalled()
        verify(audioClientMock.startSession(self.audioHostUrl,
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
                                            audioMode: .Stereo48K,
                                            audioDeviceCapabilities: .InputAndOutput,
                                            enableAudioRedundancy: true,
                                            reconnectTimeoutMs: self.reconnectTimeoutMs)).wasCalled()
        XCTAssertEqual(.initialized, DefaultAudioClientController.state)
        verify(audioLockMock.unlock()).wasCalled()
        verify(eventAnalyticsControllerMock.publishEvent(name: .meetingStartFailed, attributes: [EventAttributeName.meetingStatus: any()])).wasCalled()
    }

    func testSetVoiceFocusEnabled_success() {
        DefaultAudioClientController.state = .started

        given(audioClientMock.setBliteNSSelected(any())).willReturn(Int(AUDIO_CLIENT_OK.rawValue))

        XCTAssertTrue(defaultAudioClientController.setVoiceFocusEnabled(enabled: true))
        verify(audioClientMock.setBliteNSSelected(true)).wasCalled()

        XCTAssertTrue(defaultAudioClientController.setVoiceFocusEnabled(enabled: false))
        verify(audioClientMock.setBliteNSSelected(false)).wasCalled()
    }

    func testSetVoiceFocusEnabled_failure_audioClientNotStarted() {
        DefaultAudioClientController.state = .initialized

        XCTAssertFalse(defaultAudioClientController.setVoiceFocusEnabled(enabled: true))
        verify(audioClientMock.setBliteNSSelected(any())).wasNeverCalled()

        XCTAssertFalse(defaultAudioClientController.setVoiceFocusEnabled(enabled: false))
        verify(audioClientMock.setBliteNSSelected(any())).wasNeverCalled()
    }

    func testSetVoiceFocusEnabled_failure_mediaFailure() {
        DefaultAudioClientController.state = .started

        given(audioClientMock.setBliteNSSelected(any())).willReturn(Int(AUDIO_CLIENT_ERR.rawValue))

        XCTAssertFalse(defaultAudioClientController.setVoiceFocusEnabled(enabled: true))
        verify(audioClientMock.setBliteNSSelected(true)).wasCalled()

        XCTAssertFalse(defaultAudioClientController.setVoiceFocusEnabled(enabled: false))
        verify(audioClientMock.setBliteNSSelected(false)).wasCalled()
    }

    func testIsVoiceFocusEnabled_success() {
        DefaultAudioClientController.state = .started

        given(audioClientMock.isBliteNSSelected()).willReturn(true)
        XCTAssertTrue(defaultAudioClientController.isVoiceFocusEnabled())
        verify(audioClientMock.isBliteNSSelected()).wasCalled()

        given(audioClientMock.isBliteNSSelected()).willReturn(false)
        XCTAssertFalse(defaultAudioClientController.isVoiceFocusEnabled())
        verify(audioClientMock.isBliteNSSelected()).wasCalled(2)
    }

    func testIsVoiceFocusEnabled_failure_audioClientNotStarted() {
        DefaultAudioClientController.state = .initialized

        XCTAssertFalse(defaultAudioClientController.isVoiceFocusEnabled())
        verify(audioClientMock.isBliteNSSelected()).wasNeverCalled()
    }
}
