.global gpio_port_read
gpio_port_read:
jmp 0x0004124a

.global ernie_3auth_single
ernie_3auth_single:
jmp 0x00042150

.global i2c_transfer_write
i2c_transfer_write:
jmp 0x000405a0

.global c_OTHER_EXC
c_OTHER_EXC:
jmp 0x00040c14

.global sm_loadstart
sm_loadstart:
jmp 0x00040df8

.global uart_printn
uart_printn:
jmp 0x0004089e

.global c_IRQ
c_IRQ:
jmp 0x00040b12

.global debug_setGpoCode
debug_setGpoCode:
jmp 0x00041be6

.global spi_write_start
spi_write_start:
jmp 0x00041eba

.global pervasive_control_clock
pervasive_control_clock:
jmp 0x0004077c

.global uart_write
uart_write:
jmp 0x00040850

.global set_dbg_mode
set_dbg_mode:
jmp 0x000411d6

.global alice_setupInts
alice_setupInts:
jmp 0x00040222

.global memcpy
memcpy:
jmp 0x00040490

.global jig_read_shared_buffer
jig_read_shared_buffer:
jmp 0x00041d7a

.global uart_print
uart_print:
jmp 0x0004086c

.global c_ARM_REQ
c_ARM_REQ:
jmp 0x00040b70

.global ernie_exec
ernie_exec:
jmp 0x00042006

.global gpio_set_port_mode
gpio_set_port_mode:
jmp 0x0004122c

.global ernie_exec_cmd
ernie_exec_cmd:
jmp 0x000420a2

.global spi_init
spi_init:
jmp 0x00041e58

.global PANIC
PANIC:
jmp 0x00040c44

.global pervasive_control_misc
pervasive_control_misc:
jmp 0x000407a0

.global readAs
readAs:
jmp 0x00040d0a

.global i2c_transfer_write_read
i2c_transfer_write_read:
jmp 0x00040662

.global keyring_slot_data
keyring_slot_data:
jmp 0x00040d64

.global compat_IRQ7_handleCmd
compat_IRQ7_handleCmd:
jmp 0x000416a6

.global debug_c_regdump
debug_c_regdump:
jmp 0x00041c10

.global enable_icache
enable_icache:
jmp 0x000411fa

.global debug_printFormat
debug_printFormat:
jmp 0x00041a34

.global memset32
memset32:
jmp 0x0004043e

.global crypto_bigmacDefaultCmd
crypto_bigmacDefaultCmd:
jmp 0x000408da

.global debug_printU32
debug_printU32:
jmp 0x000419c0

.global memset8
memset8:
jmp 0x00040418

.global pervasive_control_reset
pervasive_control_reset:
jmp 0x000406f4

.global glitch_test
glitch_test:
jmp 0x00042308

.global c_OTHER_INT
c_OTHER_INT:
jmp 0x00040be4

.global uart_init
uart_init:
jmp 0x000407c0

.global ernie_read
ernie_read:
jmp 0x00041f8c

.global test
test:
jmp 0x00041944

.global pervasive_control_gate
pervasive_control_gate:
jmp 0x00040738

.global alice_armReBoot
alice_armReBoot:
jmp 0x000400d4

.global i2c_transfer_read
i2c_transfer_read:
jmp 0x000405fa

.global gpio_enable_port
gpio_enable_port:
jmp 0x000413d8

.global gpio_port_set
gpio_port_set:
jmp 0x00041260

.global gpio_query_intr
gpio_query_intr:
jmp 0x000412e8

.global spi_read
spi_read:
jmp 0x00041f12

.global ernie_exec_cmd_short
ernie_exec_cmd_short:
jmp 0x00042134

.global cbus_write
cbus_write:
jmp 0x000411a6

.global glitch_init
glitch_init:
jmp 0x0004234c

.global spi_read_end
spi_read_end:
jmp 0x00041f1e

.global memcmp
memcmp:
jmp 0x000404ce

.global set_exception_table
set_exception_table:
jmp 0x00040ca2

.global init
init:
jmp 0x00041884

.global i2c_init_bus
i2c_init_bus:
jmp 0x0004052e

.global alice_handleCmd
alice_handleCmd:
jmp 0x0004027a

.global crypto_waitStopBigmacOps
crypto_waitStopBigmacOps:
jmp 0x0004099e

.global compat_pListCopy
compat_pListCopy:
jmp 0x000417b8

.global gpio_set_intr_mode
gpio_set_intr_mode:
jmp 0x000412a0

.global ernie_init
ernie_init:
jmp 0x00042286

.global memset
memset:
jmp 0x00040460

.global get_build_timestamp
get_build_timestamp:
jmp 0x000411f0

.global gpio_acquire_intr
gpio_acquire_intr:
jmp 0x00041354

.global writeAs
writeAs:
jmp 0x00040d40

.global delay
delay:
jmp 0x00041152

.global rpc_loop
rpc_loop:
jmp 0x00040dfa

.global jig_update_shared_buffer
jig_update_shared_buffer:
jmp 0x00041c7a

.global ce_framework
ce_framework:
jmp 0x00041802

.global cbus_read
cbus_read:
jmp 0x0004117e

.global keyring_slot_prot
keyring_slot_prot:
jmp 0x00040dd2

.global spi_write_end
spi_write_end:
jmp 0x00041eda

.global spi_write
spi_write:
jmp 0x00041ef6

.global ernie_write
ernie_write:
jmp 0x00041f34

.global c_SWI
c_SWI:
jmp 0x00040aac

.global debug_printRange
debug_printRange:
jmp 0x00041b30

.global spi_read_available
spi_read_available:
jmp 0x00041f04

.global gpio_port_clear
gpio_port_clear:
jmp 0x00041280

.global strlen
strlen:
jmp 0x00040512

.global c_DBG
c_DBG:
jmp 0x00040c78

.global gpio_init
gpio_init:
jmp 0x000413f4

.global crypto_memset
crypto_memset:
jmp 0x00040a28

.global c_RESET
c_RESET:
jmp 0x00040a64

.global compat_Cry2Arm0
compat_Cry2Arm0:
jmp 0x00041446

