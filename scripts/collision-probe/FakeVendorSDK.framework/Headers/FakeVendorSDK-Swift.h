//
//  FakeVendorSDK-Swift.h
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//
//  Stands in for another vendor's generated Objective-C interface. The
//  declarations mirror Cisco WebexConnectCore v3.0.6 as quoted in the report
//  that prompted the AWSChime prefix: a Logger protocol with one referenced
//  protocol, and a ConsoleLogger with a one-parameter initWithLogType:. Those
//  two details are what the Clang diagnostic names, so they are what this
//  reproduces.
//
//  Add a declaration here for any name a real SDK is known to collide on.
//
#import <Foundation/Foundation.h>

@protocol VendorBase
@end

@protocol Logger <VendorBase>
- (void)vendorLog:(NSString * _Nonnull)message;
@end

@interface ConsoleLogger : NSObject
- (nonnull instancetype)initWithLogType:(NSInteger)logType;
@end

@interface Meeting : NSObject
@end

@interface Attendee : NSObject
@end

@interface VideoTileState : NSObject
@end

typedef NS_ENUM(NSInteger, LogLevel) {
    LogLevelVendorDefault = 0,
};

// A uint32_t-backed enum. The SDK has one of these (MeetingSessionStatusCode)
// and it shipped unprefixed once, because the namespace check's character class
// excluded digits and silently skipped it. Keep this here so the collision
// check covers that shape independently.
typedef NS_ENUM(uint32_t, MeetingSessionStatusCode) {
    MeetingSessionStatusCodeVendorOk = 0,
};
