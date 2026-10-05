#include "include/c3p.h"

#include "include/types.h"

// WIP

#define c3p_xorswap(_a, _b, _it, _ot) { _a = _ot (_it _a ^ _it _b); _b = _ot (_it _b ^ _it _a); _a = _ot (_it _a ^ _it _b); } // heh
int c3p_machine(void *reset, unsigned int num, void *work) {
#ifdef C3P_UNUSE
    return -C3PMR_EUNUSE;
#else
    uint32_t *c = (uint32_t *)reset; // 12-op-sized context window with ops
    unsigned int i = 0; // current op idx in context
    uint32_t p = 0;     // result from last Pop
    uint32_t a[4];      // instr arg a0, a1|a1_imm16, a2, a1_imm12|a1_imm8
    uint32_t g[4];      // GPr
    int r = C3PMR_OK;
    g[0] = (uint32_t)reset;
    g[1] = num;
    g[2] = 0;
    g[3] = (uint32_t)work;
    unsigned int r_pos = 0;
    while ((r_pos + i) < num) {
        r = -C3PMR_EBADOP;
        uint32_t op = c[i], t;
        int o = (op >> 10) & 0b111111;
        if (!o)
            break;
        i++;
        
        r = -C3PMR_EBADMOD;
        int m = (op >> 4) & 0xFF;
        bool is2 = false;
        bool isx = !!C3P_MOD(m, _EXTND);
        bool a1i = !!C3P_MOD(m, _A1IMM);
        a[0] = op & 0b1111;
        a[1] = (op >> 16) & 0xFFFF;
        a[2] = (op >> 28) & 0b1111;
        a[3] = a1i ? 0 : (op >> 20) & 0xFFF;
        if (isx) {
            a[1] &= 0xFFF;
            a[3] &= 0xFF;
        } else {
            o &= 0b1111;
            if (!o) { r = -C3PMR_EBADOP; break; }
        }
        if (!a1i) {
            if (a[3] && !C3P_MOD(m, _PTRA1)) {
                if (isx)
                    break;
                is2 = true;
                a[3] = 0;
            }
            a[1] &= 0b1111;
        } else if (C3P_MOD(m, _TIM16))
            a[1] <<= 16;

        uint32_t *ca0, *ca1, *ca2;
l_C3Pm_pdop:
        ca0 = (a[0] >= 12) ? &g[a[0] - 12] : &c[a[0]];
        ca1 = a1i ? &a[1] : ((a[1] >= 12) ? &g[a[1] - 12] : &c[a[1]]);
        ca2 = (a[2] >= 12) ? &g[a[2] - 12] : &c[a[2]];
        if (C3P_MOD(m, _PTRA0)) {
            if (o > C3P_OP__JOPSEND)
                ca0 = (uint32_t *)(*ca0);
        } else if (o <= C3P_OP__JOPSEND)
            ca0 = &a[0];
        if (!a1i && C3P_MOD(m, _PTRA1))
            ca1 = (uint32_t *)((uint32_t)*ca1 + a[3]);
        if (C3P_MOD(m, _SWAPA) && (o > C3P_OP__JOPSEND))
            c3p_xorswap(ca0, ca1, (uint32_t), (uint32_t *));

        r = C3PMR_OK;
        t = (o < C3P_OP__XOPSTART) ? *ca1 : 0;
        switch (o) {
            case C3P_OP_JDC: // warn: absolute _host_ addr jump if > JDCA2RILT
                if (t < C3PM_JDCA2RILT) {
                    if (t > num) { r = -C3PMR_EBADJDCD; break; }
                    r_pos = t;
                    t = (uint32_t)reset + (t * sizeof(uint32_t));
                }
                c = (uint32_t *)t;
            break; case C3P_OP_JNE:
                if (C3P_MOD(m, _JEQUS)) {
                    if (t == p)
                        i = *ca0;
                } else if (t != p)
                    i = *ca0;
            break; case C3P_OP_JLT:
                if (C3P_MOD(m, _JSIGC)) {
                    if ((int)t < (int)p)
                        i = *ca0;
                    else if (C3P_MOD(m, _JEQUS) && ((int)t <= (int)p))
                        i = *ca0;
                } else {
                    if (t < p)
                        i = *ca0;
                    else if (C3P_MOD(m, _JEQUS) && (t <= p))
                        i = *ca0;
                }
            break; case C3P_OP_JGT:
                if (C3P_MOD(m, _JSIGC)) {
                    if ((int)t > (int)p)
                        i = *ca0;
                    else if (C3P_MOD(m, _JEQUS) && ((int)t >= (int)p))
                        i = *ca0;
                } else {
                    if (t > p)
                        i = *ca0;
                    else if (C3P_MOD(m, _JEQUS) && (t >= p))
                        i = *ca0;
                }
            break;
            case C3P_OP_MOV32:
            break; case C3P_OP_ADD:
                t += *ca0;
            break; case C3P_OP_SUB:
                t = *ca0 - t;
            break; case C3P_OP_MUL:
                t *= *ca0;
            break; case C3P_OP_DIV:
                if (t)
                    t = *ca0 / t;
                else
                    r = -C3PMR_EZDIV;
            break; case C3P_OP_AND:
                t = *ca0 & t;
            break; case C3P_OP_OR:
                t |= *ca0;
            break; case C3P_OP_XOR:
                t ^= *ca0;
            break; case C3P_OP_LSH:
                t = *ca0 << (t % 32);
            break; case C3P_OP_RSH:
                t = *ca0 >> (t % 32);
                break;
            case C3P_OP_MOV8:
                t = *(uint8_t *)((uint32_t)ca1 + ((*ca2 >> 2) & 3));
                *(uint8_t *)((uint32_t)ca0 + (*ca2 & 3)) = (uint8_t)t;
            break; case C3P_OP_MOV16:
                t = *(uint16_t *)((uint32_t)ca1 + (((*ca2 >> 1) & 1) * 2));
                *(uint16_t *)((uint32_t)ca0 + ((*ca2 & 1) * 2)) = (uint16_t)t;
            break;
            default:
                r = -C3PMR_EUNKOPC;
                break;
        }
        if (r < 0)
            break;
        if (o > C3P_OP__JOPSEND) {
            if (o < C3P_OP__XOPSTART)
                *ca0 = t;
            if (!(C3P_MOD(m, _NOPCG)))
                p = t;
        }
        if (C3P_MOD(m, _CTXMV)) {
            c = &c[i];
            r_pos += i;
        }
        if (is2) {
            o = (op >> 24) & 0b1111;
            if (!o) { r = -C3PMR_EBAD2OP; break; }
            m = (op >> 20) & 0b1111;
            a[0] = (op >> 16) & 0b1111;
            a[1] = (op >> 28) & 0b1111;
            a[2] = 0;
            a[3] = 0;
            is2 = isx = a1i = false;
            goto l_C3Pm_pdop;
        }
    }
    return r;
#endif // C3P_UNUSE
}