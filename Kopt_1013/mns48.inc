	.DEF _butS=R6
	.DEF _bNN=R7
	.DEF _bNN_=R8
	.DEF _bPER=R9
	.DEF _bPER_=R10
	.DEF _bCHER_=R11
	.DEF _t0_cnt0=R12
	.DEF _t0_cnt1=R13
	.DEF _t0_cnt2=R14
_DF:
	.DB  0x0,0xA,0xF,0x14,0x19,0x1E,0x23
_3:
	.DW  0xFFEC

;GPIOR0-GPIOR2 INITIALIZATION
	.EQU  __GPIOR0_INIT=0x00
	.EQU  __GPIOR1_INIT=0x00
	.EQU  __GPIOR2_INIT=0x00

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  _proc_cnt_l
	.DW  _3*2

	.DW  0
