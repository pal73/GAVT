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
;       3 
;       4 
;       5 #define LED_ORIENT	4
;       6 #define LED_NAPOLN	2 
;       7 #define LED_PAYKA	3
;       8 #define LED_ERROR	0 
;       9 #define LED_WRK	6
;      10 #define LED_LOOP_AUTO	7
;      11 
;      12 
;      13 
;      14 
;      15 #define BD1	7
;      16 #define BD2	4
;      17 #define DM	1
;      18 #define START	0
;      19 #define STOP	2
;      20 #define MD1	3
;      21 #define MD2	5
;      22 
;      23 
;      24 #define PP1	6
;      25 #define PP2	7
;      26 #define PP3	5
;      27 #define PP4	4
;      28 #define PP5	3 
;      29 #define PP6	2
;      30 #define PP7	1
;      31 
;      32 
;      33 bit b600Hz;
;      34 
;      35 bit b100Hz;
;      36 bit b10Hz;
;      37 char t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3;
;      38 char ind_cnt;
;      39 flash char IND_STROB[]={0b10111111,0b11011111,0b11101111,0b11110111,0b01111111};

	.CSEG
;      40 flash char DIGISYM[]={0b11000000,0b11111001,0b10100100,0b10110000,0b10011001,0b10010010,0b10000010,0b11111000,0b10000000,0b10010000,0b11111111};								
;      41 
;      42 char ind_out[5]={0x255,0x255,0x255,0x255,0x255};

	.DSEG
_ind_out:
	.BYTE 0x5
;      43 char dig[4];
_dig:
	.BYTE 0x4
;      44 bit bZ;    
;      45 char but;
;      46 static char but_n;
_but_n_G1:
	.BYTE 0x1
;      47 static char but_s;
_but_s_G1:
	.BYTE 0x1
;      48 static char but0_cnt;
_but0_cnt_G1:
	.BYTE 0x1
;      49 static char but1_cnt;
_but1_cnt_G1:
	.BYTE 0x1
;      50 static char but_onL_temp;
_but_onL_temp_G1:
	.BYTE 0x1
;      51 bit l_but;		//идет длинное нажатие на кнопку
;      52 bit n_but;          //произошло нажатие
;      53 bit speed;		//разрешение ускорения перебора 
;      54 bit bFL2; 
;      55 bit bFL5;
;      56 eeprom enum{elmAUTO=0x55,elmMNL=0xaa}ee_loop_mode;

	.ESEG
_ee_loop_mode:
	.DB  0x0
;      57 //eeprom char ee_program[2];
;      58 enum {p1=1,p2=2,p3=3,p4=4}prog;
;      59 enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}step=sOFF;
;      60 enum {iMn,iPr_sel,iSet} ind;
;      61 char sub_ind;

	.DSEG
_sub_ind:
	.BYTE 0x1
;      62 char in_word,in_word_old,in_word_new,in_word_cnt;
_in_word:
	.BYTE 0x1
_in_word_old:
	.BYTE 0x1
_in_word_new:
	.BYTE 0x1
_in_word_cnt:
	.BYTE 0x1
;      63 bit bERR;
;      64 signed int cnt_del=0;
_cnt_del:
	.BYTE 0x2
;      65 
;      66 bit bMD1,bMD2,bBD1,bBD2,bDM,bSTART,bSTOP;
;      67 
;      68 char cnt_md1,cnt_md2,cnt_bd1,cnt_bd2,cnt_dm,cnt_start,cnt_stop;
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
;      69 
;      70 //eeprom unsigned ee_delay[4,2];
;      71 //eeprom char ee_vr_log;
;      72 #include <mega16.h>
;      73 //#include <mega8535.h>  
;      74 
;      75 bit bPP1,bPP2,bPP3,bPP4,bPP5,bPP6,bPP7,bPP8;
;      76 
;      77 enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}payka_step=sOFF,napoln_step=sOFF,orient_step=sOFF,main_loop_step=sOFF;
_payka_step:
	.BYTE 0x1
_napoln_step:
	.BYTE 0x1
_orient_step:
	.BYTE 0x1
_main_loop_step:
	.BYTE 0x1
;      78 enum{cmdOFF=0,cmdSTART,cmdSTOP}payka_cmd=cmdOFF,napoln_cmd=cmdOFF,orient_cmd=cmdOFF,main_loop_cmd=cmdOFF;
_payka_cmd:
	.BYTE 0x1
_napoln_cmd:
	.BYTE 0x1
_orient_cmd:
	.BYTE 0x1
_main_loop_cmd:
	.BYTE 0x1
<<<<<<< HEAD
;      79 signed short payka_cnt_del,napoln_cnt_del,orient_cnt_del;
=======
;      79 signed short payka_cnt_del,napoln_cnt_del,orient_cnt_del,main_loop_cnt_del;
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
_payka_cnt_del:
	.BYTE 0x2
_napoln_cnt_del:
	.BYTE 0x2
_orient_cnt_del:
	.BYTE 0x2
<<<<<<< HEAD
=======
_main_loop_cnt_del:
	.BYTE 0x2
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
;      80 eeprom signed short ee_temp1,ee_temp2;

	.ESEG
_ee_temp1:
	.DW  0x0
_ee_temp2:
	.DW  0x0
;      81 
;      82 bit bPAYKA_COMPLETE=0,bNAPOLN_COMPLETE=0,bORIENT_COMPLETE=0;
;      83 eeprom signed int ee_prog;
_ee_prog:
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
<<<<<<< HEAD
	RJMP _0x155
=======
	RJMP _0x169
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
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
;     259 	if(cnt_dm<10)
	LDS  R26,_cnt_dm
	CPI  R26,LOW(0xA)
	BRSH _0x39
;     260 		{
;     261 		cnt_dm++;
	LDS  R30,_cnt_dm
	SUBI R30,-LOW(1)
	STS  _cnt_dm,R30
;     262 		if(cnt_dm==10) bDM=1;
	LDS  R26,_cnt_dm
	CPI  R26,LOW(0xA)
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
<<<<<<< HEAD
	CPI  R26,LOW(0x1)
	BRNE _0x4A
;     317 	{
;     318 	payka_cmd=cmdSTART;
	LDI  R30,LOW(1)
	STS  _payka_cmd,R30
;     319 	main_loop_cmd=cmdOFF;
	LDI  R30,LOW(0)
	STS  _main_loop_cmd,R30
;     320 	}                      
;     321 else if(main_loop_cmd==cmdSTOP)
	RJMP _0x4B
_0x4A:
	LDS  R26,_main_loop_cmd
	CPI  R26,LOW(0x2)
	BRNE _0x4C
;     322 	{
;     323 
;     324 	}
;     325 	 
;     326 }
_0x4C:
_0x4B:
	RET
