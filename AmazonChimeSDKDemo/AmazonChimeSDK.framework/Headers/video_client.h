// Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#ifndef VIDEO_CLIENT_H
#define VIDEO_CLIENT_H

#include <stddef.h>
#include <stdint.h>

#include "logger.h"
#include "instrumentation.h"
#include "proxy_comm.h"

#ifdef __cplusplus
extern "C" {
#endif

#define VIDEO_LEGACY_BIBA_VERSION 2
#define VIDEO_FIRST_WORKTALK_VERSION 3

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
    VIDEO_CLIENT_STATUS_ENUM_END = 65, /* this should always be last */
} video_client_status_t;

typedef enum {
    VIDEO_CLIENT_STATUS_CALL_AT_CAPACITY = 509,
    VIDEO_CLIENT_STATUS_CALL_AT_CAPACITY_VIEW_ONLY = 206
} video_client_control_status_t;

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
    VIDEO_CLIENT_STATE_UNKNOWN = -1,
    VIDEO_CLIENT_STATE_INIT = 0, // Deprecated
    VIDEO_CLIENT_STATE_FAILED = 1,
    VIDEO_CLIENT_STATE_STARTING = 2, // Deprecated
    VIDEO_CLIENT_STATE_CONNECTING = 3,
    VIDEO_CLIENT_STATE_CONNECTED = 4,
    VIDEO_CLIENT_STATE_STOPPING = 5,
    VIDEO_CLIENT_STATE_STOPPED = 6,
} video_client_service_state_t;

typedef enum {
    VIDEO_CLIENT_TEST_PATTERN_NONE = 0,
    VIDEO_CLIENT_TEST_PATTERN_VIDEO_FILE = 1, // Not implemented
    VIDEO_CLIENT_STUB_GENERATOR_SOLID_COLOR = 2, // Deprecated
    VIDEO_CLIENT_STUB_GENERATOR_RAW_DATA = 3, // Requires application to pass in raw YUV
} video_client_test_pattern_id_t;

typedef enum {
    VIDEO_CLIENT_LOG_LEVEL_TRACE = 1,
    VIDEO_CLIENT_LOG_LEVEL_DEBUG = 2,
    VIDEO_CLIENT_LOG_LEVEL_INFO = 3,
    VIDEO_CLIENT_LOG_LEVEL_WARNING = 4,
    VIDEO_CLIENT_LOG_LEVEL_ERROR = 5,
    VIDEO_CLIENT_LOG_LEVEL_FATAL = 6,
} video_client_loglevel_t;

typedef enum {
    VIDEO_CLIENT_NO_PAUSE = 0,
    VIDEO_CLIENT_LOCAL_PAUSED_BY_BAD_NETWORKING = 1,
    VIDEO_CLIENT_REMOTE_PAUSED_BY_USER = 2,
    VIDEO_CLIENT_REMOTE_PAUSED_BY_VSI = 3, // Deprecated
    VIDEO_CLIENT_REMOTE_PAUSED_BY_LOCAL_BAD_NETWORK = 4,
} video_client_pause_type_t;

typedef enum {
    // treat the 1st built-in device (if no built-in, use 1st available device) as default
    VIDEO_CLIENT_CAPTURE_DEVICE_DEFAULT = 1 << 0, // Unused by upstream
    VIDEO_CLIENT_CAPTURE_DEVICE_BUILT_IN = 1 << 1, // Unused by upstream
    VIDEO_CLIENT_CAPTURE_DEVICE_FRONT = 1 << 2,
    VIDEO_CLIENT_CAPTURE_DEVICE_BACK = 1 << 3,
} video_client_capture_device_flag_t;

typedef enum {
    VIDEO_CLIENT_CAPTURE_DEVICE_EVENT_UNKNOWN = 0,
    VIDEO_CLIENT_CAPTURE_DEVICE_EVENT_NOT_AVAILABLE = 1,
    VIDEO_CLIENT_CAPTURE_DEVICE_EVENT_AVAILABLE = 2,
    VIDEO_CLIENT_CAPTURE_DEVICE_END_EVENTS = 3,
} video_client_capture_device_event_t; // Deprecated

