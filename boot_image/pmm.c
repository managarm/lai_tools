#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <lib.h>
#include <pmm.h>
#include <print.h>
#include <bit.h>
#include <limine.h>

static const char *memmap_type(uint32_t type) {
    switch (type) {
        case LIMINE_MEMMAP_USABLE:
            return "Usable RAM";
        case LIMINE_MEMMAP_RESERVED:
            return "Reserved";
        case LIMINE_MEMMAP_ACPI_RECLAIMABLE:
            return "ACPI reclaimable";
        case LIMINE_MEMMAP_ACPI_NVS:
            return "ACPI NVS";
        case LIMINE_MEMMAP_BAD_MEMORY:
            return "Bad memory";
        case LIMINE_MEMMAP_BOOTLOADER_RECLAIMABLE:
            return "Bootloader reclaimable";
        case LIMINE_MEMMAP_KERNEL_AND_MODULES:
            return "Kernel/Modules";
        case LIMINE_MEMMAP_FRAMEBUFFER:
            return "Framebuffer";
        default:
            return "???";
    }
}

void print_memmap(struct limine_memmap_entry **mm, size_t size) {
    for (size_t i = 0; i < size; i++) {
        print("[%X -> %X] : %X  <%s>\n",
              mm[i]->base,
              mm[i]->base + mm[i]->length,
              mm[i]->length,
              memmap_type(mm[i]->type));
    }
}

static void *bitmap;
static size_t last_used_index = 0;
static uintptr_t highest_addr = 0;

static volatile struct limine_memmap_request memmap_req = {
    .id = LIMINE_MEMMAP_REQUEST,
    .revision = 0
};

void pmm_init(void) {
    struct limine_memmap_entry **memmap = memmap_req.response->entries;
    size_t memmap_entries = memmap_req.response->entry_count;

    print_memmap(memmap, memmap_entries);

    // First, calculate how big the bitmap needs to be.
    for (size_t i = 0; i < memmap_entries; i++) {
        if (memmap[i]->type != LIMINE_MEMMAP_USABLE
         && memmap[i]->type != LIMINE_MEMMAP_BOOTLOADER_RECLAIMABLE)
            continue;

        uintptr_t top = memmap[i]->base + memmap[i]->length;

        if (top > highest_addr)
            highest_addr = top;
    }

    size_t bitmap_size = ALIGN_UP((highest_addr / PAGE_SIZE) / 8, PAGE_SIZE);

    // Second, find a location with enough free pages to host the bitmap.
    for (size_t i = 0; i < memmap_entries; i++) {
        if (memmap[i]->type != LIMINE_MEMMAP_USABLE)
            continue;

        if (memmap[i]->length >= bitmap_size) {
            bitmap = (void *)(memmap[i]->base + MEM_PHYS_OFFSET);

            // Initialise entire bitmap to 1 (non-free)
            memset(bitmap, 0xff, bitmap_size);

            memmap[i]->length -= bitmap_size;
            memmap[i]->base += bitmap_size;

            break;
        }
    }

    // Third, populate free bitmap entries according to memory map.
    for (size_t i = 0; i < memmap_entries; i++) {
        if (memmap[i]->type != LIMINE_MEMMAP_USABLE)
            continue;

        for (uintptr_t j = 0; j < memmap[i]->length; j += PAGE_SIZE)
            bitmap_unset(bitmap, (memmap[i]->base + j) / PAGE_SIZE);
    }
}

static void *inner_alloc(size_t count, size_t limit) {
    size_t p = 0;

    while (last_used_index < limit) {
        if (!bitmap_test(bitmap, last_used_index++)) {
            if (++p == count) {
                size_t page = last_used_index - count;
                for (size_t i = page; i < last_used_index; i++) {
                    bitmap_set(bitmap, i);
                }
                return (void *)(page * PAGE_SIZE);
            }
        } else {
            p = 0;
        }
    }

    return NULL;
}

void *pmm_alloc(size_t count) {
    size_t l = last_used_index;
    void *ret = inner_alloc(count, highest_addr / PAGE_SIZE);
    if (ret == NULL) {
        last_used_index = 0;
        ret = inner_alloc(count, l);
    }

    if (ret == NULL) {
        print("pmm: Alloc failed with count=%X\n", count);
        for (;;) asm ("hlt");
    }

    return ret;
}

void *pmm_allocz(size_t count) {
    char *ret = (char *)pmm_alloc(count);

    if (ret == NULL)
        return NULL;

    uint64_t *ptr = (uint64_t *)(ret + MEM_PHYS_OFFSET);

    for (size_t i = 0; i < count * (PAGE_SIZE / sizeof(uint64_t)); i++)
        ptr[i] = 0;

    return ret;
}

void pmm_free(void *ptr, size_t count) {
    size_t page = (size_t)ptr / PAGE_SIZE;
    for (size_t i = page; i < page + count; i++)
        bitmap_unset(bitmap, i);
}
