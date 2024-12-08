.global setup_ints
setup_ints:
jmp 0x00044bd4

.global dram_init
dram_init:
jmp 0x0004170e

.global s_GLITCH
s_GLITCH:
jmp 0x0004028a

.global gpio_port_read
gpio_port_read:
jmp 0x00041f0a

.global ernie_3auth_single
ernie_3auth_single:
jmp 0x00041a2c

.global i2c_transfer_write
i2c_transfer_write:
jmp 0x00042186

.global s_IRQ
s_IRQ:
jmp 0x0004022a

.global c_OTHER_EXC
c_OTHER_EXC:
jmp 0x00041dac

.global sm_loadstart
sm_loadstart:
jmp 0x00044508

.global alice_schedule_task
alice_schedule_task:
jmp 0x0004046a

.global compat_armReBoot
compat_armReBoot:
jmp 0x00040cd8

.global uart_printn
uart_printn:
jmp 0x00044ab0

.global c_IRQ
c_IRQ:
jmp 0x00041c96

.global alice_get_task_status
alice_get_task_status:
jmp 0x000402d0

.global debug_setGpoCode
debug_setGpoCode:
jmp 0x000414fe

.global spi_write_start
spi_write_start:
jmp 0x0004456e

.global pervasive_control_clock
pervasive_control_clock:
jmp 0x00042804

.global uart_write
uart_write:
jmp 0x00044a0e

.global alice_stopReloadAlice
alice_stopReloadAlice:
jmp 0x000403ea

.global debug_s_regdump
debug_s_regdump:
jmp 0x00044c42

.global set_dbg_mode
set_dbg_mode:
jmp 0x00044d8c

.global regina_sendCmd
regina_sendCmd:
jmp 0x0004291c

.global s_DBG
s_DBG:
jmp 0x0004026a

.global compat_handleAllegrex
compat_handleAllegrex:
jmp 0x00040ec4

.global memcpy
memcpy:
jmp 0x0004084c

.global jig_read_shared_buffer
jig_read_shared_buffer:
jmp 0x000423e4

.global uart_print
uart_print:
jmp 0x00044a7e

.global c_ARM_REQ
c_ARM_REQ:
jmp 0x00041cf8

.global ernie_exec
ernie_exec:
jmp 0x000418e2

.global gpio_set_port_mode
gpio_set_port_mode:
jmp 0x00041eec

.global ernie_exec_cmd
ernie_exec_cmd:
jmp 0x0004197e

.global spi_init
spi_init:
jmp 0x0004450c

.global PANIC
PANIC:
jmp 0x00041ddc

.global pervasive_control_misc
pervasive_control_misc:
jmp 0x0004282e

.global readAs
readAs:
jmp 0x000424c2

.global sdif_read_sector_mmc
sdif_read_sector_mmc:
jmp 0x00043ee6

.global i2c_transfer_write_read
i2c_transfer_write_read:
jmp 0x0004224c

.global keyring_slot_data
keyring_slot_data:
jmp 0x0004251c

.global compat_IRQ7_handleCmd
compat_IRQ7_handleCmd:
jmp 0x00040b3c

.global ex_save_ctx
ex_save_ctx:
jmp 0x0004018c

.global debug_c_regdump
debug_c_regdump:
jmp 0x00041528

.global enable_icache
enable_icache:
jmp 0x00044da0

.global stor_read_emmc
stor_read_emmc:
jmp 0x00044844

.global debug_printFormat
debug_printFormat:
jmp 0x00041168

.global regina_loadRegina
regina_loadRegina:
jmp 0x00042854

.global sdif_init_ctx
sdif_init_ctx:
jmp 0x0004403e

.global uart_rxfifo_flush
uart_rxfifo_flush:
jmp 0x00044a5e

.global alice_loadAlice
alice_loadAlice:
jmp 0x00040302

.global stor_write_emmc
stor_write_emmc:
jmp 0x00044894

.global memset32
memset32:
jmp 0x000407fe

.global crypto_bigmacDefaultCmd
crypto_bigmacDefaultCmd:
jmp 0x00040f6a

.global sdif_read_sector_sd
sdif_read_sector_sd:
jmp 0x00043dee

.global debug_printU32
debug_printU32:
jmp 0x000410f4

.global sdif_init_sd
sdif_init_sd:
jmp 0x000440c8

.global memset8
memset8:
jmp 0x000407d8

.global stor_read_sd
stor_read_sd:
jmp 0x000447a4

.global pervasive_control_reset
pervasive_control_reset:
jmp 0x00042774

.global glitch_test
glitch_test:
jmp 0x00041ea2

.global sdif_init_mmc
sdif_init_mmc:
jmp 0x0004432a

