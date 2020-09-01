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

class DefaultAudioClientControllerTests: XCTestCase {
    let audioFallbackUrl = "audio-fallback-url"
    let audioHostUrl = "audio-host-url:2020"
    let meetingId = "meeting-id"
    let attendeeId = "attendee-id"
    let joinToken = "join-token"
    let callKitEnabled = false

    var audioClientMock: AudioClientProtocolMock!
    var audioClientObserverMock: AudioClientObserverMock!
    var audioSessionMock: AudioSessionMock!
    var audioLockMock: AudioLockMock!

    var defaultAudioClientController: DefaultAudioClientController!

    override func setUp() {
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

        XCTAssertThrowsError(try defaultAudioClientController.start(audioFallbackUrl: audioFallbackUrl, audioHostUrl: audioHostUrl, meetingId: meetingId, attendeeId: attendeeId, joinToken: joinToken, callKitEnabled: callKitEnabled))
        verify(audioLockMock.lock()).wasCalled()
        verify(audioLockMock.unlock()).wasCalled()
    }

    func testStart_alreadyStarted() {
        DefaultAudioClientController.state = .started
        given(audioSessionMock.getRecordPermission()).willReturn(.granted)

        XCTAssertThrowsError(try defaultAudioClientController.start(audioFallbackUrl: audioFallbackUrl, audioHostUrl: audioHostUrl, meetingId: meetingId, attendeeId: attendeeId, joinToken: joinToken, callKitEnabled: callKitEnabled))
        verify(audioLockMock.lock()).wasCalled()
        verify(audioLockMock.unlock()).wasCalled()
    }

    func testStart_startedOk() {
        DefaultAudioClientController.state = .initialized
        given(audioSessionMock.getRecordPermission()).willReturn(.granted)
        given(audioClientMock.startSession(any(), basePort: any(), callId: any(), profileId: any(), microphoneMute: any(), speakerMute: any(), isPresenter: any(), sessionToken: any(), audioWsUrl: any(), callKitEnabled: any())).willReturn(AUDIO_CLIENT_OK)

        XCTAssertNoThrow(try defaultAudioClientController.start(audioFallbackUrl: audioFallbackUrl, audioHostUrl: audioHostUrl, meetingId: meetingId, attendeeId: attendeeId, joinToken: joinToken, callKitEnabled: callKitEnabled))
        verify(audioLockMock.lock()).wasCalled()
        verify(audioClientObserverMock.notifyAudioClientObserver(observerFunction: any())).wasCalled()
        verify(audioClientMock.startSession("audio-host-url",
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
        given(audioClientMock.startSession(any(), basePort: any(), callId: any(), profileId: any(), microphoneMute: any(), speakerMute: any(), isPresenter: any(), sessionToken: any(), audioWsUrl: any(), callKitEnabled: any())).willReturn(AUDIO_CLIENT_ERR)

        XCTAssertThrowsError(try defaultAudioClientController.start(audioFallbackUrl: audioFallbackUrl, audioHostUrl: audioHostUrl, meetingId: meetingId, attendeeId: attendeeId, joinToken: joinToken, callKitEnabled: callKitEnabled))
        verify(audioLockMock.lock()).wasCalled()
        verify(audioClientObserverMock.notifyAudioClientObserver(observerFunction: any())).wasCalled()
        verify(audioClientMock.startSession("audio-host-url",
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
}
