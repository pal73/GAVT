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
;      17 //#define I380_WI
;      18 //#define I220_WI
;      19 //#define DV3KL2MD 
;      20 #define  I380_WI_GAZ
;      21 
;      22 #define MD1	2
;      23 #define MD2	3
;      24 #define VR	4
;      25 #define MD3	5
;      26 #define VR2	7
;      27 
;      28 #define PP1	6
;      29 #define PP2	7
;      30 #define PP3	5
;      31 #define PP4	4
;      32 #define PP5	3
;      33 #define DV	0 
;      34 
;      35 #define PP7	2
;      36 
;      37 #ifdef P380_MINI
;      38 #define MINPROG 1
;      39 #define MAXPROG 1 
;      40 #ifdef GAVT3
;      41 #define DV	2
;      42 #endif
;      43 #define PP3	3
;      44 #endif 
;      45 
;      46 #ifdef P380
;      47 #define MINPROG 1
;      48 #define MAXPROG 3 
;      49 #ifdef GAVT3
;      50 #define DV	2
;      51 #endif
;      52 #endif 
;      53 
;      54 #ifdef I380
;      55 #define MINPROG 1
;      56 #define MAXPROG 4
;      57 #endif
;      58 
;      59 #ifdef I380_WI
;      60 #define MINPROG 1
;      61 #define MAXPROG 4
;      62 #endif
;      63 
;      64 #ifdef I220
;      65 #define MINPROG 3
;      66 #define MAXPROG 4
;      67 #endif
;      68 
;      69 
;      70 #ifdef I220_WI
;      71 #define MINPROG 3
;      72 #define MAXPROG 4
;      73 #endif
;      74 
;      75 #ifdef TVIST_SKO
;      76 #define MINPROG 2
;      77 #define MAXPROG 3
;      78 #define DV	2
;      79 #endif
;      80 
;      81 #ifdef DV3KL2MD
;      82 
;      83 #define PP1	6
;      84 #define PP2	7
;      85 #define PP3	3
;      86 //#define PP4	4
;      87 //#define PP5	3
;      88 #define DV	2 
;      89 
;      90 #define MINPROG 2
;      91 #define MAXPROG 3
;      92 
;      93 #endif
;      94        
;      95 
;      96 #ifdef I380_WI_GAZ
;      97 
;      98 #define PP1	6
;      99 #define PP2	7
;     100 #define PP3	5
;     101 #define PP4	4
;     102 #define PP5	3
;     103 #define PP6	2
;     104 #define PP7	1
;     105 #define PP8	0
;     106 
;     107 #define DV	8 
;     108 
;     109 #define MINPROG 1
;     110 #define MAXPROG 4
;     111 
;     112 #endif
;     113 
;     114 bit b600Hz;
;     115 
;     116 bit b100Hz;
;     117 bit b10Hz;
;     118 char t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3;
;     119 char ind_cnt;
;     120 flash char IND_STROB[]={0b10111111,0b11011111,0b11101111,0b11110111,0b01111111};

	.CSEG
;     121 flash char DIGISYM[]={0b11000000,0b11111001,0b10100100,0b10110000,0b10011001,0b10010010,0b10000010,0b11111000,0b10000000,0b10010000,0b11111111};								
;     122 
;     123 char ind_out[5]={0x255,0x255,0x255,0x255,0x255};

	.DSEG
_ind_out:
	.BYTE 0x5
;     124 char dig[4];
_dig:
	.BYTE 0x4
;     125 bit bZ;    
;     126 char but;
;     127 static char but_n;
_but_n_G1:
	.BYTE 0x1
;     128 static char but_s;
_but_s_G1:
	.BYTE 0x1
;     129 static char but0_cnt;
_but0_cnt_G1:
	.BYTE 0x1
;     130 static char but1_cnt;
_but1_cnt_G1:
	.BYTE 0x1
;     131 static char but_onL_temp;
_but_onL_temp_G1:
	.BYTE 0x1
;     132 bit l_but;		//идет длинное нажатие на кнопку
;     133 bit n_but;          //произошло нажатие
;     134 bit speed;		//разрешение ускорения перебора 
;     135 bit bFL2; 
;     136 bit bFL5;
;     137 eeprom enum{evmON=0x55,evmOFF=0xaa}ee_vacuum_mode;

	.ESEG
_ee_vacuum_mode:
	.DB  0x0
;     138 eeprom char ee_program[2];
_ee_program:
	.DB  0x0
	.DB  0x0
;     139 enum {p1=1,p2=2,p3=3,p4=4}prog;
;     140 enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}step=sOFF;
;     141 enum {iMn,iPr_sel,iVr} ind;
;     142 char sub_ind;
;     143 char in_word,in_word_old,in_word_new,in_word_cnt;

	.DSEG
_in_word_old:
	.BYTE 0x1
_in_word_new:
	.BYTE 0x1
_in_word_cnt:
	.BYTE 0x1
;     144 bit bERR;
;     145 signed int cnt_del=0;
_cnt_del:
	.BYTE 0x2
;     146 
;     147 char bVR;
_bVR:
	.BYTE 0x1
;     148 char bMD1;
_bMD1:
	.BYTE 0x1
;     149 bit bMD2;
;     150 bit bMD3;
;     151 bit bVR2;
;     152 char cnt_md1,cnt_md2,cnt_vr,cnt_md3,cnt_vr2;
_cnt_md1:
	.BYTE 0x1
_cnt_md2:
	.BYTE 0x1
_cnt_vr:
	.BYTE 0x1
_cnt_md3:
	.BYTE 0x1
_cnt_vr2:
	.BYTE 0x1
;     153 
;     154 eeprom unsigned ee_delay[4,2];

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
;     155 eeprom char ee_vr_log;
_ee_vr_log:
	.DB  0x0
;     156 //#include <mega16.h>
;     157 //#include <mega8535.h>
;     158 #include <mega32.h>
;     159 //-----------------------------------------------
;     160 void prog_drv(void)
;     161 {

	.CSEG
_prog_drv:
;     162 char temp,temp1,temp2;
;     163 
;     164 temp=ee_program[0];
	CALL __SAVELOCR3
;	temp -> R16
;	temp1 -> R17
;	temp2 -> R18
	LDI  R26,LOW(_ee_program)
	LDI  R27,HIGH(_ee_program)
	CALL __EEPROMRDB
	MOV  R16,R30
;     165 temp1=ee_program[1];
	__POINTW2MN _ee_program,1
	CALL __EEPROMRDB
	MOV  R17,R30
;     166 temp2=ee_program[2];
	__POINTW2MN _ee_program,2
	CALL __EEPROMRDB
	MOV  R18,R30
;     167 
;     168 if((temp==temp1)&&(temp==temp2))
	CP   R17,R16
	BRNE _0x5
	CP   R18,R16
	BREQ _0x6
_0x5:
	RJMP _0x4
_0x6:
;     169 	{
;     170 	}
;     171 else if((temp==temp1)&&(temp!=temp2))
	RJMP _0x7
_0x4:
	CP   R17,R16
	BRNE _0x9
	CP   R18,R16
	BRNE _0xA
_0x9:
	RJMP _0x8
_0xA:
;     172 	{
;     173 	temp2=temp;
	MOV  R18,R16
;     174 	}
;     175 else if((temp!=temp1)&&(temp==temp2))
	RJMP _0xB
_0x8:
	CP   R17,R16
	BREQ _0xD
	CP   R18,R16
	BREQ _0xE
_0xD:
	RJMP _0xC
_0xE:
;     176 	{
;     177 	temp1=temp;
	MOV  R17,R16
;     178 	}
;     179 else if((temp!=temp1)&&(temp1==temp2))
	RJMP _0xF
_0xC:
	CP   R17,R16
	BREQ _0x11
	CP   R18,R17
	BREQ _0x12
_0x11:
	RJMP _0x10
_0x12:
;     180 	{
;     181 	temp=temp1;
	MOV  R16,R17
;     182 	}
;     183 else if((temp!=temp1)&&(temp!=temp2))
	RJMP _0x13
_0x10:
	CP   R17,R16
	BREQ _0x15
	CP   R18,R16
	BRNE _0x16
_0x15:
	RJMP _0x14
_0x16:
;     184 	{
;     185 	temp=MINPROG;
	LDI  R16,LOW(1)
;     186 	temp1=MINPROG;
	LDI  R17,LOW(1)
;     187 	temp2=MINPROG;
	LDI  R18,LOW(1)
;     188 	}
;     189 
;     190 if(!((temp<=MAXPROG)&&(temp>=MINPROG)))
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
;     191 	{
;     192 	temp=MINPROG;
	LDI  R16,LOW(1)
;     193 	}
;     194 
;     195 if(temp!=ee_program[0])ee_program[0]=temp;
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
;     196 if(temp!=ee_program[1])ee_program[1]=temp;
_0x1A:
	__POINTW2MN _ee_program,1
	CALL __EEPROMRDB
	CP   R30,R16
	BREQ _0x1B
	__POINTW2MN _ee_program,1
	MOV  R30,R16
	CALL __EEPROMWRB
;     197 if(temp!=ee_program[2])ee_program[2]=temp;
_0x1B:
	__POINTW2MN _ee_program,2
	CALL __EEPROMRDB
	CP   R30,R16
	BREQ _0x1C
	__POINTW2MN _ee_program,2
	MOV  R30,R16
	CALL __EEPROMWRB
;     198 
;     199 prog=temp;
_0x1C:
	MOV  R10,R16
;     200 }
	CALL __LOADLOCR3
	RJMP _0x12D
