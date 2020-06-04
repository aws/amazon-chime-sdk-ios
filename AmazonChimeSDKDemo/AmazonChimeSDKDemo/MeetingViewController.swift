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
    @IBOutlet var meetingNameLabel: UILabel!
    @IBOutlet var muteButton: UIButton!
    @IBOutlet var deviceButton: UIButton!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var endButton: UIButton!
    @IBOutlet var rosterTable: UITableView!
    @IBOutlet var videoCollection: UICollectionView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var screenView: DefaultVideoRenderView!
    public var meetingSessionConfig: MeetingSessionConfiguration?
    public var meetingId: String?
    public var selfName: String?
    private var activeSpeakerIds: [String] = []
    private var attendees = [RosterAttendee]()
    private let contentDelimiter = "#content"
    private let contentSuffix = "<<Content>>"
    private var currentMeetingSession: MeetingSession?
    private var currentRoster = [String: RosterAttendee]()
    private let dispatchGroup = DispatchGroup()
    private let jsonDecoder = JSONDecoder()
    private let logger = ConsoleLogger(name: "MeetingViewController")
    private let uuid = UUID().uuidString
    private let videoTileCellReuseIdentifier = "VideoTileCell"
    private var videoTileStates: [VideoTileState?] = [nil]
    private var videoTileStatesForDisplay: ArraySlice<VideoTileState?> = ArraySlice.init(repeating: nil, count: 1)
    private var videoTileIdToIndexPath: [Int: IndexPath] = [:]
    private let maxVideoTileCount = 4

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.meetingNameLabel.text = self.meetingId
        guard self.meetingSessionConfig != nil else {
            self.logger.error(msg: "Unable to get meeting session")
            return
        }

        DispatchQueue.global(qos: .background).async {
            self.currentMeetingSession = DefaultMeetingSession(
                configuration: self.meetingSessionConfig!, logger: self.logger)
            self.videoCollection.accessibilityIdentifier = "Video Collection"

            self.setupAudioEnv()
        }
    }

    private func setupAudioEnv() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, options:
                AVAudioSession.CategoryOptions.allowBluetooth)
            self.setupSubscriptionToAttendeeChangeHandler()
            try self.currentMeetingSession?.audioVideo.start(callKitEnabled: false)
        } catch PermissionError.audioPermissionError {
            let audioPermission = AVAudioSession.sharedInstance().recordPermission
            if audioPermission == .denied {
                self.logger.error(msg: "User did not grant audio permission, it should redirect to Settings")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    if granted {
                        self.setupAudioEnv()
                    } else {
                        self.logger.error(msg: "User did not grant audio permission")
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        } catch {
            self.logger.error(msg: "Error starting the Meeting: \(error.localizedDescription)")
            self.leaveMeeting()
        }
    }

    private func setupVideoEnv() {
        do {
            try self.currentMeetingSession?.audioVideo.startLocalVideo()
        } catch PermissionError.videoPermissionError {
            let videoPermission = AVCaptureDevice.authorizationStatus(for: .video)
            if videoPermission == .denied {
                self.logger.error(msg: "User did not grant video permission, it should redirect to Settings")
                self.notify(msg: "You did not grant video permission, Please go to Settings and change it")
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
            self.logger.error(msg: "Error starting the Meeting: \(error.localizedDescription)")
            self.leaveMeeting()
        }
    }

    func setupSubscriptionToAttendeeChangeHandler() {
        self.currentMeetingSession?.audioVideo.addVideoTileObserver(observer: self)
        self.currentMeetingSession?.audioVideo.addRealtimeObserver(observer: self)
        self.currentMeetingSession?.audioVideo.addAudioVideoObserver(observer: self)
        self.currentMeetingSession?.audioVideo.addMetricsObserver(observer: self)
        self.currentMeetingSession?.audioVideo.addDeviceChangeObserver(observer: self)
        self.currentMeetingSession?.audioVideo.addActiveSpeakerObserver(policy: DefaultActiveSpeakerPolicy(),
                                                                        observer: self)
    }

    func removeSubscriptionToAttendeeChangeHandler () {
        self.currentMeetingSession?.audioVideo.removeVideoTileObserver(observer: self)
        self.currentMeetingSession?.audioVideo.removeRealtimeObserver(observer: self)
        self.currentMeetingSession?.audioVideo.removeAudioVideoObserver(observer: self)
        self.currentMeetingSession?.audioVideo.removeMetricsObserver(observer: self)
        self.currentMeetingSession?.audioVideo.removeDeviceChangeObserver(observer: self)
        self.currentMeetingSession?.audioVideo.removeActiveSpeakerObserver(observer: self)
    }

    private func notify(msg: String) {
        self.logger.info(msg: msg)
        self.view.makeToast(msg, duration: 2.0)
    }

    private func getMaxIndexOfVisibleVideoTiles() -> Int {
        // If local video was not enabled, we can show one more remote video
        let maxRemoteVideoTileCount = self.maxVideoTileCount - (self.videoTileStates[0] == nil ? 0 : 1)
        return min(maxRemoteVideoTileCount, self.videoTileStates.count - 1)
    }

    // MARK: UI related

    private func setupUI() {
        let buttonStack = [self.muteButton, self.deviceButton, self.cameraButton, self.endButton]
        for button in buttonStack {
            button?.imageView!.contentMode = UIView.ContentMode.scaleAspectFit
        }
    }

    @IBAction func muteButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            let muted = self.currentMeetingSession?.audioVideo.realtimeLocalMute()
            self.logger.info(msg: "Microphone has been muted \(muted!)")
        } else {
            let unmuted = self.currentMeetingSession?.audioVideo.realtimeLocalUnmute()
            self.logger.info(msg: "Microphone has been unmuted \(unmuted!)")
        }
    }

    @IBAction func cameraButtonClicked(_ sender: UIButton) {
        self.cameraButton.isSelected = !self.cameraButton.isSelected

        if self.cameraButton.isSelected {
            self.setupVideoEnv()
        } else {
            self.currentMeetingSession?.audioVideo.stopLocalVideo()
        }
    }

    @IBAction func deviceButtonClicked(_ sender: UIButton) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Audio Device", preferredStyle: .actionSheet)

        if self.currentMeetingSession == nil {
            return
        }

        for inputDevice in self.currentMeetingSession!.audioVideo.listAudioDevices() {
            let deviceAction = UIAlertAction(
                title: inputDevice.label,
                style: .default,
                handler: { _ in self.currentMeetingSession?.audioVideo.chooseAudioDevice(mediaDevice: inputDevice)
            })
            optionMenu.addAction(deviceAction)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(cancelAction)

        self.present(optionMenu, animated: true, completion: nil)
    }

    @IBAction func switchPageButtonClicked(_ sender: Any) {
        switch self.segmentedControl.selectedSegmentIndex {
        case SegmentedControlIndex.roster.rawValue:
            self.rosterTable.isHidden = false
            self.screenView.isHidden = true
            self.videoCollection.isHidden = true
            self.currentMeetingSession?.audioVideo.stopRemoteVideo()
        case SegmentedControlIndex.videos.rawValue:
            // Skip index 0 as it's reserved for self video tile
            for index in 1 ..< self.videoTileStatesForDisplay.count {
                if let tileState = self.videoTileStatesForDisplay[index] {
                    self.currentMeetingSession?.audioVideo.resumeRemoteVideoTile(tileId: tileState.tileId)
                    if let indexPath = self.videoTileIdToIndexPath[tileState.tileId],
                        let otherVideoTileCell = self.videoCollection.cellForItem(at: indexPath) as? VideoTileCell {
                            otherVideoTileCell.onTileButton.isSelected = false
                    }
                }
            }
            self.rosterTable.isHidden = true
            self.screenView.isHidden = true
            self.videoCollection.isHidden = false
            self.currentMeetingSession?.audioVideo.startRemoteVideo()
        case SegmentedControlIndex.screen.rawValue:
            // Skip index 0 as it's reserved for self video tile
            for index in 1 ..< self.videoTileStatesForDisplay.count {
                if let tileState = self.videoTileStatesForDisplay[index] {
                    self.currentMeetingSession?.audioVideo.pauseRemoteVideoTile(tileId: tileState.tileId)
                }
            }
            self.rosterTable.isHidden = true
            self.videoCollection.isHidden = true
            self.screenView.isHidden = false
            self.currentMeetingSession?.audioVideo.startRemoteVideo()
        default:
            return
        }
    }

    @IBAction func leaveButtonClicked(_ sender: UIButton?) {
        self.leaveMeeting()
    }

    func switchCameraClicked() {
        self.currentMeetingSession?.audioVideo.switchCamera()
        if let tileState = self.videoTileStatesForDisplay[0],
            let indexPath = self.videoTileIdToIndexPath[tileState.tileId],
            let selfVideoTileCell = self.videoCollection.cellForItem(at: indexPath) as? VideoTileCell {
            if let selfVideoTileView = selfVideoTileCell.contentView as? DefaultVideoRenderView {
                selfVideoTileView.mirror = !selfVideoTileView.mirror
            }
        }
        self.logger.info(msg:
            "currentDevice \(self.currentMeetingSession?.audioVideo.getActiveCamera()?.description ?? "No device")")
    }

    func toggleVideo(index: Int, selected: Bool) {
        if let tileState = self.videoTileStatesForDisplay[index], !tileState.isLocalTile {
            if selected {
                self.currentMeetingSession?.audioVideo.pauseRemoteVideoTile(
                    tileId: tileState.tileId
                )
            } else {
                self.currentMeetingSession?.audioVideo.resumeRemoteVideoTile(
                    tileId: tileState.tileId
                )
            }
        }
    }

    @objc func onTileButtonClicked(_ sender: UIButton) {
        if sender.tag == 0 {
            self.switchCameraClicked()
        } else {
            sender.isSelected = !sender.isSelected
            self.toggleVideo(index: sender.tag, selected: sender.isSelected)
        }
    }

    private func getAttendeeName(_ info: AttendeeInfo) -> String {
        let externalUserIdArray = info.externalUserId.components(separatedBy: "#")
        let attendeeName: String = externalUserIdArray[1]
        return info.attendeeId.hasSuffix(self.contentDelimiter) ? "\(attendeeName) \(self.contentSuffix)" : attendeeName
    }

    private func logAttendee(attendeeInfo: [AttendeeInfo], action: String) {
        for currentAttendeeInfo in attendeeInfo {
            let attendeeId = currentAttendeeInfo.attendeeId
            guard let attendee = self.currentRoster[attendeeId] else {
                self.logger.error(msg: "Cannot find attendee with attendee id \(attendeeId)" +
                    " external user id \(currentAttendeeInfo.externalUserId): \(action)")
                continue
            }
            self.logger.info(msg: "\(attendee.attendeeName ?? "nil"): \(action)")
        }
    }

    private func leaveMeeting() {
        self.currentMeetingSession?.audioVideo.stop()
        removeSubscriptionToAttendeeChangeHandler()
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension MeetingViewController: AudioVideoObserver {
    func connectionDidRecover() {
        self.notify(msg: "Connection quality has recovered")
    }

    func connectionDidBecomePoor() {
        self.notify(msg: "Connection quality has become poor")
    }

    func videoSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {
        self.logger.info(msg: "Video stopped \(sessionStatus.statusCode)")
    }

    func audioSessionDidStartConnecting(reconnecting: Bool) {
        self.notify(msg: "Audio started connecting. Reconnecting: \(reconnecting)")
    }

    func audioSessionDidStart(reconnecting: Bool) {
        self.notify(msg: "Audio successfully started. Reconnecting: \(reconnecting)")
    }

    func audioSessionDidDrop() {
        self.notify(msg: "Audio Session Dropped")
    }

    func audioSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {
        self.logger.info(msg: "Audio stopped for a reason: \(sessionStatus.statusCode)")
        if sessionStatus.statusCode != .ok {
            self.leaveMeeting()
        }
    }

    func audioSessionDidCancelReconnect() {
        self.notify(msg: "Audio cancelled reconnecting")
    }

    func videoSessionDidStartConnecting() {
        self.logger.info(msg: "Video connecting")
    }

    func videoSessionDidStartWithStatus(sessionStatus: MeetingSessionStatus) {
        switch sessionStatus.statusCode {
        case .videoAtCapacityViewOnly:
            self.notify(msg: "Maximum concurrent video limit reached! Failed to start local video.")
        default:
            self.logger.info(msg: "Video started \(sessionStatus.statusCode)")
        }
    }
}

extension MeetingViewController: RealtimeObserver {
    private func removeAttendeesAndReload(attendeeInfo: [AttendeeInfo]) {
        for currentAttendeeInfo in attendeeInfo {
            self.currentRoster.removeValue(forKey: currentAttendeeInfo.attendeeId)
        }
        self.attendees = self.currentRoster.values.sorted(by: {
            if let name0 = $0.attendeeName, let name1 = $1.attendeeName {
                return name0 < name1
            }
            return false
        })
        self.rosterTable.reloadData()
    }

    func attendeesDidLeave(attendeeInfo: [AttendeeInfo]) {
        self.logAttendee(attendeeInfo: attendeeInfo, action: "Left")
        self.removeAttendeesAndReload(attendeeInfo: attendeeInfo)
    }

    func attendeesDidDrop(attendeeInfo: [AttendeeInfo]) {
        for attendee in attendeeInfo {
            self.notify(msg: "\(attendee.externalUserId) dropped")
        }

        self.removeAttendeesAndReload(attendeeInfo: attendeeInfo)
    }

    func attendeesDidMute(attendeeInfo: [AttendeeInfo]) {
        self.logAttendee(attendeeInfo: attendeeInfo, action: "Muted")
    }

    func attendeesDidUnmute(attendeeInfo: [AttendeeInfo]) {
        self.logAttendee(attendeeInfo: attendeeInfo, action: "Unmuted")
    }

    func volumeDidChange(volumeUpdates: [VolumeUpdate]) {
        for currentVolumeUpdate in volumeUpdates {
            let attendeeId = currentVolumeUpdate.attendeeInfo.attendeeId
            guard let attendee = self.currentRoster[attendeeId] else {
                self.logger.error(msg: "Cannot find attendee with attendee id \(attendeeId)" +
                    " external user id \(currentVolumeUpdate.attendeeInfo.externalUserId)")
                continue
            }
            let volume = currentVolumeUpdate.volumeLevel
            if attendee.volume != volume {
                attendee.volume = volume
                if let name = attendee.attendeeName {
                    self.logger.info(msg: "Volume changed for \(name): \(volume)")
                    self.rosterTable.reloadData()
                }
            }
        }
    }

    func signalStrengthDidChange(signalUpdates: [SignalUpdate]) {
        for currentSignalUpdate in signalUpdates {
            let attendeeId = currentSignalUpdate.attendeeInfo.attendeeId
            guard let attendee = self.currentRoster[attendeeId] else {
                self.logger.error(msg: "Cannot find attendee with attendee id \(attendeeId)" +
                    " external user id \(currentSignalUpdate.attendeeInfo.externalUserId)")
                continue
            }
            let signal = currentSignalUpdate.signalStrength
            if attendee.signal != signal {
                attendee.signal = signal
                if let name = attendee.attendeeName {
                    self.logger.info(msg: "Signal strength changed for \(name): \(signal)")
                    self.rosterTable.reloadData()
                }
            }
        }
    }

    func attendeesDidJoin(attendeeInfo: [AttendeeInfo]) {
        var updateRoster = [String: RosterAttendee]()
        for currentAttendeeInfo in attendeeInfo {
            let attendeeId = currentAttendeeInfo.attendeeId
            let attendeeName = self.getAttendeeName(currentAttendeeInfo)
            if let attendee = self.currentRoster[attendeeId] {
                updateRoster[attendeeId] = attendee
            } else {
                updateRoster[attendeeId] = RosterAttendee(
                    attendeeId: attendeeId, attendeeName: attendeeName, volume: .notSpeaking, signal: .high)
            }
        }

        for (attendeeId, attendee) in updateRoster {
            self.currentRoster[attendeeId] = attendee
            self.attendees.append(attendee)
        }
        self.attendees.sort(by: {
            if let name0 = $0.attendeeName, let name1 = $1.attendeeName {
                return name0 < name1
            }
            return false
        })
        self.rosterTable.reloadData()
    }
}

extension MeetingViewController: MetricsObserver {
    func metricsDidReceive(metrics: [AnyHashable: Any]) {
        guard let observableMetrics = metrics as? [ObservableMetric: Any] else {
            self.logger.error(msg: "The received metrics \(metrics) is not of type [ObservableMetric: Any].")
            return
        }
        self.logger.info(msg: "Media metrics have been received: \(observableMetrics)")
    }
}

extension MeetingViewController: DeviceChangeObserver {
    func audioDeviceDidChange(freshAudioDeviceList: [MediaDevice]) {
        let deviceLabels: [String] = freshAudioDeviceList.map { device in "* \(device.label)" }
        self.view.makeToast("Device availability changed:\nAvailable Devices:\n\(deviceLabels.joined(separator: "\n"))")
    }
}

extension MeetingViewController: VideoTileObserver {
    func videoTileDidAdd(tileState: VideoTileState) {
        self.logger.info(msg: "Adding Video Tile tileId: \(tileState.tileId)" +
            " attendeeId: \(String(describing: tileState.attendeeId))")
        if tileState.isContent {
            self.currentMeetingSession?.audioVideo.bindVideoView(videoView: self.screenView, tileId: tileState.tileId)
        } else {
            if tileState.isLocalTile {
                self.videoTileStates[0] = tileState
            } else {
                self.videoTileStates.append(tileState)
            }

            self.videoTileStatesForDisplay = self.videoTileStates[...self.getMaxIndexOfVisibleVideoTiles()]
            self.videoCollection?.reloadData()
        }
    }

    func videoTileDidRemove(tileState: VideoTileState) {
        self.logger.info(msg: "Removing Video Tile tileId: \(tileState.tileId)" +
            " attendeeId: \(String(describing: tileState.attendeeId))")
        self.currentMeetingSession?.audioVideo.unbindVideoView(tileId: tileState.tileId)
        self.videoTileIdToIndexPath[tileState.tileId] = nil

        if tileState.isLocalTile {
            self.videoTileStates[0] = nil
        } else {
            if let tileStateIndex = self.videoTileStates.firstIndex(of: tileState) {
                self.videoTileStates.remove(at: tileStateIndex)
            }
        }

        self.videoTileStatesForDisplay = self.videoTileStates[...self.getMaxIndexOfVisibleVideoTiles()]
        self.videoCollection?.reloadData()
    }

    func videoTileDidPause(tileState: VideoTileState) {
        let attendeeId = tileState.attendeeId ?? "unkown"
        if tileState.pauseState == .pausedForPoorConnection {
            self.view.makeToast("Video for attendee \(attendeeId) " +
                " has been paused for poor network connection," +
                " video will automatically resume when connection improves")
        } else {
            self.view.makeToast("Video for attendee \(attendeeId) " +
                " has been paused")
        }
    }

    func videoTileDidResume(tileState: VideoTileState) {
        let attendeeId = tileState.attendeeId ?? "unkown"
        self.view.makeToast("Video for attendee \(attendeeId) has been unpaused")
    }
}

extension MeetingViewController: ActiveSpeakerObserver {
    var observerId: String {
        return self.uuid
    }

    func activeSpeakerDidDetect(attendeeInfo: [AttendeeInfo]) {
        self.activeSpeakerIds = attendeeInfo.map { $0.attendeeId }
        self.rosterTable.reloadData()
    }
}

extension MeetingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.attendees.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "rosterCell") as? RosterTableCell else {
            return UITableViewCell()
        }
        let currentAttendee = self.attendees[indexPath.item]
        cell.attendeeName.text = currentAttendee.attendeeName
        cell.attendeeName.accessibilityIdentifier = currentAttendee.attendeeName
        cell.accessibilityIdentifier = "\(currentAttendee.attendeeName ?? "") Speaking"

        switch currentAttendee.volume {
        case .muted:
            cell.speakLevel.image = UIImage(named: "volume-muted")
            cell.accessibilityIdentifier = "\(currentAttendee.attendeeName ?? "") Muted"
        case .notSpeaking:
            cell.speakLevel.image = UIImage(named: "volume-0")
            cell.accessibilityIdentifier = "\(currentAttendee.attendeeName ?? "") Not Speaking"
        case .low:
            cell.speakLevel.image = UIImage(named: "volume-1")
        case .medium:
            cell.speakLevel.image = UIImage(named: "volume-2")
        case .high:
            cell.speakLevel.image = UIImage(named: "volume-3")
        }

        if self.activeSpeakerIds.contains(currentAttendee.attendeeId) {
            cell.activeSpeaker.text = "Active Speaker"
        } else {
            cell.activeSpeaker.text = ""
        }

        if currentAttendee.signal != .high {
            if currentAttendee.volume == .muted {
                cell.speakLevel.image = UIImage(named: "signal-poor-muted")
            } else {
                cell.speakLevel.image = UIImage(named: "signal-poor")
            }
        }

        return cell
    }
}

