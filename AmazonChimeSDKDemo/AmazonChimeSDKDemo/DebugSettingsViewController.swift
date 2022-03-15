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
    @IBOutlet var saveButton: UIButton!

    var model: DebugSettingsModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHideKeyboardOnTap()
        serverEndpointUrlTextField.delegate = self
        serverEndpointUrlTextField.text = model?.endpointUrl
        primaryExternalMeetingIdTextField.text = model?.primaryExternalMeetingId
    }

    @IBAction func saveButtonClicked(_: UIButton) {
        let endpointUrl = serverEndpointUrlTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        model?.endpointUrl = endpointUrl

        let primaryExternalMeetingId = primaryExternalMeetingIdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        model?.primaryExternalMeetingId = primaryExternalMeetingId

        self.dismiss(animated: true, completion: nil)
    }

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
