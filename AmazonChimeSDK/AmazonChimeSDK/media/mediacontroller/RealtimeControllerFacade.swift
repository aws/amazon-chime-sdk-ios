//
//  RealtimeControllerFacade.swift
//  AmazonChimeSDK
//
//  Created by Hwang, Hokyung on 1/22/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation
import AudioClient

public protocol RealtimeControllerFacade {
    func realtimeLocalMute() -> Bool
    func realtimeLocalUnmute() -> Bool
    func realtimeSubscribeToVolumeIndicator(callback: @escaping ([String: Int]) -> Void)
    func realtimeUnsubscribeFromVolumeIndicator(callback: @escaping ([String: Int]) -> Void)
    func realtimeSubscribeToSignalStrengthChange(callback: @escaping ([String: Int]) -> Void)
    func realtimeUnsubscribeFromSignalStrengthChange(callback: @escaping ([String: Int]) -> Void)
}
