.global setup_ints
setup_ints:
jmp 0x00042832

.global gpio_port_read
gpio_port_read:
jmp 0x0004180e

.global ernie_3auth_single
ernie_3auth_single:
jmp 0x00041280

.global i2c_transfer_write
i2c_transfer_write:
jmp 0x00041a8a

.global c_OTHER_EXC
c_OTHER_EXC:
jmp 0x000415f8

.global sm_loadstart
sm_loadstart:
jmp 0x00042560

.global alice_schedule_task
alice_schedule_task:
jmp 0x0004024e

.global compat_armReBoot
compat_armReBoot:
jmp 0x0004098e

.global uart_printn
uart_printn:
jmp 0x0004271c

.global c_IRQ
c_IRQ:
jmp 0x000414e6

.global alice_get_task_status
alice_get_task_status:
jmp 0x000400d4

.global debug_setGpoCode
debug_setGpoCode:
jmp 0x00040fd0

.global spi_write_start
spi_write_start:
jmp 0x000425c4

.global pervasive_control_clock
pervasive_control_clock:
jmp 0x0004210c

.global uart_write
uart_write:
jmp 0x000426ce

.global set_dbg_mode
set_dbg_mode:
jmp 0x000427dc

.global memcpy
memcpy:
jmp 0x0004054c

.global jig_read_shared_buffer
jig_read_shared_buffer:
jmp 0x00041cde

.global uart_print
uart_print:
jmp 0x000426ea

.global c_ARM_REQ
c_ARM_REQ:
jmp 0x00041544

.global ernie_exec
ernie_exec:
jmp 0x00041136

.global gpio_set_port_mode
gpio_set_port_mode:
jmp 0x000417f0

.global ernie_exec_cmd
ernie_exec_cmd:
jmp 0x000411d2

.global spi_init
spi_init:
jmp 0x00042562

.global PANIC
PANIC:
jmp 0x00041628

.global pervasive_control_misc
pervasive_control_misc:
jmp 0x00042130

.global readAs
readAs:
jmp 0x00041dbc

.global i2c_transfer_write_read
i2c_transfer_write_read:
jmp 0x00041b4c

.global keyring_slot_data
keyring_slot_data:
jmp 0x00041e16

.global compat_IRQ7_handleCmd
compat_IRQ7_handleCmd:
jmp 0x0004083c

.global debug_c_regdump
debug_c_regdump:
jmp 0x00040ffa

.global enable_icache
enable_icache:
jmp 0x00042800

.global debug_printFormat
debug_printFormat:
jmp 0x00040cda

.global alice_loadAlice
alice_loadAlice:
jmp 0x00040162

.global memset32
memset32:
jmp 0x000404fa

.global crypto_bigmacDefaultCmd
crypto_bigmacDefaultCmd:
jmp 0x00040adc

.global debug_printU32
debug_printU32:
jmp 0x00040c66

.global memset8
memset8:
jmp 0x000404d4

.global pervasive_control_reset
pervasive_control_reset:
jmp 0x00042084

.global glitch_test
glitch_test:
jmp 0x000416ea

.global c_OTHER_INT
c_OTHER_INT:
jmp 0x000415c8

.global uart_init
uart_init:
jmp 0x0004263e

.global ernie_read
ernie_read:
jmp 0x000410bc

.global test
test:
jmp 0x00041fec

.global pervasive_control_gate
pervasive_control_gate:
jmp 0x000420c8

.global i2c_transfer_read
i2c_transfer_read:
jmp 0x00041ae4

.global gpio_enable_port
gpio_enable_port:
jmp 0x0004199c

.global gpio_port_set
gpio_port_set:
jmp 0x00041824

.global gpio_query_intr
gpio_query_intr:
jmp 0x000418ac

.global spi_read
spi_read:
jmp 0x0004261c

.global ernie_exec_cmd_short
ernie_exec_cmd_short:
jmp 0x00041264

.global cbus_write
cbus_write:
jmp 0x000427ac

.global glitch_init
glitch_init:
jmp 0x0004172e

.global spi_read_end
spi_read_end:
jmp 0x00042628

.global memcmp
memcmp:
jmp 0x0004058a

.global set_exception_table
set_exception_table:
jmp 0x00041686

.global init
init:
jmp 0x00041f2c

.global i2c_init_bus
i2c_init_bus:
jmp 0x00041a18

.global alice_handleCmd
alice_handleCmd:
jmp 0x0004031a

.global crypto_waitStopBigmacOps
crypto_waitStopBigmacOps:
jmp 0x00040ba0

.global compat_pListCopy
compat_pListCopy:
jmp 0x00040944

.global gpio_set_intr_mode
gpio_set_intr_mode:
jmp 0x00041864

.global ernie_init
ernie_init:
jmp 0x000413b6

.global memset
memset:
jmp 0x0004051c

.global get_build_timestamp
get_build_timestamp:
jmp 0x000427f6

.global gpio_acquire_intr
gpio_acquire_intr:
jmp 0x00041918

.global writeAs
writeAs:
jmp 0x00041df2

.global delay
delay:
jmp 0x00042758

.global rpc_loop
rpc_loop:
jmp 0x00042150

.global jig_update_shared_buffer
jig_update_shared_buffer:
jmp 0x00041bde

.global ce_framework
ce_framework:
jmp 0x00041eaa

.global cbus_read
cbus_read:
jmp 0x00042784

.global keyring_slot_prot
keyring_slot_prot:
jmp 0x00041e84

.global spi_write_end
spi_write_end:
jmp 0x000425e4

.global spi_write
spi_write:
jmp 0x00042600

.global ernie_write
ernie_write:
jmp 0x00041064

.global c_SWI
c_SWI:
jmp 0x00041480

.global debug_printRange
debug_printRange:
jmp 0x00040fb2

.global spi_read_available
spi_read_available:
jmp 0x0004260e

.global gpio_port_clear
gpio_port_clear:
jmp 0x00041844

.global strlen
strlen:
jmp 0x000405ce

.global c_DBG
c_DBG:
jmp 0x0004165c

.global gpio_init
gpio_init:
jmp 0x000419b8

.global alice_schedule_bob_task
alice_schedule_bob_task:
jmp 0x00040106

.global crypto_memset
crypto_memset:
jmp 0x00040c2a

.global c_RESET
c_RESET:
jmp 0x00041438

.global compat_Cry2Arm0
compat_Cry2Arm0:
jmp 0x000405dc

