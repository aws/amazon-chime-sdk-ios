//
//  Errors.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

enum Errors: Error, LocalizedError, CustomStringConvertible {
    
    case audioPermissionDenied
    case unknownAudioPermission
    case cameraPermissionDenied
    case unknownCameraPermission
    case failedToJoinMeeting
    case failedToStartMeetingSession
    
    public var description: String {
        switch self {
        case .audioPermissionDenied, .unknownAudioPermission:
            return "Microphone permission denied. Please enable microphone permission in Settings and try again."
        case .cameraPermissionDenied, .unknownCameraPermission:
            return "Camera permission denied. Please enable camera permission in Settings and try again."
        case .failedToJoinMeeting:
            return "Failed to join meeting"
        case .failedToStartMeetingSession:
            return "Failed to start meeting session"
        }
    }
    
    public var errorDescription: String? {
        return self.description
    }
}
