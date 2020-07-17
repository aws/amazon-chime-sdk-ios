//
//  MeetingViewController.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import AVFoundation
import CallKit
import Foundation
import Toast
import UIKit

class MeetingViewController: UIViewController {
    // Controls
    @IBOutlet var controlView: UIView!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var deviceButton: UIButton!
    @IBOutlet var endButton: UIButton!
    @IBOutlet var muteButton: UIButton!
    @IBOutlet var resumeCallKitMeetingButton: UIButton!
    @IBOutlet var segmentedControl: UISegmentedControl!

    // Accessory views
    @IBOutlet var containerView: UIView!
    @IBOutlet var titleView: UIView!
    @IBOutlet var titleLabel: UILabel!

    // Screen share
    @IBOutlet var screenView: UIView!
    @IBOutlet var noScreenViewLabel: UILabel!
    @IBOutlet var screenRenderView: DefaultVideoRenderView!

    // Roster
    @IBOutlet var rosterTable: UITableView!

    // Video
    @IBOutlet var videoCollection: UICollectionView!

    // Metrics
    @IBOutlet var metricsTable: UITableView!

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

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let layout = videoCollection.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        if UIDevice.current.orientation.isLandscape {
            layout.scrollDirection = .horizontal
        } else {
            layout.scrollDirection = .vertical
        }
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
        meetingModel.isEndedHandler = { [weak self] in
            DispatchQueue.main.async {
                self?.dismiss(animated: true, completion: nil)
            }
        }
        meetingModel.rosterModel.rosterUpdatedHandler = { [weak self] in
            self?.rosterTable.reloadData()
        }
        meetingModel.metricsModel.metricsUpdatedHandler = { [weak self] in
            self?.metricsTable.reloadData()
        }
        meetingModel.videoModel.videoUpdatedHandler = { [weak self] in
            self?.videoCollection.reloadData()
        }
        meetingModel.videoModel.localVideoUpdatedHandler = { [weak self] in
            self?.videoCollection?.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
        meetingModel.screenShareModel.tileIdDidSetHandler = { [weak self] tileId in
            if let tileId = tileId, let screenRenderView = self?.screenRenderView {
                meetingModel.bind(videoRenderView: screenRenderView, tileId: tileId)
            }
        }
        meetingModel.screenShareModel.viewUpdateHandler = { [weak self] shouldShow in
            self?.screenRenderView.isHidden = !shouldShow
            self?.noScreenViewLabel.isHidden = shouldShow
        }
    }

    // MARK: UI functions

    private func setupUI() {
        // Labels
        titleLabel.text = meetingModel?.meetingId
        titleLabel.accessibilityLabel = "Meeting ID \(meetingModel?.meetingId ?? "")"

        // Buttons
        let buttonStack = [muteButton, deviceButton, cameraButton, endButton]
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

        // Segmented Controler
        segmentedControl.selectedSegmentIndex = SegmentedControlIndex.attendees.rawValue

        // Roster table view
        rosterTable.delegate = meetingModel?.rosterModel
        rosterTable.dataSource = meetingModel?.rosterModel

        // Video collection view
        videoCollection.delegate = self
        videoCollection.dataSource = self

        // Metrics table view
        metricsTable.delegate = meetingModel?.metricsModel
        metricsTable.dataSource = meetingModel?.metricsModel
    }

    private func switchSubview(mode: MeetingModel.ActiveMode) {
        rosterTable.isHidden = true
        videoCollection.isHidden = true
        screenView.isHidden = true
        screenRenderView.isHidden = true
        noScreenViewLabel.isHidden = true
        metricsTable.isHidden = true
        resumeCallKitMeetingButton.isHidden = true
        segmentedControl.isHidden = false
        containerView.isHidden = false
        muteButton.isEnabled = true
        deviceButton.isEnabled = true
        cameraButton.isEnabled = true

        switch mode {
        case .roster:
            rosterTable.reloadData()
            rosterTable.isHidden = false
        case .video:
            videoCollection.reloadData()
            videoCollection.isHidden = false
        case .screenShare:
            screenView.isHidden = false
            if meetingModel?.screenShareModel.isAvailable ?? false {
                screenRenderView.isHidden = false
            } else {
                noScreenViewLabel.isHidden = false
            }
        case .metrics:
            metricsTable.reloadData()
            metricsTable.isHidden = false
        case .callKitOnHold:
            resumeCallKitMeetingButton.isHidden = false
            segmentedControl.isHidden = true
            containerView.isHidden = true
            muteButton.isEnabled = false
            deviceButton.isEnabled = false
            cameraButton.isEnabled = false
        }
    }

    // MARK: IBAction functions

    @IBAction func segmentedControlClicked(_: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case SegmentedControlIndex.attendees.rawValue:
            meetingModel?.activeMode = .roster
        case SegmentedControlIndex.video.rawValue:
            meetingModel?.activeMode = .video
        case SegmentedControlIndex.screen.rawValue:
            meetingModel?.activeMode = .screenShare
        case SegmentedControlIndex.metrics.rawValue:
            meetingModel?.activeMode = .metrics
        default:
            return
        }
    }

    @IBAction func muteButtonClicked(_: UIButton) {
        meetingModel?.setMute(isMuted: !muteButton.isSelected)
    }

    @IBAction func deviceButtonClicked(_: UIButton) {
        guard let meetingModel = meetingModel else {
            return
        }
        let optionMenu = UIAlertController(title: nil, message: "Choose Audio Device", preferredStyle: .actionSheet)

        for inputDevice in meetingModel.audioDevices {
            let deviceAction = UIAlertAction(title: inputDevice.label,
                                             style: .default,
                                             handler: { _ in meetingModel.chooseAudioDevice(inputDevice)
                })
            optionMenu.addAction(deviceAction)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(cancelAction)

        present(optionMenu, animated: true, completion: nil)
    }

    @IBAction func cameraButtonClicked(_: UIButton) {
        cameraButton.isSelected = !cameraButton.isSelected
        meetingModel?.isLocalVideoActive = cameraButton.isSelected
    }

    @IBAction func leaveButtonClicked(_: UIButton) {
        meetingModel?.endMeeting()
    }

    @IBAction func resumeCallKitMeetingButtonClicked(_: UIButton) {
        meetingModel?.resumeCallKitMeeting()
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

// MARK: UICollectionViewDataSource

extension MeetingViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        // Only one section for all video tiles
        return 1
    }

    func collectionView(_: UICollectionView,
                        numberOfItemsInSection _: Int) -> Int {
        guard let meetingModel = meetingModel else {
            return 0
        }
        return meetingModel.videoModel.videoTileCount
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let meetingModel = meetingModel, indexPath.item < meetingModel.videoModel.videoTileCount else {
            return UICollectionViewCell()
        }
        let isSelf = indexPath.item == 0
        let videoTileState = meetingModel.videoModel.getVideoTileState(for: indexPath)
        let displayName = meetingModel.getVideoTileDisplayName(for: indexPath)
        let isVideoActive = (videoTileState != nil)

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoTileCellReuseIdentifier,
                                                            for: indexPath) as? VideoTileCell else {
            return VideoTileCell()
        }

        cell.updateCell(name: displayName,
                        isSelf: isSelf,
                        isVideoActive: isVideoActive,
                        tag: indexPath.row)
        cell.delegate = meetingModel.videoModel

        if let tileState = videoTileState {
            if tileState.isLocalTile, meetingModel.isFrontCameraActive {
                cell.videoRenderView.mirror = true
            }
            meetingModel.bind(videoRenderView: cell.videoRenderView, tileId: tileState.tileId)
        }

        return cell
    }
}
