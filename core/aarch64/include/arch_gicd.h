#ifndef ARCH_GICD_H_
#define ARCH_GICD_H_

#define ARCH_GICD_CTLR               0x0000                  //! Distributor Control Register
#define ARCH_GICD_TYPER              0x0004                  //! Interrupt Controller Type Register
#define ARCH_GICD_IIDR               0x0008                  //! Distributor Implementer Identification Register
#define ARCH_GICD_SETSPI_NSR         0x0040                  //! Non-secure SPI Set Register
#define ARCH_GICD_CLRSPI_NSR         0x0048                  //! Non-secure SPI Clear Register
#define ARCH_GICD_SETSPI_SR          0x0050                  //! Secure SPI Set Register
#define ARCH_GICD_CLRSPI_SR          0x0058                  //! Secure SPI Clear Register
#define ARCH_GICD_IGROUPR            0x0080                  //! Interrupt Group Registers
#define ARCH_GICD_ISENABLER          0x0100                  //! Interrupt Set-Enable Registers
#define ARCH_GICD_ICENABLER          0x0180                  //! Interrupt Clear-Enable Registers
#define ARCH_GICD_ISPENDR            0x0200                  //! Interrupt Set-Pending Registers
#define ARCH_GICD_ICPENDR            0x0280                  //! Interrupt Clear-Pending Registers
#define ARCH_GICD_ISACTIVER          0x0300                  //! Interrupt Set-Active Registers
#define ARCH_GICD_ICACTIVER          0x0380                  //! Interrupt Clear-Active Registers
#define ARCH_GICD_IPRIORITYR         0x0400                  //! Interrupt Priority Registers
#define ARCH_GICD_ITARGETSR          0x0800                  //! Interrupt Targets Registers
#define ARCH_GICD_ICFGR              0x0C00                  //! Interrupt Configuration Registers
#define ARCH_GICD_IGRPMODR           0x0D00                  //! Interrupt Group Modifier Registers
#define ARCH_GICD_NSACR              0x0E00                  //! Non-secure Access Control Registers
#define ARCH_GICD_SGIR               0x0F00                  //! Software Generated Interrupt Register
#define ARCH_GICD_CPENDSGIR          0x0F10                  //! SGI Clear-Pending Registers
#define ARCH_GICD_SPENDSGIR          0x0F20                  //! SGI Set-Pending Registers
#define ARCH_GICD_IROUTER            0x6100                  //! Interrupt Routing Registers, 64-bit
#define ARCH_GICD_ESTATUSR           0xC000                  //! Extended Status Register
#define ARCH_GICD_ERRTESTR           0xC004                  //! Error Test Register
#define ARCH_GICD_SPISR              0xC084                  //! GIC-500 Shared Peripheral Interrupt Status Registers
#define ARCH_GICD_PIDR4              0xFFD0                  //! Peripheral ID 4 Register
#define ARCH_GICD_PIDR5              0xFFD4                  //! Peripheral ID 5 Register
#define ARCH_GICD_PIDR6              0xFFD8                  //! Peripheral ID 6 Register
#define ARCH_GICD_PIDR7              0xFFDC                  //! Peripheral ID 7 Register
#define ARCH_GICD_PIDR0              0xFFE0                  //! Peripheral ID 0 Register
#define ARCH_GICD_PIDR1              0xFFE4                  //! Peripheral ID 1 Register
#define ARCH_GICD_PIDR2              0xFFE8                  //! Peripheral ID 2 Register
#define ARCH_GICD_PIDR3              0xFFEC                  //! Peripheral ID 3 Register
#define ARCH_GICD_CIDR0              0xFFF0                  //! Component ID 0 Register
#define ARCH_GICD_CIDR1              0xFFF4                  //! Component ID 1 Register
#define ARCH_GICD_CIDR2              0xFFF8                  //! Component ID 2 Register
#define ARCH_GICD_CIDR3              0xFFFC                  //! Component ID 3 Register

#ifndef __ASSEMBLY__
#include "arch_types.h"

typedef enum {
    GICD_SECURE = 0,
    GICD_NON_SECURE
} arch_gicd_secure_type;

typedef enum {
    GICD_G0S = 0,
    GICD_G1NS,
    GICD_G1S
} arch_gicd_group_type;

typedef enum {
    GICD_LEVEL_SENSITIVE = 0,
    GICD_EDGE_TRIGGERD = 2
} arch_gicd_configure_type;

typedef enum {
    GICD_NO_NON_SECURE_ACCESS = 0,
    GICD_NON_SECURE_WR,
    GICD_NON_SECURE_WR_PLUS
} arch_gicd_access_type;

typedef enum {
    GICD_CPU_TARGET_LIST = 0,
    GICD_ALL_CPU_EXCEPT_PE,
    GICD_NOLY_PE
} arch_gicd_target_list_filter_type;

