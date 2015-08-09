;CodeVisionAVR C Compiler V1.24.1d Standard
;(C) Copyright 1998-2004 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.ro
;e-mail:office@hpinfotech.ro

;Chip type           : ATtiny2313
;Clock frequency     : 8,000000 MHz
;Memory model        : Tiny
;Optimize for        : Size
;(s)printf features  : int, width
;(s)scanf features   : long, width
;External SRAM size  : 0
;Data Stack size     : 50 byte(s)
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

	.INCLUDE "GAVT6.vec"
	.INCLUDE "GAVT6.inc"

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
	LDI  R28,LOW(0x92)
	LDI  R29,HIGH(0x92)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x92
;       1 //Программа для платы индикации "Пакетик полуавтомат"(3 задержки)
;       2 
;       3 
;       4 #include <90s2313.h>
;       5 #include <delay.h>
;       6 #include <stdio.h>
;       7 #include <math.h>
;       8 
;       9 
;      10 
;      11 #define but_on	 25
;      12 #define on	 0
;      13 #define off	 1
;      14 
;      15 
;      16 bit b100Hz;
;      17 bit b10Hz;
;      18 bit b5Hz;
;      19 bit b1Hz;
;      20 bit bFL;
;      21 bit bZ;
;      22 bit speed=0;
;      23 
;      24 char t0_cnt,t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3;
;      25 char ind_cnt;
;      26 char ind_out[5];
_ind_out:
	.BYTE 0x5
;      27 char dig[4];
_dig:
	.BYTE 0x4
;      28 flash char STROB[]={0b11111011,0b11110111,0b11101111,0b11011111,0b10111111,0b11111111};

	.CSEG
;      29 flash char DIGISYM[]={0b01001000,0b01111011,0b00101100,0b00101001,0b00011011,0b10001001,0b10001000,0b01101011,0b00001000,0b00001001,0b11111111};								
;      30 						
;      31 
;      32 char but_pr_LD_if,but_pr_LD_get,but_pr_imp_v,delay,but_pr_CAN_vozb;

	.DSEG
_but_pr_CAN_vozb:
	.BYTE 0x1
;      33 bit n_but_LD_if,n_but_LD_get,n_but_imp_v,delay_on,n_but_CAN_vozb;
;      34 int cnt;
_cnt:
	.BYTE 0x2
;      35 int ccc1,ccc2,ccc3;
_ccc1:
	.BYTE 0x2
_ccc2:
	.BYTE 0x2
_ccc3:
	.BYTE 0x2
;      36 
;      37 char but_cnt0,but_cnt1,but_cnt01;
_but_cnt0:
	.BYTE 0x1
_but_cnt1:
	.BYTE 0x1
_but_cnt01:
	.BYTE 0x1
;      38 bit b0,b0L,b1,b1L,b01,b01L;
;      39 
;      40 enum {iMn,iSet} ind;
_ind:
	.BYTE 0x1
;      41 eeprom int delay_ee;

	.ESEG
_delay_ee:
	.DW  0x0
;      42 int delay_cnt;

	.DSEG
_delay_cnt:
	.BYTE 0x2
;      43 //-----------------------------------------------
;      44 void t0_init(void)
;      45 {

	.CSEG
_t0_init:
;      46 TCCR0=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
;      47 TCNT0=-62;
	LDI  R30,LOW(194)
	OUT  0x32,R30
;      48 } 
	RET
;      49 
;      50 //-----------------------------------------------
;      51 void port_init(void)
;      52 {
_port_init:
;      53 PORTB=0x1B;
	LDI  R30,LOW(27)
	OUT  0x18,R30
;      54 DDRB=0x1F;
	LDI  R30,LOW(31)
	OUT  0x17,R30
;      55 
;      56 
;      57 PORTD=0x7B;
	LDI  R30,LOW(123)
	OUT  0x12,R30
;      58 DDRD=0x6F;
	LDI  R30,LOW(111)
	OUT  0x11,R30
;      59 } 
	RET
