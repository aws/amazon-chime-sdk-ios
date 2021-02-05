//
//  TestSettingsViewController.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit

class TestSettingsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var serverEndpointTextField: UITextField!
    @IBOutlet var doneButton: UIButton!
    
    private let meetingPresenter = MeetingPresenter.shared()
    var model: TestSettingsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serverEndpointTextField.delegate = self
        serverEndpointTextField.text = model?.endpointUrl
    }
    
    @IBAction func doneButtonClicked(_: UIButton) {
        let endpointUrl = serverEndpointTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard let model = model else {
            return
        }
        model.endpointUrl = endpointUrl
        meetingPresenter.dismissTestSettingsView(model: model)
    }
}
