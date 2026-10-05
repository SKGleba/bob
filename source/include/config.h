#ifndef __CONFIG_H__
#define __CONFIG_H__

#include "types.h"

struct _bob_fm_nfo_s {
    uint16_t magic;
    uint8_t exp_status;
    uint8_t status;
    union {
        uint32_t (*c_n)(uint32_t arg, volatile uint8_t* status_addr);
        uint32_t (*c_ext)(); // 8 args
        uint32_t codepaddr;
    };
    uint32_t arg0;
    uint32_t resp;
    union {
        struct _bob_fm_nfo_s *next; // next in chain, watch the stack
        uint32_t unext;
    };
    union {
        uint32_t argx[7];
        uint32_t snext_start;
    };
};
_Static_assert(sizeof(struct _bob_fm_nfo_s) == 0x30, "unexp fm_nfo struct size");

enum BOB_CEFW_MB {
    BOB_CEFW_MB_ICACHEOFF = 0, // disable & restore icache
    BOB_CEFW_MB_EXTENDED, // has next param (!next?next=s+sizeof)
    BOB_CEFW_MB_EXTRARG, // has argx (size=big)
};

#define CE_FRAMEWORK_MAGIC 0x14FF
#define CE_FRAMEWORK_MAGIC_FB 0b111
#define CE_FRAMEWORK_STATUS_TORUN 0x34
#define CE_FRAMEWORK_STATUS_RUNNING 0x69

#define ICEPARAM_MAX_BIG 2
#define ICEPARAM_MAX_SMALL 5 // *next=&argx[0]
#define ICEPARAM_BIG_SIZE (sizeof(struct _bob_fm_nfo_s))
#define ICEPARAM_SMALL_SIZE (sizeof(struct _bob_fm_nfo_s) - sizeof(uint32_t[7]))

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
    BOB_CFG_FRT_TFWP_COUNT,       // number of additional test() params (0-3) to copyin
    BOB_CFG_FRT_TFWP_COUNT__L,
    BOB_CFG_FRT_TEST_ONINIT,      // run test() on init
    BOB_CFG_FRT_TEST_ONRESET,     // run test() on reset
    BOB_CFG_FRT_CFG_USEINT,       // use hardcoded config
    BOB_CFG_FRT_SET_UART = 16,    // set uart bus
    BOB_CFG_FRT_UART_BUS = 24,    // uart bus (3 bits)
    BOB_CFG_FRT_UART_BUS__L = 26,
    BOB_CFG_FRT_ISCFGV2           // is valid v2 config
};

enum BOB_INITCFG32 {
    BOB_ICFG_FLAG1 = 0,
    BOB_ICFG_TEST_DEFAULT, // use internal test()
    BOB_ICFG_TEST_ONINIT, // v2
    BOB_ICFG_TEST_ONRESET, // v2
    BOB_ICFG_UART_BUS, // v2
    BOB_ICFG_UART_BUS__L = BOB_ICFG_UART_BUS + 2,
    BOB_ICFG_SET_UART, // v2
    BOB_ICFG_UART_CLK, // v2
    BOB_ICFG_UART_CLK__L = BOB_ICFG_UART_CLK + 7,
    BOB_ICFG_TARG0_POS, // test() arg0 pos
    BOB_ICFG_TARG0_POS__L = BOB_ICFG_TARG0_POS + 1,
    BOB_ICFG_TARG1_POS, // test() arg1 pos off (+arg0_pos)
    BOB_ICFG_TARG1_POS__L = BOB_ICFG_TARG1_POS + 1,
    BOB_ICFG_MAGIC = 20,
};
#define BOB_ICFG_MAGIC_V 0xB0B00001
#define BOB_ICFG_MAGIC_M 0xFFF00001

#define BOB_CFG_FRT_ISLATEST (BOB_CFG_FRT_ISCFGV2)

#ifndef NOT_BOB
    #include "utils.h"
    typedef struct _bob_fm_nfo_s bob_fm_nfo_s;
    typedef struct _bob_config_v2_s bob_config_s;
    extern volatile bob_config_s g_config;
    extern volatile bob_fm_nfo_s g_iceparams[ICEPARAM_MAX_BIG];
    extern const int g_exparam;
    #define CEFW_FLAG(magic, flag) (!((magic) & BITN(BOB_CEFW_MB##flag)))
    #define CEFW_ISMAGIC(magic) (((magic) | CE_FRAMEWORK_MAGIC_FB) == CE_FRAMEWORK_MAGIC)
    #define CONFIG_FLAG(features, flag) ((features) & BITN(BOB_CFG_FRT##flag))
    #define CONFIG_FLAGK(features, flag) (CONFIG_FLAG(features, _ISLATEST) && CONFIG_FLAG(features, flag))
    #define CONFIG_VAL(features, val) (XBITNVALM(features, BOB_CFG_FRT##val, BITFL(BOB_CFG_FRT##val##__L - BOB_CFG_FRT##val)))
    #define CONFIG_GFLAG(flag) CONFIG_FLAG(g_config.features, flag)
    #define CONFIG_GFLAGK(flag) CONFIG_FLAGK(g_config.features, flag)
    #define CONFIG_GVAL(val) CONFIG_VAL(g_config.features, val)
    #define ICONFIG_IS(_v) (((uint32_t)(_v) & BOB_ICFG_MAGIC_M) == BOB_ICFG_MAGIC_V)
    #define ICONFIG_FLAG(icfg, flag) ((icfg) & BITN(BOB_ICFG##flag))
    #define ICONFIG_VAL(icfg, val) (XBITNVALM(icfg, BOB_ICFG##val, BITFL(BOB_ICFG##val##__L - BOB_ICFG##val)))
    #ifndef CONFIG_ADD_TRANSLATORS
        #define config_translate_122(in, out) stub()
    #endif
    #define config_translate_12L config_translate_122
    int config_set_dfl_test(bob_fm_nfo_s *test_params, void *func, uint32_t arg, bool once, uint32_t *argx);
    int config_parse(void *in);
    int config_iparse(uint32_t in, void *tf, int ta0, int ta1);
#endif

#endif