;CodeVisionAVR C Compiler V1.24.1d Standard
;(C) Copyright 1998-2004 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.ro
;e-mail:office@hpinfotech.ro

;Chip type           : ATtiny13
;Clock frequency     : 0,128000 MHz
;Memory model        : Tiny
;Optimize for        : Size
;(s)printf features  : int, width
;(s)scanf features   : long, width
;External SRAM size  : 0
;Data Stack size     : 16 byte(s)
;Heap size           : 0 byte(s)
;Promote char to int : No
;char is unsigned    : Yes
;8 bit enums         : Yes
;Automatic register allocation : On

	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __se_bit=0x20
	.EQU __sm_mask=0x18
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@2,@0+@1
	.ENDM

	.MACRO __GETWRMN
	LDS  R@2,@0+@1
	LDS  R@3,@0+@1+1
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETW1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOV  R30,R0
	MOV  R31,R1
	.ENDM

	.MACRO __GETB2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOV  R26,R0
	MOV  R27,R1
	.ENDM

	.MACRO __GETBRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTBSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.CSEG
	.ORG 0

	.INCLUDE "ch_p.vec"
	.INCLUDE "ch_p.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	IN   R26,MCUSR
	OUT  MCUSR,R30
	OUT  WDTCR,R31
	OUT  WDTCR,R30
	OUT  MCUSR,R26

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x40)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM
	ADIW R30,1
	MOV  R24,R0
	LPM
	ADIW R30,1
	MOV  R25,R0
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM
	ADIW R30,1
	MOV  R26,R0
	LPM
	ADIW R30,1
	MOV  R27,R0
	LPM
	ADIW R30,1
	MOV  R1,R0
	LPM
	ADIW R30,1
	MOV  R22,R30
	MOV  R23,R31
	MOV  R31,R0
	MOV  R30,R1
__GLOBAL_INI_LOOP:
	LPM
	ADIW R30,1
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOV  R30,R22
	MOV  R31,R23
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x9F)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x70)
	LDI  R29,HIGH(0x70)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x70
;       1 // �������� ��������, ������� ��������, ������� �����.
;       2 
;       3 #include <tiny13.h>  
;       4 char cnt_imp; 
;       5 unsigned int one_cnt,zero_cnt;
;       6 bit bIN_OLD,bREADY;
;       7 int out_cnt,out_out_cnt;
;       8 int opto_err_cnt;
;       9 bit bOPTO_ERR; 
;      10 char stat; 
_stat:
	.BYTE 0x1
;      11 char t0_cnt0;
_t0_cnt0:
	.BYTE 0x1
;      12 signed short val_cnt,metka_cnt;
_val_cnt:
	.BYTE 0x2
_metka_cnt:
	.BYTE 0x2
;      13 signed long pause_cnt,wrk_cnt;
_pause_cnt:
	.BYTE 0x4
_wrk_cnt:
	.BYTE 0x4
