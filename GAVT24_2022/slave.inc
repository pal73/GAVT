	.DEF _t0_cnt0_=R8
	.DEF _t0_cnt0=R9
	.DEF _t0_cnt1=R10
	.DEF _t0_cnt2=R11
	.DEF _t0_cnt3=R12
	.DEF _ind_cnt=R13
_3:
	.DB  0x55,0x55,0x55,0x55,0x55
	.DEF _but=R14

__GLOBAL_INI_TBL:
	.DW  0x05
	.DW  _ind_out
	.DW  _3*2

	.DW  0
