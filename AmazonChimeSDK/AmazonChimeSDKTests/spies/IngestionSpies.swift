//
//  IngestionSpies.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Foundation

// Hand-written test spies: record the calls they receive so tests can assert on
// them afterwards, and expose settable `...Return` values where a return is needed.
// Unstubbed members no-op, which matches how the tests previously used mocks.

class EventDaoSpy: EventDao {
    var queryMeetingEventItemsCalls: [Int] = []
    var queryMeetingEventItemsReturn: [MeetingEventItem] = []

    var insertMeetingEventCalls: [MeetingEventItem] = []
    var insertMeetingEventReturn = false

    var deleteMeetingEventsByIdsCalls: [[String]] = []
    var deleteMeetingEventsByIdsReturn = false

    func queryMeetingEventItems(size: Int) -> [MeetingEventItem] {
        queryMeetingEventItemsCalls.append(size)
        return queryMeetingEventItemsReturn
    }

    func insertMeetingEvent(event: MeetingEventItem) -> Bool {
        insertMeetingEventCalls.append(event)
        return insertMeetingEventReturn
    }

    func deleteMeetingEventsByIds(ids: [String]) -> Bool {
        deleteMeetingEventsByIdsCalls.append(ids)
        return deleteMeetingEventsByIdsReturn
    }
}

class DirtyEventDaoSpy: DirtyEventDao {
    var queryDirtyMeetingEventItemsCalls: [Int] = []
    var queryDirtyMeetingEventItemsReturn: [DirtyMeetingEventItem] = []

    var deleteDirtyMeetingEventsByIdsCalls: [[String]] = []
    var deleteDirtyMeetingEventsByIdsReturn = false

    var insertDirtyMeetingEventItemsCalls: [[DirtyMeetingEventItem]] = []
    var insertDirtyMeetingEventItemsReturn = false

    func queryDirtyMeetingEventItems(size: Int) -> [DirtyMeetingEventItem] {
        queryDirtyMeetingEventItemsCalls.append(size)
        return queryDirtyMeetingEventItemsReturn
    }

    func deleteDirtyMeetingEventsByIds(ids: [String]) -> Bool {
        deleteDirtyMeetingEventsByIdsCalls.append(ids)
        return deleteDirtyMeetingEventsByIdsReturn
    }

    func insertDirtyMeetingEventItems(dirtyEvents: [DirtyMeetingEventItem]) -> Bool {
        insertDirtyMeetingEventItemsCalls.append(dirtyEvents)
        return insertDirtyMeetingEventItemsReturn
    }
}

class EventSenderSpy: EventSender {
    var sendEventsCalls: [IngestionRecord] = []
    /// When set, the recorded completion handler is invoked with this value.
    var sendEventsCompletionResult: Bool?

    func sendEvents(ingestionRecord: IngestionRecord, completionHandler: @escaping (Bool) -> Void) {
        sendEventsCalls.append(ingestionRecord)
        if let result = sendEventsCompletionResult {
            completionHandler(result)
        }
    }
}

class AppStateMonitorSpy: AppStateMonitor {
    weak var delegate: AppStateMonitorDelegate?
    var appStateReturn: AppState = .active
    var startCallCount = 0
    var stopCallCount = 0
    var getBatteryLevelCallCount = 0
    var getBatteryLevelReturn: NSNumber?
    var getBatteryStateCallCount = 0
    var getBatteryStateReturn: BatteryState = .unknown
    var isLowPowerModeEnabledCallCount = 0
    var isLowPowerModeEnabledReturn = false
    var getNetworkConnectionTypeCallCount = 0
    var getNetworkConnectionTypeReturn: NetworkConnectionType = .unknown

    var appState: AppState { return appStateReturn }

    func start() { startCallCount += 1 }
    func stop() { stopCallCount += 1 }

    func getBatteryLevel() -> NSNumber? {
        getBatteryLevelCallCount += 1
        return getBatteryLevelReturn
    }

    func getBatteryState() -> BatteryState {
        getBatteryStateCallCount += 1
        return getBatteryStateReturn
    }

    func isLowPowerModeEnabled() -> Bool {
        isLowPowerModeEnabledCallCount += 1
        return isLowPowerModeEnabledReturn
    }

    func getNetworkConnectionType() -> NetworkConnectionType {
        getNetworkConnectionTypeCallCount += 1
        return getNetworkConnectionTypeReturn
    }
}

class AppStateMonitorDelegateSpy: AppStateMonitorDelegate {
    var appStateDidChangeCalls: [AppState] = []
    var didReceiveMemoryWarningCallCount = 0
    var networkConnectionTypeDidChangeCalls: [NetworkConnectionType] = []

    func appStateDidChange(monitor: AppStateMonitor, newAppState: AppState) {
        appStateDidChangeCalls.append(newAppState)
    }

