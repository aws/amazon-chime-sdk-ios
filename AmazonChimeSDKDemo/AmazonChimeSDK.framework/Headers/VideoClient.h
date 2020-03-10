//
//  VideoClient.h
//  MediaClient
//
//  Copyright (c) 2020 Amazon, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGImage.h>

#import "VideoRendererDelegate.h"
#import "VideoClientMetric.h"

#import "video_client.h"
#import "proxy_comm.h"
#import "instrumentation.h"

@protocol VideoClientDelegate;
@protocol VideoClientObserverAdapterDelegate;

@interface VideoDevice : NSObject
@property (atomic, strong, readonly) NSString* identifier;
@property (atomic, strong, readonly) NSString* name;
@property (atomic, assign, readonly) BOOL isDefault;
@property (atomic, assign, readonly) BOOL isBuiltIn;
@end

// Note: If adding to this, make sure to add correspondingly to VideoClient.m
@interface VideoConfiguration : NSObject
// Feature flags
@property (nonatomic, assign) BOOL isUsing16by9AspectRatio;
@property (nonatomic, assign) BOOL isUsingUnifiedPlan;
@property (nonatomic, assign) BOOL isUsingProbingAdaptiveSubscribe;
@property (nonatomic, assign) BOOL isUsingSendSideBwe;
@property (nonatomic, assign) BOOL isUsingPixelBufferRenderer;
@end

#define kMaximumSupportedVideoTiles 16

#pragma clang diagnostic push
// To get rid of 'No protocol definition found' warnings for adapter delegate
// who's header we cannot include because it contains C++ and this header
// is sometimes transitively included from Obj-C (i.e. not Obj-C++ files)
#pragma clang diagnostic ignored "-Weverything"

@interface VideoClient : NSObject<VideoClientObserverAdapterDelegate, VideoRendererDelegate>

#pragma clang diagnostic pop

@property (nonatomic, retain) NSObject<VideoClientDelegate>* delegate;

+ (void)globalInitialize:(instrumentation_client_t*)instrumentation_client;
// Set the dynamic media client config whenever it is passed down from application
+ (void)setMediaClientConfig:(NSString*)configStr;

- (void)start:(NSString*)controlUrl
    proxyCallback:(proxy_params_for_url_func)proxyCallback
    stunServerUrl:(NSString*)stunServerUrl
           callId:(NSString*)callId
            token:(NSString*)token
          sending:(BOOL)sending
           config:(VideoConfiguration*)config
          appInfo:(app_detailed_info_t)appInfo;

- (void)stop;
- (BOOL)isActive;
- (void)updateTurnCreds:(turn_session_response_t)turnResponse turnStatus:(video_client_turn_status_t)turnStatus;
- (NSString*)stateString;
- (void)setSending:(BOOL)sending;
- (void)setReceiving:(BOOL)receiving;
- (video_client_service_type_t)getServiceType;
- (void)setRemotePause:(uint32_t)video_id
                 pause:(BOOL)pause;

- (NSArray*)activeTracks;
+ (NSArray*)devices;
+ (void)setDevice:(VideoDevice*)captureDevice;
- (void)setCurrentDevice:(VideoDevice*)captureDevice;
- (void)setDisplayDimension:(int)display_id width:(int)width height:(int)height;

// currently selected device
+ (VideoDevice*)currentDevice;

// saved device, nil if unsaved or set to default
+ (void)setSavedDevice:(VideoDevice*)savedDevice;
+ (void)clearSavedDevice;

// actual saved device id (to check if there is no setting saved)
+ (NSString*)savedDeviceId;
+ (void)setSavedDeviceId:(NSString*)savedDeviceId;

@end

// All of these callbacks occur on the main thread
@protocol VideoClientDelegate <NSObject>

@optional

- (void)videoClient:(VideoClient*)client
    didReceiveFrame:(CGImageRef)image
          displayId:(int)displayId
          profileId:(NSString*)profileId
          pauseType:(video_client_pause_type_t)pauseType
            videoId:(uint32_t)videoId;

- (void)didReceiveBuffer:(CVPixelBufferRef)buffer
               profileId:(NSString*)profileId
              pauseState:(PauseState)pauseState
                 videoId:(uint32_t)videoId;

- (void)videoClient:(VideoClient*)client didUpdateNumberOfTracks:(NSArray*)tracks;

- (void)videoClientIsConnecting:(VideoClient*)client;

- (void)videoClientDidConnect:(VideoClient*)client
                controlStatus:(int)controlStatus;

- (void)videoClientDidFail:(VideoClient*)client
                    status:(video_client_status_t)status
             controlStatus:(int)controlStatus;

- (void)videoClientDidStop:(VideoClient*)client;

- (void)videoClient:(VideoClient*)client cameraSendIsAvailable:(BOOL)available;

- (void)videoClientRequestTurnCreds:(VideoClient*)client;

- (void)videoClientMetricsReceived:(NSDictionary*)metrics;

@end
