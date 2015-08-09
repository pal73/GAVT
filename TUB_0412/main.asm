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

	.INCLUDE "main.vec"
	.INCLUDE "main.inc"

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
;       1 
;       2 #define inSTART	5
;       3 #define inSTOP		6
;       4 
;       5 
;       6 #define PP1	PORTB.3
;       7 #define PP2	PORTB.2
;       8 #define TENPL	PORTD.5
;       9 #define TENMI	PORTD.4
;      10 
;      11 
;      12 bit b600Hz;
;      13 
;      14 bit b100Hz;
;      15 bit b10Hz;
;      16 char t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3;
;      17 
;      18 
;      19 bit bZ;    
;      20 char but;
;      21 static char but_onL_temp;
_but_onL_temp_G1:
	.BYTE 0x1
;      22 bit l_but;		//идет длинное нажатие на кнопку
;      23 bit n_but;          //произошло нажатие
;      24 bit speed;		//разрешение ускорения перебора 
;      25 bit bFL2; 
;      26 bit bFL5;
;      27 
;      28 enum {p1=1,p2=2,p3=3,p4=4}prog;
;      29 enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}step=sOFF;
;      30 
;      31 char in_word=0xff,in_word_old,in_word_new,in_word_cnt;
;      32 bit bERR;
;      33 signed short cnt_del=0;
_cnt_del:
	.BYTE 0x2
;      34 signed short adc_del=0;
_adc_del:
	.BYTE 0x2
;      35 
;      36 char cnt_stop,cnt_start;
_cnt_stop:
	.BYTE 0x1
_cnt_start:
	.BYTE 0x1
