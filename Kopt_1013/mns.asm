;CodeVisionAVR C Compiler V1.24.1d Standard
;(C) Copyright 1998-2004 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.ro
;e-mail:office@hpinfotech.ro

;Chip type           : ATmega8
;Program type        : Application
;Clock frequency     : 1,000000 MHz
;Memory model        : Small
;Optimize for        : Size
;(s)printf features  : int, width
;(s)scanf features   : long, width
;External SRAM size  : 0
;Data Stack size     : 256 byte(s)
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
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
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

	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_adc_noise_red=0x10
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70

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

	.INCLUDE "mns.vec"
	.INCLUDE "mns.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
	LDI  R26,0x60
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

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	RJMP _main

	.ESEG
	.ORG 0
	.DB  0 ; FIRST EEPROM LOCATION NOT USED, SEE ATMEL ERRATA SHEETS

	.DSEG
	.ORG 0x160
;       1 //#define DEBUG
;       2 #define RELEASE
;       3 #define MIN_U	100
;       4 
;       5 #define SIBHOLOD
;       6 //#define TRIADA
;       7 
;       8 
;       9 #include <Mega8.h>
;      10 #include <delay.h> 
;      11 
;      12 #ifdef DEBUG
;      13 #include "usart.c"
;      14 #include "cmd.c"
;      15 #include <stdio.h>
;      16 #endif
;      17 
;      18 
;      19 #ifdef DEBUG
;      20 #define LED_NET PORTB.0
;      21 #define LED_PER PORTB.1
;      22 #define LED_DEL PORTB.2
;      23 #define KL1 PORTB.7
;      24 #define KL2 PORTB.6
;      25 #endif
;      26 
;      27 #ifdef RELEASE
;      28 #define LED_NET PORTD.0
;      29 #define LED_PER PORTD.1
;      30 #define LED_DEL PORTD.2
;      31 #define KL2 PORTD.3
;      32 #define KL1 PORTD.4
;      33 #endif
;      34 
;      35 bit bT0;
;      36 bit b100Hz;
;      37 bit b10Hz;
;      38 bit b5Hz;
;      39 bit b2Hz;
;      40 bit b1Hz;
;      41 bit n_but;
;      42 
;      43 char t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3,t0_cnt4;
;      44 unsigned int bankA,bankB,bankC;
_bankC:
	.BYTE 0x2
;      45 unsigned int adc_bankU[3][25],ADCU,adc_bankU_[3];
_adc_bankU:
	.BYTE 0x96
_ADCU:
	.BYTE 0x2
_adc_bankU_:
	.BYTE 0x6
;      46 unsigned int del_cnt;
_del_cnt:
	.BYTE 0x2
;      47 char flags;
;      48 char deltas;
_deltas:
	.BYTE 0x1
;      49 char adc_cntA,adc_cntB,adc_cntC;
_adc_cntA:
	.BYTE 0x1
_adc_cntB:
	.BYTE 0x1
_adc_cntC:
	.BYTE 0x1
;      50 bit bA_,bB_,bC_;
;      51 bit bA,bB,bC;
;      52 unsigned int adc_data;
_adc_data:
	.BYTE 0x2
;      53 char cnt_x;
_cnt_x:
	.BYTE 0x1
;      54 char cher[3]={5,6,7};
_cher:
	.BYTE 0x3
;      55 int cher_cnt=25; 
_cher_cnt:
	.BYTE 0x2
;      56 char reset_cnt=25;
_reset_cnt:
	.BYTE 0x1
;      57 char pcnt[3];
_pcnt:
	.BYTE 0x3
;      58 bit bPER,bPER_,bCHER_;
;      59 bit bNN,bNN_;
;      60 enum char {iMn,iSet}ind;
_ind:
	.BYTE 0x1
;      61 bit bFl;
;      62 eeprom char delta; 

	.ESEG
_delta:
	.DB  0x0
;      63 char cnt_butS,cnt_butR; 

	.DSEG
_cnt_butS:
	.BYTE 0x1
_cnt_butR:
	.BYTE 0x1
;      64 bit butR,butS;
;      65 flash char DF[]={0,10,15,20,25,30,35};

	.CSEG
;      66 char per_cnt;

	.DSEG
_per_cnt:
	.BYTE 0x1
;      67 char nn_cnt;
_nn_cnt:
	.BYTE 0x1
;      68 //-----------------------------------------------
;      69 void t0_init(void)
;      70 {

	.CSEG
_t0_init:
;      71 TCCR0=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
;      72 TCNT0=-78;
	LDI  R30,LOW(178)
	OUT  0x32,R30
;      73 TIMSK|=0b00000001;
	IN   R30,0x39
	ORI  R30,1
	OUT  0x39,R30
;      74 } 
	RET
;      75 
;      76 //-----------------------------------------------
;      77 void t2_init(void)
;      78 {
_t2_init:
;      79 //TIFR|=0b01000000;
;      80 TCNT2=-97;
	LDI  R30,LOW(159)
	OUT  0x24,R30
;      81 TCCR2=0x07;
	LDI  R30,LOW(7)
	OUT  0x25,R30
;      82 OCR2=-80;
	LDI  R30,LOW(176)
	OUT  0x23,R30
;      83 TIMSK|=0b11000000;
	IN   R30,0x39
	ORI  R30,LOW(0xC0)
	OUT  0x39,R30
;      84 }  
	RET
;      85 
;      86 //-----------------------------------------------
;      87 void del_init(void)
;      88 {
_del_init:
;      89 if(!del_cnt)
	RCALL SUBOPT_0x0
	BRNE _0x6
;      90 	{
;      91 #ifdef SIBHOLOD
;      92 	del_cnt=300;
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	STS  _del_cnt,R30
	STS  _del_cnt+1,R31
;      93 #endif
;      94 
;      95 #ifdef TRIADA
;      96 	del_cnt=3;
;      97 #endif
;      98 	}
;      99 } 
_0x6:
	RET
;     100 
;     101 //-----------------------------------------------
;     102 void del_hndl(void)
;     103 {
_del_hndl:
;     104 if((del_cnt)&&(!bCHER_)) del_cnt--;
	RCALL SUBOPT_0x0
	BREQ _0x8
	SBRS R3,7
	RJMP _0x9
_0x8:
	RJMP _0x7
_0x9:
	LDS  R30,_del_cnt
	LDS  R31,_del_cnt+1
	SBIW R30,1
	STS  _del_cnt,R30
	STS  _del_cnt+1,R31
;     105 } 
_0x7:
	RET
