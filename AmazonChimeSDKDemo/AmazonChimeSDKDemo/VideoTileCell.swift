//
//  VideoTileCell.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import UIKit
import Toast

let videoTileCellReuseIdentifier = "VideoTileCell"

protocol VideoTileCellDelegate: class {
    func onTileButtonClicked(tag: Int, selected: Bool)
    func onUpdatePriorityButtonClicked(attendeeId: String, priority: VideoPriority)
    func onVideoFilterButtonClicked(videoFilter: BackgroundFilter, uiView: UIViewController)
}

class VideoTileCell: UICollectionViewCell {
    @IBOutlet var attendeeName: UILabel!
    @IBOutlet var shadedView: UIView!
    @IBOutlet var onTileButton: UIButton!
    @IBOutlet var updateVideoSubscriptionsButton: UIButton!
    @IBOutlet var videoFiltersButton: UIButton!
    @IBOutlet var videoDisabledImage: UIImageView!
    @IBOutlet var poorConnectionBackground: UIView!
    @IBOutlet var poorConnectionImage: UIImageView!
    @IBOutlet var poorConnectionLabel: UILabel!
    @IBOutlet var videoRenderView: DefaultVideoRenderView!

    weak var delegate: VideoTileCellDelegate?
    weak var viewController: UIViewController?
    var attendeeId: String = ""

    func updateCell(id: String, name: String, isSelf: Bool, videoTileState: VideoTileState?, tag: Int) {
        let isVideoActive = videoTileState != nil
        let isVideoPausedByUser = isVideoActive && videoTileState?.pauseState == .pausedByUserRequest

        attendeeId = id
        attendeeName.text = name
        backgroundColor = .systemGray
        isHidden = false

        // Self video cell not active
        if isSelf, !isVideoActive {
            onTileButton.isHidden = true
            updateVideoSubscriptionsButton.isHidden = true
            videoDisabledImage.image = UIImage(named: "meeting-video")?.withRenderingMode(.alwaysTemplate)
            videoDisabledImage.tintColor = .white
            videoDisabledImage.isHidden = false
            return
        }

        videoDisabledImage.isHidden = true
        videoRenderView.isHidden = false
        videoRenderView.accessibilityIdentifier = "\(name) VideoTile"

        onTileButton.tintColor = .white
        onTileButton.isHidden = false
        onTileButton.tag = tag
        onTileButton.addTarget(self, action: #selector(onTileButtonClicked), for: .touchUpInside)
        onTileButton.isSelected = isVideoPausedByUser
        updateVideoSubscriptionsButton.isHidden = false
        videoFiltersButton.isHidden = true
        
        if isSelf {
            onTileButton.setImage(UIImage(named: "switch-camera")?.withRenderingMode(.alwaysTemplate),
                                  for: .normal)

            updateVideoSubscriptionsButton.isHidden = true
            // If current video cell is local video then render the menu to apply the background filters.
            videoFiltersButton.isHidden = false
            videoFiltersButton.setImage(UIImage(named: "more")?.withRenderingMode(.alwaysTemplate), for: .normal)
            videoFiltersButton.tintColor = .white
            videoFiltersButton.addTarget(self, action: #selector(showVideoFiltersMenu), for: .touchUpInside)
        } else {
            onTileButton.setImage(UIImage(named: "pause-video")?.withRenderingMode(.alwaysTemplate),
                                  for: .normal)
            onTileButton.setImage(UIImage(named: "resume-video")?.withRenderingMode(.alwaysTemplate),
                                  for: .selected)
            let shouldShowPoorConnection = videoTileState?.pauseState == .pausedForPoorConnection
            renderPoorConnection(isHidden: !shouldShowPoorConnection)
            
            updateVideoSubscriptionsButton.setImage(UIImage(named: "more")?.withRenderingMode(.alwaysTemplate), for: .normal)
            updateVideoSubscriptionsButton.tintColor = .white
            updateVideoSubscriptionsButton.addTarget(self, action: #selector(showUpdateVideoSubscriptionsMenu), for: .touchUpInside)
        }
    }
    
    @objc func showUpdateVideoSubscriptionsMenu() {
        let alertController = UIAlertController(title: "Set video priority", message: "Choose the display priority order for the selected video", preferredStyle: .alert)
        let priorityList = [VideoPriority.lowest, VideoPriority.low, VideoPriority.medium, VideoPriority.high, VideoPriority.highest]
        let titleList = ["Lowest", "Low", "Medium", "High", "Highest"]
        
        for index in 0...(priorityList.count-1) {
            let action = UIAlertAction(title: titleList[index], style: UIAlertAction.Style.default) {_ in
                self.delegate?.onUpdatePriorityButtonClicked(attendeeId: self.attendeeId, priority: priorityList[index])
            }
            alertController.addAction(action)
        }

        // Present the controller
        viewController?.present(alertController, animated: true, completion: nil)
    }

    /// Add the background filter options to be presented.
    @objc func showVideoFiltersMenu() {
        let videoFilterAlertController = UIAlertController(title: "Set video filter",
                                                           message: "Choose a video filter for the selected video",
                                                           preferredStyle: .alert)
        var filtersList = [BackgroundFilter.none]
        var titleList = ["None"]
        if BackgroundFilterProcessor.isAvailable() {
            filtersList.append(contentsOf: [BackgroundFilter.blur, BackgroundFilter.replacement])
            titleList.append(contentsOf: ["Background Blur", "Background Replacement"])
        }

        for index in 0...(filtersList.count-1) {
            let action = UIAlertAction(title: titleList[index], style: UIAlertAction.Style.default) {_ in
                self.delegate?.onVideoFilterButtonClicked(videoFilter: filtersList[index], uiView: self.viewController!)
            }
            videoFilterAlertController.addAction(action)
        }

        viewController?.present(videoFilterAlertController, animated: true, completion: nil)
    }

    override func prepareForReuse() {
        accessibilityIdentifier = nil
        attendeeName.isHidden = false
        contentView.isHidden = false
        isHidden = true

        onTileButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        updateVideoSubscriptionsButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        shadedView.isHidden = false
        videoRenderView.backgroundColor = .systemGray
        videoRenderView.isHidden = true
        renderPoorConnection(isHidden: true)
        videoRenderView.mirror = false
        // Clean up old video image to prevent frame flicker
        videoRenderView.resetImage()
    }

    @objc func onTileButtonClicked(_ sender: UIButton) {
        sender.isSelected.toggle()
        delegate?.onTileButtonClicked(tag: sender.tag, selected: sender.isSelected)
        if sender.tag == 0 {
            videoRenderView.mirror.toggle()
        }
    }

    private func renderPoorConnection(isHidden: Bool) {
        if !isHidden {
            poorConnectionImage.image = UIImage(named: "connection-problem")!.withRenderingMode(.alwaysTemplate)
            poorConnectionImage.tintColor = .white
        }
        poorConnectionImage.isHidden = isHidden
        poorConnectionLabel.isHidden = isHidden
        poorConnectionBackground.isHidden = isHidden
    }
}
