//
//  DefaultAudioClientObserver.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import Foundation

class DefaultAudioClientObserver: NSObject, AudioClientDelegate {
    private var audioClient: AudioClientProtocol
    private let audioClientStateObservers = ConcurrentMutableSet()
    private var clientMetricsCollector: ClientMetricsCollector
    private var configuration: MeetingSessionConfiguration
    private var currentAttendeeSet: Set<AttendeeInfo> = Set()
    private var currentAttendeeSignalMap = [AttendeeInfo: SignalStrength]()
    private var currentAttendeeVolumeMap = [AttendeeInfo: VolumeLevel]()
    private var currentAudioState = SessionStateControllerAction.initialize
    private var currentAudioStatus = MeetingSessionStatusCode.ok
    private let realtimeObservers = ConcurrentMutableSet()
    private let transcriptEventObservers = ConcurrentMutableSet()
    private let logger: Logger
    private let eventAnalyticsController: EventAnalyticsController
    private let meetingStatsCollector: MeetingStatsCollector
    private var primaryMeetingPromotionObserver: PrimaryMeetingPromotionObserver?

    private let audioLock: AudioLock

    init(audioClient: AudioClientProtocol,
         clientMetricsCollector: ClientMetricsCollector,
         audioClientLock: AudioLock,
         configuration: MeetingSessionConfiguration,
         logger: Logger,
         eventAnalyticsController: EventAnalyticsController,
         meetingStatsCollector: MeetingStatsCollector) {
        self.audioClient = audioClient
        self.clientMetricsCollector = clientMetricsCollector
        self.configuration = configuration
        self.logger = logger
        self.eventAnalyticsController = eventAnalyticsController
        self.meetingStatsCollector = meetingStatsCollector
        audioLock = audioClientLock
        super.init()
        audioClient.delegate = self
    }

    public func audioClientStateChanged(_ audioClientState: audio_client_state_t, status: audio_client_status_t) {
        let newAudioState = Converters.AudioClientState.toSessionStateControllerAction(state: audioClientState)
        let newAudioStatus = Converters.AudioClientStatus.toMeetingSessionStatusCode(status: status)

        if newAudioStatus == .unknown {
            logger.info(msg: "AudioClient State rawValue: \(audioClientState.rawValue) Unknown Status rawValue: \(status.rawValue)")
        } else {
            logger.info(msg: "AudioClient State: \(newAudioState) Status: \(newAudioStatus)")
        }

        if newAudioState == .unknown || (newAudioState == currentAudioState && newAudioStatus == currentAudioStatus) {
            return
        }

        switch newAudioState {
        case .finishConnecting:
            handleStateChangeToConnected(newAudioStatus: newAudioStatus)
        case .reconnecting:
            handleStateChangeToReconnecting()
        case .finishDisconnecting:
            handleStateChangeToDisconnected()
        case .fail:
            handleStateChangeToFail(newAudioStatus: newAudioStatus)
        default:
            break
        }

        currentAudioState = newAudioState
        currentAudioStatus = newAudioStatus
    }

    public func audioMetricsChanged(_ metrics: [AnyHashable: Any]?) {
        guard let metrics = metrics else { return }

        clientMetricsCollector.processAudioClientMetrics(metrics: metrics)
    }

    public func signalStrengthChanged(_ signalStrengths: [Any]?) {
        guard let signalUpdate = signalStrengths as? [AttendeeUpdate] else {
            return
        }

        let newAttendeeSignalMap = signalUpdate.reduce(into: [AttendeeInfo: SignalStrength]()) {
            let attendeeInfo = createAttendeeInfo(attendeeUpdate: $1)
            $0[attendeeInfo] = SignalStrength(rawValue: Int(truncating: $1.data))
        }

        let attendeeSignalDelta = newAttendeeSignalMap.subtracting(dict: currentAttendeeSignalMap)
        currentAttendeeSignalMap = newAttendeeSignalMap

        if !attendeeSignalDelta.isEmpty {
            let signalUpdates = attendeeSignalDelta.reduce(into: [SignalUpdate]()) {
                let signalUpdate = SignalUpdate(attendeeInfo: $1.key, signalStrength: $1.value)
                $0.append(signalUpdate)
            }
            ObserverUtils.forEach(observers: realtimeObservers) { (observer: RealtimeObserver) in
                observer.signalStrengthDidChange(signalUpdates: signalUpdates)
            }
        }
    }

