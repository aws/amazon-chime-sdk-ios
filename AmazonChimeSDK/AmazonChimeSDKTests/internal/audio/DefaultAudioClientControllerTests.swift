//
//  DefaultAudioClientControllerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import AmazonChimeSDKMedia
import Mockingbird
import XCTest

class DefaultAudioClientControllerTests: CommonTestCase {
    let callKitEnabled = false

    var audioClientMock: AudioClientProtocolMock!
    var audioClientObserverMock: AudioClientObserverMock!
    var audioSessionMock: AudioSessionMock!
    var audioLockMock: AudioLockMock!

    var defaultAudioClientController: DefaultAudioClientController!

    override func setUp() {
        super.setUp()

        audioClientMock = mock(AudioClientProtocol.self)
        audioClientObserverMock = mock(AudioClientObserver.self)
        audioSessionMock = mock(AudioSession.self)
        audioLockMock = mock(AudioLock.self)
        defaultAudioClientController = DefaultAudioClientController(audioClient: audioClientMock,
                                                                    audioClientObserver: audioClientObserverMock,
                                                                    audioSession: audioSessionMock,
                                                                    audioClientLock: audioLockMock)
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
        given(audioSessionMock.getRecordPermission()).willReturn(.denied)

        XCTAssertThrowsError(try defaultAudioClientController.start(audioFallbackUrl: audioFallbackUrl,
                                                                    audioHostUrl: audioHostUrlWithPort,
                                                                    meetingId: meetingId,
                                                                    attendeeId: attendeeId,
                                                                    joinToken: joinToken,
                                                                    callKitEnabled: callKitEnabled))
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
                                                                    callKitEnabled: callKitEnabled))
        verify(audioLockMock.lock()).wasCalled()
        verify(audioLockMock.unlock()).wasCalled()
    }

    func testStart_startedOk() {
        DefaultAudioClientController.state = .initialized
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
                                           callKitEnabled: any())).willReturn(AUDIO_CLIENT_OK)

        XCTAssertNoThrow(try defaultAudioClientController.start(audioFallbackUrl: audioFallbackUrl,
                                                                audioHostUrl: audioHostUrlWithPort,
                                                                meetingId: meetingId,
                                                                attendeeId: attendeeId,
                                                                joinToken: joinToken,
                                                                callKitEnabled: callKitEnabled))
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
                                            callKitEnabled: false)).wasCalled()
        XCTAssertEqual(.started, DefaultAudioClientController.state)
        verify(audioLockMock.unlock()).wasCalled()
    }

    func testStart_failedToStart() {
        DefaultAudioClientController.state = .initialized
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
                                           callKitEnabled: any())).willReturn(AUDIO_CLIENT_ERR)

        XCTAssertThrowsError(try defaultAudioClientController.start(audioFallbackUrl: audioFallbackUrl,
                                                                    audioHostUrl: audioHostUrlWithPort,
                                                                    meetingId: meetingId,
                                                                    attendeeId: attendeeId,
                                                                    joinToken: joinToken,
                                                                    callKitEnabled: callKitEnabled))
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
                                            callKitEnabled: false)).wasCalled()
        XCTAssertEqual(.initialized, DefaultAudioClientController.state)
        verify(audioLockMock.unlock()).wasCalled()
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
