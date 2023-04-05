//
//  video_client_enum.h
//  AmazonChimeSDKMedia
//
//  Copyright © 2020 Amazon. All rights reserved.
//

#ifndef video_client_enum_h
#define video_client_enum_h

#ifdef __cplusplus
extern "C" {
#endif

// Nearly all of these are unused
typedef enum {
    VIDEO_CLIENT_OK = 0,
    VIDEO_CLIENT_SERVICE_STOPPED = 1,
    VIDEO_CLIENT_ERR = 2,
    VIDEO_CLIENT_ERR_NO_MEM = 3,
    VIDEO_CLIENT_ERR_BUSY = 4,
    VIDEO_CLIENT_ERR_PEERCONN_FACTORY_CREATE_FAILED = 5,
    VIDEO_CLIENT_ERR_PEERCONN_CREATE_FAILED = 6,
    VIDEO_CLIENT_ERR_INVALID_SERVICE = 7,
    VIDEO_CLIENT_ERR_VIDEO_CAPTURER_CREATE_FAILED = 8,
    VIDEO_CLIENT_ERR_UNKNOWN_SERVICE_ID = 9,
    VIDEO_CLIENT_ERR_INVALID_PARAMETER = 10,
    VIDEO_CLIENT_ERR_NOT_STARTED = 11,
    VIDEO_CLIENT_ERR_SEND_JOIN_FAILED = 12,
    VIDEO_CLIENT_ERR_SIGNALER_OPEN_FAILED = 13,
    VIDEO_CLIENT_ERR_PEERCONN = 14,
    VIDEO_CLIENT_ERR_SUBSCRIBE = 15,
    VIDEO_CLIENT_ERR_JOIN_ACK = 16,
    VIDEO_CLIENT_ERR_SUBSCRIBE_ACK = 17,
    VIDEO_CLIENT_ERR_CREATE_OFFER = 18,
    VIDEO_CLIENT_ERR_CONTROL_STATUS = 19,
    VIDEO_CLIENT_ERR_CONTROL_SEND = 20,
    VIDEO_CLIENT_ERR_CONTROL_CONNECTION = 21,
    VIDEO_CLIENT_ERR_CONTROL_TIMEOUT = 22,
    VIDEO_CLIENT_ERR_INVALID_ARG = 23,
    VIDEO_CLIENT_ERR_DEPRECATED = 24,
    VIDEO_CLIENT_ERR_THREAD_CREATE_FAILED = 25,
    VIDEO_CLIENT_ERR_THREAD_JOIN_FAILED = 26,
    VIDEO_CLIENT_ERR_QUEUE_CREATE_FAILED = 27,
    VIDEO_CLIENT_ERR_QUEUE_TERM_FAILED = 28,
    VIDEO_CLIENT_ERR_QUEUE_PUSH_FAILED = 29,
    VIDEO_CLIENT_ERR_POOL_CREATE_FAILED = 30,
    VIDEO_CLIENT_ERR_UNKNOWN_EVENT = 31,
    VIDEO_CLIENT_ERR_INVALID_STATE = 32,
    VIDEO_CLIENT_ERR_SESSION_DESCRIPTION_FAILED = 33,
    VIDEO_CLIENT_ERR_SET_LOCAL_DESCRIPTION_FAILED = 34,
    VIDEO_CLIENT_ERR_SET_REMOTE_DESCRIPTION_FAILED = 35,
    VIDEO_CLIENT_ERR_ADD_STREAM = 36,
    VIDEO_CLIENT_ERR_SEND_SUBSCRIBE_FAILED = 37,
    VIDEO_CLIENT_ERR_BAD_SPD_ANSWER = 38,
    VIDEO_CLIENT_ERR_SIGNALER_CLOSE_FAILED = 39,
    VIDEO_CLIENT_ERR_SUBSCRIPTION_INDEX = 40,
    VIDEO_CLIENT_ERR_MAX_RETRY_PERIOD_EXCEEDED = 41,
    VIDEO_CLIENT_ERR_SEND_LEAVE_FAILED = 42,
    VIDEO_CLIENT_ERR_LEAVE_ACK = 43,
    VIDEO_CLIENT_ERR_STOP_WAIT = 44,
    VIDEO_CLIENT_ERR_ICE_FAILED = 45,
    VIDEO_CLIENT_ERR_CREATE_LOCAL_MEDIA_STREAM = 46,
    VIDEO_CLIENT_ERR_QUEUE_POP_FAILED = 47,
    VIDEO_CLIENT_ERR_QUEUE_EOF = 48,
    VIDEO_CLIENT_ERR_SEND_STATS_FAILED = 49,
    VIDEO_CLIENT_ERR_SEND_PAUSE_FAILED = 50,
    VIDEO_CLIENT_ERR_INVALID_VIDEO_ID_FOR_TRACK = 51,
    VIDEO_CLIENT_ERR_NOT_IN_CONNECTED_STATE = 52,
    VIDEO_CLIENT_ERR_EVENT_PUT_TO_PENDING_QUEUE = 53,
    VIDEO_CLIENT_ERR_MEDIA_CONTEXT = 54,
    VIDEO_CLIENT_ERR_CREATE_DEVICE_MANAGER_FAIL = 55,
    VIDEO_CLIENT_ERR_GET_VIDEO_CAPTURE_DEVICES = 56,
    VIDEO_CLIENT_ERR_NO_CURRENT_CAPTURE_DEVICE = 57,
    VIDEO_CLIENT_ERR_CREATE_GLOBAL_OBJECT_FAIL = 58,
    VIDEO_CLIENT_ERR_GET_RENDERER_LOCK_FAIL = 59,
    VIDEO_CLIENT_ERR_AV_SYNC_NO_SYNCHUB_OBJECT = 60,
    VIDEO_CLIENT_ERR_AV_SYNC_PROCESS = 61,
    VIDEO_CLIENT_ERR_SEND_CLIENT_INFO_FAILED = 62,
    VIDEO_CLIENT_ERR_INVALID_RESOLUTION = 63,
    VIDEO_CLIENT_ERR_PROXY_AUTHENTICATION_FAILED = 64,
    VIDEO_CLIENT_ERR_PRIMARY_MEETING_JOIN_AUTHENTICATION_FAILED = 65,
    VIDEO_CLIENT_ERR_PRIMARY_MEETING_JOIN_AT_CAPACITY = 66,
    VIDEO_CLIENT_STATUS_ENUM_END = 67, /* this should always be last */
} video_client_status_t;

typedef enum {
    VIDEO_CLIENT_SERVICE_UNKNOWN = 0,
    VIDEO_CLIENT_SERVICE_SCREEN_TRANSMIT = 1, // Not implemented
    VIDEO_CLIENT_SERVICE_SCREEN_RECEIVE = 2, // Not implemented
    VIDEO_CLIENT_SERVICE_CAMERA_TRANSMIT = 3,
    VIDEO_CLIENT_SERVICE_CAMERA_RECEIVE = 4,
    VIDEO_CLIENT_SERVICE_CAMERA_DUPLEX = 5,
    VIDEO_CLIENT_SERVICE_CAMERA_IDLE = 6, // Neither send or receive
} video_client_service_type_t;

typedef enum {
    VIDEO_CLIENT_LOG_LEVEL_TRACE = 1,
    VIDEO_CLIENT_LOG_LEVEL_DEBUG = 2,
    VIDEO_CLIENT_LOG_LEVEL_INFO = 3,
    VIDEO_CLIENT_LOG_LEVEL_WARNING = 4,
    VIDEO_CLIENT_LOG_LEVEL_ERROR = 5,
    VIDEO_CLIENT_LOG_LEVEL_FATAL = 6,
    VIDEO_CLIENT_LOG_LEVEL_NOTIFY = 7,
} video_client_loglevel_t;

typedef enum {
    VIDEO_CLIENT_NO_PAUSE = 0,
    VIDEO_CLIENT_LOCAL_PAUSED_BY_BAD_NETWORKING = 1,
    VIDEO_CLIENT_REMOTE_PAUSED_BY_USER = 2,
    VIDEO_CLIENT_REMOTE_PAUSED_BY_VSI = 3, // Deprecated
    VIDEO_CLIENT_REMOTE_PAUSED_BY_LOCAL_BAD_NETWORK = 4,
} video_client_pause_type_t;

typedef enum {
    VIDEO_CLIENT_TURN_FEATURE_ON = 0, // Video via TURN
    VIDEO_CLIENT_TURN_FEATURE_OFF = 1, // Video direct to tincan
    VIDEO_CLIENT_TURN_STATUS_CCP_FAILURE = 2,
} video_client_turn_status_t;

typedef struct {
    const char* app_name;
    const char* app_version;
    const char* device_model;
    const char* device_make;
    const char* platform_name;
    const char* platform_version;
    const char* client_source;
    const char* chime_sdk_version;
} app_detailed_info_t;

typedef struct {
    const char* user_name;
    const char* password;
    uint64_t ttl;
    const char* signaling_url;
    const char** turn_data_uris;
    int size;
} turn_session_response_t;

typedef enum {
    LOWEST = 0,
    LOW = 10,
    MEDIUM = 20,
    HIGH = 30,
    HIGHEST = 40,
} priority_t;

typedef struct {
      int width;
      int height;
      int targetBitrate;
} target_resolution_t ;

typedef struct {
    priority_t priority;
    target_resolution_t target_resolution;
} remote_video_subscription_configuration_t;

typedef struct {
    char *attendee_id;
    remote_video_subscription_configuration_t config;
} remote_video_subscription_map_t;

typedef struct {
    const char* name;
    int clock_rate;
    const char* parameters;
} video_codec_t;

#ifdef __cplusplus
}
#endif

#endif /* video_client_enum_h */
