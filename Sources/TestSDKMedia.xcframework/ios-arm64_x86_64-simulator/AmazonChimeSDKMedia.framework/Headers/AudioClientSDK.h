//
//  AudioClientSDK.h
//  AmazonChimeSDKMedia
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

#import <Foundation/Foundation.h>
#import "audio_client_enum.h"

typedef enum
{
    LOGGER_TRACE = 1,
    LOGGER_DEBUG = 2,
    LOGGER_INFO = 3,
    LOGGER_WARNING = 4,
    LOGGER_ERROR = 5,
    LOGGER_FATAL = 6,
    LOGGER_NOTIFY = 7,
} loglevel_t;

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

typedef NS_ENUM(NSUInteger, AudioModeInternal) {
    NoAudio   = 0,
    Mono16K   = 1,
    Mono48K   = 2,
    Stereo48K = 3,
    NoDevice  = 4,
};

@interface AppInfo: NSObject
    @property NSString *appName;
    @property NSString *appVersion;
    @property NSString *deviceMake;
    @property NSString *deviceModel;
    @property NSString *platformName;
    @property NSString *platformVersion;
    @property NSString *clientSource;
    @property NSString *chimeSdkVersion;
- (id) initWithAppName:(NSString *)appName
            appVersion:(NSString *)appVersion
            deviceMake:(NSString *)deviceMake
           deviceModel:(NSString *)deviceModel
          platformName:(NSString *)platformName
       platformVersion:(NSString *)platformVersion
          clientSource:(NSString *)clientSource
       chimeSdkVersion:(NSString *)chimeSdkVersion;
@end

// Internal transcript models
typedef NS_ENUM(NSInteger, TranscriptItemTypeInternal) {
    TranscriptItemTypeInternalPronunciation = 1,
    TranscriptItemTypeInternalPunctuation = 2,
};

typedef NS_ENUM(NSInteger, TranscriptionStatusTypeInternal) {
    TranscriptionStatusTypeInternalStarted = 1,
    TranscriptionStatusTypeInternalInterrupted = 2,
    TranscriptionStatusTypeInternalResumed = 3,
    TranscriptionStatusTypeInternalStopped = 4,
    TranscriptionStatusTypeInternalFailed = 5,
};

@interface AttendeeInfoInternal : NSObject
@property (nonatomic, readonly, copy) NSString *attendeeId;
@property (nonatomic, readonly, copy) NSString *externalUserId;
- (instancetype)initWithAttendeeId:(NSString *)attendeeId externalUserId:(NSString *)externalUserId;
@end

@interface TranscriptItemInternal : NSObject
@property (nonatomic, readonly) enum TranscriptItemTypeInternal type;
@property (nonatomic, readonly) int64_t startTimeMs;
@property (nonatomic, readonly) int64_t endTimeMs;
@property (nonatomic, readonly, strong) AttendeeInfoInternal *attendee;
@property (nonatomic, readonly, copy) NSString *content;
@property (nonatomic, readonly) BOOL vocabularyFilterMatch;
@property (nonatomic, readonly) BOOL stable;
@property (nonatomic, readonly) double confidence;
- (instancetype)initWithType:(TranscriptItemTypeInternal)type
                 startTimeMs:(int64_t)startTimeMs
                   endTimeMs:(int64_t)endTimeMs
                    attendee:(AttendeeInfoInternal *)attendee
                     content:(NSString *)content
       vocabularyFilterMatch:(BOOL)vocabularyFilterMatch;

- (instancetype)initWithType:(TranscriptItemTypeInternal)type
                 startTimeMs:(int64_t)startTimeMs
                   endTimeMs:(int64_t)endTimeMs
                    attendee:(AttendeeInfoInternal *)attendee
                     content:(NSString *)content
       vocabularyFilterMatch:(BOOL)vocabularyFilterMatch
                      stable:(BOOL)stable
                  confidence:(double)confidence;
@end

