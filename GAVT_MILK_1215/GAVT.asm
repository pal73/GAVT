;CodeVisionAVR C Compiler V1.24.1d Standard
;(C) Copyright 1998-2004 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.ro
;e-mail:office@hpinfotech.ro

;Chip type           : ATmega16
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

	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_adc_noise_red=0x10
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0

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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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

	.INCLUDE "GAVT.vec"
	.INCLUDE "GAVT.inc"

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

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160
;       1 #define LED_POW_ON	5
;       2 #define LED_MAIN_LOOP	1
;       3 
;       4 #define LED_NAPOLN	2 
;       5 #define LED_PAYKA	3
;       6 #define LED_ERROR	0 
;       7 #define LED_WRK	6
;       8 #define LED_LOOP_AUTO	7
;       9 #define LED_PROG4	1
;      10 #define LED_PROG2	2
;      11 #define LED_PROG3	3
;      12 #define LED_PROG1	4 
;      13 #define MAXPROG	1
;      14 
;      15 
;      16 #define SW1	6
;      17 #define SW2	7
;      18 
;      19 #define PP1	6
;      20 #define PP2	7
;      21 
;      22 
;      23 bit b600Hz;
;      24 
;      25 bit b100Hz;
;      26 bit b10Hz;
;      27 char t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3;
;      28 char ind_cnt;
;      29 flash char IND_STROB[]={0b10111111,0b11011111,0b11101111,0b11110111,0b01111111};

	.CSEG
;      30 flash char DIGISYM[]={0b11000000,0b11111001,0b10100100,0b10110000,0b10011001,0b10010010,0b10000010,0b11111000,0b10000000,0b10010000,0b11111111};								
;      31 
;      32 char ind_out[5]={0x255,0x255,0x255,0x255,0x255};

	.DSEG
_ind_out:
	.BYTE 0x5
;      33 char dig[4];
_dig:
	.BYTE 0x4
;      34 bit bZ;    
;      35 char but;
;      36 static char but_n;
_but_n_G1:
	.BYTE 0x1
;      37 static char but_s;
_but_s_G1:
	.BYTE 0x1
;      38 static char but0_cnt;
_but0_cnt_G1:
	.BYTE 0x1
;      39 static char but1_cnt;
_but1_cnt_G1:
	.BYTE 0x1
;      40 static char but_onL_temp;
_but_onL_temp_G1:
	.BYTE 0x1
;      41 bit l_but;		//идет длинное нажатие на кнопку
;      42 bit n_but;          //произошло нажатие
;      43 bit speed;		//разрешение ускорения перебора 
;      44 bit bFL2; 
;      45 bit bFL5;
;      46 eeprom enum{elmAUTO=0x55,elmMNL=0xaa}ee_loop_mode;

	.ESEG
_ee_loop_mode:
	.DB  0x0
;      47 //eeprom char ee_program[2];
;      48 eeprom enum {p1=1,p2=2,p3=3,p4=4}ee_prog;
_ee_prog:
	.DB  0x0
;      49 enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}step=sOFF;
;      50 enum {iMn,iPr_sel,iSet} ind;
;      51 char sub_ind;
;      52 char in_word,in_word_old,in_word_new,in_word_cnt;

	.DSEG
_in_word:
	.BYTE 0x1
_in_word_old:
	.BYTE 0x1
_in_word_new:
	.BYTE 0x1
_in_word_cnt:
	.BYTE 0x1
;      53 bit bERR;
;      54 signed int cnt_del=0;
_cnt_del:
	.BYTE 0x2
;      55 
;      56 bit bSW1,bSW2;
;      57 
;      58 char cnt_sw1,cnt_sw2;
_cnt_sw1:
	.BYTE 0x1
_cnt_sw2:
	.BYTE 0x1
;      59 
;      60 //eeprom unsigned ee_delay[4,2];
;      61 //eeprom char ee_vr_log;
;      62 #include <mega16.h>
;      63 //#include <mega8535.h>  
;      64 
;      65 bit bPP1,bPP2,bPP3,bPP4,bPP5,bPP6,bPP7,bPP8;
;      66 
;      67 enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}payka_step=sOFF,napoln_step=sOFF,orient_step=sOFF,main_loop_step=sOFF;
_payka_step:
	.BYTE 0x1
_napoln_step:
	.BYTE 0x1
_orient_step:
	.BYTE 0x1
_main_loop_step:
	.BYTE 0x1
;      68 enum{cmdOFF=0,cmdSTART,cmdSTOP}payka_cmd=cmdOFF,napoln_cmd=cmdOFF,orient_cmd=cmdOFF,main_loop_cmd=cmdOFF;
_payka_cmd:
	.BYTE 0x1
_napoln_cmd:
	.BYTE 0x1
_orient_cmd:
	.BYTE 0x1
_main_loop_cmd:
	.BYTE 0x1
;      69 signed short payka_cnt_del,napoln_cnt_del,orient_cnt_del,main_loop_cnt_del;
_payka_cnt_del:
	.BYTE 0x2
_napoln_cnt_del:
	.BYTE 0x2
_orient_cnt_del:
	.BYTE 0x2
_main_loop_cnt_del:
	.BYTE 0x2
;      70 eeprom signed short ee_temp1,ee_temp2;

	.ESEG
_ee_temp1:
	.DW  0x0
_ee_temp2:
	.DW  0x0
