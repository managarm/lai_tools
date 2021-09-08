#ifndef __CIO_H__
#define __CIO_H__

#include <stdint.h>

#define DISABLE_INTERRUPTS      asm volatile ("cli":::"memory")
#define ENABLE_INTERRUPTS       asm volatile ("sti":::"memory")

#define SYSTEM_HALT              \
    asm volatile (              \
                    "1:"        \
                    "cli;"      \
                    "hlt;"      \
                    "jmp 1b;"   \
                    ::: "memory"\
                 )

#define port_out_b(port, value) ({				\
	asm volatile (	"outb %0, %1"				\
					:							\
					: "a" ((uint8_t)value), "Nd" (port)	\
					: "memory" );						\
})

#define port_out_w(port, value) ({				\
	asm volatile (	"outw %0, %1"				\
					:							\
					: "a" ((uint16_t)value), "Nd" (port)	\
					: "memory"  );						\
})

#define port_out_d(port, value) ({				\
	asm volatile (	"outl %0, %1"				\
					:							\
					: "a" ((uint32_t)value), "Nd" (port)	\
					: "memory"  );						\
})

#define port_in_b(port) ({						\
	uint8_t value;								\
	asm volatile (	"inb %1, %0"					\
					: "=a" (value)				\
					: "Nd" (port)				\
					: "memory"  );						\
	value;										\
})

#define port_in_w(port) ({						\
	uint16_t value;								\
	asm volatile (	"inw %1, %0"					\
					: "=a" (value)				\
					: "Nd" (port)				\
					: "memory"  );						\
	value;										\
})

#define port_in_d(port) ({						\
	uint32_t value;								\
	asm volatile (	"inl %1, %0"				\
					: "=a" (value)				\
					: "Nd" (port)				\
					: "memory"  );						\
	value;										\
})

#endif
