	.file	"perv.c"
	.text
	.core
	.p2align 1
	.globl pervasive_control_reset
	.type	pervasive_control_reset, @function
pervasive_control_reset:
	movh	$0, 0x38c4
	or3	$0, $0, 0x400
	add3	$1, $1, $0
	sll	$1, 2
	beqz	$3, .L2
	lw	$0, ($1)
	or	$0, $2
	sw	$0, ($1)
.L3:
	syncm
	lw	$0, ($1)
	beqz	$4, .L4
	beqz	$3, .L5
	erepeat	.L15
	lw	$3, ($1)
.L15:
	and	$3, $2
	beq	$2, $3, .L16
	# erepeat end
.L16:
.L4:
	lw	$0, ($1)
	ret
.L2:
	lw	$9, ($1)
	mov	$0, $2
	nor	$0, $0
	and	$0, $9
	sw	$0, ($1)
	bra	.L3
.L5:
	erepeat	.L17
	lw	$3, ($1)
.L17:
	and	$3, $2
	beqz	$3, .L18
	# erepeat end
.L18:
	bra	.L4
	.size	pervasive_control_reset, .-pervasive_control_reset
	.p2align 1
	.globl pervasive_control_gate
	.type	pervasive_control_gate, @function
pervasive_control_gate:
	movh	$0, 0x38c4
	or3	$0, $0, 0x800
	add3	$1, $1, $0
	sll	$1, 2
	beqz	$3, .L20
	lw	$0, ($1)
	or	$0, $2
	sw	$0, ($1)
.L21:
	syncm
	lw	$0, ($1)
	beqz	$4, .L22
	beqz	$3, .L23
	erepeat	.L33
	lw	$3, ($1)
.L33:
	and	$3, $2
	beq	$2, $3, .L34
	# erepeat end
.L34:
.L22:
	lw	$0, ($1)
	ret
.L20:
	lw	$9, ($1)
	mov	$0, $2
	nor	$0, $0
	and	$0, $9
	sw	$0, ($1)
	bra	.L21
.L23:
	erepeat	.L35
	lw	$3, ($1)
.L35:
	and	$3, $2
	beqz	$3, .L36
	# erepeat end
.L36:
	bra	.L22
	.size	pervasive_control_gate, .-pervasive_control_gate
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
