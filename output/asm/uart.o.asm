	.file	"uart.c"
	.globl g_uart_bus
	.section .far,"aw"
	.p2align 2
	.type	g_uart_bus, @object
	.size	g_uart_bus, 4
g_uart_bus:
	.zero	4
	.text
	.core
	.p2align 1
	.globl uart_init
	.type	uart_init, @function
uart_init:
	# frame: 32   32 regs
	add	$sp, -32
	sll3	$0, $1, 16
	movh	$3, 0xe203
	sw	$5, 20($sp)
	add3	$5, $0, $3
	movh	$3, 0x38c4
	sw	$6, 16($sp)
	or3	$3, $3, 0x1400
	add3	$6, $1, 72
	ldc	$11, $lp
	sw	$7, 12($sp)
	sw	$8, 8($sp)
	add3	$7, $1, $3
	mov	$8, $2
	mov	$4, 0
	mov	$3, 1
	mov	$2, 1
	mov	$1, $6
	sw	$11, 4($sp)
	bsr	pervasive_control_gate
	mov	$3, 0
	mov	$2, 1
	mov	$1, $6
	mov	$4, 0
	bsr	pervasive_control_reset
	sll	$7, 2
	mov	$3, 0
	mov	$2, 3
	sw	$3, 4($5)
	mov	$1, 771 # 0x303
	sw	$8, ($7)
	sw	$2, 32($5)
	mov	$2, 1
	sw	$2, 16($5)
	sw	$3, 48($5)
	sw	$1, 96($5)
	sw	$3, 64($5)
	sw	$3, 80($5)
	movu	$3, 65537
	sw	$3, 100($5)
	sw	$2, 4($5)
.L2:
	lw	$3, 40($5)
	and3	$3, $3, 0x200
	beqz	$3, .L3
	lw	$8, 8($sp)
	lw	$7, 12($sp)
	lw	$6, 16($sp)
	lw	$5, 20($sp)
	lw	$11, 4($sp)
	add3	$sp, $sp, 32
	jmp	$11
.L3:
#APP
;# 29 "source/uart.c" 1
	syncm

;# 0 "" 2
#NO_APP
	bra	.L2
	.size	uart_init, .-uart_init
	.p2align 1
	.globl uart_write
	.type	uart_write, @function
uart_write:
	sll3	$0, $1, 16
	movh	$3, 0xe203
	add3	$0, $0, $3
.L5:
	lw	$3, 40($0)
	and3	$3, $3, 0x100
	beqz	$3, .L6
	sw	$2, 112($0)
	ret
.L6:
#APP
;# 36 "source/uart.c" 1
	syncm

;# 0 "" 2
#NO_APP
	bra	.L5
	.size	uart_write, .-uart_write
	.p2align 1
	.globl uart_read
	.type	uart_read, @function
uart_read:
	sll3	$0, $1, 16
	movh	$1, 0xe203
	add3	$0, $0, $1
	mov	$1, -1 # 0xffff
.L8:
	lw	$9, 104($0)
	and3	$9, $9, 0x3f
	bnez	$9, .L9
	bnez	$3, .L10
	add	$2, -1
	bne	$2, $1, .L10
.L9:
	lw	$3, 120($0)
	movh	$0, 0x8000
	and3	$3, $3, 0xff
	beqz	$9, .L11
	mov	$0, 0
.L11:
	or	$0, $3
	ret
.L10:
#APP
;# 47 "source/uart.c" 1
	syncm

;# 0 "" 2
#NO_APP
	bra	.L8
	.size	uart_read, .-uart_read
	.p2align 1
	.globl uart_rxfifo_flush
	.type	uart_rxfifo_flush, @function
uart_rxfifo_flush:
	sll3	$0, $1, 16
	movh	$2, 0xe203
	add3	$0, $0, $2
.L14:
	lw	$2, 104($0)
	and3	$2, $2, 0x3f
	bnez	$2, .L15
	and3	$0, $3, 0xff
	ret
.L15:
	lw	$3, 120($0)
	bra	.L14
	.size	uart_rxfifo_flush, .-uart_rxfifo_flush
	.p2align 1
	.globl uart_print
	.type	uart_print, @function
uart_print:
	# frame: 24   24 regs
	add	$sp, -24
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	ldc	$11, $lp
	mov	$6, $1
	mov	$5, $2
	sw	$11, 4($sp)
.L17:
	lb	$3, ($5)
	bnez	$3, .L19
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, 4($sp)
	add	$sp, 24
	jmp	$11
