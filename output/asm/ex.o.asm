	.file	"ex.c"
	.section	.rodata
	.p2align 2
.LC0:
	.string	"[BOB] warning: did reset\n"
	.text
	.core
	.p2align 1
	.globl c_RESET
	.type	c_RESET, @function
c_RESET:
	# frame: 24   24 regs
	add	$sp, -24
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	sw	$tp, 20($sp)
	sw	$gp, 16($sp)
	ldc	$11, $lp
	sw	$11, 4($sp)
	mov	$5, $tp
	mov	$6, $gp
	di
	mov	$tp, $5
	mov	$gp, $6
	bsr	debug_regdump
	mov	$3, 0
	stc	$3, $exc
	mov	$3, 0
	stc	$3, $tmp
	movh	$sp, 0x4
	or3	$sp, $sp, 0x9000
	movh	$gp, 0x4
	or3	$gp, $gp, 0xfc00
	mov	$2, $sp
	movu	$3, c_RESET
	sltu3	$0, $2, $3
	mov	$3, $0
	beqz	$3, .L2
	movh	$sp, 0x80
	or3	$sp, $sp, 0x9000
	movh	$gp, 0x80
	or3	$gp, $gp, 0xfc00
.L2:
	movu	$2, .LC0
	mov	$1, 1
	mov	$tp, $5
	mov	$gp, $6
	bsr	uart_print
	ei
.L3:
	mov	$1, 1
	mov	$tp, $5
	mov	$gp, $6
	bsr	ce_framework
	bra	.L3
	.size	c_RESET, .-c_RESET
	.section	.rodata
	.p2align 2
.LC1:
	.string	"[BOB] entering SWI\n"
	.p2align 2
.LC2:
	.string	"[BOB] exiting SWI\n"
	.text
	.core
	.p2align 1
	.globl c_SWI
	.type	c_SWI, @function
c_SWI:
	# frame: 24   24 regs
	add	$sp, -24
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	sw	$tp, 20($sp)
	sw	$gp, 16($sp)
	ldc	$11, $lp
	sw	$11, 4($sp)
	mov	$5, $tp
	mov	$6, $gp
	movu	$2, .LC1
	mov	$1, 1
	mov	$tp, $5
	mov	$gp, $6
	bsr	uart_print
	movu	$2, .LC2
	mov	$1, 1
	mov	$tp, $5
	mov	$gp, $6
	bsr	uart_print
	nop
	lw	$gp, 16($sp)
	lw	$tp, 20($sp)
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, 4($sp)
	add	$sp, 24
	jmp	$11
	.size	c_SWI, .-c_SWI
	.section	.rodata
	.p2align 2
.LC3:
	.string	"[BOB] entering IRQ\n"
	.p2align 2
.LC4:
	.string	"[BOB] exiting IRQ\n"
	.text
	.core
	.p2align 1
	.globl c_IRQ
	.type	c_IRQ, @function
c_IRQ:
	# frame: 24   24 regs
	add	$sp, -24
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	sw	$tp, 20($sp)
	sw	$gp, 16($sp)
	ldc	$11, $lp
	sw	$11, 4($sp)
	mov	$5, $tp
	mov	$6, $gp
	movu	$2, .LC3
	mov	$1, 1
	mov	$tp, $5
	mov	$gp, $6
	bsr	uart_print
	movu	$2, .LC4
	mov	$1, 1
	mov	$tp, $5
	mov	$gp, $6
	bsr	uart_print
	nop
	lw	$gp, 16($sp)
	lw	$tp, 20($sp)
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, 4($sp)
	add	$sp, 24
	jmp	$11
	.size	c_IRQ, .-c_IRQ
	.section	.rodata
	.p2align 2
.LC5:
	.string	"[BOB] entering ARM req\n"
	.p2align 2
.LC6:
	.string	"[BOB] exiting ARM req\n"
	.text
	.core
	.p2align 1
	.globl c_ARM_REQ
	.type	c_ARM_REQ, @function
c_ARM_REQ:
	# frame: 24   24 regs
	add	$sp, -24
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	sw	$tp, 20($sp)
	sw	$gp, 16($sp)
	ldc	$11, $lp
	sw	$11, 4($sp)
	mov	$5, $tp
	mov	$6, $gp
	movu	$2, .LC5
	mov	$1, 1
	mov	$tp, $5
	mov	$gp, $6
	bsr	uart_print
	mov	$1, 0
	mov	$tp, $5
	mov	$gp, $6
	bsr	ce_framework
	mov	$3, $0
	beqz	$3, .L7
	movh	$3, 0xe000
	or3	$3, $3, 0x10
	mov	$2, -1 # 0xffff
	sw	$2, ($3)
	bra	.L8
