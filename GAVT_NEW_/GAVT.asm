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
;       2 #define LED_PROG4	1
;       3 #define LED_PROG2	2
;       4 #define LED_PROG3	3
;       5 #define LED_PROG1	4 
;       6 #define LED_ERROR	0 
;       7 #define LED_WRK	6
;       8 #define LED_VACUUM	7
;       9 
;      10 #define GAVT3
;      11 
;      12 //#define P380
;      13 //#define I380
;      14 //#define I220
;      15 //#define P380_MINI
;      16 //#define TVIST_SKO
;      17 #define I380_WI
;      18 //#define I220_WI
;      19 
;      20 #define MD1	2
;      21 #define MD2	3
;      22 #define VR	4
;      23 #define MD3	5
;      24 
;      25 #define PP1	6
;      26 #define PP2	7
;      27 #define PP3	5
;      28 #define PP4	4
;      29 #define PP5	3
;      30 #define DV	0 
;      31 
;      32 #define PP7	2
;      33 
;      34 #ifdef P380_MINI
;      35 #define MINPROG 1
;      36 #define MAXPROG 1 
;      37 #ifdef GAVT3
;      38 #define DV	2
;      39 #endif
;      40 #define PP3	3
;      41 #endif 
;      42 
;      43 #ifdef P380
;      44 #define MINPROG 1
;      45 #define MAXPROG 3 
;      46 #ifdef GAVT3
;      47 #define DV	2
;      48 #endif
;      49 #endif 
;      50 
;      51 #ifdef I380
;      52 #define MINPROG 1
;      53 #define MAXPROG 4
;      54 #endif
;      55 
;      56 #ifdef I380_WI
;      57 #define MINPROG 1
;      58 #define MAXPROG 4
;      59 #endif
;      60 
;      61 #ifdef I220
;      62 #define MINPROG 3
;      63 #define MAXPROG 4
;      64 #endif
;      65 
;      66 
;      67 #ifdef I220_WI
;      68 #define MINPROG 3
;      69 #define MAXPROG 4
;      70 #endif
;      71 
;      72 #ifdef TVIST_SKO
;      73 #define MINPROG 2
;      74 #define MAXPROG 3
;      75 #define DV	2
;      76 #endif
;      77 
;      78 bit b600Hz;
;      79 
;      80 bit b100Hz;
;      81 bit b10Hz;
;      82 char t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3;
;      83 char ind_cnt;
;      84 flash char IND_STROB[]={0b10111111,0b11011111,0b11101111,0b11110111,0b01111111};

	.CSEG
;      85 flash char DIGISYM[]={0b11000000,0b11111001,0b10100100,0b10110000,0b10011001,0b10010010,0b10000010,0b11111000,0b10000000,0b10010000,0b11111111};								
;      86 
;      87 char ind_out[5]={0x255,0x255,0x255,0x255,0x255};

	.DSEG
_ind_out:
	.BYTE 0x5
;      88 char dig[4];
_dig:
	.BYTE 0x4
;      89 bit bZ;    
;      90 char but;
;      91 static char but_n;
_but_n_G1:
	.BYTE 0x1
;      92 static char but_s;
_but_s_G1:
	.BYTE 0x1
;      93 static char but0_cnt;
_but0_cnt_G1:
	.BYTE 0x1
;      94 static char but1_cnt;
_but1_cnt_G1:
	.BYTE 0x1
;      95 static char but_onL_temp;
_but_onL_temp_G1:
	.BYTE 0x1
;      96 bit l_but;		//идет длинное нажатие на кнопку
;      97 bit n_but;          //произошло нажатие
;      98 bit speed;		//разрешение ускорения перебора 
;      99 bit bFL2; 
;     100 bit bFL5;
;     101 eeprom enum{evmON=0x55,evmOFF=0xaa}ee_vacuum_mode;

	.ESEG
_ee_vacuum_mode:
	.DB  0x0
;     102 eeprom char ee_program[2];
_ee_program:
	.DB  0x0
	.DB  0x0
;     103 enum {p1=1,p2=2,p3=3,p4=4}prog;
;     104 enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}step=sOFF;
;     105 enum {iMn,iPr_sel} ind;
;     106 char sub_ind;
;     107 char in_word,in_word_old,in_word_new,in_word_cnt;

	.DSEG
_in_word_old:
	.BYTE 0x1
_in_word_new:
	.BYTE 0x1
_in_word_cnt:
	.BYTE 0x1
;     108 bit bERR;
;     109 signed int cnt_del=0;
_cnt_del:
	.BYTE 0x2
;     110 
;     111 char bVR;
_bVR:
	.BYTE 0x1
;     112 char bMD1;
_bMD1:
	.BYTE 0x1
;     113 bit bMD2;
;     114 bit bMD3;
;     115 char cnt_md1,cnt_md2,cnt_vr,cnt_md3;
_cnt_md1:
	.BYTE 0x1
_cnt_md2:
	.BYTE 0x1
_cnt_vr:
	.BYTE 0x1
_cnt_md3:
	.BYTE 0x1
;     116 
;     117 eeprom unsigned ee_delay[4,2];

	.ESEG
_ee_delay:
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
;     118 //#include <mega16.h>
;     119 #include <mega8535.h>
;     120 //-----------------------------------------------
;     121 void prog_drv(void)
;     122 {

	.CSEG
_prog_drv:
;     123 char temp,temp1,temp2;
;     124 
;     125 temp=ee_program[0];
	CALL __SAVELOCR3
;	temp -> R16
;	temp1 -> R17
;	temp2 -> R18
	LDI  R26,LOW(_ee_program)
	LDI  R27,HIGH(_ee_program)
	CALL __EEPROMRDB
	MOV  R16,R30
;     126 temp1=ee_program[1];
	__POINTW2MN _ee_program,1
	CALL __EEPROMRDB
	MOV  R17,R30
;     127 temp2=ee_program[2];
	__POINTW2MN _ee_program,2
	CALL __EEPROMRDB
	MOV  R18,R30
;     128 
;     129 if((temp==temp1)&&(temp==temp2))
	CP   R17,R16
	BRNE _0x5
	CP   R18,R16
	BREQ _0x6
_0x5:
	RJMP _0x4
_0x6:
;     130 	{
;     131 	}
;     132 else if((temp==temp1)&&(temp!=temp2))
	RJMP _0x7
_0x4:
	CP   R17,R16
	BRNE _0x9
	CP   R18,R16
	BRNE _0xA
_0x9:
	RJMP _0x8
_0xA:
;     133 	{
;     134 	temp2=temp;
	MOV  R18,R16
;     135 	}
;     136 else if((temp!=temp1)&&(temp==temp2))
	RJMP _0xB
_0x8:
	CP   R17,R16
	BREQ _0xD
	CP   R18,R16
	BREQ _0xE
_0xD:
	RJMP _0xC
_0xE:
;     137 	{
;     138 	temp1=temp;
	MOV  R17,R16
;     139 	}
;     140 else if((temp!=temp1)&&(temp1==temp2))
	RJMP _0xF
_0xC:
	CP   R17,R16
	BREQ _0x11
	CP   R18,R17
	BREQ _0x12
_0x11:
	RJMP _0x10
_0x12:
;     141 	{
;     142 	temp=temp1;
	MOV  R16,R17
;     143 	}
;     144 else if((temp!=temp1)&&(temp!=temp2))
	RJMP _0x13
_0x10:
	CP   R17,R16
	BREQ _0x15
	CP   R18,R16
	BRNE _0x16
_0x15:
	RJMP _0x14
_0x16:
;     145 	{
;     146 	temp=MINPROG;
	LDI  R16,LOW(1)
;     147 	temp1=MINPROG;
	LDI  R17,LOW(1)
;     148 	temp2=MINPROG;
	LDI  R18,LOW(1)
;     149 	}
;     150 
;     151 if(!((temp<=MAXPROG)&&(temp>=MINPROG)))
_0x14:
_0x13:
_0xF:
_0xB:
_0x7:
	LDI  R30,LOW(4)
	CP   R30,R16
	BRLO _0x18
	CPI  R16,1
	BRSH _0x17
_0x18:
;     152 	{
;     153 	temp=MINPROG;
	LDI  R16,LOW(1)
;     154 	}
;     155 
;     156 if(temp!=ee_program[0])ee_program[0]=temp;
_0x17:
	LDI  R26,LOW(_ee_program)
	LDI  R27,HIGH(_ee_program)
	CALL __EEPROMRDB
	CP   R30,R16
	BREQ _0x1A
	MOV  R30,R16
	LDI  R26,LOW(_ee_program)
	LDI  R27,HIGH(_ee_program)
	CALL __EEPROMWRB
;     157 if(temp!=ee_program[1])ee_program[1]=temp;
_0x1A:
	__POINTW2MN _ee_program,1
	CALL __EEPROMRDB
	CP   R30,R16
	BREQ _0x1B
	__POINTW2MN _ee_program,1
	MOV  R30,R16
	CALL __EEPROMWRB
;     158 if(temp!=ee_program[2])ee_program[2]=temp;
_0x1B:
	__POINTW2MN _ee_program,2
	CALL __EEPROMRDB
	CP   R30,R16
	BREQ _0x1C
	__POINTW2MN _ee_program,2
	MOV  R30,R16
	CALL __EEPROMWRB
;     159 
;     160 prog=temp;
_0x1C:
	MOV  R10,R16
;     161 }
	CALL __LOADLOCR3
	RJMP _0x115
