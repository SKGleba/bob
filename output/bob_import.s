.global setup_ints
setup_ints:
jmp 0x00044d54

.global dram_init
dram_init:
jmp 0x00041752

.global s_GLITCH
s_GLITCH:
jmp 0x000402b0

.global gpio_port_read
gpio_port_read:
jmp 0x00041ff2

.global ernie_3auth_single
ernie_3auth_single:
jmp 0x00041a70

.global i2c_transfer_write
i2c_transfer_write:
jmp 0x0004226e

.global s_IRQ
s_IRQ:
jmp 0x00040250

.global c_OTHER_EXC
c_OTHER_EXC:
jmp 0x00041e4a

.global sm_loadstart
sm_loadstart:
jmp 0x00044688

.global alice_schedule_task
alice_schedule_task:
jmp 0x0004048e

.global compat_armReBoot
compat_armReBoot:
jmp 0x00040d1c

.global uart_printn
uart_printn:
jmp 0x00044c30

.global c_IRQ
c_IRQ:
jmp 0x00041d02

.global alice_get_task_status
alice_get_task_status:
jmp 0x000402f4

.global debug_setGpoCode
debug_setGpoCode:
jmp 0x00041542

.global spi_write_start
spi_write_start:
jmp 0x000446ee

.global pervasive_control_clock
pervasive_control_clock:
jmp 0x0004292a

.global uart_write
uart_write:
jmp 0x00044b8e

.global alice_stopReloadAlice
alice_stopReloadAlice:
jmp 0x0004040e

.global debug_s_regdump
debug_s_regdump:
jmp 0x00044dc2

.global set_dbg_mode
set_dbg_mode:
jmp 0x00044f0c

.global regina_sendCmd
regina_sendCmd:
jmp 0x00042a42

.global s_DBG
s_DBG:
jmp 0x00040290

.global compat_handleAllegrex
compat_handleAllegrex:
jmp 0x00040f08

.global memcpy
memcpy:
jmp 0x0004086c

.global jig_read_shared_buffer
jig_read_shared_buffer:
jmp 0x000424cc

.global uart_print
uart_print:
jmp 0x00044bfe

.global c_ARM_REQ
c_ARM_REQ:
jmp 0x00041d78

.global ernie_exec
ernie_exec:
jmp 0x00041926

.global gpio_set_port_mode
gpio_set_port_mode:
jmp 0x00041fd4

.global ernie_exec_cmd
ernie_exec_cmd:
jmp 0x000419c2

.global spi_init
spi_init:
jmp 0x0004468c

.global PANIC
PANIC:
jmp 0x00041e84

.global pervasive_control_misc
pervasive_control_misc:
jmp 0x00042954

.global readAs
readAs:
jmp 0x000425aa

.global sdif_read_sector_mmc
sdif_read_sector_mmc:
jmp 0x00044066

.global i2c_transfer_write_read
i2c_transfer_write_read:
jmp 0x00042334

.global keyring_slot_data
keyring_slot_data:
jmp 0x00042604

.global compat_IRQ7_handleCmd
compat_IRQ7_handleCmd:
jmp 0x00040b5c

.global ex_save_ctx
ex_save_ctx:
jmp 0x000401b2

.global debug_c_regdump
debug_c_regdump:
jmp 0x0004156c

.global enable_icache
enable_icache:
jmp 0x00044f20

.global stor_read_emmc
stor_read_emmc:
jmp 0x000449c4

.global debug_printFormat
debug_printFormat:
jmp 0x000411ac

.global regina_loadRegina
regina_loadRegina:
jmp 0x0004297a

.global sdif_init_ctx
sdif_init_ctx:
jmp 0x000441be

.global uart_rxfifo_flush
uart_rxfifo_flush:
jmp 0x00044bde

.global alice_loadAlice
alice_loadAlice:
jmp 0x00040326

.global stor_write_emmc
stor_write_emmc:
jmp 0x00044a14

.global memset32
memset32:
jmp 0x0004081e

.global crypto_bigmacDefaultCmd
crypto_bigmacDefaultCmd:
jmp 0x00040fae

.global sdif_read_sector_sd
sdif_read_sector_sd:
jmp 0x00043f6e

.global debug_printU32
debug_printU32:
jmp 0x00041138

.global sdif_init_sd
sdif_init_sd:
jmp 0x00044248

.global memset8
memset8:
jmp 0x000407f8

.global stor_read_sd
stor_read_sd:
jmp 0x00044924

.global pervasive_control_reset
pervasive_control_reset:
jmp 0x0004289a

.global glitch_test
glitch_test:
jmp 0x00041f78

.global sdif_init_mmc
sdif_init_mmc:
jmp 0x000444aa

