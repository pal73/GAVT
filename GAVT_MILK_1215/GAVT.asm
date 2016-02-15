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
;      82 short time_cnt;

	.DSEG
_time_cnt:
	.BYTE 0x2
;      83 short adc_output;
_adc_output:
	.BYTE 0x2
;      84 
;      85 #define FIRST_ADC_INPUT 2
;      86 #define LAST_ADC_INPUT 2
;      87 unsigned int adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
_adc_data:
	.BYTE 0x2
;      88 #define ADC_VREF_TYPE 0x40
;      89 // ADC interrupt service routine
;      90 // with auto input scanning
;      91 
;      92 //-----------------------------------------------
;      93 void prog_drv(void)
;      94 {

	.CSEG
_prog_drv:
;      95 char temp,temp1,temp2;
;      96 
;      97 ///temp=ee_program[0];
;      98 ///temp1=ee_program[1];
;      99 ///temp2=ee_program[2];
;     100 
;     101 if((temp==temp1)&&(temp==temp2))
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
;     102 	{
;     103 	}
;     104 else if((temp==temp1)&&(temp!=temp2))
	RJMP _0x7
_0x4:
	CP   R17,R16
	BRNE _0x9
	CP   R18,R16
	BRNE _0xA
_0x9:
	RJMP _0x8
_0xA:
;     105 	{
;     106 	temp2=temp;
	MOV  R18,R16
;     107 	}
;     108 else if((temp!=temp1)&&(temp==temp2))
	RJMP _0xB
_0x8:
	CP   R17,R16
	BREQ _0xD
	CP   R18,R16
	BREQ _0xE
_0xD:
	RJMP _0xC
_0xE:
;     109 	{
;     110 	temp1=temp;
	MOV  R17,R16
;     111 	}
;     112 else if((temp!=temp1)&&(temp1==temp2))
	RJMP _0xF
_0xC:
	CP   R17,R16
	BREQ _0x11
	CP   R18,R17
	BREQ _0x12
_0x11:
	RJMP _0x10
_0x12:
;     113 	{
;     114 	temp=temp1;
	MOV  R16,R17
;     115 	}
;     116 else if((temp!=temp1)&&(temp!=temp2))
	RJMP _0x13
_0x10:
	CP   R17,R16
	BREQ _0x15
	CP   R18,R16
	BRNE _0x16
_0x15:
_0x16:
;     117 	{
;     118 ////	temp=MINPROG;
;     119 ////	temp1=MINPROG;
;     120 ////	temp2=MINPROG;
;     121 	}
;     122 
;     123 ////if(!((temp<=MAXPROG)&&(temp>=MINPROG)))
;     124 ////	{
;     125 ////	temp=MINPROG;
;     126 ////	}
;     127 
;     128 ///if(temp!=ee_program[0])ee_program[0]=temp;
;     129 ///if(temp!=ee_program[1])ee_program[1]=temp;
;     130 ///if(temp!=ee_program[2])ee_program[2]=temp;
;     131 
;     132 
;     133 }
_0x13:
_0xF:
_0xB:
_0x7:
	CALL __LOADLOCR3
	RJMP _0x98
