//
//  MediaDevice.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import AVFoundation
import Foundation

public struct MediaDevice: CustomStringConvertible {
    public let label: String
    public let type: MediaDeviceType
    public let port: AVAudioSessionPortDescription?

    static func fromAVSessionPort(port: AVAudioSessionPortDescription) -> MediaDevice {
        return MediaDevice(label: port.portName, port: port)
    }

    static func fromVideoDevice(device: VideoDevice?) -> MediaDevice {
        return MediaDevice(label: device?.name ?? "unknown", videoDevice: device)
    }

    public init(label: String, port: AVAudioSessionPortDescription? = nil, videoDevice: VideoDevice? = nil) {
        self.label = label
        self.port = port
        if let videoDevice = videoDevice {
            let nameLowercased = videoDevice.name.lowercased()
            if nameLowercased.contains("front") {
                self.type = .videoFrontCamera
            } else if nameLowercased.contains("back") {
                self.type = .videoBackCamera
            } else {
                self.type = .other
            }
        } else if let port = port {
            switch port.portType {
            case .bluetoothLE, .bluetoothHFP, .bluetoothA2DP:
                self.type = .audioBluetooth
            case .builtInReceiver, .builtInMic:
                self.type = .audioHandset
            case .headphones, .headsetMic:
                self.type = .audioWiredHeadset
            default:
                self.type = .other
            }
        } else {
            self.type = .other
        }
    }

    public var description: String {
        return "\(self.label) - \(self.type)"
    }
}

public enum MediaDeviceType {
    case audioBluetooth
    case audioWiredHeadset
    case audioBuiltInSpeaker
    case audioHandset
    case videoFrontCamera
    case videoBackCamera
    case other
}
