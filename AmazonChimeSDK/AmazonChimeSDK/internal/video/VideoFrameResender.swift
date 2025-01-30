//
//  VideoFrameResender.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import CoreMedia

/// `VideoFrameResender` contains logic to resend video frames as needed to maintain a minimum frame rate
/// This can be useful with sources which may pause the generation of frames (like in-app ReplayKit screen sharing)
/// so that internally encoders don't get in a poor state, and new receivers can immediately receive frames
@objcMembers public class VideoFrameResender: NSObject {
    
    // Create a serial queue for resending video frame
    private let resendQueue = DispatchQueue(label: "com.amazonaws.services.chime.VideoFrameResender")
    
    // Will be nil until the first frame is sent, and nil again on stop
    private let resendTimer: DispatchSourceTimer
    
    // Cached constant values
    private let resendScheduleLeewayMs = DispatchTimeInterval.milliseconds(20)
    
    private let logger: Logger
    
    private let lock = NSLock()
    
    private var lastSendTimestamp: CMTime?
    private var lastVideoFrame: VideoFrame?

    /// Callback will be triggered with a previous `VideoFrame` which will have different timestamp
    /// than originally sent with so it won't be dropped by downstream encoders
    init(minFrameRate: UInt,
         logger: Logger,
         resendFrameHandler: @escaping (VideoFrame) -> Void) {
        self.resendTimer = DispatchSource.makeTimerSource(flags: .strict, queue: resendQueue)
        self.logger = logger
        
        super.init()
        
        let minFrameInterval = Constants.millisecondsPerSecond / Int(minFrameRate)
        let resendTimeInterval:CMTime = CMTime(value: CMTimeValue(minFrameInterval),
                                         timescale: CMTimeScale(Constants.millisecondsPerSecond))
        
        self.resendTimer.setEventHandler(handler: { [weak self] in
            guard let `self` = self else {
                self?.resendTimer.cancel()
                self?.logger.error(msg: "Unable to resend video frame, VideoFrameResender is unavailable. Thread: \(Thread.current)")
                return
            }
            
            self.logger.info(msg: "Checking if there is pending frame for resending. Thread: \(Thread.current)")
            lock.lock()
            guard let lastSendTimestamp = self.lastSendTimestamp,
                  let lastVideoFrame = self.lastVideoFrame else { return }
            lock.unlock()

            self.logger.info(msg: "Checking the time elapsed for resending. Thread: \(Thread.current)")
            let currentTimestamp = CMClockGetTime(CMClockGetHostTimeClock())
            let delta = CMTimeSubtract(currentTimestamp, lastSendTimestamp)

            // Resend the last input frame if there is no new input frame after resendTimeInterval
            if delta > resendTimeInterval {
                self.logger.info(msg: "Creating new video frame for resending. Thread: \(Thread.current)")
                // Update the timestamp so it's not dropped by downstream as a duplicate
                let lastVideoFrameTime = CMTimeMake(value: lastVideoFrame.timestampNs,
                                                    timescale: Int32(Constants.nanosecondsPerSecond))
                let newVideoFrame = VideoFrame(timestampNs: Int64(CMTimeAdd(lastVideoFrameTime, delta).seconds
                                                                    * Double(Constants.nanosecondsPerSecond)),
                                               rotation: lastVideoFrame.rotation,
                                               buffer: lastVideoFrame.buffer)
                self.logger.info(msg: "Resending last frame. Thread: \(Thread.current)")
                resendFrameHandler(newVideoFrame)
            }
        })
        
        self.resendTimer.schedule(deadline: .now(),
                                  repeating: DispatchTimeInterval.milliseconds(minFrameInterval),
                                  leeway: resendScheduleLeewayMs)
        
        self.resendTimer.activate()
    }
    
    deinit {
        // Call stop on deinit to cancel`resendTimer` and queued tasks in `resendQueue`
        self.stop()
    }

    func stop() {
        // Stop `resendTimer` from scheduling in tasks
        self.resendTimer.cancel()
        
        // This will stop the queued tasks in resendQueue from running
        lock.lock()
        self.lastSendTimestamp = nil
        self.lastVideoFrame = nil
        lock.unlock()
    }

    /// Calling this function will kick off a timer which will begin checking if frames need to be resent
    /// to maintain a minimum frame frame
    func frameDidSend(videoFrame: VideoFrame) {
        lock.lock()
        lastSendTimestamp = CMClockGetTime(CMClockGetHostTimeClock())
        lastVideoFrame = videoFrame
        lock.unlock()
    }
}
