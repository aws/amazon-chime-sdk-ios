//
//  VideoFrameResender.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import CoreMedia

/// `VideoFrameResender` contains logic to resend video frames as needed to maintain a minimum framerate
/// This can be useful with sources which may pause the generation of frames (like in-app ReplayKit screen sharing)
/// so that internally encoders don't get in a poor state, and new receivers can immediately receive frames
@objcMembers public class VideoFrameResender: NSObject {
    private let minFramerate: UInt
    private let resendQueue = DispatchQueue.global()
    // Will be nil until the first frame is sent, and nil again on stop
    private var resendTimer: DispatchSourceTimer?
    // Cached constant values
    private let resendTimeInterval: CMTime
    private let resendScheduleLeewayMs = DispatchTimeInterval.milliseconds(20)

    private var lastSendTimestamp: CMTime?
    private var lastVideoFrame: VideoFrame?

    private let resendFrameHandler: (VideoFrame) -> Void

    /// Callback will be triggered with a previous `VideoFrame` which will have different timestamp
    /// then originally sent with so it won't be dropped by downstream encoders
    init(minFramerate: UInt, resendFrameHandler: @escaping (VideoFrame) -> Void) {
        self.minFramerate = minFramerate
        self.resendFrameHandler = resendFrameHandler
        self.resendTimeInterval = CMTime(value: CMTimeValue(Constants.millisecondsPerSecond / Int(minFramerate)),
                                      timescale: CMTimeScale(Constants.millisecondsPerSecond))
    }

    func stop() {
        resendTimer?.cancel()
        resendTimer = nil
    }

    /// Calling this function will kick off a timer which will begin checking if frames need to be resent
    /// to maintain a minimum frame frame
    func frameDidSend(videoFrame: VideoFrame) {
        lastSendTimestamp = CMClockGetTime(CMClockGetHostTimeClock())
        lastVideoFrame = videoFrame

        if let resendTimer = resendTimer,
           resendTimer.isCancelled == false {
            // There is already a timer running
            return
        }
        let timer = DispatchSource.makeTimerSource(flags: .strict, queue: resendQueue)
        resendTimer = timer

        // This timer is invoked every resendTimeInterval when no frame is sent from video source
        timer.setEventHandler(handler: { [weak self] in
            guard let `self` = self else {
                timer.cancel()
                return
            }

            guard let lastSendTimestamp = self.lastSendTimestamp,
                  let lastVideoFrame = self.lastVideoFrame else { return }

            let currentTimestamp = CMClockGetTime(CMClockGetHostTimeClock())
            let delta = CMTimeSubtract(currentTimestamp, lastSendTimestamp)

            // Resend the last input frame if there is no new input frame after resendTimeInterval
            if delta > self.resendTimeInterval {
                // Update the timestamp so it's not dropped by downstream as a duplicate
                let lastVideoFrameTime = CMTimeMake(value: lastVideoFrame.timestampNs,
                                                    timescale: Int32(Constants.nanosecondsPerSecond))
                let newVideoFrame = VideoFrame(timestampNs: Int64(CMTimeAdd(lastVideoFrameTime, delta).seconds
                                                                    * Double(Constants.nanosecondsPerSecond)),
                                               rotation: lastVideoFrame.rotation,
                                               buffer: lastVideoFrame.buffer)

                // Cancel the current timer so that new frames will kick it off again
                self.resendTimer?.cancel()
                self.resendTimer = nil

                self.resendFrameHandler(newVideoFrame)
            } else {
                // Reset resending schedule if there is an input frame between internals
                let remainingSeconds = self.resendTimeInterval.seconds - delta.seconds
                let deadline = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(remainingSeconds *
                                                           Double(Constants.millisecondsPerSecond)))
                self.resendTimer?.schedule(deadline: deadline, leeway: self.resendScheduleLeewayMs)
            }

        })

        let deadline = DispatchTime.now()
            + DispatchTimeInterval.milliseconds(Constants.millisecondsPerSecond / Int(minFramerate))
        timer.schedule(deadline: deadline, leeway: resendScheduleLeewayMs)
        timer.activate()
    }
}
