//
//  ActiveSpeakerDetectorTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@testable import AmazonChimeSDK
import XCTest

class MockaudioClientObserver: AudioClientObserver {
    func notifyAudioClientObserver(observerFunction: (AudioVideoObserver) -> Void) {}
    func subscribeToAudioClientStateChange(observer: AudioVideoObserver) {}
    func subscribeToRealTimeEvents(observer: RealtimeObserver) {}
    func unsubscribeFromAudioClientStateChange(observer: AudioVideoObserver) {}
    func unsubscribeFromRealTimeEvents(observer: RealtimeObserver) {}
}

class ActiveSpeakerDetectorTests: XCTestCase, ActiveSpeakerPolicy, ActiveSpeakerObserver, AudioClientObserver {
    let scores = [0.1, 0.2, 0.3, 0.4, 0.5]
    let volumes: [VolumeLevel] = [.muted, .notSpeaking, .low, .medium, .high]
    var attendees = [AttendeeInfo]()
    var volumeUpdates = [VolumeUpdate]()
    var attendeesReceived: [AttendeeInfo] = [AttendeeInfo(attendeeId: "", externalUserId: "")]
    var scoreChangeAttendees: [AttendeeInfo: Double] = [AttendeeInfo(attendeeId: "", externalUserId: ""): 0.0]
    var scoreIndex = 0
    var activeSpeakerDetector = DefaultActiveSpeakerDetector(
        audioClientObserver: MockaudioClientObserver(), selfAttendeeId: "")
    private let calculateScoreExpectation = XCTestExpectation(
        description: "Is fullfilled when calculateScore is called")
    private let prioritizeBandwidthExpectation = XCTestExpectation(
        description: "Is fullfilled when prioritizeVideoSendBandwidthForActiveSpeaker is called")
    private let subscribeToRealTimeEventsExpectation = XCTestExpectation(
        description: "Is fullfilled when subscribeToRealTimeEvents is called")
    private let unSubscribeFromRealTimeEventsExpectation = XCTestExpectation(
        description: "Is fullfilled when unsubscribeFromRealTimeEvents is called")
    private let onActiveSpeakerDetectExpectation = XCTestExpectation(
        description: "Is fullfilled when onActiveSpeakerDetect is called")
    private let onScoreChangeExpectation = XCTestExpectation(
        description: "Is fullfilled when onActiveSpeakerScoreChange is called")
    private let oneMilliSecondInSeconds = 0.001
    private let twoHundredMilliSecondsInSeconds = 0.2

    override func setUp() {
        for index in 0...4 {
            attendees.append(AttendeeInfo(
                attendeeId: "attendee" + String(index),
                externalUserId: "attendee" + String(index)))
            volumeUpdates.append(VolumeUpdate(attendeeInfo: attendees[index], volumeLevel: volumes[index]))
        }
        calculateScoreExpectation.expectedFulfillmentCount = 5
        prioritizeBandwidthExpectation.assertForOverFulfill = true
        subscribeToRealTimeEventsExpectation.assertForOverFulfill = true
        unSubscribeFromRealTimeEventsExpectation.assertForOverFulfill = true
        activeSpeakerDetector = DefaultActiveSpeakerDetector(audioClientObserver: self, selfAttendeeId: "attendee0")
        activeSpeakerDetector.addActiveSpeakerObserver(policy: self, observer: self)
        activeSpeakerDetector.onAttendeesJoin(attendeeInfo: attendees)
    }

    override func tearDown() {
        activeSpeakerDetector.removeActiveSpeakerObserver(observer: self)
    }

    func testActiveSpeakerDetectorShouldOnAttendeesJoinMakeExpectedCallbacks() {
        // received no attendees in callback because scores are not calculated until volumes are received
        XCTAssertEqual(attendeesReceived.isEmpty, true)
        calculateScoreExpectation.isInverted = true
        wait(for: [calculateScoreExpectation], timeout: oneMilliSecondInSeconds)
        prioritizeBandwidthExpectation.isInverted = true
        wait(for: [prioritizeBandwidthExpectation], timeout: oneMilliSecondInSeconds)
        wait(for: [subscribeToRealTimeEventsExpectation], timeout: oneMilliSecondInSeconds)
        unSubscribeFromRealTimeEventsExpectation.isInverted = true
        wait(for: [unSubscribeFromRealTimeEventsExpectation], timeout: oneMilliSecondInSeconds)
        wait(for: [onActiveSpeakerDetectExpectation], timeout: oneMilliSecondInSeconds)
    }

