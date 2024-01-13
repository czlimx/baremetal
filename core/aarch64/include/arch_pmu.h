#ifndef ARCH_PMU_H_
#define ARCH_PMU_H_

#include "arch_types.h"

/**
 * @brief Architecture Performance Monitors init
 */
void arch_pmu_init(void);

/**
 * @brief Architecture Performance Monitors Cycle counter enable
 */
void arch_pmu_cycle_enable(void);

/**
 * @brief Architecture Performance Monitors Cycle counter disable
 */
void arch_pmu_cycle_disable(void);

/**
 * @brief Architecture Performance Monitors Cycle counter set value
 * 
 * @param value The Cycle counter value
 */
void arch_pmu_cycle_set(const uint64_t value);

/**
 * @brief Architecture Performance Monitors Cycle counter get value
 * 
 * @return uint64_t The Cycle counter value
 */
uint64_t arch_pmu_cycle_get(void);

/**
 * @brief Architecture Performance Monitors Cycle counter interrupt enable
 */
void arch_pmu_cycle_interrupt_enable(void);

/**
 * @brief Architecture Performance Monitors Cycle counter interrupt disable
 */
void arch_pmu_cycle_interrupt_disable(void);

/**
 * @brief Architecture Performance Monitors Cycle counter Unsigned overflow flag
 * 
 * @return Cycle counter Unsigned overflow flag
 */
bool arch_pmu_cycle_overflow_status_get(void);

/**
 * @brief Architecture Performance Monitors Cycle counter Unsigned overflow flag clear
 */
void arch_pmu_cycle_overflow_status_clr(void);

/**
 * @brief Architecture Performance Monitors Event counter enable
 * 
 * @param counter The Event counter ID
 */
void arch_pmu_event_enable(const uint64_t counter);

/**
 * @brief Architecture Performance Monitors Event counter disable
 * 
 * @param counter The Event counter ID
 */
void arch_pmu_event_disable(const uint64_t counter);

/**
 * @brief Architecture Performance Monitors Event counter set value
 * 
 * @param counter The Event counter ID
 * @param value The Event counter value
 */
void arch_pmu_event_set(const uint64_t counter, const uint64_t value);

/**
 * @brief Architecture Performance Monitors Event counter get value
 * 
 * @return uint64_t The Event counter value
 */
uint64_t arch_pmu_event_get(void);

/**
 * @brief Architecture Performance Monitors Event counter select event
 * 
 * @param counter The Event counter ID
 * @param event The Event ID
 */
void arch_pmu_event_select(const uint64_t counter, const uint64_t event);

/**
 * @brief Architecture Performance Monitors Event counter sofeware increment
 * 
 * @param counter The Event counter ID
 */
void arch_pmu_event_increment(const uint64_t counter);

/**
 * @brief Architecture Performance Monitors Event counter interrupt enable
 * 
 * @param counter The Event counter ID
 */
void arch_pmu_event_interrupt_enable(const uint64_t counter);

/**
 * @brief Architecture Performance Monitors Event counter interrupt disable
 * 
 * @param counter The Event counter ID
 */
void arch_pmu_event_interrupt_disable(const uint64_t counter);

/**
 * @brief Architecture Performance Monitors Event counter Unsigned overflow flag
 * 
 * @param counter The Event counter ID
 * 
 * @return Cycle counter Unsigned overflow flag
 */
bool arch_pmu_event_overflow_status_get(const uint64_t counter);

/**
 * @brief Architecture Performance Monitors Event counter Unsigned overflow flag clear
 * 
 * @param counter The Event counter ID
 */
void arch_pmu_event_overflow_status_clr(const uint64_t counter);

#endif /* ARCH_CACHE_H_ */
