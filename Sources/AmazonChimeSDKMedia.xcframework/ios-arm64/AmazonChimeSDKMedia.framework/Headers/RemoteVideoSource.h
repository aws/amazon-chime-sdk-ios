//
//  RemoteVideoSource.h
//  AmazonChimeSDKMedia
//
//  Copyright (c) 2020 Amazon, Inc. All rights reserved.
//
 
#import <Foundation/Foundation.h>

typedef struct {
      int width;
      int height;
}ResolutionInternal;


typedef NS_ENUM(NSUInteger, PriorityInternal) {
      lowest = 0,
      low = 10,
      medium = 20,
      high = 30,
      highest = 40,
};
 
@interface RemoteVideoSourceInternal : NSObject
@property (atomic, strong) NSString* attendeeId;

- (instancetype)initWithAttendeeId:(NSString *)attendeeId;

@end

@interface VideoSubscriptionConfigurationInternal : NSObject
@property (nonatomic, assign) PriorityInternal priority;
@property (nonatomic, assign) ResolutionInternal targetResolution;
@property (nonatomic, assign) int targetBitrate;

- (instancetype)initWithPriority:(PriorityInternal)priority
                targetResolution:(ResolutionInternal)targetResolution;

- (BOOL)isEqual:(VideoSubscriptionConfigurationInternal *)object;

@end
