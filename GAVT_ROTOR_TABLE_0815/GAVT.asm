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
;     124 eeprom enum{evmON=0x55,evmOFF=0xaa}ee_vacuum_mode;

	.ESEG
_ee_vacuum_mode:
	.DB  0x0
;     125 eeprom char ee_program[2];
_ee_program:
	.DB  0x0
	.DB  0x0
;     126 enum {p1=1,p2=2,p3=3,p4=4}prog;
;     127 enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}step=sOFF;
;     128 enum {iMn,iPr_sel,iVr} ind;
;     129 char sub_ind;
;     130 char in_word,in_word_old,in_word_new,in_word_cnt;

	.DSEG
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
;     134 char bVR;
_bVR:
	.BYTE 0x1
;     135 char bMD1;
_bMD1:
	.BYTE 0x1
;     136 bit bMD2;
;     137 bit bMD3;
;     138 char cnt_md1,cnt_md2,cnt_vr,cnt_md3;
_cnt_md1:
	.BYTE 0x1
_cnt_md2:
	.BYTE 0x1
_cnt_vr:
	.BYTE 0x1
_cnt_md3:
	.BYTE 0x1
;     139 
;     140 eeprom unsigned ee_delay[4,2];

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
;     141 eeprom char ee_vr_log;
_ee_vr_log:
	.DB  0x0
;     142 #include <mega16.h>
;     143 //#include <mega8535.h>
;     144 //-----------------------------------------------
;     145 void prog_drv(void)
;     146 {

	.CSEG
_prog_drv:
;     147 char temp,temp1,temp2;
;     148 
;     149 temp=ee_program[0];
	CALL __SAVELOCR3
;	temp -> R16
;	temp1 -> R17
;	temp2 -> R18
	LDI  R26,LOW(_ee_program)
	LDI  R27,HIGH(_ee_program)
	CALL __EEPROMRDB
	MOV  R16,R30
;     150 temp1=ee_program[1];
	__POINTW2MN _ee_program,1
	CALL __EEPROMRDB
	MOV  R17,R30
;     151 temp2=ee_program[2];
	__POINTW2MN _ee_program,2
	CALL __EEPROMRDB
	MOV  R18,R30
;     152 
;     153 if((temp==temp1)&&(temp==temp2))
	CP   R17,R16
	BRNE _0x5
	CP   R18,R16
	BREQ _0x6
_0x5:
	RJMP _0x4
_0x6:
;     154 	{
;     155 	}
;     156 else if((temp==temp1)&&(temp!=temp2))
	RJMP _0x7
_0x4:
	CP   R17,R16
	BRNE _0x9
	CP   R18,R16
	BRNE _0xA
_0x9:
	RJMP _0x8
_0xA:
;     157 	{
;     158 	temp2=temp;
	MOV  R18,R16
;     159 	}
;     160 else if((temp!=temp1)&&(temp==temp2))
	RJMP _0xB
_0x8:
	CP   R17,R16
	BREQ _0xD
	CP   R18,R16
	BREQ _0xE
_0xD:
	RJMP _0xC
_0xE:
;     161 	{
;     162 	temp1=temp;
	MOV  R17,R16
;     163 	}
;     164 else if((temp!=temp1)&&(temp1==temp2))
	RJMP _0xF
_0xC:
	CP   R17,R16
	BREQ _0x11
	CP   R18,R17
	BREQ _0x12
_0x11:
	RJMP _0x10
_0x12:
;     165 	{
;     166 	temp=temp1;
	MOV  R16,R17
;     167 	}
;     168 else if((temp!=temp1)&&(temp!=temp2))
	RJMP _0x13
_0x10:
	CP   R17,R16
	BREQ _0x15
	CP   R18,R16
	BRNE _0x16
_0x15:
	RJMP _0x14
_0x16:
;     169 	{
;     170 	temp=MINPROG;
	LDI  R16,LOW(2)
;     171 	temp1=MINPROG;
	LDI  R17,LOW(2)
;     172 	temp2=MINPROG;
	LDI  R18,LOW(2)
;     173 	}
;     174 
;     175 if(!((temp<=MAXPROG)&&(temp>=MINPROG)))
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
;     176 	{
;     177 	temp=MINPROG;
	LDI  R16,LOW(2)
;     178 	}
;     179 
;     180 if(temp!=ee_program[0])ee_program[0]=temp;
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
;     181 if(temp!=ee_program[1])ee_program[1]=temp;
_0x1A:
	__POINTW2MN _ee_program,1
	CALL __EEPROMRDB
	CP   R30,R16
	BREQ _0x1B
	__POINTW2MN _ee_program,1
	MOV  R30,R16
	CALL __EEPROMWRB
;     182 if(temp!=ee_program[2])ee_program[2]=temp;
_0x1B:
	__POINTW2MN _ee_program,2
	CALL __EEPROMRDB
	CP   R30,R16
	BREQ _0x1C
	__POINTW2MN _ee_program,2
	MOV  R30,R16
	CALL __EEPROMWRB
;     183 
;     184 prog=temp;
_0x1C:
	MOV  R10,R16
;     185 }
	CALL __LOADLOCR3
	RJMP _0xC9
