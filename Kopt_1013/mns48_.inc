	.DEF _t0_cnt0=R5
	.DEF _t0_cnt1=R6
	.DEF _t0_cnt2=R7
	.DEF _t0_cnt3=R8
	.DEF _bankA=R9
	.DEF _bankB=R11
	.DEF _bankC=R13
_3:
	.DB  0x5,0x6,0x7
_4:
	.DW  0x19
_DF:
	.DB  0x0,0xA,0xF,0x14,0x19,0x1E,0x23

;GPIOR0-GPIOR2 INITIALIZATION
	.EQU  __GPIOR0_INIT=0x00
	.EQU  __GPIOR1_INIT=0x00
	.EQU  __GPIOR2_INIT=0x00

__GLOBAL_INI_TBL:
	.DW  0x03
	.DW  _cher
	.DW  _3*2

	.DW  0x02
	.DW  _cher_cnt
	.DW  _4*2

	.DW  0
