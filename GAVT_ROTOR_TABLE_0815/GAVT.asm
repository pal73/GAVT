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
;       3 #define LED_ORIENT	4
;       4 #define LED_NAPOLN	2 
;       5 #define LED_PAYKA	3
;       6 #define LED_ERROR	0 
;       7 #define LED_WRK	6
;       8 #define LED_LOOP_AUTO	7
;       9 
;      10 
;      11 
;      12 
;      13 #define BD1	7
;      14 #define BD2	4
;      15 #define DM	1
;      16 #define START	0
;      17 #define STOP	2
;      18 #define MD1	3
;      19 #define MD2	5
;      20 
;      21 
;      22 #define PP1	6
;      23 #define PP2	7
;      24 #define PP3	5
;      25 #define PP4	4
;      26 #define PP5	3 
;      27 #define PP6	2
;      28 #define PP7	1
;      29 
;      30 
;      31 bit b600Hz;
;      32 
;      33 bit b100Hz;
;      34 bit b10Hz;
;      35 char t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3;
;      36 char ind_cnt;
;      37 flash char IND_STROB[]={0b10111111,0b11011111,0b11101111,0b11110111,0b01111111};

	.CSEG
;      38 flash char DIGISYM[]={0b11000000,0b11111001,0b10100100,0b10110000,0b10011001,0b10010010,0b10000010,0b11111000,0b10000000,0b10010000,0b11111111};								
;      39 
;      40 char ind_out[5]={0x255,0x255,0x255,0x255,0x255};

	.DSEG
_ind_out:
	.BYTE 0x5
;      41 char dig[4];
_dig:
	.BYTE 0x4
;      42 bit bZ;    
;      43 char but;
;      44 static char but_n;
_but_n_G1:
	.BYTE 0x1
;      45 static char but_s;
_but_s_G1:
	.BYTE 0x1
;      46 static char but0_cnt;
_but0_cnt_G1:
	.BYTE 0x1
;      47 static char but1_cnt;
_but1_cnt_G1:
	.BYTE 0x1
;      48 static char but_onL_temp;
_but_onL_temp_G1:
	.BYTE 0x1
;      49 bit l_but;		//идет длинное нажатие на кнопку
;      50 bit n_but;          //произошло нажатие
;      51 bit speed;		//разрешение ускорения перебора 
;      52 bit bFL2; 
;      53 bit bFL5;
;      54 eeprom enum{elmAUTO=0x55,elmMNL=0xaa}ee_loop_mode;

	.ESEG
_ee_loop_mode:
	.DB  0x0
;      55 //eeprom char ee_program[2];
;      56 enum {p1=1,p2=2,p3=3,p4=4}prog;
;      57 enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}step=sOFF;
;      58 enum {iMn,iPr_sel,iSet} ind;
;      59 char sub_ind;

	.DSEG
_sub_ind:
	.BYTE 0x1
;      60 char in_word,in_word_old,in_word_new,in_word_cnt;
_in_word:
	.BYTE 0x1
_in_word_old:
	.BYTE 0x1
_in_word_new:
	.BYTE 0x1
_in_word_cnt:
	.BYTE 0x1
;      61 bit bERR;
;      62 signed int cnt_del=0;
_cnt_del:
	.BYTE 0x2
;      63 
;      64 bit bMD1,bMD2,bBD1,bBD2,bDM,bSTART,bSTOP;
;      65 
;      66 char cnt_md1,cnt_md2,cnt_bd1,cnt_bd2,cnt_dm,cnt_start,cnt_stop;
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
;      67 
;      68 //eeprom unsigned ee_delay[4,2];
;      69 //eeprom char ee_vr_log;
;      70 #include <mega16.h>
;      71 //#include <mega8535.h>  
;      72 
;      73 bit bPP1,bPP2,bPP3,bPP4,bPP5,bPP6,bPP7,bPP8;
;      74 
;      75 enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}payka_step=sOFF,napoln_step=sOFF,orient_step=sOFF,main_loop_step=sOFF;
_payka_step:
	.BYTE 0x1
_napoln_step:
	.BYTE 0x1
_orient_step:
	.BYTE 0x1
_main_loop_step:
	.BYTE 0x1
;      76 enum{cmdOFF=0,cmdSTART,cmdSTOP}payka_cmd=cmdOFF,napoln_cmd=cmdOFF,orient_cmd=cmdOFF,main_loop_cmd=cmdOFF;
_payka_cmd:
	.BYTE 0x1
_napoln_cmd:
	.BYTE 0x1
_orient_cmd:
	.BYTE 0x1
_main_loop_cmd:
	.BYTE 0x1
;      77 signed short payka_cnt_del,napoln_cnt_del,orient_cnt_del,main_loop_cnt_del;
_payka_cnt_del:
	.BYTE 0x2
_napoln_cnt_del:
	.BYTE 0x2
_orient_cnt_del:
	.BYTE 0x2
_main_loop_cnt_del:
	.BYTE 0x2
;      78 eeprom signed short ee_temp1,ee_temp2;

	.ESEG
_ee_temp1:
	.DW  0x0
_ee_temp2:
	.DW  0x0
;      79 
;      80 bit bPAYKA_COMPLETE=0,bNAPOLN_COMPLETE=0,bORIENT_COMPLETE=0;
;      81 eeprom signed int ee_prog;
_ee_prog:
	.DW  0x0
;      82 
;      83 eeprom signed short ee_temp3,ee_temp4;
_ee_temp3:
	.DW  0x0
_ee_temp4:
	.DW  0x0
;      84 
;      85 #define EE_PROG_FULL		0
;      86 #define EE_PROG_ONLY_ORIENT 	1
;      87 #define EE_PROG_ONLY_NAPOLN	2
;      88 #define EE_PROG_ONLY_PAYKA	3
;      89 #define EE_PROG_ONLY_MAIN_LOOP 	4
;      90 
;      91 //-----------------------------------------------
;      92 void prog_drv(void)
;      93 {

	.CSEG
_prog_drv:
;      94 char temp,temp1,temp2;
;      95 
;      96 ///temp=ee_program[0];
;      97 ///temp1=ee_program[1];
;      98 ///temp2=ee_program[2];
;      99 
;     100 if((temp==temp1)&&(temp==temp2))
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
;     101 	{
;     102 	}
;     103 else if((temp==temp1)&&(temp!=temp2))
	RJMP _0x7
_0x4:
	CP   R17,R16
	BRNE _0x9
	CP   R18,R16
	BRNE _0xA
_0x9:
	RJMP _0x8
_0xA:
;     104 	{
;     105 	temp2=temp;
	MOV  R18,R16
;     106 	}
;     107 else if((temp!=temp1)&&(temp==temp2))
	RJMP _0xB
_0x8:
	CP   R17,R16
	BREQ _0xD
	CP   R18,R16
	BREQ _0xE
_0xD:
	RJMP _0xC
_0xE:
;     108 	{
;     109 	temp1=temp;
	MOV  R17,R16
;     110 	}
;     111 else if((temp!=temp1)&&(temp1==temp2))
	RJMP _0xF
_0xC:
	CP   R17,R16
	BREQ _0x11
	CP   R18,R17
	BREQ _0x12
_0x11:
	RJMP _0x10
_0x12:
;     112 	{
;     113 	temp=temp1;
	MOV  R16,R17
;     114 	}
;     115 else if((temp!=temp1)&&(temp!=temp2))
	RJMP _0x13
_0x10:
	CP   R17,R16
	BREQ _0x15
	CP   R18,R16
	BRNE _0x16
_0x15:
_0x16:
;     116 	{
;     117 ////	temp=MINPROG;
;     118 ////	temp1=MINPROG;
;     119 ////	temp2=MINPROG;
;     120 	}
;     121 
;     122 ////if(!((temp<=MAXPROG)&&(temp>=MINPROG)))
;     123 ////	{
;     124 ////	temp=MINPROG;
;     125 ////	}
;     126 
;     127 ///if(temp!=ee_program[0])ee_program[0]=temp;
;     128 ///if(temp!=ee_program[1])ee_program[1]=temp;
;     129 ///if(temp!=ee_program[2])ee_program[2]=temp;
;     130 
;     131 prog=temp;
_0x13:
_0xF:
_0xB:
_0x7:
	MOV  R12,R16
;     132 }
	CALL __LOADLOCR3
	RJMP _0x189
;     133 
;     134 //-----------------------------------------------
;     135 void in_drv(void)
;     136 {
;     137 char i,temp;
;     138 unsigned int tempUI;
;     139 DDRA=0x00;
;	i -> R16
;	temp -> R17
;	tempUI -> R18,R19
;     140 PORTA=0xff;
;     141 in_word_new=PINA;
;     142 if(in_word_old==in_word_new)
;     143 	{
;     144 	if(in_word_cnt<10)
;     145 		{
;     146 		in_word_cnt++;
;     147 		if(in_word_cnt>=10)
;     148 			{
;     149 			in_word=in_word_old;
;     150 			}
;     151 		}
;     152 	}
;     153 else in_word_cnt=0;
;     154 
;     155 
;     156 in_word_old=in_word_new;
;     157 }   
;     158 
;     159 //-----------------------------------------------
;     160 void err_drv(void)
;     161 {
_err_drv:
;     162 if(step==sOFF)
	TST  R13
	BRNE _0x1B
;     163 	{
;     164     	if(prog==p2)	
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x1C
;     165     		{
;     166        		if(bMD1) bERR=1;
	SBRS R3,2
	RJMP _0x1D
	SET
	BLD  R3,1
;     167        		else bERR=0;
	RJMP _0x1E
_0x1D:
	CLT
	BLD  R3,1
_0x1E:
;     168 		}
;     169 	}
_0x1C:
;     170 else bERR=0;
	RJMP _0x1F
_0x1B:
	CLT
	BLD  R3,1
_0x1F:
;     171 }
	RET
