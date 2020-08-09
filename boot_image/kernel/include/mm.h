#ifndef __MM_H__
#define __MM_H__

#include <stddef.h>
#include <stdint.h>

#define PAGE_SIZE ((size_t)4096)

#define KERNEL_PHYS_OFFSET ((size_t)0xffffffffc0000000)
#define MEM_PHYS_OFFSET ((size_t)0xffff800000000000)

void *pmm_alloc(size_t);
void *pmm_allocz(size_t);
void pmm_free(void *, size_t);
void init_pmm(void);

#endif