.global c_OTHER_INT
c_OTHER_INT:
jmp 0x00041d7c

.global uart_init
uart_init:
jmp 0x0004497e

.global stor_export_ctx
stor_export_ctx:
jmp 0x000448e4

.global ernie_read
ernie_read:
jmp 0x00041868

.global test
test:
jmp 0x00042704

.global delay_nx
delay_nx:
jmp 0x00044ba0

.global pervasive_control_gate
pervasive_control_gate:
jmp 0x000427bc

.global i2c_transfer_read
i2c_transfer_read:
jmp 0x000421e2

.global gpio_enable_port
gpio_enable_port:
jmp 0x00042098

.global gpio_port_set
gpio_port_set:
jmp 0x00041f20

.global gpio_query_intr
gpio_query_intr:
jmp 0x00041fa8

.global spi_read
spi_read:
jmp 0x000445c6

.global ernie_exec_cmd_short
ernie_exec_cmd_short:
jmp 0x00041a10

.global cbus_write
cbus_write:
jmp 0x00044d6c

.global glitch_init
glitch_init:
jmp 0x000400d8

.global stor_import_ctx
stor_import_ctx:
jmp 0x0004492a

.global spi_read_end
spi_read_end:
jmp 0x000445d2

.global memcmp
memcmp:
jmp 0x0004088a

.global set_exception_table
set_exception_table:
jmp 0x00041e3a

.global stor_init_emmc
stor_init_emmc:
jmp 0x00044728

.global uart_scann
uart_scann:
jmp 0x00044aec

.global s_RESET
s_RESET:
jmp 0x0004029a

.global init
init:
jmp 0x00042634

.global i2c_init_bus
i2c_init_bus:
jmp 0x00042114

.global alice_handleCmd
alice_handleCmd:
jmp 0x000405a4

.global crypto_waitStopBigmacOps
crypto_waitStopBigmacOps:
jmp 0x0004102e

.global compat_pListCopy
compat_pListCopy:
jmp 0x00040c8e

.global gpio_set_intr_mode
gpio_set_intr_mode:
jmp 0x00041f60

.global stor_init_sd
stor_init_sd:
jmp 0x000446aa

.global ernie_init
ernie_init:
jmp 0x00041b62

.global memset
memset:
jmp 0x00040820

.global s_ARM_REQ
s_ARM_REQ:
jmp 0x0004024a

.global get_build_timestamp
get_build_timestamp:
jmp 0x00044bca

.global gpio_acquire_intr
gpio_acquire_intr:
jmp 0x00042014

.global writeAs
writeAs:
jmp 0x000424f8

.global delay
delay:
jmp 0x00044d44

.global rpc_loop
rpc_loop:
jmp 0x000430fa

.global jig_update_shared_buffer
jig_update_shared_buffer:
jmp 0x000422e4

.global ce_framework
ce_framework:
jmp 0x000425b0

.global cbus_read
cbus_read:
jmp 0x00044d4c

.global uart_scanns
uart_scanns:
jmp 0x00044b3e

.global keyring_slot_prot
keyring_slot_prot:
jmp 0x0004258a

.global spi_write_end
spi_write_end:
jmp 0x0004458e

.global spi_write
spi_write:
jmp 0x000445aa

.global stub
stub:
jmp 0x00044c38

.global compat_killArm
compat_killArm:
jmp 0x00040e26

.global ernie_write
ernie_write:
jmp 0x00041810

.global c_SWI
c_SWI:
jmp 0x00041c2c

.global debug_printRange
debug_printRange:
jmp 0x000414d6

.global sdif_write_sector_mmc
sdif_write_sector_mmc:
jmp 0x00043f92

.global uart_read
uart_read:
jmp 0x00044a2a

.global spi_read_available
spi_read_available:
jmp 0x000445b8

.global gpio_port_clear
gpio_port_clear:
jmp 0x00041f40

.global strlen
strlen:
jmp 0x000408ce

.global c_DBG
c_DBG:
jmp 0x00041e10

.global gpio_init
gpio_init:
jmp 0x000420b4

.global alice_schedule_bob_task
alice_schedule_bob_task:
jmp 0x00040536

.global s_SWI
s_SWI:
jmp 0x0004020a

.global sdif_write_sector_sd
sdif_write_sector_sd:
jmp 0x00043e6a

.global ex_restore_ctx
ex_restore_ctx:
jmp 0x000401cc

.global stor_write_sd
stor_write_sd:
jmp 0x000447f4

.global crypto_memset
crypto_memset:
jmp 0x000410b8

.global c_RESET
c_RESET:
jmp 0x00041be4

.global compat_Cry2Arm0
compat_Cry2Arm0:
jmp 0x000408dc