.L19:
	bnei	$3, 10, .L18
	mov	$2, 13
	mov	$1, $6
	bsr	uart_write
.L18:
	add	$5, 1
	lb	$2, -1($5)
	mov	$1, $6
	bsr	uart_write
	bra	.L17
	.size	uart_print, .-uart_print
	.p2align 1
	.globl uart_printn
	.type	uart_printn, @function
uart_printn:
	# frame: 24   24 regs
	add	$sp, -24
	sw	$5, 12($sp)
	sw	$6, 8($sp)
	sw	$7, 4($sp)
	ldc	$11, $lp
	mov	$6, $1
	mov	$5, $2
	add3	$7, $2, $3
	sw	$11, ($sp)
.L21:
	beq	$5, $7, .L20
	lb	$3, ($5)
	bnez	$3, .L24
.L20:
	lw	$7, 4($sp)
	lw	$6, 8($sp)
	lw	$5, 12($sp)
	lw	$11, ($sp)
	add	$sp, 24
	jmp	$11
.L24:
	bnei	$3, 10, .L22
	mov	$2, 13
	mov	$1, $6
	bsr	uart_write
.L22:
	add	$5, 1
	lb	$2, -1($5)
	mov	$1, $6
	bsr	uart_write
	bra	.L21
	.size	uart_printn, .-uart_printn
	.p2align 1
	.globl uart_scann
	.type	uart_scann, @function
uart_scann:
	# frame: 40   32 regs   8 locals
	add3	$sp, $sp, -40 # 0xffd8
	sw	$5, 28($sp)
	sw	$6, 24($sp)
	sw	$7, 20($sp)
	sw	$8, 16($sp)
	ldc	$11, $lp
	mov	$9, $1
	mov	$6, $2
	mov	$8, $3
	mov	$7, $4
	mov	$5, $2
	sltu3	$10, $4, 1
	sw	$11, 12($sp)
.L26:
	mov	$0, $5
	sub	$0, $6
	slt3	$0, $0, $8
	bnez	$0, .L28
.L25:
	lw	$8, 16($sp)
	lw	$7, 20($sp)
	lw	$6, 24($sp)
	lw	$5, 28($sp)
	lw	$11, 12($sp)
	add3	$sp, $sp, 40
	jmp	$11
.L28:
	mov	$3, $10
	mov	$1, $9
	mov	$2, $7
	sw	$9, 4($sp)
	sw	$10, ($sp)
	bsr	uart_read
	lw	$9, 4($sp)
	lw	$10, ($sp)
	blti	$0, 0, .L29
	sb	$0, ($5)
	add	$5, 1
	bra	.L26
.L29:
	mov	$0, -1 # 0xffff
	bra	.L25
	.size	uart_scann, .-uart_scann
	.p2align 1
	.globl uart_scanns
	.type	uart_scanns, @function
uart_scanns:
	# frame: 40   32 regs   8 locals
	add3	$sp, $sp, -40 # 0xffd8
	sw	$5, 28($sp)
	sw	$6, 24($sp)
	sw	$7, 20($sp)
	sw	$8, 16($sp)
	ldc	$11, $lp
	mov	$9, $1
	mov	$8, $3
	mov	$7, $4
	mov	$6, $2
	mov	$5, 0
	sltu3	$10, $4, 1
	sw	$11, 12($sp)
.L31:
	slt3	$0, $5, $8
	beqz	$0, .L36
	mov	$3, $10
	mov	$1, $9
	mov	$2, $7
	sw	$9, 4($sp)
	sw	$10, ($sp)
	bsr	uart_read
	lw	$9, 4($sp)
	lw	$10, ($sp)
	bgei	$0, 0, .L32
.L36:
	mov	$0, -1 # 0xffff
.L30:
	lw	$8, 16($sp)
	lw	$7, 20($sp)
	lw	$6, 24($sp)
	lw	$5, 28($sp)
	lw	$11, 12($sp)
	add3	$sp, $sp, 40
	jmp	$11
.L32:
	extb	$0
	sb	$0, ($6)
	bnei	$0, 10, .L34
	beqz	$5, .L34
	lb	$3, -1($6)
	beqi	$3, 13, .L37
.L34:
	add	$5, 1
	add	$6, 1
	bra	.L31
.L37:
	mov	$0, 0
	bra	.L30
	.size	uart_scanns, .-uart_scanns
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