;     106 
;     107 //-----------------------------------------------
;     108 void ind_hndl(void)
;     109 {
_ind_hndl:
;     110 #ifdef DEBUG
;     111 DDRB|=0x07;
;     112 #endif
;     113 
;     114 #ifdef RELEASE
;     115 DDRD|=0x07;   
	IN   R30,0x11
	ORI  R30,LOW(0x7)
	OUT  0x11,R30
;     116 #endif
;     117  
;     118 if(ind==iMn)
	RCALL SUBOPT_0x1
	BRNE _0xA
;     119 	{
;     120 	if(bCHER_)
	SBRS R3,7
	RJMP _0xB
;     121 		{
;     122 		LED_NET=bFl;
	BST  R4,2
	IN   R30,0x12
	BLD  R30,0
	OUT  0x12,R30
;     123 		}
;     124 	else LED_NET=0;
	RJMP _0xC
_0xB:
	CBI  0x12,0
_0xC:
;     125 	
;     126 	if(del_cnt||bCHER_)
	RCALL SUBOPT_0x0
	BRNE _0xE
	SBRS R3,7
	RJMP _0xD
_0xE:
;     127 		{
;     128 		LED_DEL=0;
	CBI  0x12,2
;     129 		}
;     130 	else LED_DEL=1;
	RJMP _0x10
_0xD:
	SBI  0x12,2
_0x10:
;     131 
;     132 	if(bNN_)
	SBRS R4,1
	RJMP _0x11
;     133 		{
;     134 		LED_PER=bFl;
	BST  R4,2
	IN   R30,0x12
	BLD  R30,1
	OUT  0x12,R30
;     135 		}
;     136 
;     137 	else if(bPER)
	RJMP _0x12
_0x11:
	SBRS R3,5
	RJMP _0x13
;     138 		{
;     139 		LED_PER=0;
	CBI  0x12,1
;     140 		}		
;     141 
;     142 	else LED_PER=1;	
	RJMP _0x14
_0x13:
	SBI  0x12,1
_0x14:
_0x12:
;     143 				
;     144 	}
;     145 else if(ind==iSet)
	RJMP _0x15
_0xA:
	RCALL SUBOPT_0x2
	BRNE _0x16
;     146 	{
;     147 	#ifdef DEBUG 
;     148 	if(bFl) PORTB|=0x07;
;     149 	else PORTB&=(delta^0xff)|0xf8;
;     150 	#endif
;     151 	
;     152 	#ifdef RELEASE 
;     153 	if(bFl) PORTD|=0x07;
	SBRS R4,2
	RJMP _0x17
	IN   R30,0x12
	ORI  R30,LOW(0x7)
	RJMP _0x9C
;     154 	else PORTD&=(delta^0xff)|0xf8;
_0x17:
	IN   R30,0x12
	PUSH R30
	LDI  R26,LOW(_delta)
	LDI  R27,HIGH(_delta)
	RCALL __EEPROMRDB
	LDI  R26,LOW(255)
	EOR  R30,R26
	ORI  R30,LOW(0xF8)
	POP  R26
	AND  R30,R26
_0x9C:
	OUT  0x12,R30
;     155 	#endif
;     156 	
;     157 	}	
;     158 }
_0x16:
_0x15:
	RET
;     159 
;     160 //-----------------------------------------------
;     161 void out_out(void)
;     162 {
_out_out:
;     163 #ifdef DEBUG
;     164 DDRB|=0xc0;   
;     165 #endif
;     166 
;     167 #ifdef RELEASE
;     168 DDRD|=0x18;   
	IN   R30,0x11
	ORI  R30,LOW(0x18)
	OUT  0x11,R30
;     169 #endif    
;     170 
;     171 if((!del_cnt)&&(!bPER_)&&(!bCHER_)&&(!bNN_))
	RCALL SUBOPT_0x0
	BRNE _0x1A
	SBRC R3,6
	RJMP _0x1A
	SBRC R3,7
	RJMP _0x1A
	SBRS R4,1
	RJMP _0x1B
_0x1A:
	RJMP _0x19
_0x1B:
;     172 	{
;     173 	KL1=1;
	SBI  0x12,4
;     174 	flags|=0x02;
	MOV  R30,R14
	ORI  R30,2
	RJMP _0x9D
;     175 	}
;     176 else 
_0x19:
;     177 	{
;     178 	KL1=0;
	CBI  0x12,4
;     179 	flags&=0xfD;
	MOV  R30,R14
	ANDI R30,0xFD
_0x9D:
	MOV  R14,R30
;     180 	}	
;     181 	
;     182 if((!bPER_)&&(!bCHER_)&&(!bNN_))
	SBRC R3,6
	RJMP _0x1E
	SBRC R3,7
	RJMP _0x1E
	SBRS R4,1
	RJMP _0x1F
_0x1E:
	RJMP _0x1D
_0x1F:
;     183 	{
;     184 	KL2=1;
	SBI  0x12,3
;     185 	flags|=0x08;
	MOV  R30,R14
	ORI  R30,8
	RJMP _0x9E
;     186 	}
;     187 else 
_0x1D:
;     188 	{
;     189 	KL2=0;
	CBI  0x12,3
;     190 	flags&=0xf7;
	MOV  R30,R14
	ANDI R30,0XF7
_0x9E:
	MOV  R14,R30
;     191 	}		
;     192 }
	RET
;     193 
;     194 //-----------------------------------------------
;     195 void per_drv(void)
;     196 {
_per_drv:
;     197 char max_,min_;
;     198 signed long temp_SL;
;     199 if((adc_bankU_[0]>=adc_bankU_[1])&&(adc_bankU_[0]>=adc_bankU_[2])) max_=0; 
	SBIW R28,4
	RCALL __SAVELOCR2
;	max_ -> R16
;	min_ -> R17
;	temp_SL -> Y+2
	__GETW1MN _adc_bankU_,2
	RCALL SUBOPT_0x3
	BRLO _0x22
	__GETW1MN _adc_bankU_,4
	RCALL SUBOPT_0x3
	BRSH _0x23
_0x22:
	RJMP _0x21
_0x23:
	LDI  R16,LOW(0)
;     200 else if(adc_bankU_[1]>=adc_bankU_[2]) max_=1; 
	RJMP _0x24
_0x21:
	__GETW1MN _adc_bankU_,2
	PUSH R31
	PUSH R30
	__GETW1MN _adc_bankU_,4
	POP  R26
	POP  R27
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x25
	LDI  R16,LOW(1)
;     201 else max_=2;  
	RJMP _0x26
_0x25:
	LDI  R16,LOW(2)
_0x26:
_0x24:
;     202 
;     203 if((adc_bankU_[0]<=adc_bankU_[1])&&(adc_bankU_[0]<=adc_bankU_[2])) min_=0; 
	__GETW1MN _adc_bankU_,2
	RCALL SUBOPT_0x4
	BRLO _0x28
	__GETW1MN _adc_bankU_,4
	RCALL SUBOPT_0x4
	BRSH _0x29
_0x28:
	RJMP _0x27
_0x29:
	LDI  R17,LOW(0)
;     204 else if(adc_bankU_[1]<=adc_bankU_[2]) min_=1; 
	RJMP _0x2A
_0x27:
	__GETW1MN _adc_bankU_,2
	PUSH R31
	PUSH R30
	__GETW1MN _adc_bankU_,4
	POP  R26
	POP  R27
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x2B
	LDI  R17,LOW(1)
;     205 else min_=2; 
	RJMP _0x2C
_0x2B:
	LDI  R17,LOW(2)
_0x2C:
_0x2A:
;     206 
;     207 temp_SL=adc_bankU_[max_]*(long)DF[delta]/100;
	RCALL SUBOPT_0x5
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_DF*2)
	LDI  R31,HIGH(_DF*2)
	PUSH R31
	PUSH R30
	LDI  R26,LOW(_delta)
	LDI  R27,HIGH(_delta)
	RCALL __EEPROMRDB
	POP  R26
	POP  R27
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R26
	POP  R27
	CLR  R24
	CLR  R25
	RCALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x64
	RCALL __DIVD21
	__PUTD1S 2
