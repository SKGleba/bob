	.file	"glitch.c"
	.text
	.core
	.p2align 1
	.globl glitch_test
	.type	glitch_test, @function
glitch_test:
	# frame: 24   24 regs
	add	$sp, -24
	ldc	$11, $lp
	mov	$1, 49
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	sw	$11, 4($sp)
	movh	$5, 0x4
	bsr	debug_setGpoCode
	movh	$6, 0x6
.L2:
	mov	$1, $5
	mov	$4, 1
	mov	$3, 16
	mov	$2, 0
	add	$5, 16
	bsr	jig_update_shared_buffer
	bne	$5, $6, .L2
	mov	$1, 50
	bsr	debug_setGpoCode
	mov	$3, 1
	movh	$2, 0x2
	movh	$1, 0x4
	bsr	debug_printRange
	mov	$1, 51
	bsr	debug_setGpoCode
	movu	$1, 100000
	bsr	delay
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, 4($sp)
	add	$sp, 24
	jmp	$11
	.size	glitch_test, .-glitch_test
	.section	.rodata
	.p2align 2
.LC0:
	.string	"[BOB] glitch_init bob [%X], me @ %X\n"
	.text
	.core
	.p2align 1
	.globl glitch_init
	.type	glitch_init, @function
glitch_init:
	# frame: 24   16 regs   8 locals
	add	$sp, -24
	ldc	$11, $lp
	sw	$11, 12($sp)
	di
	mov	$2, 7
	mov	$1, 0
	bsr	gpio_port_set
	mov	$1, 6
	bsr	debug_setGpoCode
	mov	$1, 1
	bsr	gpio_init
	mov	$1, 7
	bsr	debug_setGpoCode
	mov	$1, 1
	bsr	ernie_init
	mov	$1, 8
	bsr	debug_setGpoCode
	movh	$3, 0xcafe
	or3	$3, $3, 0xbabe
	mov	$4, 1
	sw	$3, 4($sp)
	mov	$2, 0
	mov	$3, 4
	add3	$1, $sp, 4
	bsr	jig_update_shared_buffer
	mov	$1, 9
	bsr	debug_setGpoCode
	movu	$2, 65562
	mov	$1, 1
	bsr	uart_init
	bsr	get_build_timestamp
	mov	$2, $0
	movu	$3, glitch_init
	movu	$1, .LC0
	bsr	debug_printFormat
	mov	$1, 10
	bsr	debug_setGpoCode
	bsr	glitch_test
	mov	$1, 11
	bsr	debug_setGpoCode
	bsr	rpc_loop
	lw	$11, 12($sp)
	add	$sp, 24
	jmp	$11
	.size	glitch_init, .-glitch_init
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
