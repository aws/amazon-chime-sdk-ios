//
//  VideoContentHint.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import Foundation

/// `VideoContentHint` describes the content type of a video source so that downstream encoders, etc. can properly
/// decide on what parameters will work best. These options mirror https://www.w3.org/TR/mst-content-hint/ .
@objc public enum VideoContentHint: Int {
    /// No hint has been provided.
    case none = 0

    /// The track should be treated as if it contains video where motion is important.
    /// 
    /// This is normally webcam video, movies or video games.
    case motion = 1

    /// The track should be treated as if video details are extra important.
    ///
    /// This is generally applicable to presentations or web pages with text content, painting or line art.
    case detail = 2

    /// The track should be treated as if video details are extra important, and that
    /// significant sharp edges and areas of consistent color can occur frequently.
    ///
    /// This is generally applicable to presentations or web pages with text content.
    case text = 3

    var toInternal: VideoContentHintInternal {
        return VideoContentHintInternal(rawValue: UInt(rawValue)) ?? .none
    }

    public var description: String {
        switch self {
        case .none:
            return "none"
        case .motion:
            return "motion"
        case .detail:
            return "detail"
        case .text:
            return "text"
        }
    }
}
