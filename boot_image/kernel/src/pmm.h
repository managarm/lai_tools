#ifndef __PMM_H__
#define __PMM_H__

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <limine.h>

#define PAGE_SIZE ((size_t)4096)

extern struct limine_hhdm_request pmm_hhdm_req;

void *pmm_alloc(size_t);
void *pmm_allocz(size_t);
void pmm_free(void *, size_t);
void pmm_init(void);

extern bool pmm_initialised;

#endif