;     134 
;     135 //-----------------------------------------------
;     136 void in_drv(void)
;     137 {
_in_drv:
;     138 char i,temp;
;     139 unsigned int tempUI;
;     140 DDRA=0x00;
	CALL __SAVELOCR4
;	i -> R16
;	temp -> R17
;	tempUI -> R18,R19
	CALL SUBOPT_0x0
;     141 PORTA=0xff;
;     142 in_word_new=PINA;
	STS  _in_word_new,R30
;     143 if(in_word_old==in_word_new)
	LDS  R26,_in_word_old
	CP   R30,R26
	BRNE _0x17
;     144 	{
;     145 	if(in_word_cnt<10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRSH _0x18
;     146 		{
;     147 		in_word_cnt++;
	LDS  R30,_in_word_cnt
	SUBI R30,-LOW(1)
	STS  _in_word_cnt,R30
;     148 		if(in_word_cnt>=10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRLO _0x19
;     149 			{
;     150 			in_word=in_word_old;
	LDS  R30,_in_word_old
	STS  _in_word,R30
;     151 			}
;     152 		}
_0x19:
;     153 	}
_0x18:
;     154 else in_word_cnt=0;
	RJMP _0x1A
_0x17:
	LDI  R30,LOW(0)
	STS  _in_word_cnt,R30
_0x1A:
;     155 
;     156 
;     157 in_word_old=in_word_new;
	LDS  R30,_in_word_new
	STS  _in_word_old,R30
;     158 }   
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;     159 
;     160 //-----------------------------------------------
;     161 void err_drv(void)
;     162 {
_err_drv:
;     163 if(ee_prog==p1)	
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x1B
;     164 	{
;     165      if(bSW1^bSW2) bERR=1;
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
;     166  	else bERR=0;
	RJMP _0x1D
_0x1C:
	CLT
	BLD  R3,1
_0x1D:
;     167 	}
;     168 else bERR=0;
	RJMP _0x1E
_0x1B:
	CLT
	BLD  R3,1
_0x1E:
;     169 }
	RET
;     170   
;     171 
;     172 //-----------------------------------------------
;     173 void in_an(void)
;     174 {
_in_an:
;     175 DDRA=0x00;
	CALL SUBOPT_0x0
;     176 PORTA=0xff;
;     177 in_word=PINA;
	STS  _in_word,R30
;     178 
;     179 if(!(in_word&(1<<SW1)))
	ANDI R30,LOW(0x40)
	BRNE _0x1F
;     180 	{
;     181 	if(cnt_sw1<10)
	LDS  R26,_cnt_sw1
	CPI  R26,LOW(0xA)
	BRSH _0x20
;     182 		{
;     183 		cnt_sw1++;
	LDS  R30,_cnt_sw1
	SUBI R30,-LOW(1)
	STS  _cnt_sw1,R30
;     184 		if(cnt_sw1==10) bSW1=1;
	LDS  R26,_cnt_sw1
	CPI  R26,LOW(0xA)
	BRNE _0x21
	SET
	BLD  R3,2
;     185 		}
_0x21:
;     186 
;     187 	}
_0x20:
;     188 else
	RJMP _0x22
_0x1F:
;     189 	{
;     190 	if(cnt_sw1)
	LDS  R30,_cnt_sw1
	CPI  R30,0
	BREQ _0x23
;     191 		{
;     192 		cnt_sw1--;
	SUBI R30,LOW(1)
	STS  _cnt_sw1,R30
;     193 		if(cnt_sw1==0) bSW1=0;
	CPI  R30,0
	BRNE _0x24
	CLT
	BLD  R3,2
;     194 		}
_0x24:
;     195 
;     196 	}
_0x23:
_0x22:
;     197 
;     198 if(!(in_word&(1<<SW2)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x80)
	BRNE _0x25
;     199 	{
;     200 	if(cnt_sw2<10)
	LDS  R26,_cnt_sw2
	CPI  R26,LOW(0xA)
	BRSH _0x26
;     201 		{
;     202 		cnt_sw2++;
	LDS  R30,_cnt_sw2
	SUBI R30,-LOW(1)
	STS  _cnt_sw2,R30
;     203 		if(cnt_sw2==10) bSW2=1;
	LDS  R26,_cnt_sw2
	CPI  R26,LOW(0xA)
	BRNE _0x27
	SET
	BLD  R3,3
;     204 		}
_0x27:
;     205 
;     206 	}
_0x26:
;     207 else
	RJMP _0x28
_0x25:
;     208 	{
;     209 	if(cnt_sw2)
	LDS  R30,_cnt_sw2
	CPI  R30,0
	BREQ _0x29
;     210 		{
;     211 		cnt_sw2--;
	SUBI R30,LOW(1)
	STS  _cnt_sw2,R30
;     212 		if(cnt_sw2==0) bSW2=0;
	CPI  R30,0
	BRNE _0x2A
	CLT
	BLD  R3,3
;     213 		}
_0x2A:
;     214 
;     215 	}
_0x29:
_0x28:
;     216 
;     217 
;     218 } 
	RET
;     219 
;     220 //-----------------------------------------------
;     221 void main_loop_hndl(void)
;     222 {
_main_loop_hndl:
;     223 	 
;     224 }
	RET
;     225 
;     226 
;     227 
;     228 //-----------------------------------------------
;     229 void out_drv(void)
;     230 {
_out_drv:
;     231 char temp=0;
;     232 DDRB=0xFF;
	ST   -Y,R16
;	temp -> R16
	LDI  R16,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     233 
;     234 if(bPP1) temp|=(1<<PP1);
	SBRS R3,4
	RJMP _0x2B
	ORI  R16,LOW(64)
;     235 if(bPP2) temp|=(1<<PP2);
_0x2B:
	SBRS R3,5
	RJMP _0x2C
	ORI  R16,LOW(128)
;     236 
;     237 PORTB=~temp;
_0x2C:
	CALL SUBOPT_0x1
;     238 //PORTB=0x55;
;     239 }
	RJMP _0x99
;     240 
;     241 //-----------------------------------------------
;     242 void step_contr(void)
;     243 {
_step_contr:
;     244 char temp=0;
;     245 DDRB=0xFF;
	ST   -Y,R16
;	temp -> R16
	LDI  R16,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     246 
;     247 if(ee_prog==p1)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x2D
;     248 	{
;     249      if(bSW1&&(step==sOFF))
	SBRS R3,2
	RJMP _0x2F
	LDI  R30,LOW(0)
	CP   R30,R12
	BREQ _0x30
_0x2F:
	RJMP _0x2E
_0x30:
;     250      	{
;     251      	step=s1;
	LDI  R30,LOW(1)
	MOV  R12,R30
;     252      	bPP1=1;
	SET
	BLD  R3,4
;     253      	bPP2=1;
	SET
	BLD  R3,5
;     254      	time_cnt=adc_output/15;
	LDS  R26,_adc_output
	LDS  R27,_adc_output+1
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL __DIVW21
	STS  _time_cnt,R30
	STS  _time_cnt+1,R31
;     255      	}              
;     256      else if(step==s1)
	RJMP _0x31
_0x2E:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x32
;     257      	{
;     258      	if(time_cnt==0)
	LDS  R30,_time_cnt
	LDS  R31,_time_cnt+1
	SBIW R30,0
	BRNE _0x33
;     259      		{
;     260      		step=s2;
	LDI  R30,LOW(2)
	MOV  R12,R30
;     261      		bPP1=1;
	SET
	BLD  R3,4
;     262      		bPP2=0;
	CLT
	BLD  R3,5
;     263      		}
;     264      	}	
_0x33:
;     265      
;     266      if(!bSW1&&(step!=sOFF)) 
_0x32:
_0x31:
	SBRC R3,2
	RJMP _0x35
	LDI  R30,LOW(0)
	CP   R30,R12
	BRNE _0x36
_0x35:
	RJMP _0x34
_0x36:
;     267      	{
;     268      	step=sOFF;
	CLR  R12
;     269      	bPP1=0;
	CLT
	BLD  R3,4
;     270      	bPP2=0;
	CLT
	BLD  R3,5
;     271      	}
;     272 	}
_0x34:
;     273 
;     274 else if(ee_prog==p2)  //ско
	RJMP _0x37
_0x2D:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BREQ _0x39
;     275 	{
;     276 
;     277 	}
;     278 
;     279 else if(ee_prog==p3)   //твист
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x3)
	BREQ _0x3B
;     280 	{
;     281 
;     282 	}
;     283 
;     284 else if(ee_prog==p4)      //замок
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x4)
	BRNE _0x3C
;     285 	{
;     286 	}
;     287 	
;     288 step_contr_end:
_0x3C:
_0x3B:
_0x39:
_0x37:
;     289 
;     290 //if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;     291 
;     292 PORTB=~temp;
	CALL SUBOPT_0x1
;     293 //PORTB=0x55;
;     294 }
_0x99:
	LD   R16,Y+
	RET
;     295 
;     296 
;     297 //-----------------------------------------------
;     298 void bin2bcd_int(unsigned int in)
;     299 {
_bin2bcd_int:
;     300 char i;
;     301 for(i=3;i>0;i--)
	ST   -Y,R16
;	in -> Y+1
;	i -> R16
	LDI  R16,LOW(3)
_0x3F:
	LDI  R30,LOW(0)
	CP   R30,R16
	BRSH _0x40
;     302 	{
;     303 	dig[i]=in%10;
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
;     304 	in/=10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
;     305 	}   
	SUBI R16,1
	RJMP _0x3F
_0x40:
;     306 }
	LDD  R16,Y+0
	RJMP _0x98
;     307 
;     308 //-----------------------------------------------
;     309 void bcd2ind(char s)
;     310 {
_bcd2ind:
;     311 char i;
;     312 bZ=1;
	ST   -Y,R16
;	s -> Y+1
;	i -> R16
	SET
	BLD  R2,3
;     313 for (i=0;i<5;i++)
	LDI  R16,LOW(0)
_0x42:
	CPI  R16,5
	BRLO PC+3
	JMP _0x43
;     314 	{
;     315 	if(bZ&&(!dig[i-1])&&(i<4))
	SBRS R2,3
	RJMP _0x45
	CALL SUBOPT_0x2
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	CPI  R30,0
	BRNE _0x45
	CPI  R16,4
	BRLO _0x46
_0x45:
	RJMP _0x44
_0x46:
;     316 		{
;     317 		if((4-i)>s)
	LDI  R30,LOW(4)
	SUB  R30,R16
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
	BRSH _0x47
;     318 			{
;     319 			ind_out[i-1]=DIGISYM[10];
	CALL SUBOPT_0x2
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	POP  R26
	POP  R27
	RJMP _0x9A
;     320 			}
;     321 		else ind_out[i-1]=DIGISYM[0];	
_0x47:
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
_0x9A:
	ST   X,R30
;     322 		}
;     323 	else
	RJMP _0x49
_0x44:
;     324 		{
;     325 		ind_out[i-1]=DIGISYM[dig[i-1]];
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
;     326 		bZ=0;
	CLT
	BLD  R2,3
;     327 		}                   
_0x49:
;     328 
;     329 	if(s)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x4A
;     330 		{
;     331 		ind_out[3-s]&=0b01111111;
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
;     332 		}	
;     333  
;     334 	}
_0x4A:
	SUBI R16,-1
	RJMP _0x42
_0x43:
;     335 }            
	LDD  R16,Y+0
	ADIW R28,2
	RET
;     336 //-----------------------------------------------
;     337 void int2ind(unsigned int in,char s)
;     338 {
_int2ind:
;     339 bin2bcd_int(in);
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _bin2bcd_int
;     340 bcd2ind(s);
	LD   R30,Y
	ST   -Y,R30
	CALL _bcd2ind
;     341 
;     342 } 
_0x98:
	ADIW R28,3
	RET
;     343 
;     344 //-----------------------------------------------
;     345 void ind_hndl(void)
;     346 {
_ind_hndl:
;     347 if(ind==iMn)
	TST  R13
	BRNE _0x4B
;     348 	{
;     349 	if(ee_prog==EE_PROG_FULL)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,0
	BREQ _0x4D
;     350 		{
;     351 		}
;     352 	else if(ee_prog==EE_PROG_ONLY_ORIENT)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x4E
;     353 		{
;     354 		int2ind(orient_step,0);
	LDS  R30,_orient_step
	CALL SUBOPT_0x3
;     355 		}
;     356 	else if(ee_prog==EE_PROG_ONLY_NAPOLN)
	RJMP _0x4F
_0x4E:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BRNE _0x50
;     357 		{
;     358 		int2ind(napoln_step,0);                              
	LDS  R30,_napoln_step
	CALL SUBOPT_0x3
;     359 		}			                
;     360 	else if(ee_prog==EE_PROG_ONLY_PAYKA)
	RJMP _0x51
_0x50:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x3)
	BRNE _0x52
;     361 		{
;     362 		int2ind(payka_step,0);
	LDS  R30,_payka_step
	CALL SUBOPT_0x3
;     363 		}
;     364 	else if(ee_prog==EE_PROG_ONLY_MAIN_LOOP)
	RJMP _0x53
_0x52:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x4)
	BRNE _0x54
;     365 		{
;     366 		int2ind(main_loop_step,0);
	LDS  R30,_main_loop_step
	CALL SUBOPT_0x3
;     367 		}			
;     368 	
;     369 	//int2ind(bDM,0);
;     370 	//int2ind(in_word,0);
;     371 	//int2ind(cnt_dm,0);
;     372 	
;     373 	//int2ind(bDM,0);
;     374 	//int2ind(ee_delay[prog,sub_ind],1);  
;     375 	//ind_out[0]=0xff;//DIGISYM[0];
;     376 	//ind_out[1]=0xff;//DIGISYM[1];
;     377 	//ind_out[2]=DIGISYM[2];//0xff;
;     378 	//ind_out[0]=DIGISYM[7]; 
;     379 
;     380 	//ind_out[0]=DIGISYM[sub_ind+1];
;     381 	}
_0x54:
_0x53:
_0x51:
_0x4F:
_0x4D:
;     382 else if(ind==iSet)
	RJMP _0x55
