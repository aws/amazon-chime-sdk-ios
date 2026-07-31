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
import XCTest

// swiftlint:disable:next type_body_length
class DefaultAudioClientControllerTests: CommonTestCase {
    let callKitEnabled = false
    private let reconnectTimeoutMs = 180 * 1000

    var audioClientMock: AudioClientProtocolSpy!
    var audioClientObserverMock: AudioClientObserverSpy!
    var audioSessionMock: AudioSessionSpy!
    var audioLockMock: AudioLockSpy!
    var activeSpeakerMock: ActiveSpeakerDetectorFacadeSpy!

    var eventAnalyticsControllerMock: EventAnalyticsControllerSpy!
    var meetingStatsCollectorMock: MeetingStatsCollectorSpy!

    var defaultAudioClientController: DefaultAudioClientController!

    /// Calls to `publishEvent` recorded for the given event name.
    private func publishedEvents(_ name: EventName) -> [EventAnalyticsControllerSpy.PublishEventCall] {
        return eventAnalyticsControllerMock.publishEventCalls.filter { $0.name == name }
    }

    override func setUp() {
        super.setUp()

        audioClientMock = AudioClientProtocolSpy()
        audioClientObserverMock = AudioClientObserverSpy()
        audioSessionMock = AudioSessionSpy()
        audioLockMock = AudioLockSpy()
        eventAnalyticsControllerMock = EventAnalyticsControllerSpy()
        meetingStatsCollectorMock = MeetingStatsCollectorSpy()
        activeSpeakerMock = ActiveSpeakerDetectorFacadeSpy()

        meetingStatsCollectorMock.getMeetingStatsReturn = [AnyHashable: Any]()
        audioSessionMock.recordPermissionReturn = AVAudioSession.RecordPermission.granted
        audioClientMock.startSessionReturn = AUDIO_CLIENT_OK

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
        audioClientMock.setMicrophoneMutedReturn = Int(AUDIO_CLIENT_OK.rawValue)

        XCTAssertTrue(defaultAudioClientController.setMute(mute: true))
    }

    func testStart_recordPermissionNotGranted() {
        audioSessionMock.recordPermissionReturn = AVAudioSession.RecordPermission.denied

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
        verify(audioLockMock.lockCallCount)
        verify(audioLockMock.unlockCallCount)

        let event = verify(publishedEvents(.audioInputFailed))
        let error = event?.attributes?[EventAttributeName.audioInputError] as? PermissionError
        XCTAssertEqual(error, PermissionError.audioPermissionError)
    }

    func testStart_emptyAudioHostUrl() {
        DefaultAudioClientController.state = .stopped
        audioSessionMock.recordPermissionReturn = AVAudioSession.RecordPermission.granted

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

        verify(audioLockMock.lockCallCount)
        verify(audioLockMock.unlockCallCount)
    }

    func testStart_emptyAudioFallbackUrl() {
        DefaultAudioClientController.state = .stopped
        audioSessionMock.recordPermissionReturn = AVAudioSession.RecordPermission.granted

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
        verify(audioLockMock.lockCallCount)
        verify(audioLockMock.unlockCallCount)
    }

    func testStart_alreadyStarted() {
        DefaultAudioClientController.state = .started
        audioSessionMock.recordPermissionReturn = AVAudioSession.RecordPermission.granted

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
        verify(audioLockMock.lockCallCount)
        verify(audioLockMock.unlockCallCount)
    }

    func testStop_stoppedOk() {
        DefaultAudioClientController.state = .started
        audioClientMock.stopSessionReturn = Int(AUDIO_CLIENT_OK.rawValue)

        defaultAudioClientController.stop()

        let expect = expectation(description: "eventually")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            verify(self.audioLockMock.lockCallCount)
            verify(self.audioLockMock.unlockCallCount)
            verify(self.publishedEvents(.meetingEnded))
            verify(self.meetingStatsCollectorMock.resetMeetingStatsCallCount)
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
    }

