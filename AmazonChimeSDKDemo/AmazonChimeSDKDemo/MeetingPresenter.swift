//
//  MeetingPresenter.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit

class MeetingPresenter {
    private static var sharedInstance: MeetingPresenter?
    private let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private var activeMeetingViewController: UIViewController?
    
    static func shared() -> MeetingPresenter {
        if sharedInstance == nil {
            sharedInstance = MeetingPresenter()
        }
        return sharedInstance!
    }

    var rootViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    
    private init() {}

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
    
    func showTestSettingsView(model testSettingsModel: TestSettingsModel) {
        guard let testSettingsVC = mainStoryboard.instantiateViewController(withIdentifier: "testSettings")
            as? TestSettingsViewController, let rootViewController = self.rootViewController else {
            return
        }
        testSettingsVC.modalPresentationStyle = .fullScreen
        testSettingsVC.model = testSettingsModel
        rootViewController.present(testSettingsVC, animated: true) {
            self.activeMeetingViewController = testSettingsVC
        }
    }
    
    func dismissTestSettingsView(model testSettingsModel: TestSettingsModel) {
        guard let activeMeetingViewController = activeMeetingViewController, let rootViewController = self.rootViewController as? JoiningViewController else {
            return
        }
        rootViewController.model = testSettingsModel
        activeMeetingViewController.dismiss(animated: true) {
            self.activeMeetingViewController = nil
        }
    }
}
