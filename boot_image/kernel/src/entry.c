#include <stdint.h>
#include <stddef.h>
#include <limine.h>
#include <print.h>
#include <pmm.h>
#include <idt.h>
#include <pic.h>
#include <acpi.h>
#include <lai/core.h>
#include <lai/helpers/sci.h>

static volatile LIMINE_BASE_REVISION(1);

void _start(void) {
    if (LIMINE_BASE_REVISION_SUPPORTED == false) {
        for (;;) asm ("hlt");
    }

    print("Kernel started.\n");

    pmm_init();

    idt_init();

    print("Remapping legacy PIC...\n");
    map_PIC(0x20, 0x28);

    pic_enable_irq(2);

    lai_enable_tracing(LAI_TRACE_OP | LAI_TRACE_IO);

    init_acpi();

    asm ("sti");

    lai_create_namespace();

    acpi_init_ec();

    lai_enable_acpi(0);

    for (;;) asm ("hlt");
}