_0x4B:
	LDI  R30,LOW(2)
	CP   R30,R13
	BREQ PC+3
	JMP _0x56
;     383 	{
;     384      if(sub_ind==0)int2ind(ee_prog,0);
	TST  R14
	BRNE _0x57
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CALL SUBOPT_0x3
;     385 	else if(sub_ind==1)int2ind(ee_temp1,1);
	RJMP _0x58
_0x57:
	LDI  R30,LOW(1)
	CP   R30,R14
	BRNE _0x59
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	CALL SUBOPT_0x4
;     386 	else if(sub_ind==2)int2ind(ee_temp2,1);
	RJMP _0x5A
_0x59:
	LDI  R30,LOW(2)
	CP   R30,R14
	BRNE _0x5B
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	CALL SUBOPT_0x4
;     387 	else if(sub_ind==3)int2ind(ee_temp3,1);
	RJMP _0x5C
_0x5B:
	LDI  R30,LOW(3)
	CP   R30,R14
	BRNE _0x5D
	LDI  R26,LOW(_ee_temp3)
	LDI  R27,HIGH(_ee_temp3)
	CALL __EEPROMRDW
	CALL SUBOPT_0x4
;     388 	else if(sub_ind==4)int2ind(ee_temp4,1);
	RJMP _0x5E
_0x5D:
	LDI  R30,LOW(4)
	CP   R30,R14
	BRNE _0x5F
	LDI  R26,LOW(_ee_temp4)
	LDI  R27,HIGH(_ee_temp4)
	CALL __EEPROMRDW
	CALL SUBOPT_0x4
;     389 		
;     390 	if(bFL5)ind_out[0]=DIGISYM[sub_ind+1];
_0x5F:
_0x5E:
_0x5C:
_0x5A:
_0x58:
	SBRS R3,0
	RJMP _0x60
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
	RJMP _0x9B
;     391 	else    ind_out[0]=DIGISYM[10];
_0x60:
	__POINTW1FN _DIGISYM,10
_0x9B:
	LPM  R30,Z
	STS  _ind_out,R30
;     392 	}
;     393 }
_0x56:
_0x55:
	RET
