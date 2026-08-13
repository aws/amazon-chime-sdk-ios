//
//  DebugSettingsViewController.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit

class DebugSettingsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var serverEndpointUrlTextField: UITextField!
    @IBOutlet var primaryExternalMeetingIdTextField: UITextField!
    @IBOutlet var fhdVideoSwitch: UISwitch!
    @IBOutlet var saveButton: UIButton!

    var model: DebugSettingsModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHideKeyboardOnTap()
        serverEndpointUrlTextField.delegate = self
        serverEndpointUrlTextField.text = model?.endpointUrl
        primaryExternalMeetingIdTextField.text = model?.primaryExternalMeetingId
        fhdVideoSwitch.isOn = model?.enableHigherDefinitionVideo ?? false
    }

    @IBAction func saveButtonClicked(_: UIButton) {
        let endpointUrl = serverEndpointUrlTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        model?.endpointUrl = endpointUrl

        let primaryExternalMeetingId = primaryExternalMeetingIdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        model?.primaryExternalMeetingId = primaryExternalMeetingId

        model?.enableHigherDefinitionVideo = fhdVideoSwitch.isOn

        self.dismiss(animated: true, completion: nil)
    }

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
