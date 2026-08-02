.global setup_ints
setup_ints:
jmp 0x0004520c

.global dram_init
dram_init:
jmp 0x00041b02

.global s_GLITCH
s_GLITCH:
jmp 0x00040312

.global gpio_port_read
gpio_port_read:
jmp 0x00042324

.global compat_pspemuColdInit
compat_pspemuColdInit:
jmp 0x00040fee

.global ernie_3auth_single
ernie_3auth_single:
jmp 0x00041e20

.global i2c_transfer_write
i2c_transfer_write:
jmp 0x000425a0

.global config_set_dfl_test
config_set_dfl_test:
jmp 0x000411cc

.global s_IRQ
s_IRQ:
jmp 0x000402b2

.global c_OTHER_EXC
c_OTHER_EXC:
jmp 0x000421fa

.global sm_loadstart
sm_loadstart:
jmp 0x00044a38

.global alice_schedule_task
alice_schedule_task:
jmp 0x00040548

.global compat_armReBoot
compat_armReBoot:
jmp 0x00040e02

.global uart_printn
uart_printn:
jmp 0x000450c4

.global c_IRQ
c_IRQ:
jmp 0x000420e0

.global alice_get_task_status
alice_get_task_status:
jmp 0x0004036c

.global debug_setGpoCode
debug_setGpoCode:
jmp 0x00041944

.global spi_write_start
spi_write_start:
jmp 0x00044a9e

.global pervasive_control_clock
pervasive_control_clock:
jmp 0x00042c34

.global uart_write
uart_write:
jmp 0x0004500a

.global alice_stopReloadAlice
alice_stopReloadAlice:
jmp 0x000404ba

.global debug_s_regdump
debug_s_regdump:
jmp 0x0004527a

.global set_dbg_mode
set_dbg_mode:
jmp 0x000453c4

.global regina_sendCmd
regina_sendCmd:
jmp 0x00042d6c

.global s_DBG
s_DBG:
jmp 0x000402f2

.global compat_handleAllegrex
compat_handleAllegrex:
jmp 0x00041126

.global memcpy
memcpy:
jmp 0x000409ac

.global jig_read_shared_buffer
jig_read_shared_buffer:
jmp 0x00042810

.global uart_print
uart_print:
jmp 0x00045086

.global c_ARM_REQ
c_ARM_REQ:
jmp 0x00042142

.global ernie_exec
ernie_exec:
jmp 0x00041cd6

.global gpio_set_port_mode
gpio_set_port_mode:
jmp 0x00042306

.global ernie_exec_cmd
ernie_exec_cmd:
jmp 0x00041d72

.global spi_init
spi_init:
jmp 0x00044a3c

.global PANIC
PANIC:
jmp 0x0004222c

.global pervasive_control_misc
pervasive_control_misc:
jmp 0x00042c5e

.global readAs
readAs:
jmp 0x000428ee

.global sdif_read_sector_mmc
sdif_read_sector_mmc:
jmp 0x00044416

.global i2c_transfer_write_read
i2c_transfer_write_read:
jmp 0x00042678

.global keyring_slot_data
keyring_slot_data:
jmp 0x00042948

.global compat_IRQ7_handleCmd
compat_IRQ7_handleCmd:
jmp 0x00040cce

.global ex_save_ctx
ex_save_ctx:
jmp 0x00040214

.global debug_c_regdump
debug_c_regdump:
jmp 0x0004196e

.global enable_icache
enable_icache:
jmp 0x000453d8

.global stor_read_emmc
stor_read_emmc:
jmp 0x00044d74

.global debug_printFormat
debug_printFormat:
jmp 0x000415e0

.global regina_loadRegina
regina_loadRegina:
jmp 0x00042c84

.global sdif_init_ctx
sdif_init_ctx:
jmp 0x0004456e

.global uart_rxfifo_flush
uart_rxfifo_flush:
jmp 0x0004505a

.global alice_loadAlice
alice_loadAlice:
jmp 0x000403a4

.global stor_write_emmc
stor_write_emmc:
jmp 0x00044dc4

.global memset32
memset32:
jmp 0x0004095e

.global crypto_bigmacDefaultCmd
crypto_bigmacDefaultCmd:
jmp 0x000413e8

.global sdif_read_sector_sd
sdif_read_sector_sd:
jmp 0x0004431e

.global debug_printU32
debug_printU32:
jmp 0x00041572

.global dfl_test
dfl_test:
jmp 0x00044eae

.global sdif_init_sd
sdif_init_sd:
jmp 0x000445f8

.global memset8
memset8:
jmp 0x00040938

.global stor_read_sd
stor_read_sd:
jmp 0x00044cd4

.global pervasive_control_reset
pervasive_control_reset:
jmp 0x00042ba4

.global glitch_test
glitch_test:
jmp 0x00044f1e

