
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

void *laihost_realloc(void *p, size_t size) {
    return realloc(p, size);
}

void laihost_free(void *p) {
    return free(p);
}

