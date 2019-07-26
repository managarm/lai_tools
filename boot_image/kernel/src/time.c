#include <stdint.h>
#include <kernel.h>
#include <klib.h>
#include <cio.h>
#include <system.h>

volatile uint64_t uptime_raw = 0;
volatile uint64_t uptime_sec = 0;

void timer_interrupt(void) {
    if (!(++uptime_raw % KRNL_PIT_FREQ))
        uptime_sec++;

    return;
}
