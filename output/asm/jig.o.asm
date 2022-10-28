	.file	"jig.c"
	.section .sbss,"aw"
	.p2align 1
	.type	l_current_request_no,@object
	.size	l_current_request_no,2
l_current_request_no:
	.zero	2
	.text
	.core
	.p2align 1
	.globl jig_update_shared_buffer
	.type	jig_update_shared_buffer, @function
jig_update_shared_buffer:
	# frame: 72   32 regs   36 locals
	extub	$2
	mov	$0, 63
	add3	$sp, $sp, -72 # 0xffb8
	ldc	$11, $lp
	sltu3	$0, $0, $2
	sw	$5, 60($sp)
	sw	$6, 56($sp)
	sw	$7, 52($sp)
	sw	$8, 48($sp)
	sw	$11, 44($sp)
	mov	$6, $1
	and3	$5, $3, 255
	mov	$7, $4
	bnez	$0, .L8
	mov	$0, 64
	sltu3	$0, $0, $5
	bnez	$0, .L8
	add3	$2, $2, $5
	slt3	$2, $2, 65
	beqz	$2, .L8
	mov	$8, 0
	mov	$2, -1 # 0xffff
.L3:
	add3	$9, $8, 24
	sltu3	$0, $5, $9
	beqz	$0, .L4
	sltu3	$0, $8, $5
	beqz	$0, .L5
	mov	$3, 27
	mov	$2, 0
	add3	$1, $sp, 13
	bsr	memset
	mov	$3, $5
	sub	$3, $8
	and3	$9, $3, 255
	add3	$2, $6, $8
	add3	$1, $sp, 16
	sb	$9, 15($sp)
	sw	$9, 4($sp)
	sb	$8, 14($sp)
	bsr	memcpy
	lw	$9, 4($sp)
	add3	$2, $sp, 13
	mov	$1, 8325 # 0x2085
	add3	$3, $9, 3
	bsr	ernie_exec_cmd
	mov	$2, $0
.L5:
	beqz	$7, .L1
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
.L4:
	mov	$3, 27
	mov	$2, 0
	add3	$1, $sp, 13
	sw	$9, 4($sp)
	bsr	memset
	mov	$3, 24
	add3	$2, $6, $8
	sb	$3, 15($sp)
	add3	$1, $sp, 16
	mov	$3, 24
	sb	$8, 14($sp)
	bsr	memcpy
	add3	$2, $sp, 13
	mov	$3, 27
	mov	$1, 8325 # 0x2085
	bsr	ernie_exec_cmd
	lw	$9, 4($sp)
	mov	$2, $0
	and3	$8, $9, 255
	bra	.L3
.L8:
	mov	$2, -1 # 0xffff
	bra	.L1
	.size	jig_update_shared_buffer, .-jig_update_shared_buffer
	.p2align 1
	.globl jig_read_shared_buffer
	.type	jig_read_shared_buffer, @function
jig_read_shared_buffer:
	# frame: 72   32 regs   36 locals
	extub	$2
	mov	$0, 63
	add3	$sp, $sp, -72 # 0xffb8
	ldc	$11, $lp
	sltu3	$0, $0, $2
	sw	$5, 60($sp)
	sw	$6, 56($sp)
	sw	$7, 52($sp)
	sw	$8, 48($sp)
	sw	$11, 44($sp)
	mov	$6, $1
	and3	$5, $3, 255
	bnez	$0, .L18
	mov	$0, 64
	sltu3	$0, $0, $5
	bnez	$0, .L18
	add3	$2, $2, $5
	slt3	$2, $2, 65
	beqz	$2, .L18
	mov	$3, $5
	mov	$2, 0
	bsr	memset
	mov	$7, 0
	mov	$8, -1 # 0xffff
.L14:
	add3	$9, $7, 24
	sltu3	$0, $5, $9
	beqz	$0, .L15
	sltu3	$0, $7, $5
	beqz	$0, .L12
	mov	$3, 26
	mov	$2, 0
	add3	$1, $sp, 14
	bsr	memset
	sub	$5, $7
	mov	$3, 2
	add3	$2, $sp, 14
	mov	$1, 8323 # 0x2083
	sb	$7, 14($sp)
	sb	$5, 15($sp)
	bsr	ernie_exec_cmd
	mov	$8, $0
	mov	$3, $5
	movu	$2, g_ernie_comms+36
	add3	$1, $6, $7
	bsr	memcpy
.L12:
	mov	$0, $8
	lw	$7, 52($sp)
	lw	$8, 48($sp)
	lw	$6, 56($sp)
	lw	$5, 60($sp)
	lw	$11, 44($sp)
	add3	$sp, $sp, 72
	jmp	$11
.L15:
	mov	$3, 26
	mov	$2, 0
	add3	$1, $sp, 14
	sw	$9, 4($sp)
	bsr	memset
	mov	$3, 24
	sb	$3, 15($sp)
	add3	$2, $sp, 14
	mov	$3, 2
	mov	$1, 8323 # 0x2083
	sb	$7, 14($sp)
	bsr	ernie_exec_cmd
	mov	$8, $0
	add3	$1, $6, $7
	mov	$3, 24
	movu	$2, g_ernie_comms+36
	bsr	memcpy
	lw	$9, 4($sp)
	and3	$7, $9, 255
	bra	.L14
.L18:
	mov	$8, -1 # 0xffff
	bra	.L12
	.size	jig_read_shared_buffer, .-jig_read_shared_buffer
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
