//
//  DefaultAudioClientController.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import AVFoundation
import Foundation

class DefaultAudioClientController: NSObject {
    static var state = AudioClientState.initialized
    private let audioLock: AudioLock
    private var audioClient: AudioClientProtocol
    private let audioClientObserver: AudioClientObserver
    private let audioSession: AudioSession
    private let audioPortOffset = 200
    private let muteMicAndSpeaker = false
    private let defaultPort = 0
    private let defaultPresenter = true
    private let eventAnalyticsController: EventAnalyticsController
    private let meetingStatsCollector: MeetingStatsCollector
    private let activeSpeakerDetector: ActiveSpeakerDetectorFacade
    private let logger: Logger

    init(audioClient: AudioClientProtocol,
         audioClientObserver: AudioClientObserver,
         audioSession: AudioSession,
         audioClientLock: AudioLock,
         eventAnalyticsController: EventAnalyticsController,
         meetingStatsCollector: MeetingStatsCollector,
         activeSpeakerDetector: ActiveSpeakerDetectorFacade,
         logger: Logger) {
        self.audioClient = audioClient
        self.audioClientObserver = audioClientObserver
        self.audioSession = audioSession
        audioLock = audioClientLock
        self.eventAnalyticsController = eventAnalyticsController
        self.meetingStatsCollector = meetingStatsCollector
        self.activeSpeakerDetector = activeSpeakerDetector
        self.logger = logger
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleMediaServiceReset),
                                               name: AVAudioSession.mediaServicesWereResetNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension DefaultAudioClientController: AudioClientController {
    public func setMute(mute: Bool) -> Bool {
        if Self.state == .started {
            return audioClient.setMicrophoneMuted(mute) == Int(AUDIO_CLIENT_OK.rawValue)
        } else {
            return false
        }
    }

    public func start(audioFallbackUrl: String,
                      audioHostUrl: String,
                      meetingId: String,
                      attendeeId: String,
                      joinToken: String,
                      callKitEnabled: Bool,
                      audioMode: AudioMode) throws {
        audioLock.lock()
        defer {
            audioLock.unlock()
        }
        
        if audioMode != .nodevice {
            guard audioSession.recordPermission == .granted else {
                throw PermissionError.audioPermissionError
            }
        }

        if Self.state == .started {
            throw MediaError.illegalState
        }

        if let defaultAudioClientObserver = audioClientObserver as? DefaultAudioClientObserver {
            DefaultAudioClient.shared(logger: logger).delegate = defaultAudioClientObserver
        }

        if let observer = activeSpeakerDetector as? RealtimeObserver {
            audioClientObserver.subscribeToRealTimeEvents(observer: observer)
        }

        let url = audioHostUrl.components(separatedBy: ":")
        let host = url[0]
        let port = url.count >= 2 ? (url[1] as NSString).integerValue - audioPortOffset : defaultPort

        audioClientObserver.notifyAudioClientObserver { (observer: AudioVideoObserver) in
            observer.audioSessionDidStartConnecting(reconnecting: false)
        }
        eventAnalyticsController.publishEvent(name: .meetingStartRequested)
        meetingStatsCollector.updateMeetingStartConnectingTimeMs()
        let appInfo = DeviceUtils.getAppInfo()
        var audioModeInternal: AudioModeInternal = .Stereo48K
        if (audioMode == .mono48K) {
            audioModeInternal = .Mono48K
        } else if (audioMode == .mono16K) {
            audioModeInternal = .Mono16K
        } else if (audioMode == .nodevice) {
            audioModeInternal = .NoDevice
        }
        let status = audioClient.startSession(host,
                                              basePort: port,
                                              callId: meetingId,
                                              profileId: attendeeId,
                                              microphoneMute: muteMicAndSpeaker,
                                              speakerMute: muteMicAndSpeaker,
                                              isPresenter: defaultPresenter,
                                              sessionToken: joinToken,
                                              audioWsUrl: audioFallbackUrl,
                                              callKitEnabled: callKitEnabled,
                                              appInfo: appInfo,
                                              audioMode: audioModeInternal)

        if status == AUDIO_CLIENT_OK {
            Self.state = .started
        } else {
            eventAnalyticsController.publishEvent(name: .meetingStartFailed)
            cleanup()
            throw MediaError.audioFailedToStart
        }
    }

    public func stop() {
        if Self.state != .started {
            return
        }

        DispatchQueue.global().async {
            self.audioLock.lock()
            let audioClientStatusCode = self.audioClient.stopSession()
            Self.state = .stopped
            let meetingSessionStatusCode = Converters.AudioClientStatus.toMeetingSessionStatusCode(
                rawValue: UInt32(audioClientStatusCode)
            )
            self.audioLock.unlock()
            self.notifyStop()
            self.audioClientObserver.notifyAudioClientObserver { (observer: AudioVideoObserver) in
                observer.audioSessionDidStopWithStatus(
                    sessionStatus: MeetingSessionStatus(statusCode: meetingSessionStatusCode)
                )
            }
            self.cleanup()
        }
    }

    func setVoiceFocusEnabled(enabled: Bool) -> Bool {
        if Self.state == .started {
            return audioClient.setBliteNSSelected(enabled) == Int(AUDIO_CLIENT_OK.rawValue)
        } else {
            return false
        }
    }

    func isVoiceFocusEnabled() -> Bool {
        if Self.state == .started {
            return audioClient.isBliteNSSelected()
        } else {
            return false
        }
    }

    func promoteToPrimaryMeeting(credentials: MeetingSessionCredentials, observer: PrimaryMeetingPromotionObserver) {
        guard Self.state == .started else {
            logger.error(msg: "Cannot join primary meeting because state=\(Self.state)")
            observer.didPromoteToPrimaryMeeting(status: MeetingSessionStatus(statusCode: MeetingSessionStatusCode.audioServiceUnavailable))
            return
        }
        audioClientObserver.setPrimaryMeetingPromotionObserver(observer: observer)
        audioClient.joinPrimaryMeeting(credentials.attendeeId,
                                        externalUserId: credentials.externalUserId,
                                        joinToken: credentials.joinToken)
    }

    func demoteFromPrimaryMeeting() {
        guard Self.state == .started else {
            logger.error(msg: "Cannot leave primary meeting because state=\(Self.state)")
            return
        }
        audioClient.leavePrimaryMeeting()
    }

    private func notifyStop() {
        eventAnalyticsController.publishEvent(name: .meetingEnded,
                                              attributes: [EventAttributeName.meetingStatus: MeetingSessionStatusCode.ok])
        meetingStatsCollector.resetMeetingStats()
    }

    private func cleanup() {
        if let observer = self.activeSpeakerDetector as? RealtimeObserver {
            self.audioClientObserver.unsubscribeFromRealTimeEvents(observer: observer)
        }
        DefaultAudioClient.shared(logger: self.logger).delegate = nil
    }

    @objc private func handleMediaServiceReset(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.audioClient.endOnHold()
        }
    }
}