;     201 
;     202 //-----------------------------------------------
;     203 void in_drv(void)
;     204 {
_in_drv:
;     205 char i,temp;
;     206 unsigned int tempUI;
;     207 DDRA=0x00;
	CALL __SAVELOCR4
;	i -> R16
;	temp -> R17
;	tempUI -> R18,R19
	CALL SUBOPT_0x0
;     208 PORTA=0xff;
	OUT  0x1B,R30
;     209 in_word_new=PINA;
	IN   R30,0x19
	STS  _in_word_new,R30
;     210 if(in_word_old==in_word_new)
	LDS  R26,_in_word_old
	CP   R30,R26
	BRNE _0x1D
;     211 	{
;     212 	if(in_word_cnt<10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRSH _0x1E
;     213 		{
;     214 		in_word_cnt++;
	LDS  R30,_in_word_cnt
	SUBI R30,-LOW(1)
	STS  _in_word_cnt,R30
;     215 		if(in_word_cnt>=10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRLO _0x1F
;     216 			{
;     217 			in_word=in_word_old;
	LDS  R14,_in_word_old
;     218 			}
;     219 		}
_0x1F:
;     220 	}
_0x1E:
;     221 else in_word_cnt=0;
	RJMP _0x20
_0x1D:
	LDI  R30,LOW(0)
	STS  _in_word_cnt,R30
_0x20:
;     222 
;     223 
;     224 in_word_old=in_word_new;
	LDS  R30,_in_word_new
	STS  _in_word_old,R30
;     225 }   
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;     226 
;     227 #ifdef TVIST_SKO
;     228 //-----------------------------------------------
;     229 void err_drv(void)
;     230 {
;     231 if(step==sOFF)
;     232 	{
;     233     	if(prog==p2)	
;     234     		{
;     235        		if(bMD1) bERR=1;
;     236        		else bERR=0;
;     237 		}
;     238 	}
;     239 else bERR=0;
;     240 }
;     241 #else  
;     242 #ifdef I380_WI_GAZ
;     243 //-----------------------------------------------
;     244 void err_drv(void)
;     245 {
_err_drv:
;     246 if(step==sOFF)
	TST  R11
	BRNE _0x21
;     247 	{
;     248 	if((bMD1)||(bMD2)||(bVR)||(bMD3)||(bVR2)) bERR=1;
	LDS  R30,_bMD1
	CPI  R30,0
	BRNE _0x23
	SBRC R3,2
	RJMP _0x23
	LDS  R30,_bVR
	CPI  R30,0
	BRNE _0x23
	SBRC R3,3
	RJMP _0x23
	SBRS R3,4
	RJMP _0x22
_0x23:
	SET
	BLD  R3,1
;     249 	else bERR=0;
	RJMP _0x25
_0x22:
	CLT
	BLD  R3,1
_0x25:
;     250 	}
;     251 else bERR=0;
	RJMP _0x26
_0x21:
	CLT
	BLD  R3,1
_0x26:
;     252 }
	RET
;     253 #else 
;     254 
;     255 //-----------------------------------------------
;     256 void err_drv(void)
;     257 {
;     258 if(step==sOFF)
;     259 	{
;     260 	if((bMD1)||(bMD2)||(bVR)||(bMD3)) bERR=1;
;     261 	else bERR=0;
;     262 	}
;     263 else bERR=0;
;     264 }
;     265 #endif
;     266 #endif
;     267 
;     268 //-----------------------------------------------
;     269 void mdvr_drv(void)
;     270 {
_mdvr_drv:
;     271 if(!(in_word&(1<<MD1)))
	SBRC R14,2
	RJMP _0x27
;     272 	{
;     273 	if(cnt_md1<10)
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRSH _0x28
;     274 		{
;     275 		cnt_md1++;
	LDS  R30,_cnt_md1
	SUBI R30,-LOW(1)
	STS  _cnt_md1,R30
;     276 		if(cnt_md1==10) bMD1=1;
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRNE _0x29
	LDI  R30,LOW(1)
	STS  _bMD1,R30
;     277 		}
_0x29:
;     278 
;     279 	}
_0x28:
;     280 else
	RJMP _0x2A
_0x27:
;     281 	{
;     282 	if(cnt_md1)
	LDS  R30,_cnt_md1
	CPI  R30,0
	BREQ _0x2B
;     283 		{
;     284 		cnt_md1--;
	SUBI R30,LOW(1)
	STS  _cnt_md1,R30
;     285 		if(cnt_md1==0) bMD1=0;
	CPI  R30,0
	BRNE _0x2C
	LDI  R30,LOW(0)
	STS  _bMD1,R30
;     286 		}
_0x2C:
;     287 
;     288 	}
_0x2B:
_0x2A:
;     289 
;     290 if(!(in_word&(1<<MD2)))
	SBRC R14,3
	RJMP _0x2D
;     291 	{
;     292 	if(cnt_md2<10)
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRSH _0x2E
;     293 		{
;     294 		cnt_md2++;
	LDS  R30,_cnt_md2
	SUBI R30,-LOW(1)
	STS  _cnt_md2,R30
;     295 		if(cnt_md2==10) bMD2=1;
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRNE _0x2F
	SET
	BLD  R3,2
;     296 		}
_0x2F:
;     297 
;     298 	}
_0x2E:
;     299 else
	RJMP _0x30
_0x2D:
;     300 	{
;     301 	if(cnt_md2)
	LDS  R30,_cnt_md2
	CPI  R30,0
	BREQ _0x31
;     302 		{
;     303 		cnt_md2--;
	SUBI R30,LOW(1)
	STS  _cnt_md2,R30
;     304 		if(cnt_md2==0) bMD2=0;
	CPI  R30,0
	BRNE _0x32
	CLT
	BLD  R3,2
;     305 		}
_0x32:
;     306 
;     307 	}
_0x31:
_0x30:
;     308 
;     309 if(!(in_word&(1<<MD3)))
	SBRC R14,5
	RJMP _0x33
;     310 	{
;     311 	if(cnt_md3<10)
	LDS  R26,_cnt_md3
	CPI  R26,LOW(0xA)
	BRSH _0x34
;     312 		{
;     313 		cnt_md3++;
	LDS  R30,_cnt_md3
	SUBI R30,-LOW(1)
	STS  _cnt_md3,R30
;     314 		if(cnt_md3==10) bMD3=1;
	LDS  R26,_cnt_md3
	CPI  R26,LOW(0xA)
	BRNE _0x35
	SET
	BLD  R3,3
;     315 		}
_0x35:
;     316 
;     317 	}
_0x34:
;     318 else
	RJMP _0x36
_0x33:
;     319 	{
;     320 	if(cnt_md3)
	LDS  R30,_cnt_md3
	CPI  R30,0
	BREQ _0x37
;     321 		{
;     322 		cnt_md3--;
	SUBI R30,LOW(1)
	STS  _cnt_md3,R30
;     323 		if(cnt_md3==0) bMD3=0;
	CPI  R30,0
	BRNE _0x38
	CLT
	BLD  R3,3
;     324 		}
_0x38:
;     325 
;     326 	}
_0x37:
_0x36:
;     327 
;     328 if(((!(in_word&(1<<VR)))/*&&(ee_vr_log)*/) /*|| (((in_word&(1<<VR)))&&(!ee_vr_log))*/)
	SBRC R14,4
	RJMP _0x39
;     329 	{
;     330 	if(cnt_vr<10)
	LDS  R26,_cnt_vr
	CPI  R26,LOW(0xA)
	BRSH _0x3A
;     331 		{
;     332 		cnt_vr++;
	LDS  R30,_cnt_vr
	SUBI R30,-LOW(1)
	STS  _cnt_vr,R30
;     333 		if(cnt_vr==10) bVR=1;
	LDS  R26,_cnt_vr
	CPI  R26,LOW(0xA)
	BRNE _0x3B
	LDI  R30,LOW(1)
	STS  _bVR,R30
;     334 		}
_0x3B:
;     335 
;     336 	}
_0x3A:
;     337 else
	RJMP _0x3C
_0x39:
;     338 	{
;     339 	if(cnt_vr)
	LDS  R30,_cnt_vr
	CPI  R30,0
	BREQ _0x3D
;     340 		{
;     341 		cnt_vr--;
	SUBI R30,LOW(1)
	STS  _cnt_vr,R30
;     342 		if(cnt_vr==0) bVR=0;
	CPI  R30,0
	BRNE _0x3E
	LDI  R30,LOW(0)
	STS  _bVR,R30
;     343 		}
_0x3E:
;     344 
;     345 	}
_0x3D:
_0x3C:
;     346 	
;     347 if(((!(in_word&(1<<VR2)))/*&&(ee_vr_log)*/) /*|| (((in_word&(1<<VR2)))&&(!ee_vr_log))*/)
	SBRC R14,7
	RJMP _0x3F
;     348 	{
;     349 	if(cnt_vr2<10)
	LDS  R26,_cnt_vr2
	CPI  R26,LOW(0xA)
	BRSH _0x40
;     350 		{
;     351 		cnt_vr2++;
	LDS  R30,_cnt_vr2
	SUBI R30,-LOW(1)
	STS  _cnt_vr2,R30
;     352 		if(cnt_vr2==10) bVR2=1;
	LDS  R26,_cnt_vr2
	CPI  R26,LOW(0xA)
	BRNE _0x41
	SET
	BLD  R3,4
;     353 		}
_0x41:
;     354 
;     355 	}
_0x40:
;     356 else
	RJMP _0x42
_0x3F:
;     357 	{
;     358 	if(cnt_vr2)
	LDS  R30,_cnt_vr2
	CPI  R30,0
	BREQ _0x43
;     359 		{
;     360 		cnt_vr2--;
	SUBI R30,LOW(1)
	STS  _cnt_vr2,R30
;     361 		if(cnt_vr2==0) bVR2=0;
	CPI  R30,0
	BRNE _0x44
	CLT
	BLD  R3,4
;     362 		}
_0x44:
;     363 
;     364 	}	
_0x43:
_0x42:
;     365 } 
	RET
;     366 
;     367 #ifdef DV3KL2MD
;     368 //-----------------------------------------------
;     369 void step_contr(void)
;     370 {
;     371 char temp=0;
;     372 DDRB=0xFF;
;     373 
;     374 if(step==sOFF)
;     375 	{
;     376 	temp=0;
;     377 	}
;     378 
;     379 else if(step==s1)
;     380 	{
;     381 	temp|=(1<<PP1);
;     382 
;     383 	cnt_del--;
;     384 	if(cnt_del==0)
;     385 		{
;     386 		step=s2;
;     387 		cnt_del=20;
;     388 		}
;     389 	}
;     390 
;     391 
;     392 else if(step==s2)
;     393 	{
;     394 	temp|=(1<<PP1)|(1<<DV);
;     395 
;     396 	cnt_del--;
;     397 	if(cnt_del==0)
;     398 		{
;     399 		step=s3;
;     400 		}
;     401 	}
;     402 	
;     403 else if(step==s3)
;     404 	{
;     405 	temp|=(1<<PP1)|(1<<PP2)|(1<<DV);
;     406      if(!bMD1)goto step_contr_end;
;     407      step=s4;
;     408      }     
;     409 else if(step==s4)
;     410 	{          
;     411      temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     412      if(!bMD2)goto step_contr_end;
;     413      step=s5;
;     414      cnt_del=50;
;     415      } 
;     416 else if(step==s5)
;     417 	{
;     418 	temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     419 
;     420 	cnt_del--;
;     421 	if(cnt_del==0)
;     422 		{
;     423 		step=s6;
;     424 		cnt_del=50;
;     425 		}
;     426 	}         
;     427 /*else if(step==s6)
;     428 	{
;     429 	temp|=(1<<PP1)|(1<<DV);
;     430 
;     431 	cnt_del--;
;     432 	if(cnt_del==0)
;     433 		{
;     434 		step=s6;
;     435 		cnt_del=70;
;     436 		}
;     437 	}*/     
;     438 else if(step==s6)
;     439 		{
;     440 	temp|=(1<<PP1);
;     441 	cnt_del--;
;     442 	if(cnt_del==0)
;     443 		{
;     444 		step=sOFF;
;     445           }     
;     446      }     
;     447 
;     448 step_contr_end:
;     449 
;     450 PORTB=~temp;
;     451 }
;     452 #endif
;     453 
;     454 #ifdef P380_MINI
;     455 //-----------------------------------------------
;     456 void step_contr(void)
;     457 {
;     458 char temp=0;
;     459 DDRB=0xFF;
;     460 
;     461 if(step==sOFF)
;     462 	{
;     463 	temp=0;
;     464 	}
;     465 
;     466 else if(step==s1)
;     467 	{
;     468 	temp|=(1<<PP1);
;     469 
;     470 	cnt_del--;
;     471 	if(cnt_del==0)
;     472 		{
;     473 		step=s2;
;     474 		}
;     475 	}
;     476 
;     477 else if(step==s2)
;     478 	{
;     479 	temp|=(1<<PP1)|(1<<PP2)|(1<<DV);
;     480      if(!bMD1)goto step_contr_end;
;     481      step=s3;
;     482      }     
;     483 else if(step==s3)
;     484 	{          
;     485      temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     486      if(!bMD2)goto step_contr_end;
;     487      step=s4;
;     488      cnt_del=50;
;     489      }
;     490 else if(step==s4)
;     491 		{
;     492 	temp|=(1<<PP1);
;     493 	cnt_del--;
;     494 	if(cnt_del==0)
;     495 		{
;     496 		step=sOFF;
;     497           }     
;     498      }     
;     499 
;     500 step_contr_end:
;     501 
;     502 PORTB=~temp;
;     503 }
;     504 #endif
;     505 
;     506 #ifdef P380
;     507 //-----------------------------------------------
;     508 void step_contr(void)
;     509 {
;     510 char temp=0;
;     511 DDRB=0xFF;
;     512 
;     513 if(step==sOFF)
;     514 	{
;     515 	temp=0;
;     516 	}
;     517 
;     518 else if(prog==p1)
;     519 	{
;     520 	if(step==s1)
;     521 		{
;     522 		temp|=(1<<PP1)|(1<<PP2);
;     523 
;     524 		cnt_del--;
;     525 		if(cnt_del==0)
;     526 			{
;     527 			if(ee_vacuum_mode==evmOFF)
;     528 				{
;     529 				goto lbl_0001;
;     530 				}
;     531 			else step=s2;
;     532 			}
;     533 		}
;     534 
;     535 	else if(step==s2)
;     536 		{
;     537 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     538 
;     539           if(!bVR)goto step_contr_end;
;     540 lbl_0001:
;     541 #ifndef BIG_CAM
;     542 		cnt_del=30;
;     543 #endif
;     544 
;     545 #ifdef BIG_CAM
;     546 		cnt_del=100;
;     547 #endif
;     548 		step=s3;
;     549 		}
;     550 
;     551 	else if(step==s3)
;     552 		{
;     553 		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     554 		cnt_del--;
;     555 		if(cnt_del==0)
;     556 			{
;     557 			step=s4;
;     558 			}
;     559           }
;     560 	else if(step==s4)
;     561 		{
;     562 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     563 
;     564           if(!bMD1)goto step_contr_end;
;     565 
;     566 		cnt_del=40;
;     567 		step=s5;
;     568 		}
;     569 	else if(step==s5)
;     570 		{
;     571 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     572 
;     573 		cnt_del--;
;     574 		if(cnt_del==0)
;     575 			{
;     576 			step=s6;
;     577 			}
;     578 		}
;     579 	else if(step==s6)
;     580 		{
;     581 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     582 
;     583          	if(!bMD2)goto step_contr_end;
;     584           cnt_del=40;
;     585 		//step=s7;
;     586 		
;     587           step=s55;
;     588           cnt_del=40;
;     589 		}
;     590 	else if(step==s55)
;     591 		{
;     592 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     593           cnt_del--;
;     594           if(cnt_del==0)
;     595 			{
;     596           	step=s7;
;     597           	cnt_del=20;
;     598 			}
;     599          		
;     600 		}
;     601 	else if(step==s7)
;     602 		{
;     603 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     604 
;     605 		cnt_del--;
;     606 		if(cnt_del==0)
;     607 			{
;     608 			step=s8;
;     609 			cnt_del=30;
;     610 			}
;     611 		}
;     612 	else if(step==s8)
;     613 		{
;     614 		temp|=(1<<PP1)|(1<<PP3);
;     615 
;     616 		cnt_del--;
;     617 		if(cnt_del==0)
;     618 			{
;     619 			step=s9;
;     620 #ifndef BIG_CAM
;     621 		cnt_del=150;
;     622 #endif
;     623 
;     624 #ifdef BIG_CAM
;     625 		cnt_del=200;
;     626 #endif
;     627 			}
;     628 		}
;     629 	else if(step==s9)
;     630 		{
;     631 		temp|=(1<<PP1)|(1<<PP2);
;     632 
;     633 		cnt_del--;
;     634 		if(cnt_del==0)
;     635 			{
;     636 			step=s10;
;     637 			cnt_del=30;
;     638 			}
;     639 		}
;     640 	else if(step==s10)
;     641 		{
;     642 		temp|=(1<<PP2);
;     643 		cnt_del--;
;     644 		if(cnt_del==0)
;     645 			{
;     646 			step=sOFF;
;     647 			}
;     648 		}
;     649 	}
;     650 
;     651 if(prog==p2)
;     652 	{
;     653 
;     654 	if(step==s1)
;     655 		{
;     656 		temp|=(1<<PP1)|(1<<PP2);
;     657 
;     658 		cnt_del--;
;     659 		if(cnt_del==0)
;     660 			{
;     661 			if(ee_vacuum_mode==evmOFF)
;     662 				{
;     663 				goto lbl_0002;
;     664 				}
;     665 			else step=s2;
;     666 			}
;     667 		}
;     668 
;     669 	else if(step==s2)
;     670 		{
;     671 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     672 
;     673           if(!bVR)goto step_contr_end;
;     674 lbl_0002:
;     675 #ifndef BIG_CAM
;     676 		cnt_del=30;
;     677 #endif
;     678 
;     679 #ifdef BIG_CAM
;     680 		cnt_del=100;
;     681 #endif
;     682 		step=s3;
;     683 		}
;     684 
;     685 	else if(step==s3)
;     686 		{
;     687 		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     688 
;     689 		cnt_del--;
;     690 		if(cnt_del==0)
;     691 			{
;     692 			step=s4;
;     693 			}
;     694 		}
;     695 
;     696 	else if(step==s4)
;     697 		{
;     698 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     699 
;     700           if(!bMD1)goto step_contr_end;
;     701          	cnt_del=30;
;     702 		step=s5;
;     703 		}
;     704 
;     705 	else if(step==s5)
;     706 		{
;     707 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     708 
;     709 		cnt_del--;
;     710 		if(cnt_del==0)
;     711 			{
;     712 			step=s6;
;     713 			cnt_del=30;
;     714 			}
;     715 		}
;     716 
;     717 	else if(step==s6)
;     718 		{
;     719 		temp|=(1<<PP1)|(1<<PP3);
;     720 
;     721 		cnt_del--;
;     722 		if(cnt_del==0)
;     723 			{
;     724 			step=s7;
;     725 #ifndef BIG_CAM
;     726 		cnt_del=150;
;     727 #endif
;     728 
;     729 #ifdef BIG_CAM
;     730 		cnt_del=200;
;     731 #endif
;     732 			}
;     733 		}
;     734 
;     735 	else if(step==s7)
;     736 		{
;     737 		temp|=(1<<PP1)|(1<<PP2);
;     738 
;     739 		cnt_del--;
;     740 		if(cnt_del==0)
;     741 			{
;     742 			step=s8;
;     743 			cnt_del=30;
;     744 			}
;     745 		}
;     746 	else if(step==s8)
;     747 		{
;     748 		temp|=(1<<PP2);
;     749 
;     750 		cnt_del--;
;     751 		if(cnt_del==0)
;     752 			{
;     753 			step=sOFF;
;     754 			}
;     755 		}
;     756 	}
;     757 
;     758 if(prog==p3)
;     759 	{
;     760 
;     761 	if(step==s1)
;     762 		{
;     763 		temp|=(1<<PP1)|(1<<PP2);
;     764 
;     765 		cnt_del--;
;     766 		if(cnt_del==0)
;     767 			{
;     768 			if(ee_vacuum_mode==evmOFF)
;     769 				{
;     770 				goto lbl_0003;
;     771 				}
;     772 			else step=s2;
;     773 			}
;     774 		}
;     775 
;     776 	else if(step==s2)
;     777 		{
;     778 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     779 
;     780           if(!bVR)goto step_contr_end;
;     781 lbl_0003:
;     782 #ifndef BIG_CAM
;     783 		cnt_del=80;
;     784 #endif
;     785 
;     786 #ifdef BIG_CAM
;     787 		cnt_del=100;
;     788 #endif
;     789 		step=s3;
;     790 		}
;     791 
;     792 	else if(step==s3)
;     793 		{
;     794 		temp|=(1<<PP1)|(1<<PP3);
;     795 
;     796 		cnt_del--;
;     797 		if(cnt_del==0)
;     798 			{
;     799 			step=s4;
;     800 			cnt_del=120;
;     801 			}
;     802 		}
;     803 
;     804 	else if(step==s4)
;     805 		{
;     806 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<PP5);
;     807 
;     808 		cnt_del--;
;     809 		if(cnt_del==0)
;     810 			{
;     811 			step=s5;
;     812 
;     813 		
;     814 #ifndef BIG_CAM
;     815 		cnt_del=150;
;     816 #endif
;     817 
;     818 #ifdef BIG_CAM
;     819 		cnt_del=200;
;     820 #endif
;     821 	//	step=s5;
;     822 	}
;     823 		}
;     824 
;     825 	else if(step==s5)
;     826 		{
;     827 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<PP5);
;     828 
;     829 		cnt_del--;
;     830 		if(cnt_del==0)
;     831 			{
;     832 			step=s6;
;     833 			cnt_del=30;
;     834 			}
;     835 		}
;     836 
;     837 	else if(step==s6)
;     838 		{
;     839 		temp|=(1<<PP2)|(1<<PP4)|(1<<PP5);
;     840 
;     841 		cnt_del--;
;     842 		if(cnt_del==0)
;     843 			{
;     844 			step=s7;
;     845 			cnt_del=30;
;     846 			}
;     847 		}
;     848 
;     849 	else if(step==s7)
;     850 		{
;     851 		temp|=(1<<PP2);
;     852 
;     853 		cnt_del--;
;     854 		if(cnt_del==0)
;     855 			{
;     856 			step=sOFF;
;     857 			}
;     858 		}
;     859 
;     860 	}
;     861 step_contr_end:
;     862 
;     863 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;     864 
;     865 PORTB=~temp;
;     866 }
;     867 #endif
;     868 #ifdef I380
;     869 //-----------------------------------------------
;     870 void step_contr(void)
;     871 {
;     872 char temp=0;
;     873 DDRB=0xFF;
;     874 
;     875 if(step==sOFF)goto step_contr_end;
;     876 
;     877 else if(prog==p1)
;     878 	{
;     879 	if(step==s1)    //жесть
;     880 		{
;     881 		temp|=(1<<PP1);
;     882           if(!bMD1)goto step_contr_end;
;     883 
;     884 			if(ee_vacuum_mode==evmOFF)
;     885 				{
;     886 				goto lbl_0001;
;     887 				}
;     888 			else step=s2;
;     889 		}
;     890 
;     891 	else if(step==s2)
;     892 		{
;     893 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     894           if(!bVR)goto step_contr_end;
;     895 lbl_0001:
;     896 
;     897           step=s100;
;     898 		cnt_del=40;
;     899           }
;     900 	else if(step==s100)
;     901 		{
;     902 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;     903           cnt_del--;
;     904           if(cnt_del==0)
;     905 			{
;     906           	step=s3;
;     907           	cnt_del=50;
;     908 			}
;     909 		}
;     910 
;     911 	else if(step==s3)
;     912 		{
;     913 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     914           cnt_del--;
;     915           if(cnt_del==0)
;     916 			{
;     917           	step=s4;
;     918 			}
;     919 		}
;     920 	else if(step==s4)
;     921 		{
;     922 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;     923           if(!bMD2)goto step_contr_end;
;     924           step=s5;
;     925           cnt_del=20;
;     926 		}
;     927 	else if(step==s5)
;     928 		{
;     929 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     930           cnt_del--;
;     931           if(cnt_del==0)
;     932 			{
;     933           	step=s6;
;     934 			}
;     935           }
;     936 	else if(step==s6)
;     937 		{
;     938 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
;     939           if(!bMD3)goto step_contr_end;
;     940           step=s7;
;     941           cnt_del=20;
;     942 		}
;     943 
;     944 	else if(step==s7)
;     945 		{
;     946 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     947           cnt_del--;
;     948           if(cnt_del==0)
;     949 			{
;     950           	step=s8;
;     951           	cnt_del=ee_delay[prog,0]*10U;;
;     952 			}
;     953           }
;     954 	else if(step==s8)
;     955 		{
;     956 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;     957           cnt_del--;
;     958           if(cnt_del==0)
;     959 			{
;     960           	step=s9;
;     961           	cnt_del=20;
;     962 			}
;     963           }
;     964 	else if(step==s9)
;     965 		{
;     966 		temp|=(1<<PP1);
;     967           cnt_del--;
;     968           if(cnt_del==0)
;     969 			{
;     970           	step=sOFF;
;     971           	}
;     972           }
;     973 	}
;     974 
;     975 else if(prog==p2)  //ско
;     976 	{
;     977 	if(step==s1)
;     978 		{
;     979 		temp|=(1<<PP1);
;     980           if(!bMD1)goto step_contr_end;
;     981 
;     982 			if(ee_vacuum_mode==evmOFF)
;     983 				{
;     984 				goto lbl_0002;
;     985 				}
;     986 			else step=s2;
;     987 
;     988           //step=s2;
;     989 		}
;     990 
;     991 	else if(step==s2)
;     992 		{
;     993 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     994           if(!bVR)goto step_contr_end;
;     995 
;     996 lbl_0002:
;     997           step=s100;
;     998 		cnt_del=40;
;     999           }
;    1000 	else if(step==s100)
;    1001 		{
;    1002 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1003           cnt_del--;
;    1004           if(cnt_del==0)
;    1005 			{
;    1006           	step=s3;
;    1007           	cnt_del=50;
;    1008 			}
;    1009 		}
;    1010 	else if(step==s3)
;    1011 		{
;    1012 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1013           cnt_del--;
;    1014           if(cnt_del==0)
;    1015 			{
;    1016           	step=s4;
;    1017 			}
;    1018 		}
;    1019 	else if(step==s4)
;    1020 		{
;    1021 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;    1022           if(!bMD2)goto step_contr_end;
;    1023           step=s5;
;    1024           cnt_del=20;
;    1025 		}
;    1026 	else if(step==s5)
;    1027 		{
;    1028 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1029           cnt_del--;
;    1030           if(cnt_del==0)
;    1031 			{
;    1032           	step=s6;
;    1033           	cnt_del=ee_delay[prog,0]*10U;
;    1034 			}
;    1035           }
;    1036 	else if(step==s6)
;    1037 		{
;    1038 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1039           cnt_del--;
;    1040           if(cnt_del==0)
;    1041 			{
;    1042           	step=s7;
;    1043           	cnt_del=20;
;    1044 			}
;    1045           }
;    1046 	else if(step==s7)
;    1047 		{
;    1048 		temp|=(1<<PP1);
;    1049           cnt_del--;
;    1050           if(cnt_del==0)
;    1051 			{
;    1052           	step=sOFF;
;    1053           	}
;    1054           }
;    1055 	}
;    1056 
;    1057 else if(prog==p3)   //твист
;    1058 	{
;    1059 	if(step==s1)
;    1060 		{
;    1061 		temp|=(1<<PP1);
;    1062           if(!bMD1)goto step_contr_end;
;    1063 
;    1064 			if(ee_vacuum_mode==evmOFF)
;    1065 				{
;    1066 				goto lbl_0003;
;    1067 				}
;    1068 			else step=s2;
;    1069 
;    1070           //step=s2;
;    1071 		}
;    1072 
;    1073 	else if(step==s2)
;    1074 		{
;    1075 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1076           if(!bVR)goto step_contr_end;
;    1077 lbl_0003:
;    1078           cnt_del=50;
;    1079 		step=s3;
;    1080 		}
;    1081 
;    1082 
;    1083 	else	if(step==s3)
;    1084 		{
;    1085 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1086 		cnt_del--;
;    1087 		if(cnt_del==0)
;    1088 			{
;    1089 			cnt_del=ee_delay[prog,0]*10U;
;    1090 			step=s4;
;    1091 			}
;    1092           }
;    1093 	else if(step==s4)
;    1094 		{
;    1095 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1096 		cnt_del--;
;    1097  		if(cnt_del==0)
;    1098 			{
;    1099 			cnt_del=ee_delay[prog,1]*10U;
;    1100 			step=s5;
;    1101 			}
;    1102 		}
;    1103 
;    1104 	else if(step==s5)
;    1105 		{
;    1106 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1107 		cnt_del--;
;    1108 		if(cnt_del==0)
;    1109 			{
;    1110 			step=s6;
;    1111 			cnt_del=20;
;    1112 			}
;    1113 		}
;    1114 
;    1115 	else if(step==s6)
;    1116 		{
;    1117 		temp|=(1<<PP1);
;    1118   		cnt_del--;
;    1119 		if(cnt_del==0)
;    1120 			{
;    1121 			step=sOFF;
;    1122 			}
;    1123 		}
;    1124 
;    1125 	}
;    1126 
;    1127 else if(prog==p4)      //замок
;    1128 	{
;    1129 	if(step==s1)
;    1130 		{
;    1131 		temp|=(1<<PP1);
;    1132           if(!bMD1)goto step_contr_end;
;    1133 
;    1134 			if(ee_vacuum_mode==evmOFF)
;    1135 				{
;    1136 				goto lbl_0004;
;    1137 				}
;    1138 			else step=s2;
;    1139           //step=s2;
;    1140 		}
;    1141 
;    1142 	else if(step==s2)
;    1143 		{
;    1144 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1145           if(!bVR)goto step_contr_end;
;    1146 lbl_0004:
;    1147           step=s3;
;    1148 		cnt_del=50;
;    1149           }
;    1150 
;    1151 	else if(step==s3)
;    1152 		{
;    1153 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1154           cnt_del--;
;    1155           if(cnt_del==0)
;    1156 			{
;    1157           	step=s4;
;    1158 			cnt_del=ee_delay[prog,0]*10U;
;    1159 			}
;    1160           }
;    1161 
;    1162    	else if(step==s4)
;    1163 		{
;    1164 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1165 		cnt_del--;
;    1166 		if(cnt_del==0)
;    1167 			{
;    1168 			step=s5;
;    1169 			cnt_del=30;
;    1170 			}
;    1171 		}
;    1172 
;    1173 	else if(step==s5)
;    1174 		{
;    1175 		temp|=(1<<PP1)|(1<<PP4);
;    1176 		cnt_del--;
;    1177 		if(cnt_del==0)
;    1178 			{
;    1179 			step=s6;
;    1180 			cnt_del=ee_delay[prog,1]*10U;
;    1181 			}
;    1182 		}
;    1183 
;    1184 	else if(step==s6)
;    1185 		{
;    1186 		temp|=(1<<PP4);
;    1187 		cnt_del--;
;    1188 		if(cnt_del==0)
;    1189 			{
;    1190 			step=sOFF;
;    1191 			}
;    1192 		}
;    1193 
;    1194 	}
;    1195 	
;    1196 step_contr_end:
;    1197 
;    1198 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1199 
;    1200 PORTB=~temp;
;    1201 //PORTB=0x55;
;    1202 }
;    1203 #endif
;    1204 
;    1205 #ifdef I220_WI
;    1206 //-----------------------------------------------
;    1207 void step_contr(void)
;    1208 {
;    1209 char temp=0;
;    1210 DDRB=0xFF;
;    1211 
;    1212 if(step==sOFF)goto step_contr_end;
;    1213 
;    1214 else if(prog==p3)   //твист
;    1215 	{
;    1216 	if(step==s1)
;    1217 		{
;    1218 		temp|=(1<<PP1);
;    1219           if(!bMD1)goto step_contr_end;
;    1220 
;    1221 			if(ee_vacuum_mode==evmOFF)
;    1222 				{
;    1223 				goto lbl_0003;
;    1224 				}
;    1225 			else step=s2;
;    1226 
;    1227           //step=s2;
;    1228 		}
;    1229 
;    1230 	else if(step==s2)
;    1231 		{
;    1232 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1233           if(!bVR)goto step_contr_end;
;    1234 lbl_0003:
;    1235           cnt_del=50;
;    1236 		step=s3;
;    1237 		}
;    1238 
;    1239 
;    1240 	else	if(step==s3)
;    1241 		{
;    1242 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1243 		cnt_del--;
;    1244 		if(cnt_del==0)
;    1245 			{
;    1246 			cnt_del=90;
;    1247 			step=s4;
;    1248 			}
;    1249           }
;    1250 	else if(step==s4)
;    1251 		{
;    1252 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1253 		cnt_del--;
;    1254  		if(cnt_del==0)
;    1255 			{
;    1256 			cnt_del=130;
;    1257 			step=s5;
;    1258 			}
;    1259 		}
;    1260 
;    1261 	else if(step==s5)
;    1262 		{
;    1263 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1264 		cnt_del--;
;    1265 		if(cnt_del==0)
;    1266 			{
;    1267 			step=s6;
;    1268 			cnt_del=20;
;    1269 			}
;    1270 		}
;    1271 
;    1272 	else if(step==s6)
;    1273 		{
;    1274 		temp|=(1<<PP1);
;    1275   		cnt_del--;
;    1276 		if(cnt_del==0)
;    1277 			{
;    1278 			step=sOFF;
;    1279 			}
;    1280 		}
;    1281 
;    1282 	}
;    1283 
;    1284 else if(prog==p4)      //замок
;    1285 	{
;    1286 	if(step==s1)
;    1287 		{
;    1288 		temp|=(1<<PP1);
;    1289           if(!bMD1)goto step_contr_end;
;    1290 
;    1291 			if(ee_vacuum_mode==evmOFF)
;    1292 				{
;    1293 				goto lbl_0004;
;    1294 				}
;    1295 			else step=s2;
;    1296           //step=s2;
;    1297 		}
;    1298 
;    1299 	else if(step==s2)
;    1300 		{
;    1301 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1302           if(!bVR)goto step_contr_end;
;    1303 lbl_0004:
;    1304           step=s3;
;    1305 		cnt_del=50;
;    1306           }
;    1307 
;    1308 	else if(step==s3)
;    1309 		{
;    1310 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1311           cnt_del--;
;    1312           if(cnt_del==0)
;    1313 			{
;    1314           	step=s4;
;    1315 			cnt_del=120;
;    1316 			}
;    1317           }
;    1318 
;    1319    	else if(step==s4)
;    1320 		{
;    1321 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1322 		cnt_del--;
;    1323 		if(cnt_del==0)
;    1324 			{
;    1325 			step=s5;
;    1326 			cnt_del=30;
;    1327 			}
;    1328 		}
;    1329 
;    1330 	else if(step==s5)
;    1331 		{
;    1332 		temp|=(1<<PP1)|(1<<PP4);
;    1333 		cnt_del--;
;    1334 		if(cnt_del==0)
;    1335 			{
;    1336 			step=s6;
;    1337 			cnt_del=120;
;    1338 			}
;    1339 		}
;    1340 
;    1341 	else if(step==s6)
;    1342 		{
;    1343 		temp|=(1<<PP4);
;    1344 		cnt_del--;
;    1345 		if(cnt_del==0)
;    1346 			{
;    1347 			step=sOFF;
;    1348 			}
;    1349 		}
;    1350 
;    1351 	}
;    1352 	
;    1353 step_contr_end:
;    1354 
;    1355 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1356 
;    1357 PORTB=~temp;
;    1358 //PORTB=0x55;
;    1359 }
;    1360 #endif 
;    1361 
;    1362 #ifdef I380_WI
;    1363 //-----------------------------------------------
;    1364 void step_contr(void)
;    1365 {
;    1366 char temp=0;
;    1367 DDRB=0xFF;
;    1368 
;    1369 if(step==sOFF)goto step_contr_end;
;    1370 
;    1371 else if(prog==p1)
;    1372 	{
;    1373 	if(step==s1)    //жесть
;    1374 		{
;    1375 		temp|=(1<<PP1);
;    1376           if(!bMD1)goto step_contr_end;
;    1377 
;    1378 			if(ee_vacuum_mode==evmOFF)
;    1379 				{
;    1380 				goto lbl_0001;
;    1381 				}
;    1382 			else step=s2;
;    1383 		}
;    1384 
;    1385 	else if(step==s2)
;    1386 		{
;    1387 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1388           if(!bVR)goto step_contr_end;
;    1389 lbl_0001:
;    1390 
;    1391           step=s100;
;    1392 		cnt_del=40;
;    1393           }
;    1394 	else if(step==s100)
;    1395 		{
;    1396 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1397           cnt_del--;
;    1398           if(cnt_del==0)
;    1399 			{
;    1400           	step=s3;
;    1401           	cnt_del=50;
;    1402 			}
;    1403 		}
;    1404 
;    1405 	else if(step==s3)
;    1406 		{
;    1407 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1408           cnt_del--;
;    1409           if(cnt_del==0)
;    1410 			{
;    1411           	step=s4;
;    1412 			}
;    1413 		}
;    1414 	else if(step==s4)
;    1415 		{
;    1416 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;    1417           if(!bMD2)goto step_contr_end;
;    1418           step=s54;
;    1419           cnt_del=20;
;    1420 		}
;    1421 	else if(step==s54)
;    1422 		{
;    1423 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;    1424           cnt_del--;
;    1425           if(cnt_del==0)
;    1426 			{
;    1427           	step=s5;
;    1428           	cnt_del=20;
;    1429 			}
;    1430           }
;    1431 
;    1432 	else if(step==s5)
;    1433 		{
;    1434 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1435           cnt_del--;
;    1436           if(cnt_del==0)
;    1437 			{
;    1438           	step=s6;
;    1439 			}
;    1440           }
;    1441 	else if(step==s6)
;    1442 		{
;    1443 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
;    1444           if(!bMD3)goto step_contr_end;
;    1445           step=s55;
;    1446           cnt_del=40;
;    1447 		}
;    1448 	else if(step==s55)
;    1449 		{
;    1450 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
;    1451           cnt_del--;
;    1452           if(cnt_del==0)
;    1453 			{
;    1454           	step=s7;
;    1455           	cnt_del=20;
;    1456 			}
;    1457           }
;    1458 	else if(step==s7)
;    1459 		{
;    1460 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1461           cnt_del--;
;    1462           if(cnt_del==0)
;    1463 			{
;    1464           	step=s8;
;    1465           	cnt_del=130;
;    1466 			}
;    1467           }
;    1468 	else if(step==s8)
;    1469 		{
;    1470 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1471           cnt_del--;
;    1472           if(cnt_del==0)
;    1473 			{
;    1474           	step=s9;
;    1475           	cnt_del=20;
;    1476 			}
;    1477           }
;    1478 	else if(step==s9)
;    1479 		{
;    1480 		temp|=(1<<PP1);
;    1481           cnt_del--;
;    1482           if(cnt_del==0)
;    1483 			{
;    1484           	step=sOFF;
;    1485           	}
;    1486           }
;    1487 	}
;    1488 
;    1489 else if(prog==p2)  //ско
;    1490 	{
;    1491 	if(step==s1)
;    1492 		{
;    1493 		temp|=(1<<PP1);
;    1494           if(!bMD1)goto step_contr_end;
;    1495 
;    1496 			if(ee_vacuum_mode==evmOFF)
;    1497 				{
;    1498 				goto lbl_0002;
;    1499 				}
;    1500 			else step=s2;
;    1501 
;    1502           //step=s2;
;    1503 		}
;    1504 
;    1505 	else if(step==s2)
;    1506 		{
;    1507 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1508           if(!bVR)goto step_contr_end;
;    1509 
;    1510 lbl_0002:
;    1511           step=s100;
;    1512 		cnt_del=40;
;    1513           }
;    1514 	else if(step==s100)
;    1515 		{
;    1516 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1517           cnt_del--;
;    1518           if(cnt_del==0)
;    1519 			{
;    1520           	step=s3;
;    1521           	cnt_del=50;
;    1522 			}
;    1523 		}
;    1524 	else if(step==s3)
;    1525 		{
;    1526 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1527           cnt_del--;
;    1528           if(cnt_del==0)
;    1529 			{
;    1530           	step=s4;
;    1531 			}
;    1532 		}
;    1533 	else if(step==s4)
;    1534 		{
;    1535 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;    1536           if(!bMD2)goto step_contr_end;
;    1537           step=s5;
;    1538           cnt_del=20;
;    1539 		}
;    1540 	else if(step==s5)
;    1541 		{
;    1542 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1543           cnt_del--;
;    1544           if(cnt_del==0)
;    1545 			{
;    1546           	step=s6;
;    1547           	cnt_del=130;
;    1548 			}
;    1549           }
;    1550 	else if(step==s6)
;    1551 		{
;    1552 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1553           cnt_del--;
;    1554           if(cnt_del==0)
;    1555 			{
;    1556           	step=s7;
;    1557           	cnt_del=20;
;    1558 			}
;    1559           }
;    1560 	else if(step==s7)
;    1561 		{
;    1562 		temp|=(1<<PP1);
;    1563           cnt_del--;
;    1564           if(cnt_del==0)
;    1565 			{
;    1566           	step=sOFF;
;    1567           	}
;    1568           }
;    1569 	}
;    1570 
;    1571 else if(prog==p3)   //твист
;    1572 	{
;    1573 	if(step==s1)
;    1574 		{
;    1575 		temp|=(1<<PP1);
;    1576           if(!bMD1)goto step_contr_end;
;    1577 
;    1578 			if(ee_vacuum_mode==evmOFF)
;    1579 				{
;    1580 				goto lbl_0003;
;    1581 				}
;    1582 			else step=s2;
;    1583 
;    1584           //step=s2;
;    1585 		}
;    1586 
;    1587 	else if(step==s2)
;    1588 		{
;    1589 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1590           if(!bVR)goto step_contr_end;
;    1591 lbl_0003:
;    1592           cnt_del=50;
;    1593 		step=s3;
;    1594 		}
;    1595 
;    1596 
;    1597 	else	if(step==s3)
;    1598 		{
;    1599 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1600 		cnt_del--;
;    1601 		if(cnt_del==0)
;    1602 			{
;    1603 			cnt_del=90;
;    1604 			step=s4;
;    1605 			}
;    1606           }
;    1607 	else if(step==s4)
;    1608 		{
;    1609 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1610 		cnt_del--;
;    1611  		if(cnt_del==0)
;    1612 			{
;    1613 			cnt_del=130;
;    1614 			step=s5;
;    1615 			}
;    1616 		}
;    1617 
;    1618 	else if(step==s5)
;    1619 		{
;    1620 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1621 		cnt_del--;
;    1622 		if(cnt_del==0)
;    1623 			{
;    1624 			step=s6;
;    1625 			cnt_del=20;
;    1626 			}
;    1627 		}
;    1628 
;    1629 	else if(step==s6)
;    1630 		{
;    1631 		temp|=(1<<PP1);
;    1632   		cnt_del--;
;    1633 		if(cnt_del==0)
;    1634 			{
;    1635 			step=sOFF;
;    1636 			}
;    1637 		}
;    1638 
;    1639 	}
;    1640 
;    1641 else if(prog==p4)      //замок
;    1642 	{
;    1643 	if(step==s1)
;    1644 		{
;    1645 		temp|=(1<<PP1);
;    1646           if(!bMD1)goto step_contr_end;
;    1647 
;    1648 			if(ee_vacuum_mode==evmOFF)
;    1649 				{
;    1650 				goto lbl_0004;
;    1651 				}
;    1652 			else step=s2;
;    1653           //step=s2;
;    1654 		}
;    1655 
;    1656 	else if(step==s2)
;    1657 		{
;    1658 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1659           if(!bVR)goto step_contr_end;
;    1660 lbl_0004:
;    1661           step=s3;
;    1662 		cnt_del=50;
;    1663           }
;    1664 
;    1665 	else if(step==s3)
;    1666 		{
;    1667 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1668           cnt_del--;
;    1669           if(cnt_del==0)
;    1670 			{
;    1671           	step=s4;
;    1672 			cnt_del=120U;
;    1673 			}
;    1674           }
;    1675 
;    1676    	else if(step==s4)
;    1677 		{
;    1678 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1679 		cnt_del--;
;    1680 		if(cnt_del==0)
;    1681 			{
;    1682 			step=s5;
;    1683 			cnt_del=30;
;    1684 			}
;    1685 		}
;    1686 
;    1687 	else if(step==s5)
;    1688 		{
;    1689 		temp|=(1<<PP1)|(1<<PP4);
;    1690 		cnt_del--;
;    1691 		if(cnt_del==0)
;    1692 			{
;    1693 			step=s6;
;    1694 			cnt_del=120U;
;    1695 			}
;    1696 		}
;    1697 
;    1698 	else if(step==s6)
;    1699 		{
;    1700 		temp|=(1<<PP4);
;    1701 		cnt_del--;
;    1702 		if(cnt_del==0)
;    1703 			{
;    1704 			step=sOFF;
;    1705 			}
;    1706 		}
;    1707 
;    1708 	}
;    1709 	
;    1710 step_contr_end:
;    1711 
;    1712 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1713 
;    1714 PORTB=~temp;
;    1715 //PORTB=0x55;
;    1716 }
;    1717 #endif
;    1718 
;    1719 #ifdef I220
;    1720 //-----------------------------------------------
;    1721 void step_contr(void)
;    1722 {
;    1723 char temp=0;
;    1724 DDRB=0xFF;
;    1725 
;    1726 if(step==sOFF)goto step_contr_end;
;    1727 
;    1728 else if(prog==p3)   //твист
;    1729 	{
;    1730 	if(step==s1)
;    1731 		{
;    1732 		temp|=(1<<PP1);
;    1733           if(!bMD1)goto step_contr_end;
;    1734 
;    1735 			if(ee_vacuum_mode==evmOFF)
;    1736 				{
;    1737 				goto lbl_0003;
;    1738 				}
;    1739 			else step=s2;
;    1740 
;    1741           //step=s2;
;    1742 		}
;    1743 
;    1744 	else if(step==s2)
;    1745 		{
;    1746 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1747           if(!bVR)goto step_contr_end;
;    1748 lbl_0003:
;    1749           cnt_del=50;
;    1750 		step=s3;
;    1751 		}
;    1752 
;    1753 
;    1754 	else	if(step==s3)
;    1755 		{
;    1756 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1757 		cnt_del--;
;    1758 		if(cnt_del==0)
;    1759 			{
;    1760 			cnt_del=ee_delay[prog,0]*10U;
;    1761 			step=s4;
;    1762 			}
;    1763           }
;    1764 	else if(step==s4)
;    1765 		{
;    1766 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1767 		cnt_del--;
;    1768  		if(cnt_del==0)
;    1769 			{
;    1770 			cnt_del=ee_delay[prog,1]*10U;
;    1771 			step=s5;
;    1772 			}
;    1773 		}
;    1774 
;    1775 	else if(step==s5)
;    1776 		{
;    1777 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1778 		cnt_del--;
;    1779 		if(cnt_del==0)
;    1780 			{
;    1781 			step=s6;
;    1782 			cnt_del=20;
;    1783 			}
;    1784 		}
;    1785 
;    1786 	else if(step==s6)
;    1787 		{
;    1788 		temp|=(1<<PP1);
;    1789   		cnt_del--;
;    1790 		if(cnt_del==0)
;    1791 			{
;    1792 			step=sOFF;
;    1793 			}
;    1794 		}
;    1795 
;    1796 	}
;    1797 
;    1798 else if(prog==p4)      //замок
;    1799 	{
;    1800 	if(step==s1)
;    1801 		{
;    1802 		temp|=(1<<PP1);
;    1803           if(!bMD1)goto step_contr_end;
;    1804 
;    1805 			if(ee_vacuum_mode==evmOFF)
;    1806 				{
;    1807 				goto lbl_0004;
;    1808 				}
;    1809 			else step=s2;
;    1810           //step=s2;
;    1811 		}
;    1812 
;    1813 	else if(step==s2)
;    1814 		{
;    1815 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1816           if(!bVR)goto step_contr_end;
;    1817 lbl_0004:
;    1818           step=s3;
;    1819 		cnt_del=50;
;    1820           }
;    1821 
;    1822 	else if(step==s3)
;    1823 		{
;    1824 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1825           cnt_del--;
;    1826           if(cnt_del==0)
;    1827 			{
;    1828           	step=s4;
;    1829 			cnt_del=ee_delay[prog,0]*10U;
;    1830 			}
;    1831           }
;    1832 
;    1833    	else if(step==s4)
;    1834 		{
;    1835 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1836 		cnt_del--;
;    1837 		if(cnt_del==0)
;    1838 			{
;    1839 			step=s5;
;    1840 			cnt_del=30;
;    1841 			}
;    1842 		}
;    1843 
;    1844 	else if(step==s5)
;    1845 		{
;    1846 		temp|=(1<<PP1)|(1<<PP4);
;    1847 		cnt_del--;
;    1848 		if(cnt_del==0)
;    1849 			{
;    1850 			step=s6;
;    1851 			cnt_del=ee_delay[prog,1]*10U;
;    1852 			}
;    1853 		}
;    1854 
;    1855 	else if(step==s6)
;    1856 		{
;    1857 		temp|=(1<<PP4);
;    1858 		cnt_del--;
;    1859 		if(cnt_del==0)
;    1860 			{
;    1861 			step=sOFF;
;    1862 			}
;    1863 		}
;    1864 
;    1865 	}
;    1866 	
;    1867 step_contr_end:
;    1868 
;    1869 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;    1870 
;    1871 PORTB=~temp;
;    1872 //PORTB=0x55;
;    1873 }
;    1874 #endif 
;    1875 
;    1876 #ifdef TVIST_SKO
;    1877 //-----------------------------------------------
;    1878 void step_contr(void)
;    1879 {
;    1880 char temp=0;
;    1881 DDRB=0xFF;
;    1882 
;    1883 if(step==sOFF)
;    1884 	{
;    1885 	temp=0;
;    1886 	}
;    1887 
;    1888 if(prog==p2) //СКО
;    1889 	{
;    1890 	if(step==s1)
;    1891 		{
;    1892 		temp|=(1<<PP1);
;    1893 
;    1894 		cnt_del--;
;    1895 		if(cnt_del==0)
;    1896 			{
;    1897 			step=s2;
;    1898 			cnt_del=30;
;    1899 			}
;    1900 		}
;    1901 
;    1902 	else if(step==s2)
;    1903 		{
;    1904 		temp|=(1<<PP1)|(1<<DV);
;    1905 
;    1906 		cnt_del--;
;    1907 		if(cnt_del==0)
;    1908 			{
;    1909 			step=s3;
;    1910 			}
;    1911 		}
;    1912 
;    1913 
;    1914 	else if(step==s3)
;    1915 		{
;    1916 		temp|=(1<<PP1)|(1<<DV)|(1<<PP2);
;    1917 
;    1918                	if(bMD1)//goto step_contr_end;
;    1919                		{  
;    1920                		cnt_del=100;
;    1921 	       		step=s4;
;    1922 	       		}
;    1923 	       	}
;    1924 
;    1925 	else if(step==s4)
;    1926 		{
;    1927 		temp|=(1<<PP1);
;    1928 		cnt_del--;
;    1929 		if(cnt_del==0)
;    1930 			{
;    1931 			step=sOFF;
;    1932 			}
;    1933 		}
;    1934 
;    1935 	}
;    1936 
;    1937 if(prog==p3)
;    1938 	{
;    1939 	if(step==s1)
;    1940 		{
;    1941 		temp|=(1<<PP1);
;    1942 
;    1943 		cnt_del--;
;    1944 		if(cnt_del==0)
;    1945 			{
;    1946 			step=s2;
;    1947 			cnt_del=100;
;    1948 			}
;    1949 		}
;    1950 
;    1951 	else if(step==s2)
;    1952 		{
;    1953 		temp|=(1<<PP1)|(1<<PP2);
;    1954 
;    1955 		cnt_del--;
;    1956 		if(cnt_del==0)
;    1957 			{
;    1958 			step=s3;
;    1959 			cnt_del=50;
;    1960 			}
;    1961 		}
;    1962 
;    1963 
;    1964 	else if(step==s3)
;    1965 		{
;    1966 		temp|=(1<<PP2);
;    1967 	
;    1968 		cnt_del--;
;    1969 		if(cnt_del==0)
;    1970 			{
;    1971 			step=sOFF;
;    1972 			}
;    1973                	}
;    1974 	}
;    1975 step_contr_end:
;    1976 
;    1977 PORTB=~temp;
;    1978 }
;    1979 #endif
;    1980 
;    1981 #ifdef I380_WI_GAZ
;    1982 //-----------------------------------------------
;    1983 void step_contr(void)
;    1984 {
_step_contr:
;    1985 short temp=0;
;    1986 DDRB=0xFF;
	ST   -Y,R17
	ST   -Y,R16
;	temp -> R16,R17
	LDI  R16,0
	LDI  R17,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
;    1987 
;    1988 if(step==sOFF)goto step_contr_end;
	TST  R11
	BRNE _0x45
	RJMP _0x46
;    1989 
;    1990 else if(prog==p1)
_0x45:
	LDI  R30,LOW(1)
	CP   R30,R10
	BREQ PC+3
	JMP _0x48
;    1991 	{
;    1992 	if(step==s1)    //жесть
	CP   R30,R11
	BRNE _0x49
;    1993 		{
;    1994 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    1995           if(!bMD1)goto step_contr_end;
	LDS  R30,_bMD1
	CPI  R30,0
	BRNE _0x4A
	RJMP _0x46
;    1996 
;    1997 			if(ee_vacuum_mode==evmOFF)
_0x4A:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x4C
;    1998 				{
;    1999 				goto lbl_0001;
;    2000 				}
;    2001 			else step=s2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;    2002 		}
;    2003 
;    2004 	else if(step==s2)
	RJMP _0x4E
_0x49:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x4F
;    2005 		{
;    2006 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP7);
	ORI  R16,LOW(226)
;    2007           if(!bVR)goto step_contr_end;
	LDS  R30,_bVR
	CPI  R30,0
	BRNE _0x50
	RJMP _0x46
;    2008 lbl_0001:
_0x50:
_0x4C:
;    2009 
;    2010           step=s3;
	LDI  R30,LOW(3)
	MOV  R11,R30
;    2011 		cnt_del=10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2012           }
;    2013 	else if(step==s3)
	RJMP _0x51
_0x4F:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0x52
;    2014 		{
;    2015 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;    2016           cnt_del--;
	CALL SUBOPT_0x1
;    2017           if(cnt_del==0)
	BRNE _0x53
;    2018 			{
;    2019           	step=s4;
	LDI  R30,LOW(4)
	MOV  R11,R30
;    2020 			}
;    2021 		}
_0x53:
;    2022 	
;    2023 	else if(step==s4)
	RJMP _0x54
_0x52:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0x55
;    2024 		{
;    2025 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP8);
	ORI  R16,LOW(193)
;    2026           if(bVR2)goto step_contr_end;
	SBRC R3,4
	RJMP _0x46
;    2027           step=s5;
	LDI  R30,LOW(5)
	CALL SUBOPT_0x2
;    2028           cnt_del=40;
;    2029 		}
;    2030 		
;    2031 	else if(step==s5)
	RJMP _0x57
