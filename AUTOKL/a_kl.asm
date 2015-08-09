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
;8 bit enums         : No
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

	.INCLUDE "a_kl.vec"
	.INCLUDE "a_kl.inc"

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
	.DB  0 ; FIRST EEPROM LOCATION NOT USED, SEE ATMEL ERRATA SHEETS

	.DSEG
	.ORG 0x260
;       1 #define CH1_ON		DDRC.2=1;PORTC.2=1;
;       2 #define CH1_OFF	DDRC.2=1;PORTC.2=0;
;       3 
;       4 #define CH2_ON		DDRC.3=1;PORTC.3=1;
;       5 #define CH2_OFF	DDRC.3=1;PORTC.3=0;
;       6 
;       7 #define CH3_ON		DDRC.0=1;PORTC.0=1;
;       8 #define CH3_OFF	DDRC.0=1;PORTC.0=0;
;       9 
;      10 #define CH4_ON		DDRC.1=1;PORTC.1=1;
;      11 #define CH4_OFF	DDRC.1=1;PORTC.1=0;
;      12 
;      13 #define LCD_SIZE 40
;      14 
;      15 #include <mega32.h>
;      16 #include <delay.h>
;      17 #include <stdio.h> 
;      18 #include <Lcd_4+2.h>
;      19 #include <spi.h>
;      20 #include <math.h>    
;      21 #include "gran.c"
;      22 //-----------------------------------------------
;      23 void gran_ring_char(signed char *adr, signed char min, signed char max)
;      24 {

	.CSEG
;      25 if (*adr<min) *adr=max;
;      26 if (*adr>max) *adr=min; 
;      27 } 
;      28  
;      29 //-----------------------------------------------
;      30 void gran_char(signed char *adr, signed char min, signed char max)
;      31 {
_gran_char:
;      32 if (*adr<min) *adr=min;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R26,X
	LDD  R30,Y+1
	CP   R26,R30
	BRGE _0x5
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
;      33 if (*adr>max) *adr=max; 
_0x5:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R26,X
	LD   R30,Y
	CP   R30,R26
	BRGE _0x6
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
;      34 } 
_0x6:
	ADIW R28,4
	RET
;      35 
;      36 //-----------------------------------------------
;      37 void gran_char_ee(eeprom signed char  *adr, signed char min, signed char max)
;      38 {
;      39 if (*adr<min) *adr=min;
;      40 if (*adr>max) *adr=max; 
;      41 }
;      42 
;      43 //-----------------------------------------------
;      44 void gran_ring(signed int *adr, signed int min, signed int max)
;      45 {
;      46 if (*adr<min) *adr=max;
;      47 if (*adr>max) *adr=min; 
;      48 } 
;      49 
;      50 //-----------------------------------------------
;      51 void gran_ring_ee(eeprom signed int *adr, signed int min, signed int max)
;      52 {
;      53 if (*adr<min) *adr=max;
;      54 if (*adr>max) *adr=min; 
;      55 } 
;      56 //-----------------------------------------------
;      57 void gran(signed int *adr, signed int min, signed int max)
;      58 {
_gran:
;      59 if (*adr<min) *adr=min;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	CALL SUBOPT_0x0
	BRGE _0xD
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X+,R30
	ST   X,R31
;      60 if (*adr>max) *adr=max; 
_0xD:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	CALL SUBOPT_0x1
	BRGE _0xE
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X+,R30
	ST   X,R31
;      61 } 
_0xE:
	RJMP _0x25C
;      62 
;      63 
;      64 //-----------------------------------------------
;      65 void gran_ee(eeprom signed int  *adr, signed int min, signed int max)
;      66 {
_gran_ee:
;      67 if (*adr<min) *adr=min;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __EEPROMRDW
	CALL SUBOPT_0x0
	BRGE _0xF
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __EEPROMWRW
;      68 if (*adr>max) *adr=max; 
_0xF:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __EEPROMRDW
	CALL SUBOPT_0x1
	BRGE _0x10
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __EEPROMWRW
;      69 }
_0x10:
_0x25C:
	ADIW R28,6
	RET
;      70 #include "ruslcd.c"
;      71 #ifndef  _rus_lcd_INCLUDED_
;      72 #define _rus_lcd_INCLUDED_ 
;      73 /*  ТАБЛИЦА СООТВЕТСТВИЯ
;      74 Число	Символ	Число	Символ	Число	Символ	Число	Символ	ЧислоСимвол
;      75 33	!	34	"	35	#	36	$	37	%
;      76 38	&	39	'	40	(	41	)	42	*
;      77 43	+	44	,	45	-	46	.	47	/
;      78 48	0	49	1	50	2	51	3	52	4
;      79 53	5	54	6	55	7	56	8	57	9
;      80 58	:	59	;	60	<	61	=	62	>
;      81 63	?	64	@	65	A	66	B	67	C
;      82 68	D	69	E	70	F	71	G	72	H
;      83 73	I	74	J	75	K	76	L	77	M
;      84 78	N	79	O	80	P	81	Q	82	R
;      85 83	S	84	T	85	U	86	V	87	W
;      86 88	X	89	Y	90	Z	91	[	92	\
;      87 93	]	94	^	95	_	96	`	97	a
;      88 98	b	99	c	100	d	101	e	102	f
;      89 103	g	104	h	105	I	106	j	107	k
;      90 108	l	109	m	110	n	111	o	112	p
;      91 113	q	114	r	115	s	116	t	117	u
;      92 118	v	119	w	120	x	121	y	122	z
;      93 123	{	124	|	125	}	126	~	132	"
;      94 133	…	145	'	146	'	147	"	148	"
;      95 149	o	150	-	151	-	153	™	166	¦
;      96 167	§	168	Ё	169	©	171	"	172	   
;      97 174	®	176	°	177	±	178	І	179	і
;      98 182		183	·	184	ё	185	№	187	"
;      99 192	А	193	Б	194	В	195	Г	196	Д
;     100 197	Е	198	Ж	199	З	200	И	201	Й
;     101 202	К	203	Л	204	М	205	Н	206	О
;     102 207	П	208	Р	209	С	210	Т	211	У
;     103 212	Ф	213	Х	214	Ц	215	Ч	216	Ш
;     104 217	Щ	218	Ъ	219	Ы	220	Ь	221	Э
;     105 222	Ю	223	Я	224	а	225	б	226	в
;     106 227	г	228	д	229	е	230	ж	231	з
;     107 232	и	233	й	234	к	235	л	236	м
;     108 237	н	238	о	239	п	240	р	241	с
;     109 242	т	243	у	244	ф	245	х	246	ц
;     110 247	ч	248	ш	249	щ	250	ъ	251	ы
;     111 252	ь	253	э	254	ю	255	я	-	-
;     112 */
;     113 const unsigned char rus_buff[]={                             // код буквы 
;     114 0xFD,0xa2,255 ,                                     //167-169
;     115 170 ,0xc8,172 ,173 ,174 ,175 ,176 ,177 ,0xd7,0x69,  //170-179
;     116 180 ,181 ,0xfe,0xdf,0xb5,0xcc,186 ,0xc9,188 ,189 ,  //180-189
;     117 190 ,191 ,0x41,0xa0,0x42,0xa1,0xe0,0x45,0xa3,0xa4,  //190-199
;     118 0xa5,0xa6,0x4b,0xa7,0x4d,0x48,0x4f,0xa8,0x50,0x43,  //200-209
;     119 0x54,0xa9,0xaa,0x58,0xe1,0xab,0xac,0xe2,0xad,0xae,  //210-219
;     120 0xc4,0xaf,0xb0,0xb1,0x61,0xb2,0xb3,0xb4,0xe3,0x65,  //220-229
;     121 0xb6,0xb7,0xb8,0xb9,0xba,0xbb,0xbc,0xbd,0x6f,0xbe,  //230-239
;     122 0x70,0x63,0xbf,0x79,0xaa,0x78,0xe5,0xc0,0xc1,0xe6,  //240-249
;     123 0xc2,0xc3,0xc4,0xc5,0xc6,0xc7};                     //250-255
;     124 //преобразование массива начинается с 167 символа
;     125 //десятичные цифры в буфере-это те символы, которые невозможно отображать на ЖКИ. 
;     126 //Их можно назначить по своему усмотрению.
;     127 //Например, сейчас (см выше) набрав на клавиатуре @ (код 169) на ЖКИ будет отображаться 
;     128 //чёрное знакоместо (код 0хFF (255десятичн.) )
;     129 /*
;     130 @- 0хFF
;     131 
;     132 */
;     133 void ruslcd (unsigned char *buff){
_ruslcd:
;     134 unsigned char i;
;     135 i=0;
	SBIW R28,1
;	*buff -> Y+1
;	i -> Y+0
	LDI  R30,LOW(0)
	ST   Y,R30
;     136 while ( buff[i]!=0 ) {
_0x11:
	CALL SUBOPT_0x2
	LD   R30,X
	CPI  R30,0
	BREQ _0x13
;     137 	if(buff[i]>166) buff[i]=rus_buff[buff[i]-167];
	CALL SUBOPT_0x2
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
	CALL SUBOPT_0x2
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
;     138 	i=i+1;}
_0x14:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x11
_0x13:
;     139 	
;     140 /*	buff[0]=0x61;
;     141 	buff[1]=rus_buff[buff[1]-167];//0xb2;//rus_buff[buff[1]-167];
;     142 	buff[2]=0xb3;
;     143 	buff[3]=0xb4;*/
;     144 
;     145 }//end void  
	ADIW R28,3
	RET
;     146 #endif
;     147 #asm
;     148 	.equ __lcd_port=0x15
	.equ __lcd_port=0x15
;     149 	.equ __lcd_cntr_port=0x12
	.equ __lcd_cntr_port=0x12
;     150  	.equ __lcd_rs=6
 	.equ __lcd_rs=6
;     151   	.equ __lcd_en=7
  	.equ __lcd_en=7
;     152 #endasm 

;     153 
;     154 
;     155 //***********************************************
;     156 //Указатели
;     157 char 		*ptr_ram;

	.DSEG
_ptr_ram:
	.BYTE 0x2
;     158 int 			*ptr_ram_int;
_ptr_ram_int:
	.BYTE 0x2
;     159 char flash 	*ptr_flash;
_ptr_flash:
	.BYTE 0x2
;     160 int eeprom	*ptr_eeprom_int;
_ptr_eeprom_int:
	.BYTE 0x2
;     161 unsigned int 	*adc_out;
_adc_out:
	.BYTE 0x2
;     162 
;     163 bit b100Hz,b10Hz,b5Hz,b2Hz,b1Hz;
;     164 bit l_but;		//идет длинное нажатие на кнопку
;     165 bit n_but;          //произошло нажатие
;     166 bit speed;		//разрешение ускорения перебора
;     167 bit zero_on;
;     168 bit bit_minus;
;     169 bit bAB;
;     170 bit bAN;
;     171 bit bAS1;
;     172 bit bAS2;
;     173 bit bFL2;
;     174 bit bFL__;
;     175 bit bI;
;     176 
;     177 enum char {iMn,iMn_,iCh,iSet,iBat,iSrc,iS2,iSetprl,iKprl,iDnd,iK,
;     178 	iSpcprl,iSpc,Grdy,Prdy,Iwrk,Gwrk,Pwrk,k,Crash_0,Crash_1,iKednd,
;     179 	iLoad,iSpc_prl_vz,iDeb,iKe,iVz,iAVAR,iStr,iVrs,iTstprl,iTst,iDebug,iDefault,iSet_st_prl}ind;
;     180 
;     181 
;     182 
;     183 
;     184 flash char char0[8]=

	.CSEG
;     185 {
;     186 0b0001000,
;     187 0b0001100,
;     188 0b0001110,
;     189 0b0001111,
;     190 0b0001110,
;     191 0b0001100,
;     192 0b0001000,
;     193 0b0000000};
;     194 
;     195 flash char char1[8]=
;     196 {
;     197 0b0000110,
;     198 0b0001001,
;     199 0b0001001,
;     200 0b0000110,
;     201 0b0000000,
;     202 0b0000000,
;     203 0b0000000,
;     204 0b0000000};
;     205 
;     206 
;     207 flash char char2[8]=
;     208 {
;     209 0b00000,
;     210 0b00010,
;     211 0b00111,
;     212 0b01111,
;     213 0b11111,
;     214 0b11111,
;     215 0b01110,
;     216 0b00000};
;     217 
;     218 flash char char2_[8]=
;     219 {
;     220 0b00000,
;     221 0b00100,
;     222 0b01110,
;     223 0b11111,
;     224 0b11111,
;     225 0b11111,
;     226 0b01110,
;     227 0b00000};
;     228 
;     229 flash char char2__[8]=
;     230 {
;     231 0b00000,
;     232 0b01000,
;     233 0b11100,
;     234 0b11110,
;     235 0b11111,
;     236 0b11111,
;     237 0b01110,
;     238 0b00000};
;     239 
;     240 flash char char3[8]=
;     241 {
;     242 0b0000100,
;     243 0b0001110,
;     244 0b0011111,
;     245 0b0000000,
;     246 0b0000000,
;     247 0b0000000,
;     248 0b0000000,
;     249 0b0000000};
;     250 
;     251 flash char char4[8]=
;     252 {
;     253 0b00000,
;     254 0b00000,
;     255 0b01111,
;     256 0b01000,
;     257 0b01000,
;     258 0b01000,
;     259 0b01111,
;     260 0b00000};
;     261 
;     262 flash char char5[8]=
;     263 {
;     264 0b10000,
;     265 0b11000,
;     266 0b11111,
;     267 0b11001,
;     268 0b10001,
;     269 0b00001,
;     270 0b11111,
;     271 0b00000};
;     272 
;     273 
;     274 char but;
;     275 unsigned char parol[3];

	.DSEG
_parol:
	.BYTE 0x3
;     276 char dig[5];
_dig:
	.BYTE 0x5
;     277 
;     278 char adc_cnt,adc_cnt1;
;     279 
;     280 enum {tstOFF,tstON,tstU} tst_state[10];
_tst_state:
	.BYTE 0x14
;     281 
;     282 
;     283 
;     284 signed char sub_ind,sub_ind1,index_set;
;     285 
;     286 char cnt_ibat,cnt_ubat;
_cnt_ubat:
	.BYTE 0x1
;     287 unsigned Fnet;
_Fnet:
	.BYTE 0x2
;     288 bit bFF,bFF_;
;     289 int Hz_out,Hz_cnt;
_Hz_out:
	.BYTE 0x2
_Hz_cnt:
	.BYTE 0x2
;     290 char t0cnt0_;
_t0cnt0_:
	.BYTE 0x1
;     291 unsigned long cnt_vz_sec,cnt_vz_sec_; 
_cnt_vz_sec:
	.BYTE 0x4
_cnt_vz_sec_:
	.BYTE 0x4
;     292 signed zar_cnt;
_zar_cnt:
	.BYTE 0x2
;     293 char cnt_ind;
_cnt_ind:
	.BYTE 0x1
;     294 
;     295 char sound_pic,sound_tic,sound_cnt;
_sound_pic:
	.BYTE 0x1
_sound_tic:
	.BYTE 0x1
_sound_cnt:
	.BYTE 0x1
;     296 unsigned int av_beep,av_rele,av_stat;
_av_beep:
	.BYTE 0x2
_av_rele:
	.BYTE 0x2
_av_stat:
	.BYTE 0x2
;     297 //0 - сеть
;     298 //1 - батарея
;     299 //2 - ист1 больше
;     300 //3 - ист1 меньше
;     301 //4 - ист1 температура 
;     302 //5 - ист2 больше
;     303 //6 - ист3 меньше
;     304 //7 - ист4 температура 
;     305 
;     306 
;     307 char lcd_buffer[LCD_SIZE]={""};
_lcd_buffer:
	.BYTE 0x28
;     308 char dumm2[40];
_dumm2:
	.BYTE 0x28
;     309 char cnt_alias_blok;
_cnt_alias_blok:
	.BYTE 0x1
;     310 char star_cnt;
_star_cnt:
	.BYTE 0x1
;     311 
;     312 
;     313 
;     314 
;     315 
;     316 #include "ret.c"
;     317 char retind,retsub,retindsec;
_retind:
	.BYTE 0x1
_retsub:
	.BYTE 0x1
_retindsec:
	.BYTE 0x1
;     318 int retcnt,retcntsec;
_retcnt:
	.BYTE 0x2
_retcntsec:
	.BYTE 0x2
;     319 //-----------------------------------------------
;     320 void ret_ind(char r_i,char r_s,int r_c)
;     321 {

	.CSEG
;     322 retcnt=r_c;
;     323 retind=r_i;
;     324 retsub=r_s;
;     325 }    
;     326 
;     327 //-----------------------------------------------
;     328 void ret_ind_hndl(void)
;     329 {
_ret_ind_hndl:
;     330 if(retcnt)
	LDS  R30,_retcnt
	LDS  R31,_retcnt+1
	SBIW R30,0
	BREQ _0x15
;     331 	{
;     332 	if((--retcnt)==0)
	SBIW R30,1
	STS  _retcnt,R30
	STS  _retcnt+1,R31
	SBIW R30,0
	BRNE _0x16
;     333 		{
;     334  		ind=retind;
	LDS  R30,_retind
	LDI  R31,0
	__PUTW1R 6,7
;     335    		sub_ind=retsub;
	LDS  R11,_retsub
;     336    		index_set=sub_ind;
	MOV  R13,R11
;     337 	 	}
;     338      }
_0x16:
;     339 }  
_0x15:
	RET
;     340 
;     341 
;     342  
;     343 //---------------------------------------------
;     344 void ret_ind_sec(char r_i,int r_c)
;     345 {
;     346 retcntsec=r_c;
;     347 retindsec=r_i;
;     348 }
;     349 
;     350 //-----------------------------------------------
;     351 void ret_ind_sec_hndl(void)
;     352 {
;     353 if(retcntsec)
;     354  	{
;     355 	if((--retcntsec)==0)
;     356 	 	{
;     357  		ind=retindsec;
;     358  		sub_ind=0;
;     359 
;     360 	 	}
;     361    	}		
;     362 }   
;     363 
;     364 char bmm_cnt,bmp_cnt;

	.DSEG
_bmm_cnt:
	.BYTE 0x1
_bmp_cnt:
	.BYTE 0x1
;     365 bit bS=1;
;     366 eeprom signed int K_t[4]={1000,1050,1100,1150};

	.ESEG
_K_t:
	.DW  0x3E8,0x41A,0x44C,0x47E
;     367 eeprom signed int ee_wrk_time[4]={1000,1050,1100,1150};
_ee_wrk_time:
	.DW  0x3E8,0x41A,0x44C,0x47E
;     368 eeprom signed int ee_time_mode[4]={1000,1050,1100,1150}; 
_ee_time_mode:
	.DW  0x3E8,0x41A,0x44C,0x47E
;     369 eeprom enum {wsOFF,wsON}wrk_state[4]={wsOFF,wsOFF,wsOFF,wsOFF}; 
_wrk_state:
	.DW  0x0,0x0,0x0,0x0
;     370 eeprom signed int ee_wrk_time_cnt_5[4];
_ee_wrk_time_cnt_5:
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
;     371 eeprom signed int t_ust[4];
_t_ust:
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
;     372 signed int wrk_time_cnt[4]={0,0,0,0};

	.DSEG
_wrk_time_cnt:
	.BYTE 0x8
;     373 signed int wrk_time_cnt_sec[4]={0,0,0,0};
_wrk_time_cnt_sec:
	.BYTE 0x8
;     374 signed int wrk_time_cnt_flag[4]={0,0,0,0};
_wrk_time_cnt_flag:
	.BYTE 0x8
;     375 signed nakal_cnt;
_nakal_cnt:
	.BYTE 0x2
;     376 signed Un,In;
_Un:
	.BYTE 0x2
_In:
	.BYTE 0x2
;     377 eeprom unsigned char ee_pwm;

	.ESEG
_ee_pwm:
	.DB  0x0
;     378 //eeprom signed ee_nagrev_time,ee_wrk_time,ee_ostiv_time;
;     379 
;     380 signed wrk_cnt;

	.DSEG
_wrk_cnt:
	.BYTE 0x2
;     381 eeprom signed Ku,Ki;

	.ESEG
_Ku:
	.DW  0x0
_Ki:
	.DW  0x0
;     382 eeprom enum {im_1,im_2}ind_mode;
_ind_mode:
	.DW  0x0
;     383 eeprom signed TIME_ust[4];
_TIME_ust:
	.DW  0x0
	.DW  0x0
	.DW  0x0
	.DW  0x0
;     384 signed time_wrks[4]; 

	.DSEG
_time_wrks:
	.BYTE 0x8
;     385 char ind_cnt;
_ind_cnt:
	.BYTE 0x1
;     386 signed int temper[4]; 
_temper:
	.BYTE 0x8
;     387 
;     388 
;     389 flash signed int temper_table[21]={5102,5614,6156,6747,7368,

	.CSEG
;     390 							8028,
;     391 							8727,9466,10244,11062,11909,
;     392 							12805,13731,14696,15701,16745,
;     393 							17828,18942,20104,20961,22015};
;     394 
;     395 unsigned int adc_bank_[10];

	.DSEG
_adc_bank_:
	.BYTE 0x14
;     396 flash char const_of_adc[4]={0,3,2,1};

	.CSEG
;     397 char nd[4]={0,0,0,0}; 

	.DSEG
_nd:
	.BYTE 0x4
;     398 char out_st[4]={0,0,0,0};  
_out_st:
	.BYTE 0x4
;     399 char out_st_old[4]={0,0,0,0};
_out_st_old:
	.BYTE 0x4
;     400 char cnt_block[4]={0,0,0,0};
_cnt_block:
	.BYTE 0x4
;     401 char def_char_cnt; 
_def_char_cnt:
	.BYTE 0x1
;     402 
;     403 unsigned int adc_bank[10,4];
_adc_bank:
	.BYTE 0x50
;     404 char cnt_ind_nd; 
_cnt_ind_nd:
	.BYTE 0x1
;     405 //-----------------------------------------------
;     406 void start_process(char in)
;     407 {

	.CSEG
_start_process:
;     408 wrk_state[in]=wsON;
	CALL SUBOPT_0x3
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EEPROMWRW
;     409 if(ee_time_mode[in]==0)wrk_time_cnt_flag[in]=1;
	CALL SUBOPT_0x4
	CALL __EEPROMRDW
	SBIW R30,0
	BRNE _0x19
	CALL SUBOPT_0x5
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x25D
;     410 else wrk_time_cnt_flag[in]=0;
_0x19:
	CALL SUBOPT_0x5
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x25D:
	ST   X+,R30
	ST   X,R31
;     411 
;     412 wrk_time_cnt[in]=ee_wrk_time[in];
	CALL SUBOPT_0x6
	PUSH R31
	PUSH R30
	LD   R30,Y
	CALL SUBOPT_0x7
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
;     413 gran(&wrk_time_cnt[in],1,720);
	CALL SUBOPT_0x6
	CALL SUBOPT_0x8
	CALL _gran
;     414 wrk_time_cnt_sec[in]=120;
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
;     415 
;     416 ee_wrk_time_cnt_5[in]=wrk_time_cnt[in]; 
	CALL SUBOPT_0xB
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC
	CALL __GETW1P
	POP  R26
	POP  R27
	CALL __EEPROMWRW
;     417 
;     418 cnt_block[in]=0;
	CALL SUBOPT_0xD
	LDI  R30,LOW(0)
	ST   X,R30
;     419 }
	RJMP _0x25B
