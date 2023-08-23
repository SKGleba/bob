.global setup_ints
setup_ints:
jmp 0x000413ac

.global gpio_port_read
gpio_port_read:
jmp 0x00041414

.global ernie_3auth_single
ernie_3auth_single:
jmp 0x000425b8

.global i2c_transfer_write
i2c_transfer_write:
jmp 0x0004065c

.global c_OTHER_EXC
c_OTHER_EXC:
jmp 0x00040ce0

.global sm_loadstart
sm_loadstart:
jmp 0x00040ec0

.global alice_schedule_task
alice_schedule_task:
jmp 0x0004024e

.global compat_armReBoot
compat_armReBoot:
jmp 0x000419c2

.global uart_printn
uart_printn:
jmp 0x0004095a

.global c_IRQ
c_IRQ:
jmp 0x00040bce

.global alice_get_task_status
alice_get_task_status:
jmp 0x000400d4

.global debug_setGpoCode
debug_setGpoCode:
jmp 0x0004204e

.global spi_write_start
spi_write_start:
jmp 0x00042322

.global pervasive_control_clock
pervasive_control_clock:
jmp 0x00040838

.global uart_write
uart_write:
jmp 0x0004090c

.global set_dbg_mode
set_dbg_mode:
jmp 0x00041356

.global memcpy
memcpy:
jmp 0x0004054c

.global jig_read_shared_buffer
jig_read_shared_buffer:
jmp 0x000421e2

.global uart_print
uart_print:
jmp 0x00040928

.global c_ARM_REQ
c_ARM_REQ:
jmp 0x00040c2c

.global ernie_exec
ernie_exec:
jmp 0x0004246e

.global gpio_set_port_mode
gpio_set_port_mode:
jmp 0x000413f6

.global ernie_exec_cmd
ernie_exec_cmd:
jmp 0x0004250a

.global spi_init
spi_init:
jmp 0x000422c0

.global PANIC
PANIC:
jmp 0x00040d10

.global pervasive_control_misc
pervasive_control_misc:
jmp 0x0004085c

.global readAs
readAs:
jmp 0x00040dd2

.global i2c_transfer_write_read
i2c_transfer_write_read:
jmp 0x0004071e

.global keyring_slot_data
keyring_slot_data:
jmp 0x00040e2c

.global compat_IRQ7_handleCmd
compat_IRQ7_handleCmd:
jmp 0x00041870

.global debug_c_regdump
debug_c_regdump:
jmp 0x00042078

.global enable_icache
enable_icache:
jmp 0x0004137a

.global debug_printFormat
debug_printFormat:
jmp 0x00041d58

.global alice_loadAlice
alice_loadAlice:
jmp 0x00040162

.global memset32
memset32:
jmp 0x000404fa

.global crypto_bigmacDefaultCmd
crypto_bigmacDefaultCmd:
jmp 0x00040996

.global debug_printU32
debug_printU32:
jmp 0x00041ce4

.global memset8
memset8:
jmp 0x000404d4

.global pervasive_control_reset
pervasive_control_reset:
jmp 0x000407b0

.global glitch_test
glitch_test:
jmp 0x00042770

.global c_OTHER_INT
c_OTHER_INT:
jmp 0x00040cb0

.global uart_init
uart_init:
jmp 0x0004087c

.global ernie_read
ernie_read:
jmp 0x000423f4

.global test
test:
jmp 0x00041c52

.global pervasive_control_gate
pervasive_control_gate:
jmp 0x000407f4

.global i2c_transfer_read
i2c_transfer_read:
jmp 0x000406b6

.global gpio_enable_port
gpio_enable_port:
jmp 0x000415a2

.global gpio_port_set
gpio_port_set:
jmp 0x0004142a

.global gpio_query_intr
gpio_query_intr:
jmp 0x000414b2

.global spi_read
spi_read:
jmp 0x0004237a

.global ernie_exec_cmd_short
ernie_exec_cmd_short:
jmp 0x0004259c

.global cbus_write
cbus_write:
jmp 0x00041326

.global glitch_init
glitch_init:
jmp 0x000427b4

.global spi_read_end
spi_read_end:
jmp 0x00042386

.global memcmp
memcmp:
jmp 0x0004058a

.global set_exception_table
set_exception_table:
jmp 0x00040d6e

.global init
init:
jmp 0x00041b92

.global i2c_init_bus
i2c_init_bus:
jmp 0x000405ea

.global alice_handleCmd
alice_handleCmd:
jmp 0x0004031a

.global crypto_waitStopBigmacOps
crypto_waitStopBigmacOps:
jmp 0x00040a5a

.global compat_pListCopy
compat_pListCopy:
jmp 0x00041978

.global gpio_set_intr_mode
gpio_set_intr_mode:
jmp 0x0004146a

.global ernie_init
ernie_init:
jmp 0x000426ee

.global memset
memset:
jmp 0x0004051c

.global get_build_timestamp
get_build_timestamp:
jmp 0x00041370

.global gpio_acquire_intr
gpio_acquire_intr:
jmp 0x0004151e

.global writeAs
writeAs:
jmp 0x00040e08

.global delay
delay:
jmp 0x000412d2

.global rpc_loop
rpc_loop:
jmp 0x00040ec2

.global jig_update_shared_buffer
jig_update_shared_buffer:
jmp 0x000420e2

.global ce_framework
ce_framework:
jmp 0x00041b10

.global cbus_read
cbus_read:
jmp 0x000412fe

.global keyring_slot_prot
keyring_slot_prot:
jmp 0x00040e9a

.global spi_write_end
spi_write_end:
jmp 0x00042342

.global spi_write
spi_write:
jmp 0x0004235e

.global ernie_write
ernie_write:
jmp 0x0004239c

.global c_SWI
c_SWI:
jmp 0x00040b68

.global debug_printRange
debug_printRange:
jmp 0x00042030

.global spi_read_available
spi_read_available:
jmp 0x0004236c

.global gpio_port_clear
gpio_port_clear:
jmp 0x0004144a

.global strlen
strlen:
jmp 0x000405ce

.global c_DBG
c_DBG:
jmp 0x00040d44

.global gpio_init
gpio_init:
jmp 0x000415be

.global alice_schedule_bob_task
alice_schedule_bob_task:
jmp 0x00040106

.global crypto_memset
crypto_memset:
jmp 0x00040ae4

.global c_RESET
c_RESET:
jmp 0x00040b20

.global compat_Cry2Arm0
compat_Cry2Arm0:
jmp 0x00041610

