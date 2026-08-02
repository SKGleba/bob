SECTIONS
{
  . = 0x00040000;
  .text   : { 
    *(.text.vectors) 
    *(.text.exs) 
    *(.text   .text.*   .gnu.linkonce.t.*) 
  }
  .rodata ALIGN(4) : SUBALIGN(4) { *(.rodata .rodata.* .gnu.linkonce.r.*) }
  .data   ALIGN(4) : SUBALIGN(4) { 
    *(.data   .data.*   .gnu.linkonce.d.*) 
    *(.far    .far.*)
  }
  .bss    ALIGN(4) : SUBALIGN(4) {
    *(.bss    .bss.*    .gnu.linkonce.b.*)
    *(.farbss .farbss.*)
    *(COMMON)
  }
}