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
    private var activeMeetingViewController: UIViewController?

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

    func showDeviceSelectionView(meetingModel: MeetingModel, completion: @escaping (Bool) -> Void) {
        guard let deviceSelectionVC = mainStoryboard.instantiateViewController(withIdentifier: "deviceSelection")
            as? DeviceSelectionViewController, let rootViewController = self.rootViewController else {
            completion(false)
            return
        }
        deviceSelectionVC.modalPresentationStyle = .fullScreen
        deviceSelectionVC.model = meetingModel.deviceSelectionModel
        rootViewController.present(deviceSelectionVC, animated: true) {
            self.activeMeetingViewController = deviceSelectionVC
            completion(true)
        }
    }
    
    func showLiveTranscriptionView(meetingModel: MeetingModel, completion: @escaping (Bool) -> Void) {
        guard let liveTranscriptionVC = mainStoryboard.instantiateViewController(withIdentifier: "liveTranscription")
                as? LiveTranscriptionOptionsViewController, let rootViewController = self.activeMeetingViewController else {
            completion(false)
            return
        }
        liveTranscriptionVC.modalPresentationStyle = .pageSheet
        liveTranscriptionVC.model = meetingModel
        rootViewController.present(liveTranscriptionVC, animated: true) {
            completion(true)
        }
    }
    
    func dismissLiveTranscriptionView(_ liveTranscriptionVC: LiveTranscriptionOptionsViewController, completion: @escaping (Bool) -> Void) {
        liveTranscriptionVC.dismiss(animated: true) {}
    }
}
