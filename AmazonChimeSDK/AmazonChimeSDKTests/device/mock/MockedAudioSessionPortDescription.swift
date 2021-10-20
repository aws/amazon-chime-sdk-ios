//
//  MockedAudioSessionPortDescription.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AVFoundation

class MockedAudioSessionPortDescription: AVAudioSessionPortDescription {
    var mockPortType: AVAudioSession.Port
    var mockPortName: String
    var mockUid: String
    var mockHasHardwareVoiceCallProcessing: Bool

    init(portType: AVAudioSession.Port,
         portName: String) {
        self.mockPortType = portType
        self.mockPortName = portName
        self.mockUid = UUID().uuidString
        self.mockHasHardwareVoiceCallProcessing = false
        super.init()
    }

    override var portType: AVAudioSession.Port {
        mockPortType
    }

    override var portName: String {
        mockPortName
    }

    override var uid: String {
        mockUid
    }

    override  var hasHardwareVoiceCallProcessing: Bool {
        mockHasHardwareVoiceCallProcessing
    }

    override var channels: [AVAudioSessionChannelDescription]? {
        nil
    }

    override var dataSources: [AVAudioSessionDataSourceDescription]? {
        nil
    }

    override var selectedDataSource: AVAudioSessionDataSourceDescription? {
        nil
    }

    override var preferredDataSource: AVAudioSessionDataSourceDescription? {
        nil
    }

    override func setPreferredDataSource(_ dataSource: AVAudioSessionDataSourceDescription?) throws {}
}
