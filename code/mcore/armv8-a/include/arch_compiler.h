#ifndef ARCH_COMPILER_H_
#define ARCH_COMPILER_H_

#define true	            1
#define false	            0
#define bool	            _Bool

#ifndef NULL
#define NULL                ((void *)0)
#endif /* NULL */

#ifdef __INT8_TYPE__
typedef __INT8_TYPE__       int8_t;
#endif
#ifdef __INT16_TYPE__
typedef __INT16_TYPE__      int16_t;
#endif
#ifdef __INT32_TYPE__
typedef __INT32_TYPE__      int32_t;
#endif
#ifdef __INT64_TYPE__
typedef __INT64_TYPE__      int64_t;
#endif
#ifdef __UINT8_TYPE__
typedef __UINT8_TYPE__      uint8_t;
#endif
#ifdef __UINT16_TYPE__
typedef __UINT16_TYPE__     uint16_t;
#endif
#ifdef __UINT32_TYPE__
typedef __UINT32_TYPE__     uint32_t;
#endif
#ifdef __UINT64_TYPE__
typedef __UINT64_TYPE__     uint64_t;
#endif
#ifdef __SIZE_TYPE__
typedef __SIZE_TYPE__       size_t;
#endif

#ifndef _VA_LIST
typedef __builtin_va_list   va_list;
#define _VA_LIST
#endif
#define va_start(ap, param) __builtin_va_start(ap, param)
#define va_end(ap)          __builtin_va_end(ap)
#define va_arg(ap, type)    __builtin_va_arg(ap, type)

#ifdef  __PTRDIFF_TYPE__
typedef __PTRDIFF_TYPE__    ptrdiff_t;
#endif

typedef __INTMAX_TYPE__     intmax_t;
typedef __UINTMAX_TYPE__    uintmax_t;

#ifndef _INTPTR_T
#ifndef __intptr_t_defined
typedef __INTPTR_TYPE__     intptr_t;
#define __intptr_t_defined
#define _INTPTR_T
#endif
#endif

#ifndef _UINTPTR_T
typedef __UINTPTR_TYPE__    uintptr_t;
#define _UINTPTR_T
#endif

#define readb(addr)         (*((volatile uint8_t  *)(addr)))
#define readw(addr)         (*((volatile uint16_t *)(addr)))
#define readl(addr)         (*((volatile uint32_t *)(addr)))
#define readq(addr)	        (*((volatile uint64_t *)(addr)))
#define writeb(v, addr)     (*((volatile uint8_t  *)(addr)) = (uint8_t )(v))
#define writew(v, addr)     (*((volatile uint16_t *)(addr)) = (uint16_t)(v))
#define writel(v, addr)     (*((volatile uint32_t *)(addr)) = (uint32_t)(v))
#define writeq(v, addr)	    (*((volatile uint64_t *)(addr)) = (uint64_t)(v))

/**
 * @brief Set/clear the bit starting from the specified address.
 * @param addr - the base addr
 * @param startbit - the target start bit.
 * @param width - the operating width.
 * @param val - the target value.
*/
static inline void rmwr32(const uint32_t addr, const uint32_t startbit, const uint32_t width, const uint32_t val)
{
    uint32_t value = 0;

    value = readl(addr);
    value &= ~((( 0x1U << width) - 1U) << startbit);
    value |=  ((((0x1U << width) - 1U) & val) << startbit);
    writel(value, addr);
}

/**
 * @brief Set/clear the bit starting from the specified address.
 * @param addr - the base addr
 * @param startbit - the target start bit.
 * @param width - the operating width.
 * @param val - the target value.
*/
static inline void rmwr64(const uint64_t addr, const uint32_t startbit, const uint32_t width, const uint64_t val)
{
    uint64_t value = 0;

    value = readq(addr);
    value &= ~((( 0x1U << width) - 1U) << startbit);
    value |=  ((((0x1U << width) - 1U) & val) << startbit);
    writeq(value, addr);
}

#define bit(nr)         (1UL << (nr))
/* Compute the number of elements in the given array */
#define array_size(a)   (sizeof(a) / sizeof((a)[0]))

#endif /* ARCH_COMPILER_H_ */
