    .global arch_icache_enable
    .global arch_icahce_disable
    .global arch_icahce_invalidate_all
    .global arch_icahce_invalidate_range

    .global arch_dcache_enable
    .global arch_dcahce_disable
    .global arch_dcahce_invalidate_all
    .global arch_dcahce_clean_all
    .global arch_dcahce_flush_all
    .global arch_dcahce_invalidate_range
    .global arch_dcahce_clean_range
    .global arch_dcahce_flush_range

    .section .text.cache, "ax"
    .balign 4

/**
 * @brief Architecture instruction cache enabled
 * 
 * @note  Only EL0 and EL1 cache are enabled, EL2 and EL3 cache are disable by default.
 */
arch_icache_enable:
    bl arch_icahce_invalidate_all

    mrs x0, SCTLR_EL1
    orr x0, x0, #(1 << 12)       // I: Instruction caches enabled.
    msr SCTLR_EL1, x0

    ret

/**
 * @brief Architecture instruction cache disabled
 * 
 * @note  Only EL0 and EL1 cache are disabled, EL2 and EL3 cache are disable by default.
 */
arch_icahce_disable:
    mrs x0, SCTLR_EL1
    bic x0, x0, #(1 << 12)       // I: Instruction caches disable.
    msr SCTLR_EL1, x0

    ret

/**
 * @brief Architecture instruction cache invalidate all to PoU Inner Shareable
 */
arch_icahce_invalidate_all:
    isb sy
    IC IALLUIS
    isb sy

    ret

/**
 * @brief Architecture instruction cache invalidate by virtual address (VA) to PoU
 * 
 * @param x0 - The virtual start address of region
 * @param x1 - The size of region
 */
arch_icahce_invalidate_range:
    mrs x2, CTR_EL0
    and x2, x2, #(0xF << 0)       // IminLine: Smallest instruction cache line size is 16 words.
    lsl x2, x2, #4
    sub x3, x2, #1
    bic x4, x0, x3
    add x5, x4, x1
1:
    IC IVAU, x4
    add x4, x4, x2
    cmp x4, x5
    b.lo    1b
    isb sy

    ret

/**
 * @brief Architecture Data cache enabled
 * 
 * @note  Only EL0 and EL1 cache are enabled, EL2 and EL3 cache are disable by default.
 */
arch_dcache_enable:
    bl arch_dcahce_invalidate_all

    mrs x0, SCTLR_EL1
    orr x0, x0, #(1 << 2)       // C: Data and unified caches enabled.
    msr SCTLR_EL1, x0

    ret

/**
 * @brief Architecture Data cache disabled
 * 
 * @note  Only EL0 and EL1 cache are disabled, EL2 and EL3 cache are disable by default.
 */
arch_dcahce_disable:
    mrs x0, SCTLR_EL1
    bic x0, x0, #(1 << 2)       // C: Data and unified caches disabled.
    msr SCTLR_EL1, x0

    ret

/**
 * @brief Architecture Data cache invalidate by virtual address (VA) to PoC
 * 
 * @param x0 - The virtual start address of region
 * @param x1 - The size of region
 */
arch_dcahce_invalidate_range:
    mrs x2, CTR_EL0
    lsr x2, x2, #16
    and x2, x2, #(0xF << 0)       // IminLine: Smallest instruction cache line size is 16 words.
    lsl x2, x2, #4
    sub x3, x2, #1
    bic x4, x0, x3
    add x5, x4, x1
1:
    DC IVAC, x4
    add x4, x4, x2
    cmp x4, x5
    b.lo    1b
    dsb sy

    ret

/**
 * @brief Architecture Data cache clean by virtual address (VA) to PoC
 * 
 * @param x0 - The virtual start address of region
 * @param x1 - The size of region
 */
arch_dcahce_clean_range:
    mrs x2, CTR_EL0
    lsr x2, x2, #16
    and x2, x2, #(0xF << 0)       // IminLine: Smallest instruction cache line size is 16 words.
    lsl x2, x2, #4
    sub x3, x2, #1
    bic x4, x0, x3
    add x5, x4, x1
1:
    DC CVAC, x4
    add x4, x4, x2
    cmp x4, x5
    b.lo    1b
    dsb sy

    ret

/**
 * @brief Architecture Data cache clean and invalidate by virtual address (VA) to PoC
 * 
 * @param x0 - The virtual start address of region
 * @param x1 - The size of region
 */
arch_dcahce_flush_range:
    mrs x2, CTR_EL0
    lsr x2, x2, #16
    and x2, x2, #(0xF << 0)       // IminLine: Smallest instruction cache line size is 16 words.
    lsl x2, x2, #4
    sub x3, x2, #1
    bic x4, x0, x3
    add x5, x4, x1
1:
    DC CIVAC, x4
    add x4, x4, x2
    cmp x4, x5
    b.lo    1b
    dsb sy

    ret

/**
 * @brief Architecture data cache invalidate all by set/way
 */
arch_dcahce_invalidate_all:
    dsb	sy				        // ensure ordering with previous memory accesses
	mrs	x0, CLIDR_EL1			// read clidr
	and	x3, x0, #0x7000000		// extract loc from clidr
	lsr	x3, x3, #23			    // left align loc bit field
	cbz	x3, 5f			        // if loc is 0, then no need to clean
	mov	x10, #0				    // start clean at cache level 0
