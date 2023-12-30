# Architecture
Embedded bare metal sample code supports armv7-m, armv7-a, armv7-r and armv8-a architecture;

# Platform
|  Architecture   |  armv7-m   | armv7-a               |  armv7-r   |  armv8-a     |
|  ----  |  ----      | ----                  |  ----      |  ----        |
|  CPU   |  Cortex-M7 | Cortex-A8/Cortex-A15  |  Cortex-R5F|  Cortex-A53  |
|  SOC   |  STM32H750 | AM3358/AM5718         |  E3640     |  H6/AM6254   |

# Build
```c
release.sh <soc>

example:
    release.sh am6254
```

# Compiler
The compilation tool uses cmake, and the compilers are:
|  ISA     |  toolchain     |
|  ----    |  ----          |
|  armv7   |  arm-none-eabi |
|  armv8   |  aarch64-none-linux-gnu |