_0x55:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0x58
;    2032 		{
;    2033 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;    2034           cnt_del--;
	CALL SUBOPT_0x1
;    2035           if(cnt_del==0)
	BRNE _0x59
;    2036 			{
;    2037           	step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x3
;    2038           	cnt_del=50;
;    2039 			}
;    2040 		}  
_0x59:
;    2041 	else if(step==s6)
	RJMP _0x5A
_0x58:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0x5B
;    2042 		{
;    2043 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<DV);
	__ORWRN 16,17,464
;    2044           cnt_del--;
	CALL SUBOPT_0x1
;    2045           if(cnt_del==0)
	BRNE _0x5C
;    2046 			{
;    2047           	step=s7;
	LDI  R30,LOW(7)
	MOV  R11,R30
;    2048 			}
;    2049 		}		
_0x5C:
;    2050 	else if(step==s7)
	RJMP _0x5D
_0x5B:
	LDI  R30,LOW(7)
	CP   R30,R11
	BRNE _0x5E
;    2051 		{
;    2052 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<PP5)|(1<<DV);
	__ORWRN 16,17,472
;    2053           if(!bMD2)goto step_contr_end;
	SBRS R3,2
	RJMP _0x46
;    2054           step=s8;
	LDI  R30,LOW(8)
	CALL SUBOPT_0x4
