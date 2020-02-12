//
//  MediaDevice.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation
import AVFoundation

public struct MediaDevice: CustomStringConvertible {
    public let label: String
    public let port: AVAudioSessionPortDescription

    static func fromAVSessionPort(port: AVAudioSessionPortDescription) -> MediaDevice {
        return MediaDevice(label: port.portName, port: port)
    }

    public init(label: String, port: AVAudioSessionPortDescription) {
        self.port = port
        self.label = label
    }

    public var description: String {
        return "\(self.label) - \(self.port)"
    }

}
