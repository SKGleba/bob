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
	mov	$3, 1
	movh	$2, 0x2
	movh	$1, 0x4
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	sw	$11, 4($sp)
	movh	$5, 0x4
	bsr	debug_printRange
	movh	$6, 0x6
.L2:
	mov	$1, $5
	mov	$4, 1
	mov	$3, 16
	mov	$2, 0
	add	$5, 16
	bsr	jig_update_shared_buffer
	bne	$5, $6, .L2
	movh	$1, 0x1
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
	.p2align 2
.LC1:
	.string	"ping pong ding dong "
	.p2align 2
.LC2:
	.string	"[BOB] ernie init\n"
	.p2align 2
.LC3:
	.string	"[BOB] jig init\n"
	.p2align 2
.LC4:
	.string	"[BOB] test test test\n"
	.p2align 2
.LC5:
	.string	"[BOB] move stack & exit to rpc\n"
	.text
	.core
	.p2align 1
	.globl glitch_init
	.type	glitch_init, @function
glitch_init:
	# frame: 24   16 regs   8 locals
	movh	$3, 0xe310
	add	$sp, -24
	ldc	$11, $lp
	or3	$3, $3, 0x3040
	movu	$2, 65543
	sw	$5, 12($sp)
	sw	$11, 8($sp)
	sw	$2, ($3)
	di
	mov	$1, 0
	bsr	gpio_init
	movu	$2, 65562
	mov	$1, 0
	bsr	uart_init
	bsr	get_build_timestamp
	mov	$2, $0
	movu	$3, glitch_init
	movu	$1, .LC0
	bsr	debug_printFormat
	mov	$5, 256 # 0x100
.L5:
	movu	$1, .LC1
	add	$5, -1
	bsr	debug_printFormat
	bnez	$5, .L5
	movu	$1, .LC2
	bsr	debug_printFormat
	mov	$2, 1
	mov	$1, 1
	bsr	ernie_init
	movu	$1, .LC3
	bsr	debug_printFormat
	movh	$3, 0xcafe
	or3	$3, $3, 0xbabe
	mov	$4, 1
	mov	$2, 0
	sw	$3, 4($sp)
	add3	$1, $sp, 4
	mov	$3, 16
	bsr	jig_update_shared_buffer
	movu	$1, .LC4
	bsr	debug_printFormat
	bsr	glitch_test
	movu	$1, .LC5
	bsr	debug_printFormat
#APP
;# 73 "source/glitch.c" 1
	movu $1, 0x5b800
mov $gp, $1
movu $0, 0x5aff0
mov $sp, $0
bsr rpc_loop
mov $0, $0
jmp vectors_exceptions

;# 0 "" 2
#NO_APP
	lw	$5, 12($sp)
	lw	$11, 8($sp)
	add	$sp, 24
	jmp	$11
	.size	glitch_init, .-glitch_init
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
