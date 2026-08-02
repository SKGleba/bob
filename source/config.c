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
static int config_translate_122(struct _bob_config_v1_s *in, struct _bob_config_v2_s *out) {
    if (!in || !out)
        return -1;
    out->features = 0;
    out->features |= (in->uart_params & (BITFL(BOB_CFG_FRT_UART_CLK__L) | BITN(BOB_CFG_FRT_SET_UART) |
                                         BITNVAL(BOB_CFG_FRT_UART_BUS, BITFL(BOB_CFG_FRT_UART_BUS__L - BOB_CFG_FRT_UART_BUS))));
    if (in->run_tests) {
        memset((void*)&g_iceparams[0], 0, sizeof(bob_fm_nfo_s));
        out->features |= BITN(BOB_CFG_FRT_TEST_ONINIT);
        out->features |= BITN(BOB_CFG_FRT_TFWP_USEINT);
        out->test_params = (bob_fm_nfo_s*)&g_iceparams[0];
        if (in->run_tests == 1)
            in->run_tests = (uint32_t)dfl_test;
        config_set_dfl_test(out->test_params, (void *)in->run_tests, in->test_arg, false);
    }
    out->features |= BITN(BOB_CFG_FRT_ISCFGV2);  // yay
    out->features |= BITN(BOB_CFG_FRT_CFG_USEINT); // mark as valid
    return 0;
}
#endif

int config_parse(void *in) {
    if (!in)
        return -1;
    memset((void*)&g_config, 0, sizeof(bob_config_s));

    if (!CONFIG_FLAG((((bob_config_s*)in)->features), _ISLATEST)) { // needs translation
        if (!CONFIG_FLAG((((bob_config_s*)in)->features), _ISCFGV2)) { // v1-> v2
            if (config_translate_12L((struct _bob_config_v1_s *)in, (struct _bob_config_v2_s *)&g_config) < 0)
                return -1;
        }
    }
    if (CONFIG_GFLAGK(_CFG_USEINT))
        return 0; // fully translated

    bob_config_s *out = (bob_config_s *)&g_config;
    if (CONFIG_FLAGK((((bob_config_s*)in)->features), _CFG_USEINT)) { // loader wants a straight copy
        memcpy((void *)out, (void *)in, sizeof(bob_config_s));
        return 0;
    }
    out->features = ((bob_config_s*)in)->features;
    if (((bob_config_s *)in)->test_params) {
        if (CONFIG_FLAG(out->features, _TFWP_USEINT)) {
            out->test_params = (bob_fm_nfo_s*)&g_iceparams[0];
            memcpy((void *)(out->test_params), (void *)((bob_config_s *)in)->test_params, sizeof(bob_fm_nfo_s) + (sizeof(bob_fm_nfo_s) * CONFIG_VAL(out->features, _TFWP_COUNT)));
        } else
            out->test_params = ((bob_config_s *)in)->test_params;
    } else if (!CONFIG_FLAG(out->features, _TFWP_USEINT) && CONFIG_FLAG(out->features, _TEST_ONINIT)) {
        out->test_params = (bob_fm_nfo_s*)&g_iceparams[0];
        memset((void *)out->test_params, 0, sizeof(bob_fm_nfo_s));
        out->features |= BITN(BOB_CFG_FRT_TFWP_USEINT);
        config_set_dfl_test(out->test_params, (void *)dfl_test, 0, true);
    }
    out->ce_framework_parms[0] = ((bob_config_s *)in)->ce_framework_parms[0];
    out->ce_framework_parms[1] = ((bob_config_s *)in)->ce_framework_parms[1];
    out->features |= BITN(BOB_CFG_FRT_CFG_USEINT); // mark as valid
    return 0;
}
