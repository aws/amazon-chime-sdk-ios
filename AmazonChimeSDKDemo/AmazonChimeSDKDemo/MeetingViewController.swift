//
//  MeetingViewController.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import AVFoundation
import Foundation
import Toast
import UIKit

class MeetingViewController: UIViewController {
    // Controls
    @IBOutlet var controlView: UIView!
    @IBOutlet var rosterButton: UIButton!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var deviceButton: UIButton!
    @IBOutlet var endButton: UIButton!
    @IBOutlet var metricsButton: UIButton!
    @IBOutlet var muteButton: UIButton!
    @IBOutlet var screenButton: UIButton!

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

    // Models
    private let rosterModel = RosterModel()
    private let videoModel = VideoModel()
    private let metricsModel = MetricsModel()

    // Dependencies
    public var meetingSessionConfig: MeetingSessionConfiguration?
    public var meetingId: String?
    public var selfName: String?
    public var callKitOption: CallKitOption = .disabled

    // Local var
    private var currentMeetingSession: MeetingSession?
    private var isFullScreen = false

    // Utils
    private let dispatchGroup = DispatchGroup()
    private let jsonDecoder = JSONDecoder()
    private let logger = ConsoleLogger(name: "MeetingViewController")
    private let uuid = UUID().uuidString

    // MARK: Override functions