;      37 bit bSTOP,bSTART;
;      38 
;      39 #include <mega16.h>
;      40 //#include <mega8535.h>  
;      41 /*
;      42 //-----------------------------------------------
;      43 void adc_drv(void)
;      44 {
;      45 adc_del=100;
;      46 }
;      47 
;      48 
;      49 /*
;      50 //-----------------------------------------------
;      51 void adc_hndl(void)
;      52 {
;      53 char i,j;
;      54 int temp_UI;
;      55 for(i=0;i<8;i++)
;      56 	{  
;      57 	temp_UI=0;
;      58 	for(j=0;j<16;j++)
;      59 		{
;      60 		temp_UI+=adc_buff[i,j];
;      61 		}
;      62 	adc_buff_[i]=temp_UI>>4;	
;      63 	}
;      64 
;      65 for(i=0;i<4;i++)
;      66 	{  
;      67 	temp_UI=0;
;      68 	for(j=0;j<16;j++)
;      69 		{
;      70 		temp_UI+=curr_ch_buff[i,j];
;      71 		}
;      72 	curr_ch_buff_[i]=temp_UI>>1;
;      73 	
;      74 	//curr_ch_buff_[0]=58;	
;      75 	}	
;      76 plazma_int[0]=adc_buff_[PTR_IN_TEMPER[0]];
;      77 plazma_int[1]=adc_buff_[PTR_IN_TEMPER[1]];
;      78 plazma_int[2]=adc_buff_[PTR_IN_VL[0]];
;      79 plazma_int[3]=adc_buff_[PTR_IN_VL[1]];	
;      80 }*/
;      81 
;      82 //-----------------------------------------------
;      83 #define ADC_VREF_TYPE 0x40
;      84 // Read the AD conversion result
;      85 unsigned int read_adc(unsigned char adc_input)
;      86 {

	.CSEG
_read_adc:
;      87 ADMUX=adc_input|ADC_VREF_TYPE;
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
;      88 // Start the AD conversion
;      89 ADCSRA|=0x40;
	SBI  0x6,6
;      90 // Wait for the AD conversion to complete
;      91 while ((ADCSRA & 0x10)==0);
_0x4:
	SBIS 0x6,4
	RJMP _0x4
;      92 ADCSRA|=0x10;
	SBI  0x6,4
;      93 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
;      94 }
;      95 
;      96 
;      97 /*
;      98 void adc_drv(void)
;      99 { 
;     100 unsigned self_adcw,temp_UI;
;     101 char temp;
;     102              
;     103 self_adcw=ADCW;
;     104 
;     105 if(adc_cnt_main<4)
;     106 	{
;     107 	if(self_adcw<self_min)self_min=self_adcw; 
;     108 	if(self_adcw>self_max)self_max=self_adcw;
;     109 	
;     110 	self_cnt++;
;     111 	if(self_cnt>=30)
;     112 		{
;     113 		curr_ch_buff[adc_cnt_main,adc_cnt_main1[adc_cnt_main]]=self_max-self_min;
;     114 		if(adc_cnt_main==0)
;     115 			{
;     116 		    //	plazma_int[0]=self_max;
;     117 		    //	plazma_int[1]=self_min;
;     118 			}
;     119 		
;     120 		adc_cnt_main1[adc_cnt_main]++;
;     121 		if(adc_cnt_main1[adc_cnt_main]>=16)adc_cnt_main1[adc_cnt_main]=0;
;     122 		adc_cnt_main++;
;     123 		if(adc_cnt_main<4)
;     124 			{
;     125 			curr_buff=0;
;     126 			self_cnt=0;
;     127 		    //	self_cnt_zero_for=0;
;     128 			self_cnt_not_zero=0;
;     129 			self_cnt_zero_after=0;
;     130 			self_min=1023;
;     131 			self_max=0;			
;     132 			} 			
;     133  
;     134 						
;     135 	 	}  		
;     136 	}
;     137 else if(adc_cnt_main==4)
;     138 	{
;     139 	adc_buff[adc_ch,adc_ch_cnt]=self_adcw;
;     140 	
;     141 	adc_ch++;
;     142 	if(adc_ch>=8)
;     143 		{
;     144 		adc_ch=0;
;     145 		
;     146 		adc_cnt_main=5;
;     147 		
;     148 		curr_buff=0;
;     149 		self_cnt=0;
;     150 		//self_cnt_zero_for=0;
;     151 		self_cnt_not_zero=0;
;     152 		self_cnt_zero_after=0;         
;     153 		
;     154 		adc_ch_cnt++;
;     155 		if(adc_ch_cnt>=16)adc_ch_cnt=0;
;     156 		}
;     157 	}
;     158 
;     159 else if(adc_cnt_main==5)
;     160 	{
;     161 	adc_cnt_main=6;
;     162 	curr_buff=0;
;     163 	self_cnt=0;
;     164     //	self_cnt_zero_for=0;
;     165 	self_cnt_not_zero=0;
;     166 	self_cnt_zero_after=0;
;     167 	self_min=1023;
;     168 	self_max=0;
;     169 	}
;     170 else if(adc_cnt_main==6)
;     171 	{
;     172 	adc_cnt_main=0;
;     173 	curr_buff=0;
;     174 	self_cnt=0;
;     175     //	self_cnt_zero_for=0;
;     176 	self_cnt_not_zero=0;
;     177 	self_cnt_zero_after=0;
;     178 	self_min=1023;
;     179 	self_max=0;
;     180 	}	
;     181 				     
;     182 DDRB|=0b11000000;
;     183 DDRD.5=1;
;     184 PORTB=(PORTB&0x3f)|(adc_ch<<6); 
;     185 PORTD.5=adc_ch>>2; 
;     186 
;     187 ADCSRA=0x86;
;     188 ADMUX=ADMUX_CONST[adc_cnt_main];
;     189 ADCSRA|=0x40;
;     190 
;     191 adc_del=100;	
;     192 }*/ 
;     193 
;     194 
;     195 //-----------------------------------------------
;     196 void in_drv(void)
;     197 {
_in_drv:
;     198 char i,temp;
;     199 unsigned int tempUI;
;     200 DDRA&=~((1<<5)|(1<<6));
	CALL __SAVELOCR4
;	i -> R16
;	temp -> R17
;	tempUI -> R18,R19
	IN   R30,0x1A
	ANDI R30,LOW(0x9F)
	OUT  0x1A,R30
;     201 PORTA|=((1<<5)|(1<<6));
	IN   R30,0x1B
	ORI  R30,LOW(0x60)
	OUT  0x1B,R30
;     202 in_word_new=PINA;
	IN   R13,25
;     203 if(in_word_old==in_word_new)
	CP   R13,R12
	BRNE _0x7
;     204 	{
;     205 	if(in_word_cnt<10)
	LDI  R30,LOW(10)
	CP   R14,R30
	BRSH _0x8
;     206 		{
;     207 		in_word_cnt++;
	INC  R14
;     208 		if(in_word_cnt>=10)
	CP   R14,R30
	BRLO _0x9
;     209 			{
;     210 			in_word=in_word_old;
	MOV  R11,R12
;     211 			}
;     212 		}
_0x9:
;     213 	}
_0x8:
;     214 else in_word_cnt=0;
	RJMP _0xA
_0x7:
	CLR  R14
_0xA:
;     215 
;     216 
;     217 in_word_old=in_word_new;
	MOV  R12,R13
;     218 }   
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;     219 
;     220 
;     221 
;     222 //-----------------------------------------------
;     223 void in_an(void)
;     224 {
_in_an:
;     225 if(!(in_word&(1<<inSTOP)))
	SBRC R11,6
	RJMP _0xB
;     226 	{
;     227 	if(cnt_stop<10)
	LDS  R26,_cnt_stop
	CPI  R26,LOW(0xA)
	BRSH _0xC
;     228 		{
;     229 		cnt_stop++;
	LDS  R30,_cnt_stop
	SUBI R30,-LOW(1)
	STS  _cnt_stop,R30
;     230 		if(cnt_stop==10) bSTOP=1;
	LDS  R26,_cnt_stop
	CPI  R26,LOW(0xA)
	BRNE _0xD
	SET
	BLD  R3,2
;     231 		}
_0xD:
;     232 
;     233 	}
_0xC:
;     234 else
	RJMP _0xE
_0xB:
;     235 	{
;     236 	if(cnt_stop)
	LDS  R30,_cnt_stop
	CPI  R30,0
	BREQ _0xF
;     237 		{
;     238 		cnt_stop--;
	SUBI R30,LOW(1)
	STS  _cnt_stop,R30
;     239 		//if(cnt_stop==0) bSTOP=0;
;     240 		}
;     241 
;     242 	}
_0xF:
_0xE:
;     243 
;     244 if(!(in_word&(1<<inSTART)))
	SBRC R11,5
	RJMP _0x10
;     245 	{
;     246 	if(cnt_start<10)
	LDS  R26,_cnt_start
	CPI  R26,LOW(0xA)
	BRSH _0x11
;     247 		{
;     248 		cnt_start++;
	LDS  R30,_cnt_start
	SUBI R30,-LOW(1)
	STS  _cnt_start,R30
;     249 		if(cnt_start==10) bSTART=1;
	LDS  R26,_cnt_start
	CPI  R26,LOW(0xA)
	BRNE _0x12
	SET
	BLD  R3,3
;     250 		}
_0x12:
;     251 
;     252 	}
_0x11:
;     253 else
	RJMP _0x13
_0x10:
;     254 	{
;     255 	if(cnt_start)
	LDS  R30,_cnt_start
	CPI  R30,0
	BREQ _0x14
;     256 		{
;     257 		cnt_start--;
	SUBI R30,LOW(1)
	STS  _cnt_start,R30
;     258 	    //	if(cnt_start==0) bSTART=0;
;     259 		}
;     260 
;     261 	}
_0x14:
_0x13:
;     262 } 
	RET