    public func volumeStateChanged(_ volumes: [Any]?) {
        guard let volumesUpdate = volumes as? [AttendeeUpdate] else {
            return
        }
        let newAttendeeVolumeMap = volumesUpdate.reduce(into: [AttendeeInfo: VolumeLevel]()) {
            let attendeeInfo = createAttendeeInfo(attendeeUpdate: $1)
            $0[attendeeInfo] = VolumeLevel(rawValue: Int(truncating: $1.data))
        }

        let attendeeVolumeDelta = newAttendeeVolumeMap.subtracting(dict: currentAttendeeVolumeMap)
        attendeeMuteStateChange(attendeeVolumeDelta)
        currentAttendeeVolumeMap = newAttendeeVolumeMap
        if !attendeeVolumeDelta.isEmpty {
            let volumeUpdates = attendeeVolumeDelta.reduce(into: [VolumeUpdate]()) {
                let volumeUpdate = VolumeUpdate(attendeeInfo: $1.key, volumeLevel: $1.value)
                $0.append(volumeUpdate)
            }
            ObserverUtils.forEach(observers: realtimeObservers) { (observer: RealtimeObserver) in
                observer.volumeDidChange(volumeUpdates: volumeUpdates)
            }
        }
    }

    private func attendeeMuteStateChange(_ map: [AttendeeInfo: VolumeLevel]) {
        let attendeesMuted = map.filter { (_, value) -> Bool in
            value == .muted
        }
        if !attendeesMuted.isEmpty {
            ObserverUtils.forEach(observers: realtimeObservers) { (observer: RealtimeObserver) in
                observer.attendeesDidMute(attendeeInfo: [AttendeeInfo](attendeesMuted.keys))
            }
        }

        let attendeesUnmuted = map.filter { (key, _) -> Bool in
            currentAttendeeVolumeMap[key] == .muted
        }
        if !attendeesUnmuted.isEmpty {
            ObserverUtils.forEach(observers: realtimeObservers) { (observer: RealtimeObserver) in
                observer.attendeesDidUnmute(attendeeInfo: [AttendeeInfo](attendeesUnmuted.keys))
            }
        }
    }

    public func attendeesPresenceChanged(_ attendees: [Any]?) {
        if attendees == nil {
            return
        }

        guard let attendeeUpdate = attendees as? [AttendeeUpdate] else {
            return
        }

        let newAttendeeMap = attendeeUpdate
            .reduce(into: [AttendeeStatus: Set<AttendeeInfo>]()) { result, attendeeUpdate in
                if let status = AttendeeStatus(rawValue: Int(truncating: attendeeUpdate.data)) {
                    if result[status] == nil {
                        result[status] = Set<AttendeeInfo>()
                    }

                    result[status]?.insert(createAttendeeInfo(attendeeUpdate: attendeeUpdate))
                }
            }

        if let attendeesWithJoinedStatus = newAttendeeMap[AttendeeStatus.joined] {
            let attendeesJoined = attendeesWithJoinedStatus.subtracting(currentAttendeeSet)
            logger.info(msg: "attendeesJoined: \(attendeesJoined)")
            if !attendeesJoined.isEmpty {
                ObserverUtils.forEach(observers: realtimeObservers) { (observer: RealtimeObserver) in
                    observer.attendeesDidJoin(attendeeInfo: [AttendeeInfo](attendeesJoined))
                }
                currentAttendeeSet = currentAttendeeSet.union(attendeesJoined)
            }
        }

        if let attendeesWithLeftStatus = newAttendeeMap[AttendeeStatus.left] {
            if !attendeesWithLeftStatus.isEmpty {
                logger.info(msg: "attendeesLeft: \(attendeesWithLeftStatus)")
                ObserverUtils.forEach(observers: realtimeObservers) { (observer: RealtimeObserver) in
                    observer.attendeesDidLeave(attendeeInfo: [AttendeeInfo](attendeesWithLeftStatus))
                }
                currentAttendeeSet.subtract(attendeesWithLeftStatus)
            }
        }

        if let attendeesWithDroppedStatus = newAttendeeMap[AttendeeStatus.dropped] {
            if !attendeesWithDroppedStatus.isEmpty {
                logger.info(msg: "attendeesDropped: \(attendeesWithDroppedStatus)")
                ObserverUtils.forEach(observers: realtimeObservers) { (observer: RealtimeObserver) in
                    observer.attendeesDidDrop(attendeeInfo: [AttendeeInfo](attendeesWithDroppedStatus))
                }
                currentAttendeeSet.subtract(attendeesWithDroppedStatus)
            }
        }
    }

