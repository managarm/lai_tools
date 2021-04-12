#include <stdint.h>
#include <stddef.h>
#include <acpi.h>
#include <lib.h>
#include <print.h>
#include <pmm.h>
#include <idt.h>
#include <pic.h>
#include <acpispec/tables.h>
#include <lai/helpers/sci.h>
#include <lai/drivers/ec.h>

rsdp_t *rsdp;
rsdt_t *rsdt;
xsdt_t *xsdt;

static int use_xsdt = 0;

/* Find SDT by signature */
void *acpi_find_sdt(const char *signature, int index) {
    acpi_sdt_t *ptr;
    int cnt = 0;

    if (use_xsdt) {
        for (size_t i = 0; i < (xsdt->sdt.length - sizeof(acpi_sdt_t)) / 8; i++) {
            ptr = (acpi_sdt_t *)((size_t)xsdt->sdt_ptr[i] + MEM_PHYS_OFFSET);
            if (!strncmp(ptr->signature, signature, 4)) {
                if (cnt++ == index) {
                    print("acpi: Found \"%s\" at %X\n", signature, (size_t)ptr);
                    return (void *)ptr;
                }
            }
        }
    } else {
        for (size_t i = 0; i < (rsdt->sdt.length - sizeof(acpi_sdt_t)) / 4; i++) {
            ptr = (acpi_sdt_t *)((size_t)rsdt->sdt_ptr[i] + MEM_PHYS_OFFSET);
            if (!strncmp(ptr->signature, signature, 4)) {
                if (cnt++ == index) {
                    print("acpi: Found \"%s\" at %X\n", signature, (size_t)ptr);
                    return (void *)ptr;
                }
            }
        }
    }

    print("acpi: \"%s\" not found\n", signature);
    return (void *)0;
}

int acpi_get_sci_irq(void) {
    acpi_fadt_t *fadt;
    if ((fadt = acpi_find_sdt("FACP", 0))) {
        return fadt->sci_irq;
    } else {
        return -1;
    }
}

static int sci_irq;

__attribute__((interrupt))
static void sci_handler(void *p) {
    (void)p;

    uint16_t ev = lai_get_sci_event();

    const char *ev_name = "?";
    if (ev & ACPI_POWER_BUTTON) ev_name = "power button";
    if (ev & ACPI_SLEEP_BUTTON) ev_name = "sleep button";
    if (ev & ACPI_WAKE) ev_name = "sleep wake up";

    print("acpi: a SCI event has occured: %x (%s)\n", ev, ev_name);

    pic_eoi(sci_irq);
}

void init_acpi(uintptr_t _rsdp) {
    print("acpi: Initialising...\n");

    rsdp = (void *)_rsdp;

    if (rsdp->rev >= 2 && rsdp->xsdt_addr) {
        use_xsdt = 1;
        print("acpi: Found XSDT at %X\n", (uint32_t)rsdp->xsdt_addr + MEM_PHYS_OFFSET);
        xsdt = (xsdt_t *)(size_t)(rsdp->xsdt_addr + MEM_PHYS_OFFSET);
    } else {
        print("acpi: Found RSDT at %X\n", (uint32_t)rsdp->rsdt_addr + MEM_PHYS_OFFSET);
        rsdt = (rsdt_t *)(size_t)(rsdp->rsdt_addr + MEM_PHYS_OFFSET);
    }

    madt_t *madt;
    // If there isn't a MADT there also shouldn't be any APICs so the PIC should just exist
    if ((madt = acpi_find_sdt("APIC", 0))) {
        if(!(madt->flags & (1 << 0))){
            // PCAT_COMPAT isn't set so there aren't any PICs
            print("No PIC detected");
            for (;;) asm ("hlt");
        }
    }

    sci_irq = acpi_get_sci_irq();
    print("acpi: SCI IRQ = %x\n", sci_irq);
    idt_register_handler(sci_irq + 0x20, sci_handler, 0, 0b10001110);
    pic_enable_irq(sci_irq);

    lai_set_acpi_revision(rsdp->rev);

    return;
}

void acpi_init_ec(void){
    LAI_CLEANUP_STATE lai_state_t state;
    lai_init_state(&state);

    LAI_CLEANUP_VAR lai_variable_t pnp_id = LAI_VAR_INITIALIZER;
    lai_eisaid(&pnp_id, ACPI_EC_PNP_ID);

    struct lai_ns_iterator it = LAI_NS_ITERATOR_INITIALIZER;
    lai_nsnode_t *node;
    while((node = lai_ns_iterate(&it))){
        if(lai_check_device_pnp_id(node, &pnp_id, &state)) // This is not an EC
            continue;

        // Found one
        struct lai_ec_driver *driver = pmm_alloc(DIV_ROUNDUP(sizeof(struct lai_ec_driver), PAGE_SIZE)); // Dynamically allocate the memory since -
        lai_init_ec(node, driver);                                           // we dont know how many ECs there could be

        struct lai_ns_child_iterator child_it = LAI_NS_CHILD_ITERATOR_INITIALIZER(node);
        lai_nsnode_t *child_node;
        while((child_node = lai_ns_child_iterate(&child_it))){
            if(lai_ns_get_node_type(child_node) == LAI_NODETYPE_OPREGION)
                lai_ns_override_opregion(child_node, &lai_ec_opregion_override, driver);
        }
    }
}