;     327 
;     328 //-----------------------------------------------
;     329 void payka_hndl(void)
;     330 {
_payka_hndl:
;     331 if(payka_cmd==cmdSTART)
	LDS  R26,_payka_cmd
	CPI  R26,LOW(0x1)
	BRNE _0x4D
;     332 	{
;     333 	payka_step=s1;
	LDI  R30,LOW(1)
	STS  _payka_step,R30
;     334 	payka_cnt_del=ee_temp1*10;
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	CALL SUBOPT_0x1
;     335 	bPAYKA_COMPLETE=0;
	CLT
	BLD  R5,1
;     336 	payka_cmd=cmdOFF;
	LDI  R30,LOW(0)
	STS  _payka_cmd,R30
;     337 	}                      
;     338 else if(payka_cmd==cmdSTOP)
	RJMP _0x4E
_0x4D:
	LDS  R26,_payka_cmd
	CPI  R26,LOW(0x2)
	BRNE _0x4F
;     339 	{
;     340 	payka_step=sOFF;
	LDI  R30,LOW(0)
	STS  _payka_step,R30
;     341 	payka_cmd=cmdOFF;
	STS  _payka_cmd,R30
;     342 	} 
;     343 		
;     344 if(payka_step==sOFF)
_0x4F:
_0x4E:
	LDS  R30,_payka_step
	CPI  R30,0
	BRNE _0x50
;     345 	{
;     346 	bPP6=0;
	CLT
	BLD  R4,6
;     347 	bPP7=0;
	CLT
	BLD  R4,7
;     348 	}      
;     349 else if(payka_step==s1)
	RJMP _0x51
_0x50:
	LDS  R26,_payka_step
	CPI  R26,LOW(0x1)
	BRNE _0x52
;     350 	{
;     351 	bPP6=1;
	SET
	BLD  R4,6
;     352 	bPP7=0;
	CLT
	BLD  R4,7
;     353 	payka_cnt_del--;
	CALL SUBOPT_0x2
;     354 	if(payka_cnt_del==0)
	BRNE _0x53
;     355 		{
;     356 		payka_step=s2;
	LDI  R30,LOW(2)
	STS  _payka_step,R30
;     357 		payka_cnt_del=20;
=======
	CPI  R26,LOW(0x1)
	BRNE _0x4A
;     317 	{
;     318 	orient_cmd=cmdSTOP;
	CALL SUBOPT_0x1
;     319 	napoln_cmd=cmdSTOP;
;     320 	payka_cmd=cmdSTOP;
;     321 	main_loop_cmd=cmdOFF;
	LDI  R30,LOW(0)
	STS  _main_loop_cmd,R30
;     322 	main_loop_step=s1;
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2
;     323 	main_loop_cnt_del=20;
;     324 	}                      
;     325 else if(main_loop_cmd==cmdSTOP)
	RJMP _0x4B
_0x4A:
	LDS  R26,_main_loop_cmd
	CPI  R26,LOW(0x2)
	BRNE _0x4C
;     326 	{
;     327 	orient_cmd=cmdSTOP;
	CALL SUBOPT_0x1
;     328 	napoln_cmd=cmdSTOP;
;     329 	payka_cmd=cmdSTOP;
;     330 	main_loop_cmd=cmdSTOP;
	LDI  R30,LOW(2)
	STS  _main_loop_cmd,R30
;     331 	}
;     332 
;     333 if(main_loop_step==sOFF)
_0x4C:
_0x4B:
	LDS  R30,_main_loop_step
	CPI  R30,0
	BRNE _0x4D
;     334 	{
;     335 	bPP1=0;
	CLT
	BLD  R4,1
;     336 	bPP2=0;              
	CLT
	BLD  R4,2
;     337 	}
;     338 else if(main_loop_step==s1)
	RJMP _0x4E
_0x4D:
	LDS  R26,_main_loop_step
	CPI  R26,LOW(0x1)
	BRNE _0x4F
;     339 	{
;     340 	bPP1=1;
	SET
	BLD  R4,1
;     341 	bPP2=0;              
	CLT
	BLD  R4,2
;     342 	main_loop_cnt_del--;
	CALL SUBOPT_0x3
;     343 	if(main_loop_cnt_del==0)
	BRNE _0x50
;     344 		{
;     345 		main_loop_step=s2;
	LDI  R30,LOW(2)
	STS  _main_loop_step,R30
;     346 		}
;     347 	}
_0x50:
;     348 else if(main_loop_step==s2)
	RJMP _0x51
_0x4F:
	LDS  R26,_main_loop_step
	CPI  R26,LOW(0x2)
	BRNE _0x52
;     349 	{
;     350 	bPP1=1;
	SET
	BLD  R4,1
;     351 	bPP2=1;              
	SET
	BLD  R4,2
;     352 	if(bMD1)
	SBRS R3,2
	RJMP _0x53
;     353 		{
;     354 		main_loop_step=s2;
	LDI  R30,LOW(2)
	CALL SUBOPT_0x2
;     355 		main_loop_cnt_del=20;
;     356 		}
;     357 	} 
_0x53:
;     358 else if(main_loop_step==s3)
	RJMP _0x54
_0x52:
	LDS  R26,_main_loop_step
	CPI  R26,LOW(0x3)
	BRNE _0x55
;     359 	{
;     360 	bPP1=0;
	CLT
	BLD  R4,1
;     361 	bPP2=1;              
	SET
	BLD  R4,2
;     362 	main_loop_cnt_del--;
	CALL SUBOPT_0x3
;     363 	if(main_loop_cnt_del==0)
	BRNE _0x56
;     364 		{
;     365 		if(ee_prog=EE_PROG_ONLY_MAIN_LOOP)main_loop_step=sOFF;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMWRW
	SBIW R30,0
	BREQ _0x57
	LDI  R30,LOW(0)
	STS  _main_loop_step,R30
;     366 		else if(ee_prog=EE_PROG_FULL)
	RJMP _0x58
_0x57:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMWRW
	SBIW R30,0
	BREQ _0x59
;     367 			{
;     368 			orient_cmd=cmdSTART;
	LDI  R30,LOW(1)
	STS  _orient_cmd,R30
;     369 			napoln_cmd=cmdSTART;
	STS  _napoln_cmd,R30
;     370 			payka_cmd=cmdSTART;
	STS  _payka_cmd,R30
;     371 			main_loop_step=s4;
	LDI  R30,LOW(4)
	STS  _main_loop_step,R30
;     372 			}
;     373 		}
_0x59:
_0x58:
;     374 	}				        
_0x56:
;     375 else if(main_loop_step==s4)
	RJMP _0x5A
_0x55:
	LDS  R26,_main_loop_step
	CPI  R26,LOW(0x4)
	BRNE _0x5B
;     376 	{                    
;     377 	if(bORIENT_COMPLETE && bNAPOLN_COMPLETE && bPAYKA_COMPLETE)
	SBRS R5,3
	RJMP _0x5D
	SBRS R5,2
	RJMP _0x5D
	SBRC R5,1
	RJMP _0x5E
_0x5D:
	RJMP _0x5C
_0x5E:
;     378 		{
;     379 		if(ee_loop_mode==elmAUTO)main_loop_step==s1;
	LDI  R26,LOW(_ee_loop_mode)
	LDI  R27,HIGH(_ee_loop_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0x5F
	LDS  R26,_main_loop_step
	LDI  R30,LOW(1)
	RJMP _0x16B
;     380 		else main_loop_step==sOFF;
_0x5F:
	LDS  R26,_main_loop_step
	LDI  R30,LOW(0)
_0x16B:
	CALL __EQB12
;     381 		}
;     382 	
;     383 	}	
_0x5C:
;     384 	 
;     385 }
_0x5B:
_0x5A:
_0x54:
_0x51:
_0x4E:
	RET
;     386 
;     387 //-----------------------------------------------
;     388 void payka_hndl(void)
;     389 {
_payka_hndl:
;     390 if(payka_cmd==cmdSTART)
	LDS  R26,_payka_cmd
	CPI  R26,LOW(0x1)
	BRNE _0x61
;     391 	{
;     392 	payka_step=s1;
	LDI  R30,LOW(1)
	STS  _payka_step,R30
;     393 	payka_cnt_del=ee_temp1*10;
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	CALL SUBOPT_0x4
;     394 	bPAYKA_COMPLETE=0;
	CLT
	BLD  R5,1
;     395 	payka_cmd=cmdOFF;
	LDI  R30,LOW(0)
	STS  _payka_cmd,R30
;     396 	}                      
;     397 else if(payka_cmd==cmdSTOP)
	RJMP _0x62
_0x61:
	LDS  R26,_payka_cmd
	CPI  R26,LOW(0x2)
	BRNE _0x63
;     398 	{
;     399 	payka_step=sOFF;
	LDI  R30,LOW(0)
	STS  _payka_step,R30
;     400 	payka_cmd=cmdOFF;
	STS  _payka_cmd,R30
;     401 	} 
;     402 		
;     403 if(payka_step==sOFF)
_0x63:
_0x62:
	LDS  R30,_payka_step
	CPI  R30,0
	BRNE _0x64
;     404 	{
;     405 	bPP6=0;
	CLT
	BLD  R4,6
;     406 	bPP7=0;
	CLT
	BLD  R4,7
;     407 	}      
;     408 else if(payka_step==s1)
	RJMP _0x65
_0x64:
	LDS  R26,_payka_step
	CPI  R26,LOW(0x1)
	BRNE _0x66
;     409 	{
;     410 	bPP6=1;
	SET
	BLD  R4,6
;     411 	bPP7=0;
	CLT
	BLD  R4,7
;     412 	payka_cnt_del--;
	CALL SUBOPT_0x5
;     413 	if(payka_cnt_del==0)
	BRNE _0x67
;     414 		{
;     415 		payka_step=s2;
	LDI  R30,LOW(2)
	STS  _payka_step,R30
;     416 		payka_cnt_del=20;
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _payka_cnt_del,R30
	STS  _payka_cnt_del+1,R31
<<<<<<< HEAD
;     358 		}                	
;     359 	}	
_0x53:
;     360 else if(payka_step==s2)
	RJMP _0x54
_0x52:
	LDS  R26,_payka_step
	CPI  R26,LOW(0x2)
	BRNE _0x55
;     361 	{
;     362 	bPP6=0;
	CLT
	BLD  R4,6
;     363 	bPP7=0;
	CLT
	BLD  R4,7
;     364 	payka_cnt_del--;
	CALL SUBOPT_0x2
;     365 	if(payka_cnt_del==0)
	BRNE _0x56
;     366 		{
;     367 		payka_step=s3;
	LDI  R30,LOW(3)
	STS  _payka_step,R30
;     368 		payka_cnt_del=ee_temp2*10;
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	CALL SUBOPT_0x1
;     369 		}                	
;     370 	}		  
_0x56:
;     371 else if(payka_step==s3)
	RJMP _0x57
_0x55:
	LDS  R26,_payka_step
	CPI  R26,LOW(0x3)
	BRNE _0x58
;     372 	{
;     373 	bPP6=0;
	CLT
	BLD  R4,6
;     374 	bPP7=1;
	SET
	BLD  R4,7
;     375 	payka_cnt_del--;
	CALL SUBOPT_0x2
;     376 	if(payka_cnt_del==0)
	BRNE _0x59
;     377 		{
;     378 		payka_step=sOFF;
	LDI  R30,LOW(0)
	STS  _payka_step,R30
;     379 		bPAYKA_COMPLETE=1;
	SET
	BLD  R5,1
;     380 		}                	
;     381 	}			
_0x59:
;     382 }
_0x58:
_0x57:
_0x54:
_0x51:
	RET
;     383 
;     384 //-----------------------------------------------
;     385 void napoln_hndl(void)
;     386 {
_napoln_hndl:
;     387 if(napoln_cmd==cmdSTART)
	LDS  R26,_napoln_cmd
	CPI  R26,LOW(0x1)
	BRNE _0x5A
;     388 	{
;     389 	napoln_step=s1;
	LDI  R30,LOW(1)
	STS  _napoln_step,R30
;     390 	napoln_cnt_del=0;
	LDI  R30,0
	STS  _napoln_cnt_del,R30
	STS  _napoln_cnt_del+1,R30
;     391 	bNAPOLN_COMPLETE=0;
	CLT
	BLD  R5,2
;     392 	
;     393 	napoln_cmd=cmdOFF;
	LDI  R30,LOW(0)
	STS  _napoln_cmd,R30
;     394 	}                      
;     395 else if(napoln_cmd==cmdSTOP)
	RJMP _0x5B
_0x5A:
	LDS  R26,_napoln_cmd
	CPI  R26,LOW(0x2)
	BRNE _0x5C
;     396 	{
;     397 	napoln_step=sOFF;
	LDI  R30,LOW(0)
	STS  _napoln_step,R30
;     398 	napoln_cmd=cmdOFF;
	STS  _napoln_cmd,R30
;     399 	} 
;     400 		
;     401 if(napoln_step==sOFF)
_0x5C:
_0x5B:
	LDS  R30,_napoln_step
	CPI  R30,0
	BRNE _0x5D
;     402 	{
;     403 	bPP4=0;
	CLT
	BLD  R4,4
;     404 	bPP5=0;
	CLT
	BLD  R4,5
;     405 	}      
;     406 else if(napoln_step==s1)
	RJMP _0x5E
_0x5D:
	LDS  R26,_napoln_step
	CPI  R26,LOW(0x1)
	BRNE _0x5F
;     407 	{
;     408 	bPP4=0;
	CLT
	BLD  R4,4
;     409 	bPP5=0;
	CLT
	BLD  R4,5
;     410 	if(bBD2)
	SBRS R3,5
	RJMP _0x60
;     411 		{
;     412 		napoln_step=s2;
	LDI  R30,LOW(2)
	STS  _napoln_step,R30
;     413 		napoln_cnt_del=20;
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _napoln_cnt_del,R30
	STS  _napoln_cnt_del+1,R31
;     414 		}
;     415 	}	
_0x60:
;     416 else if(napoln_step==s2)
	RJMP _0x61
_0x5F:
	LDS  R26,_napoln_step
	CPI  R26,LOW(0x2)
	BRNE _0x62
;     417 	{
;     418 	bPP4=1;
	SET
	BLD  R4,4
;     419 	bPP5=0;
	CLT
	BLD  R4,5
;     420 	napoln_cnt_del--;
	CALL SUBOPT_0x3
;     421 	if(napoln_cnt_del==0)
	LDS  R30,_napoln_cnt_del
	LDS  R31,_napoln_cnt_del+1
	SBIW R30,0
	BRNE _0x63
;     422 		{
;     423 		napoln_step=s3;
	LDI  R30,LOW(3)
	STS  _napoln_step,R30
;     424 		}                	
;     425 	}		  
_0x63:
;     426 else if(napoln_step==s3)
	RJMP _0x64
_0x62:
	LDS  R26,_napoln_step
	CPI  R26,LOW(0x3)
	BRNE _0x65
;     427 	{
;     428 	bPP4=1;
	SET
	BLD  R4,4
;     429 	bPP5=1;
	SET
	BLD  R4,5
;     430 	napoln_cnt_del--;
	CALL SUBOPT_0x3
;     431 	if(bMD2)
	SBRS R3,3
	RJMP _0x66
;     432 		{
;     433 		napoln_step=sOFF;
	LDI  R30,LOW(0)
	STS  _napoln_step,R30
;     434 		bNAPOLN_COMPLETE=1;
	SET
	BLD  R5,2
;     435 		}                	
;     436 	}			
_0x66:
;     437 }
_0x65:
_0x64:
_0x61:
_0x5E:
	RET
;     438 
;     439 //-----------------------------------------------
;     440 void orient_hndl(void)
;     441 {
_orient_hndl:
;     442 if(orient_cmd==cmdSTART)
	LDS  R26,_orient_cmd
	CPI  R26,LOW(0x1)
	BRNE _0x67
;     443 	{
;     444 	orient_step=s1;
	LDI  R30,LOW(1)
	STS  _orient_step,R30
;     445 	orient_cnt_del=0;
	LDI  R30,0
	STS  _orient_cnt_del,R30
	STS  _orient_cnt_del+1,R30
;     446 	bORIENT_COMPLETE=0;
	CLT
	BLD  R5,3
;     447 	
;     448 	orient_cmd=cmdOFF;
	LDI  R30,LOW(0)
	STS  _orient_cmd,R30
;     449 	}                      
;     450 else if(orient_cmd==cmdSTOP)
	RJMP _0x68
_0x67:
	LDS  R26,_orient_cmd
	CPI  R26,LOW(0x2)
	BRNE _0x69
;     451 	{
;     452 	orient_step=sOFF;
	LDI  R30,LOW(0)
	STS  _orient_step,R30
;     453 	orient_cmd=cmdOFF;
	STS  _orient_cmd,R30
;     454 	} 
;     455 		
;     456 if(orient_step==sOFF)
_0x69:
_0x68:
	LDS  R30,_orient_step
	CPI  R30,0
	BRNE _0x6A
;     457 	{
;     458 	bPP3=0;
	CLT
	BLD  R4,3
;     459 	}      
;     460 else if(orient_step==s1)
	RJMP _0x6B
_0x6A:
	LDS  R26,_orient_step
	CPI  R26,LOW(0x1)
	BRNE _0x6C
;     461 	{
;     462 	bPP3=1;
	SET
	BLD  R4,3
;     463 	if(!bDM)
	SBRC R3,6
	RJMP _0x6D
;     464 		{
;     465 		orient_step=s2;
	LDI  R30,LOW(2)
	STS  _orient_step,R30
;     466 		}
;     467 	}	
_0x6D:
;     468 else if(orient_step==s2)
	RJMP _0x6E
_0x6C:
	LDS  R26,_orient_step
	CPI  R26,LOW(0x2)
	BRNE _0x6F
;     469 	{
;     470 	bPP3=1;
	SET
	BLD  R4,3
;     471 	if(bDM)
	SBRS R3,6
	RJMP _0x70
;     472 		{
;     473 		orient_step=sOFF;
	LDI  R30,LOW(0)
	STS  _orient_step,R30
;     474 		bORIENT_COMPLETE=1;
	SET
	BLD  R5,3
;     475 		}               	
;     476 	}		  
_0x70:
;     477 }
_0x6F:
_0x6E:
_0x6B:
	RET
;     478 
;     479 //-----------------------------------------------
;     480 void out_drv(void)
;     481 {
_out_drv:
;     482 char temp=0;
;     483 DDRB=0xFF;
=======
;     417 		}                	
;     418 	}	
_0x67:
;     419 else if(payka_step==s2)
	RJMP _0x68
_0x66:
	LDS  R26,_payka_step
	CPI  R26,LOW(0x2)
	BRNE _0x69
;     420 	{
;     421 	bPP6=0;
	CLT
	BLD  R4,6
;     422 	bPP7=0;
	CLT
	BLD  R4,7
;     423 	payka_cnt_del--;
	CALL SUBOPT_0x5
;     424 	if(payka_cnt_del==0)
	BRNE _0x6A
;     425 		{
;     426 		payka_step=s3;
	LDI  R30,LOW(3)
	STS  _payka_step,R30
;     427 		payka_cnt_del=ee_temp2*10;
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	CALL SUBOPT_0x4
;     428 		}                	
;     429 	}		  
_0x6A:
;     430 else if(payka_step==s3)
	RJMP _0x6B
_0x69:
	LDS  R26,_payka_step
	CPI  R26,LOW(0x3)
	BRNE _0x6C
;     431 	{
;     432 	bPP6=0;
	CLT
	BLD  R4,6
;     433 	bPP7=1;
	SET
	BLD  R4,7
;     434 	payka_cnt_del--;
	CALL SUBOPT_0x5
;     435 	if(payka_cnt_del==0)
	BRNE _0x6D
;     436 		{
;     437 		payka_step=sOFF;
	LDI  R30,LOW(0)
	STS  _payka_step,R30
;     438 		bPAYKA_COMPLETE=1;
	SET
	BLD  R5,1
;     439 		}                	
;     440 	}			
_0x6D:
;     441 }
_0x6C:
_0x6B:
_0x68:
_0x65:
	RET
;     442 
;     443 //-----------------------------------------------
;     444 void napoln_hndl(void)
;     445 {
_napoln_hndl:
;     446 if(napoln_cmd==cmdSTART)
	LDS  R26,_napoln_cmd
	CPI  R26,LOW(0x1)
	BRNE _0x6E
;     447 	{
;     448 	napoln_step=s1;
	LDI  R30,LOW(1)
	STS  _napoln_step,R30
;     449 	napoln_cnt_del=0;
	LDI  R30,0
	STS  _napoln_cnt_del,R30
	STS  _napoln_cnt_del+1,R30
;     450 	bNAPOLN_COMPLETE=0;
	CLT
	BLD  R5,2
;     451 	
;     452 	napoln_cmd=cmdOFF;
	LDI  R30,LOW(0)
	STS  _napoln_cmd,R30
;     453 	}                      
;     454 else if(napoln_cmd==cmdSTOP)
	RJMP _0x6F
_0x6E:
	LDS  R26,_napoln_cmd
	CPI  R26,LOW(0x2)
	BRNE _0x70
;     455 	{
;     456 	napoln_step=sOFF;
	LDI  R30,LOW(0)
	STS  _napoln_step,R30
;     457 	napoln_cmd=cmdOFF;
	STS  _napoln_cmd,R30
;     458 	} 
;     459 		
;     460 if(napoln_step==sOFF)
_0x70:
_0x6F:
	LDS  R30,_napoln_step
	CPI  R30,0
	BRNE _0x71
;     461 	{
;     462 	bPP4=0;
	CLT
	BLD  R4,4
;     463 	bPP5=0;
	CLT
	BLD  R4,5
;     464 	}      
;     465 else if(napoln_step==s1)
	RJMP _0x72
_0x71:
	LDS  R26,_napoln_step
	CPI  R26,LOW(0x1)
	BRNE _0x73
;     466 	{
;     467 	bPP4=0;
	CLT
	BLD  R4,4
;     468 	bPP5=0;
	CLT
	BLD  R4,5
;     469 	if(bBD2)
	SBRS R3,5
	RJMP _0x74
;     470 		{
;     471 		napoln_step=s2;
	LDI  R30,LOW(2)
	STS  _napoln_step,R30
;     472 		napoln_cnt_del=20;
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _napoln_cnt_del,R30
	STS  _napoln_cnt_del+1,R31
;     473 		}
;     474 	}	
_0x74:
;     475 else if(napoln_step==s2)
	RJMP _0x75
_0x73:
	LDS  R26,_napoln_step
	CPI  R26,LOW(0x2)
	BRNE _0x76
;     476 	{
;     477 	bPP4=1;
	SET
	BLD  R4,4
;     478 	bPP5=0;
	CLT
	BLD  R4,5
;     479 	napoln_cnt_del--;
	CALL SUBOPT_0x6
;     480 	if(napoln_cnt_del==0)
	LDS  R30,_napoln_cnt_del
	LDS  R31,_napoln_cnt_del+1
	SBIW R30,0
	BRNE _0x77
;     481 		{
;     482 		napoln_step=s3;
	LDI  R30,LOW(3)
	STS  _napoln_step,R30
;     483 		}                	
;     484 	}		  
_0x77:
;     485 else if(napoln_step==s3)
	RJMP _0x78
_0x76:
	LDS  R26,_napoln_step
	CPI  R26,LOW(0x3)
	BRNE _0x79
;     486 	{
;     487 	bPP4=1;
	SET
	BLD  R4,4
;     488 	bPP5=1;
	SET
	BLD  R4,5
;     489 	napoln_cnt_del--;
	CALL SUBOPT_0x6
;     490 	if(bMD2)
	SBRS R3,3
	RJMP _0x7A
;     491 		{
;     492 		napoln_step=sOFF;
	LDI  R30,LOW(0)
	STS  _napoln_step,R30
;     493 		bNAPOLN_COMPLETE=1;
	SET
	BLD  R5,2
;     494 		}                	
;     495 	}			
_0x7A:
;     496 }
_0x79:
_0x78:
_0x75:
_0x72:
	RET
;     497 
;     498 //-----------------------------------------------
;     499 void orient_hndl(void)
;     500 {
_orient_hndl:
;     501 if(orient_cmd==cmdSTART)
	LDS  R26,_orient_cmd
	CPI  R26,LOW(0x1)
	BRNE _0x7B
;     502 	{
;     503 	orient_step=s1;
	LDI  R30,LOW(1)
	STS  _orient_step,R30
;     504 	orient_cnt_del=0;
	LDI  R30,0
	STS  _orient_cnt_del,R30
	STS  _orient_cnt_del+1,R30
;     505 	bORIENT_COMPLETE=0;
	CLT
	BLD  R5,3
;     506 	
;     507 	orient_cmd=cmdOFF;
	LDI  R30,LOW(0)
	STS  _orient_cmd,R30
;     508 	}                      
;     509 else if(orient_cmd==cmdSTOP)
	RJMP _0x7C
_0x7B:
	LDS  R26,_orient_cmd
	CPI  R26,LOW(0x2)
	BRNE _0x7D
;     510 	{
;     511 	orient_step=sOFF;
	LDI  R30,LOW(0)
	STS  _orient_step,R30
;     512 	orient_cmd=cmdOFF;
	STS  _orient_cmd,R30
;     513 	} 
;     514 		
;     515 if(orient_step==sOFF)
_0x7D:
_0x7C:
	LDS  R30,_orient_step
	CPI  R30,0
	BRNE _0x7E
;     516 	{
;     517 	bPP3=0;
	CLT
	BLD  R4,3
;     518 	}      
;     519 else if(orient_step==s1)
	RJMP _0x7F
_0x7E:
	LDS  R26,_orient_step
	CPI  R26,LOW(0x1)
	BRNE _0x80
;     520 	{
;     521 	bPP3=1;
	SET
	BLD  R4,3
;     522 	if(!bDM)
	SBRC R3,6
	RJMP _0x81
;     523 		{
;     524 		orient_step=s2;
	LDI  R30,LOW(2)
	STS  _orient_step,R30
;     525 		}
;     526 	}	
_0x81:
;     527 else if(orient_step==s2)
	RJMP _0x82
_0x80:
	LDS  R26,_orient_step
	CPI  R26,LOW(0x2)
	BRNE _0x83
;     528 	{
;     529 	bPP3=1;
	SET
	BLD  R4,3
;     530 	if(bDM)
	SBRS R3,6
	RJMP _0x84
;     531 		{
;     532 		orient_step=sOFF;
	LDI  R30,LOW(0)
	STS  _orient_step,R30
;     533 		bORIENT_COMPLETE=1;
	SET
	BLD  R5,3
;     534 		}               	
;     535 	}		  
_0x84:
;     536 }
_0x83:
_0x82:
_0x7F:
	RET
;     537 
;     538 //-----------------------------------------------
;     539 void out_drv(void)
;     540 {
_out_drv:
;     541 char temp=0;
;     542 DDRB=0xFF;
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	ST   -Y,R16
;	temp -> R16
	LDI  R16,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
<<<<<<< HEAD
;     484 
;     485 if(bPP1) temp|=(1<<PP1);
	SBRS R4,1
	RJMP _0x71
	ORI  R16,LOW(64)
;     486 if(bPP2) temp|=(1<<PP2);
_0x71:
	SBRS R4,2
	RJMP _0x72
	ORI  R16,LOW(128)
;     487 if(bPP3) temp|=(1<<PP3);
_0x72:
	SBRS R4,3
	RJMP _0x73
	ORI  R16,LOW(32)
;     488 if(bPP4) temp|=(1<<PP4);
_0x73:
	SBRS R4,4
	RJMP _0x74
	ORI  R16,LOW(16)
;     489 if(bPP5) temp|=(1<<PP5);
_0x74:
	SBRS R4,5
	RJMP _0x75
	ORI  R16,LOW(8)
;     490 if(bPP6) temp|=(1<<PP6);
_0x75:
	SBRS R4,6
	RJMP _0x76
	ORI  R16,LOW(4)
;     491 if(bPP7) temp|=(1<<PP7);
_0x76:
	SBRS R4,7
	RJMP _0x77
	ORI  R16,LOW(2)
;     492 
;     493 PORTB=~temp;
_0x77:
	CALL SUBOPT_0x4
;     494 //PORTB=0x55;
;     495 }
	RJMP _0x156
;     496 
;     497 //-----------------------------------------------
;     498 void step_contr(void)
;     499 {
_step_contr:
;     500 char temp=0;
;     501 DDRB=0xFF;
=======
;     543 
;     544 if(bPP1) temp|=(1<<PP1);
	SBRS R4,1
	RJMP _0x85
	ORI  R16,LOW(64)
;     545 if(bPP2) temp|=(1<<PP2);
_0x85:
	SBRS R4,2
	RJMP _0x86
	ORI  R16,LOW(128)
;     546 if(bPP3) temp|=(1<<PP3);
_0x86:
	SBRS R4,3
	RJMP _0x87
	ORI  R16,LOW(32)
;     547 if(bPP4) temp|=(1<<PP4);
_0x87:
	SBRS R4,4
	RJMP _0x88
	ORI  R16,LOW(16)
;     548 if(bPP5) temp|=(1<<PP5);
_0x88:
	SBRS R4,5
	RJMP _0x89
	ORI  R16,LOW(8)
;     549 if(bPP6) temp|=(1<<PP6);
_0x89:
	SBRS R4,6
	RJMP _0x8A
	ORI  R16,LOW(4)
;     550 if(bPP7) temp|=(1<<PP7);
_0x8A:
	SBRS R4,7
	RJMP _0x8B
	ORI  R16,LOW(2)
;     551 
;     552 PORTB=~temp;
_0x8B:
	CALL SUBOPT_0x7
;     553 //PORTB=0x55;
;     554 }
	RJMP _0x16A
;     555 
;     556 //-----------------------------------------------
;     557 void step_contr(void)
;     558 {
_step_contr:
;     559 char temp=0;
;     560 DDRB=0xFF;
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	ST   -Y,R16
;	temp -> R16
	LDI  R16,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
<<<<<<< HEAD
;     502 
;     503 if(step==sOFF)goto step_contr_end;
	TST  R13
	BRNE _0x78
	RJMP _0x79
;     504 
;     505 else if(prog==p1)
_0x78:
	LDI  R30,LOW(1)
	CP   R30,R12
	BREQ PC+3
	JMP _0x7B
;     506 	{
;     507 	if(step==s1)    //жесть
	CP   R30,R13
	BRNE _0x7C
;     508 		{
;     509 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     510           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x79
;     511 
;     512 			//if(ee_vacuum_mode==evmOFF)
;     513 				{
;     514 				//goto lbl_0001;
;     515 				}
;     516 			//else step=s2;
;     517 		}
;     518 
;     519 	else if(step==s2)
	RJMP _0x7E
_0x7C:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0x7F
;     520 		{
;     521 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;     522  //         if(!bVR)goto step_contr_end;
;     523 lbl_0001:
;     524 
;     525           step=s100;
	CALL SUBOPT_0x5
;     526 		cnt_del=40;
;     527           }
;     528 	else if(step==s100)
	RJMP _0x81
_0x7F:
	LDI  R30,LOW(19)
	CP   R30,R13
	BRNE _0x82
;     529 		{
;     530 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     531           cnt_del--;
	CALL SUBOPT_0x6
;     532           if(cnt_del==0)
	BRNE _0x83
;     533 			{
;     534           	step=s3;
	CALL SUBOPT_0x7
;     535           	cnt_del=50;
;     536 			}
;     537 		}
_0x83:
;     538 
;     539 	else if(step==s3)
	RJMP _0x84
_0x82:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0x85
;     540 		{
;     541 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     542           cnt_del--;
	CALL SUBOPT_0x6
;     543           if(cnt_del==0)
	BRNE _0x86
;     544 			{
;     545           	step=s4;
	LDI  R30,LOW(4)
	MOV  R13,R30
;     546 			}
;     547 		}
_0x86:
;     548 	else if(step==s4)
	RJMP _0x87
_0x85:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0x88
;     549 		{
;     550 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5);
	ORI  R16,LOW(248)
;     551           if(!bMD2)goto step_contr_end;
	SBRS R3,3
	RJMP _0x79
;     552           step=s5;
	CALL SUBOPT_0x8
;     553           cnt_del=20;
;     554 		}
;     555 	else if(step==s5)
	RJMP _0x8A
_0x88:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0x8B
;     556 		{
;     557 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     558           cnt_del--;
	CALL SUBOPT_0x6
;     559           if(cnt_del==0)
	BRNE _0x8C
;     560 			{
;     561           	step=s6;
	LDI  R30,LOW(6)
	MOV  R13,R30
;     562 			}
;     563           }
_0x8C:
;     564 	else if(step==s6)
	RJMP _0x8D
_0x8B:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0x8E
;     565 		{
;     566 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP7);
	ORI  R16,LOW(242)
;     567  //         if(!bMD3)goto step_contr_end;
;     568           step=s7;
	CALL SUBOPT_0x9
;     569           cnt_del=20;
;     570 		}
;     571 
;     572 	else if(step==s7)
	RJMP _0x8F
_0x8E:
	LDI  R30,LOW(7)
	CP   R30,R13
	BRNE _0x90
;     573 		{
;     574 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     575           cnt_del--;
	CALL SUBOPT_0x6
;     576           if(cnt_del==0)
	BRNE _0x91
;     577 			{
;     578           	step=s8;
	LDI  R30,LOW(8)
	MOV  R13,R30
;     579           	//cnt_del=ee_delay[prog,0]*10U;;
;     580 			}
;     581           }
_0x91:
;     582 	else if(step==s8)
	RJMP _0x92
_0x90:
	LDI  R30,LOW(8)
	CP   R30,R13
	BRNE _0x93
;     583 		{
;     584 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;     585           cnt_del--;
	CALL SUBOPT_0x6
;     586           if(cnt_del==0)
	BRNE _0x94
;     587 			{
;     588           	step=s9;
	LDI  R30,LOW(9)
	CALL SUBOPT_0xA
;     589           	cnt_del=20;
;     590 			}
;     591           }
_0x94:
;     592 	else if(step==s9)
	RJMP _0x95
_0x93:
	LDI  R30,LOW(9)
	CP   R30,R13
	BRNE _0x96
;     593 		{
;     594 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     595           cnt_del--;
	CALL SUBOPT_0x6
;     596           if(cnt_del==0)
	BRNE _0x97
;     597 			{
;     598           	step=sOFF;
	CLR  R13
;     599           	}
;     600           }
_0x97:
;     601 	}
_0x96:
_0x95:
_0x92:
_0x8F:
_0x8D:
_0x8A:
_0x87:
_0x84:
_0x81:
_0x7E:
;     602 
;     603 else if(prog==p2)  //ско
	RJMP _0x98
