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
;      14 #define I220
;      15 //#define P380_MINI
;      16 //#define TVIST_SKO
;      17 //#define I380_WI
;      18 //#define I220_WI
;      19 //#define DV3KL2MD
;      20 
;      21 #define MD1	2
;      22 #define MD2	3
;      23 #define VR	4
;      24 #define MD3	5
;      25 
;      26 #define PP1	6
;      27 #define PP2	7
;      28 #define PP3	5
;      29 #define PP4	4
;      30 #define PP5	3
;      31 #define DV	0 
;      32 
;      33 #define PP7	2
;      34 
;      35 #ifdef P380_MINI
;      36 #define MINPROG 1
;      37 #define MAXPROG 1 
;      38 #ifdef GAVT3
;      39 #define DV	2
;      40 #endif
;      41 #define PP3	3
;      42 #endif 
;      43 
;      44 #ifdef P380
;      45 #define MINPROG 1
;      46 #define MAXPROG 3 
;      47 #ifdef GAVT3
;      48 #define DV	2
;      49 #endif
;      50 #endif 
;      51 
;      52 #ifdef I380
;      53 #define MINPROG 1
;      54 #define MAXPROG 4
;      55 #endif
;      56 
;      57 #ifdef I380_WI
;      58 #define MINPROG 1
;      59 #define MAXPROG 4
;      60 #endif
;      61 
;      62 #ifdef I220
;      63 #define MINPROG 3
;      64 #define MAXPROG 4
;      65 #endif
;      66 
;      67 
;      68 #ifdef I220_WI
;      69 #define MINPROG 3
;      70 #define MAXPROG 4
;      71 #endif
;      72 
;      73 #ifdef TVIST_SKO
;      74 #define MINPROG 2
;      75 #define MAXPROG 3
;      76 #define DV	2
;      77 #endif
;      78 
;      79 #ifdef DV3KL2MD
;      80 
;      81 #define PP1	3
;      82 #define PP2	2
;      83 #define PP3	1
;      84 //#define PP4	4
;      85 //#define PP5	3
;      86 #define DV	0 
;      87 
;      88 #define MINPROG 2
;      89 #define MAXPROG 3
;      90 
;      91 #endif
;      92 
;      93 bit b600Hz;
;      94 
;      95 bit b100Hz;
;      96 bit b10Hz;
;      97 char t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3;
;      98 char ind_cnt;
;      99 flash char IND_STROB[]={0b10111111,0b11011111,0b11101111,0b11110111,0b01111111};

	.CSEG
;     100 flash char DIGISYM[]={0b11000000,0b11111001,0b10100100,0b10110000,0b10011001,0b10010010,0b10000010,0b11111000,0b10000000,0b10010000,0b11111111};								
;     101 
;     102 char ind_out[5]={0x255,0x255,0x255,0x255,0x255};

	.DSEG
_ind_out:
	.BYTE 0x5
;     103 char dig[4];
_dig:
	.BYTE 0x4
;     104 bit bZ;    
;     105 char but;
;     106 static char but_n;
_but_n_G1:
	.BYTE 0x1
;     107 static char but_s;
_but_s_G1:
	.BYTE 0x1
;     108 static char but0_cnt;
_but0_cnt_G1:
	.BYTE 0x1
;     109 static char but1_cnt;
_but1_cnt_G1:
	.BYTE 0x1
;     110 static char but_onL_temp;
_but_onL_temp_G1:
	.BYTE 0x1
;     111 bit l_but;		//идет длинное нажатие на кнопку
;     112 bit n_but;          //произошло нажатие
;     113 bit speed;		//разрешение ускорения перебора 
;     114 bit bFL2; 
;     115 bit bFL5;
;     116 eeprom enum{evmON=0x55,evmOFF=0xaa}ee_vacuum_mode;

	.ESEG
_ee_vacuum_mode:
	.DB  0x0
;     117 eeprom char ee_program[2];
_ee_program:
	.DB  0x0
	.DB  0x0
;     118 enum {p1=1,p2=2,p3=3,p4=4}prog;
;     119 enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}step=sOFF;
;     120 enum {iMn,iPr_sel,iVr} ind;
;     121 char sub_ind;
;     122 char in_word,in_word_old,in_word_new,in_word_cnt;

	.DSEG
_in_word_old:
	.BYTE 0x1
_in_word_new:
	.BYTE 0x1
_in_word_cnt:
	.BYTE 0x1
;     123 bit bERR;
;     124 signed int cnt_del=0;
_cnt_del:
	.BYTE 0x2
;     125 
;     126 char bVR;
_bVR:
	.BYTE 0x1
;     127 char bMD1;
_bMD1:
	.BYTE 0x1
;     128 bit bMD2;
;     129 bit bMD3;
;     130 char cnt_md1,cnt_md2,cnt_vr,cnt_md3;
_cnt_md1:
	.BYTE 0x1
_cnt_md2:
	.BYTE 0x1
_cnt_vr:
	.BYTE 0x1
_cnt_md3:
	.BYTE 0x1
;     131 
;     132 eeprom unsigned ee_delay[4,2];

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
;     133 eeprom char ee_vr_log;
_ee_vr_log:
	.DB  0x0
;     134 #include <mega16.h>
;     135 //#include <mega8535.h>
;     136 //-----------------------------------------------
;     137 void prog_drv(void)
;     138 {

	.CSEG
_prog_drv:
;     139 char temp,temp1,temp2;
;     140 
;     141 temp=ee_program[0];
	CALL __SAVELOCR3
;	temp -> R16
;	temp1 -> R17
;	temp2 -> R18
	LDI  R26,LOW(_ee_program)
	LDI  R27,HIGH(_ee_program)
	CALL __EEPROMRDB
	MOV  R16,R30
;     142 temp1=ee_program[1];
	__POINTW2MN _ee_program,1
	CALL __EEPROMRDB
	MOV  R17,R30
;     143 temp2=ee_program[2];
	__POINTW2MN _ee_program,2
	CALL __EEPROMRDB
	MOV  R18,R30
;     144 
;     145 if((temp==temp1)&&(temp==temp2))
	CP   R17,R16
	BRNE _0x5
	CP   R18,R16
	BREQ _0x6
_0x5:
	RJMP _0x4
_0x6:
;     146 	{
;     147 	}
;     148 else if((temp==temp1)&&(temp!=temp2))
	RJMP _0x7
_0x4:
	CP   R17,R16
	BRNE _0x9
	CP   R18,R16
	BRNE _0xA
_0x9:
	RJMP _0x8
_0xA:
;     149 	{
;     150 	temp2=temp;
	MOV  R18,R16
;     151 	}
;     152 else if((temp!=temp1)&&(temp==temp2))
	RJMP _0xB
_0x8:
	CP   R17,R16
	BREQ _0xD
	CP   R18,R16
	BREQ _0xE
_0xD:
	RJMP _0xC
_0xE:
;     153 	{
;     154 	temp1=temp;
	MOV  R17,R16
;     155 	}
;     156 else if((temp!=temp1)&&(temp1==temp2))
	RJMP _0xF
_0xC:
	CP   R17,R16
	BREQ _0x11
	CP   R18,R17
	BREQ _0x12
_0x11:
	RJMP _0x10
_0x12:
;     157 	{
;     158 	temp=temp1;
	MOV  R16,R17
;     159 	}
;     160 else if((temp!=temp1)&&(temp!=temp2))
	RJMP _0x13
_0x10:
	CP   R17,R16
	BREQ _0x15
	CP   R18,R16
	BRNE _0x16
_0x15:
	RJMP _0x14
_0x16:
;     161 	{
;     162 	temp=MINPROG;
	LDI  R16,LOW(3)
;     163 	temp1=MINPROG;
	LDI  R17,LOW(3)
;     164 	temp2=MINPROG;
	LDI  R18,LOW(3)
;     165 	}
;     166 
;     167 if(!((temp<=MAXPROG)&&(temp>=MINPROG)))
_0x14:
_0x13:
_0xF:
_0xB:
_0x7:
	LDI  R30,LOW(4)
	CP   R30,R16
	BRLO _0x18
	CPI  R16,3
	BRSH _0x17
_0x18:
;     168 	{
;     169 	temp=MINPROG;
	LDI  R16,LOW(3)
;     170 	}
;     171 
;     172 if(temp!=ee_program[0])ee_program[0]=temp;
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
;     173 if(temp!=ee_program[1])ee_program[1]=temp;
_0x1A:
	__POINTW2MN _ee_program,1
	CALL __EEPROMRDB
	CP   R30,R16
	BREQ _0x1B
	__POINTW2MN _ee_program,1
	MOV  R30,R16
	CALL __EEPROMWRB
;     174 if(temp!=ee_program[2])ee_program[2]=temp;
_0x1B:
	__POINTW2MN _ee_program,2
	CALL __EEPROMRDB
	CP   R30,R16
	BREQ _0x1C
	__POINTW2MN _ee_program,2
	MOV  R30,R16
	CALL __EEPROMWRB
;     175 
;     176 prog=temp;
_0x1C:
	MOV  R10,R16
;     177 }
	CALL __LOADLOCR3
	RJMP _0xE1
