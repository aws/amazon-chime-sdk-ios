//
//  ObjCNamespaceTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

@testable import AmazonChimeSDK
import XCTest

class ObjCNamespaceTests: XCTestCase {
    func testObjCClassNamesArePrefixed() {
        XCTAssertEqual(NSStringFromClass(ConsoleLogger.self), "AWSChimeConsoleLogger")
        XCTAssertEqual(NSStringFromClass(DefaultMeetingSession.self), "AWSChimeDefaultMeetingSession")
        XCTAssertEqual(NSStringFromClass(DefaultVideoRenderView.self), "AWSChimeDefaultVideoRenderView")
        XCTAssertEqual(NSStringFromClass(Meeting.self), "AWSChimeMeeting")
        XCTAssertEqual(NSStringFromClass(Attendee.self), "AWSChimeAttendee")
    }

    func testObjCProtocolNamesArePrefixed() {
        XCTAssertEqual(NSStringFromProtocol(Logger.self), "AWSChimeLogger")
        XCTAssertEqual(NSStringFromProtocol(AudioVideoFacade.self), "AWSChimeAudioVideoFacade")
        XCTAssertEqual(NSStringFromProtocol(VideoTile.self), "AWSChimeVideoTile")
    }

    func testNSDictionaryHelperUsesPrefixedSelector() {
        let dict: NSDictionary = ["a": 1]
        XCTAssertTrue(dict.responds(to: Selector("awsChimeToJsonString")))
        XCTAssertFalse(dict.responds(to: Selector("toJsonString")))
    }

    // The bridged NSError domain comes from the Swift type name, which @objc(...)
    // does not change. The Objective-C demo compares this string literally.
    func testErrorDomainsAreUnchangedBySymbolRename() {
        XCTAssertEqual(PermissionError.audioPermissionError._domain, "AmazonChimeSDK.PermissionError")
        XCTAssertEqual(MediaError.illegalState._domain, "AmazonChimeSDK.MediaError")
    }
}
