//
//  VideoRendererDelegate.h
//  AmazonChimeSDKMedia
//
//  Copyright (c) 2020 Amazon, Inc. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>

// Mirrors  https://w3c.github.io/mst-content-hint/
typedef NS_ENUM(NSUInteger, VideoContentHintInternal) {
    VideoContentHintInternalNone = 0,
    VideoContentHintInternalMotion,
    VideoContentHintInternalDetailed,
    VideoContentHintInternalText,
};

typedef NS_ENUM(NSUInteger, VideoRotationInternal) {
    VideoRotation0 = 0,
    VideoRotation90 = 90,
    VideoRotation180 = 180,
    VideoRotation270 = 270,
};

typedef NS_ENUM(NSUInteger, PauseState) {
    Unpaused,
    PausedByUserRequest,
    PausedForPoorConnection
};

@protocol VideoRendererDelegate <NSObject>

- (void)didReceiveVideoBuffer:(CVPixelBufferRef)image
                    profileId:(NSString*)profileId
                      videoId:(uint32_t)videoId
                  timestampNs:(int64_t)timestampNs
                     rotation:(VideoRotationInternal)rotation;

- (void)didUpdatePauseForRendererWithId:(uint32_t)videoId profileId:(NSString*)profileId state:(PauseState)type;

- (void)didRemoveRendererWithId:(uint32_t)videoId;

@end
