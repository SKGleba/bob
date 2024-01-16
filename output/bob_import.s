.global setup_ints
setup_ints:
jmp 0x00042d8c

.global gpio_port_read
gpio_port_read:
jmp 0x00041934

.global ernie_3auth_single
ernie_3auth_single:
jmp 0x000413a6

.global i2c_transfer_write
i2c_transfer_write:
jmp 0x00041bb0

.global c_OTHER_EXC
c_OTHER_EXC:
jmp 0x0004171e

.global sm_loadstart
sm_loadstart:
jmp 0x000429b4

.global alice_schedule_task
alice_schedule_task:
jmp 0x000402d0

.global compat_armReBoot
compat_armReBoot:
jmp 0x00040a30

.global uart_printn
uart_printn:
jmp 0x00042bc2

.global c_IRQ
c_IRQ:
jmp 0x0004160c

.global alice_get_task_status
alice_get_task_status:
jmp 0x000400d8

.global debug_setGpoCode
debug_setGpoCode:
jmp 0x000410f6

.global spi_write_start
spi_write_start:
jmp 0x00042a18

.global pervasive_control_clock
pervasive_control_clock:
jmp 0x00042218

.global uart_write
uart_write:
jmp 0x00042b22

.global alice_stopReloadAlice
alice_stopReloadAlice:
jmp 0x00040252

.global set_dbg_mode
set_dbg_mode:
jmp 0x00042d36

.global memcpy
memcpy:
jmp 0x000405dc

.global jig_read_shared_buffer
jig_read_shared_buffer:
jmp 0x00041e04

.global uart_print
uart_print:
jmp 0x00042b90

.global c_ARM_REQ
c_ARM_REQ:
jmp 0x0004166a

.global ernie_exec
ernie_exec:
jmp 0x0004125c

.global gpio_set_port_mode
gpio_set_port_mode:
jmp 0x00041916

.global ernie_exec_cmd
ernie_exec_cmd:
jmp 0x000412f8

.global spi_init
spi_init:
jmp 0x000429b6

.global PANIC
PANIC:
jmp 0x0004174e

.global pervasive_control_misc
pervasive_control_misc:
jmp 0x0004223c

.global readAs
readAs:
jmp 0x00041ee2

.global i2c_transfer_write_read
i2c_transfer_write_read:
jmp 0x00041c72

.global keyring_slot_data
keyring_slot_data:
jmp 0x00041f3c

.global compat_IRQ7_handleCmd
compat_IRQ7_handleCmd:
jmp 0x000408cc

.global debug_c_regdump
debug_c_regdump:
jmp 0x00041120

.global enable_icache
enable_icache:
jmp 0x00042d5a

.global debug_printFormat
debug_printFormat:
jmp 0x00040e00

.global uart_rxfifo_flush
uart_rxfifo_flush:
jmp 0x00042b72

.global alice_loadAlice
alice_loadAlice:
jmp 0x00040166

.global memset32
memset32:
jmp 0x0004058a

.global crypto_bigmacDefaultCmd
crypto_bigmacDefaultCmd:
jmp 0x00040c02

.global debug_printU32
debug_printU32:
jmp 0x00040d8c

.global memset8
memset8:
jmp 0x00040564

.global pervasive_control_reset
pervasive_control_reset:
jmp 0x00042190

.global glitch_test
glitch_test:
jmp 0x00041810

.global c_OTHER_INT
c_OTHER_INT:
jmp 0x000416ee

.global uart_init
uart_init:
jmp 0x00042a92

.global ernie_read
ernie_read:
jmp 0x000411e2

.global test
test:
jmp 0x00042122

.global pervasive_control_gate
pervasive_control_gate:
jmp 0x000421d4

.global i2c_transfer_read
i2c_transfer_read:
jmp 0x00041c0a

.global gpio_enable_port
gpio_enable_port:
jmp 0x00041ac2

.global gpio_port_set
gpio_port_set:
jmp 0x0004194a

.global gpio_query_intr
gpio_query_intr:
jmp 0x000419d2

.global spi_read
spi_read:
jmp 0x00042a70

.global ernie_exec_cmd_short
ernie_exec_cmd_short:
jmp 0x0004138a

.global cbus_write
cbus_write:
jmp 0x00042d06

.global glitch_init
glitch_init:
jmp 0x00041854

.global spi_read_end
spi_read_end:
jmp 0x00042a7c

.global memcmp
memcmp:
jmp 0x0004061a

.global set_exception_table
set_exception_table:
jmp 0x000417ac

.global uart_scann
uart_scann:
jmp 0x00042bfe

.global init
init:
jmp 0x00042052

.global i2c_init_bus
i2c_init_bus:
jmp 0x00041b3e

.global alice_handleCmd
alice_handleCmd:
jmp 0x0004039c

.global crypto_waitStopBigmacOps
crypto_waitStopBigmacOps:
jmp 0x00040cc6

.global compat_pListCopy
compat_pListCopy:
jmp 0x000409e6

.global gpio_set_intr_mode
gpio_set_intr_mode:
jmp 0x0004198a

.global ernie_init
ernie_init:
jmp 0x000414dc

.global memset
memset:
jmp 0x000405ac

.global get_build_timestamp
get_build_timestamp:
jmp 0x00042d50

.global gpio_acquire_intr
gpio_acquire_intr:
jmp 0x00041a3e

.global writeAs
writeAs:
jmp 0x00041f18

.global delay
delay:
jmp 0x00042cb2

.global rpc_loop
rpc_loop:
jmp 0x000428ba

.global jig_update_shared_buffer
jig_update_shared_buffer:
jmp 0x00041d04

.global ce_framework
ce_framework:
jmp 0x00041fd0

.global cbus_read
cbus_read:
jmp 0x00042cde

.global uart_scanns
uart_scanns:
jmp 0x00042c50

.global keyring_slot_prot
keyring_slot_prot:
jmp 0x00041faa

.global spi_write_end
spi_write_end:
jmp 0x00042a38

.global spi_write
spi_write:
jmp 0x00042a54

.global compat_killArm
compat_killArm:
jmp 0x00040b7e

.global ernie_write
ernie_write:
jmp 0x0004118a

.global c_SWI
c_SWI:
jmp 0x000415a6

.global debug_printRange
debug_printRange:
jmp 0x000410d8

.global uart_read
uart_read:
jmp 0x00042b3e

.global spi_read_available
spi_read_available:
jmp 0x00042a62

.global gpio_port_clear
gpio_port_clear:
jmp 0x0004196a

.global strlen
strlen:
jmp 0x0004065e

.global c_DBG
c_DBG:
jmp 0x00041782

.global gpio_init
gpio_init:
jmp 0x00041ade

.global alice_schedule_bob_task
alice_schedule_bob_task:
jmp 0x0004010a

.global crypto_memset
crypto_memset:
jmp 0x00040d50

.global c_RESET
c_RESET:
jmp 0x0004155e

.global compat_Cry2Arm0
compat_Cry2Arm0:
jmp 0x0004066c

