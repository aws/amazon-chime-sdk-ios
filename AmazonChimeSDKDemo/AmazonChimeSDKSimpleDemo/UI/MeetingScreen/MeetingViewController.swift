//
//  MeetingViewController.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit
import AmazonChimeSDK

class MeetingViewController: UIViewController {
    
    @IBOutlet weak var muteButton: UIBarButtonItem!
    @IBOutlet weak var videoButton: UIBarButtonItem!
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var attendeesTableView: UITableView!
    
    var isCallKitEnabled: Bool = false
    private var vm: MeetingViewModel!
    
    private let attendeeCellId = "AttendeeCell"
    private let videoCellId = "VideoTileCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vm = MeetingViewModel(enableCallKit: self.isCallKitEnabled)
        
        self.videoCollectionView.delegate = self
        self.videoCollectionView.dataSource = self
        self.attendeesTableView.delegate = self
        self.attendeesTableView.dataSource = self
        
        self.title = self.vm.meetingId
        
        MeetingNotificationCenter.shared.addObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.attendeesTableView.reloadData()
    }
    
    deinit {
        MeetingNotificationCenter.shared.removeObserver(self)
    }
    
    @IBAction func muteButtonPressed(_ sender: Any) {
        self.vm.isMuted = !self.vm.isMuted
    }
    
    
    @IBAction func videoButtonPressed(_ sender: Any) {
        if self.vm.isLocalVideoEnabled {
            self.vm.stopLocalVideo()
        } else {
            self.vm.startLocalVideo()
        }
    }
    
    @IBAction func leaveButtonPressed(_ sender: Any) {
        self.vm.leaveMeeting()
    }
}

extension MeetingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.attendees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let attendee = self.vm.attendees[indexPath.row]
        let attendeeName = RosterModel.convertAttendeeName(from: attendee)
        let isMuted = self.vm.isAttendeeMuted(attendeeId: attendee.attendeeId)
        var cell = tableView.dequeueReusableCell(withIdentifier: attendeeCellId)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: attendeeCellId)
        }
        cell!.textLabel?.text = attendeeName
        cell!.detailTextLabel?.text = isMuted ? "Muted" : ""
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
}

extension MeetingViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vm.videoAttendeeIds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let attendeeId = self.vm.videoAttendeeIds[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoCellId, for: indexPath) as! VideoTileCell
        
        if let attendeeInfo = self.vm.getAttendeeInfo(attendeeId: attendeeId) {
            let attendeeName = RosterModel.convertAttendeeName(from: attendeeInfo)
            cell.attendeeNameLabel.text = attendeeName
        } else {
            cell.attendeeNameLabel.text = ""
        }
        
        self.vm.bindVideoTile(attendeeId: attendeeId, videoView: cell.videoRenderView)
        
        return cell
    }
}

extension MeetingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = collectionView.frame.size.width / 2.0
        return CGSize(width: length, height: length)
    }
}

extension MeetingViewController: MeetingObserver {
    func muteStatesDidUpdate() {
        self.attendeesTableView.reloadData()
        self.muteButton.title = self.vm.isMuted ? "Unmute" : "Mute"
    }
    
    func attendeesDidUpdate() {
        self.attendeesTableView.reloadData()
    }
    
    func videoTileStatesDidUpdate() {
        self.videoCollectionView.reloadData()
        self.videoButton.title = self.vm.isLocalVideoEnabled ? "Disable Video" : "Enable Video"
    }
    
    func meetingEnded() {
        self.dismiss(animated: true)
    }
}
