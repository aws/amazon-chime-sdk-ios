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
        let route = AVAudioSession.sharedInstance().currentRoute
        audioSessionMock = mock(AudioSession.self)
        given(audioSessionMock.getCurrentRoute()).willReturn(route)
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

    func testGetCurrentAudioDevice() {
        let currentDevice = defaultDeviceController.getActiveAudioDevice()
        let route = AVAudioSession.sharedInstance().currentRoute
        var expected: MediaDevice?
        if route.outputs.count > 0 {
            if route.outputs[0].portType == .builtInSpeaker {
                expected = MediaDevice(label: "Built-in Speaker", type: MediaDeviceType.audioBuiltInSpeaker)
            } else if route.inputs.count > 0 {
                expected = MediaDevice.fromAVSessionPort(port: route.inputs[0])
            }
        }

        verify(audioSessionMock.getCurrentRoute()).wasCalled(2)
        XCTAssertEqual(currentDevice?.label, expected?.label)
        XCTAssertEqual(currentDevice?.type, expected?.type)

    }
}