_0x7B:
	LDI  R30,LOW(2)
	CP   R30,R12
	BREQ PC+3
	JMP _0x99
;     604 	{
;     605 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0x9A
;     606 		{
;     607 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     608           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x79
;     609 
;     610 		/*	if(ee_vacuum_mode==evmOFF)
;     611 				{
;     612 				goto lbl_0002;
;     613 				}
;     614 			else step=s2; */
;     615 
;     616           //step=s2;
;     617 		}
;     618 
;     619 	else if(step==s2)
	RJMP _0x9C
_0x9A:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0x9D
;     620 		{
;     621 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;     622  //         if(!bVR)goto step_contr_end;
;     623 
;     624 lbl_0002:
;     625           step=s100;
	CALL SUBOPT_0x5
;     626 		cnt_del=40;
;     627           }
;     628 	else if(step==s100)
	RJMP _0x9F
_0x9D:
	LDI  R30,LOW(19)
	CP   R30,R13
	BRNE _0xA0
;     629 		{
;     630 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     631           cnt_del--;
	CALL SUBOPT_0x6
;     632           if(cnt_del==0)
	BRNE _0xA1
;     633 			{
;     634           	step=s3;
	CALL SUBOPT_0x7
;     635           	cnt_del=50;
;     636 			}
;     637 		}
_0xA1:
;     638 	else if(step==s3)
	RJMP _0xA2
_0xA0:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0xA3
;     639 		{
;     640 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     641           cnt_del--;
	CALL SUBOPT_0x6
;     642           if(cnt_del==0)
	BRNE _0xA4
;     643 			{
;     644           	step=s4;
	LDI  R30,LOW(4)
	MOV  R13,R30
;     645 			}
;     646 		}
_0xA4:
;     647 	else if(step==s4)
	RJMP _0xA5
_0xA3:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0xA6
;     648 		{
;     649 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5);
	ORI  R16,LOW(248)
;     650           if(!bMD2)goto step_contr_end;
	SBRS R3,3
	RJMP _0x79
;     651           step=s5;
	CALL SUBOPT_0x8
;     652           cnt_del=20;
;     653 		}
;     654 	else if(step==s5)
	RJMP _0xA8
_0xA6:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0xA9
;     655 		{
;     656 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     657           cnt_del--;
	CALL SUBOPT_0x6
;     658           if(cnt_del==0)
	BRNE _0xAA
;     659 			{
;     660           	step=s6;
	LDI  R30,LOW(6)
	MOV  R13,R30
;     661           	//cnt_del=ee_delay[prog,0]*10U;
;     662 			}
;     663           }
_0xAA:
;     664 	else if(step==s6)
	RJMP _0xAB
_0xA9:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0xAC
;     665 		{
;     666 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;     667           cnt_del--;
	CALL SUBOPT_0x6
;     668           if(cnt_del==0)
	BRNE _0xAD
;     669 			{
;     670           	step=s7;
	CALL SUBOPT_0x9
;     671           	cnt_del=20;
;     672 			}
;     673           }
_0xAD:
;     674 	else if(step==s7)
	RJMP _0xAE
_0xAC:
	LDI  R30,LOW(7)
	CP   R30,R13
	BRNE _0xAF
;     675 		{
;     676 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     677           cnt_del--;
	CALL SUBOPT_0x6
;     678           if(cnt_del==0)
	BRNE _0xB0
;     679 			{
;     680           	step=sOFF;
	CLR  R13
;     681           	}
;     682           }
_0xB0:
;     683 	}
_0xAF:
_0xAE:
_0xAB:
_0xA8:
_0xA5:
_0xA2:
_0x9F:
_0x9C:
;     684 
;     685 else if(prog==p3)   //твист
	RJMP _0xB1
_0x99:
	LDI  R30,LOW(3)
	CP   R30,R12
	BRNE _0xB2
;     686 	{
;     687 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0xB3
;     688 		{
;     689 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     690           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x79
;     691 
;     692 		/*	if(ee_vacuum_mode==evmOFF)
;     693 				{
;     694 				goto lbl_0003;
;     695 				}
;     696 			else step=s2;*/
;     697 
;     698           //step=s2;
;     699 		}
;     700 
;     701 	else if(step==s2)
	RJMP _0xB5
_0xB3:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0xB6
;     702 		{
;     703 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;     704  //         if(!bVR)goto step_contr_end;
;     705 lbl_0003:
;     706           cnt_del=50;
=======
;     561 
;     562 if(step==sOFF)goto step_contr_end;
	TST  R13
	BRNE _0x8C
	RJMP _0x8D
;     563 
;     564 else if(prog==p1)
_0x8C:
	LDI  R30,LOW(1)
	CP   R30,R12
	BREQ PC+3
	JMP _0x8F
;     565 	{
;     566 	if(step==s1)    //жесть
	CP   R30,R13
	BRNE _0x90
;     567 		{
;     568 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     569           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x8D
;     570 
;     571 			//if(ee_vacuum_mode==evmOFF)
;     572 				{
;     573 				//goto lbl_0001;
;     574 				}
;     575 			//else step=s2;
;     576 		}
;     577 
;     578 	else if(step==s2)
	RJMP _0x92
_0x90:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0x93
;     579 		{
;     580 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;     581  //         if(!bVR)goto step_contr_end;
;     582 lbl_0001:
;     583 
;     584           step=s100;
	CALL SUBOPT_0x8
;     585 		cnt_del=40;
;     586           }
;     587 	else if(step==s100)
	RJMP _0x95
_0x93:
	LDI  R30,LOW(19)
	CP   R30,R13
	BRNE _0x96
;     588 		{
;     589 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     590           cnt_del--;
	CALL SUBOPT_0x9
;     591           if(cnt_del==0)
	BRNE _0x97
;     592 			{
;     593           	step=s3;
	CALL SUBOPT_0xA
;     594           	cnt_del=50;
;     595 			}
;     596 		}
_0x97:
;     597 
;     598 	else if(step==s3)
	RJMP _0x98
_0x96:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0x99
;     599 		{
;     600 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     601           cnt_del--;
	CALL SUBOPT_0x9
;     602           if(cnt_del==0)
	BRNE _0x9A
;     603 			{
;     604           	step=s4;
	LDI  R30,LOW(4)
	MOV  R13,R30
;     605 			}
;     606 		}
_0x9A:
;     607 	else if(step==s4)
	RJMP _0x9B
_0x99:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0x9C
;     608 		{
;     609 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5);
	ORI  R16,LOW(248)
;     610           if(!bMD2)goto step_contr_end;
	SBRS R3,3
	RJMP _0x8D
;     611           step=s5;
	CALL SUBOPT_0xB
;     612           cnt_del=20;
;     613 		}
;     614 	else if(step==s5)
	RJMP _0x9E
_0x9C:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0x9F
;     615 		{
;     616 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     617           cnt_del--;
	CALL SUBOPT_0x9
;     618           if(cnt_del==0)
	BRNE _0xA0
;     619 			{
;     620           	step=s6;
	LDI  R30,LOW(6)
	MOV  R13,R30
;     621 			}
;     622           }
_0xA0:
;     623 	else if(step==s6)
	RJMP _0xA1
_0x9F:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0xA2
;     624 		{
;     625 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP7);
	ORI  R16,LOW(242)
;     626  //         if(!bMD3)goto step_contr_end;
;     627           step=s7;
	CALL SUBOPT_0xC
;     628           cnt_del=20;
;     629 		}
;     630 
;     631 	else if(step==s7)
	RJMP _0xA3
_0xA2:
	LDI  R30,LOW(7)
	CP   R30,R13
	BRNE _0xA4
;     632 		{
;     633 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     634           cnt_del--;
	CALL SUBOPT_0x9
;     635           if(cnt_del==0)
	BRNE _0xA5
;     636 			{
;     637           	step=s8;
	LDI  R30,LOW(8)
	MOV  R13,R30
;     638           	//cnt_del=ee_delay[prog,0]*10U;;
;     639 			}
;     640           }
_0xA5:
;     641 	else if(step==s8)
	RJMP _0xA6
_0xA4:
	LDI  R30,LOW(8)
	CP   R30,R13
	BRNE _0xA7
;     642 		{
;     643 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;     644           cnt_del--;
	CALL SUBOPT_0x9
;     645           if(cnt_del==0)
	BRNE _0xA8
;     646 			{
;     647           	step=s9;
	LDI  R30,LOW(9)
	CALL SUBOPT_0xD
;     648           	cnt_del=20;
;     649 			}
;     650           }
_0xA8:
;     651 	else if(step==s9)
	RJMP _0xA9
_0xA7:
	LDI  R30,LOW(9)
	CP   R30,R13
	BRNE _0xAA
;     652 		{
;     653 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     654           cnt_del--;
	CALL SUBOPT_0x9
;     655           if(cnt_del==0)
	BRNE _0xAB
;     656 			{
;     657           	step=sOFF;
	CLR  R13
;     658           	}
;     659           }
_0xAB:
;     660 	}
_0xAA:
_0xA9:
_0xA6:
_0xA3:
_0xA1:
_0x9E:
_0x9B:
_0x98:
_0x95:
_0x92:
;     661 
;     662 else if(prog==p2)  //ско
	RJMP _0xAC
_0x8F:
	LDI  R30,LOW(2)
	CP   R30,R12
	BREQ PC+3
	JMP _0xAD
;     663 	{
;     664 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0xAE
;     665 		{
;     666 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     667           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x8D
;     668 
;     669 		/*	if(ee_vacuum_mode==evmOFF)
;     670 				{
;     671 				goto lbl_0002;
;     672 				}
;     673 			else step=s2; */
;     674 
;     675           //step=s2;
;     676 		}
;     677 
;     678 	else if(step==s2)
	RJMP _0xB0
_0xAE:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0xB1
;     679 		{
;     680 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;     681  //         if(!bVR)goto step_contr_end;
;     682 
;     683 lbl_0002:
;     684           step=s100;
	CALL SUBOPT_0x8
;     685 		cnt_del=40;
;     686           }
;     687 	else if(step==s100)
	RJMP _0xB3
_0xB1:
	LDI  R30,LOW(19)
	CP   R30,R13
	BRNE _0xB4
;     688 		{
;     689 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     690           cnt_del--;
	CALL SUBOPT_0x9
;     691           if(cnt_del==0)
	BRNE _0xB5
;     692 			{
;     693           	step=s3;
	CALL SUBOPT_0xA
;     694           	cnt_del=50;
;     695 			}
;     696 		}
_0xB5:
;     697 	else if(step==s3)
	RJMP _0xB6
_0xB4:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0xB7
;     698 		{
;     699 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     700           cnt_del--;
	CALL SUBOPT_0x9
;     701           if(cnt_del==0)
	BRNE _0xB8
;     702 			{
;     703           	step=s4;
	LDI  R30,LOW(4)
	MOV  R13,R30
;     704 			}
;     705 		}
_0xB8:
;     706 	else if(step==s4)
	RJMP _0xB9
_0xB7:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0xBA
;     707 		{
;     708 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5);
	ORI  R16,LOW(248)
;     709           if(!bMD2)goto step_contr_end;
	SBRS R3,3
	RJMP _0x8D
;     710           step=s5;
	CALL SUBOPT_0xB
;     711           cnt_del=20;
;     712 		}
;     713 	else if(step==s5)
	RJMP _0xBC
_0xBA:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0xBD
;     714 		{
;     715 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     716           cnt_del--;
	CALL SUBOPT_0x9
;     717           if(cnt_del==0)
	BRNE _0xBE
;     718 			{
;     719           	step=s6;
	LDI  R30,LOW(6)
	MOV  R13,R30
;     720           	//cnt_del=ee_delay[prog,0]*10U;
;     721 			}
;     722           }
_0xBE:
;     723 	else if(step==s6)
	RJMP _0xBF
