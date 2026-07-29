//
//  InternalAudioSpies.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import AmazonChimeSDKMedia
import AVFoundation
import Foundation

class AudioLockSpy: AudioLock {
    var lockCallCount = 0
    var unlockCallCount = 0

    func lock() { lockCallCount += 1 }
    func unlock() { unlockCallCount += 1 }
}

class AudioSessionSpy: AudioSession {
    var recordPermissionReturn: AVAudioSession.RecordPermission = .undetermined
    var availableInputsReturn: [AVAudioSessionPortDescription]?
    var currentRouteReturn: AVAudioSessionRouteDescription!
    /// Number of reads of `currentRoute`, for tests that verified the property getter.
    var currentRouteGetCount = 0

    var setPreferredInputCalls: [AVAudioSessionPortDescription?] = []
    var setPreferredInputError: Error?
    var overrideOutputAudioPortCalls: [AVAudioSession.PortOverride] = []
    var overrideOutputAudioPortError: Error?

    var recordPermission: AVAudioSession.RecordPermission { return recordPermissionReturn }
    var availableInputs: [AVAudioSessionPortDescription]? { return availableInputsReturn }
    var currentRoute: AVAudioSessionRouteDescription {
        currentRouteGetCount += 1
        return currentRouteReturn
    }

    func setPreferredInput(_ inPort: AVAudioSessionPortDescription?) throws {
        setPreferredInputCalls.append(inPort)
        if let error = setPreferredInputError { throw error }
    }

    func overrideOutputAudioPort(_ portOverride: AVAudioSession.PortOverride) throws {
        overrideOutputAudioPortCalls.append(portOverride)
        if let error = overrideOutputAudioPortError { throw error }
    }
}

class AudioClientProtocolSpy: AudioClientProtocol {
    // swiftlint:disable:next type_body_length
    struct StartSessionCall {
        let host: String?
        let port: Int
        let callId: String?
        let profileId: String?
        let microphoneMute: Bool
        let speakerMute: Bool
        let isPresenter: Bool
        let sessionToken: String?
        let audioWsUrl: String?
        let callKitEnabled: Bool
        let appInfo: AppInfo?
        let audioMode: AudioModeInternal
        let audioDeviceCapabilities: AudioDeviceCapabilitiesInternal
        let enableAudioRedundancy: Bool
        let reconnectTimeoutMs: Int
    }

    struct JoinPrimaryMeetingCall {
        let attendeeId: String?
        let externalUserId: String?
        let joinToken: String?
    }

    var delegate: AudioClientDelegate!

    var startSessionCalls: [StartSessionCall] = []
    var startSessionReturn: audio_client_status_t = AUDIO_CLIENT_OK
    var stopSessionCallCount = 0
    var stopSessionReturn = 0
    var isSpeakerOnCallCount = 0
    var isSpeakerOnReturn = false
    var setSpeakerOnCalls: [Bool] = []
    var setSpeakerOnReturn = false
    var stopAudioRecordCallCount = 0
    var stopAudioRecordReturn = 0
    var isMicrophoneMutedCallCount = 0
    var isMicrophoneMutedReturn = false
    var setMicrophoneMutedCalls: [Bool] = []
    var setMicrophoneMutedReturn = 0
    var setSpeakerMutedCalls: [Bool] = []
    var setSpeakerMutedReturn = 0
    var setPresenterCalls: [Bool] = []
    var remoteMuteCallCount = 0
    var audioLogCallBackCalls: [String?] = []
    var isBliteNSSelectedCallCount = 0
    var isBliteNSSelectedReturn = false
    var setBliteNSSelectedCalls: [Bool] = []
    var setBliteNSSelectedReturn = 0
    var endOnHoldCallCount = 0
    var joinPrimaryMeetingCalls: [JoinPrimaryMeetingCall] = []
    var leavePrimaryMeetingCallCount = 0

