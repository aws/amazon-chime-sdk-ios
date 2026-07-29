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
        XCTAssertEqual(audioLockMock.lockCallCount, 1)
        XCTAssertEqual(audioLockMock.unlockCallCount, 1)

        let events = publishedEvents(.audioInputFailed)
        XCTAssertEqual(events.count, 1)
        let error = events.first?.attributes?[EventAttributeName.audioInputError] as? PermissionError
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

        XCTAssertEqual(audioLockMock.lockCallCount, 1)
        XCTAssertEqual(audioLockMock.unlockCallCount, 1)
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
        XCTAssertEqual(audioLockMock.lockCallCount, 1)
        XCTAssertEqual(audioLockMock.unlockCallCount, 1)
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
        XCTAssertEqual(audioLockMock.lockCallCount, 1)
        XCTAssertEqual(audioLockMock.unlockCallCount, 1)
    }

    func testStop_stoppedOk() {
        DefaultAudioClientController.state = .started
        audioClientMock.stopSessionReturn = Int(AUDIO_CLIENT_OK.rawValue)

        defaultAudioClientController.stop()

        let expect = expectation(description: "eventually")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.audioLockMock.lockCallCount, 1)
            XCTAssertEqual(self.audioLockMock.unlockCallCount, 1)
            XCTAssertEqual(self.publishedEvents(.meetingEnded).count, 1)
            XCTAssertEqual(self.meetingStatsCollectorMock.resetMeetingStatsCallCount, 1)
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
        let matching = audioClientMock.startSessionCalls.filter {
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
        XCTAssertEqual(matching.count, 1, file: file, line: line)
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
        XCTAssertEqual(audioLockMock.lockCallCount, 1)
        XCTAssertEqual(audioClientObserverMock.notifyAudioClientObserverCallCount, 1)
        assertStartSession(audioMode: .Stereo48K, audioDeviceCapabilities: .InputAndOutput)
        XCTAssertEqual(publishedEvents(.meetingStartRequested).count, 1)
        XCTAssertEqual(.started, DefaultAudioClientController.state)
        XCTAssertEqual(audioLockMock.unlockCallCount, 1)
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
        XCTAssertEqual(audioLockMock.lockCallCount, 1)
        XCTAssertEqual(audioClientObserverMock.notifyAudioClientObserverCallCount, 1)
        assertStartSession(audioMode: .Mono48K, audioDeviceCapabilities: .InputAndOutput)
        XCTAssertEqual(publishedEvents(.meetingStartRequested).count, 1)
        XCTAssertEqual(.started, DefaultAudioClientController.state)
        XCTAssertEqual(audioLockMock.unlockCallCount, 1)
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
        XCTAssertEqual(audioLockMock.lockCallCount, 1)
        XCTAssertEqual(audioClientObserverMock.notifyAudioClientObserverCallCount, 1)
        assertStartSession(audioMode: .Mono16K, audioDeviceCapabilities: .InputAndOutput)
        XCTAssertEqual(publishedEvents(.meetingStartRequested).count, 1)
        XCTAssertEqual(.started, DefaultAudioClientController.state)
        XCTAssertEqual(audioLockMock.unlockCallCount, 1)
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
            XCTAssertEqual(publishedEvents(.meetingStartRequested).count, count)
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
        XCTAssertEqual(audioLockMock.lockCallCount, 1)
        XCTAssertEqual(audioClientObserverMock.notifyAudioClientObserverCallCount, 1)
        assertStartSession(audioMode: .Stereo48K, audioDeviceCapabilities: .InputAndOutput)
        XCTAssertEqual(.initialized, DefaultAudioClientController.state)
        XCTAssertEqual(audioLockMock.unlockCallCount, 1)

        let failedEvents = publishedEvents(.meetingStartFailed)
            .filter { $0.attributes?[EventAttributeName.meetingStatus] != nil }
        XCTAssertEqual(failedEvents.count, 1)
    }

    func testSetVoiceFocusEnabled_success() {
        DefaultAudioClientController.state = .started
        audioClientMock.setBliteNSSelectedReturn = Int(AUDIO_CLIENT_OK.rawValue)

        XCTAssertTrue(defaultAudioClientController.setVoiceFocusEnabled(enabled: true))
        XCTAssertEqual(audioClientMock.setBliteNSSelectedCalls.filter { $0 == true }.count, 1)

        XCTAssertTrue(defaultAudioClientController.setVoiceFocusEnabled(enabled: false))
        XCTAssertEqual(audioClientMock.setBliteNSSelectedCalls.filter { $0 == false }.count, 1)

        let events = publishedEvents(.voiceFocusEnabled).filter {
            $0.notifyObservers == false
                && NSDictionary(dictionary: $0.attributes ?? [:]).isEqual(to: [:])
        }
        XCTAssertEqual(events.count, 1)
    }

    func testSetVoiceFocusEnabled_failure_audioClientNotStarted() {
        DefaultAudioClientController.state = .initialized

        XCTAssertFalse(defaultAudioClientController.setVoiceFocusEnabled(enabled: true))
        XCTAssertTrue(audioClientMock.setBliteNSSelectedCalls.isEmpty)

        XCTAssertFalse(defaultAudioClientController.setVoiceFocusEnabled(enabled: false))
        XCTAssertTrue(audioClientMock.setBliteNSSelectedCalls.isEmpty)

        let events = publishedEvents(.voiceFocusEnableFailed).filter { $0.notifyObservers == false }
        XCTAssertEqual(events.count, 1)
        let error = events.first?.attributes?[EventAttributeName.voiceFocusError] as? VoiceFocusError
        XCTAssertEqual(error, VoiceFocusError.audioClientNotStarted)
    }

    func testSetVoiceFocusEnabled_failure_mediaFailure() {
        DefaultAudioClientController.state = .started
        audioClientMock.setBliteNSSelectedReturn = Int(AUDIO_CLIENT_ERR.rawValue)

        XCTAssertFalse(defaultAudioClientController.setVoiceFocusEnabled(enabled: true))
        XCTAssertEqual(audioClientMock.setBliteNSSelectedCalls.filter { $0 == true }.count, 1)

        XCTAssertFalse(defaultAudioClientController.setVoiceFocusEnabled(enabled: false))
        XCTAssertEqual(audioClientMock.setBliteNSSelectedCalls.filter { $0 == false }.count, 1)

        let events = publishedEvents(.voiceFocusEnableFailed).filter { $0.notifyObservers == false }
        XCTAssertEqual(events.count, 1)
        let error = events.first?.attributes?[EventAttributeName.voiceFocusError] as? VoiceFocusError
        XCTAssertEqual(error, VoiceFocusError.audioClientError)
    }

    func testIsVoiceFocusEnabled_success() {
        DefaultAudioClientController.state = .started

        audioClientMock.isBliteNSSelectedReturn = true
        XCTAssertTrue(defaultAudioClientController.isVoiceFocusEnabled())
        XCTAssertEqual(audioClientMock.isBliteNSSelectedCallCount, 1)

        audioClientMock.isBliteNSSelectedReturn = false
        XCTAssertFalse(defaultAudioClientController.isVoiceFocusEnabled())
        XCTAssertEqual(audioClientMock.isBliteNSSelectedCallCount, 2)
    }

    func testIsVoiceFocusEnabled_failure_audioClientNotStarted() {
        DefaultAudioClientController.state = .initialized

        XCTAssertFalse(defaultAudioClientController.isVoiceFocusEnabled())
        XCTAssertEqual(audioClientMock.isBliteNSSelectedCallCount, 0)
    }
}