;    2055           cnt_del=30;
;    2056 		}
;    2057 	else if(step==s8)
	RJMP _0x60
_0x5E:
	LDI  R30,LOW(8)
	CP   R30,R11
	BRNE _0x61
;    2058 		{
;    2059 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<PP5)|(1<<DV);
	__ORWRN 16,17,472
;    2060           cnt_del--;
	CALL SUBOPT_0x1
;    2061           if(cnt_del==0)
	BRNE _0x62
;    2062 			{
;    2063           	step=s9;
	LDI  R30,LOW(9)
	CALL SUBOPT_0x5
;    2064           	cnt_del=20;
;    2065 			}
;    2066           }
_0x62:
;    2067 
;    2068 	else if(step==s9)
	RJMP _0x63
_0x61:
	LDI  R30,LOW(9)
	CP   R30,R11
	BRNE _0x64
;    2069 		{
;    2070 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<DV);
	__ORWRN 16,17,464
;    2071           cnt_del--;
	CALL SUBOPT_0x1
;    2072           if(cnt_del==0)
	BRNE _0x65
;    2073 			{
;    2074           	step=s10;
	LDI  R30,LOW(10)
	MOV  R11,R30
;    2075 			}
;    2076           }
_0x65:
;    2077 	else if(step==s10)
	RJMP _0x66