_0xBD:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0xC0
;     724 		{
;     725 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;     726           cnt_del--;
	CALL SUBOPT_0x9
;     727           if(cnt_del==0)
	BRNE _0xC1
;     728 			{
;     729           	step=s7;
	CALL SUBOPT_0xC
;     730           	cnt_del=20;
;     731 			}
;     732           }
_0xC1:
;     733 	else if(step==s7)
	RJMP _0xC2
_0xC0:
	LDI  R30,LOW(7)
	CP   R30,R13
	BRNE _0xC3
;     734 		{
;     735 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     736           cnt_del--;
	CALL SUBOPT_0x9
;     737           if(cnt_del==0)
	BRNE _0xC4
;     738 			{
;     739           	step=sOFF;
	CLR  R13
;     740           	}
;     741           }
_0xC4:
;     742 	}
_0xC3:
_0xC2:
_0xBF:
_0xBC:
_0xB9:
_0xB6:
_0xB3:
_0xB0:
;     743 
;     744 else if(prog==p3)   //твист
	RJMP _0xC5
_0xAD:
	LDI  R30,LOW(3)
	CP   R30,R12
	BRNE _0xC6
;     745 	{
;     746 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0xC7
;     747 		{
;     748 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     749           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x8D
;     750 
;     751 		/*	if(ee_vacuum_mode==evmOFF)
;     752 				{
;     753 				goto lbl_0003;
;     754 				}
;     755 			else step=s2;*/
;     756 
;     757           //step=s2;
;     758 		}
;     759 
;     760 	else if(step==s2)
	RJMP _0xC9
_0xC7:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0xCA
;     761 		{
;     762 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;     763  //         if(!bVR)goto step_contr_end;
;     764 lbl_0003:
;     765           cnt_del=50;
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
<<<<<<< HEAD
;     707 		step=s3;
	LDI  R30,LOW(3)
	MOV  R13,R30
;     708 		}
;     709 
;     710 
;     711 	else	if(step==s3)
	RJMP _0xB8
_0xB6:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0xB9
;     712 		{
;     713 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     714 		cnt_del--;
	CALL SUBOPT_0x6
;     715 		if(cnt_del==0)
	BRNE _0xBA
;     716 			{
;     717 			//cnt_del=ee_delay[prog,0]*10U;
;     718 			step=s4;
	LDI  R30,LOW(4)
	MOV  R13,R30
;     719 			}
;     720           }
_0xBA:
;     721 	else if(step==s4)
	RJMP _0xBB
_0xB9:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0xBC
;     722 		{
;     723 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
	ORI  R16,LOW(250)
;     724 		cnt_del--;
	CALL SUBOPT_0x6
;     725  		if(cnt_del==0)
	BRNE _0xBD
;     726 			{
;     727 		    //	cnt_del=ee_delay[prog,1]*10U;
;     728 			step=s5;
	LDI  R30,LOW(5)
	MOV  R13,R30
;     729 			}
;     730 		}
_0xBD:
;     731 
;     732 	else if(step==s5)
	RJMP _0xBE
_0xBC:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0xBF
;     733 		{
;     734 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
	ORI  R16,LOW(202)
;     735 		cnt_del--;
	CALL SUBOPT_0x6
;     736 		if(cnt_del==0)
	BRNE _0xC0
;     737 			{
;     738 			step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0xA
;     739 			cnt_del=20;
;     740 			}
;     741 		}
_0xC0:
;     742 
;     743 	else if(step==s6)
	RJMP _0xC1
_0xBF:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0xC2
;     744 		{
;     745 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     746   		cnt_del--;
	CALL SUBOPT_0x6
;     747 		if(cnt_del==0)
	BRNE _0xC3
;     748 			{
;     749 			step=sOFF;
	CLR  R13
;     750 			}
;     751 		}
_0xC3:
;     752 
;     753 	}
_0xC2:
_0xC1:
_0xBE:
_0xBB:
_0xB8:
_0xB5:
;     754 
;     755 else if(prog==p4)      //замок
	RJMP _0xC4
_0xB2:
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0xC5
;     756 	{
;     757 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0xC6
;     758 		{
;     759 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     760           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x79
;     761 
;     762 		 /*	if(ee_vacuum_mode==evmOFF)
;     763 				{
;     764 				goto lbl_0004;
;     765 				}
;     766 			else step=s2;*/
;     767           //step=s2;
;     768 		}
;     769 
;     770 	else if(step==s2)
	RJMP _0xC8
_0xC6:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0xC9
;     771 		{
;     772 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;     773  //         if(!bVR)goto step_contr_end;
;     774 lbl_0004:
;     775           step=s3;
	CALL SUBOPT_0x7
;     776 		cnt_del=50;
;     777           }
;     778 
;     779 	else if(step==s3)
	RJMP _0xCB
_0xC9:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0xCC
;     780 		{
;     781 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     782           cnt_del--;
	CALL SUBOPT_0x6
;     783           if(cnt_del==0)
	BRNE _0xCD
;     784 			{
;     785           	step=s4;
	LDI  R30,LOW(4)
	MOV  R13,R30
;     786 			//cnt_del=ee_delay[prog,0]*10U;
;     787 			}
;     788           }
_0xCD:
;     789 
;     790    	else if(step==s4)
	RJMP _0xCE
_0xCC:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0xCF
;     791 		{
;     792 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;     793 		cnt_del--;
	CALL SUBOPT_0x6
;     794 		if(cnt_del==0)
	BRNE _0xD0
;     795 			{
;     796 			step=s5;
	LDI  R30,LOW(5)
	MOV  R13,R30
;     797 			cnt_del=30;
=======
;     766 		step=s3;
	LDI  R30,LOW(3)
	MOV  R13,R30
;     767 		}
;     768 
;     769 
;     770 	else	if(step==s3)
	RJMP _0xCC
_0xCA:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0xCD
;     771 		{
;     772 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     773 		cnt_del--;
	CALL SUBOPT_0x9
;     774 		if(cnt_del==0)
	BRNE _0xCE
;     775 			{
;     776 			//cnt_del=ee_delay[prog,0]*10U;
;     777 			step=s4;
	LDI  R30,LOW(4)
	MOV  R13,R30
;     778 			}
;     779           }
_0xCE:
;     780 	else if(step==s4)
	RJMP _0xCF
_0xCD:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0xD0
;     781 		{
;     782 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
	ORI  R16,LOW(250)
;     783 		cnt_del--;
	CALL SUBOPT_0x9
;     784  		if(cnt_del==0)
	BRNE _0xD1
;     785 			{
;     786 		    //	cnt_del=ee_delay[prog,1]*10U;
;     787 			step=s5;
	LDI  R30,LOW(5)
	MOV  R13,R30
;     788 			}
;     789 		}
_0xD1:
;     790 
;     791 	else if(step==s5)
	RJMP _0xD2
_0xD0:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0xD3
;     792 		{
;     793 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
	ORI  R16,LOW(202)
;     794 		cnt_del--;
	CALL SUBOPT_0x9
;     795 		if(cnt_del==0)
	BRNE _0xD4
;     796 			{
;     797 			step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0xD
;     798 			cnt_del=20;
;     799 			}
;     800 		}
_0xD4:
;     801 
;     802 	else if(step==s6)
	RJMP _0xD5
_0xD3:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0xD6
;     803 		{
;     804 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     805   		cnt_del--;
	CALL SUBOPT_0x9
;     806 		if(cnt_del==0)
	BRNE _0xD7
;     807 			{
;     808 			step=sOFF;
	CLR  R13
;     809 			}
;     810 		}
_0xD7:
;     811 
;     812 	}
_0xD6:
_0xD5:
_0xD2:
_0xCF:
_0xCC:
_0xC9:
;     813 
;     814 else if(prog==p4)      //замок
	RJMP _0xD8
_0xC6:
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0xD9
;     815 	{
;     816 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0xDA
;     817 		{
;     818 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     819           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x8D
;     820 
;     821 		 /*	if(ee_vacuum_mode==evmOFF)
;     822 				{
;     823 				goto lbl_0004;
;     824 				}
;     825 			else step=s2;*/
;     826           //step=s2;
;     827 		}
;     828 
;     829 	else if(step==s2)
	RJMP _0xDC
_0xDA:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0xDD
;     830 		{
;     831 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;     832  //         if(!bVR)goto step_contr_end;
;     833 lbl_0004:
;     834           step=s3;
	CALL SUBOPT_0xA
;     835 		cnt_del=50;
;     836           }
;     837 
;     838 	else if(step==s3)
	RJMP _0xDF
_0xDD:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0xE0
;     839 		{
;     840 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     841           cnt_del--;
	CALL SUBOPT_0x9
;     842           if(cnt_del==0)
	BRNE _0xE1
;     843 			{
;     844           	step=s4;
	LDI  R30,LOW(4)
	MOV  R13,R30
;     845 			//cnt_del=ee_delay[prog,0]*10U;
;     846 			}
;     847           }
_0xE1:
;     848 
;     849    	else if(step==s4)
	RJMP _0xE2
_0xE0:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0xE3
;     850 		{
;     851 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;     852 		cnt_del--;
	CALL SUBOPT_0x9
;     853 		if(cnt_del==0)
	BRNE _0xE4
;     854 			{
;     855 			step=s5;
	LDI  R30,LOW(5)
	MOV  R13,R30
;     856 			cnt_del=30;
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
<<<<<<< HEAD
;     798 			}
;     799 		}
_0xD0:
;     800 
;     801 	else if(step==s5)
	RJMP _0xD1
_0xCF:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0xD2
;     802 		{
;     803 		temp|=(1<<PP1)|(1<<PP4);
	ORI  R16,LOW(80)
;     804 		cnt_del--;
	CALL SUBOPT_0x6
;     805 		if(cnt_del==0)
	BRNE _0xD3
;     806 			{
;     807 			step=s6;
	LDI  R30,LOW(6)
	MOV  R13,R30
;     808 			//cnt_del=ee_delay[prog,1]*10U;
;     809 			}
;     810 		}
_0xD3:
;     811 
;     812 	else if(step==s6)
	RJMP _0xD4
_0xD2:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0xD5
;     813 		{
;     814 		temp|=(1<<PP4);
	ORI  R16,LOW(16)
;     815 		cnt_del--;
	CALL SUBOPT_0x6
;     816 		if(cnt_del==0)
	BRNE _0xD6
;     817 			{
;     818 			step=sOFF;
	CLR  R13
;     819 			}
;     820 		}
_0xD6:
;     821 
;     822 	}
_0xD5:
_0xD4:
_0xD1:
_0xCE:
_0xCB:
_0xC8:
;     823 	
;     824 step_contr_end:
_0xC5:
_0xC4:
_0xB1:
_0x98:
_0x79:
;     825 
;     826 //if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;     827 
;     828 PORTB=~temp;
	CALL SUBOPT_0x4
;     829 //PORTB=0x55;
;     830 }
_0x156:
	LD   R16,Y+
	RET
;     831 
;     832 
;     833 //-----------------------------------------------
;     834 void bin2bcd_int(unsigned int in)
;     835 {
_bin2bcd_int:
;     836 char i;
;     837 for(i=3;i>0;i--)
=======
;     857 			}
;     858 		}
_0xE4:
;     859 
;     860 	else if(step==s5)
	RJMP _0xE5
_0xE3:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0xE6
;     861 		{
;     862 		temp|=(1<<PP1)|(1<<PP4);
	ORI  R16,LOW(80)
;     863 		cnt_del--;
	CALL SUBOPT_0x9
;     864 		if(cnt_del==0)
	BRNE _0xE7
;     865 			{
;     866 			step=s6;
	LDI  R30,LOW(6)
	MOV  R13,R30
;     867 			//cnt_del=ee_delay[prog,1]*10U;
;     868 			}
;     869 		}
_0xE7:
;     870 
;     871 	else if(step==s6)
	RJMP _0xE8
_0xE6:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0xE9
;     872 		{
;     873 		temp|=(1<<PP4);
	ORI  R16,LOW(16)
;     874 		cnt_del--;
	CALL SUBOPT_0x9
;     875 		if(cnt_del==0)
	BRNE _0xEA
;     876 			{
;     877 			step=sOFF;
	CLR  R13
;     878 			}
;     879 		}
_0xEA:
;     880 
;     881 	}
_0xE9:
_0xE8:
_0xE5:
_0xE2:
_0xDF:
_0xDC:
;     882 	
;     883 step_contr_end:
_0xD9:
_0xD8:
_0xC5:
_0xAC:
_0x8D:
;     884 
;     885 //if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;     886 
;     887 PORTB=~temp;
	CALL SUBOPT_0x7
;     888 //PORTB=0x55;
;     889 }
_0x16A:
	LD   R16,Y+
	RET
;     890 
;     891 
;     892 //-----------------------------------------------
;     893 void bin2bcd_int(unsigned int in)
;     894 {
_bin2bcd_int:
;     895 char i;
;     896 for(i=3;i>0;i--)
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	ST   -Y,R16
;	in -> Y+1
;	i -> R16
	LDI  R16,LOW(3)
<<<<<<< HEAD
_0xD8:
	LDI  R30,LOW(0)
	CP   R30,R16
	BRSH _0xD9
;     838 	{
;     839 	dig[i]=in%10;
=======
_0xEC:
	LDI  R30,LOW(0)
	CP   R30,R16
	BRSH _0xED
;     897 	{
;     898 	dig[i]=in%10;
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
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
<<<<<<< HEAD
;     840 	in/=10;
=======
;     899 	in/=10;
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
<<<<<<< HEAD
;     841 	}   
	SUBI R16,1
	RJMP _0xD8
_0xD9:
;     842 }
	LDD  R16,Y+0
	RJMP _0x155
;     843 
;     844 //-----------------------------------------------
;     845 void bcd2ind(char s)
;     846 {
_bcd2ind:
;     847 char i;
;     848 bZ=1;
=======
;     900 	}   
	SUBI R16,1
	RJMP _0xEC
_0xED:
;     901 }
	LDD  R16,Y+0
	RJMP _0x169
;     902 
;     903 //-----------------------------------------------
;     904 void bcd2ind(char s)
;     905 {
_bcd2ind:
;     906 char i;
;     907 bZ=1;
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	ST   -Y,R16
;	s -> Y+1
;	i -> R16
	SET
	BLD  R2,3
<<<<<<< HEAD
;     849 for (i=0;i<5;i++)
	LDI  R16,LOW(0)
_0xDB:
	CPI  R16,5
	BRLO PC+3
	JMP _0xDC
;     850 	{
;     851 	if(bZ&&(!dig[i-1])&&(i<4))
	SBRS R2,3
	RJMP _0xDE
	CALL SUBOPT_0xB
=======
;     908 for (i=0;i<5;i++)
	LDI  R16,LOW(0)
_0xEF:
	CPI  R16,5
	BRLO PC+3
	JMP _0xF0
;     909 	{
;     910 	if(bZ&&(!dig[i-1])&&(i<4))
	SBRS R2,3
	RJMP _0xF2
	CALL SUBOPT_0xE
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	CPI  R30,0
<<<<<<< HEAD
	BRNE _0xDE
	CPI  R16,4
	BRLO _0xDF
_0xDE:
	RJMP _0xDD
_0xDF:
;     852 		{
;     853 		if((4-i)>s)
=======
	BRNE _0xF2
	CPI  R16,4
	BRLO _0xF3
_0xF2:
	RJMP _0xF1
_0xF3:
;     911 		{
;     912 		if((4-i)>s)
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R30,LOW(4)
	SUB  R30,R16
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
<<<<<<< HEAD
	BRSH _0xE0
;     854 			{
;     855 			ind_out[i-1]=DIGISYM[10];
	CALL SUBOPT_0xB
=======
	BRSH _0xF4
;     913 			{
;     914 			ind_out[i-1]=DIGISYM[10];
	CALL SUBOPT_0xE
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	POP  R26
	POP  R27
<<<<<<< HEAD
	RJMP _0x157
;     856 			}
;     857 		else ind_out[i-1]=DIGISYM[0];	
_0xE0:
	CALL SUBOPT_0xB
=======
	RJMP _0x16C
;     915 			}
;     916 		else ind_out[i-1]=DIGISYM[0];	
_0xF4:
	CALL SUBOPT_0xE
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	LPM  R30,Z
	POP  R26
	POP  R27
<<<<<<< HEAD
_0x157:
	ST   X,R30
;     858 		}
;     859 	else
	RJMP _0xE2
_0xDD:
;     860 		{
;     861 		ind_out[i-1]=DIGISYM[dig[i-1]];
	CALL SUBOPT_0xB
=======
_0x16C:
	ST   X,R30
;     917 		}
;     918 	else
	RJMP _0xF6
_0xF1:
;     919 		{
;     920 		ind_out[i-1]=DIGISYM[dig[i-1]];
	CALL SUBOPT_0xE
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	PUSH R31
	PUSH R30
<<<<<<< HEAD
	CALL SUBOPT_0xB
=======
	CALL SUBOPT_0xE
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
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
<<<<<<< HEAD
;     862 		bZ=0;
	CLT
	BLD  R2,3
;     863 		}                   
_0xE2:
;     864 
;     865 	if(s)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0xE3
;     866 		{
;     867 		ind_out[3-s]&=0b01111111;
=======
;     921 		bZ=0;
	CLT
	BLD  R2,3
;     922 		}                   
_0xF6:
;     923 
;     924 	if(s)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0xF7
;     925 		{
;     926 		ind_out[3-s]&=0b01111111;
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
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
<<<<<<< HEAD
;     868 		}	
;     869  
;     870 	}
_0xE3:
	SUBI R16,-1
	RJMP _0xDB
_0xDC:
;     871 }            
	LDD  R16,Y+0
	ADIW R28,2
	RET
;     872 //-----------------------------------------------
;     873 void int2ind(unsigned int in,char s)
;     874 {
_int2ind:
;     875 bin2bcd_int(in);
=======
;     927 		}	
;     928  
;     929 	}
_0xF7:
	SUBI R16,-1
	RJMP _0xEF
_0xF0:
;     930 }            
	LDD  R16,Y+0
	ADIW R28,2
	RET
