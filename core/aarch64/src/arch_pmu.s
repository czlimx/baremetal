    .global arch_pmu_init
    .global arch_pmu_cycle_enable
    .global arch_pmu_cycle_disable
    .global arch_pmu_cycle_set
    .global arch_pmu_cycle_get
    .global arch_pmu_cycle_interrupt_enable
    .global arch_pmu_cycle_interrupt_disable
    .global arch_pmu_cycle_interrupt_overflow_get
    .global arch_pmu_cycle_interrupt_overflow_clr

    .global arch_pmu_event_enable
    .global arch_pmu_event_disable
    .global arch_pmu_event_set
    .global arch_pmu_event_get
    .global arch_pmu_event_select
    .global arch_pmu_event_increment
    .global arch_pmu_event_interrupt_enable
    .global arch_pmu_event_interrupt_disable
    .global arch_pmu_event_interrupt_overflow_get
    .global arch_pmu_event_interrupt_overflow_clr

    .section .text.arch.pmu, "ax"
    .balign 4

/**
 * @brief Architecture Performance Monitors init
 */
arch_pmu_init:
    mrs x0, PMCR_EL0
    orr x0, x0, #(1 << 6)       // LC: Overflow on increment that changes PMCCNTR_EL0[63] from 1 to 0.
    orr x0, x0, #(1 << 5)       // DP: Cycle counter is disabled if non-invasive debug is not permitted and enabled.
    orr x0, x0, #(1 << 4)       //  X: Export of events is enabled.
    orr x0, x0, #(1 << 3)       //  D: When enabled, PMCCNTR_EL0 counts every 64 clock cycles.
    orr x0, x0, #(1 << 2)       //  C: Reset PMCCNTR_EL0 to 0.
    orr x0, x0, #(1 << 1)       //  P: Reset all event counters, not including PMCCNTR_EL0, to zero.
    orr x0, x0, #(1 << 0)       //  E: All counters are enabled.
    msr PMCR_EL0, x0

    mrs x0, PMCCFILTR_EL0
    bic x0, x0, #(1 << 31)      //  P: This field has no effect on filtering of cycles for EL1 filtering.
    bic x0, x0, #(1 << 30)      //  U: This field has no effect on filtering of cycles for EL0 filtering.
    bic x0, x0, #(1 << 29)      //NSK: This field has no effect on filtering of cycles for Non-secure EL1 filtering.
    bic x0, x0, #(1 << 28)      //NSU: This field has no effect on filtering of cycles for Non-secure EL0 filtering.
    orr x0, x0, #(1 << 27)      //NSH: This field has no effect on filtering of cycles for EL2 filtering.
    bic x0, x0, #(1 << 26)      //  M: This field has no effect on filtering of cycles for EL3 filtering.
    msr PMCCFILTR_EL0, x0

    mrs x0, PMCCFILTR_EL0
    orr x0, x0, #(1 << 3)       // ER: Enables EL0 reads of the event counters and EL0 reads and writes of the select register.
    orr x0, x0, #(1 << 2)       // CR: Enables EL0 reads of the cycle counter.
    orr x0, x0, #(1 << 1)       // SW: Enables EL0 writes to the Software increment register.
    orr x0, x0, #(1 << 0)       // EN: Enables EL0 read/write access to PMU registers.
    msr PMCCFILTR_EL0, x0
    ret

/**
 * @brief Architecture Performance Monitors Cycle counter enable
 */
arch_pmu_cycle_enable:
    mrs x4, PMCNTENSET_EL0
    orr x4, x4, #(1 << 31)      // C: Enables PMCCNTR_EL0.
    msr PMCNTENSET_EL0, x4
    ret

/**
 * @brief Architecture Performance Monitors Cycle counter disable
 */
arch_pmu_cycle_disable:
    mrs x4, PMCNTENCLR_EL0
    orr x4, x4, #(1 << 31)      // C: Disable PMCCNTR_EL0.
    msr PMCNTENCLR_EL0, x4
    ret

/**
 * @brief Architecture Performance Monitors Cycle counter set value
 * 
 * @param x0 - The Cycle counter value
 */
arch_pmu_cycle_set:
    msr PMCCNTR_EL0, x0         // Cycle count. default Every 64th processor clock cycle.
    ret

/**
 * @brief Architecture Performance Monitors Cycle counter get value
 * 
 * @return x0 - The Cycle counter value
 */
arch_pmu_cycle_get:
    mrs x0, PMCCNTR_EL0         // Cycle count. default Every 64th processor clock cycle.
    ret

/**
 * @brief Architecture Performance Monitors Cycle counter interrupt enable
 */
arch_pmu_cycle_interrupt_enable:
    mrs x4, PMINTENSET_EL1
    orr x4, x4, #(1 << 31)      // C: Enable Interrupt request on unsigned overflow of PMCCNTR_EL0.
    msr PMINTENSET_EL1, x4
    ret

/**
 * @brief Architecture Performance Monitors Cycle counter interrupt disable
 */
arch_pmu_cycle_interrupt_disable:
    mrs x4, PMINTENCLR_EL1
    orr x4, x4, #(1 << 31)      // C: Disable Interrupt request on unsigned overflow of PMCCNTR_EL0.
    msr PMINTENCLR_EL1, x4
    ret

