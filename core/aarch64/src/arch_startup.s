    .global _start
    .extern _early_init
    .extern _el1_vectors
    .extern _el2_vectors
    .extern _el3_vectors
    .extern _core0_el3_stack_top

    .section .text.arch.startup, "ax"
    .balign 4

_start:
    /* Setup the vector base address */
    ldr x0, = _el1_vectors
    msr VBAR_EL1, x0

    ldr x0, = _el2_vectors
    msr VBAR_EL2, x0

    ldr x0, = _el3_vectors
    msr VBAR_EL3, x0

    /* Setup the Stack for EL3, stack size 4K */
    mrs x0, MPIDR_EL1
    and x0, x0, #0xFF
    ldr x1, = _core0_el3_stack_top
    add x1, x1, x0, lsl #12
    mov sp, x1

    /* Architecture early init */
    bl _trap_early_init
    bl _permissions_early_init
    bl _cache_early_init
    bl _exception_early_init
    bl _mmu_early_init
    bl _floating_early_init

    /* Synchronous completion of the above instructions */
    isb

    /* Clear the VTTBR_EL2 */
    msr VTTBR_EL2, xzr

    /* Update the Virtualization Multiprocessor ID */
    mrs x0, MPIDR_EL1
    msr VMPIDR_EL2, x0

    mrs x0, MIDR_EL1
    msr VPIDR_EL2, x0

    /* Goto early init for high level language */
    bl _early_init

/**
 * @brief Architecture early Trap initialization
 */
_trap_early_init:
    mrs x0, SCR_EL3
    bic x0, x0, #(1 << 13)      // TWE: WFE instructions are not trapped.
    bic x0, x0, #(1 << 12)      // TWI: WFI instructions are not trapped.
    msr SCR_EL3, x0

    mrs x0, HCR_EL2
    bic x0, x0, #(1 << 30)      // TRVM: Non-secure EL1 reads of Virtual Memory controls are not trapped.
    bic x0, x0, #(1 << 28)      // TDZ: Non-secure EL1 or EL0 executed DC ZVA instruction is not trapped.
    bic x0, x0, #(1 << 27)      // TGE: Not Traps general exceptions.
    bic x0, x0, #(1 << 26)      // TVM: Non-secure EL1 writes of Virtual memory controls are not trapped.
    bic x0, x0, #(1 << 25)      // TTLB: Non-secure EL1 TLB maintenance instructions are not trapped.
    bic x0, x0, #(1 << 24)      // TPU: Cache maintenance instructions to Point of Unification (POU) are not trapped.
    bic x0, x0, #(1 << 23)      // TPC: Data or unified cache maintenance instructions to Point of Coherency (POC) are not trapped.
    bic x0, x0, #(1 << 22)      // TSW: Data or unified cache maintenance instructions by Set or Way are not trapped.
    bic x0, x0, #(1 << 21)      // TACR: Accesses to Auxiliary Control registers are not trapped.
    bic x0, x0, #(1 << 20)      // TIDCP: Not Trap Implementation Dependent functionality.
    bic x0, x0, #(1 << 19)      // TSC: SMC instruction in not trapped.
    bic x0, x0, #(1 << 18)      // TID3: ID group 3 register accesses are not trapped.
    bic x0, x0, #(1 << 17)      // TID2: ID group 2 register accesses are not trapped.
    bic x0, x0, #(1 << 16)      // TID1: ID group 1 register accesses are not trapped.
    bic x0, x0, #(1 << 15)      // TID0: ID group 0 register accesses are not trapped.
    bic x0, x0, #(1 << 14)      // TWE: WFE instruction is not trapped.
    bic x0, x0, #(1 << 13)      // TWI: WFI instruction is not trapped.
    msr HCR_EL2, x0

    mrs x0, CPTR_EL3
    bic x0, x0, #(1 << 31)      // TCPAC: Does not cause access to the CPACR_EL1 or CPTR_EL2 to be trapped.
    bic x0, x0, #(1 << 10)      // TFP: Does not cause any access the registers associated with Advanced SIMD or floating-poin instruction to be trapped.
    msr CPTR_EL3, x0

    mrs x0, CPTR_EL2
    bic x0, x0, #(1 << 31)      // TCPAC: Access to CPACR is not trapped.
    bic x0, x0, #(1 << 10)      // TFP: Does not cause any access the registers associated with Advanced SIMD or floating-poin instruction to be trapped.
    msr CPTR_EL2, x0

    ret

