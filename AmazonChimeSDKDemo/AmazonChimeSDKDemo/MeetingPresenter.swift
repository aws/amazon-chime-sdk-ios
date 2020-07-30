//
//  MeetingPresenter.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit

class MeetingPresenter {
    private let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private var activeMeetingViewController: MeetingViewController?

    var rootViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }

    func showMeetingView(meetingModel: MeetingModel, completion: @escaping (Bool) -> Void) {
        guard let meetingViewController = mainStoryboard.instantiateViewController(withIdentifier: "meeting")
            as? MeetingViewController, let rootViewController = self.rootViewController else {
            completion(false)
            return
        }
        meetingViewController.modalPresentationStyle = .fullScreen
        meetingViewController.meetingModel = meetingModel
        rootViewController.present(meetingViewController, animated: true) {
            self.activeMeetingViewController = meetingViewController
            completion(true)
        }
    }

    func dismissActiveMeetingView(completion: @escaping () -> Void) {
        guard let activeMeetingViewController = activeMeetingViewController else {
            completion()
            return
        }
        activeMeetingViewController.dismiss(animated: true) {
            self.activeMeetingViewController = nil
            completion()
        }
    }
}
