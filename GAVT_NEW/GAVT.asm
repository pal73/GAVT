;CodeVisionAVR C Compiler V1.24.1d Standard
;(C) Copyright 1998-2004 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.ro
;e-mail:office@hpinfotech.ro

;Chip type           : ATmega32
;Program type        : Application
;Clock frequency     : 1,000000 MHz
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
;      17 #define I380_WI
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
;     134 //#include <mega16.h>
;     135 //#include <mega8535.h>
;     136 #include <mega32.h>
;     137 //-----------------------------------------------
;     138 void prog_drv(void)
;     139 {

	.CSEG
_prog_drv:
;     140 char temp,temp1,temp2;
;     141 
;     142 temp=ee_program[0];
	CALL __SAVELOCR3
;	temp -> R16
;	temp1 -> R17
;	temp2 -> R18
	LDI  R26,LOW(_ee_program)
	LDI  R27,HIGH(_ee_program)
	CALL __EEPROMRDB
	MOV  R16,R30
;     143 temp1=ee_program[1];
	__POINTW2MN _ee_program,1
	CALL __EEPROMRDB
	MOV  R17,R30
;     144 temp2=ee_program[2];
	__POINTW2MN _ee_program,2
	CALL __EEPROMRDB
	MOV  R18,R30
;     145 
;     146 if((temp==temp1)&&(temp==temp2))
	CP   R17,R16
	BRNE _0x5
	CP   R18,R16
	BREQ _0x6
_0x5:
	RJMP _0x4
_0x6:
;     147 	{
;     148 	}
;     149 else if((temp==temp1)&&(temp!=temp2))
	RJMP _0x7
_0x4:
	CP   R17,R16
	BRNE _0x9
	CP   R18,R16
	BRNE _0xA
_0x9:
	RJMP _0x8
_0xA:
;     150 	{
;     151 	temp2=temp;
	MOV  R18,R16
;     152 	}
;     153 else if((temp!=temp1)&&(temp==temp2))
	RJMP _0xB
_0x8:
	CP   R17,R16
	BREQ _0xD
	CP   R18,R16
	BREQ _0xE
_0xD:
	RJMP _0xC
_0xE:
;     154 	{
;     155 	temp1=temp;
	MOV  R17,R16
;     156 	}
;     157 else if((temp!=temp1)&&(temp1==temp2))
	RJMP _0xF
_0xC:
	CP   R17,R16
	BREQ _0x11
	CP   R18,R17
	BREQ _0x12
_0x11:
	RJMP _0x10
_0x12:
;     158 	{
;     159 	temp=temp1;
	MOV  R16,R17
;     160 	}
;     161 else if((temp!=temp1)&&(temp!=temp2))
	RJMP _0x13
_0x10:
	CP   R17,R16
	BREQ _0x15
	CP   R18,R16
	BRNE _0x16
_0x15:
	RJMP _0x14
_0x16:
;     162 	{
;     163 	temp=MINPROG;
	LDI  R16,LOW(1)
;     164 	temp1=MINPROG;
	LDI  R17,LOW(1)
;     165 	temp2=MINPROG;
	LDI  R18,LOW(1)
;     166 	}
;     167 
;     168 if(!((temp<=MAXPROG)&&(temp>=MINPROG)))
_0x14:
_0x13:
_0xF:
_0xB:
_0x7:
	LDI  R30,LOW(4)
	CP   R30,R16
	BRLO _0x18
	CPI  R16,1
	BRSH _0x17
_0x18:
;     169 	{
;     170 	temp=MINPROG;
	LDI  R16,LOW(1)
;     171 	}
;     172 
;     173 if(temp!=ee_program[0])ee_program[0]=temp;
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
;     174 if(temp!=ee_program[1])ee_program[1]=temp;
_0x1A:
	__POINTW2MN _ee_program,1
	CALL __EEPROMRDB
	CP   R30,R16
	BREQ _0x1B
	__POINTW2MN _ee_program,1
	MOV  R30,R16
	CALL __EEPROMWRB
;     175 if(temp!=ee_program[2])ee_program[2]=temp;
_0x1B:
	__POINTW2MN _ee_program,2
	CALL __EEPROMRDB
	CP   R30,R16
	BREQ _0x1C
	__POINTW2MN _ee_program,2
	MOV  R30,R16
	CALL __EEPROMWRB
;     176 
;     177 prog=temp;
_0x1C:
	MOV  R10,R16
;     178 }
	CALL __LOADLOCR3
	RJMP _0x125
