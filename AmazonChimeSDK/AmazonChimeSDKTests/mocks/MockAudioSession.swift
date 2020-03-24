//
//  MockAudioSession.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AVFoundation
import Foundation

public final class MockAVAudioSessionPortDescription: AVAudioSessionPortDescription {

    private var _portName: String

    public override var portName: String {
        return self._portName
    }

    init(portName: String) {
        self._portName = portName
    }
}

public final class MockAudioSession: AVAudioSession {
    var setPreferredInputCallParams: [AVAudioSessionPortDescription] = []
    var overrideOutputAudioPortCallParams: [AVAudioSession.PortOverride] = []
    var availableInputsCallCount = 0

    override init() {

    }

    public override var availableInputs: [AVAudioSessionPortDescription]? {
        self.availableInputsCallCount += 1
        let port1 = MockAVAudioSessionPortDescription(portName: "Fake1")
        let port2 = MockAVAudioSessionPortDescription(portName: "Fake2")
        return [port1, port2]
    }

    public func reset() {
        self.availableInputsCallCount = 0
        self.overrideOutputAudioPortCallParams = []
        self.setPreferredInputCallParams = []
    }

    public override func setPreferredInput(_ port: AVAudioSessionPortDescription?) throws {
        self.setPreferredInputCallParams.append(port!)
    }

    public override func overrideOutputAudioPort(_ portOverride: AVAudioSession.PortOverride) throws {
        self.overrideOutputAudioPortCallParams.append(portOverride)
    }
}