;      60 
;      61 
;      62 //-----------------------------------------------
;      63 void granee(eeprom signed int *adr, signed int min, signed int max)
;      64 {
_granee:
;      65 if (*adr<min) *adr=min;
	RCALL SUBOPT_0x0
	MOVW R26,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x3
	RCALL SUBOPT_0x1
;      66 if (*adr>max) *adr=max; 
_0x3:
	RCALL SUBOPT_0x0
	MOVW R26,R30
	LD   R30,Y
	LDD  R31,Y+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x4
	RCALL SUBOPT_0x1
;      67 } 
_0x4:
	ADIW R28,6
	RET
;      68 
;      69 
;      70 
;      71 
;      72 //-----------------------------------------------
;      73 void bin2bcd_int(unsigned int in)
;      74 {
_bin2bcd_int:
;      75 char i;
;      76 for(i=3;i>0;i--)
	ST   -Y,R16
;	in -> Y+1
;	i -> R16
	LDI  R16,LOW(3)
_0x6:
	LDI  R30,LOW(0)
	CP   R30,R16
	BRSH _0x7
;      77 	{
;      78 	dig[i]=in%10;
	MOV  R30,R16
	SUBI R30,-LOW(_dig)
	PUSH R30
	RCALL SUBOPT_0x2
	RCALL __MODW21U
	POP  R26
	ST   X,R30
;      79 	in/=10;
	RCALL SUBOPT_0x2
	RCALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
;      80 	}   
	SUBI R16,1
	RJMP _0x6
_0x7:
;      81 }
	LDD  R16,Y+0
	ADIW R28,3
	RET
;      82 
;      83 //-----------------------------------------------
;      84 void bcd2ind(char s)
;      85 {
_bcd2ind:
;      86 char i;
;      87 bZ=1;
	ST   -Y,R16
;	s -> Y+1
;	i -> R16
	SBI  0x13,5
;      88 for (i=0;i<5;i++)
	LDI  R16,LOW(0)
_0x9:
	CPI  R16,5
	BRSH _0xA
;      89 	{
;      90 	if(bZ&&(!dig[i-1])&&(i<4))
	SBIS 0x13,5
	RJMP _0xC
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	CPI  R30,0
	BRNE _0xC
	CPI  R16,4
	BRLO _0xD
_0xC:
	RJMP _0xB
_0xD:
;      91 		{
;      92 		if((4-i)>s)
	LDI  R30,LOW(4)
	SUB  R30,R16
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
	BRSH _0xE
;      93 			{
;      94 			ind_out[i-1]=DIGISYM[10];
	RCALL SUBOPT_0x3
	SUBI R30,-LOW(_ind_out)
	PUSH R30
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	POP  R26
	RJMP _0x51
;      95 			}
;      96 		else ind_out[i-1]=DIGISYM[0];	
_0xE:
	RCALL SUBOPT_0x3
	SUBI R30,-LOW(_ind_out)
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	LPM  R30,Z
	POP  R26
_0x51:
	ST   X,R30
;      97 		}
;      98 	else
	RJMP _0x10
_0xB:
;      99 		{
;     100 		ind_out[i-1]=DIGISYM[dig[i-1]];
	RCALL SUBOPT_0x3
	SUBI R30,-LOW(_ind_out)
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	POP  R26
	POP  R27
	RCALL SUBOPT_0x5
	LPM  R30,Z
	POP  R26
	ST   X,R30
;     101 		bZ=0;
	CBI  0x13,5
;     102 		}                   
_0x10:
;     103 
;     104 	if(s)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x11
;     105 		{
;     106 		ind_out[3-s]&=0b11110111;
	LDD  R26,Y+1
	LDI  R30,LOW(3)
	SUB  R30,R26
	SUBI R30,-LOW(_ind_out)
	PUSH R30
	LD   R30,Z
	ANDI R30,0XF7
	POP  R26
	ST   X,R30
;     107 		}	
;     108  
;     109 	}
_0x11:
	SUBI R16,-1
	RJMP _0x9
_0xA:
;     110 }                         
	LDD  R16,Y+0
	ADIW R28,2
	RET