;     179 
;     180 //-----------------------------------------------
;     181 void in_drv(void)
;     182 {
_in_drv:
;     183 char i,temp;
;     184 unsigned int tempUI;
;     185 DDRA=0x00;
	CALL __SAVELOCR4
;	i -> R16
;	temp -> R17
;	tempUI -> R18,R19
	CALL SUBOPT_0x0
;     186 PORTA=0xff;
	OUT  0x1B,R30
;     187 in_word_new=PINA;
	IN   R30,0x19
	STS  _in_word_new,R30
;     188 if(in_word_old==in_word_new)
	LDS  R26,_in_word_old
	CP   R30,R26
	BRNE _0x1D
;     189 	{
;     190 	if(in_word_cnt<10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRSH _0x1E
;     191 		{
;     192 		in_word_cnt++;
	LDS  R30,_in_word_cnt
	SUBI R30,-LOW(1)
	STS  _in_word_cnt,R30
;     193 		if(in_word_cnt>=10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRLO _0x1F
;     194 			{
;     195 			in_word=in_word_old;
	LDS  R14,_in_word_old
;     196 			}
;     197 		}
_0x1F:
;     198 	}
_0x1E:
;     199 else in_word_cnt=0;
	RJMP _0x20
_0x1D:
	LDI  R30,LOW(0)
	STS  _in_word_cnt,R30
_0x20:
;     200 
;     201 
;     202 in_word_old=in_word_new;
	LDS  R30,_in_word_new
	STS  _in_word_old,R30
;     203 }   
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;     204 
;     205 #ifdef TVIST_SKO
;     206 //-----------------------------------------------
;     207 void err_drv(void)
;     208 {
;     209 if(step==sOFF)
;     210 	{
;     211     	if(prog==p2)	
;     212     		{
;     213        		if(bMD1) bERR=1;
;     214        		else bERR=0;
;     215 		}
;     216 	}
;     217 else bERR=0;
;     218 }
;     219 #endif  
;     220 
;     221 #ifndef TVIST_SKO
;     222 //-----------------------------------------------
;     223 void err_drv(void)
;     224 {
_err_drv:
;     225 if(step==sOFF)
	TST  R11
	BRNE _0x21
;     226 	{
;     227 	if((bMD1)||(bMD2)||(bVR)||(bMD3)) bERR=1;
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
;     228 	else bERR=0;
	RJMP _0x25
_0x22:
	CLT
	BLD  R3,1
_0x25:
;     229 	}
;     230 else bERR=0;
	RJMP _0x26
_0x21:
	CLT
	BLD  R3,1
_0x26:
;     231 }
	RET
;     232 #endif
;     233 //-----------------------------------------------
;     234 void mdvr_drv(void)
;     235 {
_mdvr_drv:
;     236 if(!(in_word&(1<<MD1)))
	SBRC R14,2
	RJMP _0x27
;     237 	{
;     238 	if(cnt_md1<10)
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRSH _0x28
;     239 		{
;     240 		cnt_md1++;
	LDS  R30,_cnt_md1
	SUBI R30,-LOW(1)
	STS  _cnt_md1,R30
;     241 		if(cnt_md1==10) bMD1=1;
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRNE _0x29
	LDI  R30,LOW(1)
	STS  _bMD1,R30
;     242 		}
_0x29:
;     243 
;     244 	}
_0x28:
;     245 else
	RJMP _0x2A
_0x27:
;     246 	{
;     247 	if(cnt_md1)
	LDS  R30,_cnt_md1
	CPI  R30,0
	BREQ _0x2B
;     248 		{
;     249 		cnt_md1--;
	SUBI R30,LOW(1)
	STS  _cnt_md1,R30
;     250 		if(cnt_md1==0) bMD1=0;
	CPI  R30,0
	BRNE _0x2C
	LDI  R30,LOW(0)
	STS  _bMD1,R30
;     251 		}
_0x2C:
;     252 
;     253 	}
_0x2B:
_0x2A:
;     254 
;     255 if(!(in_word&(1<<MD2)))
	SBRC R14,3
	RJMP _0x2D
;     256 	{
;     257 	if(cnt_md2<10)
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRSH _0x2E
;     258 		{
;     259 		cnt_md2++;
	LDS  R30,_cnt_md2
	SUBI R30,-LOW(1)
	STS  _cnt_md2,R30
;     260 		if(cnt_md2==10) bMD2=1;
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRNE _0x2F
	SET
	BLD  R3,2
;     261 		}
_0x2F:
;     262 
;     263 	}
_0x2E:
;     264 else
	RJMP _0x30
_0x2D:
;     265 	{
;     266 	if(cnt_md2)
	LDS  R30,_cnt_md2
	CPI  R30,0
	BREQ _0x31
;     267 		{
;     268 		cnt_md2--;
	SUBI R30,LOW(1)
	STS  _cnt_md2,R30
;     269 		if(cnt_md2==0) bMD2=0;
	CPI  R30,0
	BRNE _0x32
	CLT
	BLD  R3,2
;     270 		}
_0x32:
;     271 
;     272 	}
_0x31:
_0x30:
;     273 
;     274 if(!(in_word&(1<<MD3)))
	SBRC R14,5
	RJMP _0x33
;     275 	{
;     276 	if(cnt_md3<10)
	LDS  R26,_cnt_md3
	CPI  R26,LOW(0xA)
	BRSH _0x34
;     277 		{
;     278 		cnt_md3++;
	LDS  R30,_cnt_md3
	SUBI R30,-LOW(1)
	STS  _cnt_md3,R30
;     279 		if(cnt_md3==10) bMD3=1;
	LDS  R26,_cnt_md3
	CPI  R26,LOW(0xA)
	BRNE _0x35
	SET
	BLD  R3,3
;     280 		}
_0x35:
;     281 
;     282 	}
_0x34:
;     283 else
	RJMP _0x36
_0x33:
;     284 	{
;     285 	if(cnt_md3)
	LDS  R30,_cnt_md3
	CPI  R30,0
	BREQ _0x37
;     286 		{
;     287 		cnt_md3--;
	SUBI R30,LOW(1)
	STS  _cnt_md3,R30
;     288 		if(cnt_md3==0) bMD3=0;
	CPI  R30,0
	BRNE _0x38
	CLT
	BLD  R3,3
;     289 		}
_0x38:
;     290 
;     291 	}
_0x37:
_0x36:
;     292 
;     293 if(((!(in_word&(1<<VR)))&&(ee_vr_log)) || (((in_word&(1<<VR)))&&(!ee_vr_log)))
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
;     294 	{
;     295 	if(cnt_vr<10)
	LDS  R26,_cnt_vr
	CPI  R26,LOW(0xA)
	BRSH _0x40
;     296 		{
;     297 		cnt_vr++;
	LDS  R30,_cnt_vr
	SUBI R30,-LOW(1)
	STS  _cnt_vr,R30
;     298 		if(cnt_vr==10) bVR=1;
	LDS  R26,_cnt_vr
	CPI  R26,LOW(0xA)
	BRNE _0x41
	LDI  R30,LOW(1)
	STS  _bVR,R30
;     299 		}
_0x41:
;     300 
;     301 	}
_0x40:
;     302 else
	RJMP _0x42
_0x39:
;     303 	{
;     304 	if(cnt_vr)
	LDS  R30,_cnt_vr
	CPI  R30,0
	BREQ _0x43
;     305 		{
;     306 		cnt_vr--;
	SUBI R30,LOW(1)
	STS  _cnt_vr,R30
;     307 		if(cnt_vr==0) bVR=0;
	CPI  R30,0
	BRNE _0x44
	LDI  R30,LOW(0)
	STS  _bVR,R30
;     308 		}
_0x44:
;     309 
;     310 	}
_0x43:
_0x42:
;     311 } 
	RET
;     312 
;     313 #ifdef DV3KL2MD
;     314 //-----------------------------------------------
;     315 void step_contr(void)
;     316 {
;     317 char temp=0;
;     318 DDRB=0xFF;
;     319 
;     320 if(step==sOFF)
;     321 	{
;     322 	temp=0;
;     323 	}
;     324 
;     325 else if(step==s1)
;     326 	{
;     327 	temp|=(1<<PP1);
;     328 
;     329 	cnt_del--;
;     330 	if(cnt_del==0)
;     331 		{
;     332 		step=s2;
;     333 		cnt_del=20;
;     334 		}
;     335 	}
;     336 
;     337 
;     338 else if(step==s2)
;     339 	{
;     340 	temp|=(1<<PP1)|(1<<DV);
;     341 
;     342 	cnt_del--;
;     343 	if(cnt_del==0)
;     344 		{
;     345 		step=s3;
;     346 		}
;     347 	}
;     348 	
;     349 else if(step==s3)
;     350 	{
;     351 	temp|=(1<<PP1)|(1<<PP2)|(1<<DV);
;     352      if(!bMD1)goto step_contr_end;
;     353      step=s4;
;     354      }     
;     355 else if(step==s4)
;     356 	{          
;     357      temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     358      if(!bMD2)goto step_contr_end;
;     359      step=s5;
;     360      cnt_del=50;
;     361      } 
;     362 else if(step==s5)
;     363 	{
;     364 	temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     365 
;     366 	cnt_del--;
;     367 	if(cnt_del==0)
;     368 		{
;     369 		step=s6;
;     370 		cnt_del=50;
;     371 		}
;     372 	}         
;     373 /*else if(step==s6)
;     374 	{
;     375 	temp|=(1<<PP1)|(1<<DV);
;     376 
;     377 	cnt_del--;
;     378 	if(cnt_del==0)
;     379 		{
;     380 		step=s6;
;     381 		cnt_del=70;
;     382 		}
;     383 	}*/     
;     384 else if(step==s6)
;     385 		{
;     386 	temp|=(1<<PP1);
;     387 	cnt_del--;
;     388 	if(cnt_del==0)
;     389 		{
;     390 		step=sOFF;
;     391           }     
;     392      }     
;     393 
;     394 step_contr_end:
;     395 
;     396 PORTB=~temp;
;     397 }
;     398 #endif
;     399 
;     400 #ifdef P380_MINI
;     401 //-----------------------------------------------
;     402 void step_contr(void)
;     403 {
;     404 char temp=0;
;     405 DDRB=0xFF;
;     406 
;     407 if(step==sOFF)
;     408 	{
;     409 	temp=0;
;     410 	}
;     411 
;     412 else if(step==s1)
;     413 	{
;     414 	temp|=(1<<PP1);
;     415 
;     416 	cnt_del--;
;     417 	if(cnt_del==0)
;     418 		{
;     419 		step=s2;
;     420 		}
;     421 	}
;     422 
;     423 else if(step==s2)
;     424 	{
;     425 	temp|=(1<<PP1)|(1<<PP2)|(1<<DV);
;     426      if(!bMD1)goto step_contr_end;
;     427      step=s3;
;     428      }     
;     429 else if(step==s3)
;     430 	{          
;     431      temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     432      if(!bMD2)goto step_contr_end;
;     433      step=s4;
;     434      cnt_del=50;
;     435      }
;     436 else if(step==s4)
;     437 		{
;     438 	temp|=(1<<PP1);
;     439 	cnt_del--;
;     440 	if(cnt_del==0)
;     441 		{
;     442 		step=sOFF;
;     443           }     
;     444      }     
;     445 
;     446 step_contr_end:
;     447 
;     448 PORTB=~temp;
;     449 }
;     450 #endif
;     451 
;     452 #ifdef P380
;     453 //-----------------------------------------------
;     454 void step_contr(void)
;     455 {
;     456 char temp=0;
;     457 DDRB=0xFF;
;     458 
;     459 if(step==sOFF)
;     460 	{
;     461 	temp=0;
;     462 	}
;     463 
;     464 else if(prog==p1)
;     465 	{
;     466 	if(step==s1)
;     467 		{
;     468 		temp|=(1<<PP1)|(1<<PP2);
;     469 
;     470 		cnt_del--;
;     471 		if(cnt_del==0)
;     472 			{
;     473 			if(ee_vacuum_mode==evmOFF)
;     474 				{
;     475 				goto lbl_0001;
;     476 				}
;     477 			else step=s2;
;     478 			}
;     479 		}
;     480 
;     481 	else if(step==s2)
;     482 		{
;     483 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     484 
;     485           if(!bVR)goto step_contr_end;
;     486 lbl_0001:
;     487 #ifndef BIG_CAM
;     488 		cnt_del=30;
;     489 #endif
;     490 
;     491 #ifdef BIG_CAM
;     492 		cnt_del=100;
;     493 #endif
;     494 		step=s3;
;     495 		}
;     496 
;     497 	else if(step==s3)
;     498 		{
;     499 		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     500 		cnt_del--;
;     501 		if(cnt_del==0)
;     502 			{
;     503 			step=s4;
;     504 			}
;     505           }
;     506 	else if(step==s4)
;     507 		{
;     508 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     509 
;     510           if(!bMD1)goto step_contr_end;
;     511 
;     512 		cnt_del=40;
;     513 		step=s5;
;     514 		}
;     515 	else if(step==s5)
;     516 		{
;     517 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     518 
;     519 		cnt_del--;
;     520 		if(cnt_del==0)
;     521 			{
;     522 			step=s6;
;     523 			}
;     524 		}
;     525 	else if(step==s6)
;     526 		{
;     527 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     528 
;     529          	if(!bMD2)goto step_contr_end;
;     530           cnt_del=40;
;     531 		//step=s7;
;     532 		
;     533           step=s55;
;     534           cnt_del=40;
;     535 		}
;     536 	else if(step==s55)
;     537 		{
;     538 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     539           cnt_del--;
;     540           if(cnt_del==0)
;     541 			{
;     542           	step=s7;
;     543           	cnt_del=20;
;     544 			}
;     545          		
;     546 		}
;     547 	else if(step==s7)
;     548 		{
;     549 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     550 
;     551 		cnt_del--;
;     552 		if(cnt_del==0)
;     553 			{
;     554 			step=s8;
;     555 			cnt_del=30;
;     556 			}
;     557 		}
;     558 	else if(step==s8)
;     559 		{
;     560 		temp|=(1<<PP1)|(1<<PP3);
;     561 
;     562 		cnt_del--;
;     563 		if(cnt_del==0)
;     564 			{
;     565 			step=s9;
;     566 #ifndef BIG_CAM
;     567 		cnt_del=150;
;     568 #endif
;     569 
;     570 #ifdef BIG_CAM
;     571 		cnt_del=200;
;     572 #endif
;     573 			}
;     574 		}
;     575 	else if(step==s9)
;     576 		{
;     577 		temp|=(1<<PP1)|(1<<PP2);
;     578 
;     579 		cnt_del--;
;     580 		if(cnt_del==0)
;     581 			{
;     582 			step=s10;
;     583 			cnt_del=30;
;     584 			}
;     585 		}
;     586 	else if(step==s10)
;     587 		{
;     588 		temp|=(1<<PP2);
;     589 		cnt_del--;
;     590 		if(cnt_del==0)
;     591 			{
;     592 			step=sOFF;
;     593 			}
;     594 		}
;     595 	}
;     596 
;     597 if(prog==p2)
;     598 	{
;     599 
;     600 	if(step==s1)
;     601 		{
;     602 		temp|=(1<<PP1)|(1<<PP2);
;     603 
;     604 		cnt_del--;
;     605 		if(cnt_del==0)
;     606 			{
;     607 			if(ee_vacuum_mode==evmOFF)
;     608 				{
;     609 				goto lbl_0002;
;     610 				}
;     611 			else step=s2;
;     612 			}
;     613 		}
;     614 
;     615 	else if(step==s2)
;     616 		{
;     617 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     618 
;     619           if(!bVR)goto step_contr_end;
;     620 lbl_0002:
;     621 #ifndef BIG_CAM
;     622 		cnt_del=30;
;     623 #endif
;     624 
;     625 #ifdef BIG_CAM
;     626 		cnt_del=100;
;     627 #endif
;     628 		step=s3;
;     629 		}
;     630 
;     631 	else if(step==s3)
;     632 		{
;     633 		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     634 
;     635 		cnt_del--;
;     636 		if(cnt_del==0)
;     637 			{
;     638 			step=s4;
;     639 			}
;     640 		}
;     641 
;     642 	else if(step==s4)
;     643 		{
;     644 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     645 
;     646           if(!bMD1)goto step_contr_end;
;     647          	cnt_del=30;
;     648 		step=s5;
;     649 		}
;     650 
;     651 	else if(step==s5)
;     652 		{
;     653 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     654 
;     655 		cnt_del--;
;     656 		if(cnt_del==0)
;     657 			{
;     658 			step=s6;
;     659 			cnt_del=30;
;     660 			}
;     661 		}
;     662 
;     663 	else if(step==s6)
;     664 		{
;     665 		temp|=(1<<PP1)|(1<<PP3);
;     666 
;     667 		cnt_del--;
;     668 		if(cnt_del==0)
;     669 			{
;     670 			step=s7;
;     671 #ifndef BIG_CAM
;     672 		cnt_del=150;
;     673 #endif
;     674 
;     675 #ifdef BIG_CAM
;     676 		cnt_del=200;
;     677 #endif
;     678 			}
;     679 		}
;     680 
;     681 	else if(step==s7)
;     682 		{
;     683 		temp|=(1<<PP1)|(1<<PP2);
;     684 
;     685 		cnt_del--;
;     686 		if(cnt_del==0)
;     687 			{
;     688 			step=s8;
;     689 			cnt_del=30;
;     690 			}
;     691 		}
;     692 	else if(step==s8)
;     693 		{
;     694 		temp|=(1<<PP2);
;     695 
;     696 		cnt_del--;
;     697 		if(cnt_del==0)
;     698 			{
;     699 			step=sOFF;
;     700 			}
;     701 		}
;     702 	}
;     703 
;     704 if(prog==p3)
;     705 	{
;     706 
;     707 	if(step==s1)
;     708 		{
;     709 		temp|=(1<<PP1)|(1<<PP2);
;     710 
;     711 		cnt_del--;
;     712 		if(cnt_del==0)
;     713 			{
;     714 			if(ee_vacuum_mode==evmOFF)
;     715 				{
;     716 				goto lbl_0003;
;     717 				}
;     718 			else step=s2;
;     719 			}
;     720 		}
;     721 
;     722 	else if(step==s2)
;     723 		{
;     724 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     725 
;     726           if(!bVR)goto step_contr_end;
;     727 lbl_0003:
;     728 #ifndef BIG_CAM
;     729 		cnt_del=80;
;     730 #endif
;     731 
;     732 #ifdef BIG_CAM
;     733 		cnt_del=100;
;     734 #endif
;     735 		step=s3;
;     736 		}
;     737 
;     738 	else if(step==s3)
;     739 		{
;     740 		temp|=(1<<PP1)|(1<<PP3);
;     741 
;     742 		cnt_del--;
;     743 		if(cnt_del==0)
;     744 			{
;     745 			step=s4;
;     746 			cnt_del=120;
;     747 			}
;     748 		}
;     749 
;     750 	else if(step==s4)
;     751 		{
;     752 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<PP5);
;     753 
;     754 		cnt_del--;
;     755 		if(cnt_del==0)
;     756 			{
;     757 			step=s5;
;     758 
;     759 		
;     760 #ifndef BIG_CAM
;     761 		cnt_del=150;
;     762 #endif
;     763 
;     764 #ifdef BIG_CAM
;     765 		cnt_del=200;
;     766 #endif
;     767 	//	step=s5;
;     768 	}
;     769 		}
;     770 
;     771 	else if(step==s5)
;     772 		{
;     773 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<PP5);
;     774 
;     775 		cnt_del--;
;     776 		if(cnt_del==0)
;     777 			{
;     778 			step=s6;
;     779 			cnt_del=30;
;     780 			}
;     781 		}
;     782 
;     783 	else if(step==s6)
;     784 		{
;     785 		temp|=(1<<PP2)|(1<<PP4)|(1<<PP5);
;     786 
;     787 		cnt_del--;
;     788 		if(cnt_del==0)
;     789 			{
;     790 			step=s7;
;     791 			cnt_del=30;
;     792 			}
;     793 		}
;     794 
;     795 	else if(step==s7)
;     796 		{
;     797 		temp|=(1<<PP2);
;     798 
;     799 		cnt_del--;
;     800 		if(cnt_del==0)
;     801 			{
;     802 			step=sOFF;
;     803 			}
;     804 		}
;     805 
;     806 	}
;     807 step_contr_end:
;     808 
;     809 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;     810 
;     811 PORTB=~temp;
;     812 }
;     813 #endif
;     814 #ifdef I380
;     815 //-----------------------------------------------
;     816 void step_contr(void)
;     817 {
;     818 char temp=0;
;     819 DDRB=0xFF;
;     820 
;     821 if(step==sOFF)goto step_contr_end;
;     822 
;     823 else if(prog==p1)
;     824 	{
;     825 	if(step==s1)    //жесть
;     826 		{
;     827 		temp|=(1<<PP1);
;     828           if(!bMD1)goto step_contr_end;
;     829 
;     830 			if(ee_vacuum_mode==evmOFF)
;     831 				{
;     832 				goto lbl_0001;
;     833 				}
;     834 			else step=s2;
;     835 		}
;     836 
;     837 	else if(step==s2)
;     838 		{
;     839 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     840           if(!bVR)goto step_contr_end;
;     841 lbl_0001:
;     842 
;     843           step=s100;
;     844 		cnt_del=40;
;     845           }
;     846 	else if(step==s100)
;     847 		{
;     848 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;     849           cnt_del--;
;     850           if(cnt_del==0)
;     851 			{
;     852           	step=s3;
;     853           	cnt_del=50;
;     854 			}
;     855 		}
;     856 
;     857 	else if(step==s3)
;     858 		{
;     859 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     860           cnt_del--;
;     861           if(cnt_del==0)
;     862 			{
;     863           	step=s4;
;     864 			}
;     865 		}
;     866 	else if(step==s4)
;     867 		{
;     868 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;     869           if(!bMD2)goto step_contr_end;
;     870           step=s5;
;     871           cnt_del=20;
;     872 		}
;     873 	else if(step==s5)
;     874 		{
;     875 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     876           cnt_del--;
;     877           if(cnt_del==0)
;     878 			{
;     879           	step=s6;
;     880 			}
;     881           }
;     882 	else if(step==s6)
;     883 		{
;     884 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
;     885           if(!bMD3)goto step_contr_end;
;     886           step=s7;
;     887           cnt_del=20;
;     888 		}
;     889 
;     890 	else if(step==s7)
;     891 		{
;     892 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     893           cnt_del--;
;     894           if(cnt_del==0)
;     895 			{
;     896           	step=s8;
;     897           	cnt_del=ee_delay[prog,0]*10U;;
;     898 			}
;     899           }
;     900 	else if(step==s8)
;     901 		{
;     902 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;     903           cnt_del--;
;     904           if(cnt_del==0)
;     905 			{
;     906           	step=s9;
;     907           	cnt_del=20;
;     908 			}
;     909           }
;     910 	else if(step==s9)
;     911 		{
;     912 		temp|=(1<<PP1);
;     913           cnt_del--;
;     914           if(cnt_del==0)
;     915 			{
;     916           	step=sOFF;
;     917           	}
;     918           }
;     919 	}
;     920 
;     921 else if(prog==p2)  //ско
;     922 	{
;     923 	if(step==s1)
;     924 		{
;     925 		temp|=(1<<PP1);
;     926           if(!bMD1)goto step_contr_end;
;     927 
;     928 			if(ee_vacuum_mode==evmOFF)
;     929 				{
;     930 				goto lbl_0002;
;     931 				}
;     932 			else step=s2;
;     933 
;     934           //step=s2;
;     935 		}
;     936 
;     937 	else if(step==s2)
;     938 		{
;     939 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     940           if(!bVR)goto step_contr_end;
;     941 
;     942 lbl_0002:
;     943           step=s100;
;     944 		cnt_del=40;
;     945           }
;     946 	else if(step==s100)
;     947 		{
;     948 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;     949           cnt_del--;
;     950           if(cnt_del==0)
;     951 			{
;     952           	step=s3;
;     953           	cnt_del=50;
;     954 			}
;     955 		}
;     956 	else if(step==s3)
;     957 		{
;     958 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     959           cnt_del--;
;     960           if(cnt_del==0)
;     961 			{
;     962           	step=s4;
;     963 			}
;     964 		}
;     965 	else if(step==s4)
;     966 		{
;     967 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;     968           if(!bMD2)goto step_contr_end;
;     969           step=s5;
;     970           cnt_del=20;
;     971 		}
;     972 	else if(step==s5)
;     973 		{
;     974 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     975           cnt_del--;
;     976           if(cnt_del==0)
;     977 			{
;     978           	step=s6;
;     979           	cnt_del=ee_delay[prog,0]*10U;
;     980 			}
;     981           }
;     982 	else if(step==s6)
;     983 		{
;     984 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;     985           cnt_del--;
;     986           if(cnt_del==0)
;     987 			{
;     988           	step=s7;
;     989           	cnt_del=20;
;     990 			}
;     991           }
;     992 	else if(step==s7)
;     993 		{
;     994 		temp|=(1<<PP1);
;     995           cnt_del--;
;     996           if(cnt_del==0)
;     997 			{
;     998           	step=sOFF;
;     999           	}
;    1000           }
;    1001 	}
;    1002 
;    1003 else if(prog==p3)   //твист
;    1004 	{
;    1005 	if(step==s1)
;    1006 		{
;    1007 		temp|=(1<<PP1);
;    1008           if(!bMD1)goto step_contr_end;
;    1009 
;    1010 			if(ee_vacuum_mode==evmOFF)
;    1011 				{
;    1012 				goto lbl_0003;
;    1013 				}
;    1014 			else step=s2;
;    1015 
;    1016           //step=s2;
;    1017 		}
;    1018 
;    1019 	else if(step==s2)
;    1020 		{
;    1021 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1022           if(!bVR)goto step_contr_end;
;    1023 lbl_0003:
;    1024           cnt_del=50;
;    1025 		step=s3;
;    1026 		}
;    1027 
;    1028 
;    1029 	else	if(step==s3)
;    1030 		{
;    1031 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1032 		cnt_del--;
;    1033 		if(cnt_del==0)
;    1034 			{
;    1035 			cnt_del=ee_delay[prog,0]*10U;
;    1036 			step=s4;
;    1037 			}
;    1038           }
;    1039 	else if(step==s4)
;    1040 		{
;    1041 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1042 		cnt_del--;
;    1043  		if(cnt_del==0)
;    1044 			{
;    1045 			cnt_del=ee_delay[prog,1]*10U;
;    1046 			step=s5;
;    1047 			}
;    1048 		}
;    1049 
;    1050 	else if(step==s5)
;    1051 		{
;    1052 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1053 		cnt_del--;
;    1054 		if(cnt_del==0)
;    1055 			{
;    1056 			step=s6;
;    1057 			cnt_del=20;
;    1058 			}
;    1059 		}
;    1060 
;    1061 	else if(step==s6)
;    1062 		{
;    1063 		temp|=(1<<PP1);
;    1064   		cnt_del--;
;    1065 		if(cnt_del==0)
;    1066 			{
;    1067 			step=sOFF;
;    1068 			}
;    1069 		}
;    1070 
;    1071 	}
;    1072 
;    1073 else if(prog==p4)      //замок
;    1074 	{
;    1075 	if(step==s1)
;    1076 		{
;    1077 		temp|=(1<<PP1);
;    1078           if(!bMD1)goto step_contr_end;
;    1079 
;    1080 			if(ee_vacuum_mode==evmOFF)
;    1081 				{
;    1082 				goto lbl_0004;
;    1083 				}
;    1084 			else step=s2;
;    1085           //step=s2;
;    1086 		}
;    1087 
;    1088 	else if(step==s2)
;    1089 		{
;    1090 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1091           if(!bVR)goto step_contr_end;
;    1092 lbl_0004:
;    1093           step=s3;
;    1094 		cnt_del=50;
;    1095           }
;    1096 
;    1097 	else if(step==s3)
;    1098 		{
;    1099 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1100           cnt_del--;
;    1101           if(cnt_del==0)
;    1102 			{
;    1103           	step=s4;
;    1104 			cnt_del=ee_delay[prog,0]*10U;
;    1105 			}
;    1106           }
;    1107 
;    1108    	else if(step==s4)
;    1109 		{
;    1110 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1111 		cnt_del--;
;    1112 		if(cnt_del==0)
;    1113 			{
;    1114 			step=s5;
;    1115 			cnt_del=30;
;    1116 			}
;    1117 		}
;    1118 
;    1119 	else if(step==s5)
;    1120 		{
;    1121 		temp|=(1<<PP1)|(1<<PP4);
;    1122 		cnt_del--;
;    1123 		if(cnt_del==0)
;    1124 			{
;    1125 			step=s6;
;    1126 			cnt_del=ee_delay[prog,1]*10U;
;    1127 			}
;    1128 		}
;    1129 
;    1130 	else if(step==s6)
;    1131 		{
;    1132 		temp|=(1<<PP4);
;    1133 		cnt_del--;
;    1134 		if(cnt_del==0)
;    1135 			{
;    1136 			step=sOFF;
;    1137 			}
;    1138 		}
;    1139 
;    1140 	}
;    1141 	
;    1142 step_contr_end:
;    1143 
;    1144 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1145 
;    1146 PORTB=~temp;
;    1147 //PORTB=0x55;
;    1148 }
;    1149 #endif
;    1150 
;    1151 #ifdef I220_WI
;    1152 //-----------------------------------------------
;    1153 void step_contr(void)
;    1154 {
;    1155 char temp=0;
;    1156 DDRB=0xFF;
;    1157 
;    1158 if(step==sOFF)goto step_contr_end;
;    1159 
;    1160 else if(prog==p3)   //твист
;    1161 	{
;    1162 	if(step==s1)
;    1163 		{
;    1164 		temp|=(1<<PP1);
;    1165           if(!bMD1)goto step_contr_end;
;    1166 
;    1167 			if(ee_vacuum_mode==evmOFF)
;    1168 				{
;    1169 				goto lbl_0003;
;    1170 				}
;    1171 			else step=s2;
;    1172 
;    1173           //step=s2;
;    1174 		}
;    1175 
;    1176 	else if(step==s2)
;    1177 		{
;    1178 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1179           if(!bVR)goto step_contr_end;
;    1180 lbl_0003:
;    1181           cnt_del=50;
;    1182 		step=s3;
;    1183 		}
;    1184 
;    1185 
;    1186 	else	if(step==s3)
;    1187 		{
;    1188 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1189 		cnt_del--;
;    1190 		if(cnt_del==0)
;    1191 			{
;    1192 			cnt_del=90;
;    1193 			step=s4;
;    1194 			}
;    1195           }
;    1196 	else if(step==s4)
;    1197 		{
;    1198 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1199 		cnt_del--;
;    1200  		if(cnt_del==0)
;    1201 			{
;    1202 			cnt_del=130;
;    1203 			step=s5;
;    1204 			}
;    1205 		}
;    1206 
;    1207 	else if(step==s5)
;    1208 		{
;    1209 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1210 		cnt_del--;
;    1211 		if(cnt_del==0)
;    1212 			{
;    1213 			step=s6;
;    1214 			cnt_del=20;
;    1215 			}
;    1216 		}
;    1217 
;    1218 	else if(step==s6)
;    1219 		{
;    1220 		temp|=(1<<PP1);
;    1221   		cnt_del--;
;    1222 		if(cnt_del==0)
;    1223 			{
;    1224 			step=sOFF;
;    1225 			}
;    1226 		}
;    1227 
;    1228 	}
;    1229 
;    1230 else if(prog==p4)      //замок
;    1231 	{
;    1232 	if(step==s1)
;    1233 		{
;    1234 		temp|=(1<<PP1);
;    1235           if(!bMD1)goto step_contr_end;
;    1236 
;    1237 			if(ee_vacuum_mode==evmOFF)
;    1238 				{
;    1239 				goto lbl_0004;
;    1240 				}
;    1241 			else step=s2;
;    1242           //step=s2;
;    1243 		}
;    1244 
;    1245 	else if(step==s2)
;    1246 		{
;    1247 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1248           if(!bVR)goto step_contr_end;
;    1249 lbl_0004:
;    1250           step=s3;
;    1251 		cnt_del=50;
;    1252           }
;    1253 
;    1254 	else if(step==s3)
;    1255 		{
;    1256 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1257           cnt_del--;
;    1258           if(cnt_del==0)
;    1259 			{
;    1260           	step=s4;
;    1261 			cnt_del=120;
;    1262 			}
;    1263           }
;    1264 
;    1265    	else if(step==s4)
;    1266 		{
;    1267 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1268 		cnt_del--;
;    1269 		if(cnt_del==0)
;    1270 			{
;    1271 			step=s5;
;    1272 			cnt_del=30;
;    1273 			}
;    1274 		}
;    1275 
;    1276 	else if(step==s5)
;    1277 		{
;    1278 		temp|=(1<<PP1)|(1<<PP4);
;    1279 		cnt_del--;
;    1280 		if(cnt_del==0)
;    1281 			{
;    1282 			step=s6;
;    1283 			cnt_del=120;
;    1284 			}
;    1285 		}
;    1286 
;    1287 	else if(step==s6)
;    1288 		{
;    1289 		temp|=(1<<PP4);
;    1290 		cnt_del--;
;    1291 		if(cnt_del==0)
;    1292 			{
;    1293 			step=sOFF;
;    1294 			}
;    1295 		}
;    1296 
;    1297 	}
;    1298 	
;    1299 step_contr_end:
;    1300 
;    1301 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1302 
;    1303 PORTB=~temp;
;    1304 //PORTB=0x55;
;    1305 }
;    1306 #endif 
;    1307 
;    1308 #ifdef I380_WI
;    1309 //-----------------------------------------------
;    1310 void step_contr(void)
;    1311 {
_step_contr:
;    1312 char temp=0;
;    1313 DDRB=0xFF;
	ST   -Y,R16
;	temp -> R16
	LDI  R16,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
;    1314 
;    1315 if(step==sOFF)goto step_contr_end;
	TST  R11
	BRNE _0x45
	RJMP _0x46
;    1316 
;    1317 else if(prog==p1)
_0x45:
	LDI  R30,LOW(1)
	CP   R30,R10
	BREQ PC+3
	JMP _0x48
;    1318 	{
;    1319 	if(step==s1)    //жесть
	CP   R30,R11
	BRNE _0x49
;    1320 		{
;    1321 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    1322           if(!bMD1)goto step_contr_end;
	LDS  R30,_bMD1
	CPI  R30,0
	BRNE _0x4A
	RJMP _0x46
;    1323 
;    1324 			if(ee_vacuum_mode==evmOFF)
_0x4A:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x4C
;    1325 				{
;    1326 				goto lbl_0001;
;    1327 				}
;    1328 			else step=s2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;    1329 		}
;    1330 
;    1331 	else if(step==s2)
	RJMP _0x4E
_0x49:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x4F
;    1332 		{
;    1333 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;    1334           if(!bVR)goto step_contr_end;
	LDS  R30,_bVR
	CPI  R30,0
	BRNE _0x50
	RJMP _0x46
;    1335 lbl_0001:
_0x50:
_0x4C:
;    1336 
;    1337           step=s100;
	CALL SUBOPT_0x1
;    1338 		cnt_del=40;
;    1339           }
;    1340 	else if(step==s100)
	RJMP _0x51
_0x4F:
	LDI  R30,LOW(19)
	CP   R30,R11
	BRNE _0x52
;    1341 		{
;    1342 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;    1343           cnt_del--;
	CALL SUBOPT_0x2
;    1344           if(cnt_del==0)
	BRNE _0x53
;    1345 			{
;    1346           	step=s3;
	CALL SUBOPT_0x3
;    1347           	cnt_del=50;
;    1348 			}
;    1349 		}
_0x53:
;    1350 
;    1351 	else if(step==s3)
	RJMP _0x54
_0x52:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0x55
;    1352 		{
;    1353 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(241)
;    1354           cnt_del--;
	CALL SUBOPT_0x2
;    1355           if(cnt_del==0)
	BRNE _0x56
;    1356 			{
;    1357           	step=s4;
	LDI  R30,LOW(4)
	MOV  R11,R30
;    1358 			}
;    1359 		}
_0x56:
;    1360 	else if(step==s4)
	RJMP _0x57
_0x55:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0x58
;    1361 		{
;    1362 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
	ORI  R16,LOW(249)
;    1363           if(!bMD2)goto step_contr_end;
	SBRS R3,2
	RJMP _0x46
;    1364           step=s54;
	LDI  R30,LOW(17)
	CALL SUBOPT_0x4
;    1365           cnt_del=20;
;    1366 		}
;    1367 	else if(step==s54)
	RJMP _0x5A
_0x58:
	LDI  R30,LOW(17)
	CP   R30,R11
	BRNE _0x5B
;    1368 		{
;    1369 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
	ORI  R16,LOW(249)
;    1370           cnt_del--;
	CALL SUBOPT_0x2
;    1371           if(cnt_del==0)
	BRNE _0x5C
;    1372 			{
;    1373           	step=s5;
	LDI  R30,LOW(5)
	CALL SUBOPT_0x4
;    1374           	cnt_del=20;
;    1375 			}
;    1376           }
_0x5C:
;    1377 
;    1378 	else if(step==s5)
	RJMP _0x5D
_0x5B:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0x5E
;    1379 		{
;    1380 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(241)
;    1381           cnt_del--;
	CALL SUBOPT_0x2
;    1382           if(cnt_del==0)
	BRNE _0x5F
;    1383 			{
;    1384           	step=s6;
	LDI  R30,LOW(6)
	MOV  R11,R30
;    1385 			}
;    1386           }
_0x5F:
;    1387 	else if(step==s6)
	RJMP _0x60
_0x5E:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0x61
;    1388 		{
;    1389 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
	ORI  R16,LOW(245)
;    1390           if(!bMD3)goto step_contr_end;
	SBRS R3,3
	RJMP _0x46
;    1391           step=s55;
	LDI  R30,LOW(18)
	MOV  R11,R30
;    1392           cnt_del=40;
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    1393 		}
;    1394 	else if(step==s55)
	RJMP _0x63
_0x61:
	LDI  R30,LOW(18)
	CP   R30,R11
	BRNE _0x64
;    1395 		{
;    1396 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
	ORI  R16,LOW(245)
;    1397           cnt_del--;
	CALL SUBOPT_0x2
;    1398           if(cnt_del==0)
	BRNE _0x65
;    1399 			{
;    1400           	step=s7;
	LDI  R30,LOW(7)
	CALL SUBOPT_0x4
;    1401           	cnt_del=20;
;    1402 			}
;    1403           }
_0x65:
;    1404 	else if(step==s7)
	RJMP _0x66
_0x64:
	LDI  R30,LOW(7)
	CP   R30,R11
	BRNE _0x67
;    1405 		{
;    1406 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(241)
;    1407           cnt_del--;
	CALL SUBOPT_0x2
;    1408           if(cnt_del==0)
	BRNE _0x68
;    1409 			{
;    1410           	step=s8;
	LDI  R30,LOW(8)
	CALL SUBOPT_0x5
;    1411           	cnt_del=130;
;    1412 			}
;    1413           }
_0x68:
;    1414 	else if(step==s8)
	RJMP _0x69
_0x67:
	LDI  R30,LOW(8)
	CP   R30,R11
	BRNE _0x6A
;    1415 		{
;    1416 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;    1417           cnt_del--;
	CALL SUBOPT_0x2
;    1418           if(cnt_del==0)
	BRNE _0x6B
;    1419 			{
;    1420           	step=s9;
	LDI  R30,LOW(9)
	CALL SUBOPT_0x4
;    1421           	cnt_del=20;
;    1422 			}
;    1423           }
_0x6B:
;    1424 	else if(step==s9)
	RJMP _0x6C
_0x6A:
	LDI  R30,LOW(9)
	CP   R30,R11
	BRNE _0x6D
;    1425 		{
;    1426 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    1427           cnt_del--;
	CALL SUBOPT_0x2
;    1428           if(cnt_del==0)
	BRNE _0x6E
;    1429 			{
;    1430           	step=sOFF;
	CLR  R11
;    1431           	}
;    1432           }
_0x6E:
;    1433 	}
_0x6D:
_0x6C:
_0x69:
_0x66:
_0x63:
_0x60:
_0x5D:
_0x5A:
_0x57:
_0x54:
_0x51:
_0x4E:
;    1434 
;    1435 else if(prog==p2)  //ско
	RJMP _0x6F
_0x48:
	LDI  R30,LOW(2)
	CP   R30,R10
	BREQ PC+3
	JMP _0x70
;    1436 	{
;    1437 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x71
;    1438 		{
;    1439 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    1440           if(!bMD1)goto step_contr_end;
	LDS  R30,_bMD1
	CPI  R30,0
	BRNE _0x72
	RJMP _0x46
;    1441 
;    1442 			if(ee_vacuum_mode==evmOFF)
_0x72:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x74
;    1443 				{
;    1444 				goto lbl_0002;
;    1445 				}
;    1446 			else step=s2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;    1447 
;    1448           //step=s2;
;    1449 		}
;    1450 
;    1451 	else if(step==s2)
	RJMP _0x76
_0x71:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x77
;    1452 		{
;    1453 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;    1454           if(!bVR)goto step_contr_end;
	LDS  R30,_bVR
	CPI  R30,0
	BRNE _0x78
	RJMP _0x46
;    1455 
;    1456 lbl_0002:
_0x78:
_0x74:
;    1457           step=s100;
	CALL SUBOPT_0x1
;    1458 		cnt_del=40;
;    1459           }
;    1460 	else if(step==s100)
	RJMP _0x79
_0x77:
	LDI  R30,LOW(19)
	CP   R30,R11
	BRNE _0x7A
;    1461 		{
;    1462 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;    1463           cnt_del--;
	CALL SUBOPT_0x2
;    1464           if(cnt_del==0)
	BRNE _0x7B
;    1465 			{
;    1466           	step=s3;
	CALL SUBOPT_0x3
;    1467           	cnt_del=50;
;    1468 			}
;    1469 		}
_0x7B:
;    1470 	else if(step==s3)
	RJMP _0x7C
_0x7A:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0x7D
;    1471 		{
;    1472 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(241)
;    1473           cnt_del--;
	CALL SUBOPT_0x2
;    1474           if(cnt_del==0)
	BRNE _0x7E
;    1475 			{
;    1476           	step=s4;
	LDI  R30,LOW(4)
	MOV  R11,R30
;    1477 			}
;    1478 		}
_0x7E:
;    1479 	else if(step==s4)
	RJMP _0x7F
_0x7D:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0x80
;    1480 		{
;    1481 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
	ORI  R16,LOW(249)
;    1482           if(!bMD2)goto step_contr_end;
	SBRS R3,2
	RJMP _0x46
;    1483           step=s5;
	LDI  R30,LOW(5)
	CALL SUBOPT_0x4
;    1484           cnt_del=20;
;    1485 		}
;    1486 	else if(step==s5)
	RJMP _0x82
_0x80:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0x83
;    1487 		{
;    1488 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(241)
;    1489           cnt_del--;
	CALL SUBOPT_0x2
;    1490           if(cnt_del==0)
	BRNE _0x84
;    1491 			{
;    1492           	step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x5
;    1493           	cnt_del=130;
;    1494 			}
;    1495           }
_0x84:
;    1496 	else if(step==s6)
	RJMP _0x85
_0x83:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0x86
;    1497 		{
;    1498 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;    1499           cnt_del--;
	CALL SUBOPT_0x2
;    1500           if(cnt_del==0)
	BRNE _0x87
;    1501 			{
;    1502           	step=s7;
	LDI  R30,LOW(7)
	CALL SUBOPT_0x4
;    1503           	cnt_del=20;
;    1504 			}
;    1505           }
_0x87:
;    1506 	else if(step==s7)
	RJMP _0x88
_0x86:
	LDI  R30,LOW(7)
	CP   R30,R11
	BRNE _0x89
;    1507 		{
;    1508 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    1509           cnt_del--;
	CALL SUBOPT_0x2
;    1510           if(cnt_del==0)
	BRNE _0x8A
;    1511 			{
;    1512           	step=sOFF;
	CLR  R11
;    1513           	}
;    1514           }
_0x8A:
;    1515 	}
_0x89:
_0x88:
_0x85:
_0x82:
_0x7F:
_0x7C:
_0x79:
_0x76:
;    1516 
;    1517 else if(prog==p3)   //твист
	RJMP _0x8B
_0x70:
	LDI  R30,LOW(3)
	CP   R30,R10
	BREQ PC+3
	JMP _0x8C
;    1518 	{
;    1519 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x8D
;    1520 		{
;    1521 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    1522           if(!bMD1)goto step_contr_end;
	LDS  R30,_bMD1
	CPI  R30,0
	BRNE _0x8E
	RJMP _0x46
;    1523 
;    1524 			if(ee_vacuum_mode==evmOFF)
_0x8E:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x90
;    1525 				{
;    1526 				goto lbl_0003;
;    1527 				}
;    1528 			else step=s2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;    1529 
;    1530           //step=s2;
;    1531 		}
;    1532 
;    1533 	else if(step==s2)
	RJMP _0x92
_0x8D:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x93
;    1534 		{
;    1535 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;    1536           if(!bVR)goto step_contr_end;
	LDS  R30,_bVR
	CPI  R30,0
	BRNE _0x94
	RJMP _0x46
;    1537 lbl_0003:
_0x94:
_0x90:
;    1538           cnt_del=50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    1539 		step=s3;
	LDI  R30,LOW(3)
	MOV  R11,R30
;    1540 		}
;    1541 
;    1542 
;    1543 	else	if(step==s3)
	RJMP _0x95
_0x93:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0x96
;    1544 		{
;    1545 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;    1546 		cnt_del--;
	CALL SUBOPT_0x2
;    1547 		if(cnt_del==0)
	BRNE _0x97
;    1548 			{
;    1549 			cnt_del=90;
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    1550 			step=s4;
	LDI  R30,LOW(4)
	MOV  R11,R30
;    1551 			}
;    1552           }
_0x97:
;    1553 	else if(step==s4)
	RJMP _0x98
_0x96:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0x99
;    1554 		{
;    1555 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
	ORI  R16,LOW(252)
;    1556 		cnt_del--;
	CALL SUBOPT_0x2
;    1557  		if(cnt_del==0)
	BRNE _0x9A
;    1558 			{
;    1559 			cnt_del=130;
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    1560 			step=s5;
	LDI  R30,LOW(5)
	MOV  R11,R30
;    1561 			}
;    1562 		}
_0x9A:
;    1563 
;    1564 	else if(step==s5)
	RJMP _0x9B
_0x99:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0x9C
;    1565 		{
;    1566 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
	ORI  R16,LOW(204)
;    1567 		cnt_del--;
	CALL SUBOPT_0x2
;    1568 		if(cnt_del==0)
	BRNE _0x9D
;    1569 			{
;    1570 			step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x4
;    1571 			cnt_del=20;
;    1572 			}
;    1573 		}
_0x9D:
;    1574 
;    1575 	else if(step==s6)
	RJMP _0x9E
_0x9C:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0x9F
;    1576 		{
;    1577 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    1578   		cnt_del--;
	CALL SUBOPT_0x2
;    1579 		if(cnt_del==0)
	BRNE _0xA0
;    1580 			{
;    1581 			step=sOFF;
	CLR  R11
;    1582 			}
;    1583 		}
_0xA0:
;    1584 
;    1585 	}
_0x9F:
_0x9E:
_0x9B:
_0x98:
_0x95:
_0x92:
;    1586 
;    1587 else if(prog==p4)      //замок
	RJMP _0xA1
_0x8C:
	LDI  R30,LOW(4)
	CP   R30,R10
	BREQ PC+3
	JMP _0xA2
;    1588 	{
;    1589 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0xA3
;    1590 		{
;    1591 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    1592           if(!bMD1)goto step_contr_end;
	LDS  R30,_bMD1
	CPI  R30,0
	BRNE _0xA4
	RJMP _0x46
;    1593 
;    1594 			if(ee_vacuum_mode==evmOFF)
_0xA4:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0xA6
;    1595 				{
;    1596 				goto lbl_0004;
;    1597 				}
;    1598 			else step=s2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;    1599           //step=s2;
;    1600 		}
;    1601 
;    1602 	else if(step==s2)
	RJMP _0xA8
_0xA3:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0xA9
;    1603 		{
;    1604 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;    1605           if(!bVR)goto step_contr_end;
	LDS  R30,_bVR
	CPI  R30,0
	BREQ _0x46
;    1606 lbl_0004:
_0xA6:
;    1607           step=s3;
	CALL SUBOPT_0x3
;    1608 		cnt_del=50;
;    1609           }
;    1610 
;    1611 	else if(step==s3)
	RJMP _0xAB
_0xA9:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0xAC
;    1612 		{
;    1613 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;    1614           cnt_del--;
	CALL SUBOPT_0x2
;    1615           if(cnt_del==0)
	BRNE _0xAD
;    1616 			{
;    1617           	step=s4;
	LDI  R30,LOW(4)
	CALL SUBOPT_0x6
;    1618 			cnt_del=120U;
;    1619 			}
;    1620           }
_0xAD:
;    1621 
;    1622    	else if(step==s4)
	RJMP _0xAE
_0xAC:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0xAF
;    1623 		{
;    1624 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;    1625 		cnt_del--;
	CALL SUBOPT_0x2
;    1626 		if(cnt_del==0)
	BRNE _0xB0
;    1627 			{
;    1628 			step=s5;
	LDI  R30,LOW(5)
	MOV  R11,R30
;    1629 			cnt_del=30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    1630 			}
;    1631 		}
_0xB0:
;    1632 
;    1633 	else if(step==s5)
	RJMP _0xB1
_0xAF:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0xB2
;    1634 		{
;    1635 		temp|=(1<<PP1)|(1<<PP4);
	ORI  R16,LOW(80)
;    1636 		cnt_del--;
	CALL SUBOPT_0x2
;    1637 		if(cnt_del==0)
	BRNE _0xB3
;    1638 			{
;    1639 			step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x6
;    1640 			cnt_del=120U;
;    1641 			}
;    1642 		}
_0xB3:
;    1643 
;    1644 	else if(step==s6)
	RJMP _0xB4
_0xB2:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0xB5
;    1645 		{
;    1646 		temp|=(1<<PP4);
	ORI  R16,LOW(16)
;    1647 		cnt_del--;
	CALL SUBOPT_0x2
;    1648 		if(cnt_del==0)
	BRNE _0xB6
;    1649 			{
;    1650 			step=sOFF;
	CLR  R11
;    1651 			}
;    1652 		}
_0xB6:
;    1653 
;    1654 	}
_0xB5:
_0xB4:
_0xB1:
_0xAE:
_0xAB:
_0xA8:
;    1655 	
;    1656 step_contr_end:
_0xA2:
_0xA1:
_0x8B:
_0x6F:
_0x46:
;    1657 
;    1658 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BRNE _0xB7
	ANDI R16,LOW(223)
;    1659 
;    1660 PORTB=~temp;
_0xB7:
	MOV  R30,R16
	COM  R30
	OUT  0x18,R30
;    1661 //PORTB=0x55;
;    1662 }
	LD   R16,Y+
	RET