@interface TranscriptEntityInternal : NSObject
@property (nonatomic, readonly, copy) NSString *type;
@property (nonatomic, readonly, copy) NSString *category;
@property (nonatomic, readonly, copy) NSString *content;
@property (nonatomic, readonly) double confidence;
@property (nonatomic, readonly) int64_t startTimeMs;
@property (nonatomic, readonly) int64_t endTimeMs;
- (instancetype)initWithType:(NSString *)type
                    category:(NSString *)category
                     content:(NSString *)content
                  confidence:(double)confidence
                 startTimeMs:(int64_t)startTimeMs
                   endTimeMs:(int64_t)endTimeMs;
@end

@interface TranscriptLanguageWithScoreInternal : NSObject
@property (nonatomic, readonly, copy) NSString *languageCode;
@property (nonatomic, readonly) double score;
- (instancetype)initWithlanguageCode:(NSString *)languageCode
                               score:(double)score;
@end

@interface TranscriptAlternativeInternal : NSObject
@property (nonatomic, readonly, copy) NSArray<TranscriptItemInternal *> *items;
@property (nonatomic, readonly, copy) NSArray<TranscriptEntityInternal *> *entities;
@property (nonatomic, readonly, copy) NSString *transcript;
- (instancetype)initWithItems:(NSArray<TranscriptItemInternal *> *)items entities:(NSArray<TranscriptEntityInternal *> *)entities transcript:(NSString *)transcript;
- (instancetype)initWithItems:(NSArray<TranscriptItemInternal *> *)items
                   transcript:(NSString *)transcript;
@end

@protocol TranscriptEventInternal
@end

@interface TranscriptResultInternal : NSObject
@property (nonatomic, readonly, copy) NSString *resultId;
@property (nonatomic, readonly, copy) NSString *channelId;
@property (nonatomic, readonly) BOOL isPartial;
@property (nonatomic, readonly) int64_t startTimeMs;
@property (nonatomic, readonly) int64_t endTimeMs;
@property (nonatomic, readonly, copy) NSArray<TranscriptAlternativeInternal *> *alternatives;
@property (nonatomic, readonly, copy) NSString *languageCode;
@property (nonatomic, readonly, copy) NSArray<TranscriptLanguageWithScoreInternal *> *languageIdentification;
- (instancetype)initWithResultId:(NSString *)resultId
                       channelId:(NSString *)channelId
                       isPartial:(BOOL)isPartial
                     startTimeMs:(int64_t)startTimeMs
                       endTimeMs:(int64_t)endTimeMs
                    alternatives:(NSArray<TranscriptAlternativeInternal *> *)alternatives
                    languageCode:(NSString *)languageCode
         languageIdentification:(NSArray<TranscriptLanguageWithScoreInternal *> *)languageIdentification;
- (instancetype)initWithResultId:(NSString *)resultId
                       channelId:(NSString *)channelId
                       isPartial:(BOOL)isPartial
                     startTimeMs:(int64_t)startTimeMs
                       endTimeMs:(int64_t)endTimeMs
                    alternatives:(NSArray<TranscriptAlternativeInternal *> *)alternatives;
@end

@interface TranscriptionStatusInternal : NSObject <TranscriptEventInternal>
@property (nonatomic, readonly) enum TranscriptionStatusTypeInternal type;
@property (nonatomic, readonly) int64_t eventTimeMs;
@property (nonatomic, readonly, copy) NSString *transcriptionRegion;
@property (nonatomic, readonly, copy) NSString *transcriptionConfiguration;
@property (nonatomic, readonly, copy) NSString *message;
- (instancetype)initWithType:(enum TranscriptionStatusTypeInternal)type
                 eventTimeMs:(int64_t)eventTimeMs
         transcriptionRegion:(NSString *)transcriptionRegion
  transcriptionConfiguration:(NSString *)transcriptionConfiguration
                     message:(NSString *)message;
@end

@interface TranscriptInternal : NSObject <TranscriptEventInternal>
@property (nonatomic, readonly, copy) NSArray<TranscriptResultInternal *> *results;
- initWithResults:(NSArray<TranscriptResultInternal *> *)results;
@end

typedef NS_ENUM(NSUInteger, PrimaryMeetingEventTypeInternal) {
    PrimaryMeetingNone = 0,
    PrimaryMeetingJoinAck = 1,
    PrimaryMeetingLeave = 2,
    PrimaryMeetingLeaveAck = 3,
};

