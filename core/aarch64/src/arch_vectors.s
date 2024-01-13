    .global _el1_vectors
    .global _el2_vectors
    .global _el3_vectors
    
    .section .text.arch.vectors, "ax", %progbits

    /* Vector tables must be placed at a 2KB-aligned address */
    .align	11
_el1_vectors:
    /* Current EL with SP0 */
    .align 7
	b	.		                        // Synchronous
	.align 7
	b	_el1_sp0_irq		            // IRQ/vIRQ
	.align 7
	b	.		                        // FIQ/vFIQ
	.align 7
	b	.		                        // SError/vSError

    /* Current EL with SPx */
    .align 7
	b	.		                        // Synchronous
	.align 7
	b	_el1_spx_irq		            // IRQ/vIRQ
	.align 7
	b	.		                        // FIQ/vFIQ
	.align 7
	b	.		                        // SError/vSError

    /* Lower EL using AArch64 */
	.align 7
	b	.                               // Synchronous
	.align 7
	b	_el1_aarch64_irq                // IRQ/vIRQ
	.align 7
	b	.                               // FIQ/vFIQ
	.align 7
	b	.                               // SError/vSError

    /* Lower EL using AArch32 */
	.align 7
	b	.                               // Synchronous
	.align 7
	b	_el1_aarch32_irq                // IRQ/vIRQ
	.align 7
	b	.                               // FIQ/vFIQ
	.align 7
	b	.                               // SError/vSError

    /* Vector tables must be placed at a 2KB-aligned address */
    .align	11
_el2_vectors:
    /* Current EL with SP0 */
    .align 7
	b	.		                        // Synchronous
	.align 7
	b	.		                        // IRQ/vIRQ
	.align 7
	b	.		                        // FIQ/vFIQ
	.align 7
	b	.		                        // SError/vSError

    /* Current EL with SPx */
    .align 7
	b	.		                        // Synchronous
	.align 7
	b	.		                        // IRQ/vIRQ
	.align 7
	b	.		                        // FIQ/vFIQ
	.align 7
	b	.		                        // SError/vSError

    /* Lower EL using AArch64 */
	.align 7
	b	.                               // Synchronous
	.align 7
	b	.                               // IRQ/vIRQ
	.align 7
	b	.                               // FIQ/vFIQ
	.align 7
	b	.                               // SError/vSError

    /* Lower EL using AArch32 */
	.align 7
	b	.                               // Synchronous
	.align 7
	b	.                               // IRQ/vIRQ
	.align 7
	b	.                               // FIQ/vFIQ
	.align 7
	b	.                               // SError/vSError

    /* Vector tables must be placed at a 2KB-aligned address */
    .align	11
_el3_vectors:
    /* Current EL with SP0 */
    .align 7
	b	.		                        // Synchronous
	.align 7
	b	.		                        // IRQ/vIRQ
	.align 7
	b	_el3_sp0_fiq		            // FIQ/vFIQ
	.align 7
	b	.		                        // SError/vSError

    /* Current EL with SPx */
    .align 7
	b	.		                        // Synchronous
	.align 7
	b	.		                        // IRQ/vIRQ
	.align 7
	b	_el3_spx_fiq		            // FIQ/vFIQ
	.align 7
	b	.		                        // SError/vSError

    /* Lower EL using AArch64 */
	.align 7
	b	.                               // Synchronous
	.align 7
	b	.                               // IRQ/vIRQ
	.align 7
	b	_el3_aarch64_fiq                // FIQ/vFIQ
	.align 7
	b	.                               // SError/vSError

    /* Lower EL using AArch32 */
	.align 7
	b	.                               // Synchronous
	.align 7
	b	.                               // IRQ/vIRQ
	.align 7
	b	_el3_aarch32_fiq                // FIQ/vFIQ
	.align 7
	b	.                               // SError/vSError

_el1_sp0_irq:
_el1_spx_irq:
_el1_aarch64_irq:
_el1_aarch32_irq:
    b .

_el3_sp0_fiq:
_el3_spx_fiq:
_el3_aarch64_fiq:
_el3_aarch32_fiq:
    b .