    override func viewDidLoad() {
        guard let meetingSessionConfig = meetingSessionConfig else {
            logger.error(msg: "Unable to get meeting session")
            return
        }

        super.viewDidLoad()
        setupUI()

        DispatchQueue.global(qos: .background).async {
            self.currentMeetingSession = DefaultMeetingSession(
                configuration: meetingSessionConfig, logger: self.logger
            )
            self.setupAudioEnv(isCallKitEnabled: self.callKitOption != .disabled)
            DispatchQueue.main.async {
                self.startRemoteVideo()
            }
        }
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
            isFullScreen = false
            controlView.isHidden = false
        }
    }

    private func setupAudioEnv(isCallKitEnabled: Bool) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord,
                                                            options: AVAudioSession.CategoryOptions.allowBluetooth)
            setupSubscriptionToAttendeeChangeHandler()
            try currentMeetingSession?.audioVideo.start(callKitEnabled: isCallKitEnabled)
        } catch PermissionError.audioPermissionError {
            let audioPermission = AVAudioSession.sharedInstance().recordPermission
            if audioPermission == .denied {
                logger.error(msg: "User did not grant audio permission, it should redirect to Settings")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    if granted {
                        self.setupAudioEnv(isCallKitEnabled: isCallKitEnabled)
                    } else {
                        self.logger.error(msg: "User did not grant audio permission")
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        } catch {
            logger.error(msg: "Error starting the Meeting: \(error.localizedDescription)")
            leaveMeeting()
        }
    }

    private func setupVideoEnv() {
        do {
            try currentMeetingSession?.audioVideo.startLocalVideo()
        } catch PermissionError.videoPermissionError {
            let videoPermission = AVCaptureDevice.authorizationStatus(for: .video)
            if videoPermission == .denied {
                logger.error(msg: "User did not grant video permission, it should redirect to Settings")
                notify(msg: "You did not grant video permission, Please go to Settings and change it")
            } else {
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.setupVideoEnv()
                    } else {
                        self.logger.error(msg: "User did not grant video permission")
                        self.notify(msg: "You did not grant video permission, Please go to Settings and change it")
                    }
                }
            }
        } catch {
            logger.error(msg: "Error starting the Meeting: \(error.localizedDescription)")
            leaveMeeting()
        }
    }

    func setupSubscriptionToAttendeeChangeHandler() {
        guard let audioVideo = currentMeetingSession?.audioVideo else {
            return
        }
        audioVideo.addVideoTileObserver(observer: self)
        audioVideo.addRealtimeObserver(observer: self)
        audioVideo.addAudioVideoObserver(observer: self)
        audioVideo.addMetricsObserver(observer: self)
        audioVideo.addDeviceChangeObserver(observer: self)
        audioVideo.addActiveSpeakerObserver(policy: DefaultActiveSpeakerPolicy(),
                                            observer: self)
    }

    func removeSubscriptionToAttendeeChangeHandler() {
        guard let audioVideo = currentMeetingSession?.audioVideo else {
            return
        }
        audioVideo.removeVideoTileObserver(observer: self)
        audioVideo.removeRealtimeObserver(observer: self)
        audioVideo.removeAudioVideoObserver(observer: self)
        audioVideo.removeMetricsObserver(observer: self)
        audioVideo.removeDeviceChangeObserver(observer: self)
        audioVideo.removeActiveSpeakerObserver(observer: self)
    }

    private func notify(msg: String) {
        logger.info(msg: msg)
        view.makeToast(msg, duration: 2.0)
    }

    // MARK: UI functions

    private func setupUI() {
        // Labels
        titleLabel.text = meetingId
        titleLabel.accessibilityLabel = "Meeting ID \(meetingId ?? "")"

        // Buttons
        let buttonStack = [muteButton, deviceButton, cameraButton, screenButton, rosterButton, endButton, metricsButton]
        for button in buttonStack {
            let normalButtonImage = button?.image(for: .normal)?.withRenderingMode(.alwaysTemplate)
            let selectedButtonImage = button?.image(for: .selected)?.withRenderingMode(.alwaysTemplate)
            button?.setImage(normalButtonImage, for: .normal)
            button?.setImage(selectedButtonImage, for: .selected)
            button?.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
            button?.tintColor = .systemGray
        }
        endButton.tintColor = .red

        // Views
        let tap = UITapGestureRecognizer(target: self, action: #selector(setFullScreen(_:)))
        containerView.addGestureRecognizer(tap)

        // States
        showVideoOrScreen(isVideo: true)

        // Roster table view
        rosterTable.delegate = rosterModel
        rosterTable.dataSource = rosterModel

        // Video collection view
        videoCollection.delegate = self
        videoCollection.dataSource = videoModel
        videoModel.delegate = self

        // Metrics table view
        metricsTable.delegate = metricsModel
        metricsTable.dataSource = metricsModel
    }

    private func showVideoOrScreen(isVideo: Bool) {
        rosterButton.isSelected = false
        metricsButton.isSelected = false
        rosterTable.isHidden = true
        screenView.isHidden = isVideo
        videoCollection.isHidden = !isVideo
    }

    private func showRosterOrMetrics(isRoster: Bool) {
        rosterTable.isHidden = !isRoster
        metricsTable.isHidden = isRoster

        if isRoster {
            metricsButton.isSelected = false
            rosterTable.reloadData()
        } else {
            rosterButton.isSelected = false
            metricsTable.reloadData()
        }
    }

    private func startRemoteVideo() {
        currentMeetingSession?.audioVideo.stopRemoteVideo()
        videoModel.resumeAllRemoteVideo()
        currentMeetingSession?.audioVideo.startRemoteVideo()
        showVideoOrScreen(isVideo: true)
    }

    private func startScreenShare() {
        videoModel.pauseAllRemoteVideo()
        currentMeetingSession?.audioVideo.startRemoteVideo()
        showVideoOrScreen(isVideo: false)
    }

    // MARK: IBAction functions

    @IBAction func metricsButtonClicked(_: UIButton) {
        metricsButton.isSelected = !metricsButton.isSelected
        if metricsButton.isSelected {
            showRosterOrMetrics(isRoster: false)
        } else {
            metricsTable.isHidden = true
        }
    }

    @IBAction func muteButtonClicked(_: UIButton) {
        muteButton.isSelected = !muteButton.isSelected
        if muteButton.isSelected {
            if let muted = currentMeetingSession?.audioVideo.realtimeLocalMute() {
                logger.info(msg: "Microphone has been muted \(muted)")
            }
        } else {
            if let unmuted = currentMeetingSession?.audioVideo.realtimeLocalUnmute() {
                logger.info(msg: "Microphone has been unmuted \(unmuted)")
            }
        }
    }

    @IBAction func deviceButtonClicked(_: UIButton) {
        guard let currentMeetingSession = currentMeetingSession else {
            return
        }
        let optionMenu = UIAlertController(title: nil, message: "Choose Audio Device", preferredStyle: .actionSheet)

        for inputDevice in currentMeetingSession.audioVideo.listAudioDevices() {
            let deviceAction = UIAlertAction(
                title: inputDevice.label,
                style: .default,
                handler: { _ in self.currentMeetingSession?.audioVideo.chooseAudioDevice(mediaDevice: inputDevice)
                }
            )
            optionMenu.addAction(deviceAction)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(cancelAction)

        present(optionMenu, animated: true, completion: nil)
    }

    @IBAction func cameraButtonClicked(_: UIButton) {
        cameraButton.isSelected = !cameraButton.isSelected
        if cameraButton.isSelected {
            setupVideoEnv()
        } else {
            currentMeetingSession?.audioVideo.stopLocalVideo()
        }
    }

    @IBAction func screenButtonClicked(_: UIButton) {
        screenButton.isSelected = !screenButton.isSelected
        if screenButton.isSelected {
            startScreenShare()
        } else {
            startRemoteVideo()
        }
    }

    @IBAction func rosterButtonClicked(_: UIButton) {
        rosterButton.isSelected = !rosterButton.isSelected
        if rosterButton.isSelected {
            showRosterOrMetrics(isRoster: true)
        } else {
            rosterTable.isHidden = true
        }
    }

    @IBAction func leaveButtonClicked(_: UIButton) {
        leaveMeeting()
    }

    private func logAttendee(attendeeInfo: [AttendeeInfo], action: String) {
        for currentAttendeeInfo in attendeeInfo {
            let attendeeId = currentAttendeeInfo.attendeeId
            if !rosterModel.contains(attendeeId: attendeeId) {
                logger.error(msg: "Cannot find attendee with attendee id \(attendeeId)" +
                    " external user id \(currentAttendeeInfo.externalUserId): \(action)")
                continue
            }
            logger.info(msg: "\(rosterModel.getAttendeeName(for: attendeeId) ?? "nil"): \(action)")
        }
    }

    private func leaveMeeting() {
        currentMeetingSession?.audioVideo.stop()
        removeSubscriptionToAttendeeChangeHandler()
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc func setFullScreen(_: UITapGestureRecognizer? = nil) {
        if rosterTable.isHidden == false {
            rosterTable.isHidden = true
            rosterButton.isSelected = false
            metricsButton.isSelected = false
        } else if UIDevice.current.orientation.isLandscape {
            isFullScreen = !isFullScreen
            controlView.isHidden = isFullScreen
        }
    }
}

// MARK: AudioVideoObserver

extension MeetingViewController: AudioVideoObserver {
    func connectionDidRecover() {
        notify(msg: "Connection quality has recovered")
    }

    func connectionDidBecomePoor() {
        notify(msg: "Connection quality has become poor")
    }

    func videoSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {
        logger.info(msg: "Video stopped \(sessionStatus.statusCode)")
    }

    func audioSessionDidStartConnecting(reconnecting: Bool) {
        notify(msg: "Audio started connecting. Reconnecting: \(reconnecting)")
    }

    func audioSessionDidStart(reconnecting: Bool) {
        notify(msg: "Audio successfully started. Reconnecting: \(reconnecting)")
    }

    func audioSessionDidDrop() {
        notify(msg: "Audio Session Dropped")
    }

    func audioSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {
        logger.info(msg: "Audio stopped for a reason: \(sessionStatus.statusCode)")
        if sessionStatus.statusCode != .ok {
            leaveMeeting()
        }
    }

    func audioSessionDidCancelReconnect() {
        notify(msg: "Audio cancelled reconnecting")
    }

    func videoSessionDidStartConnecting() {
        logger.info(msg: "Video connecting")
    }

    func videoSessionDidStartWithStatus(sessionStatus: MeetingSessionStatus) {
        switch sessionStatus.statusCode {
        case .videoAtCapacityViewOnly:
            notify(msg: "Maximum concurrent video limit reached! Failed to start local video.")
        default:
            logger.info(msg: "Video started \(sessionStatus.statusCode)")
        }
    }
}

// MARK: RealtimeObserver

extension MeetingViewController: RealtimeObserver {
    private func removeAttendeesAndReload(attendeeInfo: [AttendeeInfo]) {
        let attendeeIds = attendeeInfo.map { $0.attendeeId }
        rosterModel.removeAttendees(attendeeIds)
        rosterTable.reloadData()
    }

    func attendeesDidLeave(attendeeInfo: [AttendeeInfo]) {
        logAttendee(attendeeInfo: attendeeInfo, action: "Left")
        removeAttendeesAndReload(attendeeInfo: attendeeInfo)
    }

    func attendeesDidDrop(attendeeInfo: [AttendeeInfo]) {
        for attendee in attendeeInfo {
            notify(msg: "\(attendee.externalUserId) dropped")
        }

        removeAttendeesAndReload(attendeeInfo: attendeeInfo)
    }

    func attendeesDidMute(attendeeInfo: [AttendeeInfo]) {
        logAttendee(attendeeInfo: attendeeInfo, action: "Muted")
    }

    func attendeesDidUnmute(attendeeInfo: [AttendeeInfo]) {
        logAttendee(attendeeInfo: attendeeInfo, action: "Unmuted")
    }

    func volumeDidChange(volumeUpdates: [VolumeUpdate]) {
        for currentVolumeUpdate in volumeUpdates {
            let attendeeId = currentVolumeUpdate.attendeeInfo.attendeeId
            rosterModel.updateVolume(attendeeId: attendeeId, volume: currentVolumeUpdate.volumeLevel)
        }
        rosterTable.reloadData()
    }

    func signalStrengthDidChange(signalUpdates: [SignalUpdate]) {
        for currentSignalUpdate in signalUpdates {
            let attendeeId = currentSignalUpdate.attendeeInfo.attendeeId
            rosterModel.updateSignal(attendeeId: attendeeId, signal: currentSignalUpdate.signalStrength)
        }
        rosterTable.reloadData()
    }

    func attendeesDidJoin(attendeeInfo: [AttendeeInfo]) {
        var newAttendees = [RosterAttendee]()
        for currentAttendeeInfo in attendeeInfo {
            let attendeeId = currentAttendeeInfo.attendeeId
            if !rosterModel.contains(attendeeId: attendeeId) {
                let attendeeName = RosterModel.convertAttendeeName(from: currentAttendeeInfo)
                let newAttendee = RosterAttendee(attendeeId: attendeeId,
                                                 attendeeName: attendeeName,
                                                 volume: .notSpeaking,
                                                 signal: .high)
                newAttendees.append(newAttendee)
            }
        }
        rosterModel.addAttendees(newAttendees)
        rosterTable.reloadData()
    }
}

// MARK: MetricsObserver

extension MeetingViewController: MetricsObserver {
    func metricsDidReceive(metrics: [AnyHashable: Any]) {
        guard let observableMetrics = metrics as? [ObservableMetric: Any] else {
            logger.error(msg: "The received metrics \(metrics) is not of type [ObservableMetric: Any].")
            return
        }
        metricsModel.update(dict: metrics)
        logger.info(msg: "Media metrics have been received: \(observableMetrics)")
        metricsTable.reloadData()
    }
}

// MARK: DeviceChangeObserver

extension MeetingViewController: DeviceChangeObserver {
    func audioDeviceDidChange(freshAudioDeviceList: [MediaDevice]) {
        let deviceLabels: [String] = freshAudioDeviceList.map { device in "* \(device.label)" }
        view.makeToast("Device availability changed:\nAvailable Devices:\n\(deviceLabels.joined(separator: "\n"))")
    }
}

// MARK: VideoTileObserver

extension MeetingViewController: VideoTileObserver {
    func videoTileDidAdd(tileState: VideoTileState) {
        logger.info(msg: "Attempting to add video tile tileId: \(tileState.tileId)" +
            " attendeeId: \(tileState.attendeeId ?? "")")
        if tileState.isContent {
            currentMeetingSession?.audioVideo.bindVideoView(videoView: screenRenderView, tileId: tileState.tileId)
            noScreenViewLabel.isHidden = true
            screenRenderView.isHidden = false
        } else {
            if tileState.isLocalTile {
                videoModel.setSelfVideoTileState(tileState)
                videoCollection?.reloadItems(at: [IndexPath(item: 0, section: 0)])
            } else {
                videoModel.addRemoteVideoTileState(tileState, completion: { success in
                    if success {
                        self.videoCollection?.reloadData()
                    } else {
                        self.logger.info(msg: "Cannot add more video tile tileId: \(tileState.tileId)")
                    }
                })
            }
        }
    }

    func videoTileDidRemove(tileState: VideoTileState) {
        logger.info(msg: "Attempting to remove video tile tileId: \(tileState.tileId)" +
            " attendeeId: \(tileState.attendeeId ?? "")")
        currentMeetingSession?.audioVideo.unbindVideoView(tileId: tileState.tileId)

        if tileState.isContent {
            screenRenderView.isHidden = true
            noScreenViewLabel.isHidden = false
        } else if tileState.isLocalTile {
            videoModel.setSelfVideoTileState(nil)
            videoCollection?.reloadItems(at: [IndexPath(item: 0, section: 0)])
        } else {
            videoModel.removeRemoteVideoTileState(tileState, completion: { success in
                if success {
                    self.videoCollection.reloadData()
                } else {
                    self.logger.error(msg: "Cannot remove unexisting remote video tile for tileId: \(tileState.tileId)")
                }
            })
        }
    }

    func videoTileDidPause(tileState: VideoTileState) {
        let attendeeId = tileState.attendeeId ?? "unkown"
        let attendeeName = rosterModel.getAttendeeName(for: attendeeId) ?? ""
        if tileState.pauseState == .pausedForPoorConnection {
            view.makeToast("Video for attendee \(attendeeName) " +
                " has been paused for poor network connection," +
                " video will automatically resume when connection improves")
        } else {
            view.makeToast("Video for attendee \(attendeeName) " +
                " has been paused")
        }
    }

    func videoTileDidResume(tileState: VideoTileState) {
        let attendeeId = tileState.attendeeId ?? "unkown"
        let attendeeName = rosterModel.getAttendeeName(for: attendeeId) ?? ""
        view.makeToast("Video for attendee \(attendeeName) has been unpaused")
    }
}

// MARK: ActiveSpeakerObserver

extension MeetingViewController: ActiveSpeakerObserver {
    var observerId: String {
        return uuid
    }

    func activeSpeakerDidDetect(attendeeInfo: [AttendeeInfo]) {
        rosterModel.updateActiveSpeakers(attendeeInfo.map { $0.attendeeId })
        rosterTable.reloadData()
    }
}

// MARK: VideoModelDelegate

extension MeetingViewController: VideoModelDelegate {
    func isFrontCameraActive() -> Bool {
        if let activeCamera = currentMeetingSession?.audioVideo.getActiveCamera() {
            return activeCamera.type == .videoFrontCamera
        }
        return false
    }

    func getVideoTileDisplayName(for videoTile: VideoTileState) -> String {
        if videoTile.isLocalTile {
            return selfName ?? ""
        }
        return rosterModel.getAttendeeName(for: videoTile.attendeeId ?? "") ?? ""
    }

    func bindVideoView(videoView: VideoRenderView, tileId: Int) {
        currentMeetingSession?.audioVideo.bindVideoView(videoView: videoView,
                                                        tileId: tileId)
    }

    func switchCamera() {
        currentMeetingSession?.audioVideo.switchCamera()
        logger.info(msg: "currentDevice \(currentMeetingSession?.audioVideo.getActiveCamera()?.description ?? "No device")")
    }

    func pauseVideo(tileId: Int) {
        currentMeetingSession?.audioVideo.pauseRemoteVideoTile(tileId: tileId)
    }

    func resumeVideo(tileId: Int) {
        currentMeetingSession?.audioVideo.resumeRemoteVideoTile(tileId: tileId)
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
