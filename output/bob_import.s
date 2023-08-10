.global gpio_port_read
gpio_port_read:
jmp 0x00041382

.global ernie_3auth_single
ernie_3auth_single:
jmp 0x000422e2

.global i2c_transfer_write
i2c_transfer_write:
jmp 0x00040648

.global c_OTHER_EXC
c_OTHER_EXC:
jmp 0x00040cd2

.global sm_loadstart
sm_loadstart:
jmp 0x00040eee

.global uart_printn
uart_printn:
jmp 0x00040902

.global c_IRQ
c_IRQ:
jmp 0x00040b9e

.global debug_setGpoCode
debug_setGpoCode:
jmp 0x00041d78

.global spi_write_start
spi_write_start:
jmp 0x0004204c

.global uart_write
uart_write:
jmp 0x000408b4

.global set_dbg_mode
set_dbg_mode:
jmp 0x0004130e

.global alice_setupInts
alice_setupInts:
jmp 0x000402ca

.global memcpy
memcpy:
jmp 0x00040538

.global jig_read_shared_buffer
jig_read_shared_buffer:
jmp 0x00041f0c

.global uart_print
uart_print:
jmp 0x000408d0

.global c_ARM_REQ
c_ARM_REQ:
jmp 0x00040c10

.global ernie_exec
ernie_exec:
jmp 0x00042198

.global gpio_set_port_mode
gpio_set_port_mode:
jmp 0x00041364

.global ernie_exec_cmd
ernie_exec_cmd:
jmp 0x00042234

.global spi_init
spi_init:
jmp 0x00041fea

.global PANIC
PANIC:
jmp 0x00040d0c

.global readAs
readAs:
jmp 0x00040e00

.global i2c_transfer_write_read
i2c_transfer_write_read:
jmp 0x0004070a

.global keyring_slot_data
keyring_slot_data:
jmp 0x00040e5a

.global compat_IRQ7_handleCmd
compat_IRQ7_handleCmd:
jmp 0x000417de

.global debug_c_regdump
debug_c_regdump:
jmp 0x00041da2

.global enable_icache
enable_icache:
jmp 0x00041332

.global debug_printFormat
debug_printFormat:
jmp 0x00041bc6

.global memset32
memset32:
jmp 0x000404e6

.global crypto_bigmacDefaultCmd
crypto_bigmacDefaultCmd:
jmp 0x0004093e

.global debug_printU32
debug_printU32:
jmp 0x00041b52

.global memset8
memset8:
jmp 0x000404c0

.global pervasive_control_reset
pervasive_control_reset:
jmp 0x0004079c

.global glitch_test
glitch_test:
jmp 0x0004249a

.global c_OTHER_INT
c_OTHER_INT:
jmp 0x00040c98

.global uart_init
uart_init:
jmp 0x00040824

.global ernie_read
ernie_read:
jmp 0x0004211e

.global test
test:
jmp 0x00041ad6

.global pervasive_control_gate
pervasive_control_gate:
jmp 0x000407e0

.global alice_armReBoot
alice_armReBoot:
jmp 0x000400d4

.global i2c_transfer_read
i2c_transfer_read:
jmp 0x000406a2

.global gpio_enable_port
gpio_enable_port:
jmp 0x00041510

.global gpio_port_set
gpio_port_set:
jmp 0x00041398

.global gpio_query_intr
gpio_query_intr:
jmp 0x00041420

.global spi_read
spi_read:
jmp 0x000420a4

.global ernie_exec_cmd_short
ernie_exec_cmd_short:
jmp 0x000422c6

.global cbus_write
cbus_write:
jmp 0x000412de

.global glitch_init
glitch_init:
jmp 0x000424f0

.global spi_read_end
spi_read_end:
jmp 0x000420b0

.global memcmp
memcmp:
jmp 0x00040576

.global set_exception_table
set_exception_table:
jmp 0x00040d98

.global init
init:
jmp 0x000419f8

.global i2c_init_bus
i2c_init_bus:
jmp 0x000405d6

.global alice_handleCmd
alice_handleCmd:
jmp 0x00040322

.global crypto_waitStopBigmacOps
crypto_waitStopBigmacOps:
jmp 0x00040a02

.global compat_pListCopy
compat_pListCopy:
jmp 0x00041914

.global gpio_set_intr_mode
gpio_set_intr_mode:
jmp 0x000413d8

.global ernie_init
ernie_init:
jmp 0x00042418

.global memset
memset:
jmp 0x00040508

.global get_build_timestamp
get_build_timestamp:
jmp 0x00041328

.global gpio_acquire_intr
gpio_acquire_intr:
jmp 0x0004148c

.global writeAs
writeAs:
jmp 0x00040e36

.global delay
delay:
jmp 0x0004128a

.global rpc_loop
rpc_loop:
jmp 0x00040ef0

.global jig_update_shared_buffer
jig_update_shared_buffer:
jmp 0x00041e0c

.global ce_framework
ce_framework:
jmp 0x0004195e

.global cbus_read
cbus_read:
jmp 0x000412b6

.global keyring_slot_prot
keyring_slot_prot:
jmp 0x00040ec8

.global spi_write_end
spi_write_end:
jmp 0x0004206c

.global spi_write
spi_write:
jmp 0x00042088

.global ernie_write
ernie_write:
jmp 0x000420c6

.global c_SWI
c_SWI:
jmp 0x00040b24

.global debug_printRange
debug_printRange:
jmp 0x00041cc2

.global spi_read_available
spi_read_available:
jmp 0x00042096

.global gpio_port_clear
gpio_port_clear:
jmp 0x000413b8

.global strlen
strlen:
jmp 0x000405ba

.global c_DBG
c_DBG:
jmp 0x00040d4a

.global gpio_init
gpio_init:
jmp 0x0004152c

.global crypto_memset
crypto_memset:
jmp 0x00040a8c

.global c_RESET
c_RESET:
jmp 0x00040ac8

.global compat_Cry2Arm0
compat_Cry2Arm0:
jmp 0x0004157e

