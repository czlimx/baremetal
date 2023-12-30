    .global _start
    .globaL _normal_setup
    .extern _early_init
    .extern _spel0_stack_top
    .extern _spel1_stack_top
    .extern _spel2_stack_top
    .extern _spel3_stack_top
    .section .text.startup, "ax"

_start:
    // get current core ID
    mrs     x0, MPIDR_EL1
    and     x0, x0, #0xFF
    // compare and branch if non zero, The main core ID is equal to zero
    cbz     x0, _normal_setup

_halt:
    // Goto standby wait for warm reset
    wfi
    b       _halt

_normal_setup:
    /* Initialize all registers to default values */
    mov     x0,  XZR
	mov     x1,  XZR
	mov     x2,  XZR
	mov     x3,  XZR
	mov     x4,  XZR
	mov     x5,  XZR
	mov     x6,  XZR
	mov     x7,  XZR
	mov     x8,  XZR
	mov     x9,  XZR
	mov     x10, XZR
	mov     x11, XZR
	mov     x12, XZR
	mov     x13, XZR
	mov     x14, XZR
	mov     x15, XZR
	mov     x16, XZR
	mov     x17, XZR
	mov     x18, XZR
	mov     x19, XZR
	mov     x20, XZR
	mov     x21, XZR
	mov     x22, XZR
	mov     x23, XZR
	mov     x24, XZR
	mov     x25, XZR
	mov     x26, XZR
	mov     x27, XZR
	mov     x28, XZR
	mov     x29, XZR
	mov     x30, XZR

    /* Set vector table base address */
	ldr	    x1, = vectors_table
	msr	    VBAR_EL3, x1
    ldr     x1, = vectors_table
    msr     VBAR_EL2, x1
    ldr     x1, = vectors_table
    msr     VBAR_EL1, x1

    /* SError, FIQ routing enablement in EL3 */
    mrs     x0, SCR_EL3
    orr     x0, x0, #(1 << 3)               // The EA bit.
    bic     x0, x0, #(1 << 1)               // The IRQ bit.
    orr     x0, x0, #(1 << 2)               // The FIQ bit.
    msr     SCR_EL3, x0

    /* SError, IRQ and FIQ not routing enablement in EL2 */
    mrs     x0, HCR_EL2
    bic     x0, x0, #(1 << 5)               // The AMO bit.
    bic     x0, x0, #(1 << 4)               // The IMO bit.
    bic     x0, x0, #(1 << 3)               // The FMO bit.
    msr     HCR_EL2, x0

    /* Enable SError for Current EL */
    msr     DAIFClr, #0x4

    /* Enable Floating Point Unit and SIMD */
    msr     CPTR_EL3, XZR                   // Disable trapping of accessing in EL3.
    msr     CPTR_EL3, XZR                   // Disable trapping of accessing in EL2.
    // Disable access trapping in EL1 and EL0.
    mov     x1, #(0x3 << 20)                // FPEN disables trapping to EL1.
    msr     CPACR_EL1, x1
    isb

    /* Initialize floating-point registers after reset */
    fmov    d0,  XZR
    fmov    d1,  XZR
    fmov    d2,  XZR
    fmov    d3,  XZR
    fmov    d4,  XZR
    fmov    d5,  XZR
    fmov    d6,  XZR
    fmov    d7,  XZR
    fmov    d8,  XZR
    fmov    d9,  XZR
    fmov    d10, XZR
    fmov    d11, XZR
    fmov    d12, XZR
    fmov    d13, XZR
    fmov    d14, XZR
    fmov    d15, XZR
    fmov    d16, XZR
    fmov    d17, XZR
    fmov    d18, XZR
    fmov    d19, XZR
    fmov    d20, XZR
    fmov    d21, XZR
    fmov    d22, XZR
    fmov    d23, XZR
    fmov    d24, XZR
    fmov    d25, XZR
    fmov    d26, XZR
    fmov    d27, XZR
    fmov    d28, XZR
    fmov    d29, XZR
    fmov    d30, XZR
    fmov    d31, XZR

    /* Initialize the stack pointer. */
    msr     SPsel, #1
    ldr     x0, = _spel3_stack_top
    mov     sp, x0

    msr     SPsel, #0
    ldr     x0, = _spel0_stack_top
    mov     sp, x0

    ldr     x0, = _spel1_stack_top
    msr     SP_EL1, x0
    ldr     x0, = _spel2_stack_top
    msr     SP_EL2, x0

    /* System control registers initialization. */
    mrs     x0, SCTLR_EL1
    bic     x0, x0, #(1 << 0)   // M        [0]     EL1 and EL0 stage 1 MMU disabled.
    orr     x0, x0, #(1 << 1)   // A        [1]     Alignment fault checking enabled.
    bic     x0, x0, #(1 << 2)   // C        [2]     Data and unified caches disabled.
    orr     x0, x0, #(1 << 3)   // SA       [3]     Enable SP alignment check.
    orr     x0, x0, #(1 << 4)   // SA0      [4]     Enable EL0 stack alignment check.
    orr     x0, x0, #(1 << 5)   // CP15BEN  [5]     CP15 barrier operations enabled.
    orr     x0, x0, #(1 << 9)   // UMA      [9]     Enable access to the interrupt masks from EL0.
    bic     x0, x0, #(1 << 12)  // I        [12]    Instruction caches disabled.
    orr     x0, x0, #(1 << 14)  // DZE      [14]    Enables execution access to the DC ZVA instruction at EL0.
    orr     x0, x0, #(1 << 15)  // UCT      [15]    Enables EL0 access to the CTR_EL0 register.
    orr     x0, x0, #(1 << 16)  // nTWI     [16]    WFI instructions executed as normal.
    orr     x0, x0, #(1 << 18)  // nTWE     [18]    WFE instructions executed as normal.
    orr     x0, x0, #(1 << 19)  // WXN      [19]    Regions with write permissions are forced XN.
    bic     x0, x0, #(1 << 24)  // E0E      [24]    Explicit data accesses at EL0 are little-endian.
    bic     x0, x0, #(1 << 25)  // EE       [25]    Exception endianness(EL1): Little-endian.
    orr     x0, x0, #(1 << 26)  // UCI      [26]    Enables EL0 access to the DC CVAU, DC CIVAC, DC CVAC and IC IVAU instructions in the AArch64 Execution state.
    msr     SCTLR_EL1, x0

    mrs     x0, SCTLR_EL2
    bic     x0, x0, #(1 << 0)   // M        [0]     EL2 MMU disabled.
    orr     x0, x0, #(1 << 1)   // A        [1]     Alignment fault checking enabled.
    bic     x0, x0, #(1 << 2)   // C        [2]     Data and unified caches disabled.
    orr     x0, x0, #(1 << 3)   // SA       [3]     Enable SP alignment check.
    bic     x0, x0, #(1 << 12)  // I        [12]    Instruction caches disabled.
    orr     x0, x0, #(1 << 19)  // WXN      [19]    Regions with write permissions are forced XN.
    bic     x0, x0, #(1 << 25)  // EE       [25]    Exception endianness(EL2): Little-endian.
    msr     SCTLR_EL2, x0

    mrs     x0, SCTLR_EL3
    bic     x0, x0, #(1 << 0)   // M        [0]     EL3 MMU disabled.
    orr     x0, x0, #(1 << 1)   // A        [1]     Alignment fault checking enabled.
    bic     x0, x0, #(1 << 2)   // C        [2]     Data and unified caches disabled.
    orr     x0, x0, #(1 << 3)   // SA       [3]     Enable SP alignment check.
    bic     x0, x0, #(1 << 12)  // I        [12]    Instruction caches disabled.
    orr     x0, x0, #(1 << 19)  // WXN      [19]    Regions with write permissions are forced XN.
    bic     x0, x0, #(1 << 25)  // EE       [25]    Exception endianness(EL3): Little-endian.
    msr     SCTLR_EL3, x0

    /* Clean and invalidate all data from the L1 Data cache. */


    /* Enable data coherency with other cores in the cluster(Cortex-A53 Manual). */
    mrs     x0, S3_1_C15_C2_1
    orr     x0, x0, #(1 << 6)   // SMPEN    [6]     Enables data coherency with other cores in the cluster.
    msr     S3_1_C15_C2_1, x0

    /* Enable data cache clean as data cache clean/invalidate. */
    mrs	    x0, S3_1_C15_C2_0
	orr	    x0, x0, #(1 << 44)  // ENDCCASCI [44]   Executes data cache clean operations as data cache clean and invalidate.
	msr	    S3_1_C15_C2_0, x0

    // Execute an ISB instruction to ensure that all of the register changes from the previous steps
    // have been committed.
    isb

    // Execute a DSB SY instruction to ensure that all cache, TLB and branch predictor
    // maintenance operations issued by any core in the cluster device before the SMPEN bit
    // was cleared have completed.
    dsb sy

    bl      _early_init

    // Invalidate Data cache to make the code general purpose.
    // Calculate the cache size first and loop through each set +
    // way.
