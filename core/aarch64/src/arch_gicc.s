    .global arch_gicc_init

    .section .text.arch.gicc, "ax"
    .balign 4

arch_gicc_init:
    mrs x0, SCR_EL3
    bic x0, x0, #(1 << 0)       // NS: Secure.
    msr SCR_EL3, x0

    
    bic x0, x0, #(1 << 10)      // EOImodeNS:GICC_EOIR and GICC_AEOIR provide both priority drop and interrupt deactivation functionality.
    bic x0, x0, #(1 << 9)       // EOImodeS: GICC_EOIR and GICC_AEOIR provide both priority drop and interrupt deactivation functionality.
    orr x0, x0, #(1 << 8)       //IRQBypDisGrp1: The bypass IRQ signal is not signaled to the PE Group 1.
    orr x0, x0, #(1 << 7)       //FIQBypDisGrp1: The bypass FIQ signal is not signaled to the PE Group 1.
    orr x0, x0, #(1 << 6)       //IRQBypDisGrp0: The bypass IRQ signal is not signaled to the PE Group 0.
    orr x0, x0, #(1 << 5)       //FIQBypDisGrp0: The bypass FIQ signal is not signaled to the PE Group 0.
    orr x0, x0, #(1 << 4)       // CBPR: GICC_BPR determines preemption for both Group 0 and Group 1 interrupts.
    orr x0, x0, #(1 << 3)       //FIQEn: Group 0 interrupts are signaled using the FIQ signal.
    orr x0, x0, #(1 << 1)       // EnableGrp1: Group 1 interrupt signaling is enabled.
    orr x0, x0, #(1 << 0)       // EnableGrp0: Group 0 interrupt signaling is enabled.
    msr GICC_CTLR, x0

    msr, GICC_BPR, #0

    ret

/**
 * x0 - Priority
 */
arch_gicc_priority_mask:
    msr GICC_PMR, x0
    ret

/**
 * x0 - INTID
 */
arch_gicc_acknowledge:
    
    ret

arch_gicc_handler:
    /* push data to stack */
    stp x29, x30, [sp, #0x10]
    stp x29, x30, [sp, #0x10]
    stp x29, x30, [sp, #0x10]
    stp x29, x30, [sp, #0x10]
    stp x29, x30, [sp, #0x10]
    stp x29, x30, [sp, #0x10]
    stp x29, x30, [sp, #0x10]
    stp x29, x30, [sp, #0x10]
    stp x29, x30, [sp, #0x10]
    stp x29, x30, [sp, #0x10]
    stp x29, x30, [sp, #0x10]
    stp x29, x30, [sp, #0x10]
    stp x29, x30, [sp, #0x10]
    stp x29, x30, [sp, #0x10]
    stp x29, x30, [sp, #0x10]

    /* get the current interrupt ID */
    mrs x0, GICC_IAR

    /* update the Priority mask */
    mrs x1, 


    ldp x29, x30, [sp, #0x10]
    ldp x29, x30, [sp, #0x10]
    ldp x29, x30, [sp, #0x10]
    ldp x29, x30, [sp, #0x10]
    ldp x29, x30, [sp, #0x10]
    ldp x29, x30, [sp, #0x10]
    ldp x29, x30, [sp, #0x10]
    ldp x29, x30, [sp, #0x10]
    ldp x29, x30, [sp, #0x10]
    ldp x29, x30, [sp, #0x10]
    ldp x29, x30, [sp, #0x10]
    ldp x29, x30, [sp, #0x10]
    ldp x29, x30, [sp, #0x10]
    ldp x29, x30, [sp, #0x10]
    ldp x29, x30, [sp, #0x10]
    ldp x29, x30, [sp, #0x10]
    ldp x29, x30, [sp, #0x10]
    ldp x29, x30, [sp, #0x10]
    eret
