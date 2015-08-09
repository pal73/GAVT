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
;      17 //#define I380_WI
;      18 //#define I220_WI
;      19 #define DV3KL2MD
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
;      81 #define PP1	6
;      82 #define PP2	7
;      83 #define PP3	3
;      84 //#define PP4	4
;      85 //#define PP5	3
;      86 #define DV	2 
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
	LDI  R16,LOW(2)
;     163 	temp1=MINPROG;
	LDI  R17,LOW(2)
;     164 	temp2=MINPROG;
	LDI  R18,LOW(2)
;     165 	}
;     166 
;     167 if(!((temp<=MAXPROG)&&(temp>=MINPROG)))
_0x14:
_0x13:
_0xF:
_0xB:
_0x7:
	LDI  R30,LOW(3)
	CP   R30,R16
	BRLO _0x18
	CPI  R16,2
	BRSH _0x17
_0x18:
;     168 	{
;     169 	temp=MINPROG;
	LDI  R16,LOW(2)
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
	RJMP _0xC9
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
_step_contr:
;     316 char temp=0;
;     317 DDRB=0xFF;
	ST   -Y,R16
;	temp -> R16
	LDI  R16,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     318 
;     319 if(step==sOFF)
	TST  R11
	BRNE _0x45
;     320 	{
;     321 	temp=0;
	LDI  R16,LOW(0)
;     322 	}
;     323 
;     324 else if(step==s1)
	RJMP _0x46
_0x45:
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x47
;     325 	{
;     326 	temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     327 
;     328 	cnt_del--;
	CALL SUBOPT_0x1
;     329 	if(cnt_del==0)
	BRNE _0x48
;     330 		{
;     331 		step=s2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;     332 		cnt_del=20;
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;     333 		}
;     334 	}
_0x48:
;     335 
;     336 
;     337 else if(step==s2)
	RJMP _0x49
_0x47:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x4A
;     338 	{
;     339 	temp|=(1<<PP1)|(1<<DV);
	ORI  R16,LOW(68)
;     340 
;     341 	cnt_del--;
	CALL SUBOPT_0x1
;     342 	if(cnt_del==0)
	BRNE _0x4B
;     343 		{
;     344 		step=s3;
	LDI  R30,LOW(3)
	MOV  R11,R30
;     345 		}
;     346 	}
_0x4B:
;     347 	
;     348 else if(step==s3)
	RJMP _0x4C
_0x4A:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0x4D
;     349 	{
;     350 	temp|=(1<<PP1)|(1<<PP2)|(1<<DV);
	ORI  R16,LOW(196)
;     351      if(!bMD1)goto step_contr_end;
	LDS  R30,_bMD1
	CPI  R30,0
	BREQ _0x4F
;     352      step=s4;
	LDI  R30,LOW(4)
	MOV  R11,R30
;     353      }     
;     354 else if(step==s4)
	RJMP _0x50
_0x4D:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0x51
;     355 	{          
;     356      temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
	ORI  R16,LOW(76)
;     357      if(!bMD2)goto step_contr_end;
	SBRS R3,2
	RJMP _0x4F
;     358      step=s5;
	LDI  R30,LOW(5)
	CALL SUBOPT_0x2
;     359      cnt_del=50;
;     360      } 
;     361 else if(step==s5)
	RJMP _0x53
_0x51:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0x54
;     362 	{
;     363 	temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
	ORI  R16,LOW(76)
;     364 
;     365 	cnt_del--;
	CALL SUBOPT_0x1
;     366 	if(cnt_del==0)
	BRNE _0x55
;     367 		{
;     368 		step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x2
;     369 		cnt_del=50;
;     370 		}
;     371 	}         
_0x55:
;     372 /*else if(step==s6)
;     373 	{
;     374 	temp|=(1<<PP1)|(1<<DV);
;     375 
;     376 	cnt_del--;
;     377 	if(cnt_del==0)
;     378 		{
;     379 		step=s6;
;     380 		cnt_del=70;
;     381 		}
;     382 	}*/     
;     383 else if(step==s6)
	RJMP _0x56
_0x54:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0x57
;     384 		{
;     385 	temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     386 	cnt_del--;
	CALL SUBOPT_0x1
;     387 	if(cnt_del==0)
	BRNE _0x58
;     388 		{
;     389 		step=sOFF;
	CLR  R11
;     390           }     
;     391      }     
_0x58:
;     392 
;     393 step_contr_end:
_0x57:
_0x56:
_0x53:
_0x50:
_0x4C:
_0x49:
_0x46:
_0x4F:
;     394 
;     395 PORTB=~temp;
	MOV  R30,R16
	COM  R30
	OUT  0x18,R30
;     396 }
	LD   R16,Y+
	RET
