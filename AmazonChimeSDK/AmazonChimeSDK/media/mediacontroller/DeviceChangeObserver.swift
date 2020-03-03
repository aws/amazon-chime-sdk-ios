//
//  DeviceChangeObserver.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

/// DeviceChangeObserver listen to the change of Audio Device
@objc public protocol DeviceChangeObserver {
    /// Called when listAudioDevices() output changed
    /// In another word, when a new media device become available
    /// or old media device become unavailable
    /// - Parameter freshAudioDeviceList : updated list of available devices
    func onAudioDeviceChange(freshAudioDeviceList: [MediaDevice])
}
