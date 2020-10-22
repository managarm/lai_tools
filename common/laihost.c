
#include <stdio.h>
#include <stdlib.h>

#include <lai/host.h>

void laihost_log(int level, const char *str) {
    printf("%s\n", str);
}

void laihost_panic(const char *str) {
    printf("%s\n", str);
    abort();
}

void *laihost_malloc(size_t size) {
    return malloc(size);
}

void *laihost_realloc(void *p, size_t size, size_t oldsize) {
    (void)oldsize;
    return realloc(p, size);
}

void laihost_free(void *p, size_t size) {
    (void)size;
    return free(p);
}