;     172   
;     173 
;     174 //-----------------------------------------------
;     175 void in_an(void)
;     176 {
_in_an:
;     177 DDRA=0x00;
	CALL SUBOPT_0x0
;     178 PORTA=0xff;
	OUT  0x1B,R30
;     179 in_word=PINA;
	IN   R30,0x19
	STS  _in_word,R30
;     180 
;     181 if(!(in_word&(1<<MD1)))
	ANDI R30,LOW(0x8)
	BRNE _0x20
;     182 	{
;     183 	if(cnt_md1<10)
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRSH _0x21
;     184 		{
;     185 		cnt_md1++;
	LDS  R30,_cnt_md1
	SUBI R30,-LOW(1)
	STS  _cnt_md1,R30
;     186 		if(cnt_md1==10) bMD1=1;
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRNE _0x22
	SET
	BLD  R3,2
;     187 		}
_0x22:
;     188 
;     189 	}
_0x21:
;     190 else
	RJMP _0x23
_0x20:
;     191 	{
;     192 	if(cnt_md1)
	LDS  R30,_cnt_md1
	CPI  R30,0
	BREQ _0x24
;     193 		{
;     194 		cnt_md1--;
	SUBI R30,LOW(1)
	STS  _cnt_md1,R30
;     195 		if(cnt_md1==0) bMD1=0;
	CPI  R30,0
	BRNE _0x25
	CLT
	BLD  R3,2
;     196 		}
_0x25:
;     197 
;     198 	}
_0x24:
_0x23:
;     199 
;     200 if(!(in_word&(1<<MD2)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x20)
	BRNE _0x26
;     201 	{
;     202 	if(cnt_md2<10)
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRSH _0x27
;     203 		{
;     204 		cnt_md2++;
	LDS  R30,_cnt_md2
	SUBI R30,-LOW(1)
	STS  _cnt_md2,R30
;     205 		if(cnt_md2==10) bMD2=1;
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRNE _0x28
	SET
	BLD  R3,3
;     206 		}
_0x28:
;     207 
;     208 	}
_0x27:
;     209 else
	RJMP _0x29
_0x26:
;     210 	{
;     211 	if(cnt_md2)
	LDS  R30,_cnt_md2
	CPI  R30,0
	BREQ _0x2A
;     212 		{
;     213 		cnt_md2--;
	SUBI R30,LOW(1)
	STS  _cnt_md2,R30
;     214 		if(cnt_md2==0) bMD2=0;
	CPI  R30,0
	BRNE _0x2B
	CLT
	BLD  R3,3
;     215 		}
_0x2B:
;     216 
;     217 	}
_0x2A:
_0x29:
;     218 
;     219 if(!(in_word&(1<<BD1)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x80)
	BRNE _0x2C
;     220 	{
;     221 	if(cnt_bd1<10)
	LDS  R26,_cnt_bd1
	CPI  R26,LOW(0xA)
	BRSH _0x2D
;     222 		{
;     223 		cnt_bd1++;
	LDS  R30,_cnt_bd1
	SUBI R30,-LOW(1)
	STS  _cnt_bd1,R30
;     224 		if(cnt_bd1==10) bBD1=1;
	LDS  R26,_cnt_bd1
	CPI  R26,LOW(0xA)
	BRNE _0x2E
	SET
	BLD  R3,4
;     225 		}
_0x2E:
;     226 
;     227 	}
_0x2D:
;     228 else
	RJMP _0x2F
_0x2C:
;     229 	{
;     230 	if(cnt_bd1)
	LDS  R30,_cnt_bd1
	CPI  R30,0
	BREQ _0x30
;     231 		{
;     232 		cnt_bd1--;
	SUBI R30,LOW(1)
	STS  _cnt_bd1,R30
;     233 		if(cnt_bd1==0) bBD1=0;
	CPI  R30,0
	BRNE _0x31
	CLT
	BLD  R3,4
;     234 		}
_0x31:
;     235 
;     236 	}
_0x30:
_0x2F:
;     237 
;     238 if(!(in_word&(1<<BD2)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x10)
	BRNE _0x32
;     239 	{
;     240 	if(cnt_bd2<10)
	LDS  R26,_cnt_bd2
	CPI  R26,LOW(0xA)
	BRSH _0x33
;     241 		{
;     242 		cnt_bd2++;
	LDS  R30,_cnt_bd2
	SUBI R30,-LOW(1)
	STS  _cnt_bd2,R30
;     243 		if(cnt_bd2==10) bBD2=1;
	LDS  R26,_cnt_bd2
	CPI  R26,LOW(0xA)
	BRNE _0x34
	SET
	BLD  R3,5
;     244 		}
_0x34:
;     245 
;     246 	}
_0x33:
;     247 else
	RJMP _0x35
_0x32:
;     248 	{
;     249 	if(cnt_bd2)
	LDS  R30,_cnt_bd2
	CPI  R30,0
	BREQ _0x36
;     250 		{
;     251 		cnt_bd2--;
	SUBI R30,LOW(1)
	STS  _cnt_bd2,R30
;     252 		if(cnt_bd2==0) bBD2=0;
	CPI  R30,0
	BRNE _0x37
	CLT
	BLD  R3,5
;     253 		}
_0x37:
;     254 
;     255 	}
_0x36:
_0x35:
;     256 
;     257 if(!(in_word&(1<<DM)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x2)
	BRNE _0x38
;     258 	{
;     259 	if(cnt_dm<5)
	LDS  R26,_cnt_dm
	CPI  R26,LOW(0x5)
	BRSH _0x39
;     260 		{
;     261 		cnt_dm++;
	LDS  R30,_cnt_dm
	SUBI R30,-LOW(1)
	STS  _cnt_dm,R30
;     262 		if(cnt_dm==5) bDM=1;
	LDS  R26,_cnt_dm
	CPI  R26,LOW(0x5)
	BRNE _0x3A
	SET
	BLD  R3,6
;     263 		}
_0x3A:
;     264 	}
_0x39:
;     265 else
	RJMP _0x3B
_0x38:
;     266 	{
;     267 	if(cnt_dm)
	LDS  R30,_cnt_dm
	CPI  R30,0
	BREQ _0x3C
;     268 		{
;     269 		cnt_dm--;
	SUBI R30,LOW(1)
	STS  _cnt_dm,R30
;     270 		if(cnt_dm==0) bDM=0;
	CPI  R30,0
	BRNE _0x3D
	CLT
	BLD  R3,6
;     271 		}
_0x3D:
;     272 	}
_0x3C:
_0x3B:
;     273 
;     274 if(!(in_word&(1<<START)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x1)
	BRNE _0x3E
;     275 	{
;     276 	if(cnt_start<10)
	LDS  R26,_cnt_start
	CPI  R26,LOW(0xA)
	BRSH _0x3F
;     277 		{
;     278 		cnt_start++;
	LDS  R30,_cnt_start
	SUBI R30,-LOW(1)
	STS  _cnt_start,R30
;     279 		if(cnt_start==10) 
	LDS  R26,_cnt_start
	CPI  R26,LOW(0xA)
	BRNE _0x40
;     280 			{
;     281 			bSTART=1;
	SET
	BLD  R3,7
;     282 			main_loop_cmd==cmdSTART;
	LDS  R26,_main_loop_cmd
	LDI  R30,LOW(1)
	CALL __EQB12
;     283 			}
;     284 		}
_0x40:
;     285 	}
_0x3F:
;     286 else
	RJMP _0x41
_0x3E:
;     287 	{
;     288 	if(cnt_start)
	LDS  R30,_cnt_start
	CPI  R30,0
	BREQ _0x42
;     289 		{
;     290 		cnt_start--;
	SUBI R30,LOW(1)
	STS  _cnt_start,R30
;     291 		if(cnt_start==0) bSTART=0;
	CPI  R30,0
	BRNE _0x43
	CLT
	BLD  R3,7
;     292 		}
_0x43:
;     293 	} 
_0x42:
_0x41:
;     294 
;     295 if(!(in_word&(1<<STOP)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x4)
	BRNE _0x44
;     296 	{
;     297 	if(cnt_stop<10)
	LDS  R26,_cnt_stop
	CPI  R26,LOW(0xA)
	BRSH _0x45
;     298 		{
;     299 		cnt_stop++;
	LDS  R30,_cnt_stop
	SUBI R30,-LOW(1)
	STS  _cnt_stop,R30
;     300 		if(cnt_stop==10) bSTOP=1;
	LDS  R26,_cnt_stop
	CPI  R26,LOW(0xA)
	BRNE _0x46
	SET
	BLD  R4,0
;     301 		}
_0x46:
;     302 	}
_0x45:
;     303 else
	RJMP _0x47
_0x44:
;     304 	{
;     305 	if(cnt_stop)
	LDS  R30,_cnt_stop
	CPI  R30,0
	BREQ _0x48
;     306 		{
;     307 		cnt_stop--;
	SUBI R30,LOW(1)
	STS  _cnt_stop,R30
;     308 		if(cnt_stop==0) bSTOP=0;
	CPI  R30,0
	BRNE _0x49
	CLT
	BLD  R4,0
;     309 		}
_0x49:
;     310 	} 
_0x48:
_0x47:
;     311 } 
	RET
;     312 
;     313 //-----------------------------------------------
;     314 void main_loop_hndl(void)
;     315 {
_main_loop_hndl:
;     316 if(main_loop_cmd==cmdSTART)
	LDS  R26,_main_loop_cmd
	CPI  R26,LOW(0x1)
	BRNE _0x4A
;     317 	{
;     318 	orient_cmd=cmdSTOP;
	CALL SUBOPT_0x1
;     319 	napoln_cmd=cmdSTOP;
;     320 	payka_cmd=cmdSTOP;
;     321 	main_loop_cmd=cmdOFF; 
	STS  _main_loop_cmd,R30
;     322 	
;     323 	if(ee_prog==EE_PROG_ONLY_ORIENT)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x4B
;     324 		{
;     325 		orient_cmd=cmdSTART;
	LDI  R30,LOW(1)
	STS  _orient_cmd,R30
;     326 		}  
;     327 	else if(ee_prog==EE_PROG_ONLY_NAPOLN)
	RJMP _0x4C
_0x4B:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x4D
;     328 		{
;     329 		napoln_cmd=cmdSTART;
	LDI  R30,LOW(1)
	STS  _napoln_cmd,R30
;     330 		}   
;     331 	else if(ee_prog==EE_PROG_ONLY_PAYKA)
	RJMP _0x4E
_0x4D:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x4F
;     332 		{
;     333 		payka_cmd=cmdSTART;
	LDI  R30,LOW(1)
	STS  _payka_cmd,R30
;     334 		}
;     335 	else if((ee_prog==EE_PROG_ONLY_MAIN_LOOP)||(ee_prog==EE_PROG_FULL))
	RJMP _0x50
_0x4F:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ _0x52
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	SBIW R30,0
	BRNE _0x51
_0x52:
;     336 		{
;     337 		main_loop_step=s1;
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2
;     338 		main_loop_cnt_del=20;
;     339 		}						
;     340 
;     341 	}                      
_0x51:
_0x50:
_0x4E:
_0x4C:
;     342 else if(main_loop_cmd==cmdSTOP)
	RJMP _0x54
_0x4A:
	LDS  R26,_main_loop_cmd
	CPI  R26,LOW(0x2)
	BRNE _0x55
;     343 	{
;     344 	orient_cmd=cmdSTOP;
	CALL SUBOPT_0x1
;     345 	napoln_cmd=cmdSTOP;
;     346 	payka_cmd=cmdSTOP;
;     347 	main_loop_step=sOFF;
	STS  _main_loop_step,R30
;     348 	}
;     349 
;     350 if(main_loop_step==sOFF)
_0x55:
_0x54:
	LDS  R30,_main_loop_step
	CPI  R30,0
	BRNE _0x56
;     351 	{
;     352 	bPP1=0;
	CLT
	BLD  R4,1
;     353 	bPP2=0;              
	CLT
	BLD  R4,2
;     354 	}
;     355 else if(main_loop_step==s1)
	RJMP _0x57
_0x56:
	LDS  R26,_main_loop_step
	CPI  R26,LOW(0x1)
	BRNE _0x58
;     356 	{
;     357 	bPP1=1;
	SET
	BLD  R4,1
;     358 	bPP2=0;              
	CLT
	BLD  R4,2
;     359 	main_loop_cnt_del--;
	CALL SUBOPT_0x3
;     360 	if(main_loop_cnt_del==0)
	BRNE _0x59
;     361 		{
;     362 		main_loop_step=s2;
	LDI  R30,LOW(2)
	STS  _main_loop_step,R30
;     363 		}
;     364 	}
_0x59:
;     365 else if(main_loop_step==s2)
	RJMP _0x5A
_0x58:
	LDS  R26,_main_loop_step
	CPI  R26,LOW(0x2)
	BRNE _0x5B
;     366 	{
;     367 	bPP1=1;
	SET
	BLD  R4,1
;     368 	bPP2=1;              
	SET
	BLD  R4,2
;     369 	if(bMD1)
	SBRS R3,2
	RJMP _0x5C
;     370 		{
;     371 		main_loop_step=s3;
	LDI  R30,LOW(3)
	CALL SUBOPT_0x2
;     372 		main_loop_cnt_del=20;
;     373 		}
;     374 	} 
_0x5C:
;     375 else if(main_loop_step==s3)
	RJMP _0x5D
_0x5B:
	LDS  R26,_main_loop_step
	CPI  R26,LOW(0x3)
	BRNE _0x5E
;     376 	{
;     377 	bPP1=0;
	CLT
	BLD  R4,1
;     378 	bPP2=1;              
	SET
	BLD  R4,2
;     379 	main_loop_cnt_del--;
	CALL SUBOPT_0x3
;     380 	if(main_loop_cnt_del==0)
	BRNE _0x5F
;     381 		{
;     382 		if(ee_prog==EE_PROG_ONLY_MAIN_LOOP)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x60
;     383 			{
;     384 			if(ee_loop_mode==elmAUTO)main_loop_cmd=cmdSTART;
	LDI  R26,LOW(_ee_loop_mode)
	LDI  R27,HIGH(_ee_loop_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0x61
	LDI  R30,LOW(1)
	STS  _main_loop_cmd,R30
;     385 			else main_loop_step=sOFF;
	RJMP _0x62
_0x61:
	LDI  R30,LOW(0)
	STS  _main_loop_step,R30
_0x62:
;     386 			}
;     387 		else if(ee_prog==EE_PROG_FULL)
	RJMP _0x63
_0x60:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	SBIW R30,0
	BRNE _0x64
;     388 			{
;     389 			orient_cmd=cmdSTART;
	LDI  R30,LOW(1)
	STS  _orient_cmd,R30
;     390 			napoln_cmd=cmdSTART;
	STS  _napoln_cmd,R30
;     391 			payka_cmd=cmdSTART;
	STS  _payka_cmd,R30
;     392 			main_loop_step=s4;
	LDI  R30,LOW(4)
	STS  _main_loop_step,R30
;     393 			}
;     394 		}
_0x64:
_0x63:
;     395 	}				        
_0x5F:
;     396 else if(main_loop_step==s4)
	RJMP _0x65
_0x5E:
	LDS  R26,_main_loop_step
	CPI  R26,LOW(0x4)
	BRNE _0x66
;     397 	{
;     398 	bPP1=0;
	CLT
	BLD  R4,1
;     399 	bPP2=0;                    
	CLT
	BLD  R4,2
;     400 	if(bORIENT_COMPLETE && bNAPOLN_COMPLETE && bPAYKA_COMPLETE)
	SBRS R5,3
	RJMP _0x68
	SBRS R5,2
	RJMP _0x68
	SBRC R5,1
	RJMP _0x69
_0x68:
	RJMP _0x67
_0x69:
;     401 		{
;     402 		if(ee_loop_mode==elmAUTO)main_loop_cmd=cmdSTART;
	LDI  R26,LOW(_ee_loop_mode)
	LDI  R27,HIGH(_ee_loop_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0x6A
	LDI  R30,LOW(1)
	STS  _main_loop_cmd,R30
;     403 		else main_loop_step=sOFF;
	RJMP _0x6B
_0x6A:
	LDI  R30,LOW(0)
	STS  _main_loop_step,R30
_0x6B:
;     404 		}
;     405 	
;     406 	}	
_0x67:
;     407 	 
;     408 }
_0x66:
_0x65:
_0x5D:
_0x5A:
_0x57:
	RET
;     409 
;     410 //-----------------------------------------------
;     411 void payka_hndl(void)
;     412 {
_payka_hndl:
;     413 if(payka_cmd==cmdSTART)
	LDS  R26,_payka_cmd
	CPI  R26,LOW(0x1)
	BRNE _0x6C
;     414 	{
;     415 	payka_step=s1;
	LDI  R30,LOW(1)
	STS  _payka_step,R30
;     416 	payka_cnt_del=ee_temp2*10;
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	CALL SUBOPT_0x4
;     417 	bPAYKA_COMPLETE=0;
	CLT
	BLD  R5,1
;     418 	payka_cmd=cmdOFF;
	LDI  R30,LOW(0)
	STS  _payka_cmd,R30
;     419 	}                      
;     420 else if(payka_cmd==cmdSTOP)
	RJMP _0x6D
_0x6C:
	LDS  R26,_payka_cmd
	CPI  R26,LOW(0x2)
	BRNE _0x6E
;     421 	{
;     422 	payka_step=sOFF;
	LDI  R30,LOW(0)
	STS  _payka_step,R30
;     423 	payka_cmd=cmdOFF;
	STS  _payka_cmd,R30
;     424 	} 
;     425 		
;     426 if(payka_step==sOFF)
_0x6E:
_0x6D:
	LDS  R30,_payka_step
	CPI  R30,0
	BRNE _0x6F
;     427 	{
;     428 	bPP6=0;
	CLT
	BLD  R4,6
;     429 	bPP7=0;
	CLT
	BLD  R4,7
;     430 	}      
;     431 else if(payka_step==s1)
	RJMP _0x70
_0x6F:
	LDS  R26,_payka_step
	CPI  R26,LOW(0x1)
	BRNE _0x71
;     432 	{
;     433 	bPP6=1;
	SET
	BLD  R4,6
;     434 	bPP7=0;
	CLT
	BLD  R4,7
;     435 	payka_cnt_del--;
	CALL SUBOPT_0x5
;     436 	if(payka_cnt_del==0)
	BRNE _0x72
;     437 		{
;     438 		payka_step=s2;
	LDI  R30,LOW(2)
	STS  _payka_step,R30
;     439 		payka_cnt_del=ee_temp3*10;
	LDI  R26,LOW(_ee_temp3)
	LDI  R27,HIGH(_ee_temp3)
	CALL __EEPROMRDW
	CALL SUBOPT_0x4
;     440 		}                	
;     441 	}	
_0x72:
;     442 else if(payka_step==s2)
	RJMP _0x73
_0x71:
	LDS  R26,_payka_step
	CPI  R26,LOW(0x2)
	BRNE _0x74
;     443 	{
;     444 	bPP6=0;
	CLT
	BLD  R4,6
;     445 	bPP7=0;
	CLT
	BLD  R4,7
;     446 	payka_cnt_del--;
	CALL SUBOPT_0x5
;     447 	if(payka_cnt_del==0)
	BRNE _0x75
;     448 		{
;     449 		payka_step=s3;
	LDI  R30,LOW(3)
	STS  _payka_step,R30
;     450 		payka_cnt_del=ee_temp4*10;
	LDI  R26,LOW(_ee_temp4)
	LDI  R27,HIGH(_ee_temp4)
	CALL __EEPROMRDW
	CALL SUBOPT_0x4
;     451 		}                	
;     452 	}		  
_0x75:
;     453 else if(payka_step==s3)
	RJMP _0x76
_0x74:
	LDS  R26,_payka_step
	CPI  R26,LOW(0x3)
	BRNE _0x77
;     454 	{
;     455 	bPP6=0;
	CLT
	BLD  R4,6
;     456 	bPP7=1;
	SET
	BLD  R4,7
;     457 	payka_cnt_del--;
	CALL SUBOPT_0x5
;     458 	if(payka_cnt_del==0)
	BRNE _0x78
;     459 		{
;     460 		payka_step=sOFF;
	LDI  R30,LOW(0)
	STS  _payka_step,R30
;     461 		bPAYKA_COMPLETE=1;
	SET
	BLD  R5,1
;     462 		}                	
;     463 	}			
_0x78:
;     464 }
_0x77:
_0x76:
_0x73:
_0x70:
	RET
;     465 
;     466 //-----------------------------------------------
;     467 void napoln_hndl(void)
;     468 {
_napoln_hndl:
;     469 if(napoln_cmd==cmdSTART)
	LDS  R26,_napoln_cmd
	CPI  R26,LOW(0x1)
	BRNE _0x79
;     470 	{
;     471 	napoln_step=s1;
	LDI  R30,LOW(1)
	STS  _napoln_step,R30
;     472 	napoln_cnt_del=0;
	LDI  R30,0
	STS  _napoln_cnt_del,R30
	STS  _napoln_cnt_del+1,R30
;     473 	bNAPOLN_COMPLETE=0;
	CLT
	BLD  R5,2
;     474 	
;     475 	napoln_cmd=cmdOFF;
	LDI  R30,LOW(0)
	STS  _napoln_cmd,R30
;     476 	}                      
;     477 else if(napoln_cmd==cmdSTOP)
	RJMP _0x7A
_0x79:
	LDS  R26,_napoln_cmd
	CPI  R26,LOW(0x2)
	BRNE _0x7B
;     478 	{
;     479 	napoln_step=sOFF;
	LDI  R30,LOW(0)
	STS  _napoln_step,R30
;     480 	napoln_cmd=cmdOFF;
	STS  _napoln_cmd,R30
;     481 	} 
;     482 		
;     483 if(napoln_step==sOFF)
_0x7B:
_0x7A:
	LDS  R30,_napoln_step
	CPI  R30,0
	BRNE _0x7C
;     484 	{
;     485 	bPP4=0;
	CLT
	BLD  R4,4
;     486 	bPP5=0;
	CLT
	BLD  R4,5
;     487 	}      
;     488 else if(napoln_step==s1)
	RJMP _0x7D
_0x7C:
	LDS  R26,_napoln_step
	CPI  R26,LOW(0x1)
	BRNE _0x7E
;     489 	{
;     490 	bPP4=0;
	CLT
	BLD  R4,4
;     491 	bPP5=0;
	CLT
	BLD  R4,5
;     492 	if(bBD2)
	SBRS R3,5
	RJMP _0x7F
;     493 		{
;     494 		napoln_step=s2;
	LDI  R30,LOW(2)
	STS  _napoln_step,R30
;     495 		napoln_cnt_del=ee_temp1*10;
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	STS  _napoln_cnt_del,R30
	STS  _napoln_cnt_del+1,R31
;     496 		}
;     497 	}	
_0x7F:
;     498 else if(napoln_step==s2)
	RJMP _0x80
_0x7E:
	LDS  R26,_napoln_step
	CPI  R26,LOW(0x2)
	BRNE _0x81
;     499 	{
;     500 	bPP4=1;
	SET
	BLD  R4,4
;     501 	bPP5=0;
	CLT
	BLD  R4,5
;     502 	napoln_cnt_del--;
	LDS  R30,_napoln_cnt_del
	LDS  R31,_napoln_cnt_del+1
	SBIW R30,1
	STS  _napoln_cnt_del,R30
	STS  _napoln_cnt_del+1,R31
;     503 	if(napoln_cnt_del==0)
	SBIW R30,0
	BRNE _0x82
;     504 		{
;     505 		napoln_step=s3;
	LDI  R30,LOW(3)
	STS  _napoln_step,R30
;     506 		}                	
;     507 	}		  
_0x82:
;     508 else if(napoln_step==s3)
	RJMP _0x83
_0x81:
	LDS  R26,_napoln_step
	CPI  R26,LOW(0x3)
	BRNE _0x84
;     509 	{
;     510 	bPP4=1;
	SET
	BLD  R4,4
;     511 	bPP5=1;
	SET
	BLD  R4,5
;     512 	//napoln_cnt_del--;
;     513 	if(bMD2)
	SBRS R3,3
	RJMP _0x85
;     514 		{
;     515 		napoln_step=sOFF;
	LDI  R30,LOW(0)
	STS  _napoln_step,R30
;     516 		bNAPOLN_COMPLETE=1;
	SET
	BLD  R5,2
;     517 		}                	
;     518 	}			
_0x85:
;     519 }
_0x84:
_0x83:
_0x80:
_0x7D:
	RET
;     520 
;     521 //-----------------------------------------------
;     522 void orient_hndl(void)
;     523 {
_orient_hndl:
;     524 if(orient_cmd==cmdSTART)
	LDS  R26,_orient_cmd
	CPI  R26,LOW(0x1)
	BRNE _0x86
;     525 	{
;     526 	orient_step=s1;
	LDI  R30,LOW(1)
	STS  _orient_step,R30
;     527 	orient_cnt_del=0;
	LDI  R30,0
	STS  _orient_cnt_del,R30
	STS  _orient_cnt_del+1,R30
;     528 	bORIENT_COMPLETE=0;
	CLT
	BLD  R5,3
;     529 	
;     530 	orient_cmd=cmdOFF;
	LDI  R30,LOW(0)
	STS  _orient_cmd,R30
;     531 	}                      
;     532 else if(orient_cmd==cmdSTOP)
	RJMP _0x87
_0x86:
	LDS  R26,_orient_cmd
	CPI  R26,LOW(0x2)
	BRNE _0x88
;     533 	{
;     534 	orient_step=sOFF;
	LDI  R30,LOW(0)
	STS  _orient_step,R30
;     535 	orient_cmd=cmdOFF;
	STS  _orient_cmd,R30
;     536 	} 
;     537 		
;     538 if(orient_step==sOFF)
_0x88:
_0x87:
	LDS  R30,_orient_step
	CPI  R30,0
	BRNE _0x89
;     539 	{
;     540 	bPP3=0;
	CLT
	BLD  R4,3
;     541 	} 
;     542 	
;     543 else if(orient_step==s1)
	RJMP _0x8A
_0x89:
	LDS  R26,_orient_step
	CPI  R26,LOW(0x1)
	BRNE _0x8B
;     544 	{
;     545 	bPP3=0;
	CLT
	BLD  R4,3
;     546 	if(bBD1)
	SBRS R3,4
	RJMP _0x8C
;     547 		{
;     548 		orient_step=s2;
	LDI  R30,LOW(2)
	STS  _orient_step,R30
;     549 		}
;     550 	}	
_0x8C:
;     551 		     
;     552 else if(orient_step==s2)
	RJMP _0x8D
_0x8B:
	LDS  R26,_orient_step
	CPI  R26,LOW(0x2)
	BRNE _0x8E
;     553 	{
;     554 	bPP3=1;
	SET
	BLD  R4,3
;     555 	if(!bDM)
	SBRC R3,6
	RJMP _0x8F
;     556 		{
;     557 		orient_step=s3;
	LDI  R30,LOW(3)
	STS  _orient_step,R30
;     558 		}
;     559 	}	
_0x8F:
;     560 else if(orient_step==s3)
	RJMP _0x90
_0x8E:
	LDS  R26,_orient_step
	CPI  R26,LOW(0x3)
	BRNE _0x91
;     561 	{
;     562 	bPP3=1;
	SET
	BLD  R4,3
;     563 	if(bDM)
	SBRS R3,6
	RJMP _0x92
;     564 		{
;     565 		orient_step=sOFF;
	LDI  R30,LOW(0)
	STS  _orient_step,R30
;     566 		bORIENT_COMPLETE=1;
	SET
	BLD  R5,3
;     567 		}               	
;     568 	}		  
_0x92:
;     569 }
_0x91:
_0x90:
_0x8D:
_0x8A:
	RET
;     570 
;     571 //-----------------------------------------------
;     572 void out_drv(void)
;     573 {
_out_drv:
;     574 char temp=0;
;     575 DDRB=0xFF;
	ST   -Y,R16
;	temp -> R16
	LDI  R16,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     576 
;     577 if(bPP1) temp|=(1<<PP1);
	SBRS R4,1
	RJMP _0x93
	ORI  R16,LOW(64)
;     578 if(bPP2) temp|=(1<<PP2);
_0x93:
	SBRS R4,2
	RJMP _0x94
	ORI  R16,LOW(128)
;     579 if(bPP3) temp|=(1<<PP3);
_0x94:
	SBRS R4,3
	RJMP _0x95
	ORI  R16,LOW(32)
;     580 if(bPP4) temp|=(1<<PP4);
_0x95:
	SBRS R4,4
	RJMP _0x96
	ORI  R16,LOW(16)
;     581 if(bPP5) temp|=(1<<PP5);
_0x96:
	SBRS R4,5
	RJMP _0x97
	ORI  R16,LOW(8)
;     582 if(bPP6) temp|=(1<<PP6);
_0x97:
	SBRS R4,6
	RJMP _0x98
	ORI  R16,LOW(4)
;     583 if(bPP7) temp|=(1<<PP7);
_0x98:
	SBRS R4,7
	RJMP _0x99
	ORI  R16,LOW(2)
;     584 
;     585 PORTB=~temp;
_0x99:
	CALL SUBOPT_0x6
;     586 //PORTB=0x55;
;     587 }
	RJMP _0x18A
;     588 
;     589 //-----------------------------------------------
;     590 void step_contr(void)
;     591 {
_step_contr:
;     592 char temp=0;
;     593 DDRB=0xFF;
	ST   -Y,R16
;	temp -> R16
	LDI  R16,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     594 
;     595 if(step==sOFF)goto step_contr_end;
	TST  R13
	BRNE _0x9A
	RJMP _0x9B
;     596 
;     597 else if(prog==p1)
_0x9A:
	LDI  R30,LOW(1)
	CP   R30,R12
	BREQ PC+3
	JMP _0x9D
;     598 	{
;     599 	if(step==s1)    //жесть
	CP   R30,R13
	BRNE _0x9E
;     600 		{
;     601 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     602           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x9B
;     603 
;     604 			//if(ee_vacuum_mode==evmOFF)
;     605 				{
;     606 				//goto lbl_0001;
;     607 				}
;     608 			//else step=s2;
;     609 		}
;     610 
;     611 	else if(step==s2)
	RJMP _0xA0
_0x9E:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0xA1
;     612 		{
;     613 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;     614  //         if(!bVR)goto step_contr_end;
;     615 lbl_0001:
;     616 
;     617           step=s100;
	CALL SUBOPT_0x7
;     618 		cnt_del=40;
;     619           }
;     620 	else if(step==s100)
	RJMP _0xA3
_0xA1:
	LDI  R30,LOW(19)
	CP   R30,R13
	BRNE _0xA4
;     621 		{
;     622 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     623           cnt_del--;
	CALL SUBOPT_0x8
;     624           if(cnt_del==0)
	BRNE _0xA5
;     625 			{
;     626           	step=s3;
	CALL SUBOPT_0x9
;     627           	cnt_del=50;
;     628 			}
;     629 		}
_0xA5:
;     630 
;     631 	else if(step==s3)
	RJMP _0xA6
_0xA4:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0xA7
;     632 		{
;     633 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     634           cnt_del--;
	CALL SUBOPT_0x8
;     635           if(cnt_del==0)
	BRNE _0xA8
;     636 			{
;     637           	step=s4;
	LDI  R30,LOW(4)
	MOV  R13,R30
;     638 			}
;     639 		}
_0xA8:
;     640 	else if(step==s4)
	RJMP _0xA9
_0xA7:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0xAA
;     641 		{
;     642 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5);
	ORI  R16,LOW(248)
;     643           if(!bMD2)goto step_contr_end;
	SBRS R3,3
	RJMP _0x9B
;     644           step=s5;
	CALL SUBOPT_0xA
;     645           cnt_del=20;
;     646 		}
;     647 	else if(step==s5)
	RJMP _0xAC
_0xAA:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0xAD
;     648 		{
;     649 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     650           cnt_del--;
	CALL SUBOPT_0x8
;     651           if(cnt_del==0)
	BRNE _0xAE
;     652 			{
;     653           	step=s6;
	LDI  R30,LOW(6)
	MOV  R13,R30
;     654 			}
;     655           }
_0xAE:
;     656 	else if(step==s6)
	RJMP _0xAF
_0xAD:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0xB0
;     657 		{
;     658 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP7);
	ORI  R16,LOW(242)
;     659  //         if(!bMD3)goto step_contr_end;
;     660           step=s7;
	CALL SUBOPT_0xB
;     661           cnt_del=20;
;     662 		}
;     663 
;     664 	else if(step==s7)
	RJMP _0xB1
_0xB0:
	LDI  R30,LOW(7)
	CP   R30,R13
	BRNE _0xB2
;     665 		{
;     666 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     667           cnt_del--;
	CALL SUBOPT_0x8
;     668           if(cnt_del==0)
	BRNE _0xB3
;     669 			{
;     670           	step=s8;
	LDI  R30,LOW(8)
	MOV  R13,R30
;     671           	//cnt_del=ee_delay[prog,0]*10U;;
;     672 			}
;     673           }
_0xB3:
;     674 	else if(step==s8)
	RJMP _0xB4
_0xB2:
	LDI  R30,LOW(8)
	CP   R30,R13
	BRNE _0xB5
;     675 		{
;     676 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;     677           cnt_del--;
	CALL SUBOPT_0x8
;     678           if(cnt_del==0)
	BRNE _0xB6
;     679 			{
;     680           	step=s9;
	LDI  R30,LOW(9)
	CALL SUBOPT_0xC
;     681           	cnt_del=20;
;     682 			}
;     683           }
_0xB6:
;     684 	else if(step==s9)
	RJMP _0xB7
_0xB5:
	LDI  R30,LOW(9)
	CP   R30,R13
	BRNE _0xB8
;     685 		{
;     686 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     687           cnt_del--;
	CALL SUBOPT_0x8
;     688           if(cnt_del==0)
	BRNE _0xB9
;     689 			{
;     690           	step=sOFF;
	CLR  R13
;     691           	}
;     692           }
_0xB9:
;     693 	}
_0xB8:
_0xB7:
_0xB4:
_0xB1:
_0xAF:
_0xAC:
_0xA9:
_0xA6:
_0xA3:
_0xA0:
;     694 
;     695 else if(prog==p2)  //ско
	RJMP _0xBA
_0x9D:
	LDI  R30,LOW(2)
	CP   R30,R12
	BREQ PC+3
	JMP _0xBB
;     696 	{
;     697 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0xBC
;     698 		{
;     699 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     700           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x9B
;     701 
;     702 		/*	if(ee_vacuum_mode==evmOFF)
;     703 				{
;     704 				goto lbl_0002;
;     705 				}
;     706 			else step=s2; */
;     707 
;     708           //step=s2;
;     709 		}
;     710 
;     711 	else if(step==s2)
	RJMP _0xBE
_0xBC:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0xBF
;     712 		{
;     713 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;     714  //         if(!bVR)goto step_contr_end;
;     715 
;     716 lbl_0002:
;     717           step=s100;
	CALL SUBOPT_0x7
;     718 		cnt_del=40;
;     719           }
;     720 	else if(step==s100)
	RJMP _0xC1
_0xBF:
	LDI  R30,LOW(19)
	CP   R30,R13
	BRNE _0xC2
;     721 		{
;     722 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     723           cnt_del--;
	CALL SUBOPT_0x8
;     724           if(cnt_del==0)
	BRNE _0xC3
;     725 			{
;     726           	step=s3;
	CALL SUBOPT_0x9
;     727           	cnt_del=50;
;     728 			}
;     729 		}
_0xC3:
;     730 	else if(step==s3)
	RJMP _0xC4
_0xC2:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0xC5
;     731 		{
;     732 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     733           cnt_del--;
	CALL SUBOPT_0x8
;     734           if(cnt_del==0)
	BRNE _0xC6
;     735 			{
;     736           	step=s4;
	LDI  R30,LOW(4)
	MOV  R13,R30
;     737 			}
;     738 		}
_0xC6:
;     739 	else if(step==s4)
	RJMP _0xC7
_0xC5:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0xC8
;     740 		{
;     741 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5);
	ORI  R16,LOW(248)
;     742           if(!bMD2)goto step_contr_end;
	SBRS R3,3
	RJMP _0x9B
;     743           step=s5;
	CALL SUBOPT_0xA
;     744           cnt_del=20;
;     745 		}
;     746 	else if(step==s5)
	RJMP _0xCA
_0xC8:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0xCB
;     747 		{
;     748 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     749           cnt_del--;
	CALL SUBOPT_0x8
;     750           if(cnt_del==0)
	BRNE _0xCC
;     751 			{
;     752           	step=s6;
	LDI  R30,LOW(6)
	MOV  R13,R30
;     753           	//cnt_del=ee_delay[prog,0]*10U;
;     754 			}
;     755           }
_0xCC:
;     756 	else if(step==s6)
	RJMP _0xCD
_0xCB:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0xCE
;     757 		{
;     758 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;     759           cnt_del--;
	CALL SUBOPT_0x8
;     760           if(cnt_del==0)
	BRNE _0xCF
;     761 			{
;     762           	step=s7;
	CALL SUBOPT_0xB
;     763           	cnt_del=20;
;     764 			}
;     765           }
_0xCF:
;     766 	else if(step==s7)
	RJMP _0xD0
_0xCE:
	LDI  R30,LOW(7)
	CP   R30,R13
	BRNE _0xD1
;     767 		{
;     768 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     769           cnt_del--;
	CALL SUBOPT_0x8
;     770           if(cnt_del==0)
	BRNE _0xD2
;     771 			{
;     772           	step=sOFF;
	CLR  R13
;     773           	}
;     774           }
_0xD2:
;     775 	}
_0xD1:
_0xD0:
_0xCD:
_0xCA:
_0xC7:
_0xC4:
_0xC1:
_0xBE:
;     776 
;     777 else if(prog==p3)   //твист
	RJMP _0xD3
_0xBB:
	LDI  R30,LOW(3)
	CP   R30,R12
	BRNE _0xD4
;     778 	{
;     779 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0xD5
;     780 		{
;     781 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     782           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x9B
;     783 
;     784 		/*	if(ee_vacuum_mode==evmOFF)
;     785 				{
;     786 				goto lbl_0003;
;     787 				}
;     788 			else step=s2;*/
;     789 
;     790           //step=s2;
;     791 		}
;     792 
;     793 	else if(step==s2)
	RJMP _0xD7
_0xD5:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0xD8
;     794 		{
;     795 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;     796  //         if(!bVR)goto step_contr_end;
;     797 lbl_0003:
;     798           cnt_del=50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;     799 		step=s3;
	LDI  R30,LOW(3)
	MOV  R13,R30
;     800 		}
;     801 
;     802 
;     803 	else	if(step==s3)
	RJMP _0xDA
_0xD8:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0xDB
;     804 		{
;     805 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     806 		cnt_del--;
	CALL SUBOPT_0x8
;     807 		if(cnt_del==0)
	BRNE _0xDC
;     808 			{
;     809 			//cnt_del=ee_delay[prog,0]*10U;
;     810 			step=s4;
	LDI  R30,LOW(4)
	MOV  R13,R30
;     811 			}
;     812           }
_0xDC:
;     813 	else if(step==s4)
	RJMP _0xDD
_0xDB:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0xDE
;     814 		{
;     815 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
	ORI  R16,LOW(250)
;     816 		cnt_del--;
	CALL SUBOPT_0x8
;     817  		if(cnt_del==0)
	BRNE _0xDF
;     818 			{
;     819 		    //	cnt_del=ee_delay[prog,1]*10U;
;     820 			step=s5;
	LDI  R30,LOW(5)
	MOV  R13,R30
;     821 			}
;     822 		}
_0xDF:
;     823 
;     824 	else if(step==s5)
	RJMP _0xE0
_0xDE:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0xE1
;     825 		{
;     826 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
	ORI  R16,LOW(202)
;     827 		cnt_del--;
	CALL SUBOPT_0x8
;     828 		if(cnt_del==0)
	BRNE _0xE2
;     829 			{
;     830 			step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0xC
;     831 			cnt_del=20;
;     832 			}
;     833 		}
_0xE2:
;     834 
;     835 	else if(step==s6)
	RJMP _0xE3
_0xE1:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0xE4
;     836 		{
;     837 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     838   		cnt_del--;
	CALL SUBOPT_0x8
;     839 		if(cnt_del==0)
	BRNE _0xE5
;     840 			{
;     841 			step=sOFF;
	CLR  R13
;     842 			}
;     843 		}
_0xE5:
;     844 
;     845 	}
_0xE4:
_0xE3:
_0xE0:
_0xDD:
_0xDA:
_0xD7:
;     846 
;     847 else if(prog==p4)      //замок
	RJMP _0xE6
_0xD4:
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0xE7
;     848 	{
;     849 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0xE8
;     850 		{
;     851 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     852           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x9B
;     853 
;     854 		 /*	if(ee_vacuum_mode==evmOFF)
;     855 				{
;     856 				goto lbl_0004;
;     857 				}
;     858 			else step=s2;*/
;     859           //step=s2;
;     860 		}
;     861 
;     862 	else if(step==s2)
	RJMP _0xEA
_0xE8:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0xEB
;     863 		{
;     864 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;     865  //         if(!bVR)goto step_contr_end;
;     866 lbl_0004:
;     867           step=s3;
	CALL SUBOPT_0x9
;     868 		cnt_del=50;
;     869           }
;     870 
;     871 	else if(step==s3)
	RJMP _0xED
_0xEB:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0xEE
;     872 		{
;     873 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     874           cnt_del--;
	CALL SUBOPT_0x8
;     875           if(cnt_del==0)
	BRNE _0xEF
;     876 			{
;     877           	step=s4;
	LDI  R30,LOW(4)
	MOV  R13,R30
;     878 			//cnt_del=ee_delay[prog,0]*10U;
;     879 			}
;     880           }
_0xEF:
;     881 
;     882    	else if(step==s4)
	RJMP _0xF0
_0xEE:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0xF1
;     883 		{
;     884 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;     885 		cnt_del--;
	CALL SUBOPT_0x8
;     886 		if(cnt_del==0)
	BRNE _0xF2
;     887 			{
;     888 			step=s5;
	LDI  R30,LOW(5)
	MOV  R13,R30
;     889 			cnt_del=30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;     890 			}
;     891 		}
_0xF2:
;     892 
;     893 	else if(step==s5)
	RJMP _0xF3
_0xF1:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0xF4
;     894 		{
;     895 		temp|=(1<<PP1)|(1<<PP4);
	ORI  R16,LOW(80)
;     896 		cnt_del--;
	CALL SUBOPT_0x8
;     897 		if(cnt_del==0)
	BRNE _0xF5
;     898 			{
;     899 			step=s6;
	LDI  R30,LOW(6)
	MOV  R13,R30
;     900 			//cnt_del=ee_delay[prog,1]*10U;
;     901 			}
;     902 		}
_0xF5:
;     903 
;     904 	else if(step==s6)
	RJMP _0xF6
_0xF4:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0xF7
;     905 		{
;     906 		temp|=(1<<PP4);
	ORI  R16,LOW(16)
;     907 		cnt_del--;
	CALL SUBOPT_0x8
;     908 		if(cnt_del==0)
	BRNE _0xF8
;     909 			{
;     910 			step=sOFF;
	CLR  R13
;     911 			}
;     912 		}
_0xF8:
;     913 
;     914 	}
_0xF7:
_0xF6:
_0xF3:
_0xF0:
_0xED:
_0xEA:
;     915 	
;     916 step_contr_end:
_0xE7:
_0xE6:
_0xD3:
_0xBA:
_0x9B:
;     917 
;     918 //if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;     919 
;     920 PORTB=~temp;
	CALL SUBOPT_0x6
;     921 //PORTB=0x55;
;     922 }
_0x18A:
	LD   R16,Y+
	RET
;     923 
;     924 
;     925 //-----------------------------------------------
;     926 void bin2bcd_int(unsigned int in)
;     927 {
_bin2bcd_int:
;     928 char i;
;     929 for(i=3;i>0;i--)
	ST   -Y,R16
;	in -> Y+1
;	i -> R16
	LDI  R16,LOW(3)
_0xFA:
	LDI  R30,LOW(0)
	CP   R30,R16
	BRSH _0xFB
;     930 	{
;     931 	dig[i]=in%10;
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
;     932 	in/=10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
;     933 	}   
	SUBI R16,1
	RJMP _0xFA
_0xFB:
;     934 }
	LDD  R16,Y+0
	RJMP _0x189
;     935 
;     936 //-----------------------------------------------
;     937 void bcd2ind(char s)
;     938 {
_bcd2ind:
;     939 char i;
;     940 bZ=1;
	ST   -Y,R16
;	s -> Y+1
;	i -> R16
	SET
	BLD  R2,3
;     941 for (i=0;i<5;i++)
	LDI  R16,LOW(0)
_0xFD:
	CPI  R16,5
	BRLO PC+3
	JMP _0xFE
;     942 	{
;     943 	if(bZ&&(!dig[i-1])&&(i<4))
	SBRS R2,3
	RJMP _0x100
	CALL SUBOPT_0xD
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	CPI  R30,0
	BRNE _0x100
	CPI  R16,4
	BRLO _0x101
_0x100:
	RJMP _0xFF
_0x101:
;     944 		{
;     945 		if((4-i)>s)
	LDI  R30,LOW(4)
	SUB  R30,R16
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
	BRSH _0x102
;     946 			{
;     947 			ind_out[i-1]=DIGISYM[10];
	CALL SUBOPT_0xD
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	POP  R26
	POP  R27
	RJMP _0x18B
;     948 			}
;     949 		else ind_out[i-1]=DIGISYM[0];	
_0x102:
	CALL SUBOPT_0xD
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	LPM  R30,Z
	POP  R26
	POP  R27
_0x18B:
	ST   X,R30
;     950 		}
;     951 	else
	RJMP _0x104
_0xFF:
;     952 		{
;     953 		ind_out[i-1]=DIGISYM[dig[i-1]];
	CALL SUBOPT_0xD
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xD
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
;     954 		bZ=0;
	CLT
	BLD  R2,3
;     955 		}                   
_0x104:
;     956 
;     957 	if(s)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x105
;     958 		{
;     959 		ind_out[3-s]&=0b01111111;
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
;     960 		}	
;     961  
;     962 	}
_0x105:
	SUBI R16,-1
	RJMP _0xFD
_0xFE:
;     963 }            
	LDD  R16,Y+0
	ADIW R28,2
	RET
;     964 //-----------------------------------------------
;     965 void int2ind(unsigned int in,char s)
;     966 {
_int2ind:
;     967 bin2bcd_int(in);
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _bin2bcd_int
;     968 bcd2ind(s);
	LD   R30,Y
	ST   -Y,R30
	CALL _bcd2ind
;     969 
;     970 } 
_0x189:
	ADIW R28,3
	RET
;     971 
;     972 //-----------------------------------------------
;     973 void ind_hndl(void)
;     974 {
_ind_hndl:
;     975 if(ind==iMn)
	TST  R14
	BRNE _0x106
;     976 	{
;     977 	if(ee_prog==EE_PROG_FULL)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	SBIW R30,0
	BREQ _0x108
;     978 		{
;     979 		}
;     980 	else if(ee_prog==EE_PROG_ONLY_ORIENT)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x109
;     981 		{
;     982 		int2ind(orient_step,0);
	LDS  R30,_orient_step
	CALL SUBOPT_0xE
;     983 		}
;     984 	else if(ee_prog==EE_PROG_ONLY_NAPOLN)
	RJMP _0x10A
_0x109:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x10B
;     985 		{
;     986 		int2ind(napoln_step,0);                              
	LDS  R30,_napoln_step
	CALL SUBOPT_0xE
;     987 		}			                
;     988 	else if(ee_prog==EE_PROG_ONLY_PAYKA)
	RJMP _0x10C
_0x10B:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x10D
;     989 		{
;     990 		int2ind(payka_step,0);
	LDS  R30,_payka_step
	CALL SUBOPT_0xE
;     991 		}
;     992 	else if(ee_prog==EE_PROG_ONLY_MAIN_LOOP)
	RJMP _0x10E
_0x10D:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x10F
;     993 		{
;     994 		int2ind(main_loop_step,0);
	LDS  R30,_main_loop_step
	CALL SUBOPT_0xE
;     995 		}			
;     996 	
;     997 	//int2ind(bDM,0);
;     998 	//int2ind(in_word,0);
;     999 	//int2ind(cnt_dm,0);
;    1000 	
;    1001 	//int2ind(bDM,0);
;    1002 	//int2ind(ee_delay[prog,sub_ind],1);  
;    1003 	//ind_out[0]=0xff;//DIGISYM[0];
;    1004 	//ind_out[1]=0xff;//DIGISYM[1];
;    1005 	//ind_out[2]=DIGISYM[2];//0xff;
;    1006 	//ind_out[0]=DIGISYM[7]; 
;    1007 
;    1008 	//ind_out[0]=DIGISYM[sub_ind+1];
;    1009 	}
_0x10F:
_0x10E:
_0x10C:
_0x10A:
_0x108:
;    1010 else if(ind==iSet)
	RJMP _0x110
_0x106:
	LDI  R30,LOW(2)
	CP   R30,R14
	BREQ PC+3
	JMP _0x111
;    1011 	{
;    1012      if(sub_ind==0)int2ind(ee_prog,0);
	LDS  R30,_sub_ind
	CPI  R30,0
	BRNE _0x112
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _int2ind
;    1013 	else if(sub_ind==1)int2ind(ee_temp1,1);
	RJMP _0x113
_0x112:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x1)
	BRNE _0x114
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	CALL SUBOPT_0xF
;    1014 	else if(sub_ind==2)int2ind(ee_temp2,1);
	RJMP _0x115
_0x114:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x2)
	BRNE _0x116
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	CALL SUBOPT_0xF
;    1015 	else if(sub_ind==3)int2ind(ee_temp3,1);
	RJMP _0x117
_0x116:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x3)
	BRNE _0x118
	LDI  R26,LOW(_ee_temp3)
	LDI  R27,HIGH(_ee_temp3)
	CALL __EEPROMRDW
	CALL SUBOPT_0xF
;    1016 	else if(sub_ind==4)int2ind(ee_temp4,1);
	RJMP _0x119
_0x118:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x4)
	BRNE _0x11A
	LDI  R26,LOW(_ee_temp4)
	LDI  R27,HIGH(_ee_temp4)
	CALL __EEPROMRDW
	CALL SUBOPT_0xF
;    1017 		
;    1018 	if(bFL5)ind_out[0]=DIGISYM[sub_ind+1];
_0x11A:
_0x119:
_0x117:
_0x115:
_0x113:
	SBRS R3,0
	RJMP _0x11B
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	PUSH R31
	PUSH R30
	LDS  R30,_sub_ind
	SUBI R30,-LOW(1)
	POP  R26
	POP  R27
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RJMP _0x18C
;    1019 	else    ind_out[0]=DIGISYM[10];
_0x11B:
	__POINTW1FN _DIGISYM,10
_0x18C:
	LPM  R30,Z
	STS  _ind_out,R30
;    1020 	}
;    1021 }
_0x111:
_0x110:
	RET
;    1022 
;    1023 //-----------------------------------------------
;    1024 void led_hndl(void)
;    1025 {
_led_hndl:
;    1026 ind_out[4]=DIGISYM[10]; 
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	__PUTB1MN _ind_out,4
;    1027 
;    1028 ind_out[4]&=~(1<<LED_POW_ON); 
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xDF
	POP  R26
	POP  R27
	ST   X,R30
;    1029 
;    1030 if(step!=sOFF)
	TST  R13
	BREQ _0x11D
;    1031 	{
;    1032 	ind_out[4]&=~(1<<LED_WRK);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xBF
	POP  R26
	POP  R27
	RJMP _0x18D
;    1033 	}
;    1034 else ind_out[4]|=(1<<LED_WRK);
_0x11D:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x40
	POP  R26
	POP  R27
_0x18D:
	ST   X,R30
;    1035 
;    1036 
;    1037 if(step==sOFF)
	TST  R13
	BRNE _0x11F
;    1038 	{
;    1039  	if(bERR)
	SBRS R3,1
	RJMP _0x120
;    1040 		{
;    1041 		ind_out[4]&=~(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFE
	POP  R26
	POP  R27
	RJMP _0x18E
;    1042 		}
;    1043 	else
_0x120:
;    1044 		{
;    1045 		ind_out[4]|=(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
_0x18E:
	ST   X,R30
;    1046 		}
;    1047      }
;    1048 else ind_out[4]|=(1<<LED_ERROR);
	RJMP _0x122
_0x11F:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
	ST   X,R30
_0x122:
;    1049 
;    1050 /* 	if(bMD1)
;    1051 		{
;    1052 		ind_out[4]&=~(1<<LED_ERROR);
;    1053 		}
;    1054 	else
;    1055 		{
;    1056 		ind_out[4]|=(1<<LED_ERROR);
;    1057 		} */
;    1058 
;    1059 //if(bERR)ind_out[4]&=~(1<<LED_ERROR);
;    1060 if(ee_loop_mode==elmAUTO)ind_out[4]&=~(1<<LED_LOOP_AUTO);
	LDI  R26,LOW(_ee_loop_mode)
	LDI  R27,HIGH(_ee_loop_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0x123
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0x7F
	POP  R26
	POP  R27
	RJMP _0x18F
;    1061 else ind_out[4]|=(1<<LED_LOOP_AUTO);
_0x123:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x80
	POP  R26
	POP  R27
_0x18F:
	ST   X,R30
;    1062 
;    1063 /*if(prog==p1) ind_out[4]&=~(1<<LED_PROG1);
;    1064 else if(prog==p2) ind_out[4]&=~(1<<LED_PROG2);
;    1065 else if(prog==p3) ind_out[4]&=~(1<<LED_PROG3);
;    1066 else if(prog==p4) ind_out[4]&=~(1<<LED_PROG4); */
;    1067 
;    1068 /*if(ind==iPr_sel)
;    1069 	{
;    1070 	if(bFL5)ind_out[4]|=(1<<LED_PROG1)|(1<<LED_PROG2)|(1<<LED_PROG3)|(1<<LED_PROG4);
;    1071 	}*/ 
;    1072 	 
;    1073 /*if(ind==iVr)
;    1074 	{
;    1075 	if(bFL5)ind_out[4]|=(1<<LED_POW_ON);
;    1076 	} */
;    1077 if(orient_step!=sOFF)ind_out[4]&=~(1<<LED_ORIENT);
	LDS  R30,_orient_step
	CPI  R30,0
	BREQ _0x125
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xEF
	POP  R26
	POP  R27
	ST   X,R30
;    1078 if(napoln_step!=sOFF)ind_out[4]&=~(1<<LED_NAPOLN);
_0x125:
	LDS  R30,_napoln_step
	CPI  R30,0
	BREQ _0x126
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFB
	POP  R26
	POP  R27
	ST   X,R30
;    1079 if(payka_step!=sOFF)ind_out[4]&=~(1<<LED_PAYKA);
_0x126:
	LDS  R30,_payka_step
	CPI  R30,0
	BREQ _0x127
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0XF7
	POP  R26
	POP  R27
	ST   X,R30
;    1080 if(main_loop_step!=sOFF)ind_out[4]&=~(1<<LED_MAIN_LOOP);	
_0x127:
	LDS  R30,_main_loop_step
	CPI  R30,0
	BREQ _0x128
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFD
	POP  R26
	POP  R27
	ST   X,R30
;    1081 }
_0x128:
	RET
;    1082 
;    1083 //-----------------------------------------------
;    1084 // Подпрограмма драйва до 7 кнопок одного порта, 
;    1085 // различает короткое и длинное нажатие,
;    1086 // срабатывает на отпускание кнопки, возможность
;    1087 // ускорения перебора при длинном нажатии...
;    1088 #define but_port PORTC
;    1089 #define but_dir  DDRC
;    1090 #define but_pin  PINC
;    1091 #define but_mask 0b01101010
;    1092 #define no_but   0b11111111
;    1093 #define but_on   5
;    1094 #define but_onL  20
;    1095 
;    1096 
;    1097 
;    1098 
;    1099 void but_drv(void)
;    1100 { 
_but_drv:
;    1101 DDRD&=0b00000111;
	IN   R30,0x11
	ANDI R30,LOW(0x7)
	CALL SUBOPT_0x10
;    1102 PORTD|=0b11111000;
;    1103 
;    1104 but_port|=(but_mask^0xff);
	CALL SUBOPT_0x11
;    1105 but_dir&=but_mask;
;    1106 #asm
;    1107 nop
nop
;    1108 nop
nop
;    1109 nop
nop
;    1110 nop
nop
;    1111 #endasm

;    1112 
;    1113 but_n=but_pin|but_mask; 
	IN   R30,0x13
	ORI  R30,LOW(0x6A)
	STS  _but_n_G1,R30
;    1114 
;    1115 if((but_n==no_but)||(but_n!=but_s))
	LDS  R26,_but_n_G1
	CPI  R26,LOW(0xFF)
	BREQ _0x12A
	RCALL SUBOPT_0x12
	BREQ _0x129
_0x12A:
;    1116  	{
;    1117  	speed=0;
	CLT
	BLD  R2,6
;    1118    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRSH _0x12D
	LDS  R26,_but1_cnt_G1
	CPI  R26,LOW(0x0)
	BREQ _0x12F
_0x12D:
	SBRS R2,4
	RJMP _0x130
_0x12F:
	RJMP _0x12C
_0x130:
;    1119   		{
;    1120    	     n_but=1;
	SET
	BLD  R2,5
;    1121           but=but_s;
	LDS  R11,_but_s_G1
;    1122           }
;    1123    	if (but1_cnt>=but_onL_temp)
_0x12C:
	RCALL SUBOPT_0x13
	BRLO _0x131
;    1124   		{
;    1125    	     n_but=1;
	SET
	BLD  R2,5
;    1126           but=but_s&0b11111101;
	RCALL SUBOPT_0x14
;    1127           }
;    1128     	l_but=0;
_0x131:
	CLT
	BLD  R2,4
;    1129    	but_onL_temp=but_onL;
	LDI  R30,LOW(20)
	STS  _but_onL_temp_G1,R30
;    1130     	but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    1131   	but1_cnt=0;          
	STS  _but1_cnt_G1,R30
;    1132      goto but_drv_out;
	RJMP _0x132
;    1133   	}  
;    1134   	
;    1135 if(but_n==but_s)
_0x129:
	RCALL SUBOPT_0x12
	BRNE _0x133
;    1136  	{
;    1137   	but0_cnt++;
	LDS  R30,_but0_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but0_cnt_G1,R30
;    1138   	if(but0_cnt>=but_on)
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRLO _0x134
;    1139   		{
;    1140    		but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    1141    		but1_cnt++;
	LDS  R30,_but1_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but1_cnt_G1,R30
;    1142    		if(but1_cnt>=but_onL_temp)
	RCALL SUBOPT_0x13
	BRLO _0x135
;    1143    			{              
;    1144     			but=but_s&0b11111101;
	RCALL SUBOPT_0x14
;    1145     			but1_cnt=0;
	LDI  R30,LOW(0)
	STS  _but1_cnt_G1,R30
;    1146     			n_but=1;
	SET
	BLD  R2,5
;    1147     			l_but=1;
	SET
	BLD  R2,4
;    1148 			if(speed)
	SBRS R2,6
	RJMP _0x136
;    1149 				{
;    1150     				but_onL_temp=but_onL_temp>>1;
	LDS  R30,_but_onL_temp_G1
	LSR  R30
	STS  _but_onL_temp_G1,R30
;    1151         			if(but_onL_temp<=2) but_onL_temp=2;
	LDS  R26,_but_onL_temp_G1
	LDI  R30,LOW(2)
	CP   R30,R26
	BRLO _0x137
	STS  _but_onL_temp_G1,R30
;    1152 				}    
_0x137:
;    1153    			}
_0x136:
;    1154   		} 
_0x135:
;    1155  	}
_0x134:
;    1156 but_drv_out:
_0x133:
_0x132:
;    1157 but_s=but_n;
	LDS  R30,_but_n_G1
	STS  _but_s_G1,R30
;    1158 but_port|=(but_mask^0xff);
	RCALL SUBOPT_0x11
;    1159 but_dir&=but_mask;
;    1160 }    
	RET
;    1161 
;    1162 #define butV	239
;    1163 #define butV_	237
;    1164 #define butP	251
;    1165 #define butP_	249
;    1166 #define butR	127
;    1167 #define butR_	125
;    1168 #define butL	254
;    1169 #define butL_	252
;    1170 #define butLR	126
;    1171 #define butLR_	124 
;    1172 #define butVP_ 233
;    1173 //-----------------------------------------------
;    1174 void but_an(void)
;    1175 {
_but_an:
;    1176 
;    1177 if(bSTART)
	SBRS R3,7
	RJMP _0x138
;    1178 	{   
;    1179 /*	if(ee_prog==EE_PROG_FULL)
;    1180 		{
;    1181 		}
;    1182 	else if(ee_prog==EE_PROG_ONLY_ORIENT)
;    1183 		{
;    1184 		orient_cmd=cmdSTART;
;    1185 		}
;    1186 	else if(ee_prog==EE_PROG_ONLY_NAPOLN)
;    1187 		{
;    1188 		napoln_cmd=cmdSTART;                              
;    1189 		}			                
;    1190 	else if(ee_prog==EE_PROG_ONLY_PAYKA)
;    1191 		{
;    1192 		payka_cmd=cmdSTART;
;    1193 		}
;    1194 	else if(ee_prog==EE_PROG_ONLY_MAIN_LOOP)
;    1195 		{
;    1196 		main_loop_cmd=cmdSTART;
;    1197 		//main_loop_del_cnt=20;
;    1198 		}  */
;    1199 		
;    1200 		
;    1201 		main_loop_cmd=cmdSTART;
	LDI  R30,LOW(1)
	STS  _main_loop_cmd,R30
;    1202 		
;    1203 						
;    1204 	}
;    1205 	
;    1206 bSTART=0;	
_0x138:
	CLT
	BLD  R3,7
;    1207 
;    1208 if(bSTOP)
	SBRS R4,0
	RJMP _0x139
;    1209 	{   
;    1210 	orient_cmd=cmdSTOP;
	LDI  R30,LOW(2)
	STS  _orient_cmd,R30
;    1211 	napoln_cmd=cmdSTOP;
	STS  _napoln_cmd,R30
;    1212 	payka_cmd=cmdSTOP;
	STS  _payka_cmd,R30
;    1213 	main_loop_cmd=cmdSTOP;
	STS  _main_loop_cmd,R30
;    1214 		
;    1215 	}
;    1216 	
;    1217 bSTOP=0;	
_0x139:
	CLT
	BLD  R4,0
;    1218 
;    1219 
;    1220 /*
;    1221 if(!(in_word&0x01))
;    1222 	{
;    1223 	#ifdef TVIST_SKO
;    1224 	if((step==sOFF)&&(!bERR))
;    1225 		{
;    1226 		step=s1;
;    1227 		if(prog==p2) cnt_del=70;
;    1228 		else if(prog==p3) cnt_del=100;
;    1229 		}
;    1230 	#endif
;    1231 	#ifdef DV3KL2MD
;    1232 	if((step==sOFF)&&(!bERR))
;    1233 		{
;    1234 		step=s1;
;    1235 		cnt_del=70;
;    1236 		}
;    1237 	#endif	
;    1238 	#ifndef TVIST_SKO
;    1239 	if((step==sOFF)&&(!bERR))
;    1240 		{
;    1241 		step=s1;
;    1242 		if(prog==p1) cnt_del=50;
;    1243 		else if(prog==p2) cnt_del=50;
;    1244 		else if(prog==p3) cnt_del=50;
;    1245           #ifdef P380_MINI
;    1246   		cnt_del=100;
;    1247   		#endif
;    1248 		}
;    1249 	#endif
;    1250 	}
;    1251 if(!(in_word&0x02))
;    1252 	{
;    1253 	step=sOFF;
;    1254 
;    1255 	} */
;    1256 
;    1257 if (!n_but) goto but_an_end;
	SBRS R2,5
	RJMP _0x13B
;    1258 
;    1259 if(but==butV_)
	LDI  R30,LOW(237)
	CP   R30,R11
	BRNE _0x13C
;    1260 	{
;    1261 	if(ee_loop_mode!=elmAUTO)ee_loop_mode=elmAUTO;
	LDI  R26,LOW(_ee_loop_mode)
	LDI  R27,HIGH(_ee_loop_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BREQ _0x13D
	LDI  R30,LOW(85)
	RJMP _0x190
;    1262 	else ee_loop_mode=elmMNL;
_0x13D:
	LDI  R30,LOW(170)
_0x190:
	LDI  R26,LOW(_ee_loop_mode)
	LDI  R27,HIGH(_ee_loop_mode)
	CALL __EEPROMWRB
;    1263 	}
;    1264 
;    1265 
;    1266 if(ind==iMn)
_0x13C:
	TST  R14
	BRNE _0x13F
;    1267 	{
;    1268 	if(but==butP_)
	LDI  R30,LOW(249)
	CP   R30,R11
	BRNE _0x140
;    1269 		{
;    1270 		ind=iSet;
	LDI  R30,LOW(2)
	MOV  R14,R30
;    1271 		sub_ind=0;
	LDI  R30,LOW(0)
	STS  _sub_ind,R30
;    1272 		}
;    1273 	}
_0x140:
;    1274 
;    1275 else if(ind==iSet)
	RJMP _0x141
_0x13F:
	LDI  R30,LOW(2)
	CP   R30,R14
	BREQ PC+3
	JMP _0x142
;    1276 	{
;    1277 	if(but==butP_)
	LDI  R30,LOW(249)
	CP   R30,R11
	BRNE _0x143
;    1278 		{
;    1279 		ind=iMn;
	CLR  R14
;    1280 		sub_ind=0;
	LDI  R30,LOW(0)
	STS  _sub_ind,R30
;    1281 		}      
;    1282 	else if(but==butP)
	RJMP _0x144
_0x143:
	LDI  R30,LOW(251)
	CP   R30,R11
	BRNE _0x145
;    1283 		{
;    1284 		sub_ind++;
	LDS  R30,_sub_ind
	SUBI R30,-LOW(1)
	STS  _sub_ind,R30
;    1285 		if(sub_ind==5)sub_ind=0;
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x5)
	BRNE _0x146
	LDI  R30,LOW(0)
	STS  _sub_ind,R30
;    1286 		}
_0x146:
;    1287 	else if (sub_ind==0)
	RJMP _0x147
_0x145:
	LDS  R30,_sub_ind
	CPI  R30,0
	BRNE _0x148
;    1288 		{
;    1289 		if(but==butR)ee_prog++;
	LDI  R30,LOW(127)
	CP   R30,R11
	BRNE _0x149
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    1290 		else if(but==butL)ee_prog--;
	RJMP _0x14A
_0x149:
	LDI  R30,LOW(254)
	CP   R30,R11
	BRNE _0x14B
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    1291 		if(ee_prog>5)ee_prog=0;
_0x14B:
_0x14A:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	MOVW R26,R30
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x14C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMWRW
;    1292 		if(ee_prog<0)ee_prog=5;
_0x14C:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	MOVW R26,R30
	SBIW R26,0
	BRGE _0x14D
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMWRW
;    1293 		}
_0x14D:
;    1294 	else if (sub_ind==1)
	RJMP _0x14E
_0x148:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x1)
	BRNE _0x14F
;    1295 		{             
;    1296 		if((but==butR)||(but==butR_))	
	LDI  R30,LOW(127)
	CP   R30,R11
	BREQ _0x151
	LDI  R30,LOW(125)
	CP   R30,R11
	BRNE _0x150
_0x151:
;    1297 			{  
;    1298 			speed=1;
	SET
	BLD  R2,6
;    1299 			ee_temp1++;
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    1300 			if(ee_temp1>900)ee_temp1=900;
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	RCALL SUBOPT_0x15
	BRGE _0x153
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMWRW
;    1301 			}   
_0x153:
;    1302 	
;    1303     		else if((but==butL)||(but==butL_))	
	RJMP _0x154
_0x150:
	LDI  R30,LOW(254)
	CP   R30,R11
	BREQ _0x156
	LDI  R30,LOW(252)
	CP   R30,R11
	BRNE _0x155
_0x156:
;    1304 			{  
;    1305     	    		speed=1;
	SET
	BLD  R2,6
;    1306     			ee_temp1--;
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    1307     			if(ee_temp1<0)ee_temp1=0;
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	MOVW R26,R30
	SBIW R26,0
	BRGE _0x158
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMWRW
;    1308     			}				
_0x158:
;    1309 		}   
_0x155:
_0x154:
;    1310 	else if (sub_ind==2)
	RJMP _0x159
_0x14F:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x2)
	BRNE _0x15A
;    1311 		{             
;    1312 		if((but==butR)||(but==butR_))	
	LDI  R30,LOW(127)
	CP   R30,R11
	BREQ _0x15C
	LDI  R30,LOW(125)
	CP   R30,R11
	BRNE _0x15B
_0x15C:
;    1313 			{  
;    1314 			speed=1;
	SET
	BLD  R2,6
;    1315 			ee_temp2++;
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    1316 			if(ee_temp2>900)ee_temp2=900;
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	RCALL SUBOPT_0x15
	BRGE _0x15E
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMWRW
;    1317 			}   
_0x15E:
;    1318 	
;    1319     		else if((but==butL)||(but==butL_))	
	RJMP _0x15F
_0x15B:
	LDI  R30,LOW(254)
	CP   R30,R11
	BREQ _0x161
	LDI  R30,LOW(252)
	CP   R30,R11
	BRNE _0x160
_0x161:
;    1320 			{  
;    1321     	    		speed=1;
	SET
	BLD  R2,6
;    1322     			ee_temp2--;
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    1323     			if(ee_temp2<0)ee_temp2=0;
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	MOVW R26,R30
	SBIW R26,0
	BRGE _0x163
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMWRW
;    1324     			}				
_0x163:
;    1325 		}
_0x160:
_0x15F:
;    1326 	else if (sub_ind==3)
	RJMP _0x164
_0x15A:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x3)
	BRNE _0x165
;    1327 		{             
;    1328 		if((but==butR)||(but==butR_))	
	LDI  R30,LOW(127)
	CP   R30,R11
	BREQ _0x167
	LDI  R30,LOW(125)
	CP   R30,R11
	BRNE _0x166
_0x167:
;    1329 			{  
;    1330 			speed=1;
	SET
	BLD  R2,6
;    1331 			ee_temp3++;
	LDI  R26,LOW(_ee_temp3)
	LDI  R27,HIGH(_ee_temp3)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    1332 			if(ee_temp3>900)ee_temp3=900;
	LDI  R26,LOW(_ee_temp3)
	LDI  R27,HIGH(_ee_temp3)
	CALL __EEPROMRDW
	RCALL SUBOPT_0x15
	BRGE _0x169
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	LDI  R26,LOW(_ee_temp3)
	LDI  R27,HIGH(_ee_temp3)
	CALL __EEPROMWRW
;    1333 			}   
_0x169:
;    1334 	
;    1335     		else if((but==butL)||(but==butL_))	
	RJMP _0x16A
_0x166:
	LDI  R30,LOW(254)
	CP   R30,R11
	BREQ _0x16C
	LDI  R30,LOW(252)
	CP   R30,R11
	BRNE _0x16B
_0x16C:
;    1336 			{  
;    1337     	    		speed=1;
	SET
	BLD  R2,6
;    1338     			ee_temp3--;
	LDI  R26,LOW(_ee_temp3)
	LDI  R27,HIGH(_ee_temp3)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    1339     			if(ee_temp3<0)ee_temp3=0;
	LDI  R26,LOW(_ee_temp3)
	LDI  R27,HIGH(_ee_temp3)
	CALL __EEPROMRDW
	MOVW R26,R30
	SBIW R26,0
	BRGE _0x16E
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	LDI  R26,LOW(_ee_temp3)
	LDI  R27,HIGH(_ee_temp3)
	CALL __EEPROMWRW
;    1340     			}				
_0x16E:
;    1341 		}		
_0x16B:
_0x16A:
;    1342 	else if (sub_ind==4)
	RJMP _0x16F
_0x165:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x4)
	BRNE _0x170
;    1343 		{             
;    1344 		if((but==butR)||(but==butR_))	
	LDI  R30,LOW(127)
	CP   R30,R11
	BREQ _0x172
	LDI  R30,LOW(125)
	CP   R30,R11
	BRNE _0x171
_0x172:
;    1345 			{  
;    1346 			speed=1;
	SET
	BLD  R2,6
;    1347 			ee_temp4++;
	LDI  R26,LOW(_ee_temp4)
	LDI  R27,HIGH(_ee_temp4)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    1348 			if(ee_temp4>900)ee_temp4=900;
	LDI  R26,LOW(_ee_temp4)
	LDI  R27,HIGH(_ee_temp4)
	CALL __EEPROMRDW
	RCALL SUBOPT_0x15
	BRGE _0x174
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	LDI  R26,LOW(_ee_temp4)
	LDI  R27,HIGH(_ee_temp4)
	CALL __EEPROMWRW
;    1349 			}   
_0x174:
;    1350 	
;    1351     		else if((but==butL)||(but==butL_))	
	RJMP _0x175
_0x171:
	LDI  R30,LOW(254)
	CP   R30,R11
	BREQ _0x177
	LDI  R30,LOW(252)
	CP   R30,R11
	BRNE _0x176
_0x177:
;    1352 			{  
;    1353     	    		speed=1;
	SET
	BLD  R2,6
;    1354     			ee_temp4--;
	LDI  R26,LOW(_ee_temp4)
	LDI  R27,HIGH(_ee_temp4)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    1355     			if(ee_temp4<0)ee_temp4=0;
	LDI  R26,LOW(_ee_temp4)
	LDI  R27,HIGH(_ee_temp4)
	CALL __EEPROMRDW
	MOVW R26,R30
	SBIW R26,0
	BRGE _0x179
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	LDI  R26,LOW(_ee_temp4)
	LDI  R27,HIGH(_ee_temp4)
	CALL __EEPROMWRW
;    1356     			}				
_0x179:
;    1357 		}													
_0x176:
_0x175:
;    1358 	}
_0x170:
_0x16F:
_0x164:
_0x159:
_0x14E:
_0x147:
_0x144:
;    1359 
;    1360 
;    1361 
;    1362 
;    1363 if(but==butVP_)
_0x142:
_0x141:
	LDI  R30,LOW(233)
	CP   R30,R11
	BRNE _0x17A
;    1364 	{
;    1365 	//if(ind!=iVr)ind=iVr;
;    1366 	//else ind=iMn;
;    1367 	}
;    1368 
;    1369 /*	
;    1370 if(ind==iMn)
;    1371 	{
;    1372 	if(but==butP_)ind=iPr_sel;
;    1373 	if(but==butLR)	
;    1374 		{
;    1375 		if((prog==p3)||(prog==p4))
;    1376 			{ 
;    1377 			if(sub_ind==0)sub_ind=1;
;    1378 			else sub_ind=0;
;    1379 			}
;    1380     		else sub_ind=0;
;    1381 		}	 
;    1382 	if((but==butR)||(but==butR_))	
;    1383 		{  
;    1384 		speed=1;
;    1385 		//ee_delay[prog,sub_ind]++;
;    1386 		}   
;    1387 	
;    1388 	else if((but==butL)||(but==butL_))	
;    1389 		{  
;    1390     		speed=1;
;    1391     		//ee_delay[prog,sub_ind]--;
;    1392     		}		
;    1393 	} 
;    1394 	
;    1395 else if(ind==iPr_sel)
;    1396 	{
;    1397 	if(but==butP_)ind=iMn;
;    1398 	if(but==butP)
;    1399 		{
;    1400 		prog++;
;    1401 ////		if(prog>MAXPROG)prog=MINPROG;
;    1402 		//ee_program[0]=prog;
;    1403 		//ee_program[1]=prog;
;    1404 		//ee_program[2]=prog;
;    1405 		}
;    1406 	
;    1407 	if(but==butR)
;    1408 		{
;    1409 		prog++;
;    1410 ////		if(prog>MAXPROG)prog=MINPROG;
;    1411 		//ee_program[0]=prog;
;    1412 		//ee_program[1]=prog;
;    1413 		//ee_program[2]=prog;
;    1414 		}
;    1415 
;    1416 	if(but==butL)
;    1417 		{
;    1418 		prog--;
;    1419 ////		if(prog>MAXPROG)prog=MINPROG;
;    1420 		//ee_program[0]=prog;
;    1421 		//ee_program[1]=prog;
;    1422 		//ee_program[2]=prog;
;    1423 		}	
;    1424 	} 
;    1425 
;    1426 /*else if(ind==iVr)
;    1427 	{
;    1428 	if(but==butP_)
;    1429 		{
;    1430 	    ///	if(ee_vr_log)ee_vr_log=0;
;    1431 	    ///	else ee_vr_log=1;
;    1432 		}	
;    1433 	}*/ 	
;    1434 
;    1435 but_an_end:
_0x17A:
_0x13B:
;    1436 n_but=0;
	CLT
	BLD  R2,5
;    1437 }
	RET