;     394 
;     395 //-----------------------------------------------
;     396 void led_hndl(void)
;     397 {
_led_hndl:
;     398 ind_out[4]=DIGISYM[10]; 
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	__PUTB1MN _ind_out,4
;     399 
;     400 ind_out[4]&=~(1<<LED_POW_ON); 
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xDF
	POP  R26
	POP  R27
	ST   X,R30
;     401 
;     402 if(step!=sOFF)
	TST  R12
	BREQ _0x62
;     403 	{
;     404 	ind_out[4]&=~(1<<LED_WRK);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xBF
	POP  R26
	POP  R27
	RJMP _0x9C
;     405 	}
;     406 else ind_out[4]|=(1<<LED_WRK);
_0x62:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x40
	POP  R26
	POP  R27
_0x9C:
	ST   X,R30
;     407 
;     408 
;     409 if(step==sOFF)
	TST  R12
	BRNE _0x64
;     410 	{
;     411  	if(bERR)
	SBRS R3,1
	RJMP _0x65
;     412 		{
;     413 		ind_out[4]&=~(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFE
	POP  R26
	POP  R27
	RJMP _0x9D
;     414 		}
;     415 	else
_0x65:
;     416 		{
;     417 		ind_out[4]|=(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
_0x9D:
	ST   X,R30
;     418 		}
;     419      }
;     420 else ind_out[4]|=(1<<LED_ERROR);
	RJMP _0x67
_0x64:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
	ST   X,R30
_0x67:
;     421 
;     422 /* 	if(bMD1)
;     423 		{
;     424 		ind_out[4]&=~(1<<LED_ERROR);
;     425 		}
;     426 	else
;     427 		{
;     428 		ind_out[4]|=(1<<LED_ERROR);
;     429 		} */
;     430 
;     431 //if(bERR)ind_out[4]&=~(1<<LED_ERROR);
;     432 ind_out[4]|=(1<<LED_LOOP_AUTO);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x80
	POP  R26
	POP  R27
	ST   X,R30
;     433 
;     434 /*if(prog==p1) ind_out[4]&=~(1<<LED_PROG1);
;     435 else if(prog==p2) ind_out[4]&=~(1<<LED_PROG2);
;     436 else if(prog==p3) ind_out[4]&=~(1<<LED_PROG3);
;     437 else if(prog==p4) ind_out[4]&=~(1<<LED_PROG4); */
;     438 
;     439 /*if(ind==iPr_sel)
;     440 	{
;     441 	if(bFL5)ind_out[4]|=(1<<LED_PROG1)|(1<<LED_PROG2)|(1<<LED_PROG3)|(1<<LED_PROG4);
;     442 	}*/ 
;     443 	 
;     444 /*if(ind==iVr)
;     445 	{
;     446 	if(bFL5)ind_out[4]|=(1<<LED_POW_ON);
;     447 	} */
;     448 if(ee_prog==p1) ind_out[4]&=~(1<<LED_PROG1);
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x68
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xEF
	POP  R26
	POP  R27
	ST   X,R30
;     449 else if(ee_prog==p2) ind_out[4]&=~(1<<LED_PROG2);
	RJMP _0x69
_0x68:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x2)
	BRNE _0x6A
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFB
	POP  R26
	POP  R27
	ST   X,R30
;     450 else if(ee_prog==p3) ind_out[4]&=~(1<<LED_PROG3);
	RJMP _0x6B
_0x6A:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x3)
	BRNE _0x6C
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0XF7
	POP  R26
	POP  R27
	ST   X,R30
;     451 else if(ee_prog==p4) ind_out[4]&=~(1<<LED_PROG4);	
	RJMP _0x6D
_0x6C:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x4)
	BRNE _0x6E
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFD
	POP  R26
	POP  R27
	ST   X,R30
