SECTIONS
{
  INCLUDE source/include/brom1k_linker.x
  INCLUDE ../output/bob_linker.x
  . = 0x0004a000;
  .text   : { *(.text.rpcp) *(.text   .text.*   .gnu.linkonce.t.*) }
  .rodata : { *(.rodata .rodata.* .gnu.linkonce.r.*) }
  .data   : { *(.data   .data.*   .gnu.linkonce.d.*) }
  .bss    : { *(.bss    .bss.*    .gnu.linkonce.b.*) *(COMMON) }
}