//
//  MediaDevice.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import AVFoundation
import Foundation

/// `MediaDevice` represents an IOS audio/video device.
@objcMembers public class MediaDevice: NSObject {
    /// Label of MediaDevice
    public let label: String

    /// Type of MediaDevice (ex: Bluetooth Audio, Front Camera)
    public let type: MediaDeviceType

    /// Audio Information based on iOS native `AVAudioSessionPortDescription`
    /// It will be null when it represent a video device.
    public let port: AVAudioSessionPortDescription?

    /// Create `MediaDevice` for audio from audio information based on iOS native `AVAudioSessionPortDescription`.
    /// - Parameter port: Audio information
    static func fromAVSessionPort(port: AVAudioSessionPortDescription) -> MediaDevice {
        return MediaDevice(label: port.portName, port: port)
    }

    /// Create `MediaDevice` for video from  `VideoDevice`.
    /// - Parameter device: Video device that contains information about device
    static func fromVideoDevice(device: VideoDevice?) -> MediaDevice {
        return MediaDevice(label: device?.name ?? "unknown", videoDevice: device)
    }

    /// List available video capture devices from the hardware
    public static func listVideoDevices() -> [MediaDevice] {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                mediaType: .video,
                                                                position: .unspecified)
        return discoverySession.devices.map { device in
            var position = MediaDeviceType.other
            if device.position == .front {
                position = .videoFrontCamera
            } else if device.position == .back {
                position = .videoBackCamera
            }
            return MediaDevice(label: device.localizedName, type: position)
        }
    }

    /// List available `VideoCaptureFormat` from the video capture device.
    /// This methods returns an empty array for `MediaDevice` that's not used for video.
    /// - Parameter mediaDevice: Video capture device to query
    public static func listSupportedVideoCaptureFormats(mediaDevice: MediaDevice) -> [VideoCaptureFormat] {
        guard mediaDevice.type == .videoFrontCamera || mediaDevice.type == .videoBackCamera else {
            return []
        }
        let position: AVCaptureDevice.Position = mediaDevice.type == .videoFrontCamera ? .front : .back
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                mediaType: .video,
                                                                position: position)
        guard let device = discoverySession.devices.first else {
            return []
        }
        var supportedFormats: [VideoCaptureFormat] = []
        for avFormat in device.formats {
            var format = VideoCaptureFormat.fromAVCaptureDeviceFormat(format: avFormat)
            if format.height > Constants.maxSupportedVideoHeight
                || format.width > Constants.maxSupportedVideoWidth {
                continue
            }
            if format.maxFrameRate > Constants.maxSupportedVideoFrameRate {
                format = VideoCaptureFormat(width: format.width,
                                            height: format.height,
                                            maxFrameRate: Constants.maxSupportedVideoFrameRate)
            }
            if !supportedFormats.contains(format) {
                supportedFormats.append(format)
            }
        }
        return supportedFormats
    }

    public init(label: String, type: MediaDeviceType) {
        self.label = label
        self.type = type
        self.port = nil
    }

    public init(label: String, port: AVAudioSessionPortDescription? = nil, videoDevice: VideoDevice? = nil) {
        self.label = label
        self.port = port
        if let videoDevice = videoDevice {
            let nameLowercased = videoDevice.name.lowercased()
            if nameLowercased.contains("front") {
                type = .videoFrontCamera
            } else if nameLowercased.contains("back") {
                type = .videoBackCamera
            } else {
                type = .other
            }
        } else if let port = port {
            switch port.portType {
            case .bluetoothLE, .bluetoothHFP, .bluetoothA2DP:
                type = .audioBluetooth
            case .builtInReceiver, .builtInMic:
                type = .audioHandset
            case .headphones, .headsetMic:
                type = .audioWiredHeadset
            case .builtInSpeaker:
                type = .audioBuiltInSpeaker
            default:
                type = .other
            }
        } else {
            self.type = .other
        }
    }

    override public var description: String {
        return "\(label) - \(type)"
    }
}
