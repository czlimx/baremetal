MEMORY
{
    .sdram(xrw)  : ORIGIN = 0x70000000, LENGTH = 0x10000
    .ddram(xrw)  : ORIGIN = 0x80000000, LENGTH = 0x20000000
}
OUTPUT_FORMAT("elf64-littleaarch64", "elf64-littleaarch64", "elf64-littleaarch64")
OUTPUT_ARCH(aarch64)
ENTRY(_start)
SECTIONS
{
    .vectors : {
        . = ALIGN(256);
        KEEP(*(.text.arch.vectors))
    } >.sdram

    .text : {
        . = ALIGN(256);
        *(.text.arch.startup)
        *(.text.arch.*)
        *(.text.*)
        *(.text*)
    } >.ddram

    .rodata : {
        . = ALIGN(256);
        *(.rodata*)
    } >.ddram

    .data : {
        . = ALIGN(256);
        *(.data*)
    } >.ddram

    .bss (NOLOAD) : {
        . = ALIGN(256);
        _bss_start_ = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(256);
        _bss_end_   = .;
    } >.ddram

    .stack (NOLOAD) : {
        . = ALIGN(256);
        *(.stack*)
        . = . + 0x100000;
        _core0_el3_stack_top = .;
        . = . + 0x100000;
        _core1_el3_stack_top = .;
        . = . + 0x100000;
        _core2_el3_stack_top = .;
        . = . + 0x100000;
        _core3_el3_stack_top = .;
    } >.ddram

 /DISCARD/ : { *(.rela*) }
 /DISCARD/ : { *(.dynsym) }
 /DISCARD/ : { *(.dynstr*) }
 /DISCARD/ : { *(.dynamic*) }
 /DISCARD/ : { *(.plt*) }
 /DISCARD/ : { *(.interp*) }
 /DISCARD/ : { *(.gnu*) }
}
