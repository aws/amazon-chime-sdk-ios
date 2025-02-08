//
//  VideoFrameResenderTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//


@testable import AmazonChimeSDK
import AmazonChimeSDKMedia
import Mockingbird
import XCTest

class VideoFrameResenderTests: CommonTestCase {
    
    let minFrameRate:UInt = 5
    let logger = ConsoleLogger(name:"test", level: .DEBUG)
    let videoFrameGenerator = VideoFrameGenerator()
    
    var testImage: UIImage!
    
    var invocationCount = 0

    override func setUp() {
        super.setUp()
        
        guard let testImage = UIImage(named: "background-ml-test-image.jpeg",
                                      in: Bundle(for: type(of: self)),
                                      compatibleWith: nil) else {
            XCTFail("Failed to load test image.")
            return
        }
        self.testImage = testImage
        self.invocationCount = 0
    }

    func testFrameDidSend_ResendTimerShoulrRunPeriodicallyWhenThereisFrame() {
        
        let timeout = 2
        let expectedCount = timeout * Int(minFrameRate)
        
        let _ = createAndRunResender(numberOfThreads: 1)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(timeout)) {
            XCTAssertTrue(
                ((expectedCount - 1)...(expectedCount + 1)).contains(self.invocationCount),
                "`handlerInvocationCount` should be close to expected count")
        }
    }
    
    func testFrameDidSend_NoCrashDuringWithMultipleFrameDidSend() {
        let _ = createAndRunResender(numberOfThreads: 10)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(true)
        }
    }
    
    
    func testFrameDidSend_NoCrashIfDestroyResenderDuringScheduledResendTasks() {
        var resender:VideoFrameResender? = createAndRunResender(numberOfThreads: 10)
        
        // Destroy resender in 2 seconds
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            resender = nil
        }
        
        // Should be no crash in 5 seconds
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(true)
        }
    }
    
    func testFrameDidSend_NoCrashIfStopResenderDuringScheduledResendTasks() {
        let resender = createAndRunResender(numberOfThreads: 10)
        
        // Stop resender in 2 seconds
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            resender.stop()
        }
        
        // Should be no crash in 5 seconds
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(true)
        }
    }
    
    private func createAndRunResender(numberOfThreads: Int) -> VideoFrameResender {
        let dispatchGroup = DispatchGroup()
        
        let resender:VideoFrameResender = VideoFrameResender(minFrameRate: self.minFrameRate,
                                                             logger: self.logger,
                                                             resendFrameHandler: { _ in
            self.invocationCount += 1
        })
        
        for _ in 1...numberOfThreads {
            let frame = self.videoFrameGenerator.generateVideoFrame(image: self.testImage)!
            DispatchQueue.global(qos: .background).async(group: dispatchGroup) {
                resender.frameDidSend(videoFrame: frame)
            }
        }
        
        dispatchGroup.wait()
        
        return resender
    }
}