    // Parameter names mirror the ObjC Media interface, as AudioClientProtocol does.
    // swiftlint:disable function_parameter_count identifier_name
    func startSession(_ host: String!,
                      basePort port: Int,
                      callId: String!,
                      profileId: String!,
                      microphoneMute mic_mute: Bool,
                      speakerMute spk_mute: Bool,
                      isPresenter presenter: Bool,
                      sessionToken tokenString: String!,
                      audioWsUrl: String!,
                      callKitEnabled: Bool,
                      appInfo: AppInfo!,
                      audioMode: AudioModeInternal,
                      audioDeviceCapabilities: AudioDeviceCapabilitiesInternal,
                      enableAudioRedundancy: Bool,
                      reconnectTimeoutMs: Int) -> audio_client_status_t {
        startSessionCalls.append(StartSessionCall(host: host,
                                                 port: port,
                                                 callId: callId,
                                                 profileId: profileId,
                                                 microphoneMute: mic_mute,
                                                 speakerMute: spk_mute,
                                                 isPresenter: presenter,
                                                 sessionToken: tokenString,
                                                 audioWsUrl: audioWsUrl,
                                                 callKitEnabled: callKitEnabled,
                                                 appInfo: appInfo,
                                                 audioMode: audioMode,
                                                 audioDeviceCapabilities: audioDeviceCapabilities,
                                                 enableAudioRedundancy: enableAudioRedundancy,
                                                 reconnectTimeoutMs: reconnectTimeoutMs))
        return startSessionReturn
    }
    // swiftlint:enable function_parameter_count identifier_name

    func stopSession() -> Int {
        stopSessionCallCount += 1
        return stopSessionReturn
    }

    func isSpeakerOn() -> Bool {
        isSpeakerOnCallCount += 1
        return isSpeakerOnReturn
    }

    func setSpeakerOn(_ value: Bool) -> Bool {
        setSpeakerOnCalls.append(value)
        return setSpeakerOnReturn
    }

    func stopAudioRecord() -> Int {
        stopAudioRecordCallCount += 1
        return stopAudioRecordReturn
    }

    func isMicrophoneMuted() -> Bool {
        isMicrophoneMutedCallCount += 1
        return isMicrophoneMutedReturn
    }

    func setMicrophoneMuted(_ mute: Bool) -> Int {
        setMicrophoneMutedCalls.append(mute)
        return setMicrophoneMutedReturn
    }

    func setSpeakerMuted(_ mute: Bool) -> Int {
        setSpeakerMutedCalls.append(mute)
        return setSpeakerMutedReturn
    }

    func setPresenter(_ presenter: Bool) { setPresenterCalls.append(presenter) }
    func remoteMute() { remoteMuteCallCount += 1 }

    func audioLogCallBack(_ logLevel: loglevel_t, msg: String!) {
        audioLogCallBackCalls.append(msg)
    }

    func isBliteNSSelected() -> Bool {
        isBliteNSSelectedCallCount += 1
        return isBliteNSSelectedReturn
    }

    func setBliteNSSelected(_ bliteSelected: Bool) -> Int {
        setBliteNSSelectedCalls.append(bliteSelected)
        return setBliteNSSelectedReturn
    }

    func endOnHold() { endOnHoldCallCount += 1 }

    func joinPrimaryMeeting(_ attendeeId: String!, externalUserId: String!, joinToken: String!) {
        joinPrimaryMeetingCalls.append(JoinPrimaryMeetingCall(attendeeId: attendeeId,
                                                             externalUserId: externalUserId,
                                                             joinToken: joinToken))
    }

    func leavePrimaryMeeting() { leavePrimaryMeetingCallCount += 1 }
}

class AudioClientObserverSpy: AudioClientObserver {
    var audioStatusReturn: MeetingSessionStatusCode = .ok

    var notifyAudioClientObserverCallCount = 0
    var subscribeToAudioClientStateChangeCalls: [AudioVideoObserver] = []
    var subscribeToRealTimeEventsCalls: [RealtimeObserver] = []
    var unsubscribeFromAudioClientStateChangeCalls: [AudioVideoObserver] = []
    var unsubscribeFromRealTimeEventsCalls: [RealtimeObserver] = []
    var subscribeToTranscriptEventCalls: [TranscriptEventObserver] = []
    var unsubscribeFromTranscriptEventCalls: [TranscriptEventObserver] = []
    var setPrimaryMeetingPromotionObserverCalls: [PrimaryMeetingPromotionObserver] = []

    var audioStatus: MeetingSessionStatusCode { return audioStatusReturn }

    func notifyAudioClientObserver(observerFunction: @escaping (_ observer: AudioVideoObserver) -> Void) {
        notifyAudioClientObserverCallCount += 1
    }

    func subscribeToAudioClientStateChange(observer: AudioVideoObserver) {
        subscribeToAudioClientStateChangeCalls.append(observer)
    }