;      71 
;      72 bit bPAYKA_COMPLETE=0,bNAPOLN_COMPLETE=0,bORIENT_COMPLETE=0;
;      73 
;      74 eeprom signed short ee_temp3,ee_temp4;
_ee_temp3:
	.DW  0x0
_ee_temp4:
	.DW  0x0
;      75 
;      76 #define EE_PROG_FULL		0
;      77 #define EE_PROG_ONLY_ORIENT 	1
;      78 #define EE_PROG_ONLY_NAPOLN	2
;      79 #define EE_PROG_ONLY_PAYKA	3
;      80 #define EE_PROG_ONLY_MAIN_LOOP 	4
;      81 
;      82 //-----------------------------------------------
;      83 void prog_drv(void)
;      84 {

	.CSEG
_prog_drv:
;      85 char temp,temp1,temp2;
;      86 
;      87 ///temp=ee_program[0];
;      88 ///temp1=ee_program[1];
;      89 ///temp2=ee_program[2];
;      90 
;      91 if((temp==temp1)&&(temp==temp2))
	CALL __SAVELOCR3
;	temp -> R16
;	temp1 -> R17
;	temp2 -> R18
	CP   R17,R16
	BRNE _0x5
	CP   R18,R16
	BREQ _0x6
_0x5:
	RJMP _0x4
_0x6:
;      92 	{
;      93 	}
;      94 else if((temp==temp1)&&(temp!=temp2))
	RJMP _0x7
_0x4:
	CP   R17,R16
	BRNE _0x9
	CP   R18,R16
	BRNE _0xA
_0x9:
	RJMP _0x8
_0xA:
;      95 	{
;      96 	temp2=temp;
	MOV  R18,R16
;      97 	}
;      98 else if((temp!=temp1)&&(temp==temp2))
	RJMP _0xB
_0x8:
	CP   R17,R16
	BREQ _0xD
	CP   R18,R16
	BREQ _0xE
_0xD:
	RJMP _0xC
_0xE:
;      99 	{
;     100 	temp1=temp;
	MOV  R17,R16
;     101 	}
;     102 else if((temp!=temp1)&&(temp1==temp2))
	RJMP _0xF
_0xC:
	CP   R17,R16
	BREQ _0x11
	CP   R18,R17
	BREQ _0x12
_0x11:
	RJMP _0x10
_0x12:
;     103 	{
;     104 	temp=temp1;
	MOV  R16,R17
;     105 	}
;     106 else if((temp!=temp1)&&(temp!=temp2))
	RJMP _0x13
_0x10:
	CP   R17,R16
	BREQ _0x15
	CP   R18,R16
	BRNE _0x16
_0x15:
_0x16:
;     107 	{
;     108 ////	temp=MINPROG;
;     109 ////	temp1=MINPROG;
;     110 ////	temp2=MINPROG;
;     111 	}
;     112 
;     113 ////if(!((temp<=MAXPROG)&&(temp>=MINPROG)))
;     114 ////	{
;     115 ////	temp=MINPROG;
;     116 ////	}
;     117 
;     118 ///if(temp!=ee_program[0])ee_program[0]=temp;
;     119 ///if(temp!=ee_program[1])ee_program[1]=temp;
;     120 ///if(temp!=ee_program[2])ee_program[2]=temp;
;     121 
;     122 
;     123 }
_0x13:
_0xF:
_0xB:
_0x7:
	CALL __LOADLOCR3
	RJMP _0x8F
;     124 
;     125 //-----------------------------------------------
;     126 void in_drv(void)
;     127 {
;     128 char i,temp;
;     129 unsigned int tempUI;
;     130 DDRA=0x00;
;	i -> R16
;	temp -> R17
;	tempUI -> R18,R19
;     131 PORTA=0xff;
;     132 in_word_new=PINA;
;     133 if(in_word_old==in_word_new)
;     134 	{
;     135 	if(in_word_cnt<10)
;     136 		{
;     137 		in_word_cnt++;
;     138 		if(in_word_cnt>=10)
;     139 			{
;     140 			in_word=in_word_old;
;     141 			}
;     142 		}
;     143 	}
;     144 else in_word_cnt=0;
;     145 
;     146 
;     147 in_word_old=in_word_new;
;     148 }   
;     149 
;     150 //-----------------------------------------------
;     151 void err_drv(void)
;     152 {
_err_drv:
;     153 if(ee_prog==p1)	
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x1B
;     154 	{
;     155      if(bSW1^bSW2) bERR=1;
	LDI  R30,0
	SBRC R3,2
	LDI  R30,1
	PUSH R30
	LDI  R30,0
	SBRC R3,3
	LDI  R30,1
	POP  R26
	EOR  R30,R26
	BREQ _0x1C
	SET
	BLD  R3,1
;     156  	else bERR=0;
	RJMP _0x1D
_0x1C:
	CLT
	BLD  R3,1
_0x1D:
;     157 	}
;     158 else bERR=0;
	RJMP _0x1E
_0x1B:
	CLT
	BLD  R3,1
_0x1E:
;     159 }
	RET
