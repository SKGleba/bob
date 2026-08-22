.global setup_ints
setup_ints:
jmp 0x0004544a

.global dram_init
dram_init:
jmp 0x00041cec

.global s_GLITCH
s_GLITCH:
jmp 0x000402ae

.global gpio_port_read
gpio_port_read:
jmp 0x000424b4

.global compat_pspemuColdInit
compat_pspemuColdInit:
jmp 0x0004106a

.global uart_printr
uart_printr:
jmp 0x00045314

.global ernie_3auth_single
ernie_3auth_single:
jmp 0x0004200a

.global i2c_transfer_write
i2c_transfer_write:
jmp 0x00042730

.global config_set_dfl_test
config_set_dfl_test:
jmp 0x00041248

.global s_IRQ
s_IRQ:
jmp 0x0004025e

.global c_OTHER_EXC
c_OTHER_EXC:
jmp 0x0004237a

.global sm_loadstart
sm_loadstart:
jmp 0x00044c40

.global alice_schedule_task
alice_schedule_task:
jmp 0x000404b2

.global compat_armReBoot
compat_armReBoot:
jmp 0x00040e7e

.global compat_Arm2Cry0123
compat_Arm2Cry0123:
jmp 0x00040d90

.global uart_printn
uart_printn:
jmp 0x000452d0

.global c_IRQ
c_IRQ:
jmp 0x000422ca

.global alice_get_task_status
alice_get_task_status:
jmp 0x000402f0

.global debug_setGpoCode
debug_setGpoCode:
jmp 0x00041afe

.global spi_write_start
spi_write_start:
jmp 0x00044ca6

.global pervasive_control_clock
pervasive_control_clock:
jmp 0x00042e34

.global uart_write
uart_write:
jmp 0x0004521e

.global alice_stopReloadAlice
alice_stopReloadAlice:
jmp 0x00040422

.global debug_s_regdump
debug_s_regdump:
jmp 0x00045502

.global set_dbg_mode
set_dbg_mode:
jmp 0x0004562a

.global regina_sendCmd
regina_sendCmd:
jmp 0x00042f78

.global s_DBG
s_DBG:
jmp 0x00040286

.global compat_handleAllegrex
compat_handleAllegrex:
jmp 0x000411a2

.global memcpy
memcpy:
jmp 0x0004098c

.global jig_read_shared_buffer
jig_read_shared_buffer:
jmp 0x000429a0

.global uart_print
uart_print:
jmp 0x00045296

.global ernie_exec
ernie_exec:
jmp 0x00041ec0

.global gpio_set_port_mode
gpio_set_port_mode:
jmp 0x00042496

.global ernie_exec_cmd
ernie_exec_cmd:
jmp 0x00041f5c

.global spi_init
spi_init:
jmp 0x00044c44

.global PANIC
PANIC:
jmp 0x000423b4

.global pervasive_control_misc
pervasive_control_misc:
jmp 0x00042e5e

.global readAs
readAs:
jmp 0x00042a7e

.global sdif_read_sector_mmc
sdif_read_sector_mmc:
jmp 0x0004461e

.global i2c_transfer_write_read
i2c_transfer_write_read:
jmp 0x00042808

.global keyring_slot_data
keyring_slot_data:
jmp 0x00042ad8

.global dbgr_flush
dbgr_flush:
jmp 0x00041612

.global ex_save_ctx
ex_save_ctx:
jmp 0x000401b8

.global debug_c_regdump
debug_c_regdump:
jmp 0x00041b28

.global enable_icache
enable_icache:
jmp 0x0004563e

.global stor_read_emmc
stor_read_emmc:
jmp 0x00044f7c

.global debug_printFormat
debug_printFormat:
jmp 0x00041766

.global regina_loadRegina
regina_loadRegina:
jmp 0x00042e84

.global sdif_init_ctx
sdif_init_ctx:
jmp 0x00044776

.global uart_rxfifo_flush
uart_rxfifo_flush:
jmp 0x0004526e

.global alice_loadAlice
alice_loadAlice:
jmp 0x0004031e

.global stor_write_emmc
stor_write_emmc:
jmp 0x00044fcc

.global memset32
memset32:
jmp 0x0004093e

.global crypto_bigmacDefaultCmd
crypto_bigmacDefaultCmd:
jmp 0x00041422

.global sdif_read_sector_sd
sdif_read_sector_sd:
jmp 0x00044526

.global dfl_test
dfl_test:
jmp 0x000450b6

.global sdif_init_sd
sdif_init_sd:
jmp 0x00044800

.global memset8
memset8:
jmp 0x00040918

.global stor_read_sd
stor_read_sd:
jmp 0x00044edc

.global pervasive_control_reset
pervasive_control_reset:
jmp 0x00042da4

.global glitch_test
glitch_test:
jmp 0x00045132

.global sdif_init_mmc
sdif_init_mmc:
jmp 0x00044a62

.global c_OTHER_INT
c_OTHER_INT:
jmp 0x00042340

.global uart_init
uart_init:
jmp 0x0004518e

.global stor_export_ctx
stor_export_ctx:
jmp 0x0004501c

