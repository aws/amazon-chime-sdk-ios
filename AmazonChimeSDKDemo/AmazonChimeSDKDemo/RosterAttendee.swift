//
//  RosterAttendee.swift
//  AmazonChimeSDKDemo
//
//  Created by Hwang, Hokyung on 1/23/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation


class RosterAttendee {
    public let name: String
    public let volume: Int

    init(name: String, volume: Int) {
        self.name = name
        self.volume = volume
    }
}
