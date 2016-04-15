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
;      20 #define  I380_WI_GAZ
;      21 
;      22 #define MD1	2
;      23 #define MD2	3
;      24 #define VR	4
;      25 #define MD3	5
;      26 
;      27 #define PP1	6
;      28 #define PP2	7
;      29 #define PP3	5
;      30 #define PP4	4
;      31 #define PP5	3
;      32 #define DV	0 
;      33 
;      34 #define PP7	2
;      35 
;      36 #ifdef P380_MINI
;      37 #define MINPROG 1
;      38 #define MAXPROG 1 
;      39 #ifdef GAVT3
;      40 #define DV	2
;      41 #endif
;      42 #define PP3	3
;      43 #endif 
;      44 
;      45 #ifdef P380
;      46 #define MINPROG 1
;      47 #define MAXPROG 3 
;      48 #ifdef GAVT3
;      49 #define DV	2
;      50 #endif
;      51 #endif 
;      52 
;      53 #ifdef I380
;      54 #define MINPROG 1
;      55 #define MAXPROG 4
;      56 #endif
;      57 
;      58 #ifdef I380_WI
;      59 #define MINPROG 1
;      60 #define MAXPROG 4
;      61 #endif
;      62 
;      63 #ifdef I220
;      64 #define MINPROG 3
;      65 #define MAXPROG 4
;      66 #endif
;      67 
;      68 
;      69 #ifdef I220_WI
;      70 #define MINPROG 3
;      71 #define MAXPROG 4
;      72 #endif
;      73 
;      74 #ifdef TVIST_SKO
;      75 #define MINPROG 2
;      76 #define MAXPROG 3
;      77 #define DV	2
;      78 #endif
;      79 
;      80 #ifdef DV3KL2MD
;      81 
;      82 #define PP1	6
;      83 #define PP2	7
;      84 #define PP3	3
;      85 //#define PP4	4
;      86 //#define PP5	3
;      87 #define DV	2 
;      88 
;      89 #define MINPROG 2
;      90 #define MAXPROG 3
;      91 
;      92 #endif
;      93        
;      94 
;      95 #ifdef I380_WI_GAZ
;      96 
;      97 #define PP1	6
;      98 #define PP2	7
;      99 #define PP3	3
;     100 #define PP4	4
;     101 #define PP5	3
;     102 #define PP6	3
;     103 #define PP7	3
;     104 #define PP8	3
;     105 
;     106 #define DV	2 
;     107 
;     108 #define MINPROG 1
;     109 #define MAXPROG 3
;     110 
;     111 #endif
;     112 
;     113 bit b600Hz;
;     114 
;     115 bit b100Hz;
;     116 bit b10Hz;
;     117 char t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3;
;     118 char ind_cnt;
;     119 flash char IND_STROB[]={0b10111111,0b11011111,0b11101111,0b11110111,0b01111111};

	.CSEG
;     120 flash char DIGISYM[]={0b11000000,0b11111001,0b10100100,0b10110000,0b10011001,0b10010010,0b10000010,0b11111000,0b10000000,0b10010000,0b11111111};								
;     121 
;     122 char ind_out[5]={0x255,0x255,0x255,0x255,0x255};

	.DSEG
_ind_out:
	.BYTE 0x5
;     123 char dig[4];
_dig:
	.BYTE 0x4
;     124 bit bZ;    
;     125 char but;
;     126 static char but_n;
_but_n_G1:
	.BYTE 0x1
;     127 static char but_s;
_but_s_G1:
	.BYTE 0x1
;     128 static char but0_cnt;
_but0_cnt_G1:
	.BYTE 0x1
;     129 static char but1_cnt;
_but1_cnt_G1:
	.BYTE 0x1
;     130 static char but_onL_temp;
_but_onL_temp_G1:
	.BYTE 0x1
;     131 bit l_but;		//идет длинное нажатие на кнопку
;     132 bit n_but;          //произошло нажатие
;     133 bit speed;		//разрешение ускорения перебора 
;     134 bit bFL2; 
;     135 bit bFL5;
;     136 eeprom enum{evmON=0x55,evmOFF=0xaa}ee_vacuum_mode;

	.ESEG
_ee_vacuum_mode:
	.DB  0x0
;     137 eeprom char ee_program[2];
_ee_program:
	.DB  0x0
	.DB  0x0
;     138 enum {p1=1,p2=2,p3=3,p4=4}prog;
;     139 enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}step=sOFF;
;     140 enum {iMn,iPr_sel,iVr} ind;
;     141 char sub_ind;
;     142 char in_word,in_word_old,in_word_new,in_word_cnt;

	.DSEG
_in_word_old:
	.BYTE 0x1
_in_word_new:
	.BYTE 0x1
_in_word_cnt:
	.BYTE 0x1
;     143 bit bERR;
;     144 signed int cnt_del=0;
_cnt_del:
	.BYTE 0x2
;     145 
;     146 char bVR;
_bVR:
	.BYTE 0x1
;     147 char bMD1;
_bMD1:
	.BYTE 0x1
;     148 bit bMD2;
;     149 bit bMD3;
;     150 char cnt_md1,cnt_md2,cnt_vr,cnt_md3;
_cnt_md1:
	.BYTE 0x1
_cnt_md2:
	.BYTE 0x1
_cnt_vr:
	.BYTE 0x1
_cnt_md3:
	.BYTE 0x1
;     151 
;     152 eeprom unsigned ee_delay[4,2];

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
;     153 eeprom char ee_vr_log;
_ee_vr_log:
	.DB  0x0
;     154 //#include <mega16.h>
;     155 //#include <mega8535.h>
;     156 #include <mega32.h>
;     157 //-----------------------------------------------
;     158 void prog_drv(void)
;     159 {

	.CSEG
_prog_drv:
;     160 char temp,temp1,temp2;
;     161 
;     162 temp=ee_program[0];
	CALL __SAVELOCR3
;	temp -> R16
;	temp1 -> R17
;	temp2 -> R18
	LDI  R26,LOW(_ee_program)
	LDI  R27,HIGH(_ee_program)
	CALL __EEPROMRDB
	MOV  R16,R30
;     163 temp1=ee_program[1];
	__POINTW2MN _ee_program,1
	CALL __EEPROMRDB
	MOV  R17,R30
;     164 temp2=ee_program[2];
	__POINTW2MN _ee_program,2
	CALL __EEPROMRDB
	MOV  R18,R30
;     165 
;     166 if((temp==temp1)&&(temp==temp2))
	CP   R17,R16
	BRNE _0x5
	CP   R18,R16
	BREQ _0x6
_0x5:
	RJMP _0x4
_0x6:
;     167 	{
;     168 	}
;     169 else if((temp==temp1)&&(temp!=temp2))
	RJMP _0x7
_0x4:
	CP   R17,R16
	BRNE _0x9
	CP   R18,R16
	BRNE _0xA
_0x9:
	RJMP _0x8
_0xA:
;     170 	{
;     171 	temp2=temp;
	MOV  R18,R16
;     172 	}
;     173 else if((temp!=temp1)&&(temp==temp2))
	RJMP _0xB
_0x8:
	CP   R17,R16
	BREQ _0xD
	CP   R18,R16
	BREQ _0xE
_0xD:
	RJMP _0xC
_0xE:
;     174 	{
;     175 	temp1=temp;
	MOV  R17,R16
;     176 	}
;     177 else if((temp!=temp1)&&(temp1==temp2))
	RJMP _0xF
_0xC:
	CP   R17,R16
	BREQ _0x11
	CP   R18,R17
	BREQ _0x12
_0x11:
	RJMP _0x10
_0x12:
;     178 	{
;     179 	temp=temp1;
	MOV  R16,R17
;     180 	}
;     181 else if((temp!=temp1)&&(temp!=temp2))
	RJMP _0x13
_0x10:
	CP   R17,R16
	BREQ _0x15
	CP   R18,R16
	BRNE _0x16
_0x15:
	RJMP _0x14
_0x16:
;     182 	{
;     183 	temp=MINPROG;
	LDI  R16,LOW(1)
;     184 	temp1=MINPROG;
	LDI  R17,LOW(1)
;     185 	temp2=MINPROG;
	LDI  R18,LOW(1)
;     186 	}
;     187 
;     188 if(!((temp<=MAXPROG)&&(temp>=MINPROG)))
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
;     189 	{
;     190 	temp=MINPROG;
	LDI  R16,LOW(1)
;     191 	}
;     192 
;     193 if(temp!=ee_program[0])ee_program[0]=temp;
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
;     194 if(temp!=ee_program[1])ee_program[1]=temp;
_0x1A:
	__POINTW2MN _ee_program,1
	CALL __EEPROMRDB
	CP   R30,R16
	BREQ _0x1B
	__POINTW2MN _ee_program,1
	MOV  R30,R16
	CALL __EEPROMWRB
;     195 if(temp!=ee_program[2])ee_program[2]=temp;
_0x1B:
	__POINTW2MN _ee_program,2
	CALL __EEPROMRDB
	CP   R30,R16
	BREQ _0x1C
	__POINTW2MN _ee_program,2
	MOV  R30,R16
	CALL __EEPROMWRB
;     196 
;     197 prog=temp;
_0x1C:
	MOV  R10,R16
;     198 }
	CALL __LOADLOCR3
<<<<<<< HEAD
	RJMP _0x125
