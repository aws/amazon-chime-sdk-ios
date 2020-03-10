#ifndef INSTRUMENTATION_H
#define INSTRUMENTATION_H

#ifdef __cplusplus
extern "C" {
#endif // ifdef __cplusplus

typedef void* instrumentation_event_t;

typedef enum {
    INSTRUMENTATION_CLIENT_OK  = 0,
    INSTRUMENTATION_CLIENT_ERR = 1,
    INSTRUMENTATION_CLIENT_NAMESPACE_INVALID = 2,
    INSTRUMENTATION_CLIENT_INVALID_ARGUMENTS = 3,
    INSTRUMENTATION_CLIENT_OUT_OF_MEMORY = 4,
    INSTRUMENTATION_CLIENT_NAME_NOT_FOUND = 5,
    INSTRUMENTATION_CLIENT_INIT_FAILURE = 6,
    INSTRUMENTATION_CLIENT_DESTROY_FAILURE = 7,
    INSTRUMENTATION_CLIENT_POST_MESSAGE_FAILURE = 8
}
instrumentation_status_t;

typedef struct instrumentation_client_s instrumentation_client_t;

/*
 * Set / Reset attribute and metric to be included with each request.  Only used within the scope of
 * this client.  These do NOT map to global attributes or metrics, they are simply copied to each
 * each event at log_event time.
 */
typedef instrumentation_status_t (* instrumentation_add_local_attribute_t) ( instrumentation_client_t *self,
                                                                             const char *name,
                                                                             const char *value );

typedef instrumentation_status_t (* instrumentation_add_local_metric_t) ( instrumentation_client_t *self,
                                                                          const char *name,
                                                                          double value );

typedef instrumentation_status_t (* instrumentation_remove_local_attribute_t) ( instrumentation_client_t *self,
                                                                                const char *name );

typedef instrumentation_status_t (* instrumentation_remove_local_metric_t) ( instrumentation_client_t *self,
                                                                             const char *name );

/*
 * creates an instrumentation event and returns the handle to it in @event
 */
typedef instrumentation_status_t (* instrumentation_create_event_t) ( instrumentation_client_t *self,
                                                                      instrumentation_event_t *event,
                                                                      const char *name );

typedef instrumentation_status_t (* instrumentation_event_add_attribute_t) ( instrumentation_client_t *self,
                                                                             instrumentation_event_t event,
                                                                             const char *name,
                                                                             const char *value );

typedef instrumentation_status_t (* instrumentation_event_add_metric_t) ( instrumentation_client_t *self,
                                                                          instrumentation_event_t event,
                                                                          const char *name,
                                                                          double value );

/*
 * logs the event, and as a side effect, reclaims it (from create_event)
 */
typedef instrumentation_status_t (* instrumentation_log_event_t) ( instrumentation_client_t *self,
                                                                   instrumentation_event_t event );

/*
 * This shouldn't be used, as instrumentation_log_event_t takes care of cleaning up the event data.
 * The function is provided for completeness, in the case where the caller *really* wants to
 * release event resources without logging it.
 */
typedef void (*instrumentation_destroy_event_t)(instrumentation_client_t *self, instrumentation_event_t event);

struct instrumentation_client_s {
    instrumentation_add_local_attribute_t    add_local_attribute;
    instrumentation_add_local_metric_t       add_local_metric;
    instrumentation_remove_local_attribute_t remove_local_attribute;
    instrumentation_remove_local_metric_t    remove_local_metric;
    instrumentation_create_event_t           create_event;
    instrumentation_event_add_attribute_t    event_add_attribute;
    instrumentation_event_add_metric_t       event_add_metric;
    instrumentation_log_event_t              log_event;
    instrumentation_destroy_event_t          destroy_event;
};

#ifdef __cplusplus
}
#endif // ifdef __cplusplus

#endif // ifndef INSTRUMENTATION_H
