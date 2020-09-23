//
//  DefaultDeviceControllerTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import AmazonChimeSDKMedia
import AVFoundation
import Mockingbird
import XCTest

class DefaultDeviceControllerTests: XCTestCase {
    var audioSessionMock: AudioSessionMock!
    var videoClientControllerMock: VideoClientControllerMock!
    var loggerMock: LoggerMock!
    var defaultDeviceController: DefaultDeviceController!

    override func setUp() {
        videoClientControllerMock = mock(VideoClientController.self)
        loggerMock = mock(Logger.self)
        audioSessionMock = mock(AudioSession.self)
        defaultDeviceController = DefaultDeviceController(audioSession: audioSessionMock,
                                                          videoClientController: videoClientControllerMock,
                                                          logger: loggerMock)
    }

    func testListAudioDevices() {
        let availableInputs = AVAudioSession.sharedInstance().availableInputs
        given(audioSessionMock.getAvailableInputs()).willReturn(availableInputs)

        let audioDevices = defaultDeviceController.listAudioDevices()
        XCTAssertTrue(!audioDevices.isEmpty)
        XCTAssertEqual(audioDevices[1].type, MediaDeviceType.audioBuiltInSpeaker)
        XCTAssertEqual(audioDevices[1].label, "Built-in Speaker")
    }

    func testChooseAudioDevice_speaker() {
        let speakerDevice = MediaDevice(label: "Built-in Speaker")
        defaultDeviceController.chooseAudioDevice(mediaDevice: speakerDevice)

        verify(audioSessionMock.overrideOutputAudioPort(.speaker)).wasCalled()
    }

    func testChooseAudioDevice_nonSpeaker() {
        let availableInputs = AVAudioSession.sharedInstance().availableInputs
        let nonSpeakerDevice = MediaDevice.fromAVSessionPort(port: (availableInputs?[0])!)
        defaultDeviceController.chooseAudioDevice(mediaDevice: nonSpeakerDevice)

        verify(audioSessionMock.setPreferredInput(nonSpeakerDevice.port)).wasCalled()
    }

    func testSwitchCamera() {
        defaultDeviceController.switchCamera()

        verify(videoClientControllerMock.switchCamera()).wasCalled()
    }
}