typedef enum {
    VIDEO_CLIENT_FLAG_DISABLE_ADAPTIVE_SUBSCRIBE = 1 << 0, // Deprecated
    VIDEO_CLIENT_FLAG_DISABLE_LOCAL_RENDERER = 1 << 1, // Deprecated
    VIDEO_CLIENT_FLAG_ENABLE_16_9_ASPECT_RATIO = 1 << 2,
    VIDEO_CLIENT_FLAG_ENABLE_UNIFIED_PLAN = 1 << 3,
    VIDEO_CLIENT_FLAG_ENABLE_PROBING_ADAPTIVE_SUBSCRIBE = 1 << 4,
    VIDEO_CLIENT_FLAG_ENABLE_SEND_SIDE_BWE = 1 << 5,
    VIDEO_CLIENT_FLAG_ENABLE_USE_HW_DECODE_AND_RENDER = 1 << 6,
} video_client_parameter_flag_t;

typedef enum {
    VIDEO_CLIENT_TURN_FEATURE_ON = 0, // Video via TURN
    VIDEO_CLIENT_TURN_FEATURE_OFF = 1, // Video direct to tincan
    VIDEO_CLIENT_TURN_STATUS_CCP_FAILURE = 2,
} video_client_turn_status_t;

typedef struct video_client_s video_client_t;
typedef struct video_capture_device_s video_capture_device_t;
typedef struct video_capture_device_list_s video_capture_device_list_t;
typedef struct video_metrics_list_s video_metrics_list_t;

typedef void(video_client_log_callback_t)(video_client_loglevel_t level, const char* msg, void* ctx);

// The video_capture_device_t object is only guaranteed valid for the duration of the callback
typedef video_client_status_t(video_client_capture_devices_event_callback_t)(video_client_capture_device_event_t type,
    video_capture_device_t* device,
    void* user_data);

struct video_capture_device_s {
    void (*destroy)(video_capture_device_t*);
    int (*flags)(video_capture_device_t*);
    const char* (*id)(video_capture_device_t*); // utf8, valid until video_capture_device_t is destroyed
    const char* (*name)(video_capture_device_t*); // utf8, valid until video_capture_device_t is destroyed
};

struct video_capture_device_list_s {
    video_capture_device_t** devices;
    int count;
    void (*destroy)(video_capture_device_list_t*);
};

typedef enum video_metric_name_s {
    VIDEO_AVAILABLE_SEND_BANDWIDTH = 0,
    VIDEO_AVAILABLE_RECEIVE_BANDWIDTH = 1,
    VIDEO_SEND_BITRATE = 2,
    VIDEO_SEND_PACKET_LOST_PERCENT = 3,
    VIDEO_SEND_FPS = 4,
    VIDEO_RECEIVE_BITRATE = 5,
    VIDEO_RECEIVE_PACKET_LOST_PERCENT = 6,
    VIDEO_METRICS_TOTAL,
} video_metric_name_t;

typedef struct video_metric_s {
    video_metric_name_t name;
    double value;
} video_metric_t;

typedef struct video_client_observer_s {
    void (*service_state)(struct video_client_observer_s*, video_client_service_state_t state,
        video_client_status_t status, int control_status);
    void (*camera_send_available)(struct video_client_observer_s*, int is_available);
    void (*request_turn_creds)(struct video_client_observer_s*);
    void (*metrics_available)(struct video_client_observer_s*, video_metric_t* metrics, int count);
    void* ctx;
} video_client_observer_t;

typedef struct video_client_track_info_s {
    int display_id;
    uint32_t video_id; // Corresponds to group ID
    const char* profile_id;
    video_client_pause_type_t pause_type;
} video_client_track_info_t;

typedef enum video_client_frame_memory_type_s {
    CPU_ARGB = 0,
    CPU_I420 = 1,
    GPU_NV12 = 2,
} video_client_frame_memory_type_t;

// width_ptr and height_ptr serve two purposes
//  1. They correspond to the image width and height
//  2. They correspond to out parameters which should be filled in with the
//     respective video tile's width and height for use by the video client
// is_hd_mode is deprecated
typedef struct video_client_renderer_s {
    void (*render)(struct video_client_renderer_s*, video_client_track_info_t* track_info, unsigned char* image_data,
        size_t len, int* width_ptr, int* height_ptr, int* is_hd_mode);

    void (*render_yuv)(struct video_client_renderer_s*, video_client_track_info_t* track_info, int* width_ptr, int* height_ptr,
        int* is_hd_mode, int chroma_size, const unsigned char* image_y, int image_stride_y,
        const unsigned char* image_u, int image_stride_u, const unsigned char* image_v,
        int image_stride_v);

    void* ctx;

    void (*render_native)(struct video_client_renderer_s*,
        video_client_track_info_t* track_info,
        video_client_frame_memory_type_t frame_memory_type,
        void* image_data,
        size_t len,
        int* width_ptr, int* height_ptr, int* is_hd_mode);
} video_client_renderer_t;