;     111              
;     112 //-----------------------------------------------
;     113 void int2ind(unsigned int in,char s,char fl)
;     114 {
_int2ind:
;     115 bin2bcd_int(in);
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _bin2bcd_int
;     116 bcd2ind(s);
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _bcd2ind
;     117 if(fl)
	LD   R30,Y
	CPI  R30,0
	BREQ _0x12
;     118 	{
;     119 	if(bFL)
	SBIS 0x13,4
	RJMP _0x13
;     120 		{
;     121 		ind_out[0]=0b11111111;
	LDI  R30,LOW(255)
	STS  _ind_out,R30
;     122 		ind_out[1]=0b11111111;
	__PUTB1MN _ind_out,1
;     123 		ind_out[2]=0b11111111;
	__PUTB1MN _ind_out,2
;     124 		ind_out[3]=0b11111111;
	__PUTB1MN _ind_out,3
;     125 		}
;     126 	}
_0x13:
;     127 } 
_0x12:
	ADIW R28,4
	RET
;     128 
;     129 //-----------------------------------------------
;     130 void ind_hndl(void)
;     131 {
_ind_hndl:
;     132 if(ind==iMn)
	RCALL SUBOPT_0x6
	BRNE _0x14
;     133 	{  
;     134 	int2ind(delay_ee,1,0);
	RCALL SUBOPT_0x7
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x8
;     135 	}
;     136 else  if(ind==iSet)
	RJMP _0x15
_0x14:
	RCALL SUBOPT_0x9
	BRNE _0x16
;     137 	{
;     138 	int2ind(delay_ee,1,1);
	RCALL SUBOPT_0x7
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x8
;     139 	} 
;     140 } 
_0x16:
_0x15:
	RET
;     141 
;     142 
;     143 //-----------------------------------------------
;     144 void but_drv(void)
;     145 {
_but_drv:
;     146 DDRB&=0b11111100;
	IN   R30,0x17
	ANDI R30,LOW(0xFC)
	OUT  0x17,R30
;     147 PORTB|=0b00000011;
	IN   R30,0x18
	ORI  R30,LOW(0x3)
	OUT  0x18,R30
;     148 #asm("nop")
	nop
;     149 if((!PINB.0)&&(PINB.1))
	SBIC 0x16,0
	RJMP _0x18
	SBIC 0x16,1
	RJMP _0x19
_0x18:
	RJMP _0x17
_0x19:
;     150 	{
;     151 	if(but_cnt0<200)
	RCALL SUBOPT_0xA
	BRSH _0x1A
;     152 		{
;     153 		but_cnt0++;
	LDS  R30,_but_cnt0
	SUBI R30,-LOW(1)
	STS  _but_cnt0,R30
;     154 		if(but_cnt0==20) b0=1;
	LDS  R26,_but_cnt0
	CPI  R26,LOW(0x14)
	BRNE _0x1B
	SBI  0x14,4
;     155 		if(but_cnt0==200)
_0x1B:
	RCALL SUBOPT_0xA
	BRNE _0x1C
;     156 			{
;     157 			b0L=1;
	SBI  0x14,5
;     158 			but_cnt0=150;
	LDI  R30,LOW(150)
	STS  _but_cnt0,R30
;     159 			}
;     160 		}	
_0x1C:
;     161 	}     
_0x1A:
;     162 else 
	RJMP _0x1D
_0x17:
;     163 	{
;     164 	but_cnt0=0;
	LDI  R30,LOW(0)
	STS  _but_cnt0,R30
;     165 	}	
_0x1D:
;     166 
;     167 if((PINB.0)&&(!PINB.1))
	SBIS 0x16,0
	RJMP _0x1F
	SBIS 0x16,1
	RJMP _0x20
_0x1F:
	RJMP _0x1E
_0x20:
;     168 	{
;     169 	if(but_cnt1<200)
	RCALL SUBOPT_0xB
	BRSH _0x21
;     170 		{
;     171 		but_cnt1++;
	LDS  R30,_but_cnt1
	SUBI R30,-LOW(1)
	STS  _but_cnt1,R30
;     172 		if(but_cnt1==20) b1=1;
	LDS  R26,_but_cnt1
	CPI  R26,LOW(0x14)
	BRNE _0x22
	SBI  0x14,6
;     173 		if(but_cnt1==200)
_0x22:
	RCALL SUBOPT_0xB
	BRNE _0x23
;     174 			{
;     175 			b1L=1;
	SBI  0x14,7
;     176 			but_cnt1=150;
	LDI  R30,LOW(150)
	STS  _but_cnt1,R30
;     177 			}
;     178 		}	
_0x23:
;     179 	}     
_0x21:
;     180 else 
	RJMP _0x24
_0x1E:
;     181 	{
;     182 	but_cnt1=0;
	LDI  R30,LOW(0)
	STS  _but_cnt1,R30
;     183 	}	
_0x24:
;     184 
;     185 if((!PINB.0)&&(!PINB.1))
	SBIC 0x16,0
	RJMP _0x26
	SBIS 0x16,1
	RJMP _0x27
_0x26:
	RJMP _0x25
_0x27:
;     186 	{
;     187 	if(but_cnt01<200)
	RCALL SUBOPT_0xC
	BRSH _0x28
;     188 		{
;     189 		but_cnt01++;
	LDS  R30,_but_cnt01
	SUBI R30,-LOW(1)
	STS  _but_cnt01,R30
;     190 		if(but_cnt01==20) b01=1;
	LDS  R26,_but_cnt01
	CPI  R26,LOW(0x14)
	BRNE _0x29
	SBI  0x15,0
;     191 		if(but_cnt01==200)
_0x29:
	RCALL SUBOPT_0xC
	BRNE _0x2A
;     192 			{
;     193 			b01L=1;
	SBI  0x15,1
;     194 			but_cnt01=150;
	LDI  R30,LOW(150)
	STS  _but_cnt01,R30
;     195 			}
;     196 		}	
_0x2A:
;     197 	}     
_0x28:
;     198 else 
	RJMP _0x2B
_0x25:
;     199 	{
;     200 	but_cnt01=0;
	LDI  R30,LOW(0)
	STS  _but_cnt01,R30
;     201 	}	
_0x2B:
;     202 
;     203 } 
	RET