;     178 
;     179 //-----------------------------------------------
;     180 void in_drv(void)
;     181 {
_in_drv:
;     182 char i,temp;
;     183 unsigned int tempUI;
;     184 DDRA=0x00;
	CALL __SAVELOCR4
;	i -> R16
;	temp -> R17
;	tempUI -> R18,R19
	CALL SUBOPT_0x0
;     185 PORTA=0xff;
	OUT  0x1B,R30
;     186 in_word_new=PINA;
	IN   R30,0x19
	STS  _in_word_new,R30
;     187 if(in_word_old==in_word_new)
	LDS  R26,_in_word_old
	CP   R30,R26
	BRNE _0x1D
;     188 	{
;     189 	if(in_word_cnt<10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRSH _0x1E
;     190 		{
;     191 		in_word_cnt++;
	LDS  R30,_in_word_cnt
	SUBI R30,-LOW(1)
	STS  _in_word_cnt,R30
;     192 		if(in_word_cnt>=10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRLO _0x1F
;     193 			{
;     194 			in_word=in_word_old;
	LDS  R14,_in_word_old
;     195 			}
;     196 		}
_0x1F:
;     197 	}
_0x1E:
;     198 else in_word_cnt=0;
	RJMP _0x20
_0x1D:
	LDI  R30,LOW(0)
	STS  _in_word_cnt,R30
_0x20:
;     199 
;     200 
;     201 in_word_old=in_word_new;
	LDS  R30,_in_word_new
	STS  _in_word_old,R30
;     202 }   
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;     203 
;     204 #ifdef TVIST_SKO
;     205 //-----------------------------------------------
;     206 void err_drv(void)
;     207 {
;     208 if(step==sOFF)
;     209 	{
;     210     	if(prog==p2)	
;     211     		{
;     212        		if(bMD1) bERR=1;
;     213        		else bERR=0;
;     214 		}
;     215 	}
;     216 else bERR=0;
;     217 }
;     218 #endif  
;     219 
;     220 #ifndef TVIST_SKO
;     221 //-----------------------------------------------
;     222 void err_drv(void)
;     223 {
_err_drv:
;     224 if(step==sOFF)
	TST  R11
	BRNE _0x21
;     225 	{
;     226 	if((bMD1)||(bMD2)||(bVR)||(bMD3)) bERR=1;
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
;     227 	else bERR=0;
	RJMP _0x25
_0x22:
	CLT
	BLD  R3,1
_0x25:
;     228 	}
;     229 else bERR=0;
	RJMP _0x26
_0x21:
	CLT
	BLD  R3,1
_0x26:
;     230 }
	RET
;     231 #endif
;     232 //-----------------------------------------------
;     233 void mdvr_drv(void)
;     234 {
_mdvr_drv:
;     235 if(!(in_word&(1<<MD1)))
	SBRC R14,2
	RJMP _0x27
;     236 	{
;     237 	if(cnt_md1<10)
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRSH _0x28
;     238 		{
;     239 		cnt_md1++;
	LDS  R30,_cnt_md1
	SUBI R30,-LOW(1)
	STS  _cnt_md1,R30
;     240 		if(cnt_md1==10) bMD1=1;
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRNE _0x29
	LDI  R30,LOW(1)
	STS  _bMD1,R30
;     241 		}
_0x29:
;     242 
;     243 	}
_0x28:
;     244 else
	RJMP _0x2A
_0x27:
;     245 	{
;     246 	if(cnt_md1)
	LDS  R30,_cnt_md1
	CPI  R30,0
	BREQ _0x2B
;     247 		{
;     248 		cnt_md1--;
	SUBI R30,LOW(1)
	STS  _cnt_md1,R30
;     249 		if(cnt_md1==0) bMD1=0;
	CPI  R30,0
	BRNE _0x2C
	LDI  R30,LOW(0)
	STS  _bMD1,R30
;     250 		}
_0x2C:
;     251 
;     252 	}
_0x2B:
_0x2A:
;     253 
;     254 if(!(in_word&(1<<MD2)))
	SBRC R14,3
	RJMP _0x2D
;     255 	{
;     256 	if(cnt_md2<10)
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRSH _0x2E
;     257 		{
;     258 		cnt_md2++;
	LDS  R30,_cnt_md2
	SUBI R30,-LOW(1)
	STS  _cnt_md2,R30
;     259 		if(cnt_md2==10) bMD2=1;
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRNE _0x2F
	SET
	BLD  R3,2
;     260 		}
_0x2F:
;     261 
;     262 	}
_0x2E:
;     263 else
	RJMP _0x30
_0x2D:
;     264 	{
;     265 	if(cnt_md2)
	LDS  R30,_cnt_md2
	CPI  R30,0
	BREQ _0x31
;     266 		{
;     267 		cnt_md2--;
	SUBI R30,LOW(1)
	STS  _cnt_md2,R30
;     268 		if(cnt_md2==0) bMD2=0;
	CPI  R30,0
	BRNE _0x32
	CLT
	BLD  R3,2
;     269 		}
_0x32:
;     270 
;     271 	}
_0x31:
_0x30:
;     272 
;     273 if(!(in_word&(1<<MD3)))
	SBRC R14,5
	RJMP _0x33
;     274 	{
;     275 	if(cnt_md3<10)
	LDS  R26,_cnt_md3
	CPI  R26,LOW(0xA)
	BRSH _0x34
;     276 		{
;     277 		cnt_md3++;
	LDS  R30,_cnt_md3
	SUBI R30,-LOW(1)
	STS  _cnt_md3,R30
;     278 		if(cnt_md3==10) bMD3=1;
	LDS  R26,_cnt_md3
	CPI  R26,LOW(0xA)
	BRNE _0x35
	SET
	BLD  R3,3
;     279 		}
_0x35:
;     280 
;     281 	}
_0x34:
;     282 else
	RJMP _0x36
_0x33:
;     283 	{
;     284 	if(cnt_md3)
	LDS  R30,_cnt_md3
	CPI  R30,0
	BREQ _0x37
;     285 		{
;     286 		cnt_md3--;
	SUBI R30,LOW(1)
	STS  _cnt_md3,R30
;     287 		if(cnt_md3==0) bMD3=0;
	CPI  R30,0
	BRNE _0x38
	CLT
	BLD  R3,3
;     288 		}
_0x38:
;     289 
;     290 	}
_0x37:
_0x36:
;     291 
;     292 if(((!(in_word&(1<<VR)))&&(ee_vr_log)) || (((in_word&(1<<VR)))&&(!ee_vr_log)))
	SBRC R14,4
	RJMP _0x3A
	LDI  R26,LOW(_ee_vr_log)
	LDI  R27,HIGH(_ee_vr_log)
	CALL __EEPROMRDB
	CPI  R30,0
	BRNE _0x3C
_0x3A:
	SBRS R14,4
	RJMP _0x3D
	LDI  R26,LOW(_ee_vr_log)
	LDI  R27,HIGH(_ee_vr_log)
	CALL __EEPROMRDB
	CPI  R30,0
	BREQ _0x3C
_0x3D:
	RJMP _0x39
_0x3C:
;     293 	{
;     294 	if(cnt_vr<10)
	LDS  R26,_cnt_vr
	CPI  R26,LOW(0xA)
	BRSH _0x40
;     295 		{
;     296 		cnt_vr++;
	LDS  R30,_cnt_vr
	SUBI R30,-LOW(1)
	STS  _cnt_vr,R30
;     297 		if(cnt_vr==10) bVR=1;
	LDS  R26,_cnt_vr
	CPI  R26,LOW(0xA)
	BRNE _0x41
	LDI  R30,LOW(1)
	STS  _bVR,R30
;     298 		}
_0x41:
;     299 
;     300 	}
_0x40:
;     301 else
	RJMP _0x42
_0x39:
;     302 	{
;     303 	if(cnt_vr)
	LDS  R30,_cnt_vr
	CPI  R30,0
	BREQ _0x43
;     304 		{
;     305 		cnt_vr--;
	SUBI R30,LOW(1)
	STS  _cnt_vr,R30
;     306 		if(cnt_vr==0) bVR=0;
	CPI  R30,0
	BRNE _0x44
	LDI  R30,LOW(0)
	STS  _bVR,R30
;     307 		}
_0x44:
;     308 
;     309 	}
_0x43:
_0x42:
;     310 } 
	RET
;     311 
;     312 #ifdef DV3KL2MD
;     313 //-----------------------------------------------
;     314 void step_contr(void)
;     315 {
;     316 char temp=0;
;     317 DDRB=0xFF;
;     318 
;     319 if(step==sOFF)
;     320 	{
;     321 	temp=0;
;     322 	}
;     323 
;     324 else if(step==s1)
;     325 	{
;     326 	temp|=(1<<PP1);
;     327 
;     328 	cnt_del--;
;     329 	if(cnt_del==0)
;     330 		{
;     331 		step=s2;
;     332 		cnt_del=20;
;     333 		}
;     334 	}
;     335 
;     336 
;     337 else if(step==s2)
;     338 	{
;     339 	temp|=(1<<PP1)|(1<<DV);
;     340 
;     341 	cnt_del--;
;     342 	if(cnt_del==0)
;     343 		{
;     344 		step=s3;
;     345 		}
;     346 	}
;     347 	
;     348 else if(step==s3)
;     349 	{
;     350 	temp|=(1<<PP1)|(1<<PP2)|(1<<DV);
;     351      if(!bMD1)goto step_contr_end;
;     352      step=s4;
;     353      }     
;     354 else if(step==s4)
;     355 	{          
;     356      temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     357      if(!bMD2)goto step_contr_end;
;     358      step=s5;
;     359      cnt_del=30;
;     360      } 
;     361      
;     362 else if(step==s5)
;     363 	{
;     364 	temp|=(1<<PP1)|(1<<DV);
;     365 
;     366 	cnt_del--;
;     367 	if(cnt_del==0)
;     368 		{
;     369 		step=s6;
;     370 		cnt_del=70;
;     371 		}
;     372 	}     
;     373 else if(step==s6)
;     374 		{
;     375 	temp|=(1<<PP1);
;     376 	cnt_del--;
;     377 	if(cnt_del==0)
;     378 		{
;     379 		step=sOFF;
;     380           }     
;     381      }     
;     382 
;     383 step_contr_end:
;     384 
;     385 PORTB=~temp;
;     386 }
;     387 #endif
;     388 
;     389 #ifdef P380_MINI
;     390 //-----------------------------------------------
;     391 void step_contr(void)
;     392 {
;     393 char temp=0;
;     394 DDRB=0xFF;
;     395 
;     396 if(step==sOFF)
;     397 	{
;     398 	temp=0;
;     399 	}
;     400 
;     401 else if(step==s1)
;     402 	{
;     403 	temp|=(1<<PP1);
;     404 
;     405 	cnt_del--;
;     406 	if(cnt_del==0)
;     407 		{
;     408 		step=s2;
;     409 		}
;     410 	}
;     411 
;     412 else if(step==s2)
;     413 	{
;     414 	temp|=(1<<PP1)|(1<<PP2)|(1<<DV);
;     415      if(!bMD1)goto step_contr_end;
;     416      step=s3;
;     417      }     
;     418 else if(step==s3)
;     419 	{          
;     420      temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     421      if(!bMD2)goto step_contr_end;
;     422      step=s4;
;     423      cnt_del=50;
;     424      }
;     425 else if(step==s4)
;     426 		{
;     427 	temp|=(1<<PP1);
;     428 	cnt_del--;
;     429 	if(cnt_del==0)
;     430 		{
;     431 		step=sOFF;
;     432           }     
;     433      }     
;     434 
;     435 step_contr_end:
;     436 
;     437 PORTB=~temp;
;     438 }
;     439 #endif
;     440 
;     441 #ifdef P380
;     442 //-----------------------------------------------
;     443 void step_contr(void)
;     444 {
;     445 char temp=0;
;     446 DDRB=0xFF;
;     447 
;     448 if(step==sOFF)
;     449 	{
;     450 	temp=0;
;     451 	}
;     452 
;     453 else if(prog==p1)
;     454 	{
;     455 	if(step==s1)
;     456 		{
;     457 		temp|=(1<<PP1)|(1<<PP2);
;     458 
;     459 		cnt_del--;
;     460 		if(cnt_del==0)
;     461 			{
;     462 			if(ee_vacuum_mode==evmOFF)
;     463 				{
;     464 				goto lbl_0001;
;     465 				}
;     466 			else step=s2;
;     467 			}
;     468 		}
;     469 
;     470 	else if(step==s2)
;     471 		{
;     472 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     473 
;     474           if(!bVR)goto step_contr_end;
;     475 lbl_0001:
;     476 #ifndef BIG_CAM
;     477 		cnt_del=30;
;     478 #endif
;     479 
;     480 #ifdef BIG_CAM
;     481 		cnt_del=100;
;     482 #endif
;     483 		step=s3;
;     484 		}
;     485 
;     486 	else if(step==s3)
;     487 		{
;     488 		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     489 		cnt_del--;
;     490 		if(cnt_del==0)
;     491 			{
;     492 			step=s4;
;     493 			}
;     494           }
;     495 	else if(step==s4)
;     496 		{
;     497 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     498 
;     499           if(!bMD1)goto step_contr_end;
;     500 
;     501 		cnt_del=40;
;     502 		step=s5;
;     503 		}
;     504 	else if(step==s5)
;     505 		{
;     506 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     507 
;     508 		cnt_del--;
;     509 		if(cnt_del==0)
;     510 			{
;     511 			step=s6;
;     512 			}
;     513 		}
;     514 	else if(step==s6)
;     515 		{
;     516 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     517 
;     518          	if(!bMD2)goto step_contr_end;
;     519           cnt_del=40;
;     520 		//step=s7;
;     521 		
;     522           step=s55;
;     523           cnt_del=40;
;     524 		}
;     525 	else if(step==s55)
;     526 		{
;     527 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     528           cnt_del--;
;     529           if(cnt_del==0)
;     530 			{
;     531           	step=s7;
;     532           	cnt_del=20;
;     533 			}
;     534          		
;     535 		}
;     536 	else if(step==s7)
;     537 		{
;     538 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     539 
;     540 		cnt_del--;
;     541 		if(cnt_del==0)
;     542 			{
;     543 			step=s8;
;     544 			cnt_del=30;
;     545 			}
;     546 		}
;     547 	else if(step==s8)
;     548 		{
;     549 		temp|=(1<<PP1)|(1<<PP3);
;     550 
;     551 		cnt_del--;
;     552 		if(cnt_del==0)
;     553 			{
;     554 			step=s9;
;     555 #ifndef BIG_CAM
;     556 		cnt_del=150;
;     557 #endif
;     558 
;     559 #ifdef BIG_CAM
;     560 		cnt_del=200;
;     561 #endif
;     562 			}
;     563 		}
;     564 	else if(step==s9)
;     565 		{
;     566 		temp|=(1<<PP1)|(1<<PP2);
;     567 
;     568 		cnt_del--;
;     569 		if(cnt_del==0)
;     570 			{
;     571 			step=s10;
;     572 			cnt_del=30;
;     573 			}
;     574 		}
;     575 	else if(step==s10)
;     576 		{
;     577 		temp|=(1<<PP2);
;     578 		cnt_del--;
;     579 		if(cnt_del==0)
;     580 			{
;     581 			step=sOFF;
;     582 			}
;     583 		}
;     584 	}
;     585 
;     586 if(prog==p2)
;     587 	{
;     588 
;     589 	if(step==s1)
;     590 		{
;     591 		temp|=(1<<PP1)|(1<<PP2);
;     592 
;     593 		cnt_del--;
;     594 		if(cnt_del==0)
;     595 			{
;     596 			if(ee_vacuum_mode==evmOFF)
;     597 				{
;     598 				goto lbl_0002;
;     599 				}
;     600 			else step=s2;
;     601 			}
;     602 		}
;     603 
;     604 	else if(step==s2)
;     605 		{
;     606 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     607 
;     608           if(!bVR)goto step_contr_end;
;     609 lbl_0002:
;     610 #ifndef BIG_CAM
;     611 		cnt_del=30;
;     612 #endif
;     613 
;     614 #ifdef BIG_CAM
;     615 		cnt_del=100;
;     616 #endif
;     617 		step=s3;
;     618 		}
;     619 
;     620 	else if(step==s3)
;     621 		{
;     622 		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     623 
;     624 		cnt_del--;
;     625 		if(cnt_del==0)
;     626 			{
;     627 			step=s4;
;     628 			}
;     629 		}
;     630 
;     631 	else if(step==s4)
;     632 		{
;     633 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     634 
;     635           if(!bMD1)goto step_contr_end;
;     636          	cnt_del=30;
;     637 		step=s5;
;     638 		}
;     639 
;     640 	else if(step==s5)
;     641 		{
;     642 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     643 
;     644 		cnt_del--;
;     645 		if(cnt_del==0)
;     646 			{
;     647 			step=s6;
;     648 			cnt_del=30;
;     649 			}
;     650 		}
;     651 
;     652 	else if(step==s6)
;     653 		{
;     654 		temp|=(1<<PP1)|(1<<PP3);
;     655 
;     656 		cnt_del--;
;     657 		if(cnt_del==0)
;     658 			{
;     659 			step=s7;
;     660 #ifndef BIG_CAM
;     661 		cnt_del=150;
;     662 #endif
;     663 
;     664 #ifdef BIG_CAM
;     665 		cnt_del=200;
;     666 #endif
;     667 			}
;     668 		}
;     669 
;     670 	else if(step==s7)
;     671 		{
;     672 		temp|=(1<<PP1)|(1<<PP2);
;     673 
;     674 		cnt_del--;
;     675 		if(cnt_del==0)
;     676 			{
;     677 			step=s8;
;     678 			cnt_del=30;
;     679 			}
;     680 		}
;     681 	else if(step==s8)
;     682 		{
;     683 		temp|=(1<<PP2);
;     684 
;     685 		cnt_del--;
;     686 		if(cnt_del==0)
;     687 			{
;     688 			step=sOFF;
;     689 			}
;     690 		}
;     691 	}
;     692 
;     693 if(prog==p3)
;     694 	{
;     695 
;     696 	if(step==s1)
;     697 		{
;     698 		temp|=(1<<PP1)|(1<<PP2);
;     699 
;     700 		cnt_del--;
;     701 		if(cnt_del==0)
;     702 			{
;     703 			if(ee_vacuum_mode==evmOFF)
;     704 				{
;     705 				goto lbl_0003;
;     706 				}
;     707 			else step=s2;
;     708 			}
;     709 		}
;     710 
;     711 	else if(step==s2)
;     712 		{
;     713 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     714 
;     715           if(!bVR)goto step_contr_end;
;     716 lbl_0003:
;     717 #ifndef BIG_CAM
;     718 		cnt_del=80;
;     719 #endif
;     720 
;     721 #ifdef BIG_CAM
;     722 		cnt_del=100;
;     723 #endif
;     724 		step=s3;
;     725 		}
;     726 
;     727 	else if(step==s3)
;     728 		{
;     729 		temp|=(1<<PP1)|(1<<PP3);
;     730 
;     731 		cnt_del--;
;     732 		if(cnt_del==0)
;     733 			{
;     734 			step=s4;
;     735 			cnt_del=120;
;     736 			}
;     737 		}
;     738 
;     739 	else if(step==s4)
;     740 		{
;     741 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<PP5);
;     742 
;     743 		cnt_del--;
;     744 		if(cnt_del==0)
;     745 			{
;     746 			step=s5;
;     747 
;     748 		
;     749 #ifndef BIG_CAM
;     750 		cnt_del=150;
;     751 #endif
;     752 
;     753 #ifdef BIG_CAM
;     754 		cnt_del=200;
;     755 #endif
;     756 	//	step=s5;
;     757 	}
;     758 		}
;     759 
;     760 	else if(step==s5)
;     761 		{
;     762 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<PP5);
;     763 
;     764 		cnt_del--;
;     765 		if(cnt_del==0)
;     766 			{
;     767 			step=s6;
;     768 			cnt_del=30;
;     769 			}
;     770 		}
;     771 
;     772 	else if(step==s6)
;     773 		{
;     774 		temp|=(1<<PP2)|(1<<PP4)|(1<<PP5);
;     775 
;     776 		cnt_del--;
;     777 		if(cnt_del==0)
;     778 			{
;     779 			step=s7;
;     780 			cnt_del=30;
;     781 			}
;     782 		}
;     783 
;     784 	else if(step==s7)
;     785 		{
;     786 		temp|=(1<<PP2);
;     787 
;     788 		cnt_del--;
;     789 		if(cnt_del==0)
;     790 			{
;     791 			step=sOFF;
;     792 			}
;     793 		}
;     794 
;     795 	}
;     796 step_contr_end:
;     797 
;     798 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;     799 
;     800 PORTB=~temp;
;     801 }
;     802 #endif
;     803 #ifdef I380
;     804 //-----------------------------------------------
;     805 void step_contr(void)
;     806 {
;     807 char temp=0;
;     808 DDRB=0xFF;
;     809 
;     810 if(step==sOFF)goto step_contr_end;
;     811 
;     812 else if(prog==p1)
;     813 	{
;     814 	if(step==s1)    //жесть
;     815 		{
;     816 		temp|=(1<<PP1);
;     817           if(!bMD1)goto step_contr_end;
;     818 
;     819 			if(ee_vacuum_mode==evmOFF)
;     820 				{
;     821 				goto lbl_0001;
;     822 				}
;     823 			else step=s2;
;     824 		}
;     825 
;     826 	else if(step==s2)
;     827 		{
;     828 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     829           if(!bVR)goto step_contr_end;
;     830 lbl_0001:
;     831 
;     832           step=s100;
;     833 		cnt_del=40;
;     834           }
;     835 	else if(step==s100)
;     836 		{
;     837 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;     838           cnt_del--;
;     839           if(cnt_del==0)
;     840 			{
;     841           	step=s3;
;     842           	cnt_del=50;
;     843 			}
;     844 		}
;     845 
;     846 	else if(step==s3)
;     847 		{
;     848 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     849           cnt_del--;
;     850           if(cnt_del==0)
;     851 			{
;     852           	step=s4;
;     853 			}
;     854 		}
;     855 	else if(step==s4)
;     856 		{
;     857 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;     858           if(!bMD2)goto step_contr_end;
;     859           step=s5;
;     860           cnt_del=20;
;     861 		}
;     862 	else if(step==s5)
;     863 		{
;     864 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     865           cnt_del--;
;     866           if(cnt_del==0)
;     867 			{
;     868           	step=s6;
;     869 			}
;     870           }
;     871 	else if(step==s6)
;     872 		{
;     873 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
;     874           if(!bMD3)goto step_contr_end;
;     875           step=s7;
;     876           cnt_del=20;
;     877 		}
;     878 
;     879 	else if(step==s7)
;     880 		{
;     881 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     882           cnt_del--;
;     883           if(cnt_del==0)
;     884 			{
;     885           	step=s8;
;     886           	cnt_del=ee_delay[prog,0]*10U;;
;     887 			}
;     888           }
;     889 	else if(step==s8)
;     890 		{
;     891 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;     892           cnt_del--;
;     893           if(cnt_del==0)
;     894 			{
;     895           	step=s9;
;     896           	cnt_del=20;
;     897 			}
;     898           }
;     899 	else if(step==s9)
;     900 		{
;     901 		temp|=(1<<PP1);
;     902           cnt_del--;
;     903           if(cnt_del==0)
;     904 			{
;     905           	step=sOFF;
;     906           	}
;     907           }
;     908 	}
;     909 
;     910 else if(prog==p2)  //ско
;     911 	{
;     912 	if(step==s1)
;     913 		{
;     914 		temp|=(1<<PP1);
;     915           if(!bMD1)goto step_contr_end;
;     916 
;     917 			if(ee_vacuum_mode==evmOFF)
;     918 				{
;     919 				goto lbl_0002;
;     920 				}
;     921 			else step=s2;
;     922 
;     923           //step=s2;
;     924 		}
;     925 
;     926 	else if(step==s2)
;     927 		{
;     928 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     929           if(!bVR)goto step_contr_end;
;     930 
;     931 lbl_0002:
;     932           step=s100;
;     933 		cnt_del=40;
;     934           }
;     935 	else if(step==s100)
;     936 		{
;     937 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;     938           cnt_del--;
;     939           if(cnt_del==0)
;     940 			{
;     941           	step=s3;
;     942           	cnt_del=50;
;     943 			}
;     944 		}
;     945 	else if(step==s3)
;     946 		{
;     947 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     948           cnt_del--;
;     949           if(cnt_del==0)
;     950 			{
;     951           	step=s4;
;     952 			}
;     953 		}
;     954 	else if(step==s4)
;     955 		{
;     956 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;     957           if(!bMD2)goto step_contr_end;
;     958           step=s5;
;     959           cnt_del=20;
;     960 		}
;     961 	else if(step==s5)
;     962 		{
;     963 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     964           cnt_del--;
;     965           if(cnt_del==0)
;     966 			{
;     967           	step=s6;
;     968           	cnt_del=ee_delay[prog,0]*10U;
;     969 			}
;     970           }
;     971 	else if(step==s6)
;     972 		{
;     973 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;     974           cnt_del--;
;     975           if(cnt_del==0)
;     976 			{
;     977           	step=s7;
;     978           	cnt_del=20;
;     979 			}
;     980           }
;     981 	else if(step==s7)
;     982 		{
;     983 		temp|=(1<<PP1);
;     984           cnt_del--;
;     985           if(cnt_del==0)
;     986 			{
;     987           	step=sOFF;
;     988           	}
;     989           }
;     990 	}
;     991 
;     992 else if(prog==p3)   //твист
;     993 	{
;     994 	if(step==s1)
;     995 		{
;     996 		temp|=(1<<PP1);
;     997           if(!bMD1)goto step_contr_end;
;     998 
;     999 			if(ee_vacuum_mode==evmOFF)
;    1000 				{
;    1001 				goto lbl_0003;
;    1002 				}
;    1003 			else step=s2;
;    1004 
;    1005           //step=s2;
;    1006 		}
;    1007 
;    1008 	else if(step==s2)
;    1009 		{
;    1010 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1011           if(!bVR)goto step_contr_end;
;    1012 lbl_0003:
;    1013           cnt_del=50;
;    1014 		step=s3;
;    1015 		}
;    1016 
;    1017 
;    1018 	else	if(step==s3)
;    1019 		{
;    1020 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1021 		cnt_del--;
;    1022 		if(cnt_del==0)
;    1023 			{
;    1024 			cnt_del=ee_delay[prog,0]*10U;
;    1025 			step=s4;
;    1026 			}
;    1027           }
;    1028 	else if(step==s4)
;    1029 		{
;    1030 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1031 		cnt_del--;
;    1032  		if(cnt_del==0)
;    1033 			{
;    1034 			cnt_del=ee_delay[prog,1]*10U;
;    1035 			step=s5;
;    1036 			}
;    1037 		}
;    1038 
;    1039 	else if(step==s5)
;    1040 		{
;    1041 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1042 		cnt_del--;
;    1043 		if(cnt_del==0)
;    1044 			{
;    1045 			step=s6;
;    1046 			cnt_del=20;
;    1047 			}
;    1048 		}
;    1049 
;    1050 	else if(step==s6)
;    1051 		{
;    1052 		temp|=(1<<PP1);
;    1053   		cnt_del--;
;    1054 		if(cnt_del==0)
;    1055 			{
;    1056 			step=sOFF;
;    1057 			}
;    1058 		}
;    1059 
;    1060 	}
;    1061 
;    1062 else if(prog==p4)      //замок
;    1063 	{
;    1064 	if(step==s1)
;    1065 		{
;    1066 		temp|=(1<<PP1);
;    1067           if(!bMD1)goto step_contr_end;
;    1068 
;    1069 			if(ee_vacuum_mode==evmOFF)
;    1070 				{
;    1071 				goto lbl_0004;
;    1072 				}
;    1073 			else step=s2;
;    1074           //step=s2;
;    1075 		}
;    1076 
;    1077 	else if(step==s2)
;    1078 		{
;    1079 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1080           if(!bVR)goto step_contr_end;
;    1081 lbl_0004:
;    1082           step=s3;
;    1083 		cnt_del=50;
;    1084           }
;    1085 
;    1086 	else if(step==s3)
;    1087 		{
;    1088 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1089           cnt_del--;
;    1090           if(cnt_del==0)
;    1091 			{
;    1092           	step=s4;
;    1093 			cnt_del=ee_delay[prog,0]*10U;
;    1094 			}
;    1095           }
;    1096 
;    1097    	else if(step==s4)
;    1098 		{
;    1099 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1100 		cnt_del--;
;    1101 		if(cnt_del==0)
;    1102 			{
;    1103 			step=s5;
;    1104 			cnt_del=30;
;    1105 			}
;    1106 		}
;    1107 
;    1108 	else if(step==s5)
;    1109 		{
;    1110 		temp|=(1<<PP1)|(1<<PP4);
;    1111 		cnt_del--;
;    1112 		if(cnt_del==0)
;    1113 			{
;    1114 			step=s6;
;    1115 			cnt_del=ee_delay[prog,1]*10U;
;    1116 			}
;    1117 		}
;    1118 
;    1119 	else if(step==s6)
;    1120 		{
;    1121 		temp|=(1<<PP4);
;    1122 		cnt_del--;
;    1123 		if(cnt_del==0)
;    1124 			{
;    1125 			step=sOFF;
;    1126 			}
;    1127 		}
;    1128 
;    1129 	}
;    1130 	
;    1131 step_contr_end:
;    1132 
;    1133 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1134 
;    1135 PORTB=~temp;
;    1136 //PORTB=0x55;
;    1137 }
;    1138 #endif
;    1139 
;    1140 #ifdef I220_WI
;    1141 //-----------------------------------------------
;    1142 void step_contr(void)
;    1143 {
;    1144 char temp=0;
;    1145 DDRB=0xFF;
;    1146 
;    1147 if(step==sOFF)goto step_contr_end;
;    1148 
;    1149 else if(prog==p3)   //твист
;    1150 	{
;    1151 	if(step==s1)
;    1152 		{
;    1153 		temp|=(1<<PP1);
;    1154           if(!bMD1)goto step_contr_end;
;    1155 
;    1156 			if(ee_vacuum_mode==evmOFF)
;    1157 				{
;    1158 				goto lbl_0003;
;    1159 				}
;    1160 			else step=s2;
;    1161 
;    1162           //step=s2;
;    1163 		}
;    1164 
;    1165 	else if(step==s2)
;    1166 		{
;    1167 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1168           if(!bVR)goto step_contr_end;
;    1169 lbl_0003:
;    1170           cnt_del=50;
;    1171 		step=s3;
;    1172 		}
;    1173 
;    1174 
;    1175 	else	if(step==s3)
;    1176 		{
;    1177 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1178 		cnt_del--;
;    1179 		if(cnt_del==0)
;    1180 			{
;    1181 			cnt_del=90;
;    1182 			step=s4;
;    1183 			}
;    1184           }
;    1185 	else if(step==s4)
;    1186 		{
;    1187 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1188 		cnt_del--;
;    1189  		if(cnt_del==0)
;    1190 			{
;    1191 			cnt_del=130;
;    1192 			step=s5;
;    1193 			}
;    1194 		}
;    1195 
;    1196 	else if(step==s5)
;    1197 		{
;    1198 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1199 		cnt_del--;
;    1200 		if(cnt_del==0)
;    1201 			{
;    1202 			step=s6;
;    1203 			cnt_del=20;
;    1204 			}
;    1205 		}
;    1206 
;    1207 	else if(step==s6)
;    1208 		{
;    1209 		temp|=(1<<PP1);
;    1210   		cnt_del--;
;    1211 		if(cnt_del==0)
;    1212 			{
;    1213 			step=sOFF;
;    1214 			}
;    1215 		}
;    1216 
;    1217 	}
;    1218 
;    1219 else if(prog==p4)      //замок
;    1220 	{
;    1221 	if(step==s1)
;    1222 		{
;    1223 		temp|=(1<<PP1);
;    1224           if(!bMD1)goto step_contr_end;
;    1225 
;    1226 			if(ee_vacuum_mode==evmOFF)
;    1227 				{
;    1228 				goto lbl_0004;
;    1229 				}
;    1230 			else step=s2;
;    1231           //step=s2;
;    1232 		}
;    1233 
;    1234 	else if(step==s2)
;    1235 		{
;    1236 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1237           if(!bVR)goto step_contr_end;
;    1238 lbl_0004:
;    1239           step=s3;
;    1240 		cnt_del=50;
;    1241           }
;    1242 
;    1243 	else if(step==s3)
;    1244 		{
;    1245 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1246           cnt_del--;
;    1247           if(cnt_del==0)
;    1248 			{
;    1249           	step=s4;
;    1250 			cnt_del=120;
;    1251 			}
;    1252           }
;    1253 
;    1254    	else if(step==s4)
;    1255 		{
;    1256 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1257 		cnt_del--;
;    1258 		if(cnt_del==0)
;    1259 			{
;    1260 			step=s5;
;    1261 			cnt_del=30;
;    1262 			}
;    1263 		}
;    1264 
;    1265 	else if(step==s5)
;    1266 		{
;    1267 		temp|=(1<<PP1)|(1<<PP4);
;    1268 		cnt_del--;
;    1269 		if(cnt_del==0)
;    1270 			{
;    1271 			step=s6;
;    1272 			cnt_del=120;
;    1273 			}
;    1274 		}
;    1275 
;    1276 	else if(step==s6)
;    1277 		{
;    1278 		temp|=(1<<PP4);
;    1279 		cnt_del--;
;    1280 		if(cnt_del==0)
;    1281 			{
;    1282 			step=sOFF;
;    1283 			}
;    1284 		}
;    1285 
;    1286 	}
;    1287 	
;    1288 step_contr_end:
;    1289 
;    1290 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1291 
;    1292 PORTB=~temp;
;    1293 //PORTB=0x55;
;    1294 }
;    1295 #endif 
;    1296 
;    1297 #ifdef I380_WI
;    1298 //-----------------------------------------------
;    1299 void step_contr(void)
;    1300 {
;    1301 char temp=0;
;    1302 DDRB=0xFF;
;    1303 
;    1304 if(step==sOFF)goto step_contr_end;
;    1305 
;    1306 else if(prog==p1)
;    1307 	{
;    1308 	if(step==s1)    //жесть
;    1309 		{
;    1310 		temp|=(1<<PP1);
;    1311           if(!bMD1)goto step_contr_end;
;    1312 
;    1313 			if(ee_vacuum_mode==evmOFF)
;    1314 				{
;    1315 				goto lbl_0001;
;    1316 				}
;    1317 			else step=s2;
;    1318 		}
;    1319 
;    1320 	else if(step==s2)
;    1321 		{
;    1322 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1323           if(!bVR)goto step_contr_end;
;    1324 lbl_0001:
;    1325 
;    1326           step=s100;
;    1327 		cnt_del=40;
;    1328           }
;    1329 	else if(step==s100)
;    1330 		{
;    1331 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1332           cnt_del--;
;    1333           if(cnt_del==0)
;    1334 			{
;    1335           	step=s3;
;    1336           	cnt_del=50;
;    1337 			}
;    1338 		}
;    1339 
;    1340 	else if(step==s3)
;    1341 		{
;    1342 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1343           cnt_del--;
;    1344           if(cnt_del==0)
;    1345 			{
;    1346           	step=s4;
;    1347 			}
;    1348 		}
;    1349 	else if(step==s4)
;    1350 		{
;    1351 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;    1352           if(!bMD2)goto step_contr_end;
;    1353           step=s54;
;    1354           cnt_del=20;
;    1355 		}
;    1356 	else if(step==s54)
;    1357 		{
;    1358 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;    1359           cnt_del--;
;    1360           if(cnt_del==0)
;    1361 			{
;    1362           	step=s5;
;    1363           	cnt_del=20;
;    1364 			}
;    1365           }
;    1366 
;    1367 	else if(step==s5)
;    1368 		{
;    1369 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1370           cnt_del--;
;    1371           if(cnt_del==0)
;    1372 			{
;    1373           	step=s6;
;    1374 			}
;    1375           }
;    1376 	else if(step==s6)
;    1377 		{
;    1378 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
;    1379           if(!bMD3)goto step_contr_end;
;    1380           step=s55;
;    1381           cnt_del=40;
;    1382 		}
;    1383 	else if(step==s55)
;    1384 		{
;    1385 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
;    1386           cnt_del--;
;    1387           if(cnt_del==0)
;    1388 			{
;    1389           	step=s7;
;    1390           	cnt_del=20;
;    1391 			}
;    1392           }
;    1393 	else if(step==s7)
;    1394 		{
;    1395 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1396           cnt_del--;
;    1397           if(cnt_del==0)
;    1398 			{
;    1399           	step=s8;
;    1400           	cnt_del=130;
;    1401 			}
;    1402           }
;    1403 	else if(step==s8)
;    1404 		{
;    1405 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1406           cnt_del--;
;    1407           if(cnt_del==0)
;    1408 			{
;    1409           	step=s9;
;    1410           	cnt_del=20;
;    1411 			}
;    1412           }
;    1413 	else if(step==s9)
;    1414 		{
;    1415 		temp|=(1<<PP1);
;    1416           cnt_del--;
;    1417           if(cnt_del==0)
;    1418 			{
;    1419           	step=sOFF;
;    1420           	}
;    1421           }
;    1422 	}
;    1423 
;    1424 else if(prog==p2)  //ско
;    1425 	{
;    1426 	if(step==s1)
;    1427 		{
;    1428 		temp|=(1<<PP1);
;    1429           if(!bMD1)goto step_contr_end;
;    1430 
;    1431 			if(ee_vacuum_mode==evmOFF)
;    1432 				{
;    1433 				goto lbl_0002;
;    1434 				}
;    1435 			else step=s2;
;    1436 
;    1437           //step=s2;
;    1438 		}
;    1439 
;    1440 	else if(step==s2)
;    1441 		{
;    1442 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1443           if(!bVR)goto step_contr_end;
;    1444 
;    1445 lbl_0002:
;    1446           step=s100;
;    1447 		cnt_del=40;
;    1448           }
;    1449 	else if(step==s100)
;    1450 		{
;    1451 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1452           cnt_del--;
;    1453           if(cnt_del==0)
;    1454 			{
;    1455           	step=s3;
;    1456           	cnt_del=50;
;    1457 			}
;    1458 		}
;    1459 	else if(step==s3)
;    1460 		{
;    1461 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1462           cnt_del--;
;    1463           if(cnt_del==0)
;    1464 			{
;    1465           	step=s4;
;    1466 			}
;    1467 		}
;    1468 	else if(step==s4)
;    1469 		{
;    1470 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;    1471           if(!bMD2)goto step_contr_end;
;    1472           step=s5;
;    1473           cnt_del=20;
;    1474 		}
;    1475 	else if(step==s5)
;    1476 		{
;    1477 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1478           cnt_del--;
;    1479           if(cnt_del==0)
;    1480 			{
;    1481           	step=s6;
;    1482           	cnt_del=130;
;    1483 			}
;    1484           }
;    1485 	else if(step==s6)
;    1486 		{
;    1487 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1488           cnt_del--;
;    1489           if(cnt_del==0)
;    1490 			{
;    1491           	step=s7;
;    1492           	cnt_del=20;
;    1493 			}
;    1494           }
;    1495 	else if(step==s7)
;    1496 		{
;    1497 		temp|=(1<<PP1);
;    1498           cnt_del--;
;    1499           if(cnt_del==0)
;    1500 			{
;    1501           	step=sOFF;
;    1502           	}
;    1503           }
;    1504 	}
;    1505 
;    1506 else if(prog==p3)   //твист
;    1507 	{
;    1508 	if(step==s1)
;    1509 		{
;    1510 		temp|=(1<<PP1);
;    1511           if(!bMD1)goto step_contr_end;
;    1512 
;    1513 			if(ee_vacuum_mode==evmOFF)
;    1514 				{
;    1515 				goto lbl_0003;
;    1516 				}
;    1517 			else step=s2;
;    1518 
;    1519           //step=s2;
;    1520 		}
;    1521 
;    1522 	else if(step==s2)
;    1523 		{
;    1524 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1525           if(!bVR)goto step_contr_end;
;    1526 lbl_0003:
;    1527           cnt_del=50;
;    1528 		step=s3;
;    1529 		}
;    1530 
;    1531 
;    1532 	else	if(step==s3)
;    1533 		{
;    1534 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1535 		cnt_del--;
;    1536 		if(cnt_del==0)
;    1537 			{
;    1538 			cnt_del=90;
;    1539 			step=s4;
;    1540 			}
;    1541           }
;    1542 	else if(step==s4)
;    1543 		{
;    1544 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1545 		cnt_del--;
;    1546  		if(cnt_del==0)
;    1547 			{
;    1548 			cnt_del=130;
;    1549 			step=s5;
;    1550 			}
;    1551 		}
;    1552 
;    1553 	else if(step==s5)
;    1554 		{
;    1555 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1556 		cnt_del--;
;    1557 		if(cnt_del==0)
;    1558 			{
;    1559 			step=s6;
;    1560 			cnt_del=20;
;    1561 			}
;    1562 		}
;    1563 
;    1564 	else if(step==s6)
;    1565 		{
;    1566 		temp|=(1<<PP1);
;    1567   		cnt_del--;
;    1568 		if(cnt_del==0)
;    1569 			{
;    1570 			step=sOFF;
;    1571 			}
;    1572 		}
;    1573 
;    1574 	}
;    1575 
;    1576 else if(prog==p4)      //замок
;    1577 	{
;    1578 	if(step==s1)
;    1579 		{
;    1580 		temp|=(1<<PP1);
;    1581           if(!bMD1)goto step_contr_end;
;    1582 
;    1583 			if(ee_vacuum_mode==evmOFF)
;    1584 				{
;    1585 				goto lbl_0004;
;    1586 				}
;    1587 			else step=s2;
;    1588           //step=s2;
;    1589 		}
;    1590 
;    1591 	else if(step==s2)
;    1592 		{
;    1593 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1594           if(!bVR)goto step_contr_end;
;    1595 lbl_0004:
;    1596           step=s3;
;    1597 		cnt_del=50;
;    1598           }
;    1599 
;    1600 	else if(step==s3)
;    1601 		{
;    1602 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1603           cnt_del--;
;    1604           if(cnt_del==0)
;    1605 			{
;    1606           	step=s4;
;    1607 			cnt_del=120U;
;    1608 			}
;    1609           }
;    1610 
;    1611    	else if(step==s4)
;    1612 		{
;    1613 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1614 		cnt_del--;
;    1615 		if(cnt_del==0)
;    1616 			{
;    1617 			step=s5;
;    1618 			cnt_del=30;
;    1619 			}
;    1620 		}
;    1621 
;    1622 	else if(step==s5)
;    1623 		{
;    1624 		temp|=(1<<PP1)|(1<<PP4);
;    1625 		cnt_del--;
;    1626 		if(cnt_del==0)
;    1627 			{
;    1628 			step=s6;
;    1629 			cnt_del=120U;
;    1630 			}
;    1631 		}
;    1632 
;    1633 	else if(step==s6)
;    1634 		{
;    1635 		temp|=(1<<PP4);
;    1636 		cnt_del--;
;    1637 		if(cnt_del==0)
;    1638 			{
;    1639 			step=sOFF;
;    1640 			}
;    1641 		}
;    1642 
;    1643 	}
;    1644 	
;    1645 step_contr_end:
;    1646 
;    1647 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1648 
;    1649 PORTB=~temp;
;    1650 //PORTB=0x55;
;    1651 }
;    1652 #endif
;    1653 
;    1654 #ifdef I220
;    1655 //-----------------------------------------------
;    1656 void step_contr(void)
;    1657 {
_step_contr:
;    1658 char temp=0;
;    1659 DDRB=0xFF;
	ST   -Y,R16
;	temp -> R16
	LDI  R16,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
;    1660 
;    1661 if(step==sOFF)goto step_contr_end;
	TST  R11
	BRNE _0x45
	RJMP _0x46
;    1662 
;    1663 else if(prog==p3)   //твист
_0x45:
	LDI  R30,LOW(3)
	CP   R30,R10
	BREQ PC+3
	JMP _0x48
;    1664 	{
;    1665 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x49
;    1666 		{
;    1667 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    1668           if(!bMD1)goto step_contr_end;
	LDS  R30,_bMD1
	CPI  R30,0
	BRNE _0x4A
	RJMP _0x46
;    1669 
;    1670 			if(ee_vacuum_mode==evmOFF)
_0x4A:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x4C
;    1671 				{
;    1672 				goto lbl_0003;
;    1673 				}
;    1674 			else step=s2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;    1675 
;    1676           //step=s2;
;    1677 		}
;    1678 
;    1679 	else if(step==s2)
	RJMP _0x4E
_0x49:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x4F
;    1680 		{
;    1681 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;    1682           if(!bVR)goto step_contr_end;
	LDS  R30,_bVR
	CPI  R30,0
	BRNE _0x50
	RJMP _0x46
;    1683 lbl_0003:
_0x50:
_0x4C:
;    1684           cnt_del=50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    1685 		step=s3;
	LDI  R30,LOW(3)
	MOV  R11,R30
;    1686 		}
;    1687 
;    1688 
;    1689 	else	if(step==s3)
	RJMP _0x51
_0x4F:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0x52
;    1690 		{
;    1691 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;    1692 		cnt_del--;
	CALL SUBOPT_0x1
;    1693 		if(cnt_del==0)
	BRNE _0x53
;    1694 			{
;    1695 			cnt_del=ee_delay[prog,0]*10U;
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
;    1696 			step=s4;
	LDI  R30,LOW(4)
	MOV  R11,R30
;    1697 			}
;    1698           }
_0x53:
;    1699 	else if(step==s4)
	RJMP _0x54
_0x52:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0x55
;    1700 		{
;    1701 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
	ORI  R16,LOW(252)
;    1702 		cnt_del--;
	CALL SUBOPT_0x1
;    1703  		if(cnt_del==0)
	BRNE _0x56
;    1704 			{
;    1705 			cnt_del=ee_delay[prog,1]*10U;
	CALL SUBOPT_0x2
	CALL SUBOPT_0x4
;    1706 			step=s5;
	LDI  R30,LOW(5)
	MOV  R11,R30
;    1707 			}
;    1708 		}
_0x56:
;    1709 
;    1710 	else if(step==s5)
	RJMP _0x57
_0x55:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0x58
;    1711 		{
;    1712 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
	ORI  R16,LOW(204)
;    1713 		cnt_del--;
	CALL SUBOPT_0x1
;    1714 		if(cnt_del==0)
	BRNE _0x59
;    1715 			{
;    1716 			step=s6;
	LDI  R30,LOW(6)
	MOV  R11,R30
;    1717 			cnt_del=20;
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    1718 			}
;    1719 		}
_0x59:
;    1720 
;    1721 	else if(step==s6)
	RJMP _0x5A
_0x58:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0x5B
;    1722 		{
;    1723 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    1724   		cnt_del--;
	CALL SUBOPT_0x1
;    1725 		if(cnt_del==0)
	BRNE _0x5C
;    1726 			{
;    1727 			step=sOFF;
	CLR  R11
;    1728 			}
;    1729 		}
_0x5C:
;    1730 
;    1731 	}
_0x5B:
_0x5A:
_0x57:
_0x54:
_0x51:
_0x4E:
;    1732 
;    1733 else if(prog==p4)      //замок
	RJMP _0x5D
_0x48:
	LDI  R30,LOW(4)
	CP   R30,R10
	BREQ PC+3
	JMP _0x5E
;    1734 	{
;    1735 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x5F
;    1736 		{
;    1737 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    1738           if(!bMD1)goto step_contr_end;
	LDS  R30,_bMD1
	CPI  R30,0
	BRNE _0x60
	RJMP _0x46
;    1739 
;    1740 			if(ee_vacuum_mode==evmOFF)
_0x60:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x62
;    1741 				{
;    1742 				goto lbl_0004;
;    1743 				}
;    1744 			else step=s2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;    1745           //step=s2;
;    1746 		}
;    1747 
;    1748 	else if(step==s2)
	RJMP _0x64
_0x5F:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x65
;    1749 		{
;    1750 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;    1751           if(!bVR)goto step_contr_end;
	LDS  R30,_bVR
	CPI  R30,0
	BREQ _0x46
;    1752 lbl_0004:
_0x62:
;    1753           step=s3;
	LDI  R30,LOW(3)
	MOV  R11,R30
;    1754 		cnt_del=50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    1755           }
;    1756 
;    1757 	else if(step==s3)
	RJMP _0x67
_0x65:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0x68
;    1758 		{
;    1759 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;    1760           cnt_del--;
	CALL SUBOPT_0x1
;    1761           if(cnt_del==0)
	BRNE _0x69
;    1762 			{
;    1763           	step=s4;
	LDI  R30,LOW(4)
	MOV  R11,R30
;    1764 			cnt_del=ee_delay[prog,0]*10U;
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
;    1765 			}
;    1766           }
_0x69:
;    1767 
;    1768    	else if(step==s4)
	RJMP _0x6A
_0x68:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0x6B
;    1769 		{
;    1770 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;    1771 		cnt_del--;
	CALL SUBOPT_0x1
;    1772 		if(cnt_del==0)
	BRNE _0x6C
;    1773 			{
;    1774 			step=s5;
	LDI  R30,LOW(5)
	MOV  R11,R30
;    1775 			cnt_del=30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    1776 			}
;    1777 		}
_0x6C:
;    1778 
;    1779 	else if(step==s5)
	RJMP _0x6D
_0x6B:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0x6E
;    1780 		{
;    1781 		temp|=(1<<PP1)|(1<<PP4);
	ORI  R16,LOW(80)
;    1782 		cnt_del--;
	CALL SUBOPT_0x1
;    1783 		if(cnt_del==0)
	BRNE _0x6F
;    1784 			{
;    1785 			step=s6;
	LDI  R30,LOW(6)
	MOV  R11,R30
;    1786 			cnt_del=ee_delay[prog,1]*10U;
	CALL SUBOPT_0x2
	CALL SUBOPT_0x4
;    1787 			}
;    1788 		}
_0x6F:
;    1789 
;    1790 	else if(step==s6)
	RJMP _0x70
_0x6E:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0x71
;    1791 		{
;    1792 		temp|=(1<<PP4);
	ORI  R16,LOW(16)
;    1793 		cnt_del--;
	CALL SUBOPT_0x1
;    1794 		if(cnt_del==0)
	BRNE _0x72
;    1795 			{
;    1796 			step=sOFF;
	CLR  R11
;    1797 			}
;    1798 		}
_0x72:
;    1799 
;    1800 	}
_0x71:
_0x70:
_0x6D:
_0x6A:
_0x67:
_0x64:
;    1801 	
;    1802 step_contr_end:
_0x5E:
_0x5D:
_0x46:
;    1803 
;    1804 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BRNE _0x73
	ANDI R16,LOW(223)
;    1805 
;    1806 PORTB=~temp;
_0x73:
	MOV  R30,R16
	COM  R30
	OUT  0x18,R30
;    1807 //PORTB=0x55;
;    1808 }
	LD   R16,Y+
	RET
