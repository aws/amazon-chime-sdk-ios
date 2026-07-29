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
import XCTest

class DefaultDeviceControllerTests: XCTestCase {
    var audioSessionMock: AudioSessionSpy!
    var videoClientControllerMock: VideoClientControllerSpy!
    var loggerMock: LoggerSpy!
    var defaultDeviceController: DefaultDeviceController!
    var eventAnalyticsControllerMock: EventAnalyticsControllerSpy!

    override func setUp() {
        videoClientControllerMock = VideoClientControllerSpy()
        eventAnalyticsControllerMock = EventAnalyticsControllerSpy()
        loggerMock = LoggerSpy()
        let route = AVAudioSession.sharedInstance().currentRoute
        audioSessionMock = AudioSessionSpy()
        audioSessionMock.currentRouteReturn = route
        defaultDeviceController = DefaultDeviceController(audioSession: audioSessionMock,
                                                          videoClientController: videoClientControllerMock,
                                                          eventAnalyticsController: eventAnalyticsControllerMock,
                                                          logger: loggerMock)
    }

    func testListAudioDevices() {
        let availableInputs = AVAudioSession.sharedInstance().availableInputs
        audioSessionMock.availableInputsReturn = availableInputs

        let audioDevices = defaultDeviceController.listAudioDevices()
        XCTAssertTrue(!audioDevices.isEmpty)
        XCTAssertEqual(audioDevices[1].type, MediaDeviceType.audioBuiltInSpeaker)
        XCTAssertEqual(audioDevices[1].label, "Built-in Speaker")
    }

    func testListAudioDevicesShouldDedupe() {
        let bt = MockedAudioSessionPortDescription(portType: AVAudioSession.Port.bluetoothHFP, portName: "BT")
        let btUnkown = MockedAudioSessionPortDescription(portType: AVAudioSession.Port.init(rawValue: "Unkown"), portName: "BT")
        let availableInputs = [bt, btUnkown]
        audioSessionMock.availableInputsReturn = availableInputs

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

        XCTAssertEqual(audioSessionMock.overrideOutputAudioPortCalls.filter { $0 == .speaker }.count, 1)
        
        let selected = eventAnalyticsControllerMock.publishEventCalls
            .filter { $0.name == .audioInputSelected && $0.notifyObservers == false }
        XCTAssertEqual(selected.count, 1)
        let audioDeviceType = selected.last?.attributes?[EventAttributeName.audioDeviceType] as? String
        XCTAssertEqual(audioDeviceType, MediaDeviceType.audioBuiltInSpeaker.description)
    }

    func testChooseAudioDevice_nonSpeaker() {
        let availableInputs = AVAudioSession.sharedInstance().availableInputs
        let nonSpeakerDevice = MediaDevice.fromAVSessionPort(port: (availableInputs?[0])!)
        defaultDeviceController.chooseAudioDevice(mediaDevice: nonSpeakerDevice)

        XCTAssertEqual(audioSessionMock.setPreferredInputCalls.filter { $0 === nonSpeakerDevice.port! }.count, 1)
        
        let selected = eventAnalyticsControllerMock.publishEventCalls
            .filter { $0.name == .audioInputSelected && $0.notifyObservers == false }
        XCTAssertEqual(selected.count, 1)
        let audioDeviceType = selected.last?.attributes?[EventAttributeName.audioDeviceType] as? String
        XCTAssertEqual(audioDeviceType, nonSpeakerDevice.type.description)
    }

    func testSwitchCamera() {
        defaultDeviceController.switchCamera()

        XCTAssertEqual(videoClientControllerMock.switchCameraCallCount, 1)
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

        XCTAssertEqual(audioSessionMock.currentRouteGetCount, 2)
        XCTAssertEqual(currentDevice?.label, expected?.label)
        XCTAssertEqual(currentDevice?.type, expected?.type)
    }
    
    func testListAudioDevices_ShouldPublishEvent_WhenNoAvailableInputs() {
        audioSessionMock.availableInputsReturn = nil

        _ = defaultDeviceController.listAudioDevices()

        let failed = eventAnalyticsControllerMock.publishEventCalls.filter { $0.name == .audioInputFailed }
        XCTAssertEqual(failed.count, 1)
        let error = failed.last?.attributes?[EventAttributeName.audioInputError] as? MediaError
        XCTAssertEqual(error, MediaError.noAudioDevices)
    }
    
    func testChooseAudioDevice_ShouldPublishEvent_WhenFail() {
        audioSessionMock.overrideOutputAudioPortError = TestError.audioInputError

        let speakerDevice = MediaDevice(label: "Built-in Speaker")
        defaultDeviceController.chooseAudioDevice(mediaDevice: speakerDevice)

        let failed = eventAnalyticsControllerMock.publishEventCalls.filter { $0.name == .audioInputFailed }
        XCTAssertEqual(failed.count, 1)
        let error = failed.last?.attributes?[EventAttributeName.audioInputError] as? MediaError
        XCTAssertEqual(error, MediaError.overrideOutputAudioPortFailed)

        let deviceType = failed.last?.attributes?[EventAttributeName.audioDeviceType] as? String
        XCTAssertEqual(deviceType, MediaDeviceType.audioBuiltInSpeaker.description)
    }
}
