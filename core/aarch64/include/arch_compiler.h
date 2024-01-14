#ifndef ARCH_COMPILER_H_
#define ARCH_COMPILER_H_

#include "arch_types.h"

#ifndef ARCH_CPU_TYPE
#define ARCH_CPU_TYPE   64
#endif

#if (ARCH_CPU_TYPE == 32)
static inline uint8_t _readb(const volatile void *addr)
{
	uint8_t val;
	__asm__ volatile("ldrb %1, %0"
		    : "+Qo" (*(volatile uint8_t *)addr),
		      "=r" (val));
	return val;
}

static inline uint16_t _readw(const volatile void *addr)
{
	uint16_t val;
	__asm__ volatile("ldrh %1, %0"
		     : "+Q" (*(volatile uint16_t *)addr),
		       "=r" (val));
	return val;
}

static inline uint32_t _readl(const volatile void *addr)
{
	uint32_t val;
	__asm__ volatile("ldr %1, %0"
		     : "+Qo" (*(volatile uint32_t *)addr),
		       "=r" (val));
	return val;
}

static inline void _writeb(uint8_t val, volatile void *addr)
{
	__asm__ volatile("strb %1, %0"
		     : "+Qo" (*(volatile uint8_t *)addr)
		     : "r" (val));
}

static inline void _writew(uint16_t val, volatile void *addr)
{
	__asm__ volatile("strh %1, %0"
		     : "+Q" (*(volatile uint16_t *)addr)
		     : "r" (val));
}

static inline void _writel(uint32_t val, volatile void *addr)
{
	__asm__ volatile("str %1, %0"
		     : "+Qo" (*(volatile uint32_t *)addr)
		     : "r" (val));
}
#else
static inline uint8_t _readb(const volatile void *addr)
{
	uint8_t val;
	__asm__ volatile("ldrb %w0, [%1]" : "=r" (val) : "r" (addr));
	return val;
}

static inline uint16_t _readw(const volatile void *addr)
{
	uint16_t val;
	__asm__ volatile("ldrh %w0, [%1]" : "=r" (val) : "r" (addr));
	return val;
}

static inline uint32_t _readl(const volatile void *addr)
{
	uint32_t val;
	__asm__ volatile("ldr %w0, [%1]" : "=r" (val) : "r" (addr));
	return val;
}

static inline uint64_t _readq(const volatile void *addr)
{
	uint64_t val;
	__asm__ volatile("ldr %0, [%1]" : "=r" (val) : "r" (addr));
	return val;
}

static inline void _writeb(uint8_t val, volatile void *addr)
{
	__asm__ volatile("strb %w0, [%1]" : : "r" (val), "r" (addr));
}

static inline void _writew(uint16_t val, volatile void *addr)
{
	__asm__ volatile("strh %w0, [%1]" : : "r" (val), "r" (addr));
}

static inline void _writel(uint32_t val, volatile void *addr)
{
	__asm__ volatile("str %w0, [%1]" : : "r" (val), "r" (addr));
}

static inline void _writeq(uint64_t val, volatile void *addr)
{
	__asm__ volatile("str %0, [%1]" : : "r" (val), "r" (addr));
}
#endif

#define bit(nr)         (1UL << (nr))
/* Compute the number of elements in the given array */
#define array_size(a)   (sizeof(a) / sizeof((a)[0]))

#define barrier()       __asm__ __volatile__("": : :"memory")

#define readb(a)       _readb((void *)(a))
#define readw(a)       _readw((void *)(a))
#define readl(a)       _readl((void *)(a))
#define readq(a)       _readq((void *)(a))
#define writeb(v, a)   _writeb(v, (void *)(a))
#define writew(v, a)   _writew(v, (void *)(a))
#define writel(v, a)   _writel(v, (void *)(a))
#define writeq(v, a)   _writeq(v, (void *)(a))

#endif /* ARCH_COMPILER_H_ */
