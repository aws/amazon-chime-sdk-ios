//
//  DeviceControllerFacade.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

@objc public protocol DeviceController {
    /// List available audio devices
    /// - Returns: list of Media Devices
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

    /// Switch between front/back camera
    func switchCamera()

    /// Get currently used video device
    /// - Returns: a media device or nil if no device is present
    func getActiveCamera() -> MediaDevice?
}
