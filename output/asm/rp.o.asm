	.file	"rp.c"
	.globl g_rpc_status
	.section .far,"aw"
	.p2align 2
	.type	g_rpc_status, @object
	.size	g_rpc_status, 4
g_rpc_status:
	.zero	4
	.section	.rodata
	.p2align 2
.LC0:
	.string	"[BOB] RPC CMD %X\n"
	.p2align 2
.LC1:
	.string	"[BOB] RPC EXEC %X\n"
	.p2align 2
.LC2:
	.string	"[BOB] RPC EXECE %X\n"
	.p2align 2
.LC3:
	.string	"[BOB] RPC RET %X\n"
	.text
	.core
	.p2align 1
	.type	rpc_handle_cmd, @function
rpc_handle_cmd:
	# frame: 56   32 regs   4 locals   16 args
	add3	$sp, $sp, -56 # 0xffc8
	sw	$6, 40($sp)
	and3	$6, $1, 255
	sw	$5, 44($sp)
	sw	$8, 32($sp)
	ldc	$11, $lp
	mov	$8, $3
	mov	$5, $2
	movu	$1, .LC0
	mov	$2, $6
	sw	$7, 36($sp)
	sw	$11, 28($sp)
	mov	$7, $4
	bsr	debug_printFormat
	movh	$3, %hi(g_rpc_status)
	add3	$3, $3, %lo(g_rpc_status)
	lw	$2, ($3)
	or3	$2, $2, 0x4
	sw	$2, ($3)
	beqi	$6, 10, .L3
	mov	$0, 10
	sltu3	$0, $0, $6
	bnez	$0, .L4
	beqi	$6, 4, .L5
	mov	$0, 4
	sltu3	$0, $0, $6
	bnez	$0, .L6
	beqi	$6, 1, .L7
	beqz	$6, .L8
	beqi	$6, 2, .L9
	beqi	$6, 3, .L10
.L35:
	mov	$6, 0
	mov	$0, -1 # 0xffff
	bra	.L2
.L6:
	beqi	$6, 7, .L11
	mov	$0, 7
	sltu3	$0, $0, $6
	bnez	$0, .L12
	beqi	$6, 5, .L13
	bnei	$6, 6, .L35
.L39:
	mov	$6, 0
	mov	$0, 0
	bra	.L2
.L12:
	beqi	$6, 8, .L15
	bnei	$6, 9, .L35
	lw	$3, 8($5)
	lw	$2, 4($5)
	lw	$1, ($5)
	mov	$6, 0
	bsr	memset32
	bra	.L2
.L4:
	mov	$0, 64
	beq	$6, $0, .L17
	sltu3	$0, $0, $6
	bnez	$0, .L18
	beqi	$6, 13, .L19
	mov	$0, 13
	sltu3	$0, $0, $6
	bnez	$0, .L20
	beqi	$6, 11, .L21
	bnei	$6, 12, .L35
	lw	$3, ($5)
	beqz	$3, .L33
	lw	$3, 4($5)
	beqz	$3, .L34
	bsr	setup_ints
.L34:
	ei
	mov	$6, 0
	mov	$0, 0
	bra	.L2
.L20:
	beqi	$6, 14, .L23
	bnei	$6, 15, .L35
	lbu	$3, 13($7)
	lbu	$2, 12($7)
	lbu	$0, 14($7)
	mov	$6, 0
	sll	$3, 8
	or	$2, $3
	lbu	$3, 15($7)
	sll	$0, 16
	or	$0, $2
	sll	$3, 24
	or	$0, $3
	lbu	$3, ($5)
	sb	$3, 12($7)
	lbu	$3, 1($5)
	sb	$3, 13($7)
	lbu	$3, 2($5)
	sb	$3, 14($7)
	lw	$3, ($5)
	srl	$3, 24
	sb	$3, 15($7)
	lw	$3, 4($5)
	mov	$2, $3
	sb	$3, 16($7)
	srl	$2, 8
	sb	$2, 17($7)
	mov	$2, $3
	srl	$3, 24
	srl	$2, 16
	sb	$2, 18($7)
	sb	$3, 19($7)
	bra	.L2
