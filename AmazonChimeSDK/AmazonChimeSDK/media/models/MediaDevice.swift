//
//  MediaDevice.swift
//  AmazonChimeSDK
//
//  Created by Huang, Weicheng on 2/2/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
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
