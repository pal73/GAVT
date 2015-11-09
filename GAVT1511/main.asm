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

	.INCLUDE "main.vec"
	.INCLUDE "main.inc"

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
;       1 /*****************************************************
;       2 This program was produced by the
;       3 CodeWizardAVR V1.24.1d Standard
;       4 Automatic Program Generator
;       5 © Copyright 1998-2004 Pavel Haiduc, HP InfoTech s.r.l.
;       6 http://www.hpinfotech.ro
;       7 e-mail:office@hpinfotech.ro
;       8 
;       9 Project : 
;      10 Version : 
;      11 Date    : 07.11.2015
;      12 Author  : PAL                             
;      13 Company : HOME                            
;      14 Comments: 
;      15 
;      16 
;      17 Chip type           : ATtiny13
;      18 Clock frequency     : 0,128000 MHz
;      19 Memory model        : Tiny
;      20 External SRAM size  : 0
;      21 Data Stack size     : 16
;      22 *****************************************************/
;      23 
;      24 #include <tiny13.h>
;      25 
;      26 short t0_cnt0;
;      27 bit b1Hz;
;      28 bit b10Hz;
;      29 short time_cnt;
;      30 short time_stamp;
;      31 short rele_cnt;
;      32 short in_cnt;
;      33 char bIN;
;      34 char bIN_OLD;
_bIN_OLD:
	.BYTE 0x1
