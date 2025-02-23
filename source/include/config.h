#ifndef __CONFIG_H__
#define __CONFIG_H__

#include "types.h"

struct _bob_fm_nfo_s {
    uint16_t magic;
    uint8_t exp_status;
    uint8_t status;
    uint32_t (*codepaddr)(uint32_t arg, volatile uint8_t* status_addr);
    uint32_t arg;
    uint32_t resp;
    struct _bob_fm_nfo_s *next; // next in chain, watch the stack
};

enum BOB_CEFW_MB {
    BOB_CEFW_MB_ICACHEOFF = 0,
    BOB_CEFW_MB_EXTENDED,
};

#define CE_FRAMEWORK_MAGIC 0x14FF
#define CE_FRAMEWORK_MAGIC_FB 0b11
#define CE_FRAMEWORK_STATUS_TORUN 0x34
#define CE_FRAMEWORK_STATUS_RUNNING 0x69

struct _bob_config_v1_s {  // backward compatibility
    struct _bob_fm_nfo_s *ce_framework_parms[2];
    uint32_t uart_params;  // (bus << 0x18) | clk
    uint32_t run_tests;    // 0: nothing, 1: test(), > 1: paddr to run
    int test_arg;          // arg passed to test() or custom test
};

struct _bob_config_v2_s {
    struct _bob_fm_nfo_s *ce_framework_parms[2];  // 0: fg, 1: bg
    uint32_t features;
    struct _bob_fm_nfo_s *test_params;
};

enum BOB_CFG_FRT {
    BOB_CFG_FRT_UART_CLK = 0,     // uart clock (8 bits)
    BOB_CFG_FRT_UART_CLK__L = 7,
    BOB_CFG_FRT_TFWP_USEINT,      // copy to and use internal buffer for test() params
    BOB_CFG_FRT_TEST_ONINIT,      // run test() on init
    BOB_CFG_FRT_TEST_ONRESET,     // run test() on reset
    BOB_CFG_FRT_CFG_USEINT,       // use hardcoded config (or memcpy in)
    BOB_CFG_FRT_SET_UART = 16,    // set uart bus
    BOB_CFG_FRT_UART_BUS = 24,    // uart bus (3 bits)
    BOB_CFG_FRT_UART_BUS__L = 26,
    BOB_CFG_FRT_ISCFGV2           // is valid v2 config
};

#define BOB_CFG_FRT_ISLATEST (BOB_CFG_FRT_ISCFGV2)
#define BOB_CFG_FRT_ISUSABLE (BOB_CFG_FRT_CFG_USEINT)

#ifndef NOT_BOB
    #include "utils.h"
    typedef struct _bob_fm_nfo_s bob_fm_nfo_s;
    typedef struct _bob_config_v2_s bob_config_s;
    extern volatile bob_config_s g_config;
    #define CEFW_FLAG(magic, flag) (!((magic) & BITN(BOB_CEFW_MB##flag)))
    #define CEFW_ISMAGIC(magic) (((magic) | CE_FRAMEWORK_MAGIC_FB) == CE_FRAMEWORK_MAGIC)
    #define CONFIG_FLAG(features, flag) ((features) & BITN(BOB_CFG_FRT##flag))
    #define CONFIG_FLAGK(features, flag) ((features) & (BITN(BOB_CFG_FRT_ISUSABLE) | BITN(BOB_CFG_FRT##flag)))
    #define CONFIG_VAL(features, val) (XBITNVALM(features, BOB_CFG_FRT##val, BITFL(BOB_CFG_FRT##val##__L - BOB_CFG_FRT##val)))
    #define CONFIG_GFLAG(flag) CONFIG_FLAG(g_config.features, flag)
    #define CONFIG_GFLAGK(flag) CONFIG_FLAGK(g_config.features, flag)
    #define CONFIG_GVAL(val) CONFIG_VAL(g_config.features, val)
    #ifndef CONFIG_ADD_TRANSLATORS
        #define config_translate_122(in, out, test_params) stub()
    #endif
    #define config_translate_12L config_translate_122
    int config_set_dfl_test(bob_fm_nfo_s *test_params, void *func, uint32_t arg, bool once);
    int config_parse(void *in, bob_config_s *out, bob_fm_nfo_s *test_params);
#endif

#endif