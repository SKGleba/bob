.global gpio_port_read
gpio_port_read:
jmp 0x00040b18

.global compat_f00dState
compat_f00dState:
jmp 0x00040ce8

.global c_OTHER_EXC
c_OTHER_EXC:
jmp 0x0004066c

.global sm_loadstart
sm_loadstart:
jmp 0x000407cc

.global uart_printn
uart_printn:
jmp 0x00040366

.global c_IRQ
c_IRQ:
jmp 0x0004055e

.global debug_setGpoCode
debug_setGpoCode:
jmp 0x00041432

.global spi_write_start
spi_write_start:
jmp 0x000416d8

.global uart_write
uart_write:
jmp 0x00040318

.global set_dbg_mode
set_dbg_mode:
jmp 0x00040aa4

.global memcpy
memcpy:
jmp 0x00040138

.global jig_read_shared_buffer
jig_read_shared_buffer:
jmp 0x000415b6

.global pervasive_clock_disable_spi
pervasive_clock_disable_spi:
jmp 0x0004024c

.global uart_print
uart_print:
jmp 0x00040334

.global c_ARM_REQ
c_ARM_REQ:
jmp 0x000405bc

.global ernie_exec
ernie_exec:
jmp 0x00041824

.global gpio_set_port_mode
gpio_set_port_mode:
jmp 0x00040afa

.global ernie_exec_cmd
ernie_exec_cmd:
jmp 0x0004189e

.global spi_init
spi_init:
jmp 0x0004168c

.global PANIC
PANIC:
jmp 0x000406a6

.global readAs
readAs:
jmp 0x00040728

.global keyring_slot_data
keyring_slot_data:
jmp 0x0004076e

.global compat_IRQ7_handleCmd
compat_IRQ7_handleCmd:
jmp 0x00040f74

.global debug_c_regdump
debug_c_regdump:
jmp 0x0004145c

.global enable_icache
enable_icache:
jmp 0x00040ac8

.global debug_printFormat
debug_printFormat:
jmp 0x000412aa

.global memset32
memset32:
jmp 0x000400e6

.global crypto_bigmacDefaultCmd
crypto_bigmacDefaultCmd:
jmp 0x000403a2

.global debug_printU32
debug_printU32:
jmp 0x0004123a

.global memset8
memset8:
jmp 0x000400c0

.global glitch_test
glitch_test:
jmp 0x000419b2

.global c_OTHER_INT
c_OTHER_INT:
jmp 0x00040632

.global uart_init
uart_init:
jmp 0x00040298

.global ernie_read
ernie_read:
jmp 0x000417aa

.global test
test:
jmp 0x000411de

.global gpio_port_set
gpio_port_set:
jmp 0x00040b2e

.global pervasive_reset_exit_uart
pervasive_reset_exit_uart:
jmp 0x000401ec

.global gpio_query_intr
gpio_query_intr:
jmp 0x00040bb6

.global spi_read
spi_read:
jmp 0x00041730

.global ernie_exec_cmd_short
ernie_exec_cmd_short:
jmp 0x0004191c

.global cbus_write
cbus_write:
jmp 0x00040a88

.global pervasive_clock_enable_spi
pervasive_clock_enable_spi:
jmp 0x00040232

.global glitch_init
glitch_init:
jmp 0x00041a08

.global spi_read_end
spi_read_end:
jmp 0x0004173c

.global memcmp
memcmp:
jmp 0x00040176

.global init
init:
jmp 0x00041134

.global crypto_waitStopBigmacOps
crypto_waitStopBigmacOps:
jmp 0x000403ec

.global compat_pListCopy
compat_pListCopy:
jmp 0x00041054

.global gpio_set_intr_mode
gpio_set_intr_mode:
jmp 0x00040b6e

.global ernie_init
ernie_init:
jmp 0x00041938

.global memset
memset:
jmp 0x00040108

.global get_build_timestamp
get_build_timestamp:
jmp 0x00040abe

.global gpio_acquire_intr
gpio_acquire_intr:
jmp 0x00040c22

.global writeAs
writeAs:
jmp 0x00040756

.global delay
delay:
jmp 0x00040a44

.global rpc_loop
rpc_loop:
jmp 0x000407ce

.global jig_update_shared_buffer
jig_update_shared_buffer:
jmp 0x000414b6

.global ce_framework
ce_framework:
jmp 0x0004109e

.global cbus_read
cbus_read:
jmp 0x00040a70

.global keyring_slot_prot
keyring_slot_prot:
jmp 0x000407b0

.global spi_write_end
spi_write_end:
jmp 0x000416f8

.global spi_write
spi_write:
jmp 0x00041714

.global ernie_write
ernie_write:
jmp 0x00041752

.global pervasive_reset_exit_spi
pervasive_reset_exit_spi:
jmp 0x00040266

.global c_SWI
c_SWI:
jmp 0x000404ee

.global debug_printRange
debug_printRange:
jmp 0x00041394

.global pervasive_clock_enable_uart
pervasive_clock_enable_uart:
jmp 0x000401d2

.global pervasive_reset_exit_gpio
pervasive_reset_exit_gpio:
jmp 0x0004021c

.global pervasive_clock_enable_gpio
pervasive_clock_enable_gpio:
jmp 0x00040206

.global spi_read_available
spi_read_available:
jmp 0x00041722

.global gpio_port_clear
gpio_port_clear:
jmp 0x00040b4e

.global pervasive_read_misc
pervasive_read_misc:
jmp 0x000401c8

.global strlen
strlen:
jmp 0x000401ba

.global c_DBG
c_DBG:
jmp 0x000406e4

.global gpio_init
gpio_init:
jmp 0x00040ca6

.global crypto_memset
crypto_memset:
jmp 0x00040462

.global c_RESET
c_RESET:
jmp 0x0004049c

.global compat_Cry2Arm0
compat_Cry2Arm0:
jmp 0x00040d06