;     452 
;     453 if(ind==iPr_sel)
_0x6E:
_0x6D:
_0x6B:
_0x69:
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0x6F
;     454 	{
;     455 	if(bFL5)ind_out[4]|=(1<<LED_PROG1)|(1<<LED_PROG2)|(1<<LED_PROG3)|(1<<LED_PROG4);
	SBRS R3,0
	RJMP _0x70
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,LOW(0x1E)
	POP  R26
	POP  R27
	ST   X,R30
;     456 	} 
_0x70:
;     457 }
_0x6F:
	RET
;     458 
;     459 //-----------------------------------------------
;     460 // Подпрограмма драйва до 7 кнопок одного порта, 
;     461 // различает короткое и длинное нажатие,
;     462 // срабатывает на отпускание кнопки, возможность
;     463 // ускорения перебора при длинном нажатии...
;     464 #define but_port PORTC
;     465 #define but_dir  DDRC
;     466 #define but_pin  PINC
;     467 #define but_mask 0b01101010
;     468 #define no_but   0b11111111
;     469 #define but_on   5
;     470 #define but_onL  20
;     471 
;     472 
;     473 
;     474 
;     475 void but_drv(void)
;     476 { 
_but_drv:
;     477 DDRD&=0b00000111;
	IN   R30,0x11
	ANDI R30,LOW(0x7)
	CALL SUBOPT_0x5
;     478 PORTD|=0b11111000;
;     479 
;     480 but_port|=(but_mask^0xff);
	CALL SUBOPT_0x6
;     481 but_dir&=but_mask;
;     482 #asm
;     483 nop
nop
;     484 nop
nop
;     485 nop
nop
;     486 nop
nop
;     487 #endasm

;     488 
;     489 but_n=but_pin|but_mask; 
	IN   R30,0x13
	ORI  R30,LOW(0x6A)
	STS  _but_n_G1,R30
;     490 
;     491 if((but_n==no_but)||(but_n!=but_s))
	LDS  R26,_but_n_G1
	CPI  R26,LOW(0xFF)
	BREQ _0x72
	RCALL SUBOPT_0x7
	BREQ _0x71
_0x72:
;     492  	{
;     493  	speed=0;
	CLT
	BLD  R2,6
;     494    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRSH _0x75
	LDS  R26,_but1_cnt_G1
	CPI  R26,LOW(0x0)
	BREQ _0x77
_0x75:
	SBRS R2,4
	RJMP _0x78
_0x77:
	RJMP _0x74
_0x78:
;     495   		{
;     496    	     n_but=1;
	SET
	BLD  R2,5
;     497           but=but_s;
	LDS  R11,_but_s_G1
;     498           }
;     499    	if (but1_cnt>=but_onL_temp)
_0x74:
	RCALL SUBOPT_0x8
	BRLO _0x79
;     500   		{
;     501    	     n_but=1;
	SET
	BLD  R2,5
;     502           but=but_s&0b11111101;
	RCALL SUBOPT_0x9
;     503           }
;     504     	l_but=0;
_0x79:
	CLT
	BLD  R2,4
;     505    	but_onL_temp=but_onL;
	LDI  R30,LOW(20)
	STS  _but_onL_temp_G1,R30
;     506     	but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;     507   	but1_cnt=0;          
	STS  _but1_cnt_G1,R30
;     508      goto but_drv_out;
	RJMP _0x7A
;     509   	}  
;     510   	
;     511 if(but_n==but_s)
_0x71:
	RCALL SUBOPT_0x7
	BRNE _0x7B
;     512  	{
;     513   	but0_cnt++;
	LDS  R30,_but0_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but0_cnt_G1,R30
;     514   	if(but0_cnt>=but_on)
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRLO _0x7C
;     515   		{
;     516    		but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;     517    		but1_cnt++;
	LDS  R30,_but1_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but1_cnt_G1,R30
;     518    		if(but1_cnt>=but_onL_temp)
	RCALL SUBOPT_0x8
	BRLO _0x7D
;     519    			{              
;     520     			but=but_s&0b11111101;
	RCALL SUBOPT_0x9
;     521     			but1_cnt=0;
	LDI  R30,LOW(0)
	STS  _but1_cnt_G1,R30
;     522     			n_but=1;
	SET
	BLD  R2,5
;     523     			l_but=1;
	SET
	BLD  R2,4
;     524 			if(speed)
	SBRS R2,6
	RJMP _0x7E
;     525 				{
;     526     				but_onL_temp=but_onL_temp>>1;
	LDS  R30,_but_onL_temp_G1
	LSR  R30
	STS  _but_onL_temp_G1,R30
;     527         			if(but_onL_temp<=2) but_onL_temp=2;
	LDS  R26,_but_onL_temp_G1
	LDI  R30,LOW(2)
	CP   R30,R26
	BRLO _0x7F
	STS  _but_onL_temp_G1,R30
;     528 				}    
_0x7F:
;     529    			}
_0x7E:
;     530   		} 
_0x7D:
;     531  	}
_0x7C:
;     532 but_drv_out:
_0x7B:
_0x7A:
;     533 but_s=but_n;
	LDS  R30,_but_n_G1
	STS  _but_s_G1,R30
;     534 but_port|=(but_mask^0xff);
	RCALL SUBOPT_0x6
;     535 but_dir&=but_mask;
;     536 }    
	RET