;    1663 #endif
;    1664 
;    1665 #ifdef I220
;    1666 //-----------------------------------------------
;    1667 void step_contr(void)
;    1668 {
;    1669 char temp=0;
;    1670 DDRB=0xFF;
;    1671 
;    1672 if(step==sOFF)goto step_contr_end;
;    1673 
;    1674 else if(prog==p3)   //твист
;    1675 	{
;    1676 	if(step==s1)
;    1677 		{
;    1678 		temp|=(1<<PP1);
;    1679           if(!bMD1)goto step_contr_end;
;    1680 
;    1681 			if(ee_vacuum_mode==evmOFF)
;    1682 				{
;    1683 				goto lbl_0003;
;    1684 				}
;    1685 			else step=s2;
;    1686 
;    1687           //step=s2;
;    1688 		}
;    1689 
;    1690 	else if(step==s2)
;    1691 		{
;    1692 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1693           if(!bVR)goto step_contr_end;
;    1694 lbl_0003:
;    1695           cnt_del=50;
;    1696 		step=s3;
;    1697 		}
;    1698 
;    1699 
;    1700 	else	if(step==s3)
;    1701 		{
;    1702 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1703 		cnt_del--;
;    1704 		if(cnt_del==0)
;    1705 			{
;    1706 			cnt_del=ee_delay[prog,0]*10U;
;    1707 			step=s4;
;    1708 			}
;    1709           }
;    1710 	else if(step==s4)
;    1711 		{
;    1712 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1713 		cnt_del--;
;    1714  		if(cnt_del==0)
;    1715 			{
;    1716 			cnt_del=ee_delay[prog,1]*10U;
;    1717 			step=s5;
;    1718 			}
;    1719 		}
;    1720 
;    1721 	else if(step==s5)
;    1722 		{
;    1723 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1724 		cnt_del--;
;    1725 		if(cnt_del==0)
;    1726 			{
;    1727 			step=s6;
;    1728 			cnt_del=20;
;    1729 			}
;    1730 		}
;    1731 
;    1732 	else if(step==s6)
;    1733 		{
;    1734 		temp|=(1<<PP1);
;    1735   		cnt_del--;
;    1736 		if(cnt_del==0)
;    1737 			{
;    1738 			step=sOFF;
;    1739 			}
;    1740 		}
;    1741 
;    1742 	}
;    1743 
;    1744 else if(prog==p4)      //замок
;    1745 	{
;    1746 	if(step==s1)
;    1747 		{
;    1748 		temp|=(1<<PP1);
;    1749           if(!bMD1)goto step_contr_end;
;    1750 
;    1751 			if(ee_vacuum_mode==evmOFF)
;    1752 				{
;    1753 				goto lbl_0004;
;    1754 				}
;    1755 			else step=s2;
;    1756           //step=s2;
;    1757 		}
;    1758 
;    1759 	else if(step==s2)
;    1760 		{
;    1761 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1762           if(!bVR)goto step_contr_end;
;    1763 lbl_0004:
;    1764           step=s3;
;    1765 		cnt_del=50;
;    1766           }
;    1767 
;    1768 	else if(step==s3)
;    1769 		{
;    1770 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1771           cnt_del--;
;    1772           if(cnt_del==0)
;    1773 			{
;    1774           	step=s4;
;    1775 			cnt_del=ee_delay[prog,0]*10U;
;    1776 			}
;    1777           }
;    1778 
;    1779    	else if(step==s4)
;    1780 		{
;    1781 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1782 		cnt_del--;
;    1783 		if(cnt_del==0)
;    1784 			{
;    1785 			step=s5;
;    1786 			cnt_del=30;
;    1787 			}
;    1788 		}
;    1789 
;    1790 	else if(step==s5)
;    1791 		{
;    1792 		temp|=(1<<PP1)|(1<<PP4);
;    1793 		cnt_del--;
;    1794 		if(cnt_del==0)
;    1795 			{
;    1796 			step=s6;
;    1797 			cnt_del=ee_delay[prog,1]*10U;
;    1798 			}
;    1799 		}
;    1800 
;    1801 	else if(step==s6)
;    1802 		{
;    1803 		temp|=(1<<PP4);
;    1804 		cnt_del--;
;    1805 		if(cnt_del==0)
;    1806 			{
;    1807 			step=sOFF;
;    1808 			}
;    1809 		}
;    1810 
;    1811 	}
;    1812 	
;    1813 step_contr_end:
;    1814 
;    1815 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1816 
;    1817 PORTB=~temp;
;    1818 //PORTB=0x55;
;    1819 }
;    1820 #endif 
;    1821 
;    1822 #ifdef TVIST_SKO
;    1823 //-----------------------------------------------
;    1824 void step_contr(void)
;    1825 {
;    1826 char temp=0;
;    1827 DDRB=0xFF;
;    1828 
;    1829 if(step==sOFF)
;    1830 	{
;    1831 	temp=0;
;    1832 	}
;    1833 
;    1834 if(prog==p2) //СКО
;    1835 	{
;    1836 	if(step==s1)
;    1837 		{
;    1838 		temp|=(1<<PP1);
;    1839 
;    1840 		cnt_del--;
;    1841 		if(cnt_del==0)
;    1842 			{
;    1843 			step=s2;
;    1844 			cnt_del=30;
;    1845 			}
;    1846 		}
;    1847 
;    1848 	else if(step==s2)
;    1849 		{
;    1850 		temp|=(1<<PP1)|(1<<DV);
;    1851 
;    1852 		cnt_del--;
;    1853 		if(cnt_del==0)
;    1854 			{
;    1855 			step=s3;
;    1856 			}
;    1857 		}
;    1858 
;    1859 
;    1860 	else if(step==s3)
;    1861 		{
;    1862 		temp|=(1<<PP1)|(1<<DV)|(1<<PP2);
;    1863 
;    1864                	if(bMD1)//goto step_contr_end;
;    1865                		{  
;    1866                		cnt_del=100;
;    1867 	       		step=s4;
;    1868 	       		}
;    1869 	       	}
;    1870 
;    1871 	else if(step==s4)
;    1872 		{
;    1873 		temp|=(1<<PP1);
;    1874 		cnt_del--;
;    1875 		if(cnt_del==0)
;    1876 			{
;    1877 			step=sOFF;
;    1878 			}
;    1879 		}
;    1880 
;    1881 	}
;    1882 
;    1883 if(prog==p3)
;    1884 	{
;    1885 	if(step==s1)
;    1886 		{
;    1887 		temp|=(1<<PP1);
;    1888 
;    1889 		cnt_del--;
;    1890 		if(cnt_del==0)
;    1891 			{
;    1892 			step=s2;
;    1893 			cnt_del=100;
;    1894 			}
;    1895 		}
;    1896 
;    1897 	else if(step==s2)
;    1898 		{
;    1899 		temp|=(1<<PP1)|(1<<PP2);
;    1900 
;    1901 		cnt_del--;
;    1902 		if(cnt_del==0)
;    1903 			{
;    1904 			step=s3;
;    1905 			cnt_del=50;
;    1906 			}
;    1907 		}
;    1908 
;    1909 
;    1910 	else if(step==s3)
;    1911 		{
;    1912 		temp|=(1<<PP2);
;    1913 	
;    1914 		cnt_del--;
;    1915 		if(cnt_del==0)
;    1916 			{
;    1917 			step=sOFF;
;    1918 			}
;    1919                	}
;    1920 	}
;    1921 step_contr_end:
;    1922 
;    1923 PORTB=~temp;
;    1924 }
;    1925 #endif
;    1926 //-----------------------------------------------
;    1927 void bin2bcd_int(unsigned int in)
;    1928 {
_bin2bcd_int:
;    1929 char i;
;    1930 for(i=3;i>0;i--)
	ST   -Y,R16
;	in -> Y+1
;	i -> R16
	LDI  R16,LOW(3)
_0xB9:
	LDI  R30,LOW(0)
	CP   R30,R16
	BRSH _0xBA
;    1931 	{
;    1932 	dig[i]=in%10;
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
;    1933 	in/=10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
;    1934 	}   
	SUBI R16,1
	RJMP _0xB9
_0xBA:
;    1935 }
	LDD  R16,Y+0
	RJMP _0x125
