;CodeVisionAVR C Compiler V1.24.1d Standard
;(C) Copyright 1998-2004 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.ro
;e-mail:office@hpinfotech.ro

;Chip type           : ATmega48
;Clock frequency     : 1,000000 MHz
;Memory model        : Small
;Optimize for        : Size
;(s)printf features  : int, width
;(s)scanf features   : long, width
;External SRAM size  : 0
;Data Stack size     : 128 byte(s)
;Heap size           : 0 byte(s)
;Promote char to int : No
;char is unsigned    : Yes
;8 bit enums         : Yes
;Enhanced core instructions    : On
;Automatic register allocation : On

	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E
	.EQU GPIOR1=0x2A
	.EQU GPIOR2=0x2B

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

	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C

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
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
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

	.INCLUDE "mns48.vec"
	.INCLUDE "mns48.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	IN   R26,MCUSR
	OUT  MCUSR,R30
	STS  WDTCSR,R31
	STS  WDTCSR,R30
	OUT  MCUSR,R26

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x200)
	LDI  R25,HIGH(0x200)
	LDI  R26,LOW(0x100)
	LDI  R27,HIGH(0x100)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
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
	LDI  R30,LOW(0x2FF)
	OUT  SPL,R30
	LDI  R30,HIGH(0x2FF)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x180)
	LDI  R29,HIGH(0x180)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x180
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
;      11 Date    : 22.09.2005
;      12 Author  : PAL                             
;      13 Company : HOME                            
;      14 Comments: 
;      15 
;      16 
;      17 Chip type           : ATmega48
;      18 Clock frequency     : 1,000000 MHz
;      19 Memory model        : Small
;      20 External SRAM size  : 0
;      21 Data Stack size     : 128 
;      22 
;      23 
;      24 *****************************************************/  
;      25 #define SIBHOLOD
;      26 //#define TRIADA
;      27 
;      28 #define RELEASE
;      29 #define LED_NET PORTD.0
;      30 #define LED_PER PORTD.1
;      31 #define LED_DEL PORTD.2
;      32 #define KL2 PORTD.3
;      33 #define KL1 PORTD.4
;      34 
;      35 #include <mega48.h>
;      36 #define MIN_U	100 
;      37 
;      38 bit bT0;
;      39 bit b100Hz;
;      40 bit b10Hz;
;      41 bit b5Hz;
;      42 bit b2Hz;
;      43 bit b1Hz;
;      44 bit bFl;
;      45 bit butR;
;      46 char butS;
;      47 char bNN,bNN_;
;      48 char bPER,bPER_,bCHER_;
;      49 char t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3,t0_cnt4; 
_t0_cnt3:
	.BYTE 0x1
_t0_cnt4:
	.BYTE 0x1
;      50 eeprom char delta; 

	.ESEG
_delta:
	.DB  0x0
;      51 char cnt_butS,cnt_butR; 

	.DSEG
_cnt_butS:
	.BYTE 0x1
_cnt_butR:
	.BYTE 0x1
;      52 
;      53 enum char {iMn,iSet}ind; 
_ind:
	.BYTE 0x1
;      54 unsigned int del_cnt;
_del_cnt:
	.BYTE 0x2
;      55 char pcnt[3];
_pcnt:
	.BYTE 0x3
;      56 unsigned int adc_bankU[3][25],ADCU,adc_bankU_[3];
_adc_bankU:
	.BYTE 0x96
_ADCU:
	.BYTE 0x2
_adc_bankU_:
	.BYTE 0x6
;      57 char per_cnt;
_per_cnt:
	.BYTE 0x1
;      58 char flags;
_flags:
	.BYTE 0x1
;      59 char nn_cnt;
_nn_cnt:
	.BYTE 0x1
;      60 flash char DF[]={0,10,15,20,25,30,35};

	.CSEG
;      61 char deltas;

	.DSEG
_deltas:
	.BYTE 0x1
;      62 unsigned int adc_data;
_adc_data:
	.BYTE 0x2
;      63 char bA_,bB_,bC_;
_bA_:
	.BYTE 0x1
_bB_:
	.BYTE 0x1
_bC_:
	.BYTE 0x1
;      64 char bA,bB,bC; 
_bA:
	.BYTE 0x1
_bB:
	.BYTE 0x1
_bC:
	.BYTE 0x1
;      65 char cnt_x;
_cnt_x:
	.BYTE 0x1
;      66 unsigned int bankA,bankB,bankC;
_bankA:
	.BYTE 0x2
_bankB:
	.BYTE 0x2
_bankC:
	.BYTE 0x2
;      67 char adc_cntA,adc_cntB,adc_cntC;
_adc_cntA:
	.BYTE 0x1