;     204 
;     205 //-----------------------------------------------
;     206 void but_an(void)
;     207 {
_but_an:
;     208 if(ind==iMn)
	RCALL SUBOPT_0x6
	BRNE _0x2C
;     209 	{
;     210 	if(b0)
	SBIS 0x14,4
	RJMP _0x2D
;     211 		{
;     212 		b0=0;
	CBI  0x14,4
;     213 	     delay_cnt=delay_ee;
	RCALL SUBOPT_0xD
;     214 	     
;     215 		}
;     216 	else if(b1)
	RJMP _0x2E
_0x2D:
	SBIS 0x14,6
	RJMP _0x2F
;     217 		{
;     218     		b1=0;
	CBI  0x14,6
;     219 	     delay_cnt=delay_ee;
	RCALL SUBOPT_0xD
;     220 		}
;     221 	else if(b0L)
	RJMP _0x30
_0x2F:
	SBIS 0x14,5
	RJMP _0x31
;     222 		{
;     223     		b0L=0;
	CBI  0x14,5
;     224 	
;     225 		}
;     226 	else if(b1L)
	RJMP _0x32
_0x31:
	SBIS 0x14,7
	RJMP _0x33
;     227 		{
;     228 		b1L=0;
	CBI  0x14,7
;     229 	
;     230 		}
;     231 	else if(b01)
	RJMP _0x34
_0x33:
	SBIS 0x15,0
	RJMP _0x35
;     232 		{
;     233     		b01=0;
	CBI  0x15,0
;     234           ind=iSet;
	LDI  R30,LOW(1)
	STS  _ind,R30
;     235 		}
;     236 	}	 
_0x35:
_0x34:
_0x32:
_0x30:
_0x2E:
;     237 if(ind==iSet)
_0x2C:
	RCALL SUBOPT_0x9
	BRNE _0x36
;     238 	{
;     239 	if(b0)
	SBIS 0x14,4
	RJMP _0x37
;     240 		{
;     241 		b0=0;
	CBI  0x14,4
;     242 	     delay_ee++;
	LDI  R26,LOW(_delay_ee)
	LDI  R27,HIGH(_delay_ee)
	RCALL __EEPROMRDW
	ADIW R30,1
	RCALL __EEPROMWRW
	SBIW R30,1
;     243 		}
;     244 	else if(b1)
	RJMP _0x38
_0x37:
	SBIS 0x14,6
	RJMP _0x39
;     245 		{
;     246     		b1=0;
	CBI  0x14,6
;     247 	     delay_ee--;
	LDI  R26,LOW(_delay_ee)
	LDI  R27,HIGH(_delay_ee)
	RCALL __EEPROMRDW
	SBIW R30,1
	RCALL __EEPROMWRW
	ADIW R30,1
;     248 		}
;     249 	else if(b0L)
	RJMP _0x3A
_0x39:
	SBIS 0x14,5
	RJMP _0x3B
;     250 		{
;     251     		b0L=0;
	CBI  0x14,5
;     252 	     delay_ee+=10;
	LDI  R26,LOW(_delay_ee)
	LDI  R27,HIGH(_delay_ee)
	RCALL __EEPROMRDW
	ADIW R30,10
	RCALL __EEPROMWRW
;     253 		}
;     254 	else if(b1L)
	RJMP _0x3C
_0x3B:
	SBIS 0x14,7
	RJMP _0x3D
;     255 		{
;     256 		b1L=0;
	CBI  0x14,7
;     257 	     delay_ee-=10;
	LDI  R26,LOW(_delay_ee)
	LDI  R27,HIGH(_delay_ee)
	RCALL __EEPROMRDW
	SBIW R30,10
	RCALL __EEPROMWRW
;     258 		}
;     259 	else if(b01)
	RJMP _0x3E
_0x3D:
	SBIS 0x15,0
	RJMP _0x3F
;     260 		{
;     261     		b01=0;
	CBI  0x15,0
;     262           ind=iMn;
	RCALL SUBOPT_0xE
;     263 		}
;     264 	granee(&delay_ee,1,100);
_0x3F:
_0x3E:
_0x3C:
_0x3A:
_0x38:
	LDI  R30,LOW(_delay_ee)
	LDI  R31,HIGH(_delay_ee)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _granee
;     265 	}					
;     266 }
_0x36:
	RET
