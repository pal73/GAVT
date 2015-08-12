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
;       8 #define LED_LOOP_AUTO	7
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
;      21 #define BD1	7
;      22 #define BD2	4
;      23 #define DM	1
;      24 #define START	0
;      25 #define STOP	2
;      26 #define MD1	3
;      27 #define MD2	5
;      28 
;      29 #define MD1	2
;      30 #define MD2	3
;      31 #define VR	4
;      32 #define MD3	5
;      33 
;      34 #define PP1	6
;      35 #define PP2	7
;      36 #define PP3	5
;      37 #define PP4	4
;      38 #define PP5	3
;      39 #define DV	0 
;      40 
;      41 #define PP7	2
;      42 
;      43 #ifdef P380_MINI
;      44 #define MINPROG 1
;      45 #define MAXPROG 1 
;      46 #ifdef GAVT3
;      47 #define DV	2
;      48 #endif
;      49 #define PP3	3
;      50 #endif 
;      51 
;      52 #ifdef P380
;      53 #define MINPROG 1
;      54 #define MAXPROG 3 
;      55 #ifdef GAVT3
;      56 #define DV	2
;      57 #endif
;      58 #endif 
;      59 
;      60 #ifdef I380
;      61 #define MINPROG 1
;      62 #define MAXPROG 4
;      63 #endif
;      64 
;      65 #ifdef I380_WI
;      66 #define MINPROG 1
;      67 #define MAXPROG 4
;      68 #endif
;      69 
;      70 #ifdef I220
;      71 #define MINPROG 3
;      72 #define MAXPROG 4
;      73 #endif
;      74 
;      75 
;      76 #ifdef I220_WI
;      77 #define MINPROG 3
;      78 #define MAXPROG 4
;      79 #endif
;      80 
;      81 #ifdef TVIST_SKO
;      82 #define MINPROG 2
;      83 #define MAXPROG 3
;      84 #define DV	2
;      85 #endif
;      86 
;      87 #ifdef DV3KL2MD
;      88 
;      89 #define PP1	6
;      90 #define PP2	7
;      91 #define PP3	3
;      92 //#define PP4	4
;      93 //#define PP5	3
;      94 #define DV	2 
;      95 
;      96 #define MINPROG 2
;      97 #define MAXPROG 3
;      98 
;      99 #endif
;     100 
;     101 bit b600Hz;
;     102 
;     103 bit b100Hz;
;     104 bit b10Hz;
;     105 char t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3;
;     106 char ind_cnt;
;     107 flash char IND_STROB[]={0b10111111,0b11011111,0b11101111,0b11110111,0b01111111};

	.CSEG
;     108 flash char DIGISYM[]={0b11000000,0b11111001,0b10100100,0b10110000,0b10011001,0b10010010,0b10000010,0b11111000,0b10000000,0b10010000,0b11111111};								
;     109 
;     110 char ind_out[5]={0x255,0x255,0x255,0x255,0x255};

	.DSEG
_ind_out:
	.BYTE 0x5
;     111 char dig[4];
_dig:
	.BYTE 0x4
;     112 bit bZ;    
;     113 char but;
;     114 static char but_n;
_but_n_G1:
	.BYTE 0x1
;     115 static char but_s;
_but_s_G1:
	.BYTE 0x1
;     116 static char but0_cnt;
_but0_cnt_G1:
	.BYTE 0x1
;     117 static char but1_cnt;
_but1_cnt_G1:
	.BYTE 0x1
;     118 static char but_onL_temp;
_but_onL_temp_G1:
	.BYTE 0x1
;     119 bit l_but;		//идет длинное нажатие на кнопку
;     120 bit n_but;          //произошло нажатие
;     121 bit speed;		//разрешение ускорения перебора 
;     122 bit bFL2; 
;     123 bit bFL5;
;     124 eeprom enum{elmAUTO=0x55,elmMNL=0xaa}ee_loop_mode;

	.ESEG
_ee_loop_mode:
	.DB  0x0
;     125 eeprom char ee_program[2];
_ee_program:
	.DB  0x0
	.DB  0x0
;     126 enum {p1=1,p2=2,p3=3,p4=4}prog;
;     127 enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}step=sOFF;
;     128 enum {iMn,iPr_sel,iVr} ind;
;     129 char sub_ind;

	.DSEG
_sub_ind:
	.BYTE 0x1
;     130 char in_word,in_word_old,in_word_new,in_word_cnt;
_in_word:
	.BYTE 0x1
_in_word_old:
	.BYTE 0x1
_in_word_new:
	.BYTE 0x1
_in_word_cnt:
	.BYTE 0x1
;     131 bit bERR;
;     132 signed int cnt_del=0;
_cnt_del:
	.BYTE 0x2
;     133 
;     134 bit bMD1,bMD2,bBD1,bBD2,bDM,bSTART,bSTOP;
;     135 
;     136 char cnt_md1,cnt_md2,cnt_bd1,cnt_bd2,cnt_dm,cnt_start,cnt_stop;
_cnt_md1:
	.BYTE 0x1
_cnt_md2:
	.BYTE 0x1
_cnt_bd1:
	.BYTE 0x1
_cnt_bd2:
	.BYTE 0x1
_cnt_dm:
	.BYTE 0x1
_cnt_start:
	.BYTE 0x1
_cnt_stop:
	.BYTE 0x1
;     137 
;     138 eeprom unsigned ee_delay[4,2];

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
;     139 eeprom char ee_vr_log;
_ee_vr_log:
	.DB  0x0
;     140 #include <mega16.h>
;     141 //#include <mega8535.h>  
;     142 
;     143 bit bPP1,bPP2,bPP3,bPP4,bPP5,bPP6,bPP7,bPP8;
;     144 
;     145 enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}payka_step=sOFF,main_loop_step=sOFF;

	.DSEG
_payka_step:
	.BYTE 0x1
_main_loop_step:
	.BYTE 0x1
;     146 enum{cmdOFF=0,cmdSTART,cmdSTOP}payka_cmd=cmdOFF,main_loop_cmd;
_payka_cmd:
	.BYTE 0x1
_main_loop_cmd:
	.BYTE 0x1
;     147 signed short payka_cnt_del;
_payka_cnt_del:
	.BYTE 0x2
;     148 eeprom signed short ee_temp1,ee_temp2;

	.ESEG
_ee_temp1:
	.DW  0x0
_ee_temp2:
	.DW  0x0
;     149 
;     150 //-----------------------------------------------
;     151 void prog_drv(void)
;     152 {

	.CSEG
_prog_drv:
;     153 char temp,temp1,temp2;
;     154 
;     155 temp=ee_program[0];
	CALL __SAVELOCR3
;	temp -> R16
;	temp1 -> R17
;	temp2 -> R18
	LDI  R26,LOW(_ee_program)
	LDI  R27,HIGH(_ee_program)
	CALL __EEPROMRDB
	MOV  R16,R30
;     156 temp1=ee_program[1];
	__POINTW2MN _ee_program,1
	CALL __EEPROMRDB
	MOV  R17,R30
;     157 temp2=ee_program[2];
	__POINTW2MN _ee_program,2
	CALL __EEPROMRDB
	MOV  R18,R30
;     158 
;     159 if((temp==temp1)&&(temp==temp2))
	CP   R17,R16
	BRNE _0x5
	CP   R18,R16
	BREQ _0x6
_0x5:
	RJMP _0x4
_0x6:
;     160 	{
;     161 	}
;     162 else if((temp==temp1)&&(temp!=temp2))
	RJMP _0x7
_0x4:
	CP   R17,R16
	BRNE _0x9
	CP   R18,R16
	BRNE _0xA
_0x9:
	RJMP _0x8
_0xA:
;     163 	{
;     164 	temp2=temp;
	MOV  R18,R16
;     165 	}
;     166 else if((temp!=temp1)&&(temp==temp2))
	RJMP _0xB
_0x8:
	CP   R17,R16
	BREQ _0xD
	CP   R18,R16
	BREQ _0xE
_0xD:
	RJMP _0xC
_0xE:
;     167 	{
;     168 	temp1=temp;
	MOV  R17,R16
;     169 	}
;     170 else if((temp!=temp1)&&(temp1==temp2))
	RJMP _0xF
_0xC:
	CP   R17,R16
	BREQ _0x11
	CP   R18,R17
	BREQ _0x12
_0x11:
	RJMP _0x10
_0x12:
;     171 	{
;     172 	temp=temp1;
	MOV  R16,R17
;     173 	}
;     174 else if((temp!=temp1)&&(temp!=temp2))
	RJMP _0x13
_0x10:
	CP   R17,R16
	BREQ _0x15
	CP   R18,R16
	BRNE _0x16
_0x15:
	RJMP _0x14
_0x16:
;     175 	{
;     176 	temp=MINPROG;
	LDI  R16,LOW(2)
;     177 	temp1=MINPROG;
	LDI  R17,LOW(2)
;     178 	temp2=MINPROG;
	LDI  R18,LOW(2)
;     179 	}
;     180 
;     181 if(!((temp<=MAXPROG)&&(temp>=MINPROG)))
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
;     182 	{
;     183 	temp=MINPROG;
	LDI  R16,LOW(2)
;     184 	}
;     185 
;     186 if(temp!=ee_program[0])ee_program[0]=temp;
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
;     187 if(temp!=ee_program[1])ee_program[1]=temp;
_0x1A:
	__POINTW2MN _ee_program,1
	CALL __EEPROMRDB
	CP   R30,R16
	BREQ _0x1B
	__POINTW2MN _ee_program,1
	MOV  R30,R16
	CALL __EEPROMWRB
;     188 if(temp!=ee_program[2])ee_program[2]=temp;
_0x1B:
	__POINTW2MN _ee_program,2
	CALL __EEPROMRDB
	CP   R30,R16
	BREQ _0x1C
	__POINTW2MN _ee_program,2
	MOV  R30,R16
	CALL __EEPROMWRB
;     189 
;     190 prog=temp;
_0x1C:
	MOV  R12,R16
;     191 }
	CALL __LOADLOCR3
	RJMP _0x122