;     208 if((adc_bankU_[max_]-adc_bankU_[min_])>=(int)temp_SL)
	RCALL SUBOPT_0x5
	PUSH R31
	PUSH R30
	MOV  R30,R17
	LDI  R26,LOW(_adc_bankU_)
	LDI  R27,HIGH(_adc_bankU_)
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x7
	POP  R26
	POP  R27
	SUB  R26,R30
	SBC  R27,R31
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x2D
;     209 	{
;     210 	bPER=1;
	SET
	BLD  R3,5
;     211 
;     212 	flags|=0x01;
	MOV  R30,R14
	ORI  R30,1
	RJMP _0x9F
;     213 	}      
;     214 else
_0x2D:
;     215 	{
;     216 	bPER=0;   
	CLT
	BLD  R3,5
;     217 
;     218 	flags&=0xfe;
	MOV  R30,R14
	ANDI R30,0xFE
_0x9F:
	MOV  R14,R30
;     219 	}
;     220 //	bPER=0;	
;     221 }
	RCALL __LOADLOCR2
	ADIW R28,6
	RET
;     222 
;     223 //-----------------------------------------------
;     224 void nn_drv(void)
;     225 {
_nn_drv:
;     226 if((adc_bankU_[0]<=MIN_U)&&(adc_bankU_[1]<=MIN_U)&&(adc_bankU_[2]<=MIN_U))
	LDS  R26,_adc_bankU_
	LDS  R27,_adc_bankU_+1
	RCALL SUBOPT_0x8
	BRLO _0x30
	__GETW2MN _adc_bankU_,2
	RCALL SUBOPT_0x8
	BRLO _0x30
	__GETW2MN _adc_bankU_,4
	RCALL SUBOPT_0x8
	BRSH _0x31
_0x30:
	RJMP _0x2F
_0x31:
;     227 	{
;     228 	bNN=1;
	SET
	BLD  R4,0
;     229 	}      
;     230 else
	RJMP _0x32
_0x2F:
;     231 	{
;     232 	bNN=0;   
	CLT
	BLD  R4,0
;     233 	}
_0x32:
;     234 }
	RET
;     235 
;     236 //-----------------------------------------------
;     237 void per_hndl(void)
;     238 {
_per_hndl:
;     239 if(!bPER)
	SBRC R3,5
	RJMP _0x33
;     240 	{
;     241 	per_cnt=0;
	LDI  R30,LOW(0)
	STS  _per_cnt,R30
;     242 	bPER_=0;
	CLT
	BLD  R3,6
;     243 	flags&=0xfB;
	MOV  R30,R14
	ANDI R30,0xFB
	MOV  R14,R30
;     244 	}
;     245 else
	RJMP _0x34
_0x33:
;     246 	{
;     247 	if(per_cnt<5)
	LDS  R26,_per_cnt
	CPI  R26,LOW(0x5)
	BRSH _0x35
;     248 		{
;     249 		if(++per_cnt>=5)
	SUBI R26,-LOW(1)
	STS  _per_cnt,R26
	CPI  R26,LOW(0x5)
	BRLO _0x36
;     250 			{
;     251 			bPER_=1;
	SET
	BLD  R3,6
;     252 			flags|=0x04;
	MOV  R30,R14
	ORI  R30,4
	MOV  R14,R30
;     253 			del_init();
	RCALL _del_init
;     254 			}
;     255 		}
_0x36:
;     256 	}	
_0x35:
_0x34:
;     257 }
	RET
;     258 
;     259 //-----------------------------------------------
;     260 void nn_hndl(void)
;     261 {
_nn_hndl:
;     262 if(!bNN)
	SBRC R4,0
	RJMP _0x37
;     263 	{
;     264 	nn_cnt=0;
	LDI  R30,LOW(0)
	STS  _nn_cnt,R30
;     265 	bNN_=0;
	CLT
	BLD  R4,1
;     266 	
;     267 	}
;     268 else
	RJMP _0x38
_0x37:
;     269 	{
;     270 	if(nn_cnt<5)
	LDS  R26,_nn_cnt
	CPI  R26,LOW(0x5)
	BRSH _0x39
;     271 		{
;     272 		if(++nn_cnt>=5)
	SUBI R26,-LOW(1)
	STS  _nn_cnt,R26
	CPI  R26,LOW(0x5)
	BRLO _0x3A
;     273 			{
;     274 			bNN_=1;
	SET
	BLD  R4,1
;     275 			del_init();
	RCALL _del_init
;     276 			}
;     277 		}
_0x3A:
;     278 	}	
_0x39:
_0x38:
;     279 }
	RET
;     280 
;     281 //-----------------------------------------------
;     282 void pcnt_hndl(void)
;     283 {
_pcnt_hndl:
;     284 if(pcnt[0])
	RCALL SUBOPT_0x9
	BREQ _0x3B
;     285 	{
;     286 	pcnt[0]--;
	LDI  R26,LOW(_pcnt)
	LDI  R27,HIGH(_pcnt)
	RCALL SUBOPT_0xA
;     287 	if(pcnt[0]==0) adc_bankU_[0]=0;
	RCALL SUBOPT_0x9
	BRNE _0x3C
	RCALL SUBOPT_0xB
;     288 	}
_0x3C:
;     289 if(pcnt[1])
_0x3B:
	__GETB1MN _pcnt,1
	CPI  R30,0
	BREQ _0x3D
;     290 	{
;     291 	pcnt[1]--;
	__POINTW2MN _pcnt,1
	RCALL SUBOPT_0xA
;     292 	if(pcnt[1]==0) adc_bankU_[1]=0;
	__GETB1MN _pcnt,1
	CPI  R30,0
	BRNE _0x3E
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _adc_bankU_,2
;     293 	}
_0x3E:
;     294 if(pcnt[2])
_0x3D:
	__GETB1MN _pcnt,2
	CPI  R30,0
	BREQ _0x3F
;     295 	{
;     296 	pcnt[2]--;
	__POINTW2MN _pcnt,2
	RCALL SUBOPT_0xA
;     297 	if(pcnt[2]==0) adc_bankU_[2]=0;
	__GETB1MN _pcnt,2
	CPI  R30,0
	BRNE _0x40
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _adc_bankU_,4
;     298 	}		
_0x40:
;     299 }
_0x3F:
	RET