;     160   
;     161 
;     162 //-----------------------------------------------
;     163 void in_an(void)
;     164 {
_in_an:
;     165 DDRA=0x00;
	CALL SUBOPT_0x0
;     166 PORTA=0xff;
	OUT  0x1B,R30
;     167 in_word=PINA;
	IN   R30,0x19
	STS  _in_word,R30
;     168 
;     169 if(!(in_word&(1<<SW1)))
	ANDI R30,LOW(0x40)
	BRNE _0x1F
;     170 	{
;     171 	if(cnt_sw1<10)
	LDS  R26,_cnt_sw1
	CPI  R26,LOW(0xA)
	BRSH _0x20
;     172 		{
;     173 		cnt_sw1++;
	LDS  R30,_cnt_sw1
	SUBI R30,-LOW(1)
	STS  _cnt_sw1,R30
;     174 		if(cnt_sw1==10) bSW1=1;
	LDS  R26,_cnt_sw1
	CPI  R26,LOW(0xA)
	BRNE _0x21
	SET
	BLD  R3,2
;     175 		}
_0x21:
;     176 
;     177 	}
_0x20:
;     178 else
	RJMP _0x22
_0x1F:
;     179 	{
;     180 	if(cnt_sw1)
	LDS  R30,_cnt_sw1
	CPI  R30,0
	BREQ _0x23
;     181 		{
;     182 		cnt_sw1--;
	SUBI R30,LOW(1)
	STS  _cnt_sw1,R30
;     183 		if(cnt_sw1==0) bSW1=0;
	CPI  R30,0
	BRNE _0x24
	CLT
	BLD  R3,2
;     184 		}
_0x24:
;     185 
;     186 	}
_0x23:
_0x22:
;     187 
;     188 if(!(in_word&(1<<SW2)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x80)
	BRNE _0x25
;     189 	{
;     190 	if(cnt_sw2<10)
	LDS  R26,_cnt_sw2
	CPI  R26,LOW(0xA)
	BRSH _0x26
;     191 		{
;     192 		cnt_sw2++;
	LDS  R30,_cnt_sw2
	SUBI R30,-LOW(1)
	STS  _cnt_sw2,R30
;     193 		if(cnt_sw2==10) bSW2=1;
	LDS  R26,_cnt_sw2
	CPI  R26,LOW(0xA)
	BRNE _0x27
	SET
	BLD  R3,3
;     194 		}
_0x27:
;     195 
;     196 	}
_0x26:
;     197 else
	RJMP _0x28
_0x25:
;     198 	{
;     199 	if(cnt_sw2)
	LDS  R30,_cnt_sw2
	CPI  R30,0
	BREQ _0x29
;     200 		{
;     201 		cnt_sw2--;
	SUBI R30,LOW(1)
	STS  _cnt_sw2,R30
;     202 		if(cnt_sw2==0) bSW2=0;
	CPI  R30,0
	BRNE _0x2A
	CLT
	BLD  R3,3
;     203 		}
_0x2A:
;     204 
;     205 	}
_0x29:
_0x28:
;     206 
;     207 
;     208 } 
	RET
;     209 
;     210 //-----------------------------------------------
;     211 void main_loop_hndl(void)
;     212 {
_main_loop_hndl:
;     213 	 
;     214 }
	RET
;     215 
;     216 
;     217 
;     218 //-----------------------------------------------
;     219 void out_drv(void)
;     220 {
_out_drv:
;     221 char temp=0;
;     222 DDRB=0xFF;
	ST   -Y,R16
;	temp -> R16
	LDI  R16,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     223 
;     224 if(bPP1) temp|=(1<<PP1);
	SBRS R3,4
	RJMP _0x2B
	ORI  R16,LOW(64)
;     225 if(bPP2) temp|=(1<<PP2);
_0x2B:
	SBRS R3,5
	RJMP _0x2C
	ORI  R16,LOW(128)
;     226 
;     227 PORTB=~temp;
_0x2C:
	CALL SUBOPT_0x1
;     228 //PORTB=0x55;
;     229 }
	RJMP _0x90
;     230 
;     231 //-----------------------------------------------
;     232 void step_contr(void)
;     233 {
_step_contr:
;     234 char temp=0;
;     235 DDRB=0xFF;
	ST   -Y,R16
;	temp -> R16
	LDI  R16,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     236 
;     237 if(ee_prog==p1)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x2D
;     238 	{
;     239      if(bSW1&&bSW2)step=s1;
	SBRS R3,2
	RJMP _0x2F
	SBRC R3,3
	RJMP _0x30
_0x2F:
	RJMP _0x2E
_0x30:
	LDI  R30,LOW(1)
	MOV  R12,R30
;     240      else step=sOFF;
	RJMP _0x31
_0x2E:
	CLR  R12
_0x31:
;     241 	}
;     242 
;     243 else if(ee_prog==p2)  //ско
	RJMP _0x32
_0x2D:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BREQ _0x34
;     244 	{
;     245 
;     246 	}
;     247 
;     248 else if(ee_prog==p3)   //твист
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x3)
	BREQ _0x36
;     249 	{
;     250 
;     251 	}
;     252 
;     253 else if(ee_prog==p4)      //замок
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x4)
	BRNE _0x37
;     254 	{
;     255 	}
;     256 	
;     257 step_contr_end:
_0x37:
_0x36:
_0x34:
_0x32:
;     258 
;     259 //if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;     260 
;     261 PORTB=~temp;
	CALL SUBOPT_0x1
;     262 //PORTB=0x55;
;     263 }
_0x90:
	LD   R16,Y+
	RET
