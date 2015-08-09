;CodeVisionAVR C Compiler V1.24.1d Standard
;(C) Copyright 1998-2004 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.ro
;e-mail:office@hpinfotech.ro

;Chip type           : ATtiny2313
;Clock frequency     : 4,000000 MHz
;Memory model        : Tiny
;Optimize for        : Size
;(s)printf features  : int, width
;(s)scanf features   : long, width
;External SRAM size  : 0
;Data Stack size     : 32 byte(s)
;Heap size           : 0 byte(s)
;Promote char to int : No
;char is unsigned    : Yes
;8 bit enums         : Yes
;Enhanced core instructions    : On
;Automatic register allocation : On

	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
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
	.EQU GPIOR0=0x13
	.EQU GPIOR1=0x14
	.EQU GPIOR2=0x15

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
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40

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
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
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
	MOVW R26,R28
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
	MOVW R26,R28
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

	.MACRO __MULBRR
	MULS R@0,R@1
	MOV  R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOV  R30,R0
	.ENDM

	.CSEG
	.ORG 0

	.INCLUDE "gavt9_23131.vec"
	.INCLUDE "gavt9_23131.inc"

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
	LDI  R24,LOW(0x80)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	LDI  R30,__GPIOR1_INIT
	OUT  GPIOR1,R30
	LDI  R30,__GPIOR2_INIT
	OUT  GPIOR2,R30

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0xDF)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x80)
	LDI  R29,HIGH(0x80)

	RJMP _main

	.ESEG
	.ORG 0
	.DB  0 ; FIRST EEPROM LOCATION NOT USED, SEE ATMEL ERRATA SHEETS

	.DSEG
	.ORG 0x80
;       1 #include <tiny2313.h>
;       2 
;       3 char t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3,t0_cnt4,t0_cnt5,t0_cnt6;
;       4 //***********************************************
;       5 //Битовые переменные
;       6 bit b200Hz;
;       7 bit b100Hz;
;       8 bit b10Hz;
;       9 bit b5Hz;
;      10 bit b2Hz;
;      11 bit b1Hz;
;      12 bit zero_on;
;      13 bit bFl;
;      14 bit bT;
;      15 bit bFl_;
;      16 
;      17 int in_cnt,main_cnt;
_main_cnt:
	.BYTE 0x2
