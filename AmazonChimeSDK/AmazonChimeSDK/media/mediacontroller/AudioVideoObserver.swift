//
//  AudioVideoObserver.swift
//  AmazonChimeSDK
//
//  Created by Hwang, Hokyung on 1/29/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation

public protocol AudioVideoObserver {
    func onAudioVideoStartConnecting(reconnecting: Bool)
    func onAudioVideoStart(reconnecting: Bool)
    func onAudioVideoStop(session: MeetingSessionStatus)
    func onAudioReconnectionCancel()
    func onConnectionRecovered()
    func onConnectionBecamePoor()
}