;     397 #endif
;     398 
;     399 #ifdef P380_MINI
;     400 //-----------------------------------------------
;     401 void step_contr(void)
;     402 {
;     403 char temp=0;
;     404 DDRB=0xFF;
;     405 
;     406 if(step==sOFF)
;     407 	{
;     408 	temp=0;
;     409 	}
;     410 
;     411 else if(step==s1)
;     412 	{
;     413 	temp|=(1<<PP1);
;     414 
;     415 	cnt_del--;
;     416 	if(cnt_del==0)
;     417 		{
;     418 		step=s2;
;     419 		}
;     420 	}
;     421 
;     422 else if(step==s2)
;     423 	{
;     424 	temp|=(1<<PP1)|(1<<PP2)|(1<<DV);
;     425      if(!bMD1)goto step_contr_end;
;     426      step=s3;
;     427      }     
;     428 else if(step==s3)
;     429 	{          
;     430      temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     431      if(!bMD2)goto step_contr_end;
;     432      step=s4;
;     433      cnt_del=50;
;     434      }
;     435 else if(step==s4)
;     436 		{
;     437 	temp|=(1<<PP1);
;     438 	cnt_del--;
;     439 	if(cnt_del==0)
;     440 		{
;     441 		step=sOFF;
;     442           }     
;     443      }     
;     444 
;     445 step_contr_end:
;     446 
;     447 PORTB=~temp;
;     448 }
;     449 #endif
;     450 
;     451 #ifdef P380
;     452 //-----------------------------------------------
;     453 void step_contr(void)
;     454 {
;     455 char temp=0;
;     456 DDRB=0xFF;
;     457 
;     458 if(step==sOFF)
;     459 	{
;     460 	temp=0;
;     461 	}
;     462 
;     463 else if(prog==p1)
;     464 	{
;     465 	if(step==s1)
;     466 		{
;     467 		temp|=(1<<PP1)|(1<<PP2);
;     468 
;     469 		cnt_del--;
;     470 		if(cnt_del==0)
;     471 			{
;     472 			if(ee_vacuum_mode==evmOFF)
;     473 				{
;     474 				goto lbl_0001;
;     475 				}
;     476 			else step=s2;
;     477 			}
;     478 		}
;     479 
;     480 	else if(step==s2)
;     481 		{
;     482 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     483 
;     484           if(!bVR)goto step_contr_end;
;     485 lbl_0001:
;     486 #ifndef BIG_CAM
;     487 		cnt_del=30;
;     488 #endif
;     489 
;     490 #ifdef BIG_CAM
;     491 		cnt_del=100;
;     492 #endif
;     493 		step=s3;
;     494 		}
;     495 
;     496 	else if(step==s3)
;     497 		{
;     498 		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     499 		cnt_del--;
;     500 		if(cnt_del==0)
;     501 			{
;     502 			step=s4;
;     503 			}
;     504           }
;     505 	else if(step==s4)
;     506 		{
;     507 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     508 
;     509           if(!bMD1)goto step_contr_end;
;     510 
;     511 		cnt_del=40;
;     512 		step=s5;
;     513 		}
;     514 	else if(step==s5)
;     515 		{
;     516 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     517 
;     518 		cnt_del--;
;     519 		if(cnt_del==0)
;     520 			{
;     521 			step=s6;
;     522 			}
;     523 		}
;     524 	else if(step==s6)
;     525 		{
;     526 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     527 
;     528          	if(!bMD2)goto step_contr_end;
;     529           cnt_del=40;
;     530 		//step=s7;
;     531 		
;     532           step=s55;
;     533           cnt_del=40;
;     534 		}
;     535 	else if(step==s55)
;     536 		{
;     537 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     538           cnt_del--;
;     539           if(cnt_del==0)
;     540 			{
;     541           	step=s7;
;     542           	cnt_del=20;
;     543 			}
;     544          		
;     545 		}
;     546 	else if(step==s7)
;     547 		{
;     548 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     549 
;     550 		cnt_del--;
;     551 		if(cnt_del==0)
;     552 			{
;     553 			step=s8;
;     554 			cnt_del=30;
;     555 			}
;     556 		}
;     557 	else if(step==s8)
;     558 		{
;     559 		temp|=(1<<PP1)|(1<<PP3);
;     560 
;     561 		cnt_del--;
;     562 		if(cnt_del==0)
;     563 			{
;     564 			step=s9;
;     565 #ifndef BIG_CAM
;     566 		cnt_del=150;
;     567 #endif
;     568 
;     569 #ifdef BIG_CAM
;     570 		cnt_del=200;
;     571 #endif
;     572 			}
;     573 		}
;     574 	else if(step==s9)
;     575 		{
;     576 		temp|=(1<<PP1)|(1<<PP2);
;     577 
;     578 		cnt_del--;
;     579 		if(cnt_del==0)
;     580 			{
;     581 			step=s10;
;     582 			cnt_del=30;
;     583 			}
;     584 		}
;     585 	else if(step==s10)
;     586 		{
;     587 		temp|=(1<<PP2);
;     588 		cnt_del--;
;     589 		if(cnt_del==0)
;     590 			{
;     591 			step=sOFF;
;     592 			}
;     593 		}
;     594 	}
;     595 
;     596 if(prog==p2)
;     597 	{
;     598 
;     599 	if(step==s1)
;     600 		{
;     601 		temp|=(1<<PP1)|(1<<PP2);
;     602 
;     603 		cnt_del--;
;     604 		if(cnt_del==0)
;     605 			{
;     606 			if(ee_vacuum_mode==evmOFF)
;     607 				{
;     608 				goto lbl_0002;
;     609 				}
;     610 			else step=s2;
;     611 			}
;     612 		}
;     613 
;     614 	else if(step==s2)
;     615 		{
;     616 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     617 
;     618           if(!bVR)goto step_contr_end;
;     619 lbl_0002:
;     620 #ifndef BIG_CAM
;     621 		cnt_del=30;
;     622 #endif
;     623 
;     624 #ifdef BIG_CAM
;     625 		cnt_del=100;
;     626 #endif
;     627 		step=s3;
;     628 		}
;     629 
;     630 	else if(step==s3)
;     631 		{
;     632 		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     633 
;     634 		cnt_del--;
;     635 		if(cnt_del==0)
;     636 			{
;     637 			step=s4;
;     638 			}
;     639 		}
;     640 
;     641 	else if(step==s4)
;     642 		{
;     643 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     644 
;     645           if(!bMD1)goto step_contr_end;
;     646          	cnt_del=30;
;     647 		step=s5;
;     648 		}
;     649 
;     650 	else if(step==s5)
;     651 		{
;     652 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     653 
;     654 		cnt_del--;
;     655 		if(cnt_del==0)
;     656 			{
;     657 			step=s6;
;     658 			cnt_del=30;
;     659 			}
;     660 		}
;     661 
;     662 	else if(step==s6)
;     663 		{
;     664 		temp|=(1<<PP1)|(1<<PP3);
;     665 
;     666 		cnt_del--;
;     667 		if(cnt_del==0)
;     668 			{
;     669 			step=s7;
;     670 #ifndef BIG_CAM
;     671 		cnt_del=150;
;     672 #endif
;     673 
;     674 #ifdef BIG_CAM
;     675 		cnt_del=200;
;     676 #endif
;     677 			}
;     678 		}
;     679 
;     680 	else if(step==s7)
;     681 		{
;     682 		temp|=(1<<PP1)|(1<<PP2);
;     683 
;     684 		cnt_del--;
;     685 		if(cnt_del==0)
;     686 			{
;     687 			step=s8;
;     688 			cnt_del=30;
;     689 			}
;     690 		}
;     691 	else if(step==s8)
;     692 		{
;     693 		temp|=(1<<PP2);
;     694 
;     695 		cnt_del--;
;     696 		if(cnt_del==0)
;     697 			{
;     698 			step=sOFF;
;     699 			}
;     700 		}
;     701 	}
;     702 
;     703 if(prog==p3)
;     704 	{
;     705 
;     706 	if(step==s1)
;     707 		{
;     708 		temp|=(1<<PP1)|(1<<PP2);
;     709 
;     710 		cnt_del--;
;     711 		if(cnt_del==0)
;     712 			{
;     713 			if(ee_vacuum_mode==evmOFF)
;     714 				{
;     715 				goto lbl_0003;
;     716 				}
;     717 			else step=s2;
;     718 			}
;     719 		}
;     720 
;     721 	else if(step==s2)
;     722 		{
;     723 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     724 
;     725           if(!bVR)goto step_contr_end;
;     726 lbl_0003:
;     727 #ifndef BIG_CAM
;     728 		cnt_del=80;
;     729 #endif
;     730 
;     731 #ifdef BIG_CAM
;     732 		cnt_del=100;
;     733 #endif
;     734 		step=s3;
;     735 		}
;     736 
;     737 	else if(step==s3)
;     738 		{
;     739 		temp|=(1<<PP1)|(1<<PP3);
;     740 
;     741 		cnt_del--;
;     742 		if(cnt_del==0)
;     743 			{
;     744 			step=s4;
;     745 			cnt_del=120;
;     746 			}
;     747 		}
;     748 
;     749 	else if(step==s4)
;     750 		{
;     751 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<PP5);
;     752 
;     753 		cnt_del--;
;     754 		if(cnt_del==0)
;     755 			{
;     756 			step=s5;
;     757 
;     758 		
;     759 #ifndef BIG_CAM
;     760 		cnt_del=150;
;     761 #endif
;     762 
;     763 #ifdef BIG_CAM
;     764 		cnt_del=200;
;     765 #endif
;     766 	//	step=s5;
;     767 	}
;     768 		}
;     769 
;     770 	else if(step==s5)
;     771 		{
;     772 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<PP5);
;     773 
;     774 		cnt_del--;
;     775 		if(cnt_del==0)
;     776 			{
;     777 			step=s6;
;     778 			cnt_del=30;
;     779 			}
;     780 		}
;     781 
;     782 	else if(step==s6)
;     783 		{
;     784 		temp|=(1<<PP2)|(1<<PP4)|(1<<PP5);
;     785 
;     786 		cnt_del--;
;     787 		if(cnt_del==0)
;     788 			{
;     789 			step=s7;
;     790 			cnt_del=30;
;     791 			}
;     792 		}
;     793 
;     794 	else if(step==s7)
;     795 		{
;     796 		temp|=(1<<PP2);
;     797 
;     798 		cnt_del--;
;     799 		if(cnt_del==0)
;     800 			{
;     801 			step=sOFF;
;     802 			}
;     803 		}
;     804 
;     805 	}
;     806 step_contr_end:
;     807 
;     808 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;     809 
;     810 PORTB=~temp;
;     811 }
;     812 #endif
;     813 #ifdef I380
;     814 //-----------------------------------------------
;     815 void step_contr(void)
;     816 {
;     817 char temp=0;
;     818 DDRB=0xFF;
;     819 
;     820 if(step==sOFF)goto step_contr_end;
;     821 
;     822 else if(prog==p1)
;     823 	{
;     824 	if(step==s1)    //жесть
;     825 		{
;     826 		temp|=(1<<PP1);
;     827           if(!bMD1)goto step_contr_end;
;     828 
;     829 			if(ee_vacuum_mode==evmOFF)
;     830 				{
;     831 				goto lbl_0001;
;     832 				}
;     833 			else step=s2;
;     834 		}
;     835 
;     836 	else if(step==s2)
;     837 		{
;     838 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     839           if(!bVR)goto step_contr_end;
;     840 lbl_0001:
;     841 
;     842           step=s100;
;     843 		cnt_del=40;
;     844           }
;     845 	else if(step==s100)
;     846 		{
;     847 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;     848           cnt_del--;
;     849           if(cnt_del==0)
;     850 			{
;     851           	step=s3;
;     852           	cnt_del=50;
;     853 			}
;     854 		}
;     855 
;     856 	else if(step==s3)
;     857 		{
;     858 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     859           cnt_del--;
;     860           if(cnt_del==0)
;     861 			{
;     862           	step=s4;
;     863 			}
;     864 		}
;     865 	else if(step==s4)
;     866 		{
;     867 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;     868           if(!bMD2)goto step_contr_end;
;     869           step=s5;
;     870           cnt_del=20;
;     871 		}
;     872 	else if(step==s5)
;     873 		{
;     874 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     875           cnt_del--;
;     876           if(cnt_del==0)
;     877 			{
;     878           	step=s6;
;     879 			}
;     880           }
;     881 	else if(step==s6)
;     882 		{
;     883 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
;     884           if(!bMD3)goto step_contr_end;
;     885           step=s7;
;     886           cnt_del=20;
;     887 		}
;     888 
;     889 	else if(step==s7)
;     890 		{
;     891 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     892           cnt_del--;
;     893           if(cnt_del==0)
;     894 			{
;     895           	step=s8;
;     896           	cnt_del=ee_delay[prog,0]*10U;;
;     897 			}
;     898           }
;     899 	else if(step==s8)
;     900 		{
;     901 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;     902           cnt_del--;
;     903           if(cnt_del==0)
;     904 			{
;     905           	step=s9;
;     906           	cnt_del=20;
;     907 			}
;     908           }
;     909 	else if(step==s9)
;     910 		{
;     911 		temp|=(1<<PP1);
;     912           cnt_del--;
;     913           if(cnt_del==0)
;     914 			{
;     915           	step=sOFF;
;     916           	}
;     917           }
;     918 	}
;     919 
;     920 else if(prog==p2)  //ско
;     921 	{
;     922 	if(step==s1)
;     923 		{
;     924 		temp|=(1<<PP1);
;     925           if(!bMD1)goto step_contr_end;
;     926 
;     927 			if(ee_vacuum_mode==evmOFF)
;     928 				{
;     929 				goto lbl_0002;
;     930 				}
;     931 			else step=s2;
;     932 
;     933           //step=s2;
;     934 		}
;     935 
;     936 	else if(step==s2)
;     937 		{
;     938 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     939           if(!bVR)goto step_contr_end;
;     940 
;     941 lbl_0002:
;     942           step=s100;
;     943 		cnt_del=40;
;     944           }
;     945 	else if(step==s100)
;     946 		{
;     947 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;     948           cnt_del--;
;     949           if(cnt_del==0)
;     950 			{
;     951           	step=s3;
;     952           	cnt_del=50;
;     953 			}
;     954 		}
;     955 	else if(step==s3)
;     956 		{
;     957 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     958           cnt_del--;
;     959           if(cnt_del==0)
;     960 			{
;     961           	step=s4;
;     962 			}
;     963 		}
;     964 	else if(step==s4)
;     965 		{
;     966 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;     967           if(!bMD2)goto step_contr_end;
;     968           step=s5;
;     969           cnt_del=20;
;     970 		}
;     971 	else if(step==s5)
;     972 		{
;     973 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     974           cnt_del--;
;     975           if(cnt_del==0)
;     976 			{
;     977           	step=s6;
;     978           	cnt_del=ee_delay[prog,0]*10U;
;     979 			}
;     980           }
;     981 	else if(step==s6)
;     982 		{
;     983 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;     984           cnt_del--;
;     985           if(cnt_del==0)
;     986 			{
;     987           	step=s7;
;     988           	cnt_del=20;
;     989 			}
;     990           }
;     991 	else if(step==s7)
;     992 		{
;     993 		temp|=(1<<PP1);
;     994           cnt_del--;
;     995           if(cnt_del==0)
;     996 			{
;     997           	step=sOFF;
;     998           	}
;     999           }
;    1000 	}
;    1001 
;    1002 else if(prog==p3)   //твист
;    1003 	{
;    1004 	if(step==s1)
;    1005 		{
;    1006 		temp|=(1<<PP1);
;    1007           if(!bMD1)goto step_contr_end;
;    1008 
;    1009 			if(ee_vacuum_mode==evmOFF)
;    1010 				{
;    1011 				goto lbl_0003;
;    1012 				}
;    1013 			else step=s2;
;    1014 
;    1015           //step=s2;
;    1016 		}
;    1017 
;    1018 	else if(step==s2)
;    1019 		{
;    1020 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1021           if(!bVR)goto step_contr_end;
;    1022 lbl_0003:
;    1023           cnt_del=50;
;    1024 		step=s3;
;    1025 		}
;    1026 
;    1027 
;    1028 	else	if(step==s3)
;    1029 		{
;    1030 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1031 		cnt_del--;
;    1032 		if(cnt_del==0)
;    1033 			{
;    1034 			cnt_del=ee_delay[prog,0]*10U;
;    1035 			step=s4;
;    1036 			}
;    1037           }
;    1038 	else if(step==s4)
;    1039 		{
;    1040 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1041 		cnt_del--;
;    1042  		if(cnt_del==0)
;    1043 			{
;    1044 			cnt_del=ee_delay[prog,1]*10U;
;    1045 			step=s5;
;    1046 			}
;    1047 		}
;    1048 
;    1049 	else if(step==s5)
;    1050 		{
;    1051 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1052 		cnt_del--;
;    1053 		if(cnt_del==0)
;    1054 			{
;    1055 			step=s6;
;    1056 			cnt_del=20;
;    1057 			}
;    1058 		}
;    1059 
;    1060 	else if(step==s6)
;    1061 		{
;    1062 		temp|=(1<<PP1);
;    1063   		cnt_del--;
;    1064 		if(cnt_del==0)
;    1065 			{
;    1066 			step=sOFF;
;    1067 			}
;    1068 		}
;    1069 
;    1070 	}
;    1071 
;    1072 else if(prog==p4)      //замок
;    1073 	{
;    1074 	if(step==s1)
;    1075 		{
;    1076 		temp|=(1<<PP1);
;    1077           if(!bMD1)goto step_contr_end;
;    1078 
;    1079 			if(ee_vacuum_mode==evmOFF)
;    1080 				{
;    1081 				goto lbl_0004;
;    1082 				}
;    1083 			else step=s2;
;    1084           //step=s2;
;    1085 		}
;    1086 
;    1087 	else if(step==s2)
;    1088 		{
;    1089 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1090           if(!bVR)goto step_contr_end;
;    1091 lbl_0004:
;    1092           step=s3;
;    1093 		cnt_del=50;
;    1094           }
;    1095 
;    1096 	else if(step==s3)
;    1097 		{
;    1098 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1099           cnt_del--;
;    1100           if(cnt_del==0)
;    1101 			{
;    1102           	step=s4;
;    1103 			cnt_del=ee_delay[prog,0]*10U;
;    1104 			}
;    1105           }
;    1106 
;    1107    	else if(step==s4)
;    1108 		{
;    1109 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1110 		cnt_del--;
;    1111 		if(cnt_del==0)
;    1112 			{
;    1113 			step=s5;
;    1114 			cnt_del=30;
;    1115 			}
;    1116 		}
;    1117 
;    1118 	else if(step==s5)
;    1119 		{
;    1120 		temp|=(1<<PP1)|(1<<PP4);
;    1121 		cnt_del--;
;    1122 		if(cnt_del==0)
;    1123 			{
;    1124 			step=s6;
;    1125 			cnt_del=ee_delay[prog,1]*10U;
;    1126 			}
;    1127 		}
;    1128 
;    1129 	else if(step==s6)
;    1130 		{
;    1131 		temp|=(1<<PP4);
;    1132 		cnt_del--;
;    1133 		if(cnt_del==0)
;    1134 			{
;    1135 			step=sOFF;
;    1136 			}
;    1137 		}
;    1138 
;    1139 	}
;    1140 	
;    1141 step_contr_end:
;    1142 
;    1143 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1144 
;    1145 PORTB=~temp;
;    1146 //PORTB=0x55;
;    1147 }
;    1148 #endif
;    1149 
;    1150 #ifdef I220_WI
;    1151 //-----------------------------------------------
;    1152 void step_contr(void)
;    1153 {
;    1154 char temp=0;
;    1155 DDRB=0xFF;
;    1156 
;    1157 if(step==sOFF)goto step_contr_end;
;    1158 
;    1159 else if(prog==p3)   //твист
;    1160 	{
;    1161 	if(step==s1)
;    1162 		{
;    1163 		temp|=(1<<PP1);
;    1164           if(!bMD1)goto step_contr_end;
;    1165 
;    1166 			if(ee_vacuum_mode==evmOFF)
;    1167 				{
;    1168 				goto lbl_0003;
;    1169 				}
;    1170 			else step=s2;
;    1171 
;    1172           //step=s2;
;    1173 		}
;    1174 
;    1175 	else if(step==s2)
;    1176 		{
;    1177 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1178           if(!bVR)goto step_contr_end;
;    1179 lbl_0003:
;    1180           cnt_del=50;
;    1181 		step=s3;
;    1182 		}
;    1183 
;    1184 
;    1185 	else	if(step==s3)
;    1186 		{
;    1187 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1188 		cnt_del--;
;    1189 		if(cnt_del==0)
;    1190 			{
;    1191 			cnt_del=90;
;    1192 			step=s4;
;    1193 			}
;    1194           }
;    1195 	else if(step==s4)
;    1196 		{
;    1197 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1198 		cnt_del--;
;    1199  		if(cnt_del==0)
;    1200 			{
;    1201 			cnt_del=130;
;    1202 			step=s5;
;    1203 			}
;    1204 		}
;    1205 
;    1206 	else if(step==s5)
;    1207 		{
;    1208 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1209 		cnt_del--;
;    1210 		if(cnt_del==0)
;    1211 			{
;    1212 			step=s6;
;    1213 			cnt_del=20;
;    1214 			}
;    1215 		}
;    1216 
;    1217 	else if(step==s6)
;    1218 		{
;    1219 		temp|=(1<<PP1);
;    1220   		cnt_del--;
;    1221 		if(cnt_del==0)
;    1222 			{
;    1223 			step=sOFF;
;    1224 			}
;    1225 		}
;    1226 
;    1227 	}
;    1228 
;    1229 else if(prog==p4)      //замок
;    1230 	{
;    1231 	if(step==s1)
;    1232 		{
;    1233 		temp|=(1<<PP1);
;    1234           if(!bMD1)goto step_contr_end;
;    1235 
;    1236 			if(ee_vacuum_mode==evmOFF)
;    1237 				{
;    1238 				goto lbl_0004;
;    1239 				}
;    1240 			else step=s2;
;    1241           //step=s2;
;    1242 		}
;    1243 
;    1244 	else if(step==s2)
;    1245 		{
;    1246 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1247           if(!bVR)goto step_contr_end;
;    1248 lbl_0004:
;    1249           step=s3;
;    1250 		cnt_del=50;
;    1251           }
;    1252 
;    1253 	else if(step==s3)
;    1254 		{
;    1255 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1256           cnt_del--;
;    1257           if(cnt_del==0)
;    1258 			{
;    1259           	step=s4;
;    1260 			cnt_del=120;
;    1261 			}
;    1262           }
;    1263 
;    1264    	else if(step==s4)
;    1265 		{
;    1266 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1267 		cnt_del--;
;    1268 		if(cnt_del==0)
;    1269 			{
;    1270 			step=s5;
;    1271 			cnt_del=30;
;    1272 			}
;    1273 		}
;    1274 
;    1275 	else if(step==s5)
;    1276 		{
;    1277 		temp|=(1<<PP1)|(1<<PP4);
;    1278 		cnt_del--;
;    1279 		if(cnt_del==0)
;    1280 			{
;    1281 			step=s6;
;    1282 			cnt_del=120;
;    1283 			}
;    1284 		}
;    1285 
;    1286 	else if(step==s6)
;    1287 		{
;    1288 		temp|=(1<<PP4);
;    1289 		cnt_del--;
;    1290 		if(cnt_del==0)
;    1291 			{
;    1292 			step=sOFF;
;    1293 			}
;    1294 		}
;    1295 
;    1296 	}
;    1297 	
;    1298 step_contr_end:
;    1299 
;    1300 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1301 
;    1302 PORTB=~temp;
;    1303 //PORTB=0x55;
;    1304 }
;    1305 #endif 
;    1306 
;    1307 #ifdef I380_WI
;    1308 //-----------------------------------------------
;    1309 void step_contr(void)
;    1310 {
;    1311 char temp=0;
;    1312 DDRB=0xFF;
;    1313 
;    1314 if(step==sOFF)goto step_contr_end;
;    1315 
;    1316 else if(prog==p1)
;    1317 	{
;    1318 	if(step==s1)    //жесть
;    1319 		{
;    1320 		temp|=(1<<PP1);
;    1321           if(!bMD1)goto step_contr_end;
;    1322 
;    1323 			if(ee_vacuum_mode==evmOFF)
;    1324 				{
;    1325 				goto lbl_0001;
;    1326 				}
;    1327 			else step=s2;
;    1328 		}
;    1329 
;    1330 	else if(step==s2)
;    1331 		{
;    1332 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1333           if(!bVR)goto step_contr_end;
;    1334 lbl_0001:
;    1335 
;    1336           step=s100;
;    1337 		cnt_del=40;
;    1338           }
;    1339 	else if(step==s100)
;    1340 		{
;    1341 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1342           cnt_del--;
;    1343           if(cnt_del==0)
;    1344 			{
;    1345           	step=s3;
;    1346           	cnt_del=50;
;    1347 			}
;    1348 		}
;    1349 
;    1350 	else if(step==s3)
;    1351 		{
;    1352 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1353           cnt_del--;
;    1354           if(cnt_del==0)
;    1355 			{
;    1356           	step=s4;
;    1357 			}
;    1358 		}
;    1359 	else if(step==s4)
;    1360 		{
;    1361 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;    1362           if(!bMD2)goto step_contr_end;
;    1363           step=s54;
;    1364           cnt_del=20;
;    1365 		}
;    1366 	else if(step==s54)
;    1367 		{
;    1368 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;    1369           cnt_del--;
;    1370           if(cnt_del==0)
;    1371 			{
;    1372           	step=s5;
;    1373           	cnt_del=20;
;    1374 			}
;    1375           }
;    1376 
;    1377 	else if(step==s5)
;    1378 		{
;    1379 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1380           cnt_del--;
;    1381           if(cnt_del==0)
;    1382 			{
;    1383           	step=s6;
;    1384 			}
;    1385           }
;    1386 	else if(step==s6)
;    1387 		{
;    1388 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
;    1389           if(!bMD3)goto step_contr_end;
;    1390           step=s55;
;    1391           cnt_del=40;
;    1392 		}
;    1393 	else if(step==s55)
;    1394 		{
;    1395 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
;    1396           cnt_del--;
;    1397           if(cnt_del==0)
;    1398 			{
;    1399           	step=s7;
;    1400           	cnt_del=20;
;    1401 			}
;    1402           }
;    1403 	else if(step==s7)
;    1404 		{
;    1405 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1406           cnt_del--;
;    1407           if(cnt_del==0)
;    1408 			{
;    1409           	step=s8;
;    1410           	cnt_del=130;
;    1411 			}
;    1412           }
;    1413 	else if(step==s8)
;    1414 		{
;    1415 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1416           cnt_del--;
;    1417           if(cnt_del==0)
;    1418 			{
;    1419           	step=s9;
;    1420           	cnt_del=20;
;    1421 			}
;    1422           }
;    1423 	else if(step==s9)
;    1424 		{
;    1425 		temp|=(1<<PP1);
;    1426           cnt_del--;
;    1427           if(cnt_del==0)
;    1428 			{
;    1429           	step=sOFF;
;    1430           	}
;    1431           }
;    1432 	}
;    1433 
;    1434 else if(prog==p2)  //ско
;    1435 	{
;    1436 	if(step==s1)
;    1437 		{
;    1438 		temp|=(1<<PP1);
;    1439           if(!bMD1)goto step_contr_end;
;    1440 
;    1441 			if(ee_vacuum_mode==evmOFF)
;    1442 				{
;    1443 				goto lbl_0002;
;    1444 				}
;    1445 			else step=s2;
;    1446 
;    1447           //step=s2;
;    1448 		}
;    1449 
;    1450 	else if(step==s2)
;    1451 		{
;    1452 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1453           if(!bVR)goto step_contr_end;
;    1454 
;    1455 lbl_0002:
;    1456           step=s100;
;    1457 		cnt_del=40;
;    1458           }
;    1459 	else if(step==s100)
;    1460 		{
;    1461 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1462           cnt_del--;
;    1463           if(cnt_del==0)
;    1464 			{
;    1465           	step=s3;
;    1466           	cnt_del=50;
;    1467 			}
;    1468 		}
;    1469 	else if(step==s3)
;    1470 		{
;    1471 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1472           cnt_del--;
;    1473           if(cnt_del==0)
;    1474 			{
;    1475           	step=s4;
;    1476 			}
;    1477 		}
;    1478 	else if(step==s4)
;    1479 		{
;    1480 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;    1481           if(!bMD2)goto step_contr_end;
;    1482           step=s5;
;    1483           cnt_del=20;
;    1484 		}
;    1485 	else if(step==s5)
;    1486 		{
;    1487 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1488           cnt_del--;
;    1489           if(cnt_del==0)
;    1490 			{
;    1491           	step=s6;
;    1492           	cnt_del=130;
;    1493 			}
;    1494           }
;    1495 	else if(step==s6)
;    1496 		{
;    1497 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1498           cnt_del--;
;    1499           if(cnt_del==0)
;    1500 			{
;    1501           	step=s7;
;    1502           	cnt_del=20;
;    1503 			}
;    1504           }
;    1505 	else if(step==s7)
;    1506 		{
;    1507 		temp|=(1<<PP1);
;    1508           cnt_del--;
;    1509           if(cnt_del==0)
;    1510 			{
;    1511           	step=sOFF;
;    1512           	}
;    1513           }
;    1514 	}
;    1515 
;    1516 else if(prog==p3)   //твист
;    1517 	{
;    1518 	if(step==s1)
;    1519 		{
;    1520 		temp|=(1<<PP1);
;    1521           if(!bMD1)goto step_contr_end;
;    1522 
;    1523 			if(ee_vacuum_mode==evmOFF)
;    1524 				{
;    1525 				goto lbl_0003;
;    1526 				}
;    1527 			else step=s2;
;    1528 
;    1529           //step=s2;
;    1530 		}
;    1531 
;    1532 	else if(step==s2)
;    1533 		{
;    1534 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1535           if(!bVR)goto step_contr_end;
;    1536 lbl_0003:
;    1537           cnt_del=50;
;    1538 		step=s3;
;    1539 		}
;    1540 
;    1541 
;    1542 	else	if(step==s3)
;    1543 		{
;    1544 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1545 		cnt_del--;
;    1546 		if(cnt_del==0)
;    1547 			{
;    1548 			cnt_del=90;
;    1549 			step=s4;
;    1550 			}
;    1551           }
;    1552 	else if(step==s4)
;    1553 		{
;    1554 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1555 		cnt_del--;
;    1556  		if(cnt_del==0)
;    1557 			{
;    1558 			cnt_del=130;
;    1559 			step=s5;
;    1560 			}
;    1561 		}
;    1562 
;    1563 	else if(step==s5)
;    1564 		{
;    1565 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1566 		cnt_del--;
;    1567 		if(cnt_del==0)
;    1568 			{
;    1569 			step=s6;
;    1570 			cnt_del=20;
;    1571 			}
;    1572 		}
;    1573 
;    1574 	else if(step==s6)
;    1575 		{
;    1576 		temp|=(1<<PP1);
;    1577   		cnt_del--;
;    1578 		if(cnt_del==0)
;    1579 			{
;    1580 			step=sOFF;
;    1581 			}
;    1582 		}
;    1583 
;    1584 	}
;    1585 
;    1586 else if(prog==p4)      //замок
;    1587 	{
;    1588 	if(step==s1)
;    1589 		{
;    1590 		temp|=(1<<PP1);
;    1591           if(!bMD1)goto step_contr_end;
;    1592 
;    1593 			if(ee_vacuum_mode==evmOFF)
;    1594 				{
;    1595 				goto lbl_0004;
;    1596 				}
;    1597 			else step=s2;
;    1598           //step=s2;
;    1599 		}
;    1600 
;    1601 	else if(step==s2)
;    1602 		{
;    1603 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1604           if(!bVR)goto step_contr_end;
;    1605 lbl_0004:
;    1606           step=s3;
;    1607 		cnt_del=50;
;    1608           }
;    1609 
;    1610 	else if(step==s3)
;    1611 		{
;    1612 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1613           cnt_del--;
;    1614           if(cnt_del==0)
;    1615 			{
;    1616           	step=s4;
;    1617 			cnt_del=120U;
;    1618 			}
;    1619           }
;    1620 
;    1621    	else if(step==s4)
;    1622 		{
;    1623 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1624 		cnt_del--;
;    1625 		if(cnt_del==0)
;    1626 			{
;    1627 			step=s5;
;    1628 			cnt_del=30;
;    1629 			}
;    1630 		}
;    1631 
;    1632 	else if(step==s5)
;    1633 		{
;    1634 		temp|=(1<<PP1)|(1<<PP4);
;    1635 		cnt_del--;
;    1636 		if(cnt_del==0)
;    1637 			{
;    1638 			step=s6;
;    1639 			cnt_del=120U;
;    1640 			}
;    1641 		}
;    1642 
;    1643 	else if(step==s6)
;    1644 		{
;    1645 		temp|=(1<<PP4);
;    1646 		cnt_del--;
;    1647 		if(cnt_del==0)
;    1648 			{
;    1649 			step=sOFF;
;    1650 			}
;    1651 		}
;    1652 
;    1653 	}
;    1654 	
;    1655 step_contr_end:
;    1656 
;    1657 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1658 
;    1659 PORTB=~temp;
;    1660 //PORTB=0x55;
;    1661 }
;    1662 #endif
;    1663 
;    1664 #ifdef I220
;    1665 //-----------------------------------------------
;    1666 void step_contr(void)
;    1667 {
;    1668 char temp=0;
;    1669 DDRB=0xFF;
;    1670 
;    1671 if(step==sOFF)goto step_contr_end;
;    1672 
;    1673 else if(prog==p3)   //твист
;    1674 	{
;    1675 	if(step==s1)
;    1676 		{
;    1677 		temp|=(1<<PP1);
;    1678           if(!bMD1)goto step_contr_end;
;    1679 
;    1680 			if(ee_vacuum_mode==evmOFF)
;    1681 				{
;    1682 				goto lbl_0003;
;    1683 				}
;    1684 			else step=s2;
;    1685 
;    1686           //step=s2;
;    1687 		}
;    1688 
;    1689 	else if(step==s2)
;    1690 		{
;    1691 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1692           if(!bVR)goto step_contr_end;
;    1693 lbl_0003:
;    1694           cnt_del=50;
;    1695 		step=s3;
;    1696 		}
;    1697 
;    1698 
;    1699 	else	if(step==s3)
;    1700 		{
;    1701 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1702 		cnt_del--;
;    1703 		if(cnt_del==0)
;    1704 			{
;    1705 			cnt_del=ee_delay[prog,0]*10U;
;    1706 			step=s4;
;    1707 			}
;    1708           }
;    1709 	else if(step==s4)
;    1710 		{
;    1711 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1712 		cnt_del--;
;    1713  		if(cnt_del==0)
;    1714 			{
;    1715 			cnt_del=ee_delay[prog,1]*10U;
;    1716 			step=s5;
;    1717 			}
;    1718 		}
;    1719 
;    1720 	else if(step==s5)
;    1721 		{
;    1722 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1723 		cnt_del--;
;    1724 		if(cnt_del==0)
;    1725 			{
;    1726 			step=s6;
;    1727 			cnt_del=20;
;    1728 			}
;    1729 		}
;    1730 
;    1731 	else if(step==s6)
;    1732 		{
;    1733 		temp|=(1<<PP1);
;    1734   		cnt_del--;
;    1735 		if(cnt_del==0)
;    1736 			{
;    1737 			step=sOFF;
;    1738 			}
;    1739 		}
;    1740 
;    1741 	}
;    1742 
;    1743 else if(prog==p4)      //замок
;    1744 	{
;    1745 	if(step==s1)
;    1746 		{
;    1747 		temp|=(1<<PP1);
;    1748           if(!bMD1)goto step_contr_end;
;    1749 
;    1750 			if(ee_vacuum_mode==evmOFF)
;    1751 				{
;    1752 				goto lbl_0004;
;    1753 				}
;    1754 			else step=s2;
;    1755           //step=s2;
;    1756 		}
;    1757 
;    1758 	else if(step==s2)
;    1759 		{
;    1760 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1761           if(!bVR)goto step_contr_end;
;    1762 lbl_0004:
;    1763           step=s3;
;    1764 		cnt_del=50;
;    1765           }
;    1766 
;    1767 	else if(step==s3)
;    1768 		{
;    1769 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1770           cnt_del--;
;    1771           if(cnt_del==0)
;    1772 			{
;    1773           	step=s4;
;    1774 			cnt_del=ee_delay[prog,0]*10U;
;    1775 			}
;    1776           }
;    1777 
;    1778    	else if(step==s4)
;    1779 		{
;    1780 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1781 		cnt_del--;
;    1782 		if(cnt_del==0)
;    1783 			{
;    1784 			step=s5;
;    1785 			cnt_del=30;
;    1786 			}
;    1787 		}
;    1788 
;    1789 	else if(step==s5)
;    1790 		{
;    1791 		temp|=(1<<PP1)|(1<<PP4);
;    1792 		cnt_del--;
;    1793 		if(cnt_del==0)
;    1794 			{
;    1795 			step=s6;
;    1796 			cnt_del=ee_delay[prog,1]*10U;
;    1797 			}
;    1798 		}
;    1799 
;    1800 	else if(step==s6)
;    1801 		{
;    1802 		temp|=(1<<PP4);
;    1803 		cnt_del--;
;    1804 		if(cnt_del==0)
;    1805 			{
;    1806 			step=sOFF;
;    1807 			}
;    1808 		}
;    1809 
;    1810 	}
;    1811 	
;    1812 step_contr_end:
;    1813 
;    1814 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1815 
;    1816 PORTB=~temp;
;    1817 //PORTB=0x55;
;    1818 }
;    1819 #endif 
;    1820 
;    1821 #ifdef TVIST_SKO
;    1822 //-----------------------------------------------
;    1823 void step_contr(void)
;    1824 {
;    1825 char temp=0;
;    1826 DDRB=0xFF;
;    1827 
;    1828 if(step==sOFF)
;    1829 	{
;    1830 	temp=0;
;    1831 	}
;    1832 
;    1833 if(prog==p2) //СКО
;    1834 	{
;    1835 	if(step==s1)
;    1836 		{
;    1837 		temp|=(1<<PP1);
;    1838 
;    1839 		cnt_del--;
;    1840 		if(cnt_del==0)
;    1841 			{
;    1842 			step=s2;
;    1843 			cnt_del=30;
;    1844 			}
;    1845 		}
;    1846 
;    1847 	else if(step==s2)
;    1848 		{
;    1849 		temp|=(1<<PP1)|(1<<DV);
;    1850 
;    1851 		cnt_del--;
;    1852 		if(cnt_del==0)
;    1853 			{
;    1854 			step=s3;
;    1855 			}
;    1856 		}
;    1857 
;    1858 
;    1859 	else if(step==s3)
;    1860 		{
;    1861 		temp|=(1<<PP1)|(1<<DV)|(1<<PP2);
;    1862 
;    1863                	if(bMD1)//goto step_contr_end;
;    1864                		{  
;    1865                		cnt_del=100;
;    1866 	       		step=s4;
;    1867 	       		}
;    1868 	       	}
;    1869 
;    1870 	else if(step==s4)
;    1871 		{
;    1872 		temp|=(1<<PP1);
;    1873 		cnt_del--;
;    1874 		if(cnt_del==0)
;    1875 			{
;    1876 			step=sOFF;
;    1877 			}
;    1878 		}
;    1879 
;    1880 	}
;    1881 
;    1882 if(prog==p3)
;    1883 	{
;    1884 	if(step==s1)
;    1885 		{
;    1886 		temp|=(1<<PP1);
;    1887 
;    1888 		cnt_del--;
;    1889 		if(cnt_del==0)
;    1890 			{
;    1891 			step=s2;
;    1892 			cnt_del=100;
;    1893 			}
;    1894 		}
;    1895 
;    1896 	else if(step==s2)
;    1897 		{
;    1898 		temp|=(1<<PP1)|(1<<PP2);
;    1899 
;    1900 		cnt_del--;
;    1901 		if(cnt_del==0)
;    1902 			{
;    1903 			step=s3;
;    1904 			cnt_del=50;
;    1905 			}
;    1906 		}
;    1907 
;    1908 
;    1909 	else if(step==s3)
;    1910 		{
;    1911 		temp|=(1<<PP2);
;    1912 	
;    1913 		cnt_del--;
;    1914 		if(cnt_del==0)
;    1915 			{
;    1916 			step=sOFF;
;    1917 			}
;    1918                	}
;    1919 	}
;    1920 step_contr_end:
;    1921 
;    1922 PORTB=~temp;
;    1923 }
;    1924 #endif
;    1925 //-----------------------------------------------
;    1926 void bin2bcd_int(unsigned int in)
;    1927 {
_bin2bcd_int:
;    1928 char i;
;    1929 for(i=3;i>0;i--)
	ST   -Y,R16
;	in -> Y+1
;	i -> R16
	LDI  R16,LOW(3)
_0x5A:
	LDI  R30,LOW(0)
	CP   R30,R16
	BRSH _0x5B
;    1930 	{
;    1931 	dig[i]=in%10;
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
;    1932 	in/=10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
;    1933 	}   
	SUBI R16,1
	RJMP _0x5A
_0x5B:
;    1934 }
	LDD  R16,Y+0
	RJMP _0xC9