;     186 
;     187 //-----------------------------------------------
;     188 void in_drv(void)
;     189 {
_in_drv:
;     190 char i,temp;
;     191 unsigned int tempUI;
;     192 DDRA=0x00;
	CALL __SAVELOCR4
;	i -> R16
;	temp -> R17
;	tempUI -> R18,R19
	CALL SUBOPT_0x0
;     193 PORTA=0xff;
	OUT  0x1B,R30
;     194 in_word_new=PINA;
	IN   R30,0x19
	STS  _in_word_new,R30
;     195 if(in_word_old==in_word_new)
	LDS  R26,_in_word_old
	CP   R30,R26
	BRNE _0x1D
;     196 	{
;     197 	if(in_word_cnt<10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRSH _0x1E
;     198 		{
;     199 		in_word_cnt++;
	LDS  R30,_in_word_cnt
	SUBI R30,-LOW(1)
	STS  _in_word_cnt,R30
;     200 		if(in_word_cnt>=10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRLO _0x1F
;     201 			{
;     202 			in_word=in_word_old;
	LDS  R14,_in_word_old
;     203 			}
;     204 		}
_0x1F:
;     205 	}
_0x1E:
;     206 else in_word_cnt=0;
	RJMP _0x20
_0x1D:
	LDI  R30,LOW(0)
	STS  _in_word_cnt,R30
_0x20:
;     207 
;     208 
;     209 in_word_old=in_word_new;
	LDS  R30,_in_word_new
	STS  _in_word_old,R30
;     210 }   
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;     211 
;     212 #ifdef TVIST_SKO
;     213 //-----------------------------------------------
;     214 void err_drv(void)
;     215 {
;     216 if(step==sOFF)
;     217 	{
;     218     	if(prog==p2)	
;     219     		{
;     220        		if(bMD1) bERR=1;
;     221        		else bERR=0;
;     222 		}
;     223 	}
;     224 else bERR=0;
;     225 }
;     226 #endif  
;     227 
;     228 #ifndef TVIST_SKO
;     229 //-----------------------------------------------
;     230 void err_drv(void)
;     231 {
_err_drv:
;     232 if(step==sOFF)
	TST  R11
	BRNE _0x21
;     233 	{
;     234 	if((bMD1)||(bMD2)||(bVR)||(bMD3)) bERR=1;
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
;     235 	else bERR=0;
	RJMP _0x25
_0x22:
	CLT
	BLD  R3,1
_0x25:
;     236 	}
;     237 else bERR=0;
	RJMP _0x26
_0x21:
	CLT
	BLD  R3,1
_0x26:
;     238 }
	RET
;     239 #endif
;     240 //-----------------------------------------------
;     241 void mdvr_drv(void)
;     242 {
_mdvr_drv:
;     243 if(!(in_word&(1<<MD1)))
	SBRC R14,2
	RJMP _0x27
;     244 	{
;     245 	if(cnt_md1<10)
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRSH _0x28
;     246 		{
;     247 		cnt_md1++;
	LDS  R30,_cnt_md1
	SUBI R30,-LOW(1)
	STS  _cnt_md1,R30
;     248 		if(cnt_md1==10) bMD1=1;
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRNE _0x29
	LDI  R30,LOW(1)
	STS  _bMD1,R30
;     249 		}
_0x29:
;     250 
;     251 	}
_0x28:
;     252 else
	RJMP _0x2A
_0x27:
;     253 	{
;     254 	if(cnt_md1)
	LDS  R30,_cnt_md1
	CPI  R30,0
	BREQ _0x2B
;     255 		{
;     256 		cnt_md1--;
	SUBI R30,LOW(1)
	STS  _cnt_md1,R30
;     257 		if(cnt_md1==0) bMD1=0;
	CPI  R30,0
	BRNE _0x2C
	LDI  R30,LOW(0)
	STS  _bMD1,R30
;     258 		}
_0x2C:
;     259 
;     260 	}
_0x2B:
_0x2A:
;     261 
;     262 if(!(in_word&(1<<MD2)))
	SBRC R14,3
	RJMP _0x2D
;     263 	{
;     264 	if(cnt_md2<10)
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRSH _0x2E
;     265 		{
;     266 		cnt_md2++;
	LDS  R30,_cnt_md2
	SUBI R30,-LOW(1)
	STS  _cnt_md2,R30
;     267 		if(cnt_md2==10) bMD2=1;
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRNE _0x2F
	SET
	BLD  R3,2
;     268 		}
_0x2F:
;     269 
;     270 	}
_0x2E:
;     271 else
	RJMP _0x30
_0x2D:
;     272 	{
;     273 	if(cnt_md2)
	LDS  R30,_cnt_md2
	CPI  R30,0
	BREQ _0x31
;     274 		{
;     275 		cnt_md2--;
	SUBI R30,LOW(1)
	STS  _cnt_md2,R30
;     276 		if(cnt_md2==0) bMD2=0;
	CPI  R30,0
	BRNE _0x32
	CLT
	BLD  R3,2
;     277 		}
_0x32:
;     278 
;     279 	}
_0x31:
_0x30:
;     280 
;     281 if(!(in_word&(1<<MD3)))
	SBRC R14,5
	RJMP _0x33
;     282 	{
;     283 	if(cnt_md3<10)
	LDS  R26,_cnt_md3
	CPI  R26,LOW(0xA)
	BRSH _0x34
;     284 		{
;     285 		cnt_md3++;
	LDS  R30,_cnt_md3
	SUBI R30,-LOW(1)
	STS  _cnt_md3,R30
;     286 		if(cnt_md3==10) bMD3=1;
	LDS  R26,_cnt_md3
	CPI  R26,LOW(0xA)
	BRNE _0x35
	SET
	BLD  R3,3
;     287 		}
_0x35:
;     288 
;     289 	}
_0x34:
;     290 else
	RJMP _0x36
_0x33:
;     291 	{
;     292 	if(cnt_md3)
	LDS  R30,_cnt_md3
	CPI  R30,0
	BREQ _0x37
;     293 		{
;     294 		cnt_md3--;
	SUBI R30,LOW(1)
	STS  _cnt_md3,R30
;     295 		if(cnt_md3==0) bMD3=0;
	CPI  R30,0
	BRNE _0x38
	CLT
	BLD  R3,3
;     296 		}
_0x38:
;     297 
;     298 	}
_0x37:
_0x36:
;     299 
;     300 if(((!(in_word&(1<<VR)))&&(ee_vr_log)) || (((in_word&(1<<VR)))&&(!ee_vr_log)))
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
;     301 	{
;     302 	if(cnt_vr<10)
	LDS  R26,_cnt_vr
	CPI  R26,LOW(0xA)
	BRSH _0x40
;     303 		{
;     304 		cnt_vr++;
	LDS  R30,_cnt_vr
	SUBI R30,-LOW(1)
	STS  _cnt_vr,R30
;     305 		if(cnt_vr==10) bVR=1;
	LDS  R26,_cnt_vr
	CPI  R26,LOW(0xA)
	BRNE _0x41
	LDI  R30,LOW(1)
	STS  _bVR,R30
;     306 		}
_0x41:
;     307 
;     308 	}
_0x40:
;     309 else
	RJMP _0x42
_0x39:
;     310 	{
;     311 	if(cnt_vr)
	LDS  R30,_cnt_vr
	CPI  R30,0
	BREQ _0x43
;     312 		{
;     313 		cnt_vr--;
	SUBI R30,LOW(1)
	STS  _cnt_vr,R30
;     314 		if(cnt_vr==0) bVR=0;
	CPI  R30,0
	BRNE _0x44
	LDI  R30,LOW(0)
	STS  _bVR,R30
;     315 		}
_0x44:
;     316 
;     317 	}
_0x43:
_0x42:
;     318 } 
	RET
;     319 
;     320 #ifdef DV3KL2MD
;     321 //-----------------------------------------------
;     322 void step_contr(void)
;     323 {
_step_contr:
;     324 char temp=0;
;     325 DDRB=0xFF;
	ST   -Y,R16
;	temp -> R16
	LDI  R16,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     326 
;     327 if(step==sOFF)
	TST  R11
	BRNE _0x45
;     328 	{
;     329 	temp=0;
	LDI  R16,LOW(0)
;     330 	}
;     331 
;     332 else if(step==s1)
	RJMP _0x46
_0x45:
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x47
;     333 	{
;     334 	temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     335 
;     336 	cnt_del--;
	CALL SUBOPT_0x1
;     337 	if(cnt_del==0)
	BRNE _0x48
;     338 		{
;     339 		step=s2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;     340 		cnt_del=20;
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;     341 		}
;     342 	}
_0x48:
;     343 
;     344 
;     345 else if(step==s2)
	RJMP _0x49
_0x47:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x4A
;     346 	{
;     347 	temp|=(1<<PP1)|(1<<DV);
	ORI  R16,LOW(68)
;     348 
;     349 	cnt_del--;
	CALL SUBOPT_0x1
;     350 	if(cnt_del==0)
	BRNE _0x4B
;     351 		{
;     352 		step=s3;
	LDI  R30,LOW(3)
	MOV  R11,R30
;     353 		}
;     354 	}
_0x4B:
;     355 	
;     356 else if(step==s3)
	RJMP _0x4C
_0x4A:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0x4D
;     357 	{
;     358 	temp|=(1<<PP1)|(1<<PP2)|(1<<DV);
	ORI  R16,LOW(196)
;     359      if(!bMD1)goto step_contr_end;
	LDS  R30,_bMD1
	CPI  R30,0
	BREQ _0x4F
;     360      step=s4;
	LDI  R30,LOW(4)
	MOV  R11,R30
;     361      }     
;     362 else if(step==s4)
	RJMP _0x50
_0x4D:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0x51
;     363 	{          
;     364      temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
	ORI  R16,LOW(76)
;     365      if(!bMD2)goto step_contr_end;
	SBRS R3,2
	RJMP _0x4F
;     366      step=s5;
	LDI  R30,LOW(5)
	CALL SUBOPT_0x2
;     367      cnt_del=50;
;     368      } 
;     369 else if(step==s5)
	RJMP _0x53
_0x51:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0x54
;     370 	{
;     371 	temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
	ORI  R16,LOW(76)
;     372 
;     373 	cnt_del--;
	CALL SUBOPT_0x1
;     374 	if(cnt_del==0)
	BRNE _0x55
;     375 		{
;     376 		step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x2
;     377 		cnt_del=50;
;     378 		}
;     379 	}         
_0x55:
;     380 /*else if(step==s6)
;     381 	{
;     382 	temp|=(1<<PP1)|(1<<DV);
;     383 
;     384 	cnt_del--;
;     385 	if(cnt_del==0)
;     386 		{
;     387 		step=s6;
;     388 		cnt_del=70;
;     389 		}
;     390 	}*/     
;     391 else if(step==s6)
	RJMP _0x56
_0x54:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0x57
;     392 		{
;     393 	temp|=(1<<PP1);
	ORI  R16,LOW(64)
;     394 	cnt_del--;
	CALL SUBOPT_0x1
;     395 	if(cnt_del==0)
	BRNE _0x58
;     396 		{
;     397 		step=sOFF;
	CLR  R11
;     398           }     
;     399      }     
_0x58:
;     400 
;     401 step_contr_end:
_0x57:
_0x56:
_0x53:
_0x50:
_0x4C:
_0x49:
_0x46:
_0x4F:
;     402 
;     403 PORTB=~temp;
	MOV  R30,R16
	COM  R30
	OUT  0x18,R30
;     404 }
	LD   R16,Y+
	RET
;     405 #endif
;     406 
;     407 #ifdef P380_MINI
;     408 //-----------------------------------------------
;     409 void step_contr(void)
;     410 {
;     411 char temp=0;
;     412 DDRB=0xFF;
;     413 
;     414 if(step==sOFF)
;     415 	{
;     416 	temp=0;
;     417 	}
;     418 
;     419 else if(step==s1)
;     420 	{
;     421 	temp|=(1<<PP1);
;     422 
;     423 	cnt_del--;
;     424 	if(cnt_del==0)
;     425 		{
;     426 		step=s2;
;     427 		}
;     428 	}
;     429 
;     430 else if(step==s2)
;     431 	{
;     432 	temp|=(1<<PP1)|(1<<PP2)|(1<<DV);
;     433      if(!bMD1)goto step_contr_end;
;     434      step=s3;
;     435      }     
;     436 else if(step==s3)
;     437 	{          
;     438      temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     439      if(!bMD2)goto step_contr_end;
;     440      step=s4;
;     441      cnt_del=50;
;     442      }
;     443 else if(step==s4)
;     444 		{
;     445 	temp|=(1<<PP1);
;     446 	cnt_del--;
;     447 	if(cnt_del==0)
;     448 		{
;     449 		step=sOFF;
;     450           }     
;     451      }     
;     452 
;     453 step_contr_end:
;     454 
;     455 PORTB=~temp;
;     456 }
;     457 #endif
;     458 
;     459 #ifdef P380
;     460 //-----------------------------------------------
;     461 void step_contr(void)
;     462 {
;     463 char temp=0;
;     464 DDRB=0xFF;
;     465 
;     466 if(step==sOFF)
;     467 	{
;     468 	temp=0;
;     469 	}
;     470 
;     471 else if(prog==p1)
;     472 	{
;     473 	if(step==s1)
;     474 		{
;     475 		temp|=(1<<PP1)|(1<<PP2);
;     476 
;     477 		cnt_del--;
;     478 		if(cnt_del==0)
;     479 			{
;     480 			if(ee_vacuum_mode==evmOFF)
;     481 				{
;     482 				goto lbl_0001;
;     483 				}
;     484 			else step=s2;
;     485 			}
;     486 		}
;     487 
;     488 	else if(step==s2)
;     489 		{
;     490 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     491 
;     492           if(!bVR)goto step_contr_end;
;     493 lbl_0001:
;     494 #ifndef BIG_CAM
;     495 		cnt_del=30;
;     496 #endif
;     497 
;     498 #ifdef BIG_CAM
;     499 		cnt_del=100;
;     500 #endif
;     501 		step=s3;
;     502 		}
;     503 
;     504 	else if(step==s3)
;     505 		{
;     506 		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     507 		cnt_del--;
;     508 		if(cnt_del==0)
;     509 			{
;     510 			step=s4;
;     511 			}
;     512           }
;     513 	else if(step==s4)
;     514 		{
;     515 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     516 
;     517           if(!bMD1)goto step_contr_end;
;     518 
;     519 		cnt_del=40;
;     520 		step=s5;
;     521 		}
;     522 	else if(step==s5)
;     523 		{
;     524 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     525 
;     526 		cnt_del--;
;     527 		if(cnt_del==0)
;     528 			{
;     529 			step=s6;
;     530 			}
;     531 		}
;     532 	else if(step==s6)
;     533 		{
;     534 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     535 
;     536          	if(!bMD2)goto step_contr_end;
;     537           cnt_del=40;
;     538 		//step=s7;
;     539 		
;     540           step=s55;
;     541           cnt_del=40;
;     542 		}
;     543 	else if(step==s55)
;     544 		{
;     545 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     546           cnt_del--;
;     547           if(cnt_del==0)
;     548 			{
;     549           	step=s7;
;     550           	cnt_del=20;
;     551 			}
;     552          		
;     553 		}
;     554 	else if(step==s7)
;     555 		{
;     556 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     557 
;     558 		cnt_del--;
;     559 		if(cnt_del==0)
;     560 			{
;     561 			step=s8;
;     562 			cnt_del=30;
;     563 			}
;     564 		}
;     565 	else if(step==s8)
;     566 		{
;     567 		temp|=(1<<PP1)|(1<<PP3);
;     568 
;     569 		cnt_del--;
;     570 		if(cnt_del==0)
;     571 			{
;     572 			step=s9;
;     573 #ifndef BIG_CAM
;     574 		cnt_del=150;
;     575 #endif
;     576 
;     577 #ifdef BIG_CAM
;     578 		cnt_del=200;
;     579 #endif
;     580 			}
;     581 		}
;     582 	else if(step==s9)
;     583 		{
;     584 		temp|=(1<<PP1)|(1<<PP2);
;     585 
;     586 		cnt_del--;
;     587 		if(cnt_del==0)
;     588 			{
;     589 			step=s10;
;     590 			cnt_del=30;
;     591 			}
;     592 		}
;     593 	else if(step==s10)
;     594 		{
;     595 		temp|=(1<<PP2);
;     596 		cnt_del--;
;     597 		if(cnt_del==0)
;     598 			{
;     599 			step=sOFF;
;     600 			}
;     601 		}
;     602 	}
;     603 
;     604 if(prog==p2)
;     605 	{
;     606 
;     607 	if(step==s1)
;     608 		{
;     609 		temp|=(1<<PP1)|(1<<PP2);
;     610 
;     611 		cnt_del--;
;     612 		if(cnt_del==0)
;     613 			{
;     614 			if(ee_vacuum_mode==evmOFF)
;     615 				{
;     616 				goto lbl_0002;
;     617 				}
;     618 			else step=s2;
;     619 			}
;     620 		}
;     621 
;     622 	else if(step==s2)
;     623 		{
;     624 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     625 
;     626           if(!bVR)goto step_contr_end;
;     627 lbl_0002:
;     628 #ifndef BIG_CAM
;     629 		cnt_del=30;
;     630 #endif
;     631 
;     632 #ifdef BIG_CAM
;     633 		cnt_del=100;
;     634 #endif
;     635 		step=s3;
;     636 		}
;     637 
;     638 	else if(step==s3)
;     639 		{
;     640 		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     641 
;     642 		cnt_del--;
;     643 		if(cnt_del==0)
;     644 			{
;     645 			step=s4;
;     646 			}
;     647 		}
;     648 
;     649 	else if(step==s4)
;     650 		{
;     651 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     652 
;     653           if(!bMD1)goto step_contr_end;
;     654          	cnt_del=30;
;     655 		step=s5;
;     656 		}
;     657 
;     658 	else if(step==s5)
;     659 		{
;     660 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     661 
;     662 		cnt_del--;
;     663 		if(cnt_del==0)
;     664 			{
;     665 			step=s6;
;     666 			cnt_del=30;
;     667 			}
;     668 		}
;     669 
;     670 	else if(step==s6)
;     671 		{
;     672 		temp|=(1<<PP1)|(1<<PP3);
;     673 
;     674 		cnt_del--;
;     675 		if(cnt_del==0)
;     676 			{
;     677 			step=s7;
;     678 #ifndef BIG_CAM
;     679 		cnt_del=150;
;     680 #endif
;     681 
;     682 #ifdef BIG_CAM
;     683 		cnt_del=200;
;     684 #endif
;     685 			}
;     686 		}
;     687 
;     688 	else if(step==s7)
;     689 		{
;     690 		temp|=(1<<PP1)|(1<<PP2);
;     691 
;     692 		cnt_del--;
;     693 		if(cnt_del==0)
;     694 			{
;     695 			step=s8;
;     696 			cnt_del=30;
;     697 			}
;     698 		}
;     699 	else if(step==s8)
;     700 		{
;     701 		temp|=(1<<PP2);
;     702 
;     703 		cnt_del--;
;     704 		if(cnt_del==0)
;     705 			{
;     706 			step=sOFF;
;     707 			}
;     708 		}
;     709 	}
;     710 
;     711 if(prog==p3)
;     712 	{
;     713 
;     714 	if(step==s1)
;     715 		{
;     716 		temp|=(1<<PP1)|(1<<PP2);
;     717 
;     718 		cnt_del--;
;     719 		if(cnt_del==0)
;     720 			{
;     721 			if(ee_vacuum_mode==evmOFF)
;     722 				{
;     723 				goto lbl_0003;
;     724 				}
;     725 			else step=s2;
;     726 			}
;     727 		}
;     728 
;     729 	else if(step==s2)
;     730 		{
;     731 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     732 
;     733           if(!bVR)goto step_contr_end;
;     734 lbl_0003:
;     735 #ifndef BIG_CAM
;     736 		cnt_del=80;
;     737 #endif
;     738 
;     739 #ifdef BIG_CAM
;     740 		cnt_del=100;
;     741 #endif
;     742 		step=s3;
;     743 		}
;     744 
;     745 	else if(step==s3)
;     746 		{
;     747 		temp|=(1<<PP1)|(1<<PP3);
;     748 
;     749 		cnt_del--;
;     750 		if(cnt_del==0)
;     751 			{
;     752 			step=s4;
;     753 			cnt_del=120;
;     754 			}
;     755 		}
;     756 
;     757 	else if(step==s4)
;     758 		{
;     759 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<PP5);
;     760 
;     761 		cnt_del--;
;     762 		if(cnt_del==0)
;     763 			{
;     764 			step=s5;
;     765 
;     766 		
;     767 #ifndef BIG_CAM
;     768 		cnt_del=150;
;     769 #endif
;     770 
;     771 #ifdef BIG_CAM
;     772 		cnt_del=200;
;     773 #endif
;     774 	//	step=s5;
;     775 	}
;     776 		}
;     777 
;     778 	else if(step==s5)
;     779 		{
;     780 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<PP5);
;     781 
;     782 		cnt_del--;
;     783 		if(cnt_del==0)
;     784 			{
;     785 			step=s6;
;     786 			cnt_del=30;
;     787 			}
;     788 		}
;     789 
;     790 	else if(step==s6)
;     791 		{
;     792 		temp|=(1<<PP2)|(1<<PP4)|(1<<PP5);
;     793 
;     794 		cnt_del--;
;     795 		if(cnt_del==0)
;     796 			{
;     797 			step=s7;
;     798 			cnt_del=30;
;     799 			}
;     800 		}
;     801 
;     802 	else if(step==s7)
;     803 		{
;     804 		temp|=(1<<PP2);
;     805 
;     806 		cnt_del--;
;     807 		if(cnt_del==0)
;     808 			{
;     809 			step=sOFF;
;     810 			}
;     811 		}
;     812 
;     813 	}
;     814 step_contr_end:
;     815 
;     816 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;     817 
;     818 PORTB=~temp;
;     819 }
;     820 #endif
;     821 #ifdef I380
;     822 //-----------------------------------------------
;     823 void step_contr(void)
;     824 {
;     825 char temp=0;
;     826 DDRB=0xFF;
;     827 
;     828 if(step==sOFF)goto step_contr_end;
;     829 
;     830 else if(prog==p1)
;     831 	{
;     832 	if(step==s1)    //жесть
;     833 		{
;     834 		temp|=(1<<PP1);
;     835           if(!bMD1)goto step_contr_end;
;     836 
;     837 			if(ee_vacuum_mode==evmOFF)
;     838 				{
;     839 				goto lbl_0001;
;     840 				}
;     841 			else step=s2;
;     842 		}
;     843 
;     844 	else if(step==s2)
;     845 		{
;     846 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     847           if(!bVR)goto step_contr_end;
;     848 lbl_0001:
;     849 
;     850           step=s100;
;     851 		cnt_del=40;
;     852           }
;     853 	else if(step==s100)
;     854 		{
;     855 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;     856           cnt_del--;
;     857           if(cnt_del==0)
;     858 			{
;     859           	step=s3;
;     860           	cnt_del=50;
;     861 			}
;     862 		}
;     863 
;     864 	else if(step==s3)
;     865 		{
;     866 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     867           cnt_del--;
;     868           if(cnt_del==0)
;     869 			{
;     870           	step=s4;
;     871 			}
;     872 		}
;     873 	else if(step==s4)
;     874 		{
;     875 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;     876           if(!bMD2)goto step_contr_end;
;     877           step=s5;
;     878           cnt_del=20;
;     879 		}
;     880 	else if(step==s5)
;     881 		{
;     882 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     883           cnt_del--;
;     884           if(cnt_del==0)
;     885 			{
;     886           	step=s6;
;     887 			}
;     888           }
;     889 	else if(step==s6)
;     890 		{
;     891 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
;     892           if(!bMD3)goto step_contr_end;
;     893           step=s7;
;     894           cnt_del=20;
;     895 		}
;     896 
;     897 	else if(step==s7)
;     898 		{
;     899 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     900           cnt_del--;
;     901           if(cnt_del==0)
;     902 			{
;     903           	step=s8;
;     904           	cnt_del=ee_delay[prog,0]*10U;;
;     905 			}
;     906           }
;     907 	else if(step==s8)
;     908 		{
;     909 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;     910           cnt_del--;
;     911           if(cnt_del==0)
;     912 			{
;     913           	step=s9;
;     914           	cnt_del=20;
;     915 			}
;     916           }
;     917 	else if(step==s9)
;     918 		{
;     919 		temp|=(1<<PP1);
;     920           cnt_del--;
;     921           if(cnt_del==0)
;     922 			{
;     923           	step=sOFF;
;     924           	}
;     925           }
;     926 	}
;     927 
;     928 else if(prog==p2)  //ско
;     929 	{
;     930 	if(step==s1)
;     931 		{
;     932 		temp|=(1<<PP1);
;     933           if(!bMD1)goto step_contr_end;
;     934 
;     935 			if(ee_vacuum_mode==evmOFF)
;     936 				{
;     937 				goto lbl_0002;
;     938 				}
;     939 			else step=s2;
;     940 
;     941           //step=s2;
;     942 		}
;     943 
;     944 	else if(step==s2)
;     945 		{
;     946 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     947           if(!bVR)goto step_contr_end;
;     948 
;     949 lbl_0002:
;     950           step=s100;
;     951 		cnt_del=40;
;     952           }
;     953 	else if(step==s100)
;     954 		{
;     955 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;     956           cnt_del--;
;     957           if(cnt_del==0)
;     958 			{
;     959           	step=s3;
;     960           	cnt_del=50;
;     961 			}
;     962 		}
;     963 	else if(step==s3)
;     964 		{
;     965 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     966           cnt_del--;
;     967           if(cnt_del==0)
;     968 			{
;     969           	step=s4;
;     970 			}
;     971 		}
;     972 	else if(step==s4)
;     973 		{
;     974 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;     975           if(!bMD2)goto step_contr_end;
;     976           step=s5;
;     977           cnt_del=20;
;     978 		}
;     979 	else if(step==s5)
;     980 		{
;     981 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     982           cnt_del--;
;     983           if(cnt_del==0)
;     984 			{
;     985           	step=s6;
;     986           	cnt_del=ee_delay[prog,0]*10U;
;     987 			}
;     988           }
;     989 	else if(step==s6)
;     990 		{
;     991 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;     992           cnt_del--;
;     993           if(cnt_del==0)
;     994 			{
;     995           	step=s7;
;     996           	cnt_del=20;
;     997 			}
;     998           }
;     999 	else if(step==s7)
;    1000 		{
;    1001 		temp|=(1<<PP1);
;    1002           cnt_del--;
;    1003           if(cnt_del==0)
;    1004 			{
;    1005           	step=sOFF;
;    1006           	}
;    1007           }
;    1008 	}
;    1009 
;    1010 else if(prog==p3)   //твист
;    1011 	{
;    1012 	if(step==s1)
;    1013 		{
;    1014 		temp|=(1<<PP1);
;    1015           if(!bMD1)goto step_contr_end;
;    1016 
;    1017 			if(ee_vacuum_mode==evmOFF)
;    1018 				{
;    1019 				goto lbl_0003;
;    1020 				}
;    1021 			else step=s2;
;    1022 
;    1023           //step=s2;
;    1024 		}
;    1025 
;    1026 	else if(step==s2)
;    1027 		{
;    1028 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1029           if(!bVR)goto step_contr_end;
;    1030 lbl_0003:
;    1031           cnt_del=50;
;    1032 		step=s3;
;    1033 		}
;    1034 
;    1035 
;    1036 	else	if(step==s3)
;    1037 		{
;    1038 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1039 		cnt_del--;
;    1040 		if(cnt_del==0)
;    1041 			{
;    1042 			cnt_del=ee_delay[prog,0]*10U;
;    1043 			step=s4;
;    1044 			}
;    1045           }
;    1046 	else if(step==s4)
;    1047 		{
;    1048 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1049 		cnt_del--;
;    1050  		if(cnt_del==0)
;    1051 			{
;    1052 			cnt_del=ee_delay[prog,1]*10U;
;    1053 			step=s5;
;    1054 			}
;    1055 		}
;    1056 
;    1057 	else if(step==s5)
;    1058 		{
;    1059 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1060 		cnt_del--;
;    1061 		if(cnt_del==0)
;    1062 			{
;    1063 			step=s6;
;    1064 			cnt_del=20;
;    1065 			}
;    1066 		}
;    1067 
;    1068 	else if(step==s6)
;    1069 		{
;    1070 		temp|=(1<<PP1);
;    1071   		cnt_del--;
;    1072 		if(cnt_del==0)
;    1073 			{
;    1074 			step=sOFF;
;    1075 			}
;    1076 		}
;    1077 
;    1078 	}
;    1079 
;    1080 else if(prog==p4)      //замок
;    1081 	{
;    1082 	if(step==s1)
;    1083 		{
;    1084 		temp|=(1<<PP1);
;    1085           if(!bMD1)goto step_contr_end;
;    1086 
;    1087 			if(ee_vacuum_mode==evmOFF)
;    1088 				{
;    1089 				goto lbl_0004;
;    1090 				}
;    1091 			else step=s2;
;    1092           //step=s2;
;    1093 		}
;    1094 
;    1095 	else if(step==s2)
;    1096 		{
;    1097 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1098           if(!bVR)goto step_contr_end;
;    1099 lbl_0004:
;    1100           step=s3;
;    1101 		cnt_del=50;
;    1102           }
;    1103 
;    1104 	else if(step==s3)
;    1105 		{
;    1106 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1107           cnt_del--;
;    1108           if(cnt_del==0)
;    1109 			{
;    1110           	step=s4;
;    1111 			cnt_del=ee_delay[prog,0]*10U;
;    1112 			}
;    1113           }
;    1114 
;    1115    	else if(step==s4)
;    1116 		{
;    1117 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1118 		cnt_del--;
;    1119 		if(cnt_del==0)
;    1120 			{
;    1121 			step=s5;
;    1122 			cnt_del=30;
;    1123 			}
;    1124 		}
;    1125 
;    1126 	else if(step==s5)
;    1127 		{
;    1128 		temp|=(1<<PP1)|(1<<PP4);
;    1129 		cnt_del--;
;    1130 		if(cnt_del==0)
;    1131 			{
;    1132 			step=s6;
;    1133 			cnt_del=ee_delay[prog,1]*10U;
;    1134 			}
;    1135 		}
;    1136 
;    1137 	else if(step==s6)
;    1138 		{
;    1139 		temp|=(1<<PP4);
;    1140 		cnt_del--;
;    1141 		if(cnt_del==0)
;    1142 			{
;    1143 			step=sOFF;
;    1144 			}
;    1145 		}
;    1146 
;    1147 	}
;    1148 	
;    1149 step_contr_end:
;    1150 
;    1151 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1152 
;    1153 PORTB=~temp;
;    1154 //PORTB=0x55;
;    1155 }
;    1156 #endif
;    1157 
;    1158 #ifdef I220_WI
;    1159 //-----------------------------------------------
;    1160 void step_contr(void)
;    1161 {
;    1162 char temp=0;
;    1163 DDRB=0xFF;
;    1164 
;    1165 if(step==sOFF)goto step_contr_end;
;    1166 
;    1167 else if(prog==p3)   //твист
;    1168 	{
;    1169 	if(step==s1)
;    1170 		{
;    1171 		temp|=(1<<PP1);
;    1172           if(!bMD1)goto step_contr_end;
;    1173 
;    1174 			if(ee_vacuum_mode==evmOFF)
;    1175 				{
;    1176 				goto lbl_0003;
;    1177 				}
;    1178 			else step=s2;
;    1179 
;    1180           //step=s2;
;    1181 		}
;    1182 
;    1183 	else if(step==s2)
;    1184 		{
;    1185 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1186           if(!bVR)goto step_contr_end;
;    1187 lbl_0003:
;    1188           cnt_del=50;
;    1189 		step=s3;
;    1190 		}
;    1191 
;    1192 
;    1193 	else	if(step==s3)
;    1194 		{
;    1195 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1196 		cnt_del--;
;    1197 		if(cnt_del==0)
;    1198 			{
;    1199 			cnt_del=90;
;    1200 			step=s4;
;    1201 			}
;    1202           }
;    1203 	else if(step==s4)
;    1204 		{
;    1205 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1206 		cnt_del--;
;    1207  		if(cnt_del==0)
;    1208 			{
;    1209 			cnt_del=130;
;    1210 			step=s5;
;    1211 			}
;    1212 		}
;    1213 
;    1214 	else if(step==s5)
;    1215 		{
;    1216 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1217 		cnt_del--;
;    1218 		if(cnt_del==0)
;    1219 			{
;    1220 			step=s6;
;    1221 			cnt_del=20;
;    1222 			}
;    1223 		}
;    1224 
;    1225 	else if(step==s6)
;    1226 		{
;    1227 		temp|=(1<<PP1);
;    1228   		cnt_del--;
;    1229 		if(cnt_del==0)
;    1230 			{
;    1231 			step=sOFF;
;    1232 			}
;    1233 		}
;    1234 
;    1235 	}
;    1236 
;    1237 else if(prog==p4)      //замок
;    1238 	{
;    1239 	if(step==s1)
;    1240 		{
;    1241 		temp|=(1<<PP1);
;    1242           if(!bMD1)goto step_contr_end;
;    1243 
;    1244 			if(ee_vacuum_mode==evmOFF)
;    1245 				{
;    1246 				goto lbl_0004;
;    1247 				}
;    1248 			else step=s2;
;    1249           //step=s2;
;    1250 		}
;    1251 
;    1252 	else if(step==s2)
;    1253 		{
;    1254 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1255           if(!bVR)goto step_contr_end;
;    1256 lbl_0004:
;    1257           step=s3;
;    1258 		cnt_del=50;
;    1259           }
;    1260 
;    1261 	else if(step==s3)
;    1262 		{
;    1263 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1264           cnt_del--;
;    1265           if(cnt_del==0)
;    1266 			{
;    1267           	step=s4;
;    1268 			cnt_del=120;
;    1269 			}
;    1270           }
;    1271 
;    1272    	else if(step==s4)
;    1273 		{
;    1274 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1275 		cnt_del--;
;    1276 		if(cnt_del==0)
;    1277 			{
;    1278 			step=s5;
;    1279 			cnt_del=30;
;    1280 			}
;    1281 		}
;    1282 
;    1283 	else if(step==s5)
;    1284 		{
;    1285 		temp|=(1<<PP1)|(1<<PP4);
;    1286 		cnt_del--;
;    1287 		if(cnt_del==0)
;    1288 			{
;    1289 			step=s6;
;    1290 			cnt_del=120;
;    1291 			}
;    1292 		}
;    1293 
;    1294 	else if(step==s6)
;    1295 		{
;    1296 		temp|=(1<<PP4);
;    1297 		cnt_del--;
;    1298 		if(cnt_del==0)
;    1299 			{
;    1300 			step=sOFF;
;    1301 			}
;    1302 		}
;    1303 
;    1304 	}
;    1305 	
;    1306 step_contr_end:
;    1307 
;    1308 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1309 
;    1310 PORTB=~temp;
;    1311 //PORTB=0x55;
;    1312 }
;    1313 #endif 
;    1314 
;    1315 #ifdef I380_WI
;    1316 //-----------------------------------------------
;    1317 void step_contr(void)
;    1318 {
;    1319 char temp=0;
;    1320 DDRB=0xFF;
;    1321 
;    1322 if(step==sOFF)goto step_contr_end;
;    1323 
;    1324 else if(prog==p1)
;    1325 	{
;    1326 	if(step==s1)    //жесть
;    1327 		{
;    1328 		temp|=(1<<PP1);
;    1329           if(!bMD1)goto step_contr_end;
;    1330 
;    1331 			if(ee_vacuum_mode==evmOFF)
;    1332 				{
;    1333 				goto lbl_0001;
;    1334 				}
;    1335 			else step=s2;
;    1336 		}
;    1337 
;    1338 	else if(step==s2)
;    1339 		{
;    1340 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1341           if(!bVR)goto step_contr_end;
;    1342 lbl_0001:
;    1343 
;    1344           step=s100;
;    1345 		cnt_del=40;
;    1346           }
;    1347 	else if(step==s100)
;    1348 		{
;    1349 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1350           cnt_del--;
;    1351           if(cnt_del==0)
;    1352 			{
;    1353           	step=s3;
;    1354           	cnt_del=50;
;    1355 			}
;    1356 		}
;    1357 
;    1358 	else if(step==s3)
;    1359 		{
;    1360 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1361           cnt_del--;
;    1362           if(cnt_del==0)
;    1363 			{
;    1364           	step=s4;
;    1365 			}
;    1366 		}
;    1367 	else if(step==s4)
;    1368 		{
;    1369 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;    1370           if(!bMD2)goto step_contr_end;
;    1371           step=s54;
;    1372           cnt_del=20;
;    1373 		}
;    1374 	else if(step==s54)
;    1375 		{
;    1376 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;    1377           cnt_del--;
;    1378           if(cnt_del==0)
;    1379 			{
;    1380           	step=s5;
;    1381           	cnt_del=20;
;    1382 			}
;    1383           }
;    1384 
;    1385 	else if(step==s5)
;    1386 		{
;    1387 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1388           cnt_del--;
;    1389           if(cnt_del==0)
;    1390 			{
;    1391           	step=s6;
;    1392 			}
;    1393           }
;    1394 	else if(step==s6)
;    1395 		{
;    1396 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
;    1397           if(!bMD3)goto step_contr_end;
;    1398           step=s55;
;    1399           cnt_del=40;
;    1400 		}
;    1401 	else if(step==s55)
;    1402 		{
;    1403 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
;    1404           cnt_del--;
;    1405           if(cnt_del==0)
;    1406 			{
;    1407           	step=s7;
;    1408           	cnt_del=20;
;    1409 			}
;    1410           }
;    1411 	else if(step==s7)
;    1412 		{
;    1413 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1414           cnt_del--;
;    1415           if(cnt_del==0)
;    1416 			{
;    1417           	step=s8;
;    1418           	cnt_del=130;
;    1419 			}
;    1420           }
;    1421 	else if(step==s8)
;    1422 		{
;    1423 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1424           cnt_del--;
;    1425           if(cnt_del==0)
;    1426 			{
;    1427           	step=s9;
;    1428           	cnt_del=20;
;    1429 			}
;    1430           }
;    1431 	else if(step==s9)
;    1432 		{
;    1433 		temp|=(1<<PP1);
;    1434           cnt_del--;
;    1435           if(cnt_del==0)
;    1436 			{
;    1437           	step=sOFF;
;    1438           	}
;    1439           }
;    1440 	}
;    1441 
;    1442 else if(prog==p2)  //ско
;    1443 	{
;    1444 	if(step==s1)
;    1445 		{
;    1446 		temp|=(1<<PP1);
;    1447           if(!bMD1)goto step_contr_end;
;    1448 
;    1449 			if(ee_vacuum_mode==evmOFF)
;    1450 				{
;    1451 				goto lbl_0002;
;    1452 				}
;    1453 			else step=s2;
;    1454 
;    1455           //step=s2;
;    1456 		}
;    1457 
;    1458 	else if(step==s2)
;    1459 		{
;    1460 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1461           if(!bVR)goto step_contr_end;
;    1462 
;    1463 lbl_0002:
;    1464           step=s100;
;    1465 		cnt_del=40;
;    1466           }
;    1467 	else if(step==s100)
;    1468 		{
;    1469 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1470           cnt_del--;
;    1471           if(cnt_del==0)
;    1472 			{
;    1473           	step=s3;
;    1474           	cnt_del=50;
;    1475 			}
;    1476 		}
;    1477 	else if(step==s3)
;    1478 		{
;    1479 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1480           cnt_del--;
;    1481           if(cnt_del==0)
;    1482 			{
;    1483           	step=s4;
;    1484 			}
;    1485 		}
;    1486 	else if(step==s4)
;    1487 		{
;    1488 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;    1489           if(!bMD2)goto step_contr_end;
;    1490           step=s5;
;    1491           cnt_del=20;
;    1492 		}
;    1493 	else if(step==s5)
;    1494 		{
;    1495 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1496           cnt_del--;
;    1497           if(cnt_del==0)
;    1498 			{
;    1499           	step=s6;
;    1500           	cnt_del=130;
;    1501 			}
;    1502           }
;    1503 	else if(step==s6)
;    1504 		{
;    1505 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1506           cnt_del--;
;    1507           if(cnt_del==0)
;    1508 			{
;    1509           	step=s7;
;    1510           	cnt_del=20;
;    1511 			}
;    1512           }
;    1513 	else if(step==s7)
;    1514 		{
;    1515 		temp|=(1<<PP1);
;    1516           cnt_del--;
;    1517           if(cnt_del==0)
;    1518 			{
;    1519           	step=sOFF;
;    1520           	}
;    1521           }
;    1522 	}
;    1523 
;    1524 else if(prog==p3)   //твист
;    1525 	{
;    1526 	if(step==s1)
;    1527 		{
;    1528 		temp|=(1<<PP1);
;    1529           if(!bMD1)goto step_contr_end;
;    1530 
;    1531 			if(ee_vacuum_mode==evmOFF)
;    1532 				{
;    1533 				goto lbl_0003;
;    1534 				}
;    1535 			else step=s2;
;    1536 
;    1537           //step=s2;
;    1538 		}
;    1539 
;    1540 	else if(step==s2)
;    1541 		{
;    1542 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1543           if(!bVR)goto step_contr_end;
;    1544 lbl_0003:
;    1545           cnt_del=50;
;    1546 		step=s3;
;    1547 		}
;    1548 
;    1549 
;    1550 	else	if(step==s3)
;    1551 		{
;    1552 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1553 		cnt_del--;
;    1554 		if(cnt_del==0)
;    1555 			{
;    1556 			cnt_del=90;
;    1557 			step=s4;
;    1558 			}
;    1559           }
;    1560 	else if(step==s4)
;    1561 		{
;    1562 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1563 		cnt_del--;
;    1564  		if(cnt_del==0)
;    1565 			{
;    1566 			cnt_del=130;
;    1567 			step=s5;
;    1568 			}
;    1569 		}
;    1570 
;    1571 	else if(step==s5)
;    1572 		{
;    1573 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1574 		cnt_del--;
;    1575 		if(cnt_del==0)
;    1576 			{
;    1577 			step=s6;
;    1578 			cnt_del=20;
;    1579 			}
;    1580 		}
;    1581 
;    1582 	else if(step==s6)
;    1583 		{
;    1584 		temp|=(1<<PP1);
;    1585   		cnt_del--;
;    1586 		if(cnt_del==0)
;    1587 			{
;    1588 			step=sOFF;
;    1589 			}
;    1590 		}
;    1591 
;    1592 	}
;    1593 
;    1594 else if(prog==p4)      //замок
;    1595 	{
;    1596 	if(step==s1)
;    1597 		{
;    1598 		temp|=(1<<PP1);
;    1599           if(!bMD1)goto step_contr_end;
;    1600 
;    1601 			if(ee_vacuum_mode==evmOFF)
;    1602 				{
;    1603 				goto lbl_0004;
;    1604 				}
;    1605 			else step=s2;
;    1606           //step=s2;
;    1607 		}
;    1608 
;    1609 	else if(step==s2)
;    1610 		{
;    1611 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1612           if(!bVR)goto step_contr_end;
;    1613 lbl_0004:
;    1614           step=s3;
;    1615 		cnt_del=50;
;    1616           }
;    1617 
;    1618 	else if(step==s3)
;    1619 		{
;    1620 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1621           cnt_del--;
;    1622           if(cnt_del==0)
;    1623 			{
;    1624           	step=s4;
;    1625 			cnt_del=120U;
;    1626 			}
;    1627           }
;    1628 
;    1629    	else if(step==s4)
;    1630 		{
;    1631 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1632 		cnt_del--;
;    1633 		if(cnt_del==0)
;    1634 			{
;    1635 			step=s5;
;    1636 			cnt_del=30;
;    1637 			}
;    1638 		}
;    1639 
;    1640 	else if(step==s5)
;    1641 		{
;    1642 		temp|=(1<<PP1)|(1<<PP4);
;    1643 		cnt_del--;
;    1644 		if(cnt_del==0)
;    1645 			{
;    1646 			step=s6;
;    1647 			cnt_del=120U;
;    1648 			}
;    1649 		}
;    1650 
;    1651 	else if(step==s6)
;    1652 		{
;    1653 		temp|=(1<<PP4);
;    1654 		cnt_del--;
;    1655 		if(cnt_del==0)
;    1656 			{
;    1657 			step=sOFF;
;    1658 			}
;    1659 		}
;    1660 
;    1661 	}
;    1662 	
;    1663 step_contr_end:
;    1664 
;    1665 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1666 
;    1667 PORTB=~temp;
;    1668 //PORTB=0x55;
;    1669 }
;    1670 #endif
;    1671 
;    1672 #ifdef I220
;    1673 //-----------------------------------------------
;    1674 void step_contr(void)
;    1675 {
;    1676 char temp=0;
;    1677 DDRB=0xFF;
;    1678 
;    1679 if(step==sOFF)goto step_contr_end;
;    1680 
;    1681 else if(prog==p3)   //твист
;    1682 	{
;    1683 	if(step==s1)
;    1684 		{
;    1685 		temp|=(1<<PP1);
;    1686           if(!bMD1)goto step_contr_end;
;    1687 
;    1688 			if(ee_vacuum_mode==evmOFF)
;    1689 				{
;    1690 				goto lbl_0003;
;    1691 				}
;    1692 			else step=s2;
;    1693 
;    1694           //step=s2;
;    1695 		}
;    1696 
;    1697 	else if(step==s2)
;    1698 		{
;    1699 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1700           if(!bVR)goto step_contr_end;
;    1701 lbl_0003:
;    1702           cnt_del=50;
;    1703 		step=s3;
;    1704 		}
;    1705 
;    1706 
;    1707 	else	if(step==s3)
;    1708 		{
;    1709 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1710 		cnt_del--;
;    1711 		if(cnt_del==0)
;    1712 			{
;    1713 			cnt_del=ee_delay[prog,0]*10U;
;    1714 			step=s4;
;    1715 			}
;    1716           }
;    1717 	else if(step==s4)
;    1718 		{
;    1719 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1720 		cnt_del--;
;    1721  		if(cnt_del==0)
;    1722 			{
;    1723 			cnt_del=ee_delay[prog,1]*10U;
;    1724 			step=s5;
;    1725 			}
;    1726 		}
;    1727 
;    1728 	else if(step==s5)
;    1729 		{
;    1730 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1731 		cnt_del--;
;    1732 		if(cnt_del==0)
;    1733 			{
;    1734 			step=s6;
;    1735 			cnt_del=20;
;    1736 			}
;    1737 		}
;    1738 
;    1739 	else if(step==s6)
;    1740 		{
;    1741 		temp|=(1<<PP1);
;    1742   		cnt_del--;
;    1743 		if(cnt_del==0)
;    1744 			{
;    1745 			step=sOFF;
;    1746 			}
;    1747 		}
;    1748 
;    1749 	}
;    1750 
;    1751 else if(prog==p4)      //замок
;    1752 	{
;    1753 	if(step==s1)
;    1754 		{
;    1755 		temp|=(1<<PP1);
;    1756           if(!bMD1)goto step_contr_end;
;    1757 
;    1758 			if(ee_vacuum_mode==evmOFF)
;    1759 				{
;    1760 				goto lbl_0004;
;    1761 				}
;    1762 			else step=s2;
;    1763           //step=s2;
;    1764 		}
;    1765 
;    1766 	else if(step==s2)
;    1767 		{
;    1768 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1769           if(!bVR)goto step_contr_end;
;    1770 lbl_0004:
;    1771           step=s3;
;    1772 		cnt_del=50;
;    1773           }
;    1774 
;    1775 	else if(step==s3)
;    1776 		{
;    1777 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1778           cnt_del--;
;    1779           if(cnt_del==0)
;    1780 			{
;    1781           	step=s4;
;    1782 			cnt_del=ee_delay[prog,0]*10U;
;    1783 			}
;    1784           }
;    1785 
;    1786    	else if(step==s4)
;    1787 		{
;    1788 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1789 		cnt_del--;
;    1790 		if(cnt_del==0)
;    1791 			{
;    1792 			step=s5;
;    1793 			cnt_del=30;
;    1794 			}
;    1795 		}
;    1796 
;    1797 	else if(step==s5)
;    1798 		{
;    1799 		temp|=(1<<PP1)|(1<<PP4);
;    1800 		cnt_del--;
;    1801 		if(cnt_del==0)
;    1802 			{
;    1803 			step=s6;
;    1804 			cnt_del=ee_delay[prog,1]*10U;
;    1805 			}
;    1806 		}
;    1807 
;    1808 	else if(step==s6)
;    1809 		{
;    1810 		temp|=(1<<PP4);
;    1811 		cnt_del--;
;    1812 		if(cnt_del==0)
;    1813 			{
;    1814 			step=sOFF;
;    1815 			}
;    1816 		}
;    1817 
;    1818 	}
;    1819 	
;    1820 step_contr_end:
;    1821 
;    1822 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1823 
;    1824 PORTB=~temp;
;    1825 //PORTB=0x55;
;    1826 }
;    1827 #endif 
;    1828 
;    1829 #ifdef TVIST_SKO
;    1830 //-----------------------------------------------
;    1831 void step_contr(void)
;    1832 {
;    1833 char temp=0;
;    1834 DDRB=0xFF;
;    1835 
;    1836 if(step==sOFF)
;    1837 	{
;    1838 	temp=0;
;    1839 	}
;    1840 
;    1841 if(prog==p2) //СКО
;    1842 	{
;    1843 	if(step==s1)
;    1844 		{
;    1845 		temp|=(1<<PP1);
;    1846 
;    1847 		cnt_del--;
;    1848 		if(cnt_del==0)
;    1849 			{
;    1850 			step=s2;
;    1851 			cnt_del=30;
;    1852 			}
;    1853 		}
;    1854 
;    1855 	else if(step==s2)
;    1856 		{
;    1857 		temp|=(1<<PP1)|(1<<DV);
;    1858 
;    1859 		cnt_del--;
;    1860 		if(cnt_del==0)
;    1861 			{
;    1862 			step=s3;
;    1863 			}
;    1864 		}
;    1865 
;    1866 
;    1867 	else if(step==s3)
;    1868 		{
;    1869 		temp|=(1<<PP1)|(1<<DV)|(1<<PP2);
;    1870 
;    1871                	if(bMD1)//goto step_contr_end;
;    1872                		{  
;    1873                		cnt_del=100;
;    1874 	       		step=s4;
;    1875 	       		}
;    1876 	       	}
;    1877 
;    1878 	else if(step==s4)
;    1879 		{
;    1880 		temp|=(1<<PP1);
;    1881 		cnt_del--;
;    1882 		if(cnt_del==0)
;    1883 			{
;    1884 			step=sOFF;
;    1885 			}
;    1886 		}
;    1887 
;    1888 	}
;    1889 
;    1890 if(prog==p3)
;    1891 	{
;    1892 	if(step==s1)
;    1893 		{
;    1894 		temp|=(1<<PP1);
;    1895 
;    1896 		cnt_del--;
;    1897 		if(cnt_del==0)
;    1898 			{
;    1899 			step=s2;
;    1900 			cnt_del=100;
;    1901 			}
;    1902 		}
;    1903 
;    1904 	else if(step==s2)
;    1905 		{
;    1906 		temp|=(1<<PP1)|(1<<PP2);
;    1907 
;    1908 		cnt_del--;
;    1909 		if(cnt_del==0)
;    1910 			{
;    1911 			step=s3;
;    1912 			cnt_del=50;
;    1913 			}
;    1914 		}
;    1915 
;    1916 
;    1917 	else if(step==s3)
;    1918 		{
;    1919 		temp|=(1<<PP2);
;    1920 	
;    1921 		cnt_del--;
;    1922 		if(cnt_del==0)
;    1923 			{
;    1924 			step=sOFF;
;    1925 			}
;    1926                	}
;    1927 	}
;    1928 step_contr_end:
;    1929 
;    1930 PORTB=~temp;
;    1931 }
;    1932 #endif
;    1933 //-----------------------------------------------
;    1934 void bin2bcd_int(unsigned int in)
;    1935 {
_bin2bcd_int:
;    1936 char i;
;    1937 for(i=3;i>0;i--)
	ST   -Y,R16
;	in -> Y+1
;	i -> R16
	LDI  R16,LOW(3)
_0x5A:
	LDI  R30,LOW(0)
	CP   R30,R16
	BRSH _0x5B
;    1938 	{
;    1939 	dig[i]=in%10;
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
;    1940 	in/=10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
;    1941 	}   
	SUBI R16,1
	RJMP _0x5A
_0x5B:
;    1942 }
	LDD  R16,Y+0
	RJMP _0xC9
