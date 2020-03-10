//
//  AudioClient_sdk.h
//  AudioClient
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

#import <Foundation/Foundation.h>
#import "audio_client_sdk.h"
#import "proxy_comm.h"
#import "codec_sdk.h"

typedef NS_ENUM(NSUInteger, AudioClientMetric) {
    clientMicDeviceFramesLostPercent,
    serverPreJbMicPacketsLostPercent,
    serverMicMaxJitterMs,
    serverPostJbMic1sPacketsLostPercent,
    serverPostJbMic5sPacketsLostPercent,
    clientPreJbSpkPacketsLostPercent,
    clientSpkMaxJitterMs,
    clientPostJbSpk1sPacketsLostPercent,
    clientPostJbSpk5sPacketsLostPercent,
};

@protocol AudioClientDelegate <NSObject>

@optional

- (void)signalStrengthChanged:(NSArray*)signalStrengths;

- (void)audioClientStateChanged:(audio_client_state_t)audio_client_state
                         status:(audio_client_status_t)status;

- (void)volumeStateChanged:(NSArray*)volumes;

- (void)audioMetricsChanged:(NSDictionary*)metrics;

@end

@interface AudioClient : NSObject
{
@private audio_client_t *_client;
}

@property (nonatomic, retain) NSObject <AudioClientDelegate> *delegate;

- (audio_client_status_t)startSession:(audio_client_transport_mode_t)transport_mode
                                 host:(NSString *)host
                             basePort:(NSInteger)port
                        proxyCallback:(proxy_params_for_url_func)proxyCallback
                               callId:(NSString *)callId
                            profileId:(NSString *)profileId
                      microphoneCodec:(codec_mode_t)mic_codec
                         speakerCodec:(codec_mode_t)spk_codec
                       microphoneMute:(BOOL)mic_mute
                          speakerMute:(BOOL)spk_mute
                          isPresenter:(BOOL)presenter
                             features:(NSArray *)features
                         sessionToken:(NSString *)tokenString
                           audioWsUrl:(NSString *)audioWsUrl
                           khiEnabled:(BOOL)khiEnabled
                       callKitEnabled:(BOOL)callKitEnabled
;


- (NSInteger)stopSession;

- (BOOL)isSpeakerOn;
- (BOOL)setSpeakerOn:(BOOL)value;

- (NSInteger) stopAudioRecord;

- (BOOL)isMicrophoneMuted;
- (NSInteger)setMicrophoneMuted:(BOOL)mute;

- (void)setPresenter:(BOOL)presenter;

- (void)remoteMute;

+ (AudioClient *)sharedInstance;

@end

@interface AttendeeUpdate: NSObject

@property NSString *profileId;
@property NSString *externalUserId;
@property NSNumber *data;
- (id) initWithProfileId:(NSString *)profile_id externalUserId:(NSString *)external_user_id data:(NSNumber *)data;

@end