;     931 //-----------------------------------------------
;     932 void int2ind(unsigned int in,char s)
;     933 {
_int2ind:
;     934 bin2bcd_int(in);
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _bin2bcd_int
<<<<<<< HEAD
;     876 bcd2ind(s);
	LD   R30,Y
	ST   -Y,R30
	CALL _bcd2ind
;     877 
;     878 } 
_0x155:
	ADIW R28,3
	RET
;     879 
;     880 //-----------------------------------------------
;     881 void ind_hndl(void)
;     882 {
_ind_hndl:
;     883 if(ind==iMn)
	TST  R14
	BRNE _0xE4
;     884 	{
;     885 	if(ee_prog==EE_PROG_FULL)
=======
;     935 bcd2ind(s);
	LD   R30,Y
	ST   -Y,R30
	CALL _bcd2ind
;     936 
;     937 } 
_0x169:
	ADIW R28,3
	RET
;     938 
;     939 //-----------------------------------------------
;     940 void ind_hndl(void)
;     941 {
_ind_hndl:
;     942 if(ind==iMn)
	TST  R14
	BRNE _0xF8
;     943 	{
;     944 	if(ee_prog==EE_PROG_FULL)
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	SBIW R30,0
<<<<<<< HEAD
	BREQ _0xE6
;     886 		{
;     887 		}
;     888 	else if(ee_prog==EE_PROG_ONLY_ORIENT)
=======
	BREQ _0xFA
;     945 		{
;     946 		}
;     947 	else if(ee_prog==EE_PROG_ONLY_ORIENT)
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
<<<<<<< HEAD
	BRNE _0xE7
;     889 		{
;     890 		int2ind(orient_step,0);
	LDS  R30,_orient_step
	CALL SUBOPT_0xC
;     891 		}
;     892 	else if(ee_prog==EE_PROG_ONLY_NAPOLN)
	RJMP _0xE8
_0xE7:
=======
	BRNE _0xFB
;     948 		{
;     949 		int2ind(orient_step,0);
	LDS  R30,_orient_step
	CALL SUBOPT_0xF
;     950 		}
;     951 	else if(ee_prog==EE_PROG_ONLY_NAPOLN)
	RJMP _0xFC
_0xFB:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
<<<<<<< HEAD
	BRNE _0xE9
;     893 		{
;     894 		int2ind(napoln_step,0);                              
	LDS  R30,_napoln_step
	CALL SUBOPT_0xC
;     895 		}			                
;     896 	else if(ee_prog==EE_PROG_ONLY_PAYKA)
	RJMP _0xEA
_0xE9:
=======
	BRNE _0xFD
;     952 		{
;     953 		int2ind(napoln_step,0);                              
	LDS  R30,_napoln_step
	CALL SUBOPT_0xF
;     954 		}			                
;     955 	else if(ee_prog==EE_PROG_ONLY_PAYKA)
	RJMP _0xFE
_0xFD:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
<<<<<<< HEAD
	BRNE _0xEB
;     897 		{
;     898 		int2ind(payka_step,0);
	LDS  R30,_payka_step
	CALL SUBOPT_0xC
;     899 		}
;     900 	else if(ee_prog==EE_PROG_ONLY_MAIN_LOOP)
	RJMP _0xEC
_0xEB:
=======
	BRNE _0xFF
;     956 		{
;     957 		int2ind(payka_step,0);
	LDS  R30,_payka_step
	CALL SUBOPT_0xF
;     958 		}
;     959 	else if(ee_prog==EE_PROG_ONLY_MAIN_LOOP)
	RJMP _0x100
_0xFF:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
<<<<<<< HEAD
	BRNE _0xED
;     901 		{
;     902 		int2ind(main_loop_step,0);
	LDS  R30,_main_loop_step
	CALL SUBOPT_0xC
;     903 		}			
;     904 	
;     905 	//int2ind(bDM,0);
;     906 	//int2ind(in_word,0);
;     907 	//int2ind(cnt_dm,0);
;     908 	
;     909 	//int2ind(bDM,0);
;     910 	//int2ind(ee_delay[prog,sub_ind],1);  
;     911 	//ind_out[0]=0xff;//DIGISYM[0];
;     912 	//ind_out[1]=0xff;//DIGISYM[1];
;     913 	//ind_out[2]=DIGISYM[2];//0xff;
;     914 	//ind_out[0]=DIGISYM[7]; 
;     915 
;     916 	//ind_out[0]=DIGISYM[sub_ind+1];
;     917 	}
_0xED:
_0xEC:
_0xEA:
_0xE8:
_0xE6:
;     918 else if(ind==iSet)
	RJMP _0xEE
_0xE4:
	LDI  R30,LOW(2)
	CP   R30,R14
	BRNE _0xEF
;     919 	{
;     920      if(sub_ind==0)int2ind(ee_prog,0);
	LDS  R30,_sub_ind
	CPI  R30,0
	BRNE _0xF0
=======
	BRNE _0x101
;     960 		{
;     961 		int2ind(main_loop_step,0);
	LDS  R30,_main_loop_step
	CALL SUBOPT_0xF
;     962 		}			
;     963 	
;     964 	//int2ind(bDM,0);
;     965 	//int2ind(in_word,0);
;     966 	//int2ind(cnt_dm,0);
;     967 	
;     968 	//int2ind(bDM,0);
;     969 	//int2ind(ee_delay[prog,sub_ind],1);  
;     970 	//ind_out[0]=0xff;//DIGISYM[0];
;     971 	//ind_out[1]=0xff;//DIGISYM[1];
;     972 	//ind_out[2]=DIGISYM[2];//0xff;
;     973 	//ind_out[0]=DIGISYM[7]; 
;     974 
;     975 	//ind_out[0]=DIGISYM[sub_ind+1];
;     976 	}
_0x101:
_0x100:
_0xFE:
_0xFC:
_0xFA:
;     977 else if(ind==iSet)
	RJMP _0x102
_0xF8:
	LDI  R30,LOW(2)
	CP   R30,R14
	BRNE _0x103
;     978 	{
;     979      if(sub_ind==0)int2ind(ee_prog,0);
	LDS  R30,_sub_ind
	CPI  R30,0
	BRNE _0x104
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _int2ind
<<<<<<< HEAD
;     921 	else if(sub_ind==1)int2ind(ee_temp1,1);
	RJMP _0xF1
_0xF0:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x1)
	BRNE _0xF2
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	CALL SUBOPT_0xD
;     922 	else if(sub_ind==2)int2ind(ee_temp2,1);
	RJMP _0xF3
_0xF2:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x2)
	BRNE _0xF4
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	CALL SUBOPT_0xD
;     923 		
;     924 	if(bFL5)ind_out[0]=DIGISYM[sub_ind+1];
_0xF4:
_0xF3:
_0xF1:
	SBRS R3,0
	RJMP _0xF5
=======
;     980 	else if(sub_ind==1)int2ind(ee_temp1,1);
	RJMP _0x105
_0x104:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x1)
	BRNE _0x106
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	CALL SUBOPT_0x10
;     981 	else if(sub_ind==2)int2ind(ee_temp2,1);
	RJMP _0x107
_0x106:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x2)
	BRNE _0x108
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	CALL SUBOPT_0x10
;     982 		
;     983 	if(bFL5)ind_out[0]=DIGISYM[sub_ind+1];
_0x108:
_0x107:
_0x105:
	SBRS R3,0
	RJMP _0x109
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
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
<<<<<<< HEAD
	RJMP _0x158
;     925 	else    ind_out[0]=DIGISYM[10];
_0xF5:
	__POINTW1FN _DIGISYM,10
_0x158:
	LPM  R30,Z
	STS  _ind_out,R30
;     926 	}
;     927 }
_0xEF:
_0xEE:
	RET
;     928 
;     929 //-----------------------------------------------
;     930 void led_hndl(void)
;     931 {
_led_hndl:
;     932 ind_out[4]=DIGISYM[10]; 
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	__PUTB1MN _ind_out,4
;     933 
;     934 ind_out[4]&=~(1<<LED_POW_ON); 
=======
	RJMP _0x16D
;     984 	else    ind_out[0]=DIGISYM[10];
_0x109:
	__POINTW1FN _DIGISYM,10
_0x16D:
	LPM  R30,Z
	STS  _ind_out,R30
;     985 	}
;     986 }
_0x103:
_0x102:
	RET