_0x64:
	LDI  R30,LOW(10)
	CP   R30,R11
	BRNE _0x67
;    2078 		{
;    2079 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<DV)|(1<<PP6);
	__ORWRN 16,17,468
;    2080           if(!bMD3)goto step_contr_end;
	SBRS R3,3
	RJMP _0x46
;    2081           step=s11;
	LDI  R30,LOW(11)
	CALL SUBOPT_0x2
;    2082           cnt_del=40;
;    2083 		}
;    2084 	else if(step==s11)
	RJMP _0x69
_0x67:
	LDI  R30,LOW(11)
	CP   R30,R11
	BRNE _0x6A
;    2085 		{
;    2086 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<DV)|(1<<PP6);
	__ORWRN 16,17,468
;    2087           cnt_del--;
	CALL SUBOPT_0x1
;    2088           if(cnt_del==0)
	BRNE _0x6B
;    2089 			{
;    2090           	step=s12;
	LDI  R30,LOW(12)
	CALL SUBOPT_0x5
;    2091           	cnt_del=20;
;    2092 			}
;    2093           }
_0x6B:
;    2094 	else if(step==s12)
	RJMP _0x6C
_0x6A:
	LDI  R30,LOW(12)
	CP   R30,R11
	BRNE _0x6D
;    2095 		{
;    2096 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP7);
	ORI  R16,LOW(194)
;    2097           cnt_del--;
	CALL SUBOPT_0x1
;    2098           if(cnt_del==0)
	BRNE _0x6E
;    2099 			{
;    2100           	step=s13;
	LDI  R30,LOW(13)
	CALL SUBOPT_0x6
;    2101           	cnt_del=130;
;    2102 			}
;    2103           }
_0x6E:
;    2104 	else if(step==s13)
	RJMP _0x6F
_0x6D:
	LDI  R30,LOW(13)
	CP   R30,R11
	BRNE _0x70
