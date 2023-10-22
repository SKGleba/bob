	.file	"utils.c"
	.text
	.core
	.p2align 1
	.globl delay
	.type	delay, @function
delay:
	# frame: 8   8 locals
	add	$sp, -8
	mov	$3, 0
	mov	$2, 0
	sw	$3, ($sp)
.L2:
	lw	$0, ($sp)
	slt3	$0, $0, $1
	bnez	$0, .L5
	add	$sp, 8
	ret
.L5:
	sw	$2, 4($sp)
.L3:
	lw	$3, 4($sp)
	slt3	$3, $3, 200
	bnez	$3, .L4
	lw	$3, ($sp)
	add	$3, 1
	sw	$3, ($sp)
	bra	.L2
.L4:
	lw	$3, 4($sp)
	add	$3, 1
	sw	$3, 4($sp)
	bra	.L3
	.size	delay, .-delay
	.p2align 1
	.globl cbus_read
	.type	cbus_read, @function
cbus_read:
	# frame: 8   4 locals
	add	$sp, -8
	sh	$1, 6($sp)
	lh	$2, 6($sp)
#APP
;# 15 "source/utils.c" 1
	movu $3, cbr+2
sh $2, ($3)
.word 0x0
.word 0x0
.word 0x0
.word 0x0
.global cbr
cbr:
.word 0xf014

;# 0 "" 2
#NO_APP
	add	$sp, 8
	ret
	.size	cbus_read, .-cbus_read
	.p2align 1
	.globl cbus_write
	.type	cbus_write, @function
cbus_write:
	# frame: 8   8 locals
	add	$sp, -8
	sh	$1, 6($sp)
	sw	$2, ($sp)
	lw	$1, ($sp)
	lh	$0, 6($sp)
#APP
;# 35 "source/utils.c" 1
	movu $3, cbw+2
sh $0, ($3)
mov $1, $2
.word 0x0
.word 0x0
.word 0x0
.word 0x0
.global cbw
cbw:
.word 0xf204

;# 0 "" 2
#NO_APP
	nop
	add	$sp, 8
	ret
	.size	cbus_write, .-cbus_write
	.p2align 1
	.globl set_dbg_mode
	.type	set_dbg_mode, @function
set_dbg_mode:
	# frame: 8   4 locals
	add	$sp, -8
	sw	$1, 4($sp)
	lw	$3, 4($sp)
	bnez	$3, .L10
#APP
;# 56 "source/utils.c" 1
	ldc $0, $lp
stc $0, $depc
mov $0, $0
dret

;# 0 "" 2
#NO_APP
	bra	.L12
.L10:
#APP
;# 63 "source/utils.c" 1
	dbreak

;# 0 "" 2
#NO_APP
.L12:
	nop
	add	$sp, 8
	ret
	.size	set_dbg_mode, .-set_dbg_mode
	.p2align 1
	.globl get_build_timestamp
	.type	get_build_timestamp, @function
get_build_timestamp:
	movh	$0, 0x6535
	or3	$0, $0, 0x655a
	ret
	.size	get_build_timestamp, .-get_build_timestamp
	.p2align 1
	.globl enable_icache
	.type	enable_icache, @function
enable_icache:
	# frame: 8   4 locals
	add	$sp, -8
	sw	$1, 4($sp)
	lw	$3, 4($sp)
	beqz	$3, .L15
	ldc	$3, $cfg
	or3	$3, $3, 0x2
	stc	$3, $cfg
	bra	.L16
.L15:
	ldc	$3, $cfg
	mov	$2, -3 # 0xfffd
	and	$3, $2
	stc	$3, $cfg
.L16:
	syncm
	ldc	$3, $cfg
	and3	$3, $3, 0x2
	sltu3	$3, $3, 1
	xor3	$3, $3, 0x1
	extub	$3
	mov	$0, $3
	add	$sp, 8
	ret
	.size	enable_icache, .-enable_icache
	.p2align 1
	.globl setup_ints
	.type	setup_ints, @function
setup_ints:
	# frame: 16   16 regs
	add	$sp, -16
	ldc	$11, $lp
	mov	$2, 0
	mov	$1, 3
	sw	$11, 4($sp)
	bsr	cbus_write
	movh	$2, 0x777
	or3	$2, $2, 0x7777
	mov	$1, 4
	bsr	cbus_write
	mov	$2, 30591 # 0x777f
	mov	$1, 5
	bsr	cbus_write
	mov	$2, 0
	mov	$1, 6
	bsr	cbus_write
	mov	$2, 0
	mov	$1, 7
	bsr	cbus_write
	mov	$2, 1536 # 0x600
	mov	$1, 0
	bsr	cbus_write
	mov	$2, 256 # 0x100
	mov	$1, 2
	bsr	cbus_write
#APP
;# 92 "source/utils.c" 1
	ldc $0, $psw
or3 $0, $0, 0x110
stc $0, $psw

;# 0 "" 2
#NO_APP
	lw	$11, 4($sp)
	add	$sp, 16
	jmp	$11
	.size	setup_ints, .-setup_ints
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