_adc_cntB:
	.BYTE 0x1
_adc_cntC:
	.BYTE 0x1
;      68 short proc_cnt_l=-20,proc_cnt_h=0;
_proc_cnt_l:
	.BYTE 0x2
_proc_cnt_h:
	.BYTE 0x2
;      69 char kl1_stat,kl2_stat;
_kl1_stat:
	.BYTE 0x1
_kl2_stat:
	.BYTE 0x1
;      70 //-----------------------------------------------
;      71 void t0_init(void)
;      72 {

	.CSEG
_t0_init:
;      73 // Timer/Counter 0 initialization
;      74 // Clock source: System Clock
;      75 // Clock value: 3,906 kHz
;      76 // Mode: Normal top=FFh
;      77 // OC0A output: Disconnected
;      78 // OC0B output: Disconnected
;      79 TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
;      80 TCCR0B=0x03;
	LDI  R30,LOW(3)
	OUT  0x25,R30
;      81 TCNT0=-78;
	LDI  R30,LOW(178)
	OUT  0x26,R30
;      82 OCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
;      83 OCR0B=0x00;
	OUT  0x28,R30
;      84 }
	RET
;      85 
;      86 //-----------------------------------------------
;      87 void ind_hndl(void)
;      88 {
_ind_hndl:
;      89 
;      90 DDRD|=0x07;   
	IN   R30,0xA
	ORI  R30,LOW(0x7)
	OUT  0xA,R30
;      91 
;      92 
;      93 if(kl1_stat)LED_DEL=0;
	LDS  R30,_kl1_stat
	CPI  R30,0
	BREQ _0x4
	CBI  0xB,2
;      94 else LED_DEL=1;
	RJMP _0x5
_0x4:
	SBI  0xB,2
_0x5:
;      95  
;      96 if(kl2_stat)LED_PER=0;
	LDS  R30,_kl2_stat
	CPI  R30,0
	BREQ _0x6
	CBI  0xB,1
;      97 else LED_PER=1; 
	RJMP _0x7
_0x6:
	SBI  0xB,1
_0x7:
;      98 
;      99 if((proc_cnt_h<=9) || (bFl))LED_NET=0;
	RCALL SUBOPT_0x0
	BRGE _0x9
	SBIS 0x1E,6
	RJMP _0x8
_0x9:
	CBI  0xB,0
;     100 else LED_NET=1;
	RJMP _0xB
_0x8:
	SBI  0xB,0
_0xB:
;     101 
;     102 }
	RET
;     103 
;     104 //-----------------------------------------------
;     105 void out_out(void)
;     106 {
_out_out:
;     107 
;     108 DDRD|=0x18;   
	IN   R30,0xA
	ORI  R30,LOW(0x18)
	OUT  0xA,R30
;     109   
;     110 
;     111 if(kl1_stat==1)
	LDS  R26,_kl1_stat
	CPI  R26,LOW(0x1)
	BRNE _0xC
;     112 	{
;     113 	KL1=1;
	SBI  0xB,4
;     114 	}
;     115 else 
	RJMP _0xD
_0xC:
;     116 	{
;     117 	KL1=0;
	CBI  0xB,4
;     118 	}	
_0xD:
;     119 	
;     120 if(kl2_stat==1)
	LDS  R26,_kl2_stat
	CPI  R26,LOW(0x1)
	BRNE _0xE
;     121 	{
;     122 	KL2=1;
	SBI  0xB,3
;     123 	}
;     124 else 
	RJMP _0xF
_0xE:
;     125 	{
;     126 	KL2=0;
	CBI  0xB,3
;     127 	}		
_0xF:
;     128 }
	RET
