SECTIONS
{
  INCLUDE ../../output/bob_linker.x
  . = XM_LOAD_ADR;
  .text            : {
        *(.text.modinfo)
        *(.text   .text.*   .gnu.linkonce.t.*) 
    }
  .rodata ALIGN(4) : SUBALIGN(4) { *(.rodata .rodata.* .gnu.linkonce.r.*) }
  .data   ALIGN(4) : SUBALIGN(4) { 
        *(.data   .data.*   .gnu.linkonce.d.*) 
        *(.far    .far.*)
    }
  .bss    ALIGN(4) (NOLOAD) : SUBALIGN(4) { 
        __mod_bss_start__ = .;
        *(.bss    .bss.*    .gnu.linkonce.b.*)
        *(.farbss .farbss.*)
        *(COMMON) 
        . = ALIGN(4);
        __mod_bss_end__ = .;
    }
}