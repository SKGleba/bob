.global setup_ints
setup_ints:
jmp 0x00044d88

.global dram_init
dram_init:
jmp 0x00041756

.global s_GLITCH
s_GLITCH:
jmp 0x000402b0

.global gpio_port_read
gpio_port_read:
jmp 0x00041f9a

.global ernie_3auth_single
ernie_3auth_single:
jmp 0x00041a74

.global i2c_transfer_write
i2c_transfer_write:
jmp 0x00042216

.global s_IRQ
s_IRQ:
jmp 0x00040250

.global c_OTHER_EXC
c_OTHER_EXC:
jmp 0x00041e4e

.global sm_loadstart
sm_loadstart:
jmp 0x000445f0

.global alice_schedule_task
alice_schedule_task:
jmp 0x0004048e

.global compat_armReBoot
compat_armReBoot:
jmp 0x00040d20

.global uart_printn
uart_printn:
jmp 0x00044c64

.global c_IRQ
c_IRQ:
jmp 0x00041d06

.global alice_get_task_status
alice_get_task_status:
jmp 0x000402f4

.global debug_setGpoCode
debug_setGpoCode:
jmp 0x00041546

.global spi_write_start
spi_write_start:
jmp 0x00044656

.global pervasive_control_clock
pervasive_control_clock:
jmp 0x00042876

.global uart_write
uart_write:
jmp 0x00044bc2

.global alice_stopReloadAlice
alice_stopReloadAlice:
jmp 0x0004040e

.global debug_s_regdump
debug_s_regdump:
jmp 0x00044df6

.global set_dbg_mode
set_dbg_mode:
jmp 0x00044f40

.global regina_sendCmd
regina_sendCmd:
jmp 0x0004298e

.global s_DBG
s_DBG:
jmp 0x00040290

.global compat_handleAllegrex
compat_handleAllegrex:
jmp 0x00040f0c

.global memcpy
memcpy:
jmp 0x00040870

.global jig_read_shared_buffer
jig_read_shared_buffer:
jmp 0x00042486

.global uart_print
uart_print:
jmp 0x00044c32

.global c_ARM_REQ
c_ARM_REQ:
jmp 0x00041d7c

.global ernie_exec
ernie_exec:
jmp 0x0004192a

.global gpio_set_port_mode
gpio_set_port_mode:
jmp 0x00041f7c

.global ernie_exec_cmd
ernie_exec_cmd:
jmp 0x000419c6

.global spi_init
spi_init:
jmp 0x000445f4

.global PANIC
PANIC:
jmp 0x00041e88

.global pervasive_control_misc
pervasive_control_misc:
jmp 0x000428a0

.global readAs
readAs:
jmp 0x00042564

.global sdif_read_sector_mmc
sdif_read_sector_mmc:
jmp 0x00043fce

.global i2c_transfer_write_read
i2c_transfer_write_read:
jmp 0x000422ee

.global keyring_slot_data
keyring_slot_data:
jmp 0x000425be

.global compat_IRQ7_handleCmd
compat_IRQ7_handleCmd:
jmp 0x00040b60

.global ex_save_ctx
ex_save_ctx:
jmp 0x000401b2

.global debug_c_regdump
debug_c_regdump:
jmp 0x00041570

.global enable_icache
enable_icache:
jmp 0x00044f54

.global stor_read_emmc
stor_read_emmc:
jmp 0x0004492c

.global debug_printFormat
debug_printFormat:
jmp 0x000411b0

.global regina_loadRegina
regina_loadRegina:
jmp 0x000428c6

.global sdif_init_ctx
sdif_init_ctx:
jmp 0x00044126

.global uart_rxfifo_flush
uart_rxfifo_flush:
jmp 0x00044c12

.global alice_loadAlice
alice_loadAlice:
jmp 0x00040326

.global stor_write_emmc
stor_write_emmc:
jmp 0x0004497c

.global memset32
memset32:
jmp 0x00040822

.global crypto_bigmacDefaultCmd
crypto_bigmacDefaultCmd:
jmp 0x00040fb2

.global sdif_read_sector_sd
sdif_read_sector_sd:
jmp 0x00043ed6

.global debug_printU32
debug_printU32:
jmp 0x0004113c

.global dfl_test
dfl_test:
jmp 0x00044a66

.global sdif_init_sd
sdif_init_sd:
jmp 0x000441b0

.global memset8
memset8:
jmp 0x000407fc

.global stor_read_sd
stor_read_sd:
jmp 0x0004488c

.global pervasive_control_reset
pervasive_control_reset:
jmp 0x000427e6

.global glitch_test
glitch_test:
jmp 0x00044ad6

.global sdif_init_mmc
sdif_init_mmc:
jmp 0x00044412