;    1809 #endif 
;    1810 
;    1811 #ifdef TVIST_SKO
;    1812 //-----------------------------------------------
;    1813 void step_contr(void)
;    1814 {
;    1815 char temp=0;
;    1816 DDRB=0xFF;
;    1817 
;    1818 if(step==sOFF)
;    1819 	{
;    1820 	temp=0;
;    1821 	}
;    1822 
;    1823 if(prog==p2) //СКО
;    1824 	{
;    1825 	if(step==s1)
;    1826 		{
;    1827 		temp|=(1<<PP1);
;    1828 
;    1829 		cnt_del--;
;    1830 		if(cnt_del==0)
;    1831 			{
;    1832 			step=s2;
;    1833 			cnt_del=30;
;    1834 			}
;    1835 		}
;    1836 
;    1837 	else if(step==s2)
;    1838 		{
;    1839 		temp|=(1<<PP1)|(1<<DV);
;    1840 
;    1841 		cnt_del--;
;    1842 		if(cnt_del==0)
;    1843 			{
;    1844 			step=s3;
;    1845 			}
;    1846 		}
;    1847 
;    1848 
;    1849 	else if(step==s3)
;    1850 		{
;    1851 		temp|=(1<<PP1)|(1<<DV)|(1<<PP2);
;    1852 
;    1853                	if(bMD1)//goto step_contr_end;
;    1854                		{  
;    1855                		cnt_del=100;
;    1856 	       		step=s4;
;    1857 	       		}
;    1858 	       	}
;    1859 
;    1860 	else if(step==s4)
;    1861 		{
;    1862 		temp|=(1<<PP1);
;    1863 		cnt_del--;
;    1864 		if(cnt_del==0)
;    1865 			{
;    1866 			step=sOFF;
;    1867 			}
;    1868 		}
;    1869 
;    1870 	}
;    1871 
;    1872 if(prog==p3)
;    1873 	{
;    1874 	if(step==s1)
;    1875 		{
;    1876 		temp|=(1<<PP1);
;    1877 
;    1878 		cnt_del--;
;    1879 		if(cnt_del==0)
;    1880 			{
;    1881 			step=s2;
;    1882 			cnt_del=100;
;    1883 			}
;    1884 		}
;    1885 
;    1886 	else if(step==s2)
;    1887 		{
;    1888 		temp|=(1<<PP1)|(1<<PP2);
;    1889 
;    1890 		cnt_del--;
;    1891 		if(cnt_del==0)
;    1892 			{
;    1893 			step=s3;
;    1894 			cnt_del=50;
;    1895 			}
;    1896 		}
;    1897 
;    1898 
;    1899 	else if(step==s3)
;    1900 		{
;    1901 		temp|=(1<<PP2);
;    1902 	
;    1903 		cnt_del--;
;    1904 		if(cnt_del==0)
;    1905 			{
;    1906 			step=sOFF;
;    1907 			}
;    1908                	}
;    1909 	}
;    1910 step_contr_end:
;    1911 
;    1912 PORTB=~temp;
;    1913 }
;    1914 #endif
;    1915 //-----------------------------------------------
;    1916 void bin2bcd_int(unsigned int in)
;    1917 {
_bin2bcd_int:
;    1918 char i;
;    1919 for(i=3;i>0;i--)
	ST   -Y,R16
;	in -> Y+1
;	i -> R16
	LDI  R16,LOW(3)
_0x75:
	LDI  R30,LOW(0)
	CP   R30,R16
	BRSH _0x76
;    1920 	{
;    1921 	dig[i]=in%10;
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
;    1922 	in/=10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
;    1923 	}   
	SUBI R16,1
	RJMP _0x75
_0x76:
;    1924 }
	LDD  R16,Y+0
	RJMP _0xE1
