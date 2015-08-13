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
;     145 enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}payka_step=sOFF,napoln_step=sOFF,main_loop_step=sOFF;

	.DSEG
_payka_step:
	.BYTE 0x1
_napoln_step:
	.BYTE 0x1
_main_loop_step:
	.BYTE 0x1
;     146 enum{cmdOFF=0,cmdSTART,cmdSTOP}payka_cmd=cmdOFF,napoln_cmd=cmdOFF,main_loop_cmd=cmdOFF;
_payka_cmd:
	.BYTE 0x1
_napoln_cmd:
	.BYTE 0x1
_main_loop_cmd:
	.BYTE 0x1
;     147 signed short payka_cnt_del,napoln_cnt_del;
_payka_cnt_del:
	.BYTE 0x2
_napoln_cnt_del:
	.BYTE 0x2
;     148 eeprom signed short ee_temp1,ee_temp2;

	.ESEG
_ee_temp1:
	.DW  0x0
_ee_temp2:
	.DW  0x0
;     149 
;     150 bit bPAYKA_COMPLETE=0,bNAPOLN_COMPLETE=0;
;     151 
;     152 //-----------------------------------------------
;     153 void prog_drv(void)
;     154 {

	.CSEG
_prog_drv:
;     155 char temp,temp1,temp2;
;     156 
;     157 temp=ee_program[0];
	CALL __SAVELOCR3
;	temp -> R16
;	temp1 -> R17
;	temp2 -> R18
	LDI  R26,LOW(_ee_program)
	LDI  R27,HIGH(_ee_program)
	CALL __EEPROMRDB
	MOV  R16,R30
;     158 temp1=ee_program[1];
	__POINTW2MN _ee_program,1
	CALL __EEPROMRDB
	MOV  R17,R30
;     159 temp2=ee_program[2];
	__POINTW2MN _ee_program,2
	CALL __EEPROMRDB
	MOV  R18,R30
;     160 
;     161 if((temp==temp1)&&(temp==temp2))
	CP   R17,R16
	BRNE _0x5
	CP   R18,R16
	BREQ _0x6
_0x5:
	RJMP _0x4
_0x6:
;     162 	{
;     163 	}
;     164 else if((temp==temp1)&&(temp!=temp2))
	RJMP _0x7
_0x4:
	CP   R17,R16
	BRNE _0x9
	CP   R18,R16
	BRNE _0xA
_0x9:
	RJMP _0x8
_0xA:
;     165 	{
;     166 	temp2=temp;
	MOV  R18,R16
;     167 	}
;     168 else if((temp!=temp1)&&(temp==temp2))
	RJMP _0xB
_0x8:
	CP   R17,R16
	BREQ _0xD
	CP   R18,R16
	BREQ _0xE
_0xD:
	RJMP _0xC
_0xE:
;     169 	{
;     170 	temp1=temp;
	MOV  R17,R16
;     171 	}
;     172 else if((temp!=temp1)&&(temp1==temp2))
	RJMP _0xF
_0xC:
	CP   R17,R16
	BREQ _0x11
	CP   R18,R17
	BREQ _0x12
_0x11:
	RJMP _0x10
_0x12:
;     173 	{
;     174 	temp=temp1;
	MOV  R16,R17
;     175 	}
;     176 else if((temp!=temp1)&&(temp!=temp2))
	RJMP _0x13
_0x10:
	CP   R17,R16
	BREQ _0x15
	CP   R18,R16
	BRNE _0x16
_0x15:
	RJMP _0x14
_0x16:
;     177 	{
;     178 	temp=MINPROG;
	LDI  R16,LOW(2)
;     179 	temp1=MINPROG;
	LDI  R17,LOW(2)
;     180 	temp2=MINPROG;
	LDI  R18,LOW(2)
;     181 	}
;     182 
;     183 if(!((temp<=MAXPROG)&&(temp>=MINPROG)))
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
;     184 	{
;     185 	temp=MINPROG;
	LDI  R16,LOW(2)
;     186 	}
;     187 
;     188 if(temp!=ee_program[0])ee_program[0]=temp;
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
;     189 if(temp!=ee_program[1])ee_program[1]=temp;
_0x1A:
	__POINTW2MN _ee_program,1
	CALL __EEPROMRDB
	CP   R30,R16
	BREQ _0x1B
	__POINTW2MN _ee_program,1
	MOV  R30,R16
	CALL __EEPROMWRB
;     190 if(temp!=ee_program[2])ee_program[2]=temp;
_0x1B:
	__POINTW2MN _ee_program,2
	CALL __EEPROMRDB
	CP   R30,R16
	BREQ _0x1C
	__POINTW2MN _ee_program,2
	MOV  R30,R16
	CALL __EEPROMWRB
;     191 
;     192 prog=temp;
_0x1C:
	MOV  R12,R16
;     193 }
	CALL __LOADLOCR3
	RJMP _0x12F
;     194 
;     195 //-----------------------------------------------
;     196 void in_drv(void)
;     197 {
;     198 char i,temp;
;     199 unsigned int tempUI;
;     200 DDRA=0x00;
;	i -> R16
;	temp -> R17
;	tempUI -> R18,R19
;     201 PORTA=0xff;
;     202 in_word_new=PINA;
;     203 if(in_word_old==in_word_new)
;     204 	{
;     205 	if(in_word_cnt<10)
;     206 		{
;     207 		in_word_cnt++;
;     208 		if(in_word_cnt>=10)
;     209 			{
;     210 			in_word=in_word_old;
;     211 			}
;     212 		}
;     213 	}
;     214 else in_word_cnt=0;
;     215 
;     216 
;     217 in_word_old=in_word_new;
;     218 }   
;     219 
;     220 //-----------------------------------------------
;     221 void err_drv(void)
;     222 {
_err_drv:
;     223 if(step==sOFF)
	TST  R13
	BRNE _0x21
;     224 	{
;     225     	if(prog==p2)	
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x22
;     226     		{
;     227        		if(bMD1) bERR=1;
	SBRS R3,2
	RJMP _0x23
	SET
	BLD  R3,1
;     228        		else bERR=0;
	RJMP _0x24
_0x23:
	CLT
	BLD  R3,1
_0x24:
;     229 		}
;     230 	}
_0x22:
;     231 else bERR=0;
	RJMP _0x25
_0x21:
	CLT
	BLD  R3,1
_0x25:
;     232 }
	RET
