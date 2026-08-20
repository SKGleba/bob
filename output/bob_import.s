.global setup_ints
setup_ints:
jmp 0x00045396

.global dram_init
dram_init:
jmp 0x00041ce2

.global s_GLITCH
s_GLITCH:
jmp 0x0004031a

.global gpio_port_read
gpio_port_read:
jmp 0x00042488

.global compat_pspemuColdInit
compat_pspemuColdInit:
jmp 0x00041060

.global uart_printr
uart_printr:
jmp 0x00045260

.global ernie_3auth_single
ernie_3auth_single:
jmp 0x00042000

.global i2c_transfer_write
i2c_transfer_write:
jmp 0x00042704

.global config_set_dfl_test
config_set_dfl_test:
jmp 0x0004123e

.global s_IRQ
s_IRQ:
jmp 0x000402ca

.global c_OTHER_EXC
c_OTHER_EXC:
jmp 0x0004235e

.global sm_loadstart
sm_loadstart:
jmp 0x00044b8c

.global alice_schedule_task
alice_schedule_task:
jmp 0x0004051e

.global compat_armReBoot
compat_armReBoot:
jmp 0x00040e74

.global compat_Arm2Cry0123
compat_Arm2Cry0123:
jmp 0x00040d88

.global uart_printn
uart_printn:
jmp 0x0004521c

.global c_IRQ
c_IRQ:
jmp 0x000422b6

.global alice_get_task_status
alice_get_task_status:
jmp 0x0004035c

.global debug_setGpoCode
debug_setGpoCode:
jmp 0x00041af4

.global spi_write_start
spi_write_start:
jmp 0x00044bf2

.global pervasive_control_clock
pervasive_control_clock:
jmp 0x00042d7e

.global uart_write
uart_write:
jmp 0x0004516a

.global alice_stopReloadAlice
alice_stopReloadAlice:
jmp 0x0004048e

.global debug_s_regdump
debug_s_regdump:
jmp 0x0004544e

.global set_dbg_mode
set_dbg_mode:
jmp 0x000455aa

.global regina_sendCmd
regina_sendCmd:
jmp 0x00042ec2

.global s_DBG
s_DBG:
jmp 0x000402f2

.global compat_handleAllegrex
compat_handleAllegrex:
jmp 0x00041198

.global memcpy
memcpy:
jmp 0x00040984

.global jig_read_shared_buffer
jig_read_shared_buffer:
jmp 0x00042974

.global uart_print
uart_print:
jmp 0x000451e2

.global ernie_exec
ernie_exec:
jmp 0x00041eb6

.global gpio_set_port_mode
gpio_set_port_mode:
jmp 0x0004246a

.global ernie_exec_cmd
ernie_exec_cmd:
jmp 0x00041f52

.global spi_init
spi_init:
jmp 0x00044b90

.global PANIC
PANIC:
jmp 0x00042390

.global pervasive_control_misc
pervasive_control_misc:
jmp 0x00042da8

.global readAs
readAs:
jmp 0x00042a52

.global sdif_read_sector_mmc
sdif_read_sector_mmc:
jmp 0x0004456a

.global i2c_transfer_write_read
i2c_transfer_write_read:
jmp 0x000427dc

.global keyring_slot_data
keyring_slot_data:
jmp 0x00042aac

.global dbgr_flush
dbgr_flush:
jmp 0x00041608

.global ex_save_ctx
ex_save_ctx:
jmp 0x00040224

.global debug_c_regdump
debug_c_regdump:
jmp 0x00041b1e

.global enable_icache
enable_icache:
jmp 0x000455be

.global stor_read_emmc
stor_read_emmc:
jmp 0x00044ec8

.global debug_printFormat
debug_printFormat:
jmp 0x0004175c

.global regina_loadRegina
regina_loadRegina:
jmp 0x00042dce

.global sdif_init_ctx
sdif_init_ctx:
jmp 0x000446c2

.global uart_rxfifo_flush
uart_rxfifo_flush:
jmp 0x000451ba

.global alice_loadAlice
alice_loadAlice:
jmp 0x0004038a

.global stor_write_emmc
stor_write_emmc:
jmp 0x00044f18

.global memset32
memset32:
jmp 0x00040936

.global crypto_bigmacDefaultCmd
crypto_bigmacDefaultCmd:
jmp 0x00041418

.global sdif_read_sector_sd
sdif_read_sector_sd:
jmp 0x00044472

.global dfl_test
dfl_test:
jmp 0x00045002

.global sdif_init_sd
sdif_init_sd:
jmp 0x0004474c

.global memset8
memset8:
jmp 0x00040910

.global stor_read_sd
stor_read_sd:
jmp 0x00044e28

.global pervasive_control_reset
pervasive_control_reset:
jmp 0x00042cee

.global glitch_test
glitch_test:
jmp 0x0004507e

.global sdif_init_mmc
sdif_init_mmc:
jmp 0x000449ae

.global c_OTHER_INT
c_OTHER_INT:
jmp 0x0004232c

.global uart_init
uart_init:
jmp 0x000450da

