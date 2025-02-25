.global setup_ints
setup_ints:
jmp 0x000450bc

.global dram_init
dram_init:
jmp 0x000419ae

.global s_GLITCH
s_GLITCH:
jmp 0x000402c2

.global gpio_port_read
gpio_port_read:
jmp 0x000421d2

.global compat_pspemuColdInit
compat_pspemuColdInit:
jmp 0x00040f3c

.global ernie_3auth_single
ernie_3auth_single:
jmp 0x00041ccc

.global i2c_transfer_write
i2c_transfer_write:
jmp 0x0004244e

.global config_set_dfl_test
config_set_dfl_test:
jmp 0x0004111a

.global s_IRQ
s_IRQ:
jmp 0x00040262

.global c_OTHER_EXC
c_OTHER_EXC:
jmp 0x000420a8

.global sm_loadstart
sm_loadstart:
jmp 0x000448e8

.global alice_schedule_task
alice_schedule_task:
jmp 0x000404be

.global compat_armReBoot
compat_armReBoot:
jmp 0x00040d50

.global uart_printn
uart_printn:
jmp 0x00044f74

.global c_IRQ
c_IRQ:
jmp 0x00041f78

.global alice_get_task_status
alice_get_task_status:
jmp 0x0004031c

.global debug_setGpoCode
debug_setGpoCode:
jmp 0x000417f0

.global spi_write_start
spi_write_start:
jmp 0x0004494e

.global pervasive_control_clock
pervasive_control_clock:
jmp 0x00042ae2

.global uart_write
uart_write:
jmp 0x00044eba

.global alice_stopReloadAlice
alice_stopReloadAlice:
jmp 0x0004043e

.global debug_s_regdump
debug_s_regdump:
jmp 0x0004512a

.global set_dbg_mode
set_dbg_mode:
jmp 0x00045274

.global regina_sendCmd
regina_sendCmd:
jmp 0x00042c1a

.global s_DBG
s_DBG:
jmp 0x000402a2

.global compat_handleAllegrex
compat_handleAllegrex:
jmp 0x00041074

.global memcpy
memcpy:
jmp 0x000408a0

.global jig_read_shared_buffer
jig_read_shared_buffer:
jmp 0x000426be

.global uart_print
uart_print:
jmp 0x00044f36

.global c_ARM_REQ
c_ARM_REQ:
jmp 0x00041fda

.global ernie_exec
ernie_exec:
jmp 0x00041b82

.global gpio_set_port_mode
gpio_set_port_mode:
jmp 0x000421b4

.global ernie_exec_cmd
ernie_exec_cmd:
jmp 0x00041c1e

.global spi_init
spi_init:
jmp 0x000448ec

.global PANIC
PANIC:
jmp 0x000420da

.global pervasive_control_misc
pervasive_control_misc:
jmp 0x00042b0c

.global readAs
readAs:
jmp 0x0004279c

.global sdif_read_sector_mmc
sdif_read_sector_mmc:
jmp 0x000442c6

.global i2c_transfer_write_read
i2c_transfer_write_read:
jmp 0x00042526

.global keyring_slot_data
keyring_slot_data:
jmp 0x000427f6

.global compat_IRQ7_handleCmd
compat_IRQ7_handleCmd:
jmp 0x00040b90

.global ex_save_ctx
ex_save_ctx:
jmp 0x000401c4

.global debug_c_regdump
debug_c_regdump:
jmp 0x0004181a

.global enable_icache
enable_icache:
jmp 0x00045288

.global stor_read_emmc
stor_read_emmc:
jmp 0x00044c24

.global debug_printFormat
debug_printFormat:
jmp 0x0004148c

.global regina_loadRegina
regina_loadRegina:
jmp 0x00042b32

.global sdif_init_ctx
sdif_init_ctx:
jmp 0x0004441e

.global uart_rxfifo_flush
uart_rxfifo_flush:
jmp 0x00044f0a

.global alice_loadAlice
alice_loadAlice:
jmp 0x0004034e

.global stor_write_emmc
stor_write_emmc:
jmp 0x00044c74

.global memset32
memset32:
jmp 0x00040852

.global crypto_bigmacDefaultCmd
crypto_bigmacDefaultCmd:
jmp 0x00041294

.global sdif_read_sector_sd
sdif_read_sector_sd:
jmp 0x000441ce

.global debug_printU32
debug_printU32:
jmp 0x0004141e

.global dfl_test
dfl_test:
jmp 0x00044d5e

.global sdif_init_sd
sdif_init_sd:
jmp 0x000444a8

.global memset8
memset8:
jmp 0x0004082c

.global stor_read_sd
stor_read_sd:
jmp 0x00044b84

.global pervasive_control_reset
pervasive_control_reset:
jmp 0x00042a52

.global glitch_test
glitch_test:
jmp 0x00044dce

