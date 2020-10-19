//
//  VideoSourceAdapter.swift
//  AmazonChimeSDKMedia
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import CoreMedia
import Foundation

/// `VideoSourceAdapter` provides two classes to adapt `VideoSource` to `VideoSourceInternal`.
class VideoSourceAdapter: NSObject, VideoSink, VideoSourceInternal {
    var contentHint = VideoContentHintInternal.none

    private let sinks = ConcurrentMutableSet()

    private var currentSource: VideoSource?

    var source: VideoSource? {
        get { return currentSource }
        set(newSource) {
            currentSource?.removeVideoSink(sink: self)
            newSource?.addVideoSink(sink: self)
            currentSource = newSource
            contentHint = newSource?.videoContentHint.toInternal ?? VideoContentHintInternal.none
        }
    }

    override init() {
        super.init()
    }

    func onVideoFrameReceived(frame: VideoFrame) {
        guard let buffer = frame.buffer as? VideoFramePixelBuffer else {
            return
        }
        sinks.forEach { item in
            guard let sink = item as? VideoSinkInternal else { return }
            sink.didReceive(buffer.pixelBuffer,
                            timestampNs: Int64(frame.timestampNs),
                            rotation: frame.rotation.toInternal)
        }
    }

    func addVideoSink(_ sink: VideoSinkInternal?) {
        if let sink = sink {
            sinks.add(sink)
        }
    }

    func removeVideoSink(_ sink: VideoSinkInternal?) {
        if let sink = sink {
            sinks.remove(sink)
        }
    }
}