;     179 
;     180 //-----------------------------------------------
;     181 void in_drv(void)
;     182 {
=======
	RJMP _0x12B
;     199 
;     200 //-----------------------------------------------
;     201 void in_drv(void)
;     202 {
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
_in_drv:
;     203 char i,temp;
;     204 unsigned int tempUI;
;     205 DDRA=0x00;
	CALL __SAVELOCR4
;	i -> R16
;	temp -> R17
;	tempUI -> R18,R19
	CALL SUBOPT_0x0
;     206 PORTA=0xff;
	OUT  0x1B,R30
;     207 in_word_new=PINA;
	IN   R30,0x19
	STS  _in_word_new,R30
;     208 if(in_word_old==in_word_new)
	LDS  R26,_in_word_old
	CP   R30,R26
	BRNE _0x1D
;     209 	{
;     210 	if(in_word_cnt<10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRSH _0x1E
;     211 		{
;     212 		in_word_cnt++;
	LDS  R30,_in_word_cnt
	SUBI R30,-LOW(1)
	STS  _in_word_cnt,R30
;     213 		if(in_word_cnt>=10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRLO _0x1F
;     214 			{
;     215 			in_word=in_word_old;
	LDS  R14,_in_word_old
;     216 			}
;     217 		}
_0x1F:
;     218 	}
_0x1E:
;     219 else in_word_cnt=0;
	RJMP _0x20
_0x1D:
	LDI  R30,LOW(0)
	STS  _in_word_cnt,R30
_0x20:
;     220 
;     221 
;     222 in_word_old=in_word_new;
	LDS  R30,_in_word_new
	STS  _in_word_old,R30
;     223 }   
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;     224 
;     225 #ifdef TVIST_SKO
;     226 //-----------------------------------------------
;     227 void err_drv(void)
;     228 {
;     229 if(step==sOFF)
;     230 	{
;     231     	if(prog==p2)	
;     232     		{
;     233        		if(bMD1) bERR=1;
;     234        		else bERR=0;
;     235 		}
;     236 	}
;     237 else bERR=0;
;     238 }
;     239 #endif  
;     240 
;     241 #ifndef TVIST_SKO
;     242 //-----------------------------------------------
;     243 void err_drv(void)
;     244 {
_err_drv:
;     245 if(step==sOFF)
	TST  R11
	BRNE _0x21
;     246 	{
;     247 	if((bMD1)||(bMD2)||(bVR)||(bMD3)) bERR=1;
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
;     248 	else bERR=0;
	RJMP _0x25
_0x22:
	CLT
	BLD  R3,1
_0x25:
;     249 	}
;     250 else bERR=0;
	RJMP _0x26
_0x21:
	CLT
	BLD  R3,1
_0x26:
;     251 }
	RET
;     252 #endif
;     253 //-----------------------------------------------
;     254 void mdvr_drv(void)
;     255 {
_mdvr_drv:
;     256 if(!(in_word&(1<<MD1)))
	SBRC R14,2
	RJMP _0x27
;     257 	{
;     258 	if(cnt_md1<10)
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRSH _0x28
;     259 		{
;     260 		cnt_md1++;
	LDS  R30,_cnt_md1
	SUBI R30,-LOW(1)
	STS  _cnt_md1,R30
;     261 		if(cnt_md1==10) bMD1=1;
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRNE _0x29
	LDI  R30,LOW(1)
	STS  _bMD1,R30
;     262 		}
_0x29:
;     263 
;     264 	}
_0x28:
;     265 else
	RJMP _0x2A
_0x27:
;     266 	{
;     267 	if(cnt_md1)
	LDS  R30,_cnt_md1
	CPI  R30,0
	BREQ _0x2B
;     268 		{
;     269 		cnt_md1--;
	SUBI R30,LOW(1)
	STS  _cnt_md1,R30
;     270 		if(cnt_md1==0) bMD1=0;
	CPI  R30,0
	BRNE _0x2C
	LDI  R30,LOW(0)
	STS  _bMD1,R30
;     271 		}
_0x2C:
;     272 
;     273 	}
_0x2B:
_0x2A:
;     274 
;     275 if(!(in_word&(1<<MD2)))
	SBRC R14,3
	RJMP _0x2D
;     276 	{
;     277 	if(cnt_md2<10)
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRSH _0x2E
;     278 		{
;     279 		cnt_md2++;
	LDS  R30,_cnt_md2
	SUBI R30,-LOW(1)
	STS  _cnt_md2,R30
;     280 		if(cnt_md2==10) bMD2=1;
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRNE _0x2F
	SET
	BLD  R3,2
;     281 		}
_0x2F:
;     282 
;     283 	}
_0x2E:
;     284 else
	RJMP _0x30
_0x2D:
;     285 	{
;     286 	if(cnt_md2)
	LDS  R30,_cnt_md2
	CPI  R30,0
	BREQ _0x31
;     287 		{
;     288 		cnt_md2--;
	SUBI R30,LOW(1)
	STS  _cnt_md2,R30
;     289 		if(cnt_md2==0) bMD2=0;
	CPI  R30,0
	BRNE _0x32
	CLT
	BLD  R3,2
;     290 		}
_0x32:
;     291 
;     292 	}
_0x31:
_0x30:
;     293 
;     294 if(!(in_word&(1<<MD3)))
	SBRC R14,5
	RJMP _0x33
;     295 	{
;     296 	if(cnt_md3<10)
	LDS  R26,_cnt_md3
	CPI  R26,LOW(0xA)
	BRSH _0x34
;     297 		{
;     298 		cnt_md3++;
	LDS  R30,_cnt_md3
	SUBI R30,-LOW(1)
	STS  _cnt_md3,R30
;     299 		if(cnt_md3==10) bMD3=1;
	LDS  R26,_cnt_md3
	CPI  R26,LOW(0xA)
	BRNE _0x35
	SET
	BLD  R3,3
;     300 		}
_0x35:
;     301 
;     302 	}
_0x34:
;     303 else
	RJMP _0x36
_0x33:
;     304 	{
;     305 	if(cnt_md3)
	LDS  R30,_cnt_md3
	CPI  R30,0
	BREQ _0x37
;     306 		{
;     307 		cnt_md3--;
	SUBI R30,LOW(1)
	STS  _cnt_md3,R30
;     308 		if(cnt_md3==0) bMD3=0;
	CPI  R30,0
	BRNE _0x38
	CLT
	BLD  R3,3
;     309 		}
_0x38:
;     310 
;     311 	}
_0x37:
_0x36:
;     312 
;     313 if(((!(in_word&(1<<VR)))&&(ee_vr_log)) || (((in_word&(1<<VR)))&&(!ee_vr_log)))
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
;     314 	{
;     315 	if(cnt_vr<10)
	LDS  R26,_cnt_vr
	CPI  R26,LOW(0xA)
	BRSH _0x40
;     316 		{
;     317 		cnt_vr++;
	LDS  R30,_cnt_vr
	SUBI R30,-LOW(1)
	STS  _cnt_vr,R30
;     318 		if(cnt_vr==10) bVR=1;
	LDS  R26,_cnt_vr
	CPI  R26,LOW(0xA)
	BRNE _0x41
	LDI  R30,LOW(1)
	STS  _bVR,R30
;     319 		}
_0x41:
;     320 
;     321 	}
_0x40:
;     322 else
	RJMP _0x42
_0x39:
;     323 	{
;     324 	if(cnt_vr)
	LDS  R30,_cnt_vr
	CPI  R30,0
	BREQ _0x43
;     325 		{
;     326 		cnt_vr--;
	SUBI R30,LOW(1)
	STS  _cnt_vr,R30
;     327 		if(cnt_vr==0) bVR=0;
	CPI  R30,0
	BRNE _0x44
	LDI  R30,LOW(0)
	STS  _bVR,R30
;     328 		}
_0x44:
;     329 
;     330 	}
_0x43:
_0x42:
;     331 } 
	RET
;     332 
;     333 #ifdef DV3KL2MD
;     334 //-----------------------------------------------
;     335 void step_contr(void)
;     336 {
;     337 char temp=0;
;     338 DDRB=0xFF;
;     339 
;     340 if(step==sOFF)
;     341 	{
;     342 	temp=0;
;     343 	}
;     344 
;     345 else if(step==s1)
;     346 	{
;     347 	temp|=(1<<PP1);
;     348 
;     349 	cnt_del--;
;     350 	if(cnt_del==0)
;     351 		{
;     352 		step=s2;
;     353 		cnt_del=20;
;     354 		}
;     355 	}
;     356 
;     357 
;     358 else if(step==s2)
;     359 	{
;     360 	temp|=(1<<PP1)|(1<<DV);
;     361 
;     362 	cnt_del--;
;     363 	if(cnt_del==0)
;     364 		{
;     365 		step=s3;
;     366 		}
;     367 	}
;     368 	
;     369 else if(step==s3)
;     370 	{
;     371 	temp|=(1<<PP1)|(1<<PP2)|(1<<DV);
;     372      if(!bMD1)goto step_contr_end;
;     373      step=s4;
;     374      }     
;     375 else if(step==s4)
;     376 	{          
;     377      temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     378      if(!bMD2)goto step_contr_end;
;     379      step=s5;
;     380      cnt_del=50;
;     381      } 
;     382 else if(step==s5)
;     383 	{
;     384 	temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     385 
;     386 	cnt_del--;
;     387 	if(cnt_del==0)
;     388 		{
;     389 		step=s6;
;     390 		cnt_del=50;
;     391 		}
;     392 	}         
;     393 /*else if(step==s6)
;     394 	{
;     395 	temp|=(1<<PP1)|(1<<DV);
;     396 
;     397 	cnt_del--;
;     398 	if(cnt_del==0)
;     399 		{
;     400 		step=s6;
;     401 		cnt_del=70;
;     402 		}
;     403 	}*/     
;     404 else if(step==s6)
;     405 		{
;     406 	temp|=(1<<PP1);
;     407 	cnt_del--;
;     408 	if(cnt_del==0)
;     409 		{
;     410 		step=sOFF;
;     411           }     
;     412      }     
;     413 
;     414 step_contr_end:
;     415 
<<<<<<< HEAD
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
=======
;     416 PORTB=~temp;
;     417 }
;     418 #endif
;     419 
;     420 #ifdef P380_MINI
;     421 //-----------------------------------------------
;     422 void step_contr(void)
;     423 {
;     424 char temp=0;
;     425 DDRB=0xFF;
;     426 
;     427 if(step==sOFF)
;     428 	{
;     429 	temp=0;
;     430 	}
;     431 
;     432 else if(step==s1)
;     433 	{
;     434 	temp|=(1<<PP1);
;     435 
;     436 	cnt_del--;
;     437 	if(cnt_del==0)
;     438 		{
;     439 		step=s2;
;     440 		}
;     441 	}
;     442 
;     443 else if(step==s2)
;     444 	{
;     445 	temp|=(1<<PP1)|(1<<PP2)|(1<<DV);
;     446      if(!bMD1)goto step_contr_end;
;     447      step=s3;
;     448      }     
;     449 else if(step==s3)
;     450 	{          
;     451      temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     452      if(!bMD2)goto step_contr_end;
;     453      step=s4;
;     454      cnt_del=50;
;     455      }
;     456 else if(step==s4)
;     457 		{
;     458 	temp|=(1<<PP1);
;     459 	cnt_del--;
;     460 	if(cnt_del==0)
;     461 		{
;     462 		step=sOFF;
;     463           }     
;     464      }     
;     465 
;     466 step_contr_end:
;     467 
;     468 PORTB=~temp;
;     469 }
;     470 #endif
;     471 
;     472 #ifdef P380
;     473 //-----------------------------------------------
;     474 void step_contr(void)
;     475 {
;     476 char temp=0;
;     477 DDRB=0xFF;
;     478 
;     479 if(step==sOFF)
;     480 	{
;     481 	temp=0;
;     482 	}
;     483 
;     484 else if(prog==p1)
;     485 	{
;     486 	if(step==s1)
;     487 		{
;     488 		temp|=(1<<PP1)|(1<<PP2);
;     489 
;     490 		cnt_del--;
;     491 		if(cnt_del==0)
;     492 			{
;     493 			if(ee_vacuum_mode==evmOFF)
;     494 				{
;     495 				goto lbl_0001;
;     496 				}
;     497 			else step=s2;
;     498 			}
;     499 		}
;     500 
;     501 	else if(step==s2)
;     502 		{
;     503 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     504 
;     505           if(!bVR)goto step_contr_end;
;     506 lbl_0001:
;     507 #ifndef BIG_CAM
;     508 		cnt_del=30;
;     509 #endif
;     510 
;     511 #ifdef BIG_CAM
;     512 		cnt_del=100;
;     513 #endif
;     514 		step=s3;
;     515 		}
;     516 
;     517 	else if(step==s3)
;     518 		{
;     519 		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     520 		cnt_del--;
;     521 		if(cnt_del==0)
;     522 			{
;     523 			step=s4;
;     524 			}
;     525           }
;     526 	else if(step==s4)
;     527 		{
;     528 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     529 
;     530           if(!bMD1)goto step_contr_end;
;     531 
;     532 		cnt_del=40;
;     533 		step=s5;
;     534 		}
;     535 	else if(step==s5)
;     536 		{
;     537 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     538 
;     539 		cnt_del--;
;     540 		if(cnt_del==0)
;     541 			{
;     542 			step=s6;
;     543 			}
;     544 		}
;     545 	else if(step==s6)
;     546 		{
;     547 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     548 
;     549          	if(!bMD2)goto step_contr_end;
;     550           cnt_del=40;
;     551 		//step=s7;
;     552 		
;     553           step=s55;
;     554           cnt_del=40;
;     555 		}
;     556 	else if(step==s55)
;     557 		{
;     558 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     559           cnt_del--;
;     560           if(cnt_del==0)
;     561 			{
;     562           	step=s7;
;     563           	cnt_del=20;
;     564 			}
;     565          		
;     566 		}
;     567 	else if(step==s7)
;     568 		{
;     569 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     570 
;     571 		cnt_del--;
;     572 		if(cnt_del==0)
;     573 			{
;     574 			step=s8;
;     575 			cnt_del=30;
;     576 			}
;     577 		}
;     578 	else if(step==s8)
;     579 		{
;     580 		temp|=(1<<PP1)|(1<<PP3);
;     581 
;     582 		cnt_del--;
;     583 		if(cnt_del==0)
;     584 			{
;     585 			step=s9;
;     586 #ifndef BIG_CAM
;     587 		cnt_del=150;
;     588 #endif
;     589 
;     590 #ifdef BIG_CAM
;     591 		cnt_del=200;
;     592 #endif
;     593 			}
;     594 		}
;     595 	else if(step==s9)
;     596 		{
;     597 		temp|=(1<<PP1)|(1<<PP2);
;     598 
;     599 		cnt_del--;
;     600 		if(cnt_del==0)
;     601 			{
;     602 			step=s10;
;     603 			cnt_del=30;
;     604 			}
;     605 		}
;     606 	else if(step==s10)
;     607 		{
;     608 		temp|=(1<<PP2);
;     609 		cnt_del--;
;     610 		if(cnt_del==0)
;     611 			{
;     612 			step=sOFF;
;     613 			}
;     614 		}
;     615 	}
;     616 
;     617 if(prog==p2)
;     618 	{
;     619 
;     620 	if(step==s1)
;     621 		{
;     622 		temp|=(1<<PP1)|(1<<PP2);
;     623 
;     624 		cnt_del--;
;     625 		if(cnt_del==0)
;     626 			{
;     627 			if(ee_vacuum_mode==evmOFF)
;     628 				{
;     629 				goto lbl_0002;
;     630 				}
;     631 			else step=s2;
;     632 			}
;     633 		}
;     634 
;     635 	else if(step==s2)
;     636 		{
;     637 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     638 
;     639           if(!bVR)goto step_contr_end;
;     640 lbl_0002:
;     641 #ifndef BIG_CAM
;     642 		cnt_del=30;
;     643 #endif
;     644 
;     645 #ifdef BIG_CAM
;     646 		cnt_del=100;
;     647 #endif
;     648 		step=s3;
;     649 		}
;     650 
;     651 	else if(step==s3)
;     652 		{
;     653 		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
;     654 
;     655 		cnt_del--;
;     656 		if(cnt_del==0)
;     657 			{
<<<<<<< HEAD
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
=======
;     658 			step=s4;
;     659 			}
;     660 		}
;     661 
;     662 	else if(step==s4)
;     663 		{
;     664 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     665 
;     666           if(!bMD1)goto step_contr_end;
;     667          	cnt_del=30;
;     668 		step=s5;
;     669 		}
;     670 
;     671 	else if(step==s5)
;     672 		{
;     673 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     674 
;     675 		cnt_del--;
;     676 		if(cnt_del==0)
;     677 			{
;     678 			step=s6;
;     679 			cnt_del=30;
;     680 			}
;     681 		}
;     682 
;     683 	else if(step==s6)
;     684 		{
;     685 		temp|=(1<<PP1)|(1<<PP3);
;     686 
;     687 		cnt_del--;
;     688 		if(cnt_del==0)
;     689 			{
;     690 			step=s7;
;     691 #ifndef BIG_CAM
;     692 		cnt_del=150;
;     693 #endif
;     694 
;     695 #ifdef BIG_CAM
;     696 		cnt_del=200;
;     697 #endif
;     698 			}
;     699 		}
;     700 
;     701 	else if(step==s7)
;     702 		{
;     703 		temp|=(1<<PP1)|(1<<PP2);
;     704 
;     705 		cnt_del--;
;     706 		if(cnt_del==0)
;     707 			{
;     708 			step=s8;
;     709 			cnt_del=30;
;     710 			}
;     711 		}
;     712 	else if(step==s8)
;     713 		{
;     714 		temp|=(1<<PP2);
;     715 
;     716 		cnt_del--;
;     717 		if(cnt_del==0)
;     718 			{
;     719 			step=sOFF;
;     720 			}
;     721 		}
;     722 	}
;     723 
;     724 if(prog==p3)
;     725 	{
;     726 
;     727 	if(step==s1)
;     728 		{
;     729 		temp|=(1<<PP1)|(1<<PP2);
;     730 
;     731 		cnt_del--;
;     732 		if(cnt_del==0)
;     733 			{
;     734 			if(ee_vacuum_mode==evmOFF)
;     735 				{
;     736 				goto lbl_0003;
;     737 				}
;     738 			else step=s2;
;     739 			}
;     740 		}
;     741 
;     742 	else if(step==s2)
;     743 		{
;     744 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     745 
;     746           if(!bVR)goto step_contr_end;
;     747 lbl_0003:
;     748 #ifndef BIG_CAM
;     749 		cnt_del=80;
;     750 #endif
;     751 
;     752 #ifdef BIG_CAM
;     753 		cnt_del=100;
;     754 #endif
;     755 		step=s3;
;     756 		}
;     757 
;     758 	else if(step==s3)
;     759 		{
;     760 		temp|=(1<<PP1)|(1<<PP3);
;     761 
;     762 		cnt_del--;
;     763 		if(cnt_del==0)
;     764 			{
;     765 			step=s4;
;     766 			cnt_del=120;
;     767 			}
;     768 		}
;     769 
;     770 	else if(step==s4)
;     771 		{
;     772 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<PP5);
;     773 
;     774 		cnt_del--;
;     775 		if(cnt_del==0)
;     776 			{
;     777 			step=s5;
;     778 
;     779 		
;     780 #ifndef BIG_CAM
;     781 		cnt_del=150;
;     782 #endif
;     783 
;     784 #ifdef BIG_CAM
;     785 		cnt_del=200;
;     786 #endif
;     787 	//	step=s5;
;     788 	}
;     789 		}
;     790 
;     791 	else if(step==s5)
;     792 		{
;     793 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<PP5);
;     794 
;     795 		cnt_del--;
;     796 		if(cnt_del==0)
;     797 			{
;     798 			step=s6;
;     799 			cnt_del=30;
;     800 			}
;     801 		}
;     802 
;     803 	else if(step==s6)
;     804 		{
;     805 		temp|=(1<<PP2)|(1<<PP4)|(1<<PP5);
;     806 
;     807 		cnt_del--;
;     808 		if(cnt_del==0)
;     809 			{
;     810 			step=s7;
;     811 			cnt_del=30;
;     812 			}
;     813 		}
;     814 
;     815 	else if(step==s7)
;     816 		{
;     817 		temp|=(1<<PP2);
;     818 
;     819 		cnt_del--;
;     820 		if(cnt_del==0)
;     821 			{
;     822 			step=sOFF;
;     823 			}
;     824 		}
;     825 
;     826 	}
;     827 step_contr_end:
;     828 
;     829 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;     830 
;     831 PORTB=~temp;
;     832 }
;     833 #endif
;     834 #ifdef I380
;     835 //-----------------------------------------------
;     836 void step_contr(void)
;     837 {
;     838 char temp=0;
;     839 DDRB=0xFF;
;     840 
;     841 if(step==sOFF)goto step_contr_end;
;     842 
;     843 else if(prog==p1)
;     844 	{
;     845 	if(step==s1)    //жесть
;     846 		{
;     847 		temp|=(1<<PP1);
;     848           if(!bMD1)goto step_contr_end;
;     849 
;     850 			if(ee_vacuum_mode==evmOFF)
;     851 				{
;     852 				goto lbl_0001;
;     853 				}
;     854 			else step=s2;
;     855 		}
;     856 
;     857 	else if(step==s2)
;     858 		{
;     859 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     860           if(!bVR)goto step_contr_end;
;     861 lbl_0001:
;     862 
;     863           step=s100;
;     864 		cnt_del=40;
;     865           }
;     866 	else if(step==s100)
;     867 		{
;     868 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;     869           cnt_del--;
;     870           if(cnt_del==0)
;     871 			{
;     872           	step=s3;
;     873           	cnt_del=50;
;     874 			}
;     875 		}
;     876 
;     877 	else if(step==s3)
;     878 		{
;     879 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     880           cnt_del--;
;     881           if(cnt_del==0)
;     882 			{
;     883           	step=s4;
;     884 			}
;     885 		}
;     886 	else if(step==s4)
;     887 		{
;     888 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;     889           if(!bMD2)goto step_contr_end;
;     890           step=s5;
;     891           cnt_del=20;
;     892 		}
;     893 	else if(step==s5)
;     894 		{
;     895 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     896           cnt_del--;
;     897           if(cnt_del==0)
;     898 			{
;     899           	step=s6;
;     900 			}
;     901           }
;     902 	else if(step==s6)
;     903 		{
;     904 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
;     905           if(!bMD3)goto step_contr_end;
;     906           step=s7;
;     907           cnt_del=20;
;     908 		}
;     909 
;     910 	else if(step==s7)
;     911 		{
;     912 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     913           cnt_del--;
;     914           if(cnt_del==0)
;     915 			{
;     916           	step=s8;
;     917           	cnt_del=ee_delay[prog,0]*10U;;
;     918 			}
;     919           }
;     920 	else if(step==s8)
;     921 		{
;     922 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;     923           cnt_del--;
;     924           if(cnt_del==0)
;     925 			{
;     926           	step=s9;
;     927           	cnt_del=20;
;     928 			}
;     929           }
;     930 	else if(step==s9)
;     931 		{
;     932 		temp|=(1<<PP1);
;     933           cnt_del--;
;     934           if(cnt_del==0)
;     935 			{
;     936           	step=sOFF;
;     937           	}
;     938           }
;     939 	}
;     940 
;     941 else if(prog==p2)  //ско
;     942 	{
;     943 	if(step==s1)
;     944 		{
;     945 		temp|=(1<<PP1);
;     946           if(!bMD1)goto step_contr_end;
;     947 
;     948 			if(ee_vacuum_mode==evmOFF)
;     949 				{
;     950 				goto lbl_0002;
;     951 				}
;     952 			else step=s2;
;     953 
;     954           //step=s2;
;     955 		}
;     956 
;     957 	else if(step==s2)
;     958 		{
;     959 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     960           if(!bVR)goto step_contr_end;
;     961 
;     962 lbl_0002:
;     963           step=s100;
;     964 		cnt_del=40;
;     965           }
;     966 	else if(step==s100)
;     967 		{
;     968 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;     969           cnt_del--;
;     970           if(cnt_del==0)
;     971 			{
;     972           	step=s3;
;     973           	cnt_del=50;
;     974 			}
;     975 		}
;     976 	else if(step==s3)
;     977 		{
;     978 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     979           cnt_del--;
;     980           if(cnt_del==0)
;     981 			{
;     982           	step=s4;
;     983 			}
;     984 		}
;     985 	else if(step==s4)
;     986 		{
;     987 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;     988           if(!bMD2)goto step_contr_end;
;     989           step=s5;
;     990           cnt_del=20;
;     991 		}
;     992 	else if(step==s5)
;     993 		{
;     994 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     995           cnt_del--;
;     996           if(cnt_del==0)
;     997 			{
;     998           	step=s6;
;     999           	cnt_del=ee_delay[prog,0]*10U;
;    1000 			}
;    1001           }
;    1002 	else if(step==s6)
;    1003 		{
;    1004 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1005           cnt_del--;
;    1006           if(cnt_del==0)
;    1007 			{
;    1008           	step=s7;
;    1009           	cnt_del=20;
;    1010 			}
;    1011           }
;    1012 	else if(step==s7)
;    1013 		{
;    1014 		temp|=(1<<PP1);
;    1015           cnt_del--;
;    1016           if(cnt_del==0)
;    1017 			{
;    1018           	step=sOFF;
;    1019           	}
;    1020           }
;    1021 	}
;    1022 
;    1023 else if(prog==p3)   //твист
;    1024 	{
;    1025 	if(step==s1)
;    1026 		{
;    1027 		temp|=(1<<PP1);
;    1028           if(!bMD1)goto step_contr_end;
;    1029 
;    1030 			if(ee_vacuum_mode==evmOFF)
;    1031 				{
;    1032 				goto lbl_0003;
;    1033 				}
;    1034 			else step=s2;
;    1035 
;    1036           //step=s2;
;    1037 		}
;    1038 
;    1039 	else if(step==s2)
;    1040 		{
;    1041 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1042           if(!bVR)goto step_contr_end;
;    1043 lbl_0003:
;    1044           cnt_del=50;
;    1045 		step=s3;
;    1046 		}
;    1047 
;    1048 
;    1049 	else	if(step==s3)
;    1050 		{
;    1051 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1052 		cnt_del--;
;    1053 		if(cnt_del==0)
;    1054 			{
;    1055 			cnt_del=ee_delay[prog,0]*10U;
;    1056 			step=s4;
;    1057 			}
;    1058           }
;    1059 	else if(step==s4)
;    1060 		{
;    1061 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1062 		cnt_del--;
;    1063  		if(cnt_del==0)
;    1064 			{
;    1065 			cnt_del=ee_delay[prog,1]*10U;
;    1066 			step=s5;
;    1067 			}
;    1068 		}
;    1069 
;    1070 	else if(step==s5)
;    1071 		{
;    1072 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1073 		cnt_del--;
;    1074 		if(cnt_del==0)
;    1075 			{
;    1076 			step=s6;
;    1077 			cnt_del=20;
;    1078 			}
;    1079 		}
;    1080 
;    1081 	else if(step==s6)
;    1082 		{
;    1083 		temp|=(1<<PP1);
;    1084   		cnt_del--;
;    1085 		if(cnt_del==0)
;    1086 			{
;    1087 			step=sOFF;
;    1088 			}
;    1089 		}
;    1090 
;    1091 	}
;    1092 
;    1093 else if(prog==p4)      //замок
;    1094 	{
;    1095 	if(step==s1)
;    1096 		{
;    1097 		temp|=(1<<PP1);
;    1098           if(!bMD1)goto step_contr_end;
;    1099 
;    1100 			if(ee_vacuum_mode==evmOFF)
;    1101 				{
;    1102 				goto lbl_0004;
;    1103 				}
;    1104 			else step=s2;
;    1105           //step=s2;
;    1106 		}
;    1107 
;    1108 	else if(step==s2)
;    1109 		{
;    1110 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1111           if(!bVR)goto step_contr_end;
;    1112 lbl_0004:
;    1113           step=s3;
;    1114 		cnt_del=50;
;    1115           }
;    1116 
;    1117 	else if(step==s3)
;    1118 		{
;    1119 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1120           cnt_del--;
;    1121           if(cnt_del==0)
;    1122 			{
;    1123           	step=s4;
;    1124 			cnt_del=ee_delay[prog,0]*10U;
;    1125 			}
;    1126           }
;    1127 
;    1128    	else if(step==s4)
;    1129 		{
;    1130 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1131 		cnt_del--;
;    1132 		if(cnt_del==0)
;    1133 			{
;    1134 			step=s5;
;    1135 			cnt_del=30;
;    1136 			}
;    1137 		}
;    1138 
;    1139 	else if(step==s5)
;    1140 		{
;    1141 		temp|=(1<<PP1)|(1<<PP4);
;    1142 		cnt_del--;
;    1143 		if(cnt_del==0)
;    1144 			{
;    1145 			step=s6;
;    1146 			cnt_del=ee_delay[prog,1]*10U;
;    1147 			}
;    1148 		}
;    1149 
;    1150 	else if(step==s6)
;    1151 		{
;    1152 		temp|=(1<<PP4);
;    1153 		cnt_del--;
;    1154 		if(cnt_del==0)
;    1155 			{
;    1156 			step=sOFF;
;    1157 			}
;    1158 		}
;    1159 
;    1160 	}
;    1161 	
;    1162 step_contr_end:
;    1163 
;    1164 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1165 
;    1166 PORTB=~temp;
;    1167 //PORTB=0x55;
;    1168 }
;    1169 #endif
;    1170 
;    1171 #ifdef I220_WI
;    1172 //-----------------------------------------------
;    1173 void step_contr(void)
;    1174 {
;    1175 char temp=0;
;    1176 DDRB=0xFF;
;    1177 
;    1178 if(step==sOFF)goto step_contr_end;
;    1179 
;    1180 else if(prog==p3)   //твист
;    1181 	{
;    1182 	if(step==s1)
;    1183 		{
;    1184 		temp|=(1<<PP1);
;    1185           if(!bMD1)goto step_contr_end;
;    1186 
;    1187 			if(ee_vacuum_mode==evmOFF)
;    1188 				{
;    1189 				goto lbl_0003;
;    1190 				}
;    1191 			else step=s2;
;    1192 
;    1193           //step=s2;
;    1194 		}
;    1195 
;    1196 	else if(step==s2)
;    1197 		{
;    1198 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1199           if(!bVR)goto step_contr_end;
;    1200 lbl_0003:
;    1201           cnt_del=50;
;    1202 		step=s3;
;    1203 		}
;    1204 
;    1205 
;    1206 	else	if(step==s3)
;    1207 		{
;    1208 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1209 		cnt_del--;
;    1210 		if(cnt_del==0)
;    1211 			{
;    1212 			cnt_del=90;
;    1213 			step=s4;
;    1214 			}
;    1215           }
;    1216 	else if(step==s4)
;    1217 		{
;    1218 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1219 		cnt_del--;
;    1220  		if(cnt_del==0)
;    1221 			{
;    1222 			cnt_del=130;
;    1223 			step=s5;
;    1224 			}
;    1225 		}
;    1226 
;    1227 	else if(step==s5)
;    1228 		{
;    1229 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1230 		cnt_del--;
;    1231 		if(cnt_del==0)
;    1232 			{
;    1233 			step=s6;
;    1234 			cnt_del=20;
;    1235 			}
;    1236 		}
;    1237 
;    1238 	else if(step==s6)
;    1239 		{
;    1240 		temp|=(1<<PP1);
;    1241   		cnt_del--;
;    1242 		if(cnt_del==0)
;    1243 			{
;    1244 			step=sOFF;
;    1245 			}
;    1246 		}
;    1247 
;    1248 	}
;    1249 
;    1250 else if(prog==p4)      //замок
;    1251 	{
;    1252 	if(step==s1)
;    1253 		{
;    1254 		temp|=(1<<PP1);
;    1255           if(!bMD1)goto step_contr_end;
;    1256 
;    1257 			if(ee_vacuum_mode==evmOFF)
;    1258 				{
;    1259 				goto lbl_0004;
;    1260 				}
;    1261 			else step=s2;
;    1262           //step=s2;
;    1263 		}
;    1264 
;    1265 	else if(step==s2)
;    1266 		{
;    1267 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1268           if(!bVR)goto step_contr_end;
;    1269 lbl_0004:
;    1270           step=s3;
;    1271 		cnt_del=50;
;    1272           }
;    1273 
;    1274 	else if(step==s3)
;    1275 		{
;    1276 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1277           cnt_del--;
;    1278           if(cnt_del==0)
;    1279 			{
;    1280           	step=s4;
;    1281 			cnt_del=120;
;    1282 			}
;    1283           }
;    1284 
;    1285    	else if(step==s4)
;    1286 		{
;    1287 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1288 		cnt_del--;
;    1289 		if(cnt_del==0)
;    1290 			{
;    1291 			step=s5;
;    1292 			cnt_del=30;
;    1293 			}
;    1294 		}
;    1295 
;    1296 	else if(step==s5)
;    1297 		{
;    1298 		temp|=(1<<PP1)|(1<<PP4);
;    1299 		cnt_del--;
;    1300 		if(cnt_del==0)
;    1301 			{
;    1302 			step=s6;
;    1303 			cnt_del=120;
;    1304 			}
;    1305 		}
;    1306 
;    1307 	else if(step==s6)
;    1308 		{
;    1309 		temp|=(1<<PP4);
;    1310 		cnt_del--;
;    1311 		if(cnt_del==0)
;    1312 			{
;    1313 			step=sOFF;
;    1314 			}
;    1315 		}
;    1316 
;    1317 	}
;    1318 	
;    1319 step_contr_end:
;    1320 
;    1321 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1322 
;    1323 PORTB=~temp;
;    1324 //PORTB=0x55;
;    1325 }
;    1326 #endif 
;    1327 
;    1328 #ifdef I380_WI
;    1329 //-----------------------------------------------
;    1330 void step_contr(void)
;    1331 {
;    1332 char temp=0;
;    1333 DDRB=0xFF;
;    1334 
;    1335 if(step==sOFF)goto step_contr_end;
;    1336 
;    1337 else if(prog==p1)
;    1338 	{
;    1339 	if(step==s1)    //жесть
;    1340 		{
;    1341 		temp|=(1<<PP1);
;    1342           if(!bMD1)goto step_contr_end;
;    1343 
;    1344 			if(ee_vacuum_mode==evmOFF)
;    1345 				{
;    1346 				goto lbl_0001;
;    1347 				}
;    1348 			else step=s2;
;    1349 		}
;    1350 
;    1351 	else if(step==s2)
;    1352 		{
;    1353 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1354           if(!bVR)goto step_contr_end;
;    1355 lbl_0001:
;    1356 
;    1357           step=s100;
;    1358 		cnt_del=40;
;    1359           }
;    1360 	else if(step==s100)
;    1361 		{
;    1362 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1363           cnt_del--;
;    1364           if(cnt_del==0)
;    1365 			{
;    1366           	step=s3;
;    1367           	cnt_del=50;
;    1368 			}
;    1369 		}
;    1370 
;    1371 	else if(step==s3)
;    1372 		{
;    1373 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1374           cnt_del--;
;    1375           if(cnt_del==0)
;    1376 			{
;    1377           	step=s4;
;    1378 			}
;    1379 		}
;    1380 	else if(step==s4)
;    1381 		{
;    1382 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;    1383           if(!bMD2)goto step_contr_end;
;    1384           step=s54;
;    1385           cnt_del=20;
;    1386 		}
;    1387 	else if(step==s54)
;    1388 		{
;    1389 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;    1390           cnt_del--;
;    1391           if(cnt_del==0)
;    1392 			{
;    1393           	step=s5;
;    1394           	cnt_del=20;
;    1395 			}
;    1396           }
;    1397 
;    1398 	else if(step==s5)
;    1399 		{
;    1400 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1401           cnt_del--;
;    1402           if(cnt_del==0)
;    1403 			{
;    1404           	step=s6;
;    1405 			}
;    1406           }
;    1407 	else if(step==s6)
;    1408 		{
;    1409 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
;    1410           if(!bMD3)goto step_contr_end;
;    1411           step=s55;
;    1412           cnt_del=40;
;    1413 		}
;    1414 	else if(step==s55)
;    1415 		{
;    1416 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
;    1417           cnt_del--;
;    1418           if(cnt_del==0)
;    1419 			{
;    1420           	step=s7;
;    1421           	cnt_del=20;
;    1422 			}
;    1423           }
;    1424 	else if(step==s7)
;    1425 		{
;    1426 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1427           cnt_del--;
;    1428           if(cnt_del==0)
;    1429 			{
;    1430           	step=s8;
;    1431           	cnt_del=130;
;    1432 			}
;    1433           }
;    1434 	else if(step==s8)
;    1435 		{
;    1436 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1437           cnt_del--;
;    1438           if(cnt_del==0)
;    1439 			{
;    1440           	step=s9;
;    1441           	cnt_del=20;
;    1442 			}
;    1443           }
;    1444 	else if(step==s9)
;    1445 		{
;    1446 		temp|=(1<<PP1);
;    1447           cnt_del--;
;    1448           if(cnt_del==0)
;    1449 			{
;    1450           	step=sOFF;
;    1451           	}
;    1452           }
;    1453 	}
;    1454 
;    1455 else if(prog==p2)  //ско
;    1456 	{
;    1457 	if(step==s1)
;    1458 		{
;    1459 		temp|=(1<<PP1);
;    1460           if(!bMD1)goto step_contr_end;
;    1461 
;    1462 			if(ee_vacuum_mode==evmOFF)
;    1463 				{
;    1464 				goto lbl_0002;
;    1465 				}
;    1466 			else step=s2;
;    1467 
;    1468           //step=s2;
;    1469 		}
;    1470 
;    1471 	else if(step==s2)
;    1472 		{
;    1473 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1474           if(!bVR)goto step_contr_end;
;    1475 
;    1476 lbl_0002:
;    1477           step=s100;
;    1478 		cnt_del=40;
;    1479           }
;    1480 	else if(step==s100)
;    1481 		{
;    1482 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1483           cnt_del--;
;    1484           if(cnt_del==0)
;    1485 			{
;    1486           	step=s3;
;    1487           	cnt_del=50;
;    1488 			}
;    1489 		}
;    1490 	else if(step==s3)
;    1491 		{
;    1492 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1493           cnt_del--;
;    1494           if(cnt_del==0)
;    1495 			{
;    1496           	step=s4;
;    1497 			}
;    1498 		}
;    1499 	else if(step==s4)
;    1500 		{
;    1501 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;    1502           if(!bMD2)goto step_contr_end;
;    1503           step=s5;
;    1504           cnt_del=20;
;    1505 		}
;    1506 	else if(step==s5)
;    1507 		{
;    1508 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1509           cnt_del--;
;    1510           if(cnt_del==0)
;    1511 			{
;    1512           	step=s6;
;    1513           	cnt_del=130;
;    1514 			}
;    1515           }
;    1516 	else if(step==s6)
;    1517 		{
;    1518 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1519           cnt_del--;
;    1520           if(cnt_del==0)
;    1521 			{
;    1522           	step=s7;
;    1523           	cnt_del=20;
;    1524 			}
;    1525           }
;    1526 	else if(step==s7)
;    1527 		{
;    1528 		temp|=(1<<PP1);
;    1529           cnt_del--;
;    1530           if(cnt_del==0)
;    1531 			{
;    1532           	step=sOFF;
;    1533           	}
;    1534           }
;    1535 	}
;    1536 
;    1537 else if(prog==p3)   //твист
;    1538 	{
;    1539 	if(step==s1)
;    1540 		{
;    1541 		temp|=(1<<PP1);
;    1542           if(!bMD1)goto step_contr_end;
;    1543 
;    1544 			if(ee_vacuum_mode==evmOFF)
;    1545 				{
;    1546 				goto lbl_0003;
;    1547 				}
;    1548 			else step=s2;
;    1549 
;    1550           //step=s2;
;    1551 		}
;    1552 
;    1553 	else if(step==s2)
;    1554 		{
;    1555 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1556           if(!bVR)goto step_contr_end;
;    1557 lbl_0003:
;    1558           cnt_del=50;
;    1559 		step=s3;
;    1560 		}
;    1561 
;    1562 
;    1563 	else	if(step==s3)
;    1564 		{
;    1565 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1566 		cnt_del--;
;    1567 		if(cnt_del==0)
;    1568 			{
;    1569 			cnt_del=90;
;    1570 			step=s4;
;    1571 			}
;    1572           }
;    1573 	else if(step==s4)
;    1574 		{
;    1575 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1576 		cnt_del--;
;    1577  		if(cnt_del==0)
;    1578 			{
;    1579 			cnt_del=130;
;    1580 			step=s5;
;    1581 			}
;    1582 		}
;    1583 
;    1584 	else if(step==s5)
;    1585 		{
;    1586 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1587 		cnt_del--;
;    1588 		if(cnt_del==0)
;    1589 			{
;    1590 			step=s6;
;    1591 			cnt_del=20;
;    1592 			}
;    1593 		}
;    1594 
;    1595 	else if(step==s6)
;    1596 		{
;    1597 		temp|=(1<<PP1);
;    1598   		cnt_del--;
;    1599 		if(cnt_del==0)
;    1600 			{
;    1601 			step=sOFF;
;    1602 			}
;    1603 		}
;    1604 
;    1605 	}
;    1606 
;    1607 else if(prog==p4)      //замок
;    1608 	{
;    1609 	if(step==s1)
;    1610 		{
;    1611 		temp|=(1<<PP1);
;    1612           if(!bMD1)goto step_contr_end;
;    1613 
;    1614 			if(ee_vacuum_mode==evmOFF)
;    1615 				{
;    1616 				goto lbl_0004;
;    1617 				}
;    1618 			else step=s2;
;    1619           //step=s2;
;    1620 		}
;    1621 
;    1622 	else if(step==s2)
;    1623 		{
;    1624 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1625           if(!bVR)goto step_contr_end;
;    1626 lbl_0004:
;    1627           step=s3;
;    1628 		cnt_del=50;
;    1629           }
;    1630 
;    1631 	else if(step==s3)
;    1632 		{
;    1633 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1634           cnt_del--;
;    1635           if(cnt_del==0)
;    1636 			{
;    1637           	step=s4;
;    1638 			cnt_del=120U;
;    1639 			}
;    1640           }
;    1641 
;    1642    	else if(step==s4)
;    1643 		{
;    1644 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1645 		cnt_del--;
;    1646 		if(cnt_del==0)
;    1647 			{
;    1648 			step=s5;
;    1649 			cnt_del=30;
;    1650 			}
;    1651 		}
;    1652 
;    1653 	else if(step==s5)
;    1654 		{
;    1655 		temp|=(1<<PP1)|(1<<PP4);
;    1656 		cnt_del--;
;    1657 		if(cnt_del==0)
;    1658 			{
;    1659 			step=s6;
;    1660 			cnt_del=120U;
;    1661 			}
;    1662 		}
;    1663 
;    1664 	else if(step==s6)
;    1665 		{
;    1666 		temp|=(1<<PP4);
;    1667 		cnt_del--;
;    1668 		if(cnt_del==0)
;    1669 			{
;    1670 			step=sOFF;
;    1671 			}
;    1672 		}
;    1673 
;    1674 	}
;    1675 	
;    1676 step_contr_end:
;    1677 
;    1678 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1679 
;    1680 PORTB=~temp;
;    1681 //PORTB=0x55;
;    1682 }
;    1683 #endif
;    1684 
;    1685 #ifdef I220
;    1686 //-----------------------------------------------
;    1687 void step_contr(void)
;    1688 {
;    1689 char temp=0;
;    1690 DDRB=0xFF;
;    1691 
;    1692 if(step==sOFF)goto step_contr_end;
;    1693 
;    1694 else if(prog==p3)   //твист
;    1695 	{
;    1696 	if(step==s1)
;    1697 		{
;    1698 		temp|=(1<<PP1);
;    1699           if(!bMD1)goto step_contr_end;
;    1700 
;    1701 			if(ee_vacuum_mode==evmOFF)
;    1702 				{
;    1703 				goto lbl_0003;
;    1704 				}
;    1705 			else step=s2;
;    1706 
;    1707           //step=s2;
;    1708 		}
;    1709 
;    1710 	else if(step==s2)
;    1711 		{
;    1712 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1713           if(!bVR)goto step_contr_end;
;    1714 lbl_0003:
;    1715           cnt_del=50;
;    1716 		step=s3;
;    1717 		}
;    1718 
;    1719 
;    1720 	else	if(step==s3)
;    1721 		{
;    1722 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1723 		cnt_del--;
;    1724 		if(cnt_del==0)
;    1725 			{
;    1726 			cnt_del=ee_delay[prog,0]*10U;
;    1727 			step=s4;
;    1728 			}
;    1729           }
;    1730 	else if(step==s4)
;    1731 		{
;    1732 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1733 		cnt_del--;
;    1734  		if(cnt_del==0)
;    1735 			{
;    1736 			cnt_del=ee_delay[prog,1]*10U;
;    1737 			step=s5;
;    1738 			}
;    1739 		}
;    1740 
;    1741 	else if(step==s5)
;    1742 		{
;    1743 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1744 		cnt_del--;
;    1745 		if(cnt_del==0)
;    1746 			{
;    1747 			step=s6;
;    1748 			cnt_del=20;
;    1749 			}
;    1750 		}
;    1751 
;    1752 	else if(step==s6)
;    1753 		{
;    1754 		temp|=(1<<PP1);
;    1755   		cnt_del--;
;    1756 		if(cnt_del==0)
;    1757 			{
;    1758 			step=sOFF;
;    1759 			}
;    1760 		}
;    1761 
;    1762 	}
;    1763 
;    1764 else if(prog==p4)      //замок
;    1765 	{
;    1766 	if(step==s1)
;    1767 		{
;    1768 		temp|=(1<<PP1);
;    1769           if(!bMD1)goto step_contr_end;
;    1770 
;    1771 			if(ee_vacuum_mode==evmOFF)
;    1772 				{
;    1773 				goto lbl_0004;
;    1774 				}
;    1775 			else step=s2;
;    1776           //step=s2;
;    1777 		}
;    1778 
;    1779 	else if(step==s2)
;    1780 		{
;    1781 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1782           if(!bVR)goto step_contr_end;
;    1783 lbl_0004:
;    1784           step=s3;
;    1785 		cnt_del=50;
;    1786           }
;    1787 
;    1788 	else if(step==s3)
;    1789 		{
;    1790 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1791           cnt_del--;
;    1792           if(cnt_del==0)
;    1793 			{
;    1794           	step=s4;
;    1795 			cnt_del=ee_delay[prog,0]*10U;
;    1796 			}
;    1797           }
;    1798 
;    1799    	else if(step==s4)
;    1800 		{
;    1801 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1802 		cnt_del--;
;    1803 		if(cnt_del==0)
;    1804 			{
;    1805 			step=s5;
;    1806 			cnt_del=30;
;    1807 			}
;    1808 		}
;    1809 
;    1810 	else if(step==s5)
;    1811 		{
;    1812 		temp|=(1<<PP1)|(1<<PP4);
;    1813 		cnt_del--;
;    1814 		if(cnt_del==0)
;    1815 			{
;    1816 			step=s6;
;    1817 			cnt_del=ee_delay[prog,1]*10U;
;    1818 			}
;    1819 		}
;    1820 
;    1821 	else if(step==s6)
;    1822 		{
;    1823 		temp|=(1<<PP4);
;    1824 		cnt_del--;
;    1825 		if(cnt_del==0)
;    1826 			{
;    1827 			step=sOFF;
;    1828 			}
;    1829 		}
;    1830 
;    1831 	}
;    1832 	
;    1833 step_contr_end:
;    1834 
;    1835 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1836 
;    1837 PORTB=~temp;
;    1838 //PORTB=0x55;
;    1839 }
;    1840 #endif 
;    1841 
;    1842 #ifdef TVIST_SKO
;    1843 //-----------------------------------------------
;    1844 void step_contr(void)
;    1845 {
;    1846 char temp=0;
;    1847 DDRB=0xFF;
;    1848 
;    1849 if(step==sOFF)
;    1850 	{
;    1851 	temp=0;
;    1852 	}
;    1853 
;    1854 if(prog==p2) //СКО
;    1855 	{
;    1856 	if(step==s1)
;    1857 		{
;    1858 		temp|=(1<<PP1);
;    1859 
;    1860 		cnt_del--;
;    1861 		if(cnt_del==0)
;    1862 			{
;    1863 			step=s2;
;    1864 			cnt_del=30;
;    1865 			}
;    1866 		}
;    1867 
;    1868 	else if(step==s2)
;    1869 		{
;    1870 		temp|=(1<<PP1)|(1<<DV);
;    1871 
;    1872 		cnt_del--;
;    1873 		if(cnt_del==0)
;    1874 			{
;    1875 			step=s3;
;    1876 			}
;    1877 		}
;    1878 
;    1879 
;    1880 	else if(step==s3)
;    1881 		{
;    1882 		temp|=(1<<PP1)|(1<<DV)|(1<<PP2);
;    1883 
;    1884                	if(bMD1)//goto step_contr_end;
;    1885                		{  
;    1886                		cnt_del=100;
;    1887 	       		step=s4;
;    1888 	       		}
;    1889 	       	}
;    1890 
;    1891 	else if(step==s4)
;    1892 		{
;    1893 		temp|=(1<<PP1);
;    1894 		cnt_del--;
;    1895 		if(cnt_del==0)
;    1896 			{
;    1897 			step=sOFF;
;    1898 			}
;    1899 		}
;    1900 
;    1901 	}
;    1902 
;    1903 if(prog==p3)
;    1904 	{
;    1905 	if(step==s1)
;    1906 		{
;    1907 		temp|=(1<<PP1);
;    1908 
;    1909 		cnt_del--;
;    1910 		if(cnt_del==0)
;    1911 			{
;    1912 			step=s2;
;    1913 			cnt_del=100;
;    1914 			}
;    1915 		}
;    1916 
;    1917 	else if(step==s2)
;    1918 		{
;    1919 		temp|=(1<<PP1)|(1<<PP2);
;    1920 
;    1921 		cnt_del--;
;    1922 		if(cnt_del==0)
;    1923 			{
;    1924 			step=s3;
;    1925 			cnt_del=50;
;    1926 			}
;    1927 		}
;    1928 
;    1929 
;    1930 	else if(step==s3)
;    1931 		{
;    1932 		temp|=(1<<PP2);
;    1933 	
;    1934 		cnt_del--;
;    1935 		if(cnt_del==0)
;    1936 			{
;    1937 			step=sOFF;
;    1938 			}
;    1939                	}
;    1940 	}
;    1941 step_contr_end:
;    1942 
;    1943 PORTB=~temp;
;    1944 }
;    1945 #endif
;    1946 
;    1947 #ifdef I380_WI_GAZ
;    1948 //-----------------------------------------------
;    1949 void step_contr(void)
;    1950 {
_step_contr:
;    1951 short temp=0;
;    1952 DDRB=0xFF;
	ST   -Y,R17
	ST   -Y,R16
;	temp -> R16,R17
	LDI  R16,0
	LDI  R17,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
;    1953 
;    1954 if(step==sOFF)goto step_contr_end;
	TST  R11
	BRNE _0x45
	RJMP _0x46
;    1955 
;    1956 else if(prog==p1)
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
_0x45:
	LDI  R30,LOW(1)
	CP   R30,R10
	BREQ PC+3
	JMP _0x48
<<<<<<< HEAD
;    1318 	{
;    1319 	if(step==s1)    //жесть
	CP   R30,R11
	BRNE _0x49
;    1320 		{
;    1321 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    1322           if(!bMD1)goto step_contr_end;
=======
;    1957 	{
;    1958 	if(step==s1)    //жесть
	CP   R30,R11
	BRNE _0x49
;    1959 		{
;    1960 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    1961           if(!bMD1)goto step_contr_end;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDS  R30,_bMD1
	CPI  R30,0
	BRNE _0x4A
	RJMP _0x46
<<<<<<< HEAD
;    1323 
;    1324 			if(ee_vacuum_mode==evmOFF)
=======
;    1962 
;    1963 			if(ee_vacuum_mode==evmOFF)
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
_0x4A:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x4C
<<<<<<< HEAD
;    1325 				{
;    1326 				goto lbl_0001;
;    1327 				}
;    1328 			else step=s2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;    1329 		}
;    1330 
;    1331 	else if(step==s2)
=======
;    1964 				{
;    1965 				goto lbl_0001;
;    1966 				}
;    1967 			else step=s2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;    1968 		}
;    1969 
;    1970 	else if(step==s2)
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	RJMP _0x4E
_0x49:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x4F
<<<<<<< HEAD
;    1332 		{
;    1333 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;    1334           if(!bVR)goto step_contr_end;
=======
;    1971 		{
;    1972 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP7);
	ORI  R16,LOW(200)
;    1973           if(!bVR)goto step_contr_end;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDS  R30,_bVR
	CPI  R30,0
	BRNE _0x50
	RJMP _0x46
<<<<<<< HEAD
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
=======
;    1974 lbl_0001:
_0x50:
_0x4C:
;    1975 
;    1976           step=s3;
	LDI  R30,LOW(3)
	MOV  R11,R30
;    1977 		cnt_del=10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    1978           }
;    1979 	else if(step==s3)
	RJMP _0x51
_0x4F:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0x52
;    1980 		{
;    1981 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)
;    1982           cnt_del--;
	ORI  R16,LOW(200)
	CALL SUBOPT_0x1
;    1983           if(cnt_del==0)
	BRNE _0x53
;    1984 			{
;    1985           	step=s4;
	LDI  R30,LOW(4)
	MOV  R11,R30
;    1986 			}
;    1987 		}
_0x53:
;    1988 	
;    1989 	else if(step==s4)
	RJMP _0x54
_0x52:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0x55
;    1990 		{
;    1991 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP8);
	ORI  R16,LOW(200)
;    1992           if(bVR2)goto step_contr_end;
	CPI  R30,0
	BREQ _0x56
	RJMP _0x46
;    1993           step=s5;
_0x56:
	LDI  R30,LOW(5)
	CALL SUBOPT_0x2
;    1994           cnt_del=40;
;    1995 		}
;    1996 		
;    1997 	else if(step==s5)
	RJMP _0x57
_0x55:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0x58
;    1998 		{
;    1999 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;    2000           cnt_del--;
	CALL SUBOPT_0x1
;    2001           if(cnt_del==0)
	BRNE _0x59
;    2002 			{
;    2003           	step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x3
;    2004           	cnt_del=50;
;    2005 			}
;    2006 		}  
_0x59:
;    2007 	else if(step==s6)
	RJMP _0x5A
_0x58:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0x5B
;    2008 		{
;    2009 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<PP5);
	ORI  R16,LOW(216)
;    2010           cnt_del--;
	CALL SUBOPT_0x1
;    2011           if(cnt_del==0)
	BRNE _0x5C
;    2012 			{
;    2013           	step=s7;
	LDI  R30,LOW(7)
	MOV  R11,R30
;    2014 			}
;    2015 		}		
_0x5C:
;    2016 	else if(step==s7)
	RJMP _0x5D
_0x5B:
	LDI  R30,LOW(7)
	CP   R30,R11
	BRNE _0x5E
;    2017 		{
;    2018 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<PP5)|(1<<DV);
	ORI  R16,LOW(220)
;    2019           if(!bMD2)goto step_contr_end;
	SBRS R3,2
	RJMP _0x46
;    2020           step=s8;
	LDI  R30,LOW(8)
	CALL SUBOPT_0x4
;    2021           cnt_del=30;
;    2022 		}
;    2023 	else if(step==s8)
	RJMP _0x60
