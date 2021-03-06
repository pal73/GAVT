;CodeVisionAVR C Compiler V1.24.1d Standard
;(C) Copyright 1998-2004 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.ro
;e-mail:office@hpinfotech.ro

;Chip type           : ATtiny13
;Clock frequency     : 4,800000 MHz
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

	.INCLUDE "gavt9_t13.vec"
	.INCLUDE "gavt9_t13.inc"

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
	.DB  0 ; FIRST EEPROM LOCATION NOT USED, SEE ATMEL ERRATA SHEETS

	.DSEG
	.ORG 0x70
;       1 #include <tiny13.h>
;       2 
;       3 char t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3,t0_cnt4,t0_cnt5,t0_cnt6;
;       4 //***********************************************
;       5 //������� ����������
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
;      18 
;      19 // Timer 0 overflow interrupt service routine
;      20 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;      21 {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;      22 TCCR0A=0x00;
	RCALL SUBOPT_0x0
;      23 TCCR0B=0x05;
;      24 TCNT0=-47;
;      25 
;      26 
;      27 b100Hz=1;
	SET
	BLD  R2,1
;      28 
;      29 if(++t0_cnt1>=10)
	INC  R5
	LDI  R30,LOW(10)
	CP   R5,R30
	BRLO _0x3
;      30 	{
;      31 	t0_cnt1=0;
	CLR  R5
;      32 	b10Hz=1;
	SET
	BLD  R2,2
;      33 	
;      34 	if(++t0_cnt3>=10)
	INC  R7
	CP   R7,R30
	BRLO _0x4
;      35 		{
;      36 		t0_cnt3=0;
	CLR  R7
;      37 		b1Hz=1;
	SET
	BLD  R2,5
;      38 		} 
;      39 	if(++t0_cnt4>=5)
_0x4:
	INC  R8
	LDI  R30,LOW(5)
	CP   R8,R30
	BRLO _0x5
;      40 		{
;      41 		t0_cnt4=0;
	CLR  R8
;      42 		b2Hz=1;
	SET
	BLD  R2,4
;      43 		}	
;      44 	} 
_0x5:
;      45 if(++t0_cnt2>=20)
_0x3:
	INC  R6
	LDI  R30,LOW(20)
	CP   R6,R30
	BRLO _0x6
;      46 	{
;      47 	t0_cnt2=0;
	CLR  R6
;      48 	b5Hz=1;
	SET
	BLD  R2,3
;      49 	
;      50 	
;      51 	} 
;      52 
;      53 }
_0x6:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;      54 
;      55 // Declare your global variables here
;      56 
;      57 void main(void)
;      58 {
_main:
;      59 // Crystal Oscillator division factor: 1
;      60 CLKPR=0x80;
	LDI  R30,LOW(128)
	RCALL SUBOPT_0x1
;      61 CLKPR=0x00;
	RCALL SUBOPT_0x1
;      62 
;      63 // Input/Output Ports initialization
;      64 // Port B initialization
;      65 // Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
;      66 // State5=T State4=T State3=T State2=T State1=T State0=T
;      67 PORTB=0x00;
	OUT  0x18,R30
;      68 DDRB=0xfd;
	RCALL SUBOPT_0x2
;      69 
;      70 // Timer/Counter 0 initialization
;      71 // Clock source: System Clock
;      72 // Clock value: 4,688 kHz
;      73 // Mode: Normal top=FFh
;      74 // OC0A output: Disconnected
;      75 // OC0B output: Disconnected
;      76 TCCR0A=0x00;
	RCALL SUBOPT_0x0
;      77 TCCR0B=0x05;
;      78 TCNT0=-47;
;      79 OCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x36,R30
;      80 OCR0B=0x00;
	OUT  0x29,R30
;      81 
;      82 // External Interrupt(s) initialization
;      83 // INT0: Off
;      84 // Interrupt on any change on pins PCINT0-5: Off
;      85 GIMSK=0x00;
	OUT  0x3B,R30
;      86 MCUCR=0x00;
	OUT  0x35,R30
;      87 
;      88 // Timer/Counter 0 Interrupt(s) initialization
;      89 TIMSK0=0x02;
	LDI  R30,LOW(2)
	OUT  0x39,R30
;      90 
;      91 // Analog Comparator initialization
;      92 // Analog Comparator: Off
;      93 // Analog Comparator Output: Off
;      94 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;      95 ADCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
;      96 
;      97 // Global enable interrupts
;      98 
;      99 main_cnt=30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	__PUTW1R 13,14
;     100 // Global enable interrupts
;     101 #asm("sei")
	sei
;     102 
;     103 while (1)
_0x7:
;     104 	{
;     105 	DDRB=0xfd;
	RCALL SUBOPT_0x2
;     106 	if(b100Hz)
	SBRS R2,1
	RJMP _0xA
;     107 		{
;     108 		b100Hz=0;
	CLT
	BLD  R2,1
;     109 
;     110 		if(!PINB.1)
	SBIC 0x16,1
	RJMP _0xB
;     111 			{
;     112 			if(in_cnt<5)
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R11,R30
	CPC  R12,R31
	BRGE _0xC
;     113 				{
;     114 				in_cnt++;
	__GETW1R 11,12
	ADIW R30,1
	__PUTW1R 11,12
;     115 				if(in_cnt==5)
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R11
	CPC  R31,R12
	BRNE _0xD
;     116 					{
;     117 					main_cnt=0;
	CLR  R13
	CLR  R14
;     118 					}          
;     119 				}
_0xD:
;     120 			}
_0xC:
;     121 		else
	RJMP _0xE
_0xB:
;     122 			{
;     123 			in_cnt=0;
	CLR  R11
	CLR  R12
;     124 			}			
_0xE:
;     125 			
;     126 			
;     127 		DDRB.1=0;
	CBI  0x17,1
;     128 		PORTB.1=1; 
	SBI  0x18,1
;     129 
;     130 		}             
;     131 	if(b10Hz)
_0xA:
	SBRS R2,2
	RJMP _0xF
;     132 		{
;     133 		b10Hz=0; 
	CLT
	BLD  R2,2
;     134 		DDRB|=0b00000101;
	IN   R30,0x17
	ORI  R30,LOW(0x5)
	OUT  0x17,R30
;     135 		
;     136           if(main_cnt<30)main_cnt++;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CP   R13,R30
	CPC  R14,R31
	BRGE _0x10
	__GETW1R 13,14
	ADIW R30,1
	__PUTW1R 13,14
;     137           if((main_cnt>0)&&(main_cnt<=13))
_0x10:
	CLR  R0
	CP   R0,R13
	CPC  R0,R14
	BRGE _0x12
	RCALL SUBOPT_0x3
	BRGE _0x13
_0x12:
	RJMP _0x11
_0x13:
;     138           	{
;     139           	PORTB.2=1;
	SBI  0x18,2
;     140           	}
;     141           else PORTB.2=0;
	RJMP _0x14
_0x11:
	CBI  0x18,2
_0x14:
;     142           
;     143           if((main_cnt>5)&&(main_cnt<=13))
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R13
	CPC  R31,R14
	BRGE _0x16
	RCALL SUBOPT_0x3
	BRGE _0x17
_0x16:
	RJMP _0x15
_0x17:
;     144           	{
;     145           	PORTB.0=1;
	SBI  0x18,0
;     146           	}
;     147           else PORTB.0=0;          	
	RJMP _0x18
_0x15:
	CBI  0x18,0
_0x18:
;     148           
;     149 		}
;     150 	if(b5Hz)
_0xF:
;     151 		{
;     152 
;     153 		} 
;     154     	if(b1Hz)
	SBRS R2,5
	RJMP _0x1A
;     155 		{
;     156 		b1Hz=0;
	CLT
	BLD  R2,5
;     157           //PORTB^=0b00000101;
;     158 		}
;     159      #asm("wdr")	
_0x1A:
	wdr
;     160 	}
	RJMP _0x7
;     161 
;     162 }
_0x1B:
	RJMP _0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	LDI  R30,LOW(0)
	OUT  0x2F,R30
	LDI  R30,LOW(5)
	OUT  0x33,R30
	LDI  R30,LOW(209)
	OUT  0x32,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	OUT  0x26,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2:
	LDI  R30,LOW(253)
	OUT  0x17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3:
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CP   R30,R13
	CPC  R31,R14
	RET

