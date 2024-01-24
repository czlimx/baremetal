    
    #include "arch_gicd.h"

    .global arch_gicd_init
    .global arch_gicd_set_message_spi_pending
    .global arch_gicd_clr_message_spi_pending

    .global arch_gicd_config_group
    .global arch_gicd_set_enable
    .global arch_gicd_set_disable
    .global arch_gicd_set_pending
    .global arch_gicd_clr_pending
    .global arch_gicd_set_active
    .global arch_gicd_clr_active
    .global arch_gicd_config_priority
    .global arch_gicd_config_trigger
    .global arch_gicd_config_access
    .global arch_gicd_set_sgi_pending
    .global arch_gicd_clr_sgi_pending
    .global arch_gicd_config_route

    .section .text.arch.gic, "ax"
    .balign 4

/**
 * @brief Architecture GIC Distributor init
 * 
 * x0 - base The GIC Distributor base address
 */
arch_gicd_init:
    add x1, x0, #ARCH_GICD_CTLR
    ldr w2, [x1]
    orr w2, w2, #(1 << 7)       // E1NWF: Enable 1 of N Wakeup Functionality.
    bic w2, w2, #(1 << 6)       // DS: Non-secure accesses are not permitted to access and modify registers that control Group 0 interrupts.
    orr w2, w2, #(1 << 5)       // ARE_NS: Affinity routing enabled for Non-secure state.
    orr w2, w2, #(1 << 4)       // ARE_S: Affinity routing enabled for Secure state.
    orr w2, w2, #(1 << 2)       // EnableGrp1S: Enable Secure Group 1 interrupts.
    orr w2, w2, #(1 << 1)       // EnableGrp1NS: Enable Non-secure Group 1 interrupts.
    orr w2, w2, #(1 << 0)       // EnableGrp0: Enable Group 0 interrupts.
    str w2, [x1]

1:
    ldr w2, [x1]
    tst w2, #0x80000000
    b.ne 1b
    ret
    
/**
 * @brief Architecture GIC Distributor Generate Message-based SPIs
 * 
 * x0 - base   The GIC Distributor base address
 * x1 - intID  The Interrupt Identification
 * x2 - secure The Target Secure Type
 */
arch_gicd_set_message_spi_pending:
    cmp  x2, #1
    b.ne 1f
    mov  x3, ARCH_GICD_SETSPI_NSR
    b    2f
1:
    mov  x3, ARCH_GICD_SETSPI_SR
2:
    add  x3, x3, x0
    str  w1, [x3]
    ret

/**
 * @brief Architecture GIC Distributor Clear Message-based SPIs
 * 
 * x0 - base   The GIC Distributor base address
 * x1 - intID  The Interrupt Identification
 * x2 - secure The Target Secure Type
 */
arch_gicd_clr_message_spi_pending:
    cmp  x2, #1
    b.ne 1f
    mov  x3, ARCH_GICD_CLRSPI_NSR
    b    2f
1:
    mov x3, ARCH_GICD_CLRSPI_SR
2:
    add x3, x3, x0
    str w1, [x3]
    ret

/**
 * @brief Architecture GIC Distributor configure the interrupt group for SPIs
 * 
 * x0 - base  The GIC Distributor base address
 * x1 - intID The Interrupt Identification
 * x2 - group The Target Secure Group Type
 */
arch_gicd_config_group:
    mov  x3, #32
    udiv x4, x1, x3             // x4 = group
    msub x5, x4, x3, x1         // x5 = bit
    mov  x3, #1
    lsl  x3, x3, x5             // x3 = (1 << bit)

    mov  x5, #4
    mul  x5, x5, x4             // x5 = 4 * group
    add  x5, x5, x0
    add  x6, x5, #ARCH_GICD_IGROUPR
    add  x5, x5, #ARCH_GICD_IGRPMODR
    ldr  w4, [x6]
    ldr  w7, [x5]

    cmp  x2, #1
    b.gt 1f
    b.eq 2f
    b.lt 3f
1:
    bic  w4, w4, w3
    orr  w7, w7, w3
    b 4f
2:
    orr  w4, w4, w3
    bic  w7, w7, w3
    b 4f
3:
    bic  w4, w4, w3
    bic  w7, w7, w3
    b 4f
4:
    str  w4, [x6]
    str  w7, [x5]
    ret

/**
 * @brief Architecture GIC Distributor enable for SPIs
 * 
 * x0 - base  The GIC Distributor base address
 * x1 - intID The Interrupt Identification
 */