;      14 #pragma savereg-
;      15 //***********************************************
;      16 //***********************************************
;      17 //***********************************************
;      18 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;      19 {

	.CSEG
_timer0_ovf_isr:
;      20 TCNT0=-16;
	LDI  R30,LOW(240)
	OUT  0x32,R30
;      21 
;      22 /*if(wrk_cnt)
;      23 	{
;      24 	pause_cnt=0;
;      25 	wrk_cnt--;
;      26 	if(!wrk_cnt)
;      27 		{
;      28 		//pause_cnt=530000L;
;      29 		pause_cnt=400000L;
;      30 		ee_stat=0;
;      31 		}
;      32 	}
;      33 
;      34 if(pause_cnt)
;      35 	{
;      36 	wrk_cnt=0;
;      37 	pause_cnt--;
;      38 	if(!pause_cnt)
;      39 		{
;      40 		//wrk_cnt=265000L;
;      41 		wrk_cnt=800000L;
;      42 		ee_stat=1;
;      43 		}
;      44 	}*/
;      45 
;      46 if(PINB.3)	//���
	SBIS 0x16,3
	RJMP _0x3
;      47 	{
;      48 	if(val_cnt<10)
	RCALL SUBOPT_0x0
	BRGE _0x4
;      49 		{
;      50 		val_cnt++;
	LDS  R30,_val_cnt
	LDS  R31,_val_cnt+1
	ADIW R30,1
	STS  _val_cnt,R30
	STS  _val_cnt+1,R31
;      51 		if(val_cnt>=10)
	RCALL SUBOPT_0x0
	BRLT _0x5
;      52 			{
;      53 			//metka_cnt=0;
;      54 			stat=1;
	LDI  R30,LOW(1)
	STS  _stat,R30
;      55 			}
;      56 		}
_0x5:
;      57 	}
_0x4:
;      58 else 
	RJMP _0x6
_0x3:
;      59 	{
;      60 	val_cnt=0;	
	LDI  R30,0
	STS  _val_cnt,R30
	STS  _val_cnt+1,R30
;      61 	}	
_0x6:
;      62 
;      63 if(!PINB.1)	//�����
	SBIC 0x16,1
	RJMP _0x7
;      64 	{
;      65 	if(metka_cnt<10)
	RCALL SUBOPT_0x1
	BRGE _0x8
;      66 		{
;      67 		metka_cnt++;
	LDS  R30,_metka_cnt
	LDS  R31,_metka_cnt+1
	ADIW R30,1
	STS  _metka_cnt,R30
	STS  _metka_cnt+1,R31
;      68 		if(metka_cnt>=10)
	RCALL SUBOPT_0x1
	BRLT _0x9
;      69 			{
;      70 			stat=0;
	RCALL SUBOPT_0x2
;      71 			//val_cnt=0;
;      72 			}
;      73 		}
_0x9:
;      74 	}
_0x8:
;      75 else 
	RJMP _0xA
_0x7:
;      76 	{
;      77 	metka_cnt=0;	
	LDI  R30,0
	STS  _metka_cnt,R30
	STS  _metka_cnt+1,R30
;      78 	}	
_0xA:
;      79 
;      80 /*DDRB.4=1;
;      81 PORTB.4=0;
;      82 
;      83 //cnt_imp++;
;      84 //if(cnt_imp>=10)cnt_imp=0;
;      85 //if(cnt_imp<5)PORTB.4=0; 
;      86 
;      87 DDRB.0=1;
;      88 if(out_cnt)
;      89 	{
;      90 	out_cnt--;
;      91 	PORTB.0=0;
;      92 	} 	  
;      93 else if(!bOPTO_ERR)
;      94 	{
;      95 	if(out_out_cnt)out_out_cnt--;
;      96 	else
;      97 		{
;      98 		out_out_cnt=100;
;      99 		PORTB.0=!PORTB.0;
;     100 		}
;     101 	}  */
;     102 
;     103 /*DDRB.4=1;
;     104 PORTB.4=1;
;     105 DDRB.4=1;
;     106 PORTB.4=0;*/	
;     107 t0_cnt0++;
	LDS  R30,_t0_cnt0
	SUBI R30,-LOW(1)
	STS  _t0_cnt0,R30
;     108 if(t0_cnt0>=100)
	LDS  R26,_t0_cnt0
	CPI  R26,LOW(0x64)
	BRLO _0xB
;     109 	{
;     110 	t0_cnt0=0;
	LDI  R30,LOW(0)
	STS  _t0_cnt0,R30
;     111 
;     112 	}
;     113 	if(stat)PORTB.0=1;
_0xB:
	LDS  R30,_stat
	CPI  R30,0
	BREQ _0xC
	SBI  0x18,0
;     114 	else PORTB.0=0;
	RJMP _0xD
_0xC:
	CBI  0x18,0
_0xD:
;     115 /*	if(ee_stat1)PORTB.0=1;
;     116 	else PORTB.0=0;*/
;     117 
;     118 }
	RETI
