	.DEF _t0_cnt0=R5
	.DEF _t0_cnt1=R6
	.DEF _t0_cnt2=R7
	.DEF _t0_cnt3=R8
	.DEF _t0_cnt4=R9
	.DEF _bankA=R10
	.DEF _bankB=R12
	.DEF _flags=R14
_3:
	.DB  0x5,0x6,0x7
_4:
	.DW  0x19
_5:
	.DB  0x19
_DF:
	.DB  0x0,0xA,0xF,0x14,0x19,0x1E,0x23

__GLOBAL_INI_TBL:
	.DW  0x03
	.DW  _cher
	.DW  _3*2

	.DW  0x02
	.DW  _cher_cnt
	.DW  _4*2

	.DW  0x01
	.DW  _reset_cnt
	.DW  _5*2

	.DW  0