;     264 
;     265 
;     266 //-----------------------------------------------
;     267 void bin2bcd_int(unsigned int in)
;     268 {
_bin2bcd_int:
;     269 char i;
;     270 for(i=3;i>0;i--)
	ST   -Y,R16
;	in -> Y+1
;	i -> R16
	LDI  R16,LOW(3)
_0x3A:
	LDI  R30,LOW(0)
	CP   R30,R16
	BRSH _0x3B
;     271 	{
;     272 	dig[i]=in%10;
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	PUSH R31
	PUSH R30
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	POP  R26
	POP  R27
	ST   X,R30
;     273 	in/=10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
;     274 	}   
	SUBI R16,1
	RJMP _0x3A
_0x3B:
;     275 }
	LDD  R16,Y+0
	RJMP _0x8F
;     276 
;     277 //-----------------------------------------------
;     278 void bcd2ind(char s)
;     279 {
_bcd2ind:
;     280 char i;
;     281 bZ=1;
	ST   -Y,R16
;	s -> Y+1
;	i -> R16
	SET
	BLD  R2,3
;     282 for (i=0;i<5;i++)
	LDI  R16,LOW(0)
_0x3D:
	CPI  R16,5
	BRLO PC+3
	JMP _0x3E
;     283 	{
;     284 	if(bZ&&(!dig[i-1])&&(i<4))
	SBRS R2,3
	RJMP _0x40
	CALL SUBOPT_0x2
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	CPI  R30,0
	BRNE _0x40
	CPI  R16,4
	BRLO _0x41
_0x40:
	RJMP _0x3F
_0x41:
;     285 		{
;     286 		if((4-i)>s)
	LDI  R30,LOW(4)
	SUB  R30,R16
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
	BRSH _0x42
;     287 			{
;     288 			ind_out[i-1]=DIGISYM[10];
	CALL SUBOPT_0x2
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	POP  R26
	POP  R27
	RJMP _0x91
;     289 			}
;     290 		else ind_out[i-1]=DIGISYM[0];	
_0x42:
	CALL SUBOPT_0x2
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	LPM  R30,Z
	POP  R26
	POP  R27
_0x91:
	ST   X,R30
;     291 		}
;     292 	else
	RJMP _0x44
_0x3F:
;     293 		{
;     294 		ind_out[i-1]=DIGISYM[dig[i-1]];
	CALL SUBOPT_0x2
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	POP  R26
	POP  R27
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	POP  R26
	POP  R27
	ST   X,R30
;     295 		bZ=0;
	CLT
	BLD  R2,3
;     296 		}                   
_0x44:
;     297 
;     298 	if(s)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x45
;     299 		{
;     300 		ind_out[3-s]&=0b01111111;
	LDD  R26,Y+1
	LDI  R30,LOW(3)
	SUB  R30,R26
	LDI  R31,0
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0x7F
	POP  R26
	POP  R27
	ST   X,R30
;     301 		}	
;     302  
;     303 	}
_0x45:
	SUBI R16,-1
	RJMP _0x3D
_0x3E:
;     304 }            
	LDD  R16,Y+0
	ADIW R28,2
	RET
;     305 //-----------------------------------------------
;     306 void int2ind(unsigned int in,char s)
;     307 {
_int2ind:
;     308 bin2bcd_int(in);
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _bin2bcd_int
;     309 bcd2ind(s);
	LD   R30,Y
	ST   -Y,R30
	CALL _bcd2ind
;     310 
;     311 } 
_0x8F:
	ADIW R28,3
	RET
;     312 
;     313 //-----------------------------------------------
;     314 void ind_hndl(void)
;     315 {
_ind_hndl:
;     316 if(ind==iMn)
	TST  R13
	BRNE _0x46
;     317 	{
;     318 	if(ee_prog==EE_PROG_FULL)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,0
	BREQ _0x48
;     319 		{
;     320 		}
;     321 	else if(ee_prog==EE_PROG_ONLY_ORIENT)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x49
;     322 		{
;     323 		int2ind(orient_step,0);
	LDS  R30,_orient_step
	CALL SUBOPT_0x3
;     324 		}
;     325 	else if(ee_prog==EE_PROG_ONLY_NAPOLN)
	RJMP _0x4A
_0x49:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BRNE _0x4B
;     326 		{
;     327 		int2ind(napoln_step,0);                              
	LDS  R30,_napoln_step
	CALL SUBOPT_0x3
;     328 		}			                
;     329 	else if(ee_prog==EE_PROG_ONLY_PAYKA)
	RJMP _0x4C
_0x4B:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x3)
	BRNE _0x4D
;     330 		{
;     331 		int2ind(payka_step,0);
	LDS  R30,_payka_step
	CALL SUBOPT_0x3
;     332 		}
;     333 	else if(ee_prog==EE_PROG_ONLY_MAIN_LOOP)
	RJMP _0x4E
_0x4D:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x4)
	BRNE _0x4F
;     334 		{
;     335 		int2ind(main_loop_step,0);
	LDS  R30,_main_loop_step
	CALL SUBOPT_0x3
;     336 		}			
;     337 	
;     338 	//int2ind(bDM,0);
;     339 	//int2ind(in_word,0);
;     340 	//int2ind(cnt_dm,0);
;     341 	
;     342 	//int2ind(bDM,0);
;     343 	//int2ind(ee_delay[prog,sub_ind],1);  
;     344 	//ind_out[0]=0xff;//DIGISYM[0];
;     345 	//ind_out[1]=0xff;//DIGISYM[1];
;     346 	//ind_out[2]=DIGISYM[2];//0xff;
;     347 	//ind_out[0]=DIGISYM[7]; 
;     348 
;     349 	//ind_out[0]=DIGISYM[sub_ind+1];
;     350 	}
_0x4F:
_0x4E:
_0x4C:
_0x4A:
_0x48:
;     351 else if(ind==iSet)
	RJMP _0x50