;     129 
;     130 //-----------------------------------------------
;     131 void proc_hndl(void)
;     132 {
_proc_hndl:
;     133 proc_cnt_l++;
	LDS  R30,_proc_cnt_l
	LDS  R31,_proc_cnt_l+1
	ADIW R30,1
	STS  _proc_cnt_l,R30
	STS  _proc_cnt_l+1,R31
;     134 if(proc_cnt_l>=1800)
	LDS  R26,_proc_cnt_l
	LDS  R27,_proc_cnt_l+1
	CPI  R26,LOW(0x708)
	LDI  R30,HIGH(0x708)
	CPC  R27,R30
	BRLT _0x10
;     135 	{
;     136 	proc_cnt_l=0;
	LDI  R30,0
	STS  _proc_cnt_l,R30
	STS  _proc_cnt_l+1,R30
;     137 	proc_cnt_h++;
	LDS  R30,_proc_cnt_h
	LDS  R31,_proc_cnt_h+1
	ADIW R30,1
	STS  _proc_cnt_h,R30
	STS  _proc_cnt_h+1,R31
;     138 	if(proc_cnt_h>20)proc_cnt_h=0;
	LDS  R26,_proc_cnt_h
	LDS  R27,_proc_cnt_h+1
	RCALL SUBOPT_0x1
	BRGE _0x11
	LDI  R30,0
	STS  _proc_cnt_h,R30
	STS  _proc_cnt_h+1,R30
;     139 	}
_0x11:
;     140 	
;     141 if ((((proc_cnt_l>=-20)&&(proc_cnt_l<=20))	|| ((proc_cnt_l>=880)&&(proc_cnt_l<=920)) || ((proc_cnt_l>=1780)&&(proc_cnt_l<=1800))) && (proc_cnt_h<=9)) kl1_stat=0;
_0x10:
	LDS  R26,_proc_cnt_l
	LDS  R27,_proc_cnt_l+1
	CPI  R26,LOW(0xFFEC)
	LDI  R30,HIGH(0xFFEC)
	CPC  R27,R30
	BRLT _0x13
	RCALL SUBOPT_0x1
	BRGE _0x15
_0x13:
	LDS  R26,_proc_cnt_l
	LDS  R27,_proc_cnt_l+1
	CPI  R26,LOW(0x370)
	LDI  R30,HIGH(0x370)
	CPC  R27,R30
	BRLT _0x16
	LDI  R30,LOW(920)
	LDI  R31,HIGH(920)
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x15
_0x16:
	LDS  R26,_proc_cnt_l
	LDS  R27,_proc_cnt_l+1
	CPI  R26,LOW(0x6F4)
	LDI  R30,HIGH(0x6F4)
	CPC  R27,R30
	BRLT _0x18
	LDI  R30,LOW(1800)
	LDI  R31,HIGH(1800)
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x15
_0x18:
	RJMP _0x1B
_0x15:
	RCALL SUBOPT_0x0
	BRGE _0x1C
_0x1B:
	RJMP _0x12
_0x1C:
	LDI  R30,LOW(0)
	RJMP _0x65
;     142 else kl1_stat=1;
_0x12:
	LDI  R30,LOW(1)
_0x65:
	STS  _kl1_stat,R30
;     143 
;     144 if ( (proc_cnt_l>=0)&&(proc_cnt_l<=900) && (proc_cnt_h<=9)) kl2_stat=1;
	LDS  R26,_proc_cnt_l
	LDS  R27,_proc_cnt_l+1
	SBIW R26,0
	BRLT _0x1F
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	CP   R30,R26
	CPC  R31,R27
	BRLT _0x1F
	RCALL SUBOPT_0x0
	BRGE _0x20
_0x1F:
	RJMP _0x1E
_0x20:
	LDI  R30,LOW(1)
	RJMP _0x66
;     145 else kl2_stat=0;
_0x1E:
	LDI  R30,LOW(0)
_0x66:
	STS  _kl2_stat,R30
;     146 }
	RET
;     147 
;     148 
;     149 
;     150 
;     151 
;     152 //-----------------------------------------------
;     153 void but_drv(void)
;     154 {
_but_drv:
;     155 
;     156 #define PINR PINC.4
;     157 #define PORTR PORTC.4
;     158 #define DDR DDRC.4
;     159 
;     160 #define PINS PINC.5
;     161 #define PORTS PORTC.5
;     162 #define DDS DDRC.5
;     163 
;     164 
;     165 
;     166 DDR=0;
	CBI  0x7,4
;     167 DDS=0;
	CBI  0x7,5
;     168 PORTR=1;
	SBI  0x8,4
;     169 PORTS=1; 
	SBI  0x8,5
;     170       
;     171 if(!PINR)
	SBIC 0x6,4
	RJMP _0x22
;     172 	{
;     173 	if(cnt_butR<10)
	LDS  R26,_cnt_butR
	CPI  R26,LOW(0xA)
	BRSH _0x23
;     174 		{
;     175 		if(++cnt_butR>=10)
	SUBI R26,-LOW(1)
	STS  _cnt_butR,R26
	CPI  R26,LOW(0xA)
	BRLO _0x24
;     176 			{
;     177 			butR=1;
	SBI  0x1E,7
;     178 			}
;     179 		}
_0x24:
;     180 	}                 
_0x23:
;     181 else 
	RJMP _0x25
_0x22:
;     182 	{
;     183 	cnt_butR=0;
	LDI  R30,LOW(0)
	STS  _cnt_butR,R30
;     184 	butR=0;
	CBI  0x1E,7
;     185 	}	 
_0x25:
;     186 	
;     187 if(!PINS)
	SBIC 0x6,5
	RJMP _0x26
;     188 	{
;     189 	if(cnt_butS<200)
	LDS  R26,_cnt_butS
	CPI  R26,LOW(0xC8)
	BRSH _0x27
;     190 		{
;     191 		if(++cnt_butS>=200)
	SUBI R26,-LOW(1)
	STS  _cnt_butS,R26
	CPI  R26,LOW(0xC8)
	BRLO _0x28
;     192 			{
;     193 			butS=1;
	LDI  R30,LOW(1)
	MOV  R6,R30
;     194 			}
;     195 		}
_0x28:
;     196 	}                 
_0x27:
;     197 else 
	RJMP _0x29
_0x26:
;     198 	{
;     199 	cnt_butS=0;
	LDI  R30,LOW(0)
	STS  _cnt_butS,R30
;     200 	butS=0;
	CLR  R6
;     201 	}		
_0x29:
;     202 	           
;     203 }
	RET