;     162 
;     163 //-----------------------------------------------
;     164 void in_drv(void)
;     165 {
_in_drv:
;     166 char i,temp;
;     167 unsigned int tempUI;
;     168 DDRA=0x00;
	CALL __SAVELOCR4
;	i -> R16
;	temp -> R17
;	tempUI -> R18,R19
	CALL SUBOPT_0x0
;     169 PORTA=0xff;
	OUT  0x1B,R30
;     170 in_word_new=PINA;
	IN   R30,0x19
	STS  _in_word_new,R30
;     171 if(in_word_old==in_word_new)
	LDS  R26,_in_word_old
	CP   R30,R26
	BRNE _0x1D
;     172 	{
;     173 	if(in_word_cnt<10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRSH _0x1E
;     174 		{
;     175 		in_word_cnt++;
	LDS  R30,_in_word_cnt
	SUBI R30,-LOW(1)
	STS  _in_word_cnt,R30
;     176 		if(in_word_cnt>=10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRLO _0x1F
;     177 			{
;     178 			in_word=in_word_old;
	LDS  R14,_in_word_old
;     179 			}
;     180 		}
_0x1F:
;     181 	}
_0x1E:
;     182 else in_word_cnt=0;
	RJMP _0x20
_0x1D:
	LDI  R30,LOW(0)
	STS  _in_word_cnt,R30
_0x20:
;     183 
;     184 
;     185 in_word_old=in_word_new;
	LDS  R30,_in_word_new
	STS  _in_word_old,R30
;     186 }   
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;     187 
;     188 #ifdef TVIST_SKO
;     189 //-----------------------------------------------
;     190 void err_drv(void)
;     191 {
;     192 if(step==sOFF)
;     193 	{
;     194     	if(prog==p2)	
;     195     		{
;     196        		if(bMD1) bERR=1;
;     197        		else bERR=0;
;     198 		}
;     199 	}
;     200 else bERR=0;
;     201 }
;     202 #endif  
;     203 
;     204 #ifndef TVIST_SKO
;     205 //-----------------------------------------------
;     206 void err_drv(void)
;     207 {
_err_drv:
;     208 if(step==sOFF)
	TST  R11
	BRNE _0x21
;     209 	{
;     210 	if((bMD1)||(bMD2)||(bVR)||(bMD3)) bERR=1;
	LDS  R30,_bMD1
	CPI  R30,0
	BRNE _0x23
	SBRC R3,2
	RJMP _0x23
	LDS  R30,_bVR
	CPI  R30,0
	BRNE _0x23
	SBRS R3,3
	RJMP _0x22
_0x23:
	SET
	BLD  R3,1
;     211 	else bERR=0;
	RJMP _0x25
_0x22:
	CLT
	BLD  R3,1
_0x25:
;     212 	}
;     213 else bERR=0;
	RJMP _0x26
_0x21:
	CLT
	BLD  R3,1
_0x26:
;     214 }
	RET
;     215 #endif
;     216 //-----------------------------------------------
;     217 void mdvr_drv(void)
;     218 {
_mdvr_drv:
;     219 if(!(in_word&(1<<MD1)))
	SBRC R14,2
	RJMP _0x27
;     220 	{
;     221 	if(cnt_md1<10)
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRSH _0x28
;     222 		{
;     223 		cnt_md1++;
	LDS  R30,_cnt_md1
	SUBI R30,-LOW(1)
	STS  _cnt_md1,R30
;     224 		if(cnt_md1==10) bMD1=1;
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRNE _0x29
	LDI  R30,LOW(1)
	STS  _bMD1,R30
;     225 		}
_0x29:
;     226 
;     227 	}
_0x28:
;     228 else
	RJMP _0x2A
_0x27:
;     229 	{
;     230 	if(cnt_md1)
	LDS  R30,_cnt_md1
	CPI  R30,0
	BREQ _0x2B
;     231 		{
;     232 		cnt_md1--;
	SUBI R30,LOW(1)
	STS  _cnt_md1,R30
;     233 		if(cnt_md1==0) bMD1=0;
	CPI  R30,0
	BRNE _0x2C
	LDI  R30,LOW(0)
	STS  _bMD1,R30
;     234 		}
_0x2C:
;     235 
;     236 	}
_0x2B:
_0x2A:
;     237 
;     238 if(!(in_word&(1<<MD2)))
	SBRC R14,3
	RJMP _0x2D
;     239 	{
;     240 	if(cnt_md2<10)
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRSH _0x2E
;     241 		{
;     242 		cnt_md2++;
	LDS  R30,_cnt_md2
	SUBI R30,-LOW(1)
	STS  _cnt_md2,R30
;     243 		if(cnt_md2==10) bMD2=1;
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRNE _0x2F
	SET
	BLD  R3,2
;     244 		}
_0x2F:
;     245 
;     246 	}
_0x2E:
;     247 else
	RJMP _0x30
_0x2D:
;     248 	{
;     249 	if(cnt_md2)
	LDS  R30,_cnt_md2
	CPI  R30,0
	BREQ _0x31
;     250 		{
;     251 		cnt_md2--;
	SUBI R30,LOW(1)
	STS  _cnt_md2,R30
;     252 		if(cnt_md2==0) bMD2=0;
	CPI  R30,0
	BRNE _0x32
	CLT
	BLD  R3,2
;     253 		}
_0x32:
;     254 
;     255 	}
_0x31:
_0x30:
;     256 
;     257 if(!(in_word&(1<<MD3)))
	SBRC R14,5
	RJMP _0x33
;     258 	{
;     259 	if(cnt_md3<10)
	LDS  R26,_cnt_md3
	CPI  R26,LOW(0xA)
	BRSH _0x34
;     260 		{
;     261 		cnt_md3++;
	LDS  R30,_cnt_md3
	SUBI R30,-LOW(1)
	STS  _cnt_md3,R30
;     262 		if(cnt_md3==10) bMD3=1;
	LDS  R26,_cnt_md3
	CPI  R26,LOW(0xA)
	BRNE _0x35
	SET
	BLD  R3,3
;     263 		}
_0x35:
;     264 
;     265 	}
_0x34:
;     266 else
	RJMP _0x36
_0x33:
;     267 	{
;     268 	if(cnt_md3)
	LDS  R30,_cnt_md3
	CPI  R30,0
	BREQ _0x37
;     269 		{
;     270 		cnt_md3--;
	SUBI R30,LOW(1)
	STS  _cnt_md3,R30
;     271 		if(cnt_md3==0) bMD3=0;
	CPI  R30,0
	BRNE _0x38
	CLT
	BLD  R3,3
;     272 		}
_0x38:
;     273 
;     274 	}
_0x37:
_0x36:
;     275 
;     276 if(!(in_word&(1<<VR)))
	SBRC R14,4
	RJMP _0x39
;     277 	{
;     278 	if(cnt_vr<10)
	LDS  R26,_cnt_vr
	CPI  R26,LOW(0xA)
	BRSH _0x3A
;     279 		{
;     280 		cnt_vr++;
	LDS  R30,_cnt_vr
	SUBI R30,-LOW(1)
	STS  _cnt_vr,R30
;     281 		if(cnt_vr==10) bVR=1;
	LDS  R26,_cnt_vr
	CPI  R26,LOW(0xA)
	BRNE _0x3B
	LDI  R30,LOW(1)
	STS  _bVR,R30
;     282 		}
_0x3B:
;     283 
;     284 	}
_0x3A:
;     285 else
	RJMP _0x3C
_0x39:
;     286 	{
;     287 	if(cnt_vr)
	LDS  R30,_cnt_vr
	CPI  R30,0
	BREQ _0x3D
;     288 		{
;     289 		cnt_vr--;
	SUBI R30,LOW(1)
	STS  _cnt_vr,R30
;     290 		if(cnt_vr==0) bVR=0;
	CPI  R30,0
	BRNE _0x3E
	LDI  R30,LOW(0)
	STS  _bVR,R30
;     291 		}
_0x3E:
;     292 
;     293 	}
_0x3D:
_0x3C:
;     294 } 
	RET
;     295 
;     296 #ifdef P380_MINI
;     297 //-----------------------------------------------
;     298 void step_contr(void)
;     299 {
;     300 char temp=0;
;     301 DDRB=0xFF;
;     302 
;     303 if(step==sOFF)
;     304 	{
;     305 	temp=0;
;     306 	}
;     307 
;     308 else if(step==s1)
;     309 	{
;     310 	temp|=(1<<PP1);
;     311 
;     312 	cnt_del--;
;     313 	if(cnt_del==0)
;     314 		{
;     315 		step=s2;
;     316 		}
;     317 	}
;     318 
;     319 else if(step==s2)
;     320 	{
;     321 	temp|=(1<<PP1)|(1<<PP2)|(1<<DV);
;     322      if(!bMD1)goto step_contr_end;
;     323      step=s3;
;     324      }     
;     325 else if(step==s3)
;     326 	{          
;     327      temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     328      if(!bMD2)goto step_contr_end;
;     329      step=s4;
;     330      cnt_del=50;
;     331      }
;     332 else if(step==s4)
;     333 		{
;     334 	temp|=(1<<PP1);
;     335 	cnt_del--;
;     336 	if(cnt_del==0)
;     337 		{
;     338 		step=sOFF;
;     339           }     
;     340      }     
;     341 
;     342 step_contr_end:
;     343 
;     344 PORTB=~temp;
;     345 }
;     346 #endif
;     347 
;     348 #ifdef P380
;     349 //-----------------------------------------------
;     350 void step_contr(void)
;     351 {
;     352 char temp=0;
;     353 DDRB=0xFF;
;     354 
;     355 if(step==sOFF)
;     356 	{
;     357 	temp=0;
;     358 	}
;     359 
;     360 else if(prog==p1)
;     361 	{
;     362 	if(step==s1)
;     363 		{
;     364 		temp|=(1<<PP1)|(1<<PP2);
;     365 
;     366 		cnt_del--;
;     367 		if(cnt_del==0)
;     368 			{
;     369 			if(ee_vacuum_mode==evmOFF)
;     370 				{
;     371 				goto lbl_0001;
;     372 				}
;     373 			else step=s2;
;     374 			}
;     375 		}
;     376 
;     377 	else if(step==s2)
;     378 		{
;     379 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     380 
;     381           if(!bVR)goto step_contr_end;
;     382 lbl_0001:
;     383 #ifndef BIG_CAM
;     384 		cnt_del=30;
;     385 #endif
;     386 
;     387 #ifdef BIG_CAM
;     388 		cnt_del=100;
;     389 #endif
;     390 		step=s3;
;     391 		}
;     392 
;     393 	else if(step==s3)
;     394 		{
;     395 		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     396 		cnt_del--;
;     397 		if(cnt_del==0)
;     398 			{
;     399 			step=s4;
;     400 			}
;     401           }
;     402 	else if(step==s4)
;     403 		{
;     404 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     405 
;     406           if(!bMD1)goto step_contr_end;
;     407 
;     408 		cnt_del=40;
;     409 		step=s5;
;     410 		}
;     411 	else if(step==s5)
;     412 		{
;     413 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     414 
;     415 		cnt_del--;
;     416 		if(cnt_del==0)
;     417 			{
;     418 			step=s6;
;     419 			}
;     420 		}
;     421 	else if(step==s6)
;     422 		{
;     423 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     424 
;     425          	if(!bMD2)goto step_contr_end;
;     426           cnt_del=40;
;     427 		//step=s7;
;     428 		
;     429           step=s55;
;     430           cnt_del=40;
;     431 		}
;     432 	else if(step==s55)
;     433 		{
;     434 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     435           cnt_del--;
;     436           if(cnt_del==0)
;     437 			{
;     438           	step=s7;
;     439           	cnt_del=20;
;     440 			}
;     441          		
;     442 		}
;     443 	else if(step==s7)
;     444 		{
;     445 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     446 
;     447 		cnt_del--;
;     448 		if(cnt_del==0)
;     449 			{
;     450 			step=s8;
;     451 			cnt_del=30;
;     452 			}
;     453 		}
;     454 	else if(step==s8)
;     455 		{
;     456 		temp|=(1<<PP1)|(1<<PP3);
;     457 
;     458 		cnt_del--;
;     459 		if(cnt_del==0)
;     460 			{
;     461 			step=s9;
;     462 #ifndef BIG_CAM
;     463 		cnt_del=150;
;     464 #endif
;     465 
;     466 #ifdef BIG_CAM
;     467 		cnt_del=200;
;     468 #endif
;     469 			}
;     470 		}
;     471 	else if(step==s9)
;     472 		{
;     473 		temp|=(1<<PP1)|(1<<PP2);
;     474 
;     475 		cnt_del--;
;     476 		if(cnt_del==0)
;     477 			{
;     478 			step=s10;
;     479 			cnt_del=30;
;     480 			}
;     481 		}
;     482 	else if(step==s10)
;     483 		{
;     484 		temp|=(1<<PP2);
;     485 		cnt_del--;
;     486 		if(cnt_del==0)
;     487 			{
;     488 			step=sOFF;
;     489 			}
;     490 		}
;     491 	}
;     492 
;     493 if(prog==p2)
;     494 	{
;     495 
;     496 	if(step==s1)
;     497 		{
;     498 		temp|=(1<<PP1)|(1<<PP2);
;     499 
;     500 		cnt_del--;
;     501 		if(cnt_del==0)
;     502 			{
;     503 			if(ee_vacuum_mode==evmOFF)
;     504 				{
;     505 				goto lbl_0002;
;     506 				}
;     507 			else step=s2;
;     508 			}
;     509 		}
;     510 
;     511 	else if(step==s2)
;     512 		{
;     513 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     514 
;     515           if(!bVR)goto step_contr_end;
;     516 lbl_0002:
;     517 #ifndef BIG_CAM
;     518 		cnt_del=30;
;     519 #endif
;     520 
;     521 #ifdef BIG_CAM
;     522 		cnt_del=100;
;     523 #endif
;     524 		step=s3;
;     525 		}
;     526 
;     527 	else if(step==s3)
;     528 		{
;     529 		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     530 
;     531 		cnt_del--;
;     532 		if(cnt_del==0)
;     533 			{
;     534 			step=s4;
;     535 			}
;     536 		}
;     537 
;     538 	else if(step==s4)
;     539 		{
;     540 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     541 
;     542           if(!bMD1)goto step_contr_end;
;     543          	cnt_del=30;
;     544 		step=s5;
;     545 		}
;     546 
;     547 	else if(step==s5)
;     548 		{
;     549 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     550 
;     551 		cnt_del--;
;     552 		if(cnt_del==0)
;     553 			{
;     554 			step=s6;
;     555 			cnt_del=30;
;     556 			}
;     557 		}
;     558 
;     559 	else if(step==s6)
;     560 		{
;     561 		temp|=(1<<PP1)|(1<<PP3);
;     562 
;     563 		cnt_del--;
;     564 		if(cnt_del==0)
;     565 			{
;     566 			step=s7;
;     567 #ifndef BIG_CAM
;     568 		cnt_del=150;
;     569 #endif
;     570 
;     571 #ifdef BIG_CAM
;     572 		cnt_del=200;
;     573 #endif
;     574 			}
;     575 		}
;     576 
;     577 	else if(step==s7)
;     578 		{
;     579 		temp|=(1<<PP1)|(1<<PP2);
;     580 
;     581 		cnt_del--;
;     582 		if(cnt_del==0)
;     583 			{
;     584 			step=s8;
;     585 			cnt_del=30;
;     586 			}
;     587 		}
;     588 	else if(step==s8)
;     589 		{
;     590 		temp|=(1<<PP2);
;     591 
;     592 		cnt_del--;
;     593 		if(cnt_del==0)
;     594 			{
;     595 			step=sOFF;
;     596 			}
;     597 		}
;     598 	}
;     599 
;     600 if(prog==p3)
;     601 	{
;     602 
;     603 	if(step==s1)
;     604 		{
;     605 		temp|=(1<<PP1)|(1<<PP2);
;     606 
;     607 		cnt_del--;
;     608 		if(cnt_del==0)
;     609 			{
;     610 			if(ee_vacuum_mode==evmOFF)
;     611 				{
;     612 				goto lbl_0003;
;     613 				}
;     614 			else step=s2;
;     615 			}
;     616 		}
;     617 
;     618 	else if(step==s2)
;     619 		{
;     620 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     621 
;     622           if(!bVR)goto step_contr_end;
;     623 lbl_0003:
;     624 #ifndef BIG_CAM
;     625 		cnt_del=80;
;     626 #endif
;     627 
;     628 #ifdef BIG_CAM
;     629 		cnt_del=100;
;     630 #endif
;     631 		step=s3;
;     632 		}
;     633 
;     634 	else if(step==s3)
;     635 		{
;     636 		temp|=(1<<PP1)|(1<<PP3);
;     637 
;     638 		cnt_del--;
;     639 		if(cnt_del==0)
;     640 			{
;     641 			step=s4;
;     642 			cnt_del=120;
;     643 			}
;     644 		}
;     645 
;     646 	else if(step==s4)
;     647 		{
;     648 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<PP5);
;     649 
;     650 		cnt_del--;
;     651 		if(cnt_del==0)
;     652 			{
;     653 			step=s5;
;     654 
;     655 		
;     656 #ifndef BIG_CAM
;     657 		cnt_del=150;
;     658 #endif
;     659 
;     660 #ifdef BIG_CAM
;     661 		cnt_del=200;
;     662 #endif
;     663 	//	step=s5;
;     664 	}
;     665 		}
;     666 
;     667 	else if(step==s5)
;     668 		{
;     669 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<PP5);
;     670 
;     671 		cnt_del--;
;     672 		if(cnt_del==0)
;     673 			{
;     674 			step=s6;
;     675 			cnt_del=30;
;     676 			}
;     677 		}
;     678 
;     679 	else if(step==s6)
;     680 		{
;     681 		temp|=(1<<PP2)|(1<<PP4)|(1<<PP5);
;     682 
;     683 		cnt_del--;
;     684 		if(cnt_del==0)
;     685 			{
;     686 			step=s7;
;     687 			cnt_del=30;
;     688 			}
;     689 		}
;     690 
;     691 	else if(step==s7)
;     692 		{
;     693 		temp|=(1<<PP2);
;     694 
;     695 		cnt_del--;
;     696 		if(cnt_del==0)
;     697 			{
;     698 			step=sOFF;
;     699 			}
;     700 		}
;     701 
;     702 	}
;     703 step_contr_end:
;     704 
;     705 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;     706 
;     707 PORTB=~temp;
;     708 }
;     709 #endif
;     710 #ifdef I380
;     711 //-----------------------------------------------
;     712 void step_contr(void)
;     713 {
;     714 char temp=0;
;     715 DDRB=0xFF;
;     716 
;     717 if(step==sOFF)goto step_contr_end;
;     718 
;     719 else if(prog==p1)
;     720 	{
;     721 	if(step==s1)    //жесть
;     722 		{
;     723 		temp|=(1<<PP1);
;     724           if(!bMD1)goto step_contr_end;
;     725 
;     726 			if(ee_vacuum_mode==evmOFF)
;     727 				{
;     728 				goto lbl_0001;
;     729 				}
;     730 			else step=s2;
;     731 		}
;     732 
;     733 	else if(step==s2)
;     734 		{
;     735 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     736           if(!bVR)goto step_contr_end;
;     737 lbl_0001:
;     738 
;     739           step=s100;
;     740 		cnt_del=40;
;     741           }
;     742 	else if(step==s100)
;     743 		{
;     744 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;     745           cnt_del--;
;     746           if(cnt_del==0)
;     747 			{
;     748           	step=s3;
;     749           	cnt_del=50;
;     750 			}
;     751 		}
;     752 
;     753 	else if(step==s3)
;     754 		{
;     755 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     756           cnt_del--;
;     757           if(cnt_del==0)
;     758 			{
;     759           	step=s4;
;     760 			}
;     761 		}
;     762 	else if(step==s4)
;     763 		{
;     764 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;     765           if(!bMD2)goto step_contr_end;
;     766           step=s5;
;     767           cnt_del=20;
;     768 		}
;     769 	else if(step==s5)
;     770 		{
;     771 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     772           cnt_del--;
;     773           if(cnt_del==0)
;     774 			{
;     775           	step=s6;
;     776 			}
;     777           }
;     778 	else if(step==s6)
;     779 		{
;     780 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
;     781           if(!bMD3)goto step_contr_end;
;     782           step=s7;
;     783           cnt_del=20;
;     784 		}
;     785 
;     786 	else if(step==s7)
;     787 		{
;     788 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     789           cnt_del--;
;     790           if(cnt_del==0)
;     791 			{
;     792           	step=s8;
;     793           	cnt_del=ee_delay[prog,0]*10U;;
;     794 			}
;     795           }
;     796 	else if(step==s8)
;     797 		{
;     798 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;     799           cnt_del--;
;     800           if(cnt_del==0)
;     801 			{
;     802           	step=s9;
;     803           	cnt_del=20;
;     804 			}
;     805           }
;     806 	else if(step==s9)
;     807 		{
;     808 		temp|=(1<<PP1);
;     809           cnt_del--;
;     810           if(cnt_del==0)
;     811 			{
;     812           	step=sOFF;
;     813           	}
;     814           }
;     815 	}
;     816 
;     817 else if(prog==p2)  //ско
;     818 	{
;     819 	if(step==s1)
;     820 		{
;     821 		temp|=(1<<PP1);
;     822           if(!bMD1)goto step_contr_end;
;     823 
;     824 			if(ee_vacuum_mode==evmOFF)
;     825 				{
;     826 				goto lbl_0002;
;     827 				}
;     828 			else step=s2;
;     829 
;     830           //step=s2;
;     831 		}
;     832 
;     833 	else if(step==s2)
;     834 		{
;     835 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     836           if(!bVR)goto step_contr_end;
;     837 
;     838 lbl_0002:
;     839           step=s100;
;     840 		cnt_del=40;
;     841           }
;     842 	else if(step==s100)
;     843 		{
;     844 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;     845           cnt_del--;
;     846           if(cnt_del==0)
;     847 			{
;     848           	step=s3;
;     849           	cnt_del=50;
;     850 			}
;     851 		}
;     852 	else if(step==s3)
;     853 		{
;     854 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     855           cnt_del--;
;     856           if(cnt_del==0)
;     857 			{
;     858           	step=s4;
;     859 			}
;     860 		}
;     861 	else if(step==s4)
;     862 		{
;     863 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;     864           if(!bMD2)goto step_contr_end;
;     865           step=s5;
;     866           cnt_del=20;
;     867 		}
;     868 	else if(step==s5)
;     869 		{
;     870 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     871           cnt_del--;
;     872           if(cnt_del==0)
;     873 			{
;     874           	step=s6;
;     875           	cnt_del=ee_delay[prog,0]*10U;
;     876 			}
;     877           }
;     878 	else if(step==s6)
;     879 		{
;     880 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;     881           cnt_del--;
;     882           if(cnt_del==0)
;     883 			{
;     884           	step=s7;
;     885           	cnt_del=20;
;     886 			}
;     887           }
;     888 	else if(step==s7)
;     889 		{
;     890 		temp|=(1<<PP1);
;     891           cnt_del--;
;     892           if(cnt_del==0)
;     893 			{
;     894           	step=sOFF;
;     895           	}
;     896           }
;     897 	}
;     898 
;     899 else if(prog==p3)   //твист
;     900 	{
;     901 	if(step==s1)
;     902 		{
;     903 		temp|=(1<<PP1);
;     904           if(!bMD1)goto step_contr_end;
;     905 
;     906 			if(ee_vacuum_mode==evmOFF)
;     907 				{
;     908 				goto lbl_0003;
;     909 				}
;     910 			else step=s2;
;     911 
;     912           //step=s2;
;     913 		}
;     914 
;     915 	else if(step==s2)
;     916 		{
;     917 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     918           if(!bVR)goto step_contr_end;
;     919 lbl_0003:
;     920           cnt_del=50;
;     921 		step=s3;
;     922 		}
;     923 
;     924 
;     925 	else	if(step==s3)
;     926 		{
;     927 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;     928 		cnt_del--;
;     929 		if(cnt_del==0)
;     930 			{
;     931 			cnt_del=ee_delay[prog,0]*10U;
;     932 			step=s4;
;     933 			}
;     934           }
;     935 	else if(step==s4)
;     936 		{
;     937 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;     938 		cnt_del--;
;     939  		if(cnt_del==0)
;     940 			{
;     941 			cnt_del=ee_delay[prog,1]*10U;
;     942 			step=s5;
;     943 			}
;     944 		}
;     945 
;     946 	else if(step==s5)
;     947 		{
;     948 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;     949 		cnt_del--;
;     950 		if(cnt_del==0)
;     951 			{
;     952 			step=s6;
;     953 			cnt_del=20;
;     954 			}
;     955 		}
;     956 
;     957 	else if(step==s6)
;     958 		{
;     959 		temp|=(1<<PP1);
;     960   		cnt_del--;
;     961 		if(cnt_del==0)
;     962 			{
;     963 			step=sOFF;
;     964 			}
;     965 		}
;     966 
;     967 	}
;     968 
;     969 else if(prog==p4)      //замок
;     970 	{
;     971 	if(step==s1)
;     972 		{
;     973 		temp|=(1<<PP1);
;     974           if(!bMD1)goto step_contr_end;
;     975 
;     976 			if(ee_vacuum_mode==evmOFF)
;     977 				{
;     978 				goto lbl_0004;
;     979 				}
;     980 			else step=s2;
;     981           //step=s2;
;     982 		}
;     983 
;     984 	else if(step==s2)
;     985 		{
;     986 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     987           if(!bVR)goto step_contr_end;
;     988 lbl_0004:
;     989           step=s3;
;     990 		cnt_del=50;
;     991           }
;     992 
;     993 	else if(step==s3)
;     994 		{
;     995 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;     996           cnt_del--;
;     997           if(cnt_del==0)
;     998 			{
;     999           	step=s4;
;    1000 			cnt_del=ee_delay[prog,0]*10U;
;    1001 			}
;    1002           }
;    1003 
;    1004    	else if(step==s4)
;    1005 		{
;    1006 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1007 		cnt_del--;
;    1008 		if(cnt_del==0)
;    1009 			{
;    1010 			step=s5;
;    1011 			cnt_del=30;
;    1012 			}
;    1013 		}
;    1014 
;    1015 	else if(step==s5)
;    1016 		{
;    1017 		temp|=(1<<PP1)|(1<<PP4);
;    1018 		cnt_del--;
;    1019 		if(cnt_del==0)
;    1020 			{
;    1021 			step=s6;
;    1022 			cnt_del=ee_delay[prog,1]*10U;
;    1023 			}
;    1024 		}
;    1025 
;    1026 	else if(step==s6)
;    1027 		{
;    1028 		temp|=(1<<PP4);
;    1029 		cnt_del--;
;    1030 		if(cnt_del==0)
;    1031 			{
;    1032 			step=sOFF;
;    1033 			}
;    1034 		}
;    1035 
;    1036 	}
;    1037 	
;    1038 step_contr_end:
;    1039 
;    1040 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1041 
;    1042 PORTB=~temp;
;    1043 //PORTB=0x55;
;    1044 }
;    1045 #endif
;    1046 
;    1047 #ifdef I220_WI
;    1048 //-----------------------------------------------
;    1049 void step_contr(void)
;    1050 {
;    1051 char temp=0;
;    1052 DDRB=0xFF;
;    1053 
;    1054 if(step==sOFF)goto step_contr_end;
;    1055 
;    1056 else if(prog==p3)   //твист
;    1057 	{
;    1058 	if(step==s1)
;    1059 		{
;    1060 		temp|=(1<<PP1);
;    1061           if(!bMD1)goto step_contr_end;
;    1062 
;    1063 			if(ee_vacuum_mode==evmOFF)
;    1064 				{
;    1065 				goto lbl_0003;
;    1066 				}
;    1067 			else step=s2;
;    1068 
;    1069           //step=s2;
;    1070 		}
;    1071 
;    1072 	else if(step==s2)
;    1073 		{
;    1074 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1075           if(!bVR)goto step_contr_end;
;    1076 lbl_0003:
;    1077           cnt_del=50;
;    1078 		step=s3;
;    1079 		}
;    1080 
;    1081 
;    1082 	else	if(step==s3)
;    1083 		{
;    1084 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1085 		cnt_del--;
;    1086 		if(cnt_del==0)
;    1087 			{
;    1088 			cnt_del=90;
;    1089 			step=s4;
;    1090 			}
;    1091           }
;    1092 	else if(step==s4)
;    1093 		{
;    1094 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1095 		cnt_del--;
;    1096  		if(cnt_del==0)
;    1097 			{
;    1098 			cnt_del=130;
;    1099 			step=s5;
;    1100 			}
;    1101 		}
;    1102 
;    1103 	else if(step==s5)
;    1104 		{
;    1105 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1106 		cnt_del--;
;    1107 		if(cnt_del==0)
;    1108 			{
;    1109 			step=s6;
;    1110 			cnt_del=20;
;    1111 			}
;    1112 		}
;    1113 
;    1114 	else if(step==s6)
;    1115 		{
;    1116 		temp|=(1<<PP1);
;    1117   		cnt_del--;
;    1118 		if(cnt_del==0)
;    1119 			{
;    1120 			step=sOFF;
;    1121 			}
;    1122 		}
;    1123 
;    1124 	}
;    1125 
;    1126 else if(prog==p4)      //замок
;    1127 	{
;    1128 	if(step==s1)
;    1129 		{
;    1130 		temp|=(1<<PP1);
;    1131           if(!bMD1)goto step_contr_end;
;    1132 
;    1133 			if(ee_vacuum_mode==evmOFF)
;    1134 				{
;    1135 				goto lbl_0004;
;    1136 				}
;    1137 			else step=s2;
;    1138           //step=s2;
;    1139 		}
;    1140 
;    1141 	else if(step==s2)
;    1142 		{
;    1143 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1144           if(!bVR)goto step_contr_end;
;    1145 lbl_0004:
;    1146           step=s3;
;    1147 		cnt_del=50;
;    1148           }
;    1149 
;    1150 	else if(step==s3)
;    1151 		{
;    1152 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1153           cnt_del--;
;    1154           if(cnt_del==0)
;    1155 			{
;    1156           	step=s4;
;    1157 			cnt_del=120;
;    1158 			}
;    1159           }
;    1160 
;    1161    	else if(step==s4)
;    1162 		{
;    1163 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1164 		cnt_del--;
;    1165 		if(cnt_del==0)
;    1166 			{
;    1167 			step=s5;
;    1168 			cnt_del=30;
;    1169 			}
;    1170 		}
;    1171 
;    1172 	else if(step==s5)
;    1173 		{
;    1174 		temp|=(1<<PP1)|(1<<PP4);
;    1175 		cnt_del--;
;    1176 		if(cnt_del==0)
;    1177 			{
;    1178 			step=s6;
;    1179 			cnt_del=120;
;    1180 			}
;    1181 		}
;    1182 
;    1183 	else if(step==s6)
;    1184 		{
;    1185 		temp|=(1<<PP4);
;    1186 		cnt_del--;
;    1187 		if(cnt_del==0)
;    1188 			{
;    1189 			step=sOFF;
;    1190 			}
;    1191 		}
;    1192 
;    1193 	}
;    1194 	
;    1195 step_contr_end:
;    1196 
;    1197 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1198 
;    1199 PORTB=~temp;
;    1200 //PORTB=0x55;
;    1201 }
;    1202 #endif 
;    1203 
;    1204 #ifdef I380_WI
;    1205 //-----------------------------------------------
;    1206 void step_contr(void)
;    1207 {
_step_contr:
;    1208 char temp=0;
;    1209 DDRB=0xFF;
	ST   -Y,R16
;	temp -> R16
	LDI  R16,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
;    1210 
;    1211 if(step==sOFF)goto step_contr_end;
	TST  R11
	BRNE _0x3F
	RJMP _0x40
;    1212 
;    1213 else if(prog==p1)
_0x3F:
	LDI  R30,LOW(1)
	CP   R30,R10
	BREQ PC+3
	JMP _0x42
;    1214 	{
;    1215 	if(step==s1)    //жесть
	CP   R30,R11
	BRNE _0x43
;    1216 		{
;    1217 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    1218           if(!bMD1)goto step_contr_end;
	LDS  R30,_bMD1
	CPI  R30,0
	BRNE _0x44
	RJMP _0x40
;    1219 
;    1220 			if(ee_vacuum_mode==evmOFF)
_0x44:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x46
;    1221 				{
;    1222 				goto lbl_0001;
;    1223 				}
;    1224 			else step=s2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;    1225 		}
;    1226 
;    1227 	else if(step==s2)
	RJMP _0x48
_0x43:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x49
;    1228 		{
;    1229 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;    1230           if(!bVR)goto step_contr_end;
	LDS  R30,_bVR
	CPI  R30,0
	BRNE _0x4A
	RJMP _0x40
;    1231 lbl_0001:
_0x4A:
_0x46:
;    1232 
;    1233           step=s100;
	CALL SUBOPT_0x1
;    1234 		cnt_del=40;
;    1235           }
;    1236 	else if(step==s100)
	RJMP _0x4B
_0x49:
	LDI  R30,LOW(19)
	CP   R30,R11
	BRNE _0x4C
;    1237 		{
;    1238 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;    1239           cnt_del--;
	CALL SUBOPT_0x2
;    1240           if(cnt_del==0)
	BRNE _0x4D
;    1241 			{
;    1242           	step=s3;
	CALL SUBOPT_0x3
;    1243           	cnt_del=50;
;    1244 			}
;    1245 		}
_0x4D:
;    1246 
;    1247 	else if(step==s3)
	RJMP _0x4E
_0x4C:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0x4F
;    1248 		{
;    1249 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(241)
;    1250           cnt_del--;
	CALL SUBOPT_0x2
;    1251           if(cnt_del==0)
	BRNE _0x50
;    1252 			{
;    1253           	step=s4;
	LDI  R30,LOW(4)
	MOV  R11,R30
;    1254 			}
;    1255 		}
_0x50:
;    1256 	else if(step==s4)
	RJMP _0x51
_0x4F:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0x52
;    1257 		{
;    1258 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
	ORI  R16,LOW(249)
;    1259           if(!bMD2)goto step_contr_end;
	SBRS R3,2
	RJMP _0x40
;    1260           step=s54;
	LDI  R30,LOW(17)
	CALL SUBOPT_0x4
;    1261           cnt_del=20;
;    1262 		}
;    1263 	else if(step==s54)
	RJMP _0x54
_0x52:
	LDI  R30,LOW(17)
	CP   R30,R11
	BRNE _0x55
;    1264 		{
;    1265 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
	ORI  R16,LOW(249)
;    1266           cnt_del--;
	CALL SUBOPT_0x2
;    1267           if(cnt_del==0)
	BRNE _0x56
;    1268 			{
;    1269           	step=s5;
	LDI  R30,LOW(5)
	CALL SUBOPT_0x5
;    1270           	cnt_del=40;
;    1271 			}
;    1272           }
_0x56:
;    1273 
;    1274 	else if(step==s5)
	RJMP _0x57
_0x55:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0x58
;    1275 		{
;    1276 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(241)
;    1277           cnt_del--;
	CALL SUBOPT_0x2
;    1278           if(cnt_del==0)
	BRNE _0x59
;    1279 			{
;    1280           	step=s6;
	LDI  R30,LOW(6)
	MOV  R11,R30
;    1281 			}
;    1282           }
_0x59:
;    1283 	else if(step==s6)
	RJMP _0x5A
_0x58:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0x5B
;    1284 		{
;    1285 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
	ORI  R16,LOW(245)
;    1286           if(!bMD3)goto step_contr_end;
	SBRS R3,3
	RJMP _0x40
;    1287           step=s55;
	LDI  R30,LOW(18)
	CALL SUBOPT_0x5
;    1288           cnt_del=40;
;    1289 		}
;    1290 	else if(step==s55)
	RJMP _0x5D
_0x5B:
	LDI  R30,LOW(18)
	CP   R30,R11
	BRNE _0x5E
;    1291 		{
;    1292 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
	ORI  R16,LOW(245)
;    1293           cnt_del--;
	CALL SUBOPT_0x2
;    1294           if(cnt_del==0)
	BRNE _0x5F
;    1295 			{
;    1296           	step=s7;
	LDI  R30,LOW(7)
	CALL SUBOPT_0x4
;    1297           	cnt_del=20;
;    1298 			}
;    1299           }
_0x5F:
;    1300 	else if(step==s7)
	RJMP _0x60
_0x5E:
	LDI  R30,LOW(7)
	CP   R30,R11
	BRNE _0x61
;    1301 		{
;    1302 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(241)
;    1303           cnt_del--;
	CALL SUBOPT_0x2
;    1304           if(cnt_del==0)
	BRNE _0x62
;    1305 			{
;    1306           	step=s8;
	LDI  R30,LOW(8)
	CALL SUBOPT_0x6
;    1307           	cnt_del=130;
;    1308 			}
;    1309           }
_0x62:
;    1310 	else if(step==s8)
	RJMP _0x63
_0x61:
	LDI  R30,LOW(8)
	CP   R30,R11
	BRNE _0x64
;    1311 		{
;    1312 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;    1313           cnt_del--;
	CALL SUBOPT_0x2
;    1314           if(cnt_del==0)
	BRNE _0x65
;    1315 			{
;    1316           	step=s9;
	LDI  R30,LOW(9)
	CALL SUBOPT_0x4
;    1317           	cnt_del=20;
;    1318 			}
;    1319           }
_0x65:
;    1320 	else if(step==s9)
	RJMP _0x66
_0x64:
	LDI  R30,LOW(9)
	CP   R30,R11
	BRNE _0x67
;    1321 		{
;    1322 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    1323           cnt_del--;
	CALL SUBOPT_0x2
;    1324           if(cnt_del==0)
	BRNE _0x68
;    1325 			{
;    1326           	step=sOFF;
	CLR  R11
;    1327           	}
;    1328           }
_0x68:
;    1329 	}
_0x67:
_0x66:
_0x63:
_0x60:
_0x5D:
_0x5A:
_0x57:
_0x54:
_0x51:
_0x4E:
_0x4B:
_0x48:
;    1330 
;    1331 else if(prog==p2)  //ско
	RJMP _0x69
_0x42:
	LDI  R30,LOW(2)
	CP   R30,R10
	BREQ PC+3
	JMP _0x6A
;    1332 	{
;    1333 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x6B
;    1334 		{
;    1335 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    1336           if(!bMD1)goto step_contr_end;
	LDS  R30,_bMD1
	CPI  R30,0
	BRNE _0x6C
	RJMP _0x40
;    1337 
;    1338 			if(ee_vacuum_mode==evmOFF)
_0x6C:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x6E
;    1339 				{
;    1340 				goto lbl_0002;
;    1341 				}
;    1342 			else step=s2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;    1343 
;    1344           //step=s2;
;    1345 		}
;    1346 
;    1347 	else if(step==s2)
	RJMP _0x70
_0x6B:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x71
;    1348 		{
;    1349 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;    1350           if(!bVR)goto step_contr_end;
	LDS  R30,_bVR
	CPI  R30,0
	BRNE _0x72
	RJMP _0x40
;    1351 
;    1352 lbl_0002:
_0x72:
_0x6E:
;    1353           step=s100;
	CALL SUBOPT_0x1
;    1354 		cnt_del=40;
;    1355           }
;    1356 	else if(step==s100)
	RJMP _0x73
_0x71:
	LDI  R30,LOW(19)
	CP   R30,R11
	BRNE _0x74
;    1357 		{
;    1358 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;    1359           cnt_del--;
	CALL SUBOPT_0x2
;    1360           if(cnt_del==0)
	BRNE _0x75
;    1361 			{
;    1362           	step=s3;
	CALL SUBOPT_0x3
;    1363           	cnt_del=50;
;    1364 			}
;    1365 		}
_0x75:
;    1366 	else if(step==s3)
	RJMP _0x76
_0x74:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0x77
;    1367 		{
;    1368 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(241)
;    1369           cnt_del--;
	CALL SUBOPT_0x2
;    1370           if(cnt_del==0)
	BRNE _0x78
;    1371 			{
;    1372           	step=s4;
	LDI  R30,LOW(4)
	MOV  R11,R30
;    1373 			}
;    1374 		}
_0x78:
;    1375 	else if(step==s4)
	RJMP _0x79
_0x77:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0x7A
;    1376 		{
;    1377 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
	ORI  R16,LOW(249)
;    1378           if(!bMD2)goto step_contr_end;
	SBRS R3,2
	RJMP _0x40
;    1379           step=s5;
	LDI  R30,LOW(5)
	CALL SUBOPT_0x4
;    1380           cnt_del=20;
;    1381 		}
;    1382 	else if(step==s5)
	RJMP _0x7C
_0x7A:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0x7D
;    1383 		{
;    1384 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(241)
;    1385           cnt_del--;
	CALL SUBOPT_0x2
;    1386           if(cnt_del==0)
	BRNE _0x7E
;    1387 			{
;    1388           	step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x6
;    1389           	cnt_del=130;
;    1390 			}
;    1391           }
_0x7E:
;    1392 	else if(step==s6)
	RJMP _0x7F
_0x7D:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0x80
;    1393 		{
;    1394 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;    1395           cnt_del--;
	CALL SUBOPT_0x2
;    1396           if(cnt_del==0)
	BRNE _0x81
;    1397 			{
;    1398           	step=s7;
	LDI  R30,LOW(7)
	CALL SUBOPT_0x4
;    1399           	cnt_del=20;
;    1400 			}
;    1401           }
_0x81:
;    1402 	else if(step==s7)
	RJMP _0x82
_0x80:
	LDI  R30,LOW(7)
	CP   R30,R11
	BRNE _0x83
;    1403 		{
;    1404 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    1405           cnt_del--;
	CALL SUBOPT_0x2
;    1406           if(cnt_del==0)
	BRNE _0x84
;    1407 			{
;    1408           	step=sOFF;
	CLR  R11
;    1409           	}
;    1410           }
_0x84:
;    1411 	}
_0x83:
_0x82:
_0x7F:
_0x7C:
_0x79:
_0x76:
_0x73:
_0x70:
;    1412 
;    1413 else if(prog==p3)   //твист
	RJMP _0x85
_0x6A:
	LDI  R30,LOW(3)
	CP   R30,R10
	BREQ PC+3
	JMP _0x86
;    1414 	{
;    1415 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x87
;    1416 		{
;    1417 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    1418           if(!bMD1)goto step_contr_end;
	LDS  R30,_bMD1
	CPI  R30,0
	BRNE _0x88
	RJMP _0x40
;    1419 
;    1420 			if(ee_vacuum_mode==evmOFF)
_0x88:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x8A
;    1421 				{
;    1422 				goto lbl_0003;
;    1423 				}
;    1424 			else step=s2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;    1425 
;    1426           //step=s2;
;    1427 		}
;    1428 
;    1429 	else if(step==s2)
	RJMP _0x8C
_0x87:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x8D
;    1430 		{
;    1431 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;    1432           if(!bVR)goto step_contr_end;
	LDS  R30,_bVR
	CPI  R30,0
	BRNE _0x8E
	RJMP _0x40
;    1433 lbl_0003:
_0x8E:
_0x8A:
;    1434           cnt_del=50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    1435 		step=s3;
	LDI  R30,LOW(3)
	MOV  R11,R30
;    1436 		}
;    1437 
;    1438 
;    1439 	else	if(step==s3)
	RJMP _0x8F
_0x8D:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0x90
;    1440 		{
;    1441 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;    1442 		cnt_del--;
	CALL SUBOPT_0x2
;    1443 		if(cnt_del==0)
	BRNE _0x91
;    1444 			{
;    1445 			cnt_del=90;
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    1446 			step=s4;
	LDI  R30,LOW(4)
	MOV  R11,R30
;    1447 			}
;    1448           }
_0x91:
;    1449 	else if(step==s4)
	RJMP _0x92
_0x90:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0x93
;    1450 		{
;    1451 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
	ORI  R16,LOW(252)
;    1452 		cnt_del--;
	CALL SUBOPT_0x2
;    1453  		if(cnt_del==0)
	BRNE _0x94
;    1454 			{
;    1455 			cnt_del=130;
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    1456 			step=s5;
	LDI  R30,LOW(5)
	MOV  R11,R30
;    1457 			}
;    1458 		}
_0x94:
;    1459 
;    1460 	else if(step==s5)
	RJMP _0x95
_0x93:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0x96
;    1461 		{
;    1462 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
	ORI  R16,LOW(204)
;    1463 		cnt_del--;
	CALL SUBOPT_0x2
;    1464 		if(cnt_del==0)
	BRNE _0x97
;    1465 			{
;    1466 			step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x4
;    1467 			cnt_del=20;
;    1468 			}
;    1469 		}
_0x97:
;    1470 
;    1471 	else if(step==s6)
	RJMP _0x98
_0x96:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0x99
;    1472 		{
;    1473 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    1474   		cnt_del--;
	CALL SUBOPT_0x2
;    1475 		if(cnt_del==0)
	BRNE _0x9A
;    1476 			{
;    1477 			step=sOFF;
	CLR  R11
;    1478 			}
;    1479 		}
_0x9A:
;    1480 
;    1481 	}
_0x99:
_0x98:
_0x95:
_0x92:
_0x8F:
_0x8C:
;    1482 
;    1483 else if(prog==p4)      //замок
	RJMP _0x9B
_0x86:
	LDI  R30,LOW(4)
	CP   R30,R10
	BREQ PC+3
	JMP _0x9C
;    1484 	{
;    1485 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x9D
;    1486 		{
;    1487 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    1488           if(!bMD1)goto step_contr_end;
	LDS  R30,_bMD1
	CPI  R30,0
	BRNE _0x9E
	RJMP _0x40
;    1489 
;    1490 			if(ee_vacuum_mode==evmOFF)
_0x9E:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0xA0
;    1491 				{
;    1492 				goto lbl_0004;
;    1493 				}
;    1494 			else step=s2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;    1495           //step=s2;
;    1496 		}
;    1497 
;    1498 	else if(step==s2)
	RJMP _0xA2
_0x9D:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0xA3
;    1499 		{
;    1500 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;    1501           if(!bVR)goto step_contr_end;
	LDS  R30,_bVR
	CPI  R30,0
	BREQ _0x40
;    1502 lbl_0004:
_0xA0:
;    1503           step=s3;
	CALL SUBOPT_0x3
;    1504 		cnt_del=50;
;    1505           }
;    1506 
;    1507 	else if(step==s3)
	RJMP _0xA5
_0xA3:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0xA6
;    1508 		{
;    1509 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;    1510           cnt_del--;
	CALL SUBOPT_0x2
;    1511           if(cnt_del==0)
	BRNE _0xA7
;    1512 			{
;    1513           	step=s4;
	LDI  R30,LOW(4)
	CALL SUBOPT_0x7
;    1514 			cnt_del=120U;
;    1515 			}
;    1516           }
_0xA7:
;    1517 
;    1518    	else if(step==s4)
	RJMP _0xA8
_0xA6:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0xA9
;    1519 		{
;    1520 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;    1521 		cnt_del--;
	CALL SUBOPT_0x2
;    1522 		if(cnt_del==0)
	BRNE _0xAA
;    1523 			{
;    1524 			step=s5;
	LDI  R30,LOW(5)
	MOV  R11,R30
;    1525 			cnt_del=30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    1526 			}
;    1527 		}
_0xAA:
;    1528 
;    1529 	else if(step==s5)
	RJMP _0xAB
_0xA9:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0xAC
;    1530 		{
;    1531 		temp|=(1<<PP1)|(1<<PP4);
	ORI  R16,LOW(80)
;    1532 		cnt_del--;
	CALL SUBOPT_0x2
;    1533 		if(cnt_del==0)
	BRNE _0xAD
;    1534 			{
;    1535 			step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x7
;    1536 			cnt_del=120U;
;    1537 			}
;    1538 		}
_0xAD:
;    1539 
;    1540 	else if(step==s6)
	RJMP _0xAE
_0xAC:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0xAF
;    1541 		{
;    1542 		temp|=(1<<PP4);
	ORI  R16,LOW(16)
;    1543 		cnt_del--;
	CALL SUBOPT_0x2
;    1544 		if(cnt_del==0)
	BRNE _0xB0
;    1545 			{
;    1546 			step=sOFF;
	CLR  R11
;    1547 			}
;    1548 		}
_0xB0:
;    1549 
;    1550 	}
_0xAF:
_0xAE:
_0xAB:
_0xA8:
_0xA5:
_0xA2:
;    1551 	
;    1552 step_contr_end:
_0x9C:
_0x9B:
_0x85:
_0x69:
_0x40:
;    1553 
;    1554 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BRNE _0xB1
	ANDI R16,LOW(223)
;    1555 
;    1556 PORTB=~temp;
_0xB1:
	MOV  R30,R16
	COM  R30
	OUT  0x18,R30
;    1557 //PORTB=0x55;
;    1558 }
	LD   R16,Y+
	RET