;     300 
;     301 //-----------------------------------------------
;     302 void gran_char(signed char *adr, signed char min, signed char max)
;     303 {
;     304 if (*adr<min) *adr=min;
;     305 if (*adr>max) *adr=max; 
;     306 } 
;     307 
;     308 
;     309 #ifdef DEBUG
;     310 
;     311 
;     312 
;     313 //-----------------------------------------------
;     314 char index_offset (signed char index,signed char offset)
;     315 {
;     316 index=index+offset;
;     317 if(index>=RX_BUFFER_SIZE) index-=RX_BUFFER_SIZE; 
;     318 if(index<0) index+=RX_BUFFER_SIZE;
;     319 return index;
;     320 }
;     321 
;     322 //-----------------------------------------------
;     323 char control_check(char index)
;     324 {
;     325 char i=0,ii=0,iii;
;     326 
;     327 if(rx_buffer[index]!=END) goto error_cc;
;     328 
;     329 ii=rx_buffer[index_offset(index,-2)];
;     330 iii=0;
;     331 for(i=0;i<=ii;i++)
;     332 	{
;     333 	iii^=rx_buffer[index_offset(index,-2-ii+i)];
;     334 	}
;     335 if (iii!=rx_buffer[index_offset(index,-1)]) goto error_cc;	
;     336 
;     337 
;     338 success_cc:
;     339 return 1;
;     340 goto end_cc;
;     341 error_cc:
;     342 return 0;
;     343 goto end_cc;
;     344 
;     345 end_cc:
;     346 }
;     347 
;     348 
;     349 //-----------------------------------------------
;     350 void OUT (char num,char data0,char data1,char data2,char data3,char data4,char data5)
;     351 {
;     352 char i,t=0;
;     353 //char *ptr=&data1;
;     354 char UOB[6]; 
;     355 UOB[0]=data0;
;     356 UOB[1]=data1;
;     357 UOB[2]=data2;
;     358 UOB[3]=data3;
;     359 UOB[4]=data4;
;     360 UOB[5]=data5;
;     361 for (i=0;i<num;i++)
;     362 	{
;     363 	t^=UOB[i];
;     364 	}    
;     365 UOB[num]=num;
;     366 t^=UOB[num];
;     367 UOB[num+1]=t;
;     368 UOB[num+2]=END;
;     369 
;     370 for (i=0;i<num+3;i++)
;     371 	{
;     372 	putchar(UOB[i]);
;     373 	}   	
;     374 }
;     375 
;     376 //-----------------------------------------------
;     377 void OUT_adr (char *ptr, char len)
;     378 {
;     379 char UOB[20]={0,0,0,0,0,0,0,0,0,0};
;     380 char i,t=0;
;     381 
;     382 for(i=0;i<len;i++)
;     383 	{
;     384 	UOB[i]=ptr[i];
;     385 	t^=UOB[i];
;     386 	}
;     387 //if(!t)t=0xff;
;     388 UOB[len]=len;
;     389 t^=len;	
;     390 UOB[len+1]=t;	
;     391 UOB[len+2]=END;
;     392 //UOB[0]=i+1;
;     393 //UOB[i]=t^UOB[0];
;     394 //UOB[i+1]=END;
;     395 	
;     396 //puts(UOB); 
;     397 for (i=0;i<len+3;i++)
;     398 	{
;     399 	putchar(UOB[i]);
;     400 	}   
;     401 }
;     402 
;     403 //-----------------------------------------------
;     404 void UART_IN_AN(void)
;     405 {
;     406 char temp_char;
;     407 int temp_int;
;     408 signed long int temp_intL;
;     409 
;     410 if((UIB[0]==CMND)&&(UIB[1]==QWEST))
;     411 	{
;     412 
;     413 	}
;     414 else if((UIB[0]==CMND)&&(UIB[1]==GETID))
;     415 	{
;     416 
;     417           
;     418 	}	
;     419 
;     420 }
;     421 
;     422 //-----------------------------------------------
;     423 void UART_IN(void)
;     424 {
;     425 //static char flag;
;     426 char temp,i,count;
;     427 if(!bRXIN) goto UART_IN_end;
;     428 #asm("cli")
;     429 //char* ptr;
;     430 //char i=0,t=0;
;     431 //int it=0;
;     432 //signed long int char_int;
;     433 //if(!bRXIN) goto UART_IN_end;
;     434 //bRXIN=0;
;     435 //count=rx_counter;
;     436 //OUT(0x01,0,0,0,0,0);
;     437 if(rx_buffer_overflow)
;     438 	{
;     439 	rx_wr_index=0;
;     440 	rx_rd_index=0;
;     441 	rx_counter=0;
;     442 	rx_buffer_overflow=0;
;     443 	}    
;     444 	
;     445 if(rx_counter&&(rx_buffer[index_offset(rx_wr_index,-1)])==END)
;     446 	{
;     447      temp=rx_buffer[index_offset(rx_wr_index,-3)];
;     448     	if(temp<10) 
;     449     		{
;     450     		if(control_check(index_offset(rx_wr_index,-1)))
;     451     			{
;     452     			rx_rd_index=index_offset(rx_wr_index,-3-temp);
;     453     			for(i=0;i<temp;i++)
;     454 				{
;     455 				UIB[i]=rx_buffer[index_offset(rx_rd_index,i)];
;     456 				} 
;     457 			rx_rd_index=rx_wr_index;
;     458 			rx_counter=0;
;     459 			UART_IN_AN();
;     460 
;     461     			}
;     462  	
;     463     		} 
;     464     	}	
;     465 
;     466 UART_IN_end:
;     467 bRXIN=0;
;     468 #asm("sei")     
;     469 } 
;     470 
;     471 #endif
;     472 
;     473     
;     474  
;     475 
;     476 
;     477 
;     478 
;     479 
;     480 
;     481 //-----------------------------------------------
;     482 void led_hndl(void)
;     483 {
;     484 
;     485 }
;     486 
;     487 
;     488 
;     489 //-----------------------------------------------
;     490 void but_drv(void)
;     491 {
_but_drv:
;     492 #ifdef DEBUG
;     493 #define PINR PIND.2
;     494 #define PORTR PORTD.2
;     495 #define DDR DDRD.2
;     496 
;     497 #define PINS PIND.3
;     498 #define PORTS PORTD.3
;     499 #define DDS DDRD.3
;     500 #endif
;     501 
;     502 #ifdef RELEASE
;     503 #define PINR PINC.4
;     504 #define PORTR PORTC.4
;     505 #define DDR DDRC.4
;     506 
;     507 #define PINS PINC.5
;     508 #define PORTS PORTC.5
;     509 #define DDS DDRC.5
;     510 #endif
;     511 
;     512 
;     513 DDR=0;
	CBI  0x14,4
;     514 DDS=0;
	CBI  0x14,5
;     515 PORTR=1;
	SBI  0x15,4
;     516 PORTS=1; 
	SBI  0x15,5
;     517       
;     518 if(!PINR)
	SBIC 0x13,4
	RJMP _0x43
;     519 	{
;     520 	if(cnt_butR<10)
	LDS  R26,_cnt_butR
	CPI  R26,LOW(0xA)
	BRSH _0x44
;     521 		{
;     522 		if(++cnt_butR>=10)
	SUBI R26,-LOW(1)
	STS  _cnt_butR,R26
	CPI  R26,LOW(0xA)
	BRLO _0x45
;     523 			{
;     524 			butR=1;
	SET
	BLD  R4,3
;     525 			}
;     526 		}
_0x45:
;     527 	}                 
_0x44:
;     528 else 
	RJMP _0x46
_0x43:
;     529 	{
;     530 	cnt_butR=0;
	LDI  R30,LOW(0)
	STS  _cnt_butR,R30
;     531 	butR=0;
	CLT
	BLD  R4,3
;     532 	}	 
_0x46:
;     533 	
;     534 if(!PINS)
	SBIC 0x13,5
	RJMP _0x47
;     535 	{
;     536 	if(cnt_butS<200)
	LDS  R26,_cnt_butS
	CPI  R26,LOW(0xC8)
	BRSH _0x48
;     537 		{
;     538 		if(++cnt_butS>=200)
	SUBI R26,-LOW(1)
	STS  _cnt_butS,R26
	CPI  R26,LOW(0xC8)
	BRLO _0x49
;     539 			{
;     540 			butS=1;
	SET
	BLD  R4,4
;     541 			}
;     542 		}
_0x49:
;     543 	}                 
_0x48:
;     544 else 
	RJMP _0x4A
_0x47:
;     545 	{
;     546 	cnt_butS=0;
	LDI  R30,LOW(0)
	STS  _cnt_butS,R30
;     547 	butS=0;
	CLT
	BLD  R4,4
;     548 	}		
_0x4A:
;     549 	           
;     550 }
	RET