    func subscribeToRealTimeEvents(observer: RealtimeObserver) {
        subscribeToRealTimeEventsCalls.append(observer)
    }

    func unsubscribeFromAudioClientStateChange(observer: AudioVideoObserver) {
        unsubscribeFromAudioClientStateChangeCalls.append(observer)
    }

    func unsubscribeFromRealTimeEvents(observer: RealtimeObserver) {
        unsubscribeFromRealTimeEventsCalls.append(observer)
    }

    func subscribeToTranscriptEvent(observer: TranscriptEventObserver) {
        subscribeToTranscriptEventCalls.append(observer)
    }

    func unsubscribeFromTranscriptEvent(observer: TranscriptEventObserver) {
        unsubscribeFromTranscriptEventCalls.append(observer)
    }

    func setPrimaryMeetingPromotionObserver(observer: PrimaryMeetingPromotionObserver) {
        setPrimaryMeetingPromotionObserverCalls.append(observer)
    }
}

class AudioClientControllerSpy: AudioClientController {
    struct StartCall {
        let audioFallbackUrl: String
        let audioHostUrl: String
        let meetingId: String
        let attendeeId: String
        let joinToken: String
        let callKitEnabled: Bool
        let audioMode: AudioMode
        let audioDeviceCapabilities: AudioDeviceCapabilities
        let enableAudioRedundancy: Bool
        let reconnectTimeoutMs: Int
    }

    struct PromoteToPrimaryMeetingCall {
        let credentials: MeetingSessionCredentials
        let observer: PrimaryMeetingPromotionObserver
    }

    var setMuteCalls: [Bool] = []
    var setMuteReturn = false
    var setPlaybackMuteCalls: [Bool] = []
    var setPlaybackMuteReturn = false
    var startCalls: [StartCall] = []
    var startError: Error?
    var stopCallCount = 0
    var setVoiceFocusEnabledCalls: [Bool] = []
    var setVoiceFocusEnabledReturn = false
    var isVoiceFocusEnabledCallCount = 0
    var isVoiceFocusEnabledReturn = false
    var promoteToPrimaryMeetingCalls: [PromoteToPrimaryMeetingCall] = []
    var demoteFromPrimaryMeetingCallCount = 0

    func setMute(mute: Bool) -> Bool {
        setMuteCalls.append(mute)
        return setMuteReturn
    }

    func setPlaybackMute(mute: Bool) -> Bool {
        setPlaybackMuteCalls.append(mute)
        return setPlaybackMuteReturn
    }

    // swiftlint:disable:next function_parameter_count
    func start(audioFallbackUrl: String,
               audioHostUrl: String,
               meetingId: String,
               attendeeId: String,
               joinToken: String,
               callKitEnabled: Bool,
               audioMode: AudioMode,
               audioDeviceCapabilities: AudioDeviceCapabilities,
               enableAudioRedundancy: Bool,
               reconnectTimeoutMs: Int) throws {
        startCalls.append(StartCall(audioFallbackUrl: audioFallbackUrl,
                                    audioHostUrl: audioHostUrl,
                                    meetingId: meetingId,
                                    attendeeId: attendeeId,
                                    joinToken: joinToken,
                                    callKitEnabled: callKitEnabled,
                                    audioMode: audioMode,
                                    audioDeviceCapabilities: audioDeviceCapabilities,
                                    enableAudioRedundancy: enableAudioRedundancy,
                                    reconnectTimeoutMs: reconnectTimeoutMs))
        if let error = startError { throw error }
    }

    func stop() { stopCallCount += 1 }

    func setVoiceFocusEnabled(enabled: Bool) -> Bool {
        setVoiceFocusEnabledCalls.append(enabled)
        return setVoiceFocusEnabledReturn
    }

    func isVoiceFocusEnabled() -> Bool {
        isVoiceFocusEnabledCallCount += 1
        return isVoiceFocusEnabledReturn
    }

    func promoteToPrimaryMeeting(credentials: MeetingSessionCredentials,
                                 observer: PrimaryMeetingPromotionObserver) {
        promoteToPrimaryMeetingCalls.append(PromoteToPrimaryMeetingCall(credentials: credentials,
                                                                       observer: observer))
    }

    func demoteFromPrimaryMeeting() { demoteFromPrimaryMeetingCallCount += 1 }
}
