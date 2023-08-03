.global gpio_port_read
gpio_port_read:
jmp 0x00040e7e

.global compat_f00dState
compat_f00dState:
jmp 0x0004107a

.global ernie_3auth_single
ernie_3auth_single:
jmp 0x00041da6

.global i2c_transfer_write
i2c_transfer_write:
jmp 0x00040248

.global c_OTHER_EXC
c_OTHER_EXC:
jmp 0x000408d2

.global sm_loadstart
sm_loadstart:
jmp 0x00040a86

.global uart_printn
uart_printn:
jmp 0x00040502

.global c_IRQ
c_IRQ:
jmp 0x0004079e

.global debug_setGpoCode
debug_setGpoCode:
jmp 0x0004183c

.global spi_write_start
spi_write_start:
jmp 0x00041b10

.global uart_write
uart_write:
jmp 0x000404b4

.global set_dbg_mode
set_dbg_mode:
jmp 0x00040e0a

.global memcpy
memcpy:
jmp 0x00040138

.global jig_read_shared_buffer
jig_read_shared_buffer:
jmp 0x000419d0

.global uart_print
uart_print:
jmp 0x000404d0

.global c_ARM_REQ
c_ARM_REQ:
jmp 0x00040810

.global ernie_exec
ernie_exec:
jmp 0x00041c5c

.global gpio_set_port_mode
gpio_set_port_mode:
jmp 0x00040e60

.global ernie_exec_cmd
ernie_exec_cmd:
jmp 0x00041cf8

.global spi_init
spi_init:
jmp 0x00041aae

.global PANIC
PANIC:
jmp 0x0004090c

.global readAs
readAs:
jmp 0x00040998

.global i2c_transfer_write_read
i2c_transfer_write_read:
jmp 0x0004030a

.global keyring_slot_data
keyring_slot_data:
jmp 0x000409f2

.global compat_IRQ7_handleCmd
compat_IRQ7_handleCmd:
jmp 0x000412f6

.global debug_c_regdump
debug_c_regdump:
jmp 0x00041866

.global enable_icache
enable_icache:
jmp 0x00040e2e

.global debug_printFormat
debug_printFormat:
jmp 0x0004168a

.global memset32
memset32:
jmp 0x000400e6

.global crypto_bigmacDefaultCmd
crypto_bigmacDefaultCmd:
jmp 0x0004053e

.global debug_printU32
debug_printU32:
jmp 0x00041616

.global memset8
memset8:
jmp 0x000400c0

.global pervasive_control_reset
pervasive_control_reset:
jmp 0x0004039c

.global glitch_test
glitch_test:
jmp 0x00041f5e

.global c_OTHER_INT
c_OTHER_INT:
jmp 0x00040898

.global uart_init
uart_init:
jmp 0x00040424

.global ernie_read
ernie_read:
jmp 0x00041be2

.global test
test:
jmp 0x00041594

.global pervasive_control_gate
pervasive_control_gate:
jmp 0x000403e0

.global i2c_transfer_read
i2c_transfer_read:
jmp 0x000402a2

.global gpio_enable_port
gpio_enable_port:
jmp 0x0004100c

.global gpio_port_set
gpio_port_set:
jmp 0x00040e94

.global gpio_query_intr
gpio_query_intr:
jmp 0x00040f1c

.global spi_read
spi_read:
jmp 0x00041b68

.global ernie_exec_cmd_short
ernie_exec_cmd_short:
jmp 0x00041d8a

.global cbus_write
cbus_write:
jmp 0x00040dee

.global glitch_init
glitch_init:
jmp 0x00041fb4

.global spi_read_end
spi_read_end:
jmp 0x00041b74

.global memcmp
memcmp:
jmp 0x00040176

.global init
init:
jmp 0x000414b6

.global i2c_init_bus
i2c_init_bus:
jmp 0x000401d6

.global crypto_waitStopBigmacOps
crypto_waitStopBigmacOps:
jmp 0x00040602

.global compat_pListCopy
compat_pListCopy:
jmp 0x000413d2

.global gpio_set_intr_mode
gpio_set_intr_mode:
jmp 0x00040ed4

.global ernie_init
ernie_init:
jmp 0x00041edc

.global memset
memset:
jmp 0x00040108

.global get_build_timestamp
get_build_timestamp:
jmp 0x00040e24

.global gpio_acquire_intr
gpio_acquire_intr:
jmp 0x00040f88

.global writeAs
writeAs:
jmp 0x000409ce

.global delay
delay:
jmp 0x00040daa

.global rpc_loop
rpc_loop:
jmp 0x00040a88

.global jig_update_shared_buffer
jig_update_shared_buffer:
jmp 0x000418d0

.global ce_framework
ce_framework:
jmp 0x0004141c

.global cbus_read
cbus_read:
jmp 0x00040dd6

.global keyring_slot_prot
keyring_slot_prot:
jmp 0x00040a60

.global spi_write_end
spi_write_end:
jmp 0x00041b30

.global spi_write
spi_write:
jmp 0x00041b4c

.global ernie_write
ernie_write:
jmp 0x00041b8a

.global c_SWI
c_SWI:
jmp 0x00040724

.global debug_printRange
debug_printRange:
jmp 0x00041786

.global spi_read_available
spi_read_available:
jmp 0x00041b5a

.global gpio_port_clear
gpio_port_clear:
jmp 0x00040eb4

.global strlen
strlen:
jmp 0x000401ba

.global c_DBG
c_DBG:
jmp 0x0004094a

.global gpio_init
gpio_init:
jmp 0x00041028

.global crypto_memset
crypto_memset:
jmp 0x0004068c

.global c_RESET
c_RESET:
jmp 0x000406c8

.global compat_Cry2Arm0
compat_Cry2Arm0:
jmp 0x0004109e

