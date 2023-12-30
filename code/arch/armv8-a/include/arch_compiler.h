/**
 * @file arch_compiler.h
 * 
 * @brief CPU architecture related underlying memory access related interfaces.
 * 
 * @copyright Copyright (c) 2023
 */
#ifndef ARCH_COMPILER_H_
#define ARCH_COMPILER_H_

#include "arch_types.h"

#ifndef ARCH_CPU_TYPE
#define ARCH_CPU_TYPE   64
#endif

#if (ARCH_CPU_TYPE == 32)
static inline uint8_t readb(const volatile void *addr)
{
	uint8_t val;
	asm volatile("ldrb %1, %0"
		    : "+Qo" (*(volatile uint8_t *)addr),
		      "=r" (val));
	return val;
}

static inline uint16_t readw(const volatile void *addr)
{
	uint16_t val;
	asm volatile("ldrh %1, %0"
		     : "+Q" (*(volatile uint16_t *)addr),
		       "=r" (val));
	return val;
}

static inline uint32_t readl(const volatile void *addr)
{
	uint32_t val;
	asm volatile("ldr %1, %0"
		     : "+Qo" (*(volatile uint32_t *)addr),
		       "=r" (val));
	return val;
}

static inline void writeb(uint8_t val, volatile void *addr)
{
	asm volatile("strb %1, %0"
		     : "+Qo" (*(volatile uint8_t *)addr)
		     : "r" (val));
}

static inline void writew(uint16_t val, volatile void *addr)
{
	asm volatile("strh %1, %0"
		     : "+Q" (*(volatile uint16_t *)addr)
		     : "r" (val));
}

static inline void writel(uint32_t val, volatile void *addr)
{
	asm volatile("str %1, %0"
		     : "+Qo" (*(volatile uint32_t *)addr)
		     : "r" (val));
}
#else
static inline uint8_t readb(const volatile void *addr)
{
	uint8_t val;
	asm volatile("ldrb %w0, [%1]" : "=r" (val) : "r" (addr));
	return val;
}

static inline uint16_t readw(const volatile void *addr)
{
	uint16_t val;
	asm volatile("ldrh %w0, [%1]" : "=r" (val) : "r" (addr));
	return val;
}

static inline uint32_t readl(const volatile void *addr)
{
	uint32_t val;
	asm volatile("ldr %w0, [%1]" : "=r" (val) : "r" (addr));
	return val;
}

static inline uint64_t readq(const volatile void *addr)
{
	uint64_t val;
	asm volatile("ldr %0, [%1]" : "=r" (val) : "r" (addr));
	return val;
}

static inline void writeb(uint8_t val, volatile void *addr)
{
	asm volatile("strb %w0, [%1]" : : "r" (val), "r" (addr));
}

static inline void writew(uint16_t val, volatile void *addr)
{
	asm volatile("strh %w0, [%1]" : : "r" (val), "r" (addr));
}

static inline void writel(uint32_t val, volatile void *addr)
{
	asm volatile("str %w0, [%1]" : : "r" (val), "r" (addr));
}

static inline void writeq(uint64_t val, volatile void *addr)
{
	asm volatile("str %0, [%1]" : : "r" (val), "r" (addr));
}
#endif

#define bit(nr)         (1UL << (nr))
/* Compute the number of elements in the given array */
#define array_size(a)   (sizeof(a) / sizeof((a)[0]))

#define barrier()       __asm__ __volatile__("": : :"memory")

#endif /* ARCH_COMPILER_H_ */