;    1559 #endif
;    1560 
;    1561 #ifdef I220
;    1562 //-----------------------------------------------
;    1563 void step_contr(void)
;    1564 {
;    1565 char temp=0;
;    1566 DDRB=0xFF;
;    1567 
;    1568 if(step==sOFF)goto step_contr_end;
;    1569 
;    1570 else if(prog==p3)   //твист
;    1571 	{
;    1572 	if(step==s1)
;    1573 		{
;    1574 		temp|=(1<<PP1);
;    1575           if(!bMD1)goto step_contr_end;
;    1576 
;    1577 			if(ee_vacuum_mode==evmOFF)
;    1578 				{
;    1579 				goto lbl_0003;
;    1580 				}
;    1581 			else step=s2;
;    1582 
;    1583           //step=s2;
;    1584 		}
;    1585 
;    1586 	else if(step==s2)
;    1587 		{
;    1588 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1589           if(!bVR)goto step_contr_end;
;    1590 lbl_0003:
;    1591           cnt_del=50;
;    1592 		step=s3;
;    1593 		}
;    1594 
;    1595 
;    1596 	else	if(step==s3)
;    1597 		{
;    1598 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1599 		cnt_del--;
;    1600 		if(cnt_del==0)
;    1601 			{
;    1602 			cnt_del=ee_delay[prog,0]*10U;
;    1603 			step=s4;
;    1604 			}
;    1605           }
;    1606 	else if(step==s4)
;    1607 		{
;    1608 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1609 		cnt_del--;
;    1610  		if(cnt_del==0)
;    1611 			{
;    1612 			cnt_del=ee_delay[prog,1]*10U;
;    1613 			step=s5;
;    1614 			}
;    1615 		}
;    1616 
;    1617 	else if(step==s5)
;    1618 		{
;    1619 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1620 		cnt_del--;
;    1621 		if(cnt_del==0)
;    1622 			{
;    1623 			step=s6;
;    1624 			cnt_del=20;
;    1625 			}
;    1626 		}
;    1627 
;    1628 	else if(step==s6)
;    1629 		{
;    1630 		temp|=(1<<PP1);
;    1631   		cnt_del--;
;    1632 		if(cnt_del==0)
;    1633 			{
;    1634 			step=sOFF;
;    1635 			}
;    1636 		}
;    1637 
;    1638 	}
;    1639 
;    1640 else if(prog==p4)      //замок
;    1641 	{
;    1642 	if(step==s1)
;    1643 		{
;    1644 		temp|=(1<<PP1);
;    1645           if(!bMD1)goto step_contr_end;
;    1646 
;    1647 			if(ee_vacuum_mode==evmOFF)
;    1648 				{
;    1649 				goto lbl_0004;
;    1650 				}
;    1651 			else step=s2;
;    1652           //step=s2;
;    1653 		}
;    1654 
;    1655 	else if(step==s2)
;    1656 		{
;    1657 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1658           if(!bVR)goto step_contr_end;
;    1659 lbl_0004:
;    1660           step=s3;
;    1661 		cnt_del=50;
;    1662           }
;    1663 
;    1664 	else if(step==s3)
;    1665 		{
;    1666 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1667           cnt_del--;
;    1668           if(cnt_del==0)
;    1669 			{
;    1670           	step=s4;
;    1671 			cnt_del=ee_delay[prog,0]*10U;
;    1672 			}
;    1673           }
;    1674 
;    1675    	else if(step==s4)
;    1676 		{
;    1677 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1678 		cnt_del--;
;    1679 		if(cnt_del==0)
;    1680 			{
;    1681 			step=s5;
;    1682 			cnt_del=30;
;    1683 			}
;    1684 		}
;    1685 
;    1686 	else if(step==s5)
;    1687 		{
;    1688 		temp|=(1<<PP1)|(1<<PP4);
;    1689 		cnt_del--;
;    1690 		if(cnt_del==0)
;    1691 			{
;    1692 			step=s6;
;    1693 			cnt_del=ee_delay[prog,1]*10U;
;    1694 			}
;    1695 		}
;    1696 
;    1697 	else if(step==s6)
;    1698 		{
;    1699 		temp|=(1<<PP4);
;    1700 		cnt_del--;
;    1701 		if(cnt_del==0)
;    1702 			{
;    1703 			step=sOFF;
;    1704 			}
;    1705 		}
;    1706 
;    1707 	}
;    1708 	
;    1709 step_contr_end:
;    1710 
;    1711 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1712 
;    1713 PORTB=~temp;
;    1714 //PORTB=0x55;
;    1715 }
;    1716 #endif 
;    1717 
;    1718 #ifdef TVIST_SKO
;    1719 //-----------------------------------------------
;    1720 void step_contr(void)
;    1721 {
;    1722 char temp=0;
;    1723 DDRB=0xFF;
;    1724 
;    1725 if(step==sOFF)
;    1726 	{
;    1727 	temp=0;
;    1728 	}
;    1729 
;    1730 if(prog==p2) //СКО
;    1731 	{
;    1732 	if(step==s1)
;    1733 		{
;    1734 		temp|=(1<<PP1);
;    1735 
;    1736 		cnt_del--;
;    1737 		if(cnt_del==0)
;    1738 			{
;    1739 			step=s2;
;    1740 			cnt_del=30;
;    1741 			}
;    1742 		}
;    1743 
;    1744 	else if(step==s2)
;    1745 		{
;    1746 		temp|=(1<<PP1)|(1<<DV);
;    1747 
;    1748 		cnt_del--;
;    1749 		if(cnt_del==0)
;    1750 			{
;    1751 			step=s3;
;    1752 			}
;    1753 		}
;    1754 
;    1755 
;    1756 	else if(step==s3)
;    1757 		{
;    1758 		temp|=(1<<PP1)|(1<<DV)|(1<<PP2);
;    1759 
;    1760                	if(bMD1)//goto step_contr_end;
;    1761                		{  
;    1762                		cnt_del=100;
;    1763 	       		step=s4;
;    1764 	       		}
;    1765 	       	}
;    1766 
;    1767 	else if(step==s4)
;    1768 		{
;    1769 		temp|=(1<<PP1);
;    1770 		cnt_del--;
;    1771 		if(cnt_del==0)
;    1772 			{
;    1773 			step=sOFF;
;    1774 			}
;    1775 		}
;    1776 
;    1777 	}
;    1778 
;    1779 if(prog==p3)
;    1780 	{
;    1781 	if(step==s1)
;    1782 		{
;    1783 		temp|=(1<<PP1);
;    1784 
;    1785 		cnt_del--;
;    1786 		if(cnt_del==0)
;    1787 			{
;    1788 			step=s2;
;    1789 			cnt_del=100;
;    1790 			}
;    1791 		}
;    1792 
;    1793 	else if(step==s2)
;    1794 		{
;    1795 		temp|=(1<<PP1)|(1<<PP2);
;    1796 
;    1797 		cnt_del--;
;    1798 		if(cnt_del==0)
;    1799 			{
;    1800 			step=s3;
;    1801 			cnt_del=50;
;    1802 			}
;    1803 		}
;    1804 
;    1805 
;    1806 	else if(step==s3)
;    1807 		{
;    1808 		temp|=(1<<PP2);
;    1809 	
;    1810 		cnt_del--;
;    1811 		if(cnt_del==0)
;    1812 			{
;    1813 			step=sOFF;
;    1814 			}
;    1815                	}
;    1816 	}
;    1817 step_contr_end:
;    1818 
;    1819 PORTB=~temp;
;    1820 }
;    1821 #endif
;    1822 //-----------------------------------------------
;    1823 void bin2bcd_int(unsigned int in)
;    1824 {
_bin2bcd_int:
;    1825 char i;
;    1826 for(i=3;i>0;i--)
	ST   -Y,R16
;	in -> Y+1
;	i -> R16
	LDI  R16,LOW(3)
_0xB3:
	LDI  R30,LOW(0)
	CP   R30,R16
	BRSH _0xB4
;    1827 	{
;    1828 	dig[i]=in%10;
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
;    1829 	in/=10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
;    1830 	}   
	SUBI R16,1
	RJMP _0xB3
_0xB4:
;    1831 }
	LDD  R16,Y+0
	RJMP _0x115
