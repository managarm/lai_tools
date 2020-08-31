#ifndef __KLIB_H__
#define __KLIB_H__

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <kernel.h>

char *strcpy(char *, const char *);
char *strncpy(char *, const char *, size_t);
size_t strlen(const char *);
int strcmp(const char *, const char *);
int strncmp(const char *, const char *, size_t);

void *memset(void *, int, size_t);
void *memcpy(void *, const void *, size_t);
int memcmp(const void *, const void *, size_t);
void *memmove(void *, const void *, size_t);

size_t kmemcpy(char *, const char *, size_t);
size_t kstrcpy(char *, const char *);
int kstrcmp(const char *, const char *);
int kstrncmp(const char *, const char *, size_t);
size_t kstrlen(const char *);
void *kalloc(size_t);
void kfree(void *);
void *krealloc(void *, size_t);
void kputs(const char *);
void knputs(const char *, size_t);
void kprn_ui(uint64_t);
void kprn_x(uint64_t);
void kprint(int type, const char *fmt, ...);

extern char *dmesg;
extern size_t dmesg_i;
extern size_t dmesg_len;
extern bool dmesg_on;

#define KPRN_INFO   0
#define KPRN_WARN   1
#define KPRN_ERR    2
#define KPRN_DBG    3
#define KPRN_RAW    4



#endif