    public func transcriptEventsReceived(_ events: [Any]?) {
        guard let internalEvents = events as? [TranscriptEventInternal] else {
            return
        }

        internalEvents.forEach { rawEvent in
            var event: TranscriptEvent?;
            if let rawStatus = rawEvent as? TranscriptionStatusInternal {
                event = TranscriptionStatus(type: Converters.Transcript.toTranscriptionStatusType(type: rawStatus.type),
                                            eventTimeMs: rawStatus.eventTimeMs,
                                            transcriptionRegion: rawStatus.transcriptionRegion,
                                            transcriptionConfiguration: rawStatus.transcriptionConfiguration,
                                            message: rawStatus.message)
            } else if let rawTranscript = rawEvent as? TranscriptInternal {
                var results: [TranscriptResult] = []
                rawTranscript.results.forEach { rawResult in
                    var alternatives: [TranscriptAlternative] = []
                    var entities: [TranscriptEntity] = []
                    var languageIdentification: [TranscriptLanguageWithScore] = []
                    rawResult.alternatives.forEach { rawAlternative in
                        let items = rawAlternative.items.map {
                            TranscriptItem(type: Converters.Transcript.toTranscriptItemType(type: $0.type), startTimeMs: $0.startTimeMs,
                                           endTimeMs: $0.endTimeMs, attendee: Converters.Transcript.toAttendeeInfo(attendeeInfo: $0.attendee),
                                           content: $0.content, vocabularyFilterMatch: $0.vocabularyFilterMatch,
                                           stable: $0.stable, confidence: $0.confidence)
                        }
                
                        if rawAlternative.entities != nil {
                            entities = rawAlternative.entities.map {
                                TranscriptEntity(type: $0.type, content: $0.content, category: $0.category,
                                                 confidence: $0.confidence, startTimeMs: $0.startTimeMs, endTimeMs: $0.endTimeMs)
                            }
                        }
                       
                        let alternative = TranscriptAlternative(items: items, transcript: rawAlternative.transcript, entities: entities)
                        alternatives.append(alternative)
                    }
                    
                    
                    if rawResult.languageIdentification != nil {
                        languageIdentification = rawResult.languageIdentification.map {
                            TranscriptLanguageWithScore(languageCode: $0.languageCode, score: $0.score)
                        }
                    }
                    
                    let result = TranscriptResult(resultId: rawResult.resultId,
                                                  channelId: rawResult.channelId,
                                                  isPartial: rawResult.isPartial,
                                                  startTimeMs: rawResult.startTimeMs,
                                                  endTimeMs: rawResult.endTimeMs,
                                                  alternatives: alternatives,
                                                  languageCode: rawResult.languageCode,
                                                  languageIdentification: languageIdentification)
                    results.append(result)
                }
                event = Transcript(results: results)
            } else {
                self.logger.error(msg: "Received transcript event in unknown format")
            }

            if let transcriptEvent = event {
                ObserverUtils.forEach(observers: transcriptEventObservers) { (observer: TranscriptEventObserver) in
                        observer.transcriptEventDidReceive(transcriptEvent: transcriptEvent)
                }
            }
        }
    }

