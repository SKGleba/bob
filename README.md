# bob
An open source monolithic kernel for Playstation Vita's Toshiba MeP security processor

## TODOs
 - SCE SM support (load/unload, compat irq/swi)
   - preferably decrypted, or keys provided by the loader
 - documentation & proper readmes

## loading bob
mep (spl/broombroom):
```C
typedef unsigned int uint32_t;
typedef unsigned char uint8_t;

typedef struct bob_config {
    uint32_t ce_framework_parms[2];
    uint32_t uart_params; // (bus << 0x18) | clk
    int run_tests;
} bob_config;

typedef struct bob_info {
	uint32_t bob_addr;
	uint32_t bob_size;
	bob_config bob_config_d;
} bob_info;

#define f00d_spram 0x00040000

__attribute__((noreturn))
void _start(bob_info* arg) {
	register volatile uint32_t cfg asm("cfg");
	cfg = cfg & ~0x2; // disable icache, bob will clean & enable it later

	for (uint32_t x = 0; x < arg->bob_size; x -= -4) // copy bob
		*(uint32_t*)(f00d_spram + x) = *(uint32_t*)(arg->bob_addr + x);

	void __attribute__((noreturn)) (*bob_init)(uint32_t * config) = (void*)(f00d_spram + 0xb0);
	bob_init(arg->bob_config); // run bob_init(config)
	while (1) {}; // for the compiler to respect noreturn
}
```
arm (spl):
```C
    memcpy(tachyon_edram + 0x20, (void*)bob_bin, sizeof(bob_bin)); // copy bob to some pallocated mem
    
    bob_info* bobinfo = (bob_info*)tachyon_edram; // some pallocated mem for bobloader args
    
    // bobloader args
    bobinfo->bob_addr = 0x1C000020; // bob addr
    bobinfo->bob_size = sizeof(bob_bin); // bob size
    
    // bob init args
    bobinfo->bob_config_d.ce_framework_parms[0] = 0x1F850000; // spl framework/only runs at arm interrupt
    bobinfo->bob_config_d.ce_framework_parms[1] = 0; // broombroom framework/runs in a loop when idle
    bobinfo->bob_config_d.uart_params = (UART_BUS << 0x18) | 0x1001A; // set used uart bus, baud 115200
    bobinfo->bob_config_d.run_tests = 1; // run test() during bob init
    
    // run with bob_info paddr as arg
    ret = spl_exec_code((void*)bobloader_nmp, sizeof(bobloader_nmp), 0x1C000000, 1);
```
