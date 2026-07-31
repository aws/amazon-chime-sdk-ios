//
//  VideoClientMock.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import Foundation

/// Hand-written mock for `VideoClient`, an Objective-C class from the binary
/// `AmazonChimeSDKMedia` framework, so a mock cannot be generated for it;
/// tests that previously used Mockingbird's `mock(VideoClient.self)` use this
/// subclass instead.
///
/// The current tests only pass instances of this mock as an argument (e.g. to
/// `videoClient(_:didReceive:)`) and never stub or verify any of its methods,
/// so no overrides are needed. If a future test needs to stub or verify
/// `VideoClient` behavior, override only the methods it uses here, recording
/// invocations in arrays and returning the values the test needs.
class VideoClientMock: VideoClient {}