;     987 
;     988 //-----------------------------------------------
;     989 void led_hndl(void)
;     990 {
_led_hndl:
;     991 ind_out[4]=DIGISYM[10]; 
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	__PUTB1MN _ind_out,4
;     992 
;     993 ind_out[4]&=~(1<<LED_POW_ON); 
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xDF
	POP  R26
	POP  R27
	ST   X,R30
<<<<<<< HEAD
;     935 
;     936 if(step!=sOFF)
	TST  R13
	BREQ _0xF7
;     937 	{
;     938 	ind_out[4]&=~(1<<LED_WRK);
=======
;     994 
;     995 if(step!=sOFF)
	TST  R13
	BREQ _0x10B
;     996 	{
;     997 	ind_out[4]&=~(1<<LED_WRK);
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xBF
	POP  R26
	POP  R27
<<<<<<< HEAD
	RJMP _0x159
;     939 	}
;     940 else ind_out[4]|=(1<<LED_WRK);
_0xF7:
=======
	RJMP _0x16E
;     998 	}
;     999 else ind_out[4]|=(1<<LED_WRK);
_0x10B:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x40
	POP  R26
	POP  R27
<<<<<<< HEAD
_0x159:
	ST   X,R30
;     941 
;     942 
;     943 if(step==sOFF)
	TST  R13
	BRNE _0xF9
;     944 	{
;     945  	if(bERR)
	SBRS R3,1
	RJMP _0xFA
;     946 		{
;     947 		ind_out[4]&=~(1<<LED_ERROR);
=======
_0x16E:
	ST   X,R30
;    1000 
;    1001 
;    1002 if(step==sOFF)
	TST  R13
	BRNE _0x10D
;    1003 	{
;    1004  	if(bERR)
	SBRS R3,1
	RJMP _0x10E
;    1005 		{
;    1006 		ind_out[4]&=~(1<<LED_ERROR);
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFE
	POP  R26
	POP  R27
<<<<<<< HEAD
	RJMP _0x15A
;     948 		}
;     949 	else
_0xFA:
;     950 		{
;     951 		ind_out[4]|=(1<<LED_ERROR);
=======
	RJMP _0x16F
;    1007 		}
;    1008 	else
_0x10E:
;    1009 		{
;    1010 		ind_out[4]|=(1<<LED_ERROR);
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
<<<<<<< HEAD
_0x15A:
	ST   X,R30
;     952 		}
;     953      }
;     954 else ind_out[4]|=(1<<LED_ERROR);
	RJMP _0xFC
_0xF9:
=======
_0x16F:
	ST   X,R30
;    1011 		}
;    1012      }
;    1013 else ind_out[4]|=(1<<LED_ERROR);
	RJMP _0x110
_0x10D:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
	ST   X,R30
<<<<<<< HEAD
_0xFC:
;     955 
;     956 /* 	if(bMD1)
;     957 		{
;     958 		ind_out[4]&=~(1<<LED_ERROR);
;     959 		}
;     960 	else
;     961 		{
;     962 		ind_out[4]|=(1<<LED_ERROR);
;     963 		} */
;     964 
;     965 //if(bERR)ind_out[4]&=~(1<<LED_ERROR);
;     966 if(ee_loop_mode==elmAUTO)ind_out[4]&=~(1<<LED_LOOP_AUTO);
=======
_0x110:
;    1014 
;    1015 /* 	if(bMD1)
;    1016 		{
;    1017 		ind_out[4]&=~(1<<LED_ERROR);
;    1018 		}
;    1019 	else
;    1020 		{
;    1021 		ind_out[4]|=(1<<LED_ERROR);
;    1022 		} */
;    1023 
;    1024 //if(bERR)ind_out[4]&=~(1<<LED_ERROR);
;    1025 if(ee_loop_mode==elmAUTO)ind_out[4]&=~(1<<LED_LOOP_AUTO);
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R26,LOW(_ee_loop_mode)
	LDI  R27,HIGH(_ee_loop_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
<<<<<<< HEAD
	BRNE _0xFD
=======
	BRNE _0x111
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0x7F
	POP  R26
	POP  R27
<<<<<<< HEAD
	RJMP _0x15B
;     967 else ind_out[4]|=(1<<LED_LOOP_AUTO);
_0xFD:
=======
	RJMP _0x170
;    1026 else ind_out[4]|=(1<<LED_LOOP_AUTO);
_0x111:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x80
	POP  R26
	POP  R27
<<<<<<< HEAD
_0x15B:
	ST   X,R30
;     968 
;     969 /*if(prog==p1) ind_out[4]&=~(1<<LED_PROG1);
;     970 else if(prog==p2) ind_out[4]&=~(1<<LED_PROG2);
;     971 else if(prog==p3) ind_out[4]&=~(1<<LED_PROG3);
;     972 else if(prog==p4) ind_out[4]&=~(1<<LED_PROG4); */
;     973 
;     974 /*if(ind==iPr_sel)
;     975 	{
;     976 	if(bFL5)ind_out[4]|=(1<<LED_PROG1)|(1<<LED_PROG2)|(1<<LED_PROG3)|(1<<LED_PROG4);
;     977 	}*/ 
;     978 	 
;     979 /*if(ind==iVr)
;     980 	{
;     981 	if(bFL5)ind_out[4]|=(1<<LED_POW_ON);
;     982 	} */
;     983 if(orient_step!=sOFF)ind_out[4]&=~(1<<LED_ORIENT);
	LDS  R30,_orient_step
	CPI  R30,0
	BREQ _0xFF
=======
_0x170:
	ST   X,R30
;    1027 
;    1028 /*if(prog==p1) ind_out[4]&=~(1<<LED_PROG1);
;    1029 else if(prog==p2) ind_out[4]&=~(1<<LED_PROG2);
;    1030 else if(prog==p3) ind_out[4]&=~(1<<LED_PROG3);
;    1031 else if(prog==p4) ind_out[4]&=~(1<<LED_PROG4); */
;    1032 
;    1033 /*if(ind==iPr_sel)
;    1034 	{
;    1035 	if(bFL5)ind_out[4]|=(1<<LED_PROG1)|(1<<LED_PROG2)|(1<<LED_PROG3)|(1<<LED_PROG4);
;    1036 	}*/ 
;    1037 	 
;    1038 /*if(ind==iVr)
;    1039 	{
;    1040 	if(bFL5)ind_out[4]|=(1<<LED_POW_ON);
;    1041 	} */
;    1042 if(orient_step!=sOFF)ind_out[4]&=~(1<<LED_ORIENT);
	LDS  R30,_orient_step
	CPI  R30,0
	BREQ _0x113
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xEF
	POP  R26
	POP  R27
	ST   X,R30
<<<<<<< HEAD
;     984 if(napoln_step!=sOFF)ind_out[4]&=~(1<<LED_NAPOLN);
_0xFF:
	LDS  R30,_napoln_step
	CPI  R30,0
	BREQ _0x100
=======
;    1043 if(napoln_step!=sOFF)ind_out[4]&=~(1<<LED_NAPOLN);
_0x113:
	LDS  R30,_napoln_step
	CPI  R30,0
	BREQ _0x114
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFB
	POP  R26
	POP  R27
	ST   X,R30
<<<<<<< HEAD
;     985 if(payka_step!=sOFF)ind_out[4]&=~(1<<LED_PAYKA);	
_0x100:
	LDS  R30,_payka_step
	CPI  R30,0
	BREQ _0x101
=======
;    1044 if(payka_step!=sOFF)ind_out[4]&=~(1<<LED_PAYKA);	
_0x114:
	LDS  R30,_payka_step
	CPI  R30,0
	BREQ _0x115
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0XF7
	POP  R26
	POP  R27
	ST   X,R30
<<<<<<< HEAD
;     986 }
_0x101:
	RET
;     987 
;     988 //-----------------------------------------------
;     989 // Подпрограмма драйва до 7 кнопок одного порта, 
;     990 // различает короткое и длинное нажатие,
;     991 // срабатывает на отпускание кнопки, возможность
;     992 // ускорения перебора при длинном нажатии...
;     993 #define but_port PORTC
;     994 #define but_dir  DDRC
;     995 #define but_pin  PINC
;     996 #define but_mask 0b01101010
;     997 #define no_but   0b11111111
;     998 #define but_on   5
;     999 #define but_onL  20
;    1000 
;    1001 
;    1002 
;    1003 
;    1004 void but_drv(void)
;    1005 { 
_but_drv:
;    1006 DDRD&=0b00000111;
	IN   R30,0x11
	ANDI R30,LOW(0x7)
	CALL SUBOPT_0xE
;    1007 PORTD|=0b11111000;
;    1008 
;    1009 but_port|=(but_mask^0xff);
	CALL SUBOPT_0xF
;    1010 but_dir&=but_mask;
;    1011 #asm
;    1012 nop
nop
;    1013 nop
nop
;    1014 nop
nop
;    1015 nop
nop
;    1016 #endasm

;    1017 
;    1018 but_n=but_pin|but_mask; 
	IN   R30,0x13
	ORI  R30,LOW(0x6A)
	STS  _but_n_G1,R30
;    1019 
;    1020 if((but_n==no_but)||(but_n!=but_s))
	LDS  R26,_but_n_G1
	CPI  R26,LOW(0xFF)
	BREQ _0x103
	RCALL SUBOPT_0x10
	BREQ _0x102
_0x103:
;    1021  	{
;    1022  	speed=0;
	CLT
	BLD  R2,6
;    1023    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRSH _0x106
	LDS  R26,_but1_cnt_G1
	CPI  R26,LOW(0x0)
	BREQ _0x108
_0x106:
	SBRS R2,4
	RJMP _0x109
_0x108:
	RJMP _0x105
_0x109:
;    1024   		{
;    1025    	     n_but=1;
	SET
	BLD  R2,5
;    1026           but=but_s;
	LDS  R11,_but_s_G1
;    1027           }
;    1028    	if (but1_cnt>=but_onL_temp)
_0x105:
	RCALL SUBOPT_0x11
	BRLO _0x10A
;    1029   		{
;    1030    	     n_but=1;
	SET
	BLD  R2,5
;    1031           but=but_s&0b11111101;
	RCALL SUBOPT_0x12
;    1032           }
;    1033     	l_but=0;
_0x10A:
	CLT
	BLD  R2,4
;    1034    	but_onL_temp=but_onL;
	LDI  R30,LOW(20)
	STS  _but_onL_temp_G1,R30
;    1035     	but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    1036   	but1_cnt=0;          
	STS  _but1_cnt_G1,R30
;    1037      goto but_drv_out;
	RJMP _0x10B
;    1038   	}  
;    1039   	
;    1040 if(but_n==but_s)
_0x102:
	RCALL SUBOPT_0x10
	BRNE _0x10C
;    1041  	{
;    1042   	but0_cnt++;
	LDS  R30,_but0_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but0_cnt_G1,R30
;    1043   	if(but0_cnt>=but_on)
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRLO _0x10D
;    1044   		{
;    1045    		but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    1046    		but1_cnt++;
	LDS  R30,_but1_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but1_cnt_G1,R30
;    1047    		if(but1_cnt>=but_onL_temp)
	RCALL SUBOPT_0x11
	BRLO _0x10E
;    1048    			{              
;    1049     			but=but_s&0b11111101;
	RCALL SUBOPT_0x12
;    1050     			but1_cnt=0;
	LDI  R30,LOW(0)
	STS  _but1_cnt_G1,R30
;    1051     			n_but=1;
	SET
	BLD  R2,5
;    1052     			l_but=1;
	SET
	BLD  R2,4
;    1053 			if(speed)
	SBRS R2,6
	RJMP _0x10F
;    1054 				{
;    1055     				but_onL_temp=but_onL_temp>>1;
	LDS  R30,_but_onL_temp_G1
	LSR  R30
	STS  _but_onL_temp_G1,R30
;    1056         			if(but_onL_temp<=2) but_onL_temp=2;
	LDS  R26,_but_onL_temp_G1
	LDI  R30,LOW(2)
	CP   R30,R26
	BRLO _0x110
	STS  _but_onL_temp_G1,R30
;    1057 				}    
_0x110:
;    1058    			}
_0x10F:
;    1059   		} 
_0x10E:
;    1060  	}
_0x10D:
;    1061 but_drv_out:
_0x10C:
_0x10B:
;    1062 but_s=but_n;
	LDS  R30,_but_n_G1
	STS  _but_s_G1,R30
;    1063 but_port|=(but_mask^0xff);
	RCALL SUBOPT_0xF
;    1064 but_dir&=but_mask;
;    1065 }    
	RET
;    1066 
;    1067 #define butV	239
;    1068 #define butV_	237
;    1069 #define butP	251
;    1070 #define butP_	249
;    1071 #define butR	127
;    1072 #define butR_	125
;    1073 #define butL	254
;    1074 #define butL_	252
;    1075 #define butLR	126
;    1076 #define butLR_	124 
;    1077 #define butVP_ 233
;    1078 //-----------------------------------------------
;    1079 void but_an(void)
;    1080 {
_but_an:
;    1081 
;    1082 if(bSTART)
	SBRS R3,7
	RJMP _0x111
;    1083 	{   
;    1084 	if(ee_prog==EE_PROG_FULL)
=======
;    1045 }
_0x115:
	RET
;    1046 
;    1047 //-----------------------------------------------
;    1048 // Подпрограмма драйва до 7 кнопок одного порта, 
;    1049 // различает короткое и длинное нажатие,
;    1050 // срабатывает на отпускание кнопки, возможность
;    1051 // ускорения перебора при длинном нажатии...
;    1052 #define but_port PORTC
;    1053 #define but_dir  DDRC
;    1054 #define but_pin  PINC
;    1055 #define but_mask 0b01101010
;    1056 #define no_but   0b11111111
;    1057 #define but_on   5
;    1058 #define but_onL  20
;    1059 
;    1060 
;    1061 
;    1062 
;    1063 void but_drv(void)
;    1064 { 
_but_drv:
;    1065 DDRD&=0b00000111;
	IN   R30,0x11
	ANDI R30,LOW(0x7)
	CALL SUBOPT_0x11
;    1066 PORTD|=0b11111000;
;    1067 
;    1068 but_port|=(but_mask^0xff);
	CALL SUBOPT_0x12
;    1069 but_dir&=but_mask;
;    1070 #asm
;    1071 nop
nop
;    1072 nop
nop
;    1073 nop
nop
;    1074 nop
nop
;    1075 #endasm

;    1076 
;    1077 but_n=but_pin|but_mask; 
	IN   R30,0x13
	ORI  R30,LOW(0x6A)
	STS  _but_n_G1,R30
;    1078 
;    1079 if((but_n==no_but)||(but_n!=but_s))
	LDS  R26,_but_n_G1
	CPI  R26,LOW(0xFF)
	BREQ _0x117
	RCALL SUBOPT_0x13
	BREQ _0x116
_0x117:
;    1080  	{
;    1081  	speed=0;
	CLT
	BLD  R2,6
;    1082    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRSH _0x11A
	LDS  R26,_but1_cnt_G1
	CPI  R26,LOW(0x0)
	BREQ _0x11C
_0x11A:
	SBRS R2,4
	RJMP _0x11D
_0x11C:
	RJMP _0x119
_0x11D:
;    1083   		{
;    1084    	     n_but=1;
	SET
	BLD  R2,5
;    1085           but=but_s;
	LDS  R11,_but_s_G1
;    1086           }
;    1087    	if (but1_cnt>=but_onL_temp)
_0x119:
	RCALL SUBOPT_0x14
	BRLO _0x11E
;    1088   		{
;    1089    	     n_but=1;
	SET
	BLD  R2,5
;    1090           but=but_s&0b11111101;
	RCALL SUBOPT_0x15
;    1091           }
;    1092     	l_but=0;
_0x11E:
	CLT
	BLD  R2,4
;    1093    	but_onL_temp=but_onL;
	LDI  R30,LOW(20)
	STS  _but_onL_temp_G1,R30
;    1094     	but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    1095   	but1_cnt=0;          
	STS  _but1_cnt_G1,R30
;    1096      goto but_drv_out;
	RJMP _0x11F
;    1097   	}  
;    1098   	
;    1099 if(but_n==but_s)
_0x116:
	RCALL SUBOPT_0x13
	BRNE _0x120
;    1100  	{
;    1101   	but0_cnt++;
	LDS  R30,_but0_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but0_cnt_G1,R30
;    1102   	if(but0_cnt>=but_on)
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRLO _0x121
;    1103   		{
;    1104    		but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    1105    		but1_cnt++;
	LDS  R30,_but1_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but1_cnt_G1,R30
;    1106    		if(but1_cnt>=but_onL_temp)
	RCALL SUBOPT_0x14
	BRLO _0x122
;    1107    			{              
;    1108     			but=but_s&0b11111101;
	RCALL SUBOPT_0x15
;    1109     			but1_cnt=0;
	LDI  R30,LOW(0)
	STS  _but1_cnt_G1,R30
;    1110     			n_but=1;
	SET
	BLD  R2,5
;    1111     			l_but=1;
	SET
	BLD  R2,4
;    1112 			if(speed)
	SBRS R2,6
	RJMP _0x123
;    1113 				{
;    1114     				but_onL_temp=but_onL_temp>>1;
	LDS  R30,_but_onL_temp_G1
	LSR  R30
	STS  _but_onL_temp_G1,R30
;    1115         			if(but_onL_temp<=2) but_onL_temp=2;
	LDS  R26,_but_onL_temp_G1
	LDI  R30,LOW(2)
	CP   R30,R26
	BRLO _0x124
	STS  _but_onL_temp_G1,R30
;    1116 				}    
_0x124:
;    1117    			}
_0x123:
;    1118   		} 
_0x122:
;    1119  	}
_0x121:
;    1120 but_drv_out:
_0x120:
_0x11F:
;    1121 but_s=but_n;
	LDS  R30,_but_n_G1
	STS  _but_s_G1,R30
;    1122 but_port|=(but_mask^0xff);
	RCALL SUBOPT_0x12
;    1123 but_dir&=but_mask;
;    1124 }    
	RET
;    1125 
;    1126 #define butV	239
;    1127 #define butV_	237
;    1128 #define butP	251
;    1129 #define butP_	249
;    1130 #define butR	127
;    1131 #define butR_	125
;    1132 #define butL	254
;    1133 #define butL_	252
;    1134 #define butLR	126
;    1135 #define butLR_	124 
;    1136 #define butVP_ 233
;    1137 //-----------------------------------------------
;    1138 void but_an(void)
;    1139 {
_but_an:
;    1140 
;    1141 if(bSTART)
	SBRS R3,7
	RJMP _0x125
;    1142 	{   
;    1143 	if(ee_prog==EE_PROG_FULL)
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	SBIW R30,0
<<<<<<< HEAD
	BREQ _0x113
;    1085 		{
;    1086 		}
;    1087 	else if(ee_prog==EE_PROG_ONLY_ORIENT)
=======
	BREQ _0x127
;    1144 		{
;    1145 		}
;    1146 	else if(ee_prog==EE_PROG_ONLY_ORIENT)
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
<<<<<<< HEAD
	BRNE _0x114
;    1088 		{
;    1089 		orient_cmd=cmdSTART;
	LDI  R30,LOW(1)
	STS  _orient_cmd,R30
;    1090 		}
;    1091 	else if(ee_prog==EE_PROG_ONLY_NAPOLN)
	RJMP _0x115
_0x114:
=======
	BRNE _0x128
;    1147 		{
;    1148 		orient_cmd=cmdSTART;
	LDI  R30,LOW(1)
	STS  _orient_cmd,R30
;    1149 		}
;    1150 	else if(ee_prog==EE_PROG_ONLY_NAPOLN)
	RJMP _0x129
_0x128:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
<<<<<<< HEAD
	BRNE _0x116
;    1092 		{
;    1093 		napoln_cmd=cmdSTART;                              
	LDI  R30,LOW(1)
	STS  _napoln_cmd,R30
;    1094 		}			                
;    1095 	else if(ee_prog==EE_PROG_ONLY_PAYKA)
	RJMP _0x117
_0x116:
=======
	BRNE _0x12A
;    1151 		{
;    1152 		napoln_cmd=cmdSTART;                              
	LDI  R30,LOW(1)
	STS  _napoln_cmd,R30
;    1153 		}			                
;    1154 	else if(ee_prog==EE_PROG_ONLY_PAYKA)
	RJMP _0x12B
_0x12A:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
<<<<<<< HEAD
	BRNE _0x118
;    1096 		{
;    1097 		payka_cmd=cmdSTART;
	LDI  R30,LOW(1)
	STS  _payka_cmd,R30
;    1098 		}
;    1099 	else if(ee_prog==EE_PROG_ONLY_MAIN_LOOP)
	RJMP _0x119
_0x118:
=======
	BRNE _0x12C
;    1155 		{
;    1156 		payka_cmd=cmdSTART;
	LDI  R30,LOW(1)
	STS  _payka_cmd,R30
;    1157 		}
;    1158 	else if(ee_prog==EE_PROG_ONLY_MAIN_LOOP)
	RJMP _0x12D
_0x12C:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
<<<<<<< HEAD
	BRNE _0x11A
;    1100 		{
;    1101 		orient_cmd=cmdSTART;
	LDI  R30,LOW(1)
	STS  _orient_cmd,R30
;    1102 		}				
;    1103 	}
_0x11A:
_0x119:
_0x117:
_0x115:
_0x113:
;    1104 	
;    1105 bSTART=0;	
_0x111:
	CLT
	BLD  R3,7
;    1106 
;    1107 if(bSTOP)
	SBRS R4,0
	RJMP _0x11B
;    1108 	{   
;    1109 	orient_cmd=cmdSTOP;
	LDI  R30,LOW(2)
	STS  _orient_cmd,R30
;    1110 	napoln_cmd=cmdSTOP;
	STS  _napoln_cmd,R30
;    1111 	payka_cmd=cmdSTOP;
	STS  _payka_cmd,R30
;    1112 	main_loop_cmd=cmdSTOP;
	STS  _main_loop_cmd,R30
;    1113 		
;    1114 	}
;    1115 	
;    1116 bSTOP=0;	
_0x11B:
	CLT
	BLD  R4,0
;    1117 
;    1118 
;    1119 /*
;    1120 if(!(in_word&0x01))
;    1121 	{
;    1122 	#ifdef TVIST_SKO
;    1123 	if((step==sOFF)&&(!bERR))
;    1124 		{
;    1125 		step=s1;
;    1126 		if(prog==p2) cnt_del=70;
;    1127 		else if(prog==p3) cnt_del=100;
;    1128 		}
;    1129 	#endif
;    1130 	#ifdef DV3KL2MD
;    1131 	if((step==sOFF)&&(!bERR))
;    1132 		{
;    1133 		step=s1;
;    1134 		cnt_del=70;
;    1135 		}
;    1136 	#endif	
;    1137 	#ifndef TVIST_SKO
;    1138 	if((step==sOFF)&&(!bERR))
;    1139 		{
;    1140 		step=s1;
;    1141 		if(prog==p1) cnt_del=50;
;    1142 		else if(prog==p2) cnt_del=50;
;    1143 		else if(prog==p3) cnt_del=50;
;    1144           #ifdef P380_MINI
;    1145   		cnt_del=100;
;    1146   		#endif
;    1147 		}
;    1148 	#endif
;    1149 	}
;    1150 if(!(in_word&0x02))
;    1151 	{
;    1152 	step=sOFF;
;    1153 
;    1154 	} */
;    1155 
;    1156 if (!n_but) goto but_an_end;
	SBRS R2,5
	RJMP _0x11D
;    1157 
;    1158 if(but==butV_)
	LDI  R30,LOW(237)
	CP   R30,R11
	BRNE _0x11E
;    1159 	{
;    1160 	if(ee_loop_mode!=elmAUTO)ee_loop_mode=elmAUTO;
=======
	BRNE _0x12E
;    1159 		{
;    1160 		orient_cmd=cmdSTART;
	LDI  R30,LOW(1)
	STS  _orient_cmd,R30
;    1161 		}				
;    1162 	}
_0x12E:
_0x12D:
_0x12B:
_0x129:
_0x127:
;    1163 	
;    1164 bSTART=0;	
_0x125:
	CLT
	BLD  R3,7
;    1165 
;    1166 if(bSTOP)
	SBRS R4,0
	RJMP _0x12F
;    1167 	{   
;    1168 	orient_cmd=cmdSTOP;
	RCALL SUBOPT_0x1
;    1169 	napoln_cmd=cmdSTOP;
;    1170 	payka_cmd=cmdSTOP;
;    1171 	main_loop_cmd=cmdSTOP;
	LDI  R30,LOW(2)
	STS  _main_loop_cmd,R30
;    1172 		
;    1173 	}
;    1174 	
;    1175 bSTOP=0;	
_0x12F:
	CLT
	BLD  R4,0
;    1176 
;    1177 
;    1178 /*
;    1179 if(!(in_word&0x01))
;    1180 	{
;    1181 	#ifdef TVIST_SKO
;    1182 	if((step==sOFF)&&(!bERR))
;    1183 		{
;    1184 		step=s1;
;    1185 		if(prog==p2) cnt_del=70;
;    1186 		else if(prog==p3) cnt_del=100;
;    1187 		}
;    1188 	#endif
;    1189 	#ifdef DV3KL2MD
;    1190 	if((step==sOFF)&&(!bERR))
;    1191 		{
;    1192 		step=s1;
;    1193 		cnt_del=70;
;    1194 		}
;    1195 	#endif	
;    1196 	#ifndef TVIST_SKO
;    1197 	if((step==sOFF)&&(!bERR))
;    1198 		{
;    1199 		step=s1;
;    1200 		if(prog==p1) cnt_del=50;
;    1201 		else if(prog==p2) cnt_del=50;
;    1202 		else if(prog==p3) cnt_del=50;
;    1203           #ifdef P380_MINI
;    1204   		cnt_del=100;
;    1205   		#endif
;    1206 		}
;    1207 	#endif
;    1208 	}
;    1209 if(!(in_word&0x02))
;    1210 	{
;    1211 	step=sOFF;
;    1212 
;    1213 	} */
;    1214 
;    1215 if (!n_but) goto but_an_end;
	SBRS R2,5
	RJMP _0x131
;    1216 
;    1217 if(but==butV_)
	LDI  R30,LOW(237)
	CP   R30,R11
	BRNE _0x132
;    1218 	{
;    1219 	if(ee_loop_mode!=elmAUTO)ee_loop_mode=elmAUTO;
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R26,LOW(_ee_loop_mode)
	LDI  R27,HIGH(_ee_loop_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
<<<<<<< HEAD
	BREQ _0x11F
	LDI  R30,LOW(85)
	RJMP _0x15C
;    1161 	else ee_loop_mode=elmMNL;
_0x11F:
	LDI  R30,LOW(170)
_0x15C:
	LDI  R26,LOW(_ee_loop_mode)
	LDI  R27,HIGH(_ee_loop_mode)
	CALL __EEPROMWRB
;    1162 	}
;    1163 
;    1164 
;    1165 if(ind==iMn)
_0x11E:
	TST  R14
	BRNE _0x121
;    1166 	{
;    1167 	if(but==butP_)
	LDI  R30,LOW(249)
	CP   R30,R11
	BRNE _0x122
;    1168 		{
;    1169 		ind=iSet;
	LDI  R30,LOW(2)
	MOV  R14,R30
;    1170 		sub_ind=0;
	LDI  R30,LOW(0)
	STS  _sub_ind,R30
;    1171 		}
;    1172 	}
_0x122:
;    1173 
;    1174 else if(ind==iSet)
	RJMP _0x123
_0x121:
	LDI  R30,LOW(2)
	CP   R30,R14
	BREQ PC+3
	JMP _0x124
;    1175 	{
;    1176 	if(but==butP_)
	LDI  R30,LOW(249)
	CP   R30,R11
	BRNE _0x125
;    1177 		{
;    1178 		ind=iMn;
	CLR  R14
;    1179 		sub_ind=0;
	LDI  R30,LOW(0)
	STS  _sub_ind,R30
;    1180 		}      
;    1181 	else if(but==butP)
	RJMP _0x126
_0x125:
	LDI  R30,LOW(251)
	CP   R30,R11
	BRNE _0x127
;    1182 		{
;    1183 		sub_ind++;
	LDS  R30,_sub_ind
	SUBI R30,-LOW(1)
	STS  _sub_ind,R30
;    1184 		if(sub_ind==5)sub_ind=0;
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x5)
	BRNE _0x128
	LDI  R30,LOW(0)
	STS  _sub_ind,R30
;    1185 		}
_0x128:
;    1186 	else if (sub_ind==0)
	RJMP _0x129
_0x127:
	LDS  R30,_sub_ind
	CPI  R30,0
	BRNE _0x12A
;    1187 		{
;    1188 		if(but==butR)ee_prog++;
	LDI  R30,LOW(127)
	CP   R30,R11
	BRNE _0x12B
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    1189 		else if(but==butL)ee_prog--;
	RJMP _0x12C
_0x12B:
	LDI  R30,LOW(254)
	CP   R30,R11
	BRNE _0x12D
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    1190 		if(ee_prog>5)ee_prog=0;
_0x12D:
_0x12C:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	MOVW R26,R30
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x12E
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMWRW
;    1191 		if(ee_prog<0)ee_prog=5;
_0x12E:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	MOVW R26,R30
	SBIW R26,0
	BRGE _0x12F
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMWRW
;    1192 		}
_0x12F:
;    1193 	else if (sub_ind==1)
	RJMP _0x130
_0x12A:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x1)
	BRNE _0x131
;    1194 		{             
;    1195 		if((but==butR)||(but==butR_))	
	LDI  R30,LOW(127)
	CP   R30,R11
	BREQ _0x133
	LDI  R30,LOW(125)
	CP   R30,R11
	BRNE _0x132
_0x133:
;    1196 			{  
;    1197 			speed=1;
	SET
	BLD  R2,6
;    1198 			ee_temp1++;
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    1199 			if(ee_temp1>900)ee_temp1=900;
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	RCALL SUBOPT_0x13
	BRGE _0x135
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMWRW
;    1200 			}   
_0x135:
;    1201 	
;    1202     		else if((but==butL)||(but==butL_))	
	RJMP _0x136
_0x132:
	LDI  R30,LOW(254)
	CP   R30,R11
	BREQ _0x138
	LDI  R30,LOW(252)
	CP   R30,R11
	BRNE _0x137
_0x138:
;    1203 			{  
;    1204     	    		speed=1;
	SET
	BLD  R2,6
;    1205     			ee_temp1--;
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    1206     			if(ee_temp1<0)ee_temp1=0;
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	MOVW R26,R30
	SBIW R26,0
	BRGE _0x13A
	LDI  R30,LOW(0)
=======
	BREQ _0x133
	LDI  R30,LOW(85)
	RJMP _0x171
;    1220 	else ee_loop_mode=elmMNL;
_0x133:
	LDI  R30,LOW(170)
_0x171:
	LDI  R26,LOW(_ee_loop_mode)
	LDI  R27,HIGH(_ee_loop_mode)
	CALL __EEPROMWRB
;    1221 	}
;    1222 
;    1223 
;    1224 if(ind==iMn)
_0x132:
	TST  R14
	BRNE _0x135
;    1225 	{
;    1226 	if(but==butP_)
	LDI  R30,LOW(249)
	CP   R30,R11
	BRNE _0x136
;    1227 		{
;    1228 		ind=iSet;
	LDI  R30,LOW(2)
	MOV  R14,R30
;    1229 		sub_ind=0;
	LDI  R30,LOW(0)
	STS  _sub_ind,R30
;    1230 		}
;    1231 	}
_0x136:
;    1232 
;    1233 else if(ind==iSet)
	RJMP _0x137
_0x135:
	LDI  R30,LOW(2)
	CP   R30,R14
	BREQ PC+3
	JMP _0x138
;    1234 	{
;    1235 	if(but==butP_)
	LDI  R30,LOW(249)
	CP   R30,R11
	BRNE _0x139
;    1236 		{
;    1237 		ind=iMn;
	CLR  R14
;    1238 		sub_ind=0;
	LDI  R30,LOW(0)
	STS  _sub_ind,R30
;    1239 		}      
;    1240 	else if(but==butP)
	RJMP _0x13A
_0x139:
	LDI  R30,LOW(251)
	CP   R30,R11
	BRNE _0x13B
;    1241 		{
;    1242 		sub_ind++;
	LDS  R30,_sub_ind
	SUBI R30,-LOW(1)
	STS  _sub_ind,R30
;    1243 		if(sub_ind==5)sub_ind=0;
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x5)
	BRNE _0x13C
	LDI  R30,LOW(0)
	STS  _sub_ind,R30
;    1244 		}
_0x13C:
;    1245 	else if (sub_ind==0)
	RJMP _0x13D
_0x13B:
	LDS  R30,_sub_ind
	CPI  R30,0
	BRNE _0x13E
;    1246 		{
;    1247 		if(but==butR)ee_prog++;
	LDI  R30,LOW(127)
	CP   R30,R11
	BRNE _0x13F
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    1248 		else if(but==butL)ee_prog--;
	RJMP _0x140
_0x13F:
	LDI  R30,LOW(254)
	CP   R30,R11
	BRNE _0x141
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    1249 		if(ee_prog>5)ee_prog=0;
_0x141:
_0x140:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	MOVW R26,R30
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x142
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMWRW
;    1250 		if(ee_prog<0)ee_prog=5;
_0x142:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	MOVW R26,R30
	SBIW R26,0
	BRGE _0x143
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMWRW
;    1251 		}
_0x143:
;    1252 	else if (sub_ind==1)
	RJMP _0x144
_0x13E:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x1)
	BRNE _0x145
;    1253 		{             
;    1254 		if((but==butR)||(but==butR_))	
	LDI  R30,LOW(127)
	CP   R30,R11
	BREQ _0x147
	LDI  R30,LOW(125)
	CP   R30,R11
	BRNE _0x146
_0x147:
;    1255 			{  
;    1256 			speed=1;
	SET
	BLD  R2,6
;    1257 			ee_temp1++;
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    1258 			if(ee_temp1>900)ee_temp1=900;
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	RCALL SUBOPT_0x16
	BRGE _0x149
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMWRW
;    1259 			}   
_0x149:
;    1260 	
;    1261     		else if((but==butL)||(but==butL_))	
	RJMP _0x14A
_0x146:
	LDI  R30,LOW(254)
	CP   R30,R11
	BREQ _0x14C
	LDI  R30,LOW(252)
	CP   R30,R11
	BRNE _0x14B
_0x14C:
;    1262 			{  
;    1263     	    		speed=1;
	SET
	BLD  R2,6
;    1264     			ee_temp1--;
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    1265     			if(ee_temp1<0)ee_temp1=0;
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	MOVW R26,R30
	SBIW R26,0
	BRGE _0x14E
	LDI  R30,LOW(0)
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R31,HIGH(0)
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMWRW
<<<<<<< HEAD
;    1207     			}				
_0x13A:
;    1208 		}   
_0x137:
_0x136:
;    1209 	else if (sub_ind==2)
	RJMP _0x13B
_0x131:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x2)
	BRNE _0x13C
;    1210 		{             
;    1211 		if((but==butR)||(but==butR_))	
	LDI  R30,LOW(127)
	CP   R30,R11
	BREQ _0x13E
	LDI  R30,LOW(125)
	CP   R30,R11
	BRNE _0x13D
_0x13E:
;    1212 			{  
;    1213 			speed=1;
	SET
	BLD  R2,6
;    1214 			ee_temp2++;
=======
;    1266     			}				
_0x14E:
;    1267 		}   
_0x14B:
_0x14A:
;    1268 	else if (sub_ind==2)
	RJMP _0x14F
_0x145:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x2)
	BRNE _0x150
;    1269 		{             
;    1270 		if((but==butR)||(but==butR_))	
	LDI  R30,LOW(127)
	CP   R30,R11
	BREQ _0x152
	LDI  R30,LOW(125)
	CP   R30,R11
	BRNE _0x151
_0x152:
;    1271 			{  
;    1272 			speed=1;
	SET
	BLD  R2,6
;    1273 			ee_temp2++;
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
<<<<<<< HEAD
;    1215 			if(ee_temp2>900)ee_temp2=900;
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	RCALL SUBOPT_0x13
	BRGE _0x140
=======
;    1274 			if(ee_temp2>900)ee_temp2=900;
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	RCALL SUBOPT_0x16
	BRGE _0x154
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMWRW
<<<<<<< HEAD
;    1216 			}   
_0x140:
;    1217 	
;    1218     		else if((but==butL)||(but==butL_))	
	RJMP _0x141
_0x13D:
	LDI  R30,LOW(254)
	CP   R30,R11
	BREQ _0x143
	LDI  R30,LOW(252)
	CP   R30,R11
	BRNE _0x142
_0x143:
;    1219 			{  
;    1220     	    		speed=1;
	SET
	BLD  R2,6
;    1221     			ee_temp2--;
=======
;    1275 			}   
_0x154:
;    1276 	
;    1277     		else if((but==butL)||(but==butL_))	
	RJMP _0x155
_0x151:
	LDI  R30,LOW(254)
	CP   R30,R11
	BREQ _0x157
	LDI  R30,LOW(252)
	CP   R30,R11
	BRNE _0x156
_0x157:
;    1278 			{  
;    1279     	    		speed=1;
	SET
	BLD  R2,6
;    1280     			ee_temp2--;
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
<<<<<<< HEAD
;    1222     			if(ee_temp2<0)ee_temp1=0;
=======
;    1281     			if(ee_temp2<0)ee_temp1=0;
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	MOVW R26,R30
	SBIW R26,0
<<<<<<< HEAD
	BRGE _0x145
=======
	BRGE _0x159
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMWRW
<<<<<<< HEAD
;    1223     			}				
_0x145:
;    1224 		}							
_0x142:
_0x141:
;    1225 	}
_0x13C:
_0x13B:
_0x130:
_0x129:
_0x126:
;    1226 
;    1227 
;    1228 
;    1229 
;    1230 if(but==butVP_)
_0x124:
_0x123:
	LDI  R30,LOW(233)
	CP   R30,R11
	BRNE _0x146