.L18:
	mov	$0, 67
	beq	$6, $0, .L25
	sltu3	$0, $0, $6
	bnez	$0, .L26
	mov	$3, 65
	beq	$6, $3, .L27
	mov	$3, 66
	bne	$6, $3, .L35
	lw	$6, ($5)
	movu	$1, .LC1
	mov	$2, $6
	bsr	debug_printFormat
	lw	$2, 8($5)
	lw	$1, 4($5)
	mov	$3, $8
	jsr	$6
	mov	$6, 0
	bra	.L2
.L26:
	mov	$3, 68
	beq	$6, $3, .L29
	mov	$3, 69
	bne	$6, $3, .L35
	lw	$3, 12($8)
	lw	$2, 4($5)
	lw	$1, ($5)
	sw	$3, 8($sp)
	lw	$3, 8($8)
	mov	$6, 0
	sw	$3, 4($sp)
	lw	$3, 4($8)
	sw	$3, ($sp)
	lw	$4, ($8)
	lw	$3, 8($5)
	bsr	alice_loadAlice
	bra	.L2
.L8:
	bsr	get_build_timestamp
.L2:
	movh	$3, %hi(g_rpc_status)
	add3	$3, $3, %lo(g_rpc_status)
	mov	$1, -5 # 0xfffb
	lw	$2, ($3)
	and	$2, $1
	sw	$2, ($3)
	movu	$1, .LC3
	mov	$2, $0
	sw	$0, 20($sp)
	bsr	debug_printFormat
	lw	$0, 20($sp)
	lw	$8, 32($sp)
	lw	$7, 36($sp)
	sw	$0, ($5)
	lw	$11, 28($sp)
	mov	$0, $6
	lw	$5, 44($sp)
	lw	$6, 40($sp)
	add3	$sp, $sp, 56
	jmp	$11
.L7:
	lw	$2, 8($5)
	bgei	$2, 0, .L31
	movh	$1, 0x7fff
	or3	$1, $1, 0xffff
	and	$2, $1
	lw	$1, ($5)
	mov	$6, 0
	bsr	readAs
	bra	.L2
.L31:
	lw	$3, ($5)
	mov	$6, 0
	lw	$0, ($3)
	bra	.L2
.L9:
	lw	$3, 8($5)
	lw	$2, 4($5)
	bgei	$3, 0, .L32
	movh	$1, 0x7fff
	or3	$1, $1, 0xffff
	and	$3, $1
	lw	$1, ($5)
	bsr	writeAs
	bra	.L39
.L32:
	lw	$3, ($5)
	mov	$6, 0
	mov	$0, 0
	sw	$2, ($3)
	bra	.L2
.L10:
	lw	$3, 8($5)
	lb	$2, 4($5)
	lw	$1, ($5)
	mov	$6, 0
	bsr	memset
	bra	.L2
.L5:
	lw	$3, 8($5)
	lw	$2, 4($5)
	lw	$1, ($5)
	mov	$6, 0
	bsr	memcpy
	bra	.L2
.L13:
	lbu	$3, 5($7)
	lbu	$2, 4($7)
	lbu	$0, 6($7)
	mov	$6, 0
	sll	$3, 8
	or	$2, $3
	lbu	$3, 7($7)
	sll	$0, 16
	or	$0, $2
	sll	$3, 24
	or	$0, $3
	lw	$3, ($5)
	mov	$2, $3
	sb	$3, 4($7)
	srl	$2, 8
	sb	$2, 5($7)
	mov	$2, $3
	srl	$3, 24
	srl	$2, 16
	sb	$2, 6($7)
	sb	$3, 7($7)
	lw	$3, 4($5)
	mov	$2, $3
	sb	$3, 8($7)
	srl	$2, 8
	sb	$2, 9($7)
	mov	$2, $3
	srl	$3, 24
	srl	$2, 16
	sb	$2, 10($7)
	sb	$3, 11($7)
	bra	.L2
