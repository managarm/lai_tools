#ifndef __KEYBOARD_H__
#define __KEYBOARD_H__

#include <stddef.h>

#define GETCHAR_UP (-10)
#define GETCHAR_DOWN (-11)
#define GETCHAR_LEFT (-12)
#define GETCHAR_RIGHT (-13)
#define GETCHAR_PGUP (-14)
#define GETCHAR_PGDOWN (-15)

void init_kbd(void);
int getchar(void);
void gets(char *buf, size_t limit);

#endif
