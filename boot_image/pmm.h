#ifndef __PMM_H__
#define __PMM_H__

#include <stddef.h>
#include <stdint.h>

#include <stivale2.h>

#define PAGE_SIZE ((size_t)4096)

#define MEM_PHYS_OFFSET ((size_t)0xffff800000000000)

void *pmm_alloc(size_t);
void *pmm_allocz(size_t);
void pmm_free(void *, size_t);
void pmm_init(struct stivale2_mmap_entry *memmap, size_t memmap_entries);

#endif