_0x46:
	LDI  R30,LOW(2)
	CP   R30,R13
	BREQ PC+3
	JMP _0x51
;     352 	{
;     353      if(sub_ind==0)int2ind(ee_prog,0);
	TST  R14
	BRNE _0x52
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CALL SUBOPT_0x3
;     354 	else if(sub_ind==1)int2ind(ee_temp1,1);
	RJMP _0x53
_0x52:
	LDI  R30,LOW(1)
	CP   R30,R14
	BRNE _0x54
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	CALL SUBOPT_0x4
;     355 	else if(sub_ind==2)int2ind(ee_temp2,1);
	RJMP _0x55
_0x54:
	LDI  R30,LOW(2)
	CP   R30,R14
	BRNE _0x56
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	CALL SUBOPT_0x4
;     356 	else if(sub_ind==3)int2ind(ee_temp3,1);
	RJMP _0x57
_0x56:
	LDI  R30,LOW(3)
	CP   R30,R14
	BRNE _0x58
	LDI  R26,LOW(_ee_temp3)
	LDI  R27,HIGH(_ee_temp3)
	CALL __EEPROMRDW
	CALL SUBOPT_0x4
;     357 	else if(sub_ind==4)int2ind(ee_temp4,1);
	RJMP _0x59
_0x58:
	LDI  R30,LOW(4)
	CP   R30,R14
	BRNE _0x5A
	LDI  R26,LOW(_ee_temp4)
	LDI  R27,HIGH(_ee_temp4)
	CALL __EEPROMRDW
	CALL SUBOPT_0x4
;     358 		
;     359 	if(bFL5)ind_out[0]=DIGISYM[sub_ind+1];
_0x5A:
_0x59:
_0x57:
_0x55:
_0x53:
	SBRS R3,0
	RJMP _0x5B
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	PUSH R31
	PUSH R30
	MOV  R30,R14
	SUBI R30,-LOW(1)
	POP  R26
	POP  R27
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RJMP _0x92
;     360 	else    ind_out[0]=DIGISYM[10];
_0x5B:
	__POINTW1FN _DIGISYM,10
_0x92:
	LPM  R30,Z
	STS  _ind_out,R30
;     361 	}
;     362 }
_0x51:
_0x50:
	RET
;     363 
;     364 //-----------------------------------------------
;     365 void led_hndl(void)
;     366 {
_led_hndl:
;     367 ind_out[4]=DIGISYM[10]; 
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	__PUTB1MN _ind_out,4
;     368 
;     369 ind_out[4]&=~(1<<LED_POW_ON); 
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xDF
	POP  R26
	POP  R27
	ST   X,R30
;     370 
;     371 if(step!=sOFF)
	TST  R12
	BREQ _0x5D
;     372 	{
;     373 	ind_out[4]&=~(1<<LED_WRK);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xBF
	POP  R26
	POP  R27
	RJMP _0x93
;     374 	}
;     375 else ind_out[4]|=(1<<LED_WRK);
_0x5D:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x40
	POP  R26
	POP  R27
_0x93:
	ST   X,R30
;     376 
;     377 
;     378 if(step==sOFF)
	TST  R12
	BRNE _0x5F
;     379 	{
;     380  	if(bERR)
	SBRS R3,1
	RJMP _0x60
;     381 		{
;     382 		ind_out[4]&=~(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFE
	POP  R26
	POP  R27
	RJMP _0x94
;     383 		}
;     384 	else
_0x60:
;     385 		{
;     386 		ind_out[4]|=(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
_0x94:
	ST   X,R30
;     387 		}
;     388      }
;     389 else ind_out[4]|=(1<<LED_ERROR);
	RJMP _0x62
_0x5F:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
	ST   X,R30
_0x62:
;     390 
;     391 /* 	if(bMD1)
;     392 		{
;     393 		ind_out[4]&=~(1<<LED_ERROR);
;     394 		}
;     395 	else
;     396 		{
;     397 		ind_out[4]|=(1<<LED_ERROR);
;     398 		} */
;     399 
;     400 //if(bERR)ind_out[4]&=~(1<<LED_ERROR);
;     401 ind_out[4]|=(1<<LED_LOOP_AUTO);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x80
	POP  R26
	POP  R27
	ST   X,R30
;     402 
;     403 /*if(prog==p1) ind_out[4]&=~(1<<LED_PROG1);
;     404 else if(prog==p2) ind_out[4]&=~(1<<LED_PROG2);
;     405 else if(prog==p3) ind_out[4]&=~(1<<LED_PROG3);
;     406 else if(prog==p4) ind_out[4]&=~(1<<LED_PROG4); */
;     407 
;     408 /*if(ind==iPr_sel)
;     409 	{
;     410 	if(bFL5)ind_out[4]|=(1<<LED_PROG1)|(1<<LED_PROG2)|(1<<LED_PROG3)|(1<<LED_PROG4);
;     411 	}*/ 
;     412 	 
;     413 /*if(ind==iVr)
;     414 	{
;     415 	if(bFL5)ind_out[4]|=(1<<LED_POW_ON);
;     416 	} */
;     417 if(ee_prog==p1) ind_out[4]&=~(1<<LED_PROG1);
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x63
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xEF
	POP  R26
	POP  R27
	ST   X,R30
;     418 else if(ee_prog==p2) ind_out[4]&=~(1<<LED_PROG2);
	RJMP _0x64
_0x63:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BRNE _0x65
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFB
	POP  R26
	POP  R27
	ST   X,R30
;     419 else if(ee_prog==p3) ind_out[4]&=~(1<<LED_PROG3);
	RJMP _0x66
_0x65:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x3)
	BRNE _0x67
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0XF7
	POP  R26
	POP  R27
	ST   X,R30
;     420 else if(ee_prog==p4) ind_out[4]&=~(1<<LED_PROG4);	
	RJMP _0x68
_0x67:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x4)
	BRNE _0x69
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFD
	POP  R26
	POP  R27
	ST   X,R30
;     421 }
_0x69:
_0x68:
_0x66:
_0x64:
	RET
