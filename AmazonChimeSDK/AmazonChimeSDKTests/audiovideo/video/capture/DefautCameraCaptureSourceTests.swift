//
//  DefautCameraCaptureSourceTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AVFoundation
@testable import AmazonChimeSDK
import AmazonChimeSDKMedia
import XCTest

class DefaultCameraCaptureSourceTests: XCTestCase {
    var defaultCameraCaptureSource: DefaultCameraCaptureSource!
    var mockSourceObserver: CaptureSourceObserverSpy!
    var eventControllerMock: EventAnalyticsControllerSpy!
    let defaultTimeout = 0.1

    override func setUp() {
        AVCaptureDevice.swizzle()
        AVCaptureSession.swizzle()
        eventControllerMock = EventAnalyticsControllerSpy()
        let loggerMock = LoggerSpy()
        mockSourceObserver = CaptureSourceObserverSpy()

        defaultCameraCaptureSource = DefaultCameraCaptureSource(logger: loggerMock)
        defaultCameraCaptureSource.setEventAnalyticsController(eventAnalyticsController: eventControllerMock)

        defaultCameraCaptureSource.addCaptureSourceObserver(observer: mockSourceObserver)
    }

    override func tearDown() {
        // swizzle is exchange so it should return back
        AVCaptureDevice.swizzle()
        AVCaptureSession.swizzle()
    }

    func testStop_captureDidStop() {
        defaultCameraCaptureSource.stop()

        let expect = XCTestExpectation(description: "eventually")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            verify(self.mockSourceObserver.captureDidStopCallCount)
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
    }

    func testStop_captureDidStart_Failed() {
        AVCaptureSession.swizzleCanAddFalse()
        defaultCameraCaptureSource.start()

        let expect = XCTestExpectation(description: "eventually")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            verifyEqual(self.mockSourceObserver.captureDidFailCalls, to: .configurationFailure)
            verify(self.eventControllerMock.publishEventCalls) { $0.name == .videoInputFailed }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
        AVCaptureSession.swizzleCanAddFalse()
    }

    func testClosestFormat() {
        XCTAssertEqual(defaultCameraCaptureSource.closestFormat(
            formatA: VideoCaptureFormat(width: 1280, height: 720, maxFrameRate: 30),
            formatB: VideoCaptureFormat(width: 1280, height: 720, maxFrameRate: 15)
        ), true)
    }
    
    func testSwitchCamera_ShouldPublishVideoInputFailed_WhenCameraNotAvailable() {
        defaultCameraCaptureSource.switchCamera()

        let failed = verify(eventControllerMock.publishEventCalls) { $0.name == .videoInputFailed }
        let error = failed?.attributes?[EventAttributeName.videoInputError] as? MediaError
        XCTAssertEqual(error, MediaError.noCameraSelected)
    }
    
    func testSetDevice_ShouldPublishVideoInputSelected() {
        defaultCameraCaptureSource.device = MediaDevice.init(label: "mock", type: MediaDeviceType.videoFrontCamera)
        
        let selected = verify(eventControllerMock.publishEventCalls) {
            $0.name == .videoInputSelected && $0.notifyObservers == false
        }
        let deviceType = selected?.attributes?[EventAttributeName.videoDeviceType] as? String
        XCTAssertEqual(deviceType, MediaDeviceType.videoFrontCamera.description)
    }
    
    func testHandleWasInterrupted_ShouldPublishInterruptionBeganEvent_WithValidReason() {
        // Given
        let interruptionReason = AVCaptureSession.InterruptionReason.videoDeviceInUseByAnotherClient
        let userInfo = [AVCaptureSessionInterruptionReasonKey: NSNumber(value: interruptionReason.rawValue)]
        
        // When - Post notification directly to trigger the handler
        NotificationCenter.default.post(name: .AVCaptureSessionWasInterrupted, 
                                       object: nil, 
                                       userInfo: userInfo)
        
        // Then
        let began = verify(eventControllerMock.publishEventCalls) {
            $0.name == .videoInterruptionBegan && $0.notifyObservers == false
        }
        let capturedReason = began?.attributes?[EventAttributeName.videoInterruptionReason] as? VideoInterruptionReason
        XCTAssertEqual(capturedReason, .videoDeviceInUseByAnotherClient)
    }
    
    func testHandleWasInterrupted_ShouldPublishEventWithoutAttribute_WhenReasonKeyIsMissing() {
        // Given
        let userInfo = ["someOtherKey": "someValue"]
        
        // When - Post notification directly to trigger the handler
        NotificationCenter.default.post(name: .AVCaptureSessionWasInterrupted, 
                                       object: nil, 
                                       userInfo: userInfo)
        
        // Then
        XCTAssertEqual(eventControllerMock.publishEventCalls
            .filter { $0.name == .videoInterruptionBegan && $0.notifyObservers == false }.count, 1)
    }
    
