//
//  VideoTileCell.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import UIKit

class VideoTileCell: UICollectionViewCell {
    @IBOutlet var attendeeName: UILabel!
    @IBOutlet var shadedView: UIView!
    @IBOutlet var onTileButton: UIButton!
    @IBOutlet var onTileImage: UIImageView!
    @IBOutlet var videoRenderView: DefaultVideoRenderView!
}
