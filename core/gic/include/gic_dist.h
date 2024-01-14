#ifndef GID_DIST_H_
#define GID_DIST_H_

#include "arch_types.h"

typedef enum {
    GICD_SECURE = 0,
    GICD_NON_SECURE
} gic_dist_secure_type;

typedef enum {
    GICD_G0S = 0,
    GICD_G1NS,
    GICD_G1S
} gic_dist_group_type;

typedef enum {
    GICD_LEVEL_SENSITIVE = 0,
    GICD_EDGE_TRIGGERD
} gic_dist_configure_type;

typedef enum {
    GICD_NO_NON_SECURE_ACCESS = 0,
    GICD_NON_SECURE_WR,
    GICD_NON_SECURE_WR_PLUS
} gic_dist_access_type;

typedef enum {
    GICD_CPU_TARGET_LIST = 0,
    GICD_ALL_CPU_EXCEPT_PE,
    GICD_NOLY_PE
} gic_dist_target_list_filter_type;

#define GICD_CTLR               0x0000                  //! Distributor Control Register
#define GICD_TYPER              0x0004                  //! Interrupt Controller Type Register
#define GICD_IIDR               0x0008                  //! Distributor Implementer Identification Register
#define GICD_SETSPI_NSR         0x0040                  //! Non-secure SPI Set Register
#define GICD_CLRSPI_NSR         0x0048                  //! Non-secure SPI Clear Register
#define GICD_SETSPI_SR          0x0050                  //! Secure SPI Set Register
#define GICD_CLRSPI_SR          0x0058                  //! Secure SPI Clear Register
#define GICD_IGROUPR(n)         (0x0080 + (4 * n))      //! Interrupt Group Registers
#define GICD_ISENABLER(n)       (0x0100 + (4 * n))      //! Interrupt Set-Enable Registers
#define GICD_ICENABLER(n)       (0x0180 + (4 * n))      //! Interrupt Clear-Enable Registers
#define GICD_ISPENDR(n)         (0x0200 + (4 * n))      //! Interrupt Set-Pending Registers
#define GICD_ICPENDR(n)         (0x0280 + (4 * n))      //! Interrupt Clear-Pending Registers
#define GICD_ISACTIVER(n)       (0x0300 + (4 * n))      //! Interrupt Set-Active Registers
#define GICD_ICACTIVER(n)       (0x0380 + (4 * n))      //! Interrupt Clear-Active Registers
#define GICD_IPRIORITYR(n)      (0x0400 + (4 * n))      //! Interrupt Priority Registers
#define GICD_ITARGETSR(n)       (0x0800 + (4 * n))      //! Interrupt Targets Registers
#define GICD_ICFGR(n)           (0x0C00 + (4 * n))      //! Interrupt Configuration Registers
#define GICD_IGRPMODR(n)        (0x0D00 + (4 * n))      //! Interrupt Group Modifier Registers
#define GICD_NSACR(n)           (0x0E00 + (4 * n))      //! Non-secure Access Control Registers
#define GICD_SGIR               0x0F00                  //! Software Generated Interrupt Register
#define GICD_CPENDSGIR(n)       (0x0F10 + (4 * n))      //! SGI Clear-Pending Registers
#define GICD_SPENDSGIR(n)       (0x0F20 + (4 * n))      //! SGI Set-Pending Registers
#define GICD_IROUTER(n)         (0x6100 + (8 * n))      //! Interrupt Routing Registers, 64-bit
#define GICD_ESTATUSR           0xC000                  //! Extended Status Register
#define GICD_ERRTESTR           0xC004                  //! Error Test Register
#define GICD_SPISR              0xC084                  //! GIC-500 Shared Peripheral Interrupt Status Registers
#define GICD_PIDR4              0xFFD0                  //! Peripheral ID 4 Register
#define GICD_PIDR5              0xFFD4                  //! Peripheral ID 5 Register
#define GICD_PIDR6              0xFFD8                  //! Peripheral ID 6 Register
#define GICD_PIDR7              0xFFDC                  //! Peripheral ID 7 Register
#define GICD_PIDR0              0xFFE0                  //! Peripheral ID 0 Register
#define GICD_PIDR1              0xFFE4                  //! Peripheral ID 1 Register
#define GICD_PIDR2              0xFFE8                  //! Peripheral ID 2 Register
#define GICD_PIDR3              0xFFEC                  //! Peripheral ID 3 Register
#define GICD_CIDR0              0xFFF0                  //! Component ID 0 Register
#define GICD_CIDR1              0xFFF4                  //! Component ID 1 Register
#define GICD_CIDR2              0xFFF8                  //! Component ID 2 Register
#define GICD_CIDR3              0xFFFC                  //! Component ID 3 Register

#endif /* GID_DIST_H_ */