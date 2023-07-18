.global gpio_port_read
gpio_port_read:
jmp 0x00040d3e

.global compat_f00dState
compat_f00dState:
jmp 0x00040f1e

.global i2c_transfer_write
i2c_transfer_write:
jmp 0x00040248

.global c_OTHER_EXC
c_OTHER_EXC:
jmp 0x00040848

.global sm_loadstart
sm_loadstart:
jmp 0x000409f2

.global uart_printn
uart_printn:
jmp 0x000404fe

.global c_IRQ
c_IRQ:
jmp 0x0004073c

.global debug_setGpoCode
debug_setGpoCode:
jmp 0x00041648

.global spi_write_start
spi_write_start:
jmp 0x00041904

.global uart_write
uart_write:
jmp 0x000404b0

.global set_dbg_mode
set_dbg_mode:
jmp 0x00040cca

.global memcpy
memcpy:
jmp 0x00040138

.global jig_read_shared_buffer
jig_read_shared_buffer:
jmp 0x000417cc

.global uart_print
uart_print:
jmp 0x000404cc

.global c_ARM_REQ
c_ARM_REQ:
jmp 0x0004079a

.global ernie_exec
ernie_exec:
jmp 0x00041a50

.global gpio_set_port_mode
gpio_set_port_mode:
jmp 0x00040d20

.global ernie_exec_cmd
ernie_exec_cmd:
jmp 0x00041aca

.global spi_init
spi_init:
jmp 0x000418a2

.global PANIC
PANIC:
jmp 0x00040882

.global readAs
readAs:
jmp 0x00040904

.global i2c_transfer_write_read
i2c_transfer_write_read:
jmp 0x0004030a

.global keyring_slot_data
keyring_slot_data:
jmp 0x0004095e

.global compat_IRQ7_handleCmd
compat_IRQ7_handleCmd:
jmp 0x00041190

.global debug_c_regdump
debug_c_regdump:
jmp 0x00041672

.global enable_icache
enable_icache:
jmp 0x00040cee

.global debug_printFormat
debug_printFormat:
jmp 0x000414c0

.global memset32
memset32:
jmp 0x000400e6

.global crypto_bigmacDefaultCmd
crypto_bigmacDefaultCmd:
jmp 0x0004053a

.global debug_printU32
debug_printU32:
jmp 0x00041450

.global memset8
memset8:
jmp 0x000400c0

.global pervasive_control_reset
pervasive_control_reset:
jmp 0x0004039c

.global glitch_test
glitch_test:
jmp 0x00041bde

.global c_OTHER_INT
c_OTHER_INT:
jmp 0x0004080e

.global uart_init
uart_init:
jmp 0x00040420

.global ernie_read
ernie_read:
jmp 0x000419d6

.global test
test:
jmp 0x000413f4

.global pervasive_control_gate
pervasive_control_gate:
jmp 0x000403de

.global i2c_transfer_read
i2c_transfer_read:
jmp 0x000402a2

.global gpio_port_set
gpio_port_set:
jmp 0x00040d54

.global gpio_query_intr
gpio_query_intr:
jmp 0x00040ddc

.global spi_read
spi_read:
jmp 0x0004195c

.global ernie_exec_cmd_short
ernie_exec_cmd_short:
jmp 0x00041b48

.global cbus_write
cbus_write:
jmp 0x00040cae

.global glitch_init
glitch_init:
jmp 0x00041c34

.global spi_read_end
spi_read_end:
jmp 0x00041968

.global memcmp
memcmp:
jmp 0x00040176

.global init
init:
jmp 0x0004134c

.global i2c_init_bus
i2c_init_bus:
jmp 0x000401d6

.global crypto_waitStopBigmacOps
crypto_waitStopBigmacOps:
jmp 0x000405b4

.global compat_pListCopy
compat_pListCopy:
jmp 0x0004126c

.global gpio_set_intr_mode
gpio_set_intr_mode:
jmp 0x00040d94

.global ernie_init
ernie_init:
jmp 0x00041b64

.global memset
memset:
jmp 0x00040108

.global get_build_timestamp
get_build_timestamp:
jmp 0x00040ce4

.global gpio_acquire_intr
gpio_acquire_intr:
jmp 0x00040e48

.global writeAs
writeAs:
jmp 0x0004093a

.global delay
delay:
jmp 0x00040c6a

.global rpc_loop
rpc_loop:
jmp 0x000409f4

.global jig_update_shared_buffer
jig_update_shared_buffer:
jmp 0x000416cc

.global ce_framework
ce_framework:
jmp 0x000412b6

.global cbus_read
cbus_read:
jmp 0x00040c96

.global keyring_slot_prot
keyring_slot_prot:
jmp 0x000409cc

.global spi_write_end
spi_write_end:
jmp 0x00041924

.global spi_write
spi_write:
jmp 0x00041940

.global ernie_write
ernie_write:
jmp 0x0004197e

.global c_SWI
c_SWI:
jmp 0x000406cc

.global debug_printRange
debug_printRange:
jmp 0x000415aa

.global spi_read_available
spi_read_available:
jmp 0x0004194e

.global gpio_port_clear
gpio_port_clear:
jmp 0x00040d74

.global strlen
strlen:
jmp 0x000401ba

.global c_DBG
c_DBG:
jmp 0x000408c0

.global gpio_init
gpio_init:
jmp 0x00040ecc

.global crypto_memset
crypto_memset:
jmp 0x0004063e

.global c_RESET
c_RESET:
jmp 0x0004067a

.global compat_Cry2Arm0
compat_Cry2Arm0:
jmp 0x00040f3c

