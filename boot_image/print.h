#ifndef __PRINT_H__
#define __PRINT_H__

#include <stddef.h>
#include <stdarg.h>

extern void (*terminal_print)(const char *buf, size_t len);

void print(const char *fmt, ...);
size_t snprint(char *buf, size_t limit, const char *fmt, ...);
size_t vsnprint(char *print_buf, size_t limit, const char *fmt, va_list args);

#endif
