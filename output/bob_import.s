.global setup_ints
setup_ints:
jmp 0x00042d74

.global gpio_port_read
gpio_port_read:
jmp 0x00041928

.global ernie_3auth_single
ernie_3auth_single:
jmp 0x0004139a

.global i2c_transfer_write
i2c_transfer_write:
jmp 0x00041ba4

.global c_OTHER_EXC
c_OTHER_EXC:
jmp 0x00041712

.global sm_loadstart
sm_loadstart:
jmp 0x0004299c

.global alice_schedule_task
alice_schedule_task:
jmp 0x000402c4

.global compat_armReBoot
compat_armReBoot:
jmp 0x00040a24

.global uart_printn
uart_printn:
jmp 0x00042baa

.global c_IRQ
c_IRQ:
jmp 0x00041600

.global alice_get_task_status
alice_get_task_status:
jmp 0x000400d8

.global debug_setGpoCode
debug_setGpoCode:
jmp 0x000410ea

.global spi_write_start
spi_write_start:
jmp 0x00042a00

.global pervasive_control_clock
pervasive_control_clock:
jmp 0x00042200

.global uart_write
uart_write:
jmp 0x00042b0a

.global alice_stopReloadAlice
alice_stopReloadAlice:
jmp 0x00040252

.global set_dbg_mode
set_dbg_mode:
jmp 0x00042d1e

.global memcpy
memcpy:
jmp 0x000405d0

.global jig_read_shared_buffer
jig_read_shared_buffer:
jmp 0x00041df8

.global uart_print
uart_print:
jmp 0x00042b78

.global c_ARM_REQ
c_ARM_REQ:
jmp 0x0004165e

.global ernie_exec
ernie_exec:
jmp 0x00041250

.global gpio_set_port_mode
gpio_set_port_mode:
jmp 0x0004190a

.global ernie_exec_cmd
ernie_exec_cmd:
jmp 0x000412ec

.global spi_init
spi_init:
jmp 0x0004299e

.global PANIC
PANIC:
jmp 0x00041742

.global pervasive_control_misc
pervasive_control_misc:
jmp 0x00042224

.global readAs
readAs:
jmp 0x00041ed6

.global i2c_transfer_write_read
i2c_transfer_write_read:
jmp 0x00041c66

.global keyring_slot_data
keyring_slot_data:
jmp 0x00041f30

.global compat_IRQ7_handleCmd
compat_IRQ7_handleCmd:
jmp 0x000408c0

.global debug_c_regdump
debug_c_regdump:
jmp 0x00041114

.global enable_icache
enable_icache:
jmp 0x00042d42

.global debug_printFormat
debug_printFormat:
jmp 0x00040df4

.global uart_rxfifo_flush
uart_rxfifo_flush:
jmp 0x00042b5a

.global alice_loadAlice
alice_loadAlice:
jmp 0x00040166

.global memset32
memset32:
jmp 0x0004057e

.global crypto_bigmacDefaultCmd
crypto_bigmacDefaultCmd:
jmp 0x00040bf6

.global debug_printU32
debug_printU32:
jmp 0x00040d80

.global memset8
memset8:
jmp 0x00040558

.global pervasive_control_reset
pervasive_control_reset:
jmp 0x00042178

.global glitch_test
glitch_test:
jmp 0x00041804

.global c_OTHER_INT
c_OTHER_INT:
jmp 0x000416e2

.global uart_init
uart_init:
jmp 0x00042a7a

.global ernie_read
ernie_read:
jmp 0x000411d6

.global test
test:
jmp 0x00042116

.global pervasive_control_gate
pervasive_control_gate:
jmp 0x000421bc

.global i2c_transfer_read
i2c_transfer_read:
jmp 0x00041bfe

.global gpio_enable_port
gpio_enable_port:
jmp 0x00041ab6

.global gpio_port_set
gpio_port_set:
jmp 0x0004193e

.global gpio_query_intr
gpio_query_intr:
jmp 0x000419c6

.global spi_read
spi_read:
jmp 0x00042a58

.global ernie_exec_cmd_short
ernie_exec_cmd_short:
jmp 0x0004137e

.global cbus_write
cbus_write:
jmp 0x00042cee

.global glitch_init
glitch_init:
jmp 0x00041848

.global spi_read_end
spi_read_end:
jmp 0x00042a64

.global memcmp
memcmp:
jmp 0x0004060e

.global set_exception_table
set_exception_table:
jmp 0x000417a0

.global uart_scann
uart_scann:
jmp 0x00042be6

.global init
init:
jmp 0x00042046

.global i2c_init_bus
i2c_init_bus:
jmp 0x00041b32

.global alice_handleCmd
alice_handleCmd:
jmp 0x00040390

.global crypto_waitStopBigmacOps
crypto_waitStopBigmacOps:
jmp 0x00040cba

.global compat_pListCopy
compat_pListCopy:
jmp 0x000409da

.global gpio_set_intr_mode
gpio_set_intr_mode:
jmp 0x0004197e

.global ernie_init
ernie_init:
jmp 0x000414d0

.global memset
memset:
jmp 0x000405a0

.global get_build_timestamp
get_build_timestamp:
jmp 0x00042d38

.global gpio_acquire_intr
gpio_acquire_intr:
jmp 0x00041a32

.global writeAs
writeAs:
jmp 0x00041f0c

.global delay
delay:
jmp 0x00042c9a

.global rpc_loop
rpc_loop:
jmp 0x000428a2

.global jig_update_shared_buffer
jig_update_shared_buffer:
jmp 0x00041cf8

.global ce_framework
ce_framework:
jmp 0x00041fc4

.global cbus_read
cbus_read:
jmp 0x00042cc6

.global uart_scanns
uart_scanns:
jmp 0x00042c38

.global keyring_slot_prot
keyring_slot_prot:
jmp 0x00041f9e

.global spi_write_end
spi_write_end:
jmp 0x00042a20

.global spi_write
spi_write:
jmp 0x00042a3c

.global compat_killArm
compat_killArm:
jmp 0x00040b72

.global ernie_write
ernie_write:
jmp 0x0004117e

.global c_SWI
c_SWI:
jmp 0x0004159a

.global debug_printRange
debug_printRange:
jmp 0x000410cc

.global uart_read
uart_read:
jmp 0x00042b26

.global spi_read_available
spi_read_available:
jmp 0x00042a4a

.global gpio_port_clear
gpio_port_clear:
jmp 0x0004195e

.global strlen
strlen:
jmp 0x00040652

.global c_DBG
c_DBG:
jmp 0x00041776

.global gpio_init
gpio_init:
jmp 0x00041ad2

.global alice_schedule_bob_task
alice_schedule_bob_task:
jmp 0x0004010a

.global crypto_memset
crypto_memset:
jmp 0x00040d44

.global c_RESET
c_RESET:
jmp 0x00041552

.global compat_Cry2Arm0
compat_Cry2Arm0:
jmp 0x00040660

