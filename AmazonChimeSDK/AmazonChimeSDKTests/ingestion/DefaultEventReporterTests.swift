//
//  DefaultEventReporterTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Mockingbird
import XCTest

class DefaultEventReporterTests: XCTestCase {
    private var eventBuffer: EventBufferMock!
    private var logger: LoggerMock!
    private var timer: SchedulerMock!

    private let clientConfigurationMock = MeetingEventClientConfiguration(eventClientJoinToken: "", meetingId: "meetingId", attendeeId: "attendeeId")
    private let ingestionUrl = "ingestionUrl"
    private let ingestionRecord = IngestionRecord(metadata: IngestionMetadata(), events: [IngestionEvent(type: "Meet",
                                                                                                         metadata: IngestionMetadata(),
                                                                                                         payloads: [IngestionPayload(name: "aeeee", ts: 1232132)])])
    private let emptyIngestionRecord = IngestionRecord(metadata: IngestionMetadata(), events: [])

    override func setUp() {
        eventBuffer = mock(EventBuffer.self)
        logger = mock(Logger.self)
        timer = mock(Scheduler.self)
        given(eventBuffer.process()).willReturn()
    }

    func testDefaultEventReporterShouldCallIntervalSchedulerStartIfDisabledIsTrue() {
        let ingestionUrl = "ingestionUrl"
        let ingestionConfiguration = IngestionConfigurationBuilder().build(disabled: true,
                                                                           ingestionUrl: ingestionUrl,
                                                                           clientConiguration: clientConfigurationMock)
        DefaultEventReporter(ingestionConfiguration: ingestionConfiguration,
                             eventBuffer: eventBuffer,
                             logger: logger)

        verify(eventBuffer.process()).wasNeverCalled()
    }

    func testDefaultEventReporterShouldCallIntervalSchedulerStartIfDisabledIsFalse() {
        let ingestionConfiguration = IngestionConfigurationBuilder().build(disabled: false,
                                                                           ingestionUrl: ingestionUrl,
                                                                           clientConiguration: clientConfigurationMock)

        DefaultEventReporter(ingestionConfiguration: ingestionConfiguration,
                             eventBuffer: eventBuffer,
                             logger: logger,
                             timer: timer)

    
        verify(timer.start()).wasCalled(1)
    }
}
