.global setup_ints
setup_ints:
jmp 0x00042ea4

.global gpio_port_read
gpio_port_read:
jmp 0x0004197c

.global ernie_3auth_single
ernie_3auth_single:
jmp 0x000413ea

.global i2c_transfer_write
i2c_transfer_write:
jmp 0x00041bf8

.global c_OTHER_EXC
c_OTHER_EXC:
jmp 0x00041762

.global sm_loadstart
sm_loadstart:
jmp 0x00042ac8

.global alice_schedule_task
alice_schedule_task:
jmp 0x000402e2

.global compat_armReBoot
compat_armReBoot:
jmp 0x00040a74

.global uart_printn
uart_printn:
jmp 0x00042cda

.global c_IRQ
c_IRQ:
jmp 0x00041650

.global alice_get_task_status
alice_get_task_status:
jmp 0x000400d8

.global debug_setGpoCode
debug_setGpoCode:
jmp 0x0004113a

.global spi_write_start
spi_write_start:
jmp 0x00042b2e

.global pervasive_control_clock
pervasive_control_clock:
jmp 0x00042270

.global uart_write
uart_write:
jmp 0x00042c38

.global alice_stopReloadAlice
alice_stopReloadAlice:
jmp 0x00040264

.global set_dbg_mode
set_dbg_mode:
jmp 0x00042e4e

.global memcpy
memcpy:
jmp 0x000405e8

.global jig_read_shared_buffer
jig_read_shared_buffer:
jmp 0x00041e56

.global uart_print
uart_print:
jmp 0x00042ca8

.global c_ARM_REQ
c_ARM_REQ:
jmp 0x000416ae

.global ernie_exec
ernie_exec:
jmp 0x000412a0

.global gpio_set_port_mode
gpio_set_port_mode:
jmp 0x0004195e

.global ernie_exec_cmd
ernie_exec_cmd:
jmp 0x0004133c

.global spi_init
spi_init:
jmp 0x00042acc

.global PANIC
PANIC:
jmp 0x00041792

.global pervasive_control_misc
pervasive_control_misc:
jmp 0x0004229a

.global readAs
readAs:
jmp 0x00041f34

.global i2c_transfer_write_read
i2c_transfer_write_read:
jmp 0x00041cbe

.global keyring_slot_data
keyring_slot_data:
jmp 0x00041f8e

.global compat_IRQ7_handleCmd
compat_IRQ7_handleCmd:
jmp 0x000408d8

.global debug_c_regdump
debug_c_regdump:
jmp 0x00041164

.global enable_icache
enable_icache:
jmp 0x00042e72

.global debug_printFormat
debug_printFormat:
jmp 0x00040e44

.global uart_rxfifo_flush
uart_rxfifo_flush:
jmp 0x00042c88

.global alice_loadAlice
alice_loadAlice:
jmp 0x00040178

.global memset32
memset32:
jmp 0x0004059a

.global crypto_bigmacDefaultCmd
crypto_bigmacDefaultCmd:
jmp 0x00040c46

.global debug_printU32
debug_printU32:
jmp 0x00040dd0

.global memset8
memset8:
jmp 0x00040574

.global pervasive_control_reset
pervasive_control_reset:
jmp 0x000421e4

.global glitch_test
glitch_test:
jmp 0x00041858

.global c_OTHER_INT
c_OTHER_INT:
jmp 0x00041732

.global uart_init
uart_init:
jmp 0x00042ba8

.global ernie_read
ernie_read:
jmp 0x00041226

.global test
test:
jmp 0x00042176

.global pervasive_control_gate
pervasive_control_gate:
jmp 0x0004222e

.global i2c_transfer_read
i2c_transfer_read:
jmp 0x00041c54

.global gpio_enable_port
gpio_enable_port:
jmp 0x00041b0a

.global gpio_port_set
gpio_port_set:
jmp 0x00041992

.global gpio_query_intr
gpio_query_intr:
jmp 0x00041a1a

.global spi_read
spi_read:
jmp 0x00042b86

.global ernie_exec_cmd_short
ernie_exec_cmd_short:
jmp 0x000413ce

.global cbus_write
cbus_write:
jmp 0x00042e1e

.global glitch_init
glitch_init:
jmp 0x0004189c

.global spi_read_end
spi_read_end:
jmp 0x00042b92

.global memcmp
memcmp:
jmp 0x00040626

.global set_exception_table
set_exception_table:
jmp 0x000417f0

.global uart_scann
uart_scann:
jmp 0x00042d16

.global init
init:
jmp 0x000420a6

.global i2c_init_bus
i2c_init_bus:
jmp 0x00041b86

.global alice_handleCmd
alice_handleCmd:
jmp 0x000403ae

.global crypto_waitStopBigmacOps
crypto_waitStopBigmacOps:
jmp 0x00040d0a

.global compat_pListCopy
compat_pListCopy:
jmp 0x00040a2a

.global gpio_set_intr_mode
gpio_set_intr_mode:
jmp 0x000419d2

.global ernie_init
ernie_init:
jmp 0x00041520

.global memset
memset:
jmp 0x000405bc

.global get_build_timestamp
get_build_timestamp:
jmp 0x00042e68

.global gpio_acquire_intr
gpio_acquire_intr:
jmp 0x00041a86

.global writeAs
writeAs:
jmp 0x00041f6a

.global delay
delay:
jmp 0x00042dca

.global rpc_loop
rpc_loop:
jmp 0x000429cc

.global jig_update_shared_buffer
jig_update_shared_buffer:
jmp 0x00041d56

.global ce_framework
ce_framework:
jmp 0x00042022

.global cbus_read
cbus_read:
jmp 0x00042df6

.global uart_scanns
uart_scanns:
jmp 0x00042d68

.global keyring_slot_prot
keyring_slot_prot:
jmp 0x00041ffc

.global spi_write_end
spi_write_end:
jmp 0x00042b4e

.global spi_write
spi_write:
jmp 0x00042b6a

.global stub
stub:
jmp 0x00042eee

.global compat_killArm
compat_killArm:
jmp 0x00040bc2

.global ernie_write
ernie_write:
jmp 0x000411ce

.global c_SWI
c_SWI:
jmp 0x000415ea

.global debug_printRange
debug_printRange:
jmp 0x0004111c

.global uart_read
uart_read:
jmp 0x00042c54

.global spi_read_available
spi_read_available:
jmp 0x00042b78

.global gpio_port_clear
gpio_port_clear:
jmp 0x000419b2

.global strlen
strlen:
jmp 0x0004066a

.global c_DBG
c_DBG:
jmp 0x000417c6

.global gpio_init
gpio_init:
jmp 0x00041b26

.global alice_schedule_bob_task
alice_schedule_bob_task:
jmp 0x0004010a

.global crypto_memset
crypto_memset:
jmp 0x00040d94

.global c_RESET
c_RESET:
jmp 0x000415a2

.global compat_Cry2Arm0
compat_Cry2Arm0:
jmp 0x00040678