;    1935 
;    1936 //-----------------------------------------------
;    1937 void bcd2ind(char s)
;    1938 {
_bcd2ind:
;    1939 char i;
;    1940 bZ=1;
	ST   -Y,R16
;	s -> Y+1
;	i -> R16
	SET
	BLD  R2,3
;    1941 for (i=0;i<5;i++)
	LDI  R16,LOW(0)
_0x5D:
	CPI  R16,5
	BRLO PC+3
	JMP _0x5E
;    1942 	{
;    1943 	if(bZ&&(!dig[i-1])&&(i<4))
	SBRS R2,3
	RJMP _0x60
	CALL SUBOPT_0x3
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	CPI  R30,0
	BRNE _0x60
	CPI  R16,4
	BRLO _0x61
_0x60:
	RJMP _0x5F
_0x61:
;    1944 		{
;    1945 		if((4-i)>s)
	LDI  R30,LOW(4)
	SUB  R30,R16
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
	BRSH _0x62
;    1946 			{
;    1947 			ind_out[i-1]=DIGISYM[10];
	CALL SUBOPT_0x3
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	POP  R26
	POP  R27
	RJMP _0xCA
;    1948 			}
;    1949 		else ind_out[i-1]=DIGISYM[0];	
_0x62:
	CALL SUBOPT_0x3
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	LPM  R30,Z
	POP  R26
	POP  R27
_0xCA:
	ST   X,R30
;    1950 		}
;    1951 	else
	RJMP _0x64
_0x5F:
;    1952 		{
;    1953 		ind_out[i-1]=DIGISYM[dig[i-1]];
	CALL SUBOPT_0x3
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	POP  R26
	POP  R27
	CALL SUBOPT_0x4
	POP  R26
	POP  R27
	ST   X,R30
;    1954 		bZ=0;
	CLT
	BLD  R2,3
;    1955 		}                   
_0x64:
;    1956 
;    1957 	if(s)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x65
;    1958 		{
;    1959 		ind_out[3-s]&=0b01111111;
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
;    1960 		}	
;    1961  
;    1962 	}
_0x65:
	SUBI R16,-1
	RJMP _0x5D
_0x5E:
;    1963 }            
	LDD  R16,Y+0
	ADIW R28,2
	RET