;    1936 
;    1937 //-----------------------------------------------
;    1938 void bcd2ind(char s)
;    1939 {
_bcd2ind:
;    1940 char i;
;    1941 bZ=1;
	ST   -Y,R16
;	s -> Y+1
;	i -> R16
	SET
	BLD  R2,3
;    1942 for (i=0;i<5;i++)
	LDI  R16,LOW(0)
_0xBC:
	CPI  R16,5
	BRLO PC+3
	JMP _0xBD
;    1943 	{
;    1944 	if(bZ&&(!dig[i-1])&&(i<4))
	SBRS R2,3
	RJMP _0xBF
	CALL SUBOPT_0x7
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	CPI  R30,0
	BRNE _0xBF
	CPI  R16,4
	BRLO _0xC0
_0xBF:
	RJMP _0xBE
_0xC0:
;    1945 		{
;    1946 		if((4-i)>s)
	LDI  R30,LOW(4)
	SUB  R30,R16
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
	BRSH _0xC1
;    1947 			{
;    1948 			ind_out[i-1]=DIGISYM[10];
	CALL SUBOPT_0x7
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	POP  R26
	POP  R27
	RJMP _0x126
;    1949 			}
;    1950 		else ind_out[i-1]=DIGISYM[0];	
_0xC1:
	CALL SUBOPT_0x7
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	LPM  R30,Z
	POP  R26
	POP  R27
_0x126:
	ST   X,R30
;    1951 		}
;    1952 	else
	RJMP _0xC3
_0xBE:
;    1953 		{
;    1954 		ind_out[i-1]=DIGISYM[dig[i-1]];
	CALL SUBOPT_0x7
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x7
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	POP  R26
	POP  R27
	CALL SUBOPT_0x8
	POP  R26
	POP  R27
	ST   X,R30
;    1955 		bZ=0;
	CLT
	BLD  R2,3
;    1956 		}                   
_0xC3:
;    1957 
;    1958 	if(s)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0xC4
;    1959 		{
;    1960 		ind_out[3-s]&=0b01111111;
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
;    1961 		}	
;    1962  
;    1963 	}
_0xC4:
	SUBI R16,-1
	RJMP _0xBC
_0xBD:
;    1964 }            
	LDD  R16,Y+0
	ADIW R28,2
	RET
