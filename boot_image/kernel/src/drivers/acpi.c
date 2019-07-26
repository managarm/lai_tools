#include <stdint.h>
#include <stddef.h>
#include <kernel.h>
#include <klib.h>
#include <panic.h>
#include <acpi.h>
#include <mm.h>

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

void init_acpi(void) {
    kprint(KPRN_INFO, "ACPI: Initialising...");

    /* look for the "RSD PTR " signature from 0x80000 to 0xa0000 */
                                           /* 0xf0000 to 0x100000 */
    for (size_t i = 0x80000 + MEM_PHYS_OFFSET; i < 0x100000 + MEM_PHYS_OFFSET; i += 16) {
        if (i == 0xa0000 + MEM_PHYS_OFFSET) {
            /* skip video mem and mapped hardware */
            i = 0xe0000 + MEM_PHYS_OFFSET - 16;
            continue;
        }
        if (!kstrncmp((char *)i, "RSD PTR ", 8)) {
            kprint(KPRN_INFO, "ACPI: Found RSDP at %X", i);
            rsdp = (rsdp_t *)i;
            goto rsdp_found;
        }
    }
    panic("ACPI: RSDP table not found", 0);

rsdp_found:
    if (rsdp->rev >= 2 && rsdp->xsdt_addr) {
        use_xsdt = 1;
        kprint(KPRN_INFO, "acpi: Found XSDT at %X", (uint32_t)rsdp->xsdt_addr + MEM_PHYS_OFFSET);
        xsdt = (xsdt_t *)(size_t)(rsdp->xsdt_addr + MEM_PHYS_OFFSET);
    } else {
        kprint(KPRN_INFO, "acpi: Found RSDT at %X", (uint32_t)rsdp->rsdt_addr + MEM_PHYS_OFFSET);
        rsdt = (rsdt_t *)(size_t)(rsdp->rsdt_addr + MEM_PHYS_OFFSET);
    }

    return;
}