    /// Asserts a single recorded `startSession` call matching the expected argument values.
    /// `appInfo` was matched with `any()` and is therefore not asserted.
    private func assertStartSession(audioMode: AudioModeInternal,
                                   audioDeviceCapabilities: AudioDeviceCapabilitiesInternal,
                                   file: StaticString = #filePath,
                                   line: UInt = #line) {
        verify(audioClientMock.startSessionCalls, file: file, line: line) {
            $0.host == audioHostUrl
                && $0.port == 1820
                && $0.callId == meetingId
                && $0.profileId == attendeeId
                && $0.microphoneMute == false
                && $0.speakerMute == false
                && $0.isPresenter == true
                && $0.sessionToken == joinToken
                && $0.audioWsUrl == audioFallbackUrl
                && $0.callKitEnabled == false
                && $0.audioMode == audioMode
                && $0.audioDeviceCapabilities == audioDeviceCapabilities
                && $0.enableAudioRedundancy == true
                && $0.reconnectTimeoutMs == reconnectTimeoutMs
        }
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
        verify(audioLockMock.lockCallCount)
        verify(audioClientObserverMock.notifyAudioClientObserverCallCount)
        assertStartSession(audioMode: .Stereo48K, audioDeviceCapabilities: .InputAndOutput)
        verify(publishedEvents(.meetingStartRequested))
        XCTAssertEqual(.started, DefaultAudioClientController.state)
        verify(audioLockMock.unlockCallCount)
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
        verify(audioLockMock.lockCallCount)
        verify(audioClientObserverMock.notifyAudioClientObserverCallCount)
        assertStartSession(audioMode: .Mono48K, audioDeviceCapabilities: .InputAndOutput)
        verify(publishedEvents(.meetingStartRequested))
        XCTAssertEqual(.started, DefaultAudioClientController.state)
        verify(audioLockMock.unlockCallCount)
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
        verify(audioLockMock.lockCallCount)
        verify(audioClientObserverMock.notifyAudioClientObserverCallCount)
        assertStartSession(audioMode: .Mono16K, audioDeviceCapabilities: .InputAndOutput)
        verify(publishedEvents(.meetingStartRequested))
        XCTAssertEqual(.started, DefaultAudioClientController.state)
        verify(audioLockMock.unlockCallCount)
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
            XCTAssertEqual(audioLockMock.lockCallCount, count)
            XCTAssertEqual(audioClientObserverMock.notifyAudioClientObserverCallCount, count)
            var capabilitiesInternal: AudioDeviceCapabilitiesInternal = .InputAndOutput
            if capabilities == .none {
                capabilitiesInternal = .None
            } else if capabilities == .outputOnly {
                capabilitiesInternal = .OutputOnly
            }
            assertStartSession(audioMode: .Stereo48K, audioDeviceCapabilities: capabilitiesInternal)
            verify(publishedEvents(.meetingStartRequested), times(count))
            XCTAssertEqual(.started, DefaultAudioClientController.state)
            XCTAssertEqual(audioLockMock.unlockCallCount, count)
        }
    }

    func testStart_failedToStart() {
        DefaultAudioClientController.state = .initialized
        audioClientMock.startSessionReturn = AUDIO_CLIENT_ERR
        audioClientObserverMock.audioStatusReturn = .ok

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
        verify(audioLockMock.lockCallCount)
        verify(audioClientObserverMock.notifyAudioClientObserverCallCount)
        assertStartSession(audioMode: .Stereo48K, audioDeviceCapabilities: .InputAndOutput)
        XCTAssertEqual(.initialized, DefaultAudioClientController.state)
        verify(audioLockMock.unlockCallCount)

        verify(publishedEvents(.meetingStartFailed)) { $0.attributes?[EventAttributeName.meetingStatus] != nil }
    }

    func testSetVoiceFocusEnabled_success() {
        DefaultAudioClientController.state = .started
        audioClientMock.setBliteNSSelectedReturn = Int(AUDIO_CLIENT_OK.rawValue)

        XCTAssertTrue(defaultAudioClientController.setVoiceFocusEnabled(enabled: true))
        verifyEqual(audioClientMock.setBliteNSSelectedCalls, to: true)

        XCTAssertTrue(defaultAudioClientController.setVoiceFocusEnabled(enabled: false))
        verifyEqual(audioClientMock.setBliteNSSelectedCalls, to: false)

        verify(publishedEvents(.voiceFocusEnabled)) {
            $0.notifyObservers == false
                && NSDictionary(dictionary: $0.attributes ?? [:]).isEqual(to: [:])
        }
    }

    func testSetVoiceFocusEnabled_failure_audioClientNotStarted() {
        DefaultAudioClientController.state = .initialized

        XCTAssertFalse(defaultAudioClientController.setVoiceFocusEnabled(enabled: true))
        XCTAssertTrue(audioClientMock.setBliteNSSelectedCalls.isEmpty)

        XCTAssertFalse(defaultAudioClientController.setVoiceFocusEnabled(enabled: false))
        XCTAssertTrue(audioClientMock.setBliteNSSelectedCalls.isEmpty)

        let event = verify(publishedEvents(.voiceFocusEnableFailed)) { $0.notifyObservers == false }
        let error = event?.attributes?[EventAttributeName.voiceFocusError] as? VoiceFocusError
        XCTAssertEqual(error, VoiceFocusError.audioClientNotStarted)
    }

    func testSetVoiceFocusEnabled_failure_mediaFailure() {
        DefaultAudioClientController.state = .started
        audioClientMock.setBliteNSSelectedReturn = Int(AUDIO_CLIENT_ERR.rawValue)

        XCTAssertFalse(defaultAudioClientController.setVoiceFocusEnabled(enabled: true))
        verifyEqual(audioClientMock.setBliteNSSelectedCalls, to: true)

        XCTAssertFalse(defaultAudioClientController.setVoiceFocusEnabled(enabled: false))
        verifyEqual(audioClientMock.setBliteNSSelectedCalls, to: false)

        let event = verify(publishedEvents(.voiceFocusEnableFailed)) { $0.notifyObservers == false }
        let error = event?.attributes?[EventAttributeName.voiceFocusError] as? VoiceFocusError
        XCTAssertEqual(error, VoiceFocusError.audioClientError)
    }

    func testIsVoiceFocusEnabled_success() {
        DefaultAudioClientController.state = .started

        audioClientMock.isBliteNSSelectedReturn = true
        XCTAssertTrue(defaultAudioClientController.isVoiceFocusEnabled())
        verify(audioClientMock.isBliteNSSelectedCallCount)

        audioClientMock.isBliteNSSelectedReturn = false
        XCTAssertFalse(defaultAudioClientController.isVoiceFocusEnabled())
        verify(audioClientMock.isBliteNSSelectedCallCount, times(2))
    }

    func testIsVoiceFocusEnabled_failure_audioClientNotStarted() {
        DefaultAudioClientController.state = .initialized

        XCTAssertFalse(defaultAudioClientController.isVoiceFocusEnabled())
        verify(audioClientMock.isBliteNSSelectedCallCount, never())
    }
}