;     204 
;     205 //-----------------------------------------------
;     206 void but_an(void)
;     207 {
_but_an:
;     208 if(ind==iMn)
	LDS  R30,_ind
	CPI  R30,0
	BRNE _0x2A
;     209 	{
;     210 	if(butS) ind=iSet;
	TST  R6
	BREQ _0x2B
	LDI  R30,LOW(1)
	STS  _ind,R30
;     211 	if(butR)
_0x2B:
	SBIS 0x1E,7
	RJMP _0x2C
;     212 		{
;     213 		if(del_cnt) del_cnt=0;
	LDS  R30,_del_cnt
	LDS  R31,_del_cnt+1
	SBIW R30,0
	BREQ _0x2D
	LDI  R30,0
	STS  _del_cnt,R30
	STS  _del_cnt+1,R30
;     214 		}
_0x2D:
;     215 	}
_0x2C:
;     216 else if(ind==iSet)
	RJMP _0x2E
_0x2A:
	LDS  R26,_ind
	CPI  R26,LOW(0x1)
	BRNE _0x2F
;     217 	{            
;     218 	if(butR)
	SBIS 0x1E,7
	RJMP _0x30
;     219 		{
;     220 		if(delta<6) delta++;
	LDI  R26,LOW(_delta)
	LDI  R27,HIGH(_delta)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x6)
	BRSH _0x31
	LDI  R26,LOW(_delta)
	LDI  R27,HIGH(_delta)
	RCALL __EEPROMRDB
	SUBI R30,-LOW(1)
	RCALL __EEPROMWRB
	SUBI R30,LOW(1)
;     221 		else delta=1;
	RJMP _0x32
_0x31:
	LDI  R30,LOW(1)
	LDI  R26,LOW(_delta)
	LDI  R27,HIGH(_delta)
	RCALL __EEPROMWRB
_0x32:
;     222 		}
;     223 	if(butS) ind=iMn;	
_0x30:
	TST  R6
	BREQ _0x33
	LDI  R30,LOW(0)
	STS  _ind,R30
;     224 	}
_0x33:
;     225 but_an_end:
_0x2F:
_0x2E:
;     226 butR=0;
	CBI  0x1E,7
;     227 butS=0;
	CLR  R6
;     228 }
	RET
