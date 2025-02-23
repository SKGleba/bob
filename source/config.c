#include "include/types.h"
#include "include/defs.h"
#include "include/main.h"
#include "include/test.h"
#include "include/utils.h"
#include "include/clib.h"

#include "include/config.h"

int config_set_dfl_test(bob_fm_nfo_s *test_params, void *func, uint32_t arg, bool once) {
    if (!test_params)
        return -1;
    test_params->magic = CE_FRAMEWORK_MAGIC;
    if (once)
        test_params->exp_status = 0xAA;
    else
        test_params->exp_status = CE_FRAMEWORK_STATUS_TORUN;
    if (func)
        test_params->codepaddr = (uint32_t (*)(uint32_t, volatile uint8_t *))func;
    else if (!test_params->codepaddr)
        test_params->codepaddr = (uint32_t (*)(uint32_t, volatile uint8_t *))dfl_test;
    test_params->arg = arg;
    test_params->resp = 0;
    test_params->status = CE_FRAMEWORK_STATUS_TORUN;
    return 0;
}

#ifdef CONFIG_ADD_TRANSLATORS
static int config_translate_122(struct _bob_config_v1_s *in, struct _bob_config_v2_s *out, bob_fm_nfo_s *test_params) {
    if (!in || !out)
        return -1;
    out->features = 0;
    out->features |= (in->uart_params & (BITFL(BOB_CFG_FRT_UART_CLK__L) | BITN(BOB_CFG_FRT_SET_UART) |
                                         BITNVAL(BOB_CFG_FRT_UART_BUS, BITFL(BOB_CFG_FRT_UART_BUS__L - BOB_CFG_FRT_UART_BUS))));
    if (in->run_tests && test_params) {
        out->features |= BITN(BOB_CFG_FRT_TEST_ONINIT);
        out->features |= BITN(BOB_CFG_FRT_TFWP_USEINT);
        out->test_params = test_params;
        if (in->run_tests == 1)
            in->run_tests = (uint32_t)dfl_test;
        config_set_dfl_test(test_params, (void *)in->run_tests, in->test_arg, false);
    }
    out->features |= BITN(BOB_CFG_FRT_ISCFGV2);  // yay
    return 0;
}
#endif

int config_parse(void *in, bob_config_s *out, bob_fm_nfo_s *test_params) {
    if (!in)
        return -1;
    if (!out)
        out = (bob_config_s *)&g_config;
    if (((bob_config_s*)in)->features & BITN(BOB_CFG_FRT_ISCFGV2)) {
        if (((bob_config_s*)in)->features & BITN(BOB_CFG_FRT_CFG_USEINT)) {
            memcpy((void *)out, (void *)in, sizeof(bob_config_s));
            return 0;
        }
        out->features = ((bob_config_s*)in)->features;
        if (test_params) {
            if (((bob_config_s *)in)->test_params) {
                if (out->features & BITN(BOB_CFG_FRT_TFWP_USEINT))
                    memcpy((void *)test_params, (void *)((bob_config_s *)in)->test_params, sizeof(bob_fm_nfo_s));
                else
                    out->test_params = ((bob_config_s *)in)->test_params;
            } else if (out->features & BITN(BOB_CFG_FRT_TEST_ONINIT)) {
                out->features |= BITN(BOB_CFG_FRT_TFWP_USEINT);
                config_set_dfl_test(test_params, (void *)dfl_test, 0, true);
            }
        }
        out->ce_framework_parms[0] = ((bob_config_s *)in)->ce_framework_parms[0];
        out->ce_framework_parms[1] = ((bob_config_s *)in)->ce_framework_parms[1];
        if (!out->test_params)
            out->test_params = test_params;
        out->features |= BITN(BOB_CFG_FRT_CFG_USEINT); // mark as valid
        return 0;
    } else // translate v1 config to current
        return config_translate_12L((struct _bob_config_v1_s *)in, (struct _bob_config_v2_s *)out, test_params);
}
