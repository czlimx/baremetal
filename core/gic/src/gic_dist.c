#include "arch_compiler.h"
#include "gic_dist.h"

void gic_dist_init(const uint64_t base)
{
    uint32_t value = readl(base + GICD_CTLR);
    /* E1NWF: Enable 1 of N Wakeup Functionality. */
    value |=  (0x1U << 7);
    /* DS: Non-secure accesses are not permitted to access and modify registers that control Group 0 interrupts.*/
    value &= ~(0x1U << 6);
    /* ARE_NS: Affinity routing enabled for Non-secure state. */
    value |=  (0x1U << 5);
    /* ARE_S: Affinity routing enabled for Secure state. */
    value |=  (0x1U << 4);
    /* EnableGrp1S: Enable Secure Group 1 interrupts. */
    value |=  (0x1U << 2);
    /* EnableGrp1NS: Enable Non-secure Group 1 interrupts. */
    value |=  (0x1U << 1);
    /* EnableGrp0: Enable Group 0 interrupts. */
    value |=  (0x1U << 0);
    writel(value, base + GICD_CTLR);

    /* Wait for Register Write Pending Compelete. */
    for (;;)
    {
        value = readl(base + GICD_CTLR);
        if (0x1U != ((value >> 31) & 0x1U))     // RWP: Register Write Pending
            break;
    }
}

void gic_dist_set_message_spi_pending(const uint64_t base, const uint32_t intID, const gic_dist_secure_type secure)
{
    uint32_t offset;

    if (GICD_NON_SECURE == secure)
        offset = GICD_SETSPI_NSR;
    else
        offset = GICD_SETSPI_SR;

    writel(intID, base + offset);
}

void gic_dist_clr_message_spi_pending(const uint64_t base, const uint32_t intID, const gic_dist_secure_type secure)
{
    uint32_t offset;

    if (GICD_NON_SECURE == secure)
        offset = GICD_CLRSPI_NSR;
    else
        offset = GICD_CLRSPI_SR;

    writel(intID, base + offset);
}

void gic_dist_config_group(const uint64_t base, const uint32_t intID, const gic_dist_group_type group)
{
    uint32_t gro = intID / 32;
    uint32_t bit = intID % 32;

    uint32_t status   = readl(base + GICD_IGROUPR(gro));
    uint32_t modifier = readl(base + GICD_IGRPMODR(gro));

    switch (group)
    {
    case GICD_G0S:  // Secure Group 0
        status   &= ~(0x1U << bit);
        modifier &= ~(0x1U << bit);
        break;
    case GICD_G1NS: // Non-secure Group 1
        status   |=  (0x1U << bit);
        modifier &= ~(0x1U << bit);
        break;
    default:        // Secure Group 1 G1S
        status   &= ~(0x1U << bit);
        modifier |=  (0x1U << bit);
        break;
    }

    writel(status,   base + GICD_IGROUPR(gro));
    writel(modifier, base + GICD_IGRPMODR(gro));
}

void gic_dist_set_enable(const uint64_t base, const uint32_t intID)
{
    uint32_t gro = intID / 32;
    uint32_t bit = intID % 32;
    uint32_t val =  (0x1U << bit);
    writel(val, base + GICD_ISENABLER(gro));
}

void gic_dist_set_disable(const uint64_t base, const uint32_t intID)
{
    uint32_t gro = intID / 32;
    uint32_t bit = intID % 32;
    uint32_t val =  (0x1U << bit);
    writel(val, base + GICD_ICENABLER(gro));
}

void gic_dist_set_pending(const uint64_t base, const uint32_t intID)
{
    uint32_t gro = intID / 32;
    uint32_t bit = intID % 32;
    uint32_t val =  (0x1U << bit);
    writel(val, base + GICD_ISPENDR(gro));
}

void gic_dist_clr_pending(const uint64_t base, const uint32_t intID)
{
    uint32_t gro = intID / 32;
    uint32_t bit = intID % 32;
    uint32_t val =  (0x1U << bit);
    writel(val, base + GICD_ICPENDR(gro));
}

void gic_dist_set_active(const uint64_t base, const uint32_t intID)
{
    uint32_t gro = intID / 32;
    uint32_t bit = intID % 32;
    uint32_t val =  (0x1U << bit);
    writel(val, base + GICD_ISACTIVER(gro));
}

void gic_dist_clr_active(const uint64_t base, const uint32_t intID)
{
    uint32_t gro = intID / 32;
    uint32_t bit = intID % 32;
    uint32_t val =  (0x1U << bit);
    writel(val, base + GICD_ICACTIVER(gro));
}

void gic_dist_config_priority(const uint64_t base, const uint32_t intID, const uint32_t priority)
{
    uint32_t gro = intID / 4;
    uint32_t bit = intID % 4;

    uint32_t val  = readl(base + GICD_IPRIORITYR(gro));
    val &= ~(0xFFU << bit);
    val |=  (priority << bit);
    writel(val, base + GICD_IPRIORITYR(gro));
}

void gic_dist_config_configure(const uint64_t base, const uint32_t intID, const gic_dist_configure_type config)
{
    uint32_t gro = intID / 16;
    uint32_t bit = intID % 16;

    uint32_t val  = readl(base + GICD_ICFGR(gro));
    val &= ~(0x3U << bit);

    if (GICD_EDGE_TRIGGERD == config)
        val |= (0x2U << bit);
    else
        val |= (0x0U << bit);

    writel(val, base + GICD_ICFGR(gro));
}

void gic_dist_config_access(const uint64_t base, const uint32_t intID, const gic_dist_access_type access)
{
    uint32_t gro = intID / 16;
    uint32_t bit = intID % 16;

    uint32_t val = readl(base + GICD_NSACR(gro));
    val &= ~(0x3U << bit);
    val |=  (access << bit);
    writel(val, base + GICD_NSACR(gro));
}

void gic_dist_generate_sgi(const uint64_t base, const uint32_t intID, const gic_dist_target_list_filter_type filter, const uint32_t target_list, const bool group0)
{
    uint32_t val = intID & 0xFU;
    val |= (group0 << 15);
    val |= ((target_list & 0xFFU) << 16);
    val |= ((filter & 0x3U) << 24);
    writel(val, base + GICD_SGIR);
}

void gic_dist_set_sgi_pending(const uint64_t base, const uint32_t intID)
{
    uint32_t gro = intID / 4;
    uint32_t bit = intID % 4;
    uint32_t val = (0x1U << bit);
    writel(val, base + GICD_SPENDSGIR(gro));
}

void gic_dist_clr_sgi_pending(const uint64_t base, const uint32_t intID)
{
    uint32_t gro = intID / 4;
    uint32_t bit = intID % 4;
    uint32_t val = (0x1U << bit);
    writel(val, base + GICD_CPENDSGIR(gro));
}

void gic_dist_config_route(const uint64_t base, const uint32_t intID, const bool irm, const uint64_t affinity)
{
    uint64_t val = affinity & 0xFF00FFFFFFU;
    val |= (irm << 31);
    writeq(val, base + GICD_IROUTER(intID));
}