;    1964 //-----------------------------------------------
;    1965 void int2ind(unsigned int in,char s)
;    1966 {
_int2ind:
;    1967 bin2bcd_int(in);
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _bin2bcd_int
;    1968 bcd2ind(s);
	LD   R30,Y
	ST   -Y,R30
	CALL _bcd2ind
;    1969 
;    1970 } 
_0xC9:
	ADIW R28,3
	RET
;    1971 
;    1972 //-----------------------------------------------
;    1973 void ind_hndl(void)
;    1974 {
_ind_hndl:
;    1975 int2ind(ee_delay[prog,sub_ind],1);  
	CALL SUBOPT_0x5
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _int2ind
;    1976 //ind_out[0]=0xff;//DIGISYM[0];
;    1977 //ind_out[1]=0xff;//DIGISYM[1];
;    1978 //ind_out[2]=DIGISYM[2];//0xff;
;    1979 //ind_out[0]=DIGISYM[7]; 
;    1980 
;    1981 ind_out[0]=DIGISYM[sub_ind+1];
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	PUSH R31
	PUSH R30
	MOV  R30,R13
	SUBI R30,-LOW(1)
	POP  R26
	POP  R27
	CALL SUBOPT_0x4
	STS  _ind_out,R30
;    1982 }
	RET
