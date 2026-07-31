//
//  ContentShareSpies.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import Foundation

class ContentShareObserverSpy: ContentShareObserver {
    var contentShareDidStartCallCount = 0
    var contentShareDidStopCalls: [ContentShareStatus] = []

    func contentShareDidStart() { contentShareDidStartCallCount += 1 }
    func contentShareDidStop(status: ContentShareStatus) { contentShareDidStopCalls.append(status) }
}

class ContentShareControllerSpy: ContentShareController {
    struct StartContentShareCall {
        let source: ContentShareSource
        let config: LocalVideoConfiguration?
    }

    var startContentShareCalls: [StartContentShareCall] = []
    var stopContentShareCallCount = 0
    var addContentShareObserverCalls: [ContentShareObserver] = []
    var removeContentShareObserverCalls: [ContentShareObserver] = []

    func startContentShare(source: ContentShareSource) {
        startContentShareCalls.append(StartContentShareCall(source: source, config: nil))
    }

    func startContentShare(source: ContentShareSource, config: LocalVideoConfiguration) {
        startContentShareCalls.append(StartContentShareCall(source: source, config: config))
    }

    func stopContentShare() { stopContentShareCallCount += 1 }

    func addContentShareObserver(observer: ContentShareObserver) {
        addContentShareObserverCalls.append(observer)
    }

    func removeContentShareObserver(observer: ContentShareObserver) {
        removeContentShareObserverCalls.append(observer)
    }
}

class ContentShareVideoClientControllerSpy: ContentShareVideoClientController {
    struct StartVideoShareCall {
        let source: VideoSource
        let config: LocalVideoConfiguration?
    }

    var startVideoShareCalls: [StartVideoShareCall] = []
    var stopVideoShareCallCount = 0
    var subscribeToVideoClientStateChangeCalls: [ContentShareObserver] = []
    var unsubscribeFromVideoClientStateChangeCalls: [ContentShareObserver] = []

    func startVideoShare(source: VideoSource) {
        startVideoShareCalls.append(StartVideoShareCall(source: source, config: nil))
    }

    func startVideoShare(source: VideoSource, config: LocalVideoConfiguration) {
        startVideoShareCalls.append(StartVideoShareCall(source: source, config: config))
    }

    func stopVideoShare() { stopVideoShareCallCount += 1 }

    func subscribeToVideoClientStateChange(observer: ContentShareObserver) {
        subscribeToVideoClientStateChangeCalls.append(observer)
    }

    func unsubscribeFromVideoClientStateChange(observer: ContentShareObserver) {
        unsubscribeFromVideoClientStateChangeCalls.append(observer)
    }
}