;    2105 		{
;    2106 		temp|=(1<<PP1)|(1<<PP2);
	ORI  R16,LOW(192)
;    2107           cnt_del--;
	CALL SUBOPT_0x1
;    2108           if(cnt_del==0)
	BRNE _0x71
;    2109 			{
;    2110           	step=s14;
	LDI  R30,LOW(14)
	CALL SUBOPT_0x5
;    2111           	cnt_del=20;
;    2112 			}
;    2113           }
_0x71:
;    2114 	else if(step==s14)
	RJMP _0x72
_0x70:
	LDI  R30,LOW(14)
	CP   R30,R11
	BRNE _0x73
;    2115 		{
;    2116 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    2117           cnt_del--;
	CALL SUBOPT_0x1
;    2118           if(cnt_del==0)
	BRNE _0x74
;    2119 			{
;    2120           	step=sOFF;
	CLR  R11
;    2121           	}
;    2122           }
_0x74:
;    2123 	}
_0x73:
_0x72:
_0x6F:
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
;    2124 
;    2125 else if(prog==p2)  //ско
	RJMP _0x75
_0x48:
	LDI  R30,LOW(2)
	CP   R30,R10
	BREQ PC+3
	JMP _0x76
;    2126 	{
;    2127 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x77
;    2128 		{
;    2129 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    2130           if(!bMD1)goto step_contr_end;
	LDS  R30,_bMD1
	CPI  R30,0
	BRNE _0x78
	RJMP _0x46
;    2131 
;    2132 			if(ee_vacuum_mode==evmOFF)
_0x78:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x7A
;    2133 				{
;    2134 				goto lbl_0002;
;    2135 				}
;    2136 			else step=s2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;    2137 
;    2138           //step=s2;
;    2139 		}
;    2140 
;    2141 	else if(step==s2)
	RJMP _0x7C
_0x77:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x7D
;    2142 		{
;    2143 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;    2144           if(!bVR)goto step_contr_end;
	LDS  R30,_bVR
	CPI  R30,0
	BRNE _0x7E
	RJMP _0x46
;    2145 
;    2146 lbl_0002:
_0x7E:
_0x7A:
;    2147           step=s100;
	LDI  R30,LOW(19)
	CALL SUBOPT_0x2
;    2148 		cnt_del=40;
;    2149           }
;    2150 	else if(step==s100)
	RJMP _0x7F
_0x7D:
	LDI  R30,LOW(19)
	CP   R30,R11
	BRNE _0x80
;    2151 		{
;    2152 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;    2153           cnt_del--;
	CALL SUBOPT_0x1
;    2154           if(cnt_del==0)
	BRNE _0x81
;    2155 			{
;    2156           	step=s3;
	LDI  R30,LOW(3)
	CALL SUBOPT_0x3
;    2157           	cnt_del=50;
;    2158 			}
;    2159 		}
_0x81:
;    2160 	else if(step==s3)
	RJMP _0x82
_0x80:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0x83
;    2161 		{
;    2162 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	__ORWRN 16,17,496
;    2163           cnt_del--;
	CALL SUBOPT_0x1
;    2164           if(cnt_del==0)
	BRNE _0x84
;    2165 			{
;    2166           	step=s4;
	LDI  R30,LOW(4)
	MOV  R11,R30
;    2167 			}
;    2168 		}
_0x84:
;    2169 	else if(step==s4)
	RJMP _0x85
_0x83:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0x86
;    2170 		{
;    2171 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
	__ORWRN 16,17,504
;    2172           if(!bMD2)goto step_contr_end;
	SBRS R3,2
	RJMP _0x46
;    2173           step=s5;
	LDI  R30,LOW(5)
	CALL SUBOPT_0x5
;    2174           cnt_del=20;
;    2175 		}
;    2176 	else if(step==s5)
	RJMP _0x88
_0x86:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0x89
;    2177 		{
;    2178 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
	__ORWRN 16,17,496
;    2179           cnt_del--;
	CALL SUBOPT_0x1
;    2180           if(cnt_del==0)
	BRNE _0x8A
;    2181 			{
;    2182           	step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x6
;    2183           	cnt_del=130;
;    2184 			}
;    2185           }
_0x8A:
;    2186 	else if(step==s6)
	RJMP _0x8B
_0x89:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0x8C
;    2187 		{
;    2188 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;    2189           cnt_del--;
	CALL SUBOPT_0x1
;    2190           if(cnt_del==0)
	BRNE _0x8D
;    2191 			{
;    2192           	step=s7;
	LDI  R30,LOW(7)
	CALL SUBOPT_0x5
;    2193           	cnt_del=20;
;    2194 			}
;    2195           }
_0x8D:
;    2196 	else if(step==s7)
	RJMP _0x8E
_0x8C:
	LDI  R30,LOW(7)
	CP   R30,R11
	BRNE _0x8F
;    2197 		{
;    2198 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    2199           cnt_del--;
	CALL SUBOPT_0x1
;    2200           if(cnt_del==0)
	BRNE _0x90
;    2201 			{
;    2202           	step=sOFF;
	CLR  R11
;    2203           	}
;    2204           }
_0x90:
;    2205 	}
_0x8F:
_0x8E:
_0x8B:
_0x88:
_0x85:
_0x82:
_0x7F:
_0x7C:
;    2206 
;    2207 else if(prog==p3)   //твист
	RJMP _0x91
_0x76:
	LDI  R30,LOW(3)
	CP   R30,R10
	BREQ PC+3
	JMP _0x92
;    2208 	{
;    2209 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x93
;    2210 		{
;    2211 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    2212           if(!bMD1)goto step_contr_end;
	LDS  R30,_bMD1
	CPI  R30,0
	BRNE _0x94
	RJMP _0x46
;    2213 
;    2214 			if(ee_vacuum_mode==evmOFF)
_0x94:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x96
;    2215 				{
;    2216 				goto lbl_0003;
;    2217 				}
;    2218 			else step=s2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;    2219 
;    2220           //step=s2;
;    2221 		}
;    2222 
;    2223 	else if(step==s2)
	RJMP _0x98
_0x93:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x99
;    2224 		{
;    2225 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;    2226           if(!bVR)goto step_contr_end;
	LDS  R30,_bVR
	CPI  R30,0
	BRNE _0x9A
	RJMP _0x46
;    2227 lbl_0003:
_0x9A:
_0x96:
;    2228           cnt_del=50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2229 		step=s3;
	LDI  R30,LOW(3)
	MOV  R11,R30
;    2230 		}
;    2231 
;    2232 
;    2233 	else	if(step==s3)
	RJMP _0x9B
_0x99:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0x9C
;    2234 		{
;    2235 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;    2236 		cnt_del--;
	CALL SUBOPT_0x1
;    2237 		if(cnt_del==0)
	BRNE _0x9D
;    2238 			{
;    2239 			cnt_del=90;
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2240 			step=s4;
	LDI  R30,LOW(4)
	MOV  R11,R30
;    2241 			}
;    2242           }
_0x9D:
;    2243 	else if(step==s4)
	RJMP _0x9E
_0x9C:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0x9F
;    2244 		{
;    2245 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
	ORI  R16,LOW(250)
;    2246 		cnt_del--;
	CALL SUBOPT_0x1
;    2247  		if(cnt_del==0)
	BRNE _0xA0
;    2248 			{
;    2249 			cnt_del=130;
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2250 			step=s5;
	LDI  R30,LOW(5)
	MOV  R11,R30
;    2251 			}
;    2252 		}
_0xA0:
;    2253 
;    2254 	else if(step==s5)
	RJMP _0xA1
_0x9F:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0xA2
;    2255 		{
;    2256 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
	ORI  R16,LOW(202)
;    2257 		cnt_del--;
	CALL SUBOPT_0x1
;    2258 		if(cnt_del==0)
	BRNE _0xA3
;    2259 			{
;    2260 			step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x5
;    2261 			cnt_del=20;
;    2262 			}
;    2263 		}
_0xA3:
;    2264 
;    2265 	else if(step==s6)
	RJMP _0xA4
_0xA2:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0xA5
;    2266 		{
;    2267 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    2268   		cnt_del--;
	CALL SUBOPT_0x1
;    2269 		if(cnt_del==0)
	BRNE _0xA6
;    2270 			{
;    2271 			step=sOFF;
	CLR  R11
;    2272 			}
;    2273 		}
_0xA6:
;    2274 
;    2275 	}
_0xA5:
_0xA4:
_0xA1:
_0x9E:
_0x9B:
_0x98:
;    2276 
;    2277 else if(prog==p4)      //замок
	RJMP _0xA7
_0x92:
	LDI  R30,LOW(4)
	CP   R30,R10
	BREQ PC+3
	JMP _0xA8
;    2278 	{
;    2279 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0xA9
;    2280 		{
;    2281 		temp|=(1<<PP1);
	ORI  R16,LOW(64)
;    2282           if(!bMD1)goto step_contr_end;
	LDS  R30,_bMD1
	CPI  R30,0
	BREQ _0x46
;    2283 
;    2284 			if(ee_vacuum_mode==evmOFF)
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0xAC
;    2285 				{
;    2286 				goto lbl_0004;
;    2287 				}
;    2288 			else step=s2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;    2289           //step=s2;
;    2290 		}
;    2291 
;    2292 	else if(step==s2)
	RJMP _0xAE
_0xA9:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0xAF
;    2293 		{
;    2294 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	ORI  R16,LOW(224)
;    2295           if(!bVR)goto step_contr_end;
	LDS  R30,_bVR
	CPI  R30,0
	BREQ _0x46
;    2296 lbl_0004:
_0xAC:
;    2297           step=s3;
	LDI  R30,LOW(3)
	CALL SUBOPT_0x3
;    2298 		cnt_del=50;
;    2299           }
;    2300 
;    2301 	else if(step==s3)
	RJMP _0xB1
_0xAF:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0xB2
;    2302 		{
;    2303 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
	ORI  R16,LOW(240)
;    2304           cnt_del--;
	CALL SUBOPT_0x1
;    2305           if(cnt_del==0)
	BRNE _0xB3
;    2306 			{
;    2307           	step=s4;
	LDI  R30,LOW(4)
	CALL SUBOPT_0x7
;    2308 			cnt_del=120U;
;    2309 			}
;    2310           }
_0xB3:
;    2311 
;    2312    	else if(step==s4)
	RJMP _0xB4
_0xB2:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0xB5
;    2313 		{
;    2314 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
	ORI  R16,LOW(208)
;    2315 		cnt_del--;
	CALL SUBOPT_0x1
;    2316 		if(cnt_del==0)
	BRNE _0xB6
;    2317 			{
;    2318 			step=s5;
	LDI  R30,LOW(5)
	CALL SUBOPT_0x4
;    2319 			cnt_del=30;
;    2320 			}
;    2321 		}
_0xB6:
;    2322 
;    2323 	else if(step==s5)
	RJMP _0xB7
_0xB5:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0xB8
;    2324 		{
;    2325 		temp|=(1<<PP1)|(1<<PP4);
	ORI  R16,LOW(80)
;    2326 		cnt_del--;
	CALL SUBOPT_0x1
;    2327 		if(cnt_del==0)
	BRNE _0xB9
;    2328 			{
;    2329 			step=s6;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x7
;    2330 			cnt_del=120U;
;    2331 			}
;    2332 		}
_0xB9:
;    2333 
;    2334 	else if(step==s6)
	RJMP _0xBA
_0xB8:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0xBB
;    2335 		{
;    2336 		temp|=(1<<PP4);
	ORI  R16,LOW(16)
;    2337 		cnt_del--;
	CALL SUBOPT_0x1
;    2338 		if(cnt_del==0)
	BRNE _0xBC
;    2339 			{
;    2340 			step=sOFF;
	CLR  R11
;    2341 			}
;    2342 		}
_0xBC:
;    2343 
;    2344 	}
_0xBB:
_0xBA:
_0xB7:
_0xB4:
_0xB1:
_0xAE:
;    2345 	
;    2346 step_contr_end:
_0xA8:
_0xA7:
_0x91:
_0x75:
_0x46:
;    2347 
;    2348 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BRNE _0xBD
	ANDI R16,LOW(65503)
;    2349 
;    2350 //temp=0;
;    2351 //temp|=(1<<DV);
;    2352 
;    2353 PORTB=~((char)temp);
_0xBD:
	MOV  R30,R16
	COM  R30
	OUT  0x18,R30
;    2354 //PORTB=0x55;
;    2355 
;    2356 DDRD.1=1;
	SBI  0x11,1
;    2357 if(temp&(1<<DV))PORTD.1=0;
	SBRS R17,0
	RJMP _0xBE
	CBI  0x12,1
;    2358 else PORTD.1=1;
	RJMP _0xBF
_0xBE:
	SBI  0x12,1
_0xBF:
;    2359 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;    2360 #endif
;    2361 
;    2362 
;    2363 //-----------------------------------------------
;    2364 void bin2bcd_int(unsigned int in)
;    2365 {
_bin2bcd_int:
;    2366 char i;
;    2367 for(i=3;i>0;i--)
	ST   -Y,R16
;	in -> Y+1
;	i -> R16
	LDI  R16,LOW(3)
_0xC1:
	LDI  R30,LOW(0)
	CP   R30,R16
	BRSH _0xC2
;    2368 	{
;    2369 	dig[i]=in%10;
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
;    2370 	in/=10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
;    2371 	}   
	SUBI R16,1
	RJMP _0xC1
_0xC2:
;    2372 }
	LDD  R16,Y+0
	RJMP _0x12D
