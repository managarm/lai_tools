#include <stdint.h>
#include <stddef.h>
#include <stivale2.h>
#include <print.h>
#include <pmm.h>
#include <idt.h>
#include <pic.h>
#include <acpi.h>
#include <lai/core.h>
#include <lai/helpers/sci.h>

static uint8_t stack[4096];

struct stivale2_header_tag_terminal terminal_hdr_tag = {
    .tag = {
        .identifier = STIVALE2_HEADER_TAG_TERMINAL_ID,
        .next = 0
    },
    .flags = 0
};

struct stivale2_header_tag_framebuffer framebuffer_hdr_tag = {
    .tag = {
        .identifier = STIVALE2_HEADER_TAG_FRAMEBUFFER_ID,
        .next = (uint64_t)&terminal_hdr_tag
    },
    .framebuffer_width  = 0,
    .framebuffer_height = 0,
    .framebuffer_bpp    = 0
};

__attribute__((section(".stivale2hdr"), used))
struct stivale2_header stivale_hdr = {
    .entry_point = 0,
    .stack = (uintptr_t)stack + sizeof(stack),
    .flags = 0,
    .tags = (uintptr_t)&framebuffer_hdr_tag
};

void *stivale2_get_tag(struct stivale2_struct *stivale2_struct, uint64_t id) {
    struct stivale2_tag *current_tag = (void *)stivale2_struct->tags;
    for (;;) {
        if (current_tag == NULL) {
            return NULL;
        }

        if (current_tag->identifier == id) {
            return current_tag;
        }

        current_tag = (void *)current_tag->next;
    }
}

void _start(struct stivale2_struct *stivale2_struct) {
    struct stivale2_struct_tag_terminal *term_str_tag;
    term_str_tag = stivale2_get_tag(stivale2_struct, STIVALE2_STRUCT_TAG_TERMINAL_ID);

    if (term_str_tag != NULL) {
        terminal_print = (void *)term_str_tag->term_write;
    }

    print("Kernel started.\n");

    struct stivale2_struct_tag_memmap *mmap_str_tag;
    mmap_str_tag = stivale2_get_tag(stivale2_struct, STIVALE2_STRUCT_TAG_MEMMAP_ID);

    pmm_init(mmap_str_tag->memmap, mmap_str_tag->entries);

    idt_init();

    print("Remapping legacy PIC...\n");
    map_PIC(0x20, 0x28);

    pic_enable_irq(2);

    struct stivale2_struct_tag_rsdp *rsdp_str_tag;
    rsdp_str_tag = stivale2_get_tag(stivale2_struct, STIVALE2_STRUCT_TAG_RSDP_ID);

    if (rsdp_str_tag == NULL) {
        print("No ACPI?");
        for (;;) asm ("hlt");
    }

    lai_enable_tracing(1);

    init_acpi(rsdp_str_tag->rsdp);

    asm ("sti");

    lai_create_namespace();

    acpi_init_ec();

    lai_enable_acpi(0);

    for (;;) asm ("hlt");
}