;     551 
;     552 //-----------------------------------------------
;     553 void but_an(void)
;     554 {
_but_an:
;     555 if(ind==iMn)
	RCALL SUBOPT_0x1
	BRNE _0x4B
;     556 	{
;     557 	if(butS) ind=iSet;
	SBRS R4,4
	RJMP _0x4C
	LDI  R30,LOW(1)
	STS  _ind,R30
;     558 	if(butR)
_0x4C:
	SBRS R4,3
	RJMP _0x4D
;     559 		{
;     560 		if(del_cnt) del_cnt=0;
	RCALL SUBOPT_0x0
	BREQ _0x4E
	LDI  R30,0
	STS  _del_cnt,R30
	STS  _del_cnt+1,R30
;     561 		}
_0x4E:
;     562 	}
_0x4D:
;     563 else if(ind==iSet)
	RJMP _0x4F
_0x4B:
	RCALL SUBOPT_0x2
	BRNE _0x50
;     564 	{            
;     565 	if(butR)
	SBRS R4,3
	RJMP _0x51
;     566 		{
;     567 		if(delta<6) delta++;
	LDI  R26,LOW(_delta)
	LDI  R27,HIGH(_delta)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x6)
	BRSH _0x52
	LDI  R26,LOW(_delta)
	LDI  R27,HIGH(_delta)
	RCALL __EEPROMRDB
	SUBI R30,-LOW(1)
	RCALL __EEPROMWRB
	SUBI R30,LOW(1)
;     568 		else delta=1;
	RJMP _0x53
_0x52:
	LDI  R30,LOW(1)
	LDI  R26,LOW(_delta)
	LDI  R27,HIGH(_delta)
	RCALL __EEPROMWRB
_0x53:
;     569 		}
;     570 	if(butS) ind=iMn;	
_0x51:
	SBRC R4,4
	RCALL SUBOPT_0xC
;     571 	}
;     572 but_an_end:
_0x50:
_0x4F:
;     573 butR=0;
	CLT
	BLD  R4,3
;     574 butS=0;
	CLT
	BLD  R4,4
;     575 }
	RET
;     576 
;     577 
;     578 
;     579 
;     580 
;     581 
;     582 
;     583 
;     584 
;     585 
;     586 
;     587 //***********************************************
;     588 //***********************************************
;     589 //***********************************************
;     590 //***********************************************
;     591 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;     592 {
_timer0_ovf_isr:
	RCALL SUBOPT_0xD
;     593 t0_init();
	RCALL _t0_init
;     594 bT0=!bT0;
	LDI  R30,LOW(1)
	EOR  R2,R30
;     595 
;     596 if(!bT0) goto lbl_000;
	SBRS R2,0
	RJMP _0x57
;     597 b100Hz=1;
	SET
	BLD  R2,1
;     598 if(++t0_cnt0>=10)
	INC  R5
	LDI  R30,LOW(10)
	CP   R5,R30
	BRLO _0x58
;     599 	{
;     600 	t0_cnt0=0;
	CLR  R5
;     601 	b10Hz=1;
	SET
	BLD  R2,2
;     602 	bFl=!bFl;
	LDI  R30,LOW(4)
	EOR  R4,R30
;     603 
;     604 	} 
;     605 if(++t0_cnt1>=20)
_0x58:
	INC  R6
	LDI  R30,LOW(20)
	CP   R6,R30
	BRLO _0x59
;     606 	{
;     607 	t0_cnt1=0;
	CLR  R6
;     608 	b5Hz=1;
	SET
	BLD  R2,3
;     609 
;     610 	}
;     611 if(++t0_cnt2>=50)
_0x59:
	INC  R7
	LDI  R30,LOW(50)
	CP   R7,R30
	BRLO _0x5A
;     612 	{
;     613 	t0_cnt2=0;
	CLR  R7
;     614 	b2Hz=1;
	SET
	BLD  R2,4
;     615 	}	
;     616 		
;     617 if(++t0_cnt3>=100)
_0x5A:
	INC  R8
	LDI  R30,LOW(100)
	CP   R8,R30
	BRLO _0x5B
;     618 	{
;     619 	t0_cnt3=0;
	CLR  R8
;     620 	b1Hz=1;
	SET
	BLD  R2,5
;     621 	}		
;     622 lbl_000:
_0x5B:
_0x57:
;     623 }
	RCALL SUBOPT_0xE
	RETI
;     624 
;     625 //-----------------------------------------------
;     626 // Timer 2 output compare interrupt service routine
;     627 interrupt [TIM2_OVF] void timer2_ovf_isr(void)
;     628 {
_timer2_ovf_isr:
	RCALL SUBOPT_0xD
;     629 t2_init();
	RCALL _t2_init
;     630 
;     631 
;     632 
;     633 }
	RCALL SUBOPT_0xE
	RETI
;     634 
;     635 //-----------------------------------------------
;     636 // Timer 2 output compare interrupt service routine
;     637 interrupt [TIM2_COMP] void timer2_comp_isr(void)
;     638 {
_timer2_comp_isr:
;     639 
;     640 	
;     641 
;     642 } 
	RETI
