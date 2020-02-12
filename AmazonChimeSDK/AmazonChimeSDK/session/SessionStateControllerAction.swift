//
//  SessionStateControllerAction.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

enum SessionStateControllerAction: Int32 {
    case unknown = -1
    case initialize = 0
    case connecting = 1
    case finishConnecting = 2
    case updating = 3
    case finishUpdating = 4
    case reconnecting = 5
    case disconnecting = 6
    case finishDisconnecting = 7
    case fail = 8
}
