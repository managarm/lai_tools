#include <stdint.h>
#include <stddef.h>
#include <acpi.h>
#include <kernel.h>
#include <klib.h>
#include <panic.h>
#include <acpi.h>
#include <mm.h>
#include <system.h>
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
                    kprint(KPRN_INFO, "acpi: Found \"%s\" at %X", signature, (size_t)ptr);
                    return (void *)ptr;
                }
            }
        }
    } else {
        for (size_t i = 0; i < (rsdt->sdt.length - sizeof(acpi_sdt_t)) / 4; i++) {
            ptr = (acpi_sdt_t *)((size_t)rsdt->sdt_ptr[i] + MEM_PHYS_OFFSET);
            if (!strncmp(ptr->signature, signature, 4)) {
                if (cnt++ == index) {
                    kprint(KPRN_INFO, "acpi: Found \"%s\" at %X", signature, (size_t)ptr);
                    return (void *)ptr;
                }
            }
        }
    }

    kprint(KPRN_INFO, "acpi: \"%s\" not found", signature);
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

void sci_handler_isr(void);
void sci_handler(void) {
    uint16_t ev = lai_get_sci_event();

    const char *ev_name = "?";
    if (ev & ACPI_POWER_BUTTON) ev_name = "power button";
    if (ev & ACPI_SLEEP_BUTTON) ev_name = "sleep button";
    if (ev & ACPI_WAKE) ev_name = "sleep wake up";

    kprint(KPRN_INFO, "acpi: a SCI event has occured: %x (%s)", ev, ev_name);
}

void init_acpi(uintptr_t _rsdp) {
    kprint(KPRN_INFO, "ACPI: Initialising...");

    rsdp = (void *)_rsdp;

    if (rsdp->rev >= 2 && rsdp->xsdt_addr) {
        use_xsdt = 1;
        kprint(KPRN_INFO, "acpi: Found XSDT at %X", (uint32_t)rsdp->xsdt_addr + MEM_PHYS_OFFSET);
        xsdt = (xsdt_t *)(size_t)(rsdp->xsdt_addr + MEM_PHYS_OFFSET);
    } else {
        kprint(KPRN_INFO, "acpi: Found RSDT at %X", (uint32_t)rsdp->rsdt_addr + MEM_PHYS_OFFSET);
        rsdt = (rsdt_t *)(size_t)(rsdp->rsdt_addr + MEM_PHYS_OFFSET);
    }

    madt_t *madt;
    // If there isn't a MADT there also shouldn't be any APICs so the PIC should just exist
    if ((madt = acpi_find_sdt("APIC", 0))) {
        if(!(madt->flags & (1 << 0))){
            // PCAT_COMPAT isn't set so there aren't any PICs
            panic("No PIC detected", 0);
        }
    }

    int sci_irq = acpi_get_sci_irq();
    kprint(KPRN_DBG, "acpi: SCI IRQ = %x", sci_irq);
    idt_register_handler(sci_irq + 0x20, 0b10001110, 0, sci_handler_isr);
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
        struct lai_ec_driver *driver = kalloc(sizeof(struct lai_ec_driver)); // Dynamically allocate the memory since -
        lai_init_ec(node, driver);                                           // we dont know how many ECs there could be

        struct lai_ns_child_iterator child_it = LAI_NS_CHILD_ITERATOR_INITIALIZER(node);
        lai_nsnode_t *child_node;
        while((child_node = lai_ns_child_iterate(&child_it))){
            if(lai_ns_get_node_type(child_node) == LAI_NODETYPE_OPREGION)
                lai_ns_override_opregion(child_node, &lai_ec_opregion_override, driver);
        }
    }
}
