//
//  SessionStateControllerAction.swift
//  AmazonChimeSDK
//
//  Created by Hwang, Hokyung on 1/29/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
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