;    1231 	{
;    1232 	//if(ind!=iVr)ind=iVr;
;    1233 	//else ind=iMn;
;    1234 	}
;    1235 
;    1236 /*	
;    1237 if(ind==iMn)
;    1238 	{
;    1239 	if(but==butP_)ind=iPr_sel;
;    1240 	if(but==butLR)	
;    1241 		{
;    1242 		if((prog==p3)||(prog==p4))
;    1243 			{ 
;    1244 			if(sub_ind==0)sub_ind=1;
;    1245 			else sub_ind=0;
;    1246 			}
;    1247     		else sub_ind=0;
;    1248 		}	 
;    1249 	if((but==butR)||(but==butR_))	
;    1250 		{  
;    1251 		speed=1;
;    1252 		//ee_delay[prog,sub_ind]++;
;    1253 		}   
;    1254 	
;    1255 	else if((but==butL)||(but==butL_))	
;    1256 		{  
;    1257     		speed=1;
;    1258     		//ee_delay[prog,sub_ind]--;
;    1259     		}		
;    1260 	} 
;    1261 	
;    1262 else if(ind==iPr_sel)
;    1263 	{
;    1264 	if(but==butP_)ind=iMn;
;    1265 	if(but==butP)
;    1266 		{
;    1267 		prog++;
;    1268 ////		if(prog>MAXPROG)prog=MINPROG;
;    1269 		//ee_program[0]=prog;
;    1270 		//ee_program[1]=prog;
;    1271 		//ee_program[2]=prog;
;    1272 		}
;    1273 	
;    1274 	if(but==butR)
;    1275 		{
;    1276 		prog++;
;    1277 ////		if(prog>MAXPROG)prog=MINPROG;
;    1278 		//ee_program[0]=prog;
;    1279 		//ee_program[1]=prog;
;    1280 		//ee_program[2]=prog;
;    1281 		}
;    1282 
;    1283 	if(but==butL)
;    1284 		{
;    1285 		prog--;
;    1286 ////		if(prog>MAXPROG)prog=MINPROG;
;    1287 		//ee_program[0]=prog;
;    1288 		//ee_program[1]=prog;
;    1289 		//ee_program[2]=prog;
;    1290 		}	
;    1291 	} 
;    1292 
;    1293 /*else if(ind==iVr)
;    1294 	{
;    1295 	if(but==butP_)
;    1296 		{
;    1297 	    ///	if(ee_vr_log)ee_vr_log=0;
;    1298 	    ///	else ee_vr_log=1;
;    1299 		}	
;    1300 	}*/ 	
;    1301 
;    1302 but_an_end:
_0x146:
_0x11D:
;    1303 n_but=0;
	CLT
	BLD  R2,5
;    1304 }
	RET
;    1305 
;    1306 //-----------------------------------------------
;    1307 void ind_drv(void)
;    1308 {
_ind_drv:
;    1309 if(++ind_cnt>=6)ind_cnt=0;
	INC  R10
	LDI  R30,LOW(6)
	CP   R10,R30
	BRLO _0x147
	CLR  R10
;    1310 
;    1311 if(ind_cnt<5)
_0x147:
	LDI  R30,LOW(5)
	CP   R10,R30
	BRSH _0x148
;    1312 	{
;    1313 	DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
;    1314 	PORTC=0xFF;
	OUT  0x15,R30
;    1315 	DDRD|=0b11111000;
	IN   R30,0x11
	ORI  R30,LOW(0xF8)
	RCALL SUBOPT_0xE
;    1316 	PORTD|=0b11111000;
;    1317 	PORTD&=IND_STROB[ind_cnt];
=======
;    1282     			}				
_0x159:
;    1283 		}							
_0x156:
_0x155:
;    1284 	}
_0x150:
_0x14F:
_0x144:
_0x13D:
_0x13A:
;    1285 
;    1286 
;    1287 
;    1288 
;    1289 if(but==butVP_)
_0x138:
_0x137:
	LDI  R30,LOW(233)
	CP   R30,R11
	BRNE _0x15A
;    1290 	{
;    1291 	//if(ind!=iVr)ind=iVr;
;    1292 	//else ind=iMn;
;    1293 	}
;    1294 
;    1295 /*	
;    1296 if(ind==iMn)
;    1297 	{
;    1298 	if(but==butP_)ind=iPr_sel;
;    1299 	if(but==butLR)	
;    1300 		{
;    1301 		if((prog==p3)||(prog==p4))
;    1302 			{ 
;    1303 			if(sub_ind==0)sub_ind=1;
;    1304 			else sub_ind=0;
;    1305 			}
;    1306     		else sub_ind=0;
;    1307 		}	 
;    1308 	if((but==butR)||(but==butR_))	
;    1309 		{  
;    1310 		speed=1;
;    1311 		//ee_delay[prog,sub_ind]++;
;    1312 		}   
;    1313 	
;    1314 	else if((but==butL)||(but==butL_))	
;    1315 		{  
;    1316     		speed=1;
;    1317     		//ee_delay[prog,sub_ind]--;
;    1318     		}		
;    1319 	} 
;    1320 	
;    1321 else if(ind==iPr_sel)
;    1322 	{
;    1323 	if(but==butP_)ind=iMn;
;    1324 	if(but==butP)
;    1325 		{
;    1326 		prog++;
;    1327 ////		if(prog>MAXPROG)prog=MINPROG;
;    1328 		//ee_program[0]=prog;
;    1329 		//ee_program[1]=prog;
;    1330 		//ee_program[2]=prog;
;    1331 		}
;    1332 	
;    1333 	if(but==butR)
;    1334 		{
;    1335 		prog++;
;    1336 ////		if(prog>MAXPROG)prog=MINPROG;
;    1337 		//ee_program[0]=prog;
;    1338 		//ee_program[1]=prog;
;    1339 		//ee_program[2]=prog;
;    1340 		}
;    1341 
;    1342 	if(but==butL)
;    1343 		{
;    1344 		prog--;
;    1345 ////		if(prog>MAXPROG)prog=MINPROG;
;    1346 		//ee_program[0]=prog;
;    1347 		//ee_program[1]=prog;
;    1348 		//ee_program[2]=prog;
;    1349 		}	
;    1350 	} 
;    1351 
;    1352 /*else if(ind==iVr)
;    1353 	{
;    1354 	if(but==butP_)
;    1355 		{
;    1356 	    ///	if(ee_vr_log)ee_vr_log=0;
;    1357 	    ///	else ee_vr_log=1;
;    1358 		}	
;    1359 	}*/ 	
;    1360 
;    1361 but_an_end:
_0x15A:
_0x131:
;    1362 n_but=0;
	CLT
	BLD  R2,5
