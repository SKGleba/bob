.global setup_ints
setup_ints:
jmp 0x000411ba

.global gpio_port_read
gpio_port_read:
jmp 0x00041222

.global ernie_3auth_single
ernie_3auth_single:
jmp 0x00042422

.global i2c_transfer_write
i2c_transfer_write:
jmp 0x00040418

.global c_OTHER_EXC
c_OTHER_EXC:
jmp 0x00040af6

.global sm_loadstart
sm_loadstart:
jmp 0x00040d12

.global compat_armReBoot
compat_armReBoot:
jmp 0x000417f6

.global uart_printn
uart_printn:
jmp 0x00040716

.global c_IRQ
c_IRQ:
jmp 0x000409b2

.global debug_setGpoCode
debug_setGpoCode:
jmp 0x00041eb8

.global spi_write_start
spi_write_start:
jmp 0x0004218c

.global pervasive_control_clock
pervasive_control_clock:
jmp 0x000405f4

.global uart_write
uart_write:
jmp 0x000406c8

.global set_dbg_mode
set_dbg_mode:
jmp 0x00041164

.global memcpy
memcpy:
jmp 0x00040308

.global jig_read_shared_buffer
jig_read_shared_buffer:
jmp 0x0004204c

.global uart_print
uart_print:
jmp 0x000406e4

.global c_ARM_REQ
c_ARM_REQ:
jmp 0x00040a24

.global ernie_exec
ernie_exec:
jmp 0x000422d8

.global gpio_set_port_mode
gpio_set_port_mode:
jmp 0x00041204

.global ernie_exec_cmd
ernie_exec_cmd:
jmp 0x00042374

.global spi_init
spi_init:
jmp 0x0004212a

.global PANIC
PANIC:
jmp 0x00040b30

.global pervasive_control_misc
pervasive_control_misc:
jmp 0x00040618

.global readAs
readAs:
jmp 0x00040c24

.global i2c_transfer_write_read
i2c_transfer_write_read:
jmp 0x000404da

.global keyring_slot_data
keyring_slot_data:
jmp 0x00040c7e

.global compat_IRQ7_handleCmd
compat_IRQ7_handleCmd:
jmp 0x0004167e

.global debug_c_regdump
debug_c_regdump:
jmp 0x00041ee2

.global enable_icache
enable_icache:
jmp 0x00041188

.global debug_printFormat
debug_printFormat:
jmp 0x00041bc2

.global memset32
memset32:
jmp 0x000402b6

.global crypto_bigmacDefaultCmd
crypto_bigmacDefaultCmd:
jmp 0x00040752

.global debug_printU32
debug_printU32:
jmp 0x00041b4e

.global memset8
memset8:
jmp 0x00040290

.global pervasive_control_reset
pervasive_control_reset:
jmp 0x0004056c

.global glitch_test
glitch_test:
jmp 0x000425da

.global c_OTHER_INT
c_OTHER_INT:
jmp 0x00040abc

.global uart_init
uart_init:
jmp 0x00040638

.global ernie_read
ernie_read:
jmp 0x0004225e

.global test
test:
jmp 0x00041abc

.global pervasive_control_gate
pervasive_control_gate:
jmp 0x000405b0

.global i2c_transfer_read
i2c_transfer_read:
jmp 0x00040472

.global gpio_enable_port
gpio_enable_port:
jmp 0x000413b0

.global gpio_port_set
gpio_port_set:
jmp 0x00041238

.global gpio_query_intr
gpio_query_intr:
jmp 0x000412c0

.global spi_read
spi_read:
jmp 0x000421e4

.global ernie_exec_cmd_short
ernie_exec_cmd_short:
jmp 0x00042406

.global cbus_write
cbus_write:
jmp 0x00041134

.global glitch_init
glitch_init:
jmp 0x00042630

.global spi_read_end
spi_read_end:
jmp 0x000421f0

.global memcmp
memcmp:
jmp 0x00040346

.global set_exception_table
set_exception_table:
jmp 0x00040bbc

.global init
init:
jmp 0x000419de

.global i2c_init_bus
i2c_init_bus:
jmp 0x000403a6

.global alice_handleCmd
alice_handleCmd:
jmp 0x000400d4

.global crypto_waitStopBigmacOps
crypto_waitStopBigmacOps:
jmp 0x00040816

.global compat_pListCopy
compat_pListCopy:
jmp 0x000417ac

.global gpio_set_intr_mode
gpio_set_intr_mode:
jmp 0x00041278

.global ernie_init
ernie_init:
jmp 0x00042558

.global memset
memset:
jmp 0x000402d8

.global get_build_timestamp
get_build_timestamp:
jmp 0x0004117e

.global gpio_acquire_intr
gpio_acquire_intr:
jmp 0x0004132c

.global writeAs
writeAs:
jmp 0x00040c5a

.global delay
delay:
jmp 0x000410e0

.global rpc_loop
rpc_loop:
jmp 0x00040d14

.global jig_update_shared_buffer
jig_update_shared_buffer:
jmp 0x00041f4c

.global ce_framework
ce_framework:
jmp 0x00041944

.global cbus_read
cbus_read:
jmp 0x0004110c

.global keyring_slot_prot
keyring_slot_prot:
jmp 0x00040cec

.global spi_write_end
spi_write_end:
jmp 0x000421ac

.global spi_write
spi_write:
jmp 0x000421c8

.global ernie_write
ernie_write:
jmp 0x00042206

.global c_SWI
c_SWI:
jmp 0x00040938

.global debug_printRange
debug_printRange:
jmp 0x00041e9a

.global spi_read_available
spi_read_available:
jmp 0x000421d6

.global gpio_port_clear
gpio_port_clear:
jmp 0x00041258

.global strlen
strlen:
jmp 0x0004038a

.global c_DBG
c_DBG:
jmp 0x00040b6e

.global gpio_init
gpio_init:
jmp 0x000413cc

.global crypto_memset
crypto_memset:
jmp 0x000408a0

.global c_RESET
c_RESET:
jmp 0x000408dc

.global compat_Cry2Arm0
compat_Cry2Arm0:
jmp 0x0004141e

