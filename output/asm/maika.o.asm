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
	movh	$0, 0xe002
	movh	$3, 0xe002
	movh	$1, 0xdead
	or3	$3, $3, 0x44
	or3	$1, $1, 0xbabe
	or3	$0, $0, 0x48
	sw	$1, ($3)
	sw	$2, ($0)
	erepeat	.L4
	nop
.L4:
	lw	$2, ($3)
	bne	$2, $1, .L5
	# erepeat end
.L5:
	lw	$0, ($3)
	ret
	.size	readAs, .-readAs
	.p2align 1
	.globl writeAs
	.type	writeAs, @function
writeAs:
	movh	$0, 0xe002
	or3	$0, $0, 0x40
	sw	$1, ($0)
	movh	$1, 0xe002
	or3	$1, $1, 0x44
	sw	$2, ($1)
	movh	$2, 0xe002
	or3	$3, $3, 0x1
	or3	$2, $2, 0x48
	sw	$3, ($2)
	ret
	.size	writeAs, .-writeAs
	.p2align 1
	.globl keyring_slot_data
	.type	keyring_slot_data, @function
keyring_slot_data:
	# frame: 24   24 regs
	add	$sp, -24
	ldc	$11, $lp
	slt3	$9, $3, 33
	sw	$5, 12($sp)
	mov	$10, $1
	sw	$6, 8($sp)
	sw	$11, 4($sp)
	mov	$1, $2
	mov	$5, $4
	beqz	$9, .L11
	mov	$0, 2048 # 0x800
	sltu3	$0, $0, $4
	bnez	$0, .L11
	bnez	$10, .L9
	sltu3	$2, $4, 1024
	bnez	$2, .L12
	mov	$2, $4
	movh	$0, 0xe005
	sll	$2, 5
	or3	$0, $0, 0x8000
	add3	$2, $2, $0
	add3	$6, $4, -1024 # 0xfc00
	bsr	memcpy
.L7:
	mov	$0, $6
	lw	$5, 12($sp)
	lw	$6, 8($sp)
	lw	$11, 4($sp)
	add	$sp, 24
	jmp	$11
.L9:
	movh	$1, 0xe003
	bsr	memcpy
	movh	$3, 0xe003
	or3	$3, $3, 0x20
	sw	$5, ($3)
	movh	$3, 0xe003
	or3	$3, $3, 0x2c
	lw	$6, ($3)
	bra	.L7
.L11:
	mov	$6, -1 # 0xffff
	bra	.L7
.L12:
	mov	$6, -2 # 0xfffe
	bra	.L7
	.size	keyring_slot_data, .-keyring_slot_data
	.p2align 1
	.globl keyring_slot_prot
	.type	keyring_slot_prot, @function
keyring_slot_prot:
	beqz	$1, .L14
	sll	$2, 16
	movh	$1, 0xe003
	or	$2, $3
	or3	$1, $1, 0x24
	sw	$2, ($1)
.L14:
	movh	$2, 0xe003
	or3	$2, $2, 0x28
	sw	$3, ($2)
	movh	$3, 0xe003
	or3	$3, $3, 0x2c
	lw	$0, ($3)
	ret
	.size	keyring_slot_prot, .-keyring_slot_prot
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