    func didReceiveMemoryWarning(monitor: AppStateMonitor) {
        didReceiveMemoryWarningCallCount += 1
    }

    func networkConnectionTypeDidChange(monitor: AppStateMonitor,
                                       newNetworkConnectionType: NetworkConnectionType) {
        networkConnectionTypeDidChangeCalls.append(newNetworkConnectionType)
    }
}

class EventBufferSpy: EventBuffer {
    var addCalls: [SDKEvent] = []
    var processCallCount = 0

    func add(item: SDKEvent) { addCalls.append(item) }
    func process() { processCallCount += 1 }
}

class EventReporterSpy: EventReporter {
    var reportCalls: [SDKEvent] = []
    var startCallCount = 0
    var stopCallCount = 0

    func report(event: SDKEvent) { reportCalls.append(event) }
    func start() { startCallCount += 1 }
    func stop() { stopCallCount += 1 }
}

class DatabaseClientSpy: DatabaseClient {
    struct StatementCall {
        let statement: String
        let params: [Any?]?
    }

    var closeCallCount = 0
    var closeReturn = false
    var queryCalls: [StatementCall] = []
    var queryReturn: [[String: Any?]] = []
    var writeCalls: [StatementCall] = []
    var writeReturn = false

    func close() -> Bool {
        closeCallCount += 1
        return closeReturn
    }

    func query(statement: String, params: [Any?]?) -> [[String: Any?]] {
        queryCalls.append(StatementCall(statement: statement, params: params))
        return queryReturn
    }

    func write(statement: String, params: [Any?]?) -> Bool {
        writeCalls.append(StatementCall(statement: statement, params: params))
        return writeReturn
    }
}

class DatabaseManagerSpy: DatabaseManager {
    struct QueryCall {
        let tableName: String
        let size: Int
    }

    struct InsertCall {
        let tableName: String
        let contentValue: [String: Any]
    }

    struct InsertMultiplesCall {
        let tableName: String
        let contentValues: [[String: Any]]
    }

    struct DeleteCall {
        let tableName: String
        let ids: [String]
    }

    var queryCalls: [QueryCall] = []
    var queryReturn: [[String: Any?]] = []
    var insertCalls: [InsertCall] = []
    var insertReturn = false
    var insertMultiplesCalls: [InsertMultiplesCall] = []
    var insertMultiplesReturn = false
    var deleteCalls: [DeleteCall] = []
    var deleteReturn = false
    var executeCalls: [String] = []
    var clearCalls: [String] = []

    func query(tableName: String, size: Int) -> [[String: Any?]] {
        queryCalls.append(QueryCall(tableName: tableName, size: size))
        return queryReturn
    }

    func insert(tableName: String, contentValue: [String: Any]) -> Bool {
        insertCalls.append(InsertCall(tableName: tableName, contentValue: contentValue))
        return insertReturn
    }

    func insertMultiples(tableName: String, contentValues: [[String: Any]]) -> Bool {
        insertMultiplesCalls.append(InsertMultiplesCall(tableName: tableName, contentValues: contentValues))
        return insertMultiplesReturn
    }

    func delete(tableName: String, ids: [String]) -> Bool {
        deleteCalls.append(DeleteCall(tableName: tableName, ids: ids))
        return deleteReturn
    }

    func execute(statement: String) { executeCalls.append(statement) }
    func clear(tableName: String) { clearCalls.append(tableName) }
}

class IngestionEventConverterSpy: IngestionEventConverter {
    var toIngestionMeetingEventCalls: [SDKEvent] = []
    var toIngestionMeetingEventReturn = IngestionMeetingEvent(name: "", eventAttributes: [:])

    var toIngestionRecordFromMeetingEventsCalls: [[MeetingEventItem]] = []
    var toIngestionRecordFromDirtyMeetingEventsCalls: [[DirtyMeetingEventItem]] = []
    var toIngestionRecordReturn = IngestionRecord(metadata: [:], events: [])

    override func toIngestionMeetingEvent(event: SDKEvent,
                                          ingestionConfiguration: IngestionConfiguration) -> IngestionMeetingEvent {
        toIngestionMeetingEventCalls.append(event)
        return toIngestionMeetingEventReturn
    }

    override func toIngestionRecord(meetingEvents: [MeetingEventItem],
                                    ingestionConfiguration: IngestionConfiguration) -> IngestionRecord {
        toIngestionRecordFromMeetingEventsCalls.append(meetingEvents)
        return toIngestionRecordReturn
    }

    override func toIngestionRecord(dirtyMeetingEvents: [DirtyMeetingEventItem],
                                    ingestionConfiguration: IngestionConfiguration) -> IngestionRecord {
        toIngestionRecordFromDirtyMeetingEventsCalls.append(dirtyMeetingEvents)
        return toIngestionRecordReturn
    }
}
