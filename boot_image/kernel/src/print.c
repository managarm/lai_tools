#include <stddef.h>
#include <stdint.h>
#include <stdarg.h>
#include <print.h>
#include <lib.h>
#include <limine.h>
#include <pmm.h>
#include <flanterm/backends/fb.h>
#include <lai/host.h>

static const char *base_digits = "0123456789abcdef";

static void prn_str(char *print_buf, size_t limit, size_t *print_buf_i, const char *string) {
    size_t i;

    for (i = 0; string[i]; i++) {
        if (*print_buf_i == (limit - 1))
            break;
        print_buf[(*print_buf_i)++] = string[i];
    }

    print_buf[*print_buf_i] = 0;
}

static void prn_nstr(char *print_buf, size_t limit, size_t *print_buf_i, const char *string, size_t len) {
    size_t i;

    for (i = 0; i < len; i++) {
        if (*print_buf_i == (limit - 1))
            break;
        print_buf[(*print_buf_i)++] = string[i];
    }

    print_buf[*print_buf_i] = 0;
}

static void prn_char(char *print_buf, size_t limit, size_t *print_buf_i, char c) {
    if (*print_buf_i < (limit - 1)) {
        print_buf[(*print_buf_i)++] = c;
    }

    print_buf[*print_buf_i] = 0;
}

static void prn_i(char *print_buf, size_t limit, size_t *print_buf_i, int64_t x) {
    int i;
    char buf[20] = {0};

    if (!x) {
        prn_char(print_buf, limit, print_buf_i, '0');
        return;
    }

    int sign = x < 0;
    if (sign) x = -x;

    for (i = 18; x; i--) {
        buf[i] = (x % 10) + 0x30;
        x = x / 10;
    }
    if (sign)
        buf[i] = '-';
    else
        i++;

    prn_str(print_buf, limit, print_buf_i, buf + i);
}

static void prn_ui(char *print_buf, size_t limit, size_t *print_buf_i, uint64_t x) {
    int i;
    char buf[21] = {0};

    if (!x) {
        prn_char(print_buf, limit, print_buf_i, '0');
        return;
    }

    for (i = 19; x; i--) {
        buf[i] = (x % 10) + 0x30;
        x = x / 10;
    }

    i++;
    prn_str(print_buf, limit, print_buf_i, buf + i);
}

static void prn_x(char *print_buf, size_t limit, size_t *print_buf_i, uint64_t x) {
    int i;
    char buf[17] = {0};

    if (!x) {
        prn_str(print_buf, limit, print_buf_i, "0x0");
        return;
    }

    for (i = 15; x; i--) {
        buf[i] = base_digits[(x % 16)];
        x = x / 16;
    }

    i++;
    prn_str(print_buf, limit, print_buf_i, "0x");
    prn_str(print_buf, limit, print_buf_i, buf + i);
}

struct limine_framebuffer_request framebuffer_request = {
    .id = LIMINE_FRAMEBUFFER_REQUEST,
    .revision = 0
};

#define MAX_PRINT_BUF_SIZE 256

void print(const char *fmt, ...) {
    if (!pmm_initialised) {
        return;
    }

    if (framebuffer_request.response == NULL) {
        return;
    }

    if (framebuffer_request.response->framebuffer_count < 1) {
        return;
    }

    struct limine_framebuffer *fb = framebuffer_request.response->framebuffers[0];

    static struct flanterm_context *term = NULL;
    if (term == NULL) {
        term = flanterm_fb_init(
            laihost_malloc,
            laihost_free,
            fb->address, fb->width, fb->height, fb->pitch,
            NULL,
            NULL, NULL,
            NULL, NULL,
            NULL, NULL,
            NULL, 0, 0, 1,
            1, 1,
            0
        );
    }

    va_list args;
    va_start(args, fmt);

    // We allocate on the stack to be thread safe *and* avoid using the allocator
    char buf[MAX_PRINT_BUF_SIZE];
    size_t len = vsnprint(buf, MAX_PRINT_BUF_SIZE, fmt, args);

    flanterm_write(term, buf, len);

    va_end(args);
}

size_t snprint(char *buf, size_t limit, const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);

    size_t ret = vsnprint(buf, limit, fmt, args);

    va_end(args);

    return ret;
}

size_t vsnprint(char *print_buf, size_t limit, const char *fmt, va_list args) {
    size_t print_buf_i = 0;

    for (;;) {
        while (*fmt && *fmt != '%')
            prn_char(print_buf, limit, &print_buf_i, *fmt++);

        if (!*fmt++)
            goto out;

        switch (*fmt++) {
            case 's': {
                char *str = (char *)va_arg(args, const char *);
                if (!str)
                    prn_str(print_buf, limit, &print_buf_i, "(null)");
                else
                    prn_str(print_buf, limit, &print_buf_i, str);
                break;
            }
            case 'S': {
                char *str = (char *)va_arg(args, const char *);
                size_t str_len = va_arg(args, size_t);
                if (!str)
                    prn_str(print_buf, limit, &print_buf_i, "(null)");
                else
                    prn_nstr(print_buf, limit, &print_buf_i, str, str_len);
                break;
            }
            case 'd':
                prn_i(print_buf, limit, &print_buf_i, (int64_t)va_arg(args, int32_t));
                break;
            case 'u':
                prn_ui(print_buf, limit, &print_buf_i, (uint64_t)va_arg(args, uint32_t));
                break;
            case 'x':
                prn_x(print_buf, limit, &print_buf_i, (uint64_t)va_arg(args, uint32_t));
                break;
            case 'D':
                prn_i(print_buf, limit, &print_buf_i, va_arg(args, int64_t));
                break;
            case 'U':
                prn_ui(print_buf, limit, &print_buf_i, va_arg(args, uint64_t));
                break;
            case 'X':
                prn_x(print_buf, limit, &print_buf_i, va_arg(args, uint64_t));
                break;
            case 'c': {
                char c = (char)va_arg(args, int);
                prn_char(print_buf, limit, &print_buf_i, c);
                break;
            }
            default:
                prn_char(print_buf, limit, &print_buf_i, '?');
                break;
        }
    }

out:
    return print_buf_i;
}