;     537 
;     538 #define butV	239
;     539 #define butV_	237
;     540 #define butP	251
;     541 #define butP_	249
;     542 #define butR	127
;     543 #define butR_	125
;     544 #define butL	254
;     545 #define butL_	252
;     546 #define butLR	126
;     547 #define butLR_	124 
;     548 #define butVP_ 233
;     549 //-----------------------------------------------
;     550 void but_an(void)
;     551 {
_but_an:
;     552 if (!n_but) goto but_an_end;
	SBRS R2,5
	RJMP _0x81
;     553 
;     554 if(ind==iMn)
	TST  R13
	BRNE _0x82
;     555 	{
;     556 	if(but==butP_)ind=iPr_sel;
	LDI  R30,LOW(249)
	CP   R30,R11
	BRNE _0x83
	LDI  R30,LOW(1)
	MOV  R13,R30
;     557 	} 
_0x83:
;     558 	
;     559 else if(ind==iPr_sel)
	RJMP _0x84
_0x82:
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0x85
;     560 	{
;     561 	if(but==butP_)ind=iMn;
	LDI  R30,LOW(249)
	CP   R30,R11
	BRNE _0x86
	CLR  R13
;     562 	if(but==butP)
_0x86:
	LDI  R30,LOW(251)
	CP   R30,R11
	BRNE _0x87
;     563 		{
;     564 		ee_prog++;
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
;     565 		if(ee_prog>MAXPROG)ee_prog=p1;
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDB
	MOV  R26,R30
	LDI  R30,LOW(1)
	CP   R30,R26
	BRGE _0x88
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMWRB
;     566 		}
_0x88:
;     567 	} 
_0x87:
;     568 
;     569 but_an_end:
_0x85:
_0x84:
_0x81:
;     570 n_but=0;
	CLT
	BLD  R2,5
;     571 }
	RET