;     643 
;     644 
;     645 //-----------------------------------------------
;     646 //#pragma savereg-
;     647 interrupt [ADC_INT] void adc_isr(void)
;     648 {
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
;     649 
;     650 register static unsigned char input_index=0;

	.DSEG
_input_index_S12:
	.BYTE 0x1

	.CSEG
;     651 // Read the AD conversion result
;     652 adc_data=ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	STS  _adc_data,R30
	STS  _adc_data+1,R31
;     653 
;     654 if (++input_index > 2)
	LDS  R26,_input_index_S12
	SUBI R26,-LOW(1)
	STS  _input_index_S12,R26
	LDI  R30,LOW(2)
	CP   R30,R26
	BRSH _0x5C
;     655    input_index=0;
	LDI  R30,LOW(0)
	STS  _input_index_S12,R30
;     656 #ifdef DEBUG
;     657 ADMUX=(0b01000011)+input_index;
;     658 #endif
;     659 #ifdef RELEASE
;     660 ADMUX=0b01000000+input_index;
_0x5C:
	LDS  R30,_input_index_S12
	SUBI R30,-LOW(64)
	OUT  0x7,R30
;     661 #endif
;     662 
;     663 // Start the AD conversion
;     664 ADCSRA|=0x40;
	SBI  0x6,6
;     665 
;     666 if(input_index==1)
	LDS  R26,_input_index_S12
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x5D
;     667 	{
;     668  	if((adc_data>100)&&!bA_)
	RCALL SUBOPT_0xF
	BRSH _0x5F
	SBRS R2,7
	RJMP _0x60
_0x5F:
	RJMP _0x5E
_0x60:
;     669     		{
;     670     		bA_=1;
	SET
	BLD  R2,7
;     671     		cnt_x++;
	RCALL SUBOPT_0x10
;     672     		}
;     673     	if((adc_data<100)&&bA_)
_0x5E:
	RCALL SUBOPT_0x11
	BRSH _0x62
	SBRC R2,7
	RJMP _0x63
_0x62:
	RJMP _0x61
_0x63:
;     674     		{
;     675     		bA_=0;
	CLT
	BLD  R2,7
;     676     		}			
;     677 //	adc_data
;     678 	if(adc_data>10U)
_0x61:
	RCALL SUBOPT_0x12
	BRSH _0x64
;     679 		{
;     680 		bankA+=adc_data;
	LDS  R30,_adc_data
	LDS  R31,_adc_data+1
	__ADDWRR 10,11,30,31
;     681 		bA=1;
	SET
	BLD  R3,2
;     682 		pcnt[0]=10;
	LDI  R30,LOW(10)
	STS  _pcnt,R30
;     683 		}
;     684 	else if((adc_data<=10U)&&bA)
	RJMP _0x65
_0x64:
	RCALL SUBOPT_0x12
	BRLO _0x67
	SBRC R3,2
	RJMP _0x68
_0x67:
	RJMP _0x66
_0x68:
;     685 		{
;     686 		bA=0;
	CLT
	BLD  R3,2
;     687 		
;     688 		adc_bankU[0,adc_cntA]=bankA/10;
	LDS  R30,_adc_cntA
	RCALL SUBOPT_0x13
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	__GETW2R 10,11
	RCALL SUBOPT_0x14
	POP  R26
	POP  R27
	RCALL __PUTWP1
;     689 		bankA=0;
	CLR  R10
	CLR  R11
;     690 		if(++adc_cntA>=25) 
	LDS  R26,_adc_cntA
	SUBI R26,-LOW(1)
	STS  _adc_cntA,R26
	CPI  R26,LOW(0x19)
	BRLO _0x69
;     691 			{
;     692 			char i;
;     693 			adc_cntA=0;
	RCALL SUBOPT_0x15
;	i -> Y+0
	STS  _adc_cntA,R30
;     694 			adc_bankU_[0]=0;
	RCALL SUBOPT_0xB
;     695 			for(i=0;i<25;i++)
	RCALL SUBOPT_0x16
_0x6B:
	RCALL SUBOPT_0x17
	BRSH _0x6C
;     696 				{
;     697 				adc_bankU_[0]+=adc_bankU[0,i];
	LDI  R26,LOW(_adc_bankU_)
	LDI  R27,HIGH(_adc_bankU_)
	PUSH R27
	PUSH R26
	RCALL __GETW1P
	PUSH R31
	PUSH R30
	LD   R30,Y
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x7
	POP  R26
	POP  R27
	ADD  R30,R26
	ADC  R31,R27
	POP  R26
	POP  R27
	RCALL __PUTWP1
;     698 				}
	RCALL SUBOPT_0x18
	RJMP _0x6B
_0x6C:
;     699 			adc_bankU_[0]/=25;	
	LDI  R26,LOW(_adc_bankU_)
	LDI  R27,HIGH(_adc_bankU_)
	PUSH R27
	PUSH R26
	RCALL SUBOPT_0x19
	POP  R26
	POP  R27
	RCALL SUBOPT_0x1A
;     700 			}	
;     701 		}
_0x69:
;     702 	//adc_bankU_[0]		          
;     703 	}  
_0x66:
_0x65:
;     704 if(input_index==2)
_0x5D:
	LDS  R26,_input_index_S12
	CPI  R26,LOW(0x2)
	BREQ PC+2
	RJMP _0x6D
;     705 	{
;     706  	if((adc_data>100)&&!bB_)
	RCALL SUBOPT_0xF
	BRSH _0x6F
	SBRS R3,0
	RJMP _0x70
_0x6F:
	RJMP _0x6E
_0x70:
;     707     		{
;     708     		bB_=1;
	SET
	BLD  R3,0
;     709     		cnt_x++;
	RCALL SUBOPT_0x10
;     710     		cher[0]=cnt_x;
	LDS  R30,_cnt_x
	STS  _cher,R30
;     711    // 		cnt_x=2;
;     712     		if(cnt_x==2)
	LDS  R26,_cnt_x
	CPI  R26,LOW(0x2)
	BRNE _0x71
;     713     			{
;     714     			if(cher_cnt<50)
	RCALL SUBOPT_0x1B
	BRGE _0x72
;     715 				{
;     716 				cher_cnt++;
	LDS  R30,_cher_cnt
	LDS  R31,_cher_cnt+1
	ADIW R30,1
	STS  _cher_cnt,R30
	STS  _cher_cnt+1,R31
;     717 				if((cher_cnt>=50)/*&&reset_cnt*/) bCHER_=1;//cher_alarm(0);
	RCALL SUBOPT_0x1B
	BRLT _0x73
	SET
	BLD  R3,7
;     718 		     	}
_0x73:
;     719     			}
_0x72:
;     720     		else
	RJMP _0x74
_0x71:
;     721     			{
;     722     			if(cher_cnt)
	RCALL SUBOPT_0x1C
	BREQ _0x75
;     723 				{
;     724 				cher_cnt--;
	LDS  R30,_cher_cnt
	LDS  R31,_cher_cnt+1
	SBIW R30,1
	STS  _cher_cnt,R30
	STS  _cher_cnt+1,R31
;     725 				if((cher_cnt==0)/*&&reset_cnt*/) bCHER_=0;//cher_alarm(1);
	RCALL SUBOPT_0x1C
	BRNE _0x76
	CLT
	BLD  R3,7
;     726 		     	}
_0x76:
;     727     			}
_0x75:
_0x74:
;     728   //  		bCHER_=0;			 
;     729     		}
;     730     	if((adc_data<100)&&bB_)
_0x6E:
	RCALL SUBOPT_0x11
	BRSH _0x78
	SBRC R3,0
	RJMP _0x79
_0x78:
	RJMP _0x77
_0x79:
;     731     		{
;     732     		bB_=0;
	CLT
	BLD  R3,0
;     733     		}	
;     734 	
;     735  	if(adc_data>10)
_0x77:
	RCALL SUBOPT_0x12
	BRSH _0x7A
;     736 		{
;     737 		bankB+=adc_data;
	LDS  R30,_adc_data
	LDS  R31,_adc_data+1
	__ADDWRR 12,13,30,31
;     738 		pcnt[1]=10;
	LDI  R30,LOW(10)
	__PUTB1MN _pcnt,1
;     739 		bB=1;
	SET
	BLD  R3,3
;     740 		}
;     741 	else if((adc_data<=30)&&bB)
	RJMP _0x7B
_0x7A:
	RCALL SUBOPT_0x1D
	BRLO _0x7D
	SBRC R3,3
	RJMP _0x7E
_0x7D:
	RJMP _0x7C
_0x7E:
;     742 		{
;     743 		bB=0;
	CLT
	BLD  R3,3
;     744 		adc_bankU[1,adc_cntB]=bankB/10;
	__POINTW2MN _adc_bankU,50
	LDS  R30,_adc_cntB
	RCALL SUBOPT_0x6
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	__GETW2R 12,13
	RCALL SUBOPT_0x14
	POP  R26
	POP  R27
	RCALL __PUTWP1
;     745 		bankB=0;
	CLR  R12
	CLR  R13
;     746 		if(++adc_cntB>=25) 
	LDS  R26,_adc_cntB
	SUBI R26,-LOW(1)
	STS  _adc_cntB,R26
	CPI  R26,LOW(0x19)
	BRLO _0x7F
;     747 			{
;     748 			char i;
;     749 			adc_cntB=0;
	RCALL SUBOPT_0x15
;	i -> Y+0
	STS  _adc_cntB,R30
;     750 			adc_bankU_[1]=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _adc_bankU_,2
;     751 			for(i=0;i<25;i++)
	RCALL SUBOPT_0x16
_0x81:
	RCALL SUBOPT_0x17
	BRSH _0x82
;     752 				{
;     753 				adc_bankU_[1]+=adc_bankU[1,i];
	__POINTW2MN _adc_bankU_,2
	PUSH R27
	PUSH R26
	RCALL __GETW1P
	PUSH R31
	PUSH R30
	__POINTW2MN _adc_bankU,50
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x7
	POP  R26
	POP  R27
	ADD  R30,R26
	ADC  R31,R27
	POP  R26
	POP  R27
	RCALL __PUTWP1
;     754 				}
	RCALL SUBOPT_0x18
	RJMP _0x81
_0x82:
;     755 			adc_bankU_[1]/=25;	
	__POINTW2MN _adc_bankU_,2
	PUSH R27
	PUSH R26
	RCALL SUBOPT_0x19
	POP  R26
	POP  R27
	RCALL SUBOPT_0x1A
;     756 			}	
;     757 		}	
_0x7F:
;     758 	} 
_0x7C:
_0x7B:
;     759 		
;     760 if(input_index==0)
_0x6D:
	LDS  R30,_input_index_S12
	CPI  R30,0
	BREQ PC+2
	RJMP _0x83
;     761 	{
;     762 	if((adc_data>100)&&!bC_)
	RCALL SUBOPT_0xF
	BRSH _0x85
	SBRS R3,1
	RJMP _0x86
_0x85:
	RJMP _0x84
_0x86:
;     763     			{
;     764     			bC_=1;
	SET
	BLD  R3,1
;     765     			cnt_x=0;
	LDI  R30,LOW(0)
	STS  _cnt_x,R30
;     766     			}
;     767     		if((adc_data<100)&&bC_)
_0x84:
	RCALL SUBOPT_0x11
	BRSH _0x88
	SBRC R3,1
	RJMP _0x89
_0x88:
	RJMP _0x87
_0x89:
;     768     			{
;     769     			bC_=0;
	CLT
	BLD  R3,1
;     770     			}	
;     771 	
;     772 	if(adc_data>30)
_0x87:
	RCALL SUBOPT_0x1D
	BRSH _0x8A
;     773 		{
;     774 		bankC+=adc_data;
	LDS  R30,_adc_data
	LDS  R31,_adc_data+1
	LDS  R26,_bankC
	LDS  R27,_bankC+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _bankC,R30
	STS  _bankC+1,R31
;     775 		pcnt[2]=10;
	LDI  R30,LOW(10)
	__PUTB1MN _pcnt,2
;     776 		bC=1;
	SET
	BLD  R3,4
;     777 		}
;     778 	else if((adc_data<=30)&&bC)
	RJMP _0x8B
_0x8A:
	RCALL SUBOPT_0x1D
	BRLO _0x8D
	SBRC R3,4
	RJMP _0x8E
_0x8D:
	RJMP _0x8C
_0x8E:
;     779 		{
;     780 		bC=0;
	CLT
	BLD  R3,4
;     781 		adc_bankU[2,adc_cntC]=bankC/10;
	__POINTW2MN _adc_bankU,100
	LDS  R30,_adc_cntC
	RCALL SUBOPT_0x6
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDS  R26,_bankC
	LDS  R27,_bankC+1
	RCALL SUBOPT_0x14
	POP  R26
	POP  R27
	RCALL __PUTWP1
;     782 		bankC=0;
	LDI  R30,0
	STS  _bankC,R30
	STS  _bankC+1,R30
;     783 		if(++adc_cntC>=25) 
	LDS  R26,_adc_cntC
	SUBI R26,-LOW(1)
	STS  _adc_cntC,R26
	CPI  R26,LOW(0x19)
	BRLO _0x8F
;     784 			{
;     785 			char i;
;     786 			adc_cntC=0;
	RCALL SUBOPT_0x15
;	i -> Y+0
	STS  _adc_cntC,R30
;     787 			adc_bankU_[2]=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _adc_bankU_,4
;     788 			for(i=0;i<25;i++)
	RCALL SUBOPT_0x16
_0x91:
	RCALL SUBOPT_0x17
	BRSH _0x92
;     789 				{
;     790 				adc_bankU_[2]+=adc_bankU[2,i];
	__POINTW2MN _adc_bankU_,4
	PUSH R27
	PUSH R26
	RCALL __GETW1P
	PUSH R31
	PUSH R30
	__POINTW2MN _adc_bankU,100
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x7
	POP  R26
	POP  R27
	ADD  R30,R26
	ADC  R31,R27
	POP  R26
	POP  R27
	RCALL __PUTWP1
;     791 				}
	RCALL SUBOPT_0x18
	RJMP _0x91
_0x92:
;     792 			adc_bankU_[2]/=25;	
	__POINTW2MN _adc_bankU_,4
	PUSH R27
	PUSH R26
	RCALL SUBOPT_0x19
	POP  R26
	POP  R27
	RCALL SUBOPT_0x1A
;     793 			}	
;     794 		}	
_0x8F:
;     795 	}
_0x8C:
_0x8B:
;     796 
;     797 #asm("sei")
_0x83:
	sei
;     798 }
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
;     799 
;     800 //===============================================
;     801 //===============================================
;     802 //===============================================
;     803 //===============================================
;     804 void main(void)
;     805 {
_main:
;     806 /*PORTC=0;
;     807 DDRC&=0xFE;*/
;     808 #ifdef DEBUG
;     809 UCSRA=0x02;
;     810 UCSRB=0xD8;
;     811 UCSRC=0x86;
;     812 UBRRH=0x00;
;     813 UBRRL=0x18; 
;     814 #endif
;     815 /*
;     816 #ifdef RELEASE
;     817 UCSRA=0x00;
;     818 UCSRB=0xD0;
;     819 UCSRC=0x00;
;     820 UBRRH=0x00;
;     821 UBRRL=0x00; 
;     822 #endif
;     823 */
;     824 #ifdef DEBUG
;     825 PORTB=0x00;
;     826 DDRB=0xB0;
;     827 DDRB|=0b00101100;
;     828 
;     829 PORTC=0x00;
;     830 DDRC=0x00;
;     831 
;     832 PORTD=0x00;
;     833 DDRD=0x02;
;     834 #endif 
;     835 
;     836 #ifdef RELEASE
;     837 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;     838 DDRC=0x00;
	OUT  0x14,R30
;     839 
;     840 PORTD=0x00;
	OUT  0x12,R30
;     841 DDRD=0x02;
	LDI  R30,LOW(2)
	OUT  0x11,R30
;     842 #endif 
;     843 
;     844 ASSR=0;
	LDI  R30,LOW(0)
	OUT  0x22,R30
;     845 OCR2=0;
	OUT  0x23,R30
;     846 
;     847 // ADC initialization
;     848 
;     849 ADMUX=0b01000011;
	LDI  R30,LOW(67)
	OUT  0x7,R30
;     850 ADCSRA=0xCC;
	LDI  R30,LOW(204)
	OUT  0x6,R30
;     851 
;     852 t0_init();
	RCALL _t0_init
;     853 t2_init(); 
	RCALL _t2_init
;     854 del_init();
	RCALL _del_init
;     855 #asm("sei")
	sei
;     856 
;     857 bCHER_=0;
	CLT
	BLD  R3,7
;     858 ind=iMn;
	RCALL SUBOPT_0xC
;     859 
;     860 while (1)
_0x93:
;     861 	{
;     862 #ifdef DEBUG
;     863 	UART_IN();
;     864 #endif
;     865 	if(b100Hz)
	SBRS R2,1
	RJMP _0x96
;     866 		{
;     867 		b100Hz=0;
	CLT
	BLD  R2,1
;     868 
;     869 		but_drv();
	RCALL _but_drv
;     870 		but_an();
	RCALL _but_an
;     871 		pcnt_hndl();
	RCALL _pcnt_hndl
;     872 		}   
;     873 	if(b10Hz)
_0x96:
	SBRS R2,2
	RJMP _0x97
;     874 		{
;     875 		b10Hz=0;
	CLT
	BLD  R2,2
;     876 		ind_hndl();
	RCALL _ind_hndl
;     877  //	DDRD^=0x07;
;     878   //	PORTD&=0xf8;
;     879 	 	out_out();
	RCALL _out_out
;     880 		}
;     881 	if(b5Hz)
_0x97:
	SBRS R2,3
	RJMP _0x98
;     882 		{
;     883 		b5Hz=0;
	CLT
	BLD  R2,3
;     884 	  	per_drv();
	RCALL _per_drv
;     885 	  	nn_drv();
	RCALL _nn_drv
;     886 
;     887 	  	
;     888 #ifdef DEBUG
;     889 		OUT_adr(adc_bankU_,10);
;     890 #endif
;     891 		//OUT(3,adc_data,0,0,4,5,6);
;     892 		deltas=delta;
	LDI  R26,LOW(_delta)
	LDI  R27,HIGH(_delta)
	RCALL __EEPROMRDB
	STS  _deltas,R30
;     893 #ifdef DEBUG
;     894 		if(bCHER_) flags|=0x10;
;     895 		else flags&=0xef;
;     896 
;     897 		if(!LED_NET) flags|=0x20;
;     898 		else flags&=0xdf;
;     899 		
;     900 		if(!LED_DEL) flags|=0x40;
;     901 		else flags&=0xbf;
;     902 		
;     903 		if(!LED_PER) flags|=0x80;
;     904 		else flags&=0x7f;
;     905 #endif								
;     906 		}
;     907 	if(b2Hz)
_0x98:
	SBRS R2,4
	RJMP _0x99
;     908 		{
;     909 		b2Hz=0;
	CLT
	BLD  R2,4
;     910 		
;     911 //		DDRB|=0x07;
;     912  //        PORTB^=0x07;
;     913 
;     914 		}		 
;     915     	if(b1Hz)
_0x99:
	SBRS R2,5
	RJMP _0x9A
;     916 		{
;     917 		b1Hz=0;
	CLT
	BLD  R2,5
;     918 		del_hndl();
	RCALL _del_hndl
;     919 		per_hndl();
	RCALL _per_hndl
;     920 		nn_hndl();  
	RCALL _nn_hndl
;     921          	//OUT(6,1,2,3,4,5,6);
;     922 		 
;     923 		}
;     924      #asm("wdr")	
_0x9A:
	wdr
;     925 	}
	RJMP _0x93
;     926 }
_0x9B:
	RJMP _0x9B

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x0:
	LDS  R30,_del_cnt
	LDS  R31,_del_cnt+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	LDS  R30,_ind
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2:
	LDS  R26,_ind
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3:
	LDS  R26,_adc_bankU_
	LDS  R27,_adc_bankU_+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4:
	LDS  R26,_adc_bankU_
	LDS  R27,_adc_bankU_+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5:
	MOV  R30,R16
	LDI  R26,LOW(_adc_bankU_)
	LDI  R27,HIGH(_adc_bankU_)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES
