#include <stddef.h>
#include <stdint.h>
#include <stdarg.h>
#include <cio.h>
#include <lib.h>
#include <print.h>
#include <lai/host.h>
#include <acpispec/tables.h>
#include <acpi.h>
#include <pmm.h>
#include <pci.h>

static void panic(const char *str) {
    print("PANIC: %s", str);
    for (;;) asm ("hlt");
}

void laihost_pci_writeb(uint16_t seg, uint8_t bus, uint8_t dev, uint8_t fun, uint16_t off, uint8_t val) {
	if (seg) panic("TODO: support PCI segments");
	pci_write_byte(bus, dev, fun, off, val);
}

uint8_t laihost_pci_readb(uint16_t seg, uint8_t bus, uint8_t dev, uint8_t fun, uint16_t off) {
	if (seg) panic("TODO: support PCI segments");
	return pci_read_byte(bus, dev, fun, off);
}

void laihost_pci_writew(uint16_t seg, uint8_t bus, uint8_t dev, uint8_t fun, uint16_t off, uint16_t val) {
	if (seg) panic("TODO: support PCI segments");
	pci_write_word(bus, dev, fun, off, val);
}

uint16_t laihost_pci_readw(uint16_t seg, uint8_t bus, uint8_t dev, uint8_t fun, uint16_t off) {
	if (seg) panic("TODO: support PCI segments");
	return pci_read_word(bus, dev, fun, off);
}

void laihost_pci_writed(uint16_t seg, uint8_t bus, uint8_t dev, uint8_t fun, uint16_t off, uint32_t val) {
	if (seg) panic("TODO: support PCI segments");
	pci_write_dword(bus, dev, fun, off, val);
}

uint32_t laihost_pci_readd(uint16_t seg, uint8_t bus, uint8_t dev, uint8_t fun, uint16_t off) {
	if (seg) panic("TODO: support PCI segments");
	return pci_read_dword(bus, dev, fun, off);
}

void laihost_log(int level, const char *str) {
    switch (level) {
        case LAI_DEBUG_LOG:
            print("lai debug: %s\n", str);
            break;
        case LAI_WARN_LOG:
            print("lai warning: %s\n", str);
            break;
        default:
            print("lai: %s\n", str);
            break;
    }
}

void laihost_panic(const char *str) {
    print("lai panic: %s", str);
    for (;;) asm ("hlt");
}

void *laihost_malloc(size_t size) {
    return pmm_alloc(DIV_ROUNDUP(size, PAGE_SIZE)) + MEM_PHYS_OFFSET;
}

void *laihost_realloc(void *p, size_t size, size_t oldsize) {
    void *old = p - MEM_PHYS_OFFSET;
    void *new = pmm_alloc(DIV_ROUNDUP(size, PAGE_SIZE)) + MEM_PHYS_OFFSET;
    memcpy(new, old, size > oldsize ? oldsize : size);
    laihost_free(p, oldsize);
    return new;
}

void laihost_free(void *p, size_t oldsize) {
    return pmm_free(p - MEM_PHYS_OFFSET, DIV_ROUNDUP(oldsize, PAGE_SIZE));
}

void *laihost_scan(const char *signature, size_t index) {
    // The DSDT is a special case, as it must be located using the pointer found in the FADT
    if (!strncmp(signature, "DSDT", 4)) {
        if (index > 0) {
            print("acpi: Only valid index for DSDT is 0\n");
            return NULL;
        }
        // Scan for the FADT
        acpi_fadt_t *fadt = (acpi_fadt_t *)acpi_find_sdt("FACP", 0);
        void *dsdt = (char *)(size_t)fadt->dsdt + MEM_PHYS_OFFSET;
        print("acpi: Address of DSDT is %X\n", dsdt);
        return dsdt;
    } else {
        return acpi_find_sdt(signature, index);
    }
}

uint8_t laihost_inb(uint16_t port) {
    return port_in_b(port);
}

void laihost_outb(uint16_t port, uint8_t value) {
    port_out_b(port, value);
}

uint16_t laihost_inw(uint16_t port) {
    return port_in_w(port);
}

void laihost_outw(uint16_t port, uint16_t value) {
    port_out_w(port, value);
}

uint32_t laihost_ind(uint16_t port) {
    return port_in_d(port);
}

void laihost_outd(uint16_t port, uint32_t value) {
    port_out_d(port, value);
}

void laihost_sleep(uint64_t duration) {
    (void)duration;
    panic("laihost_sleep is a stub");
}

void *laihost_map(size_t phys_addr, size_t count) {
    // all physical memory is mapped into the higher half, so we can just return
    // the physical address + the offset into the higher half.
    (void)count;
    size_t virt_addr = phys_addr + MEM_PHYS_OFFSET;
    return (void *)virt_addr;
}
