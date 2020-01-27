//
//  RealtimeControllerFacade.swift
//  AmazonChimeSDK
//
//  Created by Hwang, Hokyung on 1/22/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation

public protocol RealtimeControllerFacade {
    func realtimeLocalMute()
    func realtimeLocalUnmute() -> Bool
}
