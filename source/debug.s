.global debug_s_regdump
debug_s_regdump:
sw $0, 0x0($gp)
sw $1, 0x4($gp)
sw $2, 0x8($gp)
sw $3, 0xC($gp)
sw $4, 0x10($gp)
sw $5, 0x14($gp)
sw $6, 0x18($gp)
sw $7, 0x1C($gp)
sw $8, 0x20($gp)
sw $9, 0x24($gp)
sw $10, 0x28($gp)
sw $11, 0x2C($gp)
sw $12, 0x30($gp)
sw $tp, 0x34($gp)
sw $gp, 0x38($gp)
sw $sp, 0x3C($gp)
ldc $0, $pc
sw $0, 0x40($gp)
ldc $0, $lp
sw $0, 0x44($gp)
ldc $0, $sar
sw $0, 0x48($gp)
ldc $0, 3
sw $0, 0x4C($gp)
ldc $0, $rpb
sw $0, 0x50($gp)
ldc $0, $rpe
sw $0, 0x54($gp)
ldc $0, $rpc
sw $0, 0x58($gp)
ldc $0, $hi
sw $0, 0x5C($gp)
ldc $0, $lo
sw $0, 0x60($gp)
ldc $0, 9
sw $0, 0x64($0)
ldc $0, 10
sw $0, 0x68($gp)
ldc $0, 11
sw $0, 0x6C($gp)
ldc $0, $mb0
sw $0, 0x70($gp)
ldc $0, $me0
sw $0, 0x74($gp)
ldc $0, $mb1
sw $0, 0x78($gp)
ldc $0, $me1
sw $0, 0x7C($gp)
ldc $0, $psw
sw $0, 0x80($gp)
ldc $0, $id
sw $0, 0x84($gp)
ldc $0, $tmp
sw $0, 0x88($gp)
ldc $0, $epc
sw $0, 0x8C($gp)
ldc $0, $exc
sw $0, 0x90($gp)
ldc $0, $cfg
sw $0, 0x94($gp)
ldc $0, 22
sw $0, 0x98($gp)
ldc $0, $npc
sw $0, 0x9C($gp)
ldc $0, $dbg
sw $0, 0xA0($gp)
ldc $0, $depc
sw $0, 0xA4($gp)
ldc $0, $opt
sw $0, 0xA8($gp)
ldc $0, $rcfg
sw $0, 0xAC($gp)
ldc $0, $ccfg
sw $0, 0xB0($gp)
ldc $0, 29
sw $0, 0xB4($gp)
ldc $0, 30
sw $0, 0xB8($gp)
ldc $0, 31
sw $0, 0xBC($gp)
jmp debug_c_regdump