.global ernie_read
ernie_read:
jmp 0x00041e46

.global delay_nx
delay_nx:
jmp 0x00045416

.global pervasive_control_gate
pervasive_control_gate:
jmp 0x00042dec

.global i2c_transfer_read
i2c_transfer_read:
jmp 0x0004279e

.global gpio_enable_port
gpio_enable_port:
jmp 0x00042642

.global gpio_port_set
gpio_port_set:
jmp 0x000424ca

.global gpio_query_intr
gpio_query_intr:
jmp 0x00042552

.global spi_read
spi_read:
jmp 0x00044cfe

.global config_parse
config_parse:
jmp 0x0004131a

.global debug_printDI32
debug_printDI32:
jmp 0x000416cc

.global ernie_exec_cmd_short
ernie_exec_cmd_short:
jmp 0x00041fee

.global cbus_write
cbus_write:
jmp 0x0004560a

.global dbgr_scan
dbgr_scan:
jmp 0x000415ea

.global glitch_init
glitch_init:
jmp 0x000400e0

.global stor_import_ctx
stor_import_ctx:
jmp 0x00045062

.global spi_read_end
spi_read_end:
jmp 0x00044d0a

.global memcmp
memcmp:
jmp 0x000409ca

.global set_exception_table
set_exception_table:
jmp 0x00042436

.global dbgr_print
dbgr_print:
jmp 0x000415ca

.global stor_init_emmc
stor_init_emmc:
jmp 0x00044e60

.global uart_scann
uart_scann:
jmp 0x00045352

.global s_RESET
s_RESET:
jmp 0x000402c6

.global init
init:
jmp 0x00042cc0

.global i2c_init_bus
i2c_init_bus:
jmp 0x000426be

.global alice_handleCmd
alice_handleCmd:
jmp 0x000405d4

.global crypto_waitStopBigmacOps
crypto_waitStopBigmacOps:
jmp 0x000414e6

.global compat_pListCopy
compat_pListCopy:
jmp 0x00040e34

.global gpio_set_intr_mode
gpio_set_intr_mode:
jmp 0x0004250a

.global stor_init_sd
stor_init_sd:
jmp 0x00044de2

.global ernie_init
ernie_init:
jmp 0x00042140

.global memset
memset:
jmp 0x00040960

.global debug_printHU64
debug_printHU64:
jmp 0x00041628

.global get_build_timestamp
get_build_timestamp:
jmp 0x00045440

.global gpio_acquire_intr
gpio_acquire_intr:
jmp 0x000425be

.global writeAs
writeAs:
jmp 0x00042ab4

.global delay
delay:
jmp 0x000455e2

.global intr_mask
intr_mask:
jmp 0x000454ae

.global rpc_loop
rpc_loop:
jmp 0x00043828

.global jig_update_shared_buffer
jig_update_shared_buffer:
jmp 0x000428a0

.global ce_framework
ce_framework:
jmp 0x00042b6c

.global cbus_read
cbus_read:
jmp 0x000455ea

.global uart_scanns
uart_scanns:
jmp 0x000453ac

.global keyring_slot_prot
keyring_slot_prot:
jmp 0x00042b46

.global spi_write_end
spi_write_end:
jmp 0x00044cc6

.global spi_write
spi_write:
jmp 0x00044ce2

.global stub
stub:
jmp 0x000454f8

.global compat_killArm
compat_killArm:
jmp 0x00040fcc

.global ernie_write
ernie_write:
jmp 0x00041dee

.global c_SWI
c_SWI:
jmp 0x00042256

.global debug_printRange
debug_printRange:
jmp 0x00041ad6

.global sdif_write_sector_mmc
sdif_write_sector_mmc:
jmp 0x000446ca

.global compat_Arm2Cry0_handleCmd
compat_Arm2Cry0_handleCmd:
jmp 0x00040ca6

.global uart_read
uart_read:
jmp 0x0004523a

.global i2c_transfer_write_short
i2c_transfer_write_short:
jmp 0x0004278c

.global spi_read_available
spi_read_available:
jmp 0x00044cf0

.global crypto_keygx
crypto_keygx:
jmp 0x000415ac

.global gpio_port_clear
gpio_port_clear:
jmp 0x000424ea

.global strlen
strlen:
jmp 0x00040a0e

.global c_DBG
c_DBG:
jmp 0x000423f2

.global gpio_init
gpio_init:
jmp 0x0004265e

.global alice_schedule_bob_task
alice_schedule_bob_task:
jmp 0x00040564

.global s_SWI
s_SWI:
jmp 0x00040236

.global sdif_write_sector_sd
sdif_write_sector_sd:
jmp 0x000445a2

.global ex_restore_ctx
ex_restore_ctx:
jmp 0x000401f8

.global stor_write_sd
stor_write_sd:
jmp 0x00044f2c

.global crypto_memset
crypto_memset:
jmp 0x00041570

.global c_RESET
c_RESET:
jmp 0x000421c4

.global compat_Cry2Arm0
compat_Cry2Arm0:
jmp 0x00040a1c

