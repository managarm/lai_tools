#ifndef __PCI_H__
#define __PCI_H__

#include <stdint.h>

uint8_t pci_read_byte(uint32_t bus, uint32_t slot, uint32_t func, uint16_t offset);

void pci_write_byte(uint32_t bus, uint32_t slot, uint32_t func, uint16_t offset, uint8_t value);

uint16_t pci_read_word(uint32_t bus, uint32_t slot, uint32_t func, uint16_t offset);

void pci_write_word(uint32_t bus, uint32_t slot, uint32_t func, uint16_t offset, uint16_t value);

uint32_t pci_read_dword(uint32_t bus, uint32_t slot, uint32_t func, uint16_t offset);

void pci_write_dword(uint32_t bus, uint32_t slot, uint32_t func, uint16_t offset, uint32_t value);

#endif