_0x5E:
	LDI  R30,LOW(8)
	CP   R30,R11
	BRNE _0x61
;    2024 		{
;    2025 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<PP5)|(1<<DV);
	ORI  R16,LOW(220)
;    2026           cnt_del--;
	CALL SUBOPT_0x1
;    2027           if(cnt_del==0)
	BRNE _0x62
;    2028 			{
;    2029           	step=s9;
	LDI  R30,LOW(9)
	CALL SUBOPT_0x5
;    2030           	cnt_del=20;
;    2031 			}
;    2032           }
_0x62:
;    2033 
;    2034 	else if(step==s9)
	RJMP _0x63
_0x61:
	LDI  R30,LOW(9)
	CP   R30,R11
	BRNE _0x64
;    2035 		{
;    2036 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(212)
;    2037           cnt_del--;
	CALL SUBOPT_0x1
;    2038           if(cnt_del==0)
	BRNE _0x65
;    2039 			{
;    2040           	step=s6;
	LDI  R30,LOW(6)
	MOV  R11,R30
;    2041 			}
;    2042           }
_0x65:
;    2043 	else if(step==s10)
	RJMP _0x66
_0x64:
	LDI  R30,LOW(10)
	CP   R30,R11
	BRNE _0x67
;    2044 		{
;    2045 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<DV)|(1<<PP6);
	ORI  R16,LOW(220)