;     119 #pragma savereg+
;     120 /*#pragma savereg-
;     121 //***********************************************
;     122 interrupt [TIM0_COMPA] void timer0_compa_isr(void)
;     123 {
;     124 PORTB.4=1;
;     125 
;     126 if(!PINB.3)
;     127 	{
;     128 	if(bIN_OLD)
;     129 		{
;     130 		if((one_cnt>20)&&(one_cnt<310)&&bREADY&&(!out_cnt))out_cnt=4000;
;     131 	    	
;     132 		}
;     133 	
;     134 	if(zero_cnt<30000)
;     135 		{
;     136 		zero_cnt++;
;     137 		bREADY=0;
;     138 		}
;     139 	else bREADY=1;
;     140 	one_cnt=0;
;     141 	
;     142 	//bREADY=0;
;     143 	opto_err_cnt=0;
;     144 	bOPTO_ERR=0;
;     145 	bIN_OLD=0;
;     146 	}
;     147 if(PINB.3)
;     148 	{
;     149 	
;     150 	if(one_cnt<30000)
;     151 		{
;     152 		one_cnt++;
;     153 		
;     154 		}
;     155 	
;     156 	zero_cnt=0;
;     157 	
;     158 	
;     159 	if((opto_err_cnt<5000))//(opto_err_cnt)&&
;     160 		{
;     161 		bOPTO_ERR=0;
;     162 		opto_err_cnt++;
;     163 	     }
;     164 	else bOPTO_ERR=1; 
;     165 	
;     166 	
;     167 	bIN_OLD=1;    
;     168 	}
;     169 DDRB.3=0;
;     170 PORTB.3=1;
;     171 }
;     172 #pragma savereg+ */
;     173 //-----------------------------------------------
;     174 //-----------------------------------------------
;     175 //-----------------------------------------------
;     176 //-----------------------------------------------
;     177 
;     178 void main(void)
;     179 {
_main:
;     180 // Declare your local variables here
;     181 
;     182 // Crystal Oscillator division factor: 1
;     183 CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
;     184 CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
;     185 
;     186 // Input/Output Ports initialization
;     187 // Port B initialization
;     188 // Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;     189 // State5=T State4=T State3=T State2=T State1=T State0=T 
;     190 //DDRB=0xf0;
;     191 //PORTB=0x0A;
;     192 DDRB.0=1;
	SBI  0x17,0
;     193 DDRB.4=1;
	SBI  0x17,4
;     194 DDRB.1=0;
	CBI  0x17,1
;     195 DDRB.3=0;
	CBI  0x17,3
;     196 PORTB.1=1;
	SBI  0x18,1
;     197 PORTB.3=0;
	CBI  0x18,3
;     198 
;     199 // Timer/Counter 0 initialization
;     200 // Clock source: System Clock
;     201 // Clock value: 0,500 kHz
;     202 // Mode: Normal top=FFh
;     203 // OC0A output: Disconnected
;     204 // OC0B output: Disconnected
;     205 TCCR0A=0x00;
	OUT  0x2F,R30
;     206 TCCR0B=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
;     207 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
;     208 OCR0A=0x00;
	OUT  0x36,R30
;     209 OCR0B=0x00;
	OUT  0x29,R30
;     210 
;     211 // External Interrupt(s) initialization
;     212 // INT0: Off
;     213 // Interrupt on any change on pins PCINT0-5: Off
;     214 GIMSK=0x00;
	OUT  0x3B,R30
;     215 MCUCR=0x00;
	OUT  0x35,R30
;     216 
;     217 // Timer/Counter 0 Interrupt(s) initialization
;     218 TIMSK0=0x02;
	LDI  R30,LOW(2)
	OUT  0x39,R30
;     219 TCNT0=-50;
	LDI  R30,LOW(206)
	OUT  0x32,R30
;     220 //OCR0A=-120;
;     221 // Analog Comparator initialization
;     222 // Analog Comparator: Off
;     223 // Analog Comparator Output: Off
;     224 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     225 ADCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
;     226 
;     227 stat=0;
	RCALL SUBOPT_0x2
;     228 //pause_cnt=530000L;
;     229 //wrk_cnt=0;
;     230 
;     231 // Global enable interrupts
;     232 #asm("sei")
	sei
;     233 
;     234 while (1)
_0xE:
;     235       {
;     236       // Place your code here
;     237 
;     238       };
	RJMP _0xE
;     239 }
_0x11:
	RJMP _0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	LDS  R26,_val_cnt
	LDS  R27,_val_cnt+1
	CPI  R26,LOW(0xA)
	LDI  R30,HIGH(0xA)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	LDS  R26,_metka_cnt
	LDS  R27,_metka_cnt+1
	CPI  R26,LOW(0xA)
	LDI  R30,HIGH(0xA)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2:
	LDI  R30,LOW(0)
	STS  _stat,R30
	RET

