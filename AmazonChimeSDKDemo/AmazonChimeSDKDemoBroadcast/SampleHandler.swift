//
//  SampleHandler.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import ReplayKit

let appGroupId = "YOUR_APP_GROUP_ID"

let userDefaultsKeyMeetingId = "demoMeetingId"
let userDefaultsKeyExternalMeetingId = "demoExternalMeetingId"
let userDefaultsKeyCredentials = "demoMeetingCredentials"
let userDefaultsKeyUrls = "demoMeetingUrls"
let userDefaultsKeyBroadcastMetrics = "demoMeetingBroadcastMetrics"

class SampleHandler: RPBroadcastSampleHandler {
    let logger = ConsoleLogger(name: "SampleHandler")
    let appGroupUserDefaults = UserDefaults(suiteName: appGroupId)
    var currentMeetingSession: MeetingSession?
    var userDefaultsObserver: NSKeyValueObservation?
    var cachedBroadcastMetrics: [String: Double] = [:]

    lazy var replayKitSource: ReplayKitSource = { return ReplayKitSource(logger: logger) }()

    lazy var contentShareSource: ContentShareSource = {
        let source = ContentShareSource()
        source.videoSource = replayKitSource
        return source
    }()

    override func broadcastStarted(withSetupInfo setupInfo: [String: NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
        guard let config = getSavedMeetingSessionConfig() else {
            logger.error(msg: "Unable to recreate MeetingSessionConfiguration from Broadcast Extension")
            finishBroadcastWithError(NSError(domain: "AmazonChimeSDKDemoBroadcast", code: 0))
            return
        }
        currentMeetingSession = DefaultMeetingSession(configuration: config, logger: logger)
        currentMeetingSession?.audioVideo.addMetricsObserver(observer: self)
        currentMeetingSession?.audioVideo.startContentShare(source: contentShareSource)

        // If the meetingId is changed from the demo app, we need to observe the meetingId and stop broadcast
        userDefaultsObserver = appGroupUserDefaults?.observe(\.demoMeetingId,
                                                 options: [.new, .old]) { [weak self] (_, _) in
            guard let strongSelf = self else { return }
            strongSelf.finishBroadcastWithError(NSError(domain: "AmazonChimeSDKDemoBroadcast", code: 1))
        }
    }

    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
    }

    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
    }

    override func broadcastFinished() {
        // User has requested to finish the broadcast.
        replayKitSource.stop()
        currentMeetingSession?.audioVideo.stopContentShare()
        currentMeetingSession?.audioVideo.removeMetricsObserver(observer: self)
        appGroupUserDefaults?.removeObject(forKey: userDefaultsKeyBroadcastMetrics)
        userDefaultsObserver?.invalidate()
    }

    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        replayKitSource.processSampleBuffer(sampleBuffer: sampleBuffer, type: sampleBufferType)
    }

    // Recreate the MeetingSessionConfiguration from the active meeting in the app
    private func getSavedMeetingSessionConfig() -> MeetingSessionConfiguration? {
        guard let appGroupUserDefaults = appGroupUserDefaults else {
            logger.error(msg: "App Group User Defaults not found")
            return nil
        }
        let decoder = JSONDecoder()
        if let meetingId = appGroupUserDefaults.demoMeetingId,
           let externalMeetingId = appGroupUserDefaults.demoExternalMeetingId,
           let credentialsData = appGroupUserDefaults.demoMeetingCredentials,
           let urlsData = appGroupUserDefaults.demoMeetingUrls,
           let credentials = try? decoder.decode(MeetingSessionCredentials.self, from: credentialsData),
           let urls = try? decoder.decode(MeetingSessionURLs.self, from: urlsData) {

            return MeetingSessionConfiguration(meetingId: meetingId,
                                               externalMeetingId: externalMeetingId,
                                               credentials: credentials,
                                               urls: urls,
                                               urlRewriter: URLRewriterUtils.defaultUrlRewriter)
        }
        return nil
    }
}

// Since Broadcast Extension runs independently from Demo app, Metrics from Broadcasting does not
// automatically flow into the app. So we are saving these metrics from Broadcast Extension into
// shared App Groups User Defaults, observe and retrieve them in MetricsModel to display in demo app.
extension SampleHandler: MetricsObserver {
    func metricsDidReceive(metrics: [AnyHashable: Any]) {
        cachedBroadcastMetrics[ObservableMetric.contentShareVideoSendBitrate.description]
            = metrics[ObservableMetric.contentShareVideoSendBitrate] as? Double
        cachedBroadcastMetrics[ObservableMetric.contentShareVideoSendPacketLossPercent.description]
            = metrics[ObservableMetric.contentShareVideoSendPacketLossPercent] as? Double
        cachedBroadcastMetrics[ObservableMetric.contentShareVideoSendFps.description]
            = metrics[ObservableMetric.contentShareVideoSendFps] as? Double
        cachedBroadcastMetrics[ObservableMetric.contentShareVideoSendRttMs.description]
            = metrics[ObservableMetric.contentShareVideoSendRttMs] as? Double
        appGroupUserDefaults?.setValue(cachedBroadcastMetrics, forKey: userDefaultsKeyBroadcastMetrics)
    }
}

extension UserDefaults {
    @objc dynamic var demoMeetingId: String? {
        return string(forKey: userDefaultsKeyMeetingId)
    }
    @objc dynamic var demoExternalMeetingId: String? {
        return string(forKey: userDefaultsKeyExternalMeetingId)
    }
    @objc dynamic var demoMeetingCredentials: Data? {
        return object(forKey: userDefaultsKeyCredentials) as? Data
    }
    @objc dynamic var demoMeetingUrls: Data? {
        return object(forKey: userDefaultsKeyUrls) as? Data
    }
}