;    2046           if(!bMD3)goto step_contr_end;
	SBRS R3,3
	RJMP _0x46
;    2047           step=s11;
	LDI  R30,LOW(11)
	CALL SUBOPT_0x2
;    2048           cnt_del=40;
;    2049 		}
;    2050 	else if(step==s11)
	RJMP _0x69
_0x67:
	LDI  R30,LOW(11)
	CP   R30,R11
	BRNE _0x6A
;    2051 		{
;    2052 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<DV)|(1<<PP6);
	ORI  R16,LOW(220)
;    2053           cnt_del--;
	CALL SUBOPT_0x1
;    2054           if(cnt_del==0)
	BRNE _0x6B
;    2055 			{
;    2056           	step=s12;
	LDI  R30,LOW(12)
	CALL SUBOPT_0x5
;    2057           	cnt_del=20;
;    2058 			}
;    2059           }
_0x6B:
;    2060 	else if(step==s12)
	RJMP _0x6C
_0x6A:
	LDI  R30,LOW(12)
	CP   R30,R11
	BRNE _0x6D
;    2061 		{
;    2062 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP7);
	ORI  R16,LOW(200)
;    2063           cnt_del--;
	CALL SUBOPT_0x1
;    2064           if(cnt_del==0)
	BRNE _0x6E