    public func primaryMeetingEventReceived(
        _ type: PrimaryMeetingEventTypeInternal,
        status: PrimaryMeetingEventStatusInternal) {
        let code: MeetingSessionStatusCode
        switch status {
        case PrimaryMeetingEventStatusInternal.Ok:
            code = MeetingSessionStatusCode.ok
        case PrimaryMeetingEventStatusInternal.CallAtCapacity:
            code = MeetingSessionStatusCode.audioCallAtCapacity
        case PrimaryMeetingEventStatusInternal.AuthenticationFailed:
            code = MeetingSessionStatusCode.audioAuthenticationRejected
        default:
            code = MeetingSessionStatusCode.unknown
        }

        switch type {
        case PrimaryMeetingEventTypeInternal.joinAck:
            self.primaryMeetingPromotionObserver?
                .didPromoteToPrimaryMeeting(status: MeetingSessionStatus(statusCode: code))
        case PrimaryMeetingEventTypeInternal.leave:
            self.primaryMeetingPromotionObserver?
                .didDemoteFromPrimaryMeeting(status: MeetingSessionStatus(statusCode: code))
            self.primaryMeetingPromotionObserver = nil
        default:
            self.logger.error(msg: "Unexpected primary meeting event type \(type)")
        }
    }

    // Create AttendeeInfo based on AttendeeUpdate, fill up external ID for local attendee
    private func createAttendeeInfo(attendeeUpdate: AttendeeUpdate) -> AttendeeInfo {
        var externalUserId: String
        if attendeeUpdate.externalUserId.isEmpty, attendeeUpdate.profileId == configuration.credentials.attendeeId {
            externalUserId = configuration.credentials.externalUserId
        } else {
            externalUserId = attendeeUpdate.externalUserId
        }
        return AttendeeInfo(attendeeId: attendeeUpdate.profileId, externalUserId: externalUserId)
    }

    private func handleStateChangeToConnected(newAudioStatus: MeetingSessionStatusCode) {
        switch currentAudioState {
        case .connecting:
            notifyStartSucceeded()
            notifyAudioClientObserver { (observer: AudioVideoObserver) in
                observer.audioSessionDidStart(reconnecting: false)
            }
        case .reconnecting:
            meetingStatsCollector.incrementRetryCount()
            eventAnalyticsController.pushHistory(historyEventName: .meetingReconnected)
            notifyStartSucceeded()
            notifyAudioClientObserver { (observer: AudioVideoObserver) in
                observer.audioSessionDidStart(reconnecting: true)
            }
            // We will not be promoted on reconnection
            self.primaryMeetingPromotionObserver?
                .didDemoteFromPrimaryMeeting(status: MeetingSessionStatus.init(statusCode: MeetingSessionStatusCode.audioInternalServerError))
            self.primaryMeetingPromotionObserver = nil
        case .finishConnecting:
            switch (newAudioStatus, currentAudioStatus) {
            case (.ok, .networkBecomePoor):
                notifyAudioClientObserver { (observer: AudioVideoObserver) in
                    observer.connectionDidRecover()
                }
            case (.networkBecomePoor, .ok):
                meetingStatsCollector.incrementPoorConnectionCount()
                notifyAudioClientObserver { (observer: AudioVideoObserver) in
                    observer.connectionDidBecomePoor()
                }
            default:
                break
            }
        default:
            break
        }
    }

