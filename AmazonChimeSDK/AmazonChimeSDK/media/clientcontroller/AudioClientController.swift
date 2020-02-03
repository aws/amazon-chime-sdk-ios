//
//  AudioClientController.swift
//  AmazonChimeSDK
//
//  Created by Hwang, Hokyung on 1/28/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation
import AudioClient

class AudioClientController: NSObject, AudioClientDelegate {
    private let audioPortOffset = 200
    private let defaultMicAndSpeaker = false
    private let defaultPresenter = true

    let audioClient: AudioClient = AudioClient.sharedInstance()

    var realtimeObservers: NSMutableSet = NSMutableSet()

    static let sharedInstance = AudioClientController()

    override init() {
        super.init()
        self.audioClient.delegate = self
    }

    public func volumeStateChanged(_ volumes: [AnyHashable: Any]!) {
        if volumes == nil {
            return
        }

        let attendeeVolumeMap = processAnyDictToStringIntDict(anyDict: volumes)
        realtimeObservers.forEach { (element) in
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
        realtimeObservers.forEach { (element) in
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
            if keyString != nil && valueInt != nil {
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
        return self.audioClient.setMicrophoneMuted(mute) == Int(AUDIO_CLIENT_OK.rawValue)
    }

    public func start(audioHostUrl: String, meetingId: String, attendeeId: String, joinToken: String) {
        // TODO
        let url = audioHostUrl.components(separatedBy: ":")
        let host = url[0]
        var port = 0

        if url.count >= 2 {
            port = (url[1] as NSString).integerValue - audioPortOffset
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
}
