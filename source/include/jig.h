#ifndef __JIG_H__
#define __JIG_H__

#define JIG_KERMIT_SHBUF_SIZE 0x28

struct _jig_cmd_kermit2jig_s {
	uint8_t push_to_jig;
    uint8_t offset;
    uint8_t size;
    uint8_t data[0x18];
} __attribute__((packed));
typedef struct _jig_cmd_kermit2jig_s jig_cmd_kermit2jig_s;

struct _jig_cmd_jig2kermit_s {
    uint8_t offset;
    uint8_t size;
    uint8_t data[0x18];
} __attribute__((packed));
typedef struct _jig_cmd_jig2kermit_s jig_cmd_jig2kermit_s;

// funcs
int jig_update_shared_buffer(uint8_t* msg, uint8_t offset, uint8_t size, bool push);
int jig_read_shared_buffer(uint8_t* msg, uint8_t offset, uint8_t size);

#endif