;     192 
;     193 //-----------------------------------------------
;     194 void in_drv(void)
;     195 {
;     196 char i,temp;
;     197 unsigned int tempUI;
;     198 DDRA=0x00;
;	i -> R16
;	temp -> R17
;	tempUI -> R18,R19
;     199 PORTA=0xff;
;     200 in_word_new=PINA;
;     201 if(in_word_old==in_word_new)
;     202 	{
;     203 	if(in_word_cnt<10)
;     204 		{
;     205 		in_word_cnt++;
;     206 		if(in_word_cnt>=10)
;     207 			{
;     208 			in_word=in_word_old;
;     209 			}
;     210 		}
;     211 	}
;     212 else in_word_cnt=0;
;     213 
;     214 
;     215 in_word_old=in_word_new;
;     216 }   
;     217 
;     218 //-----------------------------------------------
;     219 void err_drv(void)
;     220 {
_err_drv:
;     221 if(step==sOFF)
	TST  R13
	BRNE _0x21
;     222 	{
;     223     	if(prog==p2)	
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x22
;     224     		{
;     225        		if(bMD1) bERR=1;
	SBRS R3,2
	RJMP _0x23
	SET
	BLD  R3,1
;     226        		else bERR=0;
	RJMP _0x24
_0x23:
	CLT
	BLD  R3,1
_0x24:
;     227 		}
;     228 	}
_0x22:
;     229 else bERR=0;
	RJMP _0x25
_0x21:
	CLT
	BLD  R3,1
_0x25:
;     230 }
	RET
