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
import Cuckoo
import XCTest

class DefaultDeviceControllerTests: XCTestCase {
    var audioSessionMock: MockAudioSession!
    var videoClientControllerMock: MockVideoClientController!
    var loggerMock: MockLogger!
    var defaultDeviceController: DefaultDeviceController!
    var eventAnalyticsControllerMock: MockEventAnalyticsController!

    override func setUp() {
        videoClientControllerMock = MockVideoClientController().withEnabledDefaultImplementation(VideoClientControllerStub())
        eventAnalyticsControllerMock = MockEventAnalyticsController().withEnabledDefaultImplementation(EventAnalyticsControllerStub())
        loggerMock = MockLogger().withEnabledDefaultImplementation(LoggerStub())
        let route = AVAudioSession.sharedInstance().currentRoute
        audioSessionMock = MockAudioSession().withEnabledDefaultImplementation(AudioSessionStub())
        stub(audioSessionMock) { stub in
            when(stub.currentRoute.get).thenReturn(route)
        }
        defaultDeviceController = DefaultDeviceController(audioSession: audioSessionMock,
                                                          videoClientController: videoClientControllerMock,
                                                          eventAnalyticsController: eventAnalyticsControllerMock,
                                                          logger: loggerMock)
    }

    func testListAudioDevices() {
        let availableInputs = AVAudioSession.sharedInstance().availableInputs
        stub(audioSessionMock) { stub in
            when(stub.availableInputs.get).thenReturn(availableInputs)
        }

        let audioDevices = defaultDeviceController.listAudioDevices()
        XCTAssertTrue(!audioDevices.isEmpty)
        XCTAssertEqual(audioDevices[1].type, MediaDeviceType.audioBuiltInSpeaker)
        XCTAssertEqual(audioDevices[1].label, "Built-in Speaker")
    }

    func testListAudioDevicesShouldDedupe() {
        let bt = MockedAudioSessionPortDescription(portType: AVAudioSession.Port.bluetoothHFP, portName: "BT")
        let btUnkown = MockedAudioSessionPortDescription(portType: AVAudioSession.Port.init(rawValue: "Unkown"), portName: "BT")
        let availableInputs = [bt, btUnkown]
        stub(audioSessionMock) { stub in
            when(stub.availableInputs.get).thenReturn(availableInputs)
        }

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

        verify(audioSessionMock).overrideOutputAudioPort(equal(to: .speaker))
        
        let captor = ArgumentCaptor<[AnyHashable: Any]>()
        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: .audioInputSelected),
                                                          attributes: captor.capture(),
                                                          notifyObservers: false)
        
        let audioDeviceType = captor.value?[EventAttributeName.audioDeviceType] as? String
        XCTAssertEqual(audioDeviceType, MediaDeviceType.audioBuiltInSpeaker.description)
    }

    func testChooseAudioDevice_nonSpeaker() {
        let availableInputs = AVAudioSession.sharedInstance().availableInputs
        let nonSpeakerDevice = MediaDevice.fromAVSessionPort(port: (availableInputs?[0])!)
        defaultDeviceController.chooseAudioDevice(mediaDevice: nonSpeakerDevice)

        verify(audioSessionMock).setPreferredInput(equal(to: nonSpeakerDevice.port!))
        
        let captor = ArgumentCaptor<[AnyHashable: Any]>()
        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: .audioInputSelected),
                                                          attributes: captor.capture(),
                                                          notifyObservers: false)
        
        let audioDeviceType = captor.value?[EventAttributeName.audioDeviceType] as? String
        XCTAssertEqual(audioDeviceType, nonSpeakerDevice.type.description)
    }

    func testSwitchCamera() {
        defaultDeviceController.switchCamera()

        verify(videoClientControllerMock).switchCamera()
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

        verify(audioSessionMock, times(2)).currentRoute.get()
        XCTAssertEqual(currentDevice?.label, expected?.label)
        XCTAssertEqual(currentDevice?.type, expected?.type)
    }
    
    func testListAudioDevices_ShouldPublishEvent_WhenNoAvailableInputs() {
        let captor = ArgumentCaptor<[AnyHashable: Any]>()
        
        stub(audioSessionMock) { stub in
            when(stub.availableInputs.get).thenReturn(nil)
        }
        
        _ = defaultDeviceController.listAudioDevices()
        
        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: .audioInputFailed),
                                                          attributes: captor.capture())
        
        let error = captor.value?[EventAttributeName.audioInputError] as? MediaError
        XCTAssertEqual(error, MediaError.noAudioDevices)
    }
    
    func testChooseAudioDevice_ShouldPublishEvent_WhenFail() {
        let captor = ArgumentCaptor<[AnyHashable: Any]>()
        
        stub(audioSessionMock) { stub in
            when(stub.overrideOutputAudioPort(equal(to: .speaker))).then { _ in
                throw TestError.audioInputError
            }
        }
        
        let speakerDevice = MediaDevice(label: "Built-in Speaker")
        defaultDeviceController.chooseAudioDevice(mediaDevice: speakerDevice)
        
        verify(eventAnalyticsControllerMock).publishEvent(name: equal(to: .audioInputFailed), attributes: captor.capture())
        
        let error = captor.value?[EventAttributeName.audioInputError] as? MediaError
        XCTAssertEqual(error, MediaError.overrideOutputAudioPortFailed)
        
        let deviceType = captor.value?[EventAttributeName.audioDeviceType] as? String
        XCTAssertEqual(deviceType, MediaDeviceType.audioBuiltInSpeaker.description)
    }
}