;     229 
;     230 
;     231 
;     232 
;     233 
;     234 
;     235 //***********************************************
;     236 //***********************************************
;     237 //***********************************************
;     238 //***********************************************
;     239 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;     240 {
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
;     241 t0_init();
	RCALL _t0_init
;     242 bT0=!bT0;
	CLT
	SBIS 0x1E,0
	SET
	IN   R30,0x1E
	BLD  R30,0
	OUT  0x1E,R30
;     243 
;     244 if(!bT0) goto lbl_000;
	SBIS 0x1E,0
	RJMP _0x36
;     245 b100Hz=1;
	SBI  0x1E,1
;     246 if(++t0_cnt0>=10)
	INC  R12
	LDI  R30,LOW(10)
	CP   R12,R30
	BRLO _0x37
;     247 	{
;     248 	t0_cnt0=0;
	CLR  R12
;     249 	b10Hz=1;
	SBI  0x1E,2
;     250 	bFl=!bFl;
	CLT
	SBIS 0x1E,6
	SET
	IN   R30,0x1E
	BLD  R30,6
	OUT  0x1E,R30
;     251 
;     252 	} 
;     253 if(++t0_cnt1>=20)
_0x37:
	INC  R13
	LDI  R30,LOW(20)
	CP   R13,R30
	BRLO _0x38
;     254 	{
;     255 	t0_cnt1=0;
	CLR  R13
;     256 	b5Hz=1;
	SBI  0x1E,3
;     257 
;     258 	}
;     259 if(++t0_cnt2>=50)
_0x38:
	INC  R14
	LDI  R30,LOW(50)
	CP   R14,R30
	BRLO _0x39
;     260 	{
;     261 	t0_cnt2=0;
	CLR  R14
;     262 	b2Hz=1;
	SBI  0x1E,4
;     263 	}	
;     264 		
;     265 if(++t0_cnt3>=100)
_0x39:
	LDS  R26,_t0_cnt3
	SUBI R26,-LOW(1)
	STS  _t0_cnt3,R26
	CPI  R26,LOW(0x64)
	BRLO _0x3A
;     266 	{
;     267 	t0_cnt3=0;
	LDI  R30,LOW(0)
	STS  _t0_cnt3,R30
;     268 	b1Hz=1;
	SBI  0x1E,5
;     269 	}		
;     270 lbl_000:
_0x3A:
_0x36:
;     271 }
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
;     272 
;     273 //-----------------------------------------------
;     274 //#pragma savereg-
;     275 interrupt [ADC_INT] void adc_isr(void)
;     276 {
_adc_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     277 
;     278 register static unsigned char input_index=0;

	.DSEG
_input_index_S7:
	.BYTE 0x1

	.CSEG
;     279 // Read the AD conversion result
;     280 adc_data=ADCW;
	LDS  R30,120
	LDS  R31,120+1
	STS  _adc_data,R30
	STS  _adc_data+1,R31
;     281 
;     282 if (++input_index > 2)
	LDS  R26,_input_index_S7
	SUBI R26,-LOW(1)
	STS  _input_index_S7,R26
	LDI  R30,LOW(2)
	CP   R30,R26
	BRSH _0x3B
;     283    input_index=0;
	LDI  R30,LOW(0)
	STS  _input_index_S7,R30
;     284 #ifdef DEBUG
;     285 ADMUX=(0b01000011)+input_index;
;     286 #endif
;     287 #ifdef RELEASE
;     288 ADMUX=0b01000000+input_index;
_0x3B:
	LDS  R30,_input_index_S7
	SUBI R30,-LOW(64)
	STS  0x7C,R30
;     289 #endif
;     290 
;     291 // Start the AD conversion
;     292 ADCSRA|=0x40;
	LDS  R30,122
	ORI  R30,0x40
	STS  122,R30
;     293 
;     294 if(input_index==1)
	LDS  R26,_input_index_S7
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x3C
;     295 	{
;     296  	if((adc_data>100)&&!bA_)
	RCALL SUBOPT_0x2
	BRSH _0x3E
	RCALL SUBOPT_0x3
	BREQ _0x3F
_0x3E:
	RJMP _0x3D
_0x3F:
;     297     		{
;     298     		bA_=1;
	LDI  R30,LOW(1)
	STS  _bA_,R30
;     299     		cnt_x++;
	LDS  R30,_cnt_x
	SUBI R30,-LOW(1)
	STS  _cnt_x,R30
;     300     		}
;     301     	if((adc_data<100)&&bA_)
_0x3D:
	RCALL SUBOPT_0x4
	BRSH _0x41
	RCALL SUBOPT_0x3
	BRNE _0x42
_0x41:
	RJMP _0x40
_0x42:
;     302     		{
;     303     		bA_=0;
	LDI  R30,LOW(0)
	STS  _bA_,R30
;     304     		}			
;     305 //	adc_data
;     306 	if(adc_data>10U)
_0x40:
	RCALL SUBOPT_0x5
	BRSH _0x43
;     307 		{
;     308 		bankA+=adc_data;
	LDS  R30,_adc_data
	LDS  R31,_adc_data+1
	LDS  R26,_bankA
	LDS  R27,_bankA+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _bankA,R30
	STS  _bankA+1,R31
;     309 		bA=1;
	LDI  R30,LOW(1)
	STS  _bA,R30
;     310 		pcnt[0]=10;
	LDI  R30,LOW(10)
	STS  _pcnt,R30
;     311 		}
;     312 	else if((adc_data<=10U)&&bA)
	RJMP _0x44
_0x43:
	RCALL SUBOPT_0x5
	BRLO _0x46
	LDS  R30,_bA
	CPI  R30,0
	BRNE _0x47
_0x46:
	RJMP _0x45
_0x47:
;     313 		{
;     314 		bA=0;
	LDI  R30,LOW(0)
	STS  _bA,R30
;     315 		
;     316 		adc_bankU[0,adc_cntA]=bankA/10;
	LDS  R30,_adc_cntA
	RCALL SUBOPT_0x6
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDS  R26,_bankA
	LDS  R27,_bankA+1
	RCALL SUBOPT_0x7
	POP  R26
	POP  R27
	RCALL __PUTWP1
;     317 		bankA=0;
	LDI  R30,0
	STS  _bankA,R30
	STS  _bankA+1,R30
;     318 		if(++adc_cntA>=25) 
	LDS  R26,_adc_cntA
	SUBI R26,-LOW(1)
	STS  _adc_cntA,R26
	CPI  R26,LOW(0x19)
	BRLO _0x48
;     319 			{
;     320 			char i;
;     321 			adc_cntA=0;
	RCALL SUBOPT_0x8
;	i -> Y+0
	STS  _adc_cntA,R30
;     322 			adc_bankU_[0]=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _adc_bankU_,R30
	STS  _adc_bankU_+1,R31
;     323 			for(i=0;i<25;i++)
	RCALL SUBOPT_0x9
_0x4A:
	RCALL SUBOPT_0xA
	BRSH _0x4B
;     324 				{
;     325 				adc_bankU_[0]+=adc_bankU[0,i];
	LDI  R26,LOW(_adc_bankU_)
	LDI  R27,HIGH(_adc_bankU_)
	PUSH R27
	PUSH R26
	RCALL __GETW1P
	PUSH R31
	PUSH R30
	LD   R30,Y
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0xB
	POP  R26
	POP  R27
	ADD  R30,R26
	ADC  R31,R27
	POP  R26
	POP  R27
	RCALL __PUTWP1
;     326 				}
	RCALL SUBOPT_0xC
	RJMP _0x4A
_0x4B:
;     327 			adc_bankU_[0]/=25;	
	LDI  R26,LOW(_adc_bankU_)
	LDI  R27,HIGH(_adc_bankU_)
	PUSH R27
	PUSH R26
	RCALL SUBOPT_0xD
	POP  R26
	POP  R27
	RCALL SUBOPT_0xE
;     328 			}	
;     329 		}
_0x48:
;     330 	//adc_bankU_[0]		          
;     331 	}  
_0x45:
_0x44:
;     332 
;     333 		
;     334 if(input_index==0)
_0x3C:
	LDS  R30,_input_index_S7
	CPI  R30,0
	BREQ PC+2
	RJMP _0x4C
;     335 	{
;     336 	if((adc_data>100)&&!bC_)
	RCALL SUBOPT_0x2
	BRSH _0x4E
	RCALL SUBOPT_0xF
	BREQ _0x4F
_0x4E:
	RJMP _0x4D
_0x4F:
;     337     			{
;     338     			bC_=1;
	LDI  R30,LOW(1)
	STS  _bC_,R30
;     339     			cnt_x=0;
	LDI  R30,LOW(0)
	STS  _cnt_x,R30
;     340     			}
;     341     		if((adc_data<100)&&bC_)
_0x4D:
	RCALL SUBOPT_0x4
	BRSH _0x51
	RCALL SUBOPT_0xF
	BRNE _0x52
_0x51:
	RJMP _0x50
_0x52:
;     342     			{
;     343     			bC_=0;
	LDI  R30,LOW(0)
	STS  _bC_,R30
;     344     			}	
;     345 	
;     346 	if(adc_data>30)
_0x50:
	RCALL SUBOPT_0x10
	BRSH _0x53
;     347 		{
;     348 		bankC+=adc_data;
	LDS  R30,_adc_data
	LDS  R31,_adc_data+1
	LDS  R26,_bankC
	LDS  R27,_bankC+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _bankC,R30
	STS  _bankC+1,R31
;     349 		pcnt[2]=10;
	LDI  R30,LOW(10)
	__PUTB1MN _pcnt,2
;     350 		bC=1;
	LDI  R30,LOW(1)
	STS  _bC,R30
;     351 		}
;     352 	else if((adc_data<=30)&&bC)
	RJMP _0x54
_0x53:
	RCALL SUBOPT_0x10
	BRLO _0x56
	LDS  R30,_bC
	CPI  R30,0
	BRNE _0x57
_0x56:
	RJMP _0x55
_0x57:
;     353 		{
;     354 		bC=0;
	LDI  R30,LOW(0)
	STS  _bC,R30
;     355 		adc_bankU[2,adc_cntC]=bankC/10;
	__POINTW2MN _adc_bankU,100
	LDS  R30,_adc_cntC
	RCALL SUBOPT_0x11
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDS  R26,_bankC
	LDS  R27,_bankC+1
	RCALL SUBOPT_0x7
	POP  R26
	POP  R27
	RCALL __PUTWP1
;     356 		bankC=0;
	LDI  R30,0
	STS  _bankC,R30
	STS  _bankC+1,R30
;     357 		if(++adc_cntC>=25) 
	LDS  R26,_adc_cntC
	SUBI R26,-LOW(1)
	STS  _adc_cntC,R26
	CPI  R26,LOW(0x19)
	BRLO _0x58
;     358 			{
;     359 			char i;
;     360 			adc_cntC=0;
	RCALL SUBOPT_0x8
;	i -> Y+0
	STS  _adc_cntC,R30
;     361 			adc_bankU_[2]=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _adc_bankU_,4
;     362 			for(i=0;i<25;i++)
	RCALL SUBOPT_0x9
_0x5A:
	RCALL SUBOPT_0xA
	BRSH _0x5B
;     363 				{
;     364 				adc_bankU_[2]+=adc_bankU[2,i];
	__POINTW2MN _adc_bankU_,4
	PUSH R27
	PUSH R26
	RCALL __GETW1P
	PUSH R31
	PUSH R30
	__POINTW2MN _adc_bankU,100
	LD   R30,Y
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0xB
	POP  R26
	POP  R27
	ADD  R30,R26
	ADC  R31,R27
	POP  R26
	POP  R27
	RCALL __PUTWP1
;     365 				}
	RCALL SUBOPT_0xC
	RJMP _0x5A
_0x5B:
;     366 			adc_bankU_[2]/=25;	
	__POINTW2MN _adc_bankU_,4
	PUSH R27
	PUSH R26
	RCALL SUBOPT_0xD
	POP  R26
	POP  R27
	RCALL SUBOPT_0xE
;     367 			}	
;     368 		}	
_0x58:
;     369 	}
_0x55:
_0x54:
;     370 
;     371 #asm("sei")
_0x4C:
	sei
;     372 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;     373 
;     374 //===============================================
;     375 //===============================================
;     376 //===============================================
;     377 //===============================================
;     378 
;     379 void main(void)
;     380 {
_main:
;     381 // Declare your local variables here
;     382 
;     383 // Crystal Oscillator division factor: 8
;     384 CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  0x61,R30
;     385 CLKPR=0x03;
	LDI  R30,LOW(3)
	STS  0x61,R30
;     386 
;     387 // Input/Output Ports initialization
;     388 // Port B initialization
;     389 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;     390 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;     391 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x5,R30
;     392 DDRB=0x00;
	OUT  0x4,R30
;     393 
;     394 // Port C initialization
;     395 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;     396 // State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;     397 PORTC=0x00;
	OUT  0x8,R30
;     398 DDRC=0x00;
	OUT  0x7,R30
;     399 
;     400 // Port D initialization
;     401 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
;     402 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
;     403 PORTD=0x00;
	OUT  0xB,R30
;     404 DDRD=0x00;
	OUT  0xA,R30
;     405 /*
;     406 // Timer/Counter 0 initialization
;     407 // Clock source: System Clock
;     408 // Clock value: 1000,000 kHz
;     409 // Mode: Normal top=FFh
;     410 // OC0A output: Disconnected
;     411 // OC0B output: Disconnected
;     412 TCCR0A=0x00;
;     413 TCCR0B=0x01;
;     414 TCNT0=0x00;
;     415 OCR0A=0x00;
;     416 OCR0B=0x00;
;     417 */
;     418 
;     419 t0_init();
	RCALL _t0_init
;     420 // Timer/Counter 1 initialization
;     421 // Clock source: System Clock
;     422 // Clock value: Timer 1 Stopped
;     423 // Mode: Normal top=FFFFh
;     424 // OC1A output: Discon.
;     425 // OC1B output: Discon.
;     426 // Noise Canceler: Off
;     427 // Input Capture on Falling Edge
;     428 TCCR1A=0x00;
	LDI  R30,LOW(0)
	STS  0x80,R30
;     429 TCCR1B=0x00;
	STS  0x81,R30
;     430 TCNT1H=0x00;
	STS  0x85,R30
;     431 TCNT1L=0x00;
	STS  0x84,R30
;     432 ICR1H=0x00;
	STS  0x87,R30
;     433 ICR1L=0x00;
	STS  0x86,R30
;     434 OCR1AH=0x00;
	STS  0x89,R30
;     435 OCR1AL=0x00;
	STS  0x88,R30
;     436 OCR1BH=0x00;
	STS  0x8B,R30
;     437 OCR1BL=0x00;
	STS  0x8A,R30
;     438 
;     439 // Timer/Counter 2 initialization
;     440 // Clock source: System Clock
;     441 // Clock value: Timer 2 Stopped
;     442 // Mode: Normal top=FFh
;     443 // OC2A output: Disconnected
;     444 // OC2B output: Disconnected
;     445 ASSR=0x00;
	STS  0xB6,R30
;     446 TCCR2A=0x00;
	STS  0xB0,R30
;     447 TCCR2B=0x00;
	STS  0xB1,R30
;     448 TCNT2=0x00;
	STS  0xB2,R30
;     449 OCR2A=0x00;
	STS  0xB3,R30
;     450 OCR2B=0x00;
	STS  0xB4,R30
;     451 
;     452 // External Interrupt(s) initialization
;     453 // INT0: Off
;     454 // INT1: Off
;     455 // Interrupt on any change on pins PCINT0-7: Off
;     456 // Interrupt on any change on pins PCINT8-14: Off
;     457 // Interrupt on any change on pins PCINT16-23: Off
;     458 EICRA=0x00;
	STS  0x69,R30
;     459 EIMSK=0x00;
	OUT  0x1D,R30
;     460 PCICR=0x00;
	STS  0x68,R30
;     461 
;     462 // Timer/Counter 0 Interrupt(s) initialization
;     463 TIMSK0=0x01;
	LDI  R30,LOW(1)
	STS  0x6E,R30
;     464 // Timer/Counter 1 Interrupt(s) initialization
;     465 TIMSK1=0x00;
	LDI  R30,LOW(0)
	STS  0x6F,R30
;     466 // Timer/Counter 2 Interrupt(s) initialization
;     467 TIMSK2=0x00;
	STS  0x70,R30
;     468 
;     469 // Analog Comparator initialization
;     470 // Analog Comparator: Off
;     471 // Analog Comparator Input Capture by Timer/Counter 1: Off
;     472 // Analog Comparator Output: Off
;     473 ADCSRA=0x00;
	STS  0x7A,R30
;     474 ADCSRB=0x00;
	STS  0x7B,R30
;     475 
;     476 
;     477 // Global enable interrupts
;     478 #asm("sei")
	sei
;     479 
;     480 while (1)
_0x5C:
;     481       {
;     482 	if(b100Hz)
	SBIS 0x1E,1
	RJMP _0x5F
;     483 		{
;     484 		b100Hz=0;
	CBI  0x1E,1
;     485 		but_drv();
	RCALL _but_drv
;     486 		but_an();
	RCALL _but_an
;     487 	
;     488 		}   
;     489 	if(b10Hz)
_0x5F:
	SBIS 0x1E,2
	RJMP _0x60
;     490 		{
;     491 		b10Hz=0;
	CBI  0x1E,2
;     492 		 
;     493 		
;     494 		proc_hndl(); 
	RCALL _proc_hndl
;     495 	 	out_out();
	RCALL _out_out
;     496 	 	ind_hndl(); 
	RCALL _ind_hndl
;     497 		}
;     498 	if(b5Hz)
_0x60:
	SBIS 0x1E,3
	RJMP _0x61
;     499 		{
;     500 		b5Hz=0;
	CBI  0x1E,3
;     501 			
;     502 		}
;     503 	if(b2Hz)
_0x61:
	SBIS 0x1E,4
	RJMP _0x62
;     504 		{
;     505 		b2Hz=0;
	CBI  0x1E,4
;     506 		
;     507 		}		 
;     508     	if(b1Hz)
_0x62:
	SBIS 0x1E,5
	RJMP _0x63
;     509 		{
;     510 		b1Hz=0;
	CBI  0x1E,5
;     511 		 
;     512      	}
;     513      #asm("wdr")	
_0x63:
	wdr
;     514 	}
	RJMP _0x5C
;     515 
;     516 }
_0x64:
	RJMP _0x64

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x0:
	LDS  R26,_proc_cnt_h
	LDS  R27,_proc_cnt_h+1
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2:
	LDS  R26,_adc_data
	LDS  R27,_adc_data+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3:
	LDS  R30,_bA_
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4:
	LDS  R26,_adc_data
	LDS  R27,_adc_data+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5:
	LDS  R26,_adc_data
	LDS  R27,_adc_data+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6:
	LDI  R26,LOW(_adc_bankU)
	LDI  R27,HIGH(_adc_bankU)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8:
	SBIW R28,1
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x9:
	LDI  R30,LOW(0)
	ST   Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA:
	LD   R26,Y
	CPI  R26,LOW(0x19)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB:
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xC:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD:
	RCALL __GETW1P
	MOVW R26,R30
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	RCALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE:
	RCALL __PUTWP1
	ADIW R28,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF:
	LDS  R30,_bC_
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10:
	LDS  R26,_adc_data
	LDS  R27,_adc_data+1
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x11:
	LDI  R31,0
	LSL  R30
	ROL  R31
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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__PUTWP1:
	ST   X+,R30
	ST   X,R31
	RET

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