.global sdif_init_mmc
sdif_init_mmc:
jmp 0x0004485a

.global c_OTHER_INT
c_OTHER_INT:
jmp 0x000421c8

.global uart_init
uart_init:
jmp 0x00044f7a

.global stor_export_ctx
stor_export_ctx:
jmp 0x00044e14

.global ernie_read
ernie_read:
jmp 0x00041c5c

.global delay_nx
delay_nx:
jmp 0x000451d8

.global pervasive_control_gate
pervasive_control_gate:
jmp 0x00042bec

.global i2c_transfer_read
i2c_transfer_read:
jmp 0x0004260e

.global gpio_enable_port
gpio_enable_port:
jmp 0x000424b2

.global gpio_port_set
gpio_port_set:
jmp 0x0004233a

.global gpio_query_intr
gpio_query_intr:
jmp 0x000423c2

.global spi_read
spi_read:
jmp 0x00044af6

.global config_parse
config_parse:
jmp 0x000412bc

.global ernie_exec_cmd_short
ernie_exec_cmd_short:
jmp 0x00041e04

.global cbus_write
cbus_write:
jmp 0x000453a4

.global glitch_init
glitch_init:
jmp 0x00040130

.global stor_import_ctx
stor_import_ctx:
jmp 0x00044e5a

.global spi_read_end
spi_read_end:
jmp 0x00044b02

.global memcmp
memcmp:
jmp 0x000409ea

.global set_exception_table
set_exception_table:
jmp 0x000422a6

.global stor_init_emmc
stor_init_emmc:
jmp 0x00044c58

.global uart_scann
uart_scann:
jmp 0x0004510c

.global s_RESET
s_RESET:
jmp 0x00040322

.global init
init:
jmp 0x00042aac

.global i2c_init_bus
i2c_init_bus:
jmp 0x0004252e

.global alice_handleCmd
alice_handleCmd:
jmp 0x0004068a

.global crypto_waitStopBigmacOps
crypto_waitStopBigmacOps:
jmp 0x000414ac

.global compat_pListCopy
compat_pListCopy:
jmp 0x00040db8

.global gpio_set_intr_mode
gpio_set_intr_mode:
jmp 0x0004237a

.global stor_init_sd
stor_init_sd:
jmp 0x00044bda

.global ernie_init
ernie_init:
jmp 0x00041f56

.global memset
memset:
jmp 0x00040980

.global s_ARM_REQ
s_ARM_REQ:
jmp 0x000402d2

.global get_build_timestamp
get_build_timestamp:
jmp 0x00045202

.global gpio_acquire_intr
gpio_acquire_intr:
jmp 0x0004242e

.global writeAs
writeAs:
jmp 0x00042924

.global delay
delay:
jmp 0x0004537c

.global rpc_loop
rpc_loop:
jmp 0x00043612

.global jig_update_shared_buffer
jig_update_shared_buffer:
jmp 0x00042710

.global ce_framework
ce_framework:
jmp 0x000429dc

.global cbus_read
cbus_read:
jmp 0x00045384

.global uart_scanns
uart_scanns:
jmp 0x0004516a

.global keyring_slot_prot
keyring_slot_prot:
jmp 0x000429b6

.global spi_write_end
spi_write_end:
jmp 0x00044abe

.global spi_write
spi_write:
jmp 0x00044ada

.global stub
stub:
jmp 0x00045270

.global compat_killArm
compat_killArm:
jmp 0x00040f50

.global ernie_write
ernie_write:
jmp 0x00041c04

.global c_SWI
c_SWI:
jmp 0x0004206c

.global debug_printRange
debug_printRange:
jmp 0x0004191c

.global sdif_write_sector_mmc
sdif_write_sector_mmc:
jmp 0x000444c2

.global uart_read
uart_read:
jmp 0x00045026

.global i2c_transfer_write_short
i2c_transfer_write_short:
jmp 0x000425fc

.global spi_read_available
spi_read_available:
jmp 0x00044ae8

.global gpio_port_clear
gpio_port_clear:
jmp 0x0004235a

.global strlen
strlen:
jmp 0x00040a2e

.global c_DBG
c_DBG:
jmp 0x00042262

.global gpio_init
gpio_init:
jmp 0x000424ce

.global alice_schedule_bob_task
alice_schedule_bob_task:
jmp 0x00040614

.global s_SWI
s_SWI:
jmp 0x00040292

.global sdif_write_sector_sd
sdif_write_sector_sd:
jmp 0x0004439a

.global ex_restore_ctx
ex_restore_ctx:
jmp 0x00040254

.global stor_write_sd
stor_write_sd:
jmp 0x00044d24

.global crypto_memset
crypto_memset:
jmp 0x00041536

.global c_RESET
c_RESET:
jmp 0x00041fd8

.global compat_Cry2Arm0
compat_Cry2Arm0:
jmp 0x00040a3c