    func testActiveSpeakerDetectorShouldOnVolumeChangeMakeExpectedCallbacks() {
        activeSpeakerDetector.onVolumeChange(volumeUpdates: volumeUpdates)
        calculateScoreExpectation.expectedFulfillmentCount = 2
        wait(for: [calculateScoreExpectation], timeout: twoHundredMilliSecondsInSeconds)
        wait(for: [prioritizeBandwidthExpectation], timeout: oneMilliSecondInSeconds)
        wait(for: [subscribeToRealTimeEventsExpectation], timeout: oneMilliSecondInSeconds)
        unSubscribeFromRealTimeEventsExpectation.isInverted = true
        wait(for: [unSubscribeFromRealTimeEventsExpectation], timeout: oneMilliSecondInSeconds)
        wait(for: [onActiveSpeakerDetectExpectation], timeout: oneMilliSecondInSeconds)
        XCTAssertEqual(attendeesReceived, attendees.reversed())
    }

    func testActiveSpeakerDetectorMakesScoresCallback() {
        activeSpeakerDetector.onVolumeChange(volumeUpdates: volumeUpdates)
        wait(for: [onScoreChangeExpectation], timeout: TimeInterval(scoresCallbackIntervalMs))
        XCTAssertEqual(scoreChangeAttendees.map { $0.key }.sorted(), attendees.sorted())
    }

    func testActiveSpeakerDetectorShouldOnAttendeesLeaveReceiveCorrectActiveSpeakers() {
        activeSpeakerDetector.onVolumeChange(volumeUpdates: volumeUpdates)
        XCTAssertEqual(attendeesReceived, attendees.reversed())
        activeSpeakerDetector.onAttendeesLeave(attendeeInfo: [attendees[0], attendees[1]])
        let newVolumeUpdates = [volumeUpdates[2], volumeUpdates[3], volumeUpdates[4]]
        scoreIndex = 0
        activeSpeakerDetector.onVolumeChange(volumeUpdates: newVolumeUpdates)
        XCTAssertEqual(attendeesReceived, [attendees[4], attendees[3], attendees[2]])
    }

    func testActiveSpeakerDetectorShouldRemoveActiveSpeakerObserver() {
        activeSpeakerDetector.removeActiveSpeakerObserver(observer: self)
        activeSpeakerDetector.onAttendeesJoin(attendeeInfo: attendees)
        activeSpeakerDetector.onVolumeChange(volumeUpdates: volumeUpdates)
        usleep(useconds_t(300000))
        XCTAssertEqual(attendeesReceived, [])
    }

    func calculateScore(attendeeInfo: AttendeeInfo, volume: VolumeLevel) -> Double {
        calculateScoreExpectation.fulfill()
        let returnScore = scoreIndex < 5 ? scores[scoreIndex] : 0.0
        scoreIndex += 1
        return returnScore
    }

    func prioritizeVideoSendBandwidthForActiveSpeaker() -> Bool {
        prioritizeBandwidthExpectation.fulfill()
        return true
    }

    func subscribeToRealTimeEvents(observer: RealtimeObserver) {
        subscribeToRealTimeEventsExpectation.fulfill()
    }

    func unsubscribeFromRealTimeEvents(observer: RealtimeObserver) {
        unSubscribeFromRealTimeEventsExpectation.fulfill()
    }

    var observerId: String = "fakeObserverId"

    func onActiveSpeakerDetect(attendeeInfo: [AttendeeInfo]) {
        onActiveSpeakerDetectExpectation.fulfill()
        attendeesReceived = attendeeInfo
    }

    var scoresCallbackIntervalMs: Int = 1

    func onActiveSpeakerScoreChange(scores: [AttendeeInfo: Double]) {
        onScoreChangeExpectation.fulfill()
        scoreChangeAttendees = scores
    }

    func notifyAudioClientObserver(observerFunction: (AudioVideoObserver) -> Void) {}
    func subscribeToAudioClientStateChange(observer: AudioVideoObserver) {}
    func unsubscribeFromAudioClientStateChange(observer: AudioVideoObserver) {}
}
