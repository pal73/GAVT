	.DEF _t0_cnt=R5
	.DEF _t0_cnt0=R6
	.DEF _t0_cnt1=R7
	.DEF _t0_cnt2=R8
	.DEF _t0_cnt3=R9
	.DEF _ind_cnt=R10
_STROB:
	.DB  0xFB,0xF7,0xEF,0xDF,0xBF,0xFF
_DIGISYM:
	.DB  0x48,0x7B,0x2C,0x29,0x1B,0x89,0x88,0x6B
	.DB  0x8,0x9,0xFF
	.DEF _but_pr_LD_if=R11
	.DEF _but_pr_LD_get=R12
	.DEF _but_pr_imp_v=R13
	.DEF _delay=R14

;GPIOR0-GPIOR2 INITIALIZATION
	.EQU  __GPIOR0_INIT=0x00
	.EQU  __GPIOR1_INIT=0x00
	.EQU  __GPIOR2_INIT=0x00

__GLOBAL_INI_TBL:
	.DW  0