;      18 
;      19 // Timer 0 overflow interrupt service routine
;      20 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;      21 {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;      22 // Place your code here
;      23 TCNT0=-78;
	RCALL SUBOPT_0x0
;      24 
;      25 
;      26 b100Hz=1;
	SBI  0x13,1
;      27 
;      28 if(++t0_cnt1>=10)
	INC  R6
	LDI  R30,LOW(10)
	CP   R6,R30
	BRLO _0x3
;      29 	{
;      30 	t0_cnt1=0;
	CLR  R6
;      31 	b10Hz=1;
	SBI  0x13,2
;      32 	
;      33 	if(++t0_cnt3>=10)
	INC  R8
	CP   R8,R30
	BRLO _0x4
;      34 		{
;      35 		t0_cnt3=0;
	CLR  R8
;      36 		b1Hz=1;
	SBI  0x13,5
;      37 		} 
;      38 	if(++t0_cnt4>=5)
_0x4:
	INC  R9
	LDI  R30,LOW(5)
	CP   R9,R30
	BRLO _0x5
;      39 		{
;      40 		t0_cnt4=0;
	CLR  R9
;      41 		b2Hz=1;
	SBI  0x13,4
;      42 		}	
;      43 	} 
_0x5:
;      44 if(++t0_cnt2>=20)
_0x3:
	INC  R7
	LDI  R30,LOW(20)
	CP   R7,R30
	BRLO _0x6
;      45 	{
;      46 	t0_cnt2=0;
	CLR  R7
;      47 	b5Hz=1;
	SBI  0x13,3
;      48 	
;      49 	
;      50 	} 
;      51 
;      52 }
_0x6:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;      53 
;      54 // Declare your global variables here
;      55 
;      56 void main(void)
;      57 {
_main:
;      58 // Declare your local variables here
;      59 
;      60 // Crystal Oscillator division factor: 1
;      61 CLKPR=0x80;
	LDI  R30,LOW(128)
	RCALL SUBOPT_0x1
;      62 CLKPR=0x00;
	RCALL SUBOPT_0x1
;      63 
;      64 // Input/Output Ports initialization
;      65 // Port A initialization
;      66 // Func2=In Func1=In Func0=In
;      67 // State2=T State1=T State0=T
;      68 PORTA=0x00;
	OUT  0x1B,R30
;      69 DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
;      70 
;      71 // Port B initialization
;      72 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
;      73 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
;      74 PORTB=0x00;
	OUT  0x18,R30
;      75 DDRB=0x00;
	OUT  0x17,R30
;      76 
;      77 // Port D initialization
;      78 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
;      79 // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
;      80 PORTD=0x00;
	OUT  0x12,R30
;      81 DDRD=0x00;
	OUT  0x11,R30
;      82 
;      83 // Timer/Counter 0 initialization
;      84 // Clock source: System Clock
;      85 // Clock value: 7,813 kHz
;      86 // Mode: Normal top=FFh
;      87 // OC0A output: Disconnected
;      88 // OC0B output: Disconnected
;      89 TCCR0A=0x00;
	OUT  0x30,R30
;      90 TCCR0B=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
;      91 TCNT0=-78;
	RCALL SUBOPT_0x0
;      92 OCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x36,R30
;      93 OCR0B=0x00;
	OUT  0x3C,R30
;      94 
;      95 // Timer/Counter 1 initialization
;      96 // Clock source: System Clock
;      97 // Clock value: Timer 1 Stopped
;      98 // Mode: Normal top=FFFFh
;      99 // OC1A output: Discon.
;     100 // OC1B output: Discon.
;     101 // Noise Canceler: Off
;     102 // Input Capture on Falling Edge
;     103 TCCR1A=0x00;
	OUT  0x2F,R30
;     104 TCCR1B=0x00;
	OUT  0x2E,R30
;     105 TCNT1H=0x00;
	OUT  0x2D,R30
;     106 TCNT1L=0x00;
	OUT  0x2C,R30
;     107 ICR1H=0x00;
	OUT  0x25,R30
;     108 ICR1L=0x00;
	OUT  0x24,R30
;     109 OCR1AH=0x00;
	OUT  0x2B,R30
;     110 OCR1AL=0x00;
	OUT  0x2A,R30
;     111 OCR1BH=0x00;
	OUT  0x29,R30
;     112 OCR1BL=0x00;
	OUT  0x28,R30
;     113 
;     114 // External Interrupt(s) initialization
;     115 // INT0: Off
;     116 // INT1: Off
;     117 // Interrupt on any change on pins PCINT0-7: Off
;     118 GIMSK=0x00;
	OUT  0x3B,R30
;     119 MCUCR=0x00;
	OUT  0x35,R30
;     120 
;     121 // Timer(s)/Counter(s) Interrupt(s) initialization
;     122 TIMSK=0x02;
	LDI  R30,LOW(2)
	OUT  0x39,R30
;     123 
;     124 // Universal Serial Interface initialization
;     125 // Mode: Disabled
;     126 // Clock source: Register & Counter=no clk.
;     127 // USI Counter Overflow Interrupt: Off
;     128 USICR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
;     129 
;     130 // Analog Comparator initialization
;     131 // Analog Comparator: Off
;     132 // Analog Comparator Input Capture by Timer/Counter 1: Off
;     133 // Analog Comparator Output: Off
;     134 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     135 
;     136 main_cnt=30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	STS  _main_cnt,R30
	STS  _main_cnt+1,R31
;     137 // Global enable interrupts
;     138 #asm("sei")
	sei
;     139 
;     140 while (1)
_0x7:
;     141       {
;     142 while (1)
_0xA:
;     143 	{
;     144 	if(b100Hz)
	SBIS 0x13,1
	RJMP _0xD
;     145 		{
;     146 		b100Hz=0;
	CBI  0x13,1
;     147 
;     148 		if(!PIND.6)
	SBIC 0x10,6
	RJMP _0xE
;     149 			{
;     150 			if(in_cnt<5)
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R12,R30
	CPC  R13,R31
	BRGE _0xF
;     151 				{
;     152 				in_cnt++;
	__GETW1R 12,13
	ADIW R30,1
	__PUTW1R 12,13
;     153 				if(in_cnt==5)
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x10
;     154 					{
;     155 					main_cnt=0;
	LDI  R30,0
	STS  _main_cnt,R30
	STS  _main_cnt+1,R30
;     156 					}          
;     157 				}
_0x10:
;     158 			}
_0xF:
;     159 		else
	RJMP _0x11
_0xE:
;     160 			{
;     161 			in_cnt=0;
	CLR  R12
	CLR  R13
;     162 			}			
_0x11:
;     163 			
;     164 			
;     165 		DDRD.6=0;
	CBI  0x11,6
;     166 		PORTD.6=1; 
	SBI  0x12,6
;     167 
;     168 		}             
;     169 	if(b10Hz)
_0xD:
	SBIS 0x13,2
	RJMP _0x12
;     170 		{
;     171 		b10Hz=0; 
	CBI  0x13,2
;     172 	
;     173 		DDRD|=0b00110000;
	IN   R30,0x11
	ORI  R30,LOW(0x30)
	OUT  0x11,R30
;     174           if(main_cnt<30)main_cnt++;
	LDS  R26,_main_cnt
	LDS  R27,_main_cnt+1
	CPI  R26,LOW(0x1E)
	LDI  R30,HIGH(0x1E)
	CPC  R27,R30
	BRGE _0x13
	LDS  R30,_main_cnt
	LDS  R31,_main_cnt+1
	ADIW R30,1
	STS  _main_cnt,R30
	STS  _main_cnt+1,R31
;     175           if((main_cnt>0)&&(main_cnt<=13))
_0x13:
	LDS  R26,_main_cnt
	LDS  R27,_main_cnt+1
	RCALL __CPW02
	BRGE _0x15
	RCALL SUBOPT_0x2
	BRGE _0x16
_0x15:
	RJMP _0x14
_0x16:
;     176           	{
;     177           	PORTD.5=1;
	SBI  0x12,5
;     178           	}
;     179           else PORTD.5=0;
	RJMP _0x17
_0x14:
	CBI  0x12,5
_0x17:
;     180           
;     181           if((main_cnt>5)&&(main_cnt<=13))
	LDS  R26,_main_cnt
	LDS  R27,_main_cnt+1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x19
	RCALL SUBOPT_0x2
	BRGE _0x1A
_0x19:
	RJMP _0x18
_0x1A:
;     182           	{
;     183           	PORTD.4=1;
	SBI  0x12,4
;     184           	}
;     185           else PORTD.4=0;          	
	RJMP _0x1B
_0x18:
	CBI  0x12,4
_0x1B:
;     186           
;     187 		}
;     188 	if(b5Hz)
_0x12:
;     189 		{
;     190 
;     191 		} 
;     192     	if(b1Hz)
	SBIS 0x13,5
	RJMP _0x1D
;     193 		{
;     194 		b1Hz=0;
	CBI  0x13,5
;     195 /*DDRD.5=1;
;     196 PORTD.5=!PORTD.5;*/
;     197 
;     198 		}
;     199      #asm("wdr")	
_0x1D:
	wdr
;     200 	}
	RJMP _0xA
;     201       };
	RJMP _0x7
;     202 }
_0x1E:
	RJMP _0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	LDI  R30,LOW(178)
	OUT  0x32,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	OUT  0x26,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2:
	LDS  R26,_main_cnt
	LDS  R27,_main_cnt+1
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CP   R30,R26
	CPC  R31,R27
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

