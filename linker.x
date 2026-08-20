SECTIONS
{
	INCLUDE cfg.x /* configuration data */

  . = cfg_PROG_load_off;

  .text   : { 
    *(.text.vectors) 
    *(.text.exs) 
    *(.text   .text.*   .gnu.linkonce.t.*) 
  }

  .rodata ALIGN(4) : SUBALIGN(4) { 
    *(.rodata .rodata.* .gnu.linkonce.r.*)
    PROG_sdastart = .;
    *(.srodata .srodata.*)
  }

  .data   ALIGN(4) : SUBALIGN(4) { 
    *(.data   .data.*   .gnu.linkonce.d.*) 
    *(.sdata   .sdata.*) 
    *(.far    .far.*)
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
  PROG_act_size = (PROG_heap_start - cfg_PROG_load_off);
}

__sdabase = cfg_gp_addr;

ASSERT(!(PROG_act_size > cfg_PROG_max_size), "cfg_PROG_max_size");