;    2373 
;    2374 //-----------------------------------------------
;    2375 void bcd2ind(char s)
;    2376 {
_bcd2ind:
;    2377 char i;
;    2378 bZ=1;
	ST   -Y,R16
;	s -> Y+1
;	i -> R16
	SET
	BLD  R2,3
;    2379 for (i=0;i<5;i++)
	LDI  R16,LOW(0)
_0xC4:
	CPI  R16,5
	BRLO PC+3
	JMP _0xC5
;    2380 	{
;    2381 	if(bZ&&(!dig[i-1])&&(i<4))
	SBRS R2,3
	RJMP _0xC7
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	CPI  R30,0
	BRNE _0xC7
	CPI  R16,4
	BRLO _0xC8
_0xC7:
	RJMP _0xC6
_0xC8:
;    2382 		{
;    2383 		if((4-i)>s)
	LDI  R30,LOW(4)
	SUB  R30,R16
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
	BRSH _0xC9
;    2384 			{
;    2385 			ind_out[i-1]=DIGISYM[10];
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	POP  R26
	POP  R27
	RJMP _0x12E
;    2386 			}
;    2387 		else ind_out[i-1]=DIGISYM[0];	
_0xC9:
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	LPM  R30,Z
	POP  R26
	POP  R27
_0x12E:
	ST   X,R30
;    2388 		}
;    2389 	else
	RJMP _0xCB
_0xC6:
;    2390 		{
;    2391 		ind_out[i-1]=DIGISYM[dig[i-1]];
	CALL SUBOPT_0x8
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
;    2392 		bZ=0;
	CLT
	BLD  R2,3
;    2393 		}                   
_0xCB:
;    2394 
;    2395 	if(s)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0xCC
;    2396 		{
;    2397 		ind_out[3-s]&=0b01111111;
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
;    2398 		}	
;    2399  
;    2400 	}
_0xCC:
	SUBI R16,-1
	RJMP _0xC4
_0xC5:
;    2401 }            
	LDD  R16,Y+0
	ADIW R28,2
	RET
;    2402 //-----------------------------------------------
;    2403 void int2ind(unsigned int in,char s)
;    2404 {
_int2ind:
;    2405 bin2bcd_int(in);
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _bin2bcd_int
;    2406 bcd2ind(s);
	LD   R30,Y
	ST   -Y,R30
	CALL _bcd2ind
;    2407 
;    2408 } 
_0x12D:
	ADIW R28,3
	RET
;    2409 
;    2410 //-----------------------------------------------
;    2411 void ind_hndl(void)
;    2412 {
_ind_hndl:
;    2413 int2ind(ee_delay[prog,sub_ind],1);  
	CALL SUBOPT_0xA
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _int2ind
;    2414 //ind_out[0]=0xff;//DIGISYM[0];
;    2415 //ind_out[1]=0xff;//DIGISYM[1];
;    2416 //ind_out[2]=DIGISYM[2];//0xff;
;    2417 //ind_out[0]=DIGISYM[7]; 
;    2418 
;    2419 ind_out[0]=DIGISYM[sub_ind+1];
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
;    2420 }
	RET
