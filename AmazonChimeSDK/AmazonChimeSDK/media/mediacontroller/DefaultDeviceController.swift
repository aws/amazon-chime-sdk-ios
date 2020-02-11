//
//  DefaultDeviceController.swift
//  AmazonChimeSDK
//
//  Created by Huang, Weicheng on 2/2/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation
import AVFoundation

public class DefaultDeviceController: DeviceController {
    let audioClient: AudioClientController
    let logger: Logger
    let audioSession: AVAudioSession

    public init(logger: Logger) {
        self.audioClient = AudioClientController.shared()
        self.logger = logger
        self.audioSession = AVAudioSession.sharedInstance()
    }

    public func listAudioInputDevices() -> [MediaDevice] {
        var inputDevices: [MediaDevice] = []

        if let availablePort = self.audioSession.availableInputs {
            inputDevices = availablePort.map { port in MediaDevice.fromAVSessionPort(port: port) }
        }
        return inputDevices
    }

    public func listAudioOutputDevices() -> [MediaDevice] {
        var outputDevice: [MediaDevice] = []

        outputDevice = self.audioSession.currentRoute.outputs.map { port in MediaDevice.fromAVSessionPort(port: port) }
        return outputDevice
    }

    public func chooseAudioInputDevice(device: MediaDevice) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setPreferredInput(device.port)
        } catch let error {
            self.logger.error(msg: "Error on setting audio input device: \(error.localizedDescription)")
        }
    }

    public func chooseAudioOutputDevice(device: MediaDevice) {
        // TODO: May need extra work to make function work, as
        // Apple did not provide such API, neither do tincan (on iOS)
    }
}
