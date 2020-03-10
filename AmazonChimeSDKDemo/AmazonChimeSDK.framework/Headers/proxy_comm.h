#ifndef __PROXY_COMM_H__
#define __PROXY_COMM_H__

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

#ifndef __CHIME_PROXY_SCHEME_T__
#define __CHIME_PROXY_SCHEME_T__
typedef enum {
    PROXY_SCHEME_DIRECT = 0,
    PROXY_SCHEME_WPAD,
    PROXY_SCHEME_PAC,
    PROXY_SCHEME_HTTP,
    PROXY_SCHEME_SOCKS,
} proxy_scheme_t;
#endif

#ifndef __CHIME_PROXY_PARAM_T__
#define __CHIME_PROXY_PARAM_T__
typedef struct proxy_param_s {
    char                  *server;
    unsigned short        port;
    proxy_scheme_t        scheme;
    char                  *username;
    char                  *password;
} proxy_param_t;
#endif

const char *proxy_scheme_string(proxy_scheme_t scheme);

void proxy_params_clear(proxy_param_t *p);

void proxy_params_free(proxy_param_t *p);

int proxy_params_dup(proxy_param_t *dst, const proxy_param_t *src);

bool proxy_params_is_valid_proxy(const proxy_param_t *p);

#ifndef __CHIME_PROXY_RESULT_T__
#define __CHIME_PROXY_RESULT_T__
typedef enum {
    PROXY_OK = 0,
    PROXY_ERR_NO_MEM,
    PROXY_ERR_INVALID_ARG,
    PROXY_ERR_HTTP_SERVICE_FAILURE,
    PROXY_ERR_INTERNAL_ERROR,
    PROXY_ERR_NO_PROXIES_FOUND,
    PROXY_ERR_UNKNOWN,
} proxy_result_t;
#endif

#ifndef __CHIME_PROXY_FPS_T__
#define __CHIME_PROXY_FPS_T__

/*
 * proxy_params_for_url_func - Callback to determine the proper proxy config to
 *                             use for the given URL.
 *
 * @url - (in)  URL for which to determine proxy parameters
 * @p   - (out) Pointer to proxy_param_t return value
 *
 * Returns PROXY_OK on success, !PROXY_OK on error. On success, the @p
 * parameter will have been populated with the proxy configuration to use.
 * This might be PROXY_SCHEME_DIRECT, as well, which means do not use a proxy
 * for this request. It is the caller's responsibility to destroy @p with the
 * proxy_params_free() function when they are finished with it. @p should not
 * be consulted if this function does not succeed.
 */
typedef proxy_result_t (*proxy_params_for_url_func)(const char*, proxy_param_t*);

/*
 * proxy_params_for_url_free_func - Free value created by proxy_params_for_url_func
 *
 * @p - (in) Object to destroy
 *
 * Only destroys the contents of @p, not @p itself. If @p was dynamically allocated,
 * it is the caller's responsbility to destroy it.
 */
typedef void (*proxy_params_for_url_free_func)(proxy_param_t*);

#endif /* __CHIME_PROXY_FPS_T__ */

#ifdef __cplusplus
}
#endif

#endif /* __PROXY_COMM_H__ */
