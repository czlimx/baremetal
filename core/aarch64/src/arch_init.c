#include "arch_types.h"
#include "arch_cache.h"
#include "arch_pmu.h"
#include "arch_libc.h"
#include "arch_gicd.h"

extern char _bss_start_[], _bss_end_[];

void _early_init(void)
{
    /* clear bss section */
    memset((void*)_bss_start_, 0, _bss_end_ - _bss_start_);

    // bool status;
    // uint64_t value;
    // arch_icache_enable();
    // arch_icahce_disable();
    // arch_icahce_invalidate_all();
    // arch_icahce_invalidate_range(0x1000, 96);
    // arch_dcache_enable();
    // arch_dcahce_disable();
    // arch_dcahce_invalidate_all();
    // arch_dcahce_clean_all();
    // arch_dcahce_flush_all();
    // arch_dcahce_invalidate_range(0x1000, 96);
    // arch_dcahce_clean_range(0x1000, 96);
    // arch_dcahce_flush_range(0x1000, 96);

    // arch_pmu_init();
    // arch_pmu_cycle_enable();
    // arch_pmu_cycle_disable();
    // arch_pmu_cycle_set(0x1000);
    // arch_pmu_cycle_enable();
    // value  = arch_pmu_cycle_get();
    // status = arch_pmu_cycle_overflow_status_get();
    // arch_pmu_cycle_interrupt_enable();
    // arch_pmu_cycle_interrupt_disable();
    // arch_pmu_cycle_overflow_status_clr();
    // if ((0x0U != value) || (true == status))
    // {
    //     value  = 0x0U;
    //     status = false;
    // }

    // arch_pmu_event_enable(3);
    // arch_pmu_event_disable(3);
    // arch_pmu_event_enable(3);
    // arch_pmu_event_set(3, 0x100);
    // arch_pmu_event_select(3, ARCH_PMU_SW_INCR);
    // arch_pmu_event_increment(3);
    // value  = arch_pmu_event_get(3);
    // arch_pmu_event_interrupt_enable(3);
    // arch_pmu_event_interrupt_disable(3);
    // status = arch_pmu_event_overflow_status_get(3);
    // arch_pmu_event_overflow_status_clr(3);
    // if ((0x0U != value) || (true == status))
    // {
    //     value  = 0x0U;
    //     status = false;
    // }
    /*
    reg = <0x00 0x01800000 0x00 0x10000>,    GICD
		  <0x00 0x01880000 0x00 0xc0000>,    GICR
		  <0x00 0x01880000 0x00 0xc0000>,    GICR
		  <0x01 0x00000000 0x00 0x2000>,     GICC
		  <0x01 0x00010000 0x00 0x1000>,     GICH
		  <0x01 0x00020000 0x00 0x2000>;     GICV
    */

    // arch_gicd_init(0x01800000);
    // arch_gicd_set_message_spi_pending(0x01800000, 64, 0);
    // arch_gicd_clr_message_spi_pending(0x01800000, 64, 1);

    // arch_gicd_config_group(0x01800000, 65, 1);
    // arch_gicd_config_group(0x01800000, 33, 2);
    // arch_gicd_config_group(0x01800000, 99, 0);
    // arch_gicd_set_enable(0x01800000, 65);
    // arch_gicd_set_pending(0x01800000, 65);
    // arch_gicd_clr_pending(0x01800000, 65);
    // arch_gicd_set_active(0x01800000, 65);
    // arch_gicd_clr_active(0x01800000, 65);
    // arch_gicd_config_priority(0x01800000, 65, 32);
    // arch_gicd_config_trigger(0x01800000, 65, GICD_EDGE_TRIGGERD);
    // arch_gicd_config_trigger(0x01800000, 65, GICD_LEVEL_SENSITIVE);
    // arch_gicd_config_access(0x01800000, 65, GICD_NON_SECURE_WR);
    // arch_gicd_set_disable(0x01800000, 65);
    arch_gicd_set_sgi_pending(0x01800000, 3);
    arch_gicd_clr_sgi_pending(0x01800000, 3);
    arch_gicd_config_route(0x01800000, 65, 1, 0x2);
}