.global stor_export_ctx
stor_export_ctx:
jmp 0x00044f68

.global ernie_read
ernie_read:
jmp 0x00041e3c

.global delay_nx
delay_nx:
jmp 0x00045362

.global pervasive_control_gate
pervasive_control_gate:
jmp 0x00042d36

.global i2c_transfer_read
i2c_transfer_read:
jmp 0x00042772

.global gpio_enable_port
gpio_enable_port:
jmp 0x00042616

.global gpio_port_set
gpio_port_set:
jmp 0x0004249e

.global gpio_query_intr
gpio_query_intr:
jmp 0x00042526

.global spi_read
spi_read:
jmp 0x00044c4a

.global config_parse
config_parse:
jmp 0x00041310

.global debug_printDI32
debug_printDI32:
jmp 0x000416c2

.global ernie_exec_cmd_short
ernie_exec_cmd_short:
jmp 0x00041fe4

.global cbus_write
cbus_write:
jmp 0x0004558a

.global dbgr_scan
dbgr_scan:
jmp 0x000415e0

.global glitch_init
glitch_init:
jmp 0x0004014c

.global stor_import_ctx
stor_import_ctx:
jmp 0x00044fae

.global spi_read_end
spi_read_end:
jmp 0x00044c56

.global memcmp
memcmp:
jmp 0x000409c2

.global set_exception_table
set_exception_table:
jmp 0x0004240a

.global dbgr_print
dbgr_print:
jmp 0x000415c0

.global stor_init_emmc
stor_init_emmc:
jmp 0x00044dac

.global uart_scann
uart_scann:
jmp 0x0004529e

.global s_RESET
s_RESET:
jmp 0x00040332

.global init
init:
jmp 0x00042c0c

.global i2c_init_bus
i2c_init_bus:
jmp 0x00042692

.global alice_handleCmd
alice_handleCmd:
jmp 0x00040640

.global crypto_waitStopBigmacOps
crypto_waitStopBigmacOps:
jmp 0x000414dc

.global compat_pListCopy
compat_pListCopy:
jmp 0x00040e2a

.global gpio_set_intr_mode
gpio_set_intr_mode:
jmp 0x000424de

.global stor_init_sd
stor_init_sd:
jmp 0x00044d2e

.global ernie_init
ernie_init:
jmp 0x00042136

.global memset
memset:
jmp 0x00040958

.global debug_printHU64
debug_printHU64:
jmp 0x0004161e

.global get_build_timestamp
get_build_timestamp:
jmp 0x0004538c

.global gpio_acquire_intr
gpio_acquire_intr:
jmp 0x00042592

.global writeAs
writeAs:
jmp 0x00042a88

.global delay
delay:
jmp 0x00045562

.global intr_mask
intr_mask:
jmp 0x000453fa

.global rpc_loop
rpc_loop:
jmp 0x00043774

.global jig_update_shared_buffer
jig_update_shared_buffer:
jmp 0x00042874

.global ce_framework
ce_framework:
jmp 0x00042b40

.global cbus_read
cbus_read:
jmp 0x0004556a

.global uart_scanns
uart_scanns:
jmp 0x000452f8

.global keyring_slot_prot
keyring_slot_prot:
jmp 0x00042b1a

.global spi_write_end
spi_write_end:
jmp 0x00044c12

.global spi_write
spi_write:
jmp 0x00044c2e

.global stub
stub:
jmp 0x00045444

.global compat_killArm
compat_killArm:
jmp 0x00040fc2

.global ernie_write
ernie_write:
jmp 0x00041de4

.global c_SWI
c_SWI:
jmp 0x00042242

.global debug_printRange
debug_printRange:
jmp 0x00041acc

.global sdif_write_sector_mmc
sdif_write_sector_mmc:
jmp 0x00044616

.global compat_Arm2Cry0_handleCmd
compat_Arm2Cry0_handleCmd:
jmp 0x00040c9e

.global uart_read
uart_read:
jmp 0x00045186

.global i2c_transfer_write_short
i2c_transfer_write_short:
jmp 0x00042760

.global spi_read_available
spi_read_available:
jmp 0x00044c3c

.global crypto_keygx
crypto_keygx:
jmp 0x000415a2

.global gpio_port_clear
gpio_port_clear:
jmp 0x000424be

.global strlen
strlen:
jmp 0x00040a06

.global c_DBG
c_DBG:
jmp 0x000423c6

.global gpio_init
gpio_init:
jmp 0x00042632

.global alice_schedule_bob_task
alice_schedule_bob_task:
jmp 0x000405d0

.global s_SWI
s_SWI:
jmp 0x000402a2

.global sdif_write_sector_sd
sdif_write_sector_sd:
jmp 0x000444ee

.global ex_restore_ctx
ex_restore_ctx:
jmp 0x00040264

.global stor_write_sd
stor_write_sd:
jmp 0x00044e78

.global crypto_memset
crypto_memset:
jmp 0x00041566

.global c_RESET
c_RESET:
jmp 0x000421ba

.global compat_Cry2Arm0
compat_Cry2Arm0:
jmp 0x00040a14

