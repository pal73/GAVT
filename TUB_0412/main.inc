	.DEF _t0_cnt0=R4
	.DEF _t0_cnt1=R5
	.DEF _t0_cnt2=R6
	.DEF _t0_cnt3=R7
	.DEF _but=R8
	.DEF _prog=R9
	.DEF _step=R10
	.DEF _in_word=R11
_3:
	.DB  0xFF
	.DEF _in_word_old=R12
	.DEF _in_word_new=R13
	.DEF _in_word_cnt=R14

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x0B
	.DW  _3*2

	.DW  0
