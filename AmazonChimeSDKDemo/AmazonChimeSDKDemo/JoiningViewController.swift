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
    @IBOutlet var joinWithoutCallKitButton: UIButton!
    @IBOutlet var joinAsIncomingCallButton: UIButton!
    @IBOutlet var joinAsOutgoingCallButton: UIButton!
    @IBOutlet var testSettingsButton: UIButton!

    private let toastDisplayDuration = 2.0
    private let meetingPresenter = MeetingPresenter.shared()
    var model: TestSettingsModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        meetingIdTextField.delegate = self
        nameTextField.delegate = self

        setupHideKeyboardOnTap()
        versionLabel.text = "amazon-chime-sdk-ios@\(Versioning.sdkVersion())"
        model = model ?? TestSettingsModel()
    }

    override func viewWillAppear(_: Bool) {
        setJoinButtons(isEnabled: true)
    }

    @IBAction func joinWithoutCallKitButtonClicked(_: UIButton) {
        joinMeeting(callKitOption: .disabled)
    }

    @IBAction func joinAsIncomingCallButton(_: UIButton) {
        view.makeToast("You can background the app or lock screen while waiting",
                       duration: incomingCallKitDelayInSeconds)
        joinMeeting(callKitOption: .incoming)
    }

    @IBAction func joinAsOutgoingCallButton(_: UIButton) {
        joinMeeting(callKitOption: .outgoing)
    }
    
    @IBAction func testSettingsButtonClicked (_: UIButton) {
        guard let model = model else {
            return
        }
        meetingPresenter.showTestSettingsView(model: model)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    private func setJoinButtons(isEnabled: Bool) {
        joinWithoutCallKitButton.isEnabled = isEnabled
        joinAsIncomingCallButton.isEnabled = isEnabled
        joinAsOutgoingCallButton.isEnabled = isEnabled
    }

    func joinMeeting(callKitOption: CallKitOption) {
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
        let endpointUrl = model?.endpointUrl ?? ""

        MeetingModule.shared().prepareMeeting(meetingId: meetingId, selfName: name, option: callKitOption, endpointUrl: endpointUrl) { success in
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
