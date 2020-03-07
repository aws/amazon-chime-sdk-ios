//
//  DefaultVideoRenderView.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import UIKit
import VideoToolbox

@objcMembers public class DefaultVideoRenderView: UIImageView, VideoRenderView {
    public var mirror: Bool = false {
        didSet {
            transformNeedsUpdate = true
        }
    }
    // Delay the transform until the next frame
    private var transformNeedsUpdate: Bool = false
    // We use an internal UIImageView so we can mirror
    // it without mirroring the entire view
    private var imageView: UIImageView

    public required init?(coder: NSCoder) {
        imageView = UIImageView.init()
        super.init(coder: coder)

        addSubview(imageView)
        sendSubviewToBack(imageView)
        imageView.frame = bounds
        imageView.contentMode = contentMode
    }

    // Expects CVPixelBuffer as frame type
    public func renderFrame(frame: Any?) {
        if frame == nil {
            isHidden = true
            return
        }

        isHidden = false
        // CF types don't work well with swift casting so force cast is required
        // We check the type ID as a necessary precaution
        if CFGetTypeID(frame as CFTypeRef?) == CVPixelBufferGetTypeID() {
            var cgImage: CGImage?
            // swiftlint:disable:next force_cast
            VTCreateCGImageFromCVPixelBuffer((frame as! CVPixelBuffer), options: nil, imageOut: &cgImage)
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
