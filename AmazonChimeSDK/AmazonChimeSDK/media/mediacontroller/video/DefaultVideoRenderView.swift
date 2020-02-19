//
//  DefaultVideoRenderView.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import UIKit

public class DefaultVideoRenderView: UIImageView, VideoRenderView {
    public func renderFrame(frame: Any?) {
        if let image = frame as? UIImage {
            self.isHidden = false
            self.image = image
        } else {
            self.isHidden = true
        }
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
