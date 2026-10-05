SECTIONS
{
  . = cfg_PROG_load_addr;

  .text   : { 
    *(.text.vectors) 
    PROG_exports_start = .;
    *(.text.exports)
    PROG_exports_end = .;
    *(.text.exs) 
    *(.text   .text.*   .gnu.linkonce.t.*) 
  }

  PROG_sdastart = .; /* gcc treats everything !far as gprel */

  .rodata ALIGN(4) : SUBALIGN(4) { 
    *(.rodata .rodata.* .gnu.linkonce.r.*)
    *(.srodata .srodata.*)
  }

  .data   ALIGN(4) : SUBALIGN(4) {
    PROG_cfg_addr = .;
    *(.cfgdata .cfgdata.*)
    *(.data   .data.*   .gnu.linkonce.d.*) 
    *(.sdata   .sdata.*) 
    *(.far    .far.*)
    *(.comment    .comment.*)
  }

  .bss    ALIGN(4) : SUBALIGN(4) {
    PROG_bss_addr = .;
    *(.bss    .bss.*    .gnu.linkonce.b.*)
    *(.sbss .sbss.*)
    *(.farbss .farbss.*)
    *(.scommon)
    *(COMMON)
    . = ALIGN(4);
		PROG_bss_end = .;
  }

  PROG_heap_start = .;
}

PROG_act_size = (PROG_bss_end - cfg_PROG_load_addr);
PROG_cfgoff = (PROG_cfg_addr - cfg_PROG_load_addr);
PROG_xpoff = (PROG_exports_start - cfg_PROG_load_addr);

__sdabase = cfg_gp_addr;

ASSERT(!(PROG_act_size > cfg_PROG_max_size), "ERROR: act_size > max_size");
ASSERT((PROG_xpoff == 0xBC) || (PROG_xpoff == 0x1C), "ERROR: PROG_exports_start !@+EXP");
