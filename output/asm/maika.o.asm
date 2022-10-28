	.file	"maika.c"
	.text
	.core
	.p2align 1
	.globl readAs
	.type	readAs, @function
readAs:
	movh	$3, 0xe002
	or3	$3, $3, 0x40
	sw	$1, ($3)
	movh	$1, 0xdead
	or3	$1, $1, 0xbabe
	sw	$1, 4($3)
	sw	$2, 8($3)
	erepeat	.L4
	nop
.L4:
	lw	$2, 4($3)
	bne	$2, $1, .L5
	# erepeat end
.L5:
	lw	$0, 4($3)
	ret
	.size	readAs, .-readAs
	.p2align 1
	.globl writeAs
	.type	writeAs, @function
writeAs:
	movh	$0, 0xe002
	or3	$0, $0, 0x40
	or3	$3, $3, 0x1
	sw	$1, ($0)
	sw	$2, 4($0)
	sw	$3, 8($0)
	ret
	.size	writeAs, .-writeAs
	.p2align 1
	.globl keyring_slot_data
	.type	keyring_slot_data, @function
keyring_slot_data:
	# frame: 16   16 regs
	add	$sp, -16
	ldc	$11, $lp
	sw	$5, 4($sp)
	sw	$11, ($sp)
	mov	$0, $2
	mov	$5, $4
	beqz	$1, .L8
	movh	$1, 0xe003
	bsr	memcpy
	movh	$3, 0xe003
	sw	$5, 32($3)
.L9:
	movh	$3, 0xe003
	lw	$5, 4($sp)
	lw	$0, 44($3)
	lw	$11, ($sp)
	add	$sp, 16
	jmp	$11
.L8:
	movh	$1, 0x700
	or3	$1, $1, 0x2c00
	add3	$2, $4, $1
	sll	$2, 5
	mov	$1, $0
	bsr	memcpy
	bra	.L9
	.size	keyring_slot_data, .-keyring_slot_data
	.p2align 1
	.globl keyring_slot_prot
	.type	keyring_slot_prot, @function
keyring_slot_prot:
	beqz	$1, .L11
	sll	$2, 16
	or	$2, $3
	movh	$1, 0xe003
	sw	$2, 36($1)
.L11:
	movh	$2, 0xe003
	sw	$3, 40($2)
	lw	$0, 44($2)
	ret
	.size	keyring_slot_prot, .-keyring_slot_prot
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
