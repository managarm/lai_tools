#ifndef __IDT_H__
#define __IDT_H__

#include <stdint.h>
#include <stddef.h>

void idt_register_handler(size_t vec, void *handler, uint8_t ist, uint8_t type);
void idt_init(void);

#endif