;    1943 
;    1944 //-----------------------------------------------
;    1945 void bcd2ind(char s)
;    1946 {
_bcd2ind:
;    1947 char i;
;    1948 bZ=1;
	ST   -Y,R16
;	s -> Y+1
;	i -> R16
	SET
	BLD  R2,3
;    1949 for (i=0;i<5;i++)
	LDI  R16,LOW(0)
_0x5D:
	CPI  R16,5
	BRLO PC+3
	JMP _0x5E
;    1950 	{
;    1951 	if(bZ&&(!dig[i-1])&&(i<4))
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
;    1952 		{
;    1953 		if((4-i)>s)
	LDI  R30,LOW(4)
	SUB  R30,R16
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
	BRSH _0x62
;    1954 			{
;    1955 			ind_out[i-1]=DIGISYM[10];
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
;    1956 			}
;    1957 		else ind_out[i-1]=DIGISYM[0];	
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
;    1958 		}
;    1959 	else
	RJMP _0x64
_0x5F:
;    1960 		{
;    1961 		ind_out[i-1]=DIGISYM[dig[i-1]];
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
;    1962 		bZ=0;
	CLT
	BLD  R2,3
;    1963 		}                   
_0x64:
;    1964 
;    1965 	if(s)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x65
;    1966 		{
;    1967 		ind_out[3-s]&=0b01111111;
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
;    1968 		}	
;    1969  
;    1970 	}
_0x65:
	SUBI R16,-1
	RJMP _0x5D
_0x5E:
;    1971 }            
	LDD  R16,Y+0
	ADIW R28,2
	RET
