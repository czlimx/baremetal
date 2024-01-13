#include "arch_types.h"
#include "arch_cache.h"
#include "arch_pmu.h"

void _early_init(void)
{
    bool status;
    uint64_t value;
    arch_icache_enable();
    arch_icahce_disable();
    arch_icahce_invalidate_all();
    arch_icahce_invalidate_range(0x1000, 96);
    arch_dcache_enable();
    arch_dcahce_disable();
    arch_dcahce_invalidate_all();
    arch_dcahce_clean_all();
    arch_dcahce_flush_all();
    arch_dcahce_invalidate_range(0x1000, 96);
    arch_dcahce_clean_range(0x1000, 96);
    arch_dcahce_flush_range(0x1000, 96);

    arch_pmu_init();
    arch_pmu_cycle_enable();
    arch_pmu_cycle_disable();
    arch_pmu_cycle_set(0x1000);
    arch_pmu_cycle_enable();
    value  = arch_pmu_cycle_get();
    status = arch_pmu_cycle_overflow_status_get();
    arch_pmu_cycle_interrupt_enable();
    arch_pmu_cycle_interrupt_disable();
    arch_pmu_cycle_overflow_status_clr();
    if ((0x0U != value) || (true == status))
    {
        value  = 0x0U;
        status = false;
    }

    arch_pmu_event_enable(3);
    arch_pmu_event_disable(3);
    arch_pmu_event_enable(3);
    arch_pmu_event_set(3, 0x100);
    arch_pmu_event_select(3, ARCH_PMU_SW_INCR);
    arch_pmu_event_increment(3);
    value  = arch_pmu_event_get(3);
    arch_pmu_event_interrupt_enable(3);
    arch_pmu_event_interrupt_disable(3);
    status = arch_pmu_event_overflow_status_get(3);
    arch_pmu_event_overflow_status_clr(3);
    if ((0x0U != value) || (true == status))
    {
        value  = 0x0U;
        status = false;
    }
}