;      35 
;      36 // Timer 0 overflow interrupt service routine
;      37 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;      38 {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;      39 TCNT0=-50;
	LDI  R30,LOW(206)
	OUT  0x32,R30
;      40 t0_cnt0++;
	__GETW1R 4,5
	ADIW R30,1
	__PUTW1R 4,5
;      41 
;      42 b10Hz=1;
	SET
	BLD  R2,1
;      43 
;      44 if(t0_cnt0>10)
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0x3
;      45 	{
;      46 	t0_cnt0=0;
	CLR  R4
	CLR  R5
;      47 	b1Hz=1;
	SET
	BLD  R2,0
;      48 	}
;      49 
;      50 }
_0x3:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;      51 
;      52 #define ADC_VREF_TYPE 0x00
;      53 // Read the AD conversion result
;      54 unsigned int read_adc(unsigned char adc_input)
;      55 {
_read_adc:
;      56 ADMUX=adc_input|ADC_VREF_TYPE;
	LD   R30,Y
	OUT  0x7,R30
;      57 // Start the AD conversion
;      58 ADCSRA|=0x40;
	SBI  0x6,6
;      59 // Wait for the AD conversion to complete
;      60 while ((ADCSRA & 0x10)==0);
_0x4:
	SBIS 0x6,4
	RJMP _0x4
;      61 ADCSRA|=0x10;
	SBI  0x6,4
;      62 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
;      63 }
;      64 
;      65 // Declare your global variables here
;      66 
;      67 void main(void)
;      68 {
_main:
;      69 // Declare your local variables here
;      70 
;      71 // Crystal Oscillator division factor: 1
;      72 CLKPR=0x80;
	LDI  R30,LOW(128)
	RCALL SUBOPT_0x0
;      73 CLKPR=0x00;
	RCALL SUBOPT_0x0
;      74 
;      75 // Input/Output Ports initialization
;      76 // Port B initialization
;      77 // Func5=In Func4=In Func3=In Func2=In Func1=In Func0=Out 
;      78 // State5=T State4=T State3=T State2=T State1=T State0=0 
;      79 PORTB=0x00;
	OUT  0x18,R30
;      80 DDRB=0x01;
	LDI  R30,LOW(1)
	OUT  0x17,R30
;      81 
;      82 // Timer/Counter 0 initialization
;      83 // Clock source: System Clock
;      84 // Clock value: 0,500 kHz
;      85 // Mode: Normal top=FFh
;      86 // OC0A output: Disconnected
;      87 // OC0B output: Disconnected
;      88 TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;      89 TCCR0B=0x04;
	LDI  R30,LOW(4)
	OUT  0x33,R30
;      90 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
;      91 OCR0A=0x00;
	OUT  0x36,R30
;      92 OCR0B=0x00;
	OUT  0x29,R30
;      93 
;      94 // External Interrupt(s) initialization
;      95 // INT0: Off
;      96 // Interrupt on any change on pins PCINT0-5: Off
;      97 GIMSK=0x00;
	OUT  0x3B,R30
;      98 MCUCR=0x00;
	OUT  0x35,R30
;      99 
;     100 // Timer/Counter 0 Interrupt(s) initialization
;     101 TIMSK0=0x02;
	LDI  R30,LOW(2)
	OUT  0x39,R30
;     102 
;     103 // Analog Comparator initialization
;     104 // Analog Comparator: Off
;     105 // Analog Comparator Output: Off
;     106 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     107 ADCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
;     108 
;     109 // ADC initialization
;     110 // ADC Clock frequency: 32,000 kHz
;     111 // ADC Bandgap Voltage Reference: Off
;     112 // ADC Auto Trigger Source: Free Running
;     113 // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On,
;     114 // ADC4: On
;     115 DIDR0=0x00;
	OUT  0x14,R30
;     116 ADMUX=ADC_VREF_TYPE;
	OUT  0x7,R30
;     117 ADCSRA=0x82;
	LDI  R30,LOW(130)
	OUT  0x6,R30
;     118 ADCSRB&=0xF8;
	IN   R30,0x3
	ANDI R30,LOW(0xF8)
	OUT  0x3,R30
;     119 
;     120 // Global enable interrupts
;     121 #asm("sei")
	sei
;     122 
;     123 while (1)
_0x7:
;     124       {
;     125       if(b10Hz)
	SBRS R2,1
	RJMP _0xA
;     126       	{
;     127       	b10Hz=0;
	CLT
	BLD  R2,1
;     128       	
;     129       	
;     130       if((bIN) && (!bIN_OLD))
	TST  R14
	BREQ _0xC
	LDS  R30,_bIN_OLD
	CPI  R30,0
	BREQ _0xD
_0xC:
	RJMP _0xB
_0xD:
;     131       	{
;     132       	if(rele_cnt==0)
	MOV  R0,R10
	OR   R0,R11
	BRNE _0xE
;     133       		{
;     134       		rele_cnt=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 10,11
;     135       		}
;     136       	}
_0xE:
;     137       bIN_OLD=bIN;      	
_0xB:
	STS  _bIN_OLD,R14
;     138       	
;     139       	
;     140       	
;     141       	time_stamp=((read_adc(3)-350)/15)+5; 
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	SUBI R30,LOW(350)
	SBCI R31,HIGH(350)
	MOV  R26,R30
	MOV  R27,R31
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	RCALL __DIVW21U
	ADIW R30,5
	__PUTW1R 8,9
;     142       //	time_stamp=10;
;     143       	/*time_cnt++;
;     144       	if(time_cnt>time_stamp)
;     145       		{
;     146       		time_cnt=0;
;     147       		PORTB.0=!PORTB.0;
;     148       		}*/
;     149       		
;     150       	if((rele_cnt)&&(rele_cnt<time_stamp))
	MOV  R0,R10
	OR   R0,R11
	BREQ _0x10
	__CPWRR 10,11,8,9
	BRLT _0x11
_0x10:
	RJMP _0xF
_0x11:
;     151       		{
;     152       		rele_cnt++;
	__GETW1R 10,11
	ADIW R30,1
	__PUTW1R 10,11
;     153       		if(rele_cnt>=time_stamp)rele_cnt=0;
	__CPWRR 10,11,8,9
	BRLT _0x12
	CLR  R10
	CLR  R11
;     154       		}	                                          
_0x12:
;     155       		
;     156       	if((rele_cnt>=5)&&(rele_cnt<=time_stamp)) PORTB.0=1;
_0xF:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R10,R30
	CPC  R11,R31
	BRLT _0x14
	__CPWRR 8,9,10,11
	BRGE _0x15
_0x14:
	RJMP _0x13
_0x15:
	SBI  0x18,0
;     157       	else 							  PORTB.0=0;
	RJMP _0x16
_0x13:
	CBI  0x18,0
_0x16:
;     158       	
;     159       //	if(!bIN_OLD&&bIN) 					PORTB.0=1;
;     160         //	else 							  PORTB.0=0;
;     161       		
;     162       	}
;     163       if(b1Hz)
_0xA:
	SBRS R2,0
	RJMP _0x17
;     164       	{
;     165       	b1Hz=0;
	CLT
	BLD  R2,0
;     166       	//
;     167 
;     168       	}
;     169       if(PINB.1)
_0x17:
	SBIS 0x16,1
	RJMP _0x18
;     170       	{ 
;     171       	if(in_cnt<200)in_cnt++;
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CP   R12,R30
	CPC  R13,R31
	BRGE _0x19
	__GETW1R 12,13
	ADIW R30,1
	__PUTW1R 12,13
;     172       	}
_0x19:
;     173       else
	RJMP _0x1A
_0x18:
;     174       	{
;     175       	if(in_cnt)in_cnt--;
	MOV  R0,R12
	OR   R0,R13
	BREQ _0x1B
	__GETW1R 12,13
	SBIW R30,1
	__PUTW1R 12,13
;     176       	} 
_0x1B:
_0x1A:
;     177       if(in_cnt>=199)bIN=1;
	LDI  R30,LOW(199)
	LDI  R31,HIGH(199)
	CP   R12,R30
	CPC  R13,R31
	BRLT _0x1C
	LDI  R30,LOW(1)
	MOV  R14,R30
;     178       if(in_cnt<=1)bIN=0;
_0x1C:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R12
	CPC  R31,R13
	BRLT _0x1D
	CLR  R14
;     179       
;     180 		 	
;     181       	
;     182       	       
;     183 /*      	if(in_cnt<200)
;     184       		{
;     185       		in_cnt++;
;     186       		if(in_cnt>=200)
;     187       			{
;     188 
;     189       			}
;     190       		}*/
;     191    /*   	}
;     192       else 
;     193       	{
;     194       	in_cnt=0;
;     195       	} */		
;     196       };
_0x1D:
	RJMP _0x7
;     197 }
_0x1E:
	RJMP _0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	OUT  0x26,R30
	LDI  R30,LOW(0)
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
	MOV  R30,R26
	MOV  R31,R27
	MOV  R26,R0
	MOV  R27,R1
	RET