arch_gicd_set_enable:
    mov  x3, #32
    udiv x4, x1, x3             // x4 = group
    msub x5, x4, x3, x1         // x5 = bit
    mov  x3, #1
    lsl  x3, x3, x5             // x3 = (1 << bit)

    mov  x5, #4
    mul  x5, x5, x4             // x5 = 4 * group
    add  x5, x5, x0
    add  x5, x5, #ARCH_GICD_ISENABLER
    str  w3, [x5]

1:
    add x5, x0, #ARCH_GICD_CTLR
    ldr w3, [x5]
    tst w3, #0x80000000
    b.ne 1b
    ret

/**
 * @brief Architecture GIC Distributor disable for SPIs
 * 
 * x0 - base  The GIC Distributor base address
 * x1 - intID The Interrupt Identification
 */
arch_gicd_set_disable:
    mov  x3, #32
    udiv x4, x1, x3             // x4 = group
    msub x5, x4, x3, x1         // x5 = bit
    mov  x3, #1
    lsl  x3, x3, x5             // x3 = (1 << bit)

    mov  x5, #4
    mul  x5, x5, x4             // x5 = 4 * group
    add  x5, x5, x0
    add  x5, x5, #ARCH_GICD_ICENABLER
    str  w3, [x5]

1:
    add x5, x0, #ARCH_GICD_CTLR
    ldr w3, [x5]
    tst w3, #0x80000000
    b.ne 1b
    ret

/**
 * @brief Architecture GIC Distributor Adds the pending state for SPIs
 * 
 * x0 - base  The GIC Distributor base address
 * x1 - intID The Interrupt Identification
 */
arch_gicd_set_pending:
    mov  x3, #32
    udiv x4, x1, x3             // x4 = group
    msub x5, x4, x3, x1         // x5 = bit
    mov  x3, #1
    lsl  x3, x3, x5             // x3 = (1 << bit)

    mov  x5, #4
    mul  x5, x5, x4             // x5 = 4 * group
    add  x5, x5, x0
    add  x5, x5, #ARCH_GICD_ISPENDR
    str  w3, [x5]
    ret

/**
 * @brief Architecture GIC Distributor Removes the pending state for SPIs
 * 
 * x0 - base  The GIC Distributor base address
 * x1 - intID The Interrupt Identification
 */
arch_gicd_clr_pending:
    mov  x3, #32
    udiv x4, x1, x3             // x4 = group
    msub x5, x4, x3, x1         // x5 = bit
    mov  x3, #1
    lsl  x3, x3, x5             // x3 = (1 << bit)

    mov  x5, #4
    mul  x5, x5, x4             // x5 = 4 * group
    add  x5, x5, x0
    add  x5, x5, #ARCH_GICD_ICPENDR
    str  w3, [x5]
    ret

/**
 * @brief Architecture GIC Distributor Adds the Activates state for SPIs
 * 
 * x0 - base  The GIC Distributor base address
 * x1 - intID The Interrupt Identification
 */
arch_gicd_set_active:
    mov  x3, #32
    udiv x4, x1, x3             // x4 = group
    msub x5, x4, x3, x1         // x5 = bit
    mov  x3, #1
    lsl  x3, x3, x5             // x3 = (1 << bit)

    mov  x5, #4
    mul  x5, x5, x4             // x5 = 4 * group
    add  x5, x5, x0
    add  x5, x5, #ARCH_GICD_ISACTIVER
    str  w3, [x5]
    ret

/**
 * @brief Architecture GIC Distributor Adds the Deactivates state for SPIs
 * 
 * x0 - base  The GIC Distributor base address
 * x1 - intID The Interrupt Identification
 */
arch_gicd_clr_active:
    mov  x3, #32
    udiv x4, x1, x3             // x4 = group
    msub x5, x4, x3, x1         // x5 = bit
    mov  x3, #1
    lsl  x3, x3, x5             // x3 = (1 << bit)

    mov  x5, #4
    mul  x5, x5, x4             // x5 = 4 * group
    add  x5, x5, x0
    add  x5, x5, #ARCH_GICD_ICACTIVER
    str  w3, [x5]
    ret

/**
 * @brief Architecture GIC Distributor Set the priority for All
 * 
 * x0 - base  The GIC Distributor base address
 * x1 - intID The Interrupt Identification
 * x2 - priority The priority value
 */
