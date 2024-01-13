MEMORY
{
    .sdram(xrw)  : ORIGIN = 0x43C00000, LENGTH = 248K
}
OUTPUT_FORMAT("elf64-littleaarch64", "elf64-littleaarch64", "elf64-littleaarch64")
OUTPUT_ARCH(aarch64)
ENTRY(_start)
SECTIONS
{
    .text : {
        . = ALIGN(256);
        KEEP(*(.text.vectors))
        *(.text.startup)
        *(.text.*)
        *(.text*)
    } >.sdram

    .rodata : {
        . = ALIGN(256);
        *(.rodata*)
    } >.sdram

    .data : {
        . = ALIGN(256);
        *(.data*)
    } >.sdram

    .bss (NOLOAD) : {
        . = ALIGN(256);
        _bss_start_ = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(256);
        _bss_end_   = .;
    } >.sdram

    .stack (NOLOAD) : {
        . = ALIGN(256);
        *(.stack*)
        . = . + 0x1000;
        _core0_el3_stack_top = .;
        . = . + 0x1000;
        _core1_el3_stack_top = .;
        . = . + 0x1000;
        _core2_el3_stack_top = .;
        . = . + 0x1000;
        _core3_el3_stack_top = .;
    } >.sdram

 /DISCARD/ : { *(.rela*) }
 /DISCARD/ : { *(.dynsym) }
 /DISCARD/ : { *(.dynstr*) }
 /DISCARD/ : { *(.dynamic*) }
 /DISCARD/ : { *(.plt*) }
 /DISCARD/ : { *(.interp*) }
 /DISCARD/ : { *(.gnu*) }
}
