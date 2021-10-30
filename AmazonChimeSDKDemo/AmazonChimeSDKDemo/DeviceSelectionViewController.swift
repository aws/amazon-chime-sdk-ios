//
//  DeviceSelectionViewController.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import UIKit

class DeviceSelectionViewController: UIViewController {
    @IBOutlet var audioDeviceLabel: UILabel!
    @IBOutlet var audioDevicePicker: UIPickerView!
    @IBOutlet var videoDevicePicker: UIPickerView!
    @IBOutlet var videoFormatPicker: UIPickerView!
    @IBOutlet var videoPreviewImageView: DefaultVideoRenderView!
    @IBOutlet var joinButton: UIButton!

    var model: DeviceSelectionModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        audioDevicePicker.delegate = self
        audioDevicePicker.dataSource = self
        videoDevicePicker.delegate = self
        videoDevicePicker.dataSource = self
        videoFormatPicker.delegate = self
        videoFormatPicker.dataSource = self

        videoPreviewImageView.mirror = model?.shouldMirrorPreview ?? false
        model?.cameraCaptureSource.addVideoSink(sink: videoPreviewImageView)
        model?.cameraCaptureSource.start()
    }

    @IBAction func joinButtonTapped(_: UIButton) {
        guard let model = model else {
            return
        }
        model.cameraCaptureSource.stop()
        model.cameraCaptureSource.removeVideoSink(sink: videoPreviewImageView)
        MeetingModule.shared().deviceSelected(model)
    }
}

extension DeviceSelectionViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        guard let model = model else {
            return nil
        }
        if pickerView == audioDevicePicker {
            if row >= model.audioDevices.count {
                return nil
            }
            return model.audioDevices[row].label
        } else if pickerView == videoDevicePicker {
            if row >= model.videoDevices.count {
                return nil
            }
            return model.videoDevices[row].label
        } else if pickerView == videoFormatPicker {
            let formats = model.supportedVideoFormat[model.selectedVideoDeviceIndex]
            if row >= formats.count {
                return nil
            }
            let format = formats[row]
            return "\(format.width) x \(format.height) @ \(format.maxFrameRate)"
        } else {
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        guard let model = model else {
            return
        }
        if pickerView == audioDevicePicker {
            if row >= model.audioDevices.count {
                return
            }
            model.selectedAudioDeviceIndex = row
        } else if pickerView == videoDevicePicker {
            if row >= model.videoDevices.count {
                return
            }
            model.selectedVideoDeviceIndex = row
            videoPreviewImageView.mirror = model.shouldMirrorPreview
            videoFormatPicker.reloadAllComponents()
        } else if pickerView == videoFormatPicker {
            let formats = model.supportedVideoFormat[model.selectedVideoDeviceIndex]
            if row >= formats.count {
                return
            }
            model.selectedVideoFormatIndex = row
        } else {
            return
        }
    }
}

extension DeviceSelectionViewController: UIPickerViewDataSource {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        guard let model = model else {
            return 0
        }
        if pickerView == audioDevicePicker {
            return model.audioDevices.count
        } else if pickerView == videoDevicePicker {
            return model.videoDevices.count
        } else if pickerView == videoFormatPicker {
            if model.videoDevices.count == 0 {
                return 0
            }
            return model.supportedVideoFormat[model.selectedVideoDeviceIndex].count
        } else {
            return 0
        }
    }
}
