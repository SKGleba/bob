	.file	"jig.c"
	.text
	.core
	.p2align 1
	.globl jig_update_shared_buffer
	.type	jig_update_shared_buffer, @function
jig_update_shared_buffer:
	# frame: 72   32 regs   40 locals
	add3	$sp, $sp, -72 # 0xffb8
	sw	$6, 56($sp)
	mov	$0, 39
	and3	$6, $2, 255
	ldc	$11, $lp
	sltu3	$0, $0, $6
	sw	$5, 60($sp)
	sw	$7, 52($sp)
	sw	$8, 48($sp)
	sw	$11, 44($sp)
	mov	$7, $1
	and3	$5, $3, 255
	sw	$4, 4($sp)
	bnez	$0, .L8
	mov	$0, 40
	sltu3	$0, $0, $5
	bnez	$0, .L8
	add3	$3, $6, $5
	slt3	$3, $3, 41
	beqz	$3, .L8
	beqz	$1, .L9
	mov	$8, 0
	mov	$2, -1 # 0xffff
.L4:
	add3	$10, $8, 24
	sltu3	$0, $5, $10
	beqz	$0, .L5
	sltu3	$0, $8, $5
	beqz	$0, .L3
	mov	$3, 27
	mov	$2, 0
	add3	$1, $sp, 13
	bsr	memset
	mov	$3, $5
	sub	$3, $8
	add3	$6, $8, $6
	sb	$6, 14($sp)
	add3	$2, $7, $8
	and3	$6, $3, 255
	add3	$1, $sp, 16
	sb	$6, 15($sp)
	bsr	memcpy
	add3	$2, $sp, 13
	add3	$3, $6, 3
	mov	$1, 8325 # 0x2085
	bsr	ernie_exec_cmd
	mov	$2, $0
.L3:
	lw	$3, 4($sp)
	beqz	$3, .L1
	mov	$3, 27
	mov	$2, 0
	add3	$1, $sp, 13
	bsr	memset
	mov	$3, 1
	sb	$3, 13($sp)
	add3	$2, $sp, 13
	mov	$3, 3
	mov	$1, 8325 # 0x2085
	sb	$5, 15($sp)
	bsr	ernie_exec_cmd
	mov	$2, $0
.L1:
	mov	$0, $2
	lw	$8, 48($sp)
	lw	$7, 52($sp)
	lw	$6, 56($sp)
	lw	$5, 60($sp)
	lw	$11, 44($sp)
	add3	$sp, $sp, 72
	jmp	$11
.L5:
	mov	$3, 27
	mov	$2, 0
	add3	$1, $sp, 13
	sw	$10, ($sp)
	bsr	memset
	add3	$3, $8, $6
	sb	$3, 14($sp)
	mov	$3, 24
	add3	$2, $7, $8
	sb	$3, 15($sp)
	add3	$1, $sp, 16
	mov	$3, 24
	bsr	memcpy
	add3	$2, $sp, 13
	mov	$3, 27
	mov	$1, 8325 # 0x2085
	bsr	ernie_exec_cmd
	lw	$10, ($sp)
	mov	$2, $0
	and3	$8, $10, 255
	bra	.L4
.L9:
	mov	$2, -1 # 0xffff
	bra	.L3
.L8:
	mov	$2, -1 # 0xffff
	bra	.L1
	.size	jig_update_shared_buffer, .-jig_update_shared_buffer
	.p2align 1
	.globl jig_read_shared_buffer
	.type	jig_read_shared_buffer, @function
jig_read_shared_buffer:
	# frame: 72   32 regs   40 locals
	add3	$sp, $sp, -72 # 0xffb8
	sw	$6, 56($sp)
	mov	$0, 39
	and3	$6, $2, 255
	ldc	$11, $lp
	sltu3	$0, $0, $6
	sw	$5, 60($sp)
	sw	$7, 52($sp)
	sw	$8, 48($sp)
	sw	$11, 44($sp)
	sw	$1, 4($sp)
	and3	$5, $3, 255
	bnez	$0, .L19
	mov	$0, 40
	sltu3	$0, $0, $5
	bnez	$0, .L19
	add3	$3, $6, $5
	slt3	$3, $3, 41
	beqz	$3, .L19
	mov	$3, $5
	mov	$2, 0
	bsr	memset
	mov	$7, -1 # 0xffff
	mov	$8, 0
.L15:
	add3	$10, $8, 24
	sltu3	$0, $5, $10
	beqz	$0, .L16
	sltu3	$0, $8, $5
	beqz	$0, .L13
	mov	$3, 26
	mov	$2, 0
	add3	$1, $sp, 14
	bsr	memset
	sub	$5, $8
	mov	$3, 2
	add3	$2, $sp, 14
	mov	$1, 8323 # 0x2083
	add3	$6, $8, $6
	sb	$6, 14($sp)
	sb	$5, 15($sp)
	bsr	ernie_exec_cmd
	mov	$7, $0
	lw	$0, 4($sp)
	movh	$2, %hi(g_ernie_comms+36)
	mov	$3, $5
	add3	$2, $2, %lo(g_ernie_comms+36)
	add3	$1, $0, $8
	bsr	memcpy
.L13:
	mov	$0, $7
	lw	$8, 48($sp)
	lw	$7, 52($sp)
	lw	$6, 56($sp)
	lw	$5, 60($sp)
	lw	$11, 44($sp)
	add3	$sp, $sp, 72
	jmp	$11
.L16:
	mov	$3, 26
	mov	$2, 0
	add3	$1, $sp, 14
	sw	$10, ($sp)
	bsr	memset
	add3	$3, $8, $6
	sb	$3, 14($sp)
	mov	$3, 24
	sb	$3, 15($sp)
	add3	$2, $sp, 14
	mov	$3, 2
	mov	$1, 8323 # 0x2083
	bsr	ernie_exec_cmd
	mov	$7, $0
	lw	$0, 4($sp)
	movh	$2, %hi(g_ernie_comms+36)
	mov	$3, 24
	add3	$1, $0, $8
	add3	$2, $2, %lo(g_ernie_comms+36)
	bsr	memcpy
	lw	$10, ($sp)
	and3	$8, $10, 255
	bra	.L15
.L19:
	mov	$7, -1 # 0xffff
	bra	.L13
	.size	jig_read_shared_buffer, .-jig_read_shared_buffer
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