;     422 
;     423 //-----------------------------------------------
;     424 // Подпрограмма драйва до 7 кнопок одного порта, 
;     425 // различает короткое и длинное нажатие,
;     426 // срабатывает на отпускание кнопки, возможность
;     427 // ускорения перебора при длинном нажатии...
;     428 #define but_port PORTC
;     429 #define but_dir  DDRC
;     430 #define but_pin  PINC
;     431 #define but_mask 0b01101010
;     432 #define no_but   0b11111111
;     433 #define but_on   5
;     434 #define but_onL  20
;     435 
;     436 
;     437 
;     438 
;     439 void but_drv(void)
;     440 { 
_but_drv:
;     441 DDRD&=0b00000111;
	IN   R30,0x11
	ANDI R30,LOW(0x7)
	CALL SUBOPT_0x5
;     442 PORTD|=0b11111000;
;     443 
;     444 but_port|=(but_mask^0xff);
	CALL SUBOPT_0x6
;     445 but_dir&=but_mask;
;     446 #asm
;     447 nop
nop
;     448 nop
nop
;     449 nop
nop
;     450 nop
nop
;     451 #endasm

;     452 
;     453 but_n=but_pin|but_mask; 
	IN   R30,0x13
	ORI  R30,LOW(0x6A)
	STS  _but_n_G1,R30
;     454 
;     455 if((but_n==no_but)||(but_n!=but_s))
	LDS  R26,_but_n_G1
	CPI  R26,LOW(0xFF)
	BREQ _0x6B
	RCALL SUBOPT_0x7
	BREQ _0x6A
_0x6B:
;     456  	{
;     457  	speed=0;
	CLT
	BLD  R2,6
;     458    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRSH _0x6E
	LDS  R26,_but1_cnt_G1
	CPI  R26,LOW(0x0)
	BREQ _0x70
_0x6E:
	SBRS R2,4
	RJMP _0x71
_0x70:
	RJMP _0x6D
_0x71:
;     459   		{
;     460    	     n_but=1;
	SET
	BLD  R2,5
;     461           but=but_s;
	LDS  R11,_but_s_G1
;     462           }
;     463    	if (but1_cnt>=but_onL_temp)
_0x6D:
	RCALL SUBOPT_0x8
	BRLO _0x72
;     464   		{
;     465    	     n_but=1;
	SET
	BLD  R2,5
;     466           but=but_s&0b11111101;
	RCALL SUBOPT_0x9
;     467           }
;     468     	l_but=0;
_0x72:
	CLT
	BLD  R2,4
;     469    	but_onL_temp=but_onL;
	LDI  R30,LOW(20)
	STS  _but_onL_temp_G1,R30
;     470     	but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;     471   	but1_cnt=0;          
	STS  _but1_cnt_G1,R30
;     472      goto but_drv_out;
	RJMP _0x73
;     473   	}  
;     474   	
;     475 if(but_n==but_s)
_0x6A:
	RCALL SUBOPT_0x7
	BRNE _0x74
;     476  	{
;     477   	but0_cnt++;
	LDS  R30,_but0_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but0_cnt_G1,R30
;     478   	if(but0_cnt>=but_on)
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRLO _0x75
;     479   		{
;     480    		but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;     481    		but1_cnt++;
	LDS  R30,_but1_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but1_cnt_G1,R30
;     482    		if(but1_cnt>=but_onL_temp)
	RCALL SUBOPT_0x8
	BRLO _0x76
;     483    			{              
;     484     			but=but_s&0b11111101;
	RCALL SUBOPT_0x9
;     485     			but1_cnt=0;
	LDI  R30,LOW(0)
	STS  _but1_cnt_G1,R30
;     486     			n_but=1;
	SET
	BLD  R2,5
;     487     			l_but=1;
	SET
	BLD  R2,4
;     488 			if(speed)
	SBRS R2,6
	RJMP _0x77
;     489 				{
;     490     				but_onL_temp=but_onL_temp>>1;
	LDS  R30,_but_onL_temp_G1
	LSR  R30
	STS  _but_onL_temp_G1,R30
;     491         			if(but_onL_temp<=2) but_onL_temp=2;
	LDS  R26,_but_onL_temp_G1
	LDI  R30,LOW(2)
	CP   R30,R26
	BRLO _0x78
	STS  _but_onL_temp_G1,R30
;     492 				}    
_0x78:
;     493    			}
_0x77:
;     494   		} 
_0x76:
;     495  	}
_0x75:
;     496 but_drv_out:
_0x74:
_0x73:
;     497 but_s=but_n;
	LDS  R30,_but_n_G1
	STS  _but_s_G1,R30
;     498 but_port|=(but_mask^0xff);
	RCALL SUBOPT_0x6
;     499 but_dir&=but_mask;
;     500 }    
	RET