;     572 
;     573 //-----------------------------------------------
;     574 void ind_drv(void)
;     575 {
_ind_drv:
;     576 if(++ind_cnt>=6)ind_cnt=0;
	INC  R10
	LDI  R30,LOW(6)
	CP   R10,R30
	BRLO _0x89
	CLR  R10
;     577 
;     578 if(ind_cnt<5)
_0x89:
	LDI  R30,LOW(5)
	CP   R10,R30
	BRSH _0x8A
;     579 	{
;     580 	DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
;     581 	PORTC=0xFF;
	OUT  0x15,R30
;     582 	DDRD|=0b11111000;
	IN   R30,0x11
	ORI  R30,LOW(0xF8)
	RCALL SUBOPT_0x5
;     583 	PORTD|=0b11111000;
;     584 	PORTD&=IND_STROB[ind_cnt];
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
;     585 	PORTC=ind_out[ind_cnt];
	MOV  R30,R10
	LDI  R31,0
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	LD   R30,Z
	OUT  0x15,R30
;     586 	}
;     587 else but_drv();
	RJMP _0x8B
_0x8A:
	CALL _but_drv
_0x8B:
;     588 }
	RET
;     589 
;     590 //***********************************************
;     591 //***********************************************
;     592 //***********************************************
;     593 //***********************************************
;     594 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;     595 {
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
;     596 TCCR0=0x02;
	RCALL SUBOPT_0xA
;     597 TCNT0=-208;
;     598 OCR0=0x00; 
;     599 
;     600 
;     601 b600Hz=1;
	SET
	BLD  R2,0
;     602 ind_drv();
	RCALL _ind_drv
;     603 if(++t0_cnt0>=6)
	INC  R6
	LDI  R30,LOW(6)
	CP   R6,R30
	BRLO _0x8C
;     604 	{
;     605 	t0_cnt0=0;
	CLR  R6
;     606 	b100Hz=1;
	SET
	BLD  R2,1
;     607 	}
;     608 
;     609 if(++t0_cnt1>=60)
_0x8C:
	INC  R7
	LDI  R30,LOW(60)
	CP   R7,R30
	BRLO _0x8D
;     610 	{
;     611 	t0_cnt1=0;
	CLR  R7
;     612 	b10Hz=1;
	SET
	BLD  R2,2
;     613 	
;     614 	if(++t0_cnt2>=2)
	INC  R8
	LDI  R30,LOW(2)
	CP   R8,R30
	BRLO _0x8E
;     615 		{
;     616 		t0_cnt2=0;
	CLR  R8
;     617 		bFL5=!bFL5;
	LDI  R30,LOW(1)
	EOR  R3,R30
;     618 		}
;     619 		
;     620 	if(++t0_cnt3>=5)
_0x8E:
	INC  R9
	LDI  R30,LOW(5)
	CP   R9,R30
	BRLO _0x8F
;     621 		{
;     622 		t0_cnt3=0;
	CLR  R9
;     623 		bFL2=!bFL2;
	LDI  R30,LOW(128)
	EOR  R2,R30
;     624 		}		
;     625 	}
_0x8F:
;     626 }
_0x8D:
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
;     627 
;     628 //***********************************************
;     629 interrupt [ADC_INT] void adc_isr(void)
;     630 {
_adc_isr:
	ST   -Y,R30
	ST   -Y,R31
;     631 register static unsigned char input_index=0;

	.DSEG
_input_index_S10:
	.BYTE 0x1

	.CSEG
;     632 // Read the AD conversion result
;     633 adc_output=ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	STS  _adc_output,R30
	STS  _adc_output+1,R31
;     634 // Select next ADC input
;     635 
;     636 ADMUX=(FIRST_ADC_INPUT|ADC_VREF_TYPE);
	LDI  R30,LOW(66)
	OUT  0x7,R30
;     637 
;     638 
;     639 }
	LD   R31,Y+
	LD   R30,Y+
	RETI