;    1832 
;    1833 //-----------------------------------------------
;    1834 void bcd2ind(char s)
;    1835 {
_bcd2ind:
;    1836 char i;
;    1837 bZ=1;
	ST   -Y,R16
;	s -> Y+1
;	i -> R16
	SET
	BLD  R2,3
;    1838 for (i=0;i<5;i++)
	LDI  R16,LOW(0)
_0xB6:
	CPI  R16,5
	BRLO PC+3
	JMP _0xB7
;    1839 	{
;    1840 	if(bZ&&(!dig[i-1])&&(i<4))
	SBRS R2,3
	RJMP _0xB9
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	CPI  R30,0
	BRNE _0xB9
	CPI  R16,4
	BRLO _0xBA
_0xB9:
	RJMP _0xB8
_0xBA:
;    1841 		{
;    1842 		if((4-i)>s)
	LDI  R30,LOW(4)
	SUB  R30,R16
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
	BRSH _0xBB
;    1843 			{
;    1844 			ind_out[i-1]=DIGISYM[10];
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	POP  R26
	POP  R27
	RJMP _0x116
;    1845 			}
;    1846 		else ind_out[i-1]=DIGISYM[0];	
_0xBB:
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	LPM  R30,Z
	POP  R26
	POP  R27
_0x116:
	ST   X,R30
;    1847 		}
;    1848 	else
	RJMP _0xBD
_0xB8:
;    1849 		{
;    1850 		ind_out[i-1]=DIGISYM[dig[i-1]];
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	POP  R26
	POP  R27
	CALL SUBOPT_0x9
	POP  R26
	POP  R27
	ST   X,R30
;    1851 		bZ=0;
	CLT
	BLD  R2,3
;    1852 		}                   
_0xBD:
;    1853 
;    1854 	if(s)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0xBE
;    1855 		{
;    1856 		ind_out[3-s]&=0b01111111;
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
;    1857 		}	
;    1858  
;    1859 	}
_0xBE:
	SUBI R16,-1
	RJMP _0xB6
_0xB7:
;    1860 }            
	LDD  R16,Y+0
	ADIW R28,2
	RET