.L11:
	lbu	$3, 1($7)
	lbu	$2, ($7)
	lbu	$0, 2($7)
	mov	$6, 0
	sll	$3, 8
	or	$2, $3
	lbu	$3, 3($7)
	sll	$0, 16
	or	$0, $2
	sll	$3, 24
	or	$0, $3
	lbu	$3, ($5)
	sb	$3, ($7)
	lbu	$3, 1($5)
	sb	$3, 1($7)
	lbu	$3, 2($5)
	sb	$3, 2($7)
	lw	$3, ($5)
	srl	$3, 24
	sb	$3, 3($7)
	bra	.L2
.L15:
	lw	$3, 8($5)
	lw	$2, 4($5)
	lw	$1, ($5)
	mov	$6, 0
	bsr	debug_printRange
	mov	$0, 0
	bra	.L2
.L3:
	lw	$3, 8($5)
	lw	$2, 4($5)
	lw	$1, ($5)
	mov	$6, 0
	bsr	compat_armReBoot
	mov	$0, 0
	bra	.L2
.L21:
	lw	$1, ($5)
	mov	$6, 0
	bsr	set_exception_table
	mov	$0, 0
	bra	.L2
.L33:
	di
	mov	$6, 0
	mov	$0, 0
	bra	.L2
.L19:
	mov	$3, 0
	sw	$3, 12($sp)
	sw	$3, 8($sp)
	lw	$3, 4($5)
	lw	$4, 8($5)
	mov	$2, 1
	sw	$3, 4($sp)
	lw	$3, ($5)
	mov	$1, 0
	mov	$6, 0
	sw	$3, ($sp)
	mov	$3, 1
	bsr	alice_schedule_bob_task
	bra	.L2
.L23:
	lw	$3, 8($5)
	lw	$2, 4($5)
	lw	$1, ($5)
	mov	$6, 0
	bsr	alice_get_task_status
	bra	.L2
.L17:
	lw	$3, 4($5)
	lw	$1, ($5)
	mov	$2, $8
	mov	$6, 0
	bsr	memcpy
	bra	.L2
.L27:
	lw	$3, 4($5)
	lw	$2, ($5)
	mov	$1, $8
	bsr	memcpy
	lbu	$6, 4($5)
	bra	.L2
.L25:
	lw	$6, ($5)
	movu	$1, .LC2
	mov	$2, $6
	bsr	debug_printFormat
	lw	$3, 20($8)
	lw	$2, 8($5)
	lw	$1, 4($5)
	sw	$3, 12($sp)
	lw	$3, 16($8)
	sw	$3, 8($sp)
	lw	$3, 12($8)
	sw	$3, 4($sp)
	lw	$3, 8($8)
	sw	$3, ($sp)
	lw	$4, 4($8)
	lw	$3, ($8)
	jsr	$6
	mov	$6, 0
	bra	.L2
.L29:
	lw	$3, 16($8)
	lw	$2, 4($5)
	lw	$1, ($5)
	sw	$3, 12($sp)
	lw	$3, 12($8)
	mov	$6, 0
	sw	$3, 8($sp)
	lw	$3, 8($8)
	sw	$3, 4($sp)
	lw	$3, 4($8)
	sw	$3, ($sp)
	lw	$4, ($8)
	lw	$3, 8($5)
	bsr	alice_schedule_bob_task
	bra	.L2
	.size	rpc_handle_cmd, .-rpc_handle_cmd
	.p2align 1
	.type	rpc_rxw_cmd_shbuf, @function
