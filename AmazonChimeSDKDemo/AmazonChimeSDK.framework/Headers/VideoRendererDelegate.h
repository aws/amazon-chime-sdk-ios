//
//  VideoRendererDelegate.h
//  MediaClient
//
//  Copyright (c) 2020 Amazon, Inc. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger, PauseState) {
    Unpaused,
    PausedByUserRequest,
    PausedForPoorConnection
};

@protocol VideoRendererDelegate <NSObject>

- (void)didReceiveVideoBuffer:(CVPixelBufferRef)image
                     profileId:(NSString*)profileId
                       videoId:(uint32_t)videoId;

- (void)didUpdatePauseForRendererWithId:(uint32_t)videoId state:(PauseState)type;

- (void)didRemoveRendererWithId:(uint32_t)videoId;

@end