;    1861 //-----------------------------------------------
;    1862 void int2ind(unsigned int in,char s)
;    1863 {
_int2ind:
;    1864 bin2bcd_int(in);
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _bin2bcd_int
;    1865 bcd2ind(s);
	LD   R30,Y
	ST   -Y,R30
	CALL _bcd2ind
;    1866 
;    1867 } 
_0x115:
	ADIW R28,3
	RET
;    1868 
;    1869 //-----------------------------------------------
;    1870 void ind_hndl(void)
;    1871 {
_ind_hndl:
;    1872 int2ind(ee_delay[prog,sub_ind],1);  
	CALL SUBOPT_0xA
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _int2ind
;    1873 //ind_out[0]=0xff;//DIGISYM[0];
;    1874 //ind_out[1]=0xff;//DIGISYM[1];
;    1875 //ind_out[2]=DIGISYM[2];//0xff;
;    1876 //ind_out[0]=DIGISYM[7]; 
;    1877 
;    1878 ind_out[0]=DIGISYM[sub_ind+1];
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	PUSH R31
	PUSH R30
	MOV  R30,R13
	SUBI R30,-LOW(1)
	POP  R26
	POP  R27
	CALL SUBOPT_0x9
	STS  _ind_out,R30
;    1879 }
	RET