1:
	add	x2, x10, x10, lsr #1	// work out 3x current cache level
	lsr	x1, x0, x2			    // extract cache type bits from clidr
	and	x1, x1, #7			    // mask of the bits for current cache only
	cmp	x1, #2				    // see what cache we have at this level
	b.lt 4f				        // skip if no cache, or just i-cache
	msr	CSSELR_EL1, x10			// select current cache level in csselr
	isb					        // isb to sych the new cssr&csidr
	mrs	x1,CCSIDR_EL1			// read the new ccsidr
	and	x2, x1, #7			    // extract the length of the cache lines
	add	x2, x2, #4			    // add 4 (line length offset)
	mov	x4, #0x3ff
	and	x4, x4, x1, lsr #3		// find maximum number on the way size
	clz	w5, w4				    // find bit position of way size increment
	mov	x7, #0x7fff
	and	x7, x7, x1, lsr #13		// extract max number of the index size
2:
	mov	x9, x4				    // create working copy of max way size
3:
	lsl	x6, x9, x5
	orr	x11, x10, x6			// factor way and cache number into x11
	lsl	x6, x7, x2
	orr	x11, x11, x6			// factor index number into x11
	DC ISW, x11			        // invalidate by set/way
	subs	x9, x9, #1			// decrement the way
	b.ge 3b
	subs	x7, x7, #1			// decrement the index
	b.ge 2b
4:
	add	x10, x10, #2			// increment cache number
	cmp	x3, x10
	b.gt 1b
5:
	mov	x10, #0				    // swith back to cache level 0
	msr	CSSELR_EL1, x10			// select current cache level in csselr
	dsb	sy
	isb

	ret

/**
 * @brief Architecture data cache clean all by set/way
 */
arch_dcahce_clean_all:
    dsb	sy				        // ensure ordering with previous memory accesses
	mrs	x0, CLIDR_EL1			// read clidr
	and	x3, x0, #0x7000000		// extract loc from clidr
	lsr	x3, x3, #23			    // left align loc bit field
	cbz	x3, 5f			        // if loc is 0, then no need to clean
	mov	x10, #0				    // start clean at cache level 0
1:
	add	x2, x10, x10, lsr #1	// work out 3x current cache level
	lsr	x1, x0, x2			    // extract cache type bits from clidr
	and	x1, x1, #7			    // mask of the bits for current cache only
	cmp	x1, #2				    // see what cache we have at this level
	b.lt 4f				        // skip if no cache, or just i-cache
	msr	CSSELR_EL1, x10			// select current cache level in csselr
	isb					        // isb to sych the new cssr&csidr
	mrs	x1,CCSIDR_EL1			// read the new ccsidr
	and	x2, x1, #7			    // extract the length of the cache lines
	add	x2, x2, #4			    // add 4 (line length offset)
	mov	x4, #0x3ff
	and	x4, x4, x1, lsr #3		// find maximum number on the way size
	clz	w5, w4				    // find bit position of way size increment
	mov	x7, #0x7fff
	and	x7, x7, x1, lsr #13		// extract max number of the index size
2:
	mov	x9, x4				    // create working copy of max way size
3:
	lsl	x6, x9, x5
	orr	x11, x10, x6			// factor way and cache number into x11
	lsl	x6, x7, x2
	orr	x11, x11, x6			// factor index number into x11
	DC CSW, x11			        // clean by set/way
	subs	x9, x9, #1			// decrement the way
	b.ge 3b
	subs	x7, x7, #1			// decrement the index
	b.ge 2b
4:
	add	x10, x10, #2			// increment cache number
	cmp	x3, x10
	b.gt 1b
5:
	mov	x10, #0				    // swith back to cache level 0
	msr	CSSELR_EL1, x10			// select current cache level in csselr
	dsb	sy
	isb

	ret

/**
 * @brief Architecture data cache clean and invalidate all by set/way
 */
arch_dcahce_flush_all:
    dsb	sy				        // ensure ordering with previous memory accesses
	mrs	x0, CLIDR_EL1			// read clidr
	and	x3, x0, #0x7000000		// extract loc from clidr
	lsr	x3, x3, #23			    // left align loc bit field
	cbz	x3, 5f			        // if loc is 0, then no need to clean
	mov	x10, #0				    // start clean at cache level 0
1:
	add	x2, x10, x10, lsr #1	// work out 3x current cache level
	lsr	x1, x0, x2			    // extract cache type bits from clidr
	and	x1, x1, #7			    // mask of the bits for current cache only
	cmp	x1, #2				    // see what cache we have at this level
	b.lt 4f				        // skip if no cache, or just i-cache
	msr	CSSELR_EL1, x10			// select current cache level in csselr
	isb					        // isb to sych the new cssr&csidr
	mrs	x1,CCSIDR_EL1			// read the new ccsidr
	and	x2, x1, #7			    // extract the length of the cache lines
	add	x2, x2, #4			    // add 4 (line length offset)
	mov	x4, #0x3ff
	and	x4, x4, x1, lsr #3		// find maximum number on the way size
	clz	w5, w4				    // find bit position of way size increment
	mov	x7, #0x7fff
	and	x7, x7, x1, lsr #13		// extract max number of the index size
2:
	mov	x9, x4				    // create working copy of max way size
3:
	lsl	x6, x9, x5
	orr	x11, x10, x6			// factor way and cache number into x11
	lsl	x6, x7, x2
	orr	x11, x11, x6			// factor index number into x11
	DC CISW, x11			    // clean & invalidate by set/way
	subs	x9, x9, #1			// decrement the way
	b.ge 3b
	subs	x7, x7, #1			// decrement the index
	b.ge 2b
4:
	add	x10, x10, #2			// increment cache number
	cmp	x3, x10
	b.gt 1b
5:
	mov	x10, #0				    // swith back to cache level 0
	msr	CSSELR_EL1, x10			// select current cache level in csselr
	dsb	sy
	isb

	ret

