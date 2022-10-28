#ifndef __JIG_H__
#define __JIG_H__

#define JIG_KERMIT_SHBUF_SIZE 0x40

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

struct _jig_kermit_bert_shbuf_s {
	uint16_t magic;
    uint16_t req_no;
    uint16_t req_id;
    uint16_t full_data_size;
    uint8_t data[0x30];
    uint16_t completed_req_no;
} __attribute__((packed));
typedef struct _jig_kermit_bert_shbuf_s jig_kermit_bert_shbuf_s;

#define JIG_KERMIT_BERT_MAGIC 0x4444

enum JIG_BERT_REQ_FLAGS {
    JIG_BERT_REQ_FLAG_NOREPLY = 0x100, // doesnt expect a reply
    JIG_BERT_REQ_FLAG_NODATA = 0x200, // doesnt contain data
    JIG_BERT_REQ_FLAG_ISLONG = 0x400, // wait for next
    JIG_BERT_REQ_FLAG_NOLONG = 0x800, // not the next
    JIG_BERT_REQ_FLAG_ISREPLY = 0x1000, // its a reply
    JIG_BERT_REQ_FLAG_ISERROR = 0x8000, // its an error
};

enum JIG_2BERT_FUNCS {
    JIG_2BERT_PING,
    JIG_2BERT_HANDSHAKE,
    JIG_2BERT_ASCII_PRINT,
    JIG_2BERT_HEX_PRINT,
};

enum JIG_MY_FUNCS {
    JIG_MY_PING,
    JIG_MY_HANDSHAKE,
    JIG_MY_CODE_EXEC,
};

// funcs
int jig_update_shared_buffer(uint8_t* msg, uint8_t offset, uint8_t size, bool push);
int jig_read_shared_buffer(uint8_t* msg, uint8_t offset, uint8_t size);

#endif