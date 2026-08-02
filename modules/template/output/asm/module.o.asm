	.file	"module.c"
	.section	.rodata
	.p2align 2
.LC0:
	.string	"[XM] init (%X)\n"
	.text
	.core
	.p2align 1
	.globl xm_init
	.type	xm_init, @function
xm_init:
	# frame: 16   16 regs
	add	$sp, -16
	ldc	$11, $lp
	mov	$2, $1
	movu	$1, .LC0
	sw	$11, 4($sp)
	bsr	debug_printFormat
	mov	$0, 0
	lw	$11, 4($sp)
	add	$sp, 16
	jmp	$11
	.size	xm_init, .-xm_init
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
