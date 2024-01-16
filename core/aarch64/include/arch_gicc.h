#ifndef ARCH_GICC_H_
#define ARCH_GICC_H_

#include "arch_types.h"

#define GICC_CTLR       0x0000      //! CPU Interface Control Register
#define GICC_PMR        0x0004      //! Interrupt Priority Mask Register
#define GICC_BPR        0x0008      //! Binary Point Register
#define GICC_IAR        0x000C      //! Interrupt Acknowledge Register
#define GICC_EOIR       0x0010      //! End Of Interrupt Register
#define GICC_RPR        0x0014      //! Running Priority Register
#define GICC_HPPIR      0x0018      //! Highest Priority Pending Interrupt Register
#define GICC_ABPR       0x001C      //! Aliased Binary Point Register
#define GICC_AIAR       0x0020      //! Aliased Interrupt Acknowledge Register
#define GICC_AEOIR      0x0024      //! Aliased End of Interrupt Register
#define GICC_AHPPIR     0x0028      //! Aliased Highest Priority Pending Interrupt Register
#define GICC_APR0       0x00D0      //! Active Priority Register
#define GICC_NSAPR0     0x00E0      //! Non-secure Active Priority Register
#define GICC_IIDR       0x00FC      //! CPU Interface Identification Register
#define GICC_DIR        0x1000      //! Deactivate Interrupt Register

#endif /* ARCH_GICC_H_ */