;    1363 }
	RET
;    1364 
;    1365 //-----------------------------------------------
;    1366 void ind_drv(void)
;    1367 {
_ind_drv:
;    1368 if(++ind_cnt>=6)ind_cnt=0;
	INC  R10
	LDI  R30,LOW(6)
	CP   R10,R30
	BRLO _0x15B
	CLR  R10
;    1369 
;    1370 if(ind_cnt<5)
_0x15B:
	LDI  R30,LOW(5)
	CP   R10,R30
	BRSH _0x15C
;    1371 	{
;    1372 	DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
;    1373 	PORTC=0xFF;
	OUT  0x15,R30
;    1374 	DDRD|=0b11111000;
	IN   R30,0x11
	ORI  R30,LOW(0xF8)
	RCALL SUBOPT_0x11
;    1375 	PORTD|=0b11111000;
;    1376 	PORTD&=IND_STROB[ind_cnt];
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
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
<<<<<<< HEAD
;    1318 	PORTC=ind_out[ind_cnt];
=======
;    1377 	PORTC=ind_out[ind_cnt];
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	MOV  R30,R10
	LDI  R31,0
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	LD   R30,Z
	OUT  0x15,R30
<<<<<<< HEAD
;    1319 	}
;    1320 else but_drv();
	RJMP _0x149
_0x148:
	CALL _but_drv
_0x149:
;    1321 }
	RET
;    1322 
;    1323 //***********************************************
;    1324 //***********************************************
;    1325 //***********************************************
;    1326 //***********************************************
;    1327 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;    1328 {
=======
;    1378 	}
;    1379 else but_drv();
	RJMP _0x15D
_0x15C:
	CALL _but_drv
_0x15D:
;    1380 }
	RET
;    1381 
;    1382 //***********************************************
;    1383 //***********************************************
;    1384 //***********************************************
;    1385 //***********************************************
;    1386 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;    1387 {
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
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
<<<<<<< HEAD
;    1329 TCCR0=0x02;
	RCALL SUBOPT_0x14
;    1330 TCNT0=-208;
;    1331 OCR0=0x00; 
;    1332 
;    1333 
;    1334 b600Hz=1;
	SET
	BLD  R2,0
;    1335 ind_drv();
	RCALL _ind_drv
;    1336 if(++t0_cnt0>=6)
	INC  R6
	LDI  R30,LOW(6)
	CP   R6,R30
	BRLO _0x14A
;    1337 	{
;    1338 	t0_cnt0=0;
	CLR  R6
;    1339 	b100Hz=1;
	SET
	BLD  R2,1
;    1340 	}
;    1341 
;    1342 if(++t0_cnt1>=60)
_0x14A:
	INC  R7
	LDI  R30,LOW(60)
	CP   R7,R30
	BRLO _0x14B
;    1343 	{
;    1344 	t0_cnt1=0;
	CLR  R7
;    1345 	b10Hz=1;
	SET
	BLD  R2,2
;    1346 	
;    1347 	if(++t0_cnt2>=2)
	INC  R8
	LDI  R30,LOW(2)
	CP   R8,R30
	BRLO _0x14C
;    1348 		{
;    1349 		t0_cnt2=0;
	CLR  R8
;    1350 		bFL5=!bFL5;
	LDI  R30,LOW(1)
	EOR  R3,R30
;    1351 		}
;    1352 		
;    1353 	if(++t0_cnt3>=5)
_0x14C:
	INC  R9
	LDI  R30,LOW(5)
	CP   R9,R30
	BRLO _0x14D
;    1354 		{
;    1355 		t0_cnt3=0;
	CLR  R9
;    1356 		bFL2=!bFL2;
	LDI  R30,LOW(128)
	EOR  R2,R30
;    1357 		}		
;    1358 	}
_0x14D:
;    1359 }
_0x14B:
=======
;    1388 TCCR0=0x02;
	RCALL SUBOPT_0x17
;    1389 TCNT0=-208;
;    1390 OCR0=0x00; 
;    1391 
;    1392 
;    1393 b600Hz=1;
	SET
	BLD  R2,0
;    1394 ind_drv();
	RCALL _ind_drv
;    1395 if(++t0_cnt0>=6)
	INC  R6
	LDI  R30,LOW(6)
	CP   R6,R30
	BRLO _0x15E
;    1396 	{
;    1397 	t0_cnt0=0;
	CLR  R6
;    1398 	b100Hz=1;
	SET
	BLD  R2,1
;    1399 	}
;    1400 
;    1401 if(++t0_cnt1>=60)
_0x15E:
	INC  R7
	LDI  R30,LOW(60)
	CP   R7,R30
	BRLO _0x15F
;    1402 	{
;    1403 	t0_cnt1=0;
	CLR  R7
;    1404 	b10Hz=1;
	SET
	BLD  R2,2
;    1405 	
;    1406 	if(++t0_cnt2>=2)
	INC  R8
	LDI  R30,LOW(2)
	CP   R8,R30
	BRLO _0x160
;    1407 		{
;    1408 		t0_cnt2=0;
	CLR  R8
;    1409 		bFL5=!bFL5;
	LDI  R30,LOW(1)
	EOR  R3,R30
;    1410 		}
;    1411 		
;    1412 	if(++t0_cnt3>=5)
_0x160:
	INC  R9
	LDI  R30,LOW(5)
	CP   R9,R30
	BRLO _0x161
;    1413 		{
;    1414 		t0_cnt3=0;
	CLR  R9
;    1415 		bFL2=!bFL2;
	LDI  R30,LOW(128)
	EOR  R2,R30
;    1416 		}		
;    1417 	}
_0x161:
;    1418 }
_0x15F:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
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
<<<<<<< HEAD
;    1360 
;    1361 //===============================================
;    1362 //===============================================
;    1363 //===============================================
;    1364 //===============================================
;    1365 
;    1366 void main(void)
;    1367 {
_main:
;    1368 
;    1369 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
;    1370 DDRA=0x00;
	RCALL SUBOPT_0x0
;    1371 
;    1372 PORTB=0xff;
	RCALL SUBOPT_0x15
;    1373 DDRB=0xFF;
;    1374 
;    1375 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;    1376 DDRC=0x00;
	OUT  0x14,R30
;    1377 
;    1378 
;    1379 PORTD=0x00;
	OUT  0x12,R30
;    1380 DDRD=0x00;
	OUT  0x11,R30
;    1381 
;    1382 
;    1383 TCCR0=0x02;
	RCALL SUBOPT_0x14
;    1384 TCNT0=-208;
;    1385 OCR0=0x00;
;    1386 
;    1387 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;    1388 TCCR1B=0x00;
	OUT  0x2E,R30
;    1389 TCNT1H=0x00;
	OUT  0x2D,R30
;    1390 TCNT1L=0x00;
	OUT  0x2C,R30
;    1391 ICR1H=0x00;
	OUT  0x27,R30
;    1392 ICR1L=0x00;
	OUT  0x26,R30
;    1393 OCR1AH=0x00;
	OUT  0x2B,R30
;    1394 OCR1AL=0x00;
	OUT  0x2A,R30
;    1395 OCR1BH=0x00;
	OUT  0x29,R30
;    1396 OCR1BL=0x00;
	OUT  0x28,R30
;    1397 
;    1398 
;    1399 ASSR=0x00;
	OUT  0x22,R30
;    1400 TCCR2=0x00;
	OUT  0x25,R30
;    1401 TCNT2=0x00;
	OUT  0x24,R30
;    1402 OCR2=0x00;
	OUT  0x23,R30
;    1403 
;    1404 MCUCR=0x00;
	OUT  0x35,R30
;    1405 MCUCSR=0x00;
	OUT  0x34,R30
;    1406 
;    1407 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;    1408 
;    1409 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;    1410 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;    1411 
;    1412 #asm("sei") 
	sei
;    1413 PORTB=0xFF;
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x15
;    1414 DDRB=0xFF;
;    1415 ind=iMn;
	CLR  R14
;    1416 prog_drv();
	CALL _prog_drv
;    1417 ind_hndl();
	CALL _ind_hndl
;    1418 led_hndl();
	CALL _led_hndl
;    1419 
;    1420 
;    1421 while (1)
_0x14E:
;    1422       {
;    1423       if(b600Hz)
	SBRS R2,0
	RJMP _0x151
;    1424 		{
;    1425 		b600Hz=0; 
	CLT
	BLD  R2,0
;    1426           in_an();
	CALL _in_an
;    1427           
;    1428 		}         
;    1429       if(b100Hz)
_0x151:
	SBRS R2,1
	RJMP _0x152
;    1430 		{        
;    1431 		b100Hz=0; 
	CLT
	BLD  R2,1
;    1432 		but_an();
	RCALL _but_an
;    1433 	    	//in_drv();
;    1434           ind_hndl();
	CALL _ind_hndl
;    1435           step_contr();
	CALL _step_contr
;    1436           
;    1437           main_loop_hndl();
	CALL _main_loop_hndl
;    1438           payka_hndl();
	CALL _payka_hndl
;    1439           napoln_hndl();
	CALL _napoln_hndl
;    1440           orient_hndl();
	CALL _orient_hndl
;    1441           out_drv();
	CALL _out_drv
;    1442 		}   
;    1443 	if(b10Hz)
_0x152:
	SBRS R2,2
	RJMP _0x153
;    1444 		{
;    1445 		b10Hz=0;
	CLT
	BLD  R2,2
;    1446 		prog_drv();
	CALL _prog_drv
;    1447 		err_drv();
	CALL _err_drv
;    1448 		
;    1449     	     
;    1450           led_hndl();
	CALL _led_hndl
;    1451           
;    1452           }
;    1453 
;    1454       };
_0x153:
	RJMP _0x14E
;    1455 }
_0x154:
	RJMP _0x154
=======
;    1419 
;    1420 //===============================================
;    1421 //===============================================
;    1422 //===============================================
;    1423 //===============================================
;    1424 
;    1425 void main(void)
;    1426 {
_main:
;    1427 
;    1428 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
;    1429 DDRA=0x00;
	RCALL SUBOPT_0x0
;    1430 
;    1431 PORTB=0xff;
	RCALL SUBOPT_0x18
;    1432 DDRB=0xFF;
;    1433 
;    1434 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;    1435 DDRC=0x00;
	OUT  0x14,R30
;    1436 
;    1437 
;    1438 PORTD=0x00;
	OUT  0x12,R30
;    1439 DDRD=0x00;
	OUT  0x11,R30
;    1440 
;    1441 
;    1442 TCCR0=0x02;
	RCALL SUBOPT_0x17
;    1443 TCNT0=-208;
;    1444 OCR0=0x00;
;    1445 
;    1446 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;    1447 TCCR1B=0x00;
	OUT  0x2E,R30
;    1448 TCNT1H=0x00;
	OUT  0x2D,R30
;    1449 TCNT1L=0x00;
	OUT  0x2C,R30
;    1450 ICR1H=0x00;
	OUT  0x27,R30
;    1451 ICR1L=0x00;
	OUT  0x26,R30
;    1452 OCR1AH=0x00;
	OUT  0x2B,R30
;    1453 OCR1AL=0x00;
	OUT  0x2A,R30
;    1454 OCR1BH=0x00;
	OUT  0x29,R30
;    1455 OCR1BL=0x00;
	OUT  0x28,R30
;    1456 
;    1457 
;    1458 ASSR=0x00;
	OUT  0x22,R30
;    1459 TCCR2=0x00;
	OUT  0x25,R30
;    1460 TCNT2=0x00;
	OUT  0x24,R30
;    1461 OCR2=0x00;
	OUT  0x23,R30
;    1462 
;    1463 MCUCR=0x00;
	OUT  0x35,R30
;    1464 MCUCSR=0x00;
	OUT  0x34,R30
;    1465 
;    1466 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;    1467 
;    1468 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;    1469 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;    1470 
;    1471 #asm("sei") 
	sei
;    1472 PORTB=0xFF;
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x18
;    1473 DDRB=0xFF;
;    1474 ind=iMn;
	CLR  R14
;    1475 prog_drv();
	CALL _prog_drv
;    1476 ind_hndl();
	CALL _ind_hndl
;    1477 led_hndl();
	CALL _led_hndl
;    1478 
;    1479 
;    1480 while (1)
_0x162:
;    1481       {
;    1482       if(b600Hz)
	SBRS R2,0
	RJMP _0x165
;    1483 		{
;    1484 		b600Hz=0; 
	CLT
	BLD  R2,0
;    1485           in_an();
	CALL _in_an
;    1486           
;    1487 		}         
;    1488       if(b100Hz)
_0x165:
	SBRS R2,1
	RJMP _0x166
;    1489 		{        
;    1490 		b100Hz=0; 
	CLT
	BLD  R2,1
;    1491 		but_an();
	RCALL _but_an
;    1492 	    	//in_drv();
;    1493           ind_hndl();
	CALL _ind_hndl
;    1494           step_contr();
	CALL _step_contr
;    1495           
;    1496           main_loop_hndl();
	CALL _main_loop_hndl
;    1497           payka_hndl();
	CALL _payka_hndl
;    1498           napoln_hndl();
	CALL _napoln_hndl
;    1499           orient_hndl();
	CALL _orient_hndl
;    1500           out_drv();
	CALL _out_drv
;    1501 		}   
;    1502 	if(b10Hz)
_0x166:
	SBRS R2,2
	RJMP _0x167
;    1503 		{
;    1504 		b10Hz=0;
	CLT
	BLD  R2,2
;    1505 		prog_drv();
	CALL _prog_drv
;    1506 		err_drv();
	CALL _err_drv
;    1507 		
;    1508     	     
;    1509           led_hndl();
	CALL _led_hndl
;    1510           
;    1511           }
;    1512 
;    1513       };
_0x167:
	RJMP _0x162
;    1514 }
_0x168:
	RJMP _0x168
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	LDI  R30,LOW(255)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
<<<<<<< HEAD
=======
	LDI  R30,LOW(2)
	STS  _orient_cmd,R30
	STS  _napoln_cmd,R30
	STS  _payka_cmd,R30
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	STS  _payka_cnt_del,R30
	STS  _payka_cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
<<<<<<< HEAD
SUBOPT_0x2:
=======
SUBOPT_0x5:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDS  R30,_payka_cnt_del
	LDS  R31,_payka_cnt_del+1
	SBIW R30,1
	STS  _payka_cnt_del,R30
	STS  _payka_cnt_del+1,R31
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
<<<<<<< HEAD
SUBOPT_0x3:
=======
SUBOPT_0x6:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDS  R30,_napoln_cnt_del
	LDS  R31,_napoln_cnt_del+1
	SBIW R30,1
	STS  _napoln_cnt_del,R30
	STS  _napoln_cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
<<<<<<< HEAD
SUBOPT_0x4:
=======
SUBOPT_0x7:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	MOV  R30,R16
	COM  R30
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
<<<<<<< HEAD
SUBOPT_0x5:
=======
SUBOPT_0x8:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R30,LOW(19)
	MOV  R13,R30
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES
<<<<<<< HEAD
SUBOPT_0x6:
=======
SUBOPT_0x9:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDS  R30,_cnt_del
	LDS  R31,_cnt_del+1
	SBIW R30,1
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
<<<<<<< HEAD
SUBOPT_0x7:
=======
SUBOPT_0xA:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R30,LOW(3)
	MOV  R13,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
<<<<<<< HEAD
SUBOPT_0x8:
=======
SUBOPT_0xB:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R30,LOW(5)
	MOV  R13,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
<<<<<<< HEAD
SUBOPT_0x9:
=======
SUBOPT_0xC:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R30,LOW(7)
	MOV  R13,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
<<<<<<< HEAD
SUBOPT_0xA:
=======
SUBOPT_0xD:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	MOV  R13,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
<<<<<<< HEAD
SUBOPT_0xB:
=======
SUBOPT_0xE:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	MOV  R30,R16
	SUBI R30,LOW(1)
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
<<<<<<< HEAD
SUBOPT_0xC:
=======
SUBOPT_0xF:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _int2ind
<<<<<<< HEAD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _int2ind
=======
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _int2ind

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x11:
	OUT  0x11,R30
	IN   R30,0x12
	ORI  R30,LOW(0xF8)
	OUT  0x12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x12:
	IN   R30,0x15
	ORI  R30,LOW(0x95)
	OUT  0x15,R30
	IN   R30,0x14
	ANDI R30,LOW(0x6A)
	OUT  0x14,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x13:
	LDS  R30,_but_s_G1
	LDS  R26,_but_n_G1
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x14:
	LDS  R30,_but_onL_temp_G1
	LDS  R26,_but1_cnt_G1
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x15:
	LDS  R30,_but_s_G1
	ANDI R30,0xFD
	MOV  R11,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
<<<<<<< HEAD
SUBOPT_0x13:
=======
SUBOPT_0x16:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	MOVW R26,R30
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
<<<<<<< HEAD
SUBOPT_0x14:
=======
SUBOPT_0x17:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
	LDI  R30,LOW(2)
	OUT  0x33,R30
	LDI  R30,LOW(65328)
	LDI  R31,HIGH(65328)
	OUT  0x32,R30
	LDI  R30,LOW(0)
	OUT  0x3C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
<<<<<<< HEAD
SUBOPT_0x15:
=======
SUBOPT_0x18:
>>>>>>> 06450accce680fafcab2b6926894ae44785803e1
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