.global sdif_init_mmc
sdif_init_mmc:
jmp 0x0004470a

.global c_OTHER_INT
c_OTHER_INT:
jmp 0x00042076

.global uart_init
uart_init:
jmp 0x00044e2a

.global stor_export_ctx
stor_export_ctx:
jmp 0x00044cc4

.global ernie_read
ernie_read:
jmp 0x00041b08

.global delay_nx
delay_nx:
jmp 0x00045088

.global pervasive_control_gate
pervasive_control_gate:
jmp 0x00042a9a

.global i2c_transfer_read
i2c_transfer_read:
jmp 0x000424bc

.global gpio_enable_port
gpio_enable_port:
jmp 0x00042360

.global gpio_port_set
gpio_port_set:
jmp 0x000421e8

.global gpio_query_intr
gpio_query_intr:
jmp 0x00042270

.global spi_read
spi_read:
jmp 0x000449a6

.global config_parse
config_parse:
jmp 0x000411ce

.global ernie_exec_cmd_short
ernie_exec_cmd_short:
jmp 0x00041cb0

.global cbus_write
cbus_write:
jmp 0x00045254

.global glitch_init
glitch_init:
jmp 0x000400e0

.global stor_import_ctx
stor_import_ctx:
jmp 0x00044d0a

.global spi_read_end
spi_read_end:
jmp 0x000449b2

.global memcmp
memcmp:
jmp 0x000408de

.global set_exception_table
set_exception_table:
jmp 0x00042154

.global stor_init_emmc
stor_init_emmc:
jmp 0x00044b08

.global uart_scann
uart_scann:
jmp 0x00044fbc

.global s_RESET
s_RESET:
jmp 0x000402d2

.global init
init:
jmp 0x0004295a

.global i2c_init_bus
i2c_init_bus:
jmp 0x000423dc

.global alice_handleCmd
alice_handleCmd:
jmp 0x000405f8

.global crypto_waitStopBigmacOps
crypto_waitStopBigmacOps:
jmp 0x00041358

.global compat_pListCopy
compat_pListCopy:
jmp 0x00040d06

.global gpio_set_intr_mode
gpio_set_intr_mode:
jmp 0x00042228

.global stor_init_sd
stor_init_sd:
jmp 0x00044a8a

.global ernie_init
ernie_init:
jmp 0x00041e02

.global memset
memset:
jmp 0x00040874

.global s_ARM_REQ
s_ARM_REQ:
jmp 0x00040282

.global get_build_timestamp
get_build_timestamp:
jmp 0x000450b2

.global gpio_acquire_intr
gpio_acquire_intr:
jmp 0x000422dc

.global writeAs
writeAs:
jmp 0x000427d2

.global delay
delay:
jmp 0x0004522c

.global rpc_loop
rpc_loop:
jmp 0x000434c2

.global jig_update_shared_buffer
jig_update_shared_buffer:
jmp 0x000425be

.global ce_framework
ce_framework:
jmp 0x0004288a

.global cbus_read
cbus_read:
jmp 0x00045234

.global uart_scanns
uart_scanns:
jmp 0x0004501a

.global keyring_slot_prot
keyring_slot_prot:
jmp 0x00042864

.global spi_write_end
spi_write_end:
jmp 0x0004496e

.global spi_write
spi_write:
jmp 0x0004498a

.global stub
stub:
jmp 0x00045120

.global compat_killArm
compat_killArm:
jmp 0x00040e9e

.global ernie_write
ernie_write:
jmp 0x00041ab0

.global c_SWI
c_SWI:
jmp 0x00041f04

.global debug_printRange
debug_printRange:
jmp 0x000417c8

.global sdif_write_sector_mmc
sdif_write_sector_mmc:
jmp 0x00044372

.global uart_read
uart_read:
jmp 0x00044ed6

.global i2c_transfer_write_short
i2c_transfer_write_short:
jmp 0x000424aa

.global spi_read_available
spi_read_available:
jmp 0x00044998

.global gpio_port_clear
gpio_port_clear:
jmp 0x00042208

.global strlen
strlen:
jmp 0x00040922

.global c_DBG
c_DBG:
jmp 0x00042110

.global gpio_init
gpio_init:
jmp 0x0004237c

.global alice_schedule_bob_task
alice_schedule_bob_task:
jmp 0x0004058a

.global s_SWI
s_SWI:
jmp 0x00040242

.global sdif_write_sector_sd
sdif_write_sector_sd:
jmp 0x0004424a

.global ex_restore_ctx
ex_restore_ctx:
jmp 0x00040204

.global stor_write_sd
stor_write_sd:
jmp 0x00044bd4

.global crypto_memset
crypto_memset:
jmp 0x000413e2

.global c_RESET
c_RESET:
jmp 0x00041e84

.global compat_Cry2Arm0
compat_Cry2Arm0:
jmp 0x00040930

