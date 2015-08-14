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
;      83 #define EE_PROG_FULL		0
;      84 #define EE_PROG_ONLY_ORIENT 	1
;      85 #define EE_PROG_ONLY_NAPOLN	2
;      86 #define EE_PROG_ONLY_PAYKA	3
;      87 #define EE_PROG_ONLY_MAIN_LOOP 	4
;      88 
;      89 //-----------------------------------------------
;      90 void prog_drv(void)
;      91 {

	.CSEG
_prog_drv:
;      92 char temp,temp1,temp2;
;      93 
;      94 ///temp=ee_program[0];
;      95 ///temp1=ee_program[1];
;      96 ///temp2=ee_program[2];
;      97 
;      98 if((temp==temp1)&&(temp==temp2))
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
;      99 	{
;     100 	}
;     101 else if((temp==temp1)&&(temp!=temp2))
	RJMP _0x7
_0x4:
	CP   R17,R16
	BRNE _0x9
	CP   R18,R16
	BRNE _0xA
_0x9:
	RJMP _0x8
_0xA:
;     102 	{
;     103 	temp2=temp;
	MOV  R18,R16
;     104 	}
;     105 else if((temp!=temp1)&&(temp==temp2))
	RJMP _0xB
_0x8:
	CP   R17,R16
	BREQ _0xD
	CP   R18,R16
	BREQ _0xE
_0xD:
	RJMP _0xC
_0xE:
;     106 	{
;     107 	temp1=temp;
	MOV  R17,R16
;     108 	}
;     109 else if((temp!=temp1)&&(temp1==temp2))
	RJMP _0xF
_0xC:
	CP   R17,R16
	BREQ _0x11
	CP   R18,R17
	BREQ _0x12
_0x11:
	RJMP _0x10
_0x12:
;     110 	{
;     111 	temp=temp1;
	MOV  R16,R17
;     112 	}
;     113 else if((temp!=temp1)&&(temp!=temp2))
	RJMP _0x13
_0x10:
	CP   R17,R16
	BREQ _0x15
	CP   R18,R16
	BRNE _0x16
_0x15:
_0x16:
;     114 	{
;     115 ////	temp=MINPROG;
;     116 ////	temp1=MINPROG;
;     117 ////	temp2=MINPROG;
;     118 	}
;     119 
;     120 ////if(!((temp<=MAXPROG)&&(temp>=MINPROG)))
;     121 ////	{
;     122 ////	temp=MINPROG;
;     123 ////	}
;     124 
;     125 ///if(temp!=ee_program[0])ee_program[0]=temp;
;     126 ///if(temp!=ee_program[1])ee_program[1]=temp;
;     127 ///if(temp!=ee_program[2])ee_program[2]=temp;
;     128 
;     129 prog=temp;
_0x13:
_0xF:
_0xB:
_0x7:
	MOV  R12,R16
;     130 }
	CALL __LOADLOCR3
	RJMP _0x16F
