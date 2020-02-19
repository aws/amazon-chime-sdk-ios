//
//  DefaultAudioClientObserver.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

class DefaultAudioClientObserver: NSObject, AudioClientDelegate {
    private var audioClient: AudioClient
    private var audioClientStateObservers: NSMutableSet
    private var clientMetricsCollector: ClientMetricsCollector
    private var currentAudioState: SessionStateControllerAction
    private var currentAudioStatus: MeetingSessionStatusCode
    private var realtimeObservers: NSMutableSet

    init(audioClient: AudioClient, clientMetricsCollector: ClientMetricsCollector) {
        audioClientStateObservers = NSMutableSet()
        currentAudioState = SessionStateControllerAction.initialize
        currentAudioStatus = MeetingSessionStatusCode.ok
        realtimeObservers = NSMutableSet()

        self.audioClient = audioClient
        self.clientMetricsCollector = clientMetricsCollector

        super.init()

        audioClient.delegate = self
    }

    public func audioClientStateChanged(_ audioClientState: audio_client_state_t, status: audio_client_status_t) {
        let newAudioState = toAudioState(state: audioClientState)
        let newAudioStatus = toAudioStatus(status: status)

        if newAudioState == .unknown
            || (newAudioState == currentAudioState
                && newAudioStatus == currentAudioStatus) {
            return
        }

        switch newAudioState {
        case .finishConnecting:
            handleStateChangeToConnected(newAudioStatus: newAudioStatus)
        case .reconnecting:
            handleStateChangeToReconnected()
        case .finishDisconnecting:
            handleStateChangeToDisconnected()
        case .fail:
            handleStateChangeToFail(newAudioStatus: newAudioStatus)
        default:
            // NOP
            break
        }

        currentAudioState = newAudioState
        currentAudioStatus = newAudioStatus
    }

    public func audioMetricsChanged(_ metrics: [AnyHashable: Any]?) {
        if metrics == nil {
            return
        }

        clientMetricsCollector.processAudioClientMetrics(metrics: metrics!)
    }

    public func signalStrengthChanged(_ signalStrengths: [AnyHashable: Any]?) {
        if signalStrengths == nil {
            return
        }

        let attendeeSignalMap: [String: SignalStrength] = processAnyDictToStringEnumDict(anyDict: signalStrengths!)
        realtimeObservers.forEach { element in
            if let realtimeObserver = element as? RealtimeObserver {
                realtimeObserver.onSignalStrengthChange(attendeeSignalMap: attendeeSignalMap)
            }
        }
    }

    public func volumeStateChanged(_ volumes: [AnyHashable: Any]?) {
        if volumes == nil {
            return
        }

        let attendeeVolumeMap: [String: VolumeLevel] = processAnyDictToStringEnumDict(anyDict: volumes!)
        realtimeObservers.forEach { element in
            if let realtimeObserver = element as? RealtimeObserver {
                realtimeObserver.onVolumeChange(attendeeVolumeMap: attendeeVolumeMap)
            }
        }
    }

    private func handleStateChangeToConnected(newAudioStatus: MeetingSessionStatusCode) {
        switch currentAudioState {
        case .connecting:
            notifyAudioClientObserver { (observer: AudioVideoObserver) in
                observer.onAudioVideoStart(reconnecting: false)
            }
        case .reconnecting:
            notifyAudioClientObserver { (observer: AudioVideoObserver) in
                observer.onAudioVideoStart(reconnecting: true)
            }
        case .finishConnecting:
            switch (newAudioStatus, currentAudioStatus) {
            case (.ok, .networkBecomePoor):
                notifyAudioClientObserver { (observer: AudioVideoObserver) in
                    observer.onConnectionRecover()
                }
            case (.networkBecomePoor, .ok):
                notifyAudioClientObserver { (observer: AudioVideoObserver) in
                    observer.onConnectionBecomePoor()
                }
            default:
                break
            }
        default:
            break
        }
    }

    private func handleStateChangeToDisconnected() {
        switch currentAudioState {
        case .connecting,
             .finishConnecting:
            notifyAudioClientObserver { (observer: AudioVideoObserver) in
                observer.onAudioVideoStop(sessionStatus: MeetingSessionStatus(statusCode: MeetingSessionStatusCode.ok))
            }
        case .reconnecting:
            notifyAudioClientObserver { (observer: AudioVideoObserver) in
                observer.onAudioReconnectionCancel()
            }
        default:
            break
        }
    }

    private func handleStateChangeToFail(newAudioStatus: MeetingSessionStatusCode) {
        switch currentAudioState {
        case .connecting, .finishConnecting:
            notifyAudioClientObserver { (observer: AudioVideoObserver) in
                observer.onAudioVideoStop(sessionStatus: MeetingSessionStatus(statusCode: newAudioStatus))
            }
        case .reconnecting:
            notifyAudioClientObserver { (observer: AudioVideoObserver) in
                observer.onAudioReconnectionCancel()
                observer.onAudioVideoStop(sessionStatus: MeetingSessionStatus(statusCode: newAudioStatus))
            }
        default:
            break
        }
    }

    private func handleStateChangeToReconnected() {
        if currentAudioState == .finishConnecting {
            notifyAudioClientObserver { (observer: AudioVideoObserver) in
                observer.onAudioVideoStart(reconnecting: true)
            }
        }
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

    private func toAudioState(state: audio_client_state_t) -> SessionStateControllerAction {
        switch state {
        case AUDIO_CLIENT_STATE_UNKNOWN:
            return .unknown
        case AUDIO_CLIENT_STATE_INIT:
            return .initialize
        case AUDIO_CLIENT_STATE_CONNECTING:
            return .connecting
        case AUDIO_CLIENT_STATE_CONNECTED:
            return .finishConnecting
        case AUDIO_CLIENT_STATE_RECONNECTING:
            return .reconnecting
        case AUDIO_CLIENT_STATE_DISCONNECTING:
            return .disconnecting
        case AUDIO_CLIENT_STATE_DISCONNECTED_NORMAL:
            return .finishDisconnecting
        case AUDIO_CLIENT_STATE_DISCONNECTED_ABNORMAL,
             AUDIO_CLIENT_STATE_SERVER_HUNGUP,
             AUDIO_CLIENT_STATE_FAILED_TO_CONNECT:
            return .fail
        default:
            return .unknown
        }
    }

    private func toAudioStatus(status: audio_client_status_t) -> MeetingSessionStatusCode {
        return MeetingSessionStatusCode(rawValue: status.rawValue) ?? .unknown
    }
}

extension DefaultAudioClientObserver: AudioClientObserver {
    func notifyAudioClientObserver(observerFunction: (_ observer: AudioVideoObserver) -> Void) {
        for observer in audioClientStateObservers {
            if let cObserver = (observer as? AudioVideoObserver) {
                observerFunction(cObserver)
            }
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
}