;     231   
;     232 
;     233 //-----------------------------------------------
;     234 void in_an(void)
;     235 {
_in_an:
;     236 DDRA=0x00;
	CALL SUBOPT_0x0
;     237 PORTA=0xff;
	OUT  0x1B,R30
;     238 in_word=PINA;
	IN   R30,0x19
	STS  _in_word,R30
;     239 
;     240 if(!(in_word&(1<<MD1)))
	ANDI R30,LOW(0x4)
	BRNE _0x26
;     241 	{
;     242 	if(cnt_md1<10)
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRSH _0x27
;     243 		{
;     244 		cnt_md1++;
	LDS  R30,_cnt_md1
	SUBI R30,-LOW(1)
	STS  _cnt_md1,R30
;     245 		if(cnt_md1==10) bMD1=1;
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRNE _0x28
	SET
	BLD  R3,2
;     246 		}
_0x28:
;     247 
;     248 	}
_0x27:
;     249 else
	RJMP _0x29
_0x26:
;     250 	{
;     251 	if(cnt_md1)
	LDS  R30,_cnt_md1
	CPI  R30,0
	BREQ _0x2A
;     252 		{
;     253 		cnt_md1--;
	SUBI R30,LOW(1)
	STS  _cnt_md1,R30
;     254 		if(cnt_md1==0) bMD1=0;
	CPI  R30,0
	BRNE _0x2B
	CLT
	BLD  R3,2
;     255 		}
_0x2B:
;     256 
;     257 	}
_0x2A:
_0x29:
;     258 
;     259 if(!(in_word&(1<<MD2)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x8)
	BRNE _0x2C
;     260 	{
;     261 	if(cnt_md2<10)
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRSH _0x2D
;     262 		{
;     263 		cnt_md2++;
	LDS  R30,_cnt_md2
	SUBI R30,-LOW(1)
	STS  _cnt_md2,R30
;     264 		if(cnt_md2==10) bMD2=1;
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRNE _0x2E
	SET
	BLD  R3,3
;     265 		}
_0x2E:
;     266 
;     267 	}
_0x2D:
;     268 else
	RJMP _0x2F
_0x2C:
;     269 	{
;     270 	if(cnt_md2)
	LDS  R30,_cnt_md2
	CPI  R30,0
	BREQ _0x30
;     271 		{
;     272 		cnt_md2--;
	SUBI R30,LOW(1)
	STS  _cnt_md2,R30
;     273 		if(cnt_md2==0) bMD2=0;
	CPI  R30,0
	BRNE _0x31
	CLT
	BLD  R3,3
;     274 		}
_0x31:
;     275 
;     276 	}
_0x30:
_0x2F:
;     277 
;     278 if(!(in_word&(1<<BD1)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x80)
	BRNE _0x32
;     279 	{
;     280 	if(cnt_bd1<10)
	LDS  R26,_cnt_bd1
	CPI  R26,LOW(0xA)
	BRSH _0x33
;     281 		{
;     282 		cnt_bd1++;
	LDS  R30,_cnt_bd1
	SUBI R30,-LOW(1)
	STS  _cnt_bd1,R30
;     283 		if(cnt_bd1==10) bBD1=1;
	LDS  R26,_cnt_bd1
	CPI  R26,LOW(0xA)
	BRNE _0x34
	SET
	BLD  R3,4
;     284 		}
_0x34:
;     285 
;     286 	}
_0x33:
;     287 else
	RJMP _0x35
_0x32:
;     288 	{
;     289 	if(cnt_bd1)
	LDS  R30,_cnt_bd1
	CPI  R30,0
	BREQ _0x36
;     290 		{
;     291 		cnt_bd1--;
	SUBI R30,LOW(1)
	STS  _cnt_bd1,R30
;     292 		if(cnt_bd1==0) bBD1=0;
	CPI  R30,0
	BRNE _0x37
	CLT
	BLD  R3,4
;     293 		}
_0x37:
;     294 
;     295 	}
_0x36:
_0x35:
;     296 
;     297 if(!(in_word&(1<<BD2)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x10)
	BRNE _0x38
;     298 	{
;     299 	if(cnt_bd2<10)
	LDS  R26,_cnt_bd2
	CPI  R26,LOW(0xA)
	BRSH _0x39
;     300 		{
;     301 		cnt_bd2++;
	LDS  R30,_cnt_bd2
	SUBI R30,-LOW(1)
	STS  _cnt_bd2,R30
;     302 		if(cnt_bd2==10) bBD2=1;
	LDS  R26,_cnt_bd2
	CPI  R26,LOW(0xA)
	BRNE _0x3A
	SET
	BLD  R3,5
;     303 		}
_0x3A:
;     304 
;     305 	}
_0x39:
;     306 else
	RJMP _0x3B
_0x38:
;     307 	{
;     308 	if(cnt_bd2)
	LDS  R30,_cnt_bd2
	CPI  R30,0
	BREQ _0x3C
;     309 		{
;     310 		cnt_bd2--;
	SUBI R30,LOW(1)
	STS  _cnt_bd2,R30
;     311 		if(cnt_bd2==0) bBD2=0;
	CPI  R30,0
	BRNE _0x3D
	CLT
	BLD  R3,5
;     312 		}
_0x3D:
;     313 
;     314 	}
_0x3C:
_0x3B:
;     315 
;     316 if(!(in_word&(1<<DM)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x2)
	BRNE _0x3E
;     317 	{
;     318 	if(cnt_dm<10)
	LDS  R26,_cnt_dm
	CPI  R26,LOW(0xA)
	BRSH _0x3F
;     319 		{
;     320 		cnt_dm++;
	LDS  R30,_cnt_dm
	SUBI R30,-LOW(1)
	STS  _cnt_dm,R30
;     321 		if(cnt_dm==10) bDM=1;
	LDS  R26,_cnt_dm
	CPI  R26,LOW(0xA)
	BRNE _0x40
	SET
	BLD  R3,6
;     322 		}
_0x40:
;     323 	}
_0x3F:
;     324 else
	RJMP _0x41
_0x3E:
;     325 	{
;     326 	if(cnt_dm)
	LDS  R30,_cnt_dm
	CPI  R30,0
	BREQ _0x42
;     327 		{
;     328 		cnt_dm--;
	SUBI R30,LOW(1)
	STS  _cnt_dm,R30
;     329 		if(cnt_dm==0) bDM=0;
	CPI  R30,0
	BRNE _0x43
	CLT
	BLD  R3,6
;     330 		}
_0x43:
;     331 	}
_0x42:
_0x41:
;     332 
;     333 if(!(in_word&(1<<START)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x1)
	BRNE _0x44
;     334 	{
;     335 	if(cnt_start<10)
	LDS  R26,_cnt_start
	CPI  R26,LOW(0xA)
	BRSH _0x45
;     336 		{
;     337 		cnt_start++;
	LDS  R30,_cnt_start
	SUBI R30,-LOW(1)
	STS  _cnt_start,R30
;     338 		if(cnt_start==10) 
	LDS  R26,_cnt_start
	CPI  R26,LOW(0xA)
	BRNE _0x46
;     339 			{
;     340 			bSTART=1;
	SET
	BLD  R3,7
;     341 			main_loop_cmd==cmdSTART;
	LDS  R26,_main_loop_cmd
	LDI  R30,LOW(1)
	CALL __EQB12
;     342 			}
;     343 		}
_0x46:
;     344 	}
_0x45:
;     345 else
	RJMP _0x47
_0x44:
;     346 	{
;     347 	if(cnt_start)
	LDS  R30,_cnt_start
	CPI  R30,0
	BREQ _0x48
;     348 		{
;     349 		cnt_start--;
	SUBI R30,LOW(1)
	STS  _cnt_start,R30
;     350 		if(cnt_start==0) bSTART=0;
	CPI  R30,0
	BRNE _0x49
	CLT
	BLD  R3,7
;     351 		}
_0x49:
;     352 	} 
_0x48:
_0x47:
;     353 
;     354 if(!(in_word&(1<<STOP)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x4)
	BRNE _0x4A
;     355 	{
;     356 	if(cnt_stop<10)
	LDS  R26,_cnt_stop
	CPI  R26,LOW(0xA)
	BRSH _0x4B
;     357 		{
;     358 		cnt_stop++;
	LDS  R30,_cnt_stop
	SUBI R30,-LOW(1)
	STS  _cnt_stop,R30
;     359 		if(cnt_stop==10) bSTOP=1;
	LDS  R26,_cnt_stop
	CPI  R26,LOW(0xA)
	BRNE _0x4C
	SET
	BLD  R4,0
;     360 		}
_0x4C:
;     361 	}
_0x4B:
;     362 else
	RJMP _0x4D
_0x4A:
;     363 	{
;     364 	if(cnt_stop)
	LDS  R30,_cnt_stop
	CPI  R30,0
	BREQ _0x4E
;     365 		{
;     366 		cnt_stop--;
	SUBI R30,LOW(1)
	STS  _cnt_stop,R30
;     367 		if(cnt_stop==0) bSTOP=0;
	CPI  R30,0
	BRNE _0x4F
	CLT
	BLD  R4,0
;     368 		}
_0x4F:
;     369 	} 
_0x4E:
_0x4D:
;     370 } 
	RET
;     371 
;     372 //-----------------------------------------------
;     373 void main_loop_hndl(void)
;     374 {
_main_loop_hndl:
;     375 if(main_loop_cmd==cmdSTART)
	LDS  R26,_main_loop_cmd
	CPI  R26,LOW(0x1)
	BRNE _0x50
;     376 	{
;     377 	payka_cmd=cmdSTART;
	LDI  R30,LOW(1)
	STS  _payka_cmd,R30
;     378 	main_loop_cmd=cmdOFF;
	LDI  R30,LOW(0)
	STS  _main_loop_cmd,R30
;     379 	}                      
;     380 else if(main_loop_cmd==cmdSTOP)
	RJMP _0x51
_0x50:
	LDS  R26,_main_loop_cmd
	CPI  R26,LOW(0x2)
	BRNE _0x52
;     381 	{
;     382 
;     383 	}
;     384 	 
;     385 }
_0x52:
_0x51:
	RET
;     386 
;     387 //-----------------------------------------------
;     388 void payka_hndl(void)
;     389 {
_payka_hndl:
;     390 if(payka_cmd==cmdSTART)
	LDS  R26,_payka_cmd
	CPI  R26,LOW(0x1)
	BRNE _0x53
;     391 	{
;     392 	payka_step=s1;
	LDI  R30,LOW(1)
	STS  _payka_step,R30
;     393 	payka_cnt_del=ee_temp1;
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	STS  _payka_cnt_del,R30
	STS  _payka_cnt_del+1,R31
;     394 	payka_cmd=cmdOFF;
	LDI  R30,LOW(0)
	STS  _payka_cmd,R30
;     395 	}                      
;     396 else if(payka_cmd==cmdSTOP)
	RJMP _0x54
_0x53:
	LDS  R26,_payka_cmd
	CPI  R26,LOW(0x2)
	BRNE _0x55
;     397 	{
;     398 	payka_step=sOFF;
	LDI  R30,LOW(0)
	STS  _payka_step,R30
;     399 	payka_cmd=cmdOFF;
	STS  _payka_cmd,R30
;     400 	} 
;     401 		
;     402 if(payka_step==sOFF)
_0x55:
_0x54:
	LDS  R30,_payka_step
	CPI  R30,0
	BRNE _0x56
;     403 	{
;     404 	bPP6=0;
	CLT
	BLD  R4,6
;     405 	bPP7=0;
	CLT
	BLD  R4,7
;     406 	}      
;     407 else if(payka_step==s1)
	RJMP _0x57
_0x56:
	LDS  R26,_payka_step
	CPI  R26,LOW(0x1)
	BRNE _0x58
;     408 	{
;     409 	bPP6=1;
	SET
	BLD  R4,6
;     410 	bPP7=0;
	CLT
	BLD  R4,7
;     411 	payka_cnt_del--;
	CALL SUBOPT_0x1
;     412 	if(payka_cnt_del==0)
	BRNE _0x59
;     413 		{
;     414 		payka_step=s2;
	LDI  R30,LOW(2)
	STS  _payka_step,R30
;     415 		payka_cnt_del=20;
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _payka_cnt_del,R30
	STS  _payka_cnt_del+1,R31
;     416 		}                	
;     417 	}	
_0x59:
;     418 else if(payka_step==s2)
	RJMP _0x5A
_0x58:
	LDS  R26,_payka_step
	CPI  R26,LOW(0x2)
	BRNE _0x5B
;     419 	{
;     420 	bPP6=0;
	CLT
	BLD  R4,6
;     421 	bPP7=0;
	CLT
	BLD  R4,7
;     422 	payka_cnt_del--;
	CALL SUBOPT_0x1
;     423 	if(payka_cnt_del==0)
	BRNE _0x5C
;     424 		{
;     425 		payka_step=s3;
	LDI  R30,LOW(3)
	STS  _payka_step,R30
;     426 		payka_cnt_del=ee_temp2;
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	STS  _payka_cnt_del,R30
	STS  _payka_cnt_del+1,R31
;     427 		}                	
;     428 	}		  
_0x5C:
;     429 else if(payka_step==s3)
	RJMP _0x5D
_0x5B:
	LDS  R26,_payka_step
	CPI  R26,LOW(0x3)
	BRNE _0x5E
;     430 	{
;     431 	bPP6=0;
	CLT
	BLD  R4,6
;     432 	bPP7=1;
	SET
	BLD  R4,7
;     433 	payka_cnt_del--;
	CALL SUBOPT_0x1
;     434 	if(payka_cnt_del==0)
	BRNE _0x5F
;     435 		{
;     436 		payka_step=sOFF;
	LDI  R30,LOW(0)
	STS  _payka_step,R30
;     437 		}                	
;     438 	}			
_0x5F:
;     439 }
_0x5E:
_0x5D:
_0x5A:
_0x57:
	RET
;     440 
;     441 //-----------------------------------------------
;     442 void step_contr(void)
;     443 {
_step_contr:
;     444 char temp=0;
;     445 DDRB=0xFF;
	ST   -Y,R16
;	temp -> R16
	LDI  R16,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     446 
;     447 if(step==sOFF)goto step_contr_end;
	TST  R13
	BRNE _0x60
	RJMP _0x61
;     448 
;     449 else if(prog==p1)
_0x60:
	LDI  R30,LOW(1)
	CP   R30,R12
	BREQ PC+3
	JMP _0x63
;     450 	{
;     451 	if(step==s1)    //жесть
	CP   R30,R13
	BRNE _0x64
;     452 		{
;     453 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     454           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x61
;     455 
;     456 			//if(ee_vacuum_mode==evmOFF)
;     457 				{
;     458 				//goto lbl_0001;
;     459 				}
;     460 			//else step=s2;
;     461 		}
;     462 
;     463 	else if(step==s2)
	RJMP _0x66
_0x64:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0x67
;     464 		{
;     465 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(200)
;     466  //         if(!bVR)goto step_contr_end;
;     467 lbl_0001:
;     468 
;     469           step=s100;
	CALL SUBOPT_0x2
;     470 		cnt_del=40;
;     471           }
;     472 	else if(step==s100)
	RJMP _0x69
_0x67:
	LDI  R30,LOW(19)
	CP   R30,R13
	BRNE _0x6A
;     473 		{
;     474 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(216)
;     475           cnt_del--;
	CALL SUBOPT_0x3
;     476           if(cnt_del==0)
	BRNE _0x6B
;     477 			{
;     478           	step=s3;
	CALL SUBOPT_0x4
;     479           	cnt_del=50;
;     480 			}
;     481 		}
_0x6B:
;     482 
;     483 	else if(step==s3)
	RJMP _0x6C
_0x6A:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0x6D
;     484 		{
;     485 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(220)
;     486           cnt_del--;
	CALL SUBOPT_0x3
;     487           if(cnt_del==0)
	BRNE _0x6E
;     488 			{
;     489           	step=s4;
	LDI  R30,LOW(4)
	MOV  R13,R30
;     490 			}
;     491 		}
_0x6E:
;     492 	else if(step==s4)
	RJMP _0x6F
_0x6D:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0x70
;     493 		{
;     494 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
	ORI  R16,LOW(220)
;     495           if(!bMD2)goto step_contr_end;
	SBRS R3,3
	RJMP _0x61
;     496           step=s5;
	CALL SUBOPT_0x5
;     497           cnt_del=20;
;     498 		}
;     499 	else if(step==s5)
	RJMP _0x72
_0x70:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0x73
;     500 		{
;     501 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(220)
;     502           cnt_del--;
	CALL SUBOPT_0x3
;     503           if(cnt_del==0)
	BRNE _0x74
;     504 			{
;     505           	step=s6;
	LDI  R30,LOW(6)
	MOV  R13,R30
;     506 			}
;     507           }
_0x74:
;     508 	else if(step==s6)
	RJMP _0x75
_0x73:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0x76
;     509 		{
;     510 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
	ORI  R16,LOW(220)
;     511  //         if(!bMD3)goto step_contr_end;
;     512           step=s7;
	CALL SUBOPT_0x6
;     513           cnt_del=20;
;     514 		}
;     515 
;     516 	else if(step==s7)
	RJMP _0x77
_0x76:
	LDI  R30,LOW(7)
	CP   R30,R13
	BRNE _0x78
;     517 		{
;     518 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(220)
;     519           cnt_del--;
	CALL SUBOPT_0x3
;     520           if(cnt_del==0)
	BRNE _0x79
;     521 			{
;     522           	step=s8;
	LDI  R30,LOW(8)
	CALL SUBOPT_0x7
;     523           	cnt_del=ee_delay[prog,0]*10U;;
;     524 			}
;     525           }
_0x79:
;     526 	else if(step==s8)
	RJMP _0x7A
_0x78:
	LDI  R30,LOW(8)
	CP   R30,R13
	BRNE _0x7B
;     527 		{
;     528 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;     529           cnt_del--;
	CALL SUBOPT_0x3
;     530           if(cnt_del==0)
	BRNE _0x7C
;     531 			{
;     532           	step=s9;
	LDI  R30,LOW(9)
	CALL SUBOPT_0x8
;     533           	cnt_del=20;
;     534 			}
;     535           }
_0x7C:
;     536 	else if(step==s9)
	RJMP _0x7D
_0x7B:
	LDI  R30,LOW(9)
	CP   R30,R13
	BRNE _0x7E
;     537 		{
;     538 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     539           cnt_del--;
	CALL SUBOPT_0x3
;     540           if(cnt_del==0)
	BRNE _0x7F
;     541 			{
;     542           	step=sOFF;
	CLR  R13
;     543           	}
;     544           }
_0x7F:
;     545 	}
_0x7E:
_0x7D:
_0x7A:
_0x77:
_0x75:
_0x72:
_0x6F:
_0x6C:
_0x69:
_0x66:
;     546 
;     547 else if(prog==p2)  //ско
	RJMP _0x80
_0x63:
	LDI  R30,LOW(2)
	CP   R30,R12
	BREQ PC+3
	JMP _0x81
;     548 	{
;     549 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0x82
;     550 		{
;     551 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     552           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x61
;     553 
;     554 		/*	if(ee_vacuum_mode==evmOFF)
;     555 				{
;     556 				goto lbl_0002;
;     557 				}
;     558 			else step=s2; */
;     559 
;     560           //step=s2;
;     561 		}
;     562 
;     563 	else if(step==s2)
	RJMP _0x84
_0x82:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0x85
;     564 		{
;     565 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(200)
;     566  //         if(!bVR)goto step_contr_end;
;     567 
;     568 lbl_0002:
;     569           step=s100;
	CALL SUBOPT_0x2
;     570 		cnt_del=40;
;     571           }
;     572 	else if(step==s100)
	RJMP _0x87
_0x85:
	LDI  R30,LOW(19)
	CP   R30,R13
	BRNE _0x88
;     573 		{
;     574 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(216)
;     575           cnt_del--;
	CALL SUBOPT_0x3
;     576           if(cnt_del==0)
	BRNE _0x89
;     577 			{
;     578           	step=s3;
	CALL SUBOPT_0x4
;     579           	cnt_del=50;
;     580 			}
;     581 		}
_0x89:
;     582 	else if(step==s3)
	RJMP _0x8A
_0x88:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0x8B
;     583 		{
;     584 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(220)
;     585           cnt_del--;
	CALL SUBOPT_0x3
;     586           if(cnt_del==0)
	BRNE _0x8C
;     587 			{
;     588           	step=s4;
	LDI  R30,LOW(4)
	MOV  R13,R30
;     589 			}
;     590 		}
_0x8C:
;     591 	else if(step==s4)
	RJMP _0x8D
_0x8B:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0x8E
;     592 		{
;     593 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
	ORI  R16,LOW(220)
;     594           if(!bMD2)goto step_contr_end;
	SBRS R3,3
	RJMP _0x61
;     595           step=s5;
	CALL SUBOPT_0x5
;     596           cnt_del=20;
;     597 		}
;     598 	else if(step==s5)
	RJMP _0x90
_0x8E:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0x91
;     599 		{
;     600 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(220)
;     601           cnt_del--;
	CALL SUBOPT_0x3
;     602           if(cnt_del==0)
	BRNE _0x92
;     603 			{
;     604           	step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x7
;     605           	cnt_del=ee_delay[prog,0]*10U;
;     606 			}
;     607           }
_0x92:
;     608 	else if(step==s6)
	RJMP _0x93
_0x91:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0x94
;     609 		{
;     610 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;     611           cnt_del--;
	CALL SUBOPT_0x3
;     612           if(cnt_del==0)
	BRNE _0x95
;     613 			{
;     614           	step=s7;
	CALL SUBOPT_0x6
;     615           	cnt_del=20;
;     616 			}
;     617           }
_0x95:
;     618 	else if(step==s7)
	RJMP _0x96
_0x94:
	LDI  R30,LOW(7)
	CP   R30,R13
	BRNE _0x97
;     619 		{
;     620 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     621           cnt_del--;
	CALL SUBOPT_0x3
;     622           if(cnt_del==0)
	BRNE _0x98
;     623 			{
;     624           	step=sOFF;
	CLR  R13
;     625           	}
;     626           }
_0x98:
;     627 	}
_0x97:
_0x96:
_0x93:
_0x90:
_0x8D:
_0x8A:
_0x87:
_0x84:
;     628 
;     629 else if(prog==p3)   //твист
	RJMP _0x99
_0x81:
	LDI  R30,LOW(3)
	CP   R30,R12
	BREQ PC+3
	JMP _0x9A
;     630 	{
;     631 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0x9B
;     632 		{
;     633 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     634           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x61
;     635 
;     636 		/*	if(ee_vacuum_mode==evmOFF)
;     637 				{
;     638 				goto lbl_0003;
;     639 				}
;     640 			else step=s2;*/
;     641 
;     642           //step=s2;
;     643 		}
;     644 
;     645 	else if(step==s2)
	RJMP _0x9D
_0x9B:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0x9E
;     646 		{
;     647 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(200)
;     648  //         if(!bVR)goto step_contr_end;
;     649 lbl_0003:
;     650           cnt_del=50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;     651 		step=s3;
	LDI  R30,LOW(3)
	MOV  R13,R30
;     652 		}
;     653 
;     654 
;     655 	else	if(step==s3)
	RJMP _0xA0
_0x9E:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0xA1
;     656 		{
;     657 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(216)
;     658 		cnt_del--;
	CALL SUBOPT_0x3
;     659 		if(cnt_del==0)
	BRNE _0xA2
;     660 			{
;     661 			cnt_del=ee_delay[prog,0]*10U;
	CALL SUBOPT_0x9
	ADD  R26,R30
	ADC  R27,R31
	CALL SUBOPT_0xA
;     662 			step=s4;
	LDI  R30,LOW(4)
	MOV  R13,R30
;     663 			}
;     664           }
_0xA2:
;     665 	else if(step==s4)
	RJMP _0xA3
_0xA1:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0xA4
;     666 		{
;     667 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
	ORI  R16,LOW(220)
;     668 		cnt_del--;
	CALL SUBOPT_0x3
;     669  		if(cnt_del==0)
	BRNE _0xA5
;     670 			{
;     671 			cnt_del=ee_delay[prog,1]*10U;
	CALL SUBOPT_0x9
	CALL SUBOPT_0xB
;     672 			step=s5;
	LDI  R30,LOW(5)
	MOV  R13,R30
;     673 			}
;     674 		}
_0xA5:
;     675 
;     676 	else if(step==s5)
	RJMP _0xA6
_0xA4:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0xA7
;     677 		{
;     678 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
	ORI  R16,LOW(204)
;     679 		cnt_del--;
	CALL SUBOPT_0x3
;     680 		if(cnt_del==0)
	BRNE _0xA8
;     681 			{
;     682 			step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x8
;     683 			cnt_del=20;
;     684 			}
;     685 		}
_0xA8:
;     686 
;     687 	else if(step==s6)
	RJMP _0xA9
_0xA7:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0xAA
;     688 		{
;     689 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     690   		cnt_del--;
	CALL SUBOPT_0x3
;     691 		if(cnt_del==0)
	BRNE _0xAB
;     692 			{
;     693 			step=sOFF;
	CLR  R13
;     694 			}
;     695 		}
_0xAB:
;     696 
;     697 	}
_0xAA:
_0xA9:
_0xA6:
_0xA3:
_0xA0:
_0x9D:
;     698 
;     699 else if(prog==p4)      //замок
	RJMP _0xAC
_0x9A:
	LDI  R30,LOW(4)
	CP   R30,R12
	BREQ PC+3
	JMP _0xAD
;     700 	{
;     701 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0xAE
;     702 		{
;     703 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     704           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x61
;     705 
;     706 		 /*	if(ee_vacuum_mode==evmOFF)
;     707 				{
;     708 				goto lbl_0004;
;     709 				}
;     710 			else step=s2;*/
;     711           //step=s2;
;     712 		}
;     713 
;     714 	else if(step==s2)
	RJMP _0xB0
_0xAE:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0xB1
;     715 		{
;     716 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(200)
;     717  //         if(!bVR)goto step_contr_end;
;     718 lbl_0004:
;     719           step=s3;
	CALL SUBOPT_0x4
;     720 		cnt_del=50;
;     721           }
;     722 
;     723 	else if(step==s3)
	RJMP _0xB3
_0xB1:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0xB4
;     724 		{
;     725 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(216)
;     726           cnt_del--;
	CALL SUBOPT_0x3
;     727           if(cnt_del==0)
	BRNE _0xB5
;     728 			{
;     729           	step=s4;
	LDI  R30,LOW(4)
	CALL SUBOPT_0x7
;     730 			cnt_del=ee_delay[prog,0]*10U;
;     731 			}
;     732           }
_0xB5:
;     733 
;     734    	else if(step==s4)
	RJMP _0xB6
_0xB4:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0xB7
;     735 		{
;     736 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;     737 		cnt_del--;
	CALL SUBOPT_0x3
;     738 		if(cnt_del==0)
	BRNE _0xB8
;     739 			{
;     740 			step=s5;
	LDI  R30,LOW(5)
	MOV  R13,R30
;     741 			cnt_del=30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;     742 			}
;     743 		}
_0xB8:
;     744 
;     745 	else if(step==s5)
	RJMP _0xB9
_0xB7:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0xBA
;     746 		{
;     747 		temp|=(1<<PP1)|(1<<PP4);
	ORI  R16,LOW(80)
;     748 		cnt_del--;
	CALL SUBOPT_0x3
;     749 		if(cnt_del==0)
	BRNE _0xBB
;     750 			{
;     751 			step=s6;
	LDI  R30,LOW(6)
	MOV  R13,R30
;     752 			cnt_del=ee_delay[prog,1]*10U;
	CALL SUBOPT_0x9
	CALL SUBOPT_0xB
;     753 			}
;     754 		}
_0xBB:
;     755 
;     756 	else if(step==s6)
	RJMP _0xBC
_0xBA:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0xBD
;     757 		{
;     758 		temp|=(1<<PP4);
	ORI  R16,LOW(16)
;     759 		cnt_del--;
	CALL SUBOPT_0x3
;     760 		if(cnt_del==0)
	BRNE _0xBE
;     761 			{
;     762 			step=sOFF;
	CLR  R13
;     763 			}
;     764 		}
_0xBE:
;     765 
;     766 	}
_0xBD:
_0xBC:
_0xB9:
_0xB6:
_0xB3:
_0xB0:
;     767 	
;     768 step_contr_end:
_0xAD:
_0xAC:
_0x99:
_0x80:
_0x61:
;     769 
;     770 //if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;     771 
;     772 PORTB=~temp;
	MOV  R30,R16
	COM  R30
	OUT  0x18,R30
;     773 //PORTB=0x55;
;     774 }
	LD   R16,Y+
	RET
;     775 
;     776 
;     777 //-----------------------------------------------
;     778 void bin2bcd_int(unsigned int in)
;     779 {
_bin2bcd_int:
;     780 char i;
;     781 for(i=3;i>0;i--)
	ST   -Y,R16
;	in -> Y+1
;	i -> R16
	LDI  R16,LOW(3)
_0xC0:
	LDI  R30,LOW(0)
	CP   R30,R16
	BRSH _0xC1
;     782 	{
;     783 	dig[i]=in%10;
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
;     784 	in/=10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
;     785 	}   
	SUBI R16,1
	RJMP _0xC0
_0xC1:
;     786 }
	LDD  R16,Y+0
	RJMP _0x122
;     787 
;     788 //-----------------------------------------------
;     789 void bcd2ind(char s)
;     790 {
_bcd2ind:
;     791 char i;
;     792 bZ=1;
	ST   -Y,R16
;	s -> Y+1
;	i -> R16
	SET
	BLD  R2,3
;     793 for (i=0;i<5;i++)
	LDI  R16,LOW(0)
_0xC3:
	CPI  R16,5
	BRLO PC+3
	JMP _0xC4
;     794 	{
;     795 	if(bZ&&(!dig[i-1])&&(i<4))
	SBRS R2,3
	RJMP _0xC6
	CALL SUBOPT_0xC
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	CPI  R30,0
	BRNE _0xC6
	CPI  R16,4
	BRLO _0xC7
_0xC6:
	RJMP _0xC5
_0xC7:
;     796 		{
;     797 		if((4-i)>s)
	LDI  R30,LOW(4)
	SUB  R30,R16
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
	BRSH _0xC8
;     798 			{
;     799 			ind_out[i-1]=DIGISYM[10];
	CALL SUBOPT_0xC
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	POP  R26
	POP  R27
	RJMP _0x123
;     800 			}
;     801 		else ind_out[i-1]=DIGISYM[0];	
_0xC8:
	CALL SUBOPT_0xC
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	LPM  R30,Z
	POP  R26
	POP  R27
_0x123:
	ST   X,R30
;     802 		}
;     803 	else
	RJMP _0xCA
_0xC5:
;     804 		{
;     805 		ind_out[i-1]=DIGISYM[dig[i-1]];
	CALL SUBOPT_0xC
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	POP  R26
	POP  R27
	CALL SUBOPT_0xD
	POP  R26
	POP  R27
	ST   X,R30
;     806 		bZ=0;
	CLT
	BLD  R2,3
;     807 		}                   
_0xCA:
;     808 
;     809 	if(s)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0xCB
;     810 		{
;     811 		ind_out[3-s]&=0b01111111;
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
;     812 		}	
;     813  
;     814 	}
_0xCB:
	SUBI R16,-1
	RJMP _0xC3
_0xC4:
;     815 }            
	LDD  R16,Y+0
	ADIW R28,2
	RET
;     816 //-----------------------------------------------
;     817 void int2ind(unsigned int in,char s)
;     818 {
_int2ind:
;     819 bin2bcd_int(in);
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _bin2bcd_int
;     820 bcd2ind(s);
	LD   R30,Y
	ST   -Y,R30
	CALL _bcd2ind
;     821 
;     822 } 
_0x122:
	ADIW R28,3
	RET
;     823 
;     824 //-----------------------------------------------
;     825 void ind_hndl(void)
;     826 {
_ind_hndl:
;     827 int2ind(bDM,0);
	LDI  R30,0
	SBRC R3,6
	LDI  R30,1
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _int2ind
;     828 //int2ind(ee_delay[prog,sub_ind],1);  
;     829 //ind_out[0]=0xff;//DIGISYM[0];
;     830 //ind_out[1]=0xff;//DIGISYM[1];
;     831 //ind_out[2]=DIGISYM[2];//0xff;
;     832 //ind_out[0]=DIGISYM[7]; 
;     833 
;     834 ind_out[0]=DIGISYM[sub_ind+1];
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	PUSH R31
	PUSH R30
	LDS  R30,_sub_ind
	SUBI R30,-LOW(1)
	POP  R26
	POP  R27
	CALL SUBOPT_0xD
	STS  _ind_out,R30
;     835 }
	RET
;     836 
;     837 //-----------------------------------------------
;     838 void led_hndl(void)
;     839 {
_led_hndl:
;     840 ind_out[4]=DIGISYM[10]; 
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	__PUTB1MN _ind_out,4
;     841 
;     842 ind_out[4]&=~(1<<LED_POW_ON); 
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xDF
	POP  R26
	POP  R27
	ST   X,R30
;     843 
;     844 if(step!=sOFF)
	TST  R13
	BREQ _0xCC
;     845 	{
;     846 	ind_out[4]&=~(1<<LED_WRK);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xBF
	POP  R26
	POP  R27
	RJMP _0x124
;     847 	}
;     848 else ind_out[4]|=(1<<LED_WRK);
_0xCC:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x40
	POP  R26
	POP  R27
_0x124:
	ST   X,R30
;     849 
;     850 
;     851 if(step==sOFF)
	TST  R13
	BRNE _0xCE
;     852 	{
;     853  	if(bERR)
	SBRS R3,1
	RJMP _0xCF
;     854 		{
;     855 		ind_out[4]&=~(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFE
	POP  R26
	POP  R27
	RJMP _0x125
;     856 		}
;     857 	else
_0xCF:
;     858 		{
;     859 		ind_out[4]|=(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
_0x125:
	ST   X,R30
;     860 		}
;     861      }
;     862 else ind_out[4]|=(1<<LED_ERROR);
	RJMP _0xD1
_0xCE:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
	ST   X,R30
_0xD1:
;     863 
;     864 /* 	if(bMD1)
;     865 		{
;     866 		ind_out[4]&=~(1<<LED_ERROR);
;     867 		}
;     868 	else
;     869 		{
;     870 		ind_out[4]|=(1<<LED_ERROR);
;     871 		} */
;     872 
;     873 //if(bERR)ind_out[4]&=~(1<<LED_ERROR);
;     874 if(ee_loop_mode==elmAUTO)ind_out[4]&=~(1<<LED_LOOP_AUTO);
	LDI  R26,LOW(_ee_loop_mode)
	LDI  R27,HIGH(_ee_loop_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0xD2
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0x7F
	POP  R26
	POP  R27
	RJMP _0x126
;     875 else ind_out[4]|=(1<<LED_LOOP_AUTO);
_0xD2:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x80
	POP  R26
	POP  R27
_0x126:
	ST   X,R30
;     876 
;     877 if(prog==p1) ind_out[4]&=~(1<<LED_PROG1);
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0xD4
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xEF
	POP  R26
	POP  R27
	ST   X,R30
;     878 else if(prog==p2) ind_out[4]&=~(1<<LED_PROG2);
	RJMP _0xD5
_0xD4:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0xD6
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFB
	POP  R26
	POP  R27
	ST   X,R30
;     879 else if(prog==p3) ind_out[4]&=~(1<<LED_PROG3);
	RJMP _0xD7
_0xD6:
	LDI  R30,LOW(3)
	CP   R30,R12
	BRNE _0xD8
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0XF7
	POP  R26
	POP  R27
	ST   X,R30
;     880 else if(prog==p4) ind_out[4]&=~(1<<LED_PROG4);
	RJMP _0xD9
_0xD8:
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0xDA
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFD
	POP  R26
	POP  R27
	ST   X,R30
;     881 
;     882 if(ind==iPr_sel)
_0xDA:
_0xD9:
_0xD7:
_0xD5:
	LDI  R30,LOW(1)
	CP   R30,R14
	BRNE _0xDB
;     883 	{
;     884 	if(bFL5)ind_out[4]|=(1<<LED_PROG1)|(1<<LED_PROG2)|(1<<LED_PROG3)|(1<<LED_PROG4);
	SBRS R3,0
	RJMP _0xDC
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,LOW(0x1E)
	POP  R26
	POP  R27
	ST   X,R30
;     885 	} 
_0xDC:
;     886 	 
;     887 if(ind==iVr)
_0xDB:
	LDI  R30,LOW(2)
	CP   R30,R14
	BRNE _0xDD
;     888 	{
;     889 	if(bFL5)ind_out[4]|=(1<<LED_POW_ON);
	SBRS R3,0
	RJMP _0xDE
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x20
	POP  R26
	POP  R27
	ST   X,R30
;     890 	}	
_0xDE:
;     891 }
_0xDD:
	RET
;     892 
;     893 //-----------------------------------------------
;     894 // Подпрограмма драйва до 7 кнопок одного порта, 
;     895 // различает короткое и длинное нажатие,
;     896 // срабатывает на отпускание кнопки, возможность
;     897 // ускорения перебора при длинном нажатии...
;     898 #define but_port PORTC
;     899 #define but_dir  DDRC
;     900 #define but_pin  PINC
;     901 #define but_mask 0b01101010
;     902 #define no_but   0b11111111
;     903 #define but_on   5
;     904 #define but_onL  20
;     905 
;     906 
;     907 
;     908 
;     909 void but_drv(void)
;     910 { 
_but_drv:
;     911 DDRD&=0b00000111;
	IN   R30,0x11
	ANDI R30,LOW(0x7)
	CALL SUBOPT_0xE
;     912 PORTD|=0b11111000;
;     913 
;     914 but_port|=(but_mask^0xff);
	CALL SUBOPT_0xF
;     915 but_dir&=but_mask;
;     916 #asm
;     917 nop
nop
;     918 nop
nop
;     919 nop
nop
;     920 nop
nop
;     921 #endasm

;     922 
;     923 but_n=but_pin|but_mask; 
	IN   R30,0x13
	ORI  R30,LOW(0x6A)
	STS  _but_n_G1,R30
;     924 
;     925 if((but_n==no_but)||(but_n!=but_s))
	LDS  R26,_but_n_G1
	CPI  R26,LOW(0xFF)
	BREQ _0xE0
	RCALL SUBOPT_0x10
	BREQ _0xDF
_0xE0:
;     926  	{
;     927  	speed=0;
	CLT
	BLD  R2,6
;     928    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRSH _0xE3
	LDS  R26,_but1_cnt_G1
	CPI  R26,LOW(0x0)
	BREQ _0xE5
_0xE3:
	SBRS R2,4
	RJMP _0xE6
_0xE5:
	RJMP _0xE2
_0xE6:
;     929   		{
;     930    	     n_but=1;
	SET
	BLD  R2,5
;     931           but=but_s;
	LDS  R11,_but_s_G1
;     932           }
;     933    	if (but1_cnt>=but_onL_temp)
_0xE2:
	RCALL SUBOPT_0x11
	BRLO _0xE7
;     934   		{
;     935    	     n_but=1;
	SET
	BLD  R2,5
;     936           but=but_s&0b11111101;
	RCALL SUBOPT_0x12
;     937           }
;     938     	l_but=0;
_0xE7:
	CLT
	BLD  R2,4
;     939    	but_onL_temp=but_onL;
	LDI  R30,LOW(20)
	STS  _but_onL_temp_G1,R30
;     940     	but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;     941   	but1_cnt=0;          
	STS  _but1_cnt_G1,R30
;     942      goto but_drv_out;
	RJMP _0xE8
;     943   	}  
;     944   	
;     945 if(but_n==but_s)
_0xDF:
	RCALL SUBOPT_0x10
	BRNE _0xE9
;     946  	{
;     947   	but0_cnt++;
	LDS  R30,_but0_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but0_cnt_G1,R30
;     948   	if(but0_cnt>=but_on)
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRLO _0xEA
;     949   		{
;     950    		but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;     951    		but1_cnt++;
	LDS  R30,_but1_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but1_cnt_G1,R30
;     952    		if(but1_cnt>=but_onL_temp)
	RCALL SUBOPT_0x11
	BRLO _0xEB
;     953    			{              
;     954     			but=but_s&0b11111101;
	RCALL SUBOPT_0x12
;     955     			but1_cnt=0;
	LDI  R30,LOW(0)
	STS  _but1_cnt_G1,R30
;     956     			n_but=1;
	SET
	BLD  R2,5
;     957     			l_but=1;
	SET
	BLD  R2,4
;     958 			if(speed)
	SBRS R2,6
	RJMP _0xEC
;     959 				{
;     960     				but_onL_temp=but_onL_temp>>1;
	LDS  R30,_but_onL_temp_G1
	LSR  R30
	STS  _but_onL_temp_G1,R30
;     961         			if(but_onL_temp<=2) but_onL_temp=2;
	LDS  R26,_but_onL_temp_G1
	LDI  R30,LOW(2)
	CP   R30,R26
	BRLO _0xED
	STS  _but_onL_temp_G1,R30
;     962 				}    
_0xED:
;     963    			}
_0xEC:
;     964   		} 
_0xEB:
;     965  	}
_0xEA:
;     966 but_drv_out:
_0xE9:
_0xE8:
;     967 but_s=but_n;
	LDS  R30,_but_n_G1
	STS  _but_s_G1,R30
;     968 but_port|=(but_mask^0xff);
	RCALL SUBOPT_0xF
;     969 but_dir&=but_mask;
;     970 }    
	RET
;     971 
;     972 #define butV	239
;     973 #define butV_	237
;     974 #define butP	251
;     975 #define butP_	249
;     976 #define butR	127
;     977 #define butR_	125
;     978 #define butL	254
;     979 #define butL_	252
;     980 #define butLR	126
;     981 #define butLR_	124 
;     982 #define butVP_ 233
;     983 //-----------------------------------------------
;     984 void but_an(void)
;     985 {
_but_an:
;     986 /*
;     987 if(!(in_word&0x01))
;     988 	{
;     989 	#ifdef TVIST_SKO
;     990 	if((step==sOFF)&&(!bERR))
;     991 		{
;     992 		step=s1;
;     993 		if(prog==p2) cnt_del=70;
;     994 		else if(prog==p3) cnt_del=100;
;     995 		}
;     996 	#endif
;     997 	#ifdef DV3KL2MD
;     998 	if((step==sOFF)&&(!bERR))
;     999 		{
;    1000 		step=s1;
;    1001 		cnt_del=70;
;    1002 		}
;    1003 	#endif	
;    1004 	#ifndef TVIST_SKO
;    1005 	if((step==sOFF)&&(!bERR))
;    1006 		{
;    1007 		step=s1;
;    1008 		if(prog==p1) cnt_del=50;
;    1009 		else if(prog==p2) cnt_del=50;
;    1010 		else if(prog==p3) cnt_del=50;
;    1011           #ifdef P380_MINI
;    1012   		cnt_del=100;
;    1013   		#endif
;    1014 		}
;    1015 	#endif
;    1016 	}
;    1017 if(!(in_word&0x02))
;    1018 	{
;    1019 	step=sOFF;
;    1020 
;    1021 	} */
;    1022 
;    1023 if (!n_but) goto but_an_end;
	SBRS R2,5
	RJMP _0xEF
;    1024 
;    1025 if(but==butV_)
	LDI  R30,LOW(237)
	CP   R30,R11
	BRNE _0xF0
;    1026 	{
;    1027 	if(ee_loop_mode!=elmAUTO)ee_loop_mode=elmAUTO;
	LDI  R26,LOW(_ee_loop_mode)
	LDI  R27,HIGH(_ee_loop_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BREQ _0xF1
	LDI  R30,LOW(85)
	RJMP _0x127
;    1028 	else ee_loop_mode=elmMNL;
_0xF1:
	LDI  R30,LOW(170)
_0x127:
	LDI  R26,LOW(_ee_loop_mode)
	LDI  R27,HIGH(_ee_loop_mode)
	CALL __EEPROMWRB
;    1029 	}
;    1030 
;    1031 if(but==butVP_)
_0xF0:
	LDI  R30,LOW(233)
	CP   R30,R11
	BRNE _0xF3
;    1032 	{
;    1033 	if(ind!=iVr)ind=iVr;
	LDI  R30,LOW(2)
	CP   R30,R14
	BREQ _0xF4
	MOV  R14,R30
;    1034 	else ind=iMn;
	RJMP _0xF5
_0xF4:
	CLR  R14
_0xF5:
;    1035 	}
;    1036 
;    1037 	
;    1038 if(ind==iMn)
_0xF3:
	TST  R14
	BRNE _0xF6
;    1039 	{
;    1040 	if(but==butP_)ind=iPr_sel;
	LDI  R30,LOW(249)
	CP   R30,R11
	BRNE _0xF7
	LDI  R30,LOW(1)
	MOV  R14,R30
;    1041 	if(but==butLR)	
_0xF7:
	LDI  R30,LOW(126)
	CP   R30,R11
	BRNE _0xF8
;    1042 		{
;    1043 		if((prog==p3)||(prog==p4))
	LDI  R30,LOW(3)
	CP   R30,R12
	BREQ _0xFA
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0xF9
_0xFA:
;    1044 			{ 
;    1045 			if(sub_ind==0)sub_ind=1;
	LDS  R30,_sub_ind
	CPI  R30,0
	BRNE _0xFC
	LDI  R30,LOW(1)
	RJMP _0x128
;    1046 			else sub_ind=0;
_0xFC:
	LDI  R30,LOW(0)
_0x128:
	STS  _sub_ind,R30
;    1047 			}
;    1048     		else sub_ind=0;
	RJMP _0xFE
_0xF9:
	LDI  R30,LOW(0)
	STS  _sub_ind,R30
_0xFE:
;    1049 		}	 
;    1050 	if((but==butR)||(but==butR_))	
_0xF8:
	LDI  R30,LOW(127)
	CP   R30,R11
	BREQ _0x100
	LDI  R30,LOW(125)
	CP   R30,R11
	BRNE _0xFF
_0x100:
;    1051 		{  
;    1052 		speed=1;
	SET
	BLD  R2,6
;    1053 		ee_delay[prog,sub_ind]++;
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x13
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    1054 		}   
;    1055 	
;    1056 	else if((but==butL)||(but==butL_))	
	RJMP _0x102
_0xFF:
	LDI  R30,LOW(254)
	CP   R30,R11
	BREQ _0x104
	LDI  R30,LOW(252)
	CP   R30,R11
	BRNE _0x103
_0x104:
;    1057 		{  
;    1058     		speed=1;
	SET
	BLD  R2,6
;    1059     		ee_delay[prog,sub_ind]--;
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x13
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    1060     		}		
;    1061 	} 
_0x103:
_0x102:
;    1062 	
;    1063 else if(ind==iPr_sel)
	RJMP _0x106
_0xF6:
	LDI  R30,LOW(1)
	CP   R30,R14
	BRNE _0x107
;    1064 	{
;    1065 	if(but==butP_)ind=iMn;
	LDI  R30,LOW(249)
	CP   R30,R11
	BRNE _0x108
	CLR  R14
;    1066 	if(but==butP)
_0x108:
	LDI  R30,LOW(251)
	CP   R30,R11
	BRNE _0x109
;    1067 		{
;    1068 		prog++;
	RCALL SUBOPT_0x14
;    1069 		if(prog>MAXPROG)prog=MINPROG;
	BRGE _0x10A
	LDI  R30,LOW(2)
	MOV  R12,R30
;    1070 		ee_program[0]=prog;
_0x10A:
	RCALL SUBOPT_0x15
;    1071 		ee_program[1]=prog;
	__POINTW2MN _ee_program,1
	MOV  R30,R12
	CALL __EEPROMWRB
;    1072 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R12
	CALL __EEPROMWRB
;    1073 		}
;    1074 	
;    1075 	if(but==butR)
_0x109:
	LDI  R30,LOW(127)
	CP   R30,R11
	BRNE _0x10B
;    1076 		{
;    1077 		prog++;
	RCALL SUBOPT_0x14
;    1078 		if(prog>MAXPROG)prog=MINPROG;
	BRGE _0x10C
	LDI  R30,LOW(2)
	MOV  R12,R30
;    1079 		ee_program[0]=prog;
_0x10C:
	RCALL SUBOPT_0x15
;    1080 		ee_program[1]=prog;
	__POINTW2MN _ee_program,1
	MOV  R30,R12
	CALL __EEPROMWRB
;    1081 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R12
	CALL __EEPROMWRB
;    1082 		}
;    1083 
;    1084 	if(but==butL)
_0x10B:
	LDI  R30,LOW(254)
	CP   R30,R11
	BRNE _0x10D
;    1085 		{
;    1086 		prog--;
	DEC  R12
;    1087 		if(prog>MAXPROG)prog=MINPROG;
	LDI  R30,LOW(3)
	CP   R30,R12
	BRGE _0x10E
	LDI  R30,LOW(2)
	MOV  R12,R30
;    1088 		ee_program[0]=prog;
_0x10E:
	RCALL SUBOPT_0x15
;    1089 		ee_program[1]=prog;
	__POINTW2MN _ee_program,1
	MOV  R30,R12
	CALL __EEPROMWRB
;    1090 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R12
	CALL __EEPROMWRB
;    1091 		}	
;    1092 	} 
_0x10D:
;    1093 
;    1094 else if(ind==iVr)
	RJMP _0x10F
_0x107:
	LDI  R30,LOW(2)
	CP   R30,R14
	BRNE _0x110
;    1095 	{
;    1096 	if(but==butP_)
	LDI  R30,LOW(249)
	CP   R30,R11
	BRNE _0x111
;    1097 		{
;    1098 		if(ee_vr_log)ee_vr_log=0;
	LDI  R26,LOW(_ee_vr_log)
	LDI  R27,HIGH(_ee_vr_log)
	CALL __EEPROMRDB
	CPI  R30,0
	BREQ _0x112
	LDI  R30,LOW(0)
	RJMP _0x129
;    1099 		else ee_vr_log=1;
_0x112:
	LDI  R30,LOW(1)
_0x129:
	LDI  R26,LOW(_ee_vr_log)
	LDI  R27,HIGH(_ee_vr_log)
	CALL __EEPROMWRB
;    1100 		}	
;    1101 	} 	
_0x111:
;    1102 
;    1103 but_an_end:
_0x110:
_0x10F:
_0x106:
_0xEF:
;    1104 n_but=0;
	CLT
	BLD  R2,5
;    1105 }
	RET
;    1106 
;    1107 //-----------------------------------------------
;    1108 void ind_drv(void)
;    1109 {
_ind_drv:
;    1110 if(++ind_cnt>=6)ind_cnt=0;
	INC  R10
	LDI  R30,LOW(6)
	CP   R10,R30
	BRLO _0x114
	CLR  R10
;    1111 
;    1112 if(ind_cnt<5)
_0x114:
	LDI  R30,LOW(5)
	CP   R10,R30
	BRSH _0x115
;    1113 	{
;    1114 	DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
;    1115 	PORTC=0xFF;
	OUT  0x15,R30
;    1116 	DDRD|=0b11111000;
	IN   R30,0x11
	ORI  R30,LOW(0xF8)
	RCALL SUBOPT_0xE
;    1117 	PORTD|=0b11111000;
;    1118 	PORTD&=IND_STROB[ind_cnt];
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
;    1119 	PORTC=ind_out[ind_cnt];
	MOV  R30,R10
	LDI  R31,0
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	LD   R30,Z
	OUT  0x15,R30
;    1120 	}
;    1121 else but_drv();
	RJMP _0x116
_0x115:
	CALL _but_drv
_0x116:
;    1122 }
	RET
;    1123 
;    1124 //***********************************************
;    1125 //***********************************************
;    1126 //***********************************************
;    1127 //***********************************************
;    1128 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;    1129 {
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
;    1130 TCCR0=0x02;
	RCALL SUBOPT_0x16
;    1131 TCNT0=-208;
;    1132 OCR0=0x00; 
;    1133 
;    1134 
;    1135 b600Hz=1;
	SET
	BLD  R2,0
;    1136 ind_drv();
	RCALL _ind_drv
;    1137 if(++t0_cnt0>=6)
	INC  R6
	LDI  R30,LOW(6)
	CP   R6,R30
	BRLO _0x117
;    1138 	{
;    1139 	t0_cnt0=0;
	CLR  R6
;    1140 	b100Hz=1;
	SET
	BLD  R2,1
;    1141 	}
;    1142 
;    1143 if(++t0_cnt1>=60)
_0x117:
	INC  R7
	LDI  R30,LOW(60)
	CP   R7,R30
	BRLO _0x118
;    1144 	{
;    1145 	t0_cnt1=0;
	CLR  R7
;    1146 	b10Hz=1;
	SET
	BLD  R2,2
;    1147 	
;    1148 	if(++t0_cnt2>=2)
	INC  R8
	LDI  R30,LOW(2)
	CP   R8,R30
	BRLO _0x119
;    1149 		{
;    1150 		t0_cnt2=0;
	CLR  R8
;    1151 		bFL5=!bFL5;
	LDI  R30,LOW(1)
	EOR  R3,R30
;    1152 		}
;    1153 		
;    1154 	if(++t0_cnt3>=5)
_0x119:
	INC  R9
	LDI  R30,LOW(5)
	CP   R9,R30
	BRLO _0x11A
;    1155 		{
;    1156 		t0_cnt3=0;
	CLR  R9
;    1157 		bFL2=!bFL2;
	LDI  R30,LOW(128)
	EOR  R2,R30
;    1158 		}		
;    1159 	}
_0x11A:
;    1160 }
_0x118:
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
;    1161 
;    1162 //===============================================
;    1163 //===============================================
;    1164 //===============================================
;    1165 //===============================================
;    1166 
;    1167 void main(void)
;    1168 {
_main:
;    1169 
;    1170 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
;    1171 DDRA=0x00;
	RCALL SUBOPT_0x0
;    1172 
;    1173 PORTB=0xff;
	RCALL SUBOPT_0x17
;    1174 DDRB=0xFF;
;    1175 
;    1176 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;    1177 DDRC=0x00;
	OUT  0x14,R30
;    1178 
;    1179 
;    1180 PORTD=0x00;
	OUT  0x12,R30
;    1181 DDRD=0x00;
	OUT  0x11,R30
;    1182 
;    1183 
;    1184 TCCR0=0x02;
	RCALL SUBOPT_0x16
;    1185 TCNT0=-208;
;    1186 OCR0=0x00;
;    1187 
;    1188 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;    1189 TCCR1B=0x00;
	OUT  0x2E,R30
;    1190 TCNT1H=0x00;
	OUT  0x2D,R30
;    1191 TCNT1L=0x00;
	OUT  0x2C,R30
;    1192 ICR1H=0x00;
	OUT  0x27,R30
;    1193 ICR1L=0x00;
	OUT  0x26,R30
;    1194 OCR1AH=0x00;
	OUT  0x2B,R30
;    1195 OCR1AL=0x00;
	OUT  0x2A,R30
;    1196 OCR1BH=0x00;
	OUT  0x29,R30
;    1197 OCR1BL=0x00;
	OUT  0x28,R30
;    1198 
;    1199 
;    1200 ASSR=0x00;
	OUT  0x22,R30
;    1201 TCCR2=0x00;
	OUT  0x25,R30
;    1202 TCNT2=0x00;
	OUT  0x24,R30
;    1203 OCR2=0x00;
	OUT  0x23,R30
;    1204 
;    1205 MCUCR=0x00;
	OUT  0x35,R30
;    1206 MCUCSR=0x00;
	OUT  0x34,R30
;    1207 
;    1208 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;    1209 
;    1210 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;    1211 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;    1212 
;    1213 #asm("sei") 
	sei
;    1214 PORTB=0xFF;
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x17
;    1215 DDRB=0xFF;
;    1216 ind=iMn;
	CLR  R14
;    1217 prog_drv();
	CALL _prog_drv
;    1218 ind_hndl();
	CALL _ind_hndl
;    1219 led_hndl();
	CALL _led_hndl
;    1220 
;    1221 ee_temp1=10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMWRW
;    1222 ee_temp2=10;
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMWRW
;    1223 while (1)
_0x11B:
;    1224       {
;    1225       if(b600Hz)
	SBRS R2,0
	RJMP _0x11E
;    1226 		{
;    1227 		b600Hz=0; 
	CLT
	BLD  R2,0
;    1228           in_an();
	CALL _in_an
;    1229           
;    1230 		}         
;    1231       if(b100Hz)
_0x11E:
	SBRS R2,1
	RJMP _0x11F
;    1232 		{        
;    1233 		b100Hz=0; 
	CLT
	BLD  R2,1
;    1234 		but_an();
	RCALL _but_an
;    1235 	    	//in_drv();
;    1236           ind_hndl();
	CALL _ind_hndl
;    1237           step_contr();
	CALL _step_contr
;    1238           
;    1239           main_loop_hndl();
	CALL _main_loop_hndl
;    1240           payka_hndl();
	CALL _payka_hndl
;    1241 		}   
;    1242 	if(b10Hz)
_0x11F:
	SBRS R2,2
	RJMP _0x120
;    1243 		{
;    1244 		b10Hz=0;
	CLT
	BLD  R2,2
;    1245 		prog_drv();
	CALL _prog_drv
;    1246 		err_drv();
	CALL _err_drv
;    1247 		
;    1248     	     
;    1249           led_hndl();
	CALL _led_hndl
;    1250           
;    1251           }
;    1252 
;    1253       };
_0x120:
	RJMP _0x11B
;    1254 }
_0x121:
	RJMP _0x121

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	LDI  R30,LOW(255)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x1:
	LDS  R30,_payka_cnt_del
	LDS  R31,_payka_cnt_del+1
	SBIW R30,1
	STS  _payka_cnt_del,R30
	STS  _payka_cnt_del+1,R31
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2:
	LDI  R30,LOW(19)
	MOV  R13,R30
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES
SUBOPT_0x3:
	LDS  R30,_cnt_del
	LDS  R31,_cnt_del+1
	SBIW R30,1
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x4:
	LDI  R30,LOW(3)
	MOV  R13,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5:
	LDI  R30,LOW(5)
	MOV  R13,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6:
	LDI  R30,LOW(7)
	MOV  R13,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x7:
	MOV  R13,R30
	MOV  R30,R12
	LDI  R26,LOW(_ee_delay)
	LDI  R27,HIGH(_ee_delay)
	LDI  R31,0
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
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
SUBOPT_0x8:
	MOV  R13,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x9:
	MOV  R30,R12
	LDI  R26,LOW(_ee_delay)
	LDI  R27,HIGH(_ee_delay)
	LDI  R31,0
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xA:
	CALL __EEPROMRDW
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB:
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,2
	MOVW R26,R30
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0xC:
	MOV  R30,R16
	SUBI R30,LOW(1)
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE:
	OUT  0x11,R30
	IN   R30,0x12
	ORI  R30,LOW(0xF8)
	OUT  0x12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF:
	IN   R30,0x15
	ORI  R30,LOW(0x95)
	OUT  0x15,R30
	IN   R30,0x14
	ANDI R30,LOW(0x6A)
	OUT  0x14,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10:
	LDS  R30,_but_s_G1
	LDS  R26,_but_n_G1
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x11:
	LDS  R30,_but_onL_temp_G1
	LDS  R26,_but1_cnt_G1
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x12:
	LDS  R30,_but_s_G1
	ANDI R30,0xFD
	MOV  R11,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x13:
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,_sub_ind
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x14:
	INC  R12
	LDI  R30,LOW(3)
	CP   R30,R12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x15:
	MOV  R30,R12
	LDI  R26,LOW(_ee_program)
	LDI  R27,HIGH(_ee_program)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x16:
	LDI  R30,LOW(2)
	OUT  0x33,R30
	LDI  R30,LOW(65328)
	LDI  R31,HIGH(65328)
	OUT  0x32,R30
	LDI  R30,LOW(0)
	OUT  0x3C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x17:
	OUT  0x18,R30
	LDI  R30,LOW(255)
	OUT  0x17,R30
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
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