;     131 
;     132 //-----------------------------------------------
;     133 void in_drv(void)
;     134 {
;     135 char i,temp;
;     136 unsigned int tempUI;
;     137 DDRA=0x00;
;	i -> R16
;	temp -> R17
;	tempUI -> R18,R19
;     138 PORTA=0xff;
;     139 in_word_new=PINA;
;     140 if(in_word_old==in_word_new)
;     141 	{
;     142 	if(in_word_cnt<10)
;     143 		{
;     144 		in_word_cnt++;
;     145 		if(in_word_cnt>=10)
;     146 			{
;     147 			in_word=in_word_old;
;     148 			}
;     149 		}
;     150 	}
;     151 else in_word_cnt=0;
;     152 
;     153 
;     154 in_word_old=in_word_new;
;     155 }   
;     156 
;     157 //-----------------------------------------------
;     158 void err_drv(void)
;     159 {
_err_drv:
;     160 if(step==sOFF)
	TST  R13
	BRNE _0x1B
;     161 	{
;     162     	if(prog==p2)	
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x1C
;     163     		{
;     164        		if(bMD1) bERR=1;
	SBRS R3,2
	RJMP _0x1D
	SET
	BLD  R3,1
;     165        		else bERR=0;
	RJMP _0x1E
_0x1D:
	CLT
	BLD  R3,1
_0x1E:
;     166 		}
;     167 	}
_0x1C:
;     168 else bERR=0;
	RJMP _0x1F
_0x1B:
	CLT
	BLD  R3,1
_0x1F:
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
	OUT  0x1B,R30
;     177 in_word=PINA;
	IN   R30,0x19
	STS  _in_word,R30
;     178 
;     179 if(!(in_word&(1<<MD1)))
	ANDI R30,LOW(0x8)
	BRNE _0x20
;     180 	{
;     181 	if(cnt_md1<10)
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRSH _0x21
;     182 		{
;     183 		cnt_md1++;
	LDS  R30,_cnt_md1
	SUBI R30,-LOW(1)
	STS  _cnt_md1,R30
;     184 		if(cnt_md1==10) bMD1=1;
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRNE _0x22
	SET
	BLD  R3,2
;     185 		}
_0x22:
;     186 
;     187 	}
_0x21:
;     188 else
	RJMP _0x23
_0x20:
;     189 	{
;     190 	if(cnt_md1)
	LDS  R30,_cnt_md1
	CPI  R30,0
	BREQ _0x24
;     191 		{
;     192 		cnt_md1--;
	SUBI R30,LOW(1)
	STS  _cnt_md1,R30
;     193 		if(cnt_md1==0) bMD1=0;
	CPI  R30,0
	BRNE _0x25
	CLT
	BLD  R3,2
;     194 		}
_0x25:
;     195 
;     196 	}
_0x24:
_0x23:
;     197 
;     198 if(!(in_word&(1<<MD2)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x20)
	BRNE _0x26
;     199 	{
;     200 	if(cnt_md2<10)
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRSH _0x27
;     201 		{
;     202 		cnt_md2++;
	LDS  R30,_cnt_md2
	SUBI R30,-LOW(1)
	STS  _cnt_md2,R30
;     203 		if(cnt_md2==10) bMD2=1;
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRNE _0x28
	SET
	BLD  R3,3
;     204 		}
_0x28:
;     205 
;     206 	}
_0x27:
;     207 else
	RJMP _0x29
_0x26:
;     208 	{
;     209 	if(cnt_md2)
	LDS  R30,_cnt_md2
	CPI  R30,0
	BREQ _0x2A
;     210 		{
;     211 		cnt_md2--;
	SUBI R30,LOW(1)
	STS  _cnt_md2,R30
;     212 		if(cnt_md2==0) bMD2=0;
	CPI  R30,0
	BRNE _0x2B
	CLT
	BLD  R3,3
;     213 		}
_0x2B:
;     214 
;     215 	}
_0x2A:
_0x29:
;     216 
;     217 if(!(in_word&(1<<BD1)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x80)
	BRNE _0x2C
;     218 	{
;     219 	if(cnt_bd1<10)
	LDS  R26,_cnt_bd1
	CPI  R26,LOW(0xA)
	BRSH _0x2D
;     220 		{
;     221 		cnt_bd1++;
	LDS  R30,_cnt_bd1
	SUBI R30,-LOW(1)
	STS  _cnt_bd1,R30
;     222 		if(cnt_bd1==10) bBD1=1;
	LDS  R26,_cnt_bd1
	CPI  R26,LOW(0xA)
	BRNE _0x2E
	SET
	BLD  R3,4
;     223 		}
_0x2E:
;     224 
;     225 	}
_0x2D:
;     226 else
	RJMP _0x2F
_0x2C:
;     227 	{
;     228 	if(cnt_bd1)
	LDS  R30,_cnt_bd1
	CPI  R30,0
	BREQ _0x30
;     229 		{
;     230 		cnt_bd1--;
	SUBI R30,LOW(1)
	STS  _cnt_bd1,R30
;     231 		if(cnt_bd1==0) bBD1=0;
	CPI  R30,0
	BRNE _0x31
	CLT
	BLD  R3,4
;     232 		}
_0x31:
;     233 
;     234 	}
_0x30:
_0x2F:
;     235 
;     236 if(!(in_word&(1<<BD2)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x10)
	BRNE _0x32
;     237 	{
;     238 	if(cnt_bd2<10)
	LDS  R26,_cnt_bd2
	CPI  R26,LOW(0xA)
	BRSH _0x33
;     239 		{
;     240 		cnt_bd2++;
	LDS  R30,_cnt_bd2
	SUBI R30,-LOW(1)
	STS  _cnt_bd2,R30
;     241 		if(cnt_bd2==10) bBD2=1;
	LDS  R26,_cnt_bd2
	CPI  R26,LOW(0xA)
	BRNE _0x34
	SET
	BLD  R3,5
;     242 		}
_0x34:
;     243 
;     244 	}
_0x33:
;     245 else
	RJMP _0x35
_0x32:
;     246 	{
;     247 	if(cnt_bd2)
	LDS  R30,_cnt_bd2
	CPI  R30,0
	BREQ _0x36
;     248 		{
;     249 		cnt_bd2--;
	SUBI R30,LOW(1)
	STS  _cnt_bd2,R30
;     250 		if(cnt_bd2==0) bBD2=0;
	CPI  R30,0
	BRNE _0x37
	CLT
	BLD  R3,5
;     251 		}
_0x37:
;     252 
;     253 	}
_0x36:
_0x35:
;     254 
;     255 if(!(in_word&(1<<DM)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x2)
	BRNE _0x38
;     256 	{
;     257 	if(cnt_dm<10)
	LDS  R26,_cnt_dm
	CPI  R26,LOW(0xA)
	BRSH _0x39
;     258 		{
;     259 		cnt_dm++;
	LDS  R30,_cnt_dm
	SUBI R30,-LOW(1)
	STS  _cnt_dm,R30
;     260 		if(cnt_dm==10) bDM=1;
	LDS  R26,_cnt_dm
	CPI  R26,LOW(0xA)
	BRNE _0x3A
	SET
	BLD  R3,6
;     261 		}
_0x3A:
;     262 	}
_0x39:
;     263 else
	RJMP _0x3B
_0x38:
;     264 	{
;     265 	if(cnt_dm)
	LDS  R30,_cnt_dm
	CPI  R30,0
	BREQ _0x3C
;     266 		{
;     267 		cnt_dm--;
	SUBI R30,LOW(1)
	STS  _cnt_dm,R30
;     268 		if(cnt_dm==0) bDM=0;
	CPI  R30,0
	BRNE _0x3D
	CLT
	BLD  R3,6
;     269 		}
_0x3D:
;     270 	}
_0x3C:
_0x3B:
;     271 
;     272 if(!(in_word&(1<<START)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x1)
	BRNE _0x3E
;     273 	{
;     274 	if(cnt_start<10)
	LDS  R26,_cnt_start
	CPI  R26,LOW(0xA)
	BRSH _0x3F
;     275 		{
;     276 		cnt_start++;
	LDS  R30,_cnt_start
	SUBI R30,-LOW(1)
	STS  _cnt_start,R30
;     277 		if(cnt_start==10) 
	LDS  R26,_cnt_start
	CPI  R26,LOW(0xA)
	BRNE _0x40
;     278 			{
;     279 			bSTART=1;
	SET
	BLD  R3,7
;     280 			main_loop_cmd==cmdSTART;
	LDS  R26,_main_loop_cmd
	LDI  R30,LOW(1)
	CALL __EQB12
;     281 			}
;     282 		}
_0x40:
;     283 	}
_0x3F:
;     284 else
	RJMP _0x41
_0x3E:
;     285 	{
;     286 	if(cnt_start)
	LDS  R30,_cnt_start
	CPI  R30,0
	BREQ _0x42
;     287 		{
;     288 		cnt_start--;
	SUBI R30,LOW(1)
	STS  _cnt_start,R30
;     289 		if(cnt_start==0) bSTART=0;
	CPI  R30,0
	BRNE _0x43
	CLT
	BLD  R3,7
;     290 		}
_0x43:
;     291 	} 
_0x42:
_0x41:
;     292 
;     293 if(!(in_word&(1<<STOP)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x4)
	BRNE _0x44
;     294 	{
;     295 	if(cnt_stop<10)
	LDS  R26,_cnt_stop
	CPI  R26,LOW(0xA)
	BRSH _0x45
;     296 		{
;     297 		cnt_stop++;
	LDS  R30,_cnt_stop
	SUBI R30,-LOW(1)
	STS  _cnt_stop,R30
;     298 		if(cnt_stop==10) bSTOP=1;
	LDS  R26,_cnt_stop
	CPI  R26,LOW(0xA)
	BRNE _0x46
	SET
	BLD  R4,0
;     299 		}
_0x46:
;     300 	}
_0x45:
;     301 else
	RJMP _0x47
_0x44:
;     302 	{
;     303 	if(cnt_stop)
	LDS  R30,_cnt_stop
	CPI  R30,0
	BREQ _0x48
;     304 		{
;     305 		cnt_stop--;
	SUBI R30,LOW(1)
	STS  _cnt_stop,R30
;     306 		if(cnt_stop==0) bSTOP=0;
	CPI  R30,0
	BRNE _0x49
	CLT
	BLD  R4,0
;     307 		}
_0x49:
;     308 	} 
_0x48:
_0x47:
;     309 } 
	RET
;     310 
;     311 //-----------------------------------------------
;     312 void main_loop_hndl(void)
;     313 {
_main_loop_hndl:
;     314 if(main_loop_cmd==cmdSTART)
	LDS  R26,_main_loop_cmd
	CPI  R26,LOW(0x1)
	BRNE _0x4A
;     315 	{
;     316 	orient_cmd=cmdSTOP;
	CALL SUBOPT_0x1
;     317 	napoln_cmd=cmdSTOP;
;     318 	payka_cmd=cmdSTOP;
;     319 	main_loop_cmd=cmdOFF; 
	STS  _main_loop_cmd,R30
;     320 	
;     321 	if(ee_prog==EE_PROG_ONLY_ORIENT)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x4B
;     322 		{
;     323 		orient_cmd=cmdSTART;
	LDI  R30,LOW(1)
	STS  _orient_cmd,R30
;     324 		}  
;     325 	else if(ee_prog==EE_PROG_ONLY_NAPOLN)
	RJMP _0x4C
_0x4B:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x4D
;     326 		{
;     327 		napoln_cmd=cmdSTART;
	LDI  R30,LOW(1)
	STS  _napoln_cmd,R30
;     328 		}   
;     329 	else if(ee_prog==EE_PROG_ONLY_PAYKA)
	RJMP _0x4E
_0x4D:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x4F
;     330 		{
;     331 		payka_cmd=cmdSTART;
	LDI  R30,LOW(1)
	STS  _payka_cmd,R30
;     332 		}
;     333 	else if((ee_prog==EE_PROG_ONLY_MAIN_LOOP)||(ee_prog==EE_PROG_FULL))
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
;     334 		{
;     335 		main_loop_step=s1;
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2
;     336 		main_loop_cnt_del=20;
;     337 		}						
;     338 
;     339 	}                      
_0x51:
_0x50:
_0x4E:
_0x4C:
;     340 else if(main_loop_cmd==cmdSTOP)
	RJMP _0x54
_0x4A:
	LDS  R26,_main_loop_cmd
	CPI  R26,LOW(0x2)
	BRNE _0x55
;     341 	{
;     342 	orient_cmd=cmdSTOP;
	CALL SUBOPT_0x1
;     343 	napoln_cmd=cmdSTOP;
;     344 	payka_cmd=cmdSTOP;
;     345 	main_loop_step=sOFF;
	STS  _main_loop_step,R30
;     346 	}
;     347 
;     348 if(main_loop_step==sOFF)
_0x55:
_0x54:
	LDS  R30,_main_loop_step
	CPI  R30,0
	BRNE _0x56
;     349 	{
;     350 	bPP1=0;
	CLT
	BLD  R4,1
;     351 	bPP2=0;              
	CLT
	BLD  R4,2
;     352 	}
;     353 else if(main_loop_step==s1)
	RJMP _0x57
_0x56:
	LDS  R26,_main_loop_step
	CPI  R26,LOW(0x1)
	BRNE _0x58
;     354 	{
;     355 	bPP1=1;
	SET
	BLD  R4,1
;     356 	bPP2=0;              
	CLT
	BLD  R4,2
;     357 	main_loop_cnt_del--;
	CALL SUBOPT_0x3
;     358 	if(main_loop_cnt_del==0)
	BRNE _0x59
;     359 		{
;     360 		main_loop_step=s2;
	LDI  R30,LOW(2)
	STS  _main_loop_step,R30
;     361 		}
;     362 	}
_0x59:
;     363 else if(main_loop_step==s2)
	RJMP _0x5A
_0x58:
	LDS  R26,_main_loop_step
	CPI  R26,LOW(0x2)
	BRNE _0x5B
;     364 	{
;     365 	bPP1=1;
	SET
	BLD  R4,1
;     366 	bPP2=1;              
	SET
	BLD  R4,2
;     367 	if(bMD1)
	SBRS R3,2
	RJMP _0x5C
;     368 		{
;     369 		main_loop_step=s3;
	LDI  R30,LOW(3)
	CALL SUBOPT_0x2
;     370 		main_loop_cnt_del=20;
;     371 		}
;     372 	} 
_0x5C:
;     373 else if(main_loop_step==s3)
	RJMP _0x5D
_0x5B:
	LDS  R26,_main_loop_step
	CPI  R26,LOW(0x3)
	BRNE _0x5E
;     374 	{
;     375 	bPP1=0;
	CLT
	BLD  R4,1
;     376 	bPP2=1;              
	SET
	BLD  R4,2
;     377 	main_loop_cnt_del--;
	CALL SUBOPT_0x3
;     378 	if(main_loop_cnt_del==0)
	BRNE _0x5F
;     379 		{
;     380 		if(ee_prog==EE_PROG_ONLY_MAIN_LOOP)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x60
;     381 			{
;     382 			if(ee_loop_mode==elmAUTO)main_loop_cmd=cmdSTART;
	LDI  R26,LOW(_ee_loop_mode)
	LDI  R27,HIGH(_ee_loop_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0x61
	LDI  R30,LOW(1)
	STS  _main_loop_cmd,R30
;     383 			else main_loop_step=sOFF;
	RJMP _0x62
_0x61:
	LDI  R30,LOW(0)
	STS  _main_loop_step,R30
_0x62:
;     384 			}
;     385 		else if(ee_prog==EE_PROG_FULL)
	RJMP _0x63
_0x60:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	SBIW R30,0
	BRNE _0x64
;     386 			{
;     387 			orient_cmd=cmdSTART;
	LDI  R30,LOW(1)
	STS  _orient_cmd,R30
;     388 			napoln_cmd=cmdSTART;
	STS  _napoln_cmd,R30
;     389 			payka_cmd=cmdSTART;
	STS  _payka_cmd,R30
;     390 			main_loop_step=s4;
	LDI  R30,LOW(4)
	STS  _main_loop_step,R30
;     391 			}
;     392 		}
_0x64:
_0x63:
;     393 	}				        
_0x5F:
;     394 else if(main_loop_step==s4)
	RJMP _0x65
_0x5E:
	LDS  R26,_main_loop_step
	CPI  R26,LOW(0x4)
	BRNE _0x66
;     395 	{
;     396 	bPP1=0;
	CLT
	BLD  R4,1
;     397 	bPP2=0;                    
	CLT
	BLD  R4,2
;     398 	if(bORIENT_COMPLETE && bNAPOLN_COMPLETE && bPAYKA_COMPLETE)
	SBRS R5,3
	RJMP _0x68
	SBRS R5,2
	RJMP _0x68
	SBRC R5,1
	RJMP _0x69
_0x68:
	RJMP _0x67
_0x69:
;     399 		{
;     400 		if(ee_loop_mode==elmAUTO)main_loop_cmd=cmdSTART;
	LDI  R26,LOW(_ee_loop_mode)
	LDI  R27,HIGH(_ee_loop_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0x6A
	LDI  R30,LOW(1)
	STS  _main_loop_cmd,R30
;     401 		else main_loop_step=sOFF;
	RJMP _0x6B
_0x6A:
	LDI  R30,LOW(0)
	STS  _main_loop_step,R30
_0x6B:
;     402 		}
;     403 	
;     404 	}	
_0x67:
;     405 	 
;     406 }
_0x66:
_0x65:
_0x5D:
_0x5A:
_0x57:
	RET
;     407 
;     408 //-----------------------------------------------
;     409 void payka_hndl(void)
;     410 {
_payka_hndl:
;     411 if(payka_cmd==cmdSTART)
	LDS  R26,_payka_cmd
	CPI  R26,LOW(0x1)
	BRNE _0x6C
;     412 	{
;     413 	payka_step=s1;
	LDI  R30,LOW(1)
	STS  _payka_step,R30
;     414 	payka_cnt_del=ee_temp1*10;
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	CALL SUBOPT_0x4
;     415 	bPAYKA_COMPLETE=0;
	CLT
	BLD  R5,1
;     416 	payka_cmd=cmdOFF;
	LDI  R30,LOW(0)
	STS  _payka_cmd,R30
;     417 	}                      
;     418 else if(payka_cmd==cmdSTOP)
	RJMP _0x6D
_0x6C:
	LDS  R26,_payka_cmd
	CPI  R26,LOW(0x2)
	BRNE _0x6E
;     419 	{
;     420 	payka_step=sOFF;
	LDI  R30,LOW(0)
	STS  _payka_step,R30
;     421 	payka_cmd=cmdOFF;
	STS  _payka_cmd,R30
;     422 	} 
;     423 		
;     424 if(payka_step==sOFF)
_0x6E:
_0x6D:
	LDS  R30,_payka_step
	CPI  R30,0
	BRNE _0x6F
;     425 	{
;     426 	bPP6=0;
	CLT
	BLD  R4,6
;     427 	bPP7=0;
	CLT
	BLD  R4,7
;     428 	}      
;     429 else if(payka_step==s1)
	RJMP _0x70
_0x6F:
	LDS  R26,_payka_step
	CPI  R26,LOW(0x1)
	BRNE _0x71
;     430 	{
;     431 	bPP6=1;
	SET
	BLD  R4,6
;     432 	bPP7=0;
	CLT
	BLD  R4,7
;     433 	payka_cnt_del--;
	CALL SUBOPT_0x5
;     434 	if(payka_cnt_del==0)
	BRNE _0x72
;     435 		{
;     436 		payka_step=s2;
	LDI  R30,LOW(2)
	STS  _payka_step,R30
;     437 		payka_cnt_del=20;
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _payka_cnt_del,R30
	STS  _payka_cnt_del+1,R31
;     438 		}                	
;     439 	}	
_0x72:
;     440 else if(payka_step==s2)
	RJMP _0x73
_0x71:
	LDS  R26,_payka_step
	CPI  R26,LOW(0x2)
	BRNE _0x74
;     441 	{
;     442 	bPP6=0;
	CLT
	BLD  R4,6
;     443 	bPP7=0;
	CLT
	BLD  R4,7
;     444 	payka_cnt_del--;
	CALL SUBOPT_0x5
;     445 	if(payka_cnt_del==0)
	BRNE _0x75
;     446 		{
;     447 		payka_step=s3;
	LDI  R30,LOW(3)
	STS  _payka_step,R30
;     448 		payka_cnt_del=ee_temp2*10;
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	CALL SUBOPT_0x4
;     449 		}                	
;     450 	}		  
_0x75:
;     451 else if(payka_step==s3)
	RJMP _0x76
_0x74:
	LDS  R26,_payka_step
	CPI  R26,LOW(0x3)
	BRNE _0x77
;     452 	{
;     453 	bPP6=0;
	CLT
	BLD  R4,6
;     454 	bPP7=1;
	SET
	BLD  R4,7
;     455 	payka_cnt_del--;
	CALL SUBOPT_0x5
;     456 	if(payka_cnt_del==0)
	BRNE _0x78
;     457 		{
;     458 		payka_step=sOFF;
	LDI  R30,LOW(0)
	STS  _payka_step,R30
;     459 		bPAYKA_COMPLETE=1;
	SET
	BLD  R5,1
;     460 		}                	
;     461 	}			
_0x78:
;     462 }
_0x77:
_0x76:
_0x73:
_0x70:
	RET
;     463 
;     464 //-----------------------------------------------
;     465 void napoln_hndl(void)
;     466 {
_napoln_hndl:
;     467 if(napoln_cmd==cmdSTART)
	LDS  R26,_napoln_cmd
	CPI  R26,LOW(0x1)
	BRNE _0x79
;     468 	{
;     469 	napoln_step=s1;
	LDI  R30,LOW(1)
	STS  _napoln_step,R30
;     470 	napoln_cnt_del=0;
	LDI  R30,0
	STS  _napoln_cnt_del,R30
	STS  _napoln_cnt_del+1,R30
;     471 	bNAPOLN_COMPLETE=0;
	CLT
	BLD  R5,2
;     472 	
;     473 	napoln_cmd=cmdOFF;
	LDI  R30,LOW(0)
	STS  _napoln_cmd,R30
;     474 	}                      
;     475 else if(napoln_cmd==cmdSTOP)
	RJMP _0x7A
_0x79:
	LDS  R26,_napoln_cmd
	CPI  R26,LOW(0x2)
	BRNE _0x7B
;     476 	{
;     477 	napoln_step=sOFF;
	LDI  R30,LOW(0)
	STS  _napoln_step,R30
;     478 	napoln_cmd=cmdOFF;
	STS  _napoln_cmd,R30
;     479 	} 
;     480 		
;     481 if(napoln_step==sOFF)
_0x7B:
_0x7A:
	LDS  R30,_napoln_step
	CPI  R30,0
	BRNE _0x7C
;     482 	{
;     483 	bPP4=0;
	CLT
	BLD  R4,4
;     484 	bPP5=0;
	CLT
	BLD  R4,5
;     485 	}      
;     486 else if(napoln_step==s1)
	RJMP _0x7D
_0x7C:
	LDS  R26,_napoln_step
	CPI  R26,LOW(0x1)
	BRNE _0x7E
;     487 	{
;     488 	bPP4=0;
	CLT
	BLD  R4,4
;     489 	bPP5=0;
	CLT
	BLD  R4,5
;     490 	if(bBD2)
	SBRS R3,5
	RJMP _0x7F
;     491 		{
;     492 		napoln_step=s2;
	LDI  R30,LOW(2)
	STS  _napoln_step,R30
;     493 		napoln_cnt_del=20;
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _napoln_cnt_del,R30
	STS  _napoln_cnt_del+1,R31
;     494 		}
;     495 	}	
_0x7F:
;     496 else if(napoln_step==s2)
	RJMP _0x80
_0x7E:
	LDS  R26,_napoln_step
	CPI  R26,LOW(0x2)
	BRNE _0x81
;     497 	{
;     498 	bPP4=1;
	SET
	BLD  R4,4
;     499 	bPP5=0;
	CLT
	BLD  R4,5
;     500 	napoln_cnt_del--;
	LDS  R30,_napoln_cnt_del
	LDS  R31,_napoln_cnt_del+1
	SBIW R30,1
	STS  _napoln_cnt_del,R30
	STS  _napoln_cnt_del+1,R31
;     501 	if(napoln_cnt_del==0)
	SBIW R30,0
	BRNE _0x82
;     502 		{
;     503 		napoln_step=s3;
	LDI  R30,LOW(3)
	STS  _napoln_step,R30
;     504 		}                	
;     505 	}		  
_0x82:
;     506 else if(napoln_step==s3)
	RJMP _0x83
_0x81:
	LDS  R26,_napoln_step
	CPI  R26,LOW(0x3)
	BRNE _0x84
;     507 	{
;     508 	bPP4=1;
	SET
	BLD  R4,4
;     509 	bPP5=1;
	SET
	BLD  R4,5
;     510 	//napoln_cnt_del--;
;     511 	if(bMD2)
	SBRS R3,3
	RJMP _0x85
;     512 		{
;     513 		napoln_step=sOFF;
	LDI  R30,LOW(0)
	STS  _napoln_step,R30
;     514 		bNAPOLN_COMPLETE=1;
	SET
	BLD  R5,2
;     515 		}                	
;     516 	}			
_0x85:
;     517 }
_0x84:
_0x83:
_0x80:
_0x7D:
	RET
;     518 
;     519 //-----------------------------------------------
;     520 void orient_hndl(void)
;     521 {
_orient_hndl:
;     522 if(orient_cmd==cmdSTART)
	LDS  R26,_orient_cmd
	CPI  R26,LOW(0x1)
	BRNE _0x86
;     523 	{
;     524 	orient_step=s1;
	LDI  R30,LOW(1)
	STS  _orient_step,R30
;     525 	orient_cnt_del=0;
	LDI  R30,0
	STS  _orient_cnt_del,R30
	STS  _orient_cnt_del+1,R30
;     526 	bORIENT_COMPLETE=0;
	CLT
	BLD  R5,3
;     527 	
;     528 	orient_cmd=cmdOFF;
	LDI  R30,LOW(0)
	STS  _orient_cmd,R30
;     529 	}                      
;     530 else if(orient_cmd==cmdSTOP)
	RJMP _0x87
_0x86:
	LDS  R26,_orient_cmd
	CPI  R26,LOW(0x2)
	BRNE _0x88
;     531 	{
;     532 	orient_step=sOFF;
	LDI  R30,LOW(0)
	STS  _orient_step,R30
;     533 	orient_cmd=cmdOFF;
	STS  _orient_cmd,R30
;     534 	} 
;     535 		
;     536 if(orient_step==sOFF)
_0x88:
_0x87:
	LDS  R30,_orient_step
	CPI  R30,0
	BRNE _0x89
;     537 	{
;     538 	bPP3=0;
	CLT
	BLD  R4,3
;     539 	} 
;     540 	
;     541 else if(orient_step==s1)
	RJMP _0x8A
_0x89:
	LDS  R26,_orient_step
	CPI  R26,LOW(0x1)
	BRNE _0x8B
;     542 	{
;     543 	bPP3=0;
	CLT
	BLD  R4,3
;     544 	if(bBD1)
	SBRS R3,4
	RJMP _0x8C
;     545 		{
;     546 		orient_step=s2;
	LDI  R30,LOW(2)
	STS  _orient_step,R30
;     547 		}
;     548 	}	
_0x8C:
;     549 		     
;     550 else if(orient_step==s2)
	RJMP _0x8D
_0x8B:
	LDS  R26,_orient_step
	CPI  R26,LOW(0x2)
	BRNE _0x8E
;     551 	{
;     552 	bPP3=1;
	SET
	BLD  R4,3
;     553 	if(!bDM)
	SBRC R3,6
	RJMP _0x8F
;     554 		{
;     555 		orient_step=s3;
	LDI  R30,LOW(3)
	STS  _orient_step,R30
;     556 		}
;     557 	}	
_0x8F:
;     558 else if(orient_step==s3)
	RJMP _0x90
_0x8E:
	LDS  R26,_orient_step
	CPI  R26,LOW(0x3)
	BRNE _0x91
;     559 	{
;     560 	bPP3=1;
	SET
	BLD  R4,3
;     561 	if(bDM)
	SBRS R3,6
	RJMP _0x92
;     562 		{
;     563 		orient_step=sOFF;
	LDI  R30,LOW(0)
	STS  _orient_step,R30
;     564 		bORIENT_COMPLETE=1;
	SET
	BLD  R5,3
;     565 		}               	
;     566 	}		  
_0x92:
;     567 }
_0x91:
_0x90:
_0x8D:
_0x8A:
	RET
;     568 
;     569 //-----------------------------------------------
;     570 void out_drv(void)
;     571 {
_out_drv:
;     572 char temp=0;
;     573 DDRB=0xFF;
	ST   -Y,R16
;	temp -> R16
	LDI  R16,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     574 
;     575 if(bPP1) temp|=(1<<PP1);
	SBRS R4,1
	RJMP _0x93
	ORI  R16,LOW(64)
;     576 if(bPP2) temp|=(1<<PP2);
_0x93:
	SBRS R4,2
	RJMP _0x94
	ORI  R16,LOW(128)
;     577 if(bPP3) temp|=(1<<PP3);
_0x94:
	SBRS R4,3
	RJMP _0x95
	ORI  R16,LOW(32)
;     578 if(bPP4) temp|=(1<<PP4);
_0x95:
	SBRS R4,4
	RJMP _0x96
	ORI  R16,LOW(16)
;     579 if(bPP5) temp|=(1<<PP5);
_0x96:
	SBRS R4,5
	RJMP _0x97
	ORI  R16,LOW(8)
;     580 if(bPP6) temp|=(1<<PP6);
_0x97:
	SBRS R4,6
	RJMP _0x98
	ORI  R16,LOW(4)
;     581 if(bPP7) temp|=(1<<PP7);
_0x98:
	SBRS R4,7
	RJMP _0x99
	ORI  R16,LOW(2)
;     582 
;     583 PORTB=~temp;
_0x99:
	CALL SUBOPT_0x6
;     584 //PORTB=0x55;
;     585 }
	RJMP _0x170
;     586 
;     587 //-----------------------------------------------
;     588 void step_contr(void)
;     589 {
_step_contr:
;     590 char temp=0;
;     591 DDRB=0xFF;
	ST   -Y,R16
;	temp -> R16
	LDI  R16,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     592 
;     593 if(step==sOFF)goto step_contr_end;
	TST  R13
	BRNE _0x9A
	RJMP _0x9B
;     594 
;     595 else if(prog==p1)
_0x9A:
	LDI  R30,LOW(1)
	CP   R30,R12
	BREQ PC+3
	JMP _0x9D
;     596 	{
;     597 	if(step==s1)    //жесть
	CP   R30,R13
	BRNE _0x9E
;     598 		{
;     599 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     600           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x9B
;     601 
;     602 			//if(ee_vacuum_mode==evmOFF)
;     603 				{
;     604 				//goto lbl_0001;
;     605 				}
;     606 			//else step=s2;
;     607 		}
;     608 
;     609 	else if(step==s2)
	RJMP _0xA0
_0x9E:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0xA1
;     610 		{
;     611 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;     612  //         if(!bVR)goto step_contr_end;
;     613 lbl_0001:
;     614 
;     615           step=s100;
	CALL SUBOPT_0x7
;     616 		cnt_del=40;
;     617           }
;     618 	else if(step==s100)
	RJMP _0xA3
_0xA1:
	LDI  R30,LOW(19)
	CP   R30,R13
	BRNE _0xA4
;     619 		{
;     620 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     621           cnt_del--;
	CALL SUBOPT_0x8
;     622           if(cnt_del==0)
	BRNE _0xA5
;     623 			{
;     624           	step=s3;
	CALL SUBOPT_0x9
;     625           	cnt_del=50;
;     626 			}
;     627 		}
_0xA5:
;     628 
;     629 	else if(step==s3)
	RJMP _0xA6
_0xA4:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0xA7
;     630 		{
;     631 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     632           cnt_del--;
	CALL SUBOPT_0x8
;     633           if(cnt_del==0)
	BRNE _0xA8
;     634 			{
;     635           	step=s4;
	LDI  R30,LOW(4)
	MOV  R13,R30
;     636 			}
;     637 		}
_0xA8:
;     638 	else if(step==s4)
	RJMP _0xA9
_0xA7:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0xAA
;     639 		{
;     640 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5);
	ORI  R16,LOW(248)
;     641           if(!bMD2)goto step_contr_end;
	SBRS R3,3
	RJMP _0x9B
;     642           step=s5;
	CALL SUBOPT_0xA
;     643           cnt_del=20;
;     644 		}
;     645 	else if(step==s5)
	RJMP _0xAC
_0xAA:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0xAD
;     646 		{
;     647 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     648           cnt_del--;
	CALL SUBOPT_0x8
;     649           if(cnt_del==0)
	BRNE _0xAE
;     650 			{
;     651           	step=s6;
	LDI  R30,LOW(6)
	MOV  R13,R30
;     652 			}
;     653           }
_0xAE:
;     654 	else if(step==s6)
	RJMP _0xAF
_0xAD:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0xB0
;     655 		{
;     656 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP7);
	ORI  R16,LOW(242)
;     657  //         if(!bMD3)goto step_contr_end;
;     658           step=s7;
	CALL SUBOPT_0xB
;     659           cnt_del=20;
;     660 		}
;     661 
;     662 	else if(step==s7)
	RJMP _0xB1
_0xB0:
	LDI  R30,LOW(7)
	CP   R30,R13
	BRNE _0xB2
;     663 		{
;     664 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     665           cnt_del--;
	CALL SUBOPT_0x8
;     666           if(cnt_del==0)
	BRNE _0xB3
;     667 			{
;     668           	step=s8;
	LDI  R30,LOW(8)
	MOV  R13,R30
;     669           	//cnt_del=ee_delay[prog,0]*10U;;
;     670 			}
;     671           }
_0xB3:
;     672 	else if(step==s8)
	RJMP _0xB4
_0xB2:
	LDI  R30,LOW(8)
	CP   R30,R13
	BRNE _0xB5
;     673 		{
;     674 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;     675           cnt_del--;
	CALL SUBOPT_0x8
;     676           if(cnt_del==0)
	BRNE _0xB6
;     677 			{
;     678           	step=s9;
	LDI  R30,LOW(9)
	CALL SUBOPT_0xC
;     679           	cnt_del=20;
;     680 			}
;     681           }
_0xB6:
;     682 	else if(step==s9)
	RJMP _0xB7
_0xB5:
	LDI  R30,LOW(9)
	CP   R30,R13
	BRNE _0xB8
;     683 		{
;     684 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     685           cnt_del--;
	CALL SUBOPT_0x8
;     686           if(cnt_del==0)
	BRNE _0xB9
;     687 			{
;     688           	step=sOFF;
	CLR  R13
;     689           	}
;     690           }
_0xB9:
;     691 	}
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
;     692 
;     693 else if(prog==p2)  //ско
	RJMP _0xBA
_0x9D:
	LDI  R30,LOW(2)
	CP   R30,R12
	BREQ PC+3
	JMP _0xBB
;     694 	{
;     695 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0xBC
;     696 		{
;     697 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     698           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x9B
;     699 
;     700 		/*	if(ee_vacuum_mode==evmOFF)
;     701 				{
;     702 				goto lbl_0002;
;     703 				}
;     704 			else step=s2; */
;     705 
;     706           //step=s2;
;     707 		}
;     708 
;     709 	else if(step==s2)
	RJMP _0xBE
_0xBC:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0xBF
;     710 		{
;     711 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;     712  //         if(!bVR)goto step_contr_end;
;     713 
;     714 lbl_0002:
;     715           step=s100;
	CALL SUBOPT_0x7
;     716 		cnt_del=40;
;     717           }
;     718 	else if(step==s100)
	RJMP _0xC1
_0xBF:
	LDI  R30,LOW(19)
	CP   R30,R13
	BRNE _0xC2
;     719 		{
;     720 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     721           cnt_del--;
	CALL SUBOPT_0x8
;     722           if(cnt_del==0)
	BRNE _0xC3
;     723 			{
;     724           	step=s3;
	CALL SUBOPT_0x9
;     725           	cnt_del=50;
;     726 			}
;     727 		}
_0xC3:
;     728 	else if(step==s3)
	RJMP _0xC4
_0xC2:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0xC5
;     729 		{
;     730 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     731           cnt_del--;
	CALL SUBOPT_0x8
;     732           if(cnt_del==0)
	BRNE _0xC6
;     733 			{
;     734           	step=s4;
	LDI  R30,LOW(4)
	MOV  R13,R30
;     735 			}
;     736 		}
_0xC6:
;     737 	else if(step==s4)
	RJMP _0xC7
_0xC5:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0xC8
;     738 		{
;     739 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5);
	ORI  R16,LOW(248)
;     740           if(!bMD2)goto step_contr_end;
	SBRS R3,3
	RJMP _0x9B
;     741           step=s5;
	CALL SUBOPT_0xA
;     742           cnt_del=20;
;     743 		}
;     744 	else if(step==s5)
	RJMP _0xCA
_0xC8:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0xCB
;     745 		{
;     746 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     747           cnt_del--;
	CALL SUBOPT_0x8
;     748           if(cnt_del==0)
	BRNE _0xCC
;     749 			{
;     750           	step=s6;
	LDI  R30,LOW(6)
	MOV  R13,R30
;     751           	//cnt_del=ee_delay[prog,0]*10U;
;     752 			}
;     753           }
_0xCC:
;     754 	else if(step==s6)
	RJMP _0xCD
_0xCB:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0xCE
;     755 		{
;     756 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;     757           cnt_del--;
	CALL SUBOPT_0x8
;     758           if(cnt_del==0)
	BRNE _0xCF
;     759 			{
;     760           	step=s7;
	CALL SUBOPT_0xB
;     761           	cnt_del=20;
;     762 			}
;     763           }
_0xCF:
;     764 	else if(step==s7)
	RJMP _0xD0
_0xCE:
	LDI  R30,LOW(7)
	CP   R30,R13
	BRNE _0xD1
;     765 		{
;     766 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     767           cnt_del--;
	CALL SUBOPT_0x8
;     768           if(cnt_del==0)
	BRNE _0xD2
;     769 			{
;     770           	step=sOFF;
	CLR  R13
;     771           	}
;     772           }
_0xD2:
;     773 	}
_0xD1:
_0xD0:
_0xCD:
_0xCA:
_0xC7:
_0xC4:
_0xC1:
_0xBE:
;     774 
;     775 else if(prog==p3)   //твист
	RJMP _0xD3
_0xBB:
	LDI  R30,LOW(3)
	CP   R30,R12
	BRNE _0xD4
;     776 	{
;     777 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0xD5
;     778 		{
;     779 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     780           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x9B
;     781 
;     782 		/*	if(ee_vacuum_mode==evmOFF)
;     783 				{
;     784 				goto lbl_0003;
;     785 				}
;     786 			else step=s2;*/
;     787 
;     788           //step=s2;
;     789 		}
;     790 
;     791 	else if(step==s2)
	RJMP _0xD7
_0xD5:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0xD8
;     792 		{
;     793 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;     794  //         if(!bVR)goto step_contr_end;
;     795 lbl_0003:
;     796           cnt_del=50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;     797 		step=s3;
	LDI  R30,LOW(3)
	MOV  R13,R30
;     798 		}
;     799 
;     800 
;     801 	else	if(step==s3)
	RJMP _0xDA
_0xD8:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0xDB
;     802 		{
;     803 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     804 		cnt_del--;
	CALL SUBOPT_0x8
;     805 		if(cnt_del==0)
	BRNE _0xDC
;     806 			{
;     807 			//cnt_del=ee_delay[prog,0]*10U;
;     808 			step=s4;
	LDI  R30,LOW(4)
	MOV  R13,R30
;     809 			}
;     810           }
_0xDC:
;     811 	else if(step==s4)
	RJMP _0xDD
_0xDB:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0xDE
;     812 		{
;     813 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
	ORI  R16,LOW(250)
;     814 		cnt_del--;
	CALL SUBOPT_0x8
;     815  		if(cnt_del==0)
	BRNE _0xDF
;     816 			{
;     817 		    //	cnt_del=ee_delay[prog,1]*10U;
;     818 			step=s5;
	LDI  R30,LOW(5)
	MOV  R13,R30
;     819 			}
;     820 		}
_0xDF:
;     821 
;     822 	else if(step==s5)
	RJMP _0xE0
_0xDE:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0xE1
;     823 		{
;     824 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
	ORI  R16,LOW(202)
;     825 		cnt_del--;
	CALL SUBOPT_0x8
;     826 		if(cnt_del==0)
	BRNE _0xE2
;     827 			{
;     828 			step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0xC
;     829 			cnt_del=20;
;     830 			}
;     831 		}
_0xE2:
;     832 
;     833 	else if(step==s6)
	RJMP _0xE3
_0xE1:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0xE4
;     834 		{
;     835 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     836   		cnt_del--;
	CALL SUBOPT_0x8
;     837 		if(cnt_del==0)
	BRNE _0xE5
;     838 			{
;     839 			step=sOFF;
	CLR  R13
;     840 			}
;     841 		}
_0xE5:
;     842 
;     843 	}
_0xE4:
_0xE3:
_0xE0:
_0xDD:
_0xDA:
_0xD7:
;     844 
;     845 else if(prog==p4)      //замок
	RJMP _0xE6
_0xD4:
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0xE7
;     846 	{
;     847 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0xE8
;     848 		{
;     849 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     850           if(!bMD1)goto step_contr_end;
	SBRS R3,2
	RJMP _0x9B
;     851 
;     852 		 /*	if(ee_vacuum_mode==evmOFF)
;     853 				{
;     854 				goto lbl_0004;
;     855 				}
;     856 			else step=s2;*/
;     857           //step=s2;
;     858 		}
;     859 
;     860 	else if(step==s2)
	RJMP _0xEA
_0xE8:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0xEB
;     861 		{
;     862 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;     863  //         if(!bVR)goto step_contr_end;
;     864 lbl_0004:
;     865           step=s3;
	CALL SUBOPT_0x9
;     866 		cnt_del=50;
;     867           }
;     868 
;     869 	else if(step==s3)
	RJMP _0xED
_0xEB:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0xEE
;     870 		{
;     871 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;     872           cnt_del--;
	CALL SUBOPT_0x8
;     873           if(cnt_del==0)
	BRNE _0xEF
;     874 			{
;     875           	step=s4;
	LDI  R30,LOW(4)
	MOV  R13,R30
;     876 			//cnt_del=ee_delay[prog,0]*10U;
;     877 			}
;     878           }
_0xEF:
;     879 
;     880    	else if(step==s4)
	RJMP _0xF0
_0xEE:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0xF1
;     881 		{
;     882 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;     883 		cnt_del--;
	CALL SUBOPT_0x8
;     884 		if(cnt_del==0)
	BRNE _0xF2
;     885 			{
;     886 			step=s5;
	LDI  R30,LOW(5)
	MOV  R13,R30
;     887 			cnt_del=30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;     888 			}
;     889 		}
_0xF2:
;     890 
;     891 	else if(step==s5)
	RJMP _0xF3
_0xF1:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0xF4
;     892 		{
;     893 		temp|=(1<<PP1)|(1<<PP4);
	ORI  R16,LOW(80)
;     894 		cnt_del--;
	CALL SUBOPT_0x8
;     895 		if(cnt_del==0)
	BRNE _0xF5
;     896 			{
;     897 			step=s6;
	LDI  R30,LOW(6)
	MOV  R13,R30
;     898 			//cnt_del=ee_delay[prog,1]*10U;
;     899 			}
;     900 		}
_0xF5:
;     901 
;     902 	else if(step==s6)
	RJMP _0xF6
_0xF4:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0xF7
;     903 		{
;     904 		temp|=(1<<PP4);
	ORI  R16,LOW(16)
;     905 		cnt_del--;
	CALL SUBOPT_0x8
;     906 		if(cnt_del==0)
	BRNE _0xF8
;     907 			{
;     908 			step=sOFF;
	CLR  R13
;     909 			}
;     910 		}
_0xF8:
;     911 
;     912 	}
_0xF7:
_0xF6:
_0xF3:
_0xF0:
_0xED:
_0xEA:
;     913 	
;     914 step_contr_end:
_0xE7:
_0xE6:
_0xD3:
_0xBA:
_0x9B:
;     915 
;     916 //if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;     917 
;     918 PORTB=~temp;
	CALL SUBOPT_0x6
;     919 //PORTB=0x55;
;     920 }
_0x170:
	LD   R16,Y+
	RET
;     921 
;     922 
;     923 //-----------------------------------------------
;     924 void bin2bcd_int(unsigned int in)
;     925 {
_bin2bcd_int:
;     926 char i;
;     927 for(i=3;i>0;i--)
	ST   -Y,R16
;	in -> Y+1
;	i -> R16
	LDI  R16,LOW(3)
_0xFA:
	LDI  R30,LOW(0)
	CP   R30,R16
	BRSH _0xFB
;     928 	{
;     929 	dig[i]=in%10;
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
;     930 	in/=10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
;     931 	}   
	SUBI R16,1
	RJMP _0xFA
_0xFB:
;     932 }
	LDD  R16,Y+0
	RJMP _0x16F
;     933 
;     934 //-----------------------------------------------
;     935 void bcd2ind(char s)
;     936 {
_bcd2ind:
;     937 char i;
;     938 bZ=1;
	ST   -Y,R16
;	s -> Y+1
;	i -> R16
	SET
	BLD  R2,3
;     939 for (i=0;i<5;i++)
	LDI  R16,LOW(0)
_0xFD:
	CPI  R16,5
	BRLO PC+3
	JMP _0xFE
;     940 	{
;     941 	if(bZ&&(!dig[i-1])&&(i<4))
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
;     942 		{
;     943 		if((4-i)>s)
	LDI  R30,LOW(4)
	SUB  R30,R16
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
	BRSH _0x102
;     944 			{
;     945 			ind_out[i-1]=DIGISYM[10];
	CALL SUBOPT_0xD
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	POP  R26
	POP  R27
	RJMP _0x171
;     946 			}
;     947 		else ind_out[i-1]=DIGISYM[0];	
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
_0x171:
	ST   X,R30
;     948 		}
;     949 	else
	RJMP _0x104
_0xFF:
;     950 		{
;     951 		ind_out[i-1]=DIGISYM[dig[i-1]];
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
;     952 		bZ=0;
	CLT
	BLD  R2,3
;     953 		}                   
_0x104:
;     954 
;     955 	if(s)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x105
;     956 		{
;     957 		ind_out[3-s]&=0b01111111;
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
;     958 		}	
;     959  
;     960 	}
_0x105:
	SUBI R16,-1
	RJMP _0xFD
_0xFE:
;     961 }            
	LDD  R16,Y+0
	ADIW R28,2
	RET
;     962 //-----------------------------------------------
;     963 void int2ind(unsigned int in,char s)
;     964 {
_int2ind:
;     965 bin2bcd_int(in);
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _bin2bcd_int
;     966 bcd2ind(s);
	LD   R30,Y
	ST   -Y,R30
	CALL _bcd2ind
;     967 
;     968 } 
_0x16F:
	ADIW R28,3
	RET
;     969 
;     970 //-----------------------------------------------
;     971 void ind_hndl(void)
;     972 {
_ind_hndl:
;     973 if(ind==iMn)
	TST  R14
	BRNE _0x106
;     974 	{
;     975 	if(ee_prog==EE_PROG_FULL)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	SBIW R30,0
	BREQ _0x108
;     976 		{
;     977 		}
;     978 	else if(ee_prog==EE_PROG_ONLY_ORIENT)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x109
;     979 		{
;     980 		int2ind(orient_step,0);
	LDS  R30,_orient_step
	CALL SUBOPT_0xE
;     981 		}
;     982 	else if(ee_prog==EE_PROG_ONLY_NAPOLN)
	RJMP _0x10A
_0x109:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x10B
;     983 		{
;     984 		int2ind(napoln_step,0);                              
	LDS  R30,_napoln_step
	CALL SUBOPT_0xE
;     985 		}			                
;     986 	else if(ee_prog==EE_PROG_ONLY_PAYKA)
	RJMP _0x10C
_0x10B:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x10D
;     987 		{
;     988 		int2ind(payka_step,0);
	LDS  R30,_payka_step
	CALL SUBOPT_0xE
;     989 		}
;     990 	else if(ee_prog==EE_PROG_ONLY_MAIN_LOOP)
	RJMP _0x10E
_0x10D:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x10F
;     991 		{
;     992 		int2ind(main_loop_step,0);
	LDS  R30,_main_loop_step
	CALL SUBOPT_0xE
;     993 		}			
;     994 	
;     995 	//int2ind(bDM,0);
;     996 	//int2ind(in_word,0);
;     997 	//int2ind(cnt_dm,0);
;     998 	
;     999 	//int2ind(bDM,0);
;    1000 	//int2ind(ee_delay[prog,sub_ind],1);  
;    1001 	//ind_out[0]=0xff;//DIGISYM[0];
;    1002 	//ind_out[1]=0xff;//DIGISYM[1];
;    1003 	//ind_out[2]=DIGISYM[2];//0xff;
;    1004 	//ind_out[0]=DIGISYM[7]; 
;    1005 
;    1006 	//ind_out[0]=DIGISYM[sub_ind+1];
;    1007 	}
_0x10F:
_0x10E:
_0x10C:
_0x10A:
_0x108:
;    1008 else if(ind==iSet)
	RJMP _0x110
_0x106:
	LDI  R30,LOW(2)
	CP   R30,R14
	BRNE _0x111
;    1009 	{
;    1010      if(sub_ind==0)int2ind(ee_prog,0);
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
;    1011 	else if(sub_ind==1)int2ind(ee_temp1,1);
	RJMP _0x113
_0x112:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x1)
	BRNE _0x114
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	CALL SUBOPT_0xF
;    1012 	else if(sub_ind==2)int2ind(ee_temp2,1);
	RJMP _0x115
_0x114:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x2)
	BRNE _0x116
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	CALL SUBOPT_0xF
;    1013 		
;    1014 	if(bFL5)ind_out[0]=DIGISYM[sub_ind+1];
_0x116:
_0x115:
_0x113:
	SBRS R3,0
	RJMP _0x117
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
	RJMP _0x172
;    1015 	else    ind_out[0]=DIGISYM[10];
_0x117:
	__POINTW1FN _DIGISYM,10
_0x172:
	LPM  R30,Z
	STS  _ind_out,R30
;    1016 	}
;    1017 }
_0x111:
_0x110:
	RET
;    1018 
;    1019 //-----------------------------------------------
;    1020 void led_hndl(void)
;    1021 {
_led_hndl:
;    1022 ind_out[4]=DIGISYM[10]; 
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	__PUTB1MN _ind_out,4
;    1023 
;    1024 ind_out[4]&=~(1<<LED_POW_ON); 
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xDF
	POP  R26
	POP  R27
	ST   X,R30
;    1025 
;    1026 if(step!=sOFF)
	TST  R13
	BREQ _0x119
;    1027 	{
;    1028 	ind_out[4]&=~(1<<LED_WRK);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xBF
	POP  R26
	POP  R27
	RJMP _0x173
;    1029 	}
;    1030 else ind_out[4]|=(1<<LED_WRK);
_0x119:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x40
	POP  R26
	POP  R27
_0x173:
	ST   X,R30
;    1031 
;    1032 
;    1033 if(step==sOFF)
	TST  R13
	BRNE _0x11B
;    1034 	{
;    1035  	if(bERR)
	SBRS R3,1
	RJMP _0x11C
;    1036 		{
;    1037 		ind_out[4]&=~(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFE
	POP  R26
	POP  R27
	RJMP _0x174
;    1038 		}
;    1039 	else
_0x11C:
;    1040 		{
;    1041 		ind_out[4]|=(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
_0x174:
	ST   X,R30
;    1042 		}
;    1043      }
;    1044 else ind_out[4]|=(1<<LED_ERROR);
	RJMP _0x11E
_0x11B:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
	ST   X,R30
_0x11E:
;    1045 
;    1046 /* 	if(bMD1)
;    1047 		{
;    1048 		ind_out[4]&=~(1<<LED_ERROR);
;    1049 		}
;    1050 	else
;    1051 		{
;    1052 		ind_out[4]|=(1<<LED_ERROR);
;    1053 		} */
;    1054 
;    1055 //if(bERR)ind_out[4]&=~(1<<LED_ERROR);
;    1056 if(ee_loop_mode==elmAUTO)ind_out[4]&=~(1<<LED_LOOP_AUTO);
	LDI  R26,LOW(_ee_loop_mode)
	LDI  R27,HIGH(_ee_loop_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0x11F
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0x7F
	POP  R26
	POP  R27
	RJMP _0x175
;    1057 else ind_out[4]|=(1<<LED_LOOP_AUTO);
_0x11F:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x80
	POP  R26
	POP  R27
_0x175:
	ST   X,R30
;    1058 
;    1059 /*if(prog==p1) ind_out[4]&=~(1<<LED_PROG1);
;    1060 else if(prog==p2) ind_out[4]&=~(1<<LED_PROG2);
;    1061 else if(prog==p3) ind_out[4]&=~(1<<LED_PROG3);
;    1062 else if(prog==p4) ind_out[4]&=~(1<<LED_PROG4); */
;    1063 
;    1064 /*if(ind==iPr_sel)
;    1065 	{
;    1066 	if(bFL5)ind_out[4]|=(1<<LED_PROG1)|(1<<LED_PROG2)|(1<<LED_PROG3)|(1<<LED_PROG4);
;    1067 	}*/ 
;    1068 	 
;    1069 /*if(ind==iVr)
;    1070 	{
;    1071 	if(bFL5)ind_out[4]|=(1<<LED_POW_ON);
;    1072 	} */
;    1073 if(orient_step!=sOFF)ind_out[4]&=~(1<<LED_ORIENT);
	LDS  R30,_orient_step
	CPI  R30,0
	BREQ _0x121
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xEF
	POP  R26
	POP  R27
	ST   X,R30
;    1074 if(napoln_step!=sOFF)ind_out[4]&=~(1<<LED_NAPOLN);
_0x121:
	LDS  R30,_napoln_step
	CPI  R30,0
	BREQ _0x122
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFB
	POP  R26
	POP  R27
	ST   X,R30
;    1075 if(payka_step!=sOFF)ind_out[4]&=~(1<<LED_PAYKA);
_0x122:
	LDS  R30,_payka_step
	CPI  R30,0
	BREQ _0x123
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0XF7
	POP  R26
	POP  R27
	ST   X,R30
;    1076 if(main_loop_step!=sOFF)ind_out[4]&=~(1<<LED_MAIN_LOOP);	
_0x123:
	LDS  R30,_main_loop_step
	CPI  R30,0
	BREQ _0x124
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFD
	POP  R26
	POP  R27
	ST   X,R30
;    1077 }
_0x124:
	RET
;    1078 
;    1079 //-----------------------------------------------
;    1080 // Подпрограмма драйва до 7 кнопок одного порта, 
;    1081 // различает короткое и длинное нажатие,
;    1082 // срабатывает на отпускание кнопки, возможность
;    1083 // ускорения перебора при длинном нажатии...
;    1084 #define but_port PORTC
;    1085 #define but_dir  DDRC
;    1086 #define but_pin  PINC
;    1087 #define but_mask 0b01101010
;    1088 #define no_but   0b11111111
;    1089 #define but_on   5
;    1090 #define but_onL  20
;    1091 
;    1092 
;    1093 
;    1094 
;    1095 void but_drv(void)
;    1096 { 
_but_drv:
;    1097 DDRD&=0b00000111;
	IN   R30,0x11
	ANDI R30,LOW(0x7)
	CALL SUBOPT_0x10
;    1098 PORTD|=0b11111000;
;    1099 
;    1100 but_port|=(but_mask^0xff);
	CALL SUBOPT_0x11
;    1101 but_dir&=but_mask;
;    1102 #asm
;    1103 nop
nop
;    1104 nop
nop
;    1105 nop
nop
;    1106 nop
nop
;    1107 #endasm

;    1108 
;    1109 but_n=but_pin|but_mask; 
	IN   R30,0x13
	ORI  R30,LOW(0x6A)
	STS  _but_n_G1,R30
;    1110 
;    1111 if((but_n==no_but)||(but_n!=but_s))
	LDS  R26,_but_n_G1
	CPI  R26,LOW(0xFF)
	BREQ _0x126
	RCALL SUBOPT_0x12
	BREQ _0x125
_0x126:
;    1112  	{
;    1113  	speed=0;
	CLT
	BLD  R2,6
;    1114    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRSH _0x129
	LDS  R26,_but1_cnt_G1
	CPI  R26,LOW(0x0)
	BREQ _0x12B
_0x129:
	SBRS R2,4
	RJMP _0x12C
_0x12B:
	RJMP _0x128
_0x12C:
;    1115   		{
;    1116    	     n_but=1;
	SET
	BLD  R2,5
;    1117           but=but_s;
	LDS  R11,_but_s_G1
;    1118           }
;    1119    	if (but1_cnt>=but_onL_temp)
_0x128:
	RCALL SUBOPT_0x13
	BRLO _0x12D
;    1120   		{
;    1121    	     n_but=1;
	SET
	BLD  R2,5
;    1122           but=but_s&0b11111101;
	RCALL SUBOPT_0x14
;    1123           }
;    1124     	l_but=0;
_0x12D:
	CLT
	BLD  R2,4
;    1125    	but_onL_temp=but_onL;
	LDI  R30,LOW(20)
	STS  _but_onL_temp_G1,R30
;    1126     	but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    1127   	but1_cnt=0;          
	STS  _but1_cnt_G1,R30
;    1128      goto but_drv_out;
	RJMP _0x12E
;    1129   	}  
;    1130   	
;    1131 if(but_n==but_s)
_0x125:
	RCALL SUBOPT_0x12
	BRNE _0x12F
;    1132  	{
;    1133   	but0_cnt++;
	LDS  R30,_but0_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but0_cnt_G1,R30
;    1134   	if(but0_cnt>=but_on)
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRLO _0x130
;    1135   		{
;    1136    		but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    1137    		but1_cnt++;
	LDS  R30,_but1_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but1_cnt_G1,R30
;    1138    		if(but1_cnt>=but_onL_temp)
	RCALL SUBOPT_0x13
	BRLO _0x131
;    1139    			{              
;    1140     			but=but_s&0b11111101;
	RCALL SUBOPT_0x14
;    1141     			but1_cnt=0;
	LDI  R30,LOW(0)
	STS  _but1_cnt_G1,R30
;    1142     			n_but=1;
	SET
	BLD  R2,5
;    1143     			l_but=1;
	SET
	BLD  R2,4
;    1144 			if(speed)
	SBRS R2,6
	RJMP _0x132
;    1145 				{
;    1146     				but_onL_temp=but_onL_temp>>1;
	LDS  R30,_but_onL_temp_G1
	LSR  R30
	STS  _but_onL_temp_G1,R30
;    1147         			if(but_onL_temp<=2) but_onL_temp=2;
	LDS  R26,_but_onL_temp_G1
	LDI  R30,LOW(2)
	CP   R30,R26
	BRLO _0x133
	STS  _but_onL_temp_G1,R30
;    1148 				}    
_0x133:
;    1149    			}
_0x132:
;    1150   		} 
_0x131:
;    1151  	}
_0x130:
;    1152 but_drv_out:
_0x12F:
_0x12E:
;    1153 but_s=but_n;
	LDS  R30,_but_n_G1
	STS  _but_s_G1,R30
;    1154 but_port|=(but_mask^0xff);
	RCALL SUBOPT_0x11
;    1155 but_dir&=but_mask;
;    1156 }    
	RET
;    1157 
;    1158 #define butV	239
;    1159 #define butV_	237
;    1160 #define butP	251
;    1161 #define butP_	249
;    1162 #define butR	127
;    1163 #define butR_	125
;    1164 #define butL	254
;    1165 #define butL_	252
;    1166 #define butLR	126
;    1167 #define butLR_	124 
;    1168 #define butVP_ 233
;    1169 //-----------------------------------------------
;    1170 void but_an(void)
;    1171 {
_but_an:
;    1172 
;    1173 if(bSTART)
	SBRS R3,7
	RJMP _0x134
;    1174 	{   
;    1175 /*	if(ee_prog==EE_PROG_FULL)
;    1176 		{
;    1177 		}
;    1178 	else if(ee_prog==EE_PROG_ONLY_ORIENT)
;    1179 		{
;    1180 		orient_cmd=cmdSTART;
;    1181 		}
;    1182 	else if(ee_prog==EE_PROG_ONLY_NAPOLN)
;    1183 		{
;    1184 		napoln_cmd=cmdSTART;                              
;    1185 		}			                
;    1186 	else if(ee_prog==EE_PROG_ONLY_PAYKA)
;    1187 		{
;    1188 		payka_cmd=cmdSTART;
;    1189 		}
;    1190 	else if(ee_prog==EE_PROG_ONLY_MAIN_LOOP)
;    1191 		{
;    1192 		main_loop_cmd=cmdSTART;
;    1193 		//main_loop_del_cnt=20;
;    1194 		}  */
;    1195 		
;    1196 		
;    1197 		main_loop_cmd=cmdSTART;
	LDI  R30,LOW(1)
	STS  _main_loop_cmd,R30
;    1198 		
;    1199 						
;    1200 	}
;    1201 	
;    1202 bSTART=0;	
_0x134:
	CLT
	BLD  R3,7
;    1203 
;    1204 if(bSTOP)
	SBRS R4,0
	RJMP _0x135
;    1205 	{   
;    1206 	orient_cmd=cmdSTOP;
	LDI  R30,LOW(2)
	STS  _orient_cmd,R30
;    1207 	napoln_cmd=cmdSTOP;
	STS  _napoln_cmd,R30
;    1208 	payka_cmd=cmdSTOP;
	STS  _payka_cmd,R30
;    1209 	main_loop_cmd=cmdSTOP;
	STS  _main_loop_cmd,R30
;    1210 		
;    1211 	}
;    1212 	
;    1213 bSTOP=0;	
_0x135:
	CLT
	BLD  R4,0
;    1214 
;    1215 
;    1216 /*
;    1217 if(!(in_word&0x01))
;    1218 	{
;    1219 	#ifdef TVIST_SKO
;    1220 	if((step==sOFF)&&(!bERR))
;    1221 		{
;    1222 		step=s1;
;    1223 		if(prog==p2) cnt_del=70;
;    1224 		else if(prog==p3) cnt_del=100;
;    1225 		}
;    1226 	#endif
;    1227 	#ifdef DV3KL2MD
;    1228 	if((step==sOFF)&&(!bERR))
;    1229 		{
;    1230 		step=s1;
;    1231 		cnt_del=70;
;    1232 		}
;    1233 	#endif	
;    1234 	#ifndef TVIST_SKO
;    1235 	if((step==sOFF)&&(!bERR))
;    1236 		{
;    1237 		step=s1;
;    1238 		if(prog==p1) cnt_del=50;
;    1239 		else if(prog==p2) cnt_del=50;
;    1240 		else if(prog==p3) cnt_del=50;
;    1241           #ifdef P380_MINI
;    1242   		cnt_del=100;
;    1243   		#endif
;    1244 		}
;    1245 	#endif
;    1246 	}
;    1247 if(!(in_word&0x02))
;    1248 	{
;    1249 	step=sOFF;
;    1250 
;    1251 	} */
;    1252 
;    1253 if (!n_but) goto but_an_end;
	SBRS R2,5
	RJMP _0x137
;    1254 
;    1255 if(but==butV_)
	LDI  R30,LOW(237)
	CP   R30,R11
	BRNE _0x138
;    1256 	{
;    1257 	if(ee_loop_mode!=elmAUTO)ee_loop_mode=elmAUTO;
	LDI  R26,LOW(_ee_loop_mode)
	LDI  R27,HIGH(_ee_loop_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BREQ _0x139
	LDI  R30,LOW(85)
	RJMP _0x176
;    1258 	else ee_loop_mode=elmMNL;
_0x139:
	LDI  R30,LOW(170)
_0x176:
	LDI  R26,LOW(_ee_loop_mode)
	LDI  R27,HIGH(_ee_loop_mode)
	CALL __EEPROMWRB
;    1259 	}
;    1260 
;    1261 
;    1262 if(ind==iMn)
_0x138:
	TST  R14
	BRNE _0x13B
;    1263 	{
;    1264 	if(but==butP_)
	LDI  R30,LOW(249)
	CP   R30,R11
	BRNE _0x13C
;    1265 		{
;    1266 		ind=iSet;
	LDI  R30,LOW(2)
	MOV  R14,R30
;    1267 		sub_ind=0;
	LDI  R30,LOW(0)
	STS  _sub_ind,R30
;    1268 		}
;    1269 	}
_0x13C:
;    1270 
;    1271 else if(ind==iSet)
	RJMP _0x13D
_0x13B:
	LDI  R30,LOW(2)
	CP   R30,R14
	BREQ PC+3
	JMP _0x13E
;    1272 	{
;    1273 	if(but==butP_)
	LDI  R30,LOW(249)
	CP   R30,R11
	BRNE _0x13F
;    1274 		{
;    1275 		ind=iMn;
	CLR  R14
;    1276 		sub_ind=0;
	LDI  R30,LOW(0)
	STS  _sub_ind,R30
;    1277 		}      
;    1278 	else if(but==butP)
	RJMP _0x140
_0x13F:
	LDI  R30,LOW(251)
	CP   R30,R11
	BRNE _0x141
;    1279 		{
;    1280 		sub_ind++;
	LDS  R30,_sub_ind
	SUBI R30,-LOW(1)
	STS  _sub_ind,R30
;    1281 		if(sub_ind==5)sub_ind=0;
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x5)
	BRNE _0x142
	LDI  R30,LOW(0)
	STS  _sub_ind,R30
;    1282 		}
_0x142:
;    1283 	else if (sub_ind==0)
	RJMP _0x143
_0x141:
	LDS  R30,_sub_ind
	CPI  R30,0
	BRNE _0x144
;    1284 		{
;    1285 		if(but==butR)ee_prog++;
	LDI  R30,LOW(127)
	CP   R30,R11
	BRNE _0x145
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    1286 		else if(but==butL)ee_prog--;
	RJMP _0x146
_0x145:
	LDI  R30,LOW(254)
	CP   R30,R11
	BRNE _0x147
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    1287 		if(ee_prog>5)ee_prog=0;
_0x147:
_0x146:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	MOVW R26,R30
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x148
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMWRW
;    1288 		if(ee_prog<0)ee_prog=5;
_0x148:
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMRDW
	MOVW R26,R30
	SBIW R26,0
	BRGE _0x149
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	LDI  R26,LOW(_ee_prog)
	LDI  R27,HIGH(_ee_prog)
	CALL __EEPROMWRW
;    1289 		}
_0x149:
;    1290 	else if (sub_ind==1)
	RJMP _0x14A
_0x144:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x1)
	BRNE _0x14B
;    1291 		{             
;    1292 		if((but==butR)||(but==butR_))	
	LDI  R30,LOW(127)
	CP   R30,R11
	BREQ _0x14D
	LDI  R30,LOW(125)
	CP   R30,R11
	BRNE _0x14C
_0x14D:
;    1293 			{  
;    1294 			speed=1;
	SET
	BLD  R2,6
;    1295 			ee_temp1++;
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    1296 			if(ee_temp1>900)ee_temp1=900;
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	RCALL SUBOPT_0x15
	BRGE _0x14F
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMWRW
;    1297 			}   
_0x14F:
;    1298 	
;    1299     		else if((but==butL)||(but==butL_))	
	RJMP _0x150
_0x14C:
	LDI  R30,LOW(254)
	CP   R30,R11
	BREQ _0x152
	LDI  R30,LOW(252)
	CP   R30,R11
	BRNE _0x151
_0x152:
;    1300 			{  
;    1301     	    		speed=1;
	SET
	BLD  R2,6
;    1302     			ee_temp1--;
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    1303     			if(ee_temp1<0)ee_temp1=0;
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMRDW
	MOVW R26,R30
	SBIW R26,0
	BRGE _0x154
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMWRW
;    1304     			}				
_0x154:
;    1305 		}   
_0x151:
_0x150:
;    1306 	else if (sub_ind==2)
	RJMP _0x155
_0x14B:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x2)
	BRNE _0x156
;    1307 		{             
;    1308 		if((but==butR)||(but==butR_))	
	LDI  R30,LOW(127)
	CP   R30,R11
	BREQ _0x158
	LDI  R30,LOW(125)
	CP   R30,R11
	BRNE _0x157
_0x158:
;    1309 			{  
;    1310 			speed=1;
	SET
	BLD  R2,6
;    1311 			ee_temp2++;
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    1312 			if(ee_temp2>900)ee_temp2=900;
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	RCALL SUBOPT_0x15
	BRGE _0x15A
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMWRW
;    1313 			}   
_0x15A:
;    1314 	
;    1315     		else if((but==butL)||(but==butL_))	
	RJMP _0x15B
_0x157:
	LDI  R30,LOW(254)
	CP   R30,R11
	BREQ _0x15D
	LDI  R30,LOW(252)
	CP   R30,R11
	BRNE _0x15C
_0x15D:
;    1316 			{  
;    1317     	    		speed=1;
	SET
	BLD  R2,6
;    1318     			ee_temp2--;
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    1319     			if(ee_temp2<0)ee_temp1=0;
	LDI  R26,LOW(_ee_temp2)
	LDI  R27,HIGH(_ee_temp2)
	CALL __EEPROMRDW
	MOVW R26,R30
	SBIW R26,0
	BRGE _0x15F
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	LDI  R26,LOW(_ee_temp1)
	LDI  R27,HIGH(_ee_temp1)
	CALL __EEPROMWRW
;    1320     			}				
_0x15F:
;    1321 		}							
_0x15C:
_0x15B:
;    1322 	}
_0x156:
_0x155:
_0x14A:
_0x143:
_0x140:
;    1323 
;    1324 
;    1325 
;    1326 
;    1327 if(but==butVP_)
_0x13E:
_0x13D:
	LDI  R30,LOW(233)
	CP   R30,R11
	BRNE _0x160
;    1328 	{
;    1329 	//if(ind!=iVr)ind=iVr;
;    1330 	//else ind=iMn;
;    1331 	}
;    1332 
;    1333 /*	
;    1334 if(ind==iMn)
;    1335 	{
;    1336 	if(but==butP_)ind=iPr_sel;
;    1337 	if(but==butLR)	
;    1338 		{
;    1339 		if((prog==p3)||(prog==p4))
;    1340 			{ 
;    1341 			if(sub_ind==0)sub_ind=1;
;    1342 			else sub_ind=0;
;    1343 			}
;    1344     		else sub_ind=0;
;    1345 		}	 
;    1346 	if((but==butR)||(but==butR_))	
;    1347 		{  
;    1348 		speed=1;
;    1349 		//ee_delay[prog,sub_ind]++;
;    1350 		}   
;    1351 	
;    1352 	else if((but==butL)||(but==butL_))	
;    1353 		{  
;    1354     		speed=1;
;    1355     		//ee_delay[prog,sub_ind]--;
;    1356     		}		
;    1357 	} 
;    1358 	
;    1359 else if(ind==iPr_sel)
;    1360 	{
;    1361 	if(but==butP_)ind=iMn;
;    1362 	if(but==butP)
;    1363 		{
;    1364 		prog++;
;    1365 ////		if(prog>MAXPROG)prog=MINPROG;
;    1366 		//ee_program[0]=prog;
;    1367 		//ee_program[1]=prog;
;    1368 		//ee_program[2]=prog;
;    1369 		}
;    1370 	
;    1371 	if(but==butR)
;    1372 		{
;    1373 		prog++;
;    1374 ////		if(prog>MAXPROG)prog=MINPROG;
;    1375 		//ee_program[0]=prog;
;    1376 		//ee_program[1]=prog;
;    1377 		//ee_program[2]=prog;
;    1378 		}
;    1379 
;    1380 	if(but==butL)
;    1381 		{
;    1382 		prog--;
;    1383 ////		if(prog>MAXPROG)prog=MINPROG;
;    1384 		//ee_program[0]=prog;
;    1385 		//ee_program[1]=prog;
;    1386 		//ee_program[2]=prog;
;    1387 		}	
;    1388 	} 
;    1389 
;    1390 /*else if(ind==iVr)
;    1391 	{
;    1392 	if(but==butP_)
;    1393 		{
;    1394 	    ///	if(ee_vr_log)ee_vr_log=0;
;    1395 	    ///	else ee_vr_log=1;
;    1396 		}	
;    1397 	}*/ 	
;    1398 
;    1399 but_an_end:
_0x160:
_0x137:
;    1400 n_but=0;
	CLT
	BLD  R2,5
;    1401 }
	RET
;    1402 
;    1403 //-----------------------------------------------
;    1404 void ind_drv(void)
;    1405 {
_ind_drv:
;    1406 if(++ind_cnt>=6)ind_cnt=0;
	INC  R10
	LDI  R30,LOW(6)
	CP   R10,R30
	BRLO _0x161
	CLR  R10
;    1407 
;    1408 if(ind_cnt<5)
_0x161:
	LDI  R30,LOW(5)
	CP   R10,R30
	BRSH _0x162
;    1409 	{
;    1410 	DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
;    1411 	PORTC=0xFF;
	OUT  0x15,R30
;    1412 	DDRD|=0b11111000;
	IN   R30,0x11
	ORI  R30,LOW(0xF8)
	RCALL SUBOPT_0x10
;    1413 	PORTD|=0b11111000;
;    1414 	PORTD&=IND_STROB[ind_cnt];
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
;    1415 	PORTC=ind_out[ind_cnt];
	MOV  R30,R10
	LDI  R31,0
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	LD   R30,Z
	OUT  0x15,R30
;    1416 	}
;    1417 else but_drv();
	RJMP _0x163
_0x162:
	CALL _but_drv
_0x163:
;    1418 }
	RET
;    1419 
;    1420 //***********************************************
;    1421 //***********************************************
;    1422 //***********************************************
;    1423 //***********************************************
;    1424 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;    1425 {
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
;    1426 TCCR0=0x02;
	RCALL SUBOPT_0x16
;    1427 TCNT0=-208;
;    1428 OCR0=0x00; 
;    1429 
;    1430 
;    1431 b600Hz=1;
	SET
	BLD  R2,0
;    1432 ind_drv();
	RCALL _ind_drv
;    1433 if(++t0_cnt0>=6)
	INC  R6
	LDI  R30,LOW(6)
	CP   R6,R30
	BRLO _0x164
;    1434 	{
;    1435 	t0_cnt0=0;
	CLR  R6
;    1436 	b100Hz=1;
	SET
	BLD  R2,1
;    1437 	}
;    1438 
;    1439 if(++t0_cnt1>=60)
_0x164:
	INC  R7
	LDI  R30,LOW(60)
	CP   R7,R30
	BRLO _0x165
;    1440 	{
;    1441 	t0_cnt1=0;
	CLR  R7
;    1442 	b10Hz=1;
	SET
	BLD  R2,2
;    1443 	
;    1444 	if(++t0_cnt2>=2)
	INC  R8
	LDI  R30,LOW(2)
	CP   R8,R30
	BRLO _0x166
;    1445 		{
;    1446 		t0_cnt2=0;
	CLR  R8
;    1447 		bFL5=!bFL5;
	LDI  R30,LOW(1)
	EOR  R3,R30
;    1448 		}
;    1449 		
;    1450 	if(++t0_cnt3>=5)
_0x166:
	INC  R9
	LDI  R30,LOW(5)
	CP   R9,R30
	BRLO _0x167
;    1451 		{
;    1452 		t0_cnt3=0;
	CLR  R9
;    1453 		bFL2=!bFL2;
	LDI  R30,LOW(128)
	EOR  R2,R30
;    1454 		}		
;    1455 	}
_0x167:
;    1456 }
_0x165:
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
;    1457 
;    1458 //===============================================
;    1459 //===============================================
;    1460 //===============================================
;    1461 //===============================================
;    1462 
;    1463 void main(void)
;    1464 {
_main:
;    1465 
;    1466 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
;    1467 DDRA=0x00;
	RCALL SUBOPT_0x0
;    1468 
;    1469 PORTB=0xff;
	RCALL SUBOPT_0x17
;    1470 DDRB=0xFF;
;    1471 
;    1472 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;    1473 DDRC=0x00;
	OUT  0x14,R30
;    1474 
;    1475 
;    1476 PORTD=0x00;
	OUT  0x12,R30
;    1477 DDRD=0x00;
	OUT  0x11,R30
;    1478 
;    1479 
;    1480 TCCR0=0x02;
	RCALL SUBOPT_0x16
;    1481 TCNT0=-208;
;    1482 OCR0=0x00;
;    1483 
;    1484 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;    1485 TCCR1B=0x00;
	OUT  0x2E,R30
;    1486 TCNT1H=0x00;
	OUT  0x2D,R30
;    1487 TCNT1L=0x00;
	OUT  0x2C,R30
;    1488 ICR1H=0x00;
	OUT  0x27,R30
;    1489 ICR1L=0x00;
	OUT  0x26,R30
;    1490 OCR1AH=0x00;
	OUT  0x2B,R30
;    1491 OCR1AL=0x00;
	OUT  0x2A,R30
;    1492 OCR1BH=0x00;
	OUT  0x29,R30
;    1493 OCR1BL=0x00;
	OUT  0x28,R30
;    1494 
;    1495 
;    1496 ASSR=0x00;
	OUT  0x22,R30
;    1497 TCCR2=0x00;
	OUT  0x25,R30
;    1498 TCNT2=0x00;
	OUT  0x24,R30
;    1499 OCR2=0x00;
	OUT  0x23,R30
;    1500 
;    1501 MCUCR=0x00;
	OUT  0x35,R30
;    1502 MCUCSR=0x00;
	OUT  0x34,R30
;    1503 
;    1504 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;    1505 
;    1506 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;    1507 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;    1508 
;    1509 #asm("sei") 
	sei
;    1510 PORTB=0xFF;
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x17
;    1511 DDRB=0xFF;
;    1512 ind=iMn;
	CLR  R14
;    1513 prog_drv();
	CALL _prog_drv
;    1514 ind_hndl();
	CALL _ind_hndl
;    1515 led_hndl();
	CALL _led_hndl
;    1516 
;    1517 
;    1518 while (1)
_0x168:
;    1519       {
;    1520       if(b600Hz)
	SBRS R2,0
	RJMP _0x16B
;    1521 		{
;    1522 		b600Hz=0; 
	CLT
	BLD  R2,0
;    1523           in_an();
	CALL _in_an
;    1524           
;    1525 		}         
;    1526       if(b100Hz)
_0x16B:
	SBRS R2,1
	RJMP _0x16C
;    1527 		{        
;    1528 		b100Hz=0; 
	CLT
	BLD  R2,1
;    1529 		but_an();
	RCALL _but_an
;    1530 	    	//in_drv();
;    1531           ind_hndl();
	CALL _ind_hndl
;    1532           step_contr();
	CALL _step_contr
;    1533           
;    1534           main_loop_hndl();
	CALL _main_loop_hndl
;    1535           payka_hndl();
	CALL _payka_hndl
;    1536           napoln_hndl();
	CALL _napoln_hndl
;    1537           orient_hndl();
	CALL _orient_hndl
;    1538           out_drv();
	CALL _out_drv
;    1539 		}   
;    1540 	if(b10Hz)
_0x16C:
	SBRS R2,2
	RJMP _0x16D
;    1541 		{
;    1542 		b10Hz=0;
	CLT
	BLD  R2,2
;    1543 		prog_drv();
	CALL _prog_drv
;    1544 		err_drv();
	CALL _err_drv
;    1545 		
;    1546     	     
;    1547           led_hndl();
	CALL _led_hndl
;    1548           
;    1549           }
;    1550 
;    1551       };
_0x16D:
	RJMP _0x168
;    1552 }
_0x16E:
	RJMP _0x16E

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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
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

