//
//  MeetingViewController.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//
// swiftlint:disable type_body_length

import AmazonChimeSDK
import AVFoundation
import CallKit
import Foundation
import ReplayKit
import Toast
import UIKit

class MeetingViewController: UIViewController {

    // Controls
    @IBOutlet var controlView: UIView!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var deviceButton: UIButton!
    @IBOutlet var additionalOptionsButton: UIButton!
    @IBOutlet var endButton: UIButton!
    @IBOutlet var muteButton: UIButton!
    @IBOutlet var resumeCallKitMeetingButton: UIButton!

    // Accessory views
    @IBOutlet var containerView: UIView!
    @IBOutlet var titleView: UIView!
    @IBOutlet var titleLabel: UILabel!

    // Roster
    @IBOutlet var rosterTable: UITableView!

    // Model
    var meetingModel: MeetingModel?

    // Local var
    private let logger = ConsoleLogger(name: "MeetingViewController")

    // MARK: Override functions

    override func viewDidLoad() {
        guard let meetingModel = meetingModel else {
            logger.error(msg: "MeetingModel not set")
            dismiss(animated: true, completion: nil)
            return
        }
        configure(meetingModel: meetingModel)
        super.viewDidLoad()
        setupUI()

        meetingModel.startMeeting()
    }

    private func registerForKeyboardNotifications() {
        // Adding notifies on keyboard appearing
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(keyboardShowHandler),
                         name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    private func deregisterFromKeyboardNotifications() {
        // Removing notifies on keyboard appearing
        NotificationCenter
            .default
            .removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter
            .default
            .removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func configure(meetingModel: MeetingModel) {
        meetingModel.activeModeDidSetHandler = { [weak self] activeMode in
            self?.switchSubview(mode: activeMode)
        }
        meetingModel.notifyHandler = { [weak self] message in
            self?.view?.makeToast(message, duration: 2.0, position: .top)
        }
        meetingModel.isMutedHandler = { [weak self] isMuted in
            self?.muteButton.isSelected = isMuted
        }
        meetingModel.isEndedHandler = { [weak meetingModel] in
            DispatchQueue.main.async {
                guard let meetingModel = meetingModel else { return }
                MeetingModule.shared().dismissMeeting(meetingModel)
            }
        }
        meetingModel.rosterModel.rosterUpdatedHandler = { [weak self] in
            self?.rosterTable.reloadData()
        }
    }

    // MARK: UI functions

    private func setupUI() {
        // Labels
        titleLabel.text = meetingModel?.meetingId
        titleLabel.accessibilityLabel = "Meeting ID \(meetingModel?.meetingId ?? "")"

        // Buttons
        let buttonStack = [muteButton,
                           deviceButton,
                           cameraButton,
                           additionalOptionsButton,
                           endButton]
        for button in buttonStack {
            let normalButtonImage = button?.image(for: .normal)?.withRenderingMode(.alwaysTemplate)
            let selectedButtonImage = button?.image(for: .selected)?.withRenderingMode(.alwaysTemplate)
            button?.setImage(normalButtonImage, for: .normal)
            button?.setImage(selectedButtonImage, for: .selected)
            button?.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
            button?.tintColor = .systemBlue
        }
        endButton.tintColor = .red
        resumeCallKitMeetingButton.isHidden = true
        // Roster table view
        rosterTable.delegate = meetingModel?.rosterModel
        rosterTable.dataSource = meetingModel?.rosterModel
    }

    private func switchSubview(mode: MeetingModel.ActiveMode) {
        rosterTable.isHidden = true
        resumeCallKitMeetingButton.isHidden = true
        containerView.isHidden = false

        switch mode {
        case .roster:
            rosterTable.reloadData()
            rosterTable.isHidden = false
        case .callKitOnHold:
            resumeCallKitMeetingButton.isHidden = false
            containerView.isHidden = true
            muteButton.isEnabled = false
            additionalOptionsButton.isEnabled = false
            deviceButton.isEnabled = false
            cameraButton.isEnabled = false
            additionalOptionsButton.isEnabled = false
        }
    }

    // MARK: IBAction functions

    @IBAction func muteButtonClicked(_: UIButton) {
        meetingModel?.setMute(isMuted: !muteButton.isSelected)
    }

    @IBAction func leaveButtonClicked(_: UIButton) {
        meetingModel?.endMeeting()
        deregisterFromKeyboardNotifications()
    }

    @IBAction func resumeCallKitMeetingButtonClicked(_: UIButton) {
        meetingModel?.resumeCallKitMeeting()
    }

    @objc private func keyboardShowHandler(notification: NSNotification) {
        // Need to calculate keyboard exact size due to Apple suggestions
        guard let info: NSDictionary = notification.userInfo as NSDictionary? else {
            return
        }
        guard ((info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size) != nil else {
            return
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension MeetingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView,
                        layout _: UICollectionViewLayout,
                        sizeForItemAt _: IndexPath) -> CGSize {
        var width = view.frame.width
        var height = view.frame.height
        if UIApplication.shared.statusBarOrientation.isLandscape {
            height /= 2.0
            width = height / 9.0 * 16.0
        } else {
            height = width / 16.0 * 9.0
        }
        return CGSize(width: width, height: height)
    }

    func collectionView(_: UICollectionView,
                        layout _: UICollectionViewLayout,
                        insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_: UICollectionView,
                        layout _: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 8
    }
}
