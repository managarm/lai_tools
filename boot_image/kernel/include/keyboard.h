#ifndef __KEYBOARD_H__
#define __KEYBOARD_H__

#include <stddef.h>

void init_kbd(void);
char getchar(void);
void gets(char *buf, size_t limit);

#endif