;    1925 
;    1926 //-----------------------------------------------
;    1927 void bcd2ind(char s)
;    1928 {
_bcd2ind:
;    1929 char i;
;    1930 bZ=1;
	ST   -Y,R16
;	s -> Y+1
;	i -> R16
	SET
	BLD  R2,3
;    1931 for (i=0;i<5;i++)
	LDI  R16,LOW(0)
_0x78:
	CPI  R16,5
	BRLO PC+3
	JMP _0x79
;    1932 	{
;    1933 	if(bZ&&(!dig[i-1])&&(i<4))
	SBRS R2,3
	RJMP _0x7B
	CALL SUBOPT_0x5
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	CPI  R30,0
	BRNE _0x7B
	CPI  R16,4
	BRLO _0x7C
_0x7B:
	RJMP _0x7A
_0x7C:
;    1934 		{
;    1935 		if((4-i)>s)
	LDI  R30,LOW(4)
	SUB  R30,R16
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
	BRSH _0x7D
;    1936 			{
;    1937 			ind_out[i-1]=DIGISYM[10];
	CALL SUBOPT_0x5
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	POP  R26
	POP  R27
	RJMP _0xE2
;    1938 			}
;    1939 		else ind_out[i-1]=DIGISYM[0];	
_0x7D:
	CALL SUBOPT_0x5
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	LPM  R30,Z
	POP  R26
	POP  R27
_0xE2:
	ST   X,R30
;    1940 		}
;    1941 	else
	RJMP _0x7F
_0x7A:
;    1942 		{
;    1943 		ind_out[i-1]=DIGISYM[dig[i-1]];
	CALL SUBOPT_0x5
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x5
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	POP  R26
	POP  R27
	CALL SUBOPT_0x6
	POP  R26
	POP  R27
	ST   X,R30
;    1944 		bZ=0;
	CLT
	BLD  R2,3
;    1945 		}                   
_0x7F:
;    1946 
;    1947 	if(s)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x80
;    1948 		{
;    1949 		ind_out[3-s]&=0b01111111;
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
;    1950 		}	
;    1951  
;    1952 	}
_0x80:
	SUBI R16,-1
	RJMP _0x78
_0x79:
;    1953 }            
	LDD  R16,Y+0
	ADIW R28,2
	RET
