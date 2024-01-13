#ifndef ARCH_LIBC_H_
#define ARCH_LIBC_H_

#include "arch_types.h"

/**
 * @brief strcpy - Copy a %NUL terminated string
 * @dest: Where to copy the string to
 * @src: Where to copy the string from
 */
char *strcpy(char *dest, const char *src);
/**
 * strncpy - Copy a length-limited, %NUL-terminated string
 * @dest: Where to copy the string to
 * @src: Where to copy the string from
 * @count: The maximum number of bytes to copy
 *
 * Note that unlike userspace strncpy, this does not %NUL-pad the buffer.
 * However, the result is not %NUL-terminated if the source exceeds
 * @count bytes.
 */
char *strncpy(char *dest, const char *src, size_t count);

/**
 * @brief strcmp - Compare two strings
 * @cs: One string
 * @ct: Another string
 */
int strcmp(const char *cs, const char *ct);

/**
 * @brief strlen - Find the length of a string
 * @s: The string to be sized
 */
size_t strlen(const char *s);

/**
 * @brief memset - Fill a region of memory with the given value
 * @s: Pointer to the start of the area.
 * @c: The byte to fill the area with
 * @count: The size of the area.
 *
 * Do not use memset() to access IO space, use memset_io() instead.
 */
void *memset(void * s, int c, size_t count);

/**
 * @brief memcpy - Copy one area of memory to another
 * @dest: Where to copy to
 * @src:  Where to copy from
 * @count: The size of the area.
 *
 * You should not use this function to access IO space, use memcpy_toio()
 * or memcpy_fromio() instead.
 */
void *memcpy(void * dest, void *src, size_t count);

/**
 * @brief memmove - Copy one area of memory to another
 * @dest: Where to copy to
 * @src:  Where to copy from
 * @count: The size of the area.
 *
 * Unlike memcpy(), memmove() copes with overlapping areas.
 */
void * memmove(void * dest, void *src, size_t count);

/**
 * @brief memcmp - Compare two areas of memory
 * @cs:   One area of memory
 * @ct:   Another area of memory
 * @count: The size of the area.
 */
int memcmp(const void * cs, const void * ct, size_t count);

#endif /* ARCH_LIBC_H_ */