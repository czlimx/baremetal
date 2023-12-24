    .global vectors_table
    .section .text.vectors, "ax", %progbits

    /* Vector tables must be placed at a 2KB-aligned address */
    .align	11
vectors_table:

     /* Each entry is 128B in size */
    /* Current EL with SP0 */
    .align 7
	b	_curr_el_sp0_sync		    // Synchronous
	.align 7
	b	_curr_el_sp0_irq		    // IRQ/vIRQ
	.align 7
	b	_curr_el_sp0_fiq		    // FIQ/vFIQ
	.align 7
	b	_curr_el_sp0_serror		    // SError/vSError

    /* Current EL with SPx */
    .align 7
	b	_curr_el_spx_sync		    // Synchronous
	.align 7
	b	_curr_el_spx_irq		    // IRQ/vIRQ
	.align 7
	b	_curr_el_spx_fiq		    // FIQ/vFIQ
	.align 7
	b	_curr_el_spx_serror		    // SError/vSError

    /* Lower EL using AArch64 */
	.align 7
	b	_lower_el_aarch64_sync      // Synchronous
	.align 7
	b	_lower_el_aarch64_irq       // IRQ/vIRQ
	.align 7
	b	_lower_el_aarch64_fiq       // FIQ/vFIQ
	.align 7
	b	_lower_el_aarch64_serror    // SError/vSError

    /* Lower EL using AArch32 */
	.align 7
	b	_lower_el_aarch32_sync      // Synchronous
	.align 7
	b	_lower_el_aarch32_irq       // IRQ/vIRQ
	.align 7
	b	_lower_el_aarch32_fiq       // FIQ/vFIQ
	.align 7
	b	_lower_el_aarch32_serror    // SError/vSError

    .section .text.exception, "ax", %progbits
    .align 4
/*
* Save exception specific context: ESR and ELR, for all exception levels.
* This is the second part of the shared routine called into from all entries.
*/
save_el_regs:
	/* Could be running at EL3/EL2/EL1 */
    mrs x1, CurrentEL
    cmp x1, 0xC
    b.eq 3f
    cmp x1, 0x8
    b.eq 2f
    cmp x1, 0x4
    b.eq 1f

3:	mrs	x1, ESR_EL3
	mrs	x2, ELR_EL3
	mrs	x3, SPSR_EL3
	b	0f
2:	mrs	x1, ESR_EL2
	mrs	x2, ELR_EL2
	mrs	x3, SPSR_EL2
	b	0f
1:	mrs	x1, ESR_EL1
	mrs	x2, ELR_EL1
	mrs	x3, SPSR_EL1
0:
	stp	x1, x0, [sp, #-16]!
	stp	x3, x2, [sp, #-16]!
	ret

/*
 * Save (most of) the GP registers to the stack frame.
 * This is the first part of the shared routine called into from all entries.
 */
save_regs:
    stp	x29, x30, [sp, #-16]!
    stp	x27, x28, [sp, #-16]!
	stp	x25, x26, [sp, #-16]!
	stp	x23, x24, [sp, #-16]!
	stp	x21, x22, [sp, #-16]!
	stp	x19, x20, [sp, #-16]!
	stp	x17, x18, [sp, #-16]!
	stp	x15, x16, [sp, #-16]!
	stp	x13, x14, [sp, #-16]!
	stp	x11, x12, [sp, #-16]!
	stp	x9,  x10, [sp, #-16]!
	stp	x7,  x8,  [sp, #-16]!
	stp	x5,  x6,  [sp, #-16]!
	stp	x3,  x4,  [sp, #-16]!
	stp	x1,  x2,  [sp, #-16]!
    ret

/*
 * Restore the general purpose registers from the exception stack, then return.
 * This is the second part of the shared routine called into from all entries.
 */
restore_regs:
	ldp	x1,  x2,  [sp],#16
	ldp	x3,  x4,  [sp],#16
	ldp	x5,  x6,  [sp],#16
	ldp	x7,  x8,  [sp],#16
	ldp	x9,  x10, [sp],#16
	ldp	x11, x12, [sp],#16
	ldp	x13, x14, [sp],#16
	ldp	x15, x16, [sp],#16
	ldp	x17, x18, [sp],#16
	ldp	x19, x20, [sp],#16
	ldp	x21, x22, [sp],#16
	ldp	x23, x24, [sp],#16
	ldp	x25, x26, [sp],#16
	ldp	x27, x28, [sp],#16
	ldp	x29, x30, [sp],#16
    ret

/*
 * Restore the exception return address, for all exception levels.
 * This is the first part of the shared routine called into from all entries.
 */
restore_el_regs:
    ldp	xzr, x2, [sp],#16
    ldp	xzr, x0, [sp],#16
    /* Could be running at EL3/EL2/EL1 */
    mrs x1, CurrentEL
    cmp x1, 0xC
    b.eq 3f
    cmp x1, 0x8
    b.eq 2f
    cmp x1, 0x4
    b.eq 1f

3:	msr	ELR_EL3, x2
2:	msr	ELR_EL2, x2
1:	msr	ELR_EL1, x2
    ret

_curr_el_sp0_sync:
_curr_el_spx_sync:
_lower_el_aarch64_sync:
    bl save_regs
    bl save_el_regs
    mov	x0, sp
    bl do_sync
    bl restore_el_regs
    bl restore_regs
    eret

_curr_el_sp0_irq:
_curr_el_spx_irq:
_lower_el_aarch64_irq:
    bl save_regs
    bl save_el_regs
    mov	x0, sp
    bl do_irq
    bl restore_el_regs
    bl restore_regs
    eret

_curr_el_sp0_fiq:
_curr_el_spx_fiq:
_lower_el_aarch64_fiq:
    bl save_regs
    bl save_el_regs
    mov	x0, sp
    bl do_fiq
    bl restore_el_regs
    bl restore_regs
    eret

_curr_el_sp0_serror:
_curr_el_spx_serror:
_lower_el_aarch64_serror:
    bl save_regs
    bl save_el_regs
    mov	x0, sp
    bl do_serror
    bl restore_el_regs
    bl restore_regs
    eret

_lower_el_aarch32_sync:
_lower_el_aarch32_irq:
_lower_el_aarch32_fiq:
_lower_el_aarch32_serror:
	b .

do_sync:
do_irq:
do_fiq:
do_serror:
    b .