;    1954 //-----------------------------------------------
;    1955 void int2ind(unsigned int in,char s)
;    1956 {
_int2ind:
;    1957 bin2bcd_int(in);
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _bin2bcd_int
;    1958 bcd2ind(s);
	LD   R30,Y
	ST   -Y,R30
	CALL _bcd2ind
;    1959 
;    1960 } 
_0xE1:
	ADIW R28,3
	RET
;    1961 
;    1962 //-----------------------------------------------
;    1963 void ind_hndl(void)
;    1964 {
_ind_hndl:
;    1965 int2ind(ee_delay[prog,sub_ind],1);  
	CALL SUBOPT_0x2
	CALL SUBOPT_0x7
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _int2ind
;    1966 //ind_out[0]=0xff;//DIGISYM[0];
;    1967 //ind_out[1]=0xff;//DIGISYM[1];
;    1968 //ind_out[2]=DIGISYM[2];//0xff;
;    1969 //ind_out[0]=DIGISYM[7]; 
;    1970 
;    1971 ind_out[0]=DIGISYM[sub_ind+1];
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	PUSH R31
	PUSH R30
	MOV  R30,R13
	SUBI R30,-LOW(1)
	POP  R26
	POP  R27
	CALL SUBOPT_0x6
	STS  _ind_out,R30
;    1972 }
	RET
