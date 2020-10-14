//
//  DefaultDeviceController.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AVFoundation

@objcMembers public class DefaultDeviceController: NSObject, DeviceController {
    let videoClientController: VideoClientController
    let logger: Logger
    let audioSession: AudioSession
    let deviceChangeObservers = ConcurrentMutableSet()

    public init(audioSession: AudioSession,
                videoClientController: VideoClientController,
                logger: Logger) {
        self.videoClientController = videoClientController
        self.logger = logger
        self.audioSession = audioSession
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleSystemAudioChange),
                                               name: AVAudioSession.routeChangeNotification,
                                               object: nil)
    }

    public func listAudioDevices() -> [MediaDevice] {
        var inputDevices: [MediaDevice] = []
        let loudSpeaker = getSpeakerMediaDevice()
        if let availablePort = audioSession.availableInputs {
            inputDevices = availablePort.map { port in MediaDevice.fromAVSessionPort(port: port) }
        }
        // Putting loudSpeaker devices as second element is to align with
        // what apple's AVRoutePickerView will present the list of audio devices:
        // 1. Build-in receiver
        // 2. Build-in loud speaker
        // 3. ...
        inputDevices.insert(loudSpeaker, at: 1)
        return inputDevices
    }

    public func chooseAudioDevice(mediaDevice: MediaDevice) {
        do {
            if mediaDevice.port == nil {
                try audioSession.overrideOutputAudioPort(.speaker)
            } else {
                try audioSession.setPreferredInput(mediaDevice.port)
            }
        } catch {
            logger.error(msg: "Error on setting audio input device: \(error.localizedDescription)")
        }
    }

    @objc private func handleSystemAudioChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
            let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue)
        else {
            return
        }

        // Switch over the route change reason.
        switch reason {
        case .newDeviceAvailable, .oldDeviceUnavailable:
            // There are two situation when a device get removed/disconnected
            // 1. The device got removed is not currently using
            // 2. The device got removed is currently using

            // Based on Apple's API of AVAudioSession.routeChangeNotification, The case 1) will not trigger
            // this function.
            DispatchQueue.main.async {
                [unowned self] in
                var availableDevices = self.listAudioDevices()
                if reason == .oldDeviceUnavailable {
                    // We need to manually remove the previous input because in some
                    // situation the mediaDevice get disconnected is still showing in .availableInputs

                    // This is an unexpect behavior from Apple's API
                    let oldDevice = userInfo[AVAudioSessionRouteChangePreviousRouteKey]
                        as? AVAudioSessionRouteDescription
                    availableDevices.removeAll(where: { mediaDevice in
                        mediaDevice.port?.uid == oldDevice?.inputs[0].uid
                    })
                }
                ObserverUtils.forEach(observers: self.deviceChangeObservers) { (observer: DeviceChangeObserver) in
                    observer.audioDeviceDidChange(freshAudioDeviceList: availableDevices)
                }
            }
        default: ()
        }
    }

    public func addDeviceChangeObserver(observer: DeviceChangeObserver) {
        deviceChangeObservers.add(observer)
    }

    public func removeDeviceChangeObserver(observer: DeviceChangeObserver) {
        deviceChangeObservers.remove(observer)
    }

    public func switchCamera() {
        videoClientController.switchCamera()
    }

    public func getActiveCamera() -> MediaDevice? {
        let activeCamera = MediaDevice.fromVideoDevice(device: videoClientController.getCurrentDevice())
        return activeCamera.type == .other ? nil : activeCamera
    }

    public func getActiveAudioDevice() -> MediaDevice? {
        // Check for speaker case
        if audioSession.currentRoute.outputs.count > 0 {
            let currentOutput = audioSession.currentRoute.outputs[0]

            if currentOutput.portType == .builtInSpeaker {
                return getSpeakerMediaDevice()
            }
        }
        if audioSession.currentRoute.inputs.count > 0 {
            return MediaDevice.fromAVSessionPort(port: audioSession.currentRoute.inputs[0])
        } else {
            return nil
        }
    }

    private func getSpeakerMediaDevice() -> MediaDevice {
        return MediaDevice(label: "Built-in Speaker", type: MediaDeviceType.audioBuiltInSpeaker)
    }
}