;    1965 //-----------------------------------------------
;    1966 void int2ind(unsigned int in,char s)
;    1967 {
_int2ind:
;    1968 bin2bcd_int(in);
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _bin2bcd_int
;    1969 bcd2ind(s);
	LD   R30,Y
	ST   -Y,R30
	CALL _bcd2ind
;    1970 
;    1971 } 
_0x125:
	ADIW R28,3
	RET
;    1972 
;    1973 //-----------------------------------------------
;    1974 void ind_hndl(void)
;    1975 {
_ind_hndl:
;    1976 int2ind(ee_delay[prog,sub_ind],1);  
	CALL SUBOPT_0x9
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _int2ind
;    1977 //ind_out[0]=0xff;//DIGISYM[0];
;    1978 //ind_out[1]=0xff;//DIGISYM[1];
;    1979 //ind_out[2]=DIGISYM[2];//0xff;
;    1980 //ind_out[0]=DIGISYM[7]; 
;    1981 
;    1982 ind_out[0]=DIGISYM[sub_ind+1];
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	PUSH R31
	PUSH R30
	MOV  R30,R13
	SUBI R30,-LOW(1)
	POP  R26
	POP  R27
	CALL SUBOPT_0x8
	STS  _ind_out,R30
;    1983 }
	RET
