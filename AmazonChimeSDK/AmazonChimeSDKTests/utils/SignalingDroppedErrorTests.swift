//
//  SignalingDroppedErrorTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest
import AmazonChimeSDKMedia

class SignalingDroppedErrorTests: XCTestCase {
    func testInitFromVideoClientSignalingDroppedError_ShouldReturnMatchingError() {
        XCTAssertEqual(
            SignalingDroppedError.init(from: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_NONE),
            SignalingDroppedError.none)
        XCTAssertEqual(
            SignalingDroppedError.init(from: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_SIGNALING_CLIENT_DISCONNECTED),
            SignalingDroppedError.signalingClientDisconnected)
        XCTAssertEqual(
            SignalingDroppedError.init(from: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_SIGNALING_CLIENT_CLOSED),
            SignalingDroppedError.signalingClientClosed)
        XCTAssertEqual(
            SignalingDroppedError.init(from: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_SIGNALING_CLIENT_EOF),
            SignalingDroppedError.signalingClientEOF)
        XCTAssertEqual(
            SignalingDroppedError.init(from: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_SIGNALING_CLIENT_ERROR),
            SignalingDroppedError.signalingClientError)
        XCTAssertEqual(
            SignalingDroppedError.init(from: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_SIGNALING_CLIENT_PROXY_ERROR),
            SignalingDroppedError.signalingClientProxyError)
        XCTAssertEqual(
            SignalingDroppedError.init(from: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_SIGNALING_CLIENT_OPEN_FAILED),
            SignalingDroppedError.signalingClientOpenFailed)
        XCTAssertEqual(
            SignalingDroppedError.init(from: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_SIGNAL_FRAME_PARSE_FAILED),
            SignalingDroppedError.signalFrameParseFailed)
        XCTAssertEqual(
            SignalingDroppedError.init(from: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_SIGNAL_FRAME_SERIALIZE_FAILED),
            SignalingDroppedError.signalFrameSerializeFailed)
        XCTAssertEqual(
            SignalingDroppedError.init(from: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_VIDEO_SIGNAL_FRAME_SENDING_FAILED),
            SignalingDroppedError.signalFrameSendingFailed)
        XCTAssertEqual(
            SignalingDroppedError.init(from: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_INTERNAL_SERVER_ERROR),
            SignalingDroppedError.internalServerError)
        XCTAssertEqual(
            SignalingDroppedError.init(from: VIDEO_CLIENT_SIGNALING_DROPPED_ERROR_OTHER),
            SignalingDroppedError.other)
        
    }
    
    func testDescriptionShouldMatch() {
        XCTAssertEqual(SignalingDroppedError.none.description, "none")
        XCTAssertEqual(SignalingDroppedError.signalingClientDisconnected.description, "signalingClientDisconnected")
        XCTAssertEqual(SignalingDroppedError.signalingClientClosed.description, "signalingClientClosed")
        XCTAssertEqual(SignalingDroppedError.signalingClientEOF.description, "signalingClientEOF")
        XCTAssertEqual(SignalingDroppedError.signalingClientError.description, "signalingClientError")
        XCTAssertEqual(SignalingDroppedError.signalingClientProxyError.description, "signalingClientProxyError")
        XCTAssertEqual(SignalingDroppedError.signalingClientOpenFailed.description, "signalingClientOpenFailed")
        XCTAssertEqual(SignalingDroppedError.signalFrameParseFailed.description, "signalFrameParseFailed")
        XCTAssertEqual(SignalingDroppedError.signalFrameSerializeFailed.description, "signalFrameSerializeFailed")
        XCTAssertEqual(SignalingDroppedError.signalFrameSendingFailed.description, "signalFrameSendingFailed")
        XCTAssertEqual(SignalingDroppedError.internalServerError.description, "internalServerError")
        XCTAssertEqual(SignalingDroppedError.other.description, "other")
    }
}
