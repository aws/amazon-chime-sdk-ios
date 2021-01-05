//
//  ContentShareVideoClientController.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objc public protocol ContentShareVideoClientController {
    func startVideoShare(source: VideoSource)
    func stopVideoShare()
    func subscribeToVideoClientStateChange(observer: ContentShareObserver)
    func unsubscribeFromVideoClientStateChange(observer: ContentShareObserver)
}
