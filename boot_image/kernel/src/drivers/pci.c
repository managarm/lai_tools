#include <stdint.h>
#include <cio.h>

/* Shamelessly stolen from qookie */

uint8_t pci_read_byte(uint32_t bus, uint32_t slot, uint32_t func, uint16_t offset) {
    port_out_d(0xCF8, (bus << 16) | (slot << 11) | (func << 8) | (offset & 0xFFFF) | 0x80000000);
    uint8_t v = port_in_b(0xCFC + (offset % 4));
    return v;
}

void pci_write_byte(uint32_t bus, uint32_t slot, uint32_t func, uint16_t offset, uint8_t value) {
    port_out_d(0xCF8, (bus << 16) | (slot << 11) | (func << 8) | (offset & 0xFFFF) | 0x80000000);
    port_out_b(0xCFC + (offset % 4), value);
}

uint16_t pci_read_word(uint32_t bus, uint32_t slot, uint32_t func, uint16_t offset) {
    port_out_d(0xCF8, (bus << 16) | (slot << 11) | (func << 8) | (offset & 0xFFFE) | 0x80000000);
    uint16_t v = port_in_w(0xCFC + (offset % 4));
    return v;
}

void pci_write_word(uint32_t bus, uint32_t slot, uint32_t func, uint16_t offset, uint16_t value) {
    port_out_d(0xCF8, (bus << 16) | (slot << 11) | (func << 8) | (offset & 0xFFFE) | 0x80000000);
    port_out_w(0xCFC + (offset % 4), value);
}

uint32_t pci_read_dword(uint32_t bus, uint32_t slot, uint32_t func, uint16_t offset) {
    port_out_d(0xCF8, (bus << 16) | (slot << 11) | (func << 8) | (offset & 0xFFFC) | 0x80000000);
    uint32_t v = port_in_d(0xCFC + (offset % 4));
    return v;
}

void pci_write_dword(uint32_t bus, uint32_t slot, uint32_t func, uint16_t offset, uint32_t value) {
    port_out_d(0xCF8, (bus << 16) | (slot << 11) | (func << 8) | (offset & 0xFFFC) | 0x80000000);
    port_out_d(0xCFC + (offset % 4), value);
}