;     267 
;     268 //***********************************************
;     269 //***********************************************
;     270 //***********************************************
;     271 //***********************************************
;     272 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;     273 {
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     274 t0_init();
	RCALL _t0_init
;     275 if(++ind_cnt>5) ind_cnt=0;
	INC  R10
	RCALL SUBOPT_0xF
	BRSH _0x40
	CLR  R10
;     276 DDRB=0xff;
_0x40:
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     277 PORTB=0xff;
	OUT  0x18,R30
;     278 DDRD|=0b11111100;
	IN   R30,0x11
	ORI  R30,LOW(0xFC)
	OUT  0x11,R30
;     279 PORTD=(PORTD|0b11111100)&STROB[ind_cnt];
	IN   R30,0x12
	ORI  R30,LOW(0xFC)
	PUSH R30
	LDI  R26,LOW(_STROB*2)
	LDI  R27,HIGH(_STROB*2)
	MOV  R30,R10
	RCALL SUBOPT_0x5
	LPM  R30,Z
	POP  R26
	AND  R30,R26
	OUT  0x12,R30
;     280 if(ind_cnt!=5) PORTB=ind_out[ind_cnt];
	RCALL SUBOPT_0xF
	BREQ _0x41
	LDI  R26,LOW(_ind_out)
	ADD  R26,R10
	LD   R30,X
	OUT  0x18,R30
;     281 else 
	RJMP _0x42
_0x41:
;     282 	{
;     283 	but_drv();
	RCALL _but_drv
;     284 	}
_0x42:
;     285 
;     286 if(++t0_cnt>=20) 
	INC  R5
	LDI  R30,LOW(20)
	CP   R5,R30
	BRLO _0x43
;     287 	{
;     288 	t0_cnt=0;
	CLR  R5
;     289 	b100Hz=1;
	SBI  0x13,0
;     290 	if(++t0_cnt0>=10)
	INC  R6
	LDI  R30,LOW(10)
	CP   R6,R30
	BRLO _0x44
;     291 		{
;     292 		t0_cnt0=0;
	CLR  R6
;     293 		b10Hz=1;
	SBI  0x13,1
;     294 
;     295 		} 
;     296 	if(++t0_cnt1>=20)
_0x44:
	INC  R7
	LDI  R30,LOW(20)
	CP   R7,R30
	BRLO _0x45
;     297 		{
;     298 		t0_cnt1=0;
	CLR  R7
;     299 		b5Hz=1;
	SBI  0x13,2
;     300      	bFL=!bFL;
	CLT
	SBIS 0x13,4
	SET
	IN   R30,0x13
	BLD  R30,4
	OUT  0x13,R30
;     301 		}
;     302 	if(++t0_cnt2>=100)
_0x45:
	INC  R8
	LDI  R30,LOW(100)
	CP   R8,R30
	BRLO _0x46
;     303 		{
;     304 		t0_cnt2=0;
	CLR  R8
;     305 		b1Hz=1;
	SBI  0x13,3
;     306 	     }
;     307 	}		
_0x46:
;     308 
;     309 }
_0x43:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;     310 
;     311 //===============================================
;     312 //===============================================
;     313 //===============================================
;     314 //===============================================
;     315 void main(void)
;     316 {
_main:
;     317 
;     318 t0_init();
	RCALL _t0_init
;     319 port_init();
	RCALL _port_init
;     320 
;     321 TIMSK=0x02;
	LDI  R30,LOW(2)
	OUT  0x39,R30
;     322 #asm("sei")
	sei
;     323 
;     324 
;     325 ind=iMn;
	RCALL SUBOPT_0xE
;     326 while (1)
_0x47:
;     327 	{
;     328 
;     329 	if(b100Hz)
	SBIS 0x13,0
	RJMP _0x4A
;     330 		{
;     331 		b100Hz=0;
	CBI  0x13,0
;     332 
;     333 		}             
;     334 	if(b10Hz)
_0x4A:
	SBIS 0x13,1
	RJMP _0x4B
;     335 		{
;     336 		b10Hz=0;
	CBI  0x13,1
;     337    	     but_an();
	RCALL _but_an
;     338    	     if(delay_cnt)
	LDS  R30,_delay_cnt
	LDS  R31,_delay_cnt+1
	SBIW R30,0
	BREQ _0x4C
;     339    	     	{
;     340    	     	DDRD.1=1;
	SBI  0x11,1
;     341    	     	PORTD.1=1;
	SBI  0x12,1
;     342    	     	delay_cnt--;
	SBIW R30,1
	STS  _delay_cnt,R30
	STS  _delay_cnt+1,R31
;     343    	     	}
;     344    	     else PORTD.1=0;	
	RJMP _0x4D
_0x4C:
	CBI  0x12,1
_0x4D:
;     345 		}
;     346 	if(b5Hz)
_0x4B:
	SBIS 0x13,2
	RJMP _0x4E
;     347 		{
;     348 		b5Hz=0;
	CBI  0x13,2
;     349 		ind_hndl();
	RCALL _ind_hndl
;     350 		} 
;     351     	if(b1Hz)
_0x4E:
	SBIS 0x13,3
	RJMP _0x4F
;     352 		{
;     353 		b1Hz=0;
	CBI  0x13,3
;     354 
;     355 
;     356 		}
;     357      #asm("wdr")	
_0x4F:
	wdr
;     358 	}
	RJMP _0x47
;     359 }
_0x50:
	RJMP _0x50
_getchar:
     sbis usr,rxc
     rjmp _getchar
     in   r30,udr
	RET
_putchar:
     sbis usr,udre
     rjmp _putchar
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x3:
	MOV  R30,R16
	SUBI R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4:
	SUBI R30,-LOW(_dig)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6:
	LDS  R30,_ind
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7:
	LDI  R26,LOW(_delay_ee)
	LDI  R27,HIGH(_delay_ee)
	RCALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8:
	ST   -Y,R30
	RJMP _int2ind

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x9:
	LDS  R26,_ind
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA:
	LDS  R26,_but_cnt0
	CPI  R26,LOW(0xC8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB:
	LDS  R26,_but_cnt1
	CPI  R26,LOW(0xC8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xC:
	LDS  R26,_but_cnt01
	CPI  R26,LOW(0xC8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD:
	LDI  R26,LOW(_delay_ee)
	LDI  R27,HIGH(_delay_ee)
	RCALL __EEPROMRDW
	STS  _delay_cnt,R30
	STS  _delay_cnt+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE:
	LDI  R30,LOW(0)
	STS  _ind,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF:
	LDI  R30,LOW(5)
	CP   R30,R10
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIC EECR,EEWE
	RJMP __EEPROMWRB
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