/**
 * @brief Architecture GIC Distributor init
 * 
 * @param base The GIC Distributor base address
 */
void arch_gicd_init(const uint64_t base);

/**
 * @brief Architecture GIC Distributor Clear Message-based SPIs
 * 
 * @param base   The GIC Distributor base address
 * @param intID  The Interrupt Identification
 * @param secure The Target Secure Type
 */
void arch_gicd_clr_message_spi_pending(const uint64_t base, const uint32_t intID,
    const arch_gicd_secure_type secure);

/**
 * @brief Architecture GIC Distributor Generate Message-based SPIs
 * 
 * @param base   The GIC Distributor base address
 * @param intID  The Interrupt Identification
 * @param secure The Target Secure Type
 */
void arch_gicd_set_message_spi_pending(const uint64_t base, const uint32_t intID,
    const arch_gicd_secure_type secure);

/**
 * @brief Architecture GIC Distributor configure the interrupt group for SPIs
 * 
 * @param base  The GIC Distributor base address
 * @param intID The Interrupt Identification
 * @param group The Target Secure Group Type
 */
void arch_gicd_config_group(const uint64_t base, const uint32_t intID, 
    const arch_gicd_group_type group);

/**
 * @brief Architecture GIC Distributor enable for SPIs
 * 
 * @param base  The GIC Distributor base address
 * @param intID The Interrupt Identification
 */
void arch_gicd_set_enable(const uint64_t base, const uint32_t intID);

/**
 * @brief Architecture GIC Distributor disable for SPIs
 * 
 * @param base  The GIC Distributor base address
 * @param intID The Interrupt Identification
 */
void arch_gicd_set_disable(const uint64_t base, const uint32_t intID);

/**
 * @brief Architecture GIC Distributor Adds the pending state for SPIs
 * 
 * @param base  The GIC Distributor base address
 * @param intID The Interrupt Identification
 */
void arch_gicd_set_pending(const uint64_t base, const uint32_t intID);

/**
 * @brief Architecture GIC Distributor Removes the pending state for SPIs
 * 
 * @param base  The GIC Distributor base address
 * @param intID The Interrupt Identification
 */
void arch_gicd_clr_pending(const uint64_t base, const uint32_t intID);

/**
 * @brief Architecture GIC Distributor Adds the Activates state for SPIs
 * 
 * @param base  The GIC Distributor base address
 * @param intID The Interrupt Identification
 */
void arch_gicd_set_active(const uint64_t base, const uint32_t intID);

/**
 * @brief Architecture GIC Distributor Adds the Deactivates state for SPIs
 * 
 * @param base  The GIC Distributor base address
 * @param intID The Interrupt Identification
 */
void arch_gicd_clr_active(const uint64_t base, const uint32_t intID);

/**
 * @brief Architecture GIC Distributor Set the priority for All
 * 
 * @param base  The GIC Distributor base address
 * @param intID The Interrupt Identification
 */
void arch_gicd_config_priority(const uint64_t base, const uint32_t intID, 
    const uint32_t priority);

/**
 * @brief Architecture GIC Distributor Set interrupt is edge-triggered or 
 *        level-sensitive for All
 * 
 * @param base    The GIC Distributor base address
 * @param intID   The Interrupt Identification
 * @param trigger The Interrupt trigger mode
 */
void arch_gicd_config_trigger(const uint64_t base, const uint32_t intID, 
    const arch_gicd_configure_type config);

/**
 * @brief Architecture GIC Distributor Set interrupt Non-Secure access Permissions
 * 
 * @param base   The GIC Distributor base address
 * @param intID  The Interrupt Identification
 * @param access The Interrupt Non-Secure access Permissions
 */
void arch_gicd_config_access(const uint64_t base, const uint32_t intID, 
    const arch_gicd_access_type access);

/**
 * @brief Architecture GIC Distributor Adds the pending state to an SGI
 * 
 * @param base   The GIC Distributor base address
 * @param intID  The Interrupt Identification
 */
void arch_gicd_set_sgi_pending(const uint64_t base, const uint32_t intID);

/**
 * @brief Architecture GIC Distributor Removes the pending state to an SGI
 * 
 * @param base   The GIC Distributor base address
 * @param intID  The Interrupt Identification
 */
void arch_gicd_clr_sgi_pending(const uint64_t base, const uint32_t intID);

/**
 * @brief Architecture GIC Distributor Set the route for SPI
 * 
 * @param base      The GIC Distributor base address
 * @param intID     The Interrupt Identification
 * @param irm       The Interrupt Routing Mode
 * @param affinity  The Affinity value
 */
void arch_gicd_config_route(const uint64_t base, const uint32_t intID, 
    const bool irm, const uint64_t affinity);

#endif /* __ASSEMBLY__ */

#endif /* ARCH_GICD_H_ */