;    1972 //-----------------------------------------------
;    1973 void int2ind(unsigned int in,char s)
;    1974 {
_int2ind:
;    1975 bin2bcd_int(in);
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _bin2bcd_int
;    1976 bcd2ind(s);
	LD   R30,Y
	ST   -Y,R30
	CALL _bcd2ind
;    1977 
;    1978 } 
_0xC9:
	ADIW R28,3
	RET
;    1979 
;    1980 //-----------------------------------------------
;    1981 void ind_hndl(void)
;    1982 {
_ind_hndl:
;    1983 int2ind(in_word,1);
	MOV  R30,R14
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _int2ind
;    1984 //int2ind(ee_delay[prog,sub_ind],1);  
;    1985 //ind_out[0]=0xff;//DIGISYM[0];
;    1986 //ind_out[1]=0xff;//DIGISYM[1];
;    1987 //ind_out[2]=DIGISYM[2];//0xff;
;    1988 //ind_out[0]=DIGISYM[7]; 
;    1989 
;    1990 ind_out[0]=DIGISYM[sub_ind+1];
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
;    1991 }
	RET
;    1992 
;    1993 //-----------------------------------------------
;    1994 void led_hndl(void)
;    1995 {
_led_hndl:
;    1996 ind_out[4]=DIGISYM[10]; 
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	__PUTB1MN _ind_out,4
;    1997 
;    1998 ind_out[4]&=~(1<<LED_POW_ON); 
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xDF
	POP  R26
	POP  R27
	ST   X,R30
;    1999 
;    2000 if(step!=sOFF)
	TST  R11
	BREQ _0x66
;    2001 	{
;    2002 	ind_out[4]&=~(1<<LED_WRK);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xBF
	POP  R26
	POP  R27
	RJMP _0xCB
;    2003 	}
;    2004 else ind_out[4]|=(1<<LED_WRK);
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
;    2005 
;    2006 
;    2007 if(step==sOFF)
	TST  R11
	BRNE _0x68
;    2008 	{
;    2009  	if(bERR)
	SBRS R3,1
	RJMP _0x69
;    2010 		{
;    2011 		ind_out[4]&=~(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFE
	POP  R26
	POP  R27
	RJMP _0xCC
;    2012 		}
;    2013 	else
_0x69:
;    2014 		{
;    2015 		ind_out[4]|=(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
_0xCC:
	ST   X,R30
;    2016 		}
;    2017      }
;    2018 else ind_out[4]|=(1<<LED_ERROR);
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
;    2019 
;    2020 /* 	if(bMD1)
;    2021 		{
;    2022 		ind_out[4]&=~(1<<LED_ERROR);
;    2023 		}
;    2024 	else
;    2025 		{
;    2026 		ind_out[4]|=(1<<LED_ERROR);
;    2027 		} */
;    2028 
;    2029 //if(bERR)ind_out[4]&=~(1<<LED_ERROR);
;    2030 if(ee_vacuum_mode==evmON)ind_out[4]&=~(1<<LED_VACUUM);
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
;    2031 else ind_out[4]|=(1<<LED_VACUUM);
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
;    2032 
;    2033 if(prog==p1) ind_out[4]&=~(1<<LED_PROG1);
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
;    2034 else if(prog==p2) ind_out[4]&=~(1<<LED_PROG2);
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
;    2035 else if(prog==p3) ind_out[4]&=~(1<<LED_PROG3);
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
;    2036 else if(prog==p4) ind_out[4]&=~(1<<LED_PROG4);
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
;    2037 
;    2038 if(ind==iPr_sel)
_0x74:
_0x73:
_0x71:
_0x6F:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x75
;    2039 	{
;    2040 	if(bFL5)ind_out[4]|=(1<<LED_PROG1)|(1<<LED_PROG2)|(1<<LED_PROG3)|(1<<LED_PROG4);
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
;    2041 	} 
_0x76:
;    2042 	 
;    2043 if(ind==iVr)
_0x75:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x77
;    2044 	{
;    2045 	if(bFL5)ind_out[4]|=(1<<LED_POW_ON);
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
;    2046 	}	
_0x78:
;    2047 }
_0x77:
	RET
;    2048 
;    2049 //-----------------------------------------------
;    2050 // Подпрограмма драйва до 7 кнопок одного порта, 
;    2051 // различает короткое и длинное нажатие,
;    2052 // срабатывает на отпускание кнопки, возможность
;    2053 // ускорения перебора при длинном нажатии...
;    2054 #define but_port PORTC
;    2055 #define but_dir  DDRC
;    2056 #define but_pin  PINC
;    2057 #define but_mask 0b01101010
;    2058 #define no_but   0b11111111
;    2059 #define but_on   5
;    2060 #define but_onL  20
;    2061 
;    2062 
;    2063 
;    2064 
;    2065 void but_drv(void)
;    2066 { 
_but_drv:
;    2067 DDRD&=0b00000111;
	IN   R30,0x11
	ANDI R30,LOW(0x7)
	CALL SUBOPT_0x5
;    2068 PORTD|=0b11111000;
;    2069 
;    2070 but_port|=(but_mask^0xff);
	CALL SUBOPT_0x6
;    2071 but_dir&=but_mask;
;    2072 #asm
;    2073 nop
nop
;    2074 nop
nop
;    2075 nop
nop
;    2076 nop
nop
;    2077 #endasm

;    2078 
;    2079 but_n=but_pin|but_mask; 
	IN   R30,0x13
	ORI  R30,LOW(0x6A)
	STS  _but_n_G1,R30
;    2080 
;    2081 if((but_n==no_but)||(but_n!=but_s))
	LDS  R26,_but_n_G1
	CPI  R26,LOW(0xFF)
	BREQ _0x7A
	RCALL SUBOPT_0x7
	BREQ _0x79
_0x7A:
;    2082  	{
;    2083  	speed=0;
	CLT
	BLD  R2,6
;    2084    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
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
;    2085   		{
;    2086    	     n_but=1;
	SET
	BLD  R2,5
;    2087           but=but_s;
	LDS  R9,_but_s_G1
;    2088           }
;    2089    	if (but1_cnt>=but_onL_temp)
_0x7C:
	RCALL SUBOPT_0x8
	BRLO _0x81
;    2090   		{
;    2091    	     n_but=1;
	SET
	BLD  R2,5
;    2092           but=but_s&0b11111101;
	RCALL SUBOPT_0x9
;    2093           }
;    2094     	l_but=0;
_0x81:
	CLT
	BLD  R2,4
;    2095    	but_onL_temp=but_onL;
	LDI  R30,LOW(20)
	STS  _but_onL_temp_G1,R30
;    2096     	but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    2097   	but1_cnt=0;          
	STS  _but1_cnt_G1,R30
;    2098      goto but_drv_out;
	RJMP _0x82
;    2099   	}  
;    2100   	
;    2101 if(but_n==but_s)
_0x79:
	RCALL SUBOPT_0x7
	BRNE _0x83
;    2102  	{
;    2103   	but0_cnt++;
	LDS  R30,_but0_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but0_cnt_G1,R30
;    2104   	if(but0_cnt>=but_on)
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRLO _0x84
;    2105   		{
;    2106    		but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    2107    		but1_cnt++;
	LDS  R30,_but1_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but1_cnt_G1,R30
;    2108    		if(but1_cnt>=but_onL_temp)
	RCALL SUBOPT_0x8
	BRLO _0x85
;    2109    			{              
;    2110     			but=but_s&0b11111101;
	RCALL SUBOPT_0x9
;    2111     			but1_cnt=0;
	LDI  R30,LOW(0)
	STS  _but1_cnt_G1,R30
;    2112     			n_but=1;
	SET
	BLD  R2,5
;    2113     			l_but=1;
	SET
	BLD  R2,4
;    2114 			if(speed)
	SBRS R2,6
	RJMP _0x86
;    2115 				{
;    2116     				but_onL_temp=but_onL_temp>>1;
	LDS  R30,_but_onL_temp_G1
	LSR  R30
	STS  _but_onL_temp_G1,R30
;    2117         			if(but_onL_temp<=2) but_onL_temp=2;
	LDS  R26,_but_onL_temp_G1
	LDI  R30,LOW(2)
	CP   R30,R26
	BRLO _0x87
	STS  _but_onL_temp_G1,R30
;    2118 				}    
_0x87:
;    2119    			}
_0x86:
;    2120   		} 
_0x85:
;    2121  	}
_0x84:
;    2122 but_drv_out:
_0x83:
_0x82:
;    2123 but_s=but_n;
	LDS  R30,_but_n_G1
	STS  _but_s_G1,R30
;    2124 but_port|=(but_mask^0xff);
	RCALL SUBOPT_0x6
;    2125 but_dir&=but_mask;
;    2126 }    
	RET
;    2127 
;    2128 #define butV	239
;    2129 #define butV_	237
;    2130 #define butP	251
;    2131 #define butP_	249
;    2132 #define butR	127
;    2133 #define butR_	125
;    2134 #define butL	254
;    2135 #define butL_	252
;    2136 #define butLR	126
;    2137 #define butLR_	124 
;    2138 #define butVP_ 233
;    2139 //-----------------------------------------------
;    2140 void but_an(void)
;    2141 {
_but_an:
;    2142 
;    2143 if(!(in_word&0x01))
	SBRC R14,0
	RJMP _0x88
;    2144 	{
;    2145 	#ifdef TVIST_SKO
;    2146 	if((step==sOFF)&&(!bERR))
;    2147 		{
;    2148 		step=s1;
;    2149 		if(prog==p2) cnt_del=70;
;    2150 		else if(prog==p3) cnt_del=100;
;    2151 		}
;    2152 	#endif
;    2153 	#ifdef DV3KL2MD
;    2154 	if((step==sOFF)&&(!bERR))
	LDI  R30,LOW(0)
	CP   R30,R11
	BRNE _0x8A
	SBRS R3,1
	RJMP _0x8B
_0x8A:
	RJMP _0x89
_0x8B:
;    2155 		{
;    2156 		step=s1;
	LDI  R30,LOW(1)
	MOV  R11,R30
;    2157 		cnt_del=70;
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2158 		}
;    2159 	#endif	
;    2160 	#ifndef TVIST_SKO
;    2161 	if((step==sOFF)&&(!bERR))
_0x89:
	LDI  R30,LOW(0)
	CP   R30,R11
	BRNE _0x8D
	SBRS R3,1
	RJMP _0x8E
_0x8D:
	RJMP _0x8C
_0x8E:
;    2162 		{
;    2163 		step=s1;
	LDI  R30,LOW(1)
	MOV  R11,R30
;    2164 		if(prog==p1) cnt_del=50;
	CP   R30,R10
	BRNE _0x8F
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2165 		else if(prog==p2) cnt_del=50;
	RJMP _0x90
_0x8F:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x91
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2166 		else if(prog==p3) cnt_del=50;
	RJMP _0x92
_0x91:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x93
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2167           #ifdef P380_MINI
;    2168   		cnt_del=100;
;    2169   		#endif
;    2170 		}
_0x93:
_0x92:
_0x90:
;    2171 	#endif
;    2172 	}
_0x8C:
;    2173 if(!(in_word&0x02))
_0x88:
	SBRC R14,1
	RJMP _0x94
;    2174 	{
;    2175 	step=sOFF;
	CLR  R11
;    2176 
;    2177 	}
;    2178 
;    2179 if (!n_but) goto but_an_end;
_0x94:
	SBRS R2,5
	RJMP _0x96
;    2180 
;    2181 if(but==butV_)
	LDI  R30,LOW(237)
	CP   R30,R9
	BRNE _0x97
;    2182 	{
;    2183 	if(ee_vacuum_mode==evmON)ee_vacuum_mode=evmOFF;
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0x98
	LDI  R30,LOW(170)
	RJMP _0xCE
;    2184 	else ee_vacuum_mode=evmON;
_0x98:
	LDI  R30,LOW(85)
_0xCE:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMWRB
;    2185 	}
;    2186 
;    2187 if(but==butVP_)
_0x97:
	LDI  R30,LOW(233)
	CP   R30,R9
	BRNE _0x9A
;    2188 	{
;    2189 	if(ind!=iVr)ind=iVr;
	LDI  R30,LOW(2)
	CP   R30,R12
	BREQ _0x9B
	MOV  R12,R30
;    2190 	else ind=iMn;
	RJMP _0x9C
_0x9B:
	CLR  R12
_0x9C:
;    2191 	}
;    2192 
;    2193 	
;    2194 if(ind==iMn)
_0x9A:
	TST  R12
	BRNE _0x9D
;    2195 	{
;    2196 	if(but==butP_)ind=iPr_sel;
	LDI  R30,LOW(249)
	CP   R30,R9
	BRNE _0x9E
	LDI  R30,LOW(1)
	MOV  R12,R30
;    2197 	if(but==butLR)	
_0x9E:
	LDI  R30,LOW(126)
	CP   R30,R9
	BRNE _0x9F
;    2198 		{
;    2199 		if((prog==p3)||(prog==p4))
	LDI  R30,LOW(3)
	CP   R30,R10
	BREQ _0xA1
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0xA0
_0xA1:
;    2200 			{ 
;    2201 			if(sub_ind==0)sub_ind=1;
	TST  R13
	BRNE _0xA3
	LDI  R30,LOW(1)
	MOV  R13,R30
;    2202 			else sub_ind=0;
	RJMP _0xA4
_0xA3:
	CLR  R13
_0xA4:
;    2203 			}
;    2204     		else sub_ind=0;
	RJMP _0xA5
_0xA0:
	CLR  R13
_0xA5:
;    2205 		}	 
;    2206 	if((but==butR)||(but==butR_))	
_0x9F:
	LDI  R30,LOW(127)
	CP   R30,R9
	BREQ _0xA7
	LDI  R30,LOW(125)
	CP   R30,R9
	BRNE _0xA6
_0xA7:
;    2207 		{  
;    2208 		speed=1;
	SET
	BLD  R2,6
;    2209 		ee_delay[prog,sub_ind]++;
	RCALL SUBOPT_0xA
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    2210 		}   
;    2211 	
;    2212 	else if((but==butL)||(but==butL_))	
	RJMP _0xA9
_0xA6:
	LDI  R30,LOW(254)
	CP   R30,R9
	BREQ _0xAB
	LDI  R30,LOW(252)
	CP   R30,R9
	BRNE _0xAA
_0xAB:
;    2213 		{  
;    2214     		speed=1;
	SET
	BLD  R2,6
;    2215     		ee_delay[prog,sub_ind]--;
	RCALL SUBOPT_0xA
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    2216     		}		
;    2217 	} 
_0xAA:
_0xA9:
;    2218 	
;    2219 else if(ind==iPr_sel)
	RJMP _0xAD
_0x9D:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0xAE
;    2220 	{
;    2221 	if(but==butP_)ind=iMn;
	LDI  R30,LOW(249)
	CP   R30,R9
	BRNE _0xAF
	CLR  R12
;    2222 	if(but==butP)
_0xAF:
	LDI  R30,LOW(251)
	CP   R30,R9
	BRNE _0xB0
;    2223 		{
;    2224 		prog++;
	RCALL SUBOPT_0xB
;    2225 		if(prog>MAXPROG)prog=MINPROG;
	BRGE _0xB1
	LDI  R30,LOW(2)
	MOV  R10,R30
;    2226 		ee_program[0]=prog;
_0xB1:
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
;    2231 	if(but==butR)
_0xB0:
	LDI  R30,LOW(127)
	CP   R30,R9
	BRNE _0xB2
;    2232 		{
;    2233 		prog++;
	RCALL SUBOPT_0xB
;    2234 		if(prog>MAXPROG)prog=MINPROG;
	BRGE _0xB3
	LDI  R30,LOW(2)
	MOV  R10,R30
;    2235 		ee_program[0]=prog;
_0xB3:
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
;    2239 
;    2240 	if(but==butL)
_0xB2:
	LDI  R30,LOW(254)
	CP   R30,R9
	BRNE _0xB4
;    2241 		{
;    2242 		prog--;
	DEC  R10
;    2243 		if(prog>MAXPROG)prog=MINPROG;
	LDI  R30,LOW(3)
	CP   R30,R10
	BRGE _0xB5
	LDI  R30,LOW(2)
	MOV  R10,R30
;    2244 		ee_program[0]=prog;
_0xB5:
	RCALL SUBOPT_0xC
;    2245 		ee_program[1]=prog;
	__POINTW2MN _ee_program,1
	MOV  R30,R10
	CALL __EEPROMWRB
;    2246 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R10
	CALL __EEPROMWRB
;    2247 		}	
;    2248 	} 
_0xB4:
;    2249 
;    2250 else if(ind==iVr)
	RJMP _0xB6
_0xAE:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0xB7
;    2251 	{
;    2252 	if(but==butP_)
	LDI  R30,LOW(249)
	CP   R30,R9
	BRNE _0xB8
;    2253 		{
;    2254 		if(ee_vr_log)ee_vr_log=0;
	LDI  R26,LOW(_ee_vr_log)
	LDI  R27,HIGH(_ee_vr_log)
	CALL __EEPROMRDB
	CPI  R30,0
	BREQ _0xB9
	LDI  R30,LOW(0)
	RJMP _0xCF
;    2255 		else ee_vr_log=1;
_0xB9:
	LDI  R30,LOW(1)
_0xCF:
	LDI  R26,LOW(_ee_vr_log)
	LDI  R27,HIGH(_ee_vr_log)
	CALL __EEPROMWRB
;    2256 		}	
;    2257 	} 	
_0xB8:
;    2258 
;    2259 but_an_end:
_0xB7:
_0xB6:
_0xAD:
_0x96:
;    2260 n_but=0;
	CLT
	BLD  R2,5
;    2261 }
	RET
;    2262 
;    2263 //-----------------------------------------------
;    2264 void ind_drv(void)
;    2265 {
_ind_drv:
;    2266 if(++ind_cnt>=6)ind_cnt=0;
	INC  R8
	LDI  R30,LOW(6)
	CP   R8,R30
	BRLO _0xBB
	CLR  R8
;    2267 
;    2268 if(ind_cnt<5)
_0xBB:
	LDI  R30,LOW(5)
	CP   R8,R30
	BRSH _0xBC
;    2269 	{
;    2270 	DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
;    2271 	PORTC=0xFF;
	OUT  0x15,R30
;    2272 	DDRD|=0b11111000;
	IN   R30,0x11
	ORI  R30,LOW(0xF8)
	RCALL SUBOPT_0x5
;    2273 	PORTD|=0b11111000;
;    2274 	PORTD&=IND_STROB[ind_cnt];
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
;    2275 	PORTC=ind_out[ind_cnt];
	MOV  R30,R8
	LDI  R31,0
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	LD   R30,Z
	OUT  0x15,R30
;    2276 	}
;    2277 else but_drv();
	RJMP _0xBD
_0xBC:
	CALL _but_drv
_0xBD:
;    2278 }
	RET
;    2279 
;    2280 //***********************************************
;    2281 //***********************************************
;    2282 //***********************************************
;    2283 //***********************************************
;    2284 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;    2285 {
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
;    2286 TCCR0=0x02;
	RCALL SUBOPT_0xD
;    2287 TCNT0=-208;
;    2288 OCR0=0x00; 
;    2289 
;    2290 
;    2291 b600Hz=1;
	SET
	BLD  R2,0
;    2292 ind_drv();
	RCALL _ind_drv
;    2293 if(++t0_cnt0>=6)
	INC  R4
	LDI  R30,LOW(6)
	CP   R4,R30
	BRLO _0xBE
;    2294 	{
;    2295 	t0_cnt0=0;
	CLR  R4
;    2296 	b100Hz=1;
	SET
	BLD  R2,1
;    2297 	}
;    2298 
;    2299 if(++t0_cnt1>=60)
_0xBE:
	INC  R5
	LDI  R30,LOW(60)
	CP   R5,R30
	BRLO _0xBF
;    2300 	{
;    2301 	t0_cnt1=0;
	CLR  R5
;    2302 	b10Hz=1;
	SET
	BLD  R2,2
;    2303 	
;    2304 	if(++t0_cnt2>=2)
	INC  R6
	LDI  R30,LOW(2)
	CP   R6,R30
	BRLO _0xC0
;    2305 		{
;    2306 		t0_cnt2=0;
	CLR  R6
;    2307 		bFL5=!bFL5;
	LDI  R30,LOW(1)
	EOR  R3,R30
;    2308 		}
;    2309 		
;    2310 	if(++t0_cnt3>=5)
_0xC0:
	INC  R7
	LDI  R30,LOW(5)
	CP   R7,R30
	BRLO _0xC1
;    2311 		{
;    2312 		t0_cnt3=0;
	CLR  R7
;    2313 		bFL2=!bFL2;
	LDI  R30,LOW(128)
	EOR  R2,R30
;    2314 		}		
;    2315 	}
_0xC1:
;    2316 }
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
;    2317 
;    2318 //===============================================
;    2319 //===============================================
;    2320 //===============================================
;    2321 //===============================================
;    2322 
;    2323 void main(void)
;    2324 {
_main:
;    2325 
;    2326 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
;    2327 DDRA=0x00;
	RCALL SUBOPT_0x0
;    2328 
;    2329 PORTB=0xff;
	RCALL SUBOPT_0xE
;    2330 DDRB=0xFF;
;    2331 
;    2332 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;    2333 DDRC=0x00;
	OUT  0x14,R30
;    2334 
;    2335 
;    2336 PORTD=0x00;
	OUT  0x12,R30
;    2337 DDRD=0x00;
	OUT  0x11,R30
;    2338 
;    2339 
;    2340 TCCR0=0x02;
	RCALL SUBOPT_0xD
;    2341 TCNT0=-208;
;    2342 OCR0=0x00;
;    2343 
;    2344 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;    2345 TCCR1B=0x00;
	OUT  0x2E,R30
;    2346 TCNT1H=0x00;
	OUT  0x2D,R30
;    2347 TCNT1L=0x00;
	OUT  0x2C,R30
;    2348 ICR1H=0x00;
	OUT  0x27,R30
;    2349 ICR1L=0x00;
	OUT  0x26,R30
;    2350 OCR1AH=0x00;
	OUT  0x2B,R30
;    2351 OCR1AL=0x00;
	OUT  0x2A,R30
;    2352 OCR1BH=0x00;
	OUT  0x29,R30
;    2353 OCR1BL=0x00;
	OUT  0x28,R30
;    2354 
;    2355 
;    2356 ASSR=0x00;
	OUT  0x22,R30
;    2357 TCCR2=0x00;
	OUT  0x25,R30
;    2358 TCNT2=0x00;
	OUT  0x24,R30
;    2359 OCR2=0x00;
	OUT  0x23,R30
;    2360 
;    2361 MCUCR=0x00;
	OUT  0x35,R30
;    2362 MCUCSR=0x00;
	OUT  0x34,R30
;    2363 
;    2364 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;    2365 
;    2366 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;    2367 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;    2368 
;    2369 #asm("sei") 
	sei
;    2370 PORTB=0xFF;
	LDI  R30,LOW(255)
	RCALL SUBOPT_0xE
;    2371 DDRB=0xFF;
;    2372 ind=iMn;
	CLR  R12
;    2373 prog_drv();
	CALL _prog_drv
;    2374 ind_hndl();
	CALL _ind_hndl
;    2375 led_hndl();
	CALL _led_hndl
;    2376 while (1)
_0xC2:
;    2377       {
;    2378       if(b600Hz)
	SBRS R2,0
	RJMP _0xC5
;    2379 		{
;    2380 		b600Hz=0; 
	CLT
	BLD  R2,0
;    2381           
;    2382 		}         
;    2383       if(b100Hz)
_0xC5:
	SBRS R2,1
	RJMP _0xC6
;    2384 		{        
;    2385 		b100Hz=0; 
	CLT
	BLD  R2,1
;    2386 		but_an();
	RCALL _but_an
;    2387 	    	in_drv();
	CALL _in_drv
;    2388           mdvr_drv();
	CALL _mdvr_drv
;    2389           step_contr();
	CALL _step_contr
;    2390 		}   
;    2391 	if(b10Hz)
_0xC6:
	SBRS R2,2
	RJMP _0xC7
;    2392 		{
;    2393 		b10Hz=0;
	CLT
	BLD  R2,2
;    2394 		prog_drv();
	CALL _prog_drv
;    2395 		err_drv();
	CALL _err_drv
;    2396 		
;    2397     	     ind_hndl();
	CALL _ind_hndl
;    2398           led_hndl();
	CALL _led_hndl
;    2399           
;    2400           }
;    2401 
;    2402       };
_0xC7:
	RJMP _0xC2
;    2403 }
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
	MOV  R9,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
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