;    1438 
;    1439 //-----------------------------------------------
;    1440 void ind_drv(void)
;    1441 {
_ind_drv:
;    1442 if(++ind_cnt>=6)ind_cnt=0;
	INC  R10
	LDI  R30,LOW(6)
	CP   R10,R30
	BRLO _0x17B
	CLR  R10
;    1443 
;    1444 if(ind_cnt<5)
_0x17B:
	LDI  R30,LOW(5)
	CP   R10,R30
	BRSH _0x17C
;    1445 	{
;    1446 	DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
;    1447 	PORTC=0xFF;
	OUT  0x15,R30
;    1448 	DDRD|=0b11111000;
	IN   R30,0x11
	ORI  R30,LOW(0xF8)
	RCALL SUBOPT_0x10
;    1449 	PORTD|=0b11111000;
;    1450 	PORTD&=IND_STROB[ind_cnt];
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
;    1451 	PORTC=ind_out[ind_cnt];
	MOV  R30,R10
	LDI  R31,0
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	LD   R30,Z
	OUT  0x15,R30
;    1452 	}
;    1453 else but_drv();
	RJMP _0x17D
_0x17C:
	CALL _but_drv
_0x17D:
;    1454 }
	RET
;    1455 
;    1456 //***********************************************
;    1457 //***********************************************
;    1458 //***********************************************
;    1459 //***********************************************
;    1460 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;    1461 {
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
;    1462 TCCR0=0x02;
	RCALL SUBOPT_0x16
;    1463 TCNT0=-208;
;    1464 OCR0=0x00; 
;    1465 
;    1466 
;    1467 b600Hz=1;
	SET
	BLD  R2,0
;    1468 ind_drv();
	RCALL _ind_drv
;    1469 if(++t0_cnt0>=6)
	INC  R6
	LDI  R30,LOW(6)
	CP   R6,R30
	BRLO _0x17E
;    1470 	{
;    1471 	t0_cnt0=0;
	CLR  R6
;    1472 	b100Hz=1;
	SET
	BLD  R2,1
;    1473 	}
;    1474 
;    1475 if(++t0_cnt1>=60)
_0x17E:
	INC  R7
	LDI  R30,LOW(60)
	CP   R7,R30
	BRLO _0x17F
;    1476 	{
;    1477 	t0_cnt1=0;
	CLR  R7
;    1478 	b10Hz=1;
	SET
	BLD  R2,2
;    1479 	
;    1480 	if(++t0_cnt2>=2)
	INC  R8
	LDI  R30,LOW(2)
	CP   R8,R30
	BRLO _0x180
;    1481 		{
;    1482 		t0_cnt2=0;
	CLR  R8
;    1483 		bFL5=!bFL5;
	LDI  R30,LOW(1)
	EOR  R3,R30
;    1484 		}
;    1485 		
;    1486 	if(++t0_cnt3>=5)
_0x180:
	INC  R9
	LDI  R30,LOW(5)
	CP   R9,R30
	BRLO _0x181
;    1487 		{
;    1488 		t0_cnt3=0;
	CLR  R9
;    1489 		bFL2=!bFL2;
	LDI  R30,LOW(128)
	EOR  R2,R30
;    1490 		}		
;    1491 	}
_0x181:
;    1492 }
_0x17F:
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
;    1493 
;    1494 //===============================================
;    1495 //===============================================
;    1496 //===============================================
;    1497 //===============================================
;    1498 
;    1499 void main(void)
;    1500 {
_main:
;    1501 
;    1502 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
;    1503 DDRA=0x00;
	RCALL SUBOPT_0x0
;    1504 
;    1505 PORTB=0xff;
	RCALL SUBOPT_0x17
;    1506 DDRB=0xFF;
;    1507 
;    1508 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;    1509 DDRC=0x00;
	OUT  0x14,R30
;    1510 
;    1511 
;    1512 PORTD=0x00;
	OUT  0x12,R30
;    1513 DDRD=0x00;
	OUT  0x11,R30
;    1514 
;    1515 
;    1516 TCCR0=0x02;
	RCALL SUBOPT_0x16
;    1517 TCNT0=-208;
;    1518 OCR0=0x00;
;    1519 
;    1520 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;    1521 TCCR1B=0x00;
	OUT  0x2E,R30
;    1522 TCNT1H=0x00;
	OUT  0x2D,R30
;    1523 TCNT1L=0x00;
	OUT  0x2C,R30
;    1524 ICR1H=0x00;
	OUT  0x27,R30
;    1525 ICR1L=0x00;
	OUT  0x26,R30
;    1526 OCR1AH=0x00;
	OUT  0x2B,R30
;    1527 OCR1AL=0x00;
	OUT  0x2A,R30
;    1528 OCR1BH=0x00;
	OUT  0x29,R30
;    1529 OCR1BL=0x00;
	OUT  0x28,R30
;    1530 
;    1531 
;    1532 ASSR=0x00;
	OUT  0x22,R30
;    1533 TCCR2=0x00;
	OUT  0x25,R30
;    1534 TCNT2=0x00;
	OUT  0x24,R30
;    1535 OCR2=0x00;
	OUT  0x23,R30
;    1536 
;    1537 MCUCR=0x00;
	OUT  0x35,R30
;    1538 MCUCSR=0x00;
	OUT  0x34,R30
;    1539 
;    1540 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;    1541 
;    1542 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;    1543 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;    1544 
;    1545 #asm("sei") 
	sei
;    1546 PORTB=0xFF;
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x17
;    1547 DDRB=0xFF;
;    1548 ind=iMn;
	CLR  R14
;    1549 prog_drv();
	CALL _prog_drv
;    1550 ind_hndl();
	CALL _ind_hndl
;    1551 led_hndl();
	CALL _led_hndl
;    1552 
;    1553 
;    1554 while (1)
_0x182:
;    1555       {
;    1556       if(b600Hz)
	SBRS R2,0
	RJMP _0x185
;    1557 		{
;    1558 		b600Hz=0; 
	CLT
	BLD  R2,0
;    1559           in_an();
	CALL _in_an
;    1560           
;    1561 		}         
;    1562       if(b100Hz)
_0x185:
	SBRS R2,1
	RJMP _0x186
;    1563 		{        
;    1564 		b100Hz=0; 
	CLT
	BLD  R2,1
;    1565 		but_an();
	RCALL _but_an
;    1566 	    	//in_drv();
;    1567           ind_hndl();
	CALL _ind_hndl
;    1568           step_contr();
	CALL _step_contr
;    1569           
;    1570           main_loop_hndl();
	CALL _main_loop_hndl
;    1571           payka_hndl();
	CALL _payka_hndl
;    1572           napoln_hndl();
	CALL _napoln_hndl
;    1573           orient_hndl();
	CALL _orient_hndl
;    1574           out_drv();
	CALL _out_drv
;    1575 		}   
;    1576 	if(b10Hz)
_0x186:
	SBRS R2,2
	RJMP _0x187
;    1577 		{
;    1578 		b10Hz=0;
	CLT
	BLD  R2,2
;    1579 		prog_drv();
	CALL _prog_drv
;    1580 		err_drv();
	CALL _err_drv
;    1581 		
;    1582     	     
;    1583           led_hndl();
	CALL _led_hndl
;    1584           
;    1585           }
;    1586 
;    1587       };
_0x187:
	RJMP _0x182
;    1588 }
_0x188:
	RJMP _0x188

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	LDI  R30,LOW(255)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	LDI  R30,LOW(2)
	STS  _orient_cmd,R30
	STS  _napoln_cmd,R30
	STS  _payka_cmd,R30
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2:
	STS  _main_loop_step,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _main_loop_cnt_del,R30
	STS  _main_loop_cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3:
	LDS  R30,_main_loop_cnt_del
	LDS  R31,_main_loop_cnt_del+1
	SBIW R30,1
	STS  _main_loop_cnt_del,R30
	STS  _main_loop_cnt_del+1,R31
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x4:
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	STS  _payka_cnt_del,R30
	STS  _payka_cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x5:
	LDS  R30,_payka_cnt_del
	LDS  R31,_payka_cnt_del+1
	SBIW R30,1
	STS  _payka_cnt_del,R30
	STS  _payka_cnt_del+1,R31
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6:
	MOV  R30,R16
	COM  R30
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7:
	LDI  R30,LOW(19)
	MOV  R13,R30
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES
SUBOPT_0x8:
	LDS  R30,_cnt_del
	LDS  R31,_cnt_del+1
	SBIW R30,1
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x9:
	LDI  R30,LOW(3)
	MOV  R13,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA:
	LDI  R30,LOW(5)
	MOV  R13,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB:
	LDI  R30,LOW(7)
	MOV  R13,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xC:
	MOV  R13,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0xD:
	MOV  R30,R16
	SUBI R30,LOW(1)
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xE:
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _int2ind

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xF:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _int2ind

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10:
	OUT  0x11,R30
	IN   R30,0x12
	ORI  R30,LOW(0xF8)
	OUT  0x12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x11:
	IN   R30,0x15
	ORI  R30,LOW(0x95)
	OUT  0x15,R30
	IN   R30,0x14
	ANDI R30,LOW(0x6A)
	OUT  0x14,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x12:
	LDS  R30,_but_s_G1
	LDS  R26,_but_n_G1
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x13:
	LDS  R30,_but_onL_temp_G1
	LDS  R26,_but1_cnt_G1
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x14:
	LDS  R30,_but_s_G1
	ANDI R30,0xFD
	MOV  R11,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x15:
	MOVW R26,R30
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	CP   R30,R26
	CPC  R31,R27
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

__ANEGW1:
	COM  R30
	COM  R31
	ADIW R30,1
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

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

