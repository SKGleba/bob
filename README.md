# bob
An open source monolithic kernel for Playstation Vita's Toshiba MeP security processor

### loading bob
mep (spl/broombroom):
```C
typedef unsigned int uint32_t;
typedef unsigned char uint8_t;

typedef struct bob_info {
	uint32_t bob_addr;
	uint32_t bob_size;
	uint32_t bob_config[];
} bob_info;

__attribute__((noreturn))
void _start(bob_info* arg) {

	uint32_t dst_addr = 0x00800000;
	const uint32_t* s = (const uint32_t*)arg->bob_addr;
	uint32_t* d = (uint32_t*)dst_addr;
	uint32_t n = arg->bob_size + 4;
	while (n) {
		*d++ = *s++;
		n-=4;
	}

	void __attribute__((noreturn)) (*bob_init)(uint32_t * config) = (void*)(dst_addr + 0xb0);
	bob_init(arg->bob_config);
}
```
arm (spl):
```C
    memcpy(tachyon_edram + 0x2800, (void*)bob_bin, sizeof(bob_bin)); // copy bob to some pallocated mem
    
    bob_info* bobinfo = (bob_info*)(tachyon_edram + 0x20); // some pallocated mem for bobloader args
    
    // bobloader args
    bobinfo->bob_addr = 0x1C002800; // bob addr
    bobinfo->bob_size = sizeof(bob_bin); // bob size
    
    // bob init args
    bobinfo->bob_config[0] = 0x1F850000; // spl framework/only runs at arm interrupt
    bobinfo->bob_config[1] = 0; // broombroom framework/runs in a loop when idle
    
    // run with bob_info paddr as arg
    ret = spl_exec_code((void*)bobloader_nmp, sizeof(bobloader_nmp), 0x1C000020, 1);
```
