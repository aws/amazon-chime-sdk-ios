//
//  DefaultVideoRenderView.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import os
import UIKit
import VideoToolbox

@objcMembers public class DefaultVideoRenderView: UIImageView, VideoRenderView {
    private let scalingContentModes: [UIView.ContentMode] = [.scaleAspectFill, .scaleToFill, .scaleAspectFit]

    public var mirror: Bool = false {
        didSet {
            transformNeedsUpdate = true
        }
    }

    override public var contentMode: UIView.ContentMode {
        willSet(newContentMode) {
            if !scalingContentModes.contains(newContentMode) {
                os_log("""
                Recommend to use a scaling ContentMode on the VideoRenderView,
                as video resolution may change during the session.
                """, type: .info)
            }
            imageView.contentMode = newContentMode
        }
    }

    // Delay the transform until the next frame
    private var transformNeedsUpdate: Bool = false
    // We use an internal UIImageView so we can mirror
    // it without mirroring the entire view
    private var imageView: UIImageView

    public required init?(coder: NSCoder) {
        imageView = UIImageView()
        super.init(coder: coder)

        initImageView()
    }

    override public init(frame: CGRect) {
        imageView = UIImageView()
        super.init(frame: frame)

        initImageView()
    }

    private func initImageView() {
        addSubview(imageView)
        sendSubviewToBack(imageView)
        imageView.frame = bounds
        imageView.contentMode = contentMode
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    // Expects CVPixelBuffer as frame type
    public func renderFrame(frame: CVPixelBuffer?) {
        if frame == nil {
            isHidden = true
        } else if let frame = frame {
            isHidden = false
            var cgImage: CGImage?
            VTCreateCGImageFromCVPixelBuffer(frame, options: nil, imageOut: &cgImage)
            if cgImage == nil {
                return
            }

            if transformNeedsUpdate {
                transformNeedsUpdate = false
                if mirror {
                    imageView.transform = CGAffineTransform(scaleX: -1, y: 1)
                } else {
                    imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            }
            imageView.image = UIImage(cgImage: cgImage!)
        }
    }
}
