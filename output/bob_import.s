.global setup_ints
setup_ints:
jmp 0x000431ac

.global gpio_port_read
gpio_port_read:
jmp 0x00041a22

.global ernie_3auth_single
ernie_3auth_single:
jmp 0x00041490

.global i2c_transfer_write
i2c_transfer_write:
jmp 0x00041c9e

.global c_OTHER_EXC
c_OTHER_EXC:
jmp 0x00041808

.global sm_loadstart
sm_loadstart:
jmp 0x00042dd0

.global alice_schedule_task
alice_schedule_task:
jmp 0x000402e2

.global compat_armReBoot
compat_armReBoot:
jmp 0x00040a74

.global uart_printn
uart_printn:
jmp 0x00042fe2

.global c_IRQ
c_IRQ:
jmp 0x000416f6

.global alice_get_task_status
alice_get_task_status:
jmp 0x000400d8

.global debug_setGpoCode
debug_setGpoCode:
jmp 0x000411e0

.global spi_write_start
spi_write_start:
jmp 0x00042e36

.global pervasive_control_clock
pervasive_control_clock:
jmp 0x0004231e

.global uart_write
uart_write:
jmp 0x00042f40

.global alice_stopReloadAlice
alice_stopReloadAlice:
jmp 0x00040264

.global set_dbg_mode
set_dbg_mode:
jmp 0x00043156

.global regina_sendCmd
regina_sendCmd:
jmp 0x00042436

.global compat_handleAllegrex
compat_handleAllegrex:
jmp 0x00040c46

.global memcpy
memcpy:
jmp 0x000405e8

.global jig_read_shared_buffer
jig_read_shared_buffer:
jmp 0x00041efc

.global uart_print
uart_print:
jmp 0x00042fb0

.global c_ARM_REQ
c_ARM_REQ:
jmp 0x00041754

.global ernie_exec
ernie_exec:
jmp 0x00041346

.global gpio_set_port_mode
gpio_set_port_mode:
jmp 0x00041a04

.global ernie_exec_cmd
ernie_exec_cmd:
jmp 0x000413e2

.global spi_init
spi_init:
jmp 0x00042dd4

.global PANIC
PANIC:
jmp 0x00041838

.global pervasive_control_misc
pervasive_control_misc:
jmp 0x00042348

.global readAs
readAs:
jmp 0x00041fda

.global i2c_transfer_write_read
i2c_transfer_write_read:
jmp 0x00041d64

.global keyring_slot_data
keyring_slot_data:
jmp 0x00042034

.global compat_IRQ7_handleCmd
compat_IRQ7_handleCmd:
jmp 0x000408d8

.global debug_c_regdump
debug_c_regdump:
jmp 0x0004120a

.global enable_icache
enable_icache:
jmp 0x0004317a

.global debug_printFormat
debug_printFormat:
jmp 0x00040eea

.global regina_loadRegina
regina_loadRegina:
jmp 0x0004236e

.global uart_rxfifo_flush
uart_rxfifo_flush:
jmp 0x00042f90

.global alice_loadAlice
alice_loadAlice:
jmp 0x00040178

.global memset32
memset32:
jmp 0x0004059a

.global crypto_bigmacDefaultCmd
crypto_bigmacDefaultCmd:
jmp 0x00040cec

.global debug_printU32
debug_printU32:
jmp 0x00040e76

.global memset8
memset8:
jmp 0x00040574

.global pervasive_control_reset
pervasive_control_reset:
jmp 0x0004228a

.global glitch_test
glitch_test:
jmp 0x000418fe

.global c_OTHER_INT
c_OTHER_INT:
jmp 0x000417d8

.global uart_init
uart_init:
jmp 0x00042eb0

.global ernie_read
ernie_read:
jmp 0x000412cc

.global test
test:
jmp 0x0004221c

.global pervasive_control_gate
pervasive_control_gate:
jmp 0x000422d4

.global i2c_transfer_read
i2c_transfer_read:
jmp 0x00041cfa

.global gpio_enable_port
gpio_enable_port:
jmp 0x00041bb0

.global gpio_port_set
gpio_port_set:
jmp 0x00041a38

.global gpio_query_intr
gpio_query_intr:
jmp 0x00041ac0

.global spi_read
spi_read:
jmp 0x00042e8e

.global ernie_exec_cmd_short
ernie_exec_cmd_short:
jmp 0x00041474

.global cbus_write
cbus_write:
jmp 0x00043126

.global glitch_init
glitch_init:
jmp 0x00041942

.global spi_read_end
spi_read_end:
jmp 0x00042e9a

.global memcmp
memcmp:
jmp 0x00040626

.global set_exception_table
set_exception_table:
jmp 0x00041896

.global uart_scann
uart_scann:
jmp 0x0004301e

.global init
init:
jmp 0x0004214c

.global i2c_init_bus
i2c_init_bus:
jmp 0x00041c2c

.global alice_handleCmd
alice_handleCmd:
jmp 0x000403ae

.global crypto_waitStopBigmacOps
crypto_waitStopBigmacOps:
jmp 0x00040db0

.global compat_pListCopy
compat_pListCopy:
jmp 0x00040a2a

.global gpio_set_intr_mode
gpio_set_intr_mode:
jmp 0x00041a78

.global ernie_init
ernie_init:
jmp 0x000415c6

.global memset
memset:
jmp 0x000405bc

.global get_build_timestamp
get_build_timestamp:
jmp 0x00043170

.global gpio_acquire_intr
gpio_acquire_intr:
jmp 0x00041b2c

.global writeAs
writeAs:
jmp 0x00042010

.global delay
delay:
jmp 0x000430d2

.global rpc_loop
rpc_loop:
jmp 0x00042cd4

.global jig_update_shared_buffer
jig_update_shared_buffer:
jmp 0x00041dfc

.global ce_framework
ce_framework:
jmp 0x000420c8

.global cbus_read
cbus_read:
jmp 0x000430fe

.global uart_scanns
uart_scanns:
jmp 0x00043070

.global keyring_slot_prot
keyring_slot_prot:
jmp 0x000420a2

.global spi_write_end
spi_write_end:
jmp 0x00042e56

.global spi_write
spi_write:
jmp 0x00042e72

.global stub
stub:
jmp 0x000431f6

.global compat_killArm
compat_killArm:
jmp 0x00040bc2

.global ernie_write
ernie_write:
jmp 0x00041274

.global c_SWI
c_SWI:
jmp 0x00041690

.global debug_printRange
debug_printRange:
jmp 0x000411c2

.global uart_read
uart_read:
jmp 0x00042f5c

.global spi_read_available
spi_read_available:
jmp 0x00042e80

.global gpio_port_clear
gpio_port_clear:
jmp 0x00041a58

.global strlen
strlen:
jmp 0x0004066a

.global c_DBG
c_DBG:
jmp 0x0004186c

.global gpio_init
gpio_init:
jmp 0x00041bcc

.global alice_schedule_bob_task
alice_schedule_bob_task:
jmp 0x0004010a

.global crypto_memset
crypto_memset:
jmp 0x00040e3a

.global c_RESET
c_RESET:
jmp 0x00041648

.global compat_Cry2Arm0
compat_Cry2Arm0:
jmp 0x00040678

