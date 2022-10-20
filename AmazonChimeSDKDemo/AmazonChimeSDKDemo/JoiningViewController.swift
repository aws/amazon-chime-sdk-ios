//
//  ViewController.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import AVFoundation
import Toast
import UIKit

class JoiningViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var meetingIdTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var callKitOptionsPicker: UIPickerView!
    @IBOutlet var audioModeOptionsPicker: UIPickerView!
    @IBOutlet var joinButton: UIButton!
    @IBOutlet var debugSettingsButton: UIButton!

    var callKitOptions = ["CallKit as Incoming in 10s", "CallKit as Outgoing"]
    var audioModeOptions = ["Stereo/48KHz Audio", "Mono/48KHz Audio", "Mono/16KHz Audio"]

    private let toastDisplayDuration = 2.0
    private let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        meetingIdTextField.delegate = self
        nameTextField.delegate = self

        callKitOptionsPicker.delegate = self
        callKitOptionsPicker.dataSource = self

        audioModeOptionsPicker.delegate = self
        audioModeOptionsPicker.dataSource = self

        setupHideKeyboardOnTap()
        versionLabel.text = "amazon-chime-sdk-ios@\(Versioning.sdkVersion())"
    }

    override func viewWillAppear(_: Bool) {
        callKitOptionsPicker.selectRow(0, inComponent: 0, animated: false)
        joinButton.isEnabled = true
    }

    @IBAction func joinButton(_: UIButton) {
        // CallKit Option
        let callKitOption = getSelectedCallKitOption()
        if callKitOption == .incoming {
            view.makeToast("You can background the app or lock screen while waiting",
                           duration: incomingCallKitDelayInSeconds)
        }

        // Audio Mode
        let audioMode = getSelectedAudioMode()

        joinMeeting(audioVideoConfig: AudioVideoConfiguration(audioMode: audioMode, callKitEnabled: true),
                    callKitOption: callKitOption
        )
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func getSelectedCallKitOption() -> CallKitOption {
        switch callKitOptionsPicker.selectedRow(inComponent: 0) {
        case 0:
            return .incoming
        case 1:
            return .outgoing
        default:
            return .outgoing
        }
    }

    func getSelectedAudioMode() -> AudioMode {
        switch audioModeOptionsPicker.selectedRow(inComponent: 0) {
        case 1:
            return .mono48K
        case 2:
            return .mono16K
        default:
            return .stereo48K
        }
    }

    func joinMeeting(audioVideoConfig: AudioVideoConfiguration, callKitOption: CallKitOption) {
        view.endEditing(true)
        let meetingId = meetingIdTextField.text ?? ""
        let name = nameTextField.text ?? ""

        if meetingId.isEmpty || name.isEmpty {
            DispatchQueue.main.async {
                self.view.makeToast("Meeting ID or name is invalid",
                                    duration: self.toastDisplayDuration)
            }
            return
        }

        MeetingModule.shared().prepareMeeting(meetingId: meetingId,
                                              selfName: name,
                                              audioVideoConfig: audioVideoConfig,
                                              option: callKitOption,
                                              overriddenEndpoint: "",
                                              primaryExternalMeetingId: "") { success in
            DispatchQueue.main.async {
                if !success {
                    self.view.hideToast()
                    self.view.makeToast("Unable to join meeting please try different meeting ID",
                                        duration: self.toastDisplayDuration)
                }
            }
        }
    }
}

extension JoiningViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        if pickerView == callKitOptionsPicker {
            if row >= callKitOptions.count {
                return nil
            }
            return callKitOptions[row]
        } else if pickerView == audioModeOptionsPicker {
            if row >= audioModeOptions.count {
                return nil
            }
            return audioModeOptions[row]
        } else {
            return nil
        }
    }
}

extension JoiningViewController: UIPickerViewDataSource {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        if pickerView == callKitOptionsPicker {
            return callKitOptions.count
        } else if pickerView == audioModeOptionsPicker {
            return audioModeOptions.count
        } else {
            return 0
        }
    }
}
