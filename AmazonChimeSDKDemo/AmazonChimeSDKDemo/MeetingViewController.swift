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
    @IBOutlet var broadcastButton: UIButton!
    @IBOutlet var broadcastPickerContainerView: UIView!
    @IBOutlet var additionalOptionsButton: UIButton!
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

    // Video Pagination Control
    @IBOutlet var videoPaginationControlView: UIView!
    @IBOutlet var prevVideoPageButton: UIButton!
    @IBOutlet var nextVideoPageButton: UIButton!

    // Metrics
    @IBOutlet var metricsTable: UITableView!

    // Chat View
    @IBOutlet var chatView: UIView!
    @IBOutlet var chatMessageTable: UITableView!
    @IBOutlet var inputBox: UIView!
    @IBOutlet var inputText: UITextField!
    @IBOutlet var sendMessageButton: UIButton!
    @IBOutlet var inputBoxBottomConstrain: NSLayoutConstraint!

    // Captions
    @IBOutlet var captionsTableView: UITableView!

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

    private func registerForKeyboardNotifications() {
        // Adding notifies on keyboard appearing
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(keyboardShowHandler),
                         name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(keyboardHideHandler),
                         name: UIResponder.keyboardWillHideNotification,
                         object: nil)
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
        meetingModel.metricsModel.metricsUpdatedHandler = { [weak self] in
            self?.metricsTable.reloadData()
        }
        meetingModel.videoModel.videoUpdatedHandler = { [weak self, weak meetingModel] in
            guard let strongSelf = self, let meetingModel = meetingModel else { return }
            meetingModel.videoModel.resumeAllRemoteVideosInCurrentPageExceptUserPausedVideos()
            strongSelf.prevVideoPageButton.isEnabled = meetingModel.videoModel.canGoToPrevRemoteVideoPage
            strongSelf.nextVideoPageButton.isEnabled = meetingModel.videoModel.canGoToNextRemoteVideoPage
            strongSelf.videoCollection.reloadData()
        }
        meetingModel.videoModel.localVideoUpdatedHandler = { [weak self] in
            self?.videoCollection?.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
        meetingModel.screenShareModel.tileIdDidSetHandler = { [weak self, weak meetingModel] tileId in
            if let tileId = tileId,
               let screenRenderView = self?.screenRenderView,
               let meetingModel = meetingModel {
                meetingModel.bind(videoRenderView: screenRenderView, tileId: tileId)
            }
        }
        meetingModel.screenShareModel.viewUpdateHandler = { [weak self] shouldShow in
            self?.screenRenderView.isHidden = !shouldShow
            self?.noScreenViewLabel.isHidden = shouldShow
        }

        meetingModel.chatModel.refreshChatTableHandler = { [weak self] in
            self?.chatMessageTable.reloadData()
        }

        meetingModel.captionsModel.refreshCaptionsTableHandler = { [weak self] in
            self?.captionsTableView.reloadData()
            // auto scroll to bottom when new captions come in
            let indexPath = IndexPath(row: meetingModel.captionsModel.captions.count - 1, section: 0)
            self?.captionsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
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
                           endButton,
                           sendMessageButton]
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
        prevVideoPageButton.isEnabled = false
        nextVideoPageButton.isEnabled = false

        if let model = meetingModel, !model.primaryExternalMeetingId.isEmpty {
            meetingModel?.setMute(isMuted: true)
            self.enableOrDisableButtonsForReplicatedMeeting(enabled: false)
        }

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

        // Chat table
        chatMessageTable.delegate = meetingModel?.chatModel
        chatMessageTable.dataSource = meetingModel?.chatModel
        registerForKeyboardNotifications()
        sendMessageButton.isEnabled = false
        chatMessageTable.separatorStyle = .none
        sendMessageButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        setupHideKeyboardOnTap()

        // Captions table
        captionsTableView.delegate = meetingModel?.captionsModel
        captionsTableView.dataSource = meetingModel?.captionsModel
        captionsTableView.separatorStyle = .none

        #if !targetEnvironment(simulator)
            if #available(iOS 12.0, *) {
                setupBroadcastPickerView()
            }
        #endif
    }

    // RPSystemBroadcastPickerView
    @available(iOS 12.0, *)
    private func setupBroadcastPickerView() {
        let pickerViewDiameter: CGFloat = 35
        let pickerView = RPSystemBroadcastPickerView(frame: CGRect(x: 0,
                                                                   y: 0,
                                                                   width: pickerViewDiameter,
                                                                   height: pickerViewDiameter))
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.preferredExtension = AppConfiguration.broadcastBundleId

        // Microphone audio is passed through AudioVideoControllerFacade instead of ContentShareController
        pickerView.showsMicrophoneButton = false

        // We add an action to turn off in app content sharing when user attemp to use broadcast
        for subview in pickerView.subviews {
            if let button = subview as? UIButton {
                button.imageView?.tintColor = .systemBlue
                button.addTarget(self, action: #selector(broadcastButtonTapped), for: .touchUpInside)
            }
        }
        broadcastPickerContainerView.addSubview(pickerView)

        let centerX = NSLayoutConstraint(item: pickerView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: broadcastPickerContainerView,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0)
        broadcastPickerContainerView.addConstraint(centerX)
        let centerY = NSLayoutConstraint(item: pickerView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: broadcastPickerContainerView,
                                         attribute: .centerY,
                                         multiplier: 1,
                                         constant: 0)
        broadcastPickerContainerView.addConstraint(centerY)
        let width = NSLayoutConstraint(item: pickerView,
                                       attribute: .width,
                                       relatedBy: .equal,
                                       toItem: nil,
                                       attribute: .notAnAttribute,
                                       multiplier: 1,
                                       constant: pickerViewDiameter)
        broadcastPickerContainerView.addConstraint(width)
        let height = NSLayoutConstraint(item: pickerView,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1,
                                        constant: pickerViewDiameter)
        broadcastPickerContainerView.addConstraint(height)
        broadcastPickerContainerView.bringSubviewToFront(pickerView)
    }

    private func switchSubview(mode: MeetingModel.ActiveMode) {
        rosterTable.isHidden = true
        videoCollection.isHidden = true
        videoPaginationControlView.isHidden = true
        screenView.isHidden = true
        screenRenderView.isHidden = true
        noScreenViewLabel.isHidden = true
        metricsTable.isHidden = true
        resumeCallKitMeetingButton.isHidden = true
        segmentedControl.isHidden = false
        containerView.isHidden = false
        chatView.isHidden = true
        captionsTableView.isHidden = true
        

        guard let meetingModel = meetingModel else {
            return
        }

        switch mode {
        case .roster:
            rosterTable.reloadData()
            rosterTable.isHidden = false
        case .chat:
            chatMessageTable.reloadData()
            chatView.isHidden = false
        case .video:
            videoCollection.reloadData()
            videoCollection.isHidden = false
            videoPaginationControlView.isHidden = false
        case .screenShare:
            screenView.isHidden = false
            if meetingModel.screenShareModel.isAvailable {
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
            additionalOptionsButton.isEnabled = false
            deviceButton.isEnabled = false
            cameraButton.isEnabled = false
            additionalOptionsButton.isEnabled = false
        case .captions:
            captionsTableView.reloadData()
            captionsTableView.isHidden = false
        }
    }

    // MARK: IBAction functions

    @IBAction func segmentedControlClicked(_: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case SegmentedControlIndex.attendees.rawValue:
            meetingModel?.activeMode = .roster
        case SegmentedControlIndex.chat.rawValue:
            meetingModel?.activeMode = .chat
        case SegmentedControlIndex.video.rawValue:
            meetingModel?.activeMode = .video
        case SegmentedControlIndex.screen.rawValue:
            meetingModel?.activeMode = .screenShare
        case SegmentedControlIndex.captions.rawValue:
            meetingModel?.activeMode = .captions
        case SegmentedControlIndex.metrics.rawValue:
            meetingModel?.activeMode = .metrics
        default:
            return
        }
    }

    @IBAction func muteButtonClicked(_: UIButton) {
        meetingModel?.setMute(isMuted: !muteButton.isSelected)
    }

    @IBAction func additionalOptionsButtonClicked(_ sender: UIButton) {
        guard let meetingModel = meetingModel else {
            return
        }
        let optionMenu = UIAlertController(title: nil, message: "Additional Options", preferredStyle: .actionSheet)

        if !meetingModel.primaryExternalMeetingId.isEmpty {
            let primaryMeetingPromotionTitle = meetingModel.isPromotedToPrimaryMeeting
                ? "Demote from Primary meeting" : "Promote to Primary meeting"
            let primaryMeetingPromotionAction = UIAlertAction(title: primaryMeetingPromotionTitle,
                                                              style: .default,
                                                              handler: { _ in self.togglePrimaryMeetingPromotion() })
            optionMenu.addAction(primaryMeetingPromotionAction)
        }

        if meetingModel.primaryExternalMeetingId.isEmpty || meetingModel.isPromotedToPrimaryMeeting {
            let isVoiceFocusEnabled = meetingModel.isVoiceFocusEnabled()
            let nextVoiceFocusStatus = nextOnOrOff(current: isVoiceFocusEnabled)
            let voiceFocusAction = UIAlertAction(title: "Turn \(nextVoiceFocusStatus) Voice Focus",
                                                 style: .default,
                                                 handler: { _ in
                                                    meetingModel.setVoiceFocusEnabled(enabled: !isVoiceFocusEnabled)
                                                 })
            optionMenu.addAction(voiceFocusAction)

            // We can only access torch and apply filter on external video source
            if meetingModel.videoModel.isUsingExternalVideoSource {
                let isTorchOn = meetingModel.videoModel.customSource.torchEnabled
                let nextTorchStatus = nextOnOrOff(current: isTorchOn)
                let torchAction = UIAlertAction(title: "Turn \(nextTorchStatus) flashlight",
                                                style: .default,
                                                handler: { _ in
                                                    self.toggleTorch(nextStatus: nextTorchStatus)
                                                })
                optionMenu.addAction(torchAction)

                let isGpuFilterOn = meetingModel.videoModel.isUsingCoreImageVideoProcessor
                let nextGpuFilterStatus = nextOnOrOff(current: isGpuFilterOn)
                let gpuFilterAction = UIAlertAction(title: "Turn \(nextGpuFilterStatus) Core Image video filter",
                                                    style: .default,
                                                    handler: { _ in
                                                        self.toggleCoreImageFilter(nextStatus: nextGpuFilterStatus)
                                                    })
                optionMenu.addAction(gpuFilterAction)

                let isCpuFilterOn = meetingModel.videoModel.isUsingMetalVideoProcessor
                let nextCpuFilterStatus = nextOnOrOff(current: isCpuFilterOn)
                let cpuFilterAction = UIAlertAction(title: "Turn \(nextCpuFilterStatus) Metal video filter",
                                                    style: .default,
                                                    handler: { _ in
                                                        self.toggleMetalFilter(nextStatus: nextCpuFilterStatus)
                                                    })
                optionMenu.addAction(cpuFilterAction)
            }

            let nextSourceType = meetingModel.videoModel.isUsingExternalVideoSource ? "internal" : "external"
            let customSourceAction = UIAlertAction(title: "Use \(nextSourceType) camera source",
                                                   style: .default,
                                                   handler: { _ in
                                                        self.toggleCustomCameraSource(nextSourceType: nextSourceType)
                                                   })
            optionMenu.addAction(customSourceAction)

            #if !targetEnvironment(simulator)
                let inAppContentShareTitle = meetingModel.screenShareModel.inAppCaptureModel.isSharing ?
                    "Stop sharing content" : "Share in app content"
                let inAppContentShareAction = UIAlertAction(title: inAppContentShareTitle,
                                                            style: .default,
                                                            handler: { _ in self.toggleInAppContentShare() })
                optionMenu.addAction(inAppContentShareAction)
            #endif
        }

        if meetingModel.primaryExternalMeetingId.isEmpty {
            // Only show for normal or primary meeting attendees
            let isLiveTranscriptionEnabled = meetingModel.captionsModel.isLiveTranscriptionEnabled
            let nextLiveTranscriptionStatus = nextOnOrOff(current: isLiveTranscriptionEnabled)
            let liveTranscriptionAction = UIAlertAction(title: "Turn \(nextLiveTranscriptionStatus) Live Transcription",
                                                 style: .default,
                                                 handler: { _ in
                                                    meetingModel.setLiveTranscriptionEnabled(enabled: !isLiveTranscriptionEnabled)
                                                 })
            optionMenu.addAction(liveTranscriptionAction)
        }


        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(cancelAction)

        if let popover = optionMenu.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
        }

        present(optionMenu, animated: true, completion: nil)
    }

    @IBAction func deviceButtonClicked(_ sender: UIButton) {
        guard let meetingModel = meetingModel else {
            return
        }

        let optionMenu = UIAlertController(title: nil, message: "Choose Audio Device", preferredStyle: .actionSheet)
        let currentAudioDevice = meetingModel.currentAudioDevice
        for inputDevice in meetingModel.audioDevices {
            var label = inputDevice.label
            if let selectedAudioDevice = currentAudioDevice {
                if selectedAudioDevice.label == inputDevice.label {
                    label = "\(label) ✔︎"
                }
            }
            let deviceAction = UIAlertAction(title: label,
                                             style: .default,
                                             handler: { _ in meetingModel.chooseAudioDevice(inputDevice)
            })
            optionMenu.addAction(deviceAction)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(cancelAction)

        if let popover = optionMenu.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
        }

        present(optionMenu, animated: true, completion: nil)
    }

    @IBAction func cameraButtonClicked(_: UIButton) {
        cameraButton.isSelected.toggle()
        meetingModel?.videoModel.isLocalVideoActive = cameraButton.isSelected
    }

    @IBAction func leaveButtonClicked(_: UIButton) {
        meetingModel?.endMeeting()
        deregisterFromKeyboardNotifications()
    }

    @IBAction func inputTextChanged(_: Any, forEvent _: UIEvent) {
        guard let text = inputText.text else {
            return
        }
        if let model = meetingModel, !model.primaryExternalMeetingId.isEmpty && !model.isPromotedToPrimaryMeeting {
            return
        }
        sendMessageButton.isEnabled = !text.isEmpty
    }

    @IBAction func sendMessageButtonClicked(_: Any) {
        guard let text = inputText.text else {
            return
        }

        meetingModel?.sendDataMessage(text)
        self.inputText.text = ""
        sendMessageButton.isEnabled = false
    }

    @IBAction func resumeCallKitMeetingButtonClicked(_: UIButton) {
        meetingModel?.resumeCallKitMeeting()
    }

    @IBAction func prevPageButtonClicked(_: UIButton) {
        meetingModel?.videoModel.getPreviousRemoteVideoPage()
        meetingModel?.videoModel.videoUpdatedHandler?()
    }

    @IBAction func nextPageButtonClicked(_: UIButton) {
        meetingModel?.videoModel.getNextRemoteVideoPage()
        meetingModel?.videoModel.videoUpdatedHandler?()
    }

    @objc private func keyboardShowHandler(notification: NSNotification) {
        // Need to calculate keyboard exact size due to Apple suggestions
        guard let info: NSDictionary = notification.userInfo as NSDictionary? else {
            return
        }
        guard let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else {
            return
        }

        let viewHeight = view.frame.size.height
        let realOrigin = chatView.convert(inputBox.frame.origin, to: view)
        let inputBoxDistanceToBottom = viewHeight - realOrigin.y - inputBox.frame.height
        self.inputBoxBottomConstrain.constant = keyboardSize.height - inputBoxDistanceToBottom
    }

    @objc private func keyboardHideHandler(notification _: NSNotification) {
        self.inputBoxBottomConstrain.constant = 0
    }

    @objc private func broadcastButtonTapped() {
        meetingModel?.screenShareModel.broadcastCaptureModel.isBlocked = false
        meetingModel?.screenShareModel.inAppCaptureModel.isSharing = false
    }

    @objc private func toggleInAppContentShare() {
        let isOn = meetingModel?.screenShareModel.inAppCaptureModel.isSharing ?? false
        let nextStateString = isOn ? "off" : "on"
        logger.info(msg: "Turning \(nextStateString) in app content share")
        guard let meetingModel = meetingModel else {
            return
        }
        if #available(iOS 11.0, *) {
            meetingModel.screenShareModel.inAppCaptureModel.isSharing.toggle()
        } else {
            meetingModel.notifyHandler?("In App Content Share is only available on iOS 11+")
        }
    }

    @objc private func toggleTorch(nextStatus: String) {
        logger.info(msg: "Turning \(nextStatus) torch")
        guard let meetingModel = meetingModel else {
            return
        }
        if !meetingModel.videoModel.toggleTorch() {
            meetingModel.notifyHandler?("Failed to turn \(nextStatus) torch on current camera; torch may not be available")
        }
    }

    @objc private func toggleCoreImageFilter(nextStatus: String) {
        logger.info(msg: "Turning \(nextStatus) CoreImage filter")
        guard let meetingModel = meetingModel else {
            return
        }
        if meetingModel.videoModel.isUsingMetalVideoProcessor {
            meetingModel.notifyHandler?("Cannot toggle both filters on at same time")
            return
        }

        meetingModel.videoModel.isUsingCoreImageVideoProcessor.toggle()
    }

    @objc private func toggleMetalFilter(nextStatus: String) {
        logger.info(msg: "Turning \(nextStatus) Metal filter")
        guard let meetingModel = meetingModel else {
            return
        }
        // See comments in MetalVideoProcessor
        guard let device = MTLCreateSystemDefaultDevice(), device.supportsFeatureSet(.iOS_GPUFamily2_v1) else {
            meetingModel.notifyHandler?("Cannot turn \(nextStatus) Metal filter because it's not available on this device")
            return
        }
        if meetingModel.videoModel.isUsingCoreImageVideoProcessor {
            meetingModel.notifyHandler?("Cannot toggle both filters on at same time")
            return
        }
        meetingModel.videoModel.isUsingMetalVideoProcessor.toggle()
    }

    @objc private func toggleCustomCameraSource(nextSourceType: String) {
        logger.info(msg: "Selecting \(nextSourceType) camera source")
        guard let meetingModel = meetingModel else {
            return
        }
        meetingModel.videoModel.isUsingExternalVideoSource.toggle()
    }

    @objc private func togglePrimaryMeetingPromotion() {
        guard let meetingModel = meetingModel else {
            return
        }
        if !meetingModel.isPromotedToPrimaryMeeting {
            if let credentials = meetingModel.primaryMeetingMeetingSessionCredentials {
                // Reuse previously retrieved crednetials
                meetingModel.videoModel.promoteToPrimaryMeeting(
                    credentials: credentials, observer: self)
            } else {
                JoinRequestService.postJoinRequest(meetingId: meetingModel.primaryExternalMeetingId,
                                                   name: "promoted-\(meetingModel.selfName)",
                                                   overriddenEndpoint: MeetingModule.shared().cachedOverriddenEndpoint,
                                                   primaryExternalMeetingId: "")
                { joinMeetingResponse in
                    if let joinMeetingResponse = joinMeetingResponse {
                        self.logger.info(msg: "Attempting to promote to primary meeting")
                        let meetingResp = JoinRequestService.getCreateMeetingResponse(from: joinMeetingResponse)
                        let attendeeResp = JoinRequestService.getCreateAttendeeResponse(from: joinMeetingResponse)
                        let meetingSessionConfiguration = MeetingSessionConfiguration(
                            createMeetingResponse: meetingResp,
                            createAttendeeResponse: attendeeResp,
                            urlRewriter: { (url: String) -> String in return url })
                        meetingModel.primaryMeetingMeetingSessionCredentials = meetingSessionConfiguration.credentials
                        meetingModel.videoModel.promoteToPrimaryMeeting(
                            credentials: meetingSessionConfiguration.credentials, observer: self)
                    }
                }
            }
        } else {
            meetingModel.videoModel.demoteFromPrimaryMeeting()
        }
    }
    
    private func enableOrDisableButtonsForReplicatedMeeting(enabled: Bool) {
        muteButton.isEnabled = enabled
        cameraButton.isEnabled = enabled
        sendMessageButton.isEnabled = enabled
        muteButton.isEnabled = enabled
        broadcastButton.isEnabled = enabled
    }

    private func nextOnOrOff(current: Bool) -> String {
        return current ? "off" : "on"
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
        let attendeeId = meetingModel.getVideoTileAttendeeId(for: indexPath)

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoTileCellReuseIdentifier,
                                                            for: indexPath) as? VideoTileCell else {
            return VideoTileCell()
        }

        cell.updateCell(id: attendeeId,
                        name: displayName,
                        isSelf: isSelf,
                        videoTileState: videoTileState,
                        tag: indexPath.row)
        cell.delegate = meetingModel.videoModel
        cell.viewController = self

        if let tileState = videoTileState {
            if tileState.isLocalTile, !tileState.isContent, meetingModel.videoModel.isFrontCameraActive {
                cell.videoRenderView.mirror = true
            }
            meetingModel.bind(videoRenderView: cell.videoRenderView, tileId: tileState.tileId)
        }
        return cell
    }
}

// MARK: PrimaryMeetingPromotionObserver

extension MeetingViewController: PrimaryMeetingPromotionObserver {
    func didPromoteToPrimaryMeeting(status: MeetingSessionStatus) {
        guard let meetingModel = meetingModel else {
            return
        }
        self.logger.info(msg: "Primary meeting promotion completed with status \(status.statusCode.description)")
        if status.statusCode == MeetingSessionStatusCode.ok {
            self.view.makeToast("Successfully promote to primary meeting")
            meetingModel.isPromotedToPrimaryMeeting = true
            self.enableOrDisableButtonsForReplicatedMeeting(enabled: true)
        } else {
            self.view.makeToast("Failed to promote to primary meeting")
            meetingModel.isPromotedToPrimaryMeeting = false
            self.enableOrDisableButtonsForReplicatedMeeting(enabled: false)
        }
    }

    func didDemoteFromPrimaryMeeting(status: MeetingSessionStatus) {
        guard let meetingModel = meetingModel else {
            return
        }
        self.logger.info(msg: "Primary meeting demotion completed with status \(status.statusCode.description)")
        meetingModel.isPromotedToPrimaryMeeting = false
        self.enableOrDisableButtonsForReplicatedMeeting(enabled: false)
    }
}