;    2065 			{
;    2066           	step=s13;
	LDI  R30,LOW(13)
	CALL SUBOPT_0x6
;    2067           	cnt_del=130;
;    2068 			}
;    2069           }
_0x6E:
;    2070 	else if(step==s13)
	RJMP _0x6F
_0x6D:
	LDI  R30,LOW(13)
	CP   R30,R11
	BRNE _0x70
;    2071 		{
;    2072 		temp|=(1<<PP1)|(1<<PP2);
	ORI  R16,LOW(192)
;    2073           cnt_del--;
	CALL SUBOPT_0x1
;    2074           if(cnt_del==0)
	BRNE _0x71
;    2075 			{
;    2076           	step=s14;
	LDI  R30,LOW(14)
	CALL SUBOPT_0x5
;    2077           	cnt_del=20;
;    2078 			}
;    2079           }
_0x71:
;    2080 	else if(step==s14)
	RJMP _0x72
_0x70:
	LDI  R30,LOW(14)
	CP   R30,R11
	BRNE _0x73
;    2081 		{
;    2082 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    2083           cnt_del--;
	CALL SUBOPT_0x1
;    2084           if(cnt_del==0)
	BRNE _0x74
;    2085 			{
;    2086           	step=sOFF;
	CLR  R11
;    2087           	}
;    2088           }
_0x74:
;    2089 	}
_0x73:
_0x72:
_0x6F:
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
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
<<<<<<< HEAD
;    1434 
;    1435 else if(prog==p2)  //ско
	RJMP _0x6F
=======
;    2090 
;    2091 else if(prog==p2)  //ско
	RJMP _0x75
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
_0x48:
	LDI  R30,LOW(2)
	CP   R30,R10
	BREQ PC+3
<<<<<<< HEAD
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
=======
	JMP _0x76
;    2092 	{
;    2093 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x77
;    2094 		{
;    2095 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    2096           if(!bMD1)goto step_contr_end;
	LDS  R30,_bMD1
	CPI  R30,0
	BRNE _0x78
	RJMP _0x46
;    2097 
;    2098 			if(ee_vacuum_mode==evmOFF)
_0x78:
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
<<<<<<< HEAD
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
=======
	BREQ _0x7A
;    2099 				{
;    2100 				goto lbl_0002;
;    2101 				}
;    2102 			else step=s2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;    2103 
;    2104           //step=s2;
;    2105 		}
;    2106 
;    2107 	else if(step==s2)
	RJMP _0x7C
_0x77:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x7D
;    2108 		{
;    2109 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(200)
;    2110           if(!bVR)goto step_contr_end;
	LDS  R30,_bVR
	CPI  R30,0
	BRNE _0x7E
	RJMP _0x46
;    2111 
;    2112 lbl_0002:
_0x7E:
_0x7A:
;    2113           step=s100;
	LDI  R30,LOW(19)
	CALL SUBOPT_0x2
;    2114 		cnt_del=40;
;    2115           }
;    2116 	else if(step==s100)
	RJMP _0x7F
_0x7D:
	LDI  R30,LOW(19)
	CP   R30,R11
	BRNE _0x80
;    2117 		{
;    2118 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(216)
;    2119           cnt_del--;
	CALL SUBOPT_0x1
;    2120           if(cnt_del==0)
	BRNE _0x81
;    2121 			{
;    2122           	step=s3;
	LDI  R30,LOW(3)
	CALL SUBOPT_0x3
;    2123           	cnt_del=50;
;    2124 			}
;    2125 		}
_0x81:
;    2126 	else if(step==s3)
	RJMP _0x82
_0x80:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0x83
;    2127 		{
;    2128 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(220)
;    2129           cnt_del--;
	CALL SUBOPT_0x1
;    2130           if(cnt_del==0)
	BRNE _0x84
;    2131 			{
;    2132           	step=s4;
	LDI  R30,LOW(4)
	MOV  R11,R30
;    2133 			}
;    2134 		}
_0x84:
;    2135 	else if(step==s4)
	RJMP _0x85
_0x83:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0x86
;    2136 		{
;    2137 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
	ORI  R16,LOW(220)
;    2138           if(!bMD2)goto step_contr_end;
	SBRS R3,2
	RJMP _0x46
;    2139           step=s5;
	LDI  R30,LOW(5)
	CALL SUBOPT_0x5
;    2140           cnt_del=20;
;    2141 		}
;    2142 	else if(step==s5)
	RJMP _0x88
_0x86:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0x89
;    2143 		{
;    2144 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R16,LOW(220)
;    2145           cnt_del--;
	CALL SUBOPT_0x1
;    2146           if(cnt_del==0)
	BRNE _0x8A
;    2147 			{
;    2148           	step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x6
;    2149           	cnt_del=130;
;    2150 			}
;    2151           }
_0x8A:
;    2152 	else if(step==s6)
	RJMP _0x8B
_0x89:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0x8C
;    2153 		{
;    2154 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;    2155           cnt_del--;
	CALL SUBOPT_0x1
;    2156           if(cnt_del==0)
	BRNE _0x8D
;    2157 			{
;    2158           	step=s7;
	LDI  R30,LOW(7)
	CALL SUBOPT_0x5
;    2159           	cnt_del=20;
;    2160 			}
;    2161           }
_0x8D:
;    2162 	else if(step==s7)
	RJMP _0x8E
_0x8C:
	LDI  R30,LOW(7)
	CP   R30,R11
	BRNE _0x8F
;    2163 		{
;    2164 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    2165           cnt_del--;
	CALL SUBOPT_0x1
;    2166           if(cnt_del==0)
	BRNE _0x90
;    2167 			{
;    2168           	step=sOFF;
	CLR  R11
;    2169           	}
;    2170           }
_0x90:
;    2171 	}
_0x8F:
_0x8E:
_0x8B:
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
_0x88:
_0x85:
_0x82:
_0x7F:
_0x7C:
<<<<<<< HEAD
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
=======
;    2172 
;    2173 else if(prog==p3)   //твист
	RJMP _0x91
_0x76:
	LDI  R30,LOW(3)
	CP   R30,R10
	BREQ PC+3
	JMP _0x92
