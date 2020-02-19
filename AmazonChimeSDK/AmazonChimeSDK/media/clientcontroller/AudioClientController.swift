//
//  AudioClientController.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import AVFoundation
import Foundation

class AudioClientController: NSObject, AudioClientDelegate {
    private let audioPortOffset = 200
    private let defaultMicAndSpeaker = false
    private let defaultPresenter = true

    private var currentAudioState: SessionStateControllerAction
    private var currentAudioStatus: MeetingSessionStatusCode

    let audioClient: AudioClient = AudioClient.sharedInstance()
    var realtimeObservers: NSMutableSet = NSMutableSet()

    // TODO: This is workaround currently for having error
    // using Swift Set, which does not allow protocol to be typed in the Set
    // Other options is create a class/struct that implements protocol and
    // user will extends class/struct instead of protocol
    var audioClientStateObservers: NSMutableSet = NSMutableSet()

    static let sharedInstance = AudioClientController()

    override init() {
        currentAudioState = SessionStateControllerAction.initialize
        currentAudioStatus = MeetingSessionStatusCode.ok

        super.init()
        audioClient.delegate = self
    }

    public func volumeStateChanged(_ volumes: [AnyHashable: Any]!) {
        if volumes == nil {
            return
        }

        let attendeeVolumeMap = processAnyDictToStringIntDict(anyDict: volumes)
        realtimeObservers.forEach { element in
            if let realtimeObserver = element as? RealtimeObserver {
                realtimeObserver.onVolumeChange(attendeeVolumeMap: attendeeVolumeMap)
            }
        }
    }

    public func signalStrengthChanged(_ signalStrengths: [AnyHashable: Any]!) {
        if signalStrengths == nil {
            return
        }

        let attendeeSignalMap = processAnyDictToStringIntDict(anyDict: signalStrengths)
        realtimeObservers.forEach { element in
            if let realtimeObserver = element as? RealtimeObserver {
                realtimeObserver.onSignalStrengthChange(attendeeSignalMap: attendeeSignalMap)
            }
        }
    }

    private func processAnyDictToStringIntDict(anyDict: [AnyHashable: Any]) -> [String: Int] {
        var strIntDict = [String: Int]()
        for (key, value) in anyDict {
            let keyString: String? = key as? String
            let valueInt: Int? = value as? Int
            if keyString != nil, valueInt != nil {
                strIntDict[keyString!] = valueInt
            }
        }
        return strIntDict
    }

    func addRealtimeObserver(observer: RealtimeObserver) {
        realtimeObservers.add(observer)
    }

    func removeRealtimeObserver(observer: RealtimeObserver) {
        realtimeObservers.remove(observer)
    }

    public func setMicMute(mute: Bool) -> Bool {
        return audioClient.setMicrophoneMuted(mute) == Int(AUDIO_CLIENT_OK.rawValue)
    }

    public func start(audioHostUrl: String, meetingId: String, attendeeId: String, joinToken: String) throws {
        guard AVAudioSession.sharedInstance().recordPermission == .granted else {
            throw PermissionError.audioPermissionError
        }

        let url = audioHostUrl.components(separatedBy: ":")
        let host = url[0]
        var port = 0

        if url.count >= 2 {
            port = (url[1] as NSString).integerValue - audioPortOffset
        }

        forEachObserver { (observer: AudioVideoObserver) in
            observer.onAudioClientConnecting(reconnecting: false)
        }

        audioClient.setSpeakerOn(true)
        audioClient.startSession(AUDIO_CLIENT_TRANSPORT_DTLS,
                                 host: host,
                                 basePort: port,
                                 proxyCallback: nil,
                                 callId: meetingId,
                                 profileId: attendeeId,
                                 microphoneCodec: kCodecOpusLow,
                                 speakerCodec: kCodecOpusLow,
                                 microphoneMute: defaultMicAndSpeaker,
                                 speakerMute: defaultMicAndSpeaker,
                                 isPresenter: defaultPresenter,
                                 features: nil,
                                 sessionToken: joinToken,
                                 audioWsUrl: "",
                                 callKitEnabled: true)
    }

    public func stop() {
        audioClient.stopSession()
    }

    // TODO: Sigleton might not be always a good idea. Examine dependency injection
    public class func shared() -> AudioClientController {
        return sharedInstance
    }

    private func toAudioStatus(status: audio_client_status_t) -> MeetingSessionStatusCode {
        return MeetingSessionStatusCode(rawValue: status.rawValue) ?? .unknown
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

    private func forEachObserver(observerFunction: (_ observer: AudioVideoObserver) -> Void) {
        for observer in audioClientStateObservers {
            if let cObserver = (observer as? AudioVideoObserver) {
                observerFunction(cObserver)
            }
        }
    }

    private func handleStateChangeToConnected(newAudioStatus: MeetingSessionStatusCode) {
        switch currentAudioState {
        case .connecting:
            forEachObserver { (observer: AudioVideoObserver) in
                observer.onAudioClientStart(reconnecting: false)
            }
        case .reconnecting:
            forEachObserver { (observer: AudioVideoObserver) in
                observer.onAudioClientStart(reconnecting: true)
            }
        case .finishConnecting:
            switch (newAudioStatus, currentAudioStatus) {
            case (.ok, .networkBecomePoor):
                forEachObserver { (observer: AudioVideoObserver) in
                    observer.onConnectionRecover()
                }
            case (.networkBecomePoor, .ok):
                forEachObserver { (observer: AudioVideoObserver) in
                    observer.onConnectionBecomePoor()
                }
            default:
                // NOP
                break
            }
        default:
            // NOP
            break
        }
    }

    private func handleStateChangeToDisconnected() {
        switch currentAudioState {
        case .connecting,
             .finishConnecting:
            forEachObserver { (observer: AudioVideoObserver) in
                observer.onAudioClientStop(sessionStatus: MeetingSessionStatus(statusCode: MeetingSessionStatusCode.ok))
            }
        case .reconnecting:
            forEachObserver { (observer: AudioVideoObserver) in
                observer.onAudioClientReconnectionCancel()
            }
        default:
            break
        }
    }

    private func handleStateChangeToReconnected() {
        if currentAudioState == .finishConnecting {
            forEachObserver { (observer: AudioVideoObserver) in
                observer.onAudioClientStart(reconnecting: true)
            }
        }
    }

    private func handleStateChangeToFail(newAudioStatus: MeetingSessionStatusCode) {
        switch currentAudioState {
        case .connecting, .finishConnecting:
            forEachObserver { (observer: AudioVideoObserver) in
                observer.onAudioClientStop(sessionStatus: MeetingSessionStatus(statusCode: newAudioStatus))
            }
        case .reconnecting:
            forEachObserver { (observer: AudioVideoObserver) in
                observer.onAudioClientReconnectionCancel()
                observer.onAudioClientStop(sessionStatus: MeetingSessionStatus(statusCode: newAudioStatus))
            }
        default:
            break
        }
    }

    public func addObserver(observer: AudioVideoObserver) {
        audioClientStateObservers.add(observer)
    }

    public func removeObserver(observer: AudioVideoObserver) {
        audioClientStateObservers.remove(observer)
    }
}