/**
 * @brief Architecture early permissions initialization
 */
_permissions_early_init:
    mrs x0, SCR_EL3    
    orr x0, x0, #(1 << 11)      // ST: Enable Secure EL1 access to CNTPS_TVAL_EL1, CNTS_CTL_EL1, and CNTPS_CVAL_EL1 registers
                                //     Registers accessible in EL3 and EL1 when SCR_EL3.NS is 0.
    orr x0, x0, #(1 << 8)       // HCE: The HVC instruction is enabled at EL1, EL2 or EL3.
    bic x0, x0, #(1 << 7)       // SMD: The SMC instruction is enabled at EL1, EL2, and EL3.
    msr SCR_EL3, x0

    mrs x0, SCTLR_EL1    
    orr x0, x0, #(1 << 26)      // UCI: Enables EL0 access to the DC CVAU, DC CIVAC, DC CVAC and IC IVAU instructions in the AArch64 Execution state.
    orr x0, x0, #(1 << 18)      // nTWE: WFE instructions executed as normal.
    orr x0, x0, #(1 << 16)      // nTWI: WFI instructions executed as normal.
    orr x0, x0, #(1 << 15)      // UCT: Enables EL0 access to the CTR_EL0 register.
    orr x0, x0, #(1 << 14)      // DZE: Enables execution access to the DC ZVA instruction at EL0.
    bic x0, x0, #(1 << 9)       // UMA: Disable access to the interrupt masks from EL0.
    orr x0, x0, #(1 << 8)       // SED: The SETEND instruction is enabled.
    orr x0, x0, #(1 << 7)       // ITD: The IT instruction functionality is enabled.
    orr x0, x0, #(1 << 5)       // CP15BEN: CP15 barrier operations enabled.
    msr SCTLR_EL1, x0

    ret
    
/**
 * @brief Architecture early cache initialization
 */
_cache_early_init:
    mrs x0, SCR_EL3
    bic x0, x0, #(1 << 9)       // SIF: Secure state instruction fetches from Non-secure memory are permitted.
    msr SCR_EL3, x0

    mrs x0, HCR_EL2
    bic x0, x0, #(1 << 33)      // ID: Enable stage 2 instruction cache.
    bic x0, x0, #(1 << 32)      // CD: Enable stage 2 data cache.
    bic x0, x0, #(1 << 12)      // DC: Disable Default cacheable.
    bic x0, x0, #(3 << 10)      // BSU: Barrier shareability upgrade No effect.
    bic x0, x0, #(1 << 9)       // FB: Instructions are not broadcast.
    bic x0, x0, #(1 << 1)       // SWIO: Disable Set/Way Invalidation Override.
    msr HCR_EL2, x0

    mrs x0, SCTLR_EL3
    bic x0, x0, #(1 << 12)      // I: Global instruction cache disable.
    bic x0, x0, #(1 << 2)       // C: Global data and unifies caches disable.
    msr SCTLR_EL3, x0

    mrs x0, SCTLR_EL2
    bic x0, x0, #(1 << 12)      // I: Instruction caches disabled.
    bic x0, x0, #(1 << 2)       // C: Disables data and unified caches.
    msr SCTLR_EL2, x0

    mrs x0, SCTLR_EL1
    bic x0, x0, #(1 << 12)      // I: Instruction caches disabled.
    bic x0, x0, #(1 << 2)       // C: Disables data and unified caches.
    msr SCTLR_EL1, x0

    mrs x0, S3_1_C15_C2_1
    bic x0, x0, #(1 << 12)      // SMPEN: Enables data coherency with other cores in the cluster.
    msr S3_1_C15_C2_1, x0

    ret

/**
 * @brief Architecture early exception initialization
 */
