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
    var eventAnalyticsControllerMock: EventAnalyticsControllerMock!

    override func setUp() {
        videoClientControllerMock = mock(VideoClientController.self)
        eventAnalyticsControllerMock = mock(EventAnalyticsController.self)
        loggerMock = mock(Logger.self)
        let route = AVAudioSession.sharedInstance().currentRoute
        audioSessionMock = mock(AudioSession.self)
        given(audioSessionMock.getCurrentRoute()).willReturn(route)
        defaultDeviceController = DefaultDeviceController(audioSession: audioSessionMock,
                                                          videoClientController: videoClientControllerMock,
                                                          eventAnalyticsController: eventAnalyticsControllerMock,
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

    func testListAudioDevicesShouldDedupe() {
        let bt = MockedAudioSessionPortDescription(portType: AVAudioSession.Port.bluetoothHFP, portName: "BT")
        let btUnkown = MockedAudioSessionPortDescription(portType: AVAudioSession.Port.init(rawValue: "Unkown"), portName: "BT")
        let availableInputs = [bt, btUnkown]
        given(audioSessionMock.getAvailableInputs()).willReturn(availableInputs)

        let audioDevices = defaultDeviceController.listAudioDevices()
        
        // contains 1 bt and 1 loud speaker
        XCTAssertEqual(2, audioDevices.count)
        XCTAssertEqual(audioDevices[0].type, MediaDeviceType.audioBluetooth)
        XCTAssertEqual(audioDevices[0].label, "BT")
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
