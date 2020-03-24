//
//  ActiveSpeakerPolicyTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@testable import AmazonChimeSDK
import XCTest

class ActiveSpeakerPolicyTests: XCTestCase {
    private var activeSpeakerPolicy: DefaultActiveSpeakerPolicy = DefaultActiveSpeakerPolicy(
        speakerWeight: 0.9, cutoffThreshold: 0.01, takeoverRate: 0.2)
    private var attendeeA: AttendeeInfo = AttendeeInfo(
        attendeeId: "fakeAttendeeIdA", externalUserId: "fakeExternalUserIdA")
    private var attendeeB: AttendeeInfo = AttendeeInfo(
        attendeeId: "fakeAttendeeIdB", externalUserId: "fakeExternalUserIdB")

    private var speakerWeight = 0.9
    private var cutoffThreshold = 0.01
    private var takeoverRate = 0.2

    override func setUp() {
        super.setUp()
        activeSpeakerPolicy = DefaultActiveSpeakerPolicy(
            speakerWeight: speakerWeight,
            cutoffThreshold: cutoffThreshold,
            takeoverRate: takeoverRate)
    }

    func testActiveSpeakerShouldGetBandwidthPriority() {
        let prioritizeBandwidth = activeSpeakerPolicy.prioritizeVideoSendBandwidthForActiveSpeaker()
        XCTAssertEqual(prioritizeBandwidth, true)
    }

    func testActiveSpeakerShouldCalculateScoreWhenNotSpeakingOrMuted() {
        var score = activeSpeakerPolicy.calculateScore(attendeeInfo: attendeeA, volume: .muted)
        XCTAssertEqual(score, 0.0)

        score = activeSpeakerPolicy.calculateScore(attendeeInfo: attendeeA, volume: .notSpeaking)
        XCTAssertEqual(score, 0.0)
    }

    func testScoreShouldIncreaseAtExpectedRate() {
        let firstScore = activeSpeakerPolicy.calculateScore(attendeeInfo: attendeeA, volume: .medium)
        XCTAssertEqual(firstScore, 1 - speakerWeight)

        let secondScore = activeSpeakerPolicy.calculateScore(attendeeInfo: attendeeA, volume: .low)
        XCTAssertEqual(secondScore, firstScore * speakerWeight + (1.0 - speakerWeight))

        let thirdScore = activeSpeakerPolicy.calculateScore(attendeeInfo: attendeeA, volume: .high)
        XCTAssertEqual(thirdScore, secondScore * speakerWeight + (1.0 - speakerWeight))
    }

    func testScoreShouldDecreaseAtExpectedRate() {
        var previousScore = activeSpeakerPolicy.calculateScore(attendeeInfo: attendeeA, volume: .medium)
        var score = activeSpeakerPolicy.calculateScore(attendeeInfo: attendeeA, volume: .muted)
        XCTAssertEqual(score, previousScore * speakerWeight)

        previousScore = activeSpeakerPolicy.calculateScore(attendeeInfo: attendeeA, volume: .medium)
        score = activeSpeakerPolicy.calculateScore(attendeeInfo: attendeeA, volume: .notSpeaking)
        XCTAssertEqual(score, previousScore * speakerWeight)
    }

    func testActiveSpeakerScoreShouldTakeOver() {
        _ = activeSpeakerPolicy.calculateScore(attendeeInfo: attendeeA, volume: .medium)
        _ = activeSpeakerPolicy.calculateScore(attendeeInfo: attendeeA, volume: .medium)
        var scoreA = activeSpeakerPolicy.calculateScore(attendeeInfo: attendeeA, volume: .medium)
        _ = activeSpeakerPolicy.calculateScore(attendeeInfo: attendeeB, volume: .medium)
        scoreA -= takeoverRate
        let score = activeSpeakerPolicy.calculateScore(attendeeInfo: attendeeA, volume: .muted)
        XCTAssertEqual(score, scoreA * speakerWeight)
    }

    func testcutoffThresholdShouldDecreaseScoreToZero() {
        cutoffThreshold = 0.1
        activeSpeakerPolicy = DefaultActiveSpeakerPolicy(
            speakerWeight: speakerWeight,
            cutoffThreshold: cutoffThreshold,
            takeoverRate: takeoverRate)
        let score = activeSpeakerPolicy.calculateScore(attendeeInfo: attendeeA, volume: .high)
        XCTAssertEqual(score, 0.0)
    }
}