typedef NS_ENUM(NSUInteger, PrimaryMeetingEventStatusInternal) {
    Ok = 0,
    CallAtCapacity = 1,
    AuthenticationFailed = 2,
    Disconnected = 3,
    RemovedFromMeeting = 4,
    InternalError = 5,
};

@protocol AudioClientDelegate <NSObject>

@optional

- (void)signalStrengthChanged:(NSArray*)signalStrengths;

- (void)audioClientStateChanged:(audio_client_state_t)audio_client_state
                         status:(audio_client_status_t)status;

- (void)volumeStateChanged:(NSArray*)volumes;

- (void)audioMetricsChanged:(NSDictionary*)metrics;

- (void)attendeesPresenceChanged:(NSArray*)attendees;

- (void)transcriptEventsReceived:(NSArray*)events;

- (void)primaryMeetingEventReceived:(PrimaryMeetingEventTypeInternal)type
                             status:(PrimaryMeetingEventStatusInternal)status;

@end

@interface AudioClient : NSObject
{
@private audio_client_t *_client;
}

@property (nonatomic, retain) NSObject <AudioClientDelegate> *delegate;

// startSession method that passes AudioModeInternal for configuration of sample rate and channel count
- (audio_client_status_t)startSession:(NSString *)host
                             basePort:(NSInteger)port
                               callId:(NSString*)callId
                            profileId:(NSString*)profileId
                       microphoneMute:(BOOL)mic_mute
                          speakerMute:(BOOL)spk_mute
                          isPresenter:(BOOL)presenter
                         sessionToken:(NSString *)tokenString
                           audioWsUrl:(NSString *)audioWsUrl
                       callKitEnabled:(BOOL)callKitEnabled
                              appInfo:(AppInfo *)appInfo
                            audioMode:(AudioModeInternal)audioMode
;

// startSession method that passes AppInfo containing iOS SDK metadata to Audioclient.
- (audio_client_status_t)startSession:(NSString *)host
                             basePort:(NSInteger)port
                               callId:(NSString*)callId
                            profileId:(NSString*)profileId
                       microphoneMute:(BOOL)mic_mute
                          speakerMute:(BOOL)spk_mute
                          isPresenter:(BOOL)presenter
                         sessionToken:(NSString *)tokenString
                           audioWsUrl:(NSString *)audioWsUrl
                       callKitEnabled:(BOOL)callKitEnabled
                              appInfo:(AppInfo *)appInfo
;

// Legacy startSession method without passing AppInfo for backward compatibility.
- (audio_client_status_t)startSession:(NSString *)host
                             basePort:(NSInteger)port
                               callId:(NSString*)callId
                            profileId:(NSString*)profileId
                       microphoneMute:(BOOL)mic_mute
                          speakerMute:(BOOL)spk_mute
                          isPresenter:(BOOL)presenter
                         sessionToken:(NSString *)tokenString
                           audioWsUrl:(NSString *)audioWsUrl
                       callKitEnabled:(BOOL)callKitEnabled
;

- (NSInteger)stopSession;

- (BOOL)isSpeakerOn;

- (BOOL)setSpeakerOn:(BOOL)value;

- (NSInteger) stopAudioRecord;

- (BOOL)isMicrophoneMuted;

- (NSInteger)setMicrophoneMuted:(BOOL)mute;

- (BOOL)isBliteNSSelected;

- (NSInteger)setBliteNSSelected:(BOOL)bliteSelected;

- (void)setPresenter:(BOOL)presenter;

- (void)joinPrimaryMeeting:(NSString*)attendeeId
            externalUserId:(NSString*)externalUserId
                 joinToken:(NSString*)joinToken;

- (void)leavePrimaryMeeting;

- (void)remoteMute;

- (void) audioLogCallBack:(loglevel_t)logLevel
                      msg:(NSString*)msg;
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
- (void)beginOnHold;
- (void)endOnHold;
#endif
+ (AudioClient *)sharedInstance;

@end

@interface AttendeeUpdate: NSObject

@property NSString *profileId;
@property NSString *externalUserId;
@property NSNumber *data;

- (id) initWithProfileId:(NSString *)profile_id
          externalUserId:(NSString *)external_user_id
                    data:(NSNumber *)data;

@end