;     420 
;     421 //-----------------------------------------------
;     422 void stop_process(char in)
;     423 {
_stop_process:
;     424 wrk_state[in]=wsOFF; 
	CALL SUBOPT_0x3
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
;     425 
;     426 wrk_time_cnt[in]=0;
	CALL SUBOPT_0xC
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
;     427 wrk_time_cnt_sec[in]=0;
	CALL SUBOPT_0x9
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
;     428 }
	RJMP _0x25B
;     429 
;     430 //-----------------------------------------------
;     431 void restart_process(char in)
;     432 {
_restart_process:
;     433 if(wrk_state[in]==wsON)
	CALL SUBOPT_0x3
	CALL __EEPROMRDW
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1B
;     434 	{
;     435 	if(ee_time_mode[in]=0)wrk_time_cnt_flag[in]=1;
	CALL SUBOPT_0x4
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
	SBIW R30,0
	BREQ _0x1C
	CALL SUBOPT_0x5
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x25E
;     436 	else wrk_time_cnt_flag[in]=0;
_0x1C:
	CALL SUBOPT_0x5
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x25E:
	ST   X+,R30
	ST   X,R31
;     437 	
;     438 	wrk_time_cnt[in]=ee_wrk_time_cnt_5[in];
	CALL SUBOPT_0x6
	PUSH R31
	PUSH R30
	LD   R30,Y
	CALL SUBOPT_0xB
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
;     439 	wrk_time_cnt_sec[in]=120;
	CALL SUBOPT_0x9
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	ST   X+,R30
	ST   X,R31
;     440 	}
;     441 }
_0x1B:
	RJMP _0x25B
;     442 
;     443 //-----------------------------------------------
;     444 void wrk_process(char in)
;     445 {
_wrk_process:
;     446 if(cnt_block[in])cnt_block[in]--;
	CALL SUBOPT_0xE
	BREQ _0x1E
	CALL SUBOPT_0xD
	LD   R30,X
	SUBI R30,LOW(1)
	ST   X,R30
;     447 if(wrk_state[in]==wsON)
_0x1E:
	CALL SUBOPT_0x3
	CALL __EEPROMRDW
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1F
;     448 	{
;     449 	if(temper[in]<(t_ust[in]))
	CALL SUBOPT_0xF
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x10
	POP  R26
	POP  R27
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x20
;     450 		{
;     451 		if(!cnt_block[in])
	CALL SUBOPT_0xE
	BRNE _0x21
;     452 			{
;     453 			out_st[in]=1;
	CALL SUBOPT_0x11
	LDI  R30,LOW(1)
	ST   X,R30
;     454 			}
;     455 		}
_0x21:
;     456 	else if(temper[in]>=(t_ust[in]))
	RJMP _0x22
_0x20:
	CALL SUBOPT_0xF
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x10
	POP  R26
	POP  R27
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x23
;     457 		{
;     458 		if(!cnt_block[in])
	CALL SUBOPT_0xE
	BRNE _0x24
;     459 			{
;     460 			out_st[in]=0;
	CALL SUBOPT_0x11
	LDI  R30,LOW(0)
	ST   X,R30
;     461 			}
;     462 		wrk_time_cnt_flag[in]=1;
_0x24:
	CALL SUBOPT_0x5
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
;     463 		}		
;     464 	}
_0x23:
_0x22:
;     465 else out_st[in]=0; 
	RJMP _0x25
_0x1F:
	CALL SUBOPT_0x11
	LDI  R30,LOW(0)
	ST   X,R30
_0x25:
;     466 
;     467 if(out_st[in]!=out_st_old[in])cnt_block[in]=20;
	CALL SUBOPT_0x12
	PUSH R30
	CALL SUBOPT_0x13
	LD   R30,Z
	POP  R26
	CP   R30,R26
	BREQ _0x26
	CALL SUBOPT_0xD
	LDI  R30,LOW(20)
	ST   X,R30
;     468 
;     469 out_st_old[in]=out_st[in];
_0x26:
	CALL SUBOPT_0x13
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x12
	POP  R26
	POP  R27
	ST   X,R30
;     470 
;     471 
;     472 if((ee_time_mode[in]==0)||(wrk_time_cnt_flag[in]==1))
	CALL SUBOPT_0x4
	CALL __EEPROMRDW
	SBIW R30,0
	BREQ _0x28
	CALL SUBOPT_0x5
	CALL __GETW1P
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ _0x28
	RJMP _0x27
_0x28:
;     473 	{
;     474 	if(wrk_time_cnt_sec[in])
	CALL SUBOPT_0x9
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2A
;     475 		{
;     476 		wrk_time_cnt_sec[in]--;
	CALL SUBOPT_0x9
	CALL SUBOPT_0x14
;     477 		if(wrk_time_cnt_sec[in]==0)
	CALL SUBOPT_0x9
	CALL __GETW1P
	SBIW R30,0
	BRNE _0x2B
;     478 			{
;     479 			if(wrk_time_cnt[in])
	CALL SUBOPT_0xC
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2C
;     480 				{
;     481 				wrk_time_cnt_sec[in]=120;
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
;     482 				wrk_time_cnt[in]--;
	CALL SUBOPT_0x15
	CALL SUBOPT_0x14
;     483 				if((wrk_time_cnt[in]%5)==0)
	CALL SUBOPT_0xC
	CALL __GETW1P
	MOVW R26,R30
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __MODW21
	SBIW R30,0
	BRNE _0x2D
;     484 					{
;     485 					ee_wrk_time_cnt_5[in]=wrk_time_cnt[in];
	LD   R30,Y
	CALL SUBOPT_0xB
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC
	CALL __GETW1P
	POP  R26
	POP  R27
	CALL __EEPROMWRW
;     486 					} 
;     487 				if(wrk_time_cnt[in]==0)
_0x2D:
	CALL SUBOPT_0xC
	CALL __GETW1P
	SBIW R30,0
	BRNE _0x2E
;     488 					{
;     489 					
;     490 					}					
;     491 				}
_0x2E:
;     492 			else 
	RJMP _0x2F
_0x2C:
;     493 				{
;     494 				stop_process(in);
	LD   R30,Y
	ST   -Y,R30
	CALL _stop_process
;     495 				}
_0x2F:
;     496 			}
;     497 		}
_0x2B:
;     498 	}
_0x2A:
;     499 
;     500 }
_0x27:
_0x25B:
	ADIW R28,1
	RET
;     501 
;     502 //-----------------------------------------------
;     503 void out_drv(void)
;     504 {
_out_drv:
;     505 if(out_st[0])
	LDS  R30,_out_st
	CPI  R30,0
	BREQ _0x30
;     506 	{
;     507 	CH1_ON
	SBI  0x14,2
	SBI  0x15,2
;     508 	}
;     509 else 
	RJMP _0x31
_0x30:
;     510 	{
;     511 	CH1_OFF
	SBI  0x14,2
	CBI  0x15,2
;     512 	}	
_0x31:
;     513 	
;     514 if(out_st[1])
	__GETB1MN _out_st,1
	CPI  R30,0
	BREQ _0x32
;     515 	{
;     516 	CH2_ON
	SBI  0x14,3
	SBI  0x15,3
;     517 	}
;     518 else 
	RJMP _0x33
_0x32:
;     519 	{
;     520 	CH2_OFF
	SBI  0x14,3
	CBI  0x15,3
;     521 	}	
_0x33:
;     522 	
;     523 if(out_st[2])
	__GETB1MN _out_st,2
	CPI  R30,0
	BREQ _0x34
;     524 	{
;     525 	CH3_ON
	SBI  0x14,0
	SBI  0x15,0
;     526 	}
;     527 else 
	RJMP _0x35
_0x34:
;     528 	{
;     529 	CH3_OFF
	SBI  0x14,0
	CBI  0x15,0
;     530 	}	
_0x35:
;     531 	
;     532 if(out_st[3])
	__GETB1MN _out_st,3
	CPI  R30,0
	BREQ _0x36
;     533 	{
;     534 	CH4_ON
	SBI  0x14,1
	SBI  0x15,1
;     535 	}
;     536 else 
	RJMP _0x37
_0x36:
;     537 	{
;     538 	CH4_OFF
	SBI  0x14,1
	CBI  0x15,1
;     539 	}				
_0x37:
;     540 }
	RET
;     541 		
;     542 //-----------------------------------------------
;     543 void adc_drv(void)
;     544 {
_adc_drv:
;     545 char i;
;     546 char temp;
;     547 unsigned int tempUI,tempUI_;
;     548 
;     549 tempUI=ADCW;
	CALL __SAVELOCR6
;	i -> R16
;	temp -> R17
;	tempUI -> R18,R19
;	tempUI_ -> R20,R21
	__INWR 18,19,4
;     550 
;     551 for (i=0;i<4;i++)
	LDI  R16,LOW(0)
_0x39:
	CPI  R16,4
	BRSH _0x3A
;     552 	{
;     553 	adc_bank[adc_cnt,i]+=tempUI;
	CALL SUBOPT_0x16
	PUSH R27
	PUSH R26
	CALL __LSLW3
	POP  R26
	POP  R27
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R16
	CALL SUBOPT_0x17
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
;     554 	}   
	SUBI R16,-1
	RJMP _0x39
_0x3A:
;     555 
;     556 
;     557 if((adc_cnt1&0x03)==0)  
	MOV  R30,R10
	ANDI R30,LOW(0x3)
	BRNE _0x3B
;     558 	{
;     559   	temp=(adc_cnt1&0x0c)>>2;
	MOV  R30,R10
	ANDI R30,LOW(0xC)
	LSR  R30
	LSR  R30
	MOV  R17,R30
;     560     	adc_bank_[adc_cnt]=(adc_bank[adc_cnt,temp])/16;
	MOV  R30,R9
	LDI  R26,LOW(_adc_bank_)
	LDI  R27,HIGH(_adc_bank_)
	CALL SUBOPT_0x17
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x16
	PUSH R27
	PUSH R26
	CALL __LSLW3
	POP  R26
	POP  R27
	CALL SUBOPT_0x18
	CALL __GETW1P
	CALL __LSRW4
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
;     561      adc_bank[adc_cnt,temp]=0;
	CALL SUBOPT_0x16
	PUSH R27
	PUSH R26
	CALL __LSLW3
	POP  R26
	POP  R27
	CALL SUBOPT_0x18
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
;     562    	} 		
;     563         
;     564 if((++adc_cnt)>=4)
_0x3B:
	INC  R9
	LDI  R30,LOW(4)
	CP   R9,R30
	BRLO _0x3C
;     565 	{
;     566 	adc_cnt=0;
	CLR  R9
;     567 	if((++adc_cnt1)>=16)
	INC  R10
	LDI  R30,LOW(16)
	CP   R10,R30
	BRLO _0x3D
;     568 		{
;     569   		adc_cnt1=0;
	CLR  R10
;     570   		}   
;     571 	}         
_0x3D:
;     572 
;     573 DDRA&=0b00001111;
_0x3C:
	IN   R30,0x1A
	ANDI R30,LOW(0xF)
	OUT  0x1A,R30
;     574 PORTA&=0b00001111;
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	OUT  0x1B,R30
;     575 
;     576 ADMUX=0b01000000|(4+adc_cnt);
	MOV  R30,R9
	SUBI R30,-LOW(4)
	ORI  R30,0x40
	OUT  0x7,R30
;     577 SFIOR&=0b00011111;
	IN   R30,0x30
	ANDI R30,LOW(0x1F)
	OUT  0x30,R30
;     578 ADCSRA=0b10100110;
	LDI  R30,LOW(166)
	OUT  0x6,R30
;     579 ADCSRA|=0b01000000;  
	SBI  0x6,6
;     580     
;     581 }
	CALL __LOADLOCR6
	ADIW R28,6
	RET
