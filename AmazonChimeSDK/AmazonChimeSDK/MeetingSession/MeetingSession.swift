//
//  MeetingSession.swift
//  AmazonChimeSDK
//
//  Created by Wang, Haoran on 1/9/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation

public protocol MeetingSession {
    var configuration: MeetingSessionConfiguration { get }
    var logger: Logger { get }
}
