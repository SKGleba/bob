.global compat_s_ArmSkSplStage2t1
.type compat_s_ArmSkSplStage2t1, @function
# $1: src
compat_s_ArmSkSplStage2t1:
    ldc $4, $lp
    add $sp,-0x10
    sw $4,($sp)
    sw $5,0x4($sp)
    sw $6,0x8($sp)
    sw $7,0xC($sp)
    mov $3,0xFC # SPLS2T1_MAXSZ - cmdid
    sub $sp,$3
    mov $6,$2
    mov $1,$sp
    bsr memcpy
    mov $1,$sp # dont take any chances
    mov $0,$sp
    jsr $0
    add3 $sp,$sp,0xFC
    lw $7,0xC($sp)
    lw $6,0x8($sp)
    lw $5,0x4($sp)
    lw $4,($sp)
    add $sp,0x10
    jmp $4