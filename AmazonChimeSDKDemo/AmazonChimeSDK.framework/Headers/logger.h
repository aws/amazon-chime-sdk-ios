#ifndef _LOGGER_H_
#define _LOGGER_H_

#ifdef __cplusplus
extern "C" {
#endif

#include <stdarg.h>

typedef enum
{
	LOGGER_TRACE = 1,
	LOGGER_DEBUG = 2,
	LOGGER_INFO = 3,
	LOGGER_WARNING = 4,
	LOGGER_ERROR = 5,
	LOGGER_FATAL = 6,
} loglevel_t;


typedef struct logger_s logger_t;

typedef void (log_callback_t)(loglevel_t level, const char *msg, void *ctx);
int logger_create(logger_t **logger);

int logger_log4c_level_to_logger_level(int log4c_level);
int logger_xlog_level_to_logger_level(int xlog_level);

struct logger_s
{
	void(*vlog)(logger_t *t, loglevel_t level, const char *format, va_list args);
	void(*log)(logger_t *t, loglevel_t level, const char *msg);
	void(*trace)(logger_t *t, ...);
	void(*debug)(logger_t *t, ...);
	void(*info)(logger_t *t, ...);
	void(*warning)(logger_t *t, ...);
	void(*error)(logger_t *t, ...);
	void(*fatal)(logger_t *t, ...);
	void(*destroy)(logger_t *t);
	void(*setcallback)(logger_t *t, log_callback_t *callback, void *ctx);
};

#define  LOGTRACE(...)       if (self && self->log) self->log->trace(self->log, __VA_ARGS__);
#define  LOGDEBUG(...)       if (self && self->log) self->log->debug(self->log, __VA_ARGS__);
#define  LOGINFO(...)        if (self && self->log) self->log->info(self->log, __VA_ARGS__);
#define  LOGWARNING(...)     if (self && self->log) self->log->warning(self->log, __VA_ARGS__);
#define  LOGERROR(...)       if (self && self->log) self->log->error(self->log, __VA_ARGS__);
#define  LOGFATAL(...)       if (self && self->log) self->log->fatal(self->log, __VA_ARGS__);

#ifdef __cplusplus
}
#endif

#endif /* _LOGGER_H_ */