;     501 
;     502 #define butV	239
;     503 #define butV_	237
;     504 #define butP	251
;     505 #define butP_	249
;     506 #define butR	127
;     507 #define butR_	125
;     508 #define butL	254
;     509 #define butL_	252
;     510 #define butLR	126
;     511 #define butLR_	124 
;     512 #define butVP_ 233
;     513 //-----------------------------------------------
;     514 void but_an(void)
;     515 {
_but_an:
;     516 
;     517 if(ind==iMn)
	TST  R13
	BRNE _0x79
;     518 	{
;     519 	if(but==butP_)ind=iPr_sel;
	LDI  R30,LOW(249)
	CP   R30,R11
	BRNE _0x7A
	LDI  R30,LOW(1)
	MOV  R13,R30
;     520 	} 
_0x7A:
;     521 	
;     522 else if(ind==iPr_sel)
	RJMP _0x7B
_0x79:
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0x7C
;     523 	{
;     524 	if(but==butP_)ind=iMn;
	LDI  R30,LOW(249)
	CP   R30,R11
	BRNE _0x7D
	CLR  R13
;     525 	if(but==butP)
_0x7D:
	LDI  R30,LOW(251)
	CP   R30,R11
	BRNE _0x7E
;     526 		{
;     527 		ee_prog++;
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
;     528 		if(ee_prog>MAXPROG)ee_prog=p1;
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	MOV  R26,R30
	LDI  R30,LOW(1)
	CP   R30,R26
	BRGE _0x7F
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMWRB
;     529 		}
_0x7F:
;     530 	} 
_0x7E:
;     531 
;     532 but_an_end:
_0x7C:
_0x7B:
;     533 n_but=0;
	CLT
	BLD  R2,5
;     534 }
	RET
;     535 
;     536 //-----------------------------------------------
;     537 void ind_drv(void)
;     538 {
_ind_drv:
;     539 if(++ind_cnt>=6)ind_cnt=0;
	INC  R10
	LDI  R30,LOW(6)
	CP   R10,R30
	BRLO _0x81
	CLR  R10
;     540 
;     541 if(ind_cnt<5)
_0x81:
	LDI  R30,LOW(5)
	CP   R10,R30
	BRSH _0x82
;     542 	{
;     543 	DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
;     544 	PORTC=0xFF;
	OUT  0x15,R30
;     545 	DDRD|=0b11111000;
	IN   R30,0x11
	ORI  R30,LOW(0xF8)
	RCALL SUBOPT_0x5
;     546 	PORTD|=0b11111000;
;     547 	PORTD&=IND_STROB[ind_cnt];
	IN   R30,0x12
	PUSH R30
	LDI  R26,LOW(_IND_STROB*2)
	LDI  R27,HIGH(_IND_STROB*2)
	MOV  R30,R10
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	POP  R26
	AND  R30,R26
	OUT  0x12,R30
;     548 	PORTC=ind_out[ind_cnt];
	MOV  R30,R10
	LDI  R31,0
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	LD   R30,Z
	OUT  0x15,R30
;     549 	}
;     550 else but_drv();
	RJMP _0x83
_0x82:
	CALL _but_drv
_0x83:
;     551 }
	RET
