//
//  DeviceControllerFacade.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public protocol DeviceController {
    /// List available audio devices
    /// - Returns: List of Media Devices
    func listAudioDevices() -> [MediaDevice]

    /// Choose audio devices
    /// - Parameter mediaDevice: the device used as audio route
    func chooseAudioDevice(mediaDevice: MediaDevice)

    /// Add device change observer
    /// - Parameter observer: the object that will receive notification
    func addDeviceChangeObserver(observer: DeviceChangeObserver)

    /// Remove device change observer
    /// - Parameter observer: the object that will be removed
    func removeDeviceChangeObserver(observer: DeviceChangeObserver)
}
