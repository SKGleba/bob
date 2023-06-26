	.file	"perv.c"
	.text
	.core
	.p2align 1
	.globl pervasive_read_misc
	.type	pervasive_read_misc, @function
pervasive_read_misc:
	movh	$3, 0xe310
	add3	$1, $1, $3
	lw	$0, ($1)
	ret
	.size	pervasive_read_misc, .-pervasive_read_misc
	.p2align 1
	.globl pervasive_clock_enable_uart
	.type	pervasive_clock_enable_uart, @function
pervasive_clock_enable_uart:
	# frame: 16   16 regs
	movh	$3, 0xe310
	add	$sp, -16
	sll3	$0, $1, 2
	or3	$3, $3, 0x2120
	ldc	$11, $lp
	add3	$1, $0, $3
	sw	$11, 4($sp)
	bsr	pervasive_mask_or.constprop.1
	lw	$11, 4($sp)
	add	$sp, 16
	jmp	$11
	.size	pervasive_clock_enable_uart, .-pervasive_clock_enable_uart
	.p2align 1
	.globl pervasive_reset_exit_uart
	.type	pervasive_reset_exit_uart, @function
pervasive_reset_exit_uart:
	# frame: 16   16 regs
	movh	$3, 0xe310
	add	$sp, -16
	sll3	$0, $1, 2
	or3	$3, $3, 0x1120
	ldc	$11, $lp
	add3	$1, $0, $3
	sw	$11, 4($sp)
	bsr	pervasive_mask_and_not.constprop.0
	lw	$11, 4($sp)
	add	$sp, 16
	jmp	$11
	.size	pervasive_reset_exit_uart, .-pervasive_reset_exit_uart
	.p2align 1
	.globl pervasive_clock_enable_gpio
	.type	pervasive_clock_enable_gpio, @function
pervasive_clock_enable_gpio:
	# frame: 16   16 regs
	add	$sp, -16
	movh	$1, 0xe310
	ldc	$11, $lp
	or3	$1, $1, 0x2100
	sw	$11, 4($sp)
	bsr	pervasive_mask_or.constprop.1
	lw	$11, 4($sp)
	add	$sp, 16
	jmp	$11
	.size	pervasive_clock_enable_gpio, .-pervasive_clock_enable_gpio
	.p2align 1
	.globl pervasive_reset_exit_gpio
	.type	pervasive_reset_exit_gpio, @function
pervasive_reset_exit_gpio:
	# frame: 16   16 regs
	add	$sp, -16
	movh	$1, 0xe310
	ldc	$11, $lp
	or3	$1, $1, 0x1100
	sw	$11, 4($sp)
	bsr	pervasive_mask_and_not.constprop.0
	lw	$11, 4($sp)
	add	$sp, 16
	jmp	$11
	.size	pervasive_reset_exit_gpio, .-pervasive_reset_exit_gpio
	.p2align 1
	.globl pervasive_clock_disable_gpio
	.type	pervasive_clock_disable_gpio, @function
pervasive_clock_disable_gpio:
	# frame: 16   16 regs
	add	$sp, -16
	movh	$1, 0xe310
	ldc	$11, $lp
	or3	$1, $1, 0x2100
	sw	$11, 4($sp)
	bsr	pervasive_mask_and_not.constprop.0
	lw	$11, 4($sp)
	add	$sp, 16
	jmp	$11
	.size	pervasive_clock_disable_gpio, .-pervasive_clock_disable_gpio
	.p2align 1
	.globl pervasive_reset_enter_gpio
	.type	pervasive_reset_enter_gpio, @function
pervasive_reset_enter_gpio:
	# frame: 16   16 regs
	add	$sp, -16
	movh	$1, 0xe310
	ldc	$11, $lp
	or3	$1, $1, 0x1100
	sw	$11, 4($sp)
	bsr	pervasive_mask_or.constprop.1
	lw	$11, 4($sp)
	add	$sp, 16
	jmp	$11
	.size	pervasive_reset_enter_gpio, .-pervasive_reset_enter_gpio
	.p2align 1
	.globl pervasive_clock_enable_spi
	.type	pervasive_clock_enable_spi, @function
pervasive_clock_enable_spi:
	# frame: 16   16 regs
	movh	$3, 0xe310
	add	$sp, -16
	sll3	$0, $1, 2
	or3	$3, $3, 0x2104
	ldc	$11, $lp
	add3	$1, $0, $3
	sw	$11, 4($sp)
	bsr	pervasive_mask_or.constprop.1
	lw	$11, 4($sp)
	add	$sp, 16
	jmp	$11
	.size	pervasive_clock_enable_spi, .-pervasive_clock_enable_spi
	.p2align 1
	.globl pervasive_clock_disable_spi
	.type	pervasive_clock_disable_spi, @function
pervasive_clock_disable_spi:
	# frame: 16   16 regs
	movh	$3, 0xe310
	add	$sp, -16
	sll3	$0, $1, 2
	or3	$3, $3, 0x2104
	ldc	$11, $lp
	add3	$1, $0, $3
	sw	$11, 4($sp)
	bsr	pervasive_mask_and_not.constprop.0
	lw	$11, 4($sp)
	add	$sp, 16
	jmp	$11
	.size	pervasive_clock_disable_spi, .-pervasive_clock_disable_spi
	.p2align 1
	.globl pervasive_reset_enter_spi
	.type	pervasive_reset_enter_spi, @function
pervasive_reset_enter_spi:
	# frame: 16   16 regs
	movh	$3, 0xe310
	add	$sp, -16
	sll3	$0, $1, 2
	or3	$3, $3, 0x1104
	ldc	$11, $lp
	add3	$1, $0, $3
	sw	$11, 4($sp)
	bsr	pervasive_mask_or.constprop.1
	lw	$11, 4($sp)
	add	$sp, 16
	jmp	$11
	.size	pervasive_reset_enter_spi, .-pervasive_reset_enter_spi
	.p2align 1
	.globl pervasive_reset_exit_spi
	.type	pervasive_reset_exit_spi, @function
pervasive_reset_exit_spi:
	# frame: 16   16 regs
	movh	$3, 0xe310
	add	$sp, -16
	sll3	$0, $1, 2
	or3	$3, $3, 0x1104
	ldc	$11, $lp
	add3	$1, $0, $3
	sw	$11, 4($sp)
	bsr	pervasive_mask_and_not.constprop.0
	lw	$11, 4($sp)
	add	$sp, 16
	jmp	$11
	.size	pervasive_reset_exit_spi, .-pervasive_reset_exit_spi
	.p2align 1
	.type	pervasive_mask_and_not.constprop.0, @function
pervasive_mask_and_not.constprop.0:
	lw	$3, ($1)
	mov	$2, -2 # 0xfffe
	and	$3, $2
	sw	$3, ($1)
	syncm
	ret
	.size	pervasive_mask_and_not.constprop.0, .-pervasive_mask_and_not.constprop.0
	.p2align 1
	.type	pervasive_mask_or.constprop.1, @function
pervasive_mask_or.constprop.1:
	lw	$3, ($1)
	or3	$3, $3, 0x1
	sw	$3, ($1)
	syncm
	ret
	.size	pervasive_mask_or.constprop.1, .-pervasive_mask_or.constprop.1
	.ident	"GCC: (WTF TEAM MOLECULE IS AT IT AGAIN?!) 6.3.0"
