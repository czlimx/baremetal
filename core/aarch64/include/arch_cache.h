#ifndef ARCH_CACHE_H_
#define ARCH_CACHE_H_

#include "arch_types.h"

/**
 * @brief Architecture instruction cache enabled
 * 
 * @note  Only EL0 and EL1 cache are enabled, EL2 and EL3 cache are disable by default.
 */
void arch_icache_enable(void);

/**
 * @brief Architecture instruction cache disabled
 * 
 * @note  Only EL0 and EL1 cache are disabled, EL2 and EL3 cache are disable by default.
 */
void arch_icahce_disable(void);

/**
 * @brief Architecture instruction cache invalidate all to PoU Inner Shareable
 */
void arch_icahce_invalidate_all(void);

/**
 * @brief Architecture instruction cache invalidate by virtual address (VA) to PoU
 * 
 * @param start The virtual start address of region
 * @param size  The size of region
 */
void arch_icahce_invalidate_range(uint64_t start, uint64_t size);

/**
 * @brief Architecture data cache enabled
 * 
 * @note  Only EL0 and EL1 cache are enabled, EL2 and EL3 cache are disable by default.
 */
void arch_dcache_enable(void);

/**
 * @brief Architecture data cache disabled
 * 
 * @note  Only EL0 and EL1 cache are disabled, EL2 and EL3 cache are disable by default.
 */
void arch_dcahce_disable(void);

/**
 * @brief Architecture data cache invalidate all by set/way
 */
void arch_dcahce_invalidate_all(void);

/**
 * @brief Architecture data cache clean all by set/way
 */
void arch_dcahce_clean_all(void);

/**
 * @brief Architecture data cache clean and invalidate all by set/way
 */
void arch_dcahce_flush_all(void);

/**
 * @brief Architecture data cache invalidate by virtual address (VA) to PoC
 * 
 * @param start The virtual start address of region
 * @param size  The size of region
 */
void arch_dcahce_invalidate_range(uint64_t start, uint64_t size);

/**
 * @brief Architecture data cache clean by virtual address (VA) to PoC
 * 
 * @param start The virtual start address of region
 * @param size  The size of region
 */
void arch_dcahce_clean_range(uint64_t start, uint64_t size);

/**
 * @brief Architecture data cache clean and invalidate by virtual address (VA) to PoC
 * 
 * @param start The virtual start address of region
 * @param size  The size of region
 */
void arch_dcahce_flush_range(uint64_t start, uint64_t size);

#endif /* ARCH_CACHE_H_ */
