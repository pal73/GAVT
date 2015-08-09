	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R6
	.DEF _rx_counter=R7
	.DEF _tx_wr_index=R8
	.DEF _tx_rd_index=R9
	.DEF _tx_counter=R10
	.DEF _t0_cnt=R11
	.DEF _t0_cnt0=R12
	.DEF _t0_cnt1=R13
	.DEF _t0_cnt2=R14
_STROB:
	.DB  0xFB,0xF7,0xEF,0xDF,0xBF,0xFF
_DIGISYM:
	.DB  0x48,0x7B,0x2C,0x29,0x1B,0x89,0x88,0x6B
	.DB  0x8,0x9,0xFF

;GPIOR0-GPIOR2 INITIALIZATION
	.EQU  __GPIOR0_INIT=0x00
	.EQU  __GPIOR1_INIT=0x00
	.EQU  __GPIOR2_INIT=0x00

__GLOBAL_INI_TBL:
	.DW  0