;    2174 	{
;    2175 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x93
;    2176 		{
;    2177 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    2178           if(!bMD1)goto step_contr_end;
	LDS  R30,_bMD1
	CPI  R30,0
	BRNE _0x94
	RJMP _0x46
;    2179 
;    2180 			if(ee_vacuum_mode==evmOFF)
_0x94:
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
<<<<<<< HEAD
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
=======
	BREQ _0x96
;    2181 				{
;    2182 				goto lbl_0003;
;    2183 				}
;    2184 			else step=s2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;    2185 
;    2186           //step=s2;
;    2187 		}
;    2188 
;    2189 	else if(step==s2)
	RJMP _0x98
_0x93:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x99
;    2190 		{
;    2191 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(200)
;    2192           if(!bVR)goto step_contr_end;
	LDS  R30,_bVR
	CPI  R30,0
	BRNE _0x9A
	RJMP _0x46
;    2193 lbl_0003:
_0x9A:
_0x96:
;    2194           cnt_del=50;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
<<<<<<< HEAD
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
=======
;    2195 		step=s3;
	LDI  R30,LOW(3)
	MOV  R11,R30
;    2196 		}
;    2197 
;    2198 
;    2199 	else	if(step==s3)
	RJMP _0x9B
_0x99:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0x9C
;    2200 		{
;    2201 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(216)
;    2202 		cnt_del--;
	CALL SUBOPT_0x1
;    2203 		if(cnt_del==0)
	BRNE _0x9D
;    2204 			{
;    2205 			cnt_del=90;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
<<<<<<< HEAD
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
=======
;    2206 			step=s4;
	LDI  R30,LOW(4)
	MOV  R11,R30
;    2207 			}
;    2208           }
_0x9D:
;    2209 	else if(step==s4)
	RJMP _0x9E
_0x9C:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0x9F
;    2210 		{
;    2211 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
	ORI  R16,LOW(216)
;    2212 		cnt_del--;
	CALL SUBOPT_0x1
;    2213  		if(cnt_del==0)
	BRNE _0xA0
;    2214 			{
;    2215 			cnt_del=130;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
<<<<<<< HEAD
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
=======
;    2216 			step=s5;
	LDI  R30,LOW(5)
	MOV  R11,R30
;    2217 			}
;    2218 		}
_0xA0:
;    2219 
;    2220 	else if(step==s5)
	RJMP _0xA1
_0x9F:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0xA2
;    2221 		{
;    2222 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
	ORI  R16,LOW(200)
;    2223 		cnt_del--;
	CALL SUBOPT_0x1
;    2224 		if(cnt_del==0)
	BRNE _0xA3
;    2225 			{
;    2226 			step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x5
;    2227 			cnt_del=20;
;    2228 			}
;    2229 		}
_0xA3:
;    2230 
;    2231 	else if(step==s6)
	RJMP _0xA4
_0xA2:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0xA5
;    2232 		{
;    2233 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    2234   		cnt_del--;
	CALL SUBOPT_0x1
;    2235 		if(cnt_del==0)
	BRNE _0xA6
;    2236 			{
;    2237 			step=sOFF;
	CLR  R11
;    2238 			}
;    2239 		}
_0xA6:
;    2240 
;    2241 	}
_0xA5:
_0xA4:
_0xA1:
_0x9E:
_0x9B:
_0x98:
;    2242 
;    2243 else if(prog==p4)      //замок
	RJMP _0xA7
_0x92:
	LDI  R30,LOW(4)
	CP   R30,R10
	BREQ PC+3
	JMP _0xA8
;    2244 	{
;    2245 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0xA9
;    2246 		{
;    2247 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    2248           if(!bMD1)goto step_contr_end;
	LDS  R30,_bMD1
	CPI  R30,0
	BREQ _0x46
;    2249 
;    2250 			if(ee_vacuum_mode==evmOFF)
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
<<<<<<< HEAD
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
=======
	BREQ _0xAC
;    2251 				{
;    2252 				goto lbl_0004;
;    2253 				}
;    2254 			else step=s2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;    2255           //step=s2;
;    2256 		}
;    2257 
;    2258 	else if(step==s2)
	RJMP _0xAE
_0xA9:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0xAF
;    2259 		{
;    2260 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(200)
;    2261           if(!bVR)goto step_contr_end;
	LDS  R30,_bVR
	CPI  R30,0
	BREQ _0x46
;    2262 lbl_0004:
_0xAC:
;    2263           step=s3;
	LDI  R30,LOW(3)
	CALL SUBOPT_0x3
;    2264 		cnt_del=50;
;    2265           }
;    2266 
;    2267 	else if(step==s3)
	RJMP _0xB1
_0xAF:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0xB2
;    2268 		{
;    2269 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(216)
;    2270           cnt_del--;
	CALL SUBOPT_0x1
;    2271           if(cnt_del==0)
	BRNE _0xB3
;    2272 			{
;    2273           	step=s4;
	LDI  R30,LOW(4)
	CALL SUBOPT_0x7
;    2274 			cnt_del=120U;
;    2275 			}
;    2276           }
_0xB3:
;    2277 
;    2278    	else if(step==s4)
	RJMP _0xB4
_0xB2:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0xB5
;    2279 		{
;    2280 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;    2281 		cnt_del--;
	CALL SUBOPT_0x1
;    2282 		if(cnt_del==0)
	BRNE _0xB6
;    2283 			{
;    2284 			step=s5;
	LDI  R30,LOW(5)
	CALL SUBOPT_0x4
;    2285 			cnt_del=30;
;    2286 			}
;    2287 		}
_0xB6:
;    2288 
;    2289 	else if(step==s5)
	RJMP _0xB7
_0xB5:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0xB8
;    2290 		{
;    2291 		temp|=(1<<PP1)|(1<<PP4);
	ORI  R16,LOW(80)
;    2292 		cnt_del--;
	CALL SUBOPT_0x1
;    2293 		if(cnt_del==0)
	BRNE _0xB9
;    2294 			{
;    2295 			step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x7
;    2296 			cnt_del=120U;
;    2297 			}
;    2298 		}
_0xB9:
;    2299 
;    2300 	else if(step==s6)
	RJMP _0xBA
_0xB8:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0xBB
;    2301 		{
;    2302 		temp|=(1<<PP4);
	ORI  R16,LOW(16)
;    2303 		cnt_del--;
	CALL SUBOPT_0x1
;    2304 		if(cnt_del==0)
	BRNE _0xBC
;    2305 			{
;    2306 			step=sOFF;
	CLR  R11
;    2307 			}
;    2308 		}
_0xBC:
;    2309 
;    2310 	}
_0xBB:
_0xBA:
_0xB7:
_0xB4:
_0xB1:
_0xAE:
;    2311 	
;    2312 step_contr_end:
_0xA8:
_0xA7:
_0x91:
_0x75:
_0x46:
;    2313 
;    2314 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
<<<<<<< HEAD
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
=======
	BRNE _0xBD
	ANDI R16,LOW(65527)
;    2315 
;    2316 PORTB=~temp;
_0xBD:
	__GETW1R 16,17
	COM  R30
	COM  R31
	OUT  0x18,R30
;    2317 //PORTB=0x55;
;    2318 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;    2319 #endif
;    2320 
;    2321 
;    2322 //-----------------------------------------------
;    2323 void bin2bcd_int(unsigned int in)
;    2324 {
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
_bin2bcd_int:
;    2325 char i;
;    2326 for(i=3;i>0;i--)
	ST   -Y,R16
;	in -> Y+1
;	i -> R16
	LDI  R16,LOW(3)
<<<<<<< HEAD
_0xB9:
	LDI  R30,LOW(0)
	CP   R30,R16
	BRSH _0xBA
;    1931 	{
;    1932 	dig[i]=in%10;
=======
_0xBF:
	LDI  R30,LOW(0)
	CP   R30,R16
	BRSH _0xC0
;    2327 	{
;    2328 	dig[i]=in%10;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
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
;    2329 	in/=10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
;    2330 	}   
	SUBI R16,1
<<<<<<< HEAD
	RJMP _0xB9
_0xBA:
;    1935 }
	LDD  R16,Y+0
	RJMP _0x125
;    1936 
;    1937 //-----------------------------------------------
;    1938 void bcd2ind(char s)
;    1939 {
=======
	RJMP _0xBF
_0xC0:
;    2331 }
	LDD  R16,Y+0
	RJMP _0x12B
;    2332 
;    2333 //-----------------------------------------------
;    2334 void bcd2ind(char s)
;    2335 {
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
_bcd2ind:
;    2336 char i;
;    2337 bZ=1;
	ST   -Y,R16
;	s -> Y+1
;	i -> R16
	SET
	BLD  R2,3
;    2338 for (i=0;i<5;i++)
	LDI  R16,LOW(0)
<<<<<<< HEAD
_0xBC:
	CPI  R16,5
	BRLO PC+3
	JMP _0xBD
;    1943 	{
;    1944 	if(bZ&&(!dig[i-1])&&(i<4))
	SBRS R2,3
	RJMP _0xBF
	CALL SUBOPT_0x7
=======
_0xC2:
	CPI  R16,5
	BRLO PC+3
	JMP _0xC3
;    2339 	{
;    2340 	if(bZ&&(!dig[i-1])&&(i<4))
	SBRS R2,3
	RJMP _0xC5
	CALL SUBOPT_0x8
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	CPI  R30,0
<<<<<<< HEAD
	BRNE _0xBF
	CPI  R16,4
	BRLO _0xC0
_0xBF:
	RJMP _0xBE
_0xC0:
;    1945 		{
;    1946 		if((4-i)>s)
=======
	BRNE _0xC5
	CPI  R16,4
	BRLO _0xC6
_0xC5:
	RJMP _0xC4
_0xC6:
;    2341 		{
;    2342 		if((4-i)>s)
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDI  R30,LOW(4)
	SUB  R30,R16
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
<<<<<<< HEAD
	BRSH _0xC1
;    1947 			{
;    1948 			ind_out[i-1]=DIGISYM[10];
	CALL SUBOPT_0x7
=======
	BRSH _0xC7
;    2343 			{
;    2344 			ind_out[i-1]=DIGISYM[10];
	CALL SUBOPT_0x8
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	POP  R26
	POP  R27
<<<<<<< HEAD
	RJMP _0x126
;    1949 			}
;    1950 		else ind_out[i-1]=DIGISYM[0];	
_0xC1:
	CALL SUBOPT_0x7
=======
	RJMP _0x12C
;    2345 			}
;    2346 		else ind_out[i-1]=DIGISYM[0];	
_0xC7:
	CALL SUBOPT_0x8
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
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
_0x126:
	ST   X,R30
;    1951 		}
;    1952 	else
	RJMP _0xC3
_0xBE:
;    1953 		{
;    1954 		ind_out[i-1]=DIGISYM[dig[i-1]];
	CALL SUBOPT_0x7
=======
_0x12C:
	ST   X,R30
;    2347 		}
;    2348 	else
	RJMP _0xC9
_0xC4:
;    2349 		{
;    2350 		ind_out[i-1]=DIGISYM[dig[i-1]];
	CALL SUBOPT_0x8
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	POP  R26
	POP  R27
	CALL SUBOPT_0x9
	POP  R26
	POP  R27
	ST   X,R30
;    2351 		bZ=0;
	CLT
	BLD  R2,3
<<<<<<< HEAD
;    1956 		}                   
_0xC3:
;    1957 
;    1958 	if(s)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0xC4
;    1959 		{
;    1960 		ind_out[3-s]&=0b01111111;
=======
;    2352 		}                   
_0xC9:
;    2353 
;    2354 	if(s)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0xCA
;    2355 		{
;    2356 		ind_out[3-s]&=0b01111111;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
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
;    1961 		}	
;    1962  
;    1963 	}
_0xC4:
	SUBI R16,-1
	RJMP _0xBC
_0xBD:
;    1964 }            
=======
;    2357 		}	
;    2358  
;    2359 	}
_0xCA:
	SUBI R16,-1
	RJMP _0xC2
_0xC3:
;    2360 }            
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDD  R16,Y+0
	ADIW R28,2
	RET
;    2361 //-----------------------------------------------
;    2362 void int2ind(unsigned int in,char s)
;    2363 {
_int2ind:
;    2364 bin2bcd_int(in);
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _bin2bcd_int
;    2365 bcd2ind(s);
	LD   R30,Y
	ST   -Y,R30
	CALL _bcd2ind
<<<<<<< HEAD
;    1970 
;    1971 } 
_0x125:
=======
;    2366 
;    2367 } 
_0x12B:
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	ADIW R28,3
	RET
;    2368 
;    2369 //-----------------------------------------------
;    2370 void ind_hndl(void)
;    2371 {
_ind_hndl:
;    2372 int2ind(ee_delay[prog,sub_ind],1);  
	CALL SUBOPT_0xA
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _int2ind
;    2373 //ind_out[0]=0xff;//DIGISYM[0];
;    2374 //ind_out[1]=0xff;//DIGISYM[1];
;    2375 //ind_out[2]=DIGISYM[2];//0xff;
;    2376 //ind_out[0]=DIGISYM[7]; 
;    2377 
;    2378 ind_out[0]=DIGISYM[sub_ind+1];
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	PUSH R31
	PUSH R30
	MOV  R30,R13
	SUBI R30,-LOW(1)
	POP  R26
	POP  R27
	CALL SUBOPT_0x9
	STS  _ind_out,R30
;    2379 }
	RET