;    1973 
;    1974 //-----------------------------------------------
;    1975 void led_hndl(void)
;    1976 {
_led_hndl:
;    1977 ind_out[4]=DIGISYM[10]; 
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	__PUTB1MN _ind_out,4
;    1978 
;    1979 ind_out[4]&=~(1<<LED_POW_ON); 
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xDF
	POP  R26
	POP  R27
	ST   X,R30
;    1980 
;    1981 if(step!=sOFF)
	TST  R11
	BREQ _0x81
;    1982 	{
;    1983 	ind_out[4]&=~(1<<LED_WRK);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xBF
	POP  R26
	POP  R27
	RJMP _0xE3
;    1984 	}
;    1985 else ind_out[4]|=(1<<LED_WRK);
_0x81:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x40
	POP  R26
	POP  R27
_0xE3:
	ST   X,R30
;    1986 
;    1987 
;    1988 if(step==sOFF)
	TST  R11
	BRNE _0x83
;    1989 	{
;    1990  	if(bERR)
	SBRS R3,1
	RJMP _0x84
;    1991 		{
;    1992 		ind_out[4]&=~(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFE
	POP  R26
	POP  R27
	RJMP _0xE4
;    1993 		}
;    1994 	else
_0x84:
;    1995 		{
;    1996 		ind_out[4]|=(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
_0xE4:
	ST   X,R30
;    1997 		}
;    1998      }
;    1999 else ind_out[4]|=(1<<LED_ERROR);
	RJMP _0x86
_0x83:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
	ST   X,R30
_0x86:
;    2000 
;    2001 /* 	if(bMD1)
;    2002 		{
;    2003 		ind_out[4]&=~(1<<LED_ERROR);
;    2004 		}
;    2005 	else
;    2006 		{
;    2007 		ind_out[4]|=(1<<LED_ERROR);
;    2008 		} */
;    2009 
;    2010 //if(bERR)ind_out[4]&=~(1<<LED_ERROR);
;    2011 if(ee_vacuum_mode==evmON)ind_out[4]&=~(1<<LED_VACUUM);
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0x87
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0x7F
	POP  R26
	POP  R27
	RJMP _0xE5
;    2012 else ind_out[4]|=(1<<LED_VACUUM);
_0x87:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x80
	POP  R26
	POP  R27
_0xE5:
	ST   X,R30
;    2013 
;    2014 if(prog==p1) ind_out[4]&=~(1<<LED_PROG1);
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x89
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xEF
	POP  R26
	POP  R27
	ST   X,R30
;    2015 else if(prog==p2) ind_out[4]&=~(1<<LED_PROG2);
	RJMP _0x8A
_0x89:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x8B
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFB
	POP  R26
	POP  R27
	ST   X,R30
;    2016 else if(prog==p3) ind_out[4]&=~(1<<LED_PROG3);
	RJMP _0x8C
_0x8B:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x8D
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0XF7
	POP  R26
	POP  R27
	ST   X,R30
;    2017 else if(prog==p4) ind_out[4]&=~(1<<LED_PROG4);
	RJMP _0x8E
_0x8D:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0x8F
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFD
	POP  R26
	POP  R27
	ST   X,R30
;    2018 
;    2019 if(ind==iPr_sel)
_0x8F:
_0x8E:
_0x8C:
_0x8A:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x90
;    2020 	{
;    2021 	if(bFL5)ind_out[4]|=(1<<LED_PROG1)|(1<<LED_PROG2)|(1<<LED_PROG3)|(1<<LED_PROG4);
	SBRS R3,0
	RJMP _0x91
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,LOW(0x1E)
	POP  R26
	POP  R27
	ST   X,R30
;    2022 	} 
_0x91:
;    2023 	 
;    2024 if(ind==iVr)
_0x90:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x92
;    2025 	{
;    2026 	if(bFL5)ind_out[4]|=(1<<LED_POW_ON);
	SBRS R3,0
	RJMP _0x93
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x20
	POP  R26
	POP  R27
	ST   X,R30
;    2027 	}	
_0x93:
;    2028 }
_0x92:
	RET
;    2029 
;    2030 //-----------------------------------------------
;    2031 // Подпрограмма драйва до 7 кнопок одного порта, 
;    2032 // различает короткое и длинное нажатие,
;    2033 // срабатывает на отпускание кнопки, возможность
;    2034 // ускорения перебора при длинном нажатии...
;    2035 #define but_port PORTC
;    2036 #define but_dir  DDRC
;    2037 #define but_pin  PINC
;    2038 #define but_mask 0b01101010
;    2039 #define no_but   0b11111111
;    2040 #define but_on   5
;    2041 #define but_onL  20
;    2042 
;    2043 
;    2044 
;    2045 
;    2046 void but_drv(void)
;    2047 { 
_but_drv:
;    2048 DDRD&=0b00000111;
	IN   R30,0x11
	ANDI R30,LOW(0x7)
	CALL SUBOPT_0x8
;    2049 PORTD|=0b11111000;
;    2050 
;    2051 but_port|=(but_mask^0xff);
	CALL SUBOPT_0x9
;    2052 but_dir&=but_mask;
;    2053 #asm
;    2054 nop
nop
;    2055 nop
nop
;    2056 nop
nop
;    2057 nop
nop
;    2058 #endasm

;    2059 
;    2060 but_n=but_pin|but_mask; 
	IN   R30,0x13
	ORI  R30,LOW(0x6A)
	STS  _but_n_G1,R30
;    2061 
;    2062 if((but_n==no_but)||(but_n!=but_s))
	LDS  R26,_but_n_G1
	CPI  R26,LOW(0xFF)
	BREQ _0x95
	RCALL SUBOPT_0xA
	BREQ _0x94
_0x95:
;    2063  	{
;    2064  	speed=0;
	CLT
	BLD  R2,6
;    2065    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRSH _0x98
	LDS  R26,_but1_cnt_G1
	CPI  R26,LOW(0x0)
	BREQ _0x9A
_0x98:
	SBRS R2,4
	RJMP _0x9B
_0x9A:
	RJMP _0x97
_0x9B:
;    2066   		{
;    2067    	     n_but=1;
	SET
	BLD  R2,5
;    2068           but=but_s;
	LDS  R9,_but_s_G1
;    2069           }
;    2070    	if (but1_cnt>=but_onL_temp)
_0x97:
	RCALL SUBOPT_0xB
	BRLO _0x9C
;    2071   		{
;    2072    	     n_but=1;
	SET
	BLD  R2,5
;    2073           but=but_s&0b11111101;
	RCALL SUBOPT_0xC
;    2074           }
;    2075     	l_but=0;
_0x9C:
	CLT
	BLD  R2,4
;    2076    	but_onL_temp=but_onL;
	LDI  R30,LOW(20)
	STS  _but_onL_temp_G1,R30
;    2077     	but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    2078   	but1_cnt=0;          
	STS  _but1_cnt_G1,R30
;    2079      goto but_drv_out;
	RJMP _0x9D
;    2080   	}  
;    2081   	
;    2082 if(but_n==but_s)
_0x94:
	RCALL SUBOPT_0xA
	BRNE _0x9E
;    2083  	{
;    2084   	but0_cnt++;
	LDS  R30,_but0_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but0_cnt_G1,R30
;    2085   	if(but0_cnt>=but_on)
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRLO _0x9F
;    2086   		{
;    2087    		but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    2088    		but1_cnt++;
	LDS  R30,_but1_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but1_cnt_G1,R30
;    2089    		if(but1_cnt>=but_onL_temp)
	RCALL SUBOPT_0xB
	BRLO _0xA0
;    2090    			{              
;    2091     			but=but_s&0b11111101;
	RCALL SUBOPT_0xC
;    2092     			but1_cnt=0;
	LDI  R30,LOW(0)
	STS  _but1_cnt_G1,R30
;    2093     			n_but=1;
	SET
	BLD  R2,5
;    2094     			l_but=1;
	SET
	BLD  R2,4
;    2095 			if(speed)
	SBRS R2,6
	RJMP _0xA1
;    2096 				{
;    2097     				but_onL_temp=but_onL_temp>>1;
	LDS  R30,_but_onL_temp_G1
	LSR  R30
	STS  _but_onL_temp_G1,R30
;    2098         			if(but_onL_temp<=2) but_onL_temp=2;
	LDS  R26,_but_onL_temp_G1
	LDI  R30,LOW(2)
	CP   R30,R26
	BRLO _0xA2
	STS  _but_onL_temp_G1,R30
;    2099 				}    
_0xA2:
;    2100    			}
_0xA1:
;    2101   		} 
_0xA0:
;    2102  	}
_0x9F:
;    2103 but_drv_out:
_0x9E:
_0x9D:
;    2104 but_s=but_n;
	LDS  R30,_but_n_G1
	STS  _but_s_G1,R30
;    2105 but_port|=(but_mask^0xff);
	RCALL SUBOPT_0x9
;    2106 but_dir&=but_mask;
;    2107 }    
	RET
;    2108 
;    2109 #define butV	239
;    2110 #define butV_	237
;    2111 #define butP	251
;    2112 #define butP_	249
;    2113 #define butR	127
;    2114 #define butR_	125
;    2115 #define butL	254
;    2116 #define butL_	252
;    2117 #define butLR	126
;    2118 #define butLR_	124 
;    2119 #define butVP_ 233
;    2120 //-----------------------------------------------
;    2121 void but_an(void)
;    2122 {
_but_an:
;    2123 
;    2124 if(!(in_word&0x01))
	SBRC R14,0
	RJMP _0xA3
;    2125 	{
;    2126 	#ifdef TVIST_SKO
;    2127 	if((step==sOFF)&&(!bERR))
;    2128 		{
;    2129 		step=s1;
;    2130 		if(prog==p2) cnt_del=70;
;    2131 		else if(prog==p3) cnt_del=100;
;    2132 		}
;    2133 	#endif
;    2134 	#ifdef DV3KL2MD
;    2135 	if((step==sOFF)&&(!bERR))
;    2136 		{
;    2137 		step=s1;
;    2138 		cnt_del=70;
;    2139 		}
;    2140 	#endif	
;    2141 	#ifndef TVIST_SKO
;    2142 	if((step==sOFF)&&(!bERR))
	LDI  R30,LOW(0)
	CP   R30,R11
	BRNE _0xA5
	SBRS R3,1
	RJMP _0xA6
_0xA5:
	RJMP _0xA4
_0xA6:
;    2143 		{
;    2144 		step=s1;
	LDI  R30,LOW(1)
	MOV  R11,R30
;    2145 		if(prog==p1) cnt_del=50;
	CP   R30,R10
	BRNE _0xA7
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2146 		else if(prog==p2) cnt_del=50;
	RJMP _0xA8
_0xA7:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0xA9
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2147 		else if(prog==p3) cnt_del=50;
	RJMP _0xAA
_0xA9:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0xAB
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2148           #ifdef P380_MINI
;    2149   		cnt_del=100;
;    2150   		#endif
;    2151 		}
_0xAB:
_0xAA:
_0xA8:
;    2152 	#endif
;    2153 	}
_0xA4:
;    2154 if(!(in_word&0x02))
_0xA3:
	SBRC R14,1
	RJMP _0xAC
;    2155 	{
;    2156 	step=sOFF;
	CLR  R11
;    2157 
;    2158 	}
;    2159 
;    2160 if (!n_but) goto but_an_end;
_0xAC:
	SBRS R2,5
	RJMP _0xAE
;    2161 
;    2162 if(but==butV_)
	LDI  R30,LOW(237)
	CP   R30,R9
	BRNE _0xAF
;    2163 	{
;    2164 	if(ee_vacuum_mode==evmON)ee_vacuum_mode=evmOFF;
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0xB0
	LDI  R30,LOW(170)
	RJMP _0xE6
;    2165 	else ee_vacuum_mode=evmON;
_0xB0:
	LDI  R30,LOW(85)
_0xE6:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMWRB
;    2166 	}
;    2167 
;    2168 if(but==butVP_)
_0xAF:
	LDI  R30,LOW(233)
	CP   R30,R9
	BRNE _0xB2
;    2169 	{
;    2170 	if(ind!=iVr)ind=iVr;
	LDI  R30,LOW(2)
	CP   R30,R12
	BREQ _0xB3
	MOV  R12,R30
;    2171 	else ind=iMn;
	RJMP _0xB4
_0xB3:
	CLR  R12
_0xB4:
;    2172 	}
;    2173 
;    2174 	
;    2175 if(ind==iMn)
_0xB2:
	TST  R12
	BRNE _0xB5
;    2176 	{
;    2177 	if(but==butP_)ind=iPr_sel;
	LDI  R30,LOW(249)
	CP   R30,R9
	BRNE _0xB6
	LDI  R30,LOW(1)
	MOV  R12,R30
;    2178 	if(but==butLR)	
_0xB6:
	LDI  R30,LOW(126)
	CP   R30,R9
	BRNE _0xB7
;    2179 		{
;    2180 		if((prog==p3)||(prog==p4))
	LDI  R30,LOW(3)
	CP   R30,R10
	BREQ _0xB9
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0xB8
_0xB9:
;    2181 			{ 
;    2182 			if(sub_ind==0)sub_ind=1;
	TST  R13
	BRNE _0xBB
	LDI  R30,LOW(1)
	MOV  R13,R30
;    2183 			else sub_ind=0;
	RJMP _0xBC
_0xBB:
	CLR  R13
_0xBC:
;    2184 			}
;    2185     		else sub_ind=0;
	RJMP _0xBD
_0xB8:
	CLR  R13
_0xBD:
;    2186 		}	 
;    2187 	if((but==butR)||(but==butR_))	
_0xB7:
	LDI  R30,LOW(127)
	CP   R30,R9
	BREQ _0xBF
	LDI  R30,LOW(125)
	CP   R30,R9
	BRNE _0xBE
_0xBF:
;    2188 		{  
;    2189 		speed=1;
	SET
	BLD  R2,6
;    2190 		ee_delay[prog,sub_ind]++;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x7
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    2191 		}   
;    2192 	
;    2193 	else if((but==butL)||(but==butL_))	
	RJMP _0xC1
_0xBE:
	LDI  R30,LOW(254)
	CP   R30,R9
	BREQ _0xC3
	LDI  R30,LOW(252)
	CP   R30,R9
	BRNE _0xC2
_0xC3:
;    2194 		{  
;    2195     		speed=1;
	SET
	BLD  R2,6
;    2196     		ee_delay[prog,sub_ind]--;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x7
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    2197     		}		
;    2198 	} 
_0xC2:
_0xC1:
;    2199 	
;    2200 else if(ind==iPr_sel)
	RJMP _0xC5
_0xB5:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0xC6
;    2201 	{
;    2202 	if(but==butP_)ind=iMn;
	LDI  R30,LOW(249)
	CP   R30,R9
	BRNE _0xC7
	CLR  R12
;    2203 	if(but==butP)
_0xC7:
	LDI  R30,LOW(251)
	CP   R30,R9
	BRNE _0xC8
;    2204 		{
;    2205 		prog++;
	RCALL SUBOPT_0xD
;    2206 		if(prog>MAXPROG)prog=MINPROG;
	BRGE _0xC9
	LDI  R30,LOW(3)
	MOV  R10,R30
;    2207 		ee_program[0]=prog;
_0xC9:
	RCALL SUBOPT_0xE
;    2208 		ee_program[1]=prog;
	__POINTW2MN _ee_program,1
	MOV  R30,R10
	CALL __EEPROMWRB
;    2209 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R10
	CALL __EEPROMWRB
;    2210 		}
;    2211 	
;    2212 	if(but==butR)
_0xC8:
	LDI  R30,LOW(127)
	CP   R30,R9
	BRNE _0xCA
;    2213 		{
;    2214 		prog++;
	RCALL SUBOPT_0xD
;    2215 		if(prog>MAXPROG)prog=MINPROG;
	BRGE _0xCB
	LDI  R30,LOW(3)
	MOV  R10,R30
;    2216 		ee_program[0]=prog;
_0xCB:
	RCALL SUBOPT_0xE
;    2217 		ee_program[1]=prog;
	__POINTW2MN _ee_program,1
	MOV  R30,R10
	CALL __EEPROMWRB
;    2218 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R10
	CALL __EEPROMWRB
;    2219 		}
;    2220 
;    2221 	if(but==butL)
_0xCA:
	LDI  R30,LOW(254)
	CP   R30,R9
	BRNE _0xCC
;    2222 		{
;    2223 		prog--;
	DEC  R10
;    2224 		if(prog>MAXPROG)prog=MINPROG;
	LDI  R30,LOW(4)
	CP   R30,R10
	BRGE _0xCD
	LDI  R30,LOW(3)
	MOV  R10,R30
;    2225 		ee_program[0]=prog;
_0xCD:
	RCALL SUBOPT_0xE
;    2226 		ee_program[1]=prog;
	__POINTW2MN _ee_program,1
	MOV  R30,R10
	CALL __EEPROMWRB
;    2227 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R10
	CALL __EEPROMWRB
;    2228 		}	
;    2229 	} 
_0xCC:
;    2230 
;    2231 else if(ind==iVr)
	RJMP _0xCE
_0xC6:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0xCF
;    2232 	{
;    2233 	if(but==butP_)
	LDI  R30,LOW(249)
	CP   R30,R9
	BRNE _0xD0
;    2234 		{
;    2235 		if(ee_vr_log)ee_vr_log=0;
	LDI  R26,LOW(_ee_vr_log)
	LDI  R27,HIGH(_ee_vr_log)
	CALL __EEPROMRDB
	CPI  R30,0
	BREQ _0xD1
	LDI  R30,LOW(0)
	RJMP _0xE7
;    2236 		else ee_vr_log=1;
_0xD1:
	LDI  R30,LOW(1)
_0xE7:
	LDI  R26,LOW(_ee_vr_log)
	LDI  R27,HIGH(_ee_vr_log)
	CALL __EEPROMWRB
;    2237 		}	
;    2238 	} 	
_0xD0:
;    2239 
;    2240 but_an_end:
_0xCF:
_0xCE:
_0xC5:
_0xAE:
;    2241 n_but=0;
	CLT
	BLD  R2,5
;    2242 }
	RET
;    2243 
;    2244 //-----------------------------------------------
;    2245 void ind_drv(void)
;    2246 {
_ind_drv:
;    2247 if(++ind_cnt>=6)ind_cnt=0;
	INC  R8
	LDI  R30,LOW(6)
	CP   R8,R30
	BRLO _0xD3
	CLR  R8
;    2248 
;    2249 if(ind_cnt<5)
_0xD3:
	LDI  R30,LOW(5)
	CP   R8,R30
	BRSH _0xD4
;    2250 	{
;    2251 	DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
;    2252 	PORTC=0xFF;
	OUT  0x15,R30
;    2253 	DDRD|=0b11111000;
	IN   R30,0x11
	ORI  R30,LOW(0xF8)
	RCALL SUBOPT_0x8
;    2254 	PORTD|=0b11111000;
;    2255 	PORTD&=IND_STROB[ind_cnt];
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
;    2256 	PORTC=ind_out[ind_cnt];
	MOV  R30,R8
	LDI  R31,0
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	LD   R30,Z
	OUT  0x15,R30
;    2257 	}
;    2258 else but_drv();
	RJMP _0xD5
_0xD4:
	CALL _but_drv
_0xD5:
;    2259 }
	RET
;    2260 
;    2261 //***********************************************
;    2262 //***********************************************
;    2263 //***********************************************
;    2264 //***********************************************
;    2265 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;    2266 {
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
;    2267 TCCR0=0x02;
	RCALL SUBOPT_0xF
;    2268 TCNT0=-208;
;    2269 OCR0=0x00; 
;    2270 
;    2271 
;    2272 b600Hz=1;
	SET
	BLD  R2,0
;    2273 ind_drv();
	RCALL _ind_drv
;    2274 if(++t0_cnt0>=6)
	INC  R4
	LDI  R30,LOW(6)
	CP   R4,R30
	BRLO _0xD6
;    2275 	{
;    2276 	t0_cnt0=0;
	CLR  R4
;    2277 	b100Hz=1;
	SET
	BLD  R2,1
;    2278 	}
;    2279 
;    2280 if(++t0_cnt1>=60)
_0xD6:
	INC  R5
	LDI  R30,LOW(60)
	CP   R5,R30
	BRLO _0xD7
;    2281 	{
;    2282 	t0_cnt1=0;
	CLR  R5
;    2283 	b10Hz=1;
	SET
	BLD  R2,2
;    2284 	
;    2285 	if(++t0_cnt2>=2)
	INC  R6
	LDI  R30,LOW(2)
	CP   R6,R30
	BRLO _0xD8
;    2286 		{
;    2287 		t0_cnt2=0;
	CLR  R6
;    2288 		bFL5=!bFL5;
	LDI  R30,LOW(1)
	EOR  R3,R30
;    2289 		}
;    2290 		
;    2291 	if(++t0_cnt3>=5)
_0xD8:
	INC  R7
	LDI  R30,LOW(5)
	CP   R7,R30
	BRLO _0xD9
;    2292 		{
;    2293 		t0_cnt3=0;
	CLR  R7
;    2294 		bFL2=!bFL2;
	LDI  R30,LOW(128)
	EOR  R2,R30
;    2295 		}		
;    2296 	}
_0xD9:
;    2297 }
_0xD7:
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
;    2298 
;    2299 //===============================================
;    2300 //===============================================
;    2301 //===============================================
;    2302 //===============================================
;    2303 
;    2304 void main(void)
;    2305 {
_main:
;    2306 
;    2307 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
;    2308 DDRA=0x00;
	RCALL SUBOPT_0x0
;    2309 
;    2310 PORTB=0xff;
	RCALL SUBOPT_0x10
;    2311 DDRB=0xFF;
;    2312 
;    2313 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;    2314 DDRC=0x00;
	OUT  0x14,R30
;    2315 
;    2316 
;    2317 PORTD=0x00;
	OUT  0x12,R30
;    2318 DDRD=0x00;
	OUT  0x11,R30
;    2319 
;    2320 
;    2321 TCCR0=0x02;
	RCALL SUBOPT_0xF
;    2322 TCNT0=-208;
;    2323 OCR0=0x00;
;    2324 
;    2325 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;    2326 TCCR1B=0x00;
	OUT  0x2E,R30
;    2327 TCNT1H=0x00;
	OUT  0x2D,R30
;    2328 TCNT1L=0x00;
	OUT  0x2C,R30
;    2329 ICR1H=0x00;
	OUT  0x27,R30
;    2330 ICR1L=0x00;
	OUT  0x26,R30
;    2331 OCR1AH=0x00;
	OUT  0x2B,R30
;    2332 OCR1AL=0x00;
	OUT  0x2A,R30
;    2333 OCR1BH=0x00;
	OUT  0x29,R30
;    2334 OCR1BL=0x00;
	OUT  0x28,R30
;    2335 
;    2336 
;    2337 ASSR=0x00;
	OUT  0x22,R30
;    2338 TCCR2=0x00;
	OUT  0x25,R30
;    2339 TCNT2=0x00;
	OUT  0x24,R30
;    2340 OCR2=0x00;
	OUT  0x23,R30
;    2341 
;    2342 MCUCR=0x00;
	OUT  0x35,R30
;    2343 MCUCSR=0x00;
	OUT  0x34,R30
;    2344 
;    2345 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;    2346 
;    2347 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;    2348 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;    2349 
;    2350 #asm("sei") 
	sei
;    2351 PORTB=0xFF;
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x10
;    2352 DDRB=0xFF;
;    2353 ind=iMn;
	CLR  R12
;    2354 prog_drv();
	CALL _prog_drv
;    2355 ind_hndl();
	CALL _ind_hndl
;    2356 led_hndl();
	CALL _led_hndl
;    2357 while (1)
_0xDA:
;    2358       {
;    2359       if(b600Hz)
	SBRS R2,0
	RJMP _0xDD
;    2360 		{
;    2361 		b600Hz=0; 
	CLT
	BLD  R2,0
;    2362           
;    2363 		}         
;    2364       if(b100Hz)
_0xDD:
	SBRS R2,1
	RJMP _0xDE
;    2365 		{        
;    2366 		b100Hz=0; 
	CLT
	BLD  R2,1
;    2367 		but_an();
	RCALL _but_an
;    2368 	    	in_drv();
	CALL _in_drv
;    2369           mdvr_drv();
	CALL _mdvr_drv
;    2370           step_contr();
	CALL _step_contr
;    2371 		}   
;    2372 	if(b10Hz)
_0xDE:
	SBRS R2,2
	RJMP _0xDF
;    2373 		{
;    2374 		b10Hz=0;
	CLT
	BLD  R2,2
;    2375 		prog_drv();
	CALL _prog_drv
;    2376 		err_drv();
	CALL _err_drv
;    2377 		
;    2378     	     ind_hndl();
	CALL _ind_hndl
;    2379           led_hndl();
	CALL _led_hndl
;    2380           
;    2381           }
;    2382 
;    2383       };
_0xDF:
	RJMP _0xDA
;    2384 }
_0xE0:
	RJMP _0xE0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	LDI  R30,LOW(255)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES
SUBOPT_0x1:
	LDS  R30,_cnt_del
	LDS  R31,_cnt_del+1
	SBIW R30,1
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES
SUBOPT_0x2:
	MOV  R30,R10
	LDI  R26,LOW(_ee_delay)
	LDI  R27,HIGH(_ee_delay)
	LDI  R31,0
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3:
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4:
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,2
	MOVW R26,R30
	CALL __EEPROMRDW
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x5:
	MOV  R30,R16
	SUBI R30,LOW(1)
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x7:
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
SUBOPT_0x8:
	OUT  0x11,R30
	IN   R30,0x12
	ORI  R30,LOW(0xF8)
	OUT  0x12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x9:
	IN   R30,0x15
	ORI  R30,LOW(0x95)
	OUT  0x15,R30
	IN   R30,0x14
	ANDI R30,LOW(0x6A)
	OUT  0x14,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA:
	LDS  R30,_but_s_G1
	LDS  R26,_but_n_G1
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB:
	LDS  R30,_but_onL_temp_G1
	LDS  R26,_but1_cnt_G1
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xC:
	LDS  R30,_but_s_G1
	ANDI R30,0xFD
	MOV  R9,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD:
	INC  R10
	LDI  R30,LOW(4)
	CP   R30,R10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xE:
	MOV  R30,R10
	LDI  R26,LOW(_ee_program)
	LDI  R27,HIGH(_ee_program)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF:
	LDI  R30,LOW(2)
	OUT  0x33,R30
	LDI  R30,LOW(65328)
	LDI  R31,HIGH(65328)
	OUT  0x32,R30
	LDI  R30,LOW(0)
	OUT  0x3C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10:
	OUT  0x18,R30
	LDI  R30,LOW(255)
	OUT  0x17,R30
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
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

