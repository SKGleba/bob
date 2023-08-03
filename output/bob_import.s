.global gpio_port_read
gpio_port_read:
jmp 0x00040d72

.global compat_f00dState
compat_f00dState:
jmp 0x00040f6e

.global ernie_3auth_single
ernie_3auth_single:
jmp 0x00041bcc

.global i2c_transfer_write
i2c_transfer_write:
jmp 0x00040248

.global c_OTHER_EXC
c_OTHER_EXC:
jmp 0x00040838

.global sm_loadstart
sm_loadstart:
jmp 0x000409aa

.global uart_printn
uart_printn:
jmp 0x000404fe

.global c_IRQ
c_IRQ:
jmp 0x0004075e

.global debug_setGpoCode
debug_setGpoCode:
jmp 0x0004166e

.global spi_write_start
spi_write_start:
jmp 0x00041936

.global uart_write
uart_write:
jmp 0x000404b0

.global set_dbg_mode
set_dbg_mode:
jmp 0x00040cfe

.global memcpy
memcpy:
jmp 0x00040138

.global jig_read_shared_buffer
jig_read_shared_buffer:
jmp 0x000417f6

.global uart_print
uart_print:
jmp 0x000404cc

.global c_ARM_REQ
c_ARM_REQ:
jmp 0x000407a8

.global ernie_exec
ernie_exec:
jmp 0x00041a82

.global gpio_set_port_mode
gpio_set_port_mode:
jmp 0x00040d54

.global ernie_exec_cmd
ernie_exec_cmd:
jmp 0x00041b1e

.global spi_init
spi_init:
jmp 0x000418d4

.global PANIC
PANIC:
jmp 0x00040868

.global readAs
readAs:
jmp 0x000408bc

.global i2c_transfer_write_read
i2c_transfer_write_read:
jmp 0x0004030a

.global keyring_slot_data
keyring_slot_data:
jmp 0x00040916

.global compat_IRQ7_handleCmd
compat_IRQ7_handleCmd:
jmp 0x000411ea

.global debug_c_regdump
debug_c_regdump:
jmp 0x00041698

.global enable_icache
enable_icache:
jmp 0x00040d22

.global debug_printFormat
debug_printFormat:
jmp 0x000414e2

.global memset32
memset32:
jmp 0x000400e6

.global crypto_bigmacDefaultCmd
crypto_bigmacDefaultCmd:
jmp 0x0004053a

.global debug_printU32
debug_printU32:
jmp 0x00041474

.global memset8
memset8:
jmp 0x000400c0

.global pervasive_control_reset
pervasive_control_reset:
jmp 0x0004039c

.global glitch_test
glitch_test:
jmp 0x00041d84

.global c_OTHER_INT
c_OTHER_INT:
jmp 0x00040808

.global uart_init
uart_init:
jmp 0x00040420

.global ernie_read
ernie_read:
jmp 0x00041a08

.global test
test:
jmp 0x00041420

.global pervasive_control_gate
pervasive_control_gate:
jmp 0x000403de

.global i2c_transfer_read
i2c_transfer_read:
jmp 0x000402a2

.global gpio_enable_port
gpio_enable_port:
jmp 0x00040f00

.global gpio_port_set
gpio_port_set:
jmp 0x00040d88

.global gpio_query_intr
gpio_query_intr:
jmp 0x00040e10

.global spi_read
spi_read:
jmp 0x0004198e

.global ernie_exec_cmd_short
ernie_exec_cmd_short:
jmp 0x00041bb0

.global cbus_write
cbus_write:
jmp 0x00040ce2

.global glitch_init
glitch_init:
jmp 0x00041dc8

.global spi_read_end
spi_read_end:
jmp 0x0004199a

.global memcmp
memcmp:
jmp 0x00040176

.global init
init:
jmp 0x0004136e

.global i2c_init_bus
i2c_init_bus:
jmp 0x000401d6

.global crypto_waitStopBigmacOps
crypto_waitStopBigmacOps:
jmp 0x000405fe

.global compat_pListCopy
compat_pListCopy:
jmp 0x000412a2

.global gpio_set_intr_mode
gpio_set_intr_mode:
jmp 0x00040dc8

.global ernie_init
ernie_init:
jmp 0x00041d02

.global memset
memset:
jmp 0x00040108

.global get_build_timestamp
get_build_timestamp:
jmp 0x00040d18

.global gpio_acquire_intr
gpio_acquire_intr:
jmp 0x00040e7c

.global writeAs
writeAs:
jmp 0x000408f2

.global delay
delay:
jmp 0x00040c9e

.global rpc_loop
rpc_loop:
jmp 0x000409ac

.global jig_update_shared_buffer
jig_update_shared_buffer:
jmp 0x000416f6

.global ce_framework
ce_framework:
jmp 0x000412ec

.global cbus_read
cbus_read:
jmp 0x00040cca

.global keyring_slot_prot
keyring_slot_prot:
jmp 0x00040984

.global spi_write_end
spi_write_end:
jmp 0x00041956

.global spi_write
spi_write:
jmp 0x00041972

.global ernie_write
ernie_write:
jmp 0x000419b0

.global c_SWI
c_SWI:
jmp 0x00040702

.global debug_printRange
debug_printRange:
jmp 0x000415cc

.global spi_read_available
spi_read_available:
jmp 0x00041980

.global gpio_port_clear
gpio_port_clear:
jmp 0x00040da8

.global strlen
strlen:
jmp 0x000401ba

.global c_DBG
c_DBG:
jmp 0x0004089c

.global gpio_init
gpio_init:
jmp 0x00040f1c

.global crypto_memset
crypto_memset:
jmp 0x00040688

.global c_RESET
c_RESET:
jmp 0x000406c4

.global compat_Cry2Arm0
compat_Cry2Arm0:
jmp 0x00040f92