rpc_rxw_cmd_shbuf:
	# frame: 80   32 regs   44 locals
	add3	$sp, $sp, -80 # 0xffb0
	sw	$6, 64($sp)
	add3	$6, $sp, 8
	ldc	$11, $lp
	sw	$5, 68($sp)
	mov	$3, 40
	mov	$2, 0
	mov	$5, $1
	mov	$1, $6
	sw	$11, 52($sp)
	sw	$7, 60($sp)
	sw	$8, 56($sp)
	bsr	memset
	mov	$3, 16
	mov	$2, 0
	mov	$1, $6
	bsr	jig_read_shared_buffer
	lhu	$2, 8($sp)
	movu	$3, 0xeb0b
	bne	$2, $3, .L49
	lbu	$1, 11($sp)
	mov	$3, $1
	extb	$3
	blti	$3, 0, .L49
	mov	$7, $6
	mov	$8, $6
	mov	$3, 0
	mov	$2, 12
	repeat	$2,.L56
.L42:
	lb	$0, 3($8)
	add	$8, 1
.L56:
	add3	$3, $3, $0
	extub	$3
	# repeat end
	lbu	$2, 10($sp)
	bne	$2, $3, .L49
	and3	$1, $1, 0x40
	beqz	$1, .L43
	mov	$3, 24
	mov	$2, 16
	add3	$1, $sp, 24
	bsr	jig_read_shared_buffer
.L43:
	lb	$1, 11($sp)
	add3	$3, $sp, 24
	add3	$2, $sp, 12
	mov	$4, $5
	bsr	rpc_handle_cmd
	lb	$3, 11($sp)
	mov	$2, -128 # 0xff80
	extub	$0
	or	$3, $2
	mov	$2, $6
	sub	$2, $8
	sb	$3, 11($sp)
	nor	$2, $2
	mov	$3, 0
	sb	$3, 10($sp)
	repeat	$2,.L55
.L44:
	lb	$1, 3($7)
	lb	$3, 10($sp)
	add	$7, 1
.L55:
	add3	$3, $3, $1
	sb	$3, 10($sp)
	# repeat end
	lbu	$1, 9($5)
	lbu	$3, 8($5)
	sw	$0, 4($sp)
	sll	$1, 8
	or	$1, $3
	lbu	$3, 10($5)
	sll	$3, 16
	or	$3, $1
	lbu	$1, 11($5)
	sll	$1, 24
	or	$1, $3
	bsr	delay
	lbu	$1, 1($5)
	lbu	$2, ($5)
	lbu	$3, 2($5)
	lw	$0, 4($sp)
	sll	$1, 8
	or	$1, $2
	lbu	$2, 3($5)
	sll	$3, 16
	or	$1, $3
	sll	$2, 24
	or	$2, $1
	beqz	$2, .L45
	mov	$4, 1
	add3	$3, $0, 16
	mov	$2, 0
	mov	$1, $6
	bsr	jig_update_shared_buffer
.L46:
	lbu	$0, 11($sp)
	add3	$0, $0, -134 # 0xff7a
	sltu3	$0, $0, 1
.L40:
	lw	$8, 56($sp)
	lw	$7, 60($sp)
	lw	$6, 64($sp)
	lw	$5, 68($sp)
	lw	$11, 52($sp)
	add3	$sp, $sp, 80
	jmp	$11
.L45:
	add3	$1, $sp, 12
	mov	$4, 0
	add3	$3, $0, 12
	mov	$2, 4
	bsr	jig_update_shared_buffer
	mov	$4, 0
	mov	$3, 4
	mov	$2, 0
	mov	$1, $6
	bsr	jig_update_shared_buffer
	bra	.L46
.L49:
	mov	$0, 0
	bra	.L40
	.size	rpc_rxw_cmd_shbuf, .-rpc_rxw_cmd_shbuf
	.section	.rodata
	.p2align 2
.LC4:
	.string	"?PC_G0\n"
	.p2align 2
.LC5:
	.string	"?PC_E1\n"
	.p2align 2
.LC6:
	.string	"?PC_%X\n"
	.p2align 2
.LC7:
	.string	"?PC_G1\n"
	.text
	.core
	.p2align 1
	.type	rpc_rxw_cmd_uart, @function
