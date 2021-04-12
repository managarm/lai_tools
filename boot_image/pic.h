#ifndef __PIC_H__
#define __PIC_H__

#include <stdint.h>

void map_PIC(uint8_t PIC0Offset, uint8_t PIC1Offset);
uint16_t get_PIC_mask(void);
void set_PIC_mask(uint16_t mask);
void pic_enable_irq(int irq);
void set_PIC0_mask(uint8_t mask);
void set_PIC1_mask(uint8_t mask);
uint8_t get_PIC0_mask(void);
uint8_t get_PIC1_mask(void);

#endif