;    2421 
;    2422 //-----------------------------------------------
;    2423 void led_hndl(void)
;    2424 {
_led_hndl:
;    2425 ind_out[4]=DIGISYM[10]; 
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	__PUTB1MN _ind_out,4
;    2426 
;    2427 ind_out[4]&=~(1<<LED_POW_ON); 
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xDF
	POP  R26
	POP  R27
	ST   X,R30
;    2428 
;    2429 if(step!=sOFF)
	TST  R11
	BREQ _0xCD
;    2430 	{
;    2431 	ind_out[4]&=~(1<<LED_WRK);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xBF
	POP  R26
	POP  R27
	RJMP _0x12F
;    2432 	}
;    2433 else ind_out[4]|=(1<<LED_WRK);
_0xCD:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x40
	POP  R26
	POP  R27
_0x12F:
	ST   X,R30
;    2434 
;    2435 
;    2436 if(step==sOFF)
	TST  R11
	BRNE _0xCF
;    2437 	{
;    2438  	if(bERR)
	SBRS R3,1
	RJMP _0xD0
;    2439 		{
;    2440 		ind_out[4]&=~(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFE
	POP  R26
	POP  R27
	RJMP _0x130
;    2441 		}
;    2442 	else
_0xD0:
;    2443 		{
;    2444 		ind_out[4]|=(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
_0x130:
	ST   X,R30
;    2445 		}
;    2446      }
;    2447 else ind_out[4]|=(1<<LED_ERROR);
	RJMP _0xD2
_0xCF:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
	ST   X,R30
_0xD2:
;    2448 
;    2449 /* 	if(bMD1)
;    2450 		{
;    2451 		ind_out[4]&=~(1<<LED_ERROR);
;    2452 		}
;    2453 	else
;    2454 		{
;    2455 		ind_out[4]|=(1<<LED_ERROR);
;    2456 		} */
;    2457 
;    2458 //if(bERR)ind_out[4]&=~(1<<LED_ERROR);
;    2459 if(ee_vacuum_mode==evmON)ind_out[4]&=~(1<<LED_VACUUM);
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0xD3
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0x7F
	POP  R26
	POP  R27
	RJMP _0x131
;    2460 else ind_out[4]|=(1<<LED_VACUUM);
_0xD3:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x80
	POP  R26
	POP  R27
_0x131:
	ST   X,R30
;    2461 
;    2462 if(prog==p1) ind_out[4]&=~(1<<LED_PROG1);
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0xD5
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xEF
	POP  R26
	POP  R27
	ST   X,R30
;    2463 else if(prog==p2) ind_out[4]&=~(1<<LED_PROG2);
	RJMP _0xD6
_0xD5:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0xD7
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFB
	POP  R26
	POP  R27
	ST   X,R30
;    2464 else if(prog==p3) ind_out[4]&=~(1<<LED_PROG3);
	RJMP _0xD8
_0xD7:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0xD9
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0XF7
	POP  R26
	POP  R27
	ST   X,R30
;    2465 else if(prog==p4) ind_out[4]&=~(1<<LED_PROG4);
	RJMP _0xDA
_0xD9:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0xDB
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFD
	POP  R26
	POP  R27
	ST   X,R30
;    2466 
;    2467 if(ind==iPr_sel)
_0xDB:
_0xDA:
_0xD8:
_0xD6:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0xDC
;    2468 	{
;    2469 	if(bFL5)ind_out[4]|=(1<<LED_PROG1)|(1<<LED_PROG2)|(1<<LED_PROG3)|(1<<LED_PROG4);
	SBRS R3,0
	RJMP _0xDD
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,LOW(0x1E)
	POP  R26
	POP  R27
	ST   X,R30
;    2470 	} 
_0xDD:
;    2471 	 
;    2472 if(ind==iVr)
_0xDC:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0xDE
;    2473 	{
;    2474 	if(bFL5)ind_out[4]|=(1<<LED_POW_ON);
	SBRS R3,0
	RJMP _0xDF
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x20
	POP  R26
	POP  R27
	ST   X,R30
;    2475 	}	
_0xDF:
;    2476 }
_0xDE:
	RET
;    2477 
;    2478 //-----------------------------------------------
;    2479 // Подпрограмма драйва до 7 кнопок одного порта, 
;    2480 // различает короткое и длинное нажатие,
;    2481 // срабатывает на отпускание кнопки, возможность
;    2482 // ускорения перебора при длинном нажатии...
;    2483 #define but_port PORTC
;    2484 #define but_dir  DDRC
;    2485 #define but_pin  PINC
;    2486 #define but_mask 0b01101010
;    2487 #define no_but   0b11111111
;    2488 #define but_on   5
;    2489 #define but_onL  20
;    2490 
;    2491 
;    2492 
;    2493 
;    2494 void but_drv(void)
;    2495 { 
_but_drv:
;    2496 DDRD&=0b00000111;
	IN   R30,0x11
	ANDI R30,LOW(0x7)
	CALL SUBOPT_0xB
;    2497 PORTD|=0b11111000;
;    2498 
;    2499 but_port|=(but_mask^0xff);
	CALL SUBOPT_0xC
;    2500 but_dir&=but_mask;
;    2501 #asm
;    2502 nop
nop
;    2503 nop
nop
;    2504 nop
nop
;    2505 nop
nop
;    2506 #endasm

;    2507 
;    2508 but_n=but_pin|but_mask; 
	IN   R30,0x13
	ORI  R30,LOW(0x6A)
	STS  _but_n_G1,R30
;    2509 
;    2510 if((but_n==no_but)||(but_n!=but_s))
	LDS  R26,_but_n_G1
	CPI  R26,LOW(0xFF)
	BREQ _0xE1
	RCALL SUBOPT_0xD
	BREQ _0xE0
_0xE1:
;    2511  	{
;    2512  	speed=0;
	CLT
	BLD  R2,6
;    2513    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRSH _0xE4
	LDS  R26,_but1_cnt_G1
	CPI  R26,LOW(0x0)
	BREQ _0xE6
_0xE4:
	SBRS R2,4
	RJMP _0xE7
_0xE6:
	RJMP _0xE3
_0xE7:
;    2514   		{
;    2515    	     n_but=1;
	SET
	BLD  R2,5
;    2516           but=but_s;
	LDS  R9,_but_s_G1
;    2517           }
;    2518    	if (but1_cnt>=but_onL_temp)
_0xE3:
	RCALL SUBOPT_0xE
	BRLO _0xE8
;    2519   		{
;    2520    	     n_but=1;
	SET
	BLD  R2,5
;    2521           but=but_s&0b11111101;
	RCALL SUBOPT_0xF
;    2522           }
;    2523     	l_but=0;
_0xE8:
	CLT
	BLD  R2,4
;    2524    	but_onL_temp=but_onL;
	LDI  R30,LOW(20)
	STS  _but_onL_temp_G1,R30
;    2525     	but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    2526   	but1_cnt=0;          
	STS  _but1_cnt_G1,R30
;    2527      goto but_drv_out;
	RJMP _0xE9
;    2528   	}  
;    2529   	
;    2530 if(but_n==but_s)
_0xE0:
	RCALL SUBOPT_0xD
	BRNE _0xEA
;    2531  	{
;    2532   	but0_cnt++;
	LDS  R30,_but0_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but0_cnt_G1,R30
;    2533   	if(but0_cnt>=but_on)
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRLO _0xEB
;    2534   		{
;    2535    		but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    2536    		but1_cnt++;
	LDS  R30,_but1_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but1_cnt_G1,R30
;    2537    		if(but1_cnt>=but_onL_temp)
	RCALL SUBOPT_0xE
	BRLO _0xEC
;    2538    			{              
;    2539     			but=but_s&0b11111101;
	RCALL SUBOPT_0xF
;    2540     			but1_cnt=0;
	LDI  R30,LOW(0)
	STS  _but1_cnt_G1,R30
;    2541     			n_but=1;
	SET
	BLD  R2,5
;    2542     			l_but=1;
	SET
	BLD  R2,4
;    2543 			if(speed)
	SBRS R2,6
	RJMP _0xED
;    2544 				{
;    2545     				but_onL_temp=but_onL_temp>>1;
	LDS  R30,_but_onL_temp_G1
	LSR  R30
	STS  _but_onL_temp_G1,R30
;    2546         			if(but_onL_temp<=2) but_onL_temp=2;
	LDS  R26,_but_onL_temp_G1
	LDI  R30,LOW(2)
	CP   R30,R26
	BRLO _0xEE
	STS  _but_onL_temp_G1,R30
;    2547 				}    
_0xEE:
;    2548    			}
_0xED:
;    2549   		} 
_0xEC:
;    2550  	}
_0xEB:
;    2551 but_drv_out:
_0xEA:
_0xE9:
;    2552 but_s=but_n;
	LDS  R30,_but_n_G1
	STS  _but_s_G1,R30
;    2553 but_port|=(but_mask^0xff);
	RCALL SUBOPT_0xC
;    2554 but_dir&=but_mask;
;    2555 }    
	RET
;    2556 
;    2557 #define butV	239
;    2558 #define butV_	237
;    2559 #define butP	251
;    2560 #define butP_	249
;    2561 #define butR	127
;    2562 #define butR_	125
;    2563 #define butL	254
;    2564 #define butL_	252
;    2565 #define butLR	126
;    2566 #define butLR_	124 
;    2567 #define butVP_ 233
;    2568 //-----------------------------------------------
;    2569 void but_an(void)
;    2570 {
_but_an:
;    2571 
;    2572 if(!(in_word&0x01))
	SBRC R14,0
	RJMP _0xEF
;    2573 	{
;    2574 	#ifdef TVIST_SKO
;    2575 	if((step==sOFF)&&(!bERR))
;    2576 		{
;    2577 		step=s1;
;    2578 		if(prog==p2) cnt_del=70;
;    2579 		else if(prog==p3) cnt_del=100;
;    2580 		}
;    2581 	#endif
;    2582 	#ifdef DV3KL2MD
;    2583 	if((step==sOFF)&&(!bERR))
;    2584 		{
;    2585 		step=s1;
;    2586 		cnt_del=70;
;    2587 		}
;    2588 	#endif	
;    2589 	#ifndef TVIST_SKO
;    2590 	if((step==sOFF)&&(!bERR))
	LDI  R30,LOW(0)
	CP   R30,R11
	BRNE _0xF1
	SBRS R3,1
	RJMP _0xF2
_0xF1:
	RJMP _0xF0
_0xF2:
;    2591 		{
;    2592 		step=s1;
	LDI  R30,LOW(1)
	MOV  R11,R30
;    2593 		if(prog==p1) cnt_del=50;
	CP   R30,R10
	BRNE _0xF3
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2594 		else if(prog==p2) cnt_del=50;
	RJMP _0xF4
_0xF3:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0xF5
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2595 		else if(prog==p3) cnt_del=50;
	RJMP _0xF6
_0xF5:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0xF7
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
;    2596           #ifdef P380_MINI
;    2597   		cnt_del=100;
;    2598   		#endif
;    2599 		}
_0xF7:
_0xF6:
_0xF4:
;    2600 	#endif
;    2601 	}
_0xF0:
;    2602 if(!(in_word&0x02))
_0xEF:
	SBRC R14,1
	RJMP _0xF8
;    2603 	{
;    2604 	step=sOFF;
	CLR  R11
;    2605 
;    2606 	}
;    2607 
;    2608 if (!n_but) goto but_an_end;
_0xF8:
	SBRS R2,5
	RJMP _0xFA
;    2609 
;    2610 if(but==butV_)
	LDI  R30,LOW(237)
	CP   R30,R9
	BRNE _0xFB
;    2611 	{
;    2612 	if(ee_vacuum_mode==evmON)ee_vacuum_mode=evmOFF;
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0xFC
	LDI  R30,LOW(170)
	RJMP _0x132
;    2613 	else ee_vacuum_mode=evmON;
_0xFC:
	LDI  R30,LOW(85)
_0x132:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMWRB
;    2614 	}
;    2615 
;    2616 if(but==butVP_)
_0xFB:
	LDI  R30,LOW(233)
	CP   R30,R9
	BRNE _0xFE
;    2617 	{
;    2618 	if(ind!=iVr)ind=iVr;
	LDI  R30,LOW(2)
	CP   R30,R12
	BREQ _0xFF
	MOV  R12,R30
;    2619 	else ind=iMn;
	RJMP _0x100
_0xFF:
	CLR  R12
_0x100:
;    2620 	}
;    2621 
;    2622 	
;    2623 if(ind==iMn)
_0xFE:
	TST  R12
	BRNE _0x101
;    2624 	{
;    2625 	if(but==butP_)ind=iPr_sel;
	LDI  R30,LOW(249)
	CP   R30,R9
	BRNE _0x102
	LDI  R30,LOW(1)
	MOV  R12,R30
;    2626 	if(but==butLR)	
_0x102:
	LDI  R30,LOW(126)
	CP   R30,R9
	BRNE _0x103
;    2627 		{
;    2628 		if((prog==p3)||(prog==p4))
	LDI  R30,LOW(3)
	CP   R30,R10
	BREQ _0x105
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0x104
_0x105:
;    2629 			{ 
;    2630 			if(sub_ind==0)sub_ind=1;
	TST  R13
	BRNE _0x107
	LDI  R30,LOW(1)
	MOV  R13,R30
;    2631 			else sub_ind=0;
	RJMP _0x108
_0x107:
	CLR  R13
_0x108:
;    2632 			}
;    2633     		else sub_ind=0;
	RJMP _0x109
_0x104:
	CLR  R13
_0x109:
;    2634 		}	 
;    2635 	if((but==butR)||(but==butR_))	
_0x103:
	LDI  R30,LOW(127)
	CP   R30,R9
	BREQ _0x10B
	LDI  R30,LOW(125)
	CP   R30,R9
	BRNE _0x10A
_0x10B:
;    2636 		{  
;    2637 		speed=1;
	SET
	BLD  R2,6
;    2638 		ee_delay[prog,sub_ind]++;
	RCALL SUBOPT_0xA
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    2639 		}   
;    2640 	
;    2641 	else if((but==butL)||(but==butL_))	
	RJMP _0x10D
_0x10A:
	LDI  R30,LOW(254)
	CP   R30,R9
	BREQ _0x10F
	LDI  R30,LOW(252)
	CP   R30,R9
	BRNE _0x10E
_0x10F:
;    2642 		{  
;    2643     		speed=1;
	SET
	BLD  R2,6
;    2644     		ee_delay[prog,sub_ind]--;
	RCALL SUBOPT_0xA
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    2645     		}		
;    2646 	} 
_0x10E:
_0x10D:
;    2647 	
;    2648 else if(ind==iPr_sel)
	RJMP _0x111
_0x101:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x112
;    2649 	{
;    2650 	if(but==butP_)ind=iMn;
	LDI  R30,LOW(249)
	CP   R30,R9
	BRNE _0x113
	CLR  R12
;    2651 	if(but==butP)
_0x113:
	LDI  R30,LOW(251)
	CP   R30,R9
	BRNE _0x114
;    2652 		{
;    2653 		prog++;
	RCALL SUBOPT_0x10
;    2654 		if(prog>MAXPROG)prog=MINPROG;
	BRGE _0x115
	LDI  R30,LOW(1)
	MOV  R10,R30
;    2655 		ee_program[0]=prog;
_0x115:
	RCALL SUBOPT_0x11
;    2656 		ee_program[1]=prog;
	__POINTW2MN _ee_program,1
	MOV  R30,R10
	CALL __EEPROMWRB
;    2657 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R10
	CALL __EEPROMWRB
;    2658 		}
;    2659 	
;    2660 	if(but==butR)
_0x114:
	LDI  R30,LOW(127)
	CP   R30,R9
	BRNE _0x116
;    2661 		{
;    2662 		prog++;
	RCALL SUBOPT_0x10
;    2663 		if(prog>MAXPROG)prog=MINPROG;
	BRGE _0x117
	LDI  R30,LOW(1)
	MOV  R10,R30
;    2664 		ee_program[0]=prog;
_0x117:
	RCALL SUBOPT_0x11
;    2665 		ee_program[1]=prog;
	__POINTW2MN _ee_program,1
	MOV  R30,R10
	CALL __EEPROMWRB
;    2666 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R10
	CALL __EEPROMWRB
;    2667 		}
;    2668 
;    2669 	if(but==butL)
_0x116:
	LDI  R30,LOW(254)
	CP   R30,R9
	BRNE _0x118
;    2670 		{
;    2671 		prog--;
	DEC  R10
;    2672 		if(prog>MAXPROG)prog=MINPROG;
	LDI  R30,LOW(4)
	CP   R30,R10
	BRGE _0x119
	LDI  R30,LOW(1)
	MOV  R10,R30
;    2673 		ee_program[0]=prog;
_0x119:
	RCALL SUBOPT_0x11
;    2674 		ee_program[1]=prog;
	__POINTW2MN _ee_program,1
	MOV  R30,R10
	CALL __EEPROMWRB
;    2675 		ee_program[2]=prog;
	__POINTW2MN _ee_program,2
	MOV  R30,R10
	CALL __EEPROMWRB
;    2676 		}	
;    2677 	} 
_0x118:
;    2678 
;    2679 else if(ind==iVr)
	RJMP _0x11A
_0x112:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x11B
;    2680 	{
;    2681 	if(but==butP_)
	LDI  R30,LOW(249)
	CP   R30,R9
	BRNE _0x11C
;    2682 		{
;    2683 		if(ee_vr_log)ee_vr_log=0;
	LDI  R26,LOW(_ee_vr_log)
	LDI  R27,HIGH(_ee_vr_log)
	CALL __EEPROMRDB
	CPI  R30,0
	BREQ _0x11D
	LDI  R30,LOW(0)
	RJMP _0x133
;    2684 		else ee_vr_log=1;
_0x11D:
	LDI  R30,LOW(1)
_0x133:
	LDI  R26,LOW(_ee_vr_log)
	LDI  R27,HIGH(_ee_vr_log)
	CALL __EEPROMWRB
;    2685 		}	
;    2686 	} 	
_0x11C:
;    2687 
;    2688 but_an_end:
_0x11B:
_0x11A:
_0x111:
_0xFA:
;    2689 n_but=0;
	CLT
	BLD  R2,5
;    2690 }
	RET
;    2691 
;    2692 //-----------------------------------------------
;    2693 void ind_drv(void)
;    2694 {
_ind_drv:
;    2695 if(++ind_cnt>=6)ind_cnt=0;
	INC  R8
	LDI  R30,LOW(6)
	CP   R8,R30
	BRLO _0x11F
	CLR  R8
;    2696 
;    2697 if(ind_cnt<5)
_0x11F:
	LDI  R30,LOW(5)
	CP   R8,R30
	BRSH _0x120
;    2698 	{
;    2699 	DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
;    2700 	PORTC=0xFF;
	OUT  0x15,R30
;    2701 	DDRD|=0b11111000;
	IN   R30,0x11
	ORI  R30,LOW(0xF8)
	RCALL SUBOPT_0xB
;    2702 	PORTD|=0b11111000;
;    2703 	PORTD&=IND_STROB[ind_cnt];
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
;    2704 	PORTC=ind_out[ind_cnt];
	MOV  R30,R8
	LDI  R31,0
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	LD   R30,Z
	OUT  0x15,R30
;    2705 	}
;    2706 else but_drv();
	RJMP _0x121
_0x120:
	CALL _but_drv
_0x121:
;    2707 }
	RET
;    2708 
;    2709 //***********************************************
;    2710 //***********************************************
;    2711 //***********************************************
;    2712 //***********************************************
;    2713 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;    2714 {
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
;    2715 TCCR0=0x02;
	RCALL SUBOPT_0x12
;    2716 TCNT0=-208;
;    2717 OCR0=0x00; 
;    2718 
;    2719 
;    2720 b600Hz=1;
	SET
	BLD  R2,0
;    2721 ind_drv();
	RCALL _ind_drv
;    2722 if(++t0_cnt0>=6)
	INC  R4
	LDI  R30,LOW(6)
	CP   R4,R30
	BRLO _0x122
;    2723 	{
;    2724 	t0_cnt0=0;
	CLR  R4
;    2725 	b100Hz=1;
	SET
	BLD  R2,1
;    2726 	}
;    2727 
;    2728 if(++t0_cnt1>=60)
_0x122:
	INC  R5
	LDI  R30,LOW(60)
	CP   R5,R30
	BRLO _0x123
;    2729 	{
;    2730 	t0_cnt1=0;
	CLR  R5
;    2731 	b10Hz=1;
	SET
	BLD  R2,2
;    2732 	
;    2733 	if(++t0_cnt2>=2)
	INC  R6
	LDI  R30,LOW(2)
	CP   R6,R30
	BRLO _0x124
;    2734 		{
;    2735 		t0_cnt2=0;
	CLR  R6
;    2736 		bFL5=!bFL5;
	LDI  R30,LOW(1)
	EOR  R3,R30
;    2737 		}
;    2738 		
;    2739 	if(++t0_cnt3>=5)
_0x124:
	INC  R7
	LDI  R30,LOW(5)
	CP   R7,R30
	BRLO _0x125
;    2740 		{
;    2741 		t0_cnt3=0;
	CLR  R7
;    2742 		bFL2=!bFL2;
	LDI  R30,LOW(128)
	EOR  R2,R30
;    2743 		}		
;    2744 	}
_0x125:
;    2745 }
_0x123:
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
;    2746 
;    2747 //===============================================
;    2748 //===============================================
;    2749 //===============================================
;    2750 //===============================================
;    2751 
;    2752 void main(void)
;    2753 {
_main:
;    2754 
;    2755 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
;    2756 DDRA=0x00;
	RCALL SUBOPT_0x0
;    2757 
;    2758 PORTB=0xff;
	RCALL SUBOPT_0x13
;    2759 DDRB=0xFF;
;    2760 
;    2761 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;    2762 DDRC=0x00;
	OUT  0x14,R30
;    2763 
;    2764 
;    2765 PORTD=0x00;
	OUT  0x12,R30
;    2766 DDRD=0x00;
	OUT  0x11,R30
;    2767 
;    2768 
;    2769 TCCR0=0x02;
	RCALL SUBOPT_0x12
;    2770 TCNT0=-208;
;    2771 OCR0=0x00;
;    2772 
;    2773 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;    2774 TCCR1B=0x00;
	OUT  0x2E,R30
;    2775 TCNT1H=0x00;
	OUT  0x2D,R30
;    2776 TCNT1L=0x00;
	OUT  0x2C,R30
;    2777 ICR1H=0x00;
	OUT  0x27,R30
;    2778 ICR1L=0x00;
	OUT  0x26,R30
;    2779 OCR1AH=0x00;
	OUT  0x2B,R30
;    2780 OCR1AL=0x00;
	OUT  0x2A,R30
;    2781 OCR1BH=0x00;
	OUT  0x29,R30
;    2782 OCR1BL=0x00;
	OUT  0x28,R30
;    2783 
;    2784 
;    2785 ASSR=0x00;
	OUT  0x22,R30
;    2786 TCCR2=0x00;
	OUT  0x25,R30
;    2787 TCNT2=0x00;
	OUT  0x24,R30
;    2788 OCR2=0x00;
	OUT  0x23,R30
;    2789 
;    2790 MCUCR=0x00;
	OUT  0x35,R30
;    2791 MCUCSR=0x00;
	OUT  0x34,R30
;    2792 
;    2793 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;    2794 
;    2795 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;    2796 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;    2797 
;    2798 #asm("sei") 
	sei
;    2799 PORTB=0xFF;
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x13
;    2800 DDRB=0xFF;
;    2801 DDRD.1=1;
	SBI  0x11,1
;    2802 PORTD.1=1;  
	SBI  0x12,1
;    2803 
;    2804 ind=iMn;
	CLR  R12
;    2805 prog_drv();
	CALL _prog_drv
;    2806 ind_hndl();
	CALL _ind_hndl
;    2807 led_hndl();
	CALL _led_hndl
;    2808 while (1)
_0x126:
;    2809       {
;    2810       if(b600Hz)
	SBRS R2,0
	RJMP _0x129
;    2811 		{
;    2812 		b600Hz=0; 
	CLT
	BLD  R2,0
;    2813           
;    2814 		}         
;    2815       if(b100Hz)
_0x129:
	SBRS R2,1
	RJMP _0x12A
;    2816 		{        
;    2817 		b100Hz=0; 
	CLT
	BLD  R2,1
;    2818 		but_an();
	RCALL _but_an
;    2819 	    	in_drv();
	CALL _in_drv
;    2820           mdvr_drv();
	CALL _mdvr_drv
;    2821           step_contr();
	CALL _step_contr
;    2822 		}   
;    2823 	if(b10Hz)
_0x12A:
	SBRS R2,2
	RJMP _0x12B
;    2824 		{
;    2825 		b10Hz=0;
	CLT
	BLD  R2,2
;    2826 		prog_drv();
	CALL _prog_drv
;    2827 		err_drv();
	CALL _err_drv
;    2828 		
;    2829     	     ind_hndl();
	CALL _ind_hndl
;    2830           led_hndl();
	CALL _led_hndl
;    2831           
;    2832           }
;    2833 
;    2834       };
_0x12B:
	RJMP _0x126
;    2835 }
_0x12C:
	RJMP _0x12C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	LDI  R30,LOW(255)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES
SUBOPT_0x1:
	LDS  R30,_cnt_del
	LDS  R31,_cnt_del+1
	SBIW R30,1
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x2:
	MOV  R11,R30
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x3:
	MOV  R11,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4:
	MOV  R11,R30
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x5:
	MOV  R11,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6:
	MOV  R11,R30
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
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