    private func notifyStartSucceeded() {
        meetingStatsCollector.updateMeetingStartTimeMs()
        eventAnalyticsController.publishEvent(name: .meetingStartSucceeded)
    }

    private func handleStateChangeToDisconnected() {
        switch currentAudioState {
        case .connecting,
             .finishConnecting:
            // No-op, already handled in DefaultAudioClientController.stop()
            break
        case .reconnecting:
            notifyAudioClientObserver { (observer: AudioVideoObserver) in
                observer.audioSessionDidCancelReconnect()
            }
        default:
            break
        }
    }

    private func handleStateChangeToFail(newAudioStatus: MeetingSessionStatusCode) {
        switch currentAudioState {
        case .connecting, .finishConnecting:
            handleAudioSessionDidFail(newAudioStatus: newAudioStatus)
        case .reconnecting:
            notifyAudioClientObserver { (observer: AudioVideoObserver) in
                observer.audioSessionDidCancelReconnect()
            }
            handleAudioSessionDidFail(newAudioStatus: newAudioStatus)
        default:
            break
        }
    }

    private func handleStateChangeToReconnecting() {
        if currentAudioState == .finishConnecting {
            notifyAudioClientObserver { (observer: AudioVideoObserver) in
                observer.audioSessionDidDrop()
            }
        }
    }

    private func handleAudioSessionDidFail(newAudioStatus: MeetingSessionStatusCode) {
        if DefaultAudioClientController.state == .stopped {
            return
        }

        notifyFailed(status: newAudioStatus)

        DispatchQueue.global().async {
            self.audioLock.lock()
            self.audioClient.stopSession()
            DefaultAudioClientController.state = .stopped
            self.audioLock.unlock()
            self.notifyAudioClientObserver { (observer: AudioVideoObserver) in
                observer.audioSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus(statusCode: newAudioStatus))
            }
        }
    }

    private func notifyFailed(status: MeetingSessionStatusCode) {
        eventAnalyticsController.publishEvent(name: .meetingFailed,
                                              attributes: [EventAttributeName.meetingStatus: status,
                                                           EventAttributeName.meetingErrorMessage: String(describing: status)])
        meetingStatsCollector.resetMeetingStats()
    }

    private func processAnyDictToStringEnumDict<T: RawRepresentable>(anyDict: [AnyHashable: Any]) -> [String: T] {
        var strEnumDict = [String: T]()
        for (key, rawValue) in anyDict {
            if let keyString = key as? String, let rawValue = rawValue as? T.RawValue {
                if let value = T(rawValue: rawValue) {
                    strEnumDict[keyString] = value
                }
            }
        }
        return strEnumDict
    }
}

extension DefaultAudioClientObserver: AudioClientObserver {
    func notifyAudioClientObserver(observerFunction: @escaping (_ observer: AudioVideoObserver) -> Void) {
        ObserverUtils.forEach(observers: self.audioClientStateObservers) { (observer: AudioVideoObserver) in
            observerFunction(observer)
        }
    }

    func subscribeToAudioClientStateChange(observer: AudioVideoObserver) {
        audioClientStateObservers.add(observer)
    }

    func subscribeToRealTimeEvents(observer: RealtimeObserver) {
        realtimeObservers.add(observer)
    }

    func unsubscribeFromAudioClientStateChange(observer: AudioVideoObserver) {
        audioClientStateObservers.remove(observer)
    }

    func unsubscribeFromRealTimeEvents(observer: RealtimeObserver) {
        realtimeObservers.remove(observer)
    }

    func subscribeToTranscriptEvent(observer: TranscriptEventObserver) {
        transcriptEventObservers.add(observer)
    }

    func unsubscribeFromTranscriptEvent(observer: TranscriptEventObserver) {
        transcriptEventObservers.remove(observer)
    }

    func setPrimaryMeetingPromotionObserver(observer: PrimaryMeetingPromotionObserver) {
        primaryMeetingPromotionObserver = observer
    }
}
