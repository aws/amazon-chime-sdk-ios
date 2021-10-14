//
//  AudioClientObserver.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objc public protocol AudioClientObserver {
    func notifyAudioClientObserver(observerFunction: @escaping (_ observer: AudioVideoObserver) -> Void)
    func subscribeToAudioClientStateChange(observer: AudioVideoObserver)
    func subscribeToRealTimeEvents(observer: RealtimeObserver)
    func unsubscribeFromAudioClientStateChange(observer: AudioVideoObserver)
    func unsubscribeFromRealTimeEvents(observer: RealtimeObserver)
    func subscribeToTranscriptEvent(observer: TranscriptEventObserver)
    func unsubscribeFromTranscriptEvent(observer: TranscriptEventObserver)
    func setPrimaryMeetingPromotionObserver(observer: PrimaryMeetingPromotionObserver)
}
