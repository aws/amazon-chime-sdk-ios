//
//  DefaultMeetingEventReporterFactory.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers public class DefaultMeetingEventReporterFactory: EventReporterFactory {
    private let ingestionConfiguration: IngestionConfiguration
    private let logger: Logger

    public init(ingestionConfiguration: IngestionConfiguration, logger: Logger) {
        self.ingestionConfiguration = ingestionConfiguration
        self.logger = logger
    }

    public func createEventReporter() -> EventReporter? {
        if ingestionConfiguration.disabled {
            return nil
        }

        let converter = IngestionEventConverter()
        let sqliteManager = SQLiteDatabaseManager(sqliteClient: SQLiteClient(databaseName: "AmazonChimeSDKEvents.db",
                                                                             logger: logger))
        let eventDao = EventSQLiteDao(sqliteManager: sqliteManager, logger: logger)
        let dirtyEventDao = DirtyEventSQLiteDao(sqliteManager: sqliteManager, logger: logger)
        let eventSender = DefaultEventSender(ingestionConfiguration: ingestionConfiguration, logger: logger)
        let eventBuffer = DefaultEventBuffer(ingestionConfiguration: ingestionConfiguration,
                                            eventDao: eventDao,
                                            dirtyEventDao: dirtyEventDao,
                                            converter: converter,
                                            eventSender: eventSender,
                                            logger: logger)

        return DefaultEventReporter(ingestionConfiguration: ingestionConfiguration,
                                                 eventBuffer: eventBuffer,
                                                 logger: logger)
    }
}