;     582 
;     583 //-----------------------------------------------
;     584 void define_char(char flash *pc,char ch_c)
;     585 {
_define_char:
;     586 char i,aaaa;
;     587 aaaa=(ch_c<<3)|0x40;
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
;     588 for (i=0; i<8; i++) lcd_write_byte(aaaa++,*pc++);
	LDI  R16,LOW(0)
_0x3F:
	CPI  R16,8
	BRSH _0x40
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
	RJMP _0x3F
_0x40:
;     589 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
;     590 
;     591 //-----------------------------------------------
;     592 void simbol_define(void)
;     593 {
_simbol_define:
;     594 #asm("cli")
	cli
;     595 //PORTD|=0b11111010;
;     596 //DDRD|=0b11111010;
;     597 delay_us(10);
	__DELAY_USB 27
;     598 define_char(char0,1);
	LDI  R30,LOW(_char0*2)
	LDI  R31,HIGH(_char0*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _define_char
;     599 define_char(char1,2);
	LDI  R30,LOW(_char1*2)
	LDI  R31,HIGH(_char1*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _define_char
;     600 if(def_char_cnt==0)define_char(char2,3);
	LDS  R30,_def_char_cnt
	CPI  R30,0
	BRNE _0x41
	CALL SUBOPT_0x19
;     601 else if(def_char_cnt==1)define_char(char2_,3);
	RJMP _0x42
_0x41:
	LDS  R26,_def_char_cnt
	CPI  R26,LOW(0x1)
	BRNE _0x43
	CALL SUBOPT_0x1A
;     602 else if(def_char_cnt==2)define_char(char2__,3);
	RJMP _0x44
_0x43:
	LDS  R26,_def_char_cnt
	CPI  R26,LOW(0x2)
	BRNE _0x45
	CALL SUBOPT_0x1B
;     603 else if(def_char_cnt==3)define_char(char2_,3);
	RJMP _0x46
_0x45:
	LDS  R26,_def_char_cnt
	CPI  R26,LOW(0x3)
	BRNE _0x47
	CALL SUBOPT_0x1A
;     604 else if(def_char_cnt==4)define_char(char2,3);
	RJMP _0x48
_0x47:
	LDS  R26,_def_char_cnt
	CPI  R26,LOW(0x4)
	BRNE _0x49
	CALL SUBOPT_0x19
;     605 else if(def_char_cnt==5)define_char(char2_,3);
	RJMP _0x4A
_0x49:
	LDS  R26,_def_char_cnt
	CPI  R26,LOW(0x5)
	BRNE _0x4B
	CALL SUBOPT_0x1A
;     606 else if(def_char_cnt==6)define_char(char2,3);
	RJMP _0x4C
_0x4B:
	LDS  R26,_def_char_cnt
	CPI  R26,LOW(0x6)
	BRNE _0x4D
	CALL SUBOPT_0x19
;     607 else if(def_char_cnt==7)define_char(char2__,3);
	RJMP _0x4E
_0x4D:
	LDS  R26,_def_char_cnt
	CPI  R26,LOW(0x7)
	BRNE _0x4F
	CALL SUBOPT_0x1B
;     608 else if(def_char_cnt==8)define_char(char2_,3);
	RJMP _0x50
_0x4F:
	LDS  R26,_def_char_cnt
	CPI  R26,LOW(0x8)
	BRNE _0x51
	CALL SUBOPT_0x1A
;     609 else if(def_char_cnt==9)define_char(char2,3);
	RJMP _0x52
_0x51:
	LDS  R26,_def_char_cnt
	CPI  R26,LOW(0x9)
	BRNE _0x53
	CALL SUBOPT_0x19
;     610 define_char(char3,4); 
_0x53:
_0x52:
_0x50:
_0x4E:
_0x4C:
_0x4A:
_0x48:
_0x46:
_0x44:
_0x42:
	LDI  R30,LOW(_char3*2)
	LDI  R31,HIGH(_char3*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _define_char
;     611 define_char(char4,5);
	LDI  R30,LOW(_char4*2)
	LDI  R31,HIGH(_char4*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _define_char
;     612 define_char(char5,6); 
	LDI  R30,LOW(_char5*2)
	LDI  R31,HIGH(_char5*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _define_char
;     613 delay_us(10);
	__DELAY_USB 27
;     614 //PORTD|=0b11111010;
;     615 //DDRD|=0b11111010;
;     616 #asm("sei")
	sei
;     617 }
	RET
;     618 
;     619 //-----------------------------------------------
;     620 void lcd_out(void)
;     621 {
_lcd_out:
;     622 #asm("cli")
	cli
;     623 //PORTD|=0b11111010;
;     624 //DDRD|=0b11111010;
;     625 delay_us(10);
	__DELAY_USB 27
;     626 lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1C
	CALL _lcd_gotoxy
;     627 lcd_puts(lcd_buffer);
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
;     628 delay_us(10);
	__DELAY_USB 27
;     629 //PORTD|=0b11111010;
;     630 //DDRD|=0b11111010;
;     631 #asm("sei")
	sei
;     632 }
	RET
;     633 
;     634 //-----------------------------------------------
;     635 void out_out(void)
;     636 { 
;     637 
;     638 }
;     639 
;     640 //-----------------------------------------------
;     641 void parol_init(void)
;     642 {
;     643 parol[0]=0;
;     644 parol[1]=0;
;     645 parol[2]=0;
;     646 sub_ind=0;
;     647 }
;     648 
;     649 //-----------------------------------------------
;     650 int Imat(int in,int k0,int k1)
;     651 {
;     652 signed long int temp;
;     653 temp= in-k0;
;	in -> Y+8
;	k0 -> Y+6
;	k1 -> Y+4
;	temp -> Y+0
;     654 if(temp<0) temp=0;
;     655 temp*=k1;
;     656 temp/=100L;
;     657 return (int)temp;
;     658 }
;     659 
;     660 //-----------------------------------------------
;     661 int Ibmat(int in,int k0,int k1)
;     662 {
;     663 signed long int temp;
;     664 temp= in-k0;
;	in -> Y+8
;	k0 -> Y+6
;	k1 -> Y+4
;	temp -> Y+0
;     665 if(temp<0)
;     666 	{ 
;     667 	temp=-temp;
;     668 	bit_minus=1;
;     669 	}
;     670 else bit_minus=0;	
;     671 temp*=k1;
;     672 temp/=160L;
;     673 return (int)temp;
;     674 }
;     675 
;     676 
;     677 //-----------------------------------------------
;     678 void matemat(void)
;     679 { 
_matemat:
;     680 signed long int temp_SL,temp_SL1;
;     681 char temp,i,ii;
;     682 
;     683 /*for(i=0;i<4;i++)
;     684 	{ 
;     685 	temp_SL=(signed long)adc_bank_[const_of_adc[i]];
;     686 	
;     687 	if((temp_SL<200)||(temp_SL>800))nd[i]=1;
;     688 	else nd[i]=0;
;     689 	
;     690 	temp_SL*=(signed long)(10000+K_t[i]);
;     691 	
;     692 	temp_SL1=10240000L-temp_SL;
;     693 	
;     694 	temp_SL1/=10000;
;     695 	
;     696 	temp_SL/=temp_SL1;
;     697 	
;     698 	if((signed)temp_SL<=temper_table[0])
;     699 		{
;     700 		temper[i]=-50;
;     701 		break;
;     702 		}
;     703 	else if((signed)temp_SL>=temper_table[20])
;     704 		{
;     705 		temper[i]=150;
;     706 		break;		
;     707 		}
;     708 	else 
;     709 		{
;     710 	    	for(ii=0;ii<20;ii++)
;     711 			{
;     712 			if(((signed)temp_SL>=temper_table[ii])&&((signed)temp_SL<=temper_table[ii+1]))break;
;     713 			}
;     714 		temp_SL1=(signed long)temper_table[ii+1]-(signed long)temper_table[ii];		
;     715 		temp_SL-=(signed long)temper_table[ii];
;     716 		temp_SL*=10;
;     717 		temp_SL/=temp_SL1;
;     718 		
;     719 		temp_SL+=(signed long)(ii*10);
;     720 		temp_SL-=50L;
;     721 	    //	temper[i]=-50;
;     722 	    //	temper[i]+=(ii*10);
;     723 		//temper[i]=(signed)temp_SL;
;     724 		  
;     725 		temper[i]=(signed)temp_SL;
;     726 		}
;     727 			
;     728 	}
;     729 */
;     730 
;     731 temp_SL=(signed long)adc_bank_[0];
	SBIW R28,8
	CALL __SAVELOCR3
;	temp_SL -> Y+7
;	temp_SL1 -> Y+3
;	temp -> R16
;	i -> R17
;	ii -> R18
	LDS  R30,_adc_bank_
	LDS  R31,_adc_bank_+1
	CALL SUBOPT_0x1D
;     732 	
;     733 if((temp_SL<200)||(temp_SL>800))nd[0]=1;
	BRLT _0x58
	CALL SUBOPT_0x1E
	BRGE _0x57
_0x58:
	LDI  R30,LOW(1)
	RJMP _0x25F
;     734 else nd[0]=0;
_0x57:
	LDI  R30,LOW(0)
_0x25F:
	STS  _nd,R30
;     735 	
;     736 temp_SL*=(signed long)(10000+K_t[0]);
	LDI  R26,LOW(_K_t)
	LDI  R27,HIGH(_K_t)
	CALL SUBOPT_0x1F
;     737 	
;     738 temp_SL1=10240000L-temp_SL;
;     739 	
;     740 temp_SL1/=10000;
;     741 	
;     742 temp_SL/=temp_SL1;
;     743 	
;     744 if((signed)temp_SL<=temper_table[0])
	BRLT _0x5B
;     745 	{
;     746 	temper[0]=-50;
	LDI  R30,LOW(65486)
	LDI  R31,HIGH(65486)
	STS  _temper,R30
	STS  _temper+1,R31
;     747 	}
;     748 else if((signed)temp_SL>=temper_table[20])
	RJMP _0x5C
_0x5B:
	__POINTW1FN _temper_table,40
	CALL SUBOPT_0x20
	BRLT _0x5D
;     749 	{
;     750 	temper[0]=150;
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	RJMP _0x260
;     751 	}
;     752 else 
_0x5D:
;     753 	{
;     754 	for(ii=0;ii<20;ii++)
	LDI  R18,LOW(0)
_0x60:
	CPI  R18,20
	BRSH _0x61
;     755 		{
;     756 		if(((signed)temp_SL>=temper_table[ii])&&((signed)temp_SL<=temper_table[ii+1]))break;
	CALL SUBOPT_0x21
	CALL SUBOPT_0x20
	BRLT _0x63
	LDI  R30,LOW(_temper_table*2)
	LDI  R31,HIGH(_temper_table*2)
	PUSH R31
	PUSH R30
	MOV  R30,R18
	SUBI R30,-LOW(1)
	POP  R26
	POP  R27
	CALL SUBOPT_0x17
	CALL SUBOPT_0x22
	BRGE _0x64
_0x63:
	RJMP _0x62
_0x64:
	RJMP _0x61
;     757 		}
_0x62:
	SUBI R18,-1
	RJMP _0x60
_0x61:
;     758 	temp_SL1=(signed long)temper_table[ii+1]-(signed long)temper_table[ii];		
	LDI  R30,LOW(_temper_table*2)
	LDI  R31,HIGH(_temper_table*2)
	PUSH R31
	PUSH R30
	MOV  R30,R18
	SUBI R30,-LOW(1)
	POP  R26
	POP  R27
	CALL SUBOPT_0x17
	CALL __GETW1PF
	CALL __CWD1
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x21
	CALL __GETW1PF
	CALL __CWD1
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x23
;     759 	temp_SL-=(signed long)temper_table[ii];
	CALL SUBOPT_0x24
;     760 	temp_SL*=10;
;     761 	temp_SL/=temp_SL1;
;     762 		
;     763 	temp_SL+=(signed long)(ii*10);
;     764 	temp_SL-=50L;
;     765 		  
;     766 	temper[0]=(signed)temp_SL;
_0x260:
	STS  _temper,R30
	STS  _temper+1,R31
;     767      }
_0x5C:
;     768 
;     769 
;     770 
;     771 temp_SL=(signed long)adc_bank_[3];
	__GETW1MN _adc_bank_,6
	CALL SUBOPT_0x1D
;     772 	
;     773 if((temp_SL<200)||(temp_SL>800))nd[1]=1;
	BRLT _0x66
	CALL SUBOPT_0x1E
	BRGE _0x65
_0x66:
	LDI  R30,LOW(1)
	__PUTB1MN _nd,1
;     774 else nd[1]=0;
	RJMP _0x68
_0x65:
	LDI  R30,LOW(0)
	__PUTB1MN _nd,1
_0x68:
;     775 	
;     776 temp_SL*=(signed long)(10000+K_t[1]);
	__POINTW2MN _K_t,2
	CALL SUBOPT_0x1F
;     777 	
;     778 temp_SL1=10240000L-temp_SL;
;     779 	
;     780 temp_SL1/=10000;
;     781 	
;     782 temp_SL/=temp_SL1;
;     783 	
;     784 if((signed)temp_SL<=temper_table[0])
	BRLT _0x69
;     785 	{
;     786 	temper[1]=-50;
	LDI  R30,LOW(65486)
	LDI  R31,HIGH(65486)
	__PUTW1MN _temper,2
;     787 	}
;     788 else if((signed)temp_SL>=temper_table[20])
	RJMP _0x6A
_0x69:
	__POINTW1FN _temper_table,40
	CALL SUBOPT_0x20
	BRLT _0x6B
;     789 	{
;     790 	temper[1]=150;
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	__PUTW1MN _temper,2
;     791 	}
;     792 else 
	RJMP _0x6C
_0x6B:
;     793 	{
;     794 	for(ii=0;ii<20;ii++)
	LDI  R18,LOW(0)
_0x6E:
	CPI  R18,20
	BRSH _0x6F
;     795 		{
;     796 		if(((signed)temp_SL>=temper_table[ii])&&((signed)temp_SL<=temper_table[ii+1]))break;
	CALL SUBOPT_0x21
	CALL SUBOPT_0x20
	BRLT _0x71
	LDI  R30,LOW(_temper_table*2)
	LDI  R31,HIGH(_temper_table*2)
	PUSH R31
	PUSH R30
	MOV  R30,R18
	SUBI R30,-LOW(1)
	POP  R26
	POP  R27
	CALL SUBOPT_0x17
	CALL SUBOPT_0x22
	BRGE _0x72
_0x71:
	RJMP _0x70
_0x72:
	RJMP _0x6F
;     797 		}
_0x70:
	SUBI R18,-1
	RJMP _0x6E
_0x6F:
;     798 	temp_SL1=(signed long)temper_table[ii+1]-(signed long)temper_table[ii];		
	LDI  R30,LOW(_temper_table*2)
	LDI  R31,HIGH(_temper_table*2)
	PUSH R31
	PUSH R30
	MOV  R30,R18
	SUBI R30,-LOW(1)
	POP  R26
	POP  R27
	CALL SUBOPT_0x17
	CALL __GETW1PF
	CALL __CWD1
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x21
	CALL __GETW1PF
	CALL __CWD1
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x23
;     799 	temp_SL-=(signed long)temper_table[ii];
	CALL SUBOPT_0x24
;     800 	temp_SL*=10;
;     801 	temp_SL/=temp_SL1;
;     802 		
;     803 	temp_SL+=(signed long)(ii*10);
;     804 	temp_SL-=50L;
;     805 		  
;     806 	temper[1]=(signed)temp_SL;
	__PUTW1MN _temper,2
;     807      }
_0x6C:
_0x6A:
;     808 
;     809 
;     810 
;     811 
;     812 temp_SL=(signed long)adc_bank_[2];
	__GETW1MN _adc_bank_,4
	CALL SUBOPT_0x1D
;     813 	
;     814 if((temp_SL<200)||(temp_SL>800))nd[2]=1;
	BRLT _0x74
	CALL SUBOPT_0x1E
	BRGE _0x73
_0x74:
	LDI  R30,LOW(1)
	__PUTB1MN _nd,2
;     815 else nd[2]=0;
	RJMP _0x76
_0x73:
	LDI  R30,LOW(0)
	__PUTB1MN _nd,2
_0x76:
;     816 	
;     817 temp_SL*=(signed long)(10000+K_t[2]);
	__POINTW2MN _K_t,4
	CALL SUBOPT_0x1F
;     818 	
;     819 temp_SL1=10240000L-temp_SL;
;     820 	
;     821 temp_SL1/=10000;
;     822 	
;     823 temp_SL/=temp_SL1;
;     824 	
;     825 if((signed)temp_SL<=temper_table[0])
	BRLT _0x77
;     826 	{
;     827 	temper[2]=-50;
	LDI  R30,LOW(65486)
	LDI  R31,HIGH(65486)
	__PUTW1MN _temper,4
;     828 	}
;     829 else if((signed)temp_SL>=temper_table[20])
	RJMP _0x78
_0x77:
	__POINTW1FN _temper_table,40
	CALL SUBOPT_0x20
	BRLT _0x79
;     830 	{
;     831 	temper[2]=150;
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	__PUTW1MN _temper,4
;     832 	}
;     833 else 
	RJMP _0x7A
_0x79:
;     834 	{
;     835 	for(ii=0;ii<20;ii++)
	LDI  R18,LOW(0)
_0x7C:
	CPI  R18,20
	BRSH _0x7D
;     836 		{
;     837 		if(((signed)temp_SL>=temper_table[ii])&&((signed)temp_SL<=temper_table[ii+1]))break;
	CALL SUBOPT_0x21
	CALL SUBOPT_0x20
	BRLT _0x7F
	LDI  R30,LOW(_temper_table*2)
	LDI  R31,HIGH(_temper_table*2)
	PUSH R31
	PUSH R30
	MOV  R30,R18
	SUBI R30,-LOW(1)
	POP  R26
	POP  R27
	CALL SUBOPT_0x17
	CALL SUBOPT_0x22
	BRGE _0x80
_0x7F:
	RJMP _0x7E
_0x80:
	RJMP _0x7D
;     838 		}
_0x7E:
	SUBI R18,-1
	RJMP _0x7C
_0x7D:
;     839 	temp_SL1=(signed long)temper_table[ii+1]-(signed long)temper_table[ii];		
	LDI  R30,LOW(_temper_table*2)
	LDI  R31,HIGH(_temper_table*2)
	PUSH R31
	PUSH R30
	MOV  R30,R18
	SUBI R30,-LOW(1)
	POP  R26
	POP  R27
	CALL SUBOPT_0x17
	CALL __GETW1PF
	CALL __CWD1
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x21
	CALL __GETW1PF
	CALL __CWD1
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x23
;     840 	temp_SL-=(signed long)temper_table[ii];
	CALL SUBOPT_0x24
;     841 	temp_SL*=10;
;     842 	temp_SL/=temp_SL1;
;     843 		
;     844 	temp_SL+=(signed long)(ii*10);
;     845 	temp_SL-=50L;
;     846 		  
;     847 	temper[2]=(signed)temp_SL;
	__PUTW1MN _temper,4
;     848      }
_0x7A:
_0x78:
;     849      
;     850 
;     851 
;     852 
;     853 temp_SL=(signed long)adc_bank_[1];
	__GETW1MN _adc_bank_,2
	CALL SUBOPT_0x1D
;     854 	
;     855 if((temp_SL<200)||(temp_SL>800))nd[3]=1;
	BRLT _0x82
	CALL SUBOPT_0x1E
	BRGE _0x81
_0x82:
	LDI  R30,LOW(1)
	__PUTB1MN _nd,3
;     856 else nd[3]=0;
	RJMP _0x84
_0x81:
	LDI  R30,LOW(0)
	__PUTB1MN _nd,3
_0x84:
;     857 	
;     858 temp_SL*=(signed long)(10000+K_t[3]);
	__POINTW2MN _K_t,6
	CALL SUBOPT_0x1F
;     859 	
;     860 temp_SL1=10240000L-temp_SL;
;     861 	
;     862 temp_SL1/=10000;
;     863 	
;     864 temp_SL/=temp_SL1;
;     865 	
;     866 if((signed)temp_SL<=temper_table[0])
	BRLT _0x85
;     867 	{
;     868 	temper[3]=-50;
	LDI  R30,LOW(65486)
	LDI  R31,HIGH(65486)
	__PUTW1MN _temper,6
;     869 	}
;     870 else if((signed)temp_SL>=temper_table[20])
	RJMP _0x86
_0x85:
	__POINTW1FN _temper_table,40
	CALL SUBOPT_0x20
	BRLT _0x87
;     871 	{
;     872 	temper[3]=150;
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	__PUTW1MN _temper,6
;     873 	}
;     874 else 
	RJMP _0x88
_0x87:
;     875 	{
;     876 	for(ii=0;ii<20;ii++)
	LDI  R18,LOW(0)
_0x8A:
	CPI  R18,20
	BRSH _0x8B
;     877 		{
;     878 		if(((signed)temp_SL>=temper_table[ii])&&((signed)temp_SL<=temper_table[ii+1]))break;
	CALL SUBOPT_0x21
	CALL SUBOPT_0x20
	BRLT _0x8D
	LDI  R30,LOW(_temper_table*2)
	LDI  R31,HIGH(_temper_table*2)
	PUSH R31
	PUSH R30
	MOV  R30,R18
	SUBI R30,-LOW(1)
	POP  R26
	POP  R27
	CALL SUBOPT_0x17
	CALL SUBOPT_0x22
	BRGE _0x8E
_0x8D:
	RJMP _0x8C
_0x8E:
	RJMP _0x8B
;     879 		}
_0x8C:
	SUBI R18,-1
	RJMP _0x8A
_0x8B:
;     880 	temp_SL1=(signed long)temper_table[ii+1]-(signed long)temper_table[ii];		
	LDI  R30,LOW(_temper_table*2)
	LDI  R31,HIGH(_temper_table*2)
	PUSH R31
	PUSH R30
	MOV  R30,R18
	SUBI R30,-LOW(1)
	POP  R26
	POP  R27
	CALL SUBOPT_0x17
	CALL __GETW1PF
	CALL __CWD1
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x21
	CALL __GETW1PF
	CALL __CWD1
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x23
;     881 	temp_SL-=(signed long)temper_table[ii];
	CALL SUBOPT_0x24
;     882 	temp_SL*=10;
;     883 	temp_SL/=temp_SL1;
;     884 		
;     885 	temp_SL+=(signed long)(ii*10);
;     886 	temp_SL-=50L;
;     887 		  
;     888 	temper[3]=(signed)temp_SL;
	__PUTW1MN _temper,6
;     889      }     
_0x88:
_0x86:
;     890 //Us[0]=Umat(adc_bank_[0],K_[kui1])/5;	
;     891 //Us[1]=Umat(adc_bank_[1],K_[kui2])/5;
;     892 //Ubat=Umat(adc_bank_[9]/4,K_[kub])/5;
;     893 //adc_out_temp=(signed long)adc_bank_[0];
;     894 //adc_out_temp*=(signed long)Ku;
;     895 //adc_out_temp/=200L; 
;     896 //Un=(signed)adc_out_temp;
;     897 //adc_out_temp=(signed long)adc_bank_[2];
;     898 //adc_out_temp*=(signed long)Ki;
;     899 //adc_out_temp/=100L;
;     900 //In=(signed)adc_out_temp;
;     901 //Un=(adc_bank_[0]*Ku)/200;
;     902 //In=(adc_bank_[2]*Ki)/200;
;     903 
;     904 
;     905 
;     906 }
	CALL __LOADLOCR3
	ADIW R28,11
	RET
;     907 
;     908  
;     909 //-----------------------------------------------
;     910 char find(char xy)
;     911 {
_find:
;     912 char i=-1;
;     913 do i++;
	ST   -Y,R16
;	xy -> Y+1
;	i -> R16
	LDI  R16,255
_0x90:
	SUBI R16,-1
;     914 while ((lcd_buffer[i]!=xy)&&(i<LCD_SIZE));
	CALL SUBOPT_0x25
	LD   R30,Z
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
	BREQ _0x92
	CPI  R16,40
	BRLO _0x93
_0x92:
	RJMP _0x91
_0x93:
	RJMP _0x90
_0x91:
;     915 if(i>(33)) i=255;
	LDI  R30,LOW(33)
	CP   R30,R16
	BRSH _0x94
	LDI  R16,LOW(255)
;     916 return i;
_0x94:
	MOV  R30,R16
	RJMP _0x25A
;     917 }
;     918 
;     919 
;     920 //-----------------------------------------------
;     921 void bin2bcd_int(unsigned int in)
;     922 {
_bin2bcd_int:
;     923 char i=5;
;     924 for(i=0;i<5;i++)
	ST   -Y,R16
;	in -> Y+1
;	i -> R16
	LDI  R16,5
	LDI  R16,LOW(0)
_0x96:
	CPI  R16,5
	BRSH _0x97
;     925 	{
;     926 	dig[i]=in%10;
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
;     927 	in/=10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
;     928 	}   
	SUBI R16,-1
	RJMP _0x96
_0x97:
;     929 }
	LDD  R16,Y+0
	ADIW R28,3
	RET
;     930 
;     931 //-----------------------------------------------
;     932 void bcd2lcd_zero(char sig)
;     933 {
_bcd2lcd_zero:
;     934 char i;
;     935 zero_on=1;
	ST   -Y,R16
;	sig -> Y+1
;	i -> R16
	SET
	BLD  R3,0
;     936 for (i=5;i>0;i--)
	LDI  R16,LOW(5)
_0x99:
	LDI  R30,LOW(0)
	CP   R30,R16
	BRSH _0x9A
;     937 	{
;     938 	if(zero_on&&(!dig[i-1])&&(i>sig))
	SBRS R3,0
	RJMP _0x9C
	CALL SUBOPT_0x26
	LD   R30,Z
	CPI  R30,0
	BRNE _0x9C
	LDD  R30,Y+1
	CP   R30,R16
	BRLO _0x9D
_0x9C:
	RJMP _0x9B
_0x9D:
;     939 		{
;     940 		dig[i-1]=0x20;
	CALL SUBOPT_0x26
	MOVW R26,R30
	LDI  R30,LOW(32)
	ST   X,R30
;     941 		}
;     942 	else
	RJMP _0x9E
_0x9B:
;     943 		{
;     944 		dig[i-1]=dig[i-1]+0x30;
	CALL SUBOPT_0x26
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x26
	LD   R30,Z
	SUBI R30,-LOW(48)
	POP  R26
	POP  R27
	ST   X,R30
;     945 		zero_on=0;
	CLT
	BLD  R3,0
;     946 		}	
_0x9E:
;     947 	}
	SUBI R16,1
	RJMP _0x99
_0x9A:
;     948 }    
_0x25A:
	LDD  R16,Y+0
	ADIW R28,2
	RET
;     949 
;     950 //-----------------------------------------------
;     951 void int2lcd(unsigned int in,char xy,char des)
;     952 {
_int2lcd:
;     953 char i;
;     954 char n;
;     955 
;     956 bin2bcd_int(in);
	CALL SUBOPT_0x27
;	in -> Y+4
;	xy -> Y+3
;	des -> Y+2
;	i -> R16
;	n -> R17
;     957 bcd2lcd_zero(des+1);
;     958 i=find(xy);
	CALL SUBOPT_0x28
;     959 for (n=0;n<5;n++)
	LDI  R17,LOW(0)
_0xA0:
	CPI  R17,5
	BRLO PC+3
	JMP _0xA1
;     960 	{
;     961    	if(!des&&(dig[n]!=' '))
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0xA3
	CALL SUBOPT_0x29
	CPI  R30,LOW(0x20)
	BRNE _0xA4
_0xA3:
	RJMP _0xA2
_0xA4:
;     962    		{
;     963    		lcd_buffer[i]=dig[n];	 
	CALL SUBOPT_0x25
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x29
	POP  R26
	POP  R27
	ST   X,R30
;     964    		}
;     965    	else 
	RJMP _0xA5
_0xA2:
;     966    		{
;     967    		if(n<des)lcd_buffer[i]=dig[n];
	LDD  R30,Y+2
	CP   R17,R30
	BRSH _0xA6
	CALL SUBOPT_0x25
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x29
	POP  R26
	POP  R27
	ST   X,R30
;     968    		else if (n==des)
	RJMP _0xA7
_0xA6:
	LDD  R30,Y+2
	CP   R30,R17
	BRNE _0xA8
;     969    			{
;     970    			lcd_buffer[i]='.';
	CALL SUBOPT_0x2A
;     971    			lcd_buffer[i-1]=dig[n];
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x29
	POP  R26
	POP  R27
	ST   X,R30
;     972    			} 
;     973    		else if ((n>des)&&(dig[n]!=' ')) lcd_buffer[i-1]=dig[n];   		
	RJMP _0xA9
_0xA8:
	LDD  R30,Y+2
	CP   R30,R17
	BRSH _0xAB
	CALL SUBOPT_0x29
	CPI  R30,LOW(0x20)
	BRNE _0xAC
_0xAB:
	RJMP _0xAA
_0xAC:
	CALL SUBOPT_0x2B
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x29
	POP  R26
	POP  R27
	ST   X,R30
;     974    		}  
_0xAA:
_0xA9:
_0xA7:
_0xA5:
;     975 		
;     976 	i--;	
	SUBI R16,1
;     977 	}
	SUBI R17,-1
	RJMP _0xA0
_0xA1:
;     978 }
	RJMP _0x259
;     979 
;     980 //-----------------------------------------------
;     981 void int2lcdxy(unsigned int in,char xy,char des)
;     982 {
_int2lcdxy:
;     983 char i;
;     984 char n;
;     985 bin2bcd_int(in);
	CALL SUBOPT_0x27
;	in -> Y+4
;	xy -> Y+3
;	des -> Y+2
;	i -> R16
;	n -> R17
;     986 bcd2lcd_zero(des+1);
;     987 i=((xy&0b00000011)*16)+((xy&0b11110000)>>4);
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
;     988 if ((xy&0b00000011)>=2) i++;
	LDD  R30,Y+3
	ANDI R30,LOW(0x3)
	CPI  R30,LOW(0x2)
	BRLO _0xAD
	SUBI R16,-1
;     989 if ((xy&0b00000011)==3) i++;
_0xAD:
	LDD  R30,Y+3
	ANDI R30,LOW(0x3)
	CPI  R30,LOW(0x3)
	BRNE _0xAE
	SUBI R16,-1
;     990 for (n=0;n<5;n++)
_0xAE:
	LDI  R17,LOW(0)
_0xB0:
	CPI  R17,5
	BRSH _0xB1
;     991 	{ 
;     992 	if(n<des)
	LDD  R30,Y+2
	CP   R17,R30
	BRSH _0xB2
;     993 		{
;     994 		lcd_buffer[i]=dig[n];
	CALL SUBOPT_0x25
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x29
	POP  R26
	POP  R27
	ST   X,R30
;     995 		}   
;     996 	if((n>=des)&&(dig[n]!=0x20))
_0xB2:
	LDD  R30,Y+2
	CP   R17,R30
	BRLO _0xB4
	CALL SUBOPT_0x29
	CPI  R30,LOW(0x20)
	BRNE _0xB5
_0xB4:
	RJMP _0xB3
_0xB5:
;     997 		{
;     998 		if(!des)lcd_buffer[i]=dig[n];	
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0xB6
	CALL SUBOPT_0x25
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x29
	POP  R26
	POP  R27
	RJMP _0x261
;     999 		else lcd_buffer[i-1]=dig[n];
_0xB6:
	CALL SUBOPT_0x2B
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x29
	POP  R26
	POP  R27
_0x261:
	ST   X,R30
;    1000    		}   
;    1001 	i--;	
_0xB3:
	SUBI R16,1
;    1002 	}
	SUBI R17,-1
	RJMP _0xB0
_0xB1:
;    1003 }
_0x259:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
;    1004 
;    1005 //-----------------------------------------------
;    1006 void int2lcd_mm(signed int in,char xy,char des)
;    1007 {
_int2lcd_mm:
;    1008 char i;
;    1009 char n;
;    1010 char minus='+';
;    1011 if(in<0)
	CALL __SAVELOCR3
;	in -> Y+5
;	xy -> Y+4
;	des -> Y+3
;	i -> R16
;	n -> R17
;	minus -> R18
	LDI  R18,43
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	SBIW R26,0
	BRGE _0xB8
;    1012 	{
;    1013 	in=abs(in);
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _abs
	STD  Y+5,R30
	STD  Y+5+1,R31
;    1014 	minus='-';
	LDI  R18,LOW(45)
;    1015 	}
;    1016 bin2bcd_int(in);
_0xB8:
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _bin2bcd_int
;    1017 bcd2lcd_zero(des+1);
	LDD  R30,Y+3
	SUBI R30,-LOW(1)
	ST   -Y,R30
	CALL _bcd2lcd_zero
;    1018 i=find(xy);
	LDD  R30,Y+4
	CALL SUBOPT_0x28
;    1019 for (n=0;n<5;n++)
	LDI  R17,LOW(0)
_0xBA:
	CPI  R17,5
	BRLO PC+3
	JMP _0xBB
;    1020 	{
;    1021    	if(!des&&(dig[n]!=' '))
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0xBD
	CALL SUBOPT_0x29
	CPI  R30,LOW(0x20)
	BRNE _0xBE
_0xBD:
	RJMP _0xBC
_0xBE:
;    1022    		{
;    1023    		if((dig[n+1]==' ')&&(minus=='-'))lcd_buffer[i-1]='-';
	CALL SUBOPT_0x2C
	BRNE _0xC0
	CPI  R18,45
	BREQ _0xC1
_0xC0:
	RJMP _0xBF
_0xC1:
	CALL SUBOPT_0x2B
	MOVW R26,R30
	LDI  R30,LOW(45)
	ST   X,R30
;    1024    		lcd_buffer[i]=dig[n];	 
_0xBF:
	CALL SUBOPT_0x25
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x29
	POP  R26
	POP  R27
	ST   X,R30
;    1025    		}
;    1026    	else 
	RJMP _0xC2
_0xBC:
;    1027    		{
;    1028    		if(n<des)lcd_buffer[i]=dig[n];
	LDD  R30,Y+3
	CP   R17,R30
	BRSH _0xC3
	CALL SUBOPT_0x25
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x29
	POP  R26
	POP  R27
	ST   X,R30
;    1029    		else if (n==des)
	RJMP _0xC4
_0xC3:
	LDD  R30,Y+3
	CP   R30,R17
	BRNE _0xC5
;    1030    			{
;    1031    			lcd_buffer[i]='.';
	CALL SUBOPT_0x2A
;    1032    			lcd_buffer[i-1]=dig[n];
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x29
	POP  R26
	POP  R27
	ST   X,R30
;    1033    			} 
;    1034    		else if ((n>des)&&(dig[n]!=' ')) lcd_buffer[i-1]=dig[n]; 
	RJMP _0xC6
_0xC5:
	LDD  R30,Y+3
	CP   R30,R17
	BRSH _0xC8
	CALL SUBOPT_0x29
	CPI  R30,LOW(0x20)
	BRNE _0xC9
_0xC8:
	RJMP _0xC7
_0xC9:
	CALL SUBOPT_0x2B
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x29
	POP  R26
	POP  R27
	ST   X,R30
;    1035    		else if ((minus=='-')&&(n>des)&&(dig[n]!=' ')&&(dig[n+1]==' ')) lcd_buffer[i]='-';  		
	RJMP _0xCA
_0xC7:
	CPI  R18,45
	BRNE _0xCC
	LDD  R30,Y+3
	CP   R30,R17
	BRSH _0xCC
	CALL SUBOPT_0x29
	CPI  R30,LOW(0x20)
	BREQ _0xCC
	CALL SUBOPT_0x2C
	BREQ _0xCD
_0xCC:
	RJMP _0xCB
_0xCD:
	CALL SUBOPT_0x2D
	LDI  R30,LOW(45)
	ST   X,R30
;    1036    		}  
_0xCB:
_0xCA:
_0xC6:
_0xC4:
_0xC2:
;    1037 		
;    1038 	i--;	
	SUBI R16,1
;    1039 	}
	SUBI R17,-1
	RJMP _0xBA
_0xBB:
;    1040 }
	CALL __LOADLOCR3
	ADIW R28,7
	RET
;    1041 
;    1042 //-----------------------------------------------
;    1043 void sint2lcdxy(signed int in,char xy,char des)
;    1044 {
;    1045 char i;
;    1046 char n;
;    1047 char sign;
;    1048 sign=0;
;	in -> Y+5
;	xy -> Y+4
;	des -> Y+3
;	i -> R16
;	n -> R17
;	sign -> R18
;    1049 if(in<0)
;    1050 	{
;    1051 	in=-in;
;    1052 	sign=1;
;    1053 	}
;    1054 bin2bcd_int(in);
;    1055 bcd2lcd_zero(des+1);
;    1056 i=((xy&0b00000011)*16)+((xy&0b11110000)>>4);
;    1057 if ((xy&0b00000011)>=2) i++;
;    1058 if ((xy&0b00000011)==3) i++;
;    1059 for (n=0;n<5;n++)
;    1060 	{ 
;    1061 	if(n<des)
;    1062 		{
;    1063 		lcd_buffer[i]=dig[n];
;    1064 		}   
;    1065 	if((n>=des)&&(dig[n]!=0x20))
;    1066 		{
;    1067 		if(!des)lcd_buffer[i]=dig[n];	
;    1068 		else lcd_buffer[i-1]=dig[n];
;    1069    		}   
;    1070 	i--;	
;    1071 	}
;    1072 }
;    1073 
;    1074 //-----------------------------------------------
;    1075 void sub_bgnd(char flash *adr,char xy,signed char offset)
;    1076 {
_sub_bgnd:
;    1077 char temp;
;    1078 temp=find(xy);
	ST   -Y,R16
;	*adr -> Y+3
;	xy -> Y+2
;	offset -> Y+1
;	temp -> R16
	LDD  R30,Y+2
	CALL SUBOPT_0x28
;    1079 
;    1080 //ptr_ram=&lcd_buffer[find(xy)];
;    1081 if(temp!=255)
	CPI  R16,255
	BREQ _0xDA
;    1082 while (*adr)
_0xDB:
	CALL SUBOPT_0x2E
	BREQ _0xDD
;    1083 	{
;    1084 	lcd_buffer[temp+offset]=*adr++;
	LDD  R30,Y+1
	ADD  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_lcd_buffer)
	SBCI R31,HIGH(-_lcd_buffer)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2F
	POP  R26
	POP  R27
	ST   X,R30
;    1085 	temp++;
	SUBI R16,-1
;    1086     	}
	RJMP _0xDB
_0xDD:
;    1087 }
_0xDA:
	RJMP _0x258
;    1088 
;    1089 //-----------------------------------------------
;    1090 void bgnd_par(char flash *ptr0,char flash *ptr1)
;    1091 {
_bgnd_par:
;    1092 char i;
;    1093 for (i=0;i<LCD_SIZE;i++)
	ST   -Y,R16
;	*ptr0 -> Y+3
;	*ptr1 -> Y+1
;	i -> R16
	LDI  R16,LOW(0)
_0xDF:
	CPI  R16,40
	BRSH _0xE0
;    1094 	{
;    1095 	lcd_buffer[i]=0x20;
	CALL SUBOPT_0x2D
	LDI  R30,LOW(32)
	ST   X,R30
;    1096 	}
	SUBI R16,-1
	RJMP _0xDF
_0xE0:
;    1097 ptr_ram=lcd_buffer;
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	STS  _ptr_ram,R30
	STS  _ptr_ram+1,R31
;    1098 while (*ptr0)
_0xE1:
	CALL SUBOPT_0x2E
	BREQ _0xE3
;    1099 	{
;    1100 	*ptr_ram++=*ptr0++;
	CALL SUBOPT_0x30
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2F
	POP  R26
	POP  R27
	ST   X,R30
;    1101    	}
	RJMP _0xE1
_0xE3:
;    1102 while (*ptr1)
_0xE4:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0xE6
;    1103 	{
;    1104 	*ptr_ram++=*ptr1++;
	CALL SUBOPT_0x30
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
;    1105    	}
	RJMP _0xE4
_0xE6:
;    1106 } 
_0x258:
	LDD  R16,Y+0
	ADIW R28,5
	RET
;    1107 
;    1108 
;    1109 //-----------------------------------------------
;    1110 void ind_hndl(void)
;    1111 {
_ind_hndl:
;    1112 /* 
;    1113 flash char sm0_0[]	={" Раб. от ист N] "};
;    1114 flash char sm0_1[]	={" Раб. от N1 и N2"}; 
;    1115 flash char sm0_2[]	={" Раб. от батареи"};
;    1116 flash char sm0_3[]	={" Ав.N[   Раб.N] "}; */
;    1117 
;    1118 signed int temp;
;    1119 flash char* ptrs[11];
;    1120 char temp_;
;    1121 if(cnt_ind_nd)cnt_ind_nd--;
	SBIW R28,22
	CALL __SAVELOCR3
;	temp -> R16,R17
;	*ptrs -> Y+3
;	temp_ -> R18
	LDS  R30,_cnt_ind_nd
	CPI  R30,0
	BREQ _0xE7
	SUBI R30,LOW(1)
	STS  _cnt_ind_nd,R30
;    1122 
;    1123 if (ind==iMn)
_0xE7:
	MOV  R0,R6
	OR   R0,R7
	BREQ PC+3
	JMP _0xE8
;    1124 	{
;    1125 	if(ind_mode==im_1)
	LDI  R26,LOW(_ind_mode)
	LDI  R27,HIGH(_ind_mode)
	CALL __EEPROMRDW
	SBIW R30,0
	BREQ PC+3
	JMP _0xE9
;    1126 		{
;    1127 		if(++ind_cnt>=40)ind_cnt=0;
	LDS  R26,_ind_cnt
	SUBI R26,-LOW(1)
	STS  _ind_cnt,R26
	CPI  R26,LOW(0x28)
	BRLO _0xEA
	LDI  R30,LOW(0)
	STS  _ind_cnt,R30
;    1128 		
;    1129 		bgnd_par(	"!       @       ",
_0xEA:
;    1130  				"#       $       "); 
	__POINTW1FN _0,1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0,18
	ST   -Y,R31
	ST   -Y,R30
	CALL _bgnd_par
;    1131                     
;    1132      	if((ind_cnt>=0)&&(ind_cnt<=20))
	LDS  R26,_ind_cnt
	CPI  R26,0
	BRLO _0xEC
	LDI  R30,LOW(20)
	CP   R30,R26
	BRSH _0xED
_0xEC:
	RJMP _0xEB
_0xED:
;    1133      		{
;    1134      		sub_bgnd("1   !gC",'!',0);
	__POINTW1FN _0,35
	CALL SUBOPT_0x31
	CALL _sub_bgnd
;    1135      		if(nd[0])sub_bgnd("Н.Д.",'!',-1);
	LDS  R30,_nd
	CPI  R30,0
	BREQ _0xEE
	__POINTW1FN _0,43
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
;    1136      		else int2lcd_mm(temper[0],'!',0);
	RJMP _0xEF
_0xEE:
	LDS  R30,_temper
	LDS  R31,_temper+1
	CALL SUBOPT_0x31
	CALL _int2lcd_mm
_0xEF:
;    1137      		}
;    1138      	else 
	RJMP _0xF0
_0xEB:
;    1139      		{
;    1140      		sub_bgnd("1  #@0!",'!',0);
	__POINTW1FN _0,48
	CALL SUBOPT_0x31
	CALL _sub_bgnd
;    1141      		if(wrk_state[0])
	LDI  R26,LOW(_wrk_state)
	LDI  R27,HIGH(_wrk_state)
	CALL __EEPROMRDW
	SBIW R30,0
	BREQ _0xF1
;    1142      			{
;    1143      			//int2lcd(wrk_time_cnt,'1',0); 
;    1144      			int2lcd(wrk_time_cnt[0]%60,'!',0);
	LDS  R26,_wrk_time_cnt
	LDS  R27,_wrk_time_cnt+1
	CALL SUBOPT_0x34
	CALL _int2lcd
;    1145 				int2lcd(wrk_time_cnt[0]/60,'#',0); 
	LDS  R26,_wrk_time_cnt
	LDS  R27,_wrk_time_cnt+1
	CALL SUBOPT_0x35
	CALL _int2lcd
;    1146 				
;    1147 				if((ee_time_mode[0]==0)||(wrk_time_cnt_flag[0]==1))
	LDI  R26,LOW(_ee_time_mode)
	LDI  R27,HIGH(_ee_time_mode)
	CALL __EEPROMRDW
	SBIW R30,0
	BREQ _0xF3
	LDS  R26,_wrk_time_cnt_flag
	LDS  R27,_wrk_time_cnt_flag+1
	CPI  R26,LOW(0x1)
	LDI  R30,HIGH(0x1)
	CPC  R27,R30
	BRNE _0xF2
_0xF3:
;    1148 					{
;    1149 					if(bFL2)lcd_buffer[find('@')]=':';
	SBRS R3,6
	RJMP _0xF5
	CALL SUBOPT_0x36
	LDI  R30,LOW(58)
	RJMP _0x262
;    1150 					else lcd_buffer[find('@')]=' ';
_0xF5:
	CALL SUBOPT_0x36
	LDI  R30,LOW(32)
_0x262:
	ST   X,R30
;    1151 					} 
;    1152 				else lcd_buffer[find('@')]=':';
	RJMP _0xF7
_0xF2:
	CALL SUBOPT_0x36
	LDI  R30,LOW(58)
	ST   X,R30
_0xF7:
;    1153      			}
;    1154 			else sub_bgnd("ВЫКЛ.",'!',-4);     			
	RJMP _0xF8
_0xF1:
	__POINTW1FN _0,56
	CALL SUBOPT_0x32
	CALL SUBOPT_0x37
_0xF8:
;    1155      		}	
_0xF0:
;    1156      	lcd_buffer[find('g')]=2;
	CALL SUBOPT_0x38
;    1157      	
;    1158      	if(out_st[0])lcd_buffer[1]=3; 
	LDS  R30,_out_st
	CPI  R30,0
	BREQ _0xF9
	LDI  R30,LOW(3)
	__PUTB1MN _lcd_buffer,1
;    1159      	
;    1160      	
;    1161      	if((ind_cnt>=15)&&(ind_cnt<=35))
_0xF9:
	LDS  R26,_ind_cnt
	CPI  R26,LOW(0xF)
	BRLO _0xFB
	LDI  R30,LOW(35)
	CP   R30,R26
	BRSH _0xFC
_0xFB:
	RJMP _0xFA
_0xFC:
;    1162      		{
;    1163      		sub_bgnd("2   !gC",'@',0);
	__POINTW1FN _0,62
	CALL SUBOPT_0x39
	CALL _sub_bgnd
;    1164      		if(nd[1])sub_bgnd("Н.Д.",'!',-1);
	__GETB1MN _nd,1
	CPI  R30,0
	BREQ _0xFD
	__POINTW1FN _0,43
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
;    1165      		else int2lcd_mm(temper[1],'!',0);
	RJMP _0xFE
_0xFD:
	__GETW1MN _temper,2
	CALL SUBOPT_0x31
	CALL _int2lcd_mm
_0xFE:
;    1166      		}
;    1167      	else 
	RJMP _0xFF
_0xFA:
;    1168      		{
;    1169      		sub_bgnd("2  #@0!",'@',0);
	__POINTW1FN _0,70
	CALL SUBOPT_0x39
	CALL _sub_bgnd
;    1170      		if(wrk_state[1])
	__POINTW2MN _wrk_state,2
	CALL __EEPROMRDW
	SBIW R30,0
	BREQ _0x100
;    1171      			{
;    1172      			//int2lcd(wrk_time_cnt,'1',0); 
;    1173      			int2lcd(wrk_time_cnt[1]%60,'!',0);
	__GETW2MN _wrk_time_cnt,2
	CALL SUBOPT_0x34
	CALL _int2lcd
;    1174 				int2lcd(wrk_time_cnt[1]/60,'#',0); 
	__GETW2MN _wrk_time_cnt,2
	CALL SUBOPT_0x35
	CALL _int2lcd
;    1175 				
;    1176 				if((ee_time_mode[1]==0)||(wrk_time_cnt_flag[1]==1))
	__POINTW2MN _ee_time_mode,2
	CALL __EEPROMRDW
	SBIW R30,0
	BREQ _0x102
	__GETW1MN _wrk_time_cnt_flag,2
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x101
_0x102:
;    1177 					{
;    1178 					if(bFL2)lcd_buffer[find('@')]=':';
	SBRS R3,6
	RJMP _0x104
	CALL SUBOPT_0x36
	LDI  R30,LOW(58)
	RJMP _0x263
;    1179 					else lcd_buffer[find('@')]=' ';
_0x104:
	CALL SUBOPT_0x36
	LDI  R30,LOW(32)
_0x263:
	ST   X,R30
;    1180 					} 
;    1181 				else lcd_buffer[find('@')]=':';
	RJMP _0x106
_0x101:
	CALL SUBOPT_0x36
	LDI  R30,LOW(58)
	ST   X,R30
_0x106:
;    1182      			}
;    1183 			else sub_bgnd("ВЫКЛ.",'!',-4);     			
	RJMP _0x107
_0x100:
	__POINTW1FN _0,56
	CALL SUBOPT_0x32
	CALL SUBOPT_0x37
_0x107:
;    1184      		}	
_0xFF:
;    1185      	lcd_buffer[find('g')]=2;
	CALL SUBOPT_0x38
;    1186      	
;    1187      	if(out_st[1])lcd_buffer[9]=3;     	
	__GETB1MN _out_st,1
	CPI  R30,0
	BREQ _0x108
	LDI  R30,LOW(3)
	__PUTB1MN _lcd_buffer,9
;    1188  
;    1189       	if((ind_cnt>=10)&&(ind_cnt<=30))
_0x108:
	LDS  R26,_ind_cnt
	CPI  R26,LOW(0xA)
	BRLO _0x10A
	LDI  R30,LOW(30)
	CP   R30,R26
	BRSH _0x10B
_0x10A:
	RJMP _0x109
_0x10B:
;    1190      		{
;    1191      		sub_bgnd("3   !gC",'#',0);
	__POINTW1FN _0,78
	CALL SUBOPT_0x3A
	CALL _sub_bgnd
;    1192      		if(nd[2])sub_bgnd("Н.Д.",'!',-1);
	__GETB1MN _nd,2
	CPI  R30,0
	BREQ _0x10C
	__POINTW1FN _0,43
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
;    1193      		else int2lcd_mm(temper[2],'!',0);
	RJMP _0x10D
_0x10C:
	__GETW1MN _temper,4
	CALL SUBOPT_0x31
	CALL _int2lcd_mm
_0x10D:
;    1194      		}
;    1195      	else 
	RJMP _0x10E
_0x109:
;    1196      		{
;    1197      		sub_bgnd("3  #@0!",'#',0);
	__POINTW1FN _0,86
	CALL SUBOPT_0x3A
	CALL _sub_bgnd
;    1198      		if(wrk_state[2])
	__POINTW2MN _wrk_state,4
	CALL __EEPROMRDW
	SBIW R30,0
	BREQ _0x10F
;    1199      			{
;    1200          			int2lcd(wrk_time_cnt[2]%60,'!',0);
	__GETW2MN _wrk_time_cnt,4
	CALL SUBOPT_0x34
	CALL _int2lcd
;    1201 				int2lcd(wrk_time_cnt[2]/60,'#',0); 
	__GETW2MN _wrk_time_cnt,4
	CALL SUBOPT_0x35
	CALL _int2lcd
;    1202 				
;    1203 				if((ee_time_mode[2]==0)||(wrk_time_cnt_flag[2]==1))
	__POINTW2MN _ee_time_mode,4
	CALL __EEPROMRDW
	SBIW R30,0
	BREQ _0x111
	__GETW1MN _wrk_time_cnt_flag,4
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x110
_0x111:
;    1204 					{
;    1205 					if(bFL2)lcd_buffer[find('@')]=':';
	SBRS R3,6
	RJMP _0x113
	CALL SUBOPT_0x36
	LDI  R30,LOW(58)
	RJMP _0x264
;    1206 					else lcd_buffer[find('@')]=' ';
_0x113:
	CALL SUBOPT_0x36
	LDI  R30,LOW(32)
_0x264:
	ST   X,R30
;    1207 					} 
;    1208 				else lcd_buffer[find('@')]=':';
	RJMP _0x115
_0x110:
	CALL SUBOPT_0x36
	LDI  R30,LOW(58)
	ST   X,R30
_0x115:
;    1209      			}
;    1210 			else sub_bgnd("ВЫКЛ.",'!',-4);     			
	RJMP _0x116
_0x10F:
	__POINTW1FN _0,56
	CALL SUBOPT_0x32
	CALL SUBOPT_0x37
_0x116:
;    1211      		}	
_0x10E:
;    1212      	lcd_buffer[find('g')]=2;
	CALL SUBOPT_0x38
;    1213      	
;    1214      	if(out_st[2])lcd_buffer[17]=3;     	
	__GETB1MN _out_st,2
	CPI  R30,0
	BREQ _0x117
	LDI  R30,LOW(3)
	__PUTB1MN _lcd_buffer,17
;    1215  
;    1216      	if((ind_cnt>=5)&&(ind_cnt<=25))
_0x117:
	LDS  R26,_ind_cnt
	CPI  R26,LOW(0x5)
	BRLO _0x119
	LDI  R30,LOW(25)
	CP   R30,R26
	BRSH _0x11A
_0x119:
	RJMP _0x118
_0x11A:
;    1217      		{
;    1218      		sub_bgnd("4   !gC",'$',0);
	__POINTW1FN _0,94
	CALL SUBOPT_0x3B
	CALL _sub_bgnd
;    1219      		if(nd[3])sub_bgnd("Н.Д.",'!',-1);
	__GETB1MN _nd,3
	CPI  R30,0
	BREQ _0x11B
	__POINTW1FN _0,43
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
;    1220      		else int2lcd_mm(temper[3],'!',0);
	RJMP _0x11C
_0x11B:
	__GETW1MN _temper,6
	CALL SUBOPT_0x31
	CALL _int2lcd_mm
_0x11C:
;    1221      		}
;    1222      	else 
	RJMP _0x11D
_0x118:
;    1223      		{
;    1224      		sub_bgnd("4  #@0!",'$',0);
	__POINTW1FN _0,102
	CALL SUBOPT_0x3B
	CALL _sub_bgnd
;    1225      		if(wrk_state[3])
	__POINTW2MN _wrk_state,6
	CALL __EEPROMRDW
	SBIW R30,0
	BREQ _0x11E
;    1226      			{
;    1227          			int2lcd(wrk_time_cnt[3]%60,'!',0);
	__GETW2MN _wrk_time_cnt,6
	CALL SUBOPT_0x34
	CALL _int2lcd
;    1228 				int2lcd(wrk_time_cnt[3]/60,'#',0); 
	__GETW2MN _wrk_time_cnt,6
	CALL SUBOPT_0x35
	CALL _int2lcd
;    1229 				
;    1230 				if((ee_time_mode[3]==0)||(wrk_time_cnt_flag[3]==1))
	__POINTW2MN _ee_time_mode,6
	CALL __EEPROMRDW
	SBIW R30,0
	BREQ _0x120
	__GETW1MN _wrk_time_cnt_flag,6
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x11F
_0x120:
;    1231 					{
;    1232 					if(bFL2)lcd_buffer[find('@')]=':';
	SBRS R3,6
	RJMP _0x122
	CALL SUBOPT_0x36
	LDI  R30,LOW(58)
	RJMP _0x265
;    1233 					else lcd_buffer[find('@')]=' ';
_0x122:
	CALL SUBOPT_0x36
	LDI  R30,LOW(32)
_0x265:
	ST   X,R30
;    1234 					} 
;    1235 				else lcd_buffer[find('@')]=':';
	RJMP _0x124
_0x11F:
	CALL SUBOPT_0x36
	LDI  R30,LOW(58)
	ST   X,R30
_0x124:
;    1236      			}
;    1237 			else sub_bgnd("ВЫКЛ.",'!',-4);     			
	RJMP _0x125
_0x11E:
	__POINTW1FN _0,56
	CALL SUBOPT_0x32
	CALL SUBOPT_0x37
_0x125:
;    1238      		}	
_0x11D:
;    1239      	lcd_buffer[find('g')]=2;
	CALL SUBOPT_0x38
;    1240      	
;    1241      	if(out_st[3])lcd_buffer[25]=3;     	     	
	__GETB1MN _out_st,3
	CPI  R30,0
	BREQ _0x126
	LDI  R30,LOW(3)
	__PUTB1MN _lcd_buffer,25
;    1242 		}
_0x126:
;    1243 	else if(ind_mode==im_2)
	RJMP _0x127
_0xE9:
	LDI  R26,LOW(_ind_mode)
	LDI  R27,HIGH(_ind_mode)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x128
;    1244 		{
;    1245 		bgnd_par(	"1       2       ",
;    1246  				"3       4       "); 
	__POINTW1FN _0,110
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0,127
	ST   -Y,R31
	ST   -Y,R30
	CALL _bgnd_par
;    1247           }	     
;    1248 	} 
_0x128:
_0x127:
;    1249 	
;    1250 else if(ind==iDeb)
	RJMP _0x129
_0xE8:
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CP   R30,R6
	CPC  R31,R7
	BREQ PC+3
	JMP _0x12A
;    1251 	{
;    1252 	bgnd_par(	"       !       @",
;    1253  			"       #       $");
	__POINTW1FN _0,144
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0,161
	ST   -Y,R31
	ST   -Y,R30
	CALL _bgnd_par
;    1254 	int2lcdxy(adc_bank_[0],0x30,0);	
	LDS  R30,_adc_bank_
	LDS  R31,_adc_bank_+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(48)
	CALL SUBOPT_0x1C
	CALL _int2lcdxy
;    1255 	int2lcdxy(adc_bank_[1],0xb0,0);
	__GETW1MN _adc_bank_,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(176)
	CALL SUBOPT_0x1C
	CALL _int2lcdxy
;    1256 	int2lcdxy(adc_bank_[2],0x31,0);
	__GETW1MN _adc_bank_,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(49)
	CALL SUBOPT_0x1C
	CALL _int2lcdxy
;    1257 	int2lcdxy(adc_bank_[3],0xb1,0); 
	__GETW1MN _adc_bank_,6
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(177)
	CALL SUBOPT_0x1C
	CALL _int2lcdxy
;    1258 	
;    1259 	int2lcd_mm(temper[0],'!',0);	
	LDS  R30,_temper
	LDS  R31,_temper+1
	CALL SUBOPT_0x31
	CALL _int2lcd_mm
;    1260 	int2lcd_mm(temper[1],'@',0);
	__GETW1MN _temper,2
	CALL SUBOPT_0x39
	CALL _int2lcd_mm
;    1261 	int2lcd_mm(temper[2],'#',0);
	__GETW1MN _temper,4
	CALL SUBOPT_0x3A
	CALL _int2lcd_mm
;    1262 	int2lcd_mm(temper[3],'$',0);	
	__GETW1MN _temper,6
	CALL SUBOPT_0x3B
	CALL _int2lcd_mm
;    1263 	} 
;    1264 
;    1265 else if(ind==iMn_)
	RJMP _0x12B
_0x12A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R6
	CPC  R31,R7
	BREQ PC+3
	JMP _0x12C
;    1266 	{
;    1267 	ptrs[0]=" Канал1    !    ";
	__POINTW1FN _0,178
	STD  Y+3,R30
	STD  Y+3+1,R31
;    1268 	ptrs[1]=" Канал2    @    ";
	__POINTW1FN _0,195
	STD  Y+5,R30
	STD  Y+5+1,R31
;    1269 	ptrs[2]=" Канал3    #    ";
	__POINTW1FN _0,212
	STD  Y+7,R30
	STD  Y+7+1,R31
;    1270 	ptrs[3]=" Канал4    $    ";
	__POINTW1FN _0,229
	STD  Y+9,R30
	STD  Y+9+1,R31
;    1271 	ptrs[4]=" Выход          ";
	__POINTW1FN _0,246
	STD  Y+11,R30
	STD  Y+11+1,R31
;    1272 	
;    1273 	if(index_set>sub_ind)index_set=sub_ind;
	CP   R11,R13
	BRGE _0x12D
	MOV  R13,R11
;    1274 	else if(index_set<(sub_ind-1)) index_set=sub_ind-1;
	RJMP _0x12E
_0x12D:
	CALL SUBOPT_0x3C
	BRGE _0x12F
	CALL SUBOPT_0x3D
;    1275 	
;    1276 	bgnd_par(ptrs[index_set],ptrs[index_set+1]);
_0x12F:
_0x12E:
	CALL SUBOPT_0x3E
;    1277 	
;    1278 	if(index_set==sub_ind) lcd_buffer[0]=1;
	CP   R11,R13
	BRNE _0x130
	LDI  R30,LOW(1)
	STS  _lcd_buffer,R30
;    1279 	else if(index_set==(sub_ind-1)) lcd_buffer[16]=1;
	RJMP _0x131
_0x130:
	MOV  R30,R11
	SUBI R30,LOW(1)
	CP   R30,R13
	BRNE _0x132
	LDI  R30,LOW(1)
	__PUTB1MN _lcd_buffer,16
;    1280 
;    1281 	if(wrk_state[0]==wsON)sub_bgnd("ВКЛ.",'!',0);
_0x132:
_0x131:
	LDI  R26,LOW(_wrk_state)
	LDI  R27,HIGH(_wrk_state)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x133
	__POINTW1FN _0,263
	RJMP _0x266
;    1282 	else sub_bgnd("ВЫКЛ.",'!',0);  
_0x133:
	__POINTW1FN _0,56
_0x266:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(33)
	CALL SUBOPT_0x1C
	CALL _sub_bgnd
;    1283 	
;    1284 	if(wrk_state[1]==wsON)sub_bgnd("ВКЛ.",'@',0);
	__POINTW2MN _wrk_state,2
	CALL __EEPROMRDW
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x135
	__POINTW1FN _0,263
	RJMP _0x267
;    1285 	else sub_bgnd("ВЫКЛ.",'@',0);
_0x135:
	__POINTW1FN _0,56
_0x267:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(64)
	CALL SUBOPT_0x1C
	CALL _sub_bgnd
;    1286 	
;    1287 	if(wrk_state[2]==wsON)sub_bgnd("ВКЛ.",'#',0);
	__POINTW2MN _wrk_state,4
	CALL __EEPROMRDW
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x137
	__POINTW1FN _0,263
	RJMP _0x268
;    1288 	else sub_bgnd("ВЫКЛ.",'#',0);
_0x137:
	__POINTW1FN _0,56
_0x268:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(35)
	CALL SUBOPT_0x1C
	CALL _sub_bgnd
;    1289 	
;    1290 	if(wrk_state[3]==wsON)sub_bgnd("ВКЛ.",'$',0);
	__POINTW2MN _wrk_state,6
	CALL __EEPROMRDW
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x139
	__POINTW1FN _0,263
	RJMP _0x269
;    1291 	else sub_bgnd("ВЫКЛ.",'$',0);			
_0x139:
	__POINTW1FN _0,56
_0x269:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(36)
	CALL SUBOPT_0x1C
	CALL _sub_bgnd
;    1292 	}	
;    1293 	
;    1294 else if(ind==iCh)
	RJMP _0x13B
_0x12C:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R6
	CPC  R31,R7
	BREQ PC+3
	JMP _0x13C
;    1295 	{
;    1296 	ptrs[0]=" Кн!   o   @    ";
	__POINTW1FN _0,268
	STD  Y+3,R30
	STD  Y+3+1,R31
;    1297 	ptrs[1]="     #gC   $%0^ ";
	__POINTW1FN _0,285
	STD  Y+5,R30
	STD  Y+5+1,R31
;    1298 	ptrs[2]=" Tуст.       >gC";
	__POINTW1FN _0,302
	STD  Y+7,R30
	STD  Y+7+1,R31
;    1299 	ptrs[3]=" Время:    (ч0)м"; 
	__POINTW1FN _0,319
	STD  Y+9,R30
	STD  Y+9+1,R31
;    1300 	ptrs[4]=" Режим времени <";
	__POINTW1FN _0,336
	STD  Y+11,R30
	STD  Y+11+1,R31
;    1301 	if(wrk_state[sub_ind1]==wsON)ptrs[5]=" Стоп           "; 
	CALL SUBOPT_0x3F
	BRNE _0x13D
	__POINTW1FN _0,353
	RJMP _0x26A
;    1302 	else ptrs[5]=" Старт          ";	
_0x13D:
	__POINTW1FN _0,370
_0x26A:
	STD  Y+13,R30
	STD  Y+13+1,R31
;    1303 	ptrs[6]=" Выход          ";
	__POINTW1FN _0,246
	STD  Y+15,R30
	STD  Y+15+1,R31
;    1304 	ptrs[7]=" Калибровка     "; 
	__POINTW1FN _0,387
	STD  Y+17,R30
	STD  Y+17+1,R31
;    1305 	if(index_set>sub_ind)index_set=sub_ind;
	CP   R11,R13
	BRGE _0x13F
	MOV  R13,R11
;    1306 	else if(index_set<(sub_ind-1))index_set=sub_ind-1;
	RJMP _0x140
_0x13F:
	CALL SUBOPT_0x3C
	BRGE _0x141
	CALL SUBOPT_0x3D
;    1307 
;    1308 	bgnd_par(ptrs[index_set],ptrs[index_set+1]);
_0x141:
_0x140:
	CALL SUBOPT_0x3E
;    1309 	int2lcd(sub_ind1+1,'!',0);
	CALL SUBOPT_0x40
	CALL _int2lcd
;    1310 	int2lcd(t_ust[sub_ind1],'>',0);
	CALL SUBOPT_0x41
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(62)
	CALL SUBOPT_0x1C
	CALL _int2lcd
;    1311 	if(wrk_state[sub_ind1]==wsON)
	CALL SUBOPT_0x3F
	BRNE _0x142
;    1312 		{
;    1313 		sub_bgnd("ВКЛ.",'@',0);
	__POINTW1FN _0,263
	CALL SUBOPT_0x39
	CALL _sub_bgnd
;    1314 		int2lcd(wrk_time_cnt[sub_ind1]%60,'^',0);
	MOV  R30,R12
	CALL SUBOPT_0x15
	CALL SUBOPT_0x42
	CALL __MODW21
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(94)
	CALL SUBOPT_0x1C
	CALL _int2lcd
;    1315 		int2lcd(wrk_time_cnt[sub_ind1]/60,'$',0);
	MOV  R30,R12
	CALL SUBOPT_0x15
	CALL SUBOPT_0x42
	CALL __DIVW21
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x43
;    1316 		if((ee_time_mode[sub_ind1]==0)||(wrk_time_cnt_flag[sub_ind1]==1))
	BREQ _0x144
	MOV  R30,R12
	LDI  R26,LOW(_wrk_time_cnt_flag)
	LDI  R27,HIGH(_wrk_time_cnt_flag)
	CALL SUBOPT_0x44
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x143
_0x144:
;    1317 			{
;    1318 			if(bFL2)lcd_buffer[find('%')]=':';
	SBRS R3,6
	RJMP _0x146
	CALL SUBOPT_0x45
	LDI  R30,LOW(58)
	RJMP _0x26B
;    1319 			else lcd_buffer[find('%')]=' ';
_0x146:
	CALL SUBOPT_0x45
	LDI  R30,LOW(32)
_0x26B:
	ST   X,R30
;    1320 			} 
;    1321 		else lcd_buffer[find('%')]=':';
	RJMP _0x148
_0x143:
	CALL SUBOPT_0x45
	LDI  R30,LOW(58)
	ST   X,R30
_0x148:
;    1322 		}
;    1323 	else 
	RJMP _0x149
_0x142:
;    1324 		{
;    1325 		sub_bgnd("ВЫКЛ.",'@',0);
	__POINTW1FN _0,56
	CALL SUBOPT_0x39
	CALL _sub_bgnd
;    1326 		sub_bgnd("    ",'^',-3);
	__POINTW1FN _0,13
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(94)
	ST   -Y,R30
	LDI  R30,LOW(253)
	ST   -Y,R30
	CALL _sub_bgnd
;    1327 		}
_0x149:
;    1328 	if(index_set)
	TST  R13
	BREQ _0x14A
;    1329 		{
;    1330 		if((sub_ind-index_set)==1)lcd_buffer[16]=1; 
	MOV  R30,R11
	SUB  R30,R13
	CPI  R30,LOW(0x1)
	BRNE _0x14B
	LDI  R30,LOW(1)
	__PUTB1MN _lcd_buffer,16
;    1331 		else if(sub_ind==index_set)lcd_buffer[0]=1;
	RJMP _0x14C
_0x14B:
	CP   R13,R11
	BRNE _0x14D
	LDI  R30,LOW(1)
	STS  _lcd_buffer,R30
;    1332 		} 
_0x14D:
_0x14C:
;    1333 	int2lcd(ee_wrk_time[sub_ind1]/60,'(',0);
_0x14A:
	MOV  R30,R12
	CALL SUBOPT_0x7
	MOVW R26,R30
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __DIVW21
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(40)
	CALL SUBOPT_0x1C
	CALL _int2lcd
;    1334 	int2lcd(ee_wrk_time[sub_ind1]%60,')',0);
	MOV  R30,R12
	CALL SUBOPT_0x7
	MOVW R26,R30
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __MODW21
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(41)
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x43
;    1335 	if(ee_time_mode[sub_ind1]==0)int2lcd(1,'<',0);
	BRNE _0x14E
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x26C
;    1336 	else int2lcd(2,'<',0); 
_0x14E:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
_0x26C:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(60)
	CALL SUBOPT_0x1C
	CALL _int2lcd
;    1337 	if(nd[sub_ind1])sub_bgnd("Н.Д. ",'#',-2);
	CALL SUBOPT_0x46
	BREQ _0x150
	__POINTW1FN _0,404
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(35)
	CALL SUBOPT_0x47
;    1338 	else 
	RJMP _0x151
_0x150:
;    1339 		{
;    1340 		int2lcd(temper[sub_ind1],'#',0);
	CALL SUBOPT_0x48
	CALL SUBOPT_0x3A
	CALL _int2lcd
;    1341 		lcd_buffer[find('g')]=2;
	CALL SUBOPT_0x38
;    1342 		}
_0x151:
;    1343 	lcd_buffer[find('g')]=2;	
	CALL SUBOPT_0x38
;    1344 	
;    1345 	if(out_st[sub_ind1])lcd_buffer[find('o')]=3;	
	MOV  R30,R12
	LDI  R31,0
	SUBI R30,LOW(-_out_st)
	SBCI R31,HIGH(-_out_st)
	LD   R30,Z
	CPI  R30,0
	BREQ _0x152
	CALL SUBOPT_0x49
	LDI  R30,LOW(3)
	RJMP _0x26D
;    1346 	else lcd_buffer[find('o')]=' ';
_0x152:
	CALL SUBOPT_0x49
	LDI  R30,LOW(32)
_0x26D:
	ST   X,R30
;    1347  /*	int2lcdxy(adc_bank_[const_of_adc[sub_ind1]],0xf0,0);
;    1348 	int2lcdxy(nd[0],0x70,0);
;    1349 	int2lcdxy(nd[1],0x80,0);
;    1350 	int2lcdxy(nd[2],0x90,0);
;    1351 	int2lcdxy(nd[3],0xa0,0);*/
;    1352 	}
;    1353 	
;    1354 else if(ind==iK)
	RJMP _0x154
_0x13C:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x155
;    1355 	{
;    1356 	ptrs[0]=" T!      @gC    ";
	__POINTW1FN _0,410
	STD  Y+3,R30
	STD  Y+3+1,R31
;    1357 	ptrs[1]=" Выход          ";
	__POINTW1FN _0,246
	STD  Y+5,R30
	STD  Y+5+1,R31
;    1358 	bgnd_par("   КАЛИБРОВКА   ",ptrs[sub_ind]);
	__POINTW1FN _0,427
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R11
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,5
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	CALL _bgnd_par
;    1359 	int2lcd(sub_ind1+1,'!',0); 
	CALL SUBOPT_0x40
	CALL _int2lcd
;    1360 	if(nd[sub_ind1])sub_bgnd("Н.Д. ",'@',-2);
	CALL SUBOPT_0x46
	BREQ _0x156
	__POINTW1FN _0,404
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(64)
	CALL SUBOPT_0x47
;    1361 	else 
	RJMP _0x157
_0x156:
;    1362 		{
;    1363 		int2lcd(temper[sub_ind1],'@',0);
	CALL SUBOPT_0x48
	CALL SUBOPT_0x39
	CALL _int2lcd
;    1364 		lcd_buffer[find('g')]=2; 
	CALL SUBOPT_0x38
;    1365 		}	
_0x157:
;    1366 			
;    1367 
;    1368 	if(sub_ind)lcd_buffer[16]=1;
	TST  R11
	BREQ _0x158
	LDI  R30,LOW(1)
	__PUTB1MN _lcd_buffer,16
;    1369 	
;    1370     /*	int2lcdxy(adc_bank_[const_of_adc[sub_ind1]],0x50,0);
;    1371 	int2lcdxy(K_t[sub_ind1],0xc0,0); */
;    1372 	}
_0x158:
;    1373 		
;    1374 
;    1375 
;    1376 if(cnt_ind_nd) 	
_0x155:
_0x154:
_0x13B:
_0x12B:
_0x129:
	LDS  R30,_cnt_ind_nd
	CPI  R30,0
	BREQ _0x159
;    1377 	{
;    1378 	bgnd_par(		"     ДАТЧИК     ",
;    1379  				"   НЕИСПРАВЕН   ");
	__POINTW1FN _0,444
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0,461
	ST   -Y,R31
	ST   -Y,R30
	CALL _bgnd_par
;    1380  	}		
;    1381 			 	
;    1382 /*bgnd(mess_Zero);
;    1383 int2lcdxy(adc_bank_[0],0x30,0);
;    1384 int2lcdxy(adc_bank_[1],0x70,0);
;    1385 int2lcdxy(adc_bank_[2],0xb0,0);
;    1386 int2lcdxy(adc_bank_[3],0xf0,0); 
;    1387 int2lcdxy(adc_bank_[4],0x31,0);
;    1388 int2lcdxy(adc_bank_[5],0x71,0);*/
;    1389 //int2lcdxy(adc_bank_[5],0xb0,0);
;    1390 //int2lcdxy(adc_bank_[6],0xf0,0);		
;    1391 /*//int2lcdxy(ind,0x30,0);
;    1392 //int2lcdxy(av_,0x70,0);
;    1393 //int2lcdxy(but,0xb0,0);
;    1394 //	int2lcdxy(temper_cnt1,0xe0,0);
;    1395 //	int2lcdxy(St,0x20,0);
;    1396 //	int2lcdxy(St1,0x50,0);
;    1397 //int2lcdxy(ctrl_stat,0x00,0); 
;    1398 /*int2lcdxy(St1,0xf0,0);
;    1399 int2lcdxy(St2,0xf1,0);
;    1400 int2lcdxy(St,0x20,0);*/
;    1401 /*int2lcdxy(K[ist],0x10,0); 
;    1402 int2lcdxy(St1,0x21,0);
;    1403 int2lcdxy(St2,0x51,0); */
;    1404 /*int2lcdxy(u_necc,0xa0,0);   
;    1405 int2lcdxy(u_necc,0xa0,0);*/
;    1406 //int2lcdxy(cntrl_stat,0x20,0);
;    1407 //int2lcdxy(cnt_blok,0x60,0); 
;    1408 //int2lcdxy(Ibat_p,0x70,0);
;    1409 //int2lcdxy(Ibat_mp,0xB0,0);
;    1410 //int2lcdxy(St,0xf0,0);
;    1411 
;    1412 //int2lcdxy(kb_cnt,0xa0,0);
;    1413 
;    1414 
;    1415 /*
;    1416 int2lcdxy(tzas_cnt,0xa0,0);
;    1417 int2lcdxy(cntrl_stat,0x20,0);*/
;    1418 
;    1419 //int2lcdxy(St_[1],0xf1,0);
;    1420 //int2lcdxy(St_[0],0xf0,0);
;    1421 
;    1422 //int2lcdxy(OFFBP1,0x10,0);
;    1423 //int2lcdxy(cnt_av_umin[0],0x30,0);
;    1424 //int2lcdxy(cnt_ubat,0xf0,0); 
;    1425 //int2lcdxy(cnt_ibat,0xc0,0); 
;    1426 
;    1427 //int2lcdxy(av_rele,0x20,0);
;    1428 //int2lcdxy(av_beep,0x50,0);
;    1429 //int2lcdxy(hour_apv_cnt,0xa0,0); 
;    1430 
;    1431 //int2lcdxy(main_apv_cnt,0xf0,0);
;    1432 //int2lcdxy(hour_apv_cnt,0xd0,0);
;    1433 
;    1434 
;    1435 //int2lcdxy(sub_ind,0x20,0);
;    1436 
;    1437 //int2lcdxy(OFFBP2,0xf0,0);
;    1438 //int2lcdxy(OFFBP1,0xe0,0);
;    1439 //int2lcdxy(St_[1],0xc0,0);
;    1440 //int2lcdxy(St_[0],0x90,0);
;    1441 //int2lcdxy(tzas_cnt,0x60,0);
;    1442 //int2lcdxy(num_necc,0x30,0);
;    1443 //int2lcdxy(adc_bank_[0],0x21,0); 
;    1444 
;    1445 /**/
;    1446 /*int2lcdxy(reset_apv_cnt,0xf0,0);
;    1447 int2lcdxy(main_apv_cnt,0x20,0);
;    1448 int2lcdxy(apv_cnt_1,0x70,0);
;    1449 int2lcdxy(hour_apv_cnt,0x21,0);*/
;    1450 
;    1451 /*int2lcdxy(cntrl_stat1,0x30,0);
;    1452 int2lcdxy(cntrl_stat2,0x31,0);
;    1453 int2lcdxy(Is[1],0xf1,0);
;    1454 int2lcdxy(Is[0],0xf0,0); */
;    1455 ruslcd(lcd_buffer);
_0x159:
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _ruslcd
;    1456 }
	CALL __LOADLOCR3
	ADIW R28,25
	RET
;    1457 
;    1458 
;    1459 // Константы состояния кнопок
;    1460 #define butL 		0b10111111
;    1461 #define butR 		0b01111111
;    1462 #define butU 		0b11101111
;    1463 #define butD 		0b11011111
;    1464 #define butE   	0b11110111
;    1465 #define butL_ 		0b10111110
;    1466 #define butR_ 		0b01111110
;    1467 #define butU_ 		0b11101110
;    1468 #define butD_ 		0b11011110
;    1469 #define butE_   	0b11110110
;    1470 #define butLR 		0b00111111 
;    1471 #define butLR_ 	0b00111110
;    1472 #define butUD 		0b11001111
;    1473 #define butS 		0b11111101
;    1474 
;    1475 
;    1476 //-----------------------------------------------
;    1477 // Подпрограмма драйва до 7 кнопок одного порта, 
;    1478 // различает короткое и длинное нажатие,
;    1479 // срабатывает на отпускание кнопки, возможность
;    1480 // ускорения перебора при длинном нажатии...
;    1481 #define but_port PORTB
;    1482 #define but_dir  DDRB
;    1483 #define but_pin  PINB
;    1484 #define but_mask 0b00000111
;    1485 #define no_but   0b11111111
;    1486 #define but_on   5
;    1487 #define but_onL  20
;    1488 
;    1489 static char but_n;

	.DSEG
_but_n_G1:
	.BYTE 0x1
;    1490 static char but_s;
_but_s_G1:
	.BYTE 0x1
;    1491 static char but0_cnt;
_but0_cnt_G1:
	.BYTE 0x1
;    1492 static char but1_cnt;
_but1_cnt_G1:
	.BYTE 0x1
;    1493 static char but_onL_temp;
_but_onL_temp_G1:
	.BYTE 0x1
;    1494 
;    1495 
;    1496 void but_drv(void)
;    1497 { 

	.CSEG
_but_drv:
;    1498 
;    1499 
;    1500 
;    1501 but_port|=(but_mask^0xff);
	CALL SUBOPT_0x4A
;    1502 but_dir/*&=but_mask*/=0b00100110;
	LDI  R30,LOW(38)
	OUT  0x17,R30
;    1503 #asm
;    1504 nop
nop
;    1505 nop
nop
;    1506 nop
nop
;    1507 nop
nop
;    1508 #endasm

;    1509 
;    1510 but_n=but_pin|but_mask; 
	IN   R30,0x16
	ORI  R30,LOW(0x7)
	STS  _but_n_G1,R30
;    1511 
;    1512 but_port|=(but_mask^0xff);
	CALL SUBOPT_0x4A
;    1513 but_dir/*&=but_mask*/=0b11011110;
	LDI  R30,LOW(222)
	OUT  0x17,R30
;    1514 #asm
;    1515 nop
nop
;    1516 nop
nop
;    1517 nop
nop
;    1518 nop
nop
;    1519 #endasm

;    1520 
;    1521 but_n&=(but_pin|0b11011111); 
	IN   R30,0x16
	ORI  R30,LOW(0xDF)
	LDS  R26,_but_n_G1
	AND  R30,R26
	STS  _but_n_G1,R30
;    1522 
;    1523 
;    1524 //plazma=but_pin;
;    1525 
;    1526 if((but_n==no_but)||(but_n!=but_s))
	LDS  R26,_but_n_G1
	CPI  R26,LOW(0xFF)
	BREQ _0x15B
	CALL SUBOPT_0x4B
	BREQ _0x15A
_0x15B:
;    1527  	{
;    1528  	speed=0;
	CLT
	BLD  R2,7
;    1529    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRSH _0x15E
	LDS  R26,_but1_cnt_G1
	CPI  R26,LOW(0x0)
	BREQ _0x160
_0x15E:
	SBRS R2,5
	RJMP _0x161
_0x160:
	RJMP _0x15D
_0x161:
;    1530   		{
;    1531    	     n_but=1;
	SET
	BLD  R2,6
;    1532           but=but_s;
	LDS  R8,_but_s_G1
;    1533           }
;    1534    	if (but1_cnt>=but_onL_temp)
_0x15D:
	CALL SUBOPT_0x4C
	BRLO _0x162
;    1535   		{
;    1536    	     n_but=1;
	SET
	BLD  R2,6
;    1537           but=but_s&0b11111110;
	CALL SUBOPT_0x4D
;    1538           }
;    1539     	l_but=0;
_0x162:
	CLT
	BLD  R2,5
;    1540    	but_onL_temp=but_onL;
	LDI  R30,LOW(20)
	STS  _but_onL_temp_G1,R30
;    1541     	but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    1542   	but1_cnt=0;          
	STS  _but1_cnt_G1,R30
;    1543      goto but_drv_out;
	RJMP _0x163
;    1544   	}  
;    1545   	
;    1546 if(but_n==but_s)
_0x15A:
	CALL SUBOPT_0x4B
	BRNE _0x164
;    1547  	{
;    1548   	but0_cnt++;
	LDS  R30,_but0_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but0_cnt_G1,R30
;    1549   	if(but0_cnt>=but_on)
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRLO _0x165
;    1550   		{
;    1551    		but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    1552    		but1_cnt++;
	LDS  R30,_but1_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but1_cnt_G1,R30
;    1553    		if(but1_cnt>=but_onL_temp)
	CALL SUBOPT_0x4C
	BRLO _0x166
;    1554    			{              
;    1555     			but=but_s&0b11111110;
	CALL SUBOPT_0x4D
;    1556     			but1_cnt=0;
	LDI  R30,LOW(0)
	STS  _but1_cnt_G1,R30
;    1557     			n_but=1;
	SET
	BLD  R2,6
;    1558     			l_but=1;
	SET
	BLD  R2,5
;    1559 			if(speed)
	SBRS R2,7
	RJMP _0x167
;    1560 				{
;    1561     				but_onL_temp=but_onL_temp>>1;
	LDS  R30,_but_onL_temp_G1
	LSR  R30
	STS  _but_onL_temp_G1,R30
;    1562         			if(but_onL_temp<=2) but_onL_temp=2;
	LDS  R26,_but_onL_temp_G1
	LDI  R30,LOW(2)
	CP   R30,R26
	BRLO _0x168
	STS  _but_onL_temp_G1,R30
;    1563 				}    
_0x168:
;    1564    			}
_0x167:
;    1565   		} 
_0x166:
;    1566  	}
_0x165:
;    1567 but_drv_out:
_0x164:
_0x163:
;    1568 but_s=but_n;
	LDS  R30,_but_n_G1
	STS  _but_s_G1,R30
;    1569 but_port|=(but_mask^0xff);
	CALL SUBOPT_0x4A
;    1570 but_dir&=but_mask;
	IN   R30,0x17
	ANDI R30,LOW(0x7)
	OUT  0x17,R30
;    1571 } 
	RET
;    1572 
;    1573 //-----------------------------------------------
;    1574 void but_an(void)
;    1575 {
_but_an:
;    1576 char temp;
;    1577 int tempU;
;    1578 
;    1579 if (!n_but) goto but_an_end;
	CALL __SAVELOCR3
;	temp -> R16
;	tempU -> R17,R18
	SBRS R2,6
	RJMP _0x16A
;    1580    
;    1581 if (ind==iMn)
	MOV  R0,R6
	OR   R0,R7
	BRNE _0x16B
;    1582 	{
;    1583 	if(but==butD)
	LDI  R30,LOW(223)
	CP   R30,R8
	BRNE _0x16C
;    1584 		{
;    1585 		ind=iMn_;
	CALL SUBOPT_0x4E
;    1586 		sub_ind=0;
;    1587 		index_set=0;
	CLR  R13
;    1588 		}
;    1589 		
;    1590 	else if(but==butUD)
	RJMP _0x16D
_0x16C:
	LDI  R30,LOW(207)
	CP   R30,R8
	BRNE _0x16E
;    1591 		{
;    1592 		ind=iDeb;
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	__PUTW1R 6,7
;    1593 		}		
;    1594 		
;    1595 	}   
_0x16E:
_0x16D:
;    1596 
;    1597 else if (ind==iMn_)
	RJMP _0x16F
_0x16B:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R6
	CPC  R31,R7
	BREQ PC+3
	JMP _0x170
;    1598 	{
;    1599 	if(but==butU)
	LDI  R30,LOW(239)
	CP   R30,R8
	BRNE _0x171
;    1600 		{
;    1601 		sub_ind--;
	DEC  R11
;    1602 		gran_char(&sub_ind,0,4);
	CALL SUBOPT_0x4F
;    1603 		}
;    1604 
;    1605 	else if(but==butD)
	RJMP _0x172
_0x171:
	LDI  R30,LOW(223)
	CP   R30,R8
	BRNE _0x173
;    1606 		{
;    1607 		sub_ind++;
	INC  R11
;    1608 		gran_char(&sub_ind,0,4);
	CALL SUBOPT_0x4F
;    1609 		}
;    1610 
;    1611 	else if(but==butL)
	RJMP _0x174
_0x173:
	LDI  R30,LOW(191)
	CP   R30,R8
	BRNE _0x175
;    1612 		{
;    1613 		ind=iMn;
	CLR  R6
	CLR  R7
;    1614 		sub_ind=0;
	CLR  R11
;    1615 		}
;    1616 				
;    1617 	else if(but==butE_)
	RJMP _0x176
_0x175:
	LDI  R30,LOW(246)
	CP   R30,R8
	BRNE _0x177
;    1618 		{
;    1619 		if(sub_ind<4)
	LDI  R30,LOW(4)
	CP   R11,R30
	BRGE _0x178
;    1620 			{
;    1621 			if(wrk_state[sub_ind]==wsOFF)
	MOV  R30,R11
	LDI  R26,LOW(_wrk_state)
	LDI  R27,HIGH(_wrk_state)
	CALL SUBOPT_0x50
	CALL __EEPROMRDW
	SBIW R30,0
	BRNE _0x179
;    1622 				{
;    1623 				if(!nd[sub_ind])start_process(sub_ind);
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-_nd)
	SBCI R31,HIGH(-_nd)
	LD   R30,Z
	CPI  R30,0
	BRNE _0x17A
	ST   -Y,R11
	CALL _start_process
;    1624 				else cnt_ind_nd=20;
	RJMP _0x17B
_0x17A:
	LDI  R30,LOW(20)
	STS  _cnt_ind_nd,R30
_0x17B:
;    1625 				}
;    1626 			else stop_process(sub_ind);
	RJMP _0x17C
_0x179:
	ST   -Y,R11
	CALL _stop_process
_0x17C:
;    1627 			}
;    1628 		} 
_0x178:
;    1629 	else if(but==butE)
	RJMP _0x17D
_0x177:
	LDI  R30,LOW(247)
	CP   R30,R8
	BRNE _0x17E
;    1630 		{
;    1631 		if(sub_ind<4)
	LDI  R30,LOW(4)
	CP   R11,R30
	BRGE _0x17F
;    1632 			{
;    1633 			ind=iCh;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	__PUTW1R 6,7
;    1634 			sub_ind1=sub_ind;
	MOV  R12,R11
;    1635 			sub_ind=0;
	RJMP _0x26E
;    1636 			}         
;    1637 		else
_0x17F:
;    1638 			{
;    1639 			ind=iMn;
	CLR  R6
	CLR  R7
;    1640 			sub_ind=0;
_0x26E:
	CLR  R11
;    1641 			}	
;    1642 		}		
;    1643 
;    1644 	}
_0x17E:
_0x17D:
_0x176:
_0x174:
_0x172:
;    1645 else if(ind==iDeb)
	RJMP _0x181
_0x170:
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x182
;    1646 	{
;    1647 	if(but==butUD)
	LDI  R30,LOW(207)
	CP   R30,R8
	BRNE _0x183
;    1648 		{
;    1649 		ind=iMn;
	CLR  R6
	CLR  R7
;    1650 		}
;    1651 	} 
_0x183:
;    1652 
;    1653 else if(ind==iCh)
	RJMP _0x184
_0x182:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R6
	CPC  R31,R7
	BREQ PC+3
	JMP _0x185
;    1654 	{
;    1655 	if(but==butU)
	LDI  R30,LOW(239)
	CP   R30,R8
	BRNE _0x186
;    1656 		{
;    1657 		sub_ind--;
	DEC  R11
;    1658 		if(sub_ind==1)sub_ind=0;
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x187
	CLR  R11
;    1659 		gran_char(&sub_ind,0,7);
_0x187:
	CALL SUBOPT_0x51
;    1660 		}
;    1661 
;    1662 	else if(but==butD)
	RJMP _0x188
_0x186:
	LDI  R30,LOW(223)
	CP   R30,R8
	BRNE _0x189
;    1663 		{
;    1664 		sub_ind++;
	INC  R11
;    1665 		if(sub_ind==1)sub_ind=2;
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x18A
	LDI  R30,LOW(2)
	MOV  R11,R30
;    1666 		gran_char(&sub_ind,0,7);
_0x18A:
	CALL SUBOPT_0x51
;    1667 		}
;    1668 
;    1669 	else if(sub_ind==2)
	RJMP _0x18B
_0x189:
	LDI  R30,LOW(2)
	CP   R30,R11
	BREQ PC+3
	JMP _0x18C
;    1670 		{
;    1671 		if(but==butR)
	LDI  R30,LOW(127)
	CP   R30,R8
	BRNE _0x18D
;    1672 			{
;    1673 			speed=1;
	SET
	BLD  R2,7
;    1674 			t_ust[sub_ind1]++;
	CALL SUBOPT_0x41
	CALL SUBOPT_0x52
;    1675 			gran_ee(&t_ust[sub_ind1],30,140);
	LDI  R26,LOW(_t_ust)
	LDI  R27,HIGH(_t_ust)
	CALL SUBOPT_0x17
	CALL SUBOPT_0x53
;    1676 			} 
;    1677 		else if(but==butR_)
	RJMP _0x18E
_0x18D:
	LDI  R30,LOW(126)
	CP   R30,R8
	BRNE _0x18F
;    1678 			{
;    1679 			speed=1;
	SET
	BLD  R2,7
;    1680 			t_ust[sub_ind1]+=2;
	CALL SUBOPT_0x54
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __EEPROMRDW
	ADIW R30,2
	POP  R26
	POP  R27
	CALL __EEPROMWRW
;    1681 			gran_ee(&t_ust[sub_ind1],30,140);
	CALL SUBOPT_0x54
	CALL SUBOPT_0x53
;    1682 			}			
;    1683 		else if(but==butL)
	RJMP _0x190
_0x18F:
	LDI  R30,LOW(191)
	CP   R30,R8
	BRNE _0x191
;    1684 			{
;    1685 			speed=1;
	SET
	BLD  R2,7
;    1686 			t_ust[sub_ind1]--;
	CALL SUBOPT_0x41
	CALL SUBOPT_0x55
;    1687 			gran_ee(&t_ust[sub_ind1],30,140);
	CALL SUBOPT_0x54
	CALL SUBOPT_0x53
;    1688 			} 
;    1689 		else if(but==butL_)
	RJMP _0x192
_0x191:
	LDI  R30,LOW(190)
	CP   R30,R8
	BRNE _0x193
;    1690 			{
;    1691 			speed=1;
	SET
	BLD  R2,7
;    1692 			t_ust[sub_ind1]-=2;
	CALL SUBOPT_0x54
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __EEPROMRDW
	SBIW R30,2
	POP  R26
	POP  R27
	CALL __EEPROMWRW
;    1693 			gran_ee(&t_ust[sub_ind1],30,140);
	CALL SUBOPT_0x54
	CALL SUBOPT_0x53
;    1694 			}			
;    1695 		}
_0x193:
_0x192:
_0x190:
_0x18E:
;    1696 		
;    1697 	else if(sub_ind==3)
	RJMP _0x194
_0x18C:
	LDI  R30,LOW(3)
	CP   R30,R11
	BREQ PC+3
	JMP _0x195
;    1698 		{
;    1699 		if(but==butR)
	LDI  R30,LOW(127)
	CP   R30,R8
	BRNE _0x196
;    1700 			{
;    1701 			speed=1;
	SET
	BLD  R2,7
;    1702 			ee_wrk_time[sub_ind1]++;
	MOV  R30,R12
	CALL SUBOPT_0x7
	CALL SUBOPT_0x52
;    1703 			gran_ee(&ee_wrk_time[sub_ind1],1,720);
	LDI  R26,LOW(_ee_wrk_time)
	LDI  R27,HIGH(_ee_wrk_time)
	CALL SUBOPT_0x17
	CALL SUBOPT_0x8
	CALL _gran_ee
;    1704 			} 
;    1705 		else if(but==butR_)
	RJMP _0x197
_0x196:
	LDI  R30,LOW(126)
	CP   R30,R8
	BRNE _0x198
;    1706 			{
;    1707 			speed=1;
	SET
	BLD  R2,7
;    1708 			ee_wrk_time[sub_ind1]=((ee_wrk_time[sub_ind1]/10)+1)*10;
	CALL SUBOPT_0x56
	PUSH R31
	PUSH R30
	MOV  R30,R12
	CALL SUBOPT_0x7
	CALL SUBOPT_0x57
	ADIW R30,1
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	POP  R26
	POP  R27
	CALL __EEPROMWRW
;    1709 			gran_ee(&ee_wrk_time[sub_ind1],1,720);
	CALL SUBOPT_0x56
	CALL SUBOPT_0x8
	CALL _gran_ee
;    1710 			}			
;    1711 		else if(but==butL)
	RJMP _0x199
_0x198:
	LDI  R30,LOW(191)
	CP   R30,R8
	BRNE _0x19A
;    1712 			{
;    1713 			speed=1;
	SET
	BLD  R2,7
;    1714 			ee_wrk_time[sub_ind1]--;
	MOV  R30,R12
	CALL SUBOPT_0x7
	CALL SUBOPT_0x55
;    1715 			gran_ee(&ee_wrk_time[sub_ind1],1,720);
	CALL SUBOPT_0x56
	CALL SUBOPT_0x8
	CALL _gran_ee
;    1716 			} 
;    1717 		else if(but==butL_)
	RJMP _0x19B
_0x19A:
	LDI  R30,LOW(190)
	CP   R30,R8
	BRNE _0x19C
;    1718 			{
;    1719 			speed=1;
	SET
	BLD  R2,7
;    1720 			ee_wrk_time[sub_ind1]=((ee_wrk_time[sub_ind1]/10)-1)*10;
	CALL SUBOPT_0x56
	PUSH R31
	PUSH R30
	MOV  R30,R12
	CALL SUBOPT_0x7
	CALL SUBOPT_0x57
	SBIW R30,1
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	POP  R26
	POP  R27
	CALL __EEPROMWRW
;    1721 			gran_ee(&ee_wrk_time[sub_ind1],1,720);
	CALL SUBOPT_0x56
	CALL SUBOPT_0x8
	CALL _gran_ee
;    1722 			}			
;    1723 		}
_0x19C:
_0x19B:
_0x199:
_0x197:
;    1724 	else if(sub_ind==4)
	RJMP _0x19D
_0x195:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0x19E
;    1725 		{
;    1726 		if((but==butR)||(but==butR_))
	LDI  R30,LOW(127)
	CP   R30,R8
	BREQ _0x1A0
	LDI  R30,LOW(126)
	CP   R30,R8
	BRNE _0x19F
_0x1A0:
;    1727 			{
;    1728 			ee_time_mode[sub_ind1]=1;
	CALL SUBOPT_0x58
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EEPROMWRW
;    1729 			} 
;    1730 		else if((but==butL)||(but==butL_))
	RJMP _0x1A2
_0x19F:
	LDI  R30,LOW(191)
	CP   R30,R8
	BREQ _0x1A4
	LDI  R30,LOW(190)
	CP   R30,R8
	BRNE _0x1A3
_0x1A4:
;    1731 			{
;    1732 			ee_time_mode[sub_ind1]=0;
	CALL SUBOPT_0x58
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
;    1733 			} 		
;    1734 		}  
_0x1A3:
_0x1A2:
;    1735 		
;    1736 	else if(sub_ind==5)
	RJMP _0x1A6
_0x19E:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0x1A7
;    1737 		{
;    1738 		if(but==butE_)
	LDI  R30,LOW(246)
	CP   R30,R8
	BRNE _0x1A8
;    1739 			{
;    1740 			if(wrk_state[sub_ind1]==wsON)stop_process(sub_ind1); 
	CALL SUBOPT_0x3F
	BRNE _0x1A9
	ST   -Y,R12
	CALL _stop_process
;    1741 			else 
	RJMP _0x1AA
_0x1A9:
;    1742 				{
;    1743 				if(!nd[sub_ind1])start_process(sub_ind1);
	CALL SUBOPT_0x46
	BRNE _0x1AB
	ST   -Y,R12
	CALL _start_process
;    1744 				else cnt_ind_nd=20;
	RJMP _0x1AC
_0x1AB:
	LDI  R30,LOW(20)
	STS  _cnt_ind_nd,R30
_0x1AC:
;    1745 				}
_0x1AA:
;    1746                }
;    1747           }
_0x1A8:
;    1748 	else if(sub_ind==6)
	RJMP _0x1AD
_0x1A7:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0x1AE
;    1749 		{
;    1750 		if(but==butE)
	LDI  R30,LOW(247)
	CP   R30,R8
	BRNE _0x1AF
;    1751 			{
;    1752 			ind=iMn_;
	CALL SUBOPT_0x4E
;    1753 			sub_ind=0;
;    1754 			} 		
;    1755 		}		
_0x1AF:
;    1756 					
;    1757 	else if(sub_ind==7)
	RJMP _0x1B0
_0x1AE:
	LDI  R30,LOW(7)
	CP   R30,R11
	BRNE _0x1B1
;    1758 		{
;    1759 		if(but==butE_)
	LDI  R30,LOW(246)
	CP   R30,R8
	BRNE _0x1B2
;    1760 			{
;    1761 			ind=iK;
	CALL SUBOPT_0x59
;    1762 			sub_ind=0;
;    1763 			} 		
;    1764 		}												
_0x1B2:
;    1765 	}
_0x1B1:
_0x1B0:
_0x1AD:
_0x1A6:
_0x19D:
_0x194:
_0x18B:
_0x188:
;    1766 else if(ind==iK)
	RJMP _0x1B3
_0x185:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R6
	CPC  R31,R7
	BREQ PC+3
	JMP _0x1B4
;    1767 	{ 
;    1768 	if(but==butU)
	LDI  R30,LOW(239)
	CP   R30,R8
	BRNE _0x1B5
;    1769 		{
;    1770 		sub_ind=0;
	CLR  R11
;    1771 		}         
;    1772 	else if(but==butD)
	RJMP _0x1B6
_0x1B5:
	LDI  R30,LOW(223)
	CP   R30,R8
	BRNE _0x1B7
;    1773 		{
;    1774 		sub_ind=1;
	LDI  R30,LOW(1)
	MOV  R11,R30
;    1775 		} 
;    1776 	else if(sub_ind==0)
	RJMP _0x1B8
_0x1B7:
	TST  R11
	BREQ PC+3
	JMP _0x1B9
;    1777 		{              
;    1778 		if(but==butR)
	LDI  R30,LOW(127)
	CP   R30,R8
	BRNE _0x1BA
;    1779 			{
;    1780 			speed=1;
	SET
	BLD  R2,7
;    1781 			K_t[sub_ind1]++;
	CALL SUBOPT_0x5A
	CALL __EEPROMRDW
	CALL SUBOPT_0x52
;    1782 			gran_ee(&K_t[sub_ind1],-1000,1000);
	LDI  R26,LOW(_K_t)
	LDI  R27,HIGH(_K_t)
	CALL SUBOPT_0x17
	CALL SUBOPT_0x5B
;    1783 			} 
;    1784 		else if(but==butR_)
	RJMP _0x1BB
_0x1BA:
	LDI  R30,LOW(126)
	CP   R30,R8
	BRNE _0x1BC
;    1785 			{
;    1786 			speed=1;
	SET
	BLD  R2,7
;    1787 			K_t[sub_ind1]+=10;
	CALL SUBOPT_0x5C
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __EEPROMRDW
	ADIW R30,10
	POP  R26
	POP  R27
	CALL __EEPROMWRW
;    1788 			gran_ee(&K_t[sub_ind1],-1000,1000);
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5B
;    1789 			}
;    1790 		else if(but==butL)
	RJMP _0x1BD
_0x1BC:
	LDI  R30,LOW(191)
	CP   R30,R8
	BRNE _0x1BE
;    1791 			{ 
;    1792 			speed=1;
	SET
	BLD  R2,7
;    1793 			K_t[sub_ind1]--;
	CALL SUBOPT_0x5A
	CALL __EEPROMRDW
	CALL SUBOPT_0x55
;    1794 			gran_ee(&K_t[sub_ind1],-1000,1000);
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5B
;    1795 			}
;    1796 		else if(but==butL_)
	RJMP _0x1BF
_0x1BE:
	LDI  R30,LOW(190)
	CP   R30,R8
	BRNE _0x1C0
;    1797 			{
;    1798 			speed=1;
	SET
	BLD  R2,7
;    1799 			K_t[sub_ind1]-=10;
	CALL SUBOPT_0x5C
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __EEPROMRDW
	SBIW R30,10
	POP  R26
	POP  R27
	CALL __EEPROMWRW
;    1800 			gran_ee(&K_t[sub_ind1],-1000,1000);
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5B
;    1801 			}									
;    1802 		}
_0x1C0:
_0x1BF:
_0x1BD:
_0x1BB:
;    1803 	else if(sub_ind==1)
	RJMP _0x1C1
_0x1B9:
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x1C2
;    1804 		{
;    1805 		if(but==butE)
	LDI  R30,LOW(247)
	CP   R30,R8
	BRNE _0x1C3
;    1806 			{   
;    1807 			ind=iCh;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	__PUTW1R 6,7
;    1808 			sub_ind=6;
	LDI  R30,LOW(6)
	MOV  R11,R30
;    1809 			}
;    1810 		}		  			
_0x1C3:
;    1811 	}	
_0x1C2:
_0x1C1:
_0x1B8:
_0x1B6:
;    1812 		
;    1813 else if(ind==iSet)
	RJMP _0x1C4
_0x1B4:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R6
	CPC  R31,R7
	BREQ PC+3
	JMP _0x1C5
;    1814 	{
;    1815 	if(sub_ind==0)
	TST  R11
	BRNE _0x1C6
;    1816 		{
;    1817 	//	if(but==butR)ee_mode=emAVT;
;    1818     //		else if(but==butL)ee_mode=emMNL;
;    1819 	//	else if(but==butE)
;    1820 	 //		{
;    1821 	 //		if(ee_mode==emMNL)ee_mode=emAVT;
;    1822 	 //		else ee_mode=emMNL;
;    1823 	 //		}
;    1824 	 //	else if(but==butD)
;    1825 	 //		{
;    1826 	 //		sub_ind=1;
;    1827 	 //		}
;    1828 		}
;    1829 	else if(sub_ind==1)
	RJMP _0x1C7
_0x1C6:
	LDI  R30,LOW(1)
	CP   R30,R11
	BREQ PC+3
	JMP _0x1C8
;    1830 		{
;    1831 		if((but==butR)||(but==butR_))
	LDI  R30,LOW(127)
	CP   R30,R8
	BREQ _0x1CA
	LDI  R30,LOW(126)
	CP   R30,R8
	BRNE _0x1C9
_0x1CA:
;    1832 			{
;    1833 			speed=1;
	SET
	BLD  R2,7
;    1834 			if(!nakal_cnt)nakal_cnt=300;
	LDS  R30,_nakal_cnt
	LDS  R31,_nakal_cnt+1
	SBIW R30,0
	BRNE _0x1CC
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	STS  _nakal_cnt,R30
	STS  _nakal_cnt+1,R31
;    1835 			else if((nakal_cnt>=200)&&(nakal_cnt<300))
	RJMP _0x1CD
_0x1CC:
	LDS  R26,_nakal_cnt
	LDS  R27,_nakal_cnt+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLT _0x1CF
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRLT _0x1D0
_0x1CF:
	RJMP _0x1CE
_0x1D0:
;    1836 				{
;    1837 				ee_pwm++;
	LDI  R26,LOW(_ee_pwm)
	LDI  R27,HIGH(_ee_pwm)
	CALL __EEPROMRDB
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
;    1838 				
;    1839 				//gran_char_ee(&ee_pwm,5,250);
;    1840 				}
;    1841 			}
_0x1CE:
_0x1CD:
;    1842 		else if((but==butL)||(but==butL_))
	RJMP _0x1D1
_0x1C9:
	LDI  R30,LOW(191)
	CP   R30,R8
	BREQ _0x1D3
	LDI  R30,LOW(190)
	CP   R30,R8
	BRNE _0x1D2
_0x1D3:
;    1843 			{
;    1844 			speed=1;
	SET
	BLD  R2,7
;    1845 			if(!nakal_cnt)nakal_cnt=300;
	LDS  R30,_nakal_cnt
	LDS  R31,_nakal_cnt+1
	SBIW R30,0
	BRNE _0x1D5
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	STS  _nakal_cnt,R30
	STS  _nakal_cnt+1,R31
;    1846 			else if((nakal_cnt>=200)&&(nakal_cnt<300))
	RJMP _0x1D6
_0x1D5:
	LDS  R26,_nakal_cnt
	LDS  R27,_nakal_cnt+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLT _0x1D8
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRLT _0x1D9
_0x1D8:
	RJMP _0x1D7
_0x1D9:
;    1847 				{
;    1848 				ee_pwm--;
	LDI  R26,LOW(_ee_pwm)
	LDI  R27,HIGH(_ee_pwm)
	CALL __EEPROMRDB
	SUBI R30,LOW(1)
	CALL __EEPROMWRB
	SUBI R30,-LOW(1)
;    1849 				//gran_char_ee(&ee_pwm,5,250);
;    1850 				}
;    1851 			}
_0x1D7:
_0x1D6:
;    1852 		else if(but==butD)
	RJMP _0x1DA
_0x1D2:
	LDI  R30,LOW(223)
	CP   R30,R8
	BRNE _0x1DB
;    1853 			{
;    1854 			sub_ind=2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;    1855 			}
;    1856 		if(ee_pwm>250)ee_pwm=250;
_0x1DB:
_0x1DA:
_0x1D1:
	LDI  R26,LOW(_ee_pwm)
	LDI  R27,HIGH(_ee_pwm)
	CALL __EEPROMRDB
	MOV  R26,R30
	LDI  R30,LOW(250)
	CP   R30,R26
	BRSH _0x1DC
	LDI  R26,LOW(_ee_pwm)
	LDI  R27,HIGH(_ee_pwm)
	CALL __EEPROMWRB
;    1857 		if(ee_pwm<5)ee_pwm=5;		
_0x1DC:
	LDI  R26,LOW(_ee_pwm)
	LDI  R27,HIGH(_ee_pwm)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x5)
	BRSH _0x1DD
	LDI  R30,LOW(5)
	LDI  R26,LOW(_ee_pwm)
	LDI  R27,HIGH(_ee_pwm)
	CALL __EEPROMWRB
;    1858 		}
_0x1DD:
;    1859 			
;    1860 	else if(sub_ind==2)
	RJMP _0x1DE
_0x1C8:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x1DF
;    1861 		{
;    1862 		if((but==butR)||(but==butR_))
	LDI  R30,LOW(127)
	CP   R30,R8
	BREQ _0x1E1
	LDI  R30,LOW(126)
	CP   R30,R8
	BRNE _0x1E0
_0x1E1:
;    1863 			{
;    1864 			speed=1;
	SET
	BLD  R2,7
;    1865 			//ee_nagrev_time++;
;    1866 		//	gran_ee(&ee_nagrev_time,10,1000);
;    1867 			}
;    1868 		else if((but==butL)||(but==butL_))
	RJMP _0x1E3
_0x1E0:
	LDI  R30,LOW(191)
	CP   R30,R8
	BREQ _0x1E5
	LDI  R30,LOW(190)
	CP   R30,R8
	BRNE _0x1E4
_0x1E5:
;    1869 			{
;    1870 			speed=1;
	SET
	BLD  R2,7
;    1871 			//ee_nagrev_time--;
;    1872 			//gran_ee(&ee_nagrev_time,10,1000);
;    1873 			}
;    1874 		else if(but==butD)
	RJMP _0x1E7
_0x1E4:
	LDI  R30,LOW(223)
	CP   R30,R8
	BRNE _0x1E8
;    1875 			{
;    1876 			sub_ind=3;
	LDI  R30,LOW(3)
	MOV  R11,R30
;    1877 			}
;    1878 		else if(but==butU)
	RJMP _0x1E9
_0x1E8:
	LDI  R30,LOW(239)
	CP   R30,R8
	BRNE _0x1EA
;    1879 			{
;    1880 			sub_ind=1;
	LDI  R30,LOW(1)
	MOV  R11,R30
;    1881 			}					
;    1882 		}		
_0x1EA:
_0x1E9:
_0x1E7:
_0x1E3:
;    1883 	else if(sub_ind==3)
	RJMP _0x1EB
_0x1DF:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0x1EC
;    1884 		{
;    1885 		if((but==butR)||(but==butR_))
	LDI  R30,LOW(127)
	CP   R30,R8
	BREQ _0x1EE
	LDI  R30,LOW(126)
	CP   R30,R8
	BRNE _0x1ED
_0x1EE:
;    1886 			{
;    1887 			speed=1;
	SET
	BLD  R2,7
;    1888 			//ee_wrk_time++;
;    1889 			//gran_ee(&ee_wrk_time,10,1000);
;    1890 			}
;    1891 		else if((but==butL)||(but==butL_))
	RJMP _0x1F0
_0x1ED:
	LDI  R30,LOW(191)
	CP   R30,R8
	BREQ _0x1F2
	LDI  R30,LOW(190)
	CP   R30,R8
	BRNE _0x1F1
_0x1F2:
;    1892 			{
;    1893 			speed=1;
	SET
	BLD  R2,7
;    1894 			//ee_wrk_time--;
;    1895 			//gran_ee(&ee_wrk_time,10,1000);
;    1896 			}
;    1897 		else if(but==butD)
	RJMP _0x1F4
_0x1F1:
	LDI  R30,LOW(223)
	CP   R30,R8
	BRNE _0x1F5
;    1898 			{
;    1899 			sub_ind=4;
	LDI  R30,LOW(4)
	MOV  R11,R30
;    1900 			}
;    1901 		else if(but==butU)
	RJMP _0x1F6
_0x1F5:
	LDI  R30,LOW(239)
	CP   R30,R8
	BRNE _0x1F7
;    1902 			{
;    1903 			sub_ind=2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;    1904 			}					
;    1905 		}
_0x1F7:
_0x1F6:
_0x1F4:
_0x1F0:
;    1906 	else if(sub_ind==4)
	RJMP _0x1F8
_0x1EC:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0x1F9
;    1907 		{
;    1908 		if((but==butR)||(but==butR_))
	LDI  R30,LOW(127)
	CP   R30,R8
	BREQ _0x1FB
	LDI  R30,LOW(126)
	CP   R30,R8
	BRNE _0x1FA
_0x1FB:
;    1909 			{
;    1910 			speed=1;
	SET
	BLD  R2,7
;    1911 			//ee_ostiv_time++;
;    1912 			//gran_ee(&ee_ostiv_time,10,1000);
;    1913 			}
;    1914 		else if((but==butL)||(but==butL_))
	RJMP _0x1FD
_0x1FA:
	LDI  R30,LOW(191)
	CP   R30,R8
	BREQ _0x1FF
	LDI  R30,LOW(190)
	CP   R30,R8
	BRNE _0x1FE
_0x1FF:
;    1915 			{
;    1916 			speed=1;
	SET
	BLD  R2,7
;    1917 			//ee_ostiv_time--;
;    1918 			//gran_ee(&ee_ostiv_time,10,1000);
;    1919 			}
;    1920 		else if(but==butD)
	RJMP _0x201
_0x1FE:
	LDI  R30,LOW(223)
	CP   R30,R8
	BRNE _0x202
;    1921 			{
;    1922 			sub_ind=5;
	LDI  R30,LOW(5)
	MOV  R11,R30
;    1923 			}
;    1924 		else if(but==butU)
	RJMP _0x203
_0x202:
	LDI  R30,LOW(239)
	CP   R30,R8
	BRNE _0x204
;    1925 			{
;    1926 			sub_ind=3;
	LDI  R30,LOW(3)
	MOV  R11,R30
;    1927 			}					
;    1928 		}			  
_0x204:
_0x203:
_0x201:
_0x1FD:
;    1929 	else if(sub_ind==5)
	RJMP _0x205
_0x1F9:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0x206
;    1930 		{
;    1931 		if(but==butE)
	LDI  R30,LOW(247)
	CP   R30,R8
	BRNE _0x207
;    1932 			{
;    1933 			ind=iMn;
	CALL SUBOPT_0x5D
;    1934 			sub_ind=0;
;    1935 			nakal_cnt=0;
;    1936 			//wrk_state=wsOFF;			
;    1937 			}
;    1938 		else if(but==butD)
	RJMP _0x208
_0x207:
	LDI  R30,LOW(223)
	CP   R30,R8
	BRNE _0x209
;    1939 			{
;    1940 			sub_ind=6;
	LDI  R30,LOW(6)
	MOV  R11,R30
;    1941 			}
;    1942 		else if(but==butU)
	RJMP _0x20A
_0x209:
	LDI  R30,LOW(239)
	CP   R30,R8
	BRNE _0x20B
;    1943 			{
;    1944 			sub_ind=4;
	LDI  R30,LOW(4)
	MOV  R11,R30
;    1945 			}					
;    1946 		}
_0x20B:
_0x20A:
_0x208:
;    1947 	else if(sub_ind==6)
	RJMP _0x20C
_0x206:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0x20D
;    1948 		{
;    1949 		if(but==butE)
	LDI  R30,LOW(247)
	CP   R30,R8
	BRNE _0x20E
;    1950 			{
;    1951 			ind=iK;
	CALL SUBOPT_0x59
;    1952 			sub_ind=0;
;    1953 			nakal_cnt=0;
	LDI  R30,0
	STS  _nakal_cnt,R30
	STS  _nakal_cnt+1,R30
;    1954 			}
;    1955 		else if(but==butU)
	RJMP _0x20F
_0x20E:
	LDI  R30,LOW(239)
	CP   R30,R8
	BRNE _0x210
;    1956 			{
;    1957 			sub_ind=5;
	LDI  R30,LOW(5)
	MOV  R11,R30
;    1958 			}	
;    1959 		}														
_0x210:
_0x20F:
;    1960 	}
_0x20D:
_0x20C:
_0x205:
_0x1F8:
_0x1EB:
_0x1DE:
_0x1C7:
;    1961 	
;    1962 else if(ind==iK)
	RJMP _0x211
_0x1C5:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R6
	CPC  R31,R7
	BREQ PC+3
	JMP _0x212
;    1963 	{
;    1964 	if(sub_ind==0)
	TST  R11
	BREQ PC+3
	JMP _0x213
;    1965 		{
;    1966 		if((but==butR)||(but==butR_))
	LDI  R30,LOW(127)
	CP   R30,R8
	BREQ _0x215
	LDI  R30,LOW(126)
	CP   R30,R8
	BRNE _0x214
_0x215:
;    1967 			{
;    1968 			speed=1;              
	SET
	BLD  R2,7
;    1969 			if(!nakal_cnt)nakal_cnt=300;
	LDS  R30,_nakal_cnt
	LDS  R31,_nakal_cnt+1
	SBIW R30,0
	BRNE _0x217
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	STS  _nakal_cnt,R30
	STS  _nakal_cnt+1,R31
;    1970 			else if((nakal_cnt>=200)&&(nakal_cnt<300))
	RJMP _0x218
_0x217:
	LDS  R26,_nakal_cnt
	LDS  R27,_nakal_cnt+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLT _0x21A
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRLT _0x21B
_0x21A:
	RJMP _0x219
_0x21B:
;    1971 				{
;    1972 				Ku++;
	LDI  R26,LOW(_Ku)
	LDI  R27,HIGH(_Ku)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    1973 				}
;    1974 			gran_ee(&Ku,100,200);
_0x219:
_0x218:
	CALL SUBOPT_0x5E
;    1975 			}
;    1976 		else if((but==butL)||(but==butL_))
	RJMP _0x21C
_0x214:
	LDI  R30,LOW(191)
	CP   R30,R8
	BREQ _0x21E
	LDI  R30,LOW(190)
	CP   R30,R8
	BRNE _0x21D
_0x21E:
;    1977 			{
;    1978 			speed=1;                    
	SET
	BLD  R2,7
;    1979 			if(!nakal_cnt)nakal_cnt=300;
	LDS  R30,_nakal_cnt
	LDS  R31,_nakal_cnt+1
	SBIW R30,0
	BRNE _0x220
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	STS  _nakal_cnt,R30
	STS  _nakal_cnt+1,R31
;    1980 			else if((nakal_cnt>=200)&&(nakal_cnt<300))
	RJMP _0x221
_0x220:
	LDS  R26,_nakal_cnt
	LDS  R27,_nakal_cnt+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLT _0x223
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRLT _0x224
_0x223:
	RJMP _0x222
_0x224:
;    1981 				{
;    1982 				Ku--;
	LDI  R26,LOW(_Ku)
	LDI  R27,HIGH(_Ku)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    1983 				}
;    1984 			gran_ee(&Ku,100,200);
_0x222:
_0x221:
	CALL SUBOPT_0x5E
;    1985 			}
;    1986 		else if(but==butD)
	RJMP _0x225
_0x21D:
	LDI  R30,LOW(223)
	CP   R30,R8
	BRNE _0x226
;    1987 			{
;    1988 			sub_ind=1;
	LDI  R30,LOW(1)
	MOV  R11,R30
;    1989 			}
;    1990 		}
_0x226:
_0x225:
_0x21C:
;    1991 	else if(sub_ind==1)
	RJMP _0x227
_0x213:
	LDI  R30,LOW(1)
	CP   R30,R11
	BREQ PC+3
	JMP _0x228
;    1992 		{
;    1993 		if((but==butR)||(but==butR_))
	LDI  R30,LOW(127)
	CP   R30,R8
	BREQ _0x22A
	LDI  R30,LOW(126)
	CP   R30,R8
	BRNE _0x229
_0x22A:
;    1994 			{
;    1995 			speed=1;                    
	SET
	BLD  R2,7
;    1996 			if(!nakal_cnt)nakal_cnt=300;
	LDS  R30,_nakal_cnt
	LDS  R31,_nakal_cnt+1
	SBIW R30,0
	BRNE _0x22C
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	STS  _nakal_cnt,R30
	STS  _nakal_cnt+1,R31
;    1997 			else if((nakal_cnt>=200)&&(nakal_cnt<300))
	RJMP _0x22D
_0x22C:
	LDS  R26,_nakal_cnt
	LDS  R27,_nakal_cnt+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLT _0x22F
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRLT _0x230
_0x22F:
	RJMP _0x22E
_0x230:
;    1998 				{
;    1999 				Ki++;
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    2000 				}
;    2001 			gran_ee(&Ki,100,200);
_0x22E:
_0x22D:
	CALL SUBOPT_0x5F
;    2002 			}
;    2003 		else if((but==butL)||(but==butL_))
	RJMP _0x231
_0x229:
	LDI  R30,LOW(191)
	CP   R30,R8
	BREQ _0x233
	LDI  R30,LOW(190)
	CP   R30,R8
	BRNE _0x232
_0x233:
;    2004 			{
;    2005 			speed=1;                    
	SET
	BLD  R2,7
;    2006 			if(!nakal_cnt)nakal_cnt=300;
	LDS  R30,_nakal_cnt
	LDS  R31,_nakal_cnt+1
	SBIW R30,0
	BRNE _0x235
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	STS  _nakal_cnt,R30
	STS  _nakal_cnt+1,R31
;    2007 			else if((nakal_cnt>=200)&&(nakal_cnt<300))
	RJMP _0x236
_0x235:
	LDS  R26,_nakal_cnt
	LDS  R27,_nakal_cnt+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLT _0x238
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRLT _0x239
_0x238:
	RJMP _0x237
_0x239:
;    2008 				{
;    2009 				Ki--;
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    2010 				}
;    2011 			gran_ee(&Ki,100,200);
_0x237:
_0x236:
	CALL SUBOPT_0x5F
;    2012 			}
;    2013 		else if(but==butD)
	RJMP _0x23A
_0x232:
	LDI  R30,LOW(223)
	CP   R30,R8
	BRNE _0x23B
;    2014 			{
;    2015 			sub_ind=2;
	LDI  R30,LOW(2)
	MOV  R11,R30
;    2016 			}
;    2017 		else if(but==butU)
	RJMP _0x23C
_0x23B:
	LDI  R30,LOW(239)
	CP   R30,R8
	BRNE _0x23D
;    2018 			{
;    2019 			sub_ind=0;
	CLR  R11
;    2020 			}	    
;    2021 		}		 		                         
_0x23D:
_0x23C:
_0x23A:
_0x231:
;    2022 	else if(sub_ind==2)
	RJMP _0x23E
_0x228:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x23F
;    2023 		{
;    2024 		if(but==butE)
	LDI  R30,LOW(247)
	CP   R30,R8
	BRNE _0x240
;    2025 			{
;    2026 			ind=iMn;
	CALL SUBOPT_0x5D
;    2027 			sub_ind=0;
;    2028 			nakal_cnt=0;
;    2029 			//wrk_state=wsOFF;			
;    2030 			}
;    2031 		else if(but==butU)
	RJMP _0x241
_0x240:
	LDI  R30,LOW(239)
	CP   R30,R8
	BRNE _0x242
;    2032 			{
;    2033 			sub_ind=1;
	LDI  R30,LOW(1)
	MOV  R11,R30
;    2034 			}	  					
;    2035 		}		
_0x242:
_0x241:
;    2036 
;    2037 	}		  			  				
_0x23F:
_0x23E:
_0x227:
;    2038 but_an_end:
_0x212:
_0x211:
_0x1C4:
_0x1B3:
_0x184:
_0x181:
_0x16F:
_0x16A:
;    2039 n_but=0;           
	CLT
	BLD  R2,6
;    2040 }	   
	CALL __LOADLOCR3
	ADIW R28,3
	RET
;    2041 
;    2042 
;    2043 //***********************************************
;    2044 //***********************************************
;    2045 //***********************************************
;    2046 //***********************************************
;    2047 //***********************************************
;    2048 
;    2049 
;    2050 //***********************************************
;    2051 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;    2052 {
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;    2053 static char t0cnt0,t0cnt1,t0cnt2,t0cnt3,t0cnt4,/*t0cnt5,*/t0cnt6;

	.DSEG
_t0cnt0_S26:
	.BYTE 0x1
_t0cnt1_S26:
	.BYTE 0x1
_t0cnt2_S26:
	.BYTE 0x1
_t0cnt3_S26:
	.BYTE 0x1
_t0cnt4_S26:
	.BYTE 0x1
_t0cnt6_S26:
	.BYTE 0x1

	.CSEG
;    2054 char temp;
;    2055 
;    2056 TCNT0=-208; 
	ST   -Y,R16
;	temp -> R16
	LDI  R30,LOW(65328)
	LDI  R31,HIGH(65328)
	OUT  0x32,R30
;    2057 
;    2058 #ifdef MIKRAN
;    2059 bFF=PINB.0;
;    2060 if(bFF!=bFF_)
;    2061 	{
;    2062 	Hz_out++;
;    2063 	}        
;    2064 bFF_=bFF;    
;    2065 #endif
;    2066 
;    2067 if(++t0cnt0_>=6)
	LDS  R26,_t0cnt0_
	SUBI R26,-LOW(1)
	STS  _t0cnt0_,R26
	CPI  R26,LOW(0x6)
	BRLO _0x243
;    2068 	{
;    2069 	t0cnt0_=0;
	LDI  R30,LOW(0)
	STS  _t0cnt0_,R30
;    2070 	}
;    2071 else goto timer1_ovf_isr_end;
	RJMP _0x244
_0x243:
	RJMP _0x245
_0x244:
;    2072 
;    2073 
;    2074 
;    2075 b100Hz=1;
	SET
	BLD  R2,0
;    2076 
;    2077 Hz_cnt++;
	LDS  R30,_Hz_cnt
	LDS  R31,_Hz_cnt+1
	ADIW R30,1
	STS  _Hz_cnt,R30
	STS  _Hz_cnt+1,R31
;    2078 if(Hz_cnt>=978)
	LDS  R26,_Hz_cnt
	LDS  R27,_Hz_cnt+1
	CPI  R26,LOW(0x3D2)
	LDI  R30,HIGH(0x3D2)
	CPC  R27,R30
	BRLT _0x246
;    2079 	{	
;    2080 	Hz_cnt=0;
	LDI  R30,0
	STS  _Hz_cnt,R30
	STS  _Hz_cnt+1,R30
;    2081 	Fnet=Hz_out/2;
	LDS  R30,_Hz_out
	LDS  R31,_Hz_out+1
	ASR  R31
	ROR  R30
	STS  _Fnet,R30
	STS  _Fnet+1,R31
;    2082 	Hz_out=0;
	LDI  R30,0
	STS  _Hz_out,R30
	STS  _Hz_out+1,R30
;    2083 	}
;    2084 
;    2085 
;    2086 #ifdef _CAN_
;    2087 CANst=spi_read_status();
;    2088 if(CANst)
;    2089 	{
;    2090 	bCAN=1;
;    2091 	}  
;    2092 #endif
;    2093 
;    2094 if(++t0cnt0>=10)
_0x246:
	LDS  R26,_t0cnt0_S26
	SUBI R26,-LOW(1)
	STS  _t0cnt0_S26,R26
	CPI  R26,LOW(0xA)
	BRLO _0x247
;    2095 	{
;    2096 	t0cnt0=0;
	LDI  R30,LOW(0)
	STS  _t0cnt0_S26,R30
;    2097 	b10Hz=1;
	SET
	BLD  R2,1
;    2098 	if(++def_char_cnt>=10)def_char_cnt=0;
	LDS  R26,_def_char_cnt
	SUBI R26,-LOW(1)
	STS  _def_char_cnt,R26
	CPI  R26,LOW(0xA)
	BRLO _0x248
	STS  _def_char_cnt,R30
;    2099 	}
_0x248:
;    2100 
;    2101 if(++t0cnt1>=20)
_0x247:
	LDS  R26,_t0cnt1_S26
	SUBI R26,-LOW(1)
	STS  _t0cnt1_S26,R26
	CPI  R26,LOW(0x14)
	BRLO _0x249
;    2102 	{
;    2103 	t0cnt1=0;
	LDI  R30,LOW(0)
	STS  _t0cnt1_S26,R30
;    2104 	b5Hz=1;
	SET
	BLD  R2,2
;    2105 	
;    2106 	}
;    2107 
;    2108 if(++t0cnt2>=50)
_0x249:
	LDS  R26,_t0cnt2_S26
	SUBI R26,-LOW(1)
	STS  _t0cnt2_S26,R26
	CPI  R26,LOW(0x32)
	BRLO _0x24A
;    2109 	{
;    2110 	t0cnt2=0;
	LDI  R30,LOW(0)
	STS  _t0cnt2_S26,R30
;    2111 	b2Hz=1;
	SET
	BLD  R2,3
;    2112 	bFL2=!bFL2;
	LDI  R30,LOW(64)
	EOR  R3,R30
;    2113 	}         
;    2114 
;    2115 if(++t0cnt3>=100)
_0x24A:
	LDS  R26,_t0cnt3_S26
	SUBI R26,-LOW(1)
	STS  _t0cnt3_S26,R26
	CPI  R26,LOW(0x64)
	BRLO _0x24B
;    2116 	{
;    2117 	t0cnt3=0;
	LDI  R30,LOW(0)
	STS  _t0cnt3_S26,R30
;    2118 	b1Hz=1;
	SET
	BLD  R2,4
;    2119 	}
;    2120 timer1_ovf_isr_end:
_0x24B:
_0x245:
;    2121 }
	LD   R16,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;    2122 
;    2123 //===============================================
;    2124 //===============================================
;    2125 //===============================================
;    2126 //===============================================
;    2127 void main(void)
;    2128 {
_main:
;    2129 char temp_char;
;    2130 int temp_int;
;    2131 
;    2132 PORTA=0x00;
;	temp_char -> R16
;	temp_int -> R17,R18
	LDI  R30,LOW(0)
	OUT  0x1B,R30
;    2133 DDRA=0x00;
	OUT  0x1A,R30
;    2134 
;    2135 PORTB=0x10;
	LDI  R30,LOW(16)
	OUT  0x18,R30
;    2136 DDRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x17,R30
;    2137 
;    2138 PORTC=0x00;
	OUT  0x15,R30
;    2139 DDRC=0x00;
	OUT  0x14,R30
;    2140 
;    2141 PORTD=0x00;
	OUT  0x12,R30
;    2142 DDRD=0x30;
	LDI  R30,LOW(48)
	OUT  0x11,R30
;    2143 
;    2144 
;    2145 
;    2146 
;    2147 GICR=0x00;
	LDI  R30,LOW(0)
	OUT  0x3B,R30
;    2148 MCUCR=0x00;
	OUT  0x35,R30
;    2149 MCUCSR=0x00;
	OUT  0x34,R30
;    2150 GIFR=0x00;
	OUT  0x3A,R30
;    2151 
;    2152 
;    2153 
;    2154 // Timer/Counter 0 initialization
;    2155 // Clock source: System Clock
;    2156 // Clock value: 125,000 kHz
;    2157 // Mode: Normal top=FFh
;    2158 // OC0 output: Disconnected
;    2159 TCCR0=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
;    2160 TCNT0=-208;
	LDI  R30,LOW(65328)
	LDI  R31,HIGH(65328)
	OUT  0x32,R30
;    2161 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
;    2162 
;    2163 // Timer/Counter 1 initialization
;    2164 // Clock source: System Clock
;    2165 // Clock value: 8000,000 kHz
;    2166 // Mode: Fast PWM top=03FFh
;    2167 // OC1A output: Non-Inv.
;    2168 // OC1B output: Non-Inv.
;    2169 // Noise Canceler: Off
;    2170 // Input Capture on Falling Edge
;    2171 TCCR1A=0x21;
	LDI  R30,LOW(33)
	OUT  0x2F,R30
;    2172 TCCR1B=0x09;
	LDI  R30,LOW(9)
	OUT  0x2E,R30
;    2173 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
;    2174 TCNT1L=0x00;
	OUT  0x2C,R30
;    2175 ICR1H=0x00;
	OUT  0x27,R30
;    2176 ICR1L=0x00;
	OUT  0x26,R30
;    2177 OCR1B=700;
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	OUT  0x28+1,R31
	OUT  0x28,R30
;    2178 
;    2179 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;    2180 
;    2181 UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
;    2182 UCSRB=0x00;
	OUT  0xA,R30
;    2183 
;    2184 matemat();
	CALL _matemat
;    2185 
;    2186 ADMUX=0x00;
	LDI  R30,LOW(0)
	OUT  0x7,R30
;    2187 ADCSR=0x86;
	LDI  R30,LOW(134)
	OUT  0x6,R30
;    2188 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
;    2189 simbol_define();
	CALL _simbol_define
;    2190 
;    2191 #asm("sei")
	sei
;    2192 
;    2193 
;    2194 
;    2195 ind=iMn;
	CLR  R6
	CLR  R7
;    2196 sub_ind=1;
	LDI  R30,LOW(1)
	MOV  R11,R30
;    2197 sub_ind1=0;
	CLR  R12
;    2198 
;    2199 ind_mode=im_1;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	LDI  R26,LOW(_ind_mode)
	LDI  R27,HIGH(_ind_mode)
	CALL __EEPROMWRW
;    2200 
;    2201 restart_process(0);
	ST   -Y,R30
	CALL _restart_process
;    2202 restart_process(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _restart_process
;    2203 restart_process(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _restart_process
;    2204 restart_process(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _restart_process
;    2205 
;    2206 
;    2207 while (1)
_0x24C:
;    2208 	{
;    2209 	#asm("wdr")
	wdr
;    2210  	
;    2211 	if(b100Hz)
	SBRS R2,0
	RJMP _0x24F
;    2212 		{
;    2213 		b100Hz=0; 
	CLT
	BLD  R2,0
;    2214 		
;    2215 		adc_drv();
	CALL _adc_drv
;    2216           but_drv();
	CALL _but_drv
;    2217           but_an();
	CALL _but_an
;    2218   		
;    2219 		}	 
;    2220 	if(b10Hz)
_0x24F:
	SBRS R2,1
	RJMP _0x250
;    2221 		{
;    2222 		b10Hz=0;
	CLT
	BLD  R2,1
;    2223           simbol_define();
	CALL _simbol_define
;    2224           ind_hndl();
	CALL _ind_hndl
;    2225 		lcd_out(); 
	CALL _lcd_out
;    2226 		//wrk_state_drv();
;    2227 		
;    2228 		}	
;    2229 	if(b5Hz)
_0x250:
	SBRS R2,2
	RJMP _0x251
;    2230 		{
;    2231 		b5Hz=0;
	CLT
	BLD  R2,2
;    2232 		
;    2233 		ret_ind_hndl();
	CALL _ret_ind_hndl
;    2234 		matemat();
	CALL _matemat
;    2235 		//out_out();
;    2236   
;    2237   		}
;    2238 	if(b2Hz)
_0x251:
	SBRS R2,3
	RJMP _0x252
;    2239 		{
;    2240 		b2Hz=0;
	CLT
	BLD  R2,3
;    2241   		wrk_process(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _wrk_process
;    2242   		wrk_process(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _wrk_process
;    2243   		wrk_process(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _wrk_process
;    2244   		wrk_process(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _wrk_process
;    2245   		out_drv();
	CALL _out_drv
;    2246 		}								
;    2247 	if(b1Hz)
_0x252:
	SBRS R2,4
	RJMP _0x253
;    2248 		{
;    2249 		b1Hz=0;
	CLT
	BLD  R2,4
;    2250 		
;    2251 			
;    2252 		}
;    2253 			
;    2254      }
_0x253:
	RJMP _0x24C
;    2255 }
_0x254:
	RJMP _0x254
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
	CALL SUBOPT_0x60
    sbi   __lcd_cntr_port,__lcd_rs     ;RS=1
	LD   R30,Y
	ST   -Y,R30
	CALL __lcd_write_data
	RJMP _0x257
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
_0x257:
	ADIW R28,2
	RET
_lcd_clear:
	CALL __lcd_ready
	__DELAY_USB 107
	LDI  R30,LOW(12)
	CALL SUBOPT_0x60
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
	BRSH _0x256
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
_0x256:
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
	RCALL SUBOPT_0x61
	RCALL SUBOPT_0x61
	RCALL SUBOPT_0x61
	CALL __long_delay
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x62
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x62
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x62
	CALL _lcd_clear
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	ADIW R28,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	MOVW R26,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	MOVW R26,R30
	LD   R30,Y
	LDD  R31,Y+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x2:
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x3:
	LD   R30,Y
	LDI  R26,LOW(_wrk_state)
	LDI  R27,HIGH(_wrk_state)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x4:
	LD   R30,Y
	LDI  R26,LOW(_ee_time_mode)
	LDI  R27,HIGH(_ee_time_mode)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x5:
	LD   R30,Y
	LDI  R26,LOW(_wrk_time_cnt_flag)
	LDI  R27,HIGH(_wrk_time_cnt_flag)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x6:
	LD   R30,Y
	LDI  R26,LOW(_wrk_time_cnt)
	LDI  R27,HIGH(_wrk_time_cnt)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES
SUBOPT_0x7:
	LDI  R26,LOW(_ee_wrk_time)
	LDI  R27,HIGH(_ee_wrk_time)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x8:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(720)
	LDI  R31,HIGH(720)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES
SUBOPT_0x9:
	LD   R30,Y
	LDI  R26,LOW(_wrk_time_cnt_sec)
	LDI  R27,HIGH(_wrk_time_cnt_sec)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA:
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	ST   X+,R30
	ST   X,R31
	LD   R30,Y
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xB:
	LDI  R26,LOW(_ee_wrk_time_cnt_5)
	LDI  R27,HIGH(_ee_wrk_time_cnt_5)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0xC:
	LD   R30,Y
	LDI  R26,LOW(_wrk_time_cnt)
	LDI  R27,HIGH(_wrk_time_cnt)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xD:
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_cnt_block)
	SBCI R27,HIGH(-_cnt_block)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xE:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_cnt_block)
	SBCI R31,HIGH(-_cnt_block)
	LD   R30,Z
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF:
	LD   R30,Y
	LDI  R26,LOW(_temper)
	LDI  R27,HIGH(_temper)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10:
	LD   R30,Y
	LDI  R26,LOW(_t_ust)
	LDI  R27,HIGH(_t_ust)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x11:
	LD   R26,Y
	LDI  R27,0
	SUBI R26,LOW(-_out_st)
	SBCI R27,HIGH(-_out_st)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x12:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_out_st)
	SBCI R31,HIGH(-_out_st)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x13:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-_out_st_old)
	SBCI R31,HIGH(-_out_st_old)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x14:
	CALL __GETW1P
	SBIW R30,1
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x15:
	LDI  R26,LOW(_wrk_time_cnt)
	LDI  R27,HIGH(_wrk_time_cnt)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x16:
	MOV  R30,R9
	LDI  R26,LOW(_adc_bank)
	LDI  R27,HIGH(_adc_bank)
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 40 TIMES
SUBOPT_0x17:
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x18:
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R17
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x19:
	LDI  R30,LOW(_char2*2)
	LDI  R31,HIGH(_char2*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _define_char

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x1A:
	LDI  R30,LOW(_char2_*2)
	LDI  R31,HIGH(_char2_*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _define_char

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1B:
	LDI  R30,LOW(_char2__*2)
	LDI  R31,HIGH(_char2__*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _define_char

;OPTIMIZER ADDED SUBROUTINE, CALLED 45 TIMES
SUBOPT_0x1C:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x1D:
	CLR  R22
	CLR  R23
	__PUTD1S 7
	__GETD2S 7
	__CPD2N 0xC8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x1E:
	__GETD2S 7
	__GETD1N 0x320
	CALL __CPD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x1F:
	CALL __EEPROMRDW
	SUBI R30,LOW(-10000)
	SBCI R31,HIGH(-10000)
	CALL __CWD1
	__GETD2S 7
	CALL __MULD12
	__PUTD1S 7
	__GETD2S 7
	__GETD1N 0x9C4000
	CALL __SUBD12
	__PUTD1S 3
	__GETD2S 3
	__GETD1N 0x2710
	CALL __DIVD21
	__PUTD1S 3
	__GETD2S 7
	CALL __DIVD21
	__PUTD1S 7
	LDI  R30,LOW(_temper_table*2)
	LDI  R31,HIGH(_temper_table*2)
	CALL __GETW1PF
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES
SUBOPT_0x20:
	CALL __GETW1PF
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES
SUBOPT_0x21:
	LDI  R26,LOW(_temper_table*2)
	LDI  R27,HIGH(_temper_table*2)
	MOV  R30,R18
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x22:
	CALL __GETW1PF
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x23:
	CALL __SWAPD12
	CALL __SUBD12
	__PUTD1S 3
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x24:
	CALL __GETW1PF
	CALL __CWD1
	__GETD2S 7
	CALL __SWAPD12
	CALL __SUBD12
	__PUTD1S 7
	__GETD2S 7
	__GETD1N 0xA
	CALL __MULD12
	__PUTD1S 7
	__GETD1S 3
	__GETD2S 7
	CALL __DIVD21
	__PUTD1S 7
	MOV  R26,R18
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOV  R30,R0
	CLR  R31
	CLR  R22
	CLR  R23
	__GETD2S 7
	CALL __ADDD12
	__PUTD1S 7
	__SUBD1N 50
	__PUTD1S 7
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES
SUBOPT_0x25:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_lcd_buffer)
	SBCI R31,HIGH(-_lcd_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x26:
	MOV  R30,R16
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x27:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x28:
	ST   -Y,R30
	CALL _find
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES
SUBOPT_0x29:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2A:
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_lcd_buffer)
	SBCI R27,HIGH(-_lcd_buffer)
	LDI  R30,LOW(46)
	ST   X,R30
	MOV  R30,R16
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_lcd_buffer)
	SBCI R31,HIGH(-_lcd_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x2B:
	MOV  R30,R16
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_lcd_buffer)
	SBCI R31,HIGH(-_lcd_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2C:
	MOV  R30,R17
	SUBI R30,-LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	CPI  R30,LOW(0x20)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2D:
	MOV  R26,R16
	LDI  R27,0
	SUBI R26,LOW(-_lcd_buffer)
	SBCI R27,HIGH(-_lcd_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2E:
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	LPM  R30,Z
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2F:
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ADIW R30,1
	STD  Y+3,R30
	STD  Y+3+1,R31
	SBIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x30:
	LDS  R30,_ptr_ram
	LDS  R31,_ptr_ram+1
	ADIW R30,1
	STS  _ptr_ram,R30
	STS  _ptr_ram+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES
SUBOPT_0x31:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(33)
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES
SUBOPT_0x32:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(33)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x33:
	LDI  R30,LOW(255)
	ST   -Y,R30
	JMP  _sub_bgnd

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x34:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __MODW21
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x35:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL __DIVW21
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(35)
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES
SUBOPT_0x36:
	LDI  R30,LOW(64)
	ST   -Y,R30
	CALL _find
	LDI  R31,0
	SUBI R30,LOW(-_lcd_buffer)
	SBCI R31,HIGH(-_lcd_buffer)
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x37:
	LDI  R30,LOW(252)
	ST   -Y,R30
	JMP  _sub_bgnd

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES
SUBOPT_0x38:
	LDI  R30,LOW(103)
	ST   -Y,R30
	CALL _find
	LDI  R31,0
	SUBI R30,LOW(-_lcd_buffer)
	SBCI R31,HIGH(-_lcd_buffer)
	MOVW R26,R30
	LDI  R30,LOW(2)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x39:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(64)
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x3A:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(35)
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x3B:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(36)
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3C:
	MOV  R30,R11
	SUBI R30,LOW(1)
	CP   R13,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3D:
	MOV  R30,R11
	SUBI R30,LOW(1)
	MOV  R13,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3E:
	MOV  R30,R13
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,3
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R13
	SUBI R30,-LOW(1)
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,5
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	JMP  _bgnd_par

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x3F:
	MOV  R30,R12
	LDI  R26,LOW(_wrk_state)
	LDI  R27,HIGH(_wrk_state)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x40:
	MOV  R30,R12
	SUBI R30,-LOW(1)
	LDI  R31,0
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x41:
	MOV  R30,R12
	LDI  R26,LOW(_t_ust)
	LDI  R27,HIGH(_t_ust)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x42:
	CALL __GETW1P
	MOVW R26,R30
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x43:
	CALL _int2lcd
	MOV  R30,R12
	LDI  R26,LOW(_ee_time_mode)
	LDI  R27,HIGH(_ee_time_mode)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x44:
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x45:
	LDI  R30,LOW(37)
	ST   -Y,R30
	CALL _find
	LDI  R31,0
	SUBI R30,LOW(-_lcd_buffer)
	SBCI R31,HIGH(-_lcd_buffer)
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x46:
	MOV  R30,R12
	LDI  R31,0
	SUBI R30,LOW(-_nd)
	SBCI R31,HIGH(-_nd)
	LD   R30,Z
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x47:
	ST   -Y,R30
	LDI  R30,LOW(254)
	ST   -Y,R30
	JMP  _sub_bgnd

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x48:
	MOV  R30,R12
	LDI  R26,LOW(_temper)
	LDI  R27,HIGH(_temper)
	RJMP SUBOPT_0x44

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x49:
	LDI  R30,LOW(111)
	ST   -Y,R30
	CALL _find
	LDI  R31,0
	SUBI R30,LOW(-_lcd_buffer)
	SBCI R31,HIGH(-_lcd_buffer)
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x4A:
	IN   R30,0x18
	ORI  R30,LOW(0xF8)
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4B:
	LDS  R30,_but_s_G1
	LDS  R26,_but_n_G1
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4C:
	LDS  R30,_but_onL_temp_G1
	LDS  R26,_but1_cnt_G1
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4D:
	LDS  R30,_but_s_G1
	ANDI R30,0xFE
	MOV  R8,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4E:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 6,7
	CLR  R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4F:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	JMP  _gran_char

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x50:
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x51:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	JMP  _gran_char

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x52:
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
	MOV  R30,R12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x53:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(140)
	LDI  R31,HIGH(140)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _gran_ee

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x54:
	MOV  R30,R12
	LDI  R26,LOW(_t_ust)
	LDI  R27,HIGH(_t_ust)
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x55:
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x56:
	MOV  R30,R12
	LDI  R26,LOW(_ee_wrk_time)
	LDI  R27,HIGH(_ee_wrk_time)
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x57:
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x58:
	MOV  R30,R12
	LDI  R26,LOW(_ee_time_mode)
	LDI  R27,HIGH(_ee_time_mode)
	RJMP SUBOPT_0x50

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x59:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	__PUTW1R 6,7
	CLR  R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5A:
	MOV  R30,R12
	LDI  R26,LOW(_K_t)
	LDI  R27,HIGH(_K_t)
	RJMP SUBOPT_0x50

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x5B:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(64536)
	LDI  R31,HIGH(64536)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _gran_ee

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x5C:
	MOV  R30,R12
	LDI  R26,LOW(_K_t)
	LDI  R27,HIGH(_K_t)
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5D:
	CLR  R6
	CLR  R7
	CLR  R11
	LDI  R30,0
	STS  _nakal_cnt,R30
	STS  _nakal_cnt+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5E:
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
SUBOPT_0x5F:
	LDI  R30,LOW(_Ki)
	LDI  R31,HIGH(_Ki)
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
SUBOPT_0x60:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __lcd_ready

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x61:
	CALL __long_delay
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x62:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

_abs:
	ld   r30,y+
	ld   r31,y+
	sbiw r30,0
	brpl __abs0
	com  r30
	com  r31
	adiw r30,1
__abs0:
	ret

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

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__ANEGW1:
	COM  R30
	COM  R31
	ADIW R30,1
	RET

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

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
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

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
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

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
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

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
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

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
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