rpc_rxw_cmd_uart:
	# frame: 96   24 regs   72 locals
	add3	$sp, $sp, -96 # 0xffa0
	sw	$6, 80($sp)
	movh	$6, %hi(g_uart_bus)
	ldc	$11, $lp
	sw	$5, 84($sp)
	mov	$3, 4
	mov	$5, $1
	mov	$2, 0
	add3	$1, $sp, 4
	add3	$6, $6, %lo(g_uart_bus)
	sw	$11, 72($sp)
	sw	$7, 76($sp)
	bsr	memset
	mov	$3, 64
	mov	$2, 0
	add3	$1, $sp, 8
	bsr	memset
	lw	$1, ($6)
	movu	$2, .LC4
	movh	$7, %hi(g_uart_bus)
	bsr	uart_print
	lbu	$4, 17($5)
	lbu	$3, 16($5)
	lw	$1, ($6)
	add3	$2, $sp, 4
	sll	$4, 8
	or	$4, $3
	lbu	$3, 18($5)
	sll	$3, 16
	or	$3, $4
	lbu	$4, 19($5)
	sll	$4, 24
	or	$4, $3
	mov	$3, 4
	bsr	uart_scann
	bgei	$0, 0, .L58
.L65:
	mov	$0, 0
.L57:
	lw	$7, 76($sp)
	lw	$6, 80($sp)
	lw	$5, 84($sp)
	lw	$11, 72($sp)
	add3	$sp, $sp, 96
	jmp	$11
.L58:
	lbu	$2, 4($sp)
	mov	$3, 38
	bne	$2, $3, .L60
	lbu	$3, 6($sp)
	lbu	$2, 5($sp)
	lbu	$1, 7($sp)
	add3	$2, $2, $3
	beq	$1, $2, .L61
.L60:
	lbu	$1, 9($5)
	lbu	$3, 8($5)
	add3	$7, $7, %lo(g_uart_bus)
	sll	$1, 8
	or	$1, $3
	lbu	$3, 10($5)
	sll	$3, 16
	or	$3, $1
	lbu	$1, 11($5)
	sll	$1, 24
	or	$1, $3
	bsr	delay
	lw	$1, ($7)
	movu	$2, .LC5
	bsr	uart_print
	lw	$1, ($7)
	bsr	uart_rxfifo_flush
	bra	.L65
.L61:
	add	$3, -1
	extub	$3
	sltu3	$3, $3, 64
	bnez	$3, .L62
.L64:
	lb	$1, 5($sp)
	mov	$4, $5
	add3	$2, $sp, 8
	add3	$3, $sp, 20
	bsr	rpc_handle_cmd
	lbu	$1, 9($5)
	lbu	$3, 8($5)
	sll	$1, 8
	or	$1, $3
	lbu	$3, 10($5)
	sll	$3, 16
	or	$3, $1
	lbu	$1, 11($5)
	sll	$1, 24
	or	$1, $3
	bsr	delay
	lw	$2, 8($sp)
	movu	$1, .LC6
	bsr	debug_printFormat
	lw	$1, %lo(g_uart_bus)($7)
	bsr	uart_rxfifo_flush
	lbu	$0, 5($sp)
	add	$0, -6
	sltu3	$0, $0, 1
	bra	.L57
.L62:
	lbu	$1, 9($5)
	lbu	$3, 8($5)
	sll	$1, 8
	or	$1, $3
	lbu	$3, 10($5)
	sll	$3, 16
	or	$3, $1
	lbu	$1, 11($5)
	sll	$1, 24
	or	$1, $3
	bsr	delay
	lw	$1, ($6)
	bsr	uart_rxfifo_flush
	lw	$1, ($6)
	movu	$2, .LC7
	bsr	uart_print
	lbu	$4, 17($5)
	lbu	$3, 16($5)
	lw	$1, ($6)
	add3	$2, $sp, 8
	sll	$4, 8
	or	$4, $3
	lbu	$3, 18($5)
	sll	$3, 16
	or	$3, $4
	lbu	$4, 19($5)
	sll	$4, 24
	or	$4, $3
	lbu	$3, 6($sp)
	bsr	uart_scann
	bgei	$0, 0, .L64
	bra	.L65
	.size	rpc_rxw_cmd_uart, .-rpc_rxw_cmd_uart
	.section	.rodata
	.p2align 2