;    2380 
;    2381 //-----------------------------------------------
;    2382 void led_hndl(void)
;    2383 {
_led_hndl:
;    2384 ind_out[4]=DIGISYM[10]; 
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	__PUTB1MN _ind_out,4
;    2385 
;    2386 ind_out[4]&=~(1<<LED_POW_ON); 
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xDF
	POP  R26
	POP  R27
	ST   X,R30
;    2387 
;    2388 if(step!=sOFF)
	TST  R11
<<<<<<< HEAD
	BREQ _0xC5
;    1993 	{
;    1994 	ind_out[4]&=~(1<<LED_WRK);
=======
	BREQ _0xCB
;    2389 	{
;    2390 	ind_out[4]&=~(1<<LED_WRK);
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xBF
	POP  R26
	POP  R27
<<<<<<< HEAD
	RJMP _0x127
;    1995 	}
;    1996 else ind_out[4]|=(1<<LED_WRK);
_0xC5:
=======
	RJMP _0x12D
;    2391 	}
;    2392 else ind_out[4]|=(1<<LED_WRK);
_0xCB:
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x40
	POP  R26
	POP  R27
<<<<<<< HEAD
_0x127:
=======
_0x12D:
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	ST   X,R30
;    2393 
;    2394 
;    2395 if(step==sOFF)
	TST  R11
<<<<<<< HEAD
	BRNE _0xC7
;    2000 	{
;    2001  	if(bERR)
	SBRS R3,1
	RJMP _0xC8
;    2002 		{
;    2003 		ind_out[4]&=~(1<<LED_ERROR);
=======
	BRNE _0xCD
;    2396 	{
;    2397  	if(bERR)
	SBRS R3,1
	RJMP _0xCE
;    2398 		{
;    2399 		ind_out[4]&=~(1<<LED_ERROR);
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFE
	POP  R26
	POP  R27
<<<<<<< HEAD
	RJMP _0x128
;    2004 		}
;    2005 	else
_0xC8:
;    2006 		{
;    2007 		ind_out[4]|=(1<<LED_ERROR);
=======
	RJMP _0x12E
;    2400 		}
;    2401 	else
_0xCE:
;    2402 		{
;    2403 		ind_out[4]|=(1<<LED_ERROR);
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
<<<<<<< HEAD
_0x128:
	ST   X,R30
;    2008 		}
;    2009      }
;    2010 else ind_out[4]|=(1<<LED_ERROR);
	RJMP _0xCA
_0xC7:
=======
_0x12E:
	ST   X,R30
;    2404 		}
;    2405      }
;    2406 else ind_out[4]|=(1<<LED_ERROR);
	RJMP _0xD0
_0xCD:
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
	ST   X,R30
<<<<<<< HEAD
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
=======
_0xD0:
;    2407 
;    2408 /* 	if(bMD1)
;    2409 		{
;    2410 		ind_out[4]&=~(1<<LED_ERROR);
;    2411 		}
;    2412 	else
;    2413 		{
;    2414 		ind_out[4]|=(1<<LED_ERROR);
;    2415 		} */
;    2416 
;    2417 //if(bERR)ind_out[4]&=~(1<<LED_ERROR);
;    2418 if(ee_vacuum_mode==evmON)ind_out[4]&=~(1<<LED_VACUUM);
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
<<<<<<< HEAD
	BRNE _0xCB
=======
	BRNE _0xD1
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0x7F
	POP  R26
	POP  R27
<<<<<<< HEAD
	RJMP _0x129
;    2023 else ind_out[4]|=(1<<LED_VACUUM);
_0xCB:
=======
	RJMP _0x12F
;    2419 else ind_out[4]|=(1<<LED_VACUUM);
_0xD1:
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x80
	POP  R26
	POP  R27
<<<<<<< HEAD
_0x129:
=======
_0x12F:
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	ST   X,R30
;    2420 
;    2421 if(prog==p1) ind_out[4]&=~(1<<LED_PROG1);
	LDI  R30,LOW(1)
	CP   R30,R10
<<<<<<< HEAD
	BRNE _0xCD
=======
	BRNE _0xD3
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xEF
	POP  R26
	POP  R27
	ST   X,R30
<<<<<<< HEAD
;    2026 else if(prog==p2) ind_out[4]&=~(1<<LED_PROG2);
	RJMP _0xCE
_0xCD:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0xCF
=======
;    2422 else if(prog==p2) ind_out[4]&=~(1<<LED_PROG2);
	RJMP _0xD4
_0xD3:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0xD5
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFB
	POP  R26
	POP  R27
	ST   X,R30
<<<<<<< HEAD
;    2027 else if(prog==p3) ind_out[4]&=~(1<<LED_PROG3);
	RJMP _0xD0
_0xCF:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0xD1
=======
;    2423 else if(prog==p3) ind_out[4]&=~(1<<LED_PROG3);
	RJMP _0xD6
_0xD5:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0xD7
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0XF7
	POP  R26
	POP  R27
	ST   X,R30
<<<<<<< HEAD
;    2028 else if(prog==p4) ind_out[4]&=~(1<<LED_PROG4);
	RJMP _0xD2
_0xD1:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0xD3
=======
;    2424 else if(prog==p4) ind_out[4]&=~(1<<LED_PROG4);
	RJMP _0xD8
_0xD7:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0xD9
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFD
	POP  R26
	POP  R27
	ST   X,R30
<<<<<<< HEAD
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
=======
;    2425 
;    2426 if(ind==iPr_sel)
_0xD9:
_0xD8:
_0xD6:
_0xD4:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0xDA
;    2427 	{
;    2428 	if(bFL5)ind_out[4]|=(1<<LED_PROG1)|(1<<LED_PROG2)|(1<<LED_PROG3)|(1<<LED_PROG4);
	SBRS R3,0
	RJMP _0xDB
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,LOW(0x1E)
	POP  R26
	POP  R27
	ST   X,R30
<<<<<<< HEAD
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
=======
;    2429 	} 
_0xDB:
;    2430 	 
;    2431 if(ind==iVr)
_0xDA:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0xDC
;    2432 	{
;    2433 	if(bFL5)ind_out[4]|=(1<<LED_POW_ON);
	SBRS R3,0
	RJMP _0xDD
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x20
	POP  R26
	POP  R27
	ST   X,R30
<<<<<<< HEAD
;    2038 	}	
_0xD7:
;    2039 }
_0xD6:
=======
;    2434 	}	
_0xDD:
;    2435 }
_0xDC:
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	RET
;    2436 
;    2437 //-----------------------------------------------
;    2438 // Подпрограмма драйва до 7 кнопок одного порта, 
;    2439 // различает короткое и длинное нажатие,
;    2440 // срабатывает на отпускание кнопки, возможность
;    2441 // ускорения перебора при длинном нажатии...
;    2442 #define but_port PORTC
;    2443 #define but_dir  DDRC
;    2444 #define but_pin  PINC
;    2445 #define but_mask 0b01101010
;    2446 #define no_but   0b11111111
;    2447 #define but_on   5
;    2448 #define but_onL  20
;    2449 
;    2450 
;    2451 
;    2452 
;    2453 void but_drv(void)
;    2454 { 
_but_drv:
;    2455 DDRD&=0b00000111;
	IN   R30,0x11
	ANDI R30,LOW(0x7)
	CALL SUBOPT_0xB
;    2456 PORTD|=0b11111000;
;    2457 
;    2458 but_port|=(but_mask^0xff);
	CALL SUBOPT_0xC
;    2459 but_dir&=but_mask;
;    2460 #asm
;    2461 nop
nop
;    2462 nop
nop
;    2463 nop
nop
;    2464 nop
nop
;    2465 #endasm

;    2466 
;    2467 but_n=but_pin|but_mask; 
	IN   R30,0x13
	ORI  R30,LOW(0x6A)
	STS  _but_n_G1,R30
;    2468 
;    2469 if((but_n==no_but)||(but_n!=but_s))
	LDS  R26,_but_n_G1
	CPI  R26,LOW(0xFF)
<<<<<<< HEAD
	BREQ _0xD9
	RCALL SUBOPT_0xC
	BREQ _0xD8
_0xD9:
;    2074  	{
;    2075  	speed=0;
=======
	BREQ _0xDF
	RCALL SUBOPT_0xD
	BREQ _0xDE
_0xDF:
;    2470  	{
;    2471  	speed=0;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	CLT
	BLD  R2,6
;    2472    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
<<<<<<< HEAD
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
=======
	BRSH _0xE2
	LDS  R26,_but1_cnt_G1
	CPI  R26,LOW(0x0)
	BREQ _0xE4
_0xE2:
	SBRS R2,4
	RJMP _0xE5
_0xE4:
	RJMP _0xE1
_0xE5:
;    2473   		{
;    2474    	     n_but=1;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	SET
	BLD  R2,5
;    2475           but=but_s;
	LDS  R9,_but_s_G1
<<<<<<< HEAD
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
=======
;    2476           }
;    2477    	if (but1_cnt>=but_onL_temp)
_0xE1:
	RCALL SUBOPT_0xE
	BRLO _0xE6
;    2478   		{
;    2479    	     n_but=1;
	SET
	BLD  R2,5
;    2480           but=but_s&0b11111101;
	RCALL SUBOPT_0xF
;    2481           }
;    2482     	l_but=0;
_0xE6:
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	CLT
	BLD  R2,4
;    2483    	but_onL_temp=but_onL;
	LDI  R30,LOW(20)
	STS  _but_onL_temp_G1,R30
;    2484     	but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    2485   	but1_cnt=0;          
	STS  _but1_cnt_G1,R30
<<<<<<< HEAD
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
=======
;    2486      goto but_drv_out;
	RJMP _0xE7
;    2487   	}  
;    2488   	
;    2489 if(but_n==but_s)
_0xDE:
	RCALL SUBOPT_0xD
	BRNE _0xE8
;    2490  	{
;    2491   	but0_cnt++;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDS  R30,_but0_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but0_cnt_G1,R30
;    2492   	if(but0_cnt>=but_on)
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
<<<<<<< HEAD
	BRLO _0xE3
;    2097   		{
;    2098    		but0_cnt=0;
=======
	BRLO _0xE9
;    2493   		{
;    2494    		but0_cnt=0;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    2495    		but1_cnt++;
	LDS  R30,_but1_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but1_cnt_G1,R30
<<<<<<< HEAD
;    2100    		if(but1_cnt>=but_onL_temp)
	RCALL SUBOPT_0xD
	BRLO _0xE4
;    2101    			{              
;    2102     			but=but_s&0b11111101;
=======
;    2496    		if(but1_cnt>=but_onL_temp)
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	RCALL SUBOPT_0xE
	BRLO _0xEA
;    2497    			{              
;    2498     			but=but_s&0b11111101;
	RCALL SUBOPT_0xF
;    2499     			but1_cnt=0;
	LDI  R30,LOW(0)
	STS  _but1_cnt_G1,R30
;    2500     			n_but=1;
	SET
	BLD  R2,5
;    2501     			l_but=1;
	SET
	BLD  R2,4
;    2502 			if(speed)
	SBRS R2,6
<<<<<<< HEAD
	RJMP _0xE5
;    2107 				{
;    2108     				but_onL_temp=but_onL_temp>>1;
=======
	RJMP _0xEB
;    2503 				{
;    2504     				but_onL_temp=but_onL_temp>>1;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDS  R30,_but_onL_temp_G1
	LSR  R30
	STS  _but_onL_temp_G1,R30
;    2505         			if(but_onL_temp<=2) but_onL_temp=2;
	LDS  R26,_but_onL_temp_G1
	LDI  R30,LOW(2)
	CP   R30,R26
<<<<<<< HEAD
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
=======
	BRLO _0xEC
	STS  _but_onL_temp_G1,R30
;    2506 				}    
_0xEC:
;    2507    			}
_0xEB:
;    2508   		} 
_0xEA:
;    2509  	}
_0xE9:
;    2510 but_drv_out:
_0xE8:
_0xE7:
;    2511 but_s=but_n;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDS  R30,_but_n_G1
	STS  _but_s_G1,R30
;    2512 but_port|=(but_mask^0xff);
	RCALL SUBOPT_0xC
;    2513 but_dir&=but_mask;
;    2514 }    
	RET
;    2515 
;    2516 #define butV	239
;    2517 #define butV_	237
;    2518 #define butP	251
;    2519 #define butP_	249
;    2520 #define butR	127
;    2521 #define butR_	125
;    2522 #define butL	254
;    2523 #define butL_	252
;    2524 #define butLR	126
;    2525 #define butLR_	124 
;    2526 #define butVP_ 233
;    2527 //-----------------------------------------------
;    2528 void but_an(void)
;    2529 {
_but_an:
;    2530 
;    2531 if(!(in_word&0x01))
	SBRC R14,0
<<<<<<< HEAD
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
=======
	RJMP _0xED
;    2532 	{
;    2533 	#ifdef TVIST_SKO
;    2534 	if((step==sOFF)&&(!bERR))
;    2535 		{
;    2536 		step=s1;
;    2537 		if(prog==p2) cnt_del=70;
;    2538 		else if(prog==p3) cnt_del=100;
;    2539 		}
;    2540 	#endif
;    2541 	#ifdef DV3KL2MD
;    2542 	if((step==sOFF)&&(!bERR))
;    2543 		{
;    2544 		step=s1;
;    2545 		cnt_del=70;
;    2546 		}
;    2547 	#endif	
;    2548 	#ifndef TVIST_SKO
;    2549 	if((step==sOFF)&&(!bERR))
	LDI  R30,LOW(0)
	CP   R30,R11
	BRNE _0xEF
	SBRS R3,1
	RJMP _0xF0
_0xEF:
	RJMP _0xEE
_0xF0:
;    2550 		{
;    2551 		step=s1;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDI  R30,LOW(1)
	MOV  R11,R30
;    2552 		if(prog==p1) cnt_del=50;
	CP   R30,R10
<<<<<<< HEAD
	BRNE _0xEB
=======
	BRNE _0xF1
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
<<<<<<< HEAD
;    2157 		else if(prog==p2) cnt_del=50;
	RJMP _0xEC
_0xEB:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0xED
=======
;    2553 		else if(prog==p2) cnt_del=50;
	RJMP _0xF2
_0xF1:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0xF3
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
<<<<<<< HEAD
;    2158 		else if(prog==p3) cnt_del=50;
	RJMP _0xEE
_0xED:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0xEF
=======
;    2554 		else if(prog==p3) cnt_del=50;
	RJMP _0xF4
_0xF3:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0xF5
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
<<<<<<< HEAD
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
=======
;    2555           #ifdef P380_MINI
;    2556   		cnt_del=100;
;    2557   		#endif
;    2558 		}
_0xF5:
_0xF4:
_0xF2:
;    2559 	#endif
;    2560 	}
_0xEE:
;    2561 if(!(in_word&0x02))
_0xED:
	SBRC R14,1
	RJMP _0xF6
;    2562 	{
;    2563 	step=sOFF;
	CLR  R11
;    2564 
;    2565 	}
;    2566 
;    2567 if (!n_but) goto but_an_end;
_0xF6:
	SBRS R2,5
	RJMP _0xF8
;    2568 
;    2569 if(but==butV_)
	LDI  R30,LOW(237)
	CP   R30,R9
	BRNE _0xF9
;    2570 	{
;    2571 	if(ee_vacuum_mode==evmON)ee_vacuum_mode=evmOFF;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
<<<<<<< HEAD
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
=======
	BRNE _0xFA
	LDI  R30,LOW(170)
	RJMP _0x130
;    2572 	else ee_vacuum_mode=evmON;
_0xFA:
	LDI  R30,LOW(85)
_0x130:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMWRB
;    2573 	}
;    2574 
;    2575 if(but==butVP_)
_0xF9:
	LDI  R30,LOW(233)
	CP   R30,R9
	BRNE _0xFC
;    2576 	{
;    2577 	if(ind!=iVr)ind=iVr;
	LDI  R30,LOW(2)
	CP   R30,R12
	BREQ _0xFD
	MOV  R12,R30
;    2578 	else ind=iMn;
	RJMP _0xFE
_0xFD:
	CLR  R12
_0xFE:
;    2579 	}
;    2580 
;    2581 	
;    2582 if(ind==iMn)
_0xFC:
	TST  R12
	BRNE _0xFF
;    2583 	{
;    2584 	if(but==butP_)ind=iPr_sel;
	LDI  R30,LOW(249)
	CP   R30,R9
	BRNE _0x100
	LDI  R30,LOW(1)
	MOV  R12,R30
;    2585 	if(but==butLR)	
_0x100:
	LDI  R30,LOW(126)
	CP   R30,R9
	BRNE _0x101
;    2586 		{
;    2587 		if((prog==p3)||(prog==p4))
	LDI  R30,LOW(3)
	CP   R30,R10
	BREQ _0x103
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0x102
_0x103:
;    2588 			{ 
;    2589 			if(sub_ind==0)sub_ind=1;
	TST  R13
	BRNE _0x105
	LDI  R30,LOW(1)
	MOV  R13,R30
;    2590 			else sub_ind=0;
	RJMP _0x106
_0x105:
	CLR  R13
_0x106:
;    2591 			}
;    2592     		else sub_ind=0;
	RJMP _0x107
_0x102:
	CLR  R13
_0x107:
;    2593 		}	 
;    2594 	if((but==butR)||(but==butR_))	
_0x101:
	LDI  R30,LOW(127)
	CP   R30,R9
	BREQ _0x109
	LDI  R30,LOW(125)
	CP   R30,R9
	BRNE _0x108
_0x109:
;    2595 		{  
;    2596 		speed=1;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	SET
	BLD  R2,6
;    2597 		ee_delay[prog,sub_ind]++;
	RCALL SUBOPT_0xA
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
<<<<<<< HEAD
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
=======
;    2598 		}   
;    2599 	
;    2600 	else if((but==butL)||(but==butL_))	
	RJMP _0x10B
_0x108:
	LDI  R30,LOW(254)
	CP   R30,R9
	BREQ _0x10D
	LDI  R30,LOW(252)
	CP   R30,R9
	BRNE _0x10C
_0x10D:
;    2601 		{  
;    2602     		speed=1;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	SET
	BLD  R2,6
;    2603     		ee_delay[prog,sub_ind]--;
	RCALL SUBOPT_0xA
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
<<<<<<< HEAD
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
=======
;    2604     		}		
;    2605 	} 
_0x10C:
_0x10B:
;    2606 	
;    2607 else if(ind==iPr_sel)
	RJMP _0x10F
_0xFF:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x110
;    2608 	{
;    2609 	if(but==butP_)ind=iMn;
	LDI  R30,LOW(249)
	CP   R30,R9
	BRNE _0x111
	CLR  R12
;    2610 	if(but==butP)
_0x111:
	LDI  R30,LOW(251)
	CP   R30,R9
	BRNE _0x112
;    2611 		{
;    2612 		prog++;
	RCALL SUBOPT_0x10
;    2613 		if(prog>MAXPROG)prog=MINPROG;
	BRGE _0x113
	LDI  R30,LOW(1)
	MOV  R10,R30
;    2614 		ee_program[0]=prog;
_0x113:
	RCALL SUBOPT_0x11
;    2615 		ee_program[1]=prog;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	__POINTW2MN _ee_program,1
	MOV  R30,R10
	CALL __EEPROMWRB
;    2616 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R10
	CALL __EEPROMWRB
<<<<<<< HEAD
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
=======
;    2617 		}
;    2618 	
;    2619 	if(but==butR)
_0x112:
	LDI  R30,LOW(127)
	CP   R30,R9
	BRNE _0x114
;    2620 		{
;    2621 		prog++;
	RCALL SUBOPT_0x10
;    2622 		if(prog>MAXPROG)prog=MINPROG;
	BRGE _0x115
	LDI  R30,LOW(1)
	MOV  R10,R30
;    2623 		ee_program[0]=prog;
_0x115:
	RCALL SUBOPT_0x11
;    2624 		ee_program[1]=prog;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	__POINTW2MN _ee_program,1
	MOV  R30,R10
	CALL __EEPROMWRB
;    2625 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R10
	CALL __EEPROMWRB
<<<<<<< HEAD
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
=======
;    2626 		}
;    2627 
;    2628 	if(but==butL)
_0x114:
	LDI  R30,LOW(254)
	CP   R30,R9
	BRNE _0x116
;    2629 		{
;    2630 		prog--;
	DEC  R10
;    2631 		if(prog>MAXPROG)prog=MINPROG;
	LDI  R30,LOW(3)
	CP   R30,R10
	BRGE _0x117
	LDI  R30,LOW(1)
	MOV  R10,R30
;    2632 		ee_program[0]=prog;
_0x117:
	RCALL SUBOPT_0x11
;    2633 		ee_program[1]=prog;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	__POINTW2MN _ee_program,1
	MOV  R30,R10
	CALL __EEPROMWRB
;    2634 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R10
	CALL __EEPROMWRB
<<<<<<< HEAD
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
=======
;    2635 		}	
;    2636 	} 
_0x116:
;    2637 
;    2638 else if(ind==iVr)
	RJMP _0x118
_0x110:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x119
;    2639 	{
;    2640 	if(but==butP_)
	LDI  R30,LOW(249)
	CP   R30,R9
	BRNE _0x11A
;    2641 		{
;    2642 		if(ee_vr_log)ee_vr_log=0;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDI  R26,LOW(_ee_vr_log)
	LDI  R27,HIGH(_ee_vr_log)
	CALL __EEPROMRDB
	CPI  R30,0
<<<<<<< HEAD
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
=======
	BREQ _0x11B
	LDI  R30,LOW(0)
	RJMP _0x131
;    2643 		else ee_vr_log=1;
_0x11B:
	LDI  R30,LOW(1)
_0x131:
	LDI  R26,LOW(_ee_vr_log)
	LDI  R27,HIGH(_ee_vr_log)
	CALL __EEPROMWRB
;    2644 		}	
;    2645 	} 	
_0x11A:
;    2646 
;    2647 but_an_end:
_0x119:
_0x118:
_0x10F:
_0xF8:
;    2648 n_but=0;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	CLT
	BLD  R2,5
;    2649 }
	RET
;    2650 
;    2651 //-----------------------------------------------
;    2652 void ind_drv(void)
;    2653 {
_ind_drv:
;    2654 if(++ind_cnt>=6)ind_cnt=0;
	INC  R8
	LDI  R30,LOW(6)
	CP   R8,R30
<<<<<<< HEAD
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
=======
	BRLO _0x11D
	CLR  R8
;    2655 
;    2656 if(ind_cnt<5)
_0x11D:
	LDI  R30,LOW(5)
	CP   R8,R30
	BRSH _0x11E
;    2657 	{
;    2658 	DDRC=0xFF;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	LDI  R30,LOW(255)
	OUT  0x14,R30
;    2659 	PORTC=0xFF;
	OUT  0x15,R30
;    2660 	DDRD|=0b11111000;
	IN   R30,0x11
	ORI  R30,LOW(0xF8)
	RCALL SUBOPT_0xB
;    2661 	PORTD|=0b11111000;
;    2662 	PORTD&=IND_STROB[ind_cnt];
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
;    2663 	PORTC=ind_out[ind_cnt];
	MOV  R30,R8
	LDI  R31,0
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	LD   R30,Z
	OUT  0x15,R30
<<<<<<< HEAD
;    2268 	}
;    2269 else but_drv();
	RJMP _0x119
_0x118:
	CALL _but_drv
_0x119:
;    2270 }
=======
;    2664 	}
;    2665 else but_drv();
	RJMP _0x11F
_0x11E:
	CALL _but_drv
_0x11F:
;    2666 }
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	RET
;    2667 
;    2668 //***********************************************
;    2669 //***********************************************
;    2670 //***********************************************
;    2671 //***********************************************
;    2672 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;    2673 {
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
;    2674 TCCR0=0x02;
	RCALL SUBOPT_0x12
;    2675 TCNT0=-208;
;    2676 OCR0=0x00; 
;    2677 
;    2678 
;    2679 b600Hz=1;
	SET
	BLD  R2,0
;    2680 ind_drv();
	RCALL _ind_drv
;    2681 if(++t0_cnt0>=6)
	INC  R4
	LDI  R30,LOW(6)
	CP   R4,R30
<<<<<<< HEAD
	BRLO _0x11A
;    2286 	{
;    2287 	t0_cnt0=0;
=======
	BRLO _0x120
;    2682 	{
;    2683 	t0_cnt0=0;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	CLR  R4
;    2684 	b100Hz=1;
	SET
	BLD  R2,1
<<<<<<< HEAD
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
=======
;    2685 	}
;    2686 
;    2687 if(++t0_cnt1>=60)
_0x120:
	INC  R5
	LDI  R30,LOW(60)
	CP   R5,R30
	BRLO _0x121
;    2688 	{
;    2689 	t0_cnt1=0;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	CLR  R5
;    2690 	b10Hz=1;
	SET
	BLD  R2,2
;    2691 	
;    2692 	if(++t0_cnt2>=2)
	INC  R6
	LDI  R30,LOW(2)
	CP   R6,R30
<<<<<<< HEAD
	BRLO _0x11C
;    2297 		{
;    2298 		t0_cnt2=0;
=======
	BRLO _0x122
;    2693 		{
;    2694 		t0_cnt2=0;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	CLR  R6
;    2695 		bFL5=!bFL5;
	LDI  R30,LOW(1)
	EOR  R3,R30
<<<<<<< HEAD
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
=======
;    2696 		}
;    2697 		
;    2698 	if(++t0_cnt3>=5)
_0x122:
	INC  R7
	LDI  R30,LOW(5)
	CP   R7,R30
	BRLO _0x123
;    2699 		{
;    2700 		t0_cnt3=0;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	CLR  R7
;    2701 		bFL2=!bFL2;
	LDI  R30,LOW(128)
	EOR  R2,R30
<<<<<<< HEAD
;    2306 		}		
;    2307 	}
_0x11D:
;    2308 }
_0x11B:
=======
;    2702 		}		
;    2703 	}
_0x123:
;    2704 }
_0x121:
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
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
;    2705 
;    2706 //===============================================
;    2707 //===============================================
;    2708 //===============================================
;    2709 //===============================================
;    2710 
;    2711 void main(void)
;    2712 {
_main:
;    2713 
;    2714 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
;    2715 DDRA=0x00;
	RCALL SUBOPT_0x0
;    2716 
;    2717 PORTB=0xff;
	RCALL SUBOPT_0x13
;    2718 DDRB=0xFF;
;    2719 
;    2720 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;    2721 DDRC=0x00;
	OUT  0x14,R30
;    2722 
;    2723 
;    2724 PORTD=0x00;
	OUT  0x12,R30
;    2725 DDRD=0x00;
	OUT  0x11,R30
;    2726 
;    2727 
;    2728 TCCR0=0x02;
	RCALL SUBOPT_0x12
;    2729 TCNT0=-208;
;    2730 OCR0=0x00;
;    2731 
;    2732 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;    2733 TCCR1B=0x00;
	OUT  0x2E,R30
;    2734 TCNT1H=0x00;
	OUT  0x2D,R30
;    2735 TCNT1L=0x00;
	OUT  0x2C,R30
;    2736 ICR1H=0x00;
	OUT  0x27,R30
;    2737 ICR1L=0x00;
	OUT  0x26,R30
;    2738 OCR1AH=0x00;
	OUT  0x2B,R30
;    2739 OCR1AL=0x00;
	OUT  0x2A,R30
;    2740 OCR1BH=0x00;
	OUT  0x29,R30
;    2741 OCR1BL=0x00;
	OUT  0x28,R30
;    2742 
;    2743 
;    2744 ASSR=0x00;
	OUT  0x22,R30
;    2745 TCCR2=0x00;
	OUT  0x25,R30
;    2746 TCNT2=0x00;
	OUT  0x24,R30
;    2747 OCR2=0x00;
	OUT  0x23,R30
;    2748 
;    2749 MCUCR=0x00;
	OUT  0x35,R30
;    2750 MCUCSR=0x00;
	OUT  0x34,R30
;    2751 
;    2752 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;    2753 
;    2754 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;    2755 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;    2756 
;    2757 #asm("sei") 
	sei
;    2758 PORTB=0xFF;
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x13
;    2759 DDRB=0xFF;
;    2760 ind=iMn;
	CLR  R12
;    2761 prog_drv();
	CALL _prog_drv
;    2762 ind_hndl();
	CALL _ind_hndl
;    2763 led_hndl();
	CALL _led_hndl
<<<<<<< HEAD
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
=======
;    2764 while (1)
_0x124:
;    2765       {
;    2766       if(b600Hz)
	SBRS R2,0
	RJMP _0x127
;    2767 		{
;    2768 		b600Hz=0; 
	CLT
	BLD  R2,0
;    2769           
;    2770 		}         
;    2771       if(b100Hz)
_0x127:
	SBRS R2,1
	RJMP _0x128
;    2772 		{        
;    2773 		b100Hz=0; 
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	CLT
	BLD  R2,1
;    2774 		but_an();
	RCALL _but_an
;    2775 	    	in_drv();
	CALL _in_drv
;    2776           mdvr_drv();
	CALL _mdvr_drv
;    2777           step_contr();
	CALL _step_contr
<<<<<<< HEAD
;    2382 		}   
;    2383 	if(b10Hz)
_0x122:
	SBRS R2,2
	RJMP _0x123
;    2384 		{
;    2385 		b10Hz=0;
=======
;    2778 		}   
;    2779 	if(b10Hz)
_0x128:
	SBRS R2,2
	RJMP _0x129
;    2780 		{
;    2781 		b10Hz=0;
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	CLT
	BLD  R2,2
;    2782 		prog_drv();
	CALL _prog_drv
;    2783 		err_drv();
	CALL _err_drv
;    2784 		
;    2785     	     ind_hndl();
	CALL _ind_hndl
;    2786           led_hndl();
	CALL _led_hndl
<<<<<<< HEAD
;    2391           
;    2392           }
;    2393 
;    2394       };
_0x123:
	RJMP _0x11E
;    2395 }
_0x124:
	RJMP _0x124
=======
;    2787           
;    2788           }
;    2789 
;    2790       };
_0x129:
	RJMP _0x124
