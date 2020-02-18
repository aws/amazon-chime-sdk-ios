//
//  RosterAttendee.swift
//  AmazonChimeSDKDemo
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

public class RosterAttendee {
    let name: String
    var volume: Int
    var signal: Int

    init(name: String, volume: Int, signal: Int) {
        self.name = name
        self.volume = volume
        self.signal = signal
    }
}