.L7:
	mov	$tp, $5
	mov	$gp, $6
	bsr	compat_IRQ7_handleCmd
.L8:
	movu	$2, .LC6
	mov	$1, 1
	mov	$tp, $5
	mov	$gp, $6
	bsr	uart_print
	nop
	lw	$gp, 16($sp)
	lw	$tp, 20($sp)
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, 4($sp)
	add	$sp, 24
	jmp	$11
	.size	c_ARM_REQ, .-c_ARM_REQ
	.section	.rodata
	.p2align 2
.LC7:
	.string	"[BOB] UNK INTERRUPT: %X @ %X\n"
	.text
	.core
	.p2align 1
	.globl c_OTHER_INT
	.type	c_OTHER_INT, @function
c_OTHER_INT:
	# frame: 24   24 regs
	add	$sp, -24
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	sw	$tp, 20($sp)
	sw	$gp, 16($sp)
	ldc	$11, $lp
	sw	$11, 4($sp)
	mov	$5, $tp
	mov	$6, $gp
	di
	mov	$tp, $5
	mov	$gp, $6
	bsr	debug_regdump
	ldc	$2, $exc
	ldc	$3, $epc
	movu	$1, .LC7
	mov	$tp, $5
	mov	$gp, $6
	bsr	debug_printFormat
	halt
.L10:
	bra	.L10
	.size	c_OTHER_INT, .-c_OTHER_INT
	.section	.rodata
	.p2align 2
.LC8:
	.string	"[BOB] UNK EXCEPTION: %X @ %X\n"
	.text
	.core
	.p2align 1
	.globl c_OTHER_EXC
	.type	c_OTHER_EXC, @function
c_OTHER_EXC:
	# frame: 24   24 regs
	add	$sp, -24
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	sw	$tp, 20($sp)
	sw	$gp, 16($sp)
	ldc	$11, $lp
	sw	$11, 4($sp)
	mov	$5, $tp
	mov	$6, $gp
	di
	mov	$tp, $5
	mov	$gp, $6
	bsr	debug_regdump
	ldc	$2, $exc
	ldc	$3, $epc
	movu	$1, .LC8
	mov	$tp, $5
	mov	$gp, $6
	bsr	debug_printFormat
	halt
.L12:
	bra	.L12
	.size	c_OTHER_EXC, .-c_OTHER_EXC
	.section	.rodata
	.p2align 2
.LC9:
	.string	"[BOB] PANIC: %s | %X\n"
	.text
	.core
	.p2align 1
	.globl PANIC
	.type	PANIC, @function
PANIC:
	# frame: 32   24 regs   8 locals
	add	$sp, -32
	sw	$5, 20($sp)
	sw	$6, 16($sp)
	sw	$tp, 28($sp)
	sw	$gp, 24($sp)
	ldc	$11, $lp
	sw	$11, 12($sp)
	mov	$5, $tp
	mov	$6, $gp
	sw	$1, 4($sp)
	sw	$2, ($sp)
	di
	mov	$tp, $5
	mov	$gp, $6
	bsr	debug_regdump
	lw	$3, ($sp)
	lw	$2, 4($sp)
	movu	$1, .LC9
	mov	$tp, $5
	mov	$gp, $6
	bsr	debug_printFormat
	halt
.L14:
	bra	.L14
	.size	PANIC, .-PANIC
	.section	.rodata
	.p2align 2
.LC10:
	.string	"[BOB] GOT DBG INTERRUPT\n"
	.text
	.core
	.p2align 1
	.globl c_DBG
	.type	c_DBG, @function
c_DBG:
	# frame: 16   16 regs
	add	$sp, -16
	sw	$tp, 12($sp)
	sw	$gp, 8($sp)
	ldc	$11, $lp
	sw	$11, 4($sp)
	movu	$2, .LC10
	mov	$1, 1
	bsr	uart_print
	nop
	lw	$gp, 8($sp)
	lw	$tp, 12($sp)
	lw	$11, 4($sp)
	add	$sp, 16
	jmp	$11
	.size	c_DBG, .-c_DBG
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