_invalidate_all_dcache:
    mov     x0, #0x0                // x0 = Cache level
    msr     CSSELR_EL1, x0          // 0x0 for L1 Dcache 0x2 for L2 Dcache.
    mrs     x4, CCSIDR_EL1          // Read Cache Size ID.
    and     x1, x4, #0x7
    add     x1, x1, #0x4            // x1 = Cache Line Size.
    ldr     x3, =0x7FFF
    and     x2, x3, x4, lsr #13     // x2 = Cache Set Number – 1.
    ldr     x3, =0x3FF
    and     x3, x3, x4, lsr #3      // x3 = Cache Associativity Number – 1.
    clz     w4, w3                  // x4 = way position in the CISW instruction.
    mov     x5, #0                  // x5 = way counter way_loop.

way_loop:
    mov     x6, #0                  // x6 = set counter set_loop.

set_loop:
    lsl     x7, x5, x4

    orr     x7, x0, x7              // Set way.
    lsl     x8, x6, x1
    orr     x7, x7, x8              // Set set.
    dc      cisw, x7                // Clean and Invalidate cache line.
    add     x6, x6, #1              // Increment set counter.
    cmp     x6, x2                  // Last set reached yet?
    ble     set_loop                // If not, iterate set_loop,
    add     x5, x5, #1              // else, next way.
    cmp     x5, x3                  // Last way reached yet?
    ble     way_loop                // If not, iterate way_loop.
    ret
