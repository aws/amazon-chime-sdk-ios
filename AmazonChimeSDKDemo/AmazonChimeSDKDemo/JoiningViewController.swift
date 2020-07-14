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

    private let logger = ConsoleLogger(name: "JoiningViewController")
    private let toastDisplayDuration = 2.0
    private let incomingCallKitDelay = 10.0

    override func viewDidLoad() {
        super.viewDidLoad()
        meetingIdTextField.delegate = self
        nameTextField.delegate = self

        setupHideKeyboardOnTap()
        versionLabel.text = "amazon-chime-sdk-ios@\(Versioning.sdkVersion())"
    }

    override func viewWillAppear(_: Bool) {
        setJoinButtons(isEnabled: true)
    }

    @IBAction func joinWithoutCallKitButtonClicked(_: UIButton) {
        joinMeeting(callKitOption: .disabled)
    }

    @IBAction func joinAsIncomingCallButton(_: UIButton) {
        joinMeeting(callKitOption: .incoming)
    }

    @IBAction func joinAsOutgoingCallButton(_: UIButton) {
        joinMeeting(callKitOption: .outgoing)
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

        setJoinButtons(isEnabled: false)

        JoinRequestService.postJoinRequest(meetingId: meetingId, name: name) { meetingSessionConfig in
            guard let meetingSessionConfig = meetingSessionConfig else {
                DispatchQueue.main.async {
                    self.view.makeToast("Unable to join meeting please try different meeting ID",
                                        duration: self.toastDisplayDuration)
                    self.setJoinButtons(isEnabled: true)
                }
                return
            }
            DispatchQueue.main.async {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                guard let meetingViewController = mainStoryboard.instantiateViewController(withIdentifier: "meeting")
                    as? MeetingViewController else {
                    self.logger.error(msg: "Unable to instantitate MeetingViewController")
                    return
                }
                let meetingModel = MeetingModel(meetingSessionConfig: meetingSessionConfig,
                                                meetingId: meetingId,
                                                selfName: name,
                                                callKitOption: callKitOption)
                meetingViewController.meetingModel = meetingModel
                meetingViewController.modalPresentationStyle = .fullScreen

                if callKitOption == .incoming {
                    let backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.incomingCallKitDelay) {
                        self.present(meetingViewController, animated: true) {
                            UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                        }
                    }
                    self.view.makeToast("You can background the app or lock screen while waiting",
                                        duration: self.incomingCallKitDelay)
                } else {
                    self.present(meetingViewController, animated: true, completion: nil)
                }
            }
        }
    }
}