/**
 * @brief Architecture Performance Monitors Cycle counter Unsigned overflow flag
 * 
 * @return x0 - Cycle counter Unsigned overflow flag
 */
arch_pmu_cycle_overflow_status_get:
    mrs x4, PMOVSCLR_EL0
    lsr x4, x4, #31
    and x0, x4, #(1 << 0)       // C: Unsigned overflow flag for PMCCNTR_EL0.
    ret

/**
 * @brief Architecture Performance Monitors Cycle counter Unsigned overflow flag clear
 */
arch_pmu_cycle_overflow_status_clr:
    mrs x4, PMOVSCLR_EL0
    orr x4, x4, #(1 << 31)      // C: Clear Unsigned overflow flag for PMCCNTR_EL0.
    msr PMOVSCLR_EL0, x4
    ret

/**
 * @brief Architecture Performance Monitors Event counter enable
 * 
 * @param x0 - The Event counter ID
 */
arch_pmu_event_enable:
    mov x2, #1
    lsl x2, x2, x0
    mrs x4, PMCNTENSET_EL0
    orr x4, x4, x2              // C: Enables PMEVCNTR<n>_EL0.
    msr PMCNTENSET_EL0, x4
    ret

/**
 * @brief Architecture Performance Monitors Event counter disable
 * 
 * @param x0 - The Event counter ID
 */
arch_pmu_event_disable:
    mov x2, #1
    lsl x2, x2, x0
    mrs x4, PMCNTENCLR_EL0
    orr x4, x4, x2              // C: Disable PMEVCNTR<n>_EL0.
    msr PMCNTENCLR_EL0, x4
    ret

/**
 * @brief Architecture Performance Monitors Event counter set value
 * 
 * @param x0 - The Event counter ID
 * @param x1 - The Event counter value
 */
arch_pmu_event_set:
    msr PMSELR_EL0, x0         // Event counter select.
    msr PMXEVCNTR_EL0, x1      // Value of the selected event counter, PMEVCNTR<n>_EL0, where n is the value stored in PMSELR_EL0.SEL.
    ret

/**
 * @brief Architecture Performance Monitors Event counter get value
 * 
 * @return x0 - The Event counter value
 */
arch_pmu_event_get:
    msr PMSELR_EL0, x0         // Event counter select.
    mrs x0, PMXEVCNTR_EL0      // Value of the selected event counter, PMEVCNTR<n>_EL0, where n is the value stored in PMSELR_EL0.SEL.
    ret

/**
 * @brief Architecture Performance Monitors Event counter select event
 * 
 * @param x0 - The Event counter ID
 * @param x1 - The Event ID
 */
arch_pmu_event_select:
    msr PMSELR_EL0, x0         // Event counter select.
    msr PMXEVTYPER_EL0, x1     // Performance Monitors Selected Event Type
    ret

/**
 * @brief Architecture Performance Monitors Event counter sofeware increment
 * 
 * @param x0 - The Event counter ID
 */
arch_pmu_event_increment:
    mov x2, #1
    lsl x2, x2, x0
    msr PMSWINC_EL0, x2        // Increment PMEVCNTR<n>_EL0, if PMEVCNTR<n>_EL0 is configured to count software increment events.
    ret

/**
 * @brief Architecture Performance Monitors Event counter interrupt enable
 * 
 * @param x0 - The Event counter ID
 */
arch_pmu_event_interrupt_enable:
    mov x2, #1
    lsl x2, x2, x0
    mrs x4, PMINTENSET_EL1
    orr x4, x4, x2             // C: Enable Interrupt request on unsigned overflow of PMEVCNTR<n>_EL0.
    msr PMINTENSET_EL1, x4
    ret

/**
 * @brief Architecture Performance Monitors Event counter interrupt disable
 * 
 * @param x0 - The Event counter ID
 */
arch_pmu_event_interrupt_disable:
    mov x2, #1
    lsl x2, x2, x0
    mrs x4, PMINTENCLR_EL1
    orr x4, x4, x2              // C: Disable Interrupt request on unsigned overflow of PMEVCNTR<n>_EL0.
    msr PMINTENCLR_EL1, x4
    ret

/**
 * @brief Architecture Performance Monitors Event counter Unsigned overflow flag
 * 
 * @param x0 - The Event counter ID
 * 
 * @return x0 - counter Unsigned overflow flag
 */
arch_pmu_event_overflow_status_get:
    mrs x4, PMOVSCLR_EL0
    lsr x4, x4, x0
    and x0, x4, #(1 << 0)       // C: Unsigned overflow flag for PMEVCNTR<n>_EL0.
    ret

/**
 * @brief Architecture Performance Monitors Event counter Unsigned overflow flag clear
 * 
 * @param x0 - The Event counter ID
 */
arch_pmu_event_overflow_status_clr:
    mov x2, #1
    lsl x2, x2, x0
    mrs x4, PMOVSCLR_EL0
    orr x4, x4, x2             // C: Clear Unsigned overflow flag for PMEVCNTR<n>_EL0.
    msr PMOVSCLR_EL0, x4
    ret