_exception_early_init:    
    mrs x0, SCR_EL3
    orr x0, x0, #(1 << 10)      // RW: The next lower level is AArch64.
    orr x0, x0, #(1 << 3)       // EA: External Aborts and SError Interrupts while executing at all exception levels are taken in EL3.
    orr x0, x0, #(1 << 2)       // FIQ: Physical FIQ while executing at all exception levels are taken in EL3.
    bic x0, x0, #(1 << 1)       // IRQ: Physical IRQ while executing at exception levels other than EL3 are not taken in EL3.
    msr SCR_EL3, x0

    mrs x0, HCR_EL2
    orr x0, x0, #(1 << 31)      // RW: EL1 is AArch64.
    bic x0, x0, #(1 << 8)       // VSE: Virtual System Error/Asynchronous Abort is not pending by this mechanism.
    bic x0, x0, #(1 << 7)       // VI: Virtual IRQ is not pending by this mechanism.
    bic x0, x0, #(1 << 6)       // VF: Virtual FIQ is not pending by this mechanism.
    orr x0, x0, #(1 << 5)       // AMO: Asynchronous external Aborts and SError Interrupts while executing at EL2.
    bic x0, x0, #(1 << 4)       // IMO: hysical IRQ while executing at exception levels lower than EL2 are not taken at EL2.
    orr x0, x0, #(1 << 3)       // FMO: Physical FIQ while executing at EL2 or lower are taken in EL2.
    msr HCR_EL2, x0

    mrs x0, SCTLR_EL3
    bic x0, x0, #(1 << 25)      // EE: Little endian.
    orr x0, x0, #(1 << 3)       // EE: Enables stack alignment check.
    orr x0, x0, #(1 << 1)       // A: Enables alignment fault checking.
    msr SCTLR_EL3, x0

    mrs x0, SCTLR_EL2
    bic x0, x0, #(1 << 25)      // EE: Little endian.
    orr x0, x0, #(1 << 3)       // SA: Enables stack alignment check.
    orr x0, x0, #(1 << 1)       //  A: Enables alignment fault checking.
    msr SCTLR_EL2, x0

    mrs x0, SCTLR_EL1    
    bic x0, x0, #(1 << 25)      // EE:  Little endian.
    bic x0, x0, #(1 << 24)      // E0E: Explicit data accesses at EL0 are little-endian.
    orr x0, x0, #(1 << 4)       // SA0: Enable EL0 stack alignment check.
    orr x0, x0, #(1 << 3)       // SA:  Enable SP alignment check.
    orr x0, x0, #(1 << 1)       //  A:  Enables alignment fault checking.
    msr SCTLR_EL1, x0

    ret

/**
 * @brief Architecture early mmu initialization
 */
_mmu_early_init:
    mrs x0, HCR_EL2
    bic x0, x0, #(1 << 2)       // PTW: Disable Protected Table Walk.
    bic x0, x0, #(1 << 1)       // VM: Disables second stage translation.
    msr HCR_EL2, x0

    mrs x0, SCTLR_EL3
    orr x0, x0, #(1 << 19)      // WXN: Regions with write permissions are forced XN.
    bic x0, x0, #(1 << 0)       // M: Global disable for the EL3 MMU
    msr SCTLR_EL3, x0

    mrs x0, SCTLR_EL2
    orr x0, x0, #(1 << 19)      // WXN: Regions with write permissions are forced XN.
    bic x0, x0, #(1 << 0)       // M: Global disable for the EL2 MMU
    msr SCTLR_EL2, x0

    mrs x0, SCTLR_EL1
    orr x0, x0, #(1 << 19)      // WXN: Regions with write permissions are forced XN.
    bic x0, x0, #(1 << 0)       // M: EL1 and EL0 stage 1 MMU disabled.
    msr SCTLR_EL1, x0

    ret

/**
 * @brief Architecture early mmu initialization
 */
_floating_early_init:
    mrs x0, CPACR_EL1
    bic x0, x0, #(3 << 20)      // FPEN: Traps instructions that access registers associated with Advanced SIMD and Floating-point execution
    orr x0, x0, #(3 << 10)      // 0b11: No instructions are trapped.
    msr CPACR_EL1, x0

    ret
