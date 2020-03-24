//
//  DeviceChangeObserver.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `DeviceChangeObserver` listens to the change of Audio Device.
@objc public protocol DeviceChangeObserver {
    /// Called when listAudioDevices() output changed
    /// In another word, when a new media device become available
    /// or old media device become unavailable
    /// - Parameter freshAudioDeviceList : updated list of available devices
    func audioDeviceDidChange(freshAudioDeviceList: [MediaDevice])
}