;     552 
;     553 //***********************************************
;     554 //***********************************************
;     555 //***********************************************
;     556 //***********************************************
;     557 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;     558 {
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
;     559 TCCR0=0x02;
	RCALL SUBOPT_0xA
;     560 TCNT0=-208;
;     561 OCR0=0x00; 
;     562 
;     563 
;     564 b600Hz=1;
	SET
	BLD  R2,0
;     565 ind_drv();
	RCALL _ind_drv
;     566 if(++t0_cnt0>=6)
	INC  R6
	LDI  R30,LOW(6)
	CP   R6,R30
	BRLO _0x84
;     567 	{
;     568 	t0_cnt0=0;
	CLR  R6
;     569 	b100Hz=1;
	SET
	BLD  R2,1
;     570 	}
;     571 
;     572 if(++t0_cnt1>=60)
_0x84:
	INC  R7
	LDI  R30,LOW(60)
	CP   R7,R30
	BRLO _0x85
;     573 	{
;     574 	t0_cnt1=0;
	CLR  R7
;     575 	b10Hz=1;
	SET
	BLD  R2,2
;     576 	
;     577 	if(++t0_cnt2>=2)
	INC  R8
	LDI  R30,LOW(2)
	CP   R8,R30
	BRLO _0x86
;     578 		{
;     579 		t0_cnt2=0;
	CLR  R8
;     580 		bFL5=!bFL5;
	LDI  R30,LOW(1)
	EOR  R3,R30
;     581 		}
;     582 		
;     583 	if(++t0_cnt3>=5)
_0x86:
	INC  R9
	LDI  R30,LOW(5)
	CP   R9,R30
	BRLO _0x87
;     584 		{
;     585 		t0_cnt3=0;
	CLR  R9
;     586 		bFL2=!bFL2;
	LDI  R30,LOW(128)
	EOR  R2,R30
;     587 		}		
;     588 	}
_0x87:
;     589 }
_0x85:
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
;     590 
;     591 //===============================================
;     592 //===============================================
;     593 //===============================================
;     594 //===============================================
;     595 
;     596 void main(void)
;     597 {
_main:
;     598 
;     599 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
;     600 DDRA=0x00;
	RCALL SUBOPT_0x0
;     601 
;     602 PORTB=0xff;
	RCALL SUBOPT_0xB
;     603 DDRB=0xFF;
;     604 
;     605 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;     606 DDRC=0x00;
	OUT  0x14,R30
;     607 
;     608 
;     609 PORTD=0x00;
	OUT  0x12,R30
;     610 DDRD=0x00;
	OUT  0x11,R30
;     611 
;     612 
;     613 TCCR0=0x02;
	RCALL SUBOPT_0xA
;     614 TCNT0=-208;
;     615 OCR0=0x00;
;     616 
;     617 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;     618 TCCR1B=0x00;
	OUT  0x2E,R30
;     619 TCNT1H=0x00;
	OUT  0x2D,R30
;     620 TCNT1L=0x00;
	OUT  0x2C,R30
;     621 ICR1H=0x00;
	OUT  0x27,R30
;     622 ICR1L=0x00;
	OUT  0x26,R30
;     623 OCR1AH=0x00;
	OUT  0x2B,R30
;     624 OCR1AL=0x00;
	OUT  0x2A,R30
;     625 OCR1BH=0x00;
	OUT  0x29,R30
;     626 OCR1BL=0x00;
	OUT  0x28,R30
;     627 
;     628 
;     629 ASSR=0x00;
	OUT  0x22,R30
;     630 TCCR2=0x00;
	OUT  0x25,R30
;     631 TCNT2=0x00;
	OUT  0x24,R30
;     632 OCR2=0x00;
	OUT  0x23,R30
;     633 
;     634 MCUCR=0x00;
	OUT  0x35,R30
;     635 MCUCSR=0x00;
	OUT  0x34,R30
;     636 
;     637 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;     638 
;     639 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     640 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     641 
;     642 #asm("sei") 
	sei
;     643 PORTB=0xFF;
	LDI  R30,LOW(255)
	RCALL SUBOPT_0xB
;     644 DDRB=0xFF;
;     645 ind=iMn;
	CLR  R13
;     646 prog_drv();
	CALL _prog_drv
;     647 ind_hndl();
	CALL _ind_hndl
;     648 led_hndl();
	CALL _led_hndl
;     649 
;     650 
;     651 while (1)
_0x88:
;     652       {
;     653       if(b600Hz)
	SBRS R2,0
	RJMP _0x8B
;     654 		{
;     655 		b600Hz=0; 
	CLT
	BLD  R2,0
;     656           in_an();
	CALL _in_an
;     657           
;     658 		}         
;     659       if(b100Hz)
_0x8B:
	SBRS R2,1
	RJMP _0x8C
;     660 		{        
;     661 		b100Hz=0; 
	CLT
	BLD  R2,1
;     662 		but_an();
	RCALL _but_an
;     663 	    	//in_drv();
;     664           ind_hndl();
	CALL _ind_hndl
;     665           step_contr();
	CALL _step_contr
;     666           
;     667           main_loop_hndl();
	CALL _main_loop_hndl
;     668 
;     669           out_drv();
	CALL _out_drv
;     670 		}   
;     671 	if(b10Hz)
_0x8C:
	SBRS R2,2
	RJMP _0x8D
;     672 		{
;     673 		b10Hz=0;
	CLT
	BLD  R2,2
;     674 		prog_drv();
	CALL _prog_drv
;     675 		err_drv();
	CALL _err_drv
;     676 		
;     677     	     
;     678           led_hndl();
	CALL _led_hndl
;     679           
;     680           }
;     681 
;     682       };
_0x8D:
	RJMP _0x88
;     683 }
_0x8E:
	RJMP _0x8E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	LDI  R30,LOW(255)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	MOV  R30,R16
	COM  R30
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x2:
	MOV  R30,R16
	SUBI R30,LOW(1)
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x3:
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _int2ind

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _int2ind

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5:
	OUT  0x11,R30
	IN   R30,0x12
	ORI  R30,LOW(0xF8)
	OUT  0x12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6:
	IN   R30,0x15
	ORI  R30,LOW(0x95)
	OUT  0x15,R30
	IN   R30,0x14
	ANDI R30,LOW(0x6A)
	OUT  0x14,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7:
	LDS  R30,_but_s_G1
	LDS  R26,_but_n_G1
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8:
	LDS  R30,_but_onL_temp_G1
	LDS  R26,_but1_cnt_G1
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x9:
	LDS  R30,_but_s_G1
	ANDI R30,0xFD
	MOV  R11,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA:
	LDI  R30,LOW(2)
	OUT  0x33,R30
	LDI  R30,LOW(65328)
	LDI  R31,HIGH(65328)
	OUT  0x32,R30
	LDI  R30,LOW(0)
	OUT  0x3C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB:
	OUT  0x18,R30
	LDI  R30,LOW(255)
	OUT  0x17,R30
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

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