;    1984 
;    1985 //-----------------------------------------------
;    1986 void led_hndl(void)
;    1987 {
_led_hndl:
;    1988 ind_out[4]=DIGISYM[10]; 
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	__PUTB1MN _ind_out,4
;    1989 
;    1990 ind_out[4]&=~(1<<LED_POW_ON); 
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xDF
	POP  R26
	POP  R27
	ST   X,R30
;    1991 
;    1992 if(step!=sOFF)
	TST  R11
	BREQ _0xC5
;    1993 	{
;    1994 	ind_out[4]&=~(1<<LED_WRK);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xBF
	POP  R26
	POP  R27
	RJMP _0x127
;    1995 	}
;    1996 else ind_out[4]|=(1<<LED_WRK);
_0xC5:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x40
	POP  R26
	POP  R27
_0x127:
	ST   X,R30
;    1997 
;    1998 
;    1999 if(step==sOFF)
	TST  R11
	BRNE _0xC7
;    2000 	{
;    2001  	if(bERR)
	SBRS R3,1
	RJMP _0xC8
;    2002 		{
;    2003 		ind_out[4]&=~(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFE
	POP  R26
	POP  R27
	RJMP _0x128
;    2004 		}
;    2005 	else
_0xC8:
;    2006 		{
;    2007 		ind_out[4]|=(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
_0x128:
	ST   X,R30
;    2008 		}
;    2009      }
;    2010 else ind_out[4]|=(1<<LED_ERROR);
	RJMP _0xCA
_0xC7:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
	ST   X,R30
_0xCA:
;    2011 
;    2012 /* 	if(bMD1)
;    2013 		{
;    2014 		ind_out[4]&=~(1<<LED_ERROR);
;    2015 		}
;    2016 	else
;    2017 		{
;    2018 		ind_out[4]|=(1<<LED_ERROR);
;    2019 		} */
;    2020 
;    2021 //if(bERR)ind_out[4]&=~(1<<LED_ERROR);
;    2022 if(ee_vacuum_mode==evmON)ind_out[4]&=~(1<<LED_VACUUM);
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0xCB
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0x7F
	POP  R26
	POP  R27
	RJMP _0x129
;    2023 else ind_out[4]|=(1<<LED_VACUUM);
_0xCB:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x80
	POP  R26
	POP  R27
_0x129:
	ST   X,R30
;    2024 
;    2025 if(prog==p1) ind_out[4]&=~(1<<LED_PROG1);
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0xCD
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xEF
	POP  R26
	POP  R27
	ST   X,R30
;    2026 else if(prog==p2) ind_out[4]&=~(1<<LED_PROG2);
	RJMP _0xCE
_0xCD:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0xCF
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFB
	POP  R26
	POP  R27
	ST   X,R30
;    2027 else if(prog==p3) ind_out[4]&=~(1<<LED_PROG3);
	RJMP _0xD0
_0xCF:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0xD1
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0XF7
	POP  R26
	POP  R27
	ST   X,R30
;    2028 else if(prog==p4) ind_out[4]&=~(1<<LED_PROG4);
	RJMP _0xD2
_0xD1:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0xD3
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFD
	POP  R26
	POP  R27
	ST   X,R30
;    2029 
;    2030 if(ind==iPr_sel)
_0xD3:
_0xD2:
_0xD0:
_0xCE:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0xD4
;    2031 	{
;    2032 	if(bFL5)ind_out[4]|=(1<<LED_PROG1)|(1<<LED_PROG2)|(1<<LED_PROG3)|(1<<LED_PROG4);
	SBRS R3,0
	RJMP _0xD5
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,LOW(0x1E)
	POP  R26
	POP  R27
	ST   X,R30
;    2033 	} 
_0xD5:
;    2034 	 
;    2035 if(ind==iVr)
_0xD4:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0xD6
;    2036 	{
;    2037 	if(bFL5)ind_out[4]|=(1<<LED_POW_ON);
	SBRS R3,0
	RJMP _0xD7
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x20
	POP  R26
	POP  R27
	ST   X,R30
;    2038 	}	
_0xD7:
;    2039 }
_0xD6:
	RET
;    2040 
;    2041 //-----------------------------------------------
;    2042 // Подпрограмма драйва до 7 кнопок одного порта, 
;    2043 // различает короткое и длинное нажатие,
;    2044 // срабатывает на отпускание кнопки, возможность
;    2045 // ускорения перебора при длинном нажатии...
;    2046 #define but_port PORTC
;    2047 #define but_dir  DDRC
;    2048 #define but_pin  PINC
;    2049 #define but_mask 0b01101010
;    2050 #define no_but   0b11111111
;    2051 #define but_on   5
;    2052 #define but_onL  20
;    2053 
;    2054 
;    2055 
;    2056 
;    2057 void but_drv(void)
;    2058 { 
_but_drv:
;    2059 DDRD&=0b00000111;
	IN   R30,0x11
	ANDI R30,LOW(0x7)
	CALL SUBOPT_0xA
;    2060 PORTD|=0b11111000;
;    2061 
;    2062 but_port|=(but_mask^0xff);
	CALL SUBOPT_0xB
;    2063 but_dir&=but_mask;
;    2064 #asm
;    2065 nop
nop
;    2066 nop
nop
;    2067 nop
nop
;    2068 nop
nop
;    2069 #endasm

;    2070 
;    2071 but_n=but_pin|but_mask; 
	IN   R30,0x13
	ORI  R30,LOW(0x6A)
	STS  _but_n_G1,R30
;    2072 
;    2073 if((but_n==no_but)||(but_n!=but_s))
	LDS  R26,_but_n_G1
	CPI  R26,LOW(0xFF)
	BREQ _0xD9
	RCALL SUBOPT_0xC
	BREQ _0xD8
_0xD9:
;    2074  	{
;    2075  	speed=0;
	CLT
	BLD  R2,6
;    2076    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRSH _0xDC
	LDS  R26,_but1_cnt_G1
	CPI  R26,LOW(0x0)
	BREQ _0xDE
_0xDC:
	SBRS R2,4
	RJMP _0xDF
_0xDE:
	RJMP _0xDB
_0xDF:
;    2077   		{
;    2078    	     n_but=1;
	SET
	BLD  R2,5
;    2079           but=but_s;
	LDS  R9,_but_s_G1
;    2080           }
;    2081    	if (but1_cnt>=but_onL_temp)
_0xDB:
	RCALL SUBOPT_0xD
	BRLO _0xE0
;    2082   		{
;    2083    	     n_but=1;
	SET
	BLD  R2,5
;    2084           but=but_s&0b11111101;
	RCALL SUBOPT_0xE
;    2085           }
;    2086     	l_but=0;
_0xE0:
	CLT
	BLD  R2,4
;    2087    	but_onL_temp=but_onL;
	LDI  R30,LOW(20)
	STS  _but_onL_temp_G1,R30
;    2088     	but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    2089   	but1_cnt=0;          
	STS  _but1_cnt_G1,R30
;    2090      goto but_drv_out;
	RJMP _0xE1
;    2091   	}  
;    2092   	
;    2093 if(but_n==but_s)
_0xD8:
	RCALL SUBOPT_0xC
	BRNE _0xE2
;    2094  	{
;    2095   	but0_cnt++;
	LDS  R30,_but0_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but0_cnt_G1,R30
;    2096   	if(but0_cnt>=but_on)
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRLO _0xE3
;    2097   		{
;    2098    		but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    2099    		but1_cnt++;
	LDS  R30,_but1_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but1_cnt_G1,R30
;    2100    		if(but1_cnt>=but_onL_temp)
	RCALL SUBOPT_0xD
	BRLO _0xE4
;    2101    			{              
;    2102     			but=but_s&0b11111101;
	RCALL SUBOPT_0xE
;    2103     			but1_cnt=0;
	LDI  R30,LOW(0)
	STS  _but1_cnt_G1,R30
;    2104     			n_but=1;
	SET
	BLD  R2,5
;    2105     			l_but=1;
	SET
	BLD  R2,4
;    2106 			if(speed)
	SBRS R2,6
	RJMP _0xE5
;    2107 				{
;    2108     				but_onL_temp=but_onL_temp>>1;
	LDS  R30,_but_onL_temp_G1
	LSR  R30
	STS  _but_onL_temp_G1,R30
;    2109         			if(but_onL_temp<=2) but_onL_temp=2;
	LDS  R26,_but_onL_temp_G1
	LDI  R30,LOW(2)
	CP   R30,R26
	BRLO _0xE6
	STS  _but_onL_temp_G1,R30
;    2110 				}    
_0xE6:
;    2111    			}
_0xE5:
;    2112   		} 
_0xE4:
;    2113  	}
_0xE3:
;    2114 but_drv_out:
_0xE2:
_0xE1:
;    2115 but_s=but_n;
	LDS  R30,_but_n_G1
	STS  _but_s_G1,R30
;    2116 but_port|=(but_mask^0xff);
	RCALL SUBOPT_0xB
;    2117 but_dir&=but_mask;
;    2118 }    
	RET
;    2119 
;    2120 #define butV	239
;    2121 #define butV_	237
;    2122 #define butP	251
;    2123 #define butP_	249
;    2124 #define butR	127
;    2125 #define butR_	125
;    2126 #define butL	254
;    2127 #define butL_	252
;    2128 #define butLR	126
;    2129 #define butLR_	124 
;    2130 #define butVP_ 233
;    2131 //-----------------------------------------------
;    2132 void but_an(void)
;    2133 {
_but_an:
;    2134 
;    2135 if(!(in_word&0x01))
	SBRC R14,0
	RJMP _0xE7
;    2136 	{
;    2137 	#ifdef TVIST_SKO
;    2138 	if((step==sOFF)&&(!bERR))
;    2139 		{
;    2140 		step=s1;
;    2141 		if(prog==p2) cnt_del=70;
;    2142 		else if(prog==p3) cnt_del=100;
;    2143 		}
;    2144 	#endif
;    2145 	#ifdef DV3KL2MD
;    2146 	if((step==sOFF)&&(!bERR))
;    2147 		{
;    2148 		step=s1;
;    2149 		cnt_del=70;
;    2150 		}
;    2151 	#endif	
;    2152 	#ifndef TVIST_SKO
;    2153 	if((step==sOFF)&&(!bERR))
	LDI  R30,LOW(0)
	CP   R30,R11
	BRNE _0xE9
	SBRS R3,1
	RJMP _0xEA
_0xE9:
	RJMP _0xE8
_0xEA:
;    2154 		{
;    2155 		step=s1;
	LDI  R30,LOW(1)
	MOV  R11,R30
;    2156 		if(prog==p1) cnt_del=50;
	CP   R30,R10
	BRNE _0xEB
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2157 		else if(prog==p2) cnt_del=50;
	RJMP _0xEC
_0xEB:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0xED
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2158 		else if(prog==p3) cnt_del=50;
	RJMP _0xEE
_0xED:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0xEF
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2159           #ifdef P380_MINI
;    2160   		cnt_del=100;
;    2161   		#endif
;    2162 		}
_0xEF:
_0xEE:
_0xEC:
;    2163 	#endif
;    2164 	}
_0xE8:
;    2165 if(!(in_word&0x02))
_0xE7:
	SBRC R14,1
	RJMP _0xF0
;    2166 	{
;    2167 	step=sOFF;
	CLR  R11
;    2168 
;    2169 	}
;    2170 
;    2171 if (!n_but) goto but_an_end;
_0xF0:
	SBRS R2,5
	RJMP _0xF2
;    2172 
;    2173 if(but==butV_)
	LDI  R30,LOW(237)
	CP   R30,R9
	BRNE _0xF3
;    2174 	{
;    2175 	if(ee_vacuum_mode==evmON)ee_vacuum_mode=evmOFF;
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0xF4
	LDI  R30,LOW(170)
	RJMP _0x12A
;    2176 	else ee_vacuum_mode=evmON;
_0xF4:
	LDI  R30,LOW(85)
_0x12A:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMWRB
;    2177 	}
;    2178 
;    2179 if(but==butVP_)
_0xF3:
	LDI  R30,LOW(233)
	CP   R30,R9
	BRNE _0xF6
;    2180 	{
;    2181 	if(ind!=iVr)ind=iVr;
	LDI  R30,LOW(2)
	CP   R30,R12
	BREQ _0xF7
	MOV  R12,R30
;    2182 	else ind=iMn;
	RJMP _0xF8
_0xF7:
	CLR  R12
_0xF8:
;    2183 	}
;    2184 
;    2185 	
;    2186 if(ind==iMn)
_0xF6:
	TST  R12
	BRNE _0xF9
;    2187 	{
;    2188 	if(but==butP_)ind=iPr_sel;
	LDI  R30,LOW(249)
	CP   R30,R9
	BRNE _0xFA
	LDI  R30,LOW(1)
	MOV  R12,R30
;    2189 	if(but==butLR)	
_0xFA:
	LDI  R30,LOW(126)
	CP   R30,R9
	BRNE _0xFB
;    2190 		{
;    2191 		if((prog==p3)||(prog==p4))
	LDI  R30,LOW(3)
	CP   R30,R10
	BREQ _0xFD
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0xFC
_0xFD:
;    2192 			{ 
;    2193 			if(sub_ind==0)sub_ind=1;
	TST  R13
	BRNE _0xFF
	LDI  R30,LOW(1)
	MOV  R13,R30
;    2194 			else sub_ind=0;
	RJMP _0x100
_0xFF:
	CLR  R13
_0x100:
;    2195 			}
;    2196     		else sub_ind=0;
	RJMP _0x101
_0xFC:
	CLR  R13
_0x101:
;    2197 		}	 
;    2198 	if((but==butR)||(but==butR_))	
_0xFB:
	LDI  R30,LOW(127)
	CP   R30,R9
	BREQ _0x103
	LDI  R30,LOW(125)
	CP   R30,R9
	BRNE _0x102
_0x103:
;    2199 		{  
;    2200 		speed=1;
	SET
	BLD  R2,6
;    2201 		ee_delay[prog,sub_ind]++;
	RCALL SUBOPT_0x9
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    2202 		}   
;    2203 	
;    2204 	else if((but==butL)||(but==butL_))	
	RJMP _0x105
_0x102:
	LDI  R30,LOW(254)
	CP   R30,R9
	BREQ _0x107
	LDI  R30,LOW(252)
	CP   R30,R9
	BRNE _0x106
_0x107:
;    2205 		{  
;    2206     		speed=1;
	SET
	BLD  R2,6
;    2207     		ee_delay[prog,sub_ind]--;
	RCALL SUBOPT_0x9
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    2208     		}		
;    2209 	} 
_0x106:
_0x105:
;    2210 	
;    2211 else if(ind==iPr_sel)
	RJMP _0x109
_0xF9:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x10A
;    2212 	{
;    2213 	if(but==butP_)ind=iMn;
	LDI  R30,LOW(249)
	CP   R30,R9
	BRNE _0x10B
	CLR  R12
;    2214 	if(but==butP)
_0x10B:
	LDI  R30,LOW(251)
	CP   R30,R9
	BRNE _0x10C
;    2215 		{
;    2216 		prog++;
	RCALL SUBOPT_0xF
;    2217 		if(prog>MAXPROG)prog=MINPROG;
	BRGE _0x10D
	LDI  R30,LOW(1)
	MOV  R10,R30
;    2218 		ee_program[0]=prog;
_0x10D:
	RCALL SUBOPT_0x10
;    2219 		ee_program[1]=prog;
	__POINTW2MN _ee_program,1
	MOV  R30,R10
	CALL __EEPROMWRB
;    2220 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R10
	CALL __EEPROMWRB
;    2221 		}
;    2222 	
;    2223 	if(but==butR)
_0x10C:
	LDI  R30,LOW(127)
	CP   R30,R9
	BRNE _0x10E
;    2224 		{
;    2225 		prog++;
	RCALL SUBOPT_0xF
;    2226 		if(prog>MAXPROG)prog=MINPROG;
	BRGE _0x10F
	LDI  R30,LOW(1)
	MOV  R10,R30
;    2227 		ee_program[0]=prog;
_0x10F:
	RCALL SUBOPT_0x10
;    2228 		ee_program[1]=prog;
	__POINTW2MN _ee_program,1
	MOV  R30,R10
	CALL __EEPROMWRB
;    2229 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R10
	CALL __EEPROMWRB
;    2230 		}
;    2231 
;    2232 	if(but==butL)
_0x10E:
	LDI  R30,LOW(254)
	CP   R30,R9
	BRNE _0x110
;    2233 		{
;    2234 		prog--;
	DEC  R10
;    2235 		if(prog>MAXPROG)prog=MINPROG;
	LDI  R30,LOW(4)
	CP   R30,R10
	BRGE _0x111
	LDI  R30,LOW(1)
	MOV  R10,R30
;    2236 		ee_program[0]=prog;
_0x111:
	RCALL SUBOPT_0x10
;    2237 		ee_program[1]=prog;
	__POINTW2MN _ee_program,1
	MOV  R30,R10
	CALL __EEPROMWRB
;    2238 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R10
	CALL __EEPROMWRB
;    2239 		}	
;    2240 	} 
_0x110:
;    2241 
;    2242 else if(ind==iVr)
	RJMP _0x112
_0x10A:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x113
;    2243 	{
;    2244 	if(but==butP_)
	LDI  R30,LOW(249)
	CP   R30,R9
	BRNE _0x114
;    2245 		{
;    2246 		if(ee_vr_log)ee_vr_log=0;
	LDI  R26,LOW(_ee_vr_log)
	LDI  R27,HIGH(_ee_vr_log)
	CALL __EEPROMRDB
	CPI  R30,0
	BREQ _0x115
	LDI  R30,LOW(0)
	RJMP _0x12B
;    2247 		else ee_vr_log=1;
_0x115:
	LDI  R30,LOW(1)
_0x12B:
	LDI  R26,LOW(_ee_vr_log)
	LDI  R27,HIGH(_ee_vr_log)
	CALL __EEPROMWRB
;    2248 		}	
;    2249 	} 	
_0x114:
;    2250 
;    2251 but_an_end:
_0x113:
_0x112:
_0x109:
_0xF2:
;    2252 n_but=0;
	CLT
	BLD  R2,5
;    2253 }
	RET
;    2254 
;    2255 //-----------------------------------------------
;    2256 void ind_drv(void)
;    2257 {
_ind_drv:
;    2258 if(++ind_cnt>=6)ind_cnt=0;
	INC  R8
	LDI  R30,LOW(6)
	CP   R8,R30
	BRLO _0x117
	CLR  R8
;    2259 
;    2260 if(ind_cnt<5)
_0x117:
	LDI  R30,LOW(5)
	CP   R8,R30
	BRSH _0x118
;    2261 	{
;    2262 	DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
;    2263 	PORTC=0xFF;
	OUT  0x15,R30
;    2264 	DDRD|=0b11111000;
	IN   R30,0x11
	ORI  R30,LOW(0xF8)
	RCALL SUBOPT_0xA
;    2265 	PORTD|=0b11111000;
;    2266 	PORTD&=IND_STROB[ind_cnt];
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
;    2267 	PORTC=ind_out[ind_cnt];
	MOV  R30,R8
	LDI  R31,0
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	LD   R30,Z
	OUT  0x15,R30
;    2268 	}
;    2269 else but_drv();
	RJMP _0x119
_0x118:
	CALL _but_drv
_0x119:
;    2270 }
	RET
;    2271 
;    2272 //***********************************************
;    2273 //***********************************************
;    2274 //***********************************************
;    2275 //***********************************************
;    2276 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;    2277 {
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
;    2278 TCCR0=0x02;
	RCALL SUBOPT_0x11
;    2279 TCNT0=-208;
;    2280 OCR0=0x00; 
;    2281 
;    2282 
;    2283 b600Hz=1;
	SET
	BLD  R2,0
;    2284 ind_drv();
	RCALL _ind_drv
;    2285 if(++t0_cnt0>=6)
	INC  R4
	LDI  R30,LOW(6)
	CP   R4,R30
	BRLO _0x11A
;    2286 	{
;    2287 	t0_cnt0=0;
	CLR  R4
;    2288 	b100Hz=1;
	SET
	BLD  R2,1
;    2289 	}
;    2290 
;    2291 if(++t0_cnt1>=60)
_0x11A:
	INC  R5
	LDI  R30,LOW(60)
	CP   R5,R30
	BRLO _0x11B
;    2292 	{
;    2293 	t0_cnt1=0;
	CLR  R5
;    2294 	b10Hz=1;
	SET
	BLD  R2,2
;    2295 	
;    2296 	if(++t0_cnt2>=2)
	INC  R6
	LDI  R30,LOW(2)
	CP   R6,R30
	BRLO _0x11C
;    2297 		{
;    2298 		t0_cnt2=0;
	CLR  R6
;    2299 		bFL5=!bFL5;
	LDI  R30,LOW(1)
	EOR  R3,R30
;    2300 		}
;    2301 		
;    2302 	if(++t0_cnt3>=5)
_0x11C:
	INC  R7
	LDI  R30,LOW(5)
	CP   R7,R30
	BRLO _0x11D
;    2303 		{
;    2304 		t0_cnt3=0;
	CLR  R7
;    2305 		bFL2=!bFL2;
	LDI  R30,LOW(128)
	EOR  R2,R30
;    2306 		}		
;    2307 	}
_0x11D:
;    2308 }
_0x11B:
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
;    2309 
;    2310 //===============================================
;    2311 //===============================================
;    2312 //===============================================
;    2313 //===============================================
;    2314 
;    2315 void main(void)
;    2316 {
_main:
;    2317 
;    2318 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
;    2319 DDRA=0x00;
	RCALL SUBOPT_0x0
;    2320 
;    2321 PORTB=0xff;
	RCALL SUBOPT_0x12
;    2322 DDRB=0xFF;
;    2323 
;    2324 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;    2325 DDRC=0x00;
	OUT  0x14,R30
;    2326 
;    2327 
;    2328 PORTD=0x00;
	OUT  0x12,R30
;    2329 DDRD=0x00;
	OUT  0x11,R30
;    2330 
;    2331 
;    2332 TCCR0=0x02;
	RCALL SUBOPT_0x11
;    2333 TCNT0=-208;
;    2334 OCR0=0x00;
;    2335 
;    2336 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;    2337 TCCR1B=0x00;
	OUT  0x2E,R30
;    2338 TCNT1H=0x00;
	OUT  0x2D,R30
;    2339 TCNT1L=0x00;
	OUT  0x2C,R30
;    2340 ICR1H=0x00;
	OUT  0x27,R30
;    2341 ICR1L=0x00;
	OUT  0x26,R30
;    2342 OCR1AH=0x00;
	OUT  0x2B,R30
;    2343 OCR1AL=0x00;
	OUT  0x2A,R30
;    2344 OCR1BH=0x00;
	OUT  0x29,R30
;    2345 OCR1BL=0x00;
	OUT  0x28,R30
;    2346 
;    2347 
;    2348 ASSR=0x00;
	OUT  0x22,R30
;    2349 TCCR2=0x00;
	OUT  0x25,R30
;    2350 TCNT2=0x00;
	OUT  0x24,R30
;    2351 OCR2=0x00;
	OUT  0x23,R30
;    2352 
;    2353 MCUCR=0x00;
	OUT  0x35,R30
;    2354 MCUCSR=0x00;
	OUT  0x34,R30
;    2355 
;    2356 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;    2357 
;    2358 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;    2359 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;    2360 
;    2361 #asm("sei") 
	sei
;    2362 PORTB=0xFF;
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x12
;    2363 DDRB=0xFF;
;    2364 ind=iMn;
	CLR  R12
;    2365 prog_drv();
	CALL _prog_drv
;    2366 ind_hndl();
	CALL _ind_hndl
;    2367 led_hndl();
	CALL _led_hndl
;    2368 while (1)
_0x11E:
;    2369       {
;    2370       if(b600Hz)
	SBRS R2,0
	RJMP _0x121
;    2371 		{
;    2372 		b600Hz=0; 
	CLT
	BLD  R2,0
;    2373           
;    2374 		}         
;    2375       if(b100Hz)
_0x121:
	SBRS R2,1
	RJMP _0x122
;    2376 		{        
;    2377 		b100Hz=0; 
	CLT
	BLD  R2,1
;    2378 		but_an();
	RCALL _but_an
;    2379 	    	in_drv();
	CALL _in_drv
;    2380           mdvr_drv();
	CALL _mdvr_drv
;    2381           step_contr();
	CALL _step_contr
;    2382 		}   
;    2383 	if(b10Hz)
_0x122:
	SBRS R2,2
	RJMP _0x123
;    2384 		{
;    2385 		b10Hz=0;
	CLT
	BLD  R2,2
;    2386 		prog_drv();
	CALL _prog_drv
;    2387 		err_drv();
	CALL _err_drv
;    2388 		
;    2389     	     ind_hndl();
	CALL _ind_hndl
;    2390           led_hndl();
	CALL _led_hndl
;    2391           
;    2392           }
;    2393 
;    2394       };
_0x123:
	RJMP _0x11E
;    2395 }
_0x124:
	RJMP _0x124

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	LDI  R30,LOW(255)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	LDI  R30,LOW(19)
	MOV  R11,R30
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES
SUBOPT_0x2:
	LDS  R30,_cnt_del
	LDS  R31,_cnt_del+1
	SBIW R30,1
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x3:
	LDI  R30,LOW(3)
	MOV  R11,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES
SUBOPT_0x4:
	MOV  R11,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5:
	MOV  R11,R30
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6:
	MOV  R11,R30
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x7:
	MOV  R30,R16
	SUBI R30,LOW(1)
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x9:
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
SUBOPT_0xA:
	OUT  0x11,R30
	IN   R30,0x12
	ORI  R30,LOW(0xF8)
	OUT  0x12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB:
	IN   R30,0x15
	ORI  R30,LOW(0x95)
	OUT  0x15,R30
	IN   R30,0x14
	ANDI R30,LOW(0x6A)
	OUT  0x14,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xC:
	LDS  R30,_but_s_G1
	LDS  R26,_but_n_G1
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD:
	LDS  R30,_but_onL_temp_G1
	LDS  R26,_but1_cnt_G1
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE:
	LDS  R30,_but_s_G1
	ANDI R30,0xFD
	MOV  R9,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF:
	INC  R10
	LDI  R30,LOW(4)
	CP   R30,R10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x10:
	MOV  R30,R10
	LDI  R26,LOW(_ee_program)
	LDI  R27,HIGH(_ee_program)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x11:
	LDI  R30,LOW(2)
	OUT  0x33,R30
	LDI  R30,LOW(65328)
	LDI  R31,HIGH(65328)
	OUT  0x32,R30
	LDI  R30,LOW(0)
	OUT  0x3C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x12:
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