    func testHandleInterruptionEnded_ShouldPublishInterruptionEndedEvent() {
        // Given - Post notification directly to trigger the handler
        NotificationCenter.default.post(name: .AVCaptureSessionInterruptionEnded, 
                                       object: nil, 
                                       userInfo: nil)
        
        // Then
        verify(eventControllerMock.publishEventCalls) {
            $0.name == .videoInterruptionEnded
                            && $0.notifyObservers == false
                            && NSDictionary(dictionary: $0.attributes ?? [:]).isEqual(to: [:])
        }
    }
}

extension AVCaptureSession {
    class func swizzle() {
        [(#selector(AVCaptureSession.addInput(_:)), #selector(AVCaptureSession.mockAddInput(_:)))].forEach {
            let original = class_getInstanceMethod(self, $0)
            let mock = class_getInstanceMethod(self, $1)
            method_exchangeImplementations(original!, mock!)
        }

        [(#selector(AVCaptureSession.canAddInput(_:)), #selector(AVCaptureSession.mockCanAddInputTrue(_:)))].forEach {
            let original = class_getInstanceMethod(self, $0)
            let mock = class_getInstanceMethod(self, $1)
            method_exchangeImplementations(original!, mock!)
        }

        [(#selector(AVCaptureSession.init(mock:)), #selector(NSObject.init))].forEach {
            let original = class_getInstanceMethod(self, $0)
            let mock = class_getInstanceMethod(self, $1)
            method_setImplementation(original!, method_getImplementation(mock!))
        }
    }

    class func swizzleCanAddFalse() {
        [(#selector(AVCaptureSession.canAddOutput(_:)),
          #selector(AVCaptureSession.mockCanAddOutputFalse(_:)))].forEach {
            let original = class_getInstanceMethod(self, $0)
            let mock = class_getInstanceMethod(self, $1)
            method_exchangeImplementations(original!, mock!)
        }
    }

    @objc convenience init(mock: String) {
        fatalError("should never be called because this is fake method replaced by original init")
    }

    @objc func mockCanAddOutputFalse(_ output: AVCaptureOutput) -> Bool {
        return false
    }

    @objc func mockAddInput(_ deviceInput: AVCaptureInput) {
        return
    }

    @objc func mockCanAddInputTrue(_ deviceInput: AVCaptureInput) -> Bool {
        return true
    }
}

extension AVCaptureDevice {
    class func swizzle() {
        [(#selector(AVCaptureDevice.default(_:for:position:)),
          #selector(AVCaptureDevice.mockDefaultDevice(_:for:position:)))].forEach {
            let original = class_getClassMethod(self, $0)
            let mock = class_getClassMethod(self, $1)
            method_exchangeImplementations(original!, mock!)
        }
        [(#selector(AVCaptureDevice.hasMediaType(_:)), #selector(AVCaptureDevice.mockHasMediaType(_:))),
         (#selector(AVCaptureDevice.supportsSessionPreset),
          #selector(AVCaptureDevice.mockSupportsAVCaptureSessionPreset)),
         (#selector(AVCaptureDevice.isTorchModeSupported(_:)), #selector(AVCaptureDevice.mockIsTorchModeSupported)),
         (#selector(getter: AVCaptureDevice.torchMode), #selector(getter: AVCaptureDevice.mockTorchMode)),
         (#selector(setter: AVCaptureDevice.torchMode), #selector(setter: AVCaptureDevice.mockTorchMode))].forEach {
            let original = class_getInstanceMethod(self, $0)
            let mock = class_getInstanceMethod(self, $1)
            method_exchangeImplementations(original!, mock!)
        }
        [(#selector(AVCaptureDevice.init(mock:)), #selector(NSObject.init))].forEach {
            let original = class_getInstanceMethod(self, $0)
            let mock = class_getInstanceMethod(self, $1)
            method_setImplementation(original!, method_getImplementation(mock!))
        }
        [(#selector(AVCaptureDevice.lockForConfiguration),
          #selector(AVCaptureDevice.mocklockForConfiguration)),
         (#selector(AVCaptureDevice.unlockForConfiguration),
          #selector(AVCaptureDevice.mockUnlockForConfiguration))].forEach {
            let original = class_getInstanceMethod(self, $0)
            let mock = class_getInstanceMethod(self, $1)
            method_exchangeImplementations(original!, mock!)
        }

    }

    @objc convenience init(mock: String) {
        fatalError("should never be called because this is fake method replaced by original init")
    }

    @objc class func mockDefaultDevice(_ deviceType: AVCaptureDevice.DeviceType,
                                       for mediaType: AVMediaType?,
                                       position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        return AVCaptureDevice(mock: "")
    }

    @objc func mocklockForConfiguration() {
        return
    }
    @objc func mockUnlockForConfiguration() {
        return
    }

    @objc func mockHasMediaType(_ mediaType: String!) -> Bool {
        return true
    }

    @objc func mockSupportsAVCaptureSessionPreset(_ preset: String!) -> Bool {
        return true
    }

    @objc func mockIsTorchModeSupported(_ torchMode: AVCaptureDevice.TorchMode) -> Bool {
        return UI_USER_INTERFACE_IDIOM() != .pad
    }

    @objc var mockTorchMode: AVCaptureDevice.TorchMode {
        get {return .off}
        set {}
    }
}
