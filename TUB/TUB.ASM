;CodeVisionAVR C Compiler V1.24.1d Standard
;(C) Copyright 1998-2004 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.ro
;e-mail:office@hpinfotech.ro

;Chip type           : ATmega32
;Program type        : Application
;Clock frequency     : 8,000000 MHz
;Memory model        : Small
;Optimize for        : Size
;(s)printf features  : int, width
;(s)scanf features   : long, width
;External SRAM size  : 0
;Data Stack size     : 512 byte(s)
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

	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_adc_noise_red=0x10
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70

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

	.INCLUDE "tub.vec"
	.INCLUDE "tub.inc"

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
	LDI  R24,LOW(0x800)
	LDI  R25,HIGH(0x800)
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
	LDI  R30,LOW(0x85F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x85F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x260)
	LDI  R29,HIGH(0x260)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260
;       1 #define LCD_SIZE 40
;       2 
;       3 #include <mega32.h>
;       4 #include <delay.h>
;       5 #include <stdio.h> 
;       6 #include <Lcd_4+2.h>
;       7 #include <spi.h>
;       8 #include <math.h>    
;       9 #include "gran.c"
;      10 //-----------------------------------------------
;      11 void gran_ring_char(signed char *adr, signed char min, signed char max)
;      12 {

	.CSEG
;      13 if (*adr<min) *adr=max;
;      14 if (*adr>max) *adr=min; 
;      15 } 
;      16  
;      17 //-----------------------------------------------
;      18 void gran_char(signed char *adr, signed char min, signed char max)
;      19 {
;      20 if (*adr<min) *adr=min;
;      21 if (*adr>max) *adr=max; 
;      22 } 
;      23 
;      24 //-----------------------------------------------
;      25 void gran_char_ee(eeprom signed char  *adr, signed char min, signed char max)
;      26 {
;      27 if (*adr<min) *adr=min;
;      28 if (*adr>max) *adr=max; 
;      29 }
;      30 
;      31 //-----------------------------------------------
;      32 void gran_ring(signed int *adr, signed int min, signed int max)
;      33 {
;      34 if (*adr<min) *adr=max;
;      35 if (*adr>max) *adr=min; 
;      36 } 
;      37 
;      38 //-----------------------------------------------
;      39 void gran_ring_ee(eeprom signed int *adr, signed int min, signed int max)
;      40 {
;      41 if (*adr<min) *adr=max;
;      42 if (*adr>max) *adr=min; 
;      43 } 
;      44 //-----------------------------------------------
;      45 void gran(signed int *adr, signed int min, signed int max)
;      46 {
;      47 if (*adr<min) *adr=min;
;      48 if (*adr>max) *adr=max; 
;      49 } 
;      50 
;      51 
;      52 //-----------------------------------------------
;      53 void gran_ee(eeprom signed int  *adr, signed int min, signed int max)
;      54 {
_gran_ee:
;      55 if (*adr<min) *adr=min;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __EEPROMRDW
	MOVW R26,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R26,R30
	CPC  R27,R31
	BRGE _0xF
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __EEPROMWRW
;      56 if (*adr>max) *adr=max; 
_0xF:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __EEPROMRDW
	MOVW R26,R30
	LD   R30,Y
	LDD  R31,Y+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x10
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __EEPROMWRW
;      57 }
_0x10:
	ADIW R28,6
	RET
;      58 #include "ruslcd.c"
;      59 #ifndef  _rus_lcd_INCLUDED_
;      60 #define _rus_lcd_INCLUDED_ 
;      61 /*  ТАБЛИЦА СООТВЕТСТВИЯ
;      62 Число	Символ	Число	Символ	Число	Символ	Число	Символ	ЧислоСимвол
;      63 33	!	34	"	35	#	36	$	37	%
;      64 38	&	39	'	40	(	41	)	42	*
;      65 43	+	44	,	45	-	46	.	47	/
;      66 48	0	49	1	50	2	51	3	52	4
;      67 53	5	54	6	55	7	56	8	57	9
;      68 58	:	59	;	60	<	61	=	62	>
;      69 63	?	64	@	65	A	66	B	67	C
;      70 68	D	69	E	70	F	71	G	72	H
;      71 73	I	74	J	75	K	76	L	77	M
;      72 78	N	79	O	80	P	81	Q	82	R
;      73 83	S	84	T	85	U	86	V	87	W
;      74 88	X	89	Y	90	Z	91	[	92	\
;      75 93	]	94	^	95	_	96	`	97	a
;      76 98	b	99	c	100	d	101	e	102	f
;      77 103	g	104	h	105	I	106	j	107	k
;      78 108	l	109	m	110	n	111	o	112	p
;      79 113	q	114	r	115	s	116	t	117	u
;      80 118	v	119	w	120	x	121	y	122	z
;      81 123	{	124	|	125	}	126	~	132	"
;      82 133	…	145	'	146	'	147	"	148	"
;      83 149	o	150	-	151	-	153	™	166	¦
;      84 167	§	168	Ё	169	©	171	"	172	   
;      85 174	®	176	°	177	±	178	І	179	і
;      86 182		183	·	184	ё	185	№	187	"
;      87 192	А	193	Б	194	В	195	Г	196	Д
;      88 197	Е	198	Ж	199	З	200	И	201	Й
;      89 202	К	203	Л	204	М	205	Н	206	О
;      90 207	П	208	Р	209	С	210	Т	211	У
;      91 212	Ф	213	Х	214	Ц	215	Ч	216	Ш
;      92 217	Щ	218	Ъ	219	Ы	220	Ь	221	Э
;      93 222	Ю	223	Я	224	а	225	б	226	в
;      94 227	г	228	д	229	е	230	ж	231	з
;      95 232	и	233	й	234	к	235	л	236	м
;      96 237	н	238	о	239	п	240	р	241	с
;      97 242	т	243	у	244	ф	245	х	246	ц
;      98 247	ч	248	ш	249	щ	250	ъ	251	ы
;      99 252	ь	253	э	254	ю	255	я	-	-
;     100 */
;     101 const unsigned char rus_buff[]={                             // код буквы 
;     102 0xFD,0xa2,255 ,                                     //167-169
;     103 170 ,0xc8,172 ,173 ,174 ,175 ,176 ,177 ,0xd7,0x69,  //170-179
;     104 180 ,181 ,0xfe,0xdf,0xb5,0xcc,186 ,0xc9,188 ,189 ,  //180-189
;     105 190 ,191 ,0x41,0xa0,0x42,0xa1,0xe0,0x45,0xa3,0xa4,  //190-199
;     106 0xa5,0xa6,0x4b,0xa7,0x4d,0x48,0x4f,0xa8,0x50,0x43,  //200-209
;     107 0x54,0xa9,0xaa,0x58,0xe1,0xab,0xac,0xe2,0xad,0xae,  //210-219
;     108 0xc4,0xaf,0xb0,0xb1,0x61,0xb2,0xb3,0xb4,0xe3,0x65,  //220-229
;     109 0xb6,0xb7,0xb8,0xb9,0xba,0xbb,0xbc,0xbd,0x6f,0xbe,  //230-239
;     110 0x70,0x63,0xbf,0x79,0xaa,0x78,0xe5,0xc0,0xc1,0xe6,  //240-249
;     111 0xc2,0xc3,0xc4,0xc5,0xc6,0xc7};                     //250-255
;     112 //преобразование массива начинается с 167 символа
;     113 //десятичные цифры в буфере-это те символы, которые невозможно отображать на ЖКИ. 
;     114 //Их можно назначить по своему усмотрению.
;     115 //Например, сейчас (см выше) набрав на клавиатуре @ (код 169) на ЖКИ будет отображаться 
;     116 //чёрное знакоместо (код 0хFF (255десятичн.) )
;     117 /*
;     118 @- 0хFF
;     119 
;     120 */
;     121 void ruslcd (unsigned char *buff){
_ruslcd:
;     122 unsigned char i;
;     123 i=0;
	SBIW R28,1
;	*buff -> Y+1
;	i -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
;     124 while ( buff[i]!=0 ) {
_0x11:
	CALL SUBOPT_0x0
	LD   R30,X
	CPI  R30,0
	BREQ _0x13
;     125 	if(buff[i]>166) buff[i]=rus_buff[buff[i]-167];
	CALL SUBOPT_0x0
	LD   R26,X
	LDI  R30,LOW(166)
	CP   R30,R26
	BRSH _0x14
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_rus_buff*2)
	LDI  R31,HIGH(_rus_buff*2)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x0
	LD   R30,X
	SUBI R30,LOW(167)
	POP  R26
	POP  R27
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	POP  R26
	POP  R27
	ST   X,R30
;     126 	i=i+1;}
_0x14:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x11
_0x13:
;     127 	
;     128 /*	buff[0]=0x61;
;     129 	buff[1]=rus_buff[buff[1]-167];//0xb2;//rus_buff[buff[1]-167];
;     130 	buff[2]=0xb3;
;     131 	buff[3]=0xb4;*/
;     132 
;     133 }//end void  
	ADIW R28,3
	RET
;     134 #endif
;     135 #asm
;     136 	.equ __lcd_port=0x15
	.equ __lcd_port=0x15
;     137 	.equ __lcd_cntr_port=0x12
	.equ __lcd_cntr_port=0x12
;     138  	.equ __lcd_rs=6
 	.equ __lcd_rs=6
;     139   	.equ __lcd_en=7
  	.equ __lcd_en=7
;     140 #endasm 

;     141 
;     142 
;     143 //***********************************************
;     144 //Указатели
;     145 char 		*ptr_ram;

	.DSEG
_ptr_ram:
	.BYTE 0x2
;     146 int 			*ptr_ram_int;
_ptr_ram_int:
	.BYTE 0x2
;     147 char flash 	*ptr_flash;
_ptr_flash:
	.BYTE 0x2
;     148 int eeprom	*ptr_eeprom_int;
_ptr_eeprom_int:
	.BYTE 0x2
;     149 unsigned int 	*adc_out;
_adc_out:
	.BYTE 0x2
;     150 
;     151 bit b100Hz,b10Hz,b5Hz,b2Hz,b1Hz;
;     152 bit l_but;		//идет длинное нажатие на кнопку
;     153 bit n_but;          //произошло нажатие
;     154 bit speed;		//разрешение ускорения перебора
;     155 bit zero_on;
;     156 bit bit_minus;
;     157 bit bAB;
;     158 bit bAN;
;     159 bit bAS1;
;     160 bit bAS2;
;     161 bit bFL_;
;     162 bit bFL__;
;     163 bit bI;
;     164 
;     165 enum char {iMn,iSrv_sl,iNet,iSet,iBat,iSrc,iS2,iSetprl,iKprl,iDnd,iK,
;     166 	iSpcprl,iSpc,Grdy,Prdy,Iwrk,Gwrk,Pwrk,k,Crash_0,Crash_1,iKednd,
;     167 	iLoad,iSpc_prl_vz,iSpc_prl_ke,iKe,iVz,iAVAR,iStr,iVrs,iTstprl,iTst,iDebug,iDefault,iSet_st_prl}ind;
;     168 
;     169 
;     170 flash char char0[8]=

	.CSEG
;     171 {
;     172 0b0001000,
;     173 0b0001100,
;     174 0b0001110,
;     175 0b0001111,
;     176 0b0001110,
;     177 0b0001100,
;     178 0b0001000,
;     179 0b0000000};
;     180 
;     181 flash char char1[8]=
;     182 {
;     183 0b0000110,
;     184 0b0001001,
;     185 0b0001001,
;     186 0b0000110,
;     187 0b0000000,
;     188 0b0000000,
;     189 0b0000000,
;     190 0b0000000};
;     191 
;     192 
;     193 flash char char2[8]=
;     194 {
;     195 0b0010000,
;     196 0b0010000,
;     197 0b0010000,
;     198 0b0011110,
;     199 0b0010001,
;     200 0b0010001,
;     201 0b0011110,
;     202 0b0000000};
;     203 
;     204 flash char char3[8]=
;     205 {
;     206 0b0000100,
;     207 0b0001110,
;     208 0b0011111,
;     209 0b0000000,
;     210 0b0000000,
;     211 0b0000000,
;     212 0b0000000,
;     213 0b0000000};
;     214 
;     215 flash char char4[8]=
;     216 {
;     217 0b00000,
;     218 0b00000,
;     219 0b01111,
;     220 0b01000,
;     221 0b01000,
;     222 0b01000,
;     223 0b01111,
;     224 0b00000};
;     225 
;     226 flash char char5[8]=
;     227 {
;     228 0b10000,
;     229 0b11000,
;     230 0b11111,
;     231 0b11001,
;     232 0b10001,
;     233 0b00001,
;     234 0b11111,
;     235 0b00000};
;     236 
;     237 
;     238 char but;
;     239 unsigned char parol[3];

	.DSEG
_parol:
	.BYTE 0x3
;     240 char dig[5];
_dig:
	.BYTE 0x5
;     241 
;     242 char adc_cnt,adc_cnt1;
;     243 unsigned int adc_bank[10,4],adc_bank_[10];
_adc_bank:
	.BYTE 0x50
_adc_bank_:
	.BYTE 0x14
;     244 enum {tstOFF,tstON,tstU} tst_state[10];
_tst_state:
	.BYTE 0xA
;     245 
;     246 
;     247 
;     248 signed char sub_ind,sub_ind1,index_set;
;     249 
;     250 char cnt_ibat,cnt_ubat;
;     251 unsigned Fnet;
_Fnet:
	.BYTE 0x2
;     252 bit bFF,bFF_;
;     253 int Hz_out,Hz_cnt;
_Hz_out:
	.BYTE 0x2
_Hz_cnt:
	.BYTE 0x2
;     254 char t0cnt0_;
_t0cnt0_:
	.BYTE 0x1
;     255 unsigned long cnt_vz_sec,cnt_vz_sec_; 
_cnt_vz_sec:
	.BYTE 0x4
_cnt_vz_sec_:
	.BYTE 0x4
;     256 signed zar_cnt;
_zar_cnt:
	.BYTE 0x2
;     257 char cnt_ind;
_cnt_ind:
	.BYTE 0x1
;     258 
;     259 char sound_pic,sound_tic,sound_cnt;
_sound_pic:
	.BYTE 0x1
_sound_tic:
	.BYTE 0x1
_sound_cnt:
	.BYTE 0x1
;     260 unsigned int av_beep,av_rele,av_stat;
_av_beep:
	.BYTE 0x2
_av_rele:
	.BYTE 0x2
_av_stat:
	.BYTE 0x2
;     261 //0 - сеть
;     262 //1 - батарея
;     263 //2 - ист1 больше
;     264 //3 - ист1 меньше
;     265 //4 - ист1 температура 
;     266 //5 - ист2 больше
;     267 //6 - ист3 меньше
;     268 //7 - ист4 температура 
;     269 
;     270 
;     271 char lcd_buffer[LCD_SIZE]={""};
_lcd_buffer:
	.BYTE 0x28