typedef struct {
    const char* app_version_name;
    const char* app_version_code;
    const char* device_model;
    const char* device_make;
    const char* platform_name;
    const char* platform_version;
} app_detailed_info_t;

typedef struct {
    const char* user_name;
    const char* password;
    uint64_t ttl;
    const char* signaling_url;
    const char** turn_data_uris;
    int size;
} turn_session_response_t;

// All following values are copied into video client
// so API user must take care of deletion
typedef struct {
    video_client_service_type_t service_type;
    const char* call_id;
    const char* control_url;
    const char* token;
    const char* ice_server_conf;
    const char* turn_server_conf; // Deprecated
    video_client_test_pattern_id_t test_pattern; // Basically just a flag for fake capturer
    const void* test_ctx; // Deprecated
    int flags;
    proxy_params_for_url_func proxy_param_callback;
    int version; // Deprecated
    app_detailed_info_t app_info;

    // Following string may be instantiated via retrival from an external service (currently feature service)
    // It is intentionally not parsed by the application, as its values are not meant to be part of the API
    const char* dynamic_config;
} video_client_parameters_t;

typedef struct {
    video_client_status_t (*create)(video_client_t** p, video_client_parameters_t* params,
        video_client_observer_t* observer, video_client_renderer_t* renderer,
        video_client_log_callback_t* log_callback, void* log_ctx,
        instrumentation_client_t* inst_client);
    // Asynchronous
    video_client_status_t (*start)(video_client_t*);

    // Synchronous - no more callbacks will occur once stop returns
    video_client_status_t (*stop)(video_client_t*);

    video_client_status_t (*set_service_type)(video_client_t*, video_client_service_type_t service_type);
    video_client_service_type_t (*get_service_type)(video_client_t*);

    // set_local_pause is deprecated, currently unused, and currently unimplemented
    // TODO: When we have rest of clients building, remove upstream wrapper functions
    // and then remove this function completely
    video_client_status_t (*set_local_pause)(video_client_t*, int pause);
    int (*get_local_pause)(video_client_t*);

    // Application/local level pausing of remote streams; 0 = unpaused, 1 = unpaused;
    // video_id corresponds to video_id in renderer callback
    video_client_status_t (*set_remote_pause)(video_client_t*, uint32_t video_id, int pause);

    // Deprecated
    // TODO: Clean up upstream
    video_client_status_t (*set_capture_devices_event_callback)(video_client_capture_devices_event_callback_t* cb,
        void* user_data);

    // Yields a video_capture_device_list_t object that should be freed by caller with destroy_capture_device_list().
    video_client_status_t (*get_capture_devices)(video_capture_device_list_t** devices);

    // caller is responsible to free the returned device object with destroy().
    // device param can be NULL.
    // if current device is unavailable/suspended/unplugged/disabled, this API will return
    // VIDEO_CLIENT_ERR_NO_CURRENT_CAPTURE_DEVICE.
    video_client_status_t (*get_current_capture_device)(video_capture_device_t** device);

    // capture_device_id = NULL for default device
    // the video client object (1st param) can be NULL: it is used to choose the camera device before starting video
    // client if video client object isn't NULL, video will be switched to the new capture device
    video_client_status_t (*set_current_capture_device_id)(video_client_t*, const char* capture_device_id);

    // feed video data to virtual capture device
    video_client_status_t (*write_capture_frame)(video_client_t*, void* data, size_t len, int width, int height,
        uint32_t fourcc, uint32_t* timestamp);

    int (*is_active)(video_client_t*); // 0 = inactive, 1 = active

    // note: the caller must not destroy the video client from an observer callback.
    void (*destroy)(video_client_t*);

    // creds needed to connect to TURN.
    void (*update_turn_creds)(video_client_t*, turn_session_response_t* turn_response, video_client_turn_status_t turn_status);
} video_client_interface_t;

#if defined(WIN32) && defined(MEDIACLIENTDLL_EXPORTS)
__declspec(dllexport) video_client_status_t video_client_get_interface(video_client_interface_t** p_video_interface);
__declspec(dllexport) video_client_status_t video_client_initialize(void);
#else
video_client_status_t video_client_get_interface(video_client_interface_t** p_video_interface);
video_client_status_t video_client_initialize(void);
#endif

// Caller is repsonsible to free the returned value of these functions, if any
const char* video_client_service_type_string(video_client_service_type_t service_type);
const char* video_client_service_state_string(video_client_service_state_t state);
const char* video_client_capture_device_event_to_string(video_client_capture_device_event_t event);

#ifdef __cplusplus
}
#endif

#endif // VIDEO_CLIENT_H
