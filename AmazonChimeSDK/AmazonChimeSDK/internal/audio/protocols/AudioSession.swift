//
//  AudioSession.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AVFoundation
import Foundation

@objc public protocol AudioSession {
    var recordPermission: AVAudioSession.RecordPermission { get }
    var availableInputs: [AVAudioSessionPortDescription]? { get }
    func setPreferredInput(_ inPort: AVAudioSessionPortDescription?) throws
    func overrideOutputAudioPort(_ portOverride: AVAudioSession.PortOverride) throws
    var currentRoute: AVAudioSessionRouteDescription { get }
}

extension AVAudioSession: AudioSession {}
