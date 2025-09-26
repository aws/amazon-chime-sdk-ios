//
//  DeviceSelectionModel.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import Foundation

class DeviceSelectionModel {
    let audioDevices: [MediaDevice]
    let videoDevices: [MediaDevice]
    let codecs: [[VideoCodecCapability]]
    let cameraCaptureSource: DefaultCameraCaptureSource
    let audioVideoConfig: AudioVideoConfiguration

    lazy var supportedVideoFormat: [[VideoCaptureFormat]] = {
        self.videoDevices.map { videoDevice in
            // Reverse these so the highest resolutions are first
            MediaDevice.listSupportedVideoCaptureFormats(mediaDevice: videoDevice, videoMaxResolution: audioVideoConfig.videoMaxResolution).reversed()
        }
    }()

    var selectedAudioDeviceIndex = 0
    var selectedVideoDeviceIndex: Int = 0 {
        didSet {
            cameraCaptureSource.device = selectedVideoDevice
        }
    }

    var selectedVideoFormatIndex = 0 {
        didSet {
            guard let selectedVideoFormat = selectedVideoFormat else { return }
            cameraCaptureSource.format = selectedVideoFormat
        }
    }

    var selectedCodecIndex = 0
    var selectedCodec: [VideoCodecCapability] {
        return codecs[selectedCodecIndex]
    }

    var selectedAudioDevice: MediaDevice {
        return audioDevices[selectedAudioDeviceIndex]
    }

    var selectedVideoDevice: MediaDevice? {
        if videoDevices.count == 0 {
            return nil
        }
        return videoDevices[selectedVideoDeviceIndex]
    }

    var selectedVideoFormat: VideoCaptureFormat? {
        let supportedVideoFormat = self.supportedVideoFormat
        guard supportedVideoFormat.count >= selectedVideoDeviceIndex + 1 else {
            return nil
        }
        return supportedVideoFormat[selectedVideoDeviceIndex][selectedVideoFormatIndex]
    }

    var shouldMirrorPreview: Bool {
        return selectedVideoDevice?.type == MediaDeviceType.videoFrontCamera
    }

    init(deviceController: DeviceController, cameraCaptureSource: DefaultCameraCaptureSource, audioVideoConfig: AudioVideoConfiguration) {
        audioDevices = deviceController.listAudioDevices()
        // Reverse these so the front camera is the initial choice
        videoDevices = MediaDevice.listVideoDevices().reversed()
        self.cameraCaptureSource = cameraCaptureSource
        self.audioVideoConfig = audioVideoConfig
        codecs = [
            [VideoCodecCapability.vp9(), VideoCodecCapability.h264ConstrainedBaselineProfile(), VideoCodecCapability.vp8()],
            [VideoCodecCapability.h264ConstrainedBaselineProfile(), VideoCodecCapability.vp8()],
            [VideoCodecCapability.vp8(), VideoCodecCapability.h264ConstrainedBaselineProfile()]
        ]
        cameraCaptureSource.device = selectedVideoDevice
        if (audioVideoConfig.videoMaxResolution == VideoResolution.videoDisabled) {
            return
        }
        guard let selectedVideoFormat = selectedVideoFormat else { return }
        cameraCaptureSource.format = selectedVideoFormat
    }
}
