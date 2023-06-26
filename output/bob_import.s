.global gpio_port_read
gpio_port_read:
jmp 0x00040b5e

.global compat_f00dState
compat_f00dState:
jmp 0x00040d2e

.global pervasive_clock_disable_gpio
pervasive_clock_disable_gpio:
jmp 0x00040232

.global c_OTHER_EXC
c_OTHER_EXC:
jmp 0x000405a8

.global sm_loadstart
sm_loadstart:
jmp 0x00040708

.global uart_printn
uart_printn:
jmp 0x00040a4e

.global c_IRQ
c_IRQ:
jmp 0x0004049a

.global debug_setGpoCode
debug_setGpoCode:
jmp 0x00041478

.global spi_write_start
spi_write_start:
jmp 0x0004171e

.global uart_write
uart_write:
jmp 0x00040a00

.global set_dbg_mode
set_dbg_mode:
jmp 0x00040aea

.global memcpy
memcpy:
jmp 0x00040138

.global jig_read_shared_buffer
jig_read_shared_buffer:
jmp 0x000415fc

.global pervasive_clock_disable_spi
pervasive_clock_disable_spi:
jmp 0x00040278

.global uart_print
uart_print:
jmp 0x00040a1c

.global c_ARM_REQ
c_ARM_REQ:
jmp 0x000404f8

.global ernie_exec
ernie_exec:
jmp 0x0004186a

.global gpio_set_port_mode
gpio_set_port_mode:
jmp 0x00040b40

.global ernie_exec_cmd
ernie_exec_cmd:
jmp 0x000418e4

.global spi_init
spi_init:
jmp 0x000416d2

.global PANIC
PANIC:
jmp 0x000405e2

.global readAs
readAs:
jmp 0x00040664

.global keyring_slot_data
keyring_slot_data:
jmp 0x000406aa

.global pervasive_reset_enter_gpio
pervasive_reset_enter_gpio:
jmp 0x00040248

.global compat_IRQ7_handleCmd
compat_IRQ7_handleCmd:
jmp 0x00040fba

.global debug_c_regdump
debug_c_regdump:
jmp 0x000414a2

.global enable_icache
enable_icache:
jmp 0x00040b0e

.global debug_printFormat
debug_printFormat:
jmp 0x000412f0

.global pervasive_reset_enter_spi
pervasive_reset_enter_spi:
jmp 0x00040292

.global memset32
memset32:
jmp 0x000400e6

.global crypto_bigmacDefaultCmd
crypto_bigmacDefaultCmd:
jmp 0x000402de

.global debug_printU32
debug_printU32:
jmp 0x00041280

.global memset8
memset8:
jmp 0x000400c0

.global glitch_test
glitch_test:
jmp 0x000419f8

.global c_OTHER_INT
c_OTHER_INT:
jmp 0x0004056e

.global uart_init
uart_init:
jmp 0x00040980

.global ernie_read
ernie_read:
jmp 0x000417f0

.global test
test:
jmp 0x00041224

.global gpio_port_set
gpio_port_set:
jmp 0x00040b74

.global pervasive_reset_exit_uart
pervasive_reset_exit_uart:
jmp 0x000401ec

.global gpio_query_intr
gpio_query_intr:
jmp 0x00040bfc

.global spi_read
spi_read:
jmp 0x00041776

.global ernie_exec_cmd_short
ernie_exec_cmd_short:
jmp 0x00041962

.global cbus_write
cbus_write:
jmp 0x00040ace

.global pervasive_clock_enable_spi
pervasive_clock_enable_spi:
jmp 0x0004025e

.global glitch_init
glitch_init:
jmp 0x00041a4e

.global spi_read_end
spi_read_end:
jmp 0x00041782

.global memcmp
memcmp:
jmp 0x00040176

.global init
init:
jmp 0x0004117a

.global crypto_waitStopBigmacOps
crypto_waitStopBigmacOps:
jmp 0x00040328

.global compat_pListCopy
compat_pListCopy:
jmp 0x0004109a

.global gpio_set_intr_mode
gpio_set_intr_mode:
jmp 0x00040bb4

.global ernie_init
ernie_init:
jmp 0x0004197e

.global memset
memset:
jmp 0x00040108

.global get_build_timestamp
get_build_timestamp:
jmp 0x00040b04

.global gpio_acquire_intr
gpio_acquire_intr:
jmp 0x00040c68

.global writeAs
writeAs:
jmp 0x00040692

.global delay
delay:
jmp 0x00040a8a

.global rpc_loop
rpc_loop:
jmp 0x0004070a

.global jig_update_shared_buffer
jig_update_shared_buffer:
jmp 0x000414fc

.global ce_framework
ce_framework:
jmp 0x000410e4

.global cbus_read
cbus_read:
jmp 0x00040ab6

.global keyring_slot_prot
keyring_slot_prot:
jmp 0x000406ec

.global spi_write_end
spi_write_end:
jmp 0x0004173e

.global spi_write
spi_write:
jmp 0x0004175a

.global ernie_write
ernie_write:
jmp 0x00041798

.global pervasive_reset_exit_spi
pervasive_reset_exit_spi:
jmp 0x000402ac

.global c_SWI
c_SWI:
jmp 0x0004042a

.global debug_printRange
debug_printRange:
jmp 0x000413da

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
jmp 0x00041768

.global gpio_port_clear
gpio_port_clear:
jmp 0x00040b94

.global pervasive_read_misc
pervasive_read_misc:
jmp 0x000401c8

.global strlen
strlen:
jmp 0x000401ba

.global c_DBG
c_DBG:
jmp 0x00040620

.global gpio_init
gpio_init:
jmp 0x00040cec

.global crypto_memset
crypto_memset:
jmp 0x0004039e

.global c_RESET
c_RESET:
jmp 0x000403d8

.global compat_Cry2Arm0
compat_Cry2Arm0:
jmp 0x00040d4c