;     263 
;     264 
;     265 //-----------------------------------------------
;     266 void step_contr(void)
;     267 {
_step_contr:
;     268 DDRB.2=1;
	SBI  0x17,2
;     269 DDRB.3=1;
	SBI  0x17,3
;     270 DDRD.4=1;
	SBI  0x11,4
;     271 DDRD.5=1;
	SBI  0x11,5
;     272 
;     273 if(bSTOP)
	SBRS R3,2
	RJMP _0x15
;     274 	{
;     275 	step=sOFF;
	CLR  R10
;     276 	} 
;     277 	
;     278 if(step==sOFF)
_0x15:
	TST  R10
	BRNE _0x16
;     279 	{
;     280 	PP1=1;
	SBI  0x18,3
;     281 	PP2=1;
	SBI  0x18,2
;     282 	TENPL=0;
	CBI  0x12,5
;     283 	TENMI=1;
	SBI  0x12,4
;     284 	
;     285 	if(bSTART) 
	SBRS R3,3
	RJMP _0x17
;     286 		{
;     287 		step=s1;
	LDI  R30,LOW(1)
	MOV  R10,R30
;     288 		cnt_del=50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;     289 		}
;     290 	}
_0x17:
;     291 
;     292 else if(step==s1)
	RJMP _0x18
_0x16:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x19
;     293 	{
;     294 	PP1=0;
	CBI  0x18,3
;     295 	PP2=1;
	SBI  0x18,2
;     296 	TENPL=0;
	CBI  0x12,5
;     297 	TENMI=1;
	SBI  0x12,4
;     298 	
;     299 	cnt_del--;
	RCALL SUBOPT_0x0
;     300 	if(cnt_del==0)
	BRNE _0x1A
;     301 		{
;     302 		step=s2;
	LDI  R30,LOW(2)
	MOV  R10,R30
;     303 		}
;     304 	}
_0x1A:
;     305 
;     306 
;     307 else if(step==s2)
	RJMP _0x1B
_0x19:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x1C
;     308 	{
;     309 	PP1=0;
	CBI  0x18,3
;     310 	PP2=1;
	SBI  0x18,2
;     311 	TENPL=0;
	CBI  0x12,5
;     312 	TENMI=1;
	SBI  0x12,4
;     313 
;     314      if(!bSTART)goto step_contr_end;
	SBRS R3,3
	RJMP _0x1E
;     315      step=s3;
	LDI  R30,LOW(3)
	MOV  R10,R30
;     316      cnt_del=adc_del;
	LDS  R30,_adc_del
	LDS  R31,_adc_del+1
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;     317 	}
;     318 	
;     319 else if(step==s3)
	RJMP _0x1F
_0x1C:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x20
;     320 	{
;     321 	PP1=0;
	CBI  0x18,3
;     322 	PP2=0;
	CBI  0x18,2
;     323 	TENPL=1;
	SBI  0x12,5
;     324 	TENMI=0;
	CBI  0x12,4
;     325 	cnt_del--;	
	RCALL SUBOPT_0x0
;     326 	if(cnt_del==0)
	BRNE _0x21
;     327 		{
;     328 		step=sOFF;
	CLR  R10
;     329 		}
;     330      }     
_0x21:
;     331   
;     332 
;     333 step_contr_end:
_0x20:
_0x1F:
_0x1B:
_0x18:
_0x1E:
;     334 bSTART=0;
	CLT
	BLD  R3,3
;     335 bSTOP=0;
	CLT
	BLD  R3,2
;     336 }
	RET
