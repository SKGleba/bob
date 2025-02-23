.global setup_ints
setup_ints:
jmp 0x00044f58

.global dram_init
dram_init:
jmp 0x0004186e

.global s_GLITCH
s_GLITCH:
jmp 0x000402bc

.global gpio_port_read
gpio_port_read:
jmp 0x0004209e

.global ernie_3auth_single
ernie_3auth_single:
jmp 0x00041b8c

.global i2c_transfer_write
i2c_transfer_write:
jmp 0x0004231a

.global config_set_dfl_test
config_set_dfl_test:
jmp 0x00040fda

.global s_IRQ
s_IRQ:
jmp 0x0004025c

.global c_OTHER_EXC
c_OTHER_EXC:
jmp 0x00041f68

.global sm_loadstart
sm_loadstart:
jmp 0x00044784

.global alice_schedule_task
alice_schedule_task:
jmp 0x000404b6

.global compat_armReBoot
compat_armReBoot:
jmp 0x00040d48

.global uart_printn
uart_printn:
jmp 0x00044e10

.global c_IRQ
c_IRQ:
jmp 0x00041e38

.global alice_get_task_status
alice_get_task_status:
jmp 0x00040314

.global debug_setGpoCode
debug_setGpoCode:
jmp 0x000416b0

.global spi_write_start
spi_write_start:
jmp 0x000447ea

.global pervasive_control_clock
pervasive_control_clock:
jmp 0x000429ae

.global uart_write
uart_write:
jmp 0x00044d56

.global alice_stopReloadAlice
alice_stopReloadAlice:
jmp 0x00040436

.global debug_s_regdump
debug_s_regdump:
jmp 0x00044fc6

.global set_dbg_mode
set_dbg_mode:
jmp 0x00045110

.global regina_sendCmd
regina_sendCmd:
jmp 0x00042ac6

.global s_DBG
s_DBG:
jmp 0x0004029c

.global compat_handleAllegrex
compat_handleAllegrex:
jmp 0x00040f34

.global memcpy
memcpy:
jmp 0x00040898

.global jig_read_shared_buffer
jig_read_shared_buffer:
jmp 0x0004258a

.global uart_print
uart_print:
jmp 0x00044dd2

.global c_ARM_REQ
c_ARM_REQ:
jmp 0x00041e9a

.global ernie_exec
ernie_exec:
jmp 0x00041a42

.global gpio_set_port_mode
gpio_set_port_mode:
jmp 0x00042080

.global ernie_exec_cmd
ernie_exec_cmd:
jmp 0x00041ade

.global spi_init
spi_init:
jmp 0x00044788

.global PANIC
PANIC:
jmp 0x00041f9a

.global pervasive_control_misc
pervasive_control_misc:
jmp 0x000429d8

.global readAs
readAs:
jmp 0x00042668

.global sdif_read_sector_mmc
sdif_read_sector_mmc:
jmp 0x00044162

.global i2c_transfer_write_read
i2c_transfer_write_read:
jmp 0x000423f2

.global keyring_slot_data
keyring_slot_data:
jmp 0x000426c2

.global compat_IRQ7_handleCmd
compat_IRQ7_handleCmd:
jmp 0x00040b88

.global ex_save_ctx
ex_save_ctx:
jmp 0x000401be

.global debug_c_regdump
debug_c_regdump:
jmp 0x000416da

.global enable_icache
enable_icache:
jmp 0x00045124

.global stor_read_emmc
stor_read_emmc:
jmp 0x00044ac0

.global debug_printFormat
debug_printFormat:
jmp 0x0004134c

.global regina_loadRegina
regina_loadRegina:
jmp 0x000429fe

.global sdif_init_ctx
sdif_init_ctx:
jmp 0x000442ba

.global uart_rxfifo_flush
uart_rxfifo_flush:
jmp 0x00044da6

.global alice_loadAlice
alice_loadAlice:
jmp 0x00040346

.global stor_write_emmc
stor_write_emmc:
jmp 0x00044b10

.global memset32
memset32:
jmp 0x0004084a

.global crypto_bigmacDefaultCmd
crypto_bigmacDefaultCmd:
jmp 0x00041154

.global sdif_read_sector_sd
sdif_read_sector_sd:
jmp 0x0004406a

.global debug_printU32
debug_printU32:
jmp 0x000412de

.global dfl_test
dfl_test:
jmp 0x00044bfa

.global sdif_init_sd
sdif_init_sd:
jmp 0x00044344

.global memset8
memset8:
jmp 0x00040824

.global stor_read_sd
stor_read_sd:
jmp 0x00044a20

.global pervasive_control_reset
pervasive_control_reset:
jmp 0x0004291e

.global glitch_test
glitch_test:
jmp 0x00044c6a

.global sdif_init_mmc
sdif_init_mmc:
jmp 0x000445a6