.global c_OTHER_INT
c_OTHER_INT:
jmp 0x00041e14

.global uart_init
uart_init:
jmp 0x00044b32

.global stor_export_ctx
stor_export_ctx:
jmp 0x000449cc

.global ernie_read
ernie_read:
jmp 0x000418b0

.global delay_nx
delay_nx:
jmp 0x00044d54

.global pervasive_control_gate
pervasive_control_gate:
jmp 0x0004282e

.global i2c_transfer_read
i2c_transfer_read:
jmp 0x00042284

.global gpio_enable_port
gpio_enable_port:
jmp 0x00042128

.global gpio_port_set
gpio_port_set:
jmp 0x00041fb0

.global gpio_query_intr
gpio_query_intr:
jmp 0x00042038

.global spi_read
spi_read:
jmp 0x000446ae

.global ernie_exec_cmd_short
ernie_exec_cmd_short:
jmp 0x00041a58

.global cbus_write
cbus_write:
jmp 0x00044f20

.global glitch_init
glitch_init:
jmp 0x000400d8

.global stor_import_ctx
stor_import_ctx:
jmp 0x00044a12

.global spi_read_end
spi_read_end:
jmp 0x000446ba

.global memcmp
memcmp:
jmp 0x000408ae

.global set_exception_table
set_exception_table:
jmp 0x00041f14

.global stor_init_emmc
stor_init_emmc:
jmp 0x00044810

.global uart_scann
uart_scann:
jmp 0x00044ca0

.global s_RESET
s_RESET:
jmp 0x000402c0

.global init
init:
jmp 0x000426ee

.global i2c_init_bus
i2c_init_bus:
jmp 0x000421a4

.global alice_handleCmd
alice_handleCmd:
jmp 0x000405c8

.global crypto_waitStopBigmacOps
crypto_waitStopBigmacOps:
jmp 0x00041076

.global compat_pListCopy
compat_pListCopy:
jmp 0x00040cd6

.global gpio_set_intr_mode
gpio_set_intr_mode:
jmp 0x00041ff0

.global stor_init_sd
stor_init_sd:
jmp 0x00044792

.global ernie_init
ernie_init:
jmp 0x00041baa

.global memset
memset:
jmp 0x00040844

.global s_ARM_REQ
s_ARM_REQ:
jmp 0x00040270

.global get_build_timestamp
get_build_timestamp:
jmp 0x00044d7e

.global gpio_acquire_intr
gpio_acquire_intr:
jmp 0x000420a4

.global writeAs
writeAs:
jmp 0x0004259a

.global delay
delay:
jmp 0x00044ef8

.global rpc_loop
rpc_loop:
jmp 0x000431c4

.global jig_update_shared_buffer
jig_update_shared_buffer:
jmp 0x00042386

.global ce_framework
ce_framework:
jmp 0x00042652

.global cbus_read
cbus_read:
jmp 0x00044f00

.global uart_scanns
uart_scanns:
jmp 0x00044cf2

.global keyring_slot_prot
keyring_slot_prot:
jmp 0x0004262c

.global spi_write_end
spi_write_end:
jmp 0x00044676

.global spi_write
spi_write:
jmp 0x00044692

.global stub
stub:
jmp 0x00044dec

.global compat_killArm
compat_killArm:
jmp 0x00040e6e

.global ernie_write
ernie_write:
jmp 0x00041858

.global c_SWI
c_SWI:
jmp 0x00041c88

.global debug_printRange
debug_printRange:
jmp 0x0004151e

.global sdif_write_sector_mmc
sdif_write_sector_mmc:
jmp 0x0004407a

.global uart_read
uart_read:
jmp 0x00044bde

.global i2c_transfer_write_short
i2c_transfer_write_short:
jmp 0x00042272

.global spi_read_available
spi_read_available:
jmp 0x000446a0

.global gpio_port_clear
gpio_port_clear:
jmp 0x00041fd0

.global strlen
strlen:
jmp 0x000408f2

.global c_DBG
c_DBG:
jmp 0x00041ec6

.global gpio_init
gpio_init:
jmp 0x00042144

.global alice_schedule_bob_task
alice_schedule_bob_task:
jmp 0x0004055a

.global s_SWI
s_SWI:
jmp 0x00040230

.global sdif_write_sector_sd
sdif_write_sector_sd:
jmp 0x00043f52

.global ex_restore_ctx
ex_restore_ctx:
jmp 0x000401f2

.global stor_write_sd
stor_write_sd:
jmp 0x000448dc

.global crypto_memset
crypto_memset:
jmp 0x00041100

.global c_RESET
c_RESET:
jmp 0x00041c2c

.global compat_Cry2Arm0
compat_Cry2Arm0:
jmp 0x00040900