;    2791 }
_0x12A:
	RJMP _0x12A
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	LDI  R30,LOW(255)
	RET

<<<<<<< HEAD
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
=======
;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
SUBOPT_0x1:
	LDI  R30,LOW(19)
	MOV  R11,R30
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

<<<<<<< HEAD
;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES
SUBOPT_0x2:
	LDS  R30,_cnt_del
	LDS  R31,_cnt_del+1
	SBIW R30,1
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	SBIW R30,0
=======
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x2:
	MOV  R11,R30
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x3:
<<<<<<< HEAD
	LDI  R30,LOW(3)
=======
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
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

<<<<<<< HEAD
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5:
	MOV  R11,R30
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
=======
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x5:
	MOV  R11,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6:
	MOV  R11,R30
<<<<<<< HEAD
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
=======
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
>>>>>>> 7ac11cc99193200236cff92932eead7277641eef
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7:
	MOV  R11,R30
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x8:
	MOV  R30,R16
	SUBI R30,LOW(1)
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x9:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
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
	OUT  0x11,R30
	IN   R30,0x12
	ORI  R30,LOW(0xF8)
	OUT  0x12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xC:
	IN   R30,0x15
	ORI  R30,LOW(0x95)
	OUT  0x15,R30
	IN   R30,0x14
	ANDI R30,LOW(0x6A)
	OUT  0x14,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD:
	LDS  R30,_but_s_G1
	LDS  R26,_but_n_G1
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE:
	LDS  R30,_but_onL_temp_G1
	LDS  R26,_but1_cnt_G1
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF:
	LDS  R30,_but_s_G1
	ANDI R30,0xFD
	MOV  R9,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10:
	INC  R10
	LDI  R30,LOW(4)
	CP   R30,R10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x11:
	MOV  R30,R10
	LDI  R26,LOW(_ee_program)
	LDI  R27,HIGH(_ee_program)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x12:
	LDI  R30,LOW(2)
	OUT  0x33,R30
	LDI  R30,LOW(65328)
	LDI  R31,HIGH(65328)
	OUT  0x32,R30
	LDI  R30,LOW(0)
	OUT  0x3C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x13:
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