;     233   
;     234 
;     235 //-----------------------------------------------
;     236 void in_an(void)
;     237 {
_in_an:
;     238 DDRA=0x00;
	CALL SUBOPT_0x0
;     239 PORTA=0xff;
	OUT  0x1B,R30
;     240 in_word=PINA;
	IN   R30,0x19
	STS  _in_word,R30
;     241 
;     242 if(!(in_word&(1<<MD1)))
	ANDI R30,LOW(0x4)
	BRNE _0x26
;     243 	{
;     244 	if(cnt_md1<10)
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRSH _0x27
;     245 		{
;     246 		cnt_md1++;
	LDS  R30,_cnt_md1
	SUBI R30,-LOW(1)
	STS  _cnt_md1,R30
;     247 		if(cnt_md1==10) bMD1=1;
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRNE _0x28
	SET
	BLD  R3,2
;     248 		}
_0x28:
;     249 
;     250 	}
_0x27:
;     251 else
	RJMP _0x29
_0x26:
;     252 	{
;     253 	if(cnt_md1)
	LDS  R30,_cnt_md1
	CPI  R30,0
	BREQ _0x2A
;     254 		{
;     255 		cnt_md1--;
	SUBI R30,LOW(1)
	STS  _cnt_md1,R30
;     256 		if(cnt_md1==0) bMD1=0;
	CPI  R30,0
	BRNE _0x2B
	CLT
	BLD  R3,2
;     257 		}
_0x2B:
;     258 
;     259 	}
_0x2A:
_0x29:
;     260 
;     261 if(!(in_word&(1<<MD2)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x8)
	BRNE _0x2C
;     262 	{
;     263 	if(cnt_md2<10)
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRSH _0x2D
;     264 		{
;     265 		cnt_md2++;
	LDS  R30,_cnt_md2
	SUBI R30,-LOW(1)
	STS  _cnt_md2,R30
;     266 		if(cnt_md2==10) bMD2=1;
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRNE _0x2E
	SET
	BLD  R3,3
;     267 		}
_0x2E:
;     268 
;     269 	}
_0x2D:
;     270 else
	RJMP _0x2F
_0x2C:
;     271 	{
;     272 	if(cnt_md2)
	LDS  R30,_cnt_md2
	CPI  R30,0
	BREQ _0x30
;     273 		{
;     274 		cnt_md2--;
	SUBI R30,LOW(1)
	STS  _cnt_md2,R30
;     275 		if(cnt_md2==0) bMD2=0;
	CPI  R30,0
	BRNE _0x31
	CLT
	BLD  R3,3
;     276 		}
_0x31:
;     277 
;     278 	}
_0x30:
_0x2F:
;     279 
;     280 if(!(in_word&(1<<BD1)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x80)
	BRNE _0x32
;     281 	{
;     282 	if(cnt_bd1<10)
	LDS  R26,_cnt_bd1
	CPI  R26,LOW(0xA)
	BRSH _0x33
;     283 		{
;     284 		cnt_bd1++;
	LDS  R30,_cnt_bd1
	SUBI R30,-LOW(1)
	STS  _cnt_bd1,R30
;     285 		if(cnt_bd1==10) bBD1=1;
	LDS  R26,_cnt_bd1
	CPI  R26,LOW(0xA)
	BRNE _0x34
	SET
	BLD  R3,4
;     286 		}
_0x34:
;     287 
;     288 	}
_0x33:
;     289 else
	RJMP _0x35
_0x32:
;     290 	{
;     291 	if(cnt_bd1)
	LDS  R30,_cnt_bd1
	CPI  R30,0
	BREQ _0x36
;     292 		{
;     293 		cnt_bd1--;
	SUBI R30,LOW(1)
	STS  _cnt_bd1,R30
;     294 		if(cnt_bd1==0) bBD1=0;
	CPI  R30,0
	BRNE _0x37
	CLT
	BLD  R3,4
;     295 		}
_0x37:
;     296 
;     297 	}
_0x36:
_0x35:
;     298 
;     299 if(!(in_word&(1<<BD2)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x10)
	BRNE _0x38
;     300 	{
;     301 	if(cnt_bd2<10)
	LDS  R26,_cnt_bd2
	CPI  R26,LOW(0xA)
	BRSH _0x39
;     302 		{
;     303 		cnt_bd2++;
	LDS  R30,_cnt_bd2
	SUBI R30,-LOW(1)
	STS  _cnt_bd2,R30
;     304 		if(cnt_bd2==10) bBD2=1;
	LDS  R26,_cnt_bd2
	CPI  R26,LOW(0xA)
	BRNE _0x3A
	SET
	BLD  R3,5
;     305 		}
_0x3A:
;     306 
;     307 	}
_0x39:
;     308 else
	RJMP _0x3B
_0x38:
;     309 	{
;     310 	if(cnt_bd2)
	LDS  R30,_cnt_bd2
	CPI  R30,0
	BREQ _0x3C
;     311 		{
;     312 		cnt_bd2--;
	SUBI R30,LOW(1)
	STS  _cnt_bd2,R30
;     313 		if(cnt_bd2==0) bBD2=0;
	CPI  R30,0
	BRNE _0x3D
	CLT
	BLD  R3,5
;     314 		}
_0x3D:
;     315 
;     316 	}
_0x3C:
_0x3B:
;     317 
;     318 if(!(in_word&(1<<DM)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x2)
	BRNE _0x3E
;     319 	{
;     320 	if(cnt_dm<10)
	LDS  R26,_cnt_dm
	CPI  R26,LOW(0xA)
	BRSH _0x3F
;     321 		{
;     322 		cnt_dm++;
	LDS  R30,_cnt_dm
	SUBI R30,-LOW(1)
	STS  _cnt_dm,R30
;     323 		if(cnt_dm==10) bDM=1;
	LDS  R26,_cnt_dm
	CPI  R26,LOW(0xA)
	BRNE _0x40
	SET
	BLD  R3,6
;     324 		}
_0x40:
;     325 	}
_0x3F:
;     326 else
	RJMP _0x41
_0x3E:
;     327 	{
;     328 	if(cnt_dm)
	LDS  R30,_cnt_dm
	CPI  R30,0
	BREQ _0x42
;     329 		{
;     330 		cnt_dm--;
	SUBI R30,LOW(1)
	STS  _cnt_dm,R30
;     331 		if(cnt_dm==0) bDM=0;
	CPI  R30,0
	BRNE _0x43
	CLT
	BLD  R3,6
;     332 		}
_0x43:
;     333 	}
_0x42:
_0x41:
;     334 
;     335 if(!(in_word&(1<<START)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x1)
	BRNE _0x44
;     336 	{
;     337 	if(cnt_start<10)
	LDS  R26,_cnt_start
	CPI  R26,LOW(0xA)
	BRSH _0x45
;     338 		{
;     339 		cnt_start++;
	LDS  R30,_cnt_start
	SUBI R30,-LOW(1)
	STS  _cnt_start,R30
;     340 		if(cnt_start==10) 
	LDS  R26,_cnt_start
	CPI  R26,LOW(0xA)
	BRNE _0x46
;     341 			{
;     342 			bSTART=1;
	SET
	BLD  R3,7
;     343 			main_loop_cmd==cmdSTART;
	LDS  R26,_main_loop_cmd
	LDI  R30,LOW(1)
	CALL __EQB12
;     344 			}
;     345 		}
_0x46:
;     346 	}
_0x45:
;     347 else
	RJMP _0x47
_0x44:
;     348 	{
;     349 	if(cnt_start)
	LDS  R30,_cnt_start
	CPI  R30,0
	BREQ _0x48
;     350 		{
;     351 		cnt_start--;
	SUBI R30,LOW(1)
	STS  _cnt_start,R30
;     352 		if(cnt_start==0) bSTART=0;
	CPI  R30,0
	BRNE _0x49
	CLT
	BLD  R3,7
;     353 		}
_0x49:
;     354 	} 
_0x48:
_0x47:
;     355 
;     356 if(!(in_word&(1<<STOP)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x4)
	BRNE _0x4A
;     357 	{
;     358 	if(cnt_stop<10)
	LDS  R26,_cnt_stop
	CPI  R26,LOW(0xA)
	BRSH _0x4B
;     359 		{
;     360 		cnt_stop++;
	LDS  R30,_cnt_stop
	SUBI R30,-LOW(1)
	STS  _cnt_stop,R30
;     361 		if(cnt_stop==10) bSTOP=1;
	LDS  R26,_cnt_stop
	CPI  R26,LOW(0xA)
	BRNE _0x4C
	SET
	BLD  R4,0
;     362 		}
_0x4C:
;     363 	}
_0x4B:
;     364 else
	RJMP _0x4D
_0x4A:
;     365 	{
;     366 	if(cnt_stop)
	LDS  R30,_cnt_stop
	CPI  R30,0
	BREQ _0x4E
;     367 		{
;     368 		cnt_stop--;
	SUBI R30,LOW(1)
	STS  _cnt_stop,R30
;     369 		if(cnt_stop==0) bSTOP=0;
	CPI  R30,0
	BRNE _0x4F
	CLT
	BLD  R4,0
;     370 		}
_0x4F:
;     371 	} 
_0x4E:
_0x4D:
;     372 } 
	RET
;     373 
;     374 //-----------------------------------------------
;     375 void main_loop_hndl(void)
;     376 {
_main_loop_hndl:
;     377 if(main_loop_cmd==cmdSTART)
	LDS  R26,_main_loop_cmd
	CPI  R26,LOW(0x1)
	BRNE _0x50
;     378 	{
;     379 	payka_cmd=cmdSTART;
	LDI  R30,LOW(1)
	STS  _payka_cmd,R30
;     380 	main_loop_cmd=cmdOFF;
	LDI  R30,LOW(0)
	STS  _main_loop_cmd,R30
;     381 	}                      
;     382 else if(main_loop_cmd==cmdSTOP)
	RJMP _0x51
_0x50:
	LDS  R26,_main_loop_cmd
	CPI  R26,LOW(0x2)
	BRNE _0x52
;     383 	{
;     384 
;     385 	}
;     386 	 
;     387 }
_0x52:
_0x51:
	RET
;     388 
;     389 //-----------------------------------------------
;     390 void payka_hndl(void)
;     391 {
_payka_hndl:
;     392 if(payka_cmd==cmdSTART)
	LDS  R26,_payka_cmd
	CPI  R26,LOW(0x1)
	BRNE _0x53
;     393 	{
;     394 	payka_step=s1;
	LDI  R30,LOW(1)
	STS  _payka_step,R30
;     395 	payka_cnt_del=ee_temp1;
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	STS  _payka_cnt_del,R30
	STS  _payka_cnt_del+1,R31
;     396 	bPAYKA_COMPLETE=0;
	CLT
	BLD  R5,1
;     397 	payka_cmd=cmdOFF;
	LDI  R30,LOW(0)
	STS  _payka_cmd,R30
;     398 	}                      
;     399 else if(payka_cmd==cmdSTOP)
	RJMP _0x54
_0x53:
	LDS  R26,_payka_cmd
	CPI  R26,LOW(0x2)
	BRNE _0x55
;     400 	{
;     401 	payka_step=sOFF;
	LDI  R30,LOW(0)
	STS  _payka_step,R30
;     402 	payka_cmd=cmdOFF;
	STS  _payka_cmd,R30
;     403 	} 
;     404 		
;     405 if(payka_step==sOFF)
_0x55:
_0x54:
	LDS  R30,_payka_step
	CPI  R30,0
	BRNE _0x56
;     406 	{
;     407 	bPP6=0;
	CLT
	BLD  R4,6
;     408 	bPP7=0;
	CLT
	BLD  R4,7
;     409 	}      
;     410 else if(payka_step==s1)
	RJMP _0x57
_0x56:
	LDS  R26,_payka_step
	CPI  R26,LOW(0x1)
	BRNE _0x58
;     411 	{
;     412 	bPP6=1;
	SET
	BLD  R4,6
;     413 	bPP7=0;
	CLT
	BLD  R4,7
;     414 	payka_cnt_del--;
	CALL SUBOPT_0x1
;     415 	if(payka_cnt_del==0)
	BRNE _0x59
;     416 		{
;     417 		payka_step=s2;
	LDI  R30,LOW(2)
	STS  _payka_step,R30
;     418 		payka_cnt_del=20;
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _payka_cnt_del,R30
	STS  _payka_cnt_del+1,R31
;     419 		}                	
;     420 	}	
_0x59:
;     421 else if(payka_step==s2)
	RJMP _0x5A
_0x58:
	LDS  R26,_payka_step
	CPI  R26,LOW(0x2)
	BRNE _0x5B
;     422 	{
;     423 	bPP6=0;
	CLT
	BLD  R4,6
;     424 	bPP7=0;
	CLT
	BLD  R4,7
;     425 	payka_cnt_del--;
	CALL SUBOPT_0x1
;     426 	if(payka_cnt_del==0)
	BRNE _0x5C
;     427 		{
;     428 		payka_step=s3;
	LDI  R30,LOW(3)
	STS  _payka_step,R30
;     429 		payka_cnt_del=ee_temp2;
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	STS  _payka_cnt_del,R30
	STS  _payka_cnt_del+1,R31
;     430 		}                	
;     431 	}		  
_0x5C:
;     432 else if(payka_step==s3)
	RJMP _0x5D
_0x5B:
	LDS  R26,_payka_step
	CPI  R26,LOW(0x3)
	BRNE _0x5E
;     433 	{
;     434 	bPP6=0;
	CLT
	BLD  R4,6
;     435 	bPP7=1;
	SET
	BLD  R4,7
;     436 	payka_cnt_del--;
	CALL SUBOPT_0x1
;     437 	if(payka_cnt_del==0)
	BRNE _0x5F
;     438 		{
;     439 		payka_step=sOFF;
	LDI  R30,LOW(0)
	STS  _payka_step,R30
;     440 		bPAYKA_COMPLETE=1;
	SET
	BLD  R5,1
;     441 		}                	
;     442 	}			
_0x5F:
;     443 }
_0x5E:
_0x5D:
_0x5A:
_0x57:
	RET
;     444 
;     445 //-----------------------------------------------
;     446 void napoln_hndl(void)
;     447 {
;     448 if(napoln_cmd==cmdSTART)
;     449 	{
;     450 	napoln_step=s1;
;     451 	napoln_cnt_del=0;
;     452 	bNAPOLN_COMPLETE=0;
;     453 	
;     454 	napoln_cmd=cmdOFF;
;     455 	}                      
;     456 else if(napoln_cmd==cmdSTOP)
;     457 	{
;     458 	napoln_step=sOFF;
;     459 	napoln_cmd=cmdOFF;
;     460 	} 
;     461 		
;     462 if(napoln_step==sOFF)
;     463 	{
;     464 	bPP4=0;
;     465 	bPP5=0;
;     466 	}      
;     467 else if(napoln_step==s1)
;     468 	{
;     469 	bPP4=0;
;     470 	bPP5=0;
;     471 	if(BD2)
;     472 		{
;     473 		napoln_step=s2;
;     474 		napoln_cnt_del=20;
;     475 		}
;     476 	}	
;     477 else if(napoln_step==s2)
;     478 	{
;     479 	bPP4=1;
;     480 	bPP5=0;
;     481 	napoln_cnt_del--;
;     482 	if(napoln_cnt_del==0)
;     483 		{
;     484 		napoln_step=s3;
;     485 		}                	
;     486 	}		  
;     487 else if(napoln_step==s3)
;     488 	{
;     489 	bPP4=1;
;     490 	bPP5=1;
;     491 	napoln_cnt_del--;
;     492 	if(bMD2)
;     493 		{
;     494 		napoln_step=sOFF;
;     495 		bNAPOLN_COMPLETE=1;
;     496 		}                	
;     497 	}			
;     498 }
;     499 //-----------------------------------------------
;     500 void step_contr(void)
;     501 {
_step_contr:
;     502 char temp=0;
;     503 DDRB=0xFF;
	ST   -Y,R16
;	temp -> R16
	LDI  R16,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     504 
;     505 if(step==sOFF)goto step_contr_end;
	TST  R13
	BRNE _0x6D
	RJMP _0x6E
;     506 
;     507 else if(prog==p1)
_0x6D:
	LDI  R30,LOW(1)
	CP   R30,R12
	BREQ PC+3
	JMP _0x70
;     508 	{
;     509 	if(step==s1)    //жесть
	CP   R30,R13
	BRNE _0x71
;     510 		{
;     511 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     512           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x6E
;     513 
;     514 			//if(ee_vacuum_mode==evmOFF)
;     515 				{
;     516 				//goto lbl_0001;
;     517 				}
;     518 			//else step=s2;
;     519 		}
;     520 
;     521 	else if(step==s2)
	RJMP _0x73
_0x71:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0x74
;     522 		{
;     523 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(200)
;     524  //         if(!bVR)goto step_contr_end;
;     525 lbl_0001:
;     526 
;     527           step=s100;
	CALL SUBOPT_0x2
;     528 		cnt_del=40;
;     529           }
;     530 	else if(step==s100)
	RJMP _0x76
_0x74:
	LDI  R30,LOW(19)
	CP   R30,R13
	BRNE _0x77
;     531 		{
;     532 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(216)
;     533           cnt_del--;
	CALL SUBOPT_0x3
;     534           if(cnt_del==0)
	BRNE _0x78
;     535 			{
;     536           	step=s3;
	CALL SUBOPT_0x4
;     537           	cnt_del=50;
;     538 			}
;     539 		}
_0x78:
;     540 
;     541 	else if(step==s3)
	RJMP _0x79
_0x77:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0x7A
;     542 		{
;     543 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(220)
;     544           cnt_del--;
	CALL SUBOPT_0x3
;     545           if(cnt_del==0)
	BRNE _0x7B
;     546 			{
;     547           	step=s4;
	LDI  R30,LOW(4)
	MOV  R13,R30
;     548 			}
;     549 		}
_0x7B:
;     550 	else if(step==s4)
	RJMP _0x7C
_0x7A:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0x7D
;     551 		{
;     552 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
	ORI  R16,LOW(220)
;     553           if(!bMD2)goto step_contr_end;
	SBRS R3,3
	RJMP _0x6E
;     554           step=s5;
	CALL SUBOPT_0x5
;     555           cnt_del=20;
;     556 		}
;     557 	else if(step==s5)
	RJMP _0x7F
_0x7D:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0x80
;     558 		{
;     559 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(220)
;     560           cnt_del--;
	CALL SUBOPT_0x3
;     561           if(cnt_del==0)
	BRNE _0x81
;     562 			{
;     563           	step=s6;
	LDI  R30,LOW(6)
	MOV  R13,R30
;     564 			}
;     565           }
_0x81:
;     566 	else if(step==s6)
	RJMP _0x82
_0x80:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0x83
;     567 		{
;     568 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
	ORI  R16,LOW(220)
;     569  //         if(!bMD3)goto step_contr_end;
;     570           step=s7;
	CALL SUBOPT_0x6
;     571           cnt_del=20;
;     572 		}
;     573 
;     574 	else if(step==s7)
	RJMP _0x84
_0x83:
	LDI  R30,LOW(7)
	CP   R30,R13
	BRNE _0x85
;     575 		{
;     576 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(220)
;     577           cnt_del--;
	CALL SUBOPT_0x3
;     578           if(cnt_del==0)
	BRNE _0x86
;     579 			{
;     580           	step=s8;
	LDI  R30,LOW(8)
	CALL SUBOPT_0x7
;     581           	cnt_del=ee_delay[prog,0]*10U;;
;     582 			}
;     583           }
_0x86:
;     584 	else if(step==s8)
	RJMP _0x87
_0x85:
	LDI  R30,LOW(8)
	CP   R30,R13
	BRNE _0x88
;     585 		{
;     586 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;     587           cnt_del--;
	CALL SUBOPT_0x3
;     588           if(cnt_del==0)
	BRNE _0x89
;     589 			{
;     590           	step=s9;
	LDI  R30,LOW(9)
	CALL SUBOPT_0x8
;     591           	cnt_del=20;
;     592 			}
;     593           }
_0x89:
;     594 	else if(step==s9)
	RJMP _0x8A
_0x88:
	LDI  R30,LOW(9)
	CP   R30,R13
	BRNE _0x8B
;     595 		{
;     596 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     597           cnt_del--;
	CALL SUBOPT_0x3
;     598           if(cnt_del==0)
	BRNE _0x8C
;     599 			{
;     600           	step=sOFF;
	CLR  R13
;     601           	}
;     602           }
_0x8C:
;     603 	}
_0x8B:
_0x8A:
_0x87:
_0x84:
_0x82:
_0x7F:
_0x7C:
_0x79:
_0x76:
_0x73:
;     604 
;     605 else if(prog==p2)  //ско
	RJMP _0x8D
_0x70:
	LDI  R30,LOW(2)
	CP   R30,R12
	BREQ PC+3
	JMP _0x8E
;     606 	{
;     607 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0x8F
;     608 		{
;     609 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     610           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x6E
;     611 
;     612 		/*	if(ee_vacuum_mode==evmOFF)
;     613 				{
;     614 				goto lbl_0002;
;     615 				}
;     616 			else step=s2; */
;     617 
;     618           //step=s2;
;     619 		}
;     620 
;     621 	else if(step==s2)
	RJMP _0x91
_0x8F:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0x92
;     622 		{
;     623 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(200)
;     624  //         if(!bVR)goto step_contr_end;
;     625 
;     626 lbl_0002:
;     627           step=s100;
	CALL SUBOPT_0x2
;     628 		cnt_del=40;
;     629           }
;     630 	else if(step==s100)
	RJMP _0x94
_0x92:
	LDI  R30,LOW(19)
	CP   R30,R13
	BRNE _0x95
;     631 		{
;     632 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(216)
;     633           cnt_del--;
	CALL SUBOPT_0x3
;     634           if(cnt_del==0)
	BRNE _0x96
;     635 			{
;     636           	step=s3;
	CALL SUBOPT_0x4
;     637           	cnt_del=50;
;     638 			}
;     639 		}
_0x96:
;     640 	else if(step==s3)
	RJMP _0x97
_0x95:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0x98
;     641 		{
;     642 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(220)
;     643           cnt_del--;
	CALL SUBOPT_0x3
;     644           if(cnt_del==0)
	BRNE _0x99
;     645 			{
;     646           	step=s4;
	LDI  R30,LOW(4)
	MOV  R13,R30
;     647 			}
;     648 		}
_0x99:
;     649 	else if(step==s4)
	RJMP _0x9A
_0x98:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0x9B
;     650 		{
;     651 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
	ORI  R16,LOW(220)
;     652           if(!bMD2)goto step_contr_end;
	SBRS R3,3
	RJMP _0x6E
;     653           step=s5;
	CALL SUBOPT_0x5
;     654           cnt_del=20;
;     655 		}
;     656 	else if(step==s5)
	RJMP _0x9D
_0x9B:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0x9E
;     657 		{
;     658 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(220)
;     659           cnt_del--;
	CALL SUBOPT_0x3
;     660           if(cnt_del==0)
	BRNE _0x9F
;     661 			{
;     662           	step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x7
;     663           	cnt_del=ee_delay[prog,0]*10U;
;     664 			}
;     665           }
_0x9F:
;     666 	else if(step==s6)
	RJMP _0xA0
_0x9E:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0xA1
;     667 		{
;     668 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;     669           cnt_del--;
	CALL SUBOPT_0x3
;     670           if(cnt_del==0)
	BRNE _0xA2
;     671 			{
;     672           	step=s7;
	CALL SUBOPT_0x6
;     673           	cnt_del=20;
;     674 			}
;     675           }
_0xA2:
;     676 	else if(step==s7)
	RJMP _0xA3
_0xA1:
	LDI  R30,LOW(7)
	CP   R30,R13
	BRNE _0xA4
;     677 		{
;     678 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     679           cnt_del--;
	CALL SUBOPT_0x3
;     680           if(cnt_del==0)
	BRNE _0xA5
;     681 			{
;     682           	step=sOFF;
	CLR  R13
;     683           	}
;     684           }
_0xA5:
;     685 	}
_0xA4:
_0xA3:
_0xA0:
_0x9D:
_0x9A:
_0x97:
_0x94:
_0x91:
;     686 
;     687 else if(prog==p3)   //твист
	RJMP _0xA6
_0x8E:
	LDI  R30,LOW(3)
	CP   R30,R12
	BREQ PC+3
	JMP _0xA7
;     688 	{
;     689 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0xA8
;     690 		{
;     691 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     692           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x6E
;     693 
;     694 		/*	if(ee_vacuum_mode==evmOFF)
;     695 				{
;     696 				goto lbl_0003;
;     697 				}
;     698 			else step=s2;*/
;     699 
;     700           //step=s2;
;     701 		}
;     702 
;     703 	else if(step==s2)
	RJMP _0xAA
_0xA8:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0xAB
;     704 		{
;     705 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(200)
;     706  //         if(!bVR)goto step_contr_end;
;     707 lbl_0003:
;     708           cnt_del=50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;     709 		step=s3;
	LDI  R30,LOW(3)
	MOV  R13,R30
;     710 		}
;     711 
;     712 
;     713 	else	if(step==s3)
	RJMP _0xAD
_0xAB:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0xAE
;     714 		{
;     715 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(216)
;     716 		cnt_del--;
	CALL SUBOPT_0x3
;     717 		if(cnt_del==0)
	BRNE _0xAF
;     718 			{
;     719 			cnt_del=ee_delay[prog,0]*10U;
	CALL SUBOPT_0x9
	ADD  R26,R30
	ADC  R27,R31
	CALL SUBOPT_0xA
;     720 			step=s4;
	LDI  R30,LOW(4)
	MOV  R13,R30
;     721 			}
;     722           }
_0xAF:
;     723 	else if(step==s4)
	RJMP _0xB0
_0xAE:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0xB1
;     724 		{
;     725 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
	ORI  R16,LOW(220)
;     726 		cnt_del--;
	CALL SUBOPT_0x3
;     727  		if(cnt_del==0)
	BRNE _0xB2
;     728 			{
;     729 			cnt_del=ee_delay[prog,1]*10U;
	CALL SUBOPT_0x9
	CALL SUBOPT_0xB
;     730 			step=s5;
	LDI  R30,LOW(5)
	MOV  R13,R30
;     731 			}
;     732 		}
_0xB2:
;     733 
;     734 	else if(step==s5)
	RJMP _0xB3
_0xB1:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0xB4
;     735 		{
;     736 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
	ORI  R16,LOW(204)
;     737 		cnt_del--;
	CALL SUBOPT_0x3
;     738 		if(cnt_del==0)
	BRNE _0xB5
;     739 			{
;     740 			step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x8
;     741 			cnt_del=20;
;     742 			}
;     743 		}
_0xB5:
;     744 
;     745 	else if(step==s6)
	RJMP _0xB6
_0xB4:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0xB7
;     746 		{
;     747 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     748   		cnt_del--;
	CALL SUBOPT_0x3
;     749 		if(cnt_del==0)
	BRNE _0xB8
;     750 			{
;     751 			step=sOFF;
	CLR  R13
;     752 			}
;     753 		}
_0xB8:
;     754 
;     755 	}
_0xB7:
_0xB6:
_0xB3:
_0xB0:
_0xAD:
_0xAA:
;     756 
;     757 else if(prog==p4)      //замок
	RJMP _0xB9
_0xA7:
	LDI  R30,LOW(4)
	CP   R30,R12
	BREQ PC+3
	JMP _0xBA
;     758 	{
;     759 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0xBB
;     760 		{
;     761 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     762           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x6E
;     763 
;     764 		 /*	if(ee_vacuum_mode==evmOFF)
;     765 				{
;     766 				goto lbl_0004;
;     767 				}
;     768 			else step=s2;*/
;     769           //step=s2;
;     770 		}
;     771 
;     772 	else if(step==s2)
	RJMP _0xBD
_0xBB:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0xBE
;     773 		{
;     774 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(200)
;     775  //         if(!bVR)goto step_contr_end;
;     776 lbl_0004:
;     777           step=s3;
	CALL SUBOPT_0x4
;     778 		cnt_del=50;
;     779           }
;     780 
;     781 	else if(step==s3)
	RJMP _0xC0
_0xBE:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0xC1
;     782 		{
;     783 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(216)
;     784           cnt_del--;
	CALL SUBOPT_0x3
;     785           if(cnt_del==0)
	BRNE _0xC2
;     786 			{
;     787           	step=s4;
	LDI  R30,LOW(4)
	CALL SUBOPT_0x7
;     788 			cnt_del=ee_delay[prog,0]*10U;
;     789 			}
;     790           }
_0xC2:
;     791 
;     792    	else if(step==s4)
	RJMP _0xC3
_0xC1:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0xC4
;     793 		{
;     794 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;     795 		cnt_del--;
	CALL SUBOPT_0x3
;     796 		if(cnt_del==0)
	BRNE _0xC5
;     797 			{
;     798 			step=s5;
	LDI  R30,LOW(5)
	MOV  R13,R30
;     799 			cnt_del=30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;     800 			}
;     801 		}
_0xC5:
;     802 
;     803 	else if(step==s5)
	RJMP _0xC6
_0xC4:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0xC7
;     804 		{
;     805 		temp|=(1<<PP1)|(1<<PP4);
	ORI  R16,LOW(80)
;     806 		cnt_del--;
	CALL SUBOPT_0x3
;     807 		if(cnt_del==0)
	BRNE _0xC8
;     808 			{
;     809 			step=s6;
	LDI  R30,LOW(6)
	MOV  R13,R30
;     810 			cnt_del=ee_delay[prog,1]*10U;
	CALL SUBOPT_0x9
	CALL SUBOPT_0xB
;     811 			}
;     812 		}
_0xC8:
;     813 
;     814 	else if(step==s6)
	RJMP _0xC9
_0xC7:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0xCA
;     815 		{
;     816 		temp|=(1<<PP4);
	ORI  R16,LOW(16)
;     817 		cnt_del--;
	CALL SUBOPT_0x3
;     818 		if(cnt_del==0)
	BRNE _0xCB
;     819 			{
;     820 			step=sOFF;
	CLR  R13
;     821 			}
;     822 		}
_0xCB:
;     823 
;     824 	}
_0xCA:
_0xC9:
_0xC6:
_0xC3:
_0xC0:
_0xBD:
;     825 	
;     826 step_contr_end:
_0xBA:
_0xB9:
_0xA6:
_0x8D:
_0x6E:
;     827 
;     828 //if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;     829 
;     830 PORTB=~temp;
	MOV  R30,R16
	COM  R30
	OUT  0x18,R30
;     831 //PORTB=0x55;
;     832 }
	LD   R16,Y+
	RET
;     833 
;     834 
;     835 //-----------------------------------------------
;     836 void bin2bcd_int(unsigned int in)
;     837 {
_bin2bcd_int:
;     838 char i;
;     839 for(i=3;i>0;i--)
	ST   -Y,R16
;	in -> Y+1
;	i -> R16
	LDI  R16,LOW(3)
_0xCD:
	LDI  R30,LOW(0)
	CP   R30,R16
	BRSH _0xCE
;     840 	{
;     841 	dig[i]=in%10;
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
;     842 	in/=10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
;     843 	}   
	SUBI R16,1
	RJMP _0xCD
_0xCE:
;     844 }
	LDD  R16,Y+0
	RJMP _0x12F
;     845 
;     846 //-----------------------------------------------
;     847 void bcd2ind(char s)
;     848 {
_bcd2ind:
;     849 char i;
;     850 bZ=1;
	ST   -Y,R16
;	s -> Y+1
;	i -> R16
	SET
	BLD  R2,3
;     851 for (i=0;i<5;i++)
	LDI  R16,LOW(0)
_0xD0:
	CPI  R16,5
	BRLO PC+3
	JMP _0xD1
;     852 	{
;     853 	if(bZ&&(!dig[i-1])&&(i<4))
	SBRS R2,3
	RJMP _0xD3
	CALL SUBOPT_0xC
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	CPI  R30,0
	BRNE _0xD3
	CPI  R16,4
	BRLO _0xD4
_0xD3:
	RJMP _0xD2
_0xD4:
;     854 		{
;     855 		if((4-i)>s)
	LDI  R30,LOW(4)
	SUB  R30,R16
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
	BRSH _0xD5
;     856 			{
;     857 			ind_out[i-1]=DIGISYM[10];
	CALL SUBOPT_0xC
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	POP  R26
	POP  R27
	RJMP _0x130
;     858 			}
;     859 		else ind_out[i-1]=DIGISYM[0];	
_0xD5:
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
_0x130:
	ST   X,R30
;     860 		}
;     861 	else
	RJMP _0xD7
_0xD2:
;     862 		{
;     863 		ind_out[i-1]=DIGISYM[dig[i-1]];
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
;     864 		bZ=0;
	CLT
	BLD  R2,3
;     865 		}                   
_0xD7:
;     866 
;     867 	if(s)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0xD8
;     868 		{
;     869 		ind_out[3-s]&=0b01111111;
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
;     870 		}	
;     871  
;     872 	}
_0xD8:
	SUBI R16,-1
	RJMP _0xD0
_0xD1:
;     873 }            
	LDD  R16,Y+0
	ADIW R28,2
	RET
;     874 //-----------------------------------------------
;     875 void int2ind(unsigned int in,char s)
;     876 {
_int2ind:
;     877 bin2bcd_int(in);
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _bin2bcd_int
;     878 bcd2ind(s);
	LD   R30,Y
	ST   -Y,R30
	CALL _bcd2ind
;     879 
;     880 } 
_0x12F:
	ADIW R28,3
	RET
;     881 
;     882 //-----------------------------------------------
;     883 void ind_hndl(void)
;     884 {
_ind_hndl:
;     885 int2ind(bDM,0);
	LDI  R30,0
	SBRC R3,6
	LDI  R30,1
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _int2ind
;     886 //int2ind(ee_delay[prog,sub_ind],1);  
;     887 //ind_out[0]=0xff;//DIGISYM[0];
;     888 //ind_out[1]=0xff;//DIGISYM[1];
;     889 //ind_out[2]=DIGISYM[2];//0xff;
;     890 //ind_out[0]=DIGISYM[7]; 
;     891 
;     892 ind_out[0]=DIGISYM[sub_ind+1];
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
;     893 }
	RET
;     894 
;     895 //-----------------------------------------------
;     896 void led_hndl(void)
;     897 {
_led_hndl:
;     898 ind_out[4]=DIGISYM[10]; 
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	__PUTB1MN _ind_out,4
;     899 
;     900 ind_out[4]&=~(1<<LED_POW_ON); 
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xDF
	POP  R26
	POP  R27
	ST   X,R30
;     901 
;     902 if(step!=sOFF)
	TST  R13
	BREQ _0xD9
;     903 	{
;     904 	ind_out[4]&=~(1<<LED_WRK);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xBF
	POP  R26
	POP  R27
	RJMP _0x131
;     905 	}
;     906 else ind_out[4]|=(1<<LED_WRK);
_0xD9:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x40
	POP  R26
	POP  R27
_0x131:
	ST   X,R30
;     907 
;     908 
;     909 if(step==sOFF)
	TST  R13
	BRNE _0xDB
;     910 	{
;     911  	if(bERR)
	SBRS R3,1
	RJMP _0xDC
;     912 		{
;     913 		ind_out[4]&=~(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFE
	POP  R26
	POP  R27
	RJMP _0x132
;     914 		}
;     915 	else
_0xDC:
;     916 		{
;     917 		ind_out[4]|=(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
_0x132:
	ST   X,R30
;     918 		}
;     919      }
;     920 else ind_out[4]|=(1<<LED_ERROR);
	RJMP _0xDE
_0xDB:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
	ST   X,R30
_0xDE:
;     921 
;     922 /* 	if(bMD1)
;     923 		{
;     924 		ind_out[4]&=~(1<<LED_ERROR);
;     925 		}
;     926 	else
;     927 		{
;     928 		ind_out[4]|=(1<<LED_ERROR);
;     929 		} */
;     930 
;     931 //if(bERR)ind_out[4]&=~(1<<LED_ERROR);
;     932 if(ee_loop_mode==elmAUTO)ind_out[4]&=~(1<<LED_LOOP_AUTO);
	LDI  R26,LOW(_ee_loop_mode)
	LDI  R27,HIGH(_ee_loop_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0xDF
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0x7F
	POP  R26
	POP  R27
	RJMP _0x133
;     933 else ind_out[4]|=(1<<LED_LOOP_AUTO);
_0xDF:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x80
	POP  R26
	POP  R27
_0x133:
	ST   X,R30
;     934 
;     935 if(prog==p1) ind_out[4]&=~(1<<LED_PROG1);
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0xE1
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xEF
	POP  R26
	POP  R27
	ST   X,R30
;     936 else if(prog==p2) ind_out[4]&=~(1<<LED_PROG2);
	RJMP _0xE2
_0xE1:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0xE3
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFB
	POP  R26
	POP  R27
	ST   X,R30
;     937 else if(prog==p3) ind_out[4]&=~(1<<LED_PROG3);
	RJMP _0xE4
_0xE3:
	LDI  R30,LOW(3)
	CP   R30,R12
	BRNE _0xE5
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0XF7
	POP  R26
	POP  R27
	ST   X,R30
;     938 else if(prog==p4) ind_out[4]&=~(1<<LED_PROG4);
	RJMP _0xE6
_0xE5:
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0xE7
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFD
	POP  R26
	POP  R27
	ST   X,R30
;     939 
;     940 if(ind==iPr_sel)
_0xE7:
_0xE6:
_0xE4:
_0xE2:
	LDI  R30,LOW(1)
	CP   R30,R14
	BRNE _0xE8
;     941 	{
;     942 	if(bFL5)ind_out[4]|=(1<<LED_PROG1)|(1<<LED_PROG2)|(1<<LED_PROG3)|(1<<LED_PROG4);
	SBRS R3,0
	RJMP _0xE9
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,LOW(0x1E)
	POP  R26
	POP  R27
	ST   X,R30
;     943 	} 
_0xE9:
;     944 	 
;     945 if(ind==iVr)
_0xE8:
	LDI  R30,LOW(2)
	CP   R30,R14
	BRNE _0xEA
;     946 	{
;     947 	if(bFL5)ind_out[4]|=(1<<LED_POW_ON);
	SBRS R3,0
	RJMP _0xEB
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x20
	POP  R26
	POP  R27
	ST   X,R30
;     948 	}	
_0xEB:
;     949 }
_0xEA:
	RET
;     950 
;     951 //-----------------------------------------------
;     952 // Подпрограмма драйва до 7 кнопок одного порта, 
;     953 // различает короткое и длинное нажатие,
;     954 // срабатывает на отпускание кнопки, возможность
;     955 // ускорения перебора при длинном нажатии...
;     956 #define but_port PORTC
;     957 #define but_dir  DDRC
;     958 #define but_pin  PINC
;     959 #define but_mask 0b01101010
;     960 #define no_but   0b11111111
;     961 #define but_on   5
;     962 #define but_onL  20
;     963 
;     964 
;     965 
;     966 
;     967 void but_drv(void)
;     968 { 
_but_drv:
;     969 DDRD&=0b00000111;
	IN   R30,0x11
	ANDI R30,LOW(0x7)
	CALL SUBOPT_0xE
;     970 PORTD|=0b11111000;
;     971 
;     972 but_port|=(but_mask^0xff);
	CALL SUBOPT_0xF
;     973 but_dir&=but_mask;
;     974 #asm
;     975 nop
nop
;     976 nop
nop
;     977 nop
nop
;     978 nop
nop
;     979 #endasm

;     980 
;     981 but_n=but_pin|but_mask; 
	IN   R30,0x13
	ORI  R30,LOW(0x6A)
	STS  _but_n_G1,R30
;     982 
;     983 if((but_n==no_but)||(but_n!=but_s))
	LDS  R26,_but_n_G1
	CPI  R26,LOW(0xFF)
	BREQ _0xED
	RCALL SUBOPT_0x10
	BREQ _0xEC
_0xED:
;     984  	{
;     985  	speed=0;
	CLT
	BLD  R2,6
;     986    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRSH _0xF0
	LDS  R26,_but1_cnt_G1
	CPI  R26,LOW(0x0)
	BREQ _0xF2
_0xF0:
	SBRS R2,4
	RJMP _0xF3
_0xF2:
	RJMP _0xEF
_0xF3:
;     987   		{
;     988    	     n_but=1;
	SET
	BLD  R2,5
;     989           but=but_s;
	LDS  R11,_but_s_G1
;     990           }
;     991    	if (but1_cnt>=but_onL_temp)
_0xEF:
	RCALL SUBOPT_0x11
	BRLO _0xF4
;     992   		{
;     993    	     n_but=1;
	SET
	BLD  R2,5
;     994           but=but_s&0b11111101;
	RCALL SUBOPT_0x12
;     995           }
;     996     	l_but=0;
_0xF4:
	CLT
	BLD  R2,4
;     997    	but_onL_temp=but_onL;
	LDI  R30,LOW(20)
	STS  _but_onL_temp_G1,R30
;     998     	but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;     999   	but1_cnt=0;          
	STS  _but1_cnt_G1,R30
;    1000      goto but_drv_out;
	RJMP _0xF5
;    1001   	}  
;    1002   	
;    1003 if(but_n==but_s)
_0xEC:
	RCALL SUBOPT_0x10
	BRNE _0xF6
;    1004  	{
;    1005   	but0_cnt++;
	LDS  R30,_but0_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but0_cnt_G1,R30
;    1006   	if(but0_cnt>=but_on)
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRLO _0xF7
;    1007   		{
;    1008    		but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    1009    		but1_cnt++;
	LDS  R30,_but1_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but1_cnt_G1,R30
;    1010    		if(but1_cnt>=but_onL_temp)
	RCALL SUBOPT_0x11
	BRLO _0xF8
;    1011    			{              
;    1012     			but=but_s&0b11111101;
	RCALL SUBOPT_0x12
;    1013     			but1_cnt=0;
	LDI  R30,LOW(0)
	STS  _but1_cnt_G1,R30
;    1014     			n_but=1;
	SET
	BLD  R2,5
;    1015     			l_but=1;
	SET
	BLD  R2,4
;    1016 			if(speed)
	SBRS R2,6
	RJMP _0xF9
;    1017 				{
;    1018     				but_onL_temp=but_onL_temp>>1;
	LDS  R30,_but_onL_temp_G1
	LSR  R30
	STS  _but_onL_temp_G1,R30
;    1019         			if(but_onL_temp<=2) but_onL_temp=2;
	LDS  R26,_but_onL_temp_G1
	LDI  R30,LOW(2)
	CP   R30,R26
	BRLO _0xFA
	STS  _but_onL_temp_G1,R30
;    1020 				}    
_0xFA:
;    1021    			}
_0xF9:
;    1022   		} 
_0xF8:
;    1023  	}
_0xF7:
;    1024 but_drv_out:
_0xF6:
_0xF5:
;    1025 but_s=but_n;
	LDS  R30,_but_n_G1
	STS  _but_s_G1,R30
;    1026 but_port|=(but_mask^0xff);
	RCALL SUBOPT_0xF
;    1027 but_dir&=but_mask;
;    1028 }    
	RET
;    1029 
;    1030 #define butV	239
;    1031 #define butV_	237
;    1032 #define butP	251
;    1033 #define butP_	249
;    1034 #define butR	127
;    1035 #define butR_	125
;    1036 #define butL	254
;    1037 #define butL_	252
;    1038 #define butLR	126
;    1039 #define butLR_	124 
;    1040 #define butVP_ 233
;    1041 //-----------------------------------------------
;    1042 void but_an(void)
;    1043 {
_but_an:
;    1044 /*
;    1045 if(!(in_word&0x01))
;    1046 	{
;    1047 	#ifdef TVIST_SKO
;    1048 	if((step==sOFF)&&(!bERR))
;    1049 		{
;    1050 		step=s1;
;    1051 		if(prog==p2) cnt_del=70;
;    1052 		else if(prog==p3) cnt_del=100;
;    1053 		}
;    1054 	#endif
;    1055 	#ifdef DV3KL2MD
;    1056 	if((step==sOFF)&&(!bERR))
;    1057 		{
;    1058 		step=s1;
;    1059 		cnt_del=70;
;    1060 		}
;    1061 	#endif	
;    1062 	#ifndef TVIST_SKO
;    1063 	if((step==sOFF)&&(!bERR))
;    1064 		{
;    1065 		step=s1;
;    1066 		if(prog==p1) cnt_del=50;
;    1067 		else if(prog==p2) cnt_del=50;
;    1068 		else if(prog==p3) cnt_del=50;
;    1069           #ifdef P380_MINI
;    1070   		cnt_del=100;
;    1071   		#endif
;    1072 		}
;    1073 	#endif
;    1074 	}
;    1075 if(!(in_word&0x02))
;    1076 	{
;    1077 	step=sOFF;
;    1078 
;    1079 	} */
;    1080 
;    1081 if (!n_but) goto but_an_end;
	SBRS R2,5
	RJMP _0xFC
;    1082 
;    1083 if(but==butV_)
	LDI  R30,LOW(237)
	CP   R30,R11
	BRNE _0xFD
;    1084 	{
;    1085 	if(ee_loop_mode!=elmAUTO)ee_loop_mode=elmAUTO;
	LDI  R26,LOW(_ee_loop_mode)
	LDI  R27,HIGH(_ee_loop_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BREQ _0xFE
	LDI  R30,LOW(85)
	RJMP _0x134
;    1086 	else ee_loop_mode=elmMNL;
_0xFE:
	LDI  R30,LOW(170)
_0x134:
	LDI  R26,LOW(_ee_loop_mode)
	LDI  R27,HIGH(_ee_loop_mode)
	CALL __EEPROMWRB
;    1087 	}
;    1088 
;    1089 if(but==butVP_)
_0xFD:
	LDI  R30,LOW(233)
	CP   R30,R11
	BRNE _0x100
;    1090 	{
;    1091 	if(ind!=iVr)ind=iVr;
	LDI  R30,LOW(2)
	CP   R30,R14
	BREQ _0x101
	MOV  R14,R30
;    1092 	else ind=iMn;
	RJMP _0x102
_0x101:
	CLR  R14
_0x102:
;    1093 	}
;    1094 
;    1095 	
;    1096 if(ind==iMn)
_0x100:
	TST  R14
	BRNE _0x103
;    1097 	{
;    1098 	if(but==butP_)ind=iPr_sel;
	LDI  R30,LOW(249)
	CP   R30,R11
	BRNE _0x104
	LDI  R30,LOW(1)
	MOV  R14,R30
;    1099 	if(but==butLR)	
_0x104:
	LDI  R30,LOW(126)
	CP   R30,R11
	BRNE _0x105
;    1100 		{
;    1101 		if((prog==p3)||(prog==p4))
	LDI  R30,LOW(3)
	CP   R30,R12
	BREQ _0x107
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0x106
_0x107:
;    1102 			{ 
;    1103 			if(sub_ind==0)sub_ind=1;
	LDS  R30,_sub_ind
	CPI  R30,0
	BRNE _0x109
	LDI  R30,LOW(1)
	RJMP _0x135
;    1104 			else sub_ind=0;
_0x109:
	LDI  R30,LOW(0)
_0x135:
	STS  _sub_ind,R30
;    1105 			}
;    1106     		else sub_ind=0;
	RJMP _0x10B
_0x106:
	LDI  R30,LOW(0)
	STS  _sub_ind,R30
_0x10B:
;    1107 		}	 
;    1108 	if((but==butR)||(but==butR_))	
_0x105:
	LDI  R30,LOW(127)
	CP   R30,R11
	BREQ _0x10D
	LDI  R30,LOW(125)
	CP   R30,R11
	BRNE _0x10C
_0x10D:
;    1109 		{  
;    1110 		speed=1;
	SET
	BLD  R2,6
;    1111 		ee_delay[prog,sub_ind]++;
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x13
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    1112 		}   
;    1113 	
;    1114 	else if((but==butL)||(but==butL_))	
	RJMP _0x10F
_0x10C:
	LDI  R30,LOW(254)
	CP   R30,R11
	BREQ _0x111
	LDI  R30,LOW(252)
	CP   R30,R11
	BRNE _0x110
_0x111:
;    1115 		{  
;    1116     		speed=1;
	SET
	BLD  R2,6
;    1117     		ee_delay[prog,sub_ind]--;
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x13
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    1118     		}		
;    1119 	} 
_0x110:
_0x10F:
;    1120 	
;    1121 else if(ind==iPr_sel)
	RJMP _0x113
_0x103:
	LDI  R30,LOW(1)
	CP   R30,R14
	BRNE _0x114
;    1122 	{
;    1123 	if(but==butP_)ind=iMn;
	LDI  R30,LOW(249)
	CP   R30,R11
	BRNE _0x115
	CLR  R14
;    1124 	if(but==butP)
_0x115:
	LDI  R30,LOW(251)
	CP   R30,R11
	BRNE _0x116
;    1125 		{
;    1126 		prog++;
	RCALL SUBOPT_0x14
;    1127 		if(prog>MAXPROG)prog=MINPROG;
	BRGE _0x117
	LDI  R30,LOW(2)
	MOV  R12,R30
;    1128 		ee_program[0]=prog;
_0x117:
	RCALL SUBOPT_0x15
;    1129 		ee_program[1]=prog;
	__POINTW2MN _ee_program,1
	MOV  R30,R12
	CALL __EEPROMWRB
;    1130 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R12
	CALL __EEPROMWRB
;    1131 		}
;    1132 	
;    1133 	if(but==butR)
_0x116:
	LDI  R30,LOW(127)
	CP   R30,R11
	BRNE _0x118
;    1134 		{
;    1135 		prog++;
	RCALL SUBOPT_0x14
;    1136 		if(prog>MAXPROG)prog=MINPROG;
	BRGE _0x119
	LDI  R30,LOW(2)
	MOV  R12,R30
;    1137 		ee_program[0]=prog;
_0x119:
	RCALL SUBOPT_0x15
;    1138 		ee_program[1]=prog;
	__POINTW2MN _ee_program,1
	MOV  R30,R12
	CALL __EEPROMWRB
;    1139 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R12
	CALL __EEPROMWRB
;    1140 		}
;    1141 
;    1142 	if(but==butL)
_0x118:
	LDI  R30,LOW(254)
	CP   R30,R11
	BRNE _0x11A
;    1143 		{
;    1144 		prog--;
	DEC  R12
;    1145 		if(prog>MAXPROG)prog=MINPROG;
	LDI  R30,LOW(3)
	CP   R30,R12
	BRGE _0x11B
	LDI  R30,LOW(2)
	MOV  R12,R30
;    1146 		ee_program[0]=prog;
_0x11B:
	RCALL SUBOPT_0x15
;    1147 		ee_program[1]=prog;
	__POINTW2MN _ee_program,1
	MOV  R30,R12
	CALL __EEPROMWRB
;    1148 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R12
	CALL __EEPROMWRB
;    1149 		}	
;    1150 	} 
_0x11A:
;    1151 
;    1152 else if(ind==iVr)
	RJMP _0x11C
_0x114:
	LDI  R30,LOW(2)
	CP   R30,R14
	BRNE _0x11D
;    1153 	{
;    1154 	if(but==butP_)
	LDI  R30,LOW(249)
	CP   R30,R11
	BRNE _0x11E
;    1155 		{
;    1156 		if(ee_vr_log)ee_vr_log=0;
	LDI  R26,LOW(_ee_vr_log)
	LDI  R27,HIGH(_ee_vr_log)
	CALL __EEPROMRDB
	CPI  R30,0
	BREQ _0x11F
	LDI  R30,LOW(0)
	RJMP _0x136
;    1157 		else ee_vr_log=1;
_0x11F:
	LDI  R30,LOW(1)
_0x136:
	LDI  R26,LOW(_ee_vr_log)
	LDI  R27,HIGH(_ee_vr_log)
	CALL __EEPROMWRB
;    1158 		}	
;    1159 	} 	
_0x11E:
;    1160 
;    1161 but_an_end:
_0x11D:
_0x11C:
_0x113:
_0xFC:
;    1162 n_but=0;
	CLT
	BLD  R2,5
;    1163 }
	RET
;    1164 
;    1165 //-----------------------------------------------
;    1166 void ind_drv(void)
;    1167 {
_ind_drv:
;    1168 if(++ind_cnt>=6)ind_cnt=0;
	INC  R10
	LDI  R30,LOW(6)
	CP   R10,R30
	BRLO _0x121
	CLR  R10
;    1169 
;    1170 if(ind_cnt<5)
_0x121:
	LDI  R30,LOW(5)
	CP   R10,R30
	BRSH _0x122
;    1171 	{
;    1172 	DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
;    1173 	PORTC=0xFF;
	OUT  0x15,R30
;    1174 	DDRD|=0b11111000;
	IN   R30,0x11
	ORI  R30,LOW(0xF8)
	RCALL SUBOPT_0xE
;    1175 	PORTD|=0b11111000;
;    1176 	PORTD&=IND_STROB[ind_cnt];
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
;    1177 	PORTC=ind_out[ind_cnt];
	MOV  R30,R10
	LDI  R31,0
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	LD   R30,Z
	OUT  0x15,R30
;    1178 	}
;    1179 else but_drv();
	RJMP _0x123
_0x122:
	CALL _but_drv
_0x123:
;    1180 }
	RET
;    1181 
;    1182 //***********************************************
;    1183 //***********************************************
;    1184 //***********************************************
;    1185 //***********************************************
;    1186 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;    1187 {
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
;    1188 TCCR0=0x02;
	RCALL SUBOPT_0x16
;    1189 TCNT0=-208;
;    1190 OCR0=0x00; 
;    1191 
;    1192 
;    1193 b600Hz=1;
	SET
	BLD  R2,0
;    1194 ind_drv();
	RCALL _ind_drv
;    1195 if(++t0_cnt0>=6)
	INC  R6
	LDI  R30,LOW(6)
	CP   R6,R30
	BRLO _0x124
;    1196 	{
;    1197 	t0_cnt0=0;
	CLR  R6
;    1198 	b100Hz=1;
	SET
	BLD  R2,1
;    1199 	}
;    1200 
;    1201 if(++t0_cnt1>=60)
_0x124:
	INC  R7
	LDI  R30,LOW(60)
	CP   R7,R30
	BRLO _0x125
;    1202 	{
;    1203 	t0_cnt1=0;
	CLR  R7
;    1204 	b10Hz=1;
	SET
	BLD  R2,2
;    1205 	
;    1206 	if(++t0_cnt2>=2)
	INC  R8
	LDI  R30,LOW(2)
	CP   R8,R30
	BRLO _0x126
;    1207 		{
;    1208 		t0_cnt2=0;
	CLR  R8
;    1209 		bFL5=!bFL5;
	LDI  R30,LOW(1)
	EOR  R3,R30
;    1210 		}
;    1211 		
;    1212 	if(++t0_cnt3>=5)
_0x126:
	INC  R9
	LDI  R30,LOW(5)
	CP   R9,R30
	BRLO _0x127
;    1213 		{
;    1214 		t0_cnt3=0;
	CLR  R9
;    1215 		bFL2=!bFL2;
	LDI  R30,LOW(128)
	EOR  R2,R30
;    1216 		}		
;    1217 	}
_0x127:
;    1218 }
_0x125:
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
;    1219 
;    1220 //===============================================
;    1221 //===============================================
;    1222 //===============================================
;    1223 //===============================================
;    1224 
;    1225 void main(void)
;    1226 {
_main:
;    1227 
;    1228 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
;    1229 DDRA=0x00;
	RCALL SUBOPT_0x0
;    1230 
;    1231 PORTB=0xff;
	RCALL SUBOPT_0x17
;    1232 DDRB=0xFF;
;    1233 
;    1234 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;    1235 DDRC=0x00;
	OUT  0x14,R30
;    1236 
;    1237 
;    1238 PORTD=0x00;
	OUT  0x12,R30
;    1239 DDRD=0x00;
	OUT  0x11,R30
;    1240 
;    1241 
;    1242 TCCR0=0x02;
	RCALL SUBOPT_0x16
;    1243 TCNT0=-208;
;    1244 OCR0=0x00;
;    1245 
;    1246 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;    1247 TCCR1B=0x00;
	OUT  0x2E,R30
;    1248 TCNT1H=0x00;
	OUT  0x2D,R30
;    1249 TCNT1L=0x00;
	OUT  0x2C,R30
;    1250 ICR1H=0x00;
	OUT  0x27,R30
;    1251 ICR1L=0x00;
	OUT  0x26,R30
;    1252 OCR1AH=0x00;
	OUT  0x2B,R30
;    1253 OCR1AL=0x00;
	OUT  0x2A,R30
;    1254 OCR1BH=0x00;
	OUT  0x29,R30
;    1255 OCR1BL=0x00;
	OUT  0x28,R30
;    1256 
;    1257 
;    1258 ASSR=0x00;
	OUT  0x22,R30
;    1259 TCCR2=0x00;
	OUT  0x25,R30
;    1260 TCNT2=0x00;
	OUT  0x24,R30
;    1261 OCR2=0x00;
	OUT  0x23,R30
;    1262 
;    1263 MCUCR=0x00;
	OUT  0x35,R30
;    1264 MCUCSR=0x00;
	OUT  0x34,R30
;    1265 
;    1266 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;    1267 
;    1268 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;    1269 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;    1270 
;    1271 #asm("sei") 
	sei
;    1272 PORTB=0xFF;
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x17
;    1273 DDRB=0xFF;
;    1274 ind=iMn;
	CLR  R14
;    1275 prog_drv();
	CALL _prog_drv
;    1276 ind_hndl();
	CALL _ind_hndl
;    1277 led_hndl();
	CALL _led_hndl
;    1278 
;    1279 ee_temp1=10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMWRW
;    1280 ee_temp2=10;
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMWRW
;    1281 while (1)
_0x128:
;    1282       {
;    1283       if(b600Hz)
	SBRS R2,0
	RJMP _0x12B
;    1284 		{
;    1285 		b600Hz=0; 
	CLT
	BLD  R2,0
;    1286           in_an();
	CALL _in_an
;    1287           
;    1288 		}         
;    1289       if(b100Hz)
_0x12B:
	SBRS R2,1
	RJMP _0x12C
;    1290 		{        
;    1291 		b100Hz=0; 
	CLT
	BLD  R2,1
;    1292 		but_an();
	RCALL _but_an
;    1293 	    	//in_drv();
;    1294           ind_hndl();
	CALL _ind_hndl
;    1295           step_contr();
	CALL _step_contr
;    1296           
;    1297           main_loop_hndl();
	CALL _main_loop_hndl
;    1298           payka_hndl();
	CALL _payka_hndl
;    1299 		}   
;    1300 	if(b10Hz)
_0x12C:
	SBRS R2,2
	RJMP _0x12D
;    1301 		{
;    1302 		b10Hz=0;
	CLT
	BLD  R2,2
;    1303 		prog_drv();
	CALL _prog_drv
;    1304 		err_drv();
	CALL _err_drv
;    1305 		
;    1306     	     
;    1307           led_hndl();
	CALL _led_hndl
;    1308           
;    1309           }
;    1310 
;    1311       };
_0x12D:
	RJMP _0x128
;    1312 }
_0x12E:
	RJMP _0x12E

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

