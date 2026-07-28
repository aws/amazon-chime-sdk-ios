//
//  DefaultEventReporterTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Cuckoo
import XCTest

class DefaultEventReporterTests: XCTestCase {
    private var eventBuffer: MockEventBuffer!
    private var logger: MockLogger!
    private var timer: MockScheduler!

    private let clientConfigurationMock = MeetingEventClientConfiguration(eventClientJoinToken: "", meetingId: "meetingId", attendeeId: "attendeeId")
    private let ingestionUrl = "ingestionUrl"
    private let ingestionRecord = IngestionRecord(metadata: [:],
                                                  events: [IngestionEvent(type: "Meet",
                                                                          metadata: [:],
                                                                          payloads: [IngestionPayload(name: "aeeee", ts: 1232132)])])
    private let emptyIngestionRecord = IngestionRecord(metadata: [:], events: [])

    override func setUp() {
        eventBuffer = MockEventBuffer().withEnabledDefaultImplementation(EventBufferStub())
        logger = MockLogger().withEnabledDefaultImplementation(LoggerStub())
        timer = MockScheduler().withEnabledDefaultImplementation(SchedulerStub())
        stub(eventBuffer) { stub in
            when(stub.process()).thenDoNothing()
        }
    }

    func testDefaultEventReporterShouldCallIntervalSchedulerStartIfDisabledIsTrue() {
        let ingestionUrl = "ingestionUrl"
        let ingestionConfiguration = IngestionConfigurationBuilder().build(disabled: true,
                                                                           ingestionUrl: ingestionUrl,
                                                                           clientConiguration: clientConfigurationMock)
        DefaultEventReporter(ingestionConfiguration: ingestionConfiguration,
                             eventBuffer: eventBuffer,
                             logger: logger)

        verify(eventBuffer, never()).process()
    }

    func testDefaultEventReporterShouldCallIntervalSchedulerStartIfDisabledIsFalse() {
        let ingestionConfiguration = IngestionConfigurationBuilder().build(disabled: false,
                                                                           ingestionUrl: ingestionUrl,
                                                                           clientConiguration: clientConfigurationMock)

        DefaultEventReporter(ingestionConfiguration: ingestionConfiguration,
                             eventBuffer: eventBuffer,
                             logger: logger,
                             timer: timer)

    
        verify(timer, times(1)).start()
    }
}
