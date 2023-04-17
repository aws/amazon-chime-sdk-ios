//
//  JoinMeetingViewController.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit

class JoinMeetingViewController: UIViewController {

    @IBOutlet weak var meetingIdTextField: UITextField!
    @IBOutlet weak var attendeeNameTextField: UITextField!
    @IBOutlet weak var callKitSwitch: UISwitch!
    
    private let vm = JoinMeetingViewModel()
    
    @IBAction func joinButtonPressed(_ sender: Any) {
        guard let meetingId = self.meetingIdTextField.text else {
            self.showError(message: "Please enter meeting ID")
            return
        }
        guard let attendeeName = self.attendeeNameTextField.text else {
            self.showError(message: "Please enter your name")
            return
        }
        let enableCallKit = self.callKitSwitch.isOn
        
        self.vm.join(meetingId: meetingId,
                     attendeeName: attendeeName,
                     enableCallKit: enableCallKit) {
            self.showMeetingViewController()
        } failed: { error in
            self.showError(message: error.localizedDescription)
        }
    }
    
    private func showMeetingViewController() {
        DispatchQueue.main.async {
            let meetingNavController = self.newMeetingNavController
            (meetingNavController.viewControllers[0] as! MeetingViewController).isCallKitEnabled = self.callKitSwitch.isOn
            meetingNavController.modalPresentationStyle = .fullScreen
            self.present(meetingNavController, animated: true)
        }
    }
}