SUBOPT_0x6:
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x7:
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x8:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x9:
	LDS  R30,_pcnt
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xA:
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _adc_bankU_,R30
	STS  _adc_bankU_+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xC:
	LDI  R30,LOW(0)
	STS  _ind,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xF:
	LDS  R26,_adc_data
	LDS  R27,_adc_data+1
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10:
	LDS  R30,_cnt_x
	SUBI R30,-LOW(1)
	STS  _cnt_x,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x11:
	LDS  R26,_adc_data
	LDS  R27,_adc_data+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x12:
	LDS  R26,_adc_data
	LDS  R27,_adc_data+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x13:
	LDI  R26,LOW(_adc_bankU)
	LDI  R27,HIGH(_adc_bankU)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x14:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x15:
	SBIW R28,1
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x16:
	LDI  R30,LOW(0)
	ST   Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x17:
	LD   R26,Y
	CPI  R26,LOW(0x19)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x18:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x19:
	RCALL __GETW1P
	MOVW R26,R30
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	RCALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x1A:
	RCALL __PUTWP1
	ADIW R28,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1B:
	LDS  R26,_cher_cnt
	LDS  R27,_cher_cnt+1
	CPI  R26,LOW(0x32)
	LDI  R30,HIGH(0x32)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1C:
	LDS  R30,_cher_cnt
	LDS  R31,_cher_cnt+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x1D:
	LDS  R26,_adc_data
	LDS  R27,_adc_data+1
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1E:
	LD   R30,Y
	RJMP SUBOPT_0x6

__ANEGD1:
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
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

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R19
	CLR  R20
	LDI  R21,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R19
	ROL  R20
	SUB  R0,R30
	SBC  R1,R31
	SBC  R19,R22
	SBC  R20,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R19,R22
	ADC  R20,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R21
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOV  R24,R19
	MOV  R25,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
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
	OUT  EEARH,R27
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
	OUT  EEARH,R27
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

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

