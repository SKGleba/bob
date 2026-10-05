#ifndef __C3P_H__
#define __C3P_H__

/* Custom C-sized Code Processor Machine
op types: (S)ingle, e(X)tended, (D)ouble
op subtypes: (J)ump, u(P)date
NAr:
	C - 12-op-sized context window with ops
	I - next op idx in context
	P - result from last Pop
	A - instr arg (0-11: nC, 12-15: gp)|imm
GPr prefill:
	12: reset haddr
	13: total num of ops
	14:	0
	15: workbuf haddr
opS:
	@0:4 a0
	@4:8 mods
	@12:4 opcode
	@16:4 a1
	 | @16:e a1_imm16 (mod A1IMM)
	@20:12 a1_imm12 (mod PTRA1)
opX:
	@0:4 a0
	@4:6 mods
	@10:6 opcode
	@16:4 a1
	 | @16:12 a1_imm12 (mod A1IMM)
	@20:8 a1_imm8 (mod PTRA1)
	@28:4 a2
opD: (op1 a1 == op2 a0)
	@0:4 op1 a0
	@4:8 op1 mods
	@12:4 op1 opcode
	@16:4 op1 a1
	@16:4 op2 a0
	@20:4 op2 mods[:4]
	@24:4 op2 opcode
	@28:4 op2 a1
*/
#define C3PM_JDCA2RILT (0x00010000 / sizeof(uint32_t)) // host AS start for JDC
enum C3P_MODS {
	C3P_MOD_PTRA0, // use *c[a0] (c[a0] for Jops)
	C3P_MOD_PTRA1, // use *(c[a1]+a1_imm12)
	C3P_MOD_TIM16 = C3P_MOD_PTRA1, // lsh16 a1_imm16 (for A1IMM)
	C3P_MOD_SWAPA, // swap a0 and a1 (for non-Jops)
	C3P_MOD_JEQUS = C3P_MOD_SWAPA, // add equ to comp - !=:=,<:<=,>:>=
	C3P_MOD_NOPCG, // dont update the P reg (for Pops)
	C3P_MOD_JSIGC = C3P_MOD_NOPCG, // signed compare (for Jops)
	C3P_MOD_CTXMV, // move C to I
	C3P_MOD_A1IMM, // a1 is imm, disables PTRA1 & Dop
	C3P_MOD_EXTND = 6, // is an extewnded op, also xop MSB
	C3P_MOD_RESERVED = 7, // (for !Xops)
};
#define C3P_MOD(_m, _n) ((_m) & (1 << (C3P_MOD##_n)))

// 0-invalid, 1-15 base ops, 32+ extended ops
enum C3P_OPS {
	C3P_OP_INVALID = 0,
	// start of J-ops
	C3P_OP_JDC, // C=c[a1]|reset+c[a1] & I=a0
	C3P_OP_JNE, // I=a0 if c[a1] != P
	C3P_OP_JLT, // I=a0 if c[a1] < P
	C3P_OP_JGT, // I=a0 if c[a1] > P
	C3P_OP__JOPSEND = C3P_OP_JGT,
	// start of P-ops
	C3P_OP_MOV32, // c[a0] = c[a1] 		| P = c[a0]
	C3P_OP_ADD, // c[a0] += c[a1]			| P = c[a0]
	C3P_OP_SUB, // c[a0] -= c[a1] 			| P = c[a0]
	C3P_OP_MUL, // c[a0] *= c[a1] 			| P = c[a0]
	C3P_OP_DIV, // c[a0] /= c[a1] 			| P = c[a0]
	C3P_OP_AND, // c[a0] &= c[a1] 			| P = c[a0]
	C3P_OP_OR, // c[a0] |= c[a1] 			| P = c[a0]
	C3P_OP_XOR, // c[a0] ^= c[a1] 			| P = c[a0]
	C3P_OP_LSH, // c[a0] <<= c[a1] 		| P = c[a0]
	C3P_OP_RSH, // c[a0] >>= c[a1] 		| P = c[a0]
	// start of extended ops
	C3P_OP_MOV8 = 32, // c[a0] = c[a1] (8b, pos=a2::b(A<<2)&3)	| P = c[a0]
	C3P_OP__XOPSTART = C3P_OP_MOV8,
	C3P_OP_MOV16, // c[a0] = c[a1] (16b, half=a2::b(A<<1)&1)	| P = c[a0]
};

enum C3P_MRETS {
	C3PMR_OK = 0,
	C3PMR_EBADOP,
	C3PMR_EBAD2OP,
	C3PMR_EBADMOD,
	C3PMR_EZDIV,
	C3PMR_EUNKOPC,
	C3PMR_EBADJDCD,
	C3PMR_EUNUSE,
};

int c3p_machine(void *reset, unsigned int num, void *work);

#endif