extension MeetingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Only one section for all video tiles
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.videoTileStatesForDisplay.count
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let layout = videoCollection.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        if UIDevice.current.orientation.isLandscape {
            layout.scrollDirection = .horizontal
        } else {
            layout.scrollDirection = .vertical
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: self.videoTileCellReuseIdentifier, for: indexPath) as? VideoTileCell else {
            return VideoTileCell()
        }
        guard let videoRenderView = cell.contentView as? DefaultVideoRenderView else {
            return cell
        }

        // Reset the reusable cell as it may contains stale data from previous usage
        videoRenderView.mirror = false
        cell.isHidden = true
        cell.accessibilityIdentifier = nil
        cell.onTileButton.imageView!.contentMode = UIView.ContentMode.scaleAspectFit
        cell.onTileButton.tag = indexPath.row
        cell.onTileButton.addTarget(self, action:
            #selector(self.onTileButtonClicked), for: .touchUpInside)

        if let tileState = self.videoTileStatesForDisplay[indexPath.row] {
            var attendeeName = ""
            if tileState.isLocalTile {
                if self.currentMeetingSession?.audioVideo.getActiveCamera()?.type == .videoFrontCamera {
                    videoRenderView.mirror = true
                }
                cell.isHidden = !self.cameraButton.isSelected
                cell.onTileButton.setImage(UIImage(named: "switch-camera"), for: .normal)
                attendeeName = self.selfName ?? ""
            } else {
                cell.isHidden = false
                cell.onTileButton.setImage(UIImage(named: "pause-video"), for: .normal)
                cell.onTileButton.setImage(UIImage(named: "resume-video"), for: .selected)
                attendeeName = self.currentRoster[tileState.attendeeId!]?.attendeeName ?? ""
            }

            cell.attendeeName.text = attendeeName
            cell.accessibilityIdentifier = "\(attendeeName) VideoTile"

            self.currentMeetingSession?.audioVideo.bindVideoView(
                videoView: videoRenderView,
                tileId: tileState.tileId)
            self.videoTileIdToIndexPath[tileState.tileId] = indexPath
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = view.frame.width
        var height = view.frame.height

        if UIDevice.current.orientation.isLandscape {
            height /= 2.0
            width = height / 9.0 * 16.0
        } else {
            height = view.frame.width / 16.0 * 9.0
        }

        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
