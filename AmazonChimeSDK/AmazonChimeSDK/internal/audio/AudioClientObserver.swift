//
//  AudioClientObserver.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

@objc public protocol AudioClientObserver {
    func notifyAudioClientObserver(observerFunction: (_ observer: AudioVideoObserver) -> Void)
    func subscribeToAudioClientStateChange(observer: AudioVideoObserver)
    func subscribeToRealTimeEvents(observer: RealtimeObserver)
    func unsubscribeFromAudioClientStateChange(observer: AudioVideoObserver)
    func unsubscribeFromRealTimeEvents(observer: RealtimeObserver)
}
