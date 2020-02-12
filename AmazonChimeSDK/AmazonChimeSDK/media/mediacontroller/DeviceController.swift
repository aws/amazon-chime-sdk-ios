//
//  DeviceControllerFacade.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

/// <#Description#>
public protocol DeviceController {

    /// List available audio input devices
    /// - Returns: List of Media Devices
    func listAudioInputDevices() -> [MediaDevice]

    
    /// List available audio output devices
    /// - Returns: List of Media Devices
     
    func listAudioOutputDevices() -> [MediaDevice]

    /// Choose audio input devices
    /// - Parameter device: the device used as audio output
    func chooseAudioInputDevice(device: MediaDevice)

    
    /// Choose audio output devices [pending implemtation]
    /// - Parameter device: the device used as audio output
    func chooseAudioOutputDevice(device: MediaDevice)
}