;     640 
;     641 //===============================================
;     642 //===============================================
;     643 //===============================================
;     644 //===============================================
;     645 
;     646 void main(void)
;     647 {
_main:
;     648 
;     649 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
;     650 DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
;     651 
;     652 PORTB=0xff;
	RCALL SUBOPT_0xB
;     653 DDRB=0xFF;
;     654 
;     655 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;     656 DDRC=0x00;
	OUT  0x14,R30
;     657 
;     658 
;     659 PORTD=0x00;
	OUT  0x12,R30
;     660 DDRD=0x00;
	OUT  0x11,R30
;     661 
;     662 
;     663 TCCR0=0x02;
	RCALL SUBOPT_0xA
;     664 TCNT0=-208;
;     665 OCR0=0x00;
;     666 
;     667 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;     668 TCCR1B=0x00;
	OUT  0x2E,R30
;     669 TCNT1H=0x00;
	OUT  0x2D,R30
;     670 TCNT1L=0x00;
	OUT  0x2C,R30
;     671 ICR1H=0x00;
	OUT  0x27,R30
;     672 ICR1L=0x00;
	OUT  0x26,R30
;     673 OCR1AH=0x00;
	OUT  0x2B,R30
;     674 OCR1AL=0x00;
	OUT  0x2A,R30
;     675 OCR1BH=0x00;
	OUT  0x29,R30
;     676 OCR1BL=0x00;
	OUT  0x28,R30
;     677 
;     678 
;     679 ASSR=0x00;
	OUT  0x22,R30
;     680 TCCR2=0x00;
	OUT  0x25,R30
;     681 TCNT2=0x00;
	OUT  0x24,R30
;     682 OCR2=0x00;
	OUT  0x23,R30
;     683 
;     684 MCUCR=0x00;
	OUT  0x35,R30
;     685 MCUCSR=0x00;
	OUT  0x34,R30
;     686 
;     687 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;     688 
;     689 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     690 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     691 
;     692 
;     693 
;     694 // ADC initialization
;     695 // ADC Clock frequency: 125,000 kHz
;     696 // ADC Voltage Reference: AVCC pin
;     697 // ADC High Speed Mode: Off
;     698 // ADC Auto Trigger Source: Timer0 Overflow
;     699 ADMUX=FIRST_ADC_INPUT|ADC_VREF_TYPE;
	LDI  R30,LOW(66)
	OUT  0x7,R30
;     700 ADCSRA=0xCB;
	LDI  R30,LOW(203)
	OUT  0x6,R30
;     701 SFIOR&=0x0F;
	IN   R30,0x30
	ANDI R30,LOW(0xF)
	OUT  0x30,R30
;     702 
;     703 
;     704 
;     705 #asm("sei") 
	sei
;     706 PORTB=0xFF;
	RCALL SUBOPT_0xB
;     707 DDRB=0xFF;
;     708 ind=iMn;
	CLR  R13
;     709 prog_drv();
	CALL _prog_drv
;     710 ind_hndl();
	CALL _ind_hndl
;     711 led_hndl();
	CALL _led_hndl
;     712 
;     713 
;     714 while (1)
_0x90:
;     715       {
;     716       if(b600Hz)
	SBRS R2,0
	RJMP _0x93
;     717 		{
;     718 		b600Hz=0; 
	CLT
	BLD  R2,0
;     719           in_an();
	CALL _in_an
;     720           
;     721 		}         
;     722       if(b100Hz)
_0x93:
	SBRS R2,1
	RJMP _0x94
;     723 		{        
;     724 		b100Hz=0; 
	CLT
	BLD  R2,1
;     725 		but_an();
	RCALL _but_an
;     726 	    	in_drv();
	CALL _in_drv
;     727           ind_hndl();
	CALL _ind_hndl
;     728           step_contr();
	CALL _step_contr
;     729           
;     730           main_loop_hndl();
	CALL _main_loop_hndl
;     731 
;     732           out_drv();
	CALL _out_drv
;     733 		}   
;     734 	if(b10Hz)
_0x94:
	SBRS R2,2
	RJMP _0x95
;     735 		{
;     736 		b10Hz=0;
	CLT
	BLD  R2,2
;     737 		prog_drv();
	CALL _prog_drv
;     738 		err_drv();
	CALL _err_drv
;     739 		
;     740     	     if(time_cnt)time_cnt--;
	LDS  R30,_time_cnt
	LDS  R31,_time_cnt+1
	SBIW R30,0
	BREQ _0x96
	SBIW R30,1
	STS  _time_cnt,R30
	STS  _time_cnt+1,R31
;     741           led_hndl();
_0x96:
	CALL _led_hndl
;     742           ADCSRA|=0x40;
	SBI  0x6,6
;     743           }
;     744 
;     745       };
_0x95:
	RJMP _0x90
;     746 }
_0x97:
	RJMP _0x97

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	LDI  R30,LOW(255)
	OUT  0x1B,R30
	IN   R30,0x19
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
	LDI  R30,LOW(255)
	OUT  0x18,R30
	OUT  0x17,R30
	RET

__ANEGW1:
	COM  R30
	COM  R31
	ADIW R30,1
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

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
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