;     272 char dumm2[40];
_dumm2:
	.BYTE 0x28
;     273 char cnt_alias_blok;
_cnt_alias_blok:
	.BYTE 0x1
;     274 char star_cnt;
_star_cnt:
	.BYTE 0x1
;     275 
;     276 
;     277 
;     278 
;     279 
;     280 #include "ret.c"
;     281 char retind,retsub,retindsec;
_retind:
	.BYTE 0x1
_retsub:
	.BYTE 0x1
_retindsec:
	.BYTE 0x1
;     282 int retcnt,retcntsec;
_retcnt:
	.BYTE 0x2
_retcntsec:
	.BYTE 0x2
;     283 //-----------------------------------------------
;     284 void ret_ind(char r_i,char r_s,int r_c)
;     285 {

	.CSEG
;     286 retcnt=r_c;
;     287 retind=r_i;
;     288 retsub=r_s;
;     289 }    
;     290 
;     291 //-----------------------------------------------
;     292 void ret_ind_hndl(void)
;     293 {
_ret_ind_hndl:
;     294 if(retcnt)
	LDS  R30,_retcnt
	LDS  R31,_retcnt+1
	SBIW R30,0
	BREQ _0x15
;     295 	{
;     296 	if((--retcnt)==0)
	SBIW R30,1
	STS  _retcnt,R30
	STS  _retcnt+1,R31
	SBIW R30,0
	BRNE _0x16
;     297 		{
;     298  		ind=retind;
	LDS  R6,_retind
;     299    		sub_ind=retsub;
	LDS  R10,_retsub
;     300    		index_set=sub_ind;
	MOV  R12,R10
;     301 	 	}
;     302      }
_0x16:
;     303 }  
_0x15:
	RET
;     304 
;     305 
;     306  
;     307 //---------------------------------------------
;     308 void ret_ind_sec(char r_i,int r_c)
;     309 {
;     310 retcntsec=r_c;
;     311 retindsec=r_i;
;     312 }
;     313 
;     314 //-----------------------------------------------
;     315 void ret_ind_sec_hndl(void)
;     316 {
;     317 if(retcntsec)
;     318  	{
;     319 	if((--retcntsec)==0)
;     320 	 	{
;     321  		ind=retindsec;
;     322  		sub_ind=0;
;     323 
;     324 	 	}
;     325    	}		
;     326 }   
;     327 
;     328 char bmm_cnt,bmp_cnt;

	.DSEG
_bmm_cnt:
	.BYTE 0x1
_bmp_cnt:
	.BYTE 0x1
;     329 bit bS=1;
;     330 
;     331 eeprom enum {emMNL=0x55,emAVT=0xaa}ee_mode; 

	.ESEG
_ee_mode:
	.DB  0x0
;     332 signed nakal_cnt;

	.DSEG
_nakal_cnt:
	.BYTE 0x2
;     333 signed Un,In;
_Un:
	.BYTE 0x2
_In:
	.BYTE 0x2
;     334 eeprom unsigned char ee_pwm;

	.ESEG
_ee_pwm:
	.DB  0x0
;     335 eeprom signed ee_nagrev_time,ee_wrk_time,ee_ostiv_time;
_ee_nagrev_time:
	.DW  0x0
_ee_wrk_time:
	.DW  0x0
_ee_ostiv_time:
	.DW  0x0
;     336 enum {wsSTOP,wsNAGREV,wsWRK,wsOSTIV}wrk_state=wsSTOP;

	.DSEG
_wrk_state:
	.BYTE 0x1
;     337 signed wrk_cnt;
_wrk_cnt:
	.BYTE 0x2
;     338 eeprom signed Ku,Ki;

	.ESEG
_Ku:
	.DW  0x0
_Ki:
	.DW  0x0
