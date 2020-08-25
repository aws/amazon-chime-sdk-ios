//
//  VideoTileCell.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import UIKit

let videoTileCellReuseIdentifier = "VideoTileCell"

protocol VideoTileCellDelegate: class {
    func onTileButtonClicked(tag: Int, selected: Bool)
}

class VideoTileCell: UICollectionViewCell {
    @IBOutlet var attendeeName: UILabel!
    @IBOutlet var shadedView: UIView!
    @IBOutlet var onTileButton: UIButton!
    @IBOutlet var onTileImage: UIImageView!
    @IBOutlet var videoRenderView: DefaultVideoRenderView!

    weak var delegate: VideoTileCellDelegate?

    func updateCell(name: String, isSelf: Bool, videoTileState: VideoTileState?, tag: Int) {
        let isVideoActive = videoTileState != nil
        let isVideoPausedByUser = isVideoActive && videoTileState?.pauseState == .pausedByUserRequest

        attendeeName.text = name
        backgroundColor = .systemGray
        isHidden = false

        // Clean up old video image to prevent frame flicker
        videoRenderView.renderFrame(frame: nil)

        // Self video cell not active
        if isSelf, !isVideoActive {
            onTileButton.isHidden = true
            onTileImage.isHidden = false
            return
        }

        onTileImage.isHidden = true
        videoRenderView.isHidden = false
        videoRenderView.accessibilityIdentifier = "\(name) VideoTile"

        onTileButton.tintColor = .white
        onTileButton.isHidden = false
        onTileButton.tag = tag
        onTileButton.addTarget(self, action: #selector(onTileButtonClicked), for: .touchUpInside)
        onTileButton.isSelected = isVideoPausedByUser

        if isSelf {
            onTileButton.setImage(UIImage(named: "switch-camera")?.withRenderingMode(.alwaysTemplate),
                                  for: .normal)
        } else {
            onTileButton.setImage(UIImage(named: "pause-video")?.withRenderingMode(.alwaysTemplate),
                                  for: .normal)
            onTileButton.setImage(UIImage(named: "resume-video")?.withRenderingMode(.alwaysTemplate),
                                  for: .selected)
        }
    }

    override func prepareForReuse() {
        accessibilityIdentifier = nil
        attendeeName.isHidden = false
        contentView.isHidden = false
        isHidden = true

        onTileButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        shadedView.isHidden = false
        videoRenderView.backgroundColor = .systemGray
        videoRenderView.isHidden = true
        videoRenderView.mirror = false
    }

    @objc func onTileButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.onTileButtonClicked(tag: sender.tag, selected: sender.isSelected)
        if sender.tag == 0 {
            videoRenderView.mirror = !videoRenderView.mirror
        }
    }
}