;    1880 
;    1881 //-----------------------------------------------
;    1882 void led_hndl(void)
;    1883 {
_led_hndl:
;    1884 ind_out[4]=DIGISYM[10]; 
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	__PUTB1MN _ind_out,4
;    1885 
;    1886 ind_out[4]&=~(1<<LED_POW_ON); 
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xDF
	POP  R26
	POP  R27
	ST   X,R30
;    1887 
;    1888 if(step!=sOFF)
	TST  R11
	BREQ _0xBF
;    1889 	{
;    1890 	ind_out[4]&=~(1<<LED_WRK);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xBF
	POP  R26
	POP  R27
	RJMP _0x117
;    1891 	}
;    1892 else ind_out[4]|=(1<<LED_WRK);
_0xBF:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x40
	POP  R26
	POP  R27
_0x117:
	ST   X,R30
;    1893 
;    1894 
;    1895 if(step==sOFF)
	TST  R11
	BRNE _0xC1
;    1896 	{
;    1897  	if(bERR)
	SBRS R3,1
	RJMP _0xC2
;    1898 		{
;    1899 		ind_out[4]&=~(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFE
	POP  R26
	POP  R27
	RJMP _0x118
;    1900 		}
;    1901 	else
_0xC2:
;    1902 		{
;    1903 		ind_out[4]|=(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
_0x118:
	ST   X,R30
;    1904 		}
;    1905      }
;    1906 else ind_out[4]|=(1<<LED_ERROR);
	RJMP _0xC4
_0xC1:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
	ST   X,R30
_0xC4:
;    1907 
;    1908 /* 	if(bMD1)
;    1909 		{
;    1910 		ind_out[4]&=~(1<<LED_ERROR);
;    1911 		}
;    1912 	else
;    1913 		{
;    1914 		ind_out[4]|=(1<<LED_ERROR);
;    1915 		} */
;    1916 
;    1917 //if(bERR)ind_out[4]&=~(1<<LED_ERROR);
;    1918 if(ee_vacuum_mode==evmON)ind_out[4]&=~(1<<LED_VACUUM);
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0xC5
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0x7F
	POP  R26
	POP  R27
	RJMP _0x119
;    1919 else ind_out[4]|=(1<<LED_VACUUM);
_0xC5:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x80
	POP  R26
	POP  R27
_0x119:
	ST   X,R30
;    1920 
;    1921 if(prog==p1) ind_out[4]&=~(1<<LED_PROG1);
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0xC7
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xEF
	POP  R26
	POP  R27
	ST   X,R30
;    1922 else if(prog==p2) ind_out[4]&=~(1<<LED_PROG2);
	RJMP _0xC8
_0xC7:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0xC9
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFB
	POP  R26
	POP  R27
	ST   X,R30
;    1923 else if(prog==p3) ind_out[4]&=~(1<<LED_PROG3);
	RJMP _0xCA
_0xC9:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0xCB
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0XF7
	POP  R26
	POP  R27
	ST   X,R30
;    1924 else if(prog==p4) ind_out[4]&=~(1<<LED_PROG4);
	RJMP _0xCC
_0xCB:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0xCD
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFD
	POP  R26
	POP  R27
	ST   X,R30
;    1925 
;    1926 if(ind==iPr_sel)
_0xCD:
_0xCC:
_0xCA:
_0xC8:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0xCE
;    1927 	{
;    1928 	if(bFL5)ind_out[4]|=(1<<LED_PROG1)|(1<<LED_PROG2)|(1<<LED_PROG3)|(1<<LED_PROG4);
	SBRS R3,0
	RJMP _0xCF
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,LOW(0x1E)
	POP  R26
	POP  R27
	ST   X,R30
;    1929 	}
_0xCF:
;    1930 }
_0xCE:
	RET
;    1931 
;    1932 //-----------------------------------------------
;    1933 // Подпрограмма драйва до 7 кнопок одного порта, 
;    1934 // различает короткое и длинное нажатие,
;    1935 // срабатывает на отпускание кнопки, возможность
;    1936 // ускорения перебора при длинном нажатии...
;    1937 #define but_port PORTC
;    1938 #define but_dir  DDRC
;    1939 #define but_pin  PINC
;    1940 #define but_mask 0b01101010
;    1941 #define no_but   0b11111111
;    1942 #define but_on   5
;    1943 #define but_onL  20
;    1944 
;    1945 
;    1946 
;    1947 
;    1948 void but_drv(void)
;    1949 { 
_but_drv:
;    1950 DDRD&=0b00000111;
	IN   R30,0x11
	ANDI R30,LOW(0x7)
	CALL SUBOPT_0xB
;    1951 PORTD|=0b11111000;
;    1952 
;    1953 but_port|=(but_mask^0xff);
	CALL SUBOPT_0xC
;    1954 but_dir&=but_mask;
;    1955 #asm
;    1956 nop
nop
;    1957 nop
nop
;    1958 nop
nop
;    1959 nop
nop
;    1960 #endasm

;    1961 
;    1962 but_n=but_pin|but_mask; 
	IN   R30,0x13
	ORI  R30,LOW(0x6A)
	STS  _but_n_G1,R30
;    1963 
;    1964 if((but_n==no_but)||(but_n!=but_s))
	LDS  R26,_but_n_G1
	CPI  R26,LOW(0xFF)
	BREQ _0xD1
	RCALL SUBOPT_0xD
	BREQ _0xD0
_0xD1:
;    1965  	{
;    1966  	speed=0;
	CLT
	BLD  R2,6
;    1967    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRSH _0xD4
	LDS  R26,_but1_cnt_G1
	CPI  R26,LOW(0x0)
	BREQ _0xD6
_0xD4:
	SBRS R2,4
	RJMP _0xD7
_0xD6:
	RJMP _0xD3
_0xD7:
;    1968   		{
;    1969    	     n_but=1;
	SET
	BLD  R2,5
;    1970           but=but_s;
	LDS  R9,_but_s_G1
;    1971           }
;    1972    	if (but1_cnt>=but_onL_temp)
_0xD3:
	RCALL SUBOPT_0xE
	BRLO _0xD8
;    1973   		{
;    1974    	     n_but=1;
	SET
	BLD  R2,5
;    1975           but=but_s&0b11111101;
	RCALL SUBOPT_0xF
;    1976           }
;    1977     	l_but=0;
_0xD8:
	CLT
	BLD  R2,4
;    1978    	but_onL_temp=but_onL;
	LDI  R30,LOW(20)
	STS  _but_onL_temp_G1,R30
;    1979     	but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    1980   	but1_cnt=0;          
	STS  _but1_cnt_G1,R30
;    1981      goto but_drv_out;
	RJMP _0xD9
;    1982   	}  
;    1983   	
;    1984 if(but_n==but_s)
_0xD0:
	RCALL SUBOPT_0xD
	BRNE _0xDA
;    1985  	{
;    1986   	but0_cnt++;
	LDS  R30,_but0_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but0_cnt_G1,R30
;    1987   	if(but0_cnt>=but_on)
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRLO _0xDB
;    1988   		{
;    1989    		but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    1990    		but1_cnt++;
	LDS  R30,_but1_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but1_cnt_G1,R30
;    1991    		if(but1_cnt>=but_onL_temp)
	RCALL SUBOPT_0xE
	BRLO _0xDC
;    1992    			{              
;    1993     			but=but_s&0b11111101;
	RCALL SUBOPT_0xF
;    1994     			but1_cnt=0;
	LDI  R30,LOW(0)
	STS  _but1_cnt_G1,R30
;    1995     			n_but=1;
	SET
	BLD  R2,5
;    1996     			l_but=1;
	SET
	BLD  R2,4
;    1997 			if(speed)
	SBRS R2,6
	RJMP _0xDD
;    1998 				{
;    1999     				but_onL_temp=but_onL_temp>>1;
	LDS  R30,_but_onL_temp_G1
	LSR  R30
	STS  _but_onL_temp_G1,R30
;    2000         			if(but_onL_temp<=2) but_onL_temp=2;
	LDS  R26,_but_onL_temp_G1
	LDI  R30,LOW(2)
	CP   R30,R26
	BRLO _0xDE
	STS  _but_onL_temp_G1,R30
;    2001 				}    
_0xDE:
;    2002    			}
_0xDD:
;    2003   		} 
_0xDC:
;    2004  	}
_0xDB:
;    2005 but_drv_out:
_0xDA:
_0xD9:
;    2006 but_s=but_n;
	LDS  R30,_but_n_G1
	STS  _but_s_G1,R30
;    2007 but_port|=(but_mask^0xff);
	RCALL SUBOPT_0xC
;    2008 but_dir&=but_mask;
;    2009 }    
	RET
;    2010 
;    2011 #define butV	239
;    2012 #define butV_	237
;    2013 #define butP	251
;    2014 #define butP_	249
;    2015 #define butR	127
;    2016 #define butR_	125
;    2017 #define butL	254
;    2018 #define butL_	252
;    2019 #define butLR	126
;    2020 #define butLR_	124
;    2021 //-----------------------------------------------
;    2022 void but_an(void)
;    2023 {
_but_an:
;    2024 
;    2025 if(!(in_word&0x01))
	SBRC R14,0
	RJMP _0xDF
;    2026 	{
;    2027 	#ifdef TVIST_SKO
;    2028 	if((step==sOFF)&&(!bERR))
;    2029 		{
;    2030 		step=s1;
;    2031 		if(prog==p2) cnt_del=70;
;    2032 		else if(prog==p3) cnt_del=100;
;    2033 		}
;    2034 	#endif
;    2035 	#ifndef TVIST_SKO
;    2036 	if((step==sOFF)&&(!bERR))
	LDI  R30,LOW(0)
	CP   R30,R11
	BRNE _0xE1
	SBRS R3,1
	RJMP _0xE2
_0xE1:
	RJMP _0xE0
_0xE2:
;    2037 		{
;    2038 		step=s1;
	LDI  R30,LOW(1)
	MOV  R11,R30
;    2039 		if(prog==p1) cnt_del=50;
	CP   R30,R10
	BRNE _0xE3
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2040 		else if(prog==p2) cnt_del=50;
	RJMP _0xE4
_0xE3:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0xE5
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2041 		else if(prog==p3) cnt_del=50;
	RJMP _0xE6
_0xE5:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0xE7
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2042           #ifdef P380_MINI
;    2043   		cnt_del=100;
;    2044   		#endif
;    2045 		}
_0xE7:
_0xE6:
_0xE4:
;    2046 	#endif
;    2047 	}
_0xE0:
;    2048 if(!(in_word&0x02))
_0xDF:
	SBRC R14,1
	RJMP _0xE8
;    2049 	{
;    2050 	step=sOFF;
	CLR  R11
;    2051 
;    2052 	}
;    2053 
;    2054 if (!n_but) goto but_an_end;
_0xE8:
	SBRS R2,5
	RJMP _0xEA
;    2055 
;    2056 if(but==butV_)
	LDI  R30,LOW(237)
	CP   R30,R9
	BRNE _0xEB
;    2057 	{
;    2058 	if(ee_vacuum_mode==evmON)ee_vacuum_mode=evmOFF;
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0xEC
	LDI  R30,LOW(170)
	RJMP _0x11A
;    2059 	else ee_vacuum_mode=evmON;
_0xEC:
	LDI  R30,LOW(85)
_0x11A:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMWRB
;    2060 	}
;    2061 	
;    2062 if(ind==iMn)
_0xEB:
	TST  R12
	BRNE _0xEE
;    2063 	{
;    2064 	if(but==butP_)ind=iPr_sel;
	LDI  R30,LOW(249)
	CP   R30,R9
	BRNE _0xEF
	LDI  R30,LOW(1)
	MOV  R12,R30
;    2065 	if(but==butLR)	
_0xEF:
	LDI  R30,LOW(126)
	CP   R30,R9
	BRNE _0xF0
;    2066 		{
;    2067 		if((prog==p3)||(prog==p4))
	LDI  R30,LOW(3)
	CP   R30,R10
	BREQ _0xF2
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0xF1
_0xF2:
;    2068 			{ 
;    2069 			if(sub_ind==0)sub_ind=1;
	TST  R13
	BRNE _0xF4
	LDI  R30,LOW(1)
	MOV  R13,R30
;    2070 			else sub_ind=0;
	RJMP _0xF5
_0xF4:
	CLR  R13
_0xF5:
;    2071 			}
;    2072     		else sub_ind=0;
	RJMP _0xF6
_0xF1:
	CLR  R13
_0xF6:
;    2073 		}	 
;    2074 	if((but==butR)||(but==butR_))	
_0xF0:
	LDI  R30,LOW(127)
	CP   R30,R9
	BREQ _0xF8
	LDI  R30,LOW(125)
	CP   R30,R9
	BRNE _0xF7
_0xF8:
;    2075 		{  
;    2076 		speed=1;
	SET
	BLD  R2,6
;    2077 		ee_delay[prog,sub_ind]++;
	RCALL SUBOPT_0xA
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    2078 		}   
;    2079 	
;    2080 	else if((but==butL)||(but==butL_))	
	RJMP _0xFA
_0xF7:
	LDI  R30,LOW(254)
	CP   R30,R9
	BREQ _0xFC
	LDI  R30,LOW(252)
	CP   R30,R9
	BRNE _0xFB
_0xFC:
;    2081 		{  
;    2082     		speed=1;
	SET
	BLD  R2,6
;    2083     		ee_delay[prog,sub_ind]--;
	RCALL SUBOPT_0xA
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    2084     		}		
;    2085 	} 
_0xFB:
_0xFA:
;    2086 	
;    2087 else if(ind==iPr_sel)
	RJMP _0xFE
_0xEE:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0xFF
;    2088 	{
;    2089 	if(but==butP_)ind=iMn;
	LDI  R30,LOW(249)
	CP   R30,R9
	BRNE _0x100
	CLR  R12
;    2090 	if(but==butP)
_0x100:
	LDI  R30,LOW(251)
	CP   R30,R9
	BRNE _0x101
;    2091 		{
;    2092 		prog++;
	RCALL SUBOPT_0x10
;    2093 		if(prog>MAXPROG)prog=MINPROG;
	BRGE _0x102
	LDI  R30,LOW(1)
	MOV  R10,R30
;    2094 		ee_program[0]=prog;
_0x102:
	RCALL SUBOPT_0x11
;    2095 		ee_program[1]=prog;
	__POINTW2MN _ee_program,1
	MOV  R30,R10
	CALL __EEPROMWRB
;    2096 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R10
	CALL __EEPROMWRB
;    2097 		}
;    2098 	
;    2099 	if(but==butR)
_0x101:
	LDI  R30,LOW(127)
	CP   R30,R9
	BRNE _0x103
;    2100 		{
;    2101 		prog++;
	RCALL SUBOPT_0x10
;    2102 		if(prog>MAXPROG)prog=MINPROG;
	BRGE _0x104
	LDI  R30,LOW(1)
	MOV  R10,R30
;    2103 		ee_program[0]=prog;
_0x104:
	RCALL SUBOPT_0x11
;    2104 		ee_program[1]=prog;
	__POINTW2MN _ee_program,1
	MOV  R30,R10
	CALL __EEPROMWRB
;    2105 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R10
	CALL __EEPROMWRB
;    2106 		}
;    2107 
;    2108 	if(but==butL)
_0x103:
	LDI  R30,LOW(254)
	CP   R30,R9
	BRNE _0x105
;    2109 		{
;    2110 		prog--;
	DEC  R10
;    2111 		if(prog>MAXPROG)prog=MINPROG;
	LDI  R30,LOW(4)
	CP   R30,R10
	BRGE _0x106
	LDI  R30,LOW(1)
	MOV  R10,R30
;    2112 		ee_program[0]=prog;
_0x106:
	RCALL SUBOPT_0x11
;    2113 		ee_program[1]=prog;
	__POINTW2MN _ee_program,1
	MOV  R30,R10
	CALL __EEPROMWRB
;    2114 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R10
	CALL __EEPROMWRB
;    2115 		}	
;    2116 	} 
_0x105:
;    2117 	
;    2118 
;    2119 but_an_end:
_0xFF:
_0xFE:
_0xEA:
;    2120 n_but=0;
	CLT
	BLD  R2,5
;    2121 }
	RET
;    2122 
;    2123 //-----------------------------------------------
;    2124 void ind_drv(void)
;    2125 {
_ind_drv:
;    2126 if(++ind_cnt>=6)ind_cnt=0;
	INC  R8
	LDI  R30,LOW(6)
	CP   R8,R30
	BRLO _0x107
	CLR  R8
;    2127 
;    2128 if(ind_cnt<5)
_0x107:
	LDI  R30,LOW(5)
	CP   R8,R30
	BRSH _0x108
;    2129 	{
;    2130 	DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
;    2131 	PORTC=0xFF;
	OUT  0x15,R30
;    2132 	DDRD|=0b11111000;
	IN   R30,0x11
	ORI  R30,LOW(0xF8)
	RCALL SUBOPT_0xB
;    2133 	PORTD|=0b11111000;
;    2134 	PORTD&=IND_STROB[ind_cnt];
	IN   R30,0x12
	PUSH R30
	LDI  R26,LOW(_IND_STROB*2)
	LDI  R27,HIGH(_IND_STROB*2)
	MOV  R30,R8
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	POP  R26
	AND  R30,R26
	OUT  0x12,R30
;    2135 	PORTC=ind_out[ind_cnt];
	MOV  R30,R8
	LDI  R31,0
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	LD   R30,Z
	OUT  0x15,R30
;    2136 	}
;    2137 else but_drv();
	RJMP _0x109
_0x108:
	CALL _but_drv
_0x109:
;    2138 }
	RET
;    2139 
;    2140 //***********************************************
;    2141 //***********************************************
;    2142 //***********************************************
;    2143 //***********************************************
;    2144 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;    2145 {
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
;    2146 TCCR0=0x02;
	RCALL SUBOPT_0x12
;    2147 TCNT0=-208;
;    2148 OCR0=0x00; 
;    2149 
;    2150 
;    2151 b600Hz=1;
	SET
	BLD  R2,0
;    2152 ind_drv();
	RCALL _ind_drv
;    2153 if(++t0_cnt0>=6)
	INC  R4
	LDI  R30,LOW(6)
	CP   R4,R30
	BRLO _0x10A
;    2154 	{
;    2155 	t0_cnt0=0;
	CLR  R4
;    2156 	b100Hz=1;
	SET
	BLD  R2,1
;    2157 	}
;    2158 
;    2159 if(++t0_cnt1>=60)
_0x10A:
	INC  R5
	LDI  R30,LOW(60)
	CP   R5,R30
	BRLO _0x10B
;    2160 	{
;    2161 	t0_cnt1=0;
	CLR  R5
;    2162 	b10Hz=1;
	SET
	BLD  R2,2
;    2163 	
;    2164 	if(++t0_cnt2>=2)
	INC  R6
	LDI  R30,LOW(2)
	CP   R6,R30
	BRLO _0x10C
;    2165 		{
;    2166 		t0_cnt2=0;
	CLR  R6
;    2167 		bFL5=!bFL5;
	LDI  R30,LOW(1)
	EOR  R3,R30
;    2168 		}
;    2169 		
;    2170 	if(++t0_cnt3>=5)
_0x10C:
	INC  R7
	LDI  R30,LOW(5)
	CP   R7,R30
	BRLO _0x10D
;    2171 		{
;    2172 		t0_cnt3=0;
	CLR  R7
;    2173 		bFL2=!bFL2;
	LDI  R30,LOW(128)
	EOR  R2,R30
;    2174 		}		
;    2175 	}
_0x10D:
;    2176 }
_0x10B:
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
;    2177 
;    2178 //===============================================
;    2179 //===============================================
;    2180 //===============================================
;    2181 //===============================================
;    2182 
;    2183 void main(void)
;    2184 {
_main:
;    2185 
;    2186 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
;    2187 DDRA=0x00;
	RCALL SUBOPT_0x0
;    2188 
;    2189 PORTB=0xff;
	RCALL SUBOPT_0x13
;    2190 DDRB=0xFF;
;    2191 
;    2192 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;    2193 DDRC=0x00;
	OUT  0x14,R30
;    2194 
;    2195 
;    2196 PORTD=0x00;
	OUT  0x12,R30
;    2197 DDRD=0x00;
	OUT  0x11,R30
;    2198 
;    2199 
;    2200 TCCR0=0x02;
	RCALL SUBOPT_0x12
;    2201 TCNT0=-208;
;    2202 OCR0=0x00;
;    2203 
;    2204 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;    2205 TCCR1B=0x00;
	OUT  0x2E,R30
;    2206 TCNT1H=0x00;
	OUT  0x2D,R30
;    2207 TCNT1L=0x00;
	OUT  0x2C,R30
;    2208 ICR1H=0x00;
	OUT  0x27,R30
;    2209 ICR1L=0x00;
	OUT  0x26,R30
;    2210 OCR1AH=0x00;
	OUT  0x2B,R30
;    2211 OCR1AL=0x00;
	OUT  0x2A,R30
;    2212 OCR1BH=0x00;
	OUT  0x29,R30
;    2213 OCR1BL=0x00;
	OUT  0x28,R30
;    2214 
;    2215 
;    2216 ASSR=0x00;
	OUT  0x22,R30
;    2217 TCCR2=0x00;
	OUT  0x25,R30
;    2218 TCNT2=0x00;
	OUT  0x24,R30
;    2219 OCR2=0x00;
	OUT  0x23,R30
;    2220 
;    2221 MCUCR=0x00;
	OUT  0x35,R30
;    2222 MCUCSR=0x00;
	OUT  0x34,R30
;    2223 
;    2224 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;    2225 
;    2226 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;    2227 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;    2228 
;    2229 #asm("sei") 
	sei
;    2230 PORTB=0xFF;
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x13
;    2231 DDRB=0xFF;
;    2232 ind=iMn;
	CLR  R12
;    2233 prog_drv();
	CALL _prog_drv
;    2234 ind_hndl();
	CALL _ind_hndl
;    2235 led_hndl();
	CALL _led_hndl
;    2236 while (1)
_0x10E:
;    2237       {
;    2238       if(b600Hz)
	SBRS R2,0
	RJMP _0x111
;    2239 		{
;    2240 		b600Hz=0; 
	CLT
	BLD  R2,0
;    2241           
;    2242 		}         
;    2243       if(b100Hz)
_0x111:
	SBRS R2,1
	RJMP _0x112
;    2244 		{        
;    2245 		b100Hz=0; 
	CLT
	BLD  R2,1
;    2246 		but_an();
	RCALL _but_an
;    2247 	    	in_drv();
	CALL _in_drv
;    2248           mdvr_drv();
	CALL _mdvr_drv
;    2249           step_contr();
	CALL _step_contr
;    2250 		}   
;    2251 	if(b10Hz)
_0x112:
	SBRS R2,2
	RJMP _0x113
;    2252 		{
;    2253 		b10Hz=0;
	CLT
	BLD  R2,2
;    2254 		prog_drv();
	CALL _prog_drv
;    2255 		err_drv();
	CALL _err_drv
;    2256 		
;    2257     	     ind_hndl();
	CALL _ind_hndl
;    2258           led_hndl();
	CALL _led_hndl
;    2259           
;    2260           }
;    2261 
;    2262       };
_0x113:
	RJMP _0x10E
;    2263 }
_0x114:
	RJMP _0x114

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	LDI  R30,LOW(255)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	LDI  R30,LOW(19)
	MOV  R11,R30
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES
SUBOPT_0x2:
	LDS  R30,_cnt_del
	LDS  R31,_cnt_del+1
	SBIW R30,1
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x3:
	LDI  R30,LOW(3)
	MOV  R11,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x4:
	MOV  R11,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5:
	MOV  R11,R30
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6:
	MOV  R11,R30
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7:
	MOV  R11,R30
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x8:
	MOV  R30,R16
	SUBI R30,LOW(1)
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x9:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xA:
	MOV  R30,R10
	LDI  R26,LOW(_ee_delay)
	LDI  R27,HIGH(_ee_delay)
	LDI  R31,0
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R13
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB:
	OUT  0x11,R30
	IN   R30,0x12
	ORI  R30,LOW(0xF8)
	OUT  0x12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xC:
	IN   R30,0x15
	ORI  R30,LOW(0x95)
	OUT  0x15,R30
	IN   R30,0x14
	ANDI R30,LOW(0x6A)
	OUT  0x14,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD:
	LDS  R30,_but_s_G1
	LDS  R26,_but_n_G1
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE:
	LDS  R30,_but_onL_temp_G1
	LDS  R26,_but1_cnt_G1
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF:
	LDS  R30,_but_s_G1
	ANDI R30,0xFD
	MOV  R9,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10:
	INC  R10
	LDI  R30,LOW(4)
	CP   R30,R10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x11:
	MOV  R30,R10
	LDI  R26,LOW(_ee_program)
	LDI  R27,HIGH(_ee_program)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x12:
	LDI  R30,LOW(2)
	OUT  0x33,R30
	LDI  R30,LOW(65328)
	LDI  R31,HIGH(65328)
	OUT  0x32,R30
	LDI  R30,LOW(0)
	OUT  0x3C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x13:
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