;     339 //-----------------------------------------------
;     340 void wrk_state_drv(void)
;     341 {

	.CSEG
_wrk_state_drv:
;     342 if(nakal_cnt)nakal_cnt--;
	LDS  R30,_nakal_cnt
	LDS  R31,_nakal_cnt+1
	SBIW R30,0
	BREQ _0x19
	SBIW R30,1
	STS  _nakal_cnt,R30
	STS  _nakal_cnt+1,R31
;     343 
;     344 if(wrk_state==wsNAGREV)
_0x19:
	LDS  R26,_wrk_state
	CPI  R26,LOW(0x1)
	BRNE _0x1A
;     345 	{
;     346 	if(wrk_cnt)
	LDS  R30,_wrk_cnt
	LDS  R31,_wrk_cnt+1
	SBIW R30,0
	BREQ _0x1B
;     347 		{
;     348 		wrk_cnt--;
	CALL SUBOPT_0x1
;     349 		}
;     350 	if(!wrk_cnt)
_0x1B:
	LDS  R30,_wrk_cnt
	LDS  R31,_wrk_cnt+1
	SBIW R30,0
	BRNE _0x1C
;     351 		{
;     352 		wrk_state=wsWRK;
	LDI  R30,LOW(2)
	STS  _wrk_state,R30
;     353 		wrk_cnt=ee_wrk_time;
	LDI  R26,LOW(_ee_wrk_time)
	LDI  R27,HIGH(_ee_wrk_time)
	CALL __EEPROMRDW
	STS  _wrk_cnt,R30
	STS  _wrk_cnt+1,R31
;     354 		}
;     355 	}
_0x1C:
;     356 else if(wrk_state==wsWRK)
	RJMP _0x1D
_0x1A:
	LDS  R26,_wrk_state
	CPI  R26,LOW(0x2)
	BRNE _0x1E
;     357 	{
;     358 	if(wrk_cnt)
	LDS  R30,_wrk_cnt
	LDS  R31,_wrk_cnt+1
	SBIW R30,0
	BREQ _0x1F
;     359 		{
;     360 		wrk_cnt--;
	CALL SUBOPT_0x1
;     361 		}
;     362 	if(!wrk_cnt)
_0x1F:
	LDS  R30,_wrk_cnt
	LDS  R31,_wrk_cnt+1
	SBIW R30,0
	BRNE _0x20
;     363 		{
;     364 		wrk_state=wsOSTIV;
	LDI  R30,LOW(3)
	STS  _wrk_state,R30
;     365 		wrk_cnt=ee_ostiv_time;
	LDI  R26,LOW(_ee_ostiv_time)
	LDI  R27,HIGH(_ee_ostiv_time)
	CALL __EEPROMRDW
	STS  _wrk_cnt,R30
	STS  _wrk_cnt+1,R31
;     366 		}
;     367 	}	
_0x20:
;     368 else if(wrk_state==wsOSTIV)
	RJMP _0x21
_0x1E:
	LDS  R26,_wrk_state
	CPI  R26,LOW(0x3)
	BRNE _0x22
;     369 	{
;     370 	if(wrk_cnt)
	LDS  R30,_wrk_cnt
	LDS  R31,_wrk_cnt+1
	SBIW R30,0
	BREQ _0x23
;     371 		{
;     372 		wrk_cnt--;
	CALL SUBOPT_0x1
;     373 		}
;     374 	if(!wrk_cnt)
_0x23:
	LDS  R30,_wrk_cnt
	LDS  R31,_wrk_cnt+1
	SBIW R30,0
	BRNE _0x24
;     375 		{
;     376 		if(ee_mode==emAVT)
	LDI  R26,LOW(_ee_mode)
	LDI  R27,HIGH(_ee_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BRNE _0x25
;     377 			{
;     378 			wrk_state=wsNAGREV;
	CALL SUBOPT_0x2
;     379 			wrk_cnt=ee_nagrev_time;
;     380 			}
;     381 		else 
	RJMP _0x26
_0x25:
;     382 			{
;     383 			wrk_state=wsSTOP;
	CALL SUBOPT_0x3
;     384 			wrk_cnt=0;			
;     385 			}	
_0x26:
;     386 		
;     387 		}
;     388 	}		
_0x24:
;     389 }
_0x22:
_0x21:
_0x1D:
	RET
;     390 		
;     391 //-----------------------------------------------
;     392 void adc_drv(void)
;     393 {
_adc_drv:
;     394 char i;
;     395 char temp;
;     396 unsigned int tempUI,tempUI_;
;     397 
;     398 if(adc_cnt<=7)tempUI=ADCW;
	CALL __SAVELOCR6
;	i -> R16
;	temp -> R17
;	tempUI -> R18,R19
;	tempUI_ -> R20,R21
	LDI  R30,LOW(7)
	CP   R30,R8
	BRLO _0x27
	__INWR 18,19,4
;     399 
;     400 for (i=0;i<4;i++)
_0x27:
	LDI  R16,LOW(0)
_0x29:
	CPI  R16,4
	BRSH _0x2A
;     401 	{
;     402 	adc_bank[adc_cnt,i]+=tempUI;
	CALL SUBOPT_0x4
	PUSH R27
	PUSH R26
	CALL __LSLW3
	POP  R26
	POP  R27
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R16
	CALL SUBOPT_0x5
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETW1P
	ADD  R30,R18
	ADC  R31,R19
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
;     403 	}   
	SUBI R16,-1
	RJMP _0x29
_0x2A:
;     404 
;     405 
;     406 if((adc_cnt1&0x03)==0)  
	MOV  R30,R9
	ANDI R30,LOW(0x3)
	BRNE _0x2B
;     407 	{
;     408   	temp=(adc_cnt1&0x0c)>>2;
	MOV  R30,R9
	ANDI R30,LOW(0xC)
	LSR  R30
	LSR  R30
	MOV  R17,R30
;     409     	adc_bank_[adc_cnt]=(adc_bank[adc_cnt,temp])/16;
	MOV  R30,R8
	LDI  R26,LOW(_adc_bank_)
	LDI  R27,HIGH(_adc_bank_)
	CALL SUBOPT_0x5
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4
	PUSH R27
	PUSH R26
	CALL __LSLW3
	POP  R26
	POP  R27
	CALL SUBOPT_0x6
	CALL __GETW1P
	CALL __LSRW4
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
;     410      	adc_bank[adc_cnt,temp]=0;
	CALL SUBOPT_0x4
	PUSH R27
	PUSH R26
	CALL __LSLW3
	POP  R26
	POP  R27
	CALL SUBOPT_0x6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
;     411    	} 		
;     412         
;     413 
;     414 if((++adc_cnt)>=10)
_0x2B:
	INC  R8
	LDI  R30,LOW(10)
	CP   R8,R30
	BRLO _0x2C
;     415 	{
;     416 	adc_cnt=0;
	CLR  R8
;     417 	if((++adc_cnt1)>=16)
	INC  R9
	LDI  R30,LOW(16)
	CP   R9,R30
	BRLO _0x2D
;     418 		{
;     419   		adc_cnt1=0;
	CLR  R9
;     420   		}   
;     421 	}         
_0x2D:
;     422 
;     423 DDRA=0b00000000;
_0x2C:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
;     424 PORTA&=0b00000000;
	IN   R30,0x1B
	ANDI R30,LOW(0x0)
	OUT  0x1B,R30
;     425 if(adc_cnt<=4)
	LDI  R30,LOW(4)
	CP   R30,R8
	BRLO _0x2E
;     426 	{
;     427 	ADMUX=0b11000000|adc_cnt;
	MOV  R30,R8
	ORI  R30,LOW(0xC0)
	CALL SUBOPT_0x7
;     428 	SFIOR&=0b00011111;
;     429 	ADCSRA=0b10100110;
;     430 	ADCSRA|=0b01000000;  
	SBI  0x6,6
;     431      } 
;     432 else if(adc_cnt<=7)
	RJMP _0x2F
_0x2E:
	LDI  R30,LOW(7)
	CP   R30,R8
	BRLO _0x30
;     433 	{
;     434 	ADMUX=0b01000000|adc_cnt;
	MOV  R30,R8
	ORI  R30,0x40
	CALL SUBOPT_0x7
;     435 	SFIOR&=0b00011111;
;     436 	ADCSRA=0b10100110;
;     437 	ADCSRA|=0b01000000;  
	SBI  0x6,6
;     438  	}
;     439 else ADMUX=0b11000000;        
	RJMP _0x31
_0x30:
	LDI  R30,LOW(192)
	OUT  0x7,R30
_0x31:
_0x2F:
;     440 }
	CALL __LOADLOCR6
	ADIW R28,6
	RET
;     441 
;     442 //-----------------------------------------------
;     443 void define_char(char flash *pc,char ch_c)
;     444 {
_define_char:
;     445 char i,aaaa;
;     446 aaaa=(ch_c<<3)|0x40;
	ST   -Y,R17
	ST   -Y,R16
;	*pc -> Y+3
;	ch_c -> Y+2
;	i -> R16
;	aaaa -> R17
	LDD  R30,Y+2
	CALL __LSLB3
	ORI  R30,0x40
	MOV  R17,R30
;     447 for (i=0; i<8; i++) lcd_write_byte(aaaa++,*pc++);
	LDI  R16,LOW(0)
_0x33:
	CPI  R16,8
	BRSH _0x34
	ST   -Y,R17
	INC  R17
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	SBIW R30,1
	LPM  R30,Z
	ST   -Y,R30
	CALL _lcd_write_byte
	SUBI R16,-1
	RJMP _0x33
_0x34:
;     448 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
;     449 
;     450 //-----------------------------------------------
;     451 void simbol_define(void)
;     452 {
_simbol_define:
;     453 #asm("cli")
	cli
;     454 //PORTD|=0b11111010;
;     455 //DDRD|=0b11111010;
;     456 delay_us(10);
	__DELAY_USB 27
;     457 define_char(char0,1);
	LDI  R30,LOW(_char0*2)
	LDI  R31,HIGH(_char0*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _define_char
;     458 define_char(char1,2);
	LDI  R30,LOW(_char1*2)
	LDI  R31,HIGH(_char1*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _define_char
;     459 define_char(char2,3);
	LDI  R30,LOW(_char2*2)
	LDI  R31,HIGH(_char2*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _define_char
;     460 define_char(char3,4); 
	LDI  R30,LOW(_char3*2)
	LDI  R31,HIGH(_char3*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _define_char
;     461 define_char(char4,5);
	LDI  R30,LOW(_char4*2)
	LDI  R31,HIGH(_char4*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _define_char
;     462 define_char(char5,6); 
	LDI  R30,LOW(_char5*2)
	LDI  R31,HIGH(_char5*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _define_char
;     463 delay_us(10);
	__DELAY_USB 27
;     464 //PORTD|=0b11111010;
;     465 //DDRD|=0b11111010;
;     466 #asm("sei")
	sei
;     467 }
	RET
;     468 
;     469 //-----------------------------------------------
;     470 void lcd_out(void)
;     471 {
_lcd_out:
;     472 #asm("cli")
	cli
;     473 //PORTD|=0b11111010;
;     474 //DDRD|=0b11111010;
;     475 delay_us(10);
	__DELAY_USB 27
;     476 lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
;     477 lcd_puts(lcd_buffer);
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
;     478 delay_us(10);
	__DELAY_USB 27
;     479 //PORTD|=0b11111010;
;     480 //DDRD|=0b11111010;
;     481 #asm("sei")
	sei
;     482 }
	RET
;     483 
;     484 //-----------------------------------------------
;     485 void out_out(void)
;     486 { 
_out_out:
;     487 DDRD|=0b00110000;
	IN   R30,0x11
	ORI  R30,LOW(0x30)
	OUT  0x11,R30
;     488 DDRC|=0b00001100;
	IN   R30,0x14
	ORI  R30,LOW(0xC)
	OUT  0x14,R30
;     489 
;     490 if((nakal_cnt>=200)&&(nakal_cnt<600))
	LDS  R26,_nakal_cnt
	LDS  R27,_nakal_cnt+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLT _0x36
	CPI  R26,LOW(0x258)
	LDI  R30,HIGH(0x258)
	CPC  R27,R30
	BRLT _0x37
_0x36:
	RJMP _0x35
_0x37:
;     491 	{
;     492 	OCR1B=~ee_pwm;
	CALL SUBOPT_0x8
;     493 	PORTD.5=0;
	CBI  0x12,5
;     494 	
;     495 	PORTC.2=0;
	CBI  0x15,2
;     496 	PORTC.3=0;
	CBI  0x15,3
;     497 	}
;     498 	
;     499 else if(wrk_state==wsSTOP)
	RJMP _0x38
_0x35:
	LDS  R30,_wrk_state
	CPI  R30,0
	BRNE _0x39
;     500 	{
;     501 	OCR1B=255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	OUT  0x28+1,R31
	OUT  0x28,R30
;     502 	PORTD.5=1;
	SBI  0x12,5
;     503 	
;     504 	PORTC.2=0;
	CBI  0x15,2
;     505 	PORTC.3=0;	
	CBI  0x15,3
;     506 	}
;     507 
;     508 else if(wrk_state==wsNAGREV)
	RJMP _0x3A
_0x39:
	LDS  R26,_wrk_state
	CPI  R26,LOW(0x1)
	BRNE _0x3B
;     509 	{
;     510 	OCR1B=~ee_pwm;
	CALL SUBOPT_0x8
;     511 	PORTD.5=0;
	CBI  0x12,5
;     512 	
;     513 	PORTC.2=0;
	CBI  0x15,2
;     514 	PORTC.3=0;
	CBI  0x15,3
;     515 	}
;     516 else if(wrk_state==wsWRK)
	RJMP _0x3C
_0x3B:
	LDS  R26,_wrk_state
	CPI  R26,LOW(0x2)
	BRNE _0x3D
;     517 	{
;     518 	OCR1B=~ee_pwm;
	CALL SUBOPT_0x8
;     519 	PORTD.5=0;
	CBI  0x12,5
;     520 
;     521 	PORTC.2=1;
	SBI  0x15,2
;     522 	PORTC.3=1;
	SBI  0x15,3
;     523 	}	
;     524 else if(wrk_state==wsOSTIV)
	RJMP _0x3E
_0x3D:
	LDS  R26,_wrk_state
	CPI  R26,LOW(0x3)
	BRNE _0x3F
;     525 	{
;     526 	OCR1B=255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	OUT  0x28+1,R31
	OUT  0x28,R30
;     527 	PORTD.5=1;
	SBI  0x12,5
;     528 	
;     529 	PORTC.2=1;
	SBI  0x15,2
;     530 	PORTC.3=1;	
	SBI  0x15,3
;     531 	}
;     532 }
_0x3F:
_0x3E:
_0x3C:
_0x3A:
_0x38:
	RET
;     533 
;     534 //-----------------------------------------------
;     535 void parol_init(void)
;     536 {
;     537 parol[0]=0;
;     538 parol[1]=0;
;     539 parol[2]=0;
;     540 sub_ind=0;
;     541 }
;     542 
;     543 //-----------------------------------------------
;     544 int Imat(int in,int k0,int k1)
;     545 {
;     546 signed long int temp;
;     547 temp= in-k0;
;	in -> Y+8
;	k0 -> Y+6
;	k1 -> Y+4
;	temp -> Y+0
;     548 if(temp<0) temp=0;
;     549 temp*=k1;
;     550 temp/=100L;
;     551 return (int)temp;
;     552 }
;     553 
;     554 //-----------------------------------------------
;     555 int Ibmat(int in,int k0,int k1)
;     556 {
;     557 signed long int temp;
;     558 temp= in-k0;
;	in -> Y+8
;	k0 -> Y+6
;	k1 -> Y+4
;	temp -> Y+0
;     559 if(temp<0)
;     560 	{ 
;     561 	temp=-temp;
;     562 	bit_minus=1;
;     563 	}
;     564 else bit_minus=0;	
;     565 temp*=k1;
;     566 temp/=160L;
;     567 return (int)temp;
;     568 }
;     569 
;     570 //-----------------------------------------------
;     571 int Umat(int in,int k1)
;     572 {
;     573 signed long int temp;
;     574 temp=in;
;	in -> Y+6
;	k1 -> Y+4
;	temp -> Y+0
;     575 temp*=k1;
;     576 temp/=100L;
;     577 return (int)temp;
;     578 }
;     579 
;     580 //-----------------------------------------------
;     581 void matemat(void)
;     582 { 
_matemat:
;     583 signed long int adc_out_temp;
;     584 char temp;
;     585 //Us[0]=Umat(adc_bank_[0],K_[kui1])/5;	
;     586 //Us[1]=Umat(adc_bank_[1],K_[kui2])/5;
;     587 //Ubat=Umat(adc_bank_[9]/4,K_[kub])/5;
;     588 adc_out_temp=(signed long)adc_bank_[0];
	SBIW R28,4
	ST   -Y,R16
;	adc_out_temp -> Y+1
;	temp -> R16
	LDS  R30,_adc_bank_
	LDS  R31,_adc_bank_+1
	CLR  R22
	CLR  R23
	__PUTD1S 1
;     589 adc_out_temp*=(signed long)Ku;
	LDI  R26,LOW(_Ku)
	LDI  R27,HIGH(_Ku)
	CALL __EEPROMRDW
	CALL SUBOPT_0x9
;     590 adc_out_temp/=200L; 
	__GETD1N 0xC8
	CALL SUBOPT_0xA
;     591 Un=(signed)adc_out_temp;
	STS  _Un,R30
	STS  _Un+1,R31
;     592 adc_out_temp=(signed long)adc_bank_[2];
	__GETW1MN _adc_bank_,4
	CLR  R22
	CLR  R23
	__PUTD1S 1
;     593 adc_out_temp*=(signed long)Ki;
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	CALL __EEPROMRDW
	CALL SUBOPT_0x9
;     594 adc_out_temp/=100L;
	__GETD1N 0x64
	CALL SUBOPT_0xA
;     595 In=(signed)adc_out_temp;
	STS  _In,R30
	STS  _In+1,R31
;     596 //Un=(adc_bank_[0]*Ku)/200;
;     597 //In=(adc_bank_[2]*Ki)/200;
;     598 
;     599 
;     600 
;     601 }
	RJMP _0x165
;     602 
;     603  
;     604 //-----------------------------------------------
;     605 char find(char xy)
;     606 {
_find:
;     607 char i=0;
;     608 do i++;
	ST   -Y,R16
;	xy -> Y+1
;	i -> R16
	LDI  R16,0
_0x44:
	SUBI R16,-1
;     609 while ((lcd_buffer[i]!=xy)&&(i<LCD_SIZE));
	CALL SUBOPT_0xB
	LD   R30,Z
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
	BREQ _0x46
	CPI  R16,40
	BRLO _0x47
_0x46:
	RJMP _0x45
_0x47:
	RJMP _0x44
_0x45:
;     610 if(i>(33)) i=255;
	LDI  R30,LOW(33)
	CP   R30,R16
	BRSH _0x48
	LDI  R16,LOW(255)
;     611 return i;
_0x48:
	MOV  R30,R16
	RJMP _0x167
;     612 }
;     613 
;     614 
;     615 //-----------------------------------------------
;     616 void bin2bcd_int(unsigned int in)
;     617 {
_bin2bcd_int:
;     618 char i=5;
;     619 for(i=0;i<5;i++)
	ST   -Y,R16
;	in -> Y+1
;	i -> R16
	LDI  R16,5
	LDI  R16,LOW(0)
_0x4A:
	CPI  R16,5
	BRSH _0x4B
;     620 	{
;     621 	dig[i]=in%10;
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
;     622 	in/=10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
;     623 	}   
	SUBI R16,-1
	RJMP _0x4A
_0x4B:
;     624 }
	LDD  R16,Y+0
	ADIW R28,3
	RET
;     625 
;     626 //-----------------------------------------------
;     627 void bcd2lcd_zero(char sig)
;     628 {
_bcd2lcd_zero:
;     629 char i;
;     630 zero_on=1;
	ST   -Y,R16
;	sig -> Y+1
;	i -> R16
	SET
	BLD  R3,0
;     631 for (i=5;i>0;i--)
	LDI  R16,LOW(5)
_0x4D:
	LDI  R30,LOW(0)
	CP   R30,R16
	BRSH _0x4E
;     632 	{
;     633 	if(zero_on&&(!dig[i-1])&&(i>sig))
	SBRS R3,0
	RJMP _0x50
	CALL SUBOPT_0xC
	LD   R30,Z
	CPI  R30,0
	BRNE _0x50
	LDD  R30,Y+1
	CP   R30,R16
	BRLO _0x51
_0x50:
	RJMP _0x4F
_0x51:
;     634 		{
;     635 		dig[i-1]=0x20;
	CALL SUBOPT_0xC
	MOVW R26,R30
	LDI  R30,LOW(32)
	ST   X,R30
;     636 		}
;     637 	else
	RJMP _0x52
_0x4F:
;     638 		{
;     639 		dig[i-1]=dig[i-1]+0x30;
	CALL SUBOPT_0xC
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC
	LD   R30,Z
	SUBI R30,-LOW(48)
	POP  R26
	POP  R27
	ST   X,R30
;     640 		zero_on=0;
	CLT
	BLD  R3,0
;     641 		}	
_0x52:
;     642 	}
	SUBI R16,1
	RJMP _0x4D
_0x4E:
;     643 }    
_0x167:
	LDD  R16,Y+0
	ADIW R28,2
	RET
;     644 
;     645 //-----------------------------------------------
;     646 void int2lcd(unsigned int in,char xy,char des)
;     647 {
_int2lcd:
;     648 char i;
;     649 char n;
;     650 
;     651 bin2bcd_int(in);
	CALL SUBOPT_0xD
;	in -> Y+4
;	xy -> Y+3
;	des -> Y+2
;	i -> R16
;	n -> R17
;     652 bcd2lcd_zero(des+1);
;     653 i=find(xy);
	CALL SUBOPT_0xE
;     654 for (n=0;n<5;n++)
	LDI  R17,LOW(0)
_0x54:
	CPI  R17,5
	BRLO PC+3
	JMP _0x55
;     655 	{
;     656    	if(!des&&(dig[n]!=' '))
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x57
	CALL SUBOPT_0xF
	CPI  R30,LOW(0x20)
	BRNE _0x58
_0x57:
	RJMP _0x56
_0x58:
;     657    		{
;     658    		lcd_buffer[i]=dig[n];	 
	CALL SUBOPT_0xB
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xF
	POP  R26
	POP  R27
	ST   X,R30
;     659    		}
;     660    	else 
	RJMP _0x59
_0x56:
;     661    		{
;     662    		if(n<des)lcd_buffer[i]=dig[n];
	LDD  R30,Y+2
	CP   R17,R30
	BRSH _0x5A
	CALL SUBOPT_0xB
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xF
	POP  R26
	POP  R27
	ST   X,R30
;     663    		else if (n==des)
	RJMP _0x5B
_0x5A:
	LDD  R30,Y+2
	CP   R30,R17
	BRNE _0x5C
;     664    			{
;     665    			lcd_buffer[i]='.';
	CALL SUBOPT_0x10
	LDI  R30,LOW(46)
	ST   X,R30
;     666    			lcd_buffer[i-1]=dig[n];
	CALL SUBOPT_0x11
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xF
	POP  R26
	POP  R27
	ST   X,R30
;     667    			} 
;     668    		else if ((n>des)&&(dig[n]!=' ')) lcd_buffer[i-1]=dig[n];   		
	RJMP _0x5D
_0x5C:
	LDD  R30,Y+2
	CP   R30,R17
	BRSH _0x5F
	CALL SUBOPT_0xF
	CPI  R30,LOW(0x20)
	BRNE _0x60
_0x5F:
	RJMP _0x5E
_0x60:
	CALL SUBOPT_0x11
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xF
	POP  R26
	POP  R27
	ST   X,R30
;     669    		}  
_0x5E:
_0x5D:
_0x5B:
_0x59:
;     670 		
;     671 	i--;	
	SUBI R16,1
;     672 	}
	SUBI R17,-1
	RJMP _0x54
_0x55:
;     673 }
	RJMP _0x166
;     674 
;     675 //-----------------------------------------------
;     676 void int2lcdxy(unsigned int in,char xy,char des)
;     677 {
_int2lcdxy:
;     678 char i;
;     679 char n;
;     680 bin2bcd_int(in);
	CALL SUBOPT_0xD
;	in -> Y+4
;	xy -> Y+3
;	des -> Y+2
;	i -> R16
;	n -> R17
;     681 bcd2lcd_zero(des+1);
;     682 i=((xy&0b00000011)*16)+((xy&0b11110000)>>4);
	ANDI R30,LOW(0x3)
	MOV  R26,R30
	LDI  R30,LOW(16)
	MUL  R30,R26
	MOV  R30,R0
	PUSH R30
	LDD  R30,Y+3
	ANDI R30,LOW(0xF0)
	SWAP R30
	ANDI R30,0xF
	POP  R26
	ADD  R30,R26
	MOV  R16,R30
;     683 if ((xy&0b00000011)>=2) i++;
	LDD  R30,Y+3
	ANDI R30,LOW(0x3)
	CPI  R30,LOW(0x2)
	BRLO _0x61
	SUBI R16,-1
;     684 if ((xy&0b00000011)==3) i++;
_0x61:
	LDD  R30,Y+3
	ANDI R30,LOW(0x3)
	CPI  R30,LOW(0x3)
	BRNE _0x62
	SUBI R16,-1
;     685 for (n=0;n<5;n++)
_0x62:
	LDI  R17,LOW(0)
_0x64:
	CPI  R17,5
	BRSH _0x65
;     686 	{ 
;     687 	if(n<des)
	LDD  R30,Y+2
	CP   R17,R30
	BRSH _0x66
;     688 		{
;     689 		lcd_buffer[i]=dig[n];
	CALL SUBOPT_0xB
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xF
	POP  R26
	POP  R27
	ST   X,R30
;     690 		}   
;     691 	if((n>=des)&&(dig[n]!=0x20))
_0x66:
	LDD  R30,Y+2
	CP   R17,R30
	BRLO _0x68
	CALL SUBOPT_0xF
	CPI  R30,LOW(0x20)
	BRNE _0x69
_0x68:
	RJMP _0x67
_0x69:
;     692 		{
;     693 		if(!des)lcd_buffer[i]=dig[n];	
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x6A
	CALL SUBOPT_0xB
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xF
	POP  R26
	POP  R27
	RJMP _0x168
;     694 		else lcd_buffer[i-1]=dig[n];
_0x6A:
	CALL SUBOPT_0x11
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xF
	POP  R26
	POP  R27
_0x168:
	ST   X,R30
;     695    		}   
;     696 	i--;	
_0x67:
	SUBI R16,1
;     697 	}
	SUBI R17,-1
	RJMP _0x64
_0x65:
;     698 }
_0x166:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
;     699 
;     700 //-----------------------------------------------
;     701 void sub_bgnd(char flash *adr,char xy,signed char offset)
;     702 {
_sub_bgnd:
;     703 char temp;
;     704 temp=find(xy);
	ST   -Y,R16
;	*adr -> Y+3
;	xy -> Y+2
;	offset -> Y+1
;	temp -> R16
	LDD  R30,Y+2
	CALL SUBOPT_0xE
;     705 
;     706 //ptr_ram=&lcd_buffer[find(xy)];
;     707 if(temp!=255)
	CPI  R16,255
	BREQ _0x6C
;     708 while (*adr)
_0x6D:
	CALL SUBOPT_0x12
	BREQ _0x6F
;     709 	{
;     710 	lcd_buffer[temp+offset]=*adr++;
	LDD  R30,Y+1
	ADD  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_lcd_buffer)
	SBCI R31,HIGH(-_lcd_buffer)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x13
	POP  R26
	POP  R27
	ST   X,R30
;     711 	temp++;
	SUBI R16,-1
;     712     	}
	RJMP _0x6D
_0x6F:
;     713 }
_0x6C:
	RJMP _0x165
;     714 
;     715 //-----------------------------------------------
;     716 void bgnd_par(char flash *ptr0,char flash *ptr1)
;     717 {
_bgnd_par:
;     718 char i;
;     719 for (i=0;i<LCD_SIZE;i++)
	ST   -Y,R16
;	*ptr0 -> Y+3
;	*ptr1 -> Y+1
;	i -> R16
	LDI  R16,LOW(0)
_0x71:
	CPI  R16,40
	BRSH _0x72
;     720 	{
;     721 	lcd_buffer[i]=0x20;
	CALL SUBOPT_0x10
	LDI  R30,LOW(32)
	ST   X,R30
;     722 	}
	SUBI R16,-1
	RJMP _0x71
_0x72:
;     723 ptr_ram=lcd_buffer;
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	STS  _ptr_ram,R30
	STS  _ptr_ram+1,R31
;     724 while (*ptr0)
_0x73:
	CALL SUBOPT_0x12
	BREQ _0x75
;     725 	{
;     726 	*ptr_ram++=*ptr0++;
	CALL SUBOPT_0x14
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x13
	POP  R26
	POP  R27
	ST   X,R30
;     727    	}
	RJMP _0x73
_0x75:
;     728 while (*ptr1)
_0x76:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0x78
;     729 	{
;     730 	*ptr_ram++=*ptr1++;
	CALL SUBOPT_0x14
	PUSH R31
	PUSH R30
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	POP  R26
	POP  R27
	ST   X,R30
;     731    	}
	RJMP _0x76
_0x78:
;     732 } 
_0x165:
	LDD  R16,Y+0
	ADIW R28,5
	RET
;     733 
;     734 
;     735 //-----------------------------------------------
;     736 void ind_hndl(void)
;     737 {
_ind_hndl:
;     738 /* 
;     739 flash char sm0_0[]	={" Раб. от ист N] "};
;     740 flash char sm0_1[]	={" Раб. от N1 и N2"}; 
;     741 flash char sm0_2[]	={" Раб. от батареи"};
;     742 flash char sm0_3[]	={" Ав.N[   Раб.N] "}; */
;     743 
;     744 signed int temp;
;     745 flash char* ptrs[11];
;     746 char temp_;
;     747 
;     748 if (ind==iMn)
	SBIW R28,22
	CALL __SAVELOCR3
;	temp -> R16,R17
;	*ptrs -> Y+3
;	temp_ -> R18
	TST  R6
	BREQ PC+3
	JMP _0x79
;     749 	{
;     750  	bgnd_par(	"      $         ",
;     751  			" U=  ,!В I=  ,@А"); 
	__POINTW1FN _0,1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0,18
	ST   -Y,R31
	ST   -Y,R30
	CALL _bgnd_par
;     752  	int2lcd(Un,'!',1);
	CALL SUBOPT_0x15
;     753  	int2lcd(In,'@',1);
	LDS  R30,_In
	LDS  R31,_In+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(64)
	CALL SUBOPT_0x16
	CALL _int2lcd
;     754 	
;     755 	if(wrk_state==wsSTOP)
	LDS  R30,_wrk_state
	CPI  R30,0
	BRNE _0x7A
;     756 		{
;     757 		sub_bgnd(" СТОП ",'$',-5);
	__POINTW1FN _0,35
	CALL SUBOPT_0x17
;     758 		}
;     759 
;     760 	else if(wrk_state==wsNAGREV)
	RJMP _0x7B
_0x7A:
	LDS  R26,_wrk_state
	CPI  R26,LOW(0x1)
	BRNE _0x7C
;     761 		{
;     762 		sub_bgnd("НАГРЕВ",'$',-5);
	__POINTW1FN _0,42
	CALL SUBOPT_0x17
;     763 		int2lcdxy(wrk_cnt,0xA0,1);
	CALL SUBOPT_0x18
	CALL _int2lcdxy
;     764 		lcd_buffer[9]='.';
	LDI  R30,LOW(46)
	__PUTB1MN _lcd_buffer,9
;     765 		lcd_buffer[11]='с';
	LDI  R30,LOW(241)
	__PUTB1MN _lcd_buffer,11
;     766 		lcd_buffer[12]='.';
	LDI  R30,LOW(46)
	__PUTB1MN _lcd_buffer,12
;     767 		
;     768 		}
;     769 
;     770 	else if(wrk_state==wsWRK)
	RJMP _0x7D
_0x7C:
	LDS  R26,_wrk_state
	CPI  R26,LOW(0x2)
	BRNE _0x7E
;     771 		{
;     772 		sub_bgnd(" ПАЙКА",'$',-5);
	__POINTW1FN _0,49
	CALL SUBOPT_0x17
;     773 		int2lcdxy(wrk_cnt,0xA0,1);
	CALL SUBOPT_0x18
	CALL _int2lcdxy
;     774 		lcd_buffer[9]='.';
	LDI  R30,LOW(46)
	__PUTB1MN _lcd_buffer,9
;     775 		lcd_buffer[11]='с';
	LDI  R30,LOW(241)
	__PUTB1MN _lcd_buffer,11
;     776 		lcd_buffer[12]='.';
	LDI  R30,LOW(46)
	__PUTB1MN _lcd_buffer,12
;     777 		}
;     778 		
;     779 	else if(wrk_state==wsOSTIV)
	RJMP _0x7F
_0x7E:
	LDS  R26,_wrk_state
	CPI  R26,LOW(0x3)
	BRNE _0x80
;     780 		{
;     781 		sub_bgnd("ОСТЫВ.",'$',-5);
	__POINTW1FN _0,56
	CALL SUBOPT_0x17
;     782 		int2lcdxy(wrk_cnt,0xA0,1);
	CALL SUBOPT_0x18
	CALL _int2lcdxy
;     783 		lcd_buffer[9]='.';
	LDI  R30,LOW(46)
	__PUTB1MN _lcd_buffer,9
;     784 		lcd_buffer[11]='с';
	LDI  R30,LOW(241)
	__PUTB1MN _lcd_buffer,11
;     785 		lcd_buffer[12]='.';
	LDI  R30,LOW(46)
	__PUTB1MN _lcd_buffer,12
;     786 		}		
;     787  	
;     788  	if(ee_mode==emAVT)
_0x80:
_0x7F:
_0x7D:
_0x7B:
	LDI  R26,LOW(_ee_mode)
	LDI  R27,HIGH(_ee_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BRNE _0x81
;     789  		{
;     790  		lcd_buffer[14]=5;
	LDI  R30,LOW(5)
	__PUTB1MN _lcd_buffer,14
;     791  		lcd_buffer[15]=6;
	LDI  R30,LOW(6)
	__PUTB1MN _lcd_buffer,15
;     792  		}	     
;     793 	}
_0x81:
;     794 else if(ind==iSet)
	RJMP _0x82
_0x79:
	LDI  R30,LOW(3)
	CP   R30,R6
	BREQ PC+3
	JMP _0x83
;     795 	{
;     796 	if(sub_ind==0)
	TST  R10
	BRNE _0x84
;     797 		{
;     798 		bgnd_par(	"   УСТАНОВКИ    ",
;     799  				" Режим         !"); 
	__POINTW1FN _0,63
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0,80
	ST   -Y,R31
	ST   -Y,R30
	CALL _bgnd_par
;     800           if(ee_mode==emAVT)sub_bgnd("АВТОМ.",'!',-5);
	LDI  R26,LOW(_ee_mode)
	LDI  R27,HIGH(_ee_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BRNE _0x85
	__POINTW1FN _0,97
	CALL SUBOPT_0x19
	LDI  R30,LOW(251)
	RJMP _0x169
;     801           else sub_bgnd("РУЧН.",'!',-4);
_0x85:
	__POINTW1FN _0,104
	CALL SUBOPT_0x19
	LDI  R30,LOW(252)
_0x169:
	ST   -Y,R30
	CALL _sub_bgnd
;     802 		}  
;     803 	else if(sub_ind==1)
	RJMP _0x87
_0x84:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x88
;     804 		{
;     805 		bgnd_par(	"   УСТАНОВКИ    ",
;     806  				" Uнагрев      !В"); 
	__POINTW1FN _0,63
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0,110
	ST   -Y,R31
	ST   -Y,R30
	CALL _bgnd_par
;     807           if((nakal_cnt>=200)&&(nakal_cnt<600))int2lcd(Un,'!',1);
	LDS  R26,_nakal_cnt
	LDS  R27,_nakal_cnt+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLT _0x8A
	CPI  R26,LOW(0x258)
	LDI  R30,HIGH(0x258)
	CPC  R27,R30
	BRLT _0x8B
_0x8A:
	RJMP _0x89
_0x8B:
	CALL SUBOPT_0x15
;     808 		else if((nakal_cnt<200)&&(nakal_cnt>0))sub_bgnd("ОСТЫВ.",'!',-4);          
	RJMP _0x8C
_0x89:
	LDS  R26,_nakal_cnt
	LDS  R27,_nakal_cnt+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRGE _0x8E
	CALL __CPW02
	BRLT _0x8F
_0x8E:
	RJMP _0x8D
_0x8F:
	__POINTW1FN _0,56
	CALL SUBOPT_0x19
	LDI  R30,LOW(252)
	RJMP _0x16A
;     809           else sub_bgnd("ВЫКЛ.",'!',-3);
_0x8D:
	__POINTW1FN _0,127
	CALL SUBOPT_0x19
	LDI  R30,LOW(253)
_0x16A:
	ST   -Y,R30
	CALL _sub_bgnd
_0x8C:
;     810           
;     811       	//int2lcdxy(ee_pwm,0xf0,0);
;     812 		}		
;     813 	else if(sub_ind==2)
	RJMP _0x91
_0x88:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x92
;     814 		{
;     815 		bgnd_par(	"   УСТАНОВКИ    ",
;     816  				" Tнагрев.    !с."); 
	__POINTW1FN _0,63
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0,133
	ST   -Y,R31
	ST   -Y,R30
	CALL _bgnd_par
;     817           int2lcd(ee_nagrev_time,'!',1);
	LDI  R26,LOW(_ee_nagrev_time)
	LDI  R27,HIGH(_ee_nagrev_time)
	CALL __EEPROMRDW
	CALL SUBOPT_0x1A
	CALL _int2lcd
;     818           }		
;     819 	else if(sub_ind==3)
	RJMP _0x93
_0x92:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x94
;     820 		{
;     821 		bgnd_par(	"   УСТАНОВКИ    ",
;     822  				" Tпайка      !с."); 
	__POINTW1FN _0,63
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0,150
	ST   -Y,R31
	ST   -Y,R30
	CALL _bgnd_par
;     823           int2lcd(ee_wrk_time,'!',1);
	LDI  R26,LOW(_ee_wrk_time)
	LDI  R27,HIGH(_ee_wrk_time)
	CALL __EEPROMRDW
	CALL SUBOPT_0x1A
	CALL _int2lcd
;     824           }		
;     825 	else if(sub_ind==4)
	RJMP _0x95
_0x94:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0x96
;     826 		{
;     827 		bgnd_par(	"   УСТАНОВКИ    ",
;     828  				" Tостыв.     !с."); 
	__POINTW1FN _0,63
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0,167
	ST   -Y,R31
	ST   -Y,R30
	CALL _bgnd_par
;     829           int2lcd(ee_ostiv_time,'!',1);
	LDI  R26,LOW(_ee_ostiv_time)
	LDI  R27,HIGH(_ee_ostiv_time)
	CALL __EEPROMRDW
	CALL SUBOPT_0x1A
	CALL _int2lcd
;     830           }
;     831 	else if(sub_ind==5)
	RJMP _0x97
_0x96:
	LDI  R30,LOW(5)
	CP   R30,R10
	BRNE _0x98
;     832 		{
;     833 		bgnd_par(	"   УСТАНОВКИ    ",
;     834  				" Выход          "); 
	__POINTW1FN _0,63
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0,184
	ST   -Y,R31
	ST   -Y,R30
	CALL _bgnd_par
;     835           }		
;     836 	else if(sub_ind==6)
	RJMP _0x99
_0x98:
	LDI  R30,LOW(6)
	CP   R30,R10
	BRNE _0x9A
;     837 		{
;     838 		bgnd_par(	"   УСТАНОВКИ    ",
;     839  				" Калибровка     "); 
	__POINTW1FN _0,63
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0,201
	ST   -Y,R31
	ST   -Y,R30
	CALL _bgnd_par
;     840           }		          		
;     841 	} 
_0x9A:
_0x99:
_0x97:
_0x95:
_0x93:
_0x91:
_0x87:
;     842 	
;     843 else if(ind==iK)
	RJMP _0x9B
_0x83:
	LDI  R30,LOW(10)
	CP   R30,R6
	BREQ PC+3
	JMP _0x9C
;     844 	{
;     845 	if(sub_ind==0)
	TST  R10
	BRNE _0x9D
;     846 		{
;     847 		bgnd_par(	"  КАЛИБРОВКИ    ",
;     848  				" Uнагр       .!В");
	__POINTW1FN _0,218
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0,235
	CALL SUBOPT_0x1B
;     849  		if(nakal_cnt==0)sub_bgnd("ВЫКЛ.",'!',-3);
	BRNE _0x9E
	__POINTW1FN _0,127
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1C
;     850  		else if(nakal_cnt<200)sub_bgnd("ОСТЫВ.",'!',-4);
	RJMP _0x9F
_0x9E:
	LDS  R26,_nakal_cnt
	LDS  R27,_nakal_cnt+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRGE _0xA0
	__POINTW1FN _0,56
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1D
;     851  		else if((nakal_cnt>=200)&&(nakal_cnt<600))int2lcd(Un,'!',1);
	RJMP _0xA1
_0xA0:
	LDS  R26,_nakal_cnt
	LDS  R27,_nakal_cnt+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLT _0xA3
	CPI  R26,LOW(0x258)
	LDI  R30,HIGH(0x258)
	CPC  R27,R30
	BRLT _0xA4
_0xA3:
	RJMP _0xA2
_0xA4:
	CALL SUBOPT_0x15
;     852  		//int2lcdxy(Ku,0xf0,0);				
;     853 		}
_0xA2:
_0xA1:
_0x9F:
;     854 	else if(sub_ind==1)
	RJMP _0xA5
_0x9D:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0xA6
;     855 		{
;     856 		bgnd_par(	"  КАЛИБРОВКИ    ",
;     857  				" Iнагр       .!А"); 
	__POINTW1FN _0,218
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0,252
	CALL SUBOPT_0x1B
;     858  		if(nakal_cnt==0)sub_bgnd("ВЫКЛ.",'!',-3);
	BRNE _0xA7
	__POINTW1FN _0,127
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1C
;     859  		else if(nakal_cnt<200)sub_bgnd("ОСТЫВ.",'!',-4);
	RJMP _0xA8
_0xA7:
	LDS  R26,_nakal_cnt
	LDS  R27,_nakal_cnt+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRGE _0xA9
	__POINTW1FN _0,56
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1D
;     860  		else if((nakal_cnt>=200)&&(nakal_cnt<600))int2lcd(In,'!',1);				
	RJMP _0xAA
_0xA9:
	LDS  R26,_nakal_cnt
	LDS  R27,_nakal_cnt+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLT _0xAC
	CPI  R26,LOW(0x258)
	LDI  R30,HIGH(0x258)
	CPC  R27,R30
	BRLT _0xAD
_0xAC:
	RJMP _0xAB
_0xAD:
	LDS  R30,_In
	LDS  R31,_In+1
	CALL SUBOPT_0x1A
	CALL _int2lcd
;     861  	    //	int2lcdxy(Ki,0xf0,0);
;     862  		}                          
_0xAB:
_0xAA:
_0xA8:
;     863 	else if(sub_ind==2)
	RJMP _0xAE
_0xA6:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0xAF
;     864 		{
;     865 		bgnd_par(	"  КАЛИБРОВКИ    ",
;     866  				" Выход          ");		
	__POINTW1FN _0,218
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0,184
	ST   -Y,R31
	ST   -Y,R30
	CALL _bgnd_par
;     867 		}		
;     868 
;     869 	}
_0xAF:
_0xAE:
_0xA5:
;     870 			 	
;     871 /*bgnd(mess_Zero);
;     872 int2lcdxy(adc_bank_[0],0x30,0);
;     873 int2lcdxy(adc_bank_[1],0x70,0);
;     874 int2lcdxy(adc_bank_[2],0xb0,0);
;     875 int2lcdxy(adc_bank_[3],0xf0,0); 
;     876 int2lcdxy(adc_bank_[4],0x31,0);
;     877 int2lcdxy(adc_bank_[5],0x71,0);*/
;     878 //int2lcdxy(adc_bank_[5],0xb0,0);
;     879 //int2lcdxy(adc_bank_[6],0xf0,0);		
;     880 /*//int2lcdxy(ind,0x30,0);
;     881 //int2lcdxy(av_,0x70,0);
;     882 //int2lcdxy(but,0xb0,0);
;     883 //	int2lcdxy(temper_cnt1,0xe0,0);
;     884 //	int2lcdxy(St,0x20,0);
;     885 //	int2lcdxy(St1,0x50,0);
;     886 //int2lcdxy(ctrl_stat,0x00,0); 
;     887 /*int2lcdxy(St1,0xf0,0);
;     888 int2lcdxy(St2,0xf1,0);
;     889 int2lcdxy(St,0x20,0);*/
;     890 /*int2lcdxy(K[ist],0x10,0); 
;     891 int2lcdxy(St1,0x21,0);
;     892 int2lcdxy(St2,0x51,0); */
;     893 /*int2lcdxy(u_necc,0xa0,0);   
;     894 int2lcdxy(u_necc,0xa0,0);*/
;     895 //int2lcdxy(cntrl_stat,0x20,0);
;     896 //int2lcdxy(cnt_blok,0x60,0); 
;     897 //int2lcdxy(Ibat_p,0x70,0);
;     898 //int2lcdxy(Ibat_mp,0xB0,0);
;     899 //int2lcdxy(St,0xf0,0);
;     900 
;     901 //int2lcdxy(kb_cnt,0xa0,0);
;     902 
;     903 
;     904 /*
;     905 int2lcdxy(tzas_cnt,0xa0,0);
;     906 int2lcdxy(cntrl_stat,0x20,0);*/
;     907 
;     908 //int2lcdxy(St_[1],0xf1,0);
;     909 //int2lcdxy(St_[0],0xf0,0);
;     910 
;     911 //int2lcdxy(OFFBP1,0x10,0);
;     912 //int2lcdxy(cnt_av_umin[0],0x30,0);
;     913 //int2lcdxy(cnt_ubat,0xf0,0); 
;     914 //int2lcdxy(cnt_ibat,0xc0,0); 
;     915 
;     916 //int2lcdxy(av_rele,0x20,0);
;     917 //int2lcdxy(av_beep,0x50,0);
;     918 //int2lcdxy(hour_apv_cnt,0xa0,0); 
;     919 
;     920 //int2lcdxy(main_apv_cnt,0xf0,0);
;     921 //int2lcdxy(hour_apv_cnt,0xd0,0);
;     922 
;     923 
;     924 //int2lcdxy(sub_ind,0x20,0);
;     925 
;     926 //int2lcdxy(OFFBP2,0xf0,0);
;     927 //int2lcdxy(OFFBP1,0xe0,0);
;     928 //int2lcdxy(St_[1],0xc0,0);
;     929 //int2lcdxy(St_[0],0x90,0);
;     930 //int2lcdxy(tzas_cnt,0x60,0);
;     931 //int2lcdxy(num_necc,0x30,0);
;     932 //int2lcdxy(adc_bank_[0],0x21,0); 
;     933 
;     934 /**/
;     935 /*int2lcdxy(reset_apv_cnt,0xf0,0);
;     936 int2lcdxy(main_apv_cnt,0x20,0);
;     937 int2lcdxy(apv_cnt_1,0x70,0);
;     938 int2lcdxy(hour_apv_cnt,0x21,0);*/
;     939 
;     940 /*int2lcdxy(cntrl_stat1,0x30,0);
;     941 int2lcdxy(cntrl_stat2,0x31,0);
;     942 int2lcdxy(Is[1],0xf1,0);
;     943 int2lcdxy(Is[0],0xf0,0); */
;     944 ruslcd(lcd_buffer);
_0x9C:
_0x9B:
_0x82:
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _ruslcd
;     945 }
	CALL __LOADLOCR3
	ADIW R28,25
	RET
;     946 
;     947 
;     948 // Константы состояния кнопок
;     949 #define butL 		0b10111111
;     950 #define butR 		0b01111111
;     951 #define butU 		0b11101111
;     952 #define butD 		0b11011111
;     953 #define butE   	0b11110111
;     954 #define butL_ 		0b10111110
;     955 #define butR_ 		0b01111110
;     956 #define butU_ 		0b11101110
;     957 #define butD_ 		0b11011110
;     958 #define butE_   	0b11110110
;     959 #define butLR 		0b00111111 
;     960 #define butLR_ 	0b00111110
;     961 #define butUD 		0b11001111
;     962 #define butS 		0b11111101
;     963 
;     964 
;     965 //-----------------------------------------------
;     966 // Подпрограмма драйва до 7 кнопок одного порта, 
;     967 // различает короткое и длинное нажатие,
;     968 // срабатывает на отпускание кнопки, возможность
;     969 // ускорения перебора при длинном нажатии...
;     970 #define but_port PORTB
;     971 #define but_dir  DDRB
;     972 #define but_pin  PINB
;     973 #define but_mask 0b00000111
;     974 #define no_but   0b11111111
;     975 #define but_on   10
;     976 #define but_onL  10
;     977 
;     978 static char but_n;

	.DSEG
_but_n_G1:
	.BYTE 0x1
;     979 static char but_s;
_but_s_G1:
	.BYTE 0x1
;     980 static char but0_cnt;
_but0_cnt_G1:
	.BYTE 0x1
;     981 static char but1_cnt;
_but1_cnt_G1:
	.BYTE 0x1
;     982 static char but_onL_temp;
_but_onL_temp_G1:
	.BYTE 0x1
;     983 
;     984 
;     985 void but_drv(void)
;     986 { 

	.CSEG
_but_drv:
;     987 
;     988 DDRC.1=0;
	CBI  0x14,1
;     989 PORTC.1=1;
	SBI  0x15,1
;     990 
;     991 but_port|=(but_mask^0xff);
	CALL SUBOPT_0x1E
;     992 but_dir/*&=but_mask*/=0b00100110;
	LDI  R30,LOW(38)
	OUT  0x17,R30
;     993 #asm
;     994 nop
nop
;     995 nop
nop
;     996 nop
nop
;     997 nop
nop
;     998 #endasm

;     999 
;    1000 but_n=but_pin|but_mask; 
	IN   R30,0x16
	ORI  R30,LOW(0x7)
	STS  _but_n_G1,R30
;    1001 
;    1002 but_port|=(but_mask^0xff);
	CALL SUBOPT_0x1E
;    1003 but_dir/*&=but_mask*/=0b11011110;
	LDI  R30,LOW(222)
	OUT  0x17,R30
;    1004 #asm
;    1005 nop
nop
;    1006 nop
nop
;    1007 nop
nop
;    1008 nop
nop
;    1009 #endasm

;    1010 
;    1011 but_n&=(but_pin|0b11011111); 
	IN   R30,0x16
	ORI  R30,LOW(0xDF)
	LDS  R26,_but_n_G1
	AND  R30,R26
	STS  _but_n_G1,R30
;    1012 
;    1013 if(!PINC.1)but_n&=0b11111101;
	SBIC 0x13,1
	RJMP _0xB0
	LDS  R30,_but_n_G1
	ANDI R30,0xFD
	STS  _but_n_G1,R30
;    1014 
;    1015 //plazma=but_pin;
;    1016 
;    1017 if((but_n==no_but)||(but_n!=but_s))
_0xB0:
	LDS  R26,_but_n_G1
	CPI  R26,LOW(0xFF)
	BREQ _0xB2
	CALL SUBOPT_0x1F
	BREQ _0xB1
_0xB2:
;    1018  	{
;    1019  	speed=0;
	CLT
	BLD  R2,7
;    1020    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0xA)
	BRSH _0xB5
	LDS  R26,_but1_cnt_G1
	CPI  R26,LOW(0x0)
	BREQ _0xB7
_0xB5:
	SBRS R2,5
	RJMP _0xB8
_0xB7:
	RJMP _0xB4
_0xB8:
;    1021   		{
;    1022    	     n_but=1;
	SET
	BLD  R2,6
;    1023           but=but_s;
	LDS  R7,_but_s_G1
;    1024           }
;    1025    	if (but1_cnt>=but_onL_temp)
_0xB4:
	CALL SUBOPT_0x20
	BRLO _0xB9
;    1026   		{
;    1027    	     n_but=1;
	SET
	BLD  R2,6
;    1028           but=but_s&0b11111110;
	CALL SUBOPT_0x21
;    1029           }
;    1030     	l_but=0;
_0xB9:
	CLT
	BLD  R2,5
;    1031    	but_onL_temp=but_onL;
	LDI  R30,LOW(10)
	STS  _but_onL_temp_G1,R30
;    1032     	but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    1033   	but1_cnt=0;          
	STS  _but1_cnt_G1,R30
;    1034      goto but_drv_out;
	RJMP _0xBA
;    1035   	}  
;    1036   	
;    1037 if(but_n==but_s)
_0xB1:
	CALL SUBOPT_0x1F
	BRNE _0xBB
;    1038  	{
;    1039   	but0_cnt++;
	LDS  R30,_but0_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but0_cnt_G1,R30
;    1040   	if(but0_cnt>=but_on)
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0xA)
	BRLO _0xBC
;    1041   		{
;    1042    		but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    1043    		but1_cnt++;
	LDS  R30,_but1_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but1_cnt_G1,R30
;    1044    		if(but1_cnt>=but_onL_temp)
	CALL SUBOPT_0x20
	BRLO _0xBD
;    1045    			{              
;    1046     			but=but_s&0b11111110;
	CALL SUBOPT_0x21
;    1047     			but1_cnt=0;
	LDI  R30,LOW(0)
	STS  _but1_cnt_G1,R30
;    1048     			n_but=1;
	SET
	BLD  R2,6
;    1049     			l_but=1;
	SET
	BLD  R2,5
;    1050 			if(speed)
	SBRS R2,7
	RJMP _0xBE
;    1051 				{
;    1052     				but_onL_temp=but_onL_temp>>1;
	LDS  R30,_but_onL_temp_G1
	LSR  R30
	STS  _but_onL_temp_G1,R30
;    1053         			if(but_onL_temp<=2) but_onL_temp=2;
	LDS  R26,_but_onL_temp_G1
	LDI  R30,LOW(2)
	CP   R30,R26
	BRLO _0xBF
	STS  _but_onL_temp_G1,R30
;    1054 				}    
_0xBF:
;    1055    			}
_0xBE:
;    1056   		} 
_0xBD:
;    1057  	}
_0xBC:
;    1058 but_drv_out:
_0xBB:
_0xBA:
;    1059 but_s=but_n;
	LDS  R30,_but_n_G1
	STS  _but_s_G1,R30
;    1060 but_port|=(but_mask^0xff);
	CALL SUBOPT_0x1E
;    1061 but_dir&=but_mask;
	IN   R30,0x17
	ANDI R30,LOW(0x7)
	OUT  0x17,R30
;    1062 } 
	RET
;    1063 
;    1064 //-----------------------------------------------
;    1065 void but_an(void)
;    1066 {
_but_an:
;    1067 char temp;
;    1068 int tempU;
;    1069 
;    1070 if (!n_but) goto but_an_end;
	CALL __SAVELOCR3
;	temp -> R16
;	tempU -> R17,R18
	SBRS R2,6
	RJMP _0xC1
;    1071    
;    1072 if (ind==iMn)
	TST  R6
	BRNE _0xC2
;    1073 	{
;    1074 	if(but==butD_)
	LDI  R30,LOW(222)
	CP   R30,R7
	BRNE _0xC3
;    1075 		{
;    1076 		ind=iSet;
	LDI  R30,LOW(3)
	MOV  R6,R30
;    1077 		sub_ind=0;
	CLR  R10
;    1078 		wrk_state=wsSTOP;
	CALL SUBOPT_0x3
;    1079 		wrk_cnt=0;
;    1080 		}
;    1081 		
;    1082 	if(but==butS)
_0xC3:
	LDI  R30,LOW(253)
	CP   R30,R7
	BRNE _0xC4
;    1083 		{
;    1084 		if(wrk_state==wsSTOP)
	LDS  R30,_wrk_state
	CPI  R30,0
	BRNE _0xC5
;    1085 			{
;    1086 			wrk_state=wsNAGREV;
	CALL SUBOPT_0x2
;    1087 			wrk_cnt=ee_nagrev_time;
;    1088 			}
;    1089 		else wrk_state=wsSTOP; 	
	RJMP _0xC6
_0xC5:
	LDI  R30,LOW(0)
	STS  _wrk_state,R30
_0xC6:
;    1090 		}
;    1091 		
;    1092 	}
_0xC4:
;    1093 else if(ind==iSet)
	RJMP _0xC7
_0xC2:
	LDI  R30,LOW(3)
	CP   R30,R6
	BREQ PC+3
	JMP _0xC8
;    1094 	{
;    1095 	if(sub_ind==0)
	TST  R10
	BRNE _0xC9
;    1096 		{
;    1097 		if(but==butR)ee_mode=emAVT;
	LDI  R30,LOW(127)
	CP   R30,R7
	BRNE _0xCA
	LDI  R30,LOW(170)
	LDI  R26,LOW(_ee_mode)
	LDI  R27,HIGH(_ee_mode)
	CALL __EEPROMWRB
;    1098 		else if(but==butL)ee_mode=emMNL;
	RJMP _0xCB
_0xCA:
	LDI  R30,LOW(191)
	CP   R30,R7
	BRNE _0xCC
	LDI  R30,LOW(85)
	LDI  R26,LOW(_ee_mode)
	LDI  R27,HIGH(_ee_mode)
	CALL __EEPROMWRB
;    1099 		else if(but==butE)
	RJMP _0xCD
_0xCC:
	LDI  R30,LOW(247)
	CP   R30,R7
	BRNE _0xCE
;    1100 			{
;    1101 			if(ee_mode==emMNL)ee_mode=emAVT;
	LDI  R26,LOW(_ee_mode)
	LDI  R27,HIGH(_ee_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0xCF
	LDI  R30,LOW(170)
	RJMP _0x16B
;    1102 			else ee_mode=emMNL;
_0xCF:
	LDI  R30,LOW(85)
_0x16B:
	LDI  R26,LOW(_ee_mode)
	LDI  R27,HIGH(_ee_mode)
	CALL __EEPROMWRB
;    1103 			}
;    1104 		else if(but==butD)
	RJMP _0xD1
_0xCE:
	LDI  R30,LOW(223)
	CP   R30,R7
	BRNE _0xD2
;    1105 			{
;    1106 			sub_ind=1;
	LDI  R30,LOW(1)
	MOV  R10,R30
;    1107 			}
;    1108 		}
_0xD2:
_0xD1:
_0xCD:
_0xCB:
;    1109 	else if(sub_ind==1)
	RJMP _0xD3
_0xC9:
	LDI  R30,LOW(1)
	CP   R30,R10
	BREQ PC+3
	JMP _0xD4
;    1110 		{
;    1111 		if((but==butR)||(but==butR_))
	LDI  R30,LOW(127)
	CP   R30,R7
	BREQ _0xD6
	LDI  R30,LOW(126)
	CP   R30,R7
	BRNE _0xD5
_0xD6:
;    1112 			{
;    1113 			speed=1;
	SET
	BLD  R2,7
;    1114 			if(!nakal_cnt)nakal_cnt=600;
	LDS  R30,_nakal_cnt
	LDS  R31,_nakal_cnt+1
	SBIW R30,0
	BRNE _0xD8
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	STS  _nakal_cnt,R30
	STS  _nakal_cnt+1,R31
;    1115 			else if((nakal_cnt>=200)&&(nakal_cnt<600))
	RJMP _0xD9
_0xD8:
	LDS  R26,_nakal_cnt
	LDS  R27,_nakal_cnt+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLT _0xDB
	CPI  R26,LOW(0x258)
	LDI  R30,HIGH(0x258)
	CPC  R27,R30
	BRLT _0xDC
_0xDB:
	RJMP _0xDA
_0xDC:
;    1116 				{
;    1117 				ee_pwm++;
	LDI  R26,LOW(_ee_pwm)
	LDI  R27,HIGH(_ee_pwm)
	CALL __EEPROMRDB
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
;    1118 				
;    1119 				//gran_char_ee(&ee_pwm,5,250);
;    1120 				}
;    1121 			}
_0xDA:
_0xD9:
;    1122 		else if((but==butL)||(but==butL_))
	RJMP _0xDD
_0xD5:
	LDI  R30,LOW(191)
	CP   R30,R7
	BREQ _0xDF
	LDI  R30,LOW(190)
	CP   R30,R7
	BRNE _0xDE
_0xDF:
;    1123 			{
;    1124 			speed=1;
	SET
	BLD  R2,7
;    1125 			if(!nakal_cnt)nakal_cnt=600;
	LDS  R30,_nakal_cnt
	LDS  R31,_nakal_cnt+1
	SBIW R30,0
	BRNE _0xE1
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	STS  _nakal_cnt,R30
	STS  _nakal_cnt+1,R31
;    1126 			else if((nakal_cnt>=200)&&(nakal_cnt<600))
	RJMP _0xE2
_0xE1:
	LDS  R26,_nakal_cnt
	LDS  R27,_nakal_cnt+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLT _0xE4
	CPI  R26,LOW(0x258)
	LDI  R30,HIGH(0x258)
	CPC  R27,R30
	BRLT _0xE5
_0xE4:
	RJMP _0xE3
_0xE5:
;    1127 				{
;    1128 				ee_pwm--;
	LDI  R26,LOW(_ee_pwm)
	LDI  R27,HIGH(_ee_pwm)
	CALL __EEPROMRDB
	SUBI R30,LOW(1)
	CALL __EEPROMWRB
	SUBI R30,-LOW(1)
;    1129 				//gran_char_ee(&ee_pwm,5,250);
;    1130 				}
;    1131 			}
_0xE3:
_0xE2:
;    1132 		else if(but==butU)
	RJMP _0xE6
_0xDE:
	LDI  R30,LOW(239)
	CP   R30,R7
	BRNE _0xE7
;    1133 			{
;    1134 			sub_ind=0;
	CLR  R10
;    1135 			nakal_cnt=0;
	LDI  R30,0
	STS  _nakal_cnt,R30
	STS  _nakal_cnt+1,R30
;    1136 			}			
;    1137 		else if(but==butD)
	RJMP _0xE8
_0xE7:
	LDI  R30,LOW(223)
	CP   R30,R7
	BRNE _0xE9
;    1138 			{
;    1139 			sub_ind=2;
	LDI  R30,LOW(2)
	MOV  R10,R30
;    1140 			nakal_cnt=0;
	LDI  R30,0
	STS  _nakal_cnt,R30
	STS  _nakal_cnt+1,R30
;    1141 			}
;    1142 		if(ee_pwm>250)ee_pwm=250;
_0xE9:
_0xE8:
_0xE6:
_0xDD:
	LDI  R26,LOW(_ee_pwm)
	LDI  R27,HIGH(_ee_pwm)
	CALL __EEPROMRDB
	MOV  R26,R30
	LDI  R30,LOW(250)
	CP   R30,R26
	BRSH _0xEA
	LDI  R26,LOW(_ee_pwm)
	LDI  R27,HIGH(_ee_pwm)
	CALL __EEPROMWRB
;    1143 		if(ee_pwm<5)ee_pwm=5;		
_0xEA:
	LDI  R26,LOW(_ee_pwm)
	LDI  R27,HIGH(_ee_pwm)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x5)
	BRSH _0xEB
	LDI  R30,LOW(5)
	LDI  R26,LOW(_ee_pwm)
	LDI  R27,HIGH(_ee_pwm)
	CALL __EEPROMWRB
;    1144 		}
_0xEB:
;    1145 			
;    1146 	else if(sub_ind==2)
	RJMP _0xEC
_0xD4:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0xED
;    1147 		{
;    1148 		if((but==butR)||(but==butR_))
	LDI  R30,LOW(127)
	CP   R30,R7
	BREQ _0xEF
	LDI  R30,LOW(126)
	CP   R30,R7
	BRNE _0xEE
_0xEF:
;    1149 			{
;    1150 			speed=1;
	SET
	BLD  R2,7
;    1151 			ee_nagrev_time++;
	LDI  R26,LOW(_ee_nagrev_time)
	LDI  R27,HIGH(_ee_nagrev_time)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    1152 			gran_ee(&ee_nagrev_time,10,1000);
	CALL SUBOPT_0x22
;    1153 			}
;    1154 		else if((but==butL)||(but==butL_))
	RJMP _0xF1
_0xEE:
	LDI  R30,LOW(191)
	CP   R30,R7
	BREQ _0xF3
	LDI  R30,LOW(190)
	CP   R30,R7
	BRNE _0xF2
_0xF3:
;    1155 			{
;    1156 			speed=1;
	SET
	BLD  R2,7
;    1157 			ee_nagrev_time--;
	LDI  R26,LOW(_ee_nagrev_time)
	LDI  R27,HIGH(_ee_nagrev_time)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    1158 			gran_ee(&ee_nagrev_time,10,1000);
	CALL SUBOPT_0x22
;    1159 			}
;    1160 		else if(but==butD)
	RJMP _0xF5
_0xF2:
	LDI  R30,LOW(223)
	CP   R30,R7
	BRNE _0xF6
;    1161 			{
;    1162 			sub_ind=3;
	LDI  R30,LOW(3)
	MOV  R10,R30
;    1163 			}
;    1164 		else if(but==butU)
	RJMP _0xF7
_0xF6:
	LDI  R30,LOW(239)
	CP   R30,R7
	BRNE _0xF8
;    1165 			{
;    1166 			sub_ind=1;
	LDI  R30,LOW(1)
	MOV  R10,R30
;    1167 			}					
;    1168 		}		
_0xF8:
_0xF7:
_0xF5:
_0xF1:
;    1169 	else if(sub_ind==3)
	RJMP _0xF9
_0xED:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0xFA
;    1170 		{
;    1171 		if((but==butR)||(but==butR_))
	LDI  R30,LOW(127)
	CP   R30,R7
	BREQ _0xFC
	LDI  R30,LOW(126)
	CP   R30,R7
	BRNE _0xFB
_0xFC:
;    1172 			{
;    1173 			speed=1;
	SET
	BLD  R2,7
;    1174 			ee_wrk_time++;
	LDI  R26,LOW(_ee_wrk_time)
	LDI  R27,HIGH(_ee_wrk_time)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    1175 			gran_ee(&ee_wrk_time,10,1000);
	CALL SUBOPT_0x23
;    1176 			}
;    1177 		else if((but==butL)||(but==butL_))
	RJMP _0xFE
_0xFB:
	LDI  R30,LOW(191)
	CP   R30,R7
	BREQ _0x100
	LDI  R30,LOW(190)
	CP   R30,R7
	BRNE _0xFF
_0x100:
;    1178 			{
;    1179 			speed=1;
	SET
	BLD  R2,7
;    1180 			ee_wrk_time--;
	LDI  R26,LOW(_ee_wrk_time)
	LDI  R27,HIGH(_ee_wrk_time)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    1181 			gran_ee(&ee_wrk_time,10,1000);
	CALL SUBOPT_0x23
;    1182 			}
;    1183 		else if(but==butD)
	RJMP _0x102
_0xFF:
	LDI  R30,LOW(223)
	CP   R30,R7
	BRNE _0x103
;    1184 			{
;    1185 			sub_ind=4;
	LDI  R30,LOW(4)
	MOV  R10,R30
;    1186 			}
;    1187 		else if(but==butU)
	RJMP _0x104
_0x103:
	LDI  R30,LOW(239)
	CP   R30,R7
	BRNE _0x105
;    1188 			{
;    1189 			sub_ind=2;
	LDI  R30,LOW(2)
	MOV  R10,R30
;    1190 			}					
;    1191 		}
_0x105:
_0x104:
_0x102:
_0xFE:
;    1192 	else if(sub_ind==4)
	RJMP _0x106
_0xFA:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0x107
;    1193 		{
;    1194 		if((but==butR)||(but==butR_))
	LDI  R30,LOW(127)
	CP   R30,R7
	BREQ _0x109
	LDI  R30,LOW(126)
	CP   R30,R7
	BRNE _0x108
_0x109:
;    1195 			{
;    1196 			speed=1;
	SET
	BLD  R2,7
;    1197 			ee_ostiv_time++;
	LDI  R26,LOW(_ee_ostiv_time)
	LDI  R27,HIGH(_ee_ostiv_time)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    1198 			gran_ee(&ee_ostiv_time,10,1000);
	CALL SUBOPT_0x24
;    1199 			}
;    1200 		else if((but==butL)||(but==butL_))
	RJMP _0x10B
_0x108:
	LDI  R30,LOW(191)
	CP   R30,R7
	BREQ _0x10D
	LDI  R30,LOW(190)
	CP   R30,R7
	BRNE _0x10C
_0x10D:
;    1201 			{
;    1202 			speed=1;
	SET
	BLD  R2,7
;    1203 			ee_ostiv_time--;
	LDI  R26,LOW(_ee_ostiv_time)
	LDI  R27,HIGH(_ee_ostiv_time)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    1204 			gran_ee(&ee_ostiv_time,10,1000);
	CALL SUBOPT_0x24
;    1205 			}
;    1206 		else if(but==butD)
	RJMP _0x10F
_0x10C:
	LDI  R30,LOW(223)
	CP   R30,R7
	BRNE _0x110
;    1207 			{
;    1208 			sub_ind=5;
	LDI  R30,LOW(5)
	MOV  R10,R30
;    1209 			}
;    1210 		else if(but==butU)
	RJMP _0x111
_0x110:
	LDI  R30,LOW(239)
	CP   R30,R7
	BRNE _0x112
;    1211 			{
;    1212 			sub_ind=3;
	LDI  R30,LOW(3)
	MOV  R10,R30
;    1213 			}					
;    1214 		}			  
_0x112:
_0x111:
_0x10F:
_0x10B:
;    1215 	else if(sub_ind==5)
	RJMP _0x113
_0x107:
	LDI  R30,LOW(5)
	CP   R30,R10
	BRNE _0x114
;    1216 		{
;    1217 		if(but==butE)
	LDI  R30,LOW(247)
	CP   R30,R7
	BRNE _0x115
;    1218 			{
;    1219 			ind=iMn;
	CALL SUBOPT_0x25
;    1220 			sub_ind=0;
;    1221 			nakal_cnt=0;
;    1222 			wrk_state=wsSTOP;			
;    1223 			}
;    1224 		else if(but==butD)
	RJMP _0x116
_0x115:
	LDI  R30,LOW(223)
	CP   R30,R7
	BRNE _0x117
;    1225 			{
;    1226 			sub_ind=6;
	LDI  R30,LOW(6)
	MOV  R10,R30
;    1227 			}
;    1228 		else if(but==butU)
	RJMP _0x118
_0x117:
	LDI  R30,LOW(239)
	CP   R30,R7
	BRNE _0x119
;    1229 			{
;    1230 			sub_ind=4;
	LDI  R30,LOW(4)
	MOV  R10,R30
;    1231 			}					
;    1232 		}
_0x119:
_0x118:
_0x116:
;    1233 	else if(sub_ind==6)
	RJMP _0x11A
_0x114:
	LDI  R30,LOW(6)
	CP   R30,R10
	BRNE _0x11B
;    1234 		{
;    1235 		if(but==butE)
	LDI  R30,LOW(247)
	CP   R30,R7
	BRNE _0x11C
;    1236 			{
;    1237 			ind=iK;
	LDI  R30,LOW(10)
	MOV  R6,R30
;    1238 			sub_ind=0;
	CLR  R10
;    1239 			nakal_cnt=0;
	LDI  R30,0
	STS  _nakal_cnt,R30
	STS  _nakal_cnt+1,R30
;    1240 			}
;    1241 		else if(but==butU)
	RJMP _0x11D
_0x11C:
	LDI  R30,LOW(239)
	CP   R30,R7
	BRNE _0x11E
;    1242 			{
;    1243 			sub_ind=5;
	LDI  R30,LOW(5)
	MOV  R10,R30
;    1244 			}	
;    1245 		}														
_0x11E:
_0x11D:
;    1246 	}
_0x11B:
_0x11A:
_0x113:
_0x106:
_0xF9:
_0xEC:
_0xD3:
;    1247 	
;    1248 else if(ind==iK)
	RJMP _0x11F
_0xC8:
	LDI  R30,LOW(10)
	CP   R30,R6
	BREQ PC+3
	JMP _0x120
;    1249 	{
;    1250 	if(sub_ind==0)
	TST  R10
	BREQ PC+3
	JMP _0x121
;    1251 		{
;    1252 		if((but==butR)||(but==butR_))
	LDI  R30,LOW(127)
	CP   R30,R7
	BREQ _0x123
	LDI  R30,LOW(126)
	CP   R30,R7
	BRNE _0x122
_0x123:
;    1253 			{
;    1254 			speed=1;              
	SET
	BLD  R2,7
;    1255 			if(!nakal_cnt)nakal_cnt=600;
	LDS  R30,_nakal_cnt
	LDS  R31,_nakal_cnt+1
	SBIW R30,0
	BRNE _0x125
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	STS  _nakal_cnt,R30
	STS  _nakal_cnt+1,R31
;    1256 			else if((nakal_cnt>=200)&&(nakal_cnt<600))
	RJMP _0x126
_0x125:
	LDS  R26,_nakal_cnt
	LDS  R27,_nakal_cnt+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLT _0x128
	CPI  R26,LOW(0x258)
	LDI  R30,HIGH(0x258)
	CPC  R27,R30
	BRLT _0x129
_0x128:
	RJMP _0x127
_0x129:
;    1257 				{
;    1258 				Ku++;
	LDI  R26,LOW(_Ku)
	LDI  R27,HIGH(_Ku)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    1259 				}
;    1260 			gran_ee(&Ku,100,200);
_0x127:
_0x126:
	CALL SUBOPT_0x26
;    1261 			}
;    1262 		else if((but==butL)||(but==butL_))
	RJMP _0x12A
_0x122:
	LDI  R30,LOW(191)
	CP   R30,R7
	BREQ _0x12C
	LDI  R30,LOW(190)
	CP   R30,R7
	BRNE _0x12B
_0x12C:
;    1263 			{
;    1264 			speed=1;                    
	SET
	BLD  R2,7
;    1265 			if(!nakal_cnt)nakal_cnt=600;
	LDS  R30,_nakal_cnt
	LDS  R31,_nakal_cnt+1
	SBIW R30,0
	BRNE _0x12E
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	STS  _nakal_cnt,R30
	STS  _nakal_cnt+1,R31
;    1266 			else if((nakal_cnt>=200)&&(nakal_cnt<600))
	RJMP _0x12F
_0x12E:
	LDS  R26,_nakal_cnt
	LDS  R27,_nakal_cnt+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLT _0x131
	CPI  R26,LOW(0x258)
	LDI  R30,HIGH(0x258)
	CPC  R27,R30
	BRLT _0x132
_0x131:
	RJMP _0x130
_0x132:
;    1267 				{
;    1268 				Ku--;
	LDI  R26,LOW(_Ku)
	LDI  R27,HIGH(_Ku)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    1269 				}
;    1270 			gran_ee(&Ku,100,200);
_0x130:
_0x12F:
	CALL SUBOPT_0x26
;    1271 			}
;    1272 		else if(but==butD)
	RJMP _0x133
_0x12B:
	LDI  R30,LOW(223)
	CP   R30,R7
	BRNE _0x134
;    1273 			{
;    1274 			sub_ind=1;
	LDI  R30,LOW(1)
	MOV  R10,R30
;    1275 			}
;    1276 		}
_0x134:
_0x133:
_0x12A:
;    1277 	else if(sub_ind==1)
	RJMP _0x135
_0x121:
	LDI  R30,LOW(1)
	CP   R30,R10
	BREQ PC+3
	JMP _0x136
;    1278 		{
;    1279 		if((but==butR)||(but==butR_))
	LDI  R30,LOW(127)
	CP   R30,R7
	BREQ _0x138
	LDI  R30,LOW(126)
	CP   R30,R7
	BRNE _0x137
_0x138:
;    1280 			{
;    1281 			speed=1;                    
	SET
	BLD  R2,7
;    1282 			if(!nakal_cnt)nakal_cnt=600;
	LDS  R30,_nakal_cnt
	LDS  R31,_nakal_cnt+1
	SBIW R30,0
	BRNE _0x13A
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	STS  _nakal_cnt,R30
	STS  _nakal_cnt+1,R31
;    1283 			else if((nakal_cnt>=200)&&(nakal_cnt<600))
	RJMP _0x13B
_0x13A:
	LDS  R26,_nakal_cnt
	LDS  R27,_nakal_cnt+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLT _0x13D
	CPI  R26,LOW(0x258)
	LDI  R30,HIGH(0x258)
	CPC  R27,R30
	BRLT _0x13E
_0x13D:
	RJMP _0x13C
_0x13E:
;    1284 				{
;    1285 				Ki++;
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    1286 				}
;    1287 			gran_ee(&Ki,50,200);
_0x13C:
_0x13B:
	CALL SUBOPT_0x27
;    1288 			}
;    1289 		else if((but==butL)||(but==butL_))
	RJMP _0x13F
_0x137:
	LDI  R30,LOW(191)
	CP   R30,R7
	BREQ _0x141
	LDI  R30,LOW(190)
	CP   R30,R7
	BRNE _0x140
_0x141:
;    1290 			{
;    1291 			speed=1;                    
	SET
	BLD  R2,7
;    1292 			if(!nakal_cnt)nakal_cnt=600;
	LDS  R30,_nakal_cnt
	LDS  R31,_nakal_cnt+1
	SBIW R30,0
	BRNE _0x143
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	STS  _nakal_cnt,R30
	STS  _nakal_cnt+1,R31
;    1293 			else if((nakal_cnt>=200)&&(nakal_cnt<600))
	RJMP _0x144
_0x143:
	LDS  R26,_nakal_cnt
	LDS  R27,_nakal_cnt+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLT _0x146
	CPI  R26,LOW(0x258)
	LDI  R30,HIGH(0x258)
	CPC  R27,R30
	BRLT _0x147
_0x146:
	RJMP _0x145
_0x147:
;    1294 				{
;    1295 				Ki--;
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    1296 				}
;    1297 			gran_ee(&Ki,50,200);
_0x145:
_0x144:
	CALL SUBOPT_0x27
;    1298 			}
;    1299 		else if(but==butD)
	RJMP _0x148
_0x140:
	LDI  R30,LOW(223)
	CP   R30,R7
	BRNE _0x149
;    1300 			{
;    1301 			sub_ind=2;
	LDI  R30,LOW(2)
	MOV  R10,R30
;    1302 			}
;    1303 		else if(but==butU)
	RJMP _0x14A
_0x149:
	LDI  R30,LOW(239)
	CP   R30,R7
	BRNE _0x14B
;    1304 			{
;    1305 			sub_ind=0;
	CLR  R10
;    1306 			}	    
;    1307 		}		 		                         
_0x14B:
_0x14A:
_0x148:
_0x13F:
;    1308 	else if(sub_ind==2)
	RJMP _0x14C
_0x136:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x14D
;    1309 		{
;    1310 		if(but==butE)
	LDI  R30,LOW(247)
	CP   R30,R7
	BRNE _0x14E
;    1311 			{
;    1312 			ind=iMn;
	CALL SUBOPT_0x25
;    1313 			sub_ind=0;
;    1314 			nakal_cnt=0;
;    1315 			wrk_state=wsSTOP;			
;    1316 			}
;    1317 		else if(but==butU)
	RJMP _0x14F
_0x14E:
	LDI  R30,LOW(239)
	CP   R30,R7
	BRNE _0x150
;    1318 			{
;    1319 			sub_ind=1;
	LDI  R30,LOW(1)
	MOV  R10,R30
;    1320 			}	  					
;    1321 		}		
_0x150:
_0x14F:
;    1322 
;    1323 	}		  			  				
_0x14D:
_0x14C:
_0x135:
;    1324 but_an_end:
_0x120:
_0x11F:
_0xC7:
_0xC1:
;    1325 n_but=0;           
	CLT
	BLD  R2,6
;    1326 }	   
	CALL __LOADLOCR3
	ADIW R28,3
	RET
;    1327 
;    1328 
;    1329 //***********************************************
;    1330 //***********************************************
;    1331 //***********************************************
;    1332 //***********************************************
;    1333 //***********************************************
;    1334 
;    1335 
;    1336 //***********************************************
;    1337 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;    1338 {
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;    1339 static char t0cnt0,t0cnt1,t0cnt2,t0cnt3,t0cnt4,/*t0cnt5,*/t0cnt6;

	.DSEG
_t0cnt0_S21:
	.BYTE 0x1
_t0cnt1_S21:
	.BYTE 0x1
_t0cnt2_S21:
	.BYTE 0x1
_t0cnt3_S21:
	.BYTE 0x1
_t0cnt4_S21:
	.BYTE 0x1
_t0cnt6_S21:
	.BYTE 0x1

	.CSEG
;    1340 char temp;
;    1341 
;    1342 TCNT0=-208; 
	ST   -Y,R16
;	temp -> R16
	LDI  R30,LOW(65328)
	LDI  R31,HIGH(65328)
	OUT  0x32,R30
;    1343 
;    1344 #ifdef MIKRAN
;    1345 bFF=PINB.0;
;    1346 if(bFF!=bFF_)
;    1347 	{
;    1348 	Hz_out++;
;    1349 	}        
;    1350 bFF_=bFF;    
;    1351 #endif
;    1352 
;    1353 if(++t0cnt0_>=6)
	LDS  R26,_t0cnt0_
	SUBI R26,-LOW(1)
	STS  _t0cnt0_,R26
	CPI  R26,LOW(0x6)
	BRLO _0x151
;    1354 	{
;    1355 	t0cnt0_=0;
	LDI  R30,LOW(0)
	STS  _t0cnt0_,R30
;    1356 	}
;    1357 else goto timer1_ovf_isr_end;
	RJMP _0x152
_0x151:
	RJMP _0x153
_0x152:
;    1358 
;    1359 
;    1360 
;    1361 b100Hz=1;
	SET
	BLD  R2,0
;    1362 
;    1363 Hz_cnt++;
	LDS  R30,_Hz_cnt
	LDS  R31,_Hz_cnt+1
	ADIW R30,1
	STS  _Hz_cnt,R30
	STS  _Hz_cnt+1,R31
;    1364 if(Hz_cnt>=978)
	LDS  R26,_Hz_cnt
	LDS  R27,_Hz_cnt+1
	CPI  R26,LOW(0x3D2)
	LDI  R30,HIGH(0x3D2)
	CPC  R27,R30
	BRLT _0x154
;    1365 	{	
;    1366 	Hz_cnt=0;
	LDI  R30,0
	STS  _Hz_cnt,R30
	STS  _Hz_cnt+1,R30
;    1367 	Fnet=Hz_out/2;
	LDS  R30,_Hz_out
	LDS  R31,_Hz_out+1
	ASR  R31
	ROR  R30
	STS  _Fnet,R30
	STS  _Fnet+1,R31
;    1368 	Hz_out=0;
	LDI  R30,0
	STS  _Hz_out,R30
	STS  _Hz_out+1,R30
;    1369 	}
;    1370 
;    1371 
;    1372 #ifdef _CAN_
;    1373 CANst=spi_read_status();
;    1374 if(CANst)
;    1375 	{
;    1376 	bCAN=1;
;    1377 	}  
;    1378 #endif
;    1379 
;    1380 if(++t0cnt0>=10)
_0x154:
	LDS  R26,_t0cnt0_S21
	SUBI R26,-LOW(1)
	STS  _t0cnt0_S21,R26
	CPI  R26,LOW(0xA)
	BRLO _0x155
;    1381 	{
;    1382 	t0cnt0=0;
	LDI  R30,LOW(0)
	STS  _t0cnt0_S21,R30
;    1383 	b10Hz=1;
	SET
	BLD  R2,1
;    1384 	}
;    1385 
;    1386 if(++t0cnt1>=20)
_0x155:
	LDS  R26,_t0cnt1_S21
	SUBI R26,-LOW(1)
	STS  _t0cnt1_S21,R26
	CPI  R26,LOW(0x14)
	BRLO _0x156
;    1387 	{
;    1388 	t0cnt1=0;
	LDI  R30,LOW(0)
	STS  _t0cnt1_S21,R30
;    1389 	b5Hz=1;
	SET
	BLD  R2,2
;    1390 	}
;    1391 
;    1392 if(++t0cnt2>=50)
_0x156:
	LDS  R26,_t0cnt2_S21
	SUBI R26,-LOW(1)
	STS  _t0cnt2_S21,R26
	CPI  R26,LOW(0x32)
	BRLO _0x157
;    1393 	{
;    1394 	t0cnt2=0;
	LDI  R30,LOW(0)
	STS  _t0cnt2_S21,R30
;    1395 	b2Hz=1;
	SET
	BLD  R2,3
;    1396 	}         
;    1397 
;    1398 if(++t0cnt3>=100)
_0x157:
	LDS  R26,_t0cnt3_S21
	SUBI R26,-LOW(1)
	STS  _t0cnt3_S21,R26
	CPI  R26,LOW(0x64)
	BRLO _0x158
;    1399 	{
;    1400 	t0cnt3=0;
	LDI  R30,LOW(0)
	STS  _t0cnt3_S21,R30
;    1401 	b1Hz=1;
	SET
	BLD  R2,4
;    1402 	}
;    1403 timer1_ovf_isr_end:
_0x158:
_0x153:
;    1404 }
	LD   R16,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;    1405 
;    1406 //===============================================
;    1407 //===============================================
;    1408 //===============================================
;    1409 //===============================================
;    1410 void main(void)
;    1411 {
_main:
;    1412 char temp_char;
;    1413 int temp_int;
;    1414 
;    1415 PORTA=0x00;
;	temp_char -> R16
;	temp_int -> R17,R18
	LDI  R30,LOW(0)
	OUT  0x1B,R30
;    1416 DDRA=0x00;
	OUT  0x1A,R30
;    1417 
;    1418 PORTB=0x10;
	LDI  R30,LOW(16)
	OUT  0x18,R30
;    1419 DDRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x17,R30
;    1420 
;    1421 PORTC=0x00;
	OUT  0x15,R30
;    1422 DDRC=0x00;
	OUT  0x14,R30
;    1423 
;    1424 PORTD=0x00;
	OUT  0x12,R30
;    1425 DDRD=0x30;
	LDI  R30,LOW(48)
	OUT  0x11,R30
;    1426 
;    1427 
;    1428 
;    1429 
;    1430 GICR=0x00;
	LDI  R30,LOW(0)
	OUT  0x3B,R30
;    1431 MCUCR=0x00;
	OUT  0x35,R30
;    1432 MCUCSR=0x00;
	OUT  0x34,R30
;    1433 GIFR=0x00;
	OUT  0x3A,R30
;    1434 
;    1435 
;    1436 
;    1437 // Timer/Counter 0 initialization
;    1438 // Clock source: System Clock
;    1439 // Clock value: 125,000 kHz
;    1440 // Mode: Normal top=FFh
;    1441 // OC0 output: Disconnected
;    1442 TCCR0=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
;    1443 TCNT0=-208;
	LDI  R30,LOW(65328)
	LDI  R31,HIGH(65328)
	OUT  0x32,R30
;    1444 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
;    1445 
;    1446 // Timer/Counter 1 initialization
;    1447 // Clock source: System Clock
;    1448 // Clock value: 8000,000 kHz
;    1449 // Mode: Fast PWM top=03FFh
;    1450 // OC1A output: Non-Inv.
;    1451 // OC1B output: Non-Inv.
;    1452 // Noise Canceler: Off
;    1453 // Input Capture on Falling Edge
;    1454 TCCR1A=0x21;
	LDI  R30,LOW(33)
	OUT  0x2F,R30
;    1455 TCCR1B=0x09;
	LDI  R30,LOW(9)
	OUT  0x2E,R30
;    1456 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
;    1457 TCNT1L=0x00;
	OUT  0x2C,R30
;    1458 ICR1H=0x00;
	OUT  0x27,R30
;    1459 ICR1L=0x00;
	OUT  0x26,R30
;    1460 OCR1B=700;
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	OUT  0x28+1,R31
	OUT  0x28,R30
;    1461 
;    1462 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;    1463 
;    1464 UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
;    1465 UCSRB=0x00;
	OUT  0xA,R30
;    1466 
;    1467 ADMUX=0x00;
	OUT  0x7,R30
;    1468 ADCSR=0x86;
	LDI  R30,LOW(134)
	OUT  0x6,R30
;    1469 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
;    1470 simbol_define();
	CALL _simbol_define
;    1471 
;    1472 #asm("sei")
	sei
;    1473 
;    1474 
;    1475 
;    1476 ind=iMn;
	CLR  R6
;    1477 sub_ind=1;
	LDI  R30,LOW(1)
	MOV  R10,R30
;    1478 sub_ind1=0;
	CLR  R11
;    1479 
;    1480 while (1)
_0x159:
;    1481 	{
;    1482 	#asm("wdr")
	wdr
;    1483  	
;    1484 	if(b100Hz)
	SBRS R2,0
	RJMP _0x15C
;    1485 		{
;    1486 		b100Hz=0; 
	CLT
	BLD  R2,0
;    1487 		
;    1488 		adc_drv();
	CALL _adc_drv
;    1489           but_drv();
	CALL _but_drv
;    1490           but_an();
	CALL _but_an
;    1491   		
;    1492 		}	 
;    1493 	if(b10Hz)
_0x15C:
	SBRS R2,1
	RJMP _0x15D
;    1494 		{
;    1495 		b10Hz=0;
	CLT
	BLD  R2,1
;    1496           
;    1497           ind_hndl();
	CALL _ind_hndl
;    1498 		lcd_out(); 
	CALL _lcd_out
;    1499 		wrk_state_drv();
	CALL _wrk_state_drv
;    1500 		
;    1501 		}	
;    1502 	if(b5Hz)
_0x15D:
	SBRS R2,2
	RJMP _0x15E
;    1503 		{
;    1504 		b5Hz=0;
	CLT
	BLD  R2,2
;    1505 		
;    1506 		ret_ind_hndl();
	CALL _ret_ind_hndl
;    1507 		matemat();
	CALL _matemat
;    1508 		out_out();
	CALL _out_out
;    1509   
;    1510   		}
;    1511 	if(b2Hz)
_0x15E:
	SBRS R2,3
	RJMP _0x15F
;    1512 		{
;    1513 		b2Hz=0;
	CLT
	BLD  R2,3
;    1514 
;    1515 		}								
;    1516 	if(b1Hz)
_0x15F:
	SBRS R2,4
	RJMP _0x160
;    1517 		{
;    1518 		b1Hz=0;
	CLT
	BLD  R2,4
;    1519 		
;    1520 
;    1521 		}
;    1522 			
;    1523      }
_0x160:
	RJMP _0x159
;    1524 }
_0x161:
	RJMP _0x161
_getchar:
     sbis usr,rxc
     rjmp _getchar
     in   r30,udr
	RET
_putchar:
     sbis usr,udre
     rjmp _putchar
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET

	.DSEG
__base_y:
	.BYTE 0x4
	.equ __lcd_direction=__lcd_port-1 
 	.equ __lcd_cntr_direction=__lcd_cntr_port-1
	.equ __lcd_pin=__lcd_port-2
 	.equ __lcd_cntr_pin=__lcd_cntr_port-2
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
__lcd_ready:
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
;    sbi	  __lcd_cntr_direction,__lcd_rs
 ;   sbi	  __lcd_cntr_direction,__lcd_rd
  ;  sbi	  __lcd_cntr_direction,__lcd_en
;    sbi   __lcd_cntr_port,__lcd_rd     ;RD=1
    cbi   __lcd_cntr_port,__lcd_rs     ;RS=0
__lcd_busy:
    rcall __lcd_delay
;    rcall __long_delay
;    sbi   __lcd_cntr_port,__lcd_en ;EN=1
;    rcall __lcd_delay
;    sbic  __lcd_pin,__lcd_busy_flag
;    rjmp  __lcd_busy
;    cbi   __lcd_cntr_port,__lcd_en ;EN=0
	__DELAY_USB 13
	__DELAY_USB 107
	RET
__lcd_write_nibble:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_cntr_port,__lcd_en ;EN=1
    rcall __lcd_delay
    cbi   __lcd_cntr_port,__lcd_en ;EN=0
__lcd_delay:
    nop
    nop
    nop
    nop
    nop
    nop
    ret
__lcd_write_data:
;    cbi  __lcd_cntr_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0                ;set as output
    out   __lcd_direction,r26 
    sbi   __lcd_cntr_direction,__lcd_rs
;    sbi   __lcd_cntr_direction,__lcd_rd
    sbi   __lcd_cntr_direction,__lcd_en
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
    rcall __lcd_write_nibble      ;RD=0, write MSN
    ld    r26,y
    swap  r26
    rcall __lcd_write_nibble      ;write LSN
 ;   sbi   __lcd_cntr_port,__lcd_rd     ;RD=1
	ADIW R28,1
	RET
_lcd_write_byte:
	CALL __lcd_ready
	LDD  R30,Y+1
	CALL SUBOPT_0x28
    sbi   __lcd_cntr_port,__lcd_rs     ;RS=1
	LD   R30,Y
	ST   -Y,R30
	CALL __lcd_write_data
	RJMP _0x164
_lcd_gotoxy:
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y)
	SBCI R31,HIGH(-__base_y)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x164:
	ADIW R28,2
	RET
_lcd_clear:
	CALL __lcd_ready
	__DELAY_USB 107
	LDI  R30,LOW(12)
	CALL SUBOPT_0x28
	__DELAY_USB 107
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R30,R26
	BRSH _0x163
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	ST   -Y,R30
	CALL _lcd_gotoxy
	brts __lcd_putchar0
_0x163:
    rcall __lcd_ready
    sbi  __lcd_cntr_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	ADIW R28,1
	RET
_lcd_puts:
    ldd  r31,y+1
    ld   r30,y
__lcd_puts0:
    ld   r26,z+
    tst  r26
    breq __lcd_puts1
    st   -y,r26    
    rcall _lcd_putchar
    rjmp __lcd_puts0
__lcd_puts1:
	ADIW R28,2
	RET
__long_delay:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
_lcd_init:
    cbi   __lcd_cntr_port,__lcd_en ;EN=0
    cbi   __lcd_cntr_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y,3
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x29
	CALL __long_delay
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x2A
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x2A
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x2A
	CALL _lcd_clear
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	ADIW R28,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x0:
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x1:
	LDS  R30,_wrk_cnt
	LDS  R31,_wrk_cnt+1
	SBIW R30,1
	STS  _wrk_cnt,R30
	STS  _wrk_cnt+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2:
	LDI  R30,LOW(1)
	STS  _wrk_state,R30
	LDI  R26,LOW(_ee_nagrev_time)
	LDI  R27,HIGH(_ee_nagrev_time)
	CALL __EEPROMRDW
	STS  _wrk_cnt,R30
	STS  _wrk_cnt+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3:
	LDI  R30,LOW(0)
	STS  _wrk_state,R30
	LDI  R30,0
	STS  _wrk_cnt,R30
	STS  _wrk_cnt+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x4:
	MOV  R30,R8
	LDI  R26,LOW(_adc_bank)
	LDI  R27,HIGH(_adc_bank)
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5:
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6:
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R17
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7:
	OUT  0x7,R30
	IN   R30,0x30
	ANDI R30,LOW(0x1F)
	OUT  0x30,R30
	LDI  R30,LOW(166)
	OUT  0x6,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x8:
	LDI  R26,LOW(_ee_pwm)
	LDI  R27,HIGH(_ee_pwm)
	CALL __EEPROMRDB
	COM  R30
	LDI  R31,0
	OUT  0x28+1,R31
	OUT  0x28,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x9:
	CALL __CWD1
	__GETD2S 1
	CALL __MULD12
	__PUTD1S 1
	__GETD2S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA:
	CALL __DIVD21
	__PUTD1S 1
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0xB:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_lcd_buffer)
	SBCI R31,HIGH(-_lcd_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xC:
	MOV  R30,R16
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _bin2bcd_int
	LDD  R30,Y+2
	SUBI R30,-LOW(1)
	ST   -Y,R30
	CALL _bcd2lcd_zero
	LDD  R30,Y+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE:
	ST   -Y,R30
	CALL _find
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES
SUBOPT_0xF:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10:
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_lcd_buffer)
	SBCI R27,HIGH(-_lcd_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x11:
	MOV  R30,R16
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_lcd_buffer)
	SBCI R31,HIGH(-_lcd_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x12:
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	LPM  R30,Z
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x13:
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ADIW R30,1
	STD  Y+3,R30
	STD  Y+3+1,R31
	SBIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x14:
	LDS  R30,_ptr_ram
	LDS  R31,_ptr_ram+1
	ADIW R30,1
	STS  _ptr_ram,R30
	STS  _ptr_ram+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x15:
	LDS  R30,_Un
	LDS  R31,_Un+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(33)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _int2lcd

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES
SUBOPT_0x16:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x17:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(36)
	ST   -Y,R30
	LDI  R30,LOW(251)
	ST   -Y,R30
	JMP  _sub_bgnd

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x18:
	LDS  R30,_wrk_cnt
	LDS  R31,_wrk_cnt+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(160)
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES
SUBOPT_0x19:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(33)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x1A:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(33)
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1B:
	ST   -Y,R31
	ST   -Y,R30
	CALL _bgnd_par
	LDS  R30,_nakal_cnt
	LDS  R31,_nakal_cnt+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1C:
	LDI  R30,LOW(253)
	ST   -Y,R30
	JMP  _sub_bgnd

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1D:
	LDI  R30,LOW(252)
	ST   -Y,R30
	JMP  _sub_bgnd

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x1E:
	IN   R30,0x18
	ORI  R30,LOW(0xF8)
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1F:
	LDS  R30,_but_s_G1
	LDS  R26,_but_n_G1
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x20:
	LDS  R30,_but_onL_temp_G1
	LDS  R26,_but1_cnt_G1
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x21:
	LDS  R30,_but_s_G1
	ANDI R30,0xFE
	MOV  R7,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x22:
	LDI  R30,LOW(_ee_nagrev_time)
	LDI  R31,HIGH(_ee_nagrev_time)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _gran_ee

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x23:
	LDI  R30,LOW(_ee_wrk_time)
	LDI  R31,HIGH(_ee_wrk_time)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _gran_ee

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x24:
	LDI  R30,LOW(_ee_ostiv_time)
	LDI  R31,HIGH(_ee_ostiv_time)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _gran_ee

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x25:
	CLR  R6
	CLR  R10
	LDI  R30,0
	STS  _nakal_cnt,R30
	STS  _nakal_cnt+1,R30
	LDI  R30,LOW(0)
	STS  _wrk_state,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x26:
	LDI  R30,LOW(_Ku)
	LDI  R31,HIGH(_Ku)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _gran_ee

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x27:
	LDI  R30,LOW(_Ki)
	LDI  R31,HIGH(_Ki)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _gran_ee

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x28:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __lcd_ready

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x29:
	CALL __long_delay
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x2A:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGD1:
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LSRW4:
	LSR  R31
	ROR  R30
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__CWD1:
	LDI  R22,0
	LDI  R23,0
	SBRS R31,7
	RET
	SER  R22
	SER  R23
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
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

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R19
	CLR  R20
	LDI  R21,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R19
	ROL  R20
	SUB  R0,R30
	SBC  R1,R31
	SBC  R19,R22
	SBC  R20,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R19,R22
	ADC  R20,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R21
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOV  R24,R19
	MOV  R25,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
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

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__LSLB3:
	LSL  R30
	LSL  R30
	LSL  R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

