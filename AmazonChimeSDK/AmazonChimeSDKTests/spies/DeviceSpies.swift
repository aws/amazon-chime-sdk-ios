//
//  DeviceSpies.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Foundation

class DeviceControllerSpy: DeviceController {
    var listAudioDevicesCallCount = 0
    var listAudioDevicesReturn: [MediaDevice] = []
    var chooseAudioDeviceCalls: [MediaDevice] = []
    var addDeviceChangeObserverCalls: [DeviceChangeObserver] = []
    var removeDeviceChangeObserverCalls: [DeviceChangeObserver] = []
    var switchCameraCallCount = 0
    var getActiveCameraCallCount = 0
    var getActiveCameraReturn: MediaDevice?
    var getActiveAudioDeviceCallCount = 0
    var getActiveAudioDeviceReturn: MediaDevice?

    func listAudioDevices() -> [MediaDevice] {
        listAudioDevicesCallCount += 1
        return listAudioDevicesReturn
    }

    func chooseAudioDevice(mediaDevice: MediaDevice) {
        chooseAudioDeviceCalls.append(mediaDevice)
    }

    func addDeviceChangeObserver(observer: DeviceChangeObserver) {
        addDeviceChangeObserverCalls.append(observer)
    }

    func removeDeviceChangeObserver(observer: DeviceChangeObserver) {
        removeDeviceChangeObserverCalls.append(observer)
    }

    func switchCamera() { switchCameraCallCount += 1 }

    func getActiveCamera() -> MediaDevice? {
        getActiveCameraCallCount += 1
        return getActiveCameraReturn
    }

    func getActiveAudioDevice() -> MediaDevice? {
        getActiveAudioDeviceCallCount += 1
        return getActiveAudioDeviceReturn
    }
}
