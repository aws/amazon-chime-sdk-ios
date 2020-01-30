//
//  AudioVideoControllerFacade.swift
//  SwiftTest
//
//  Created by Xu, Tianyu on 1/10/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import Foundation

public protocol AudioVideoControllerFacade {
    var configuration: MeetingSessionConfiguration { get }
    var logger: Logger { get }
    func start() throws
    func stop()
}