.global c_OTHER_INT
c_OTHER_INT:
jmp 0x00041f36

.global uart_init
uart_init:
jmp 0x00044cc6

.global stor_export_ctx
stor_export_ctx:
jmp 0x00044b60

.global ernie_read
ernie_read:
jmp 0x000419c8

.global delay_nx
delay_nx:
jmp 0x00044f24

.global pervasive_control_gate
pervasive_control_gate:
jmp 0x00042966

.global i2c_transfer_read
i2c_transfer_read:
jmp 0x00042388

.global gpio_enable_port
gpio_enable_port:
jmp 0x0004222c

.global gpio_port_set
gpio_port_set:
jmp 0x000420b4

.global gpio_query_intr
gpio_query_intr:
jmp 0x0004213c

.global spi_read
spi_read:
jmp 0x00044842

.global config_parse
config_parse:
jmp 0x0004108e

.global ernie_exec_cmd_short
ernie_exec_cmd_short:
jmp 0x00041b70

.global cbus_write
cbus_write:
jmp 0x000450f0

.global glitch_init
glitch_init:
jmp 0x000400e0

.global stor_import_ctx
stor_import_ctx:
jmp 0x00044ba6

.global spi_read_end
spi_read_end:
jmp 0x0004484e

.global memcmp
memcmp:
jmp 0x000408d6

.global set_exception_table
set_exception_table:
jmp 0x00042014

.global stor_init_emmc
stor_init_emmc:
jmp 0x000449a4

.global uart_scann
uart_scann:
jmp 0x00044e58

.global s_RESET
s_RESET:
jmp 0x000402cc

.global init
init:
jmp 0x00042826

.global i2c_init_bus
i2c_init_bus:
jmp 0x000422a8

.global alice_handleCmd
alice_handleCmd:
jmp 0x000405f0

.global crypto_waitStopBigmacOps
crypto_waitStopBigmacOps:
jmp 0x00041218

.global compat_pListCopy
compat_pListCopy:
jmp 0x00040cfe

.global gpio_set_intr_mode
gpio_set_intr_mode:
jmp 0x000420f4

.global stor_init_sd
stor_init_sd:
jmp 0x00044926

.global ernie_init
ernie_init:
jmp 0x00041cc2

.global memset
memset:
jmp 0x0004086c

.global s_ARM_REQ
s_ARM_REQ:
jmp 0x0004027c

.global get_build_timestamp
get_build_timestamp:
jmp 0x00044f4e

.global gpio_acquire_intr
gpio_acquire_intr:
jmp 0x000421a8

.global writeAs
writeAs:
jmp 0x0004269e

.global delay
delay:
jmp 0x000450c8

.global rpc_loop
rpc_loop:
jmp 0x0004335e

.global jig_update_shared_buffer
jig_update_shared_buffer:
jmp 0x0004248a

.global ce_framework
ce_framework:
jmp 0x00042756

.global cbus_read
cbus_read:
jmp 0x000450d0

.global uart_scanns
uart_scanns:
jmp 0x00044eb6

.global keyring_slot_prot
keyring_slot_prot:
jmp 0x00042730

.global spi_write_end
spi_write_end:
jmp 0x0004480a

.global spi_write
spi_write:
jmp 0x00044826

.global stub
stub:
jmp 0x00044fbc

.global compat_killArm
compat_killArm:
jmp 0x00040e96

.global ernie_write
ernie_write:
jmp 0x00041970

.global c_SWI
c_SWI:
jmp 0x00041dc4

.global debug_printRange
debug_printRange:
jmp 0x00041688

.global sdif_write_sector_mmc
sdif_write_sector_mmc:
jmp 0x0004420e

.global uart_read
uart_read:
jmp 0x00044d72

.global i2c_transfer_write_short
i2c_transfer_write_short:
jmp 0x00042376

.global spi_read_available
spi_read_available:
jmp 0x00044834

.global gpio_port_clear
gpio_port_clear:
jmp 0x000420d4

.global strlen
strlen:
jmp 0x0004091a

.global c_DBG
c_DBG:
jmp 0x00041fd0

.global gpio_init
gpio_init:
jmp 0x00042248

.global alice_schedule_bob_task
alice_schedule_bob_task:
jmp 0x00040582

.global s_SWI
s_SWI:
jmp 0x0004023c

.global sdif_write_sector_sd
sdif_write_sector_sd:
jmp 0x000440e6

.global ex_restore_ctx
ex_restore_ctx:
jmp 0x000401fe

.global stor_write_sd
stor_write_sd:
jmp 0x00044a70

.global crypto_memset
crypto_memset:
jmp 0x000412a2

.global c_RESET
c_RESET:
jmp 0x00041d44

.global compat_Cry2Arm0
compat_Cry2Arm0:
jmp 0x00040928

