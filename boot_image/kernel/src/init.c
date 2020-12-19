#include <stdint.h>
#include <kernel.h>
#include <mm.h>
#include <klib.h>
#include <cio.h>
#include <system.h>
#include <panic.h>
#include <acpi.h>
#include <vga_textmode.h>
#include <keyboard.h>
#include <pci.h>
#include <system.h>
#include <prompt.h>
#include <lai/core.h>
#include <lai/helpers/sci.h>

#include <stivale.h>

void _start(struct stivale_struct *stivale_struct) {
    init_gdt();

    #ifdef _KERNEL_VGA_OUTPUT_
        init_vga_textmode();
    #endif

    /* build descriptor tables */
    load_IDT();

    init_pmm((void *)stivale_struct->memory_map_addr,
             (size_t)stivale_struct->memory_map_entries);

    dmesg_on = true;

    kprint(KPRN_INFO, "PIC: Remapping legacy PIC...");
    map_PIC(0x20, 0x28);
    /* Mask all IRQs */
    set_PIC_mask(-1);
    /* Enable PIC0 cascade */
    pic_enable_irq(2);
    /* Enable IRQ0 (PIT) */
    pic_enable_irq(0);

    /* set PIT frequency */
    set_pit_freq(KRNL_PIT_FREQ);

    /* Enable LAI tracing */
    lai_enable_tracing(1);

    /* initialise ACPI */
    init_acpi(stivale_struct->rsdp);

    ENABLE_INTERRUPTS;

    init_kbd();

    /* Enable LAI */
    lai_create_namespace();

    acpi_init_ec();

    lai_enable_acpi(0);

    kprint(0, "kernel init done");

    debug_prompt();
}