arch_gicd_config_priority:
    mov  x3, #0xFF
    and  x2, x2, #0xFF

    mov  x5, #1
    mul  x5, x5, x1             // x5 = 1 * intID
    add  x5, x5, x0
    add  x5, x5, #ARCH_GICD_IPRIORITYR
    ldrb w4, [x5]
    bic  x4, x4, x3
    orr  x4, x4, x2
    strb w4, [x5]
    ret

/**
 * @brief Architecture GIC Distributor Set interrupt is edge-triggered or 
 *        level-sensitive for All
 * 
 * x0 - base   The GIC Distributor base address
 * x1 - intID  The Interrupt Identification
 * x2 - config The Interrupt mode
 */
arch_gicd_config_trigger:
    mov  x3, #16
    udiv x4, x1, x3             // x4 = group
    msub x5, x4, x3, x1         // x5 = bit/2
    mov  x3, #2
    mul  x5, x5, x3
    mov  x3, #0x3
    lsl  x3, x3, x5             // x3 = (0x3 << bit)
    and  x2, x2, #0xFF
    lsl  x2, x2, x5             // x2 = (priority << bit)

    mov  x5, #4
    mul  x5, x5, x4             // x5 = 4 * group
    add  x5, x5, x0
    add  x5, x5, #ARCH_GICD_ICFGR
    ldr  w4, [x5]
    bic  x4, x4, x3
    orr  x4, x4, x2
    str  w4, [x5]
    ret

/**
 * @brief Architecture GIC Distributor Set interrupt Non-Secure access Permissions
 * 
 * x0 - base   The GIC Distributor base address
 * x1 - intID  The Interrupt Identification
 * x2 - access The Interrupt Non-Secure access Permissions
 */
arch_gicd_config_access:
    mov  x3, #16
    udiv x4, x1, x3             // x4 = group
    msub x5, x4, x3, x1         // x5 = bit
    mov  x3, #2
    mul  x5, x5, x3
    mov  x3, #0x3
    lsl  x3, x3, x5             // x3 = (0x3 << bit)
    and  x2, x2, #0xFF
    lsl  x2, x2, x5             // x2 = (access << bit)

    mov  x5, #4
    mul  x5, x5, x4             // x5 = 4 * group
    add  x5, x5, x0
    add  x5, x5, #ARCH_GICD_NSACR
    ldr  w4, [x5]
    bic  x4, x4, x3
    orr  x4, x4, x2
    str  w4, [x5]
    ret

/**
 * @brief Architecture GIC Distributor Adds the pending state to an SGI
 * 
 * x0 - base   The GIC Distributor base address
 * x1 - intID  The Interrupt Identification
 */
arch_gicd_set_sgi_pending:
    mov  x3, #4
    udiv x4, x1, x3             // x4 = group
    msub x5, x4, x3, x1         // x5 = bit
    mov  x3, #8
    mul  x5, x5, x3
    mov  x3, #0x1
    lsl  x3, x3, x5             // x3 = (0x1 << bit)

    mov  x5, #4
    mul  x5, x5, x4             // x5 = 4 * group
    add  x5, x5, x0
    add  x5, x5, #ARCH_GICD_SPENDSGIR
    str  w3, [x5]
    ret

/**
 * @brief Architecture GIC Distributor Removes the pending state to an SGI
 * 
 * x0 - base   The GIC Distributor base address
 * x1 - intID  The Interrupt Identification
 */
arch_gicd_clr_sgi_pending:
    mov  x3, #4
    udiv x4, x1, x3             // x4 = group
    msub x5, x4, x3, x1         // x5 = bit
    mov  x3, #8
    mul  x5, x5, x3
    mov  x3, #0x1
    lsl  x3, x3, x5             // x3 = (0x1 << bit)

    mov  x5, #4
    mul  x5, x5, x4             // x5 = 4 * group
    add  x5, x5, x0
    add  x5, x5, #ARCH_GICD_CPENDSGIR
    str  w3, [x5]
    ret

/**
 * @brief Architecture GIC Distributor Set the route for SPI
 * 
 * x0 - base      The GIC Distributor base address
 * x1 - intID     The Interrupt Identification
 * x2 - irm       The Interrupt Routing Mode
 * x3 - affinity  The Affinity value
 */
arch_gicd_config_route:
    ldr x4, = 0xFF00FFFFFF
    and x3, x3, x4
    lsl x2, x2, #31
    orr x3, x3, x2

    sub  w1, w1, #32
    lsl  w5, w1, #3             // x5 = 8 * intID
    ldr  x6, = ARCH_GICD_IROUTER
    add  x5, x5, x6
    add  x5, x5, x0
    str  x3, [x5]
    ret