;     337 
;     338 //-----------------------------------------------
;     339 void but_an(void)
;     340 {
;     341 
;     342 if(!(in_word&0x01))
;     343 	{
;     344 	#ifdef TVIST_SKO
;     345 	if((step==sOFF)&&(!bERR))
;     346 		{
;     347 		step=s1;
;     348 		if(prog==p2) cnt_del=70;
;     349 		else if(prog==p3) cnt_del=100;
;     350 		}
;     351 	#endif
;     352 	#ifdef DV3KL2MD
;     353 	if((step==sOFF)&&(!bERR))
;     354 		{
;     355 		step=s1;
;     356 		cnt_del=70;
;     357 		}
;     358 	#endif	
;     359 	#ifndef TVIST_SKO
;     360 	if((step==sOFF)&&(!bERR))
;     361 		{
;     362 		step=s1;
;     363 		if(prog==p1) cnt_del=50;
;     364 		else if(prog==p2) cnt_del=50;
;     365 		else if(prog==p3) cnt_del=50;
;     366           #ifdef P380_MINI
;     367   		cnt_del=100;
;     368   		#endif
;     369 		}
;     370 	#endif
;     371 	}
;     372 if(!(in_word&0x02))
;     373 	{
;     374 	step=sOFF;
;     375 
;     376 	}
;     377 
;     378 if (!n_but) goto but_an_end;
;     379 
;     380 
;     381 but_an_end:
;     382 n_but=0;
;     383 }
;     384 
;     385 
;     386 //***********************************************
;     387 //***********************************************
;     388 //***********************************************
;     389 //***********************************************
;     390 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;     391 {
_timer0_ovf_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     392 TCCR0=0x02;
	RCALL SUBOPT_0x1
;     393 TCNT0=-208;
;     394 OCR0=0x00; 
;     395 
;     396 
;     397 b600Hz=1;
	SET
	BLD  R2,0
;     398 
;     399 if(++t0_cnt0>=6)
	INC  R4
	LDI  R30,LOW(6)
	CP   R4,R30
	BRLO _0x2E
;     400 	{
;     401 	t0_cnt0=0;
	CLR  R4
;     402 	b100Hz=1;
	SET
	BLD  R2,1
;     403 	}
;     404 
;     405 if(++t0_cnt1>=60)
_0x2E:
	INC  R5
	LDI  R30,LOW(60)
	CP   R5,R30
	BRLO _0x2F
;     406 	{
;     407 	t0_cnt1=0;
	CLR  R5
;     408 	b10Hz=1;
	SET
	BLD  R2,2
;     409 	
;     410 	if(++t0_cnt2>=2)
	INC  R6
	LDI  R30,LOW(2)
	CP   R6,R30
	BRLO _0x30
;     411 		{
;     412 		t0_cnt2=0;
	CLR  R6
;     413 		bFL5=!bFL5;
	LDI  R30,LOW(1)
	EOR  R3,R30
;     414 		}
;     415 		
;     416 	if(++t0_cnt3>=5)
_0x30:
	INC  R7
	LDI  R30,LOW(5)
	CP   R7,R30
	BRLO _0x31
;     417 		{
;     418 		t0_cnt3=0;
	CLR  R7
;     419 		bFL2=!bFL2;
	LDI  R30,LOW(128)
	EOR  R2,R30
;     420 		}		
;     421 	}
_0x31:
;     422 }
_0x2F:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;     423 
;     424 //===============================================
;     425 //===============================================
;     426 //===============================================
;     427 //===============================================
;     428 
;     429 void main(void)
;     430 {
_main:
;     431 
;     432 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
;     433 DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
;     434 
;     435 PORTB=0xff;
	RCALL SUBOPT_0x2
;     436 DDRB=0xFF;
;     437 
;     438 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;     439 DDRC=0x00;
	OUT  0x14,R30
;     440 
;     441 
;     442 PORTD=0x00;
	OUT  0x12,R30
;     443 DDRD=0x00;
	OUT  0x11,R30
;     444 
;     445 
;     446 TCCR0=0x02;
	RCALL SUBOPT_0x1
;     447 TCNT0=-208;
;     448 OCR0=0x00;
;     449 
;     450 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;     451 TCCR1B=0x00;
	OUT  0x2E,R30
;     452 TCNT1H=0x00;
	OUT  0x2D,R30
;     453 TCNT1L=0x00;
	OUT  0x2C,R30
;     454 ICR1H=0x00;
	OUT  0x27,R30
;     455 ICR1L=0x00;
	OUT  0x26,R30
;     456 OCR1AH=0x00;
	OUT  0x2B,R30
;     457 OCR1AL=0x00;
	OUT  0x2A,R30
;     458 OCR1BH=0x00;
	OUT  0x29,R30
;     459 OCR1BL=0x00;
	OUT  0x28,R30
;     460 
;     461 
;     462 ASSR=0x00;
	OUT  0x22,R30
;     463 TCCR2=0x00;
	OUT  0x25,R30
;     464 TCNT2=0x00;
	OUT  0x24,R30
;     465 OCR2=0x00;
	OUT  0x23,R30
;     466 
;     467 MCUCR=0x00;
	OUT  0x35,R30
;     468 MCUCSR=0x00;
	OUT  0x34,R30
;     469 
;     470 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;     471 
;     472 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     473 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     474 
;     475 #asm("sei") 
	sei
;     476 PORTB=0xFF;
	RCALL SUBOPT_0x2
;     477 DDRB=0xFF;
;     478 
;     479 DDRA.7=0;
	CBI  0x1A,7
;     480 PORTA.7=0;
	CBI  0x1B,7
;     481 ADCSRA=0x83;
	LDI  R30,LOW(131)
	OUT  0x6,R30
;     482 SFIOR&=0x0F;
	IN   R30,0x30
	ANDI R30,LOW(0xF)
	OUT  0x30,R30
;     483 
;     484 while (1)
_0x32:
;     485       {
;     486       if(b600Hz)
	SBRS R2,0
	RJMP _0x35
;     487 		{
;     488 		b600Hz=0; 
	CLT
	BLD  R2,0
;     489           
;     490 		}         
;     491       if(b100Hz)
_0x35:
	SBRS R2,1
	RJMP _0x36
;     492 		{        
;     493 		b100Hz=0; 
	CLT
	BLD  R2,1
;     494 	    	in_drv();
	RCALL _in_drv
;     495           in_an();
	RCALL _in_an
;     496           step_contr();
	RCALL _step_contr
;     497 		}   
;     498 	if(b10Hz)
_0x36:
	SBRS R2,2
	RJMP _0x37
;     499 		{
;     500 		b10Hz=0;
	CLT
	BLD  R2,2
;     501 		//adc_drv();
;     502 		
;     503 		adc_del=((adc_del*9)/10)+(read_adc(7)/10)+10;
	LDS  R26,_adc_del
	LDS  R27,_adc_del+1
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CALL __MULW12
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	PUSH R31
	PUSH R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _read_adc
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	POP  R26
	POP  R27
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,10
	STS  _adc_del,R30
	STS  _adc_del+1,R31
;     504 		
;     505 		DDRC.6=1;
	SBI  0x14,6
;     506 		DDRC.7=1;
	SBI  0x14,7
;     507 		PORTC.7=1;
	SBI  0x15,7
;     508 		PORTC.6=!PORTC.6;
	CLT
	SBIS 0x15,6
	SET
	IN   R30,0x15
	BLD  R30,6
	OUT  0x15,R30
;     509           }
;     510 
;     511       };
_0x37:
	RJMP _0x32
;     512 }
_0x38:
	RJMP _0x38

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	LDS  R30,_cnt_del
	LDS  R31,_cnt_del+1
	SBIW R30,1
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	LDI  R30,LOW(2)
	OUT  0x33,R30
	LDI  R30,LOW(65328)
	LDI  R31,HIGH(65328)
	OUT  0x32,R30
	LDI  R30,LOW(0)
	OUT  0x3C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2:
	LDI  R30,LOW(255)
	OUT  0x18,R30
	OUT  0x17,R30
	RET

__ANEGW1:
	COM  R30
	COM  R31
	ADIW R30,1
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

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
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