.LC8:
	.string	"[BOB] RPC mode disabled, status: %X\n"
	.p2align 2
.LC9:
	.string	"[BOB] entering RPC mode, delay %X\n"
	.p2align 2
.LC10:
	.string	"[BOB] RPC blocked\n"
	.p2align 2
.LC11:
	.string	"[BOB] RPC unblocked\n"
	.p2align 2
.LC12:
	.string	"[BOB] exiting RPC mode\n"
	.text
	.core
	.p2align 1
	.globl rpc_loop
	.type	rpc_loop, @function
rpc_loop:
	# frame: 48   24 regs   24 locals
	add3	$sp, $sp, -48 # 0xffd0
	sw	$6, 32($sp)
	movh	$6, %hi(g_rpc_status)
	ldc	$11, $lp
	add3	$6, $6, %lo(g_rpc_status)
	mov	$3, 0
	sw	$5, 36($sp)
	sw	$7, 28($sp)
	sw	$11, 24($sp)
	sw	$3, 4($sp)
	sw	$3, 16($sp)
	sw	$3, 20($sp)
	lw	$3, ($6)
	mov	$2, 4096 # 0x1000
	mov	$1, 128
	sw	$2, 8($sp)
	sw	$1, 12($sp)
	movh	$5, %hi(g_rpc_status)
	bgei	$3, 0, .L67
	lw	$2, ($6)
	movu	$1, .LC8
	bsr	debug_printFormat
.L66:
	lw	$7, 28($sp)
	lw	$6, 32($sp)
	lw	$5, 36($sp)
	lw	$11, 24($sp)
	add3	$sp, $sp, 48
	jmp	$11
.L67:
	movu	$1, .LC9
	bsr	debug_printFormat
	lw	$3, ($6)
	or3	$3, $3, 0x1
	sw	$3, ($6)
	lw	$3, 16($sp)
	beqz	$3, .L76
	movh	$3, %hi(g_uart_bus)
	lw	$1, %lo(g_uart_bus)($3)
	bsr	uart_rxfifo_flush
.L76:
	lw	$1, 8($sp)
	bsr	delay
	lw	$3, %lo(g_rpc_status)($5)
	movh	$2, 0x80
	and	$3, $2
	beqz	$3, .L70
	lw	$3, %lo(g_rpc_status)($5)
	movu	$1, .LC10
	mov	$6, 10240 # 0x2800
	or3	$3, $3, 0x2
	sw	$3, %lo(g_rpc_status)($5)
	bsr	debug_printFormat
.L71:
	mov	$1, $6
	bsr	delay
	mov	$1, $6
	bsr	delay
	lw	$3, %lo(g_rpc_status)($5)
	movh	$2, 0x80
	mov	$7, $5
	and	$3, $2
	add3	$7, $7, %lo(g_rpc_status)
	bnez	$3, .L71
	movu	$1, .LC11
	bsr	debug_printFormat
	lw	$3, ($7)
	mov	$2, -3 # 0xfffd
	and	$3, $2
	sw	$3, ($7)
.L70:
	lw	$3, 16($sp)
	bnez	$3, .L72
.L75:
	add3	$1, $sp, 4
	bsr	rpc_rxw_cmd_shbuf
	beqz	$0, .L87
.L73:
	add3	$5, $5, %lo(g_rpc_status)
	mov	$2, -256 # 0xff00
	lw	$3, ($5)
	movu	$1, .LC12
	and	$3, $2
	sw	$3, ($5)
	bsr	debug_printFormat
	bra	.L66
.L72:
	add3	$1, $sp, 4
	bsr	rpc_rxw_cmd_uart
	beqz	$0, .L75
	bra	.L73
.L87:
	lw	$3, %lo(g_rpc_status)($5)
	and3	$3, $3, 0x8000
	beqz	$3, .L76
	bra	.L73
	.size	rpc_loop, .-rpc_loop
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