.global c_OTHER_INT
c_OTHER_INT:
jmp 0x00041e10

.global uart_init
uart_init:
jmp 0x00044afe

.global stor_export_ctx
stor_export_ctx:
jmp 0x00044a64

.global ernie_read
ernie_read:
jmp 0x000418ac

.global test
test:
jmp 0x0004282a

.global delay_nx
delay_nx:
jmp 0x00044d20

.global pervasive_control_gate
pervasive_control_gate:
jmp 0x000428e2

.global i2c_transfer_read
i2c_transfer_read:
jmp 0x000422ca

.global gpio_enable_port
gpio_enable_port:
jmp 0x00042180

.global gpio_port_set
gpio_port_set:
jmp 0x00042008

.global gpio_query_intr
gpio_query_intr:
jmp 0x00042090

.global spi_read
spi_read:
jmp 0x00044746

.global ernie_exec_cmd_short
ernie_exec_cmd_short:
jmp 0x00041a54

.global cbus_write
cbus_write:
jmp 0x00044eec

.global glitch_init
glitch_init:
jmp 0x000400d8

.global stor_import_ctx
stor_import_ctx:
jmp 0x00044aaa

.global spi_read_end
spi_read_end:
jmp 0x00044752

.global memcmp
memcmp:
jmp 0x000408aa

.global set_exception_table
set_exception_table:
jmp 0x00041f10

.global stor_init_emmc
stor_init_emmc:
jmp 0x000448a8

.global uart_scann
uart_scann:
jmp 0x00044c6c

.global s_RESET
s_RESET:
jmp 0x000402c0

.global init
init:
jmp 0x00042734

.global i2c_init_bus
i2c_init_bus:
jmp 0x000421fc

.global alice_handleCmd
alice_handleCmd:
jmp 0x000405c8

.global crypto_waitStopBigmacOps
crypto_waitStopBigmacOps:
jmp 0x00041072

.global compat_pListCopy
compat_pListCopy:
jmp 0x00040cd2

.global gpio_set_intr_mode
gpio_set_intr_mode:
jmp 0x00042048

.global stor_init_sd
stor_init_sd:
jmp 0x0004482a

.global ernie_init
ernie_init:
jmp 0x00041ba6

.global memset
memset:
jmp 0x00040840

.global s_ARM_REQ
s_ARM_REQ:
jmp 0x00040270

.global get_build_timestamp
get_build_timestamp:
jmp 0x00044d4a

.global gpio_acquire_intr
gpio_acquire_intr:
jmp 0x000420fc

.global writeAs
writeAs:
jmp 0x000425e0

.global delay
delay:
jmp 0x00044ec4

.global rpc_loop
rpc_loop:
jmp 0x00043278

.global jig_update_shared_buffer
jig_update_shared_buffer:
jmp 0x000423cc

.global ce_framework
ce_framework:
jmp 0x00042698

.global cbus_read
cbus_read:
jmp 0x00044ecc

.global uart_scanns
uart_scanns:
jmp 0x00044cbe

.global keyring_slot_prot
keyring_slot_prot:
jmp 0x00042672

.global spi_write_end
spi_write_end:
jmp 0x0004470e

.global spi_write
spi_write:
jmp 0x0004472a

.global stub
stub:
jmp 0x00044db8

.global compat_killArm
compat_killArm:
jmp 0x00040e6a

.global ernie_write
ernie_write:
jmp 0x00041854

.global c_SWI
c_SWI:
jmp 0x00041c84

.global debug_printRange
debug_printRange:
jmp 0x0004151a

.global sdif_write_sector_mmc
sdif_write_sector_mmc:
jmp 0x00044112

.global uart_read
uart_read:
jmp 0x00044baa

.global spi_read_available
spi_read_available:
jmp 0x00044738

.global gpio_port_clear
gpio_port_clear:
jmp 0x00042028

.global strlen
strlen:
jmp 0x000408ee

.global c_DBG
c_DBG:
jmp 0x00041ec2

.global gpio_init
gpio_init:
jmp 0x0004219c

.global alice_schedule_bob_task
alice_schedule_bob_task:
jmp 0x0004055a

.global s_SWI
s_SWI:
jmp 0x00040230

.global sdif_write_sector_sd
sdif_write_sector_sd:
jmp 0x00043fea

.global ex_restore_ctx
ex_restore_ctx:
jmp 0x000401f2

.global stor_write_sd
stor_write_sd:
jmp 0x00044974

.global crypto_memset
crypto_memset:
jmp 0x000410fc

.global c_RESET
c_RESET:
jmp 0x00041c28

.global compat_Cry2Arm0
compat_Cry2Arm0:
jmp 0x000408fc

