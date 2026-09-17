//
//  main.m
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//
//  Imports the Chime SDK's generated interface alongside a second framework
//  that declares the same bare Objective-C names. The Clang module check fires
//  on USE, not on import, so each colliding name must actually be referenced.
//
@import AmazonChimeSDK.Swift;
@import FakeVendorSDK.Swift;

int main(void) {
    ConsoleLogger *vendorLogger = [[ConsoleLogger alloc] initWithLogType:1];
    id<Logger> vendorProtocol = (id<Logger>)vendorLogger;
    Meeting *vendorMeeting = [[Meeting alloc] init];
    Attendee *vendorAttendee = [[Attendee alloc] init];
    VideoTileState *vendorTile = [[VideoTileState alloc] init];
    LogLevel vendorLevel = LogLevelVendorDefault;
    MeetingSessionStatusCode vendorStatus = MeetingSessionStatusCodeVendorOk;

    AWSChimeConsoleLogger *chimeLogger =
        [[AWSChimeConsoleLogger alloc] initWithName:@"probe" level:AWSChimeLogLevelINFO];
    id<AWSChimeLogger> chimeProtocol = chimeLogger;

    (void)vendorProtocol; (void)vendorMeeting; (void)vendorAttendee;
    (void)vendorTile; (void)vendorLevel; (void)vendorStatus; (void)chimeProtocol;
    return 0;
}