;    1983 
;    1984 //-----------------------------------------------
;    1985 void led_hndl(void)
;    1986 {
_led_hndl:
;    1987 ind_out[4]=DIGISYM[10]; 
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	__PUTB1MN _ind_out,4
;    1988 
;    1989 ind_out[4]&=~(1<<LED_POW_ON); 
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xDF
	POP  R26
	POP  R27
	ST   X,R30
;    1990 
;    1991 if(step!=sOFF)
	TST  R11
	BREQ _0x66
;    1992 	{
;    1993 	ind_out[4]&=~(1<<LED_WRK);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xBF
	POP  R26
	POP  R27
	RJMP _0xCB
;    1994 	}
;    1995 else ind_out[4]|=(1<<LED_WRK);
_0x66:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x40
	POP  R26
	POP  R27
_0xCB:
	ST   X,R30
;    1996 
;    1997 
;    1998 if(step==sOFF)
	TST  R11
	BRNE _0x68
;    1999 	{
;    2000  	if(bERR)
	SBRS R3,1
	RJMP _0x69
;    2001 		{
;    2002 		ind_out[4]&=~(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFE
	POP  R26
	POP  R27
	RJMP _0xCC
;    2003 		}
;    2004 	else
_0x69:
;    2005 		{
;    2006 		ind_out[4]|=(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
_0xCC:
	ST   X,R30
;    2007 		}
;    2008      }
;    2009 else ind_out[4]|=(1<<LED_ERROR);
	RJMP _0x6B
_0x68:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
	ST   X,R30
_0x6B:
;    2010 
;    2011 /* 	if(bMD1)
;    2012 		{
;    2013 		ind_out[4]&=~(1<<LED_ERROR);
;    2014 		}
;    2015 	else
;    2016 		{
;    2017 		ind_out[4]|=(1<<LED_ERROR);
;    2018 		} */
;    2019 
;    2020 //if(bERR)ind_out[4]&=~(1<<LED_ERROR);
;    2021 if(ee_vacuum_mode==evmON)ind_out[4]&=~(1<<LED_VACUUM);
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0x6C
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0x7F
	POP  R26
	POP  R27
	RJMP _0xCD
;    2022 else ind_out[4]|=(1<<LED_VACUUM);
_0x6C:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x80
	POP  R26
	POP  R27
_0xCD:
	ST   X,R30
;    2023 
;    2024 if(prog==p1) ind_out[4]&=~(1<<LED_PROG1);
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x6E
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xEF
	POP  R26
	POP  R27
	ST   X,R30
;    2025 else if(prog==p2) ind_out[4]&=~(1<<LED_PROG2);
	RJMP _0x6F
_0x6E:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x70
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFB
	POP  R26
	POP  R27
	ST   X,R30
;    2026 else if(prog==p3) ind_out[4]&=~(1<<LED_PROG3);
	RJMP _0x71
_0x70:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x72
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0XF7
	POP  R26
	POP  R27
	ST   X,R30
;    2027 else if(prog==p4) ind_out[4]&=~(1<<LED_PROG4);
	RJMP _0x73
_0x72:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0x74
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFD
	POP  R26
	POP  R27
	ST   X,R30
;    2028 
;    2029 if(ind==iPr_sel)
_0x74:
_0x73:
_0x71:
_0x6F:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x75
;    2030 	{
;    2031 	if(bFL5)ind_out[4]|=(1<<LED_PROG1)|(1<<LED_PROG2)|(1<<LED_PROG3)|(1<<LED_PROG4);
	SBRS R3,0
	RJMP _0x76
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,LOW(0x1E)
	POP  R26
	POP  R27
	ST   X,R30
;    2032 	} 
_0x76:
;    2033 	 
;    2034 if(ind==iVr)
_0x75:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x77
;    2035 	{
;    2036 	if(bFL5)ind_out[4]|=(1<<LED_POW_ON);
	SBRS R3,0
	RJMP _0x78
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x20
	POP  R26
	POP  R27
	ST   X,R30
;    2037 	}	
_0x78:
;    2038 }
_0x77:
	RET
;    2039 
;    2040 //-----------------------------------------------
;    2041 // Подпрограмма драйва до 7 кнопок одного порта, 
;    2042 // различает короткое и длинное нажатие,
;    2043 // срабатывает на отпускание кнопки, возможность
;    2044 // ускорения перебора при длинном нажатии...
;    2045 #define but_port PORTC
;    2046 #define but_dir  DDRC
;    2047 #define but_pin  PINC
;    2048 #define but_mask 0b01101010
;    2049 #define no_but   0b11111111
;    2050 #define but_on   5
;    2051 #define but_onL  20
;    2052 
;    2053 
;    2054 
;    2055 
;    2056 void but_drv(void)
;    2057 { 
_but_drv:
;    2058 DDRD&=0b00000111;
	IN   R30,0x11
	ANDI R30,LOW(0x7)
	CALL SUBOPT_0x6
;    2059 PORTD|=0b11111000;
;    2060 
;    2061 but_port|=(but_mask^0xff);
	CALL SUBOPT_0x7
;    2062 but_dir&=but_mask;
;    2063 #asm
;    2064 nop
nop
;    2065 nop
nop
;    2066 nop
nop
;    2067 nop
nop
;    2068 #endasm

;    2069 
;    2070 but_n=but_pin|but_mask; 
	IN   R30,0x13
	ORI  R30,LOW(0x6A)
	STS  _but_n_G1,R30
;    2071 
;    2072 if((but_n==no_but)||(but_n!=but_s))
	LDS  R26,_but_n_G1
	CPI  R26,LOW(0xFF)
	BREQ _0x7A
	RCALL SUBOPT_0x8
	BREQ _0x79
_0x7A:
;    2073  	{
;    2074  	speed=0;
	CLT
	BLD  R2,6
;    2075    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRSH _0x7D
	LDS  R26,_but1_cnt_G1
	CPI  R26,LOW(0x0)
	BREQ _0x7F
_0x7D:
	SBRS R2,4
	RJMP _0x80
_0x7F:
	RJMP _0x7C
_0x80:
;    2076   		{
;    2077    	     n_but=1;
	SET
	BLD  R2,5
;    2078           but=but_s;
	LDS  R9,_but_s_G1
;    2079           }
;    2080    	if (but1_cnt>=but_onL_temp)
_0x7C:
	RCALL SUBOPT_0x9
	BRLO _0x81
;    2081   		{
;    2082    	     n_but=1;
	SET
	BLD  R2,5
;    2083           but=but_s&0b11111101;
	RCALL SUBOPT_0xA
;    2084           }
;    2085     	l_but=0;
_0x81:
	CLT
	BLD  R2,4
;    2086    	but_onL_temp=but_onL;
	LDI  R30,LOW(20)
	STS  _but_onL_temp_G1,R30
;    2087     	but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    2088   	but1_cnt=0;          
	STS  _but1_cnt_G1,R30
;    2089      goto but_drv_out;
	RJMP _0x82
;    2090   	}  
;    2091   	
;    2092 if(but_n==but_s)
_0x79:
	RCALL SUBOPT_0x8
	BRNE _0x83
;    2093  	{
;    2094   	but0_cnt++;
	LDS  R30,_but0_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but0_cnt_G1,R30
;    2095   	if(but0_cnt>=but_on)
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRLO _0x84
;    2096   		{
;    2097    		but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    2098    		but1_cnt++;
	LDS  R30,_but1_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but1_cnt_G1,R30
;    2099    		if(but1_cnt>=but_onL_temp)
	RCALL SUBOPT_0x9
	BRLO _0x85
;    2100    			{              
;    2101     			but=but_s&0b11111101;
	RCALL SUBOPT_0xA
;    2102     			but1_cnt=0;
	LDI  R30,LOW(0)
	STS  _but1_cnt_G1,R30
;    2103     			n_but=1;
	SET
	BLD  R2,5
;    2104     			l_but=1;
	SET
	BLD  R2,4
;    2105 			if(speed)
	SBRS R2,6
	RJMP _0x86
;    2106 				{
;    2107     				but_onL_temp=but_onL_temp>>1;
	LDS  R30,_but_onL_temp_G1
	LSR  R30
	STS  _but_onL_temp_G1,R30
;    2108         			if(but_onL_temp<=2) but_onL_temp=2;
	LDS  R26,_but_onL_temp_G1
	LDI  R30,LOW(2)
	CP   R30,R26
	BRLO _0x87
	STS  _but_onL_temp_G1,R30
;    2109 				}    
_0x87:
;    2110    			}
_0x86:
;    2111   		} 
_0x85:
;    2112  	}
_0x84:
;    2113 but_drv_out:
_0x83:
_0x82:
;    2114 but_s=but_n;
	LDS  R30,_but_n_G1
	STS  _but_s_G1,R30
;    2115 but_port|=(but_mask^0xff);
	RCALL SUBOPT_0x7
;    2116 but_dir&=but_mask;
;    2117 }    
	RET
;    2118 
;    2119 #define butV	239
;    2120 #define butV_	237
;    2121 #define butP	251
;    2122 #define butP_	249
;    2123 #define butR	127
;    2124 #define butR_	125
;    2125 #define butL	254
;    2126 #define butL_	252
;    2127 #define butLR	126
;    2128 #define butLR_	124 
;    2129 #define butVP_ 233
;    2130 //-----------------------------------------------
;    2131 void but_an(void)
;    2132 {
_but_an:
;    2133 
;    2134 if(!(in_word&0x01))
	SBRC R14,0
	RJMP _0x88
;    2135 	{
;    2136 	#ifdef TVIST_SKO
;    2137 	if((step==sOFF)&&(!bERR))
;    2138 		{
;    2139 		step=s1;
;    2140 		if(prog==p2) cnt_del=70;
;    2141 		else if(prog==p3) cnt_del=100;
;    2142 		}
;    2143 	#endif
;    2144 	#ifdef DV3KL2MD
;    2145 	if((step==sOFF)&&(!bERR))
	LDI  R30,LOW(0)
	CP   R30,R11
	BRNE _0x8A
	SBRS R3,1
	RJMP _0x8B
_0x8A:
	RJMP _0x89
_0x8B:
;    2146 		{
;    2147 		step=s1;
	LDI  R30,LOW(1)
	MOV  R11,R30
;    2148 		cnt_del=70;
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2149 		}
;    2150 	#endif	
;    2151 	#ifndef TVIST_SKO
;    2152 	if((step==sOFF)&&(!bERR))
_0x89:
	LDI  R30,LOW(0)
	CP   R30,R11
	BRNE _0x8D
	SBRS R3,1
	RJMP _0x8E
_0x8D:
	RJMP _0x8C
_0x8E:
;    2153 		{
;    2154 		step=s1;
	LDI  R30,LOW(1)
	MOV  R11,R30
;    2155 		if(prog==p1) cnt_del=50;
	CP   R30,R10
	BRNE _0x8F
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2156 		else if(prog==p2) cnt_del=50;
	RJMP _0x90
_0x8F:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x91
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2157 		else if(prog==p3) cnt_del=50;
	RJMP _0x92
_0x91:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x93
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2158           #ifdef P380_MINI
;    2159   		cnt_del=100;
;    2160   		#endif
;    2161 		}
_0x93:
_0x92:
_0x90:
;    2162 	#endif
;    2163 	}
_0x8C:
;    2164 if(!(in_word&0x02))
_0x88:
	SBRC R14,1
	RJMP _0x94
;    2165 	{
;    2166 	step=sOFF;
	CLR  R11
;    2167 
;    2168 	}
;    2169 
;    2170 if (!n_but) goto but_an_end;
_0x94:
	SBRS R2,5
	RJMP _0x96
;    2171 
;    2172 if(but==butV_)
	LDI  R30,LOW(237)
	CP   R30,R9
	BRNE _0x97
;    2173 	{
;    2174 	if(ee_vacuum_mode==evmON)ee_vacuum_mode=evmOFF;
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0x98
	LDI  R30,LOW(170)
	RJMP _0xCE
;    2175 	else ee_vacuum_mode=evmON;
_0x98:
	LDI  R30,LOW(85)
_0xCE:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMWRB
;    2176 	}
;    2177 
;    2178 if(but==butVP_)
_0x97:
	LDI  R30,LOW(233)
	CP   R30,R9
	BRNE _0x9A
;    2179 	{
;    2180 	if(ind!=iVr)ind=iVr;
	LDI  R30,LOW(2)
	CP   R30,R12
	BREQ _0x9B
	MOV  R12,R30
;    2181 	else ind=iMn;
	RJMP _0x9C
_0x9B:
	CLR  R12
_0x9C:
;    2182 	}
;    2183 
;    2184 	
;    2185 if(ind==iMn)
_0x9A:
	TST  R12
	BRNE _0x9D
;    2186 	{
;    2187 	if(but==butP_)ind=iPr_sel;
	LDI  R30,LOW(249)
	CP   R30,R9
	BRNE _0x9E
	LDI  R30,LOW(1)
	MOV  R12,R30
;    2188 	if(but==butLR)	
_0x9E:
	LDI  R30,LOW(126)
	CP   R30,R9
	BRNE _0x9F
;    2189 		{
;    2190 		if((prog==p3)||(prog==p4))
	LDI  R30,LOW(3)
	CP   R30,R10
	BREQ _0xA1
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0xA0
_0xA1:
;    2191 			{ 
;    2192 			if(sub_ind==0)sub_ind=1;
	TST  R13
	BRNE _0xA3
	LDI  R30,LOW(1)
	MOV  R13,R30
;    2193 			else sub_ind=0;
	RJMP _0xA4
_0xA3:
	CLR  R13
_0xA4:
;    2194 			}
;    2195     		else sub_ind=0;
	RJMP _0xA5
_0xA0:
	CLR  R13
_0xA5:
;    2196 		}	 
;    2197 	if((but==butR)||(but==butR_))	
_0x9F:
	LDI  R30,LOW(127)
	CP   R30,R9
	BREQ _0xA7
	LDI  R30,LOW(125)
	CP   R30,R9
	BRNE _0xA6
_0xA7:
;    2198 		{  
;    2199 		speed=1;
	SET
	BLD  R2,6
;    2200 		ee_delay[prog,sub_ind]++;
	RCALL SUBOPT_0x5
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    2201 		}   
;    2202 	
;    2203 	else if((but==butL)||(but==butL_))	
	RJMP _0xA9
_0xA6:
	LDI  R30,LOW(254)
	CP   R30,R9
	BREQ _0xAB
	LDI  R30,LOW(252)
	CP   R30,R9
	BRNE _0xAA
_0xAB:
;    2204 		{  
;    2205     		speed=1;
	SET
	BLD  R2,6
;    2206     		ee_delay[prog,sub_ind]--;
	RCALL SUBOPT_0x5
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    2207     		}		
;    2208 	} 
_0xAA:
_0xA9:
;    2209 	
;    2210 else if(ind==iPr_sel)
	RJMP _0xAD
_0x9D:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0xAE
;    2211 	{
;    2212 	if(but==butP_)ind=iMn;
	LDI  R30,LOW(249)
	CP   R30,R9
	BRNE _0xAF
	CLR  R12
;    2213 	if(but==butP)
_0xAF:
	LDI  R30,LOW(251)
	CP   R30,R9
	BRNE _0xB0
;    2214 		{
;    2215 		prog++;
	RCALL SUBOPT_0xB
;    2216 		if(prog>MAXPROG)prog=MINPROG;
	BRGE _0xB1
	LDI  R30,LOW(2)
	MOV  R10,R30
;    2217 		ee_program[0]=prog;
_0xB1:
	RCALL SUBOPT_0xC
;    2218 		ee_program[1]=prog;
	__POINTW2MN _ee_program,1
	MOV  R30,R10
	CALL __EEPROMWRB
;    2219 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R10
	CALL __EEPROMWRB
;    2220 		}
;    2221 	
;    2222 	if(but==butR)
_0xB0:
	LDI  R30,LOW(127)
	CP   R30,R9
	BRNE _0xB2
;    2223 		{
;    2224 		prog++;
	RCALL SUBOPT_0xB
;    2225 		if(prog>MAXPROG)prog=MINPROG;
	BRGE _0xB3
	LDI  R30,LOW(2)
	MOV  R10,R30
;    2226 		ee_program[0]=prog;
_0xB3:
	RCALL SUBOPT_0xC
;    2227 		ee_program[1]=prog;
	__POINTW2MN _ee_program,1
	MOV  R30,R10
	CALL __EEPROMWRB
;    2228 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R10
	CALL __EEPROMWRB
;    2229 		}
;    2230 
;    2231 	if(but==butL)
_0xB2:
	LDI  R30,LOW(254)
	CP   R30,R9
	BRNE _0xB4
;    2232 		{
;    2233 		prog--;
	DEC  R10
;    2234 		if(prog>MAXPROG)prog=MINPROG;
	LDI  R30,LOW(3)
	CP   R30,R10
	BRGE _0xB5
	LDI  R30,LOW(2)
	MOV  R10,R30
;    2235 		ee_program[0]=prog;
_0xB5:
	RCALL SUBOPT_0xC
;    2236 		ee_program[1]=prog;
	__POINTW2MN _ee_program,1
	MOV  R30,R10
	CALL __EEPROMWRB
;    2237 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R10
	CALL __EEPROMWRB
;    2238 		}	
;    2239 	} 
_0xB4:
;    2240 
;    2241 else if(ind==iVr)
	RJMP _0xB6
_0xAE:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0xB7
;    2242 	{
;    2243 	if(but==butP_)
	LDI  R30,LOW(249)
	CP   R30,R9
	BRNE _0xB8
;    2244 		{
;    2245 		if(ee_vr_log)ee_vr_log=0;
	LDI  R26,LOW(_ee_vr_log)
	LDI  R27,HIGH(_ee_vr_log)
	CALL __EEPROMRDB
	CPI  R30,0
	BREQ _0xB9
	LDI  R30,LOW(0)
	RJMP _0xCF
;    2246 		else ee_vr_log=1;
_0xB9:
	LDI  R30,LOW(1)
_0xCF:
	LDI  R26,LOW(_ee_vr_log)
	LDI  R27,HIGH(_ee_vr_log)
	CALL __EEPROMWRB
;    2247 		}	
;    2248 	} 	
_0xB8:
;    2249 
;    2250 but_an_end:
_0xB7:
_0xB6:
_0xAD:
_0x96:
;    2251 n_but=0;
	CLT
	BLD  R2,5
;    2252 }
	RET
;    2253 
;    2254 //-----------------------------------------------
;    2255 void ind_drv(void)
;    2256 {
_ind_drv:
;    2257 if(++ind_cnt>=6)ind_cnt=0;
	INC  R8
	LDI  R30,LOW(6)
	CP   R8,R30
	BRLO _0xBB
	CLR  R8
;    2258 
;    2259 if(ind_cnt<5)
_0xBB:
	LDI  R30,LOW(5)
	CP   R8,R30
	BRSH _0xBC
;    2260 	{
;    2261 	DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
;    2262 	PORTC=0xFF;
	OUT  0x15,R30
;    2263 	DDRD|=0b11111000;
	IN   R30,0x11
	ORI  R30,LOW(0xF8)
	RCALL SUBOPT_0x6
;    2264 	PORTD|=0b11111000;
;    2265 	PORTD&=IND_STROB[ind_cnt];
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
;    2266 	PORTC=ind_out[ind_cnt];
	MOV  R30,R8
	LDI  R31,0
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	LD   R30,Z
	OUT  0x15,R30
;    2267 	}
;    2268 else but_drv();
	RJMP _0xBD
_0xBC:
	CALL _but_drv
_0xBD:
;    2269 }
	RET
;    2270 
;    2271 //***********************************************
;    2272 //***********************************************
;    2273 //***********************************************
;    2274 //***********************************************
;    2275 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;    2276 {
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
;    2277 TCCR0=0x02;
	RCALL SUBOPT_0xD
;    2278 TCNT0=-208;
;    2279 OCR0=0x00; 
;    2280 
;    2281 
;    2282 b600Hz=1;
	SET
	BLD  R2,0
;    2283 ind_drv();
	RCALL _ind_drv
;    2284 if(++t0_cnt0>=6)
	INC  R4
	LDI  R30,LOW(6)
	CP   R4,R30
	BRLO _0xBE
;    2285 	{
;    2286 	t0_cnt0=0;
	CLR  R4
;    2287 	b100Hz=1;
	SET
	BLD  R2,1
;    2288 	}
;    2289 
;    2290 if(++t0_cnt1>=60)
_0xBE:
	INC  R5
	LDI  R30,LOW(60)
	CP   R5,R30
	BRLO _0xBF
;    2291 	{
;    2292 	t0_cnt1=0;
	CLR  R5
;    2293 	b10Hz=1;
	SET
	BLD  R2,2
;    2294 	
;    2295 	if(++t0_cnt2>=2)
	INC  R6
	LDI  R30,LOW(2)
	CP   R6,R30
	BRLO _0xC0
;    2296 		{
;    2297 		t0_cnt2=0;
	CLR  R6
;    2298 		bFL5=!bFL5;
	LDI  R30,LOW(1)
	EOR  R3,R30
;    2299 		}
;    2300 		
;    2301 	if(++t0_cnt3>=5)
_0xC0:
	INC  R7
	LDI  R30,LOW(5)
	CP   R7,R30
	BRLO _0xC1
;    2302 		{
;    2303 		t0_cnt3=0;
	CLR  R7
;    2304 		bFL2=!bFL2;
	LDI  R30,LOW(128)
	EOR  R2,R30
;    2305 		}		
;    2306 	}
_0xC1:
;    2307 }
_0xBF:
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
;    2308 
;    2309 //===============================================
;    2310 //===============================================
;    2311 //===============================================
;    2312 //===============================================
;    2313 
;    2314 void main(void)
;    2315 {
_main:
;    2316 
;    2317 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
;    2318 DDRA=0x00;
	RCALL SUBOPT_0x0
;    2319 
;    2320 PORTB=0xff;
	RCALL SUBOPT_0xE
;    2321 DDRB=0xFF;
;    2322 
;    2323 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;    2324 DDRC=0x00;
	OUT  0x14,R30
;    2325 
;    2326 
;    2327 PORTD=0x00;
	OUT  0x12,R30
;    2328 DDRD=0x00;
	OUT  0x11,R30
;    2329 
;    2330 
;    2331 TCCR0=0x02;
	RCALL SUBOPT_0xD
;    2332 TCNT0=-208;
;    2333 OCR0=0x00;
;    2334 
;    2335 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;    2336 TCCR1B=0x00;
	OUT  0x2E,R30
;    2337 TCNT1H=0x00;
	OUT  0x2D,R30
;    2338 TCNT1L=0x00;
	OUT  0x2C,R30
;    2339 ICR1H=0x00;
	OUT  0x27,R30
;    2340 ICR1L=0x00;
	OUT  0x26,R30
;    2341 OCR1AH=0x00;
	OUT  0x2B,R30
;    2342 OCR1AL=0x00;
	OUT  0x2A,R30
;    2343 OCR1BH=0x00;
	OUT  0x29,R30
;    2344 OCR1BL=0x00;
	OUT  0x28,R30
;    2345 
;    2346 
;    2347 ASSR=0x00;
	OUT  0x22,R30
;    2348 TCCR2=0x00;
	OUT  0x25,R30
;    2349 TCNT2=0x00;
	OUT  0x24,R30
;    2350 OCR2=0x00;
	OUT  0x23,R30
;    2351 
;    2352 MCUCR=0x00;
	OUT  0x35,R30
;    2353 MCUCSR=0x00;
	OUT  0x34,R30
;    2354 
;    2355 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;    2356 
;    2357 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;    2358 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;    2359 
;    2360 #asm("sei") 
	sei
;    2361 PORTB=0xFF;
	LDI  R30,LOW(255)
	RCALL SUBOPT_0xE
;    2362 DDRB=0xFF;
;    2363 ind=iMn;
	CLR  R12
;    2364 prog_drv();
	CALL _prog_drv
;    2365 ind_hndl();
	CALL _ind_hndl
;    2366 led_hndl();
	CALL _led_hndl
;    2367 while (1)
_0xC2:
;    2368       {
;    2369       if(b600Hz)
	SBRS R2,0
	RJMP _0xC5
;    2370 		{
;    2371 		b600Hz=0; 
	CLT
	BLD  R2,0
;    2372           
;    2373 		}         
;    2374       if(b100Hz)
_0xC5:
	SBRS R2,1
	RJMP _0xC6
;    2375 		{        
;    2376 		b100Hz=0; 
	CLT
	BLD  R2,1
;    2377 		but_an();
	RCALL _but_an
;    2378 	    	in_drv();
	CALL _in_drv
;    2379           mdvr_drv();
	CALL _mdvr_drv
;    2380           step_contr();
	CALL _step_contr
;    2381 		}   
;    2382 	if(b10Hz)
_0xC6:
	SBRS R2,2
	RJMP _0xC7
;    2383 		{
;    2384 		b10Hz=0;
	CLT
	BLD  R2,2
;    2385 		prog_drv();
	CALL _prog_drv
;    2386 		err_drv();
	CALL _err_drv
;    2387 		
;    2388     	     ind_hndl();
	CALL _ind_hndl
;    2389           led_hndl();
	CALL _led_hndl
;    2390           
;    2391           }
;    2392 
;    2393       };
_0xC7:
	RJMP _0xC2
;    2394 }
_0xC8:
	RJMP _0xC8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	LDI  R30,LOW(255)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x1:
	LDS  R30,_cnt_del
	LDS  R31,_cnt_del+1
	SBIW R30,1
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2:
	MOV  R11,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x3:
	MOV  R30,R16
	SUBI R30,LOW(1)
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x5:
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
SUBOPT_0x6:
	OUT  0x11,R30
	IN   R30,0x12
	ORI  R30,LOW(0xF8)
	OUT  0x12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7:
	IN   R30,0x15
	ORI  R30,LOW(0x95)
	OUT  0x15,R30
	IN   R30,0x14
	ANDI R30,LOW(0x6A)
	OUT  0x14,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8:
	LDS  R30,_but_s_G1
	LDS  R26,_but_n_G1
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x9:
	LDS  R30,_but_onL_temp_G1
	LDS  R26,_but1_cnt_G1
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA:
	LDS  R30,_but_s_G1
	ANDI R30,0xFD
	MOV  R9,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB:
	INC  R10
	LDI  R30,LOW(3)
	CP   R30,R10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xC:
	MOV  R30,R10
	LDI  R26,LOW(_ee_program)
	LDI  R27,HIGH(_ee_program)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD:
	LDI  R30,LOW(2)
	OUT  0x33,R30
	LDI  R30,LOW(65328)
	LDI  R31,HIGH(65328)
	OUT  0x32,R30
	LDI  R30,LOW(0)
	OUT  0x3C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE:
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

