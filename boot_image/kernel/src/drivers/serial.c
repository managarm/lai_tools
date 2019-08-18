#include <stdint.h>
#include <cio.h>
#include <serial.h>

static uint16_t serial_ports[] = { 0x3f8, 0x2f8, 0x3e8, 0x2e8 };

void init_com1(void) {
    port_out_b(serial_ports[0] + 1, 0x00);
    port_out_b(serial_ports[0] + 3, 0x80);
    port_out_b(serial_ports[0] + 0, 0x03);
    port_out_b(serial_ports[0] + 1, 0x00);
    port_out_b(serial_ports[0] + 3, 0x03);
    port_out_b(serial_ports[0] + 2, 0xc7);
    port_out_b(serial_ports[0] + 4, 0x0b);
}

uint8_t com1_read(void) {
    while (!(port_in_b(serial_ports[0] + 5) & 0x01));
    return port_in_b(serial_ports[0]);
}

void com1_write(uint8_t data) {
    while (!(port_in_b(serial_ports[0] + 5) & 0x20));
    port_out_b(serial_ports[0], data);
}
