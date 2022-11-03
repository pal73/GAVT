;CodeVisionAVR C Compiler V1.24.1d Standard
;(C) Copyright 1998-2004 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.ro
;e-mail:office@hpinfotech.ro

;Chip type           : ATmega16
;Program type        : Application
;Clock frequency     : 8,000000 MHz
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

	.INCLUDE "host.vec"
	.INCLUDE "host.inc"

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
;       1 #define SLAVE_MESS_LEN	4
;       2 
;       3 #define LED_POW_ON	5
;       4 #define LED_PROG4	1
;       5 #define LED_PROG2	2
;       6 #define LED_PROG3	3
;       7 #define LED_PROG1	4 
;       8 #define LED_ERROR	0 
;       9 #define LED_WRK	6
;      10 #define LED_AVTOM	7
;      11 
;      12 
;      13 
;      14 #define MD1	2
;      15 #define MD2	3
;      16 #define VR	4
;      17 #define MD3	5
;      18 
;      19 #define PP1	6
;      20 #define PP2	7
;      21 #define PP3	5
;      22 #define PP4	4
;      23 #define PP5	3
;      24 #define DV	0 
;      25 
;      26 #define PP7	2
;      27 
;      28 
;      29 
;      30 bit b600Hz;
;      31 bit b100Hz;
;      32 bit b10Hz;
;      33 char t0_cnt0_,t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3;
;      34 char ind_cnt;
;      35 flash char IND_STROB[]={0b10111111,0b11011111,0b11101111,0b11110111,0b01111111};

	.CSEG
;      36 flash char DIGISYM[]={0b11000000,0b11111001,0b10100100,0b10110000,0b10011001,0b10010010,0b10000010,0b11111000,0b10000000,0b10010000,0b11111111};								
;      37 #define SYMn 0b10101011
;      38 #define SYMo 0b10100011
;      39 #define SYMf 0b10001110
;      40 #define SYMu 0b11100011
;      41 #define SYMt 0b10000111
;      42 #define SYM  0b11111111
;      43 char ind_out[5]={0x255,0x255,0x255,0x255,0x255};

	.DSEG
_ind_out:
	.BYTE 0x5
;      44 char dig[4];
_dig:
	.BYTE 0x4
;      45 bit bZ;    
;      46 char but;
;      47 static char but_n;
_but_n_G1:
	.BYTE 0x1
;      48 static char but_s;
_but_s_G1:
	.BYTE 0x1
;      49 static char but0_cnt;
_but0_cnt_G1:
	.BYTE 0x1
;      50 static char but1_cnt;
_but1_cnt_G1:
	.BYTE 0x1
;      51 static char but_onL_temp;
_but_onL_temp_G1:
	.BYTE 0x1
;      52 bit l_but;		//идет длинное нажатие на кнопку
;      53 bit n_but;          //произошло нажатие
;      54 bit speed;		//разрешение ускорения перебора 
;      55 bit bFL2; 
;      56 bit bFL5;
;      57 eeprom enum{eamON=0x55,eamOFF=0xaa}ee_avtom_mode;

	.ESEG
_ee_avtom_mode:
	.DB  0x0
;      58 enum {p1=1,p2=2,p3=3,p4=4}prog;
;      59 //enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s100}step=sOFF;
;      60 enum {iMn,iPr_sel,iSet_sel,iSet_delay,iCh_on} ind;

	.DSEG
_ind:
	.BYTE 0x1
;      61 char sub_ind;
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
;      65 bit bVR;
;      66 bit bMD1;
;      67 bit bMD2;
;      68 bit bMD3;
;      69 char cnt_md1,cnt_md2,cnt_vr,cnt_md3;
_cnt_md1:
	.BYTE 0x1
_cnt_md2:
	.BYTE 0x1
_cnt_vr:
	.BYTE 0x1
_cnt_md3:
	.BYTE 0x1
;      70 
;      71 eeprom enum {coOFF=0x55,coON=0xaa}ch_on[6];

	.ESEG
_ch_on:
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
;      72 eeprom unsigned ee_timer1_delay;
_ee_timer1_delay:
	.DW  0x0
;      73 bit opto_angle_old;
;      74 enum {msON=0x55,msOFF=0xAA}motor_state;

	.DSEG
_motor_state:
	.BYTE 0x1
;      75 unsigned timer1_delay;
_timer1_delay:
	.BYTE 0x2
;      76 
;      77 char stop_cnt/*,start_cnt*/;
_stop_cnt:
	.BYTE 0x1
;      78 char cnt_net_drv,cnt_drv;
_cnt_net_drv:
	.BYTE 0x1
_cnt_drv:
	.BYTE 0x1
;      79 char cmnd_byte,state_byte,crc_byte;
_cmnd_byte:
	.BYTE 0x1
_state_byte:
	.BYTE 0x1
_crc_byte:
	.BYTE 0x1
;      80 signed char od_cnt;
_od_cnt:
	.BYTE 0x1
;      81 enum {odON=55,odOFF=77}od;
_od:
	.BYTE 0x1
;      82 char state[3];
_state:
	.BYTE 0x3
;      83 enum{sOFF,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16}step_main=sOFF;
_step_main:
	.BYTE 0x1
;      84 char plazma;
_plazma:
	.BYTE 0x1
;      85 signed cnt_del_main;
_cnt_del_main:
	.BYTE 0x2
;      86 bit bDel;
;      87 #include <mega16.h>
;      88 #include <stdio.h>
;      89 #include "usart_host.c"  
;      90 #define RXB8 1
;      91 #define TXB8 0
;      92 #define UPE 2
;      93 #define OVR 3
;      94 #define FE 4
;      95 #define UDRE 5
;      96 #define RXC 7
;      97 
;      98 #define FRAMING_ERROR (1<<FE)
;      99 #define PARITY_ERROR (1<<UPE)
;     100 #define DATA_OVERRUN (1<<OVR)
;     101 #define DATA_REGISTER_EMPTY (1<<UDRE)
;     102 #define RX_COMPLETE (1<<RXC)
;     103 
;     104 extern void uart_in_an(void); 
;     105 // USART Receiver buffer
;     106 #define RX_BUFFER_SIZE 50
;     107 bit bRXIN;
;     108 char UIB[10]={0,0,0,0,0,0,0,0,0,0};
_UIB:
	.BYTE 0xA
;     109 char flag;
_flag:
	.BYTE 0x1
;     110 char rx_buffer[RX_BUFFER_SIZE];
_rx_buffer:
	.BYTE 0x32
;     111 unsigned char rx_wr_index,rx_rd_index,rx_counter;
_rx_wr_index:
	.BYTE 0x1
_rx_rd_index:
	.BYTE 0x1
_rx_counter:
	.BYTE 0x1
;     112 // This flag is set on USART Receiver buffer overflow
;     113 bit rx_buffer_overflow;
;     114 
;     115 // USART Receiver interrupt service routine
;     116 #pragma savereg-
;     117 interrupt [USART_RXC] void uart_rx_isr(void)
;     118 {

	.CSEG
_uart_rx_isr:
;     119 char status,data;
;     120 #asm
	ST   -Y,R17
	ST   -Y,R16
;	status -> R16
;	data -> R17
;     121     push r26
    push r26
;     122     push r27
    push r27
;     123     push r30
    push r30
;     124     push r31
    push r31
;     125     in   r26,sreg
    in   r26,sreg
;     126     push r26
    push r26
;     127 #endasm  

;     128 
;     129 status=UCSRA;
	IN   R16,11
;     130 data=UDR;
	IN   R17,12
;     131 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R16
	ANDI R30,LOW(0x1C)
	BRNE _0x4
;     132    { 
;     133    
;     134    if((data&0b11111000)==0)rx_wr_index=0;
	MOV  R30,R17
	ANDI R30,LOW(0xF8)
	BRNE _0x5
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
;     135    rx_buffer[rx_wr_index]=data;
_0x5:
	LDS  R26,_rx_wr_index
	LDI  R27,0
	SUBI R26,LOW(-_rx_buffer)
	SBCI R27,HIGH(-_rx_buffer)
	ST   X,R17
;     136    if (++rx_wr_index >= SLAVE_MESS_LEN)
	LDS  R26,_rx_wr_index
	SUBI R26,-LOW(1)
	STS  _rx_wr_index,R26
	CPI  R26,LOW(0x4)
	BRLO _0x6
;     137    	{
;     138    	if((((rx_buffer[0]^rx_buffer[1])^(rx_buffer[2]^rx_buffer[3]))&0b01111111)==0)
	__GETB1MN _rx_buffer,1
	LDS  R26,_rx_buffer
	EOR  R30,R26
	PUSH R30
	__GETB1MN _rx_buffer,2
	PUSH R30
	__GETB1MN _rx_buffer,3
	POP  R26
	EOR  R30,R26
	POP  R26
	EOR  R30,R26
	ANDI R30,0x7F
	CPI  R30,0
	BRNE _0x7
;     139    		{
;     140    		uart_in_an();plazma++;
	CALL _uart_in_an
	LDS  R30,_plazma
	SUBI R30,-LOW(1)
	STS  _plazma,R30
;     141    		}
;     142      }
_0x7:
;     143    };
_0x6:
_0x4:
;     144 #asm
;     145     pop  r26
    pop  r26
;     146     out  sreg,r26
    out  sreg,r26
;     147     pop  r31
    pop  r31
;     148     pop  r30
    pop  r30
;     149     pop  r27
    pop  r27
;     150     pop  r26
    pop  r26
;     151 #endasm

;     152 }
	LD   R16,Y+
	LD   R17,Y+
	RETI
;     153 #pragma savereg+
;     154 
;     155 #ifndef _DEBUG_TERMINAL_IO_
;     156 // Get a character from the USART Receiver buffer
;     157 #define _ALTERNATE_GETCHAR_
;     158 #pragma used+
;     159 char getchar(void)
;     160 {
;     161 char data;
;     162 while (rx_counter==0);
;	data -> R16
;     163 data=rx_buffer[rx_rd_index];
;     164 if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
;     165 #asm("cli")
	cli
;     166 --rx_counter;
;     167 #asm("sei")
	sei
;     168 return data;
;     169 }
;     170 #pragma used-
;     171 #endif
;     172 
;     173 // USART Transmitter buffer
;     174 #define TX_BUFFER_SIZE 100
;     175 char tx_buffer[TX_BUFFER_SIZE];

	.DSEG
_tx_buffer:
	.BYTE 0x64
;     176 unsigned char tx_wr_index,tx_rd_index,tx_counter;
_tx_wr_index:
	.BYTE 0x1
_tx_rd_index:
	.BYTE 0x1
_tx_counter:
	.BYTE 0x1
;     177 
;     178 // USART Transmitter interrupt service routine
;     179 #pragma savereg-
;     180 interrupt [USART_TXC] void uart_tx_isr(void)
;     181 {

	.CSEG
_uart_tx_isr:
;     182 #asm
;     183     push r26
    push r26
;     184     push r27
    push r27
;     185     push r30
    push r30
;     186     push r31
    push r31
;     187     in   r26,sreg
    in   r26,sreg
;     188     push r26
    push r26
;     189 #endasm

;     190 if (tx_counter)
	LDS  R30,_tx_counter
	CPI  R30,0
	BREQ _0xC
;     191    {
;     192    --tx_counter;
	SUBI R30,LOW(1)
	STS  _tx_counter,R30
;     193    UDR=tx_buffer[tx_rd_index];
	LDS  R30,_tx_rd_index
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
;     194    if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDS  R26,_tx_rd_index
	SUBI R26,-LOW(1)
	STS  _tx_rd_index,R26
	CPI  R26,LOW(0x64)
	BRNE _0xD
	LDI  R30,LOW(0)
	STS  _tx_rd_index,R30
;     195    };
_0xD:
_0xC:
;     196 #asm
;     197     pop  r26
    pop  r26
;     198     out  sreg,r26
    out  sreg,r26
;     199     pop  r31
    pop  r31
;     200     pop  r30
    pop  r30
;     201     pop  r27
    pop  r27
;     202     pop  r26
    pop  r26
;     203 #endasm

;     204 }
	RETI
;     205 #pragma savereg+
;     206 
;     207 #ifndef _DEBUG_TERMINAL_IO_
;     208 // Write a character to the USART Transmitter buffer
;     209 #define _ALTERNATE_PUTCHAR_
;     210 #pragma used+
;     211 void putchar(char c)
;     212 {
_putchar:
;     213 while (tx_counter == TX_BUFFER_SIZE);
_0xE:
	LDS  R26,_tx_counter
	CPI  R26,LOW(0x64)
	BREQ _0xE
;     214 #asm("cli")
	cli
;     215 if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter
	CPI  R30,0
	BRNE _0x12
	SBIC 0xB,5
	RJMP _0x11
_0x12:
;     216    {
;     217    tx_buffer[tx_wr_index]=c;
	LDS  R26,_tx_wr_index
	LDI  R27,0
	SUBI R26,LOW(-_tx_buffer)
	SBCI R27,HIGH(-_tx_buffer)
	LD   R30,Y
	ST   X,R30
;     218    if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDS  R26,_tx_wr_index
	SUBI R26,-LOW(1)
	STS  _tx_wr_index,R26
	CPI  R26,LOW(0x64)
	BRNE _0x14
	LDI  R30,LOW(0)
	STS  _tx_wr_index,R30
;     219    ++tx_counter;
_0x14:
	LDS  R30,_tx_counter
	SUBI R30,-LOW(1)
	STS  _tx_counter,R30
;     220    }
;     221 else UDR=c;
	RJMP _0x15
_0x11:
	LD   R30,Y
	OUT  0xC,R30
_0x15:
;     222 #asm("sei")
	sei
;     223 }
	ADIW R28,1
	RET
;     224 #pragma used-
;     225 #endif
;     226 enum{amON=0x55,amOFF=0xaa}avtom_mode=amOFF; 

	.DSEG
_avtom_mode:
	.BYTE 0x1
;     227 char avtom_mode_cnt;
_avtom_mode_cnt:
	.BYTE 0x1
;     228 
;     229 //-----------------------------------------------
;     230 void od_drv(void)
;     231 {

	.CSEG
_od_drv:
;     232 
;     233 if(!PINA.1)
	SBIC 0x19,1
	RJMP _0x17
;     234 	{
;     235 	if(od_cnt<10)od_cnt++;
	LDS  R26,_od_cnt
	CPI  R26,LOW(0xA)
	BRGE _0x18
	LDS  R30,_od_cnt
	SUBI R30,-LOW(1)
	STS  _od_cnt,R30
;     236 	}
_0x18:
;     237 else
	RJMP _0x19
_0x17:
;     238 	{
;     239 	if(od_cnt>0)od_cnt--;
	LDS  R26,_od_cnt
	LDI  R30,LOW(0)
	CP   R30,R26
	BRGE _0x1A
	LDS  R30,_od_cnt
	SUBI R30,LOW(1)
	STS  _od_cnt,R30
;     240 	} 
_0x1A:
_0x19:
;     241 
;     242 if(od_cnt>=9)od=odON;
	LDS  R26,_od_cnt
	CPI  R26,LOW(0x9)
	BRLT _0x1B
	LDI  R30,LOW(55)
	STS  _od,R30
;     243 else if(od_cnt<=1)od=odOFF;
	RJMP _0x1C
_0x1B:
	LDS  R26,_od_cnt
	LDI  R30,LOW(1)
	CP   R30,R26
	BRLT _0x1D
	LDI  R30,LOW(77)
	STS  _od,R30
;     244 
;     245 DDRA.1=0;
_0x1D:
_0x1C:
	CBI  0x1A,1
;     246 PORTA.1=1;
	SBI  0x1B,1
;     247 
;     248 }
	RET
;     249  
;     250 //-----------------------------------------------
;     251 void avtom_mode_drv(void)
;     252 {
_avtom_mode_drv:
;     253 if(in_word&(1<<5))
	LDS  R30,_in_word
	ANDI R30,LOW(0x20)
	BREQ _0x1E
;     254 	{
;     255 	if(avtom_mode_cnt) avtom_mode_cnt--;
	LDS  R30,_avtom_mode_cnt
	CPI  R30,0
	BREQ _0x1F
	SUBI R30,LOW(1)
	STS  _avtom_mode_cnt,R30
;     256 	}
_0x1F:
;     257 	
;     258 else 
	RJMP _0x20
_0x1E:
;     259 	{
;     260 	if(avtom_mode_cnt<100) avtom_mode_cnt++;
	LDS  R26,_avtom_mode_cnt
	CPI  R26,LOW(0x64)
	BRSH _0x21
	LDS  R30,_avtom_mode_cnt
	SUBI R30,-LOW(1)
	STS  _avtom_mode_cnt,R30
;     261 	}
_0x21:
_0x20:
;     262 
;     263 if(avtom_mode_cnt>90)avtom_mode=amON;
	LDS  R26,_avtom_mode_cnt
	LDI  R30,LOW(90)
	CP   R30,R26
	BRSH _0x22
	LDI  R30,LOW(85)
	STS  _avtom_mode,R30
;     264 else if(avtom_mode_cnt<10)avtom_mode=amOFF; 		
	RJMP _0x23
_0x22:
	LDS  R26,_avtom_mode_cnt
	CPI  R26,LOW(0xA)
	BRSH _0x24
	LDI  R30,LOW(170)
	STS  _avtom_mode,R30
;     265 }
_0x24:
_0x23:
	RET
;     266 
;     267 //-----------------------------------------------
;     268 void out_drv(void)
;     269 {
_out_drv:
;     270 DDRB|=0xc0;
	IN   R30,0x17
	ORI  R30,LOW(0xC0)
	OUT  0x17,R30
;     271 if(stop_cnt)
	LDS  R30,_stop_cnt
	CPI  R30,0
	BREQ _0x25
;     272 	{
;     273 	stop_cnt--;
	SUBI R30,LOW(1)
	STS  _stop_cnt,R30
;     274 	PORTB.6=0;
	CBI  0x18,6
;     275 	}
;     276 else PORTB.6=1;
	RJMP _0x26
_0x25:
	SBI  0x18,6
_0x26:
;     277 
;     278 if(motor_state==msON)
	LDS  R26,_motor_state
	CPI  R26,LOW(0x55)
	BRNE _0x27
;     279 	{
;     280 	//start_cnt--;
;     281 	PORTB.7=0;
	CBI  0x18,7
;     282 	}
;     283 else PORTB.7=1;
	RJMP _0x28
_0x27:
	SBI  0x18,7
_0x28:
;     284 }
	RET
;     285 
;     286 
;     287 //-----------------------------------------------
;     288 void step_main_contr(void)
;     289 {
_step_main_contr:
;     290 
;     291 if(step_main==sOFF)
	LDS  R30,_step_main
	CPI  R30,0
	BRNE _0x29
;     292 	{
;     293 	cmnd_byte=0x33;
	LDI  R30,LOW(51)
	STS  _cmnd_byte,R30
;     294 	}
;     295 else if(step_main==s1)
	RJMP _0x2A
_0x29:
	LDS  R26,_step_main
	CPI  R26,LOW(0x1)
	BRNE _0x2B
;     296 	{
;     297 	cmnd_byte=0x33;
	LDI  R30,LOW(51)
	STS  _cmnd_byte,R30
;     298 	if(od==odON)
	LDS  R26,_od
	CPI  R26,LOW(0x37)
	BRNE _0x2C
;     299 		{
;     300 		step_main=s2;
	LDI  R30,LOW(2)
	CALL SUBOPT_0x0
;     301 		cnt_del_main=30;
;     302 		}
;     303 	}
_0x2C:
;     304 else if(step_main==s2)
	RJMP _0x2D
_0x2B:
	LDS  R26,_step_main
	CPI  R26,LOW(0x2)
	BRNE _0x2E
;     305 	{
;     306 	cmnd_byte=0x33;
	CALL SUBOPT_0x1
;     307 	cnt_del_main--;
;     308 	if(cnt_del_main==0)
	BRNE _0x2F
;     309 		{
;     310   		motor_state=msON;
	LDI  R30,LOW(85)
	STS  _motor_state,R30
;     311      	//start_cnt=20;
;     312 		step_main=s3;
	LDI  R30,LOW(3)
	STS  _step_main,R30
;     313 		bDel=0;
	CLT
	BLD  R3,7
;     314 		}
;     315 	}
_0x2F:
;     316 else if(step_main==s3)
	RJMP _0x30
_0x2E:
	LDS  R26,_step_main
	CPI  R26,LOW(0x3)
	BRNE _0x31
;     317 	{
;     318 	cmnd_byte=0x33;
	LDI  R30,LOW(51)
	STS  _cmnd_byte,R30
;     319 	if(motor_state==msOFF)
	LDS  R26,_motor_state
	CPI  R26,LOW(0xAA)
	BRNE _0x32
;     320 		{
;     321 		step_main=s4;
	LDI  R30,LOW(4)
	CALL SUBOPT_0x0
;     322 		cnt_del_main=30;
;     323 		}
;     324 	
;     325 	}
_0x32:
;     326 else if(step_main==s4)
	RJMP _0x33
_0x31:
	LDS  R26,_step_main
	CPI  R26,LOW(0x4)
	BRNE _0x34
;     327 	{              
;     328 	cmnd_byte=0x33;
	CALL SUBOPT_0x1
;     329 	cnt_del_main--;
;     330 	if(cnt_del_main==0)
	BRNE _0x35
;     331 		{
;     332 		step_main=s5;
	LDI  R30,LOW(5)
	STS  _step_main,R30
;     333 		cnt_del_main=100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _cnt_del_main,R30
	STS  _cnt_del_main+1,R31
;     334 		}
;     335 	}   
_0x35:
;     336 else if(step_main==s5)
	RJMP _0x36
_0x34:
	LDS  R26,_step_main
	CPI  R26,LOW(0x5)
	BRNE _0x37
;     337 	{              
;     338 	cmnd_byte=0x55;
	LDI  R30,LOW(85)
	STS  _cmnd_byte,R30
;     339 	cnt_del_main--;
	LDS  R30,_cnt_del_main
	LDS  R31,_cnt_del_main+1
	SBIW R30,1
	STS  _cnt_del_main,R30
	STS  _cnt_del_main+1,R31
;     340 	if(cnt_del_main==0)
	SBIW R30,0
	BRNE _0x38
;     341 		{
;     342 		step_main=s6;
	LDI  R30,LOW(6)
	STS  _step_main,R30
;     343 		}
;     344 	}	
_0x38:
;     345 else if(step_main==s6)
	RJMP _0x39
_0x37:
	LDS  R26,_step_main
	CPI  R26,LOW(0x6)
	BREQ PC+3
	JMP _0x3A
;     346 	{              
;     347 	cmnd_byte=0x55;
	LDI  R30,LOW(85)
	STS  _cmnd_byte,R30
;     348 	if((((state[0]&0b00000100)==0)||(ch_on[0]!=coON))
;     349 		&&(((state[0]&0b00100000)==0)||(ch_on[1]!=coON))
;     350 		&&(((state[1]&0b00000100)==0)||(ch_on[2]!=coON))
;     351 		&&(((state[1]&0b00100000)==0)||(ch_on[3]!=coON))
;     352 		&&(((state[2]&0b00000100)==0)||(ch_on[4]!=coON))
;     353 		&&(((state[2]&0b00100000)==0)||(ch_on[5]!=coON)))step_main=s7;
	LDS  R30,_state
	ANDI R30,LOW(0x4)
	BREQ _0x3C
	CALL SUBOPT_0x2
	BREQ _0x3E
_0x3C:
	LDS  R30,_state
	ANDI R30,LOW(0x20)
	BREQ _0x3F
	__POINTW2MN _ch_on,1
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x3E
_0x3F:
	__GETB1MN _state,1
	ANDI R30,LOW(0x4)
	BREQ _0x41
	__POINTW2MN _ch_on,2
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x3E
_0x41:
	__GETB1MN _state,1
	ANDI R30,LOW(0x20)
	BREQ _0x43
	__POINTW2MN _ch_on,3
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x3E
_0x43:
	__GETB1MN _state,2
	ANDI R30,LOW(0x4)
	BREQ _0x45
	__POINTW2MN _ch_on,4
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x3E
_0x45:
	__GETB1MN _state,2
	ANDI R30,LOW(0x20)
	BREQ _0x47
	__POINTW2MN _ch_on,5
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x3E
_0x47:
	RJMP _0x49
_0x3E:
	RJMP _0x3B
_0x49:
	LDI  R30,LOW(7)
	STS  _step_main,R30
;     354 	}
_0x3B:
;     355 else if(step_main==s7)
	RJMP _0x4A
_0x3A:
	LDS  R26,_step_main
	CPI  R26,LOW(0x7)
	BRNE _0x4B
;     356 	{
;     357 	cmnd_byte=0x33;
	LDI  R30,LOW(51)
	STS  _cmnd_byte,R30
;     358 	if(avtom_mode==amON)step_main=s1;
	LDS  R26,_avtom_mode
	CPI  R26,LOW(0x55)
	BRNE _0x4C
	LDI  R30,LOW(1)
	RJMP _0x12F
;     359 	else step_main=sOFF;
_0x4C:
	LDI  R30,LOW(0)
_0x12F:
	STS  _step_main,R30
;     360 	}
;     361 	
;     362 }
_0x4B:
_0x4A:
_0x39:
_0x36:
_0x33:
_0x30:
_0x2D:
_0x2A:
	RET
;     363 
;     364 
;     365 
;     366 //-----------------------------------------------
;     367 void out_usart (char num,char data0,char data1,char data2,char data3,char data4,char data5,char data6,char data7,char data8)
;     368 {
_out_usart:
;     369 char i,t=0;
;     370 
;     371 char UOB[12]; 
;     372 UOB[0]=data0;
	SBIW R28,12
	ST   -Y,R17
	ST   -Y,R16
;	num -> Y+23
;	data0 -> Y+22
;	data1 -> Y+21
;	data2 -> Y+20
;	data3 -> Y+19
;	data4 -> Y+18
;	data5 -> Y+17
;	data6 -> Y+16
;	data7 -> Y+15
;	data8 -> Y+14
;	i -> R16
;	t -> R17
;	UOB -> Y+2
	LDI  R17,0
	LDD  R30,Y+22
	STD  Y+2,R30
;     373 UOB[1]=data1;
	LDD  R30,Y+21
	STD  Y+3,R30
;     374 UOB[2]=data2;
	LDD  R30,Y+20
	STD  Y+4,R30
;     375 UOB[3]=data3;
	LDD  R30,Y+19
	STD  Y+5,R30
;     376 UOB[4]=data4;
	LDD  R30,Y+18
	STD  Y+6,R30
;     377 UOB[5]=data5;
	LDD  R30,Y+17
	STD  Y+7,R30
;     378 UOB[6]=data6;
	LDD  R30,Y+16
	STD  Y+8,R30
;     379 UOB[7]=data7;
	LDD  R30,Y+15
	STD  Y+9,R30
;     380 UOB[8]=data8;
	LDD  R30,Y+14
	STD  Y+10,R30
;     381 
;     382 for (i=0;i<num;i++)
	LDI  R16,LOW(0)
_0x4F:
	LDD  R30,Y+23
	CP   R16,R30
	BRSH _0x50
;     383 	{
;     384 	putchar(UOB[i]);
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	CALL _putchar
;     385 	}   	
	SUBI R16,-1
	RJMP _0x4F
_0x50:
;     386 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,24
	RET
;     387 
;     388 //-----------------------------------------------
;     389 void byte_drv(void)
;     390 {
;     391 cmnd_byte|=0x80;
;     392 state_byte=0xff;
;     393 
;     394 if(ch_on[0]!=coON)state_byte&=~(1<<0);
;     395 if(ch_on[1]!=coON)state_byte&=~(1<<1);
;     396 if(ch_on[2]!=coON)state_byte&=~(1<<2);
;     397 if(ch_on[3]!=coON)state_byte&=~(1<<3);
;     398 if(ch_on[4]!=coON)state_byte&=~(1<<4);
;     399 if(ch_on[5]!=coON)state_byte&=~(1<<5);
;     400 
;     401 crc_byte=cmnd_byte^state_byte;
;     402 }
;     403 
;     404 //-----------------------------------------------
;     405 void net_drv(void)
;     406 {
_net_drv:
;     407 if(++cnt_net_drv>=3)
	LDS  R26,_cnt_net_drv
	SUBI R26,-LOW(1)
	STS  _cnt_net_drv,R26
	CPI  R26,LOW(0x3)
	BRSH PC+3
	JMP _0x57
;     408 	{
;     409 	cnt_net_drv=0;
	LDI  R30,LOW(0)
	STS  _cnt_net_drv,R30
;     410 	if(++cnt_drv>=4)
	LDS  R26,_cnt_drv
	SUBI R26,-LOW(1)
	STS  _cnt_drv,R26
	CPI  R26,LOW(0x4)
	BRLO _0x58
;     411 		{
;     412 		cnt_drv=1;
	LDI  R30,LOW(1)
	STS  _cnt_drv,R30
;     413 		} 
;     414 		
;     415 	cmnd_byte|=0x80;
_0x58:
	LDS  R30,_cmnd_byte
	ORI  R30,0x80
	STS  _cmnd_byte,R30
;     416 	state_byte=0xff;
	LDI  R30,LOW(255)
	STS  _state_byte,R30
;     417 
;     418 	if(ch_on[0]!=coON)state_byte&=~(1<<0);
	CALL SUBOPT_0x2
	BREQ _0x59
	LDS  R30,_state_byte
	ANDI R30,0xFE
	STS  _state_byte,R30
;     419 	if(ch_on[1]!=coON)state_byte&=~(1<<1);
_0x59:
	__POINTW2MN _ch_on,1
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x5A
	LDS  R30,_state_byte
	ANDI R30,0xFD
	STS  _state_byte,R30
;     420 	if(ch_on[2]!=coON)state_byte&=~(1<<2);
_0x5A:
	__POINTW2MN _ch_on,2
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x5B
	LDS  R30,_state_byte
	ANDI R30,0xFB
	STS  _state_byte,R30
;     421 	if(ch_on[3]!=coON)state_byte&=~(1<<3);
_0x5B:
	__POINTW2MN _ch_on,3
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x5C
	LDS  R30,_state_byte
	ANDI R30,0XF7
	STS  _state_byte,R30
;     422 	if(ch_on[4]!=coON)state_byte&=~(1<<4);
_0x5C:
	__POINTW2MN _ch_on,4
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x5D
	LDS  R30,_state_byte
	ANDI R30,0xEF
	STS  _state_byte,R30
;     423 	if(ch_on[5]!=coON)state_byte&=~(1<<5);
_0x5D:
	__POINTW2MN _ch_on,5
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x5E
	LDS  R30,_state_byte
	ANDI R30,0xDF
	STS  _state_byte,R30
;     424 
;     425 	crc_byte=cmnd_byte^state_byte;
_0x5E:
	LDS  R30,_state_byte
	LDS  R26,_cmnd_byte
	EOR  R30,R26
	STS  _crc_byte,R30
;     426 	crc_byte=crc_byte^cnt_drv;
	LDS  R30,_cnt_drv
	LDS  R26,_crc_byte
	EOR  R30,R26
	STS  _crc_byte,R30
;     427 	crc_byte|=0x80;
	ORI  R30,0x80
	STS  _crc_byte,R30
;     428 		            
;     429 	out_usart(4,cnt_drv,cmnd_byte,state_byte,crc_byte,0,0,0,0,0);	
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDS  R30,_cnt_drv
	ST   -Y,R30
	LDS  R30,_cmnd_byte
	ST   -Y,R30
	LDS  R30,_state_byte
	ST   -Y,R30
	LDS  R30,_crc_byte
	CALL SUBOPT_0x3
	CALL SUBOPT_0x3
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _out_usart
;     430 	}
;     431 }
_0x57:
	RET
;     432 //-----------------------------------------------
;     433 void in_drv(void)
;     434 {
_in_drv:
;     435 char i,temp;
;     436 unsigned int tempUI;
;     437 DDRA&=0x00;
	CALL __SAVELOCR4
;	i -> R16
;	temp -> R17
;	tempUI -> R18,R19
	IN   R30,0x1A
	ANDI R30,LOW(0x0)
	OUT  0x1A,R30
;     438 PORTA|=0xff;
	IN   R30,0x1B
	ORI  R30,LOW(0xFF)
	OUT  0x1B,R30
;     439 in_word_new=PINA;
	IN   R30,0x19
	STS  _in_word_new,R30
;     440 if(in_word_old==in_word_new)
	LDS  R26,_in_word_old
	CP   R30,R26
	BRNE _0x5F
;     441 	{
;     442 	if(in_word_cnt<10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRSH _0x60
;     443 		{
;     444 		in_word_cnt++;
	LDS  R30,_in_word_cnt
	SUBI R30,-LOW(1)
	STS  _in_word_cnt,R30
;     445 		if(in_word_cnt>=10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRLO _0x61
;     446 			{
;     447 			in_word=in_word_old;
	LDS  R30,_in_word_old
	STS  _in_word,R30
;     448 			}
;     449 		}
_0x61:
;     450 	}
_0x60:
;     451 else in_word_cnt=0;
	RJMP _0x62
_0x5F:
	LDI  R30,LOW(0)
	STS  _in_word_cnt,R30
_0x62:
;     452 
;     453 
;     454 in_word_old=in_word_new;
	LDS  R30,_in_word_new
	STS  _in_word_old,R30
;     455 }   
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;     456 
;     457 //-----------------------------------------------
;     458 void err_drv(void)
;     459 {
_err_drv:
;     460 if(step_main==sOFF)
	LDS  R30,_step_main
	CPI  R30,0
	BREQ PC+3
	JMP _0x63
;     461 	{
;     462 	if((((state[0]&0b00000011)!=0b00000010)&&(ch_on[0]==coON))
;     463 		||(((state[0]&0b00011000)!=0b00010000)&&(ch_on[1]==coON))
;     464 		||(((state[1]&0b00000011)!=0b00000010)&&(ch_on[2]==coON))
;     465 		||(((state[1]&0b00011000)!=0b00010000)&&(ch_on[3]==coON))
;     466 		||(((state[2]&0b00000011)!=0b00000010)&&(ch_on[4]==coON))
;     467 		||(((state[2]&0b00011000)!=0b00010000)&&(ch_on[5]==coON))) bERR=1;
	LDS  R30,_state
	ANDI R30,LOW(0x3)
	CPI  R30,LOW(0x2)
	BREQ _0x65
	CALL SUBOPT_0x2
	BREQ _0x67
_0x65:
	LDS  R30,_state
	ANDI R30,LOW(0x18)
	CPI  R30,LOW(0x10)
	BREQ _0x68
	__POINTW2MN _ch_on,1
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x67
_0x68:
	__GETB1MN _state,1
	ANDI R30,LOW(0x3)
	CPI  R30,LOW(0x2)
	BREQ _0x6A
	__POINTW2MN _ch_on,2
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x67
_0x6A:
	__GETB1MN _state,1
	ANDI R30,LOW(0x18)
	CPI  R30,LOW(0x10)
	BREQ _0x6C
	__POINTW2MN _ch_on,3
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x67
_0x6C:
	__GETB1MN _state,2
	ANDI R30,LOW(0x3)
	CPI  R30,LOW(0x2)
	BREQ _0x6E
	__POINTW2MN _ch_on,4
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x67
_0x6E:
	__GETB1MN _state,2
	ANDI R30,LOW(0x18)
	CPI  R30,LOW(0x10)
	BREQ _0x70
	__POINTW2MN _ch_on,5
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BREQ _0x67
_0x70:
	RJMP _0x64
_0x67:
	SET
	BLD  R3,1
;     468 	else bERR=0;
	RJMP _0x73
_0x64:
	CLT
	BLD  R3,1
_0x73:
;     469 	}
;     470 else bERR=0;
	RJMP _0x74
_0x63:
	CLT
	BLD  R3,1
_0x74:
;     471 
;     472 }
	RET
;     473 
;     474 //-----------------------------------------------
;     475 void mdvr_drv(void)
;     476 {
;     477 if(!(in_word&(1<<MD1)))
;     478 	{
;     479 	if(cnt_md1<10)
;     480 		{
;     481 		cnt_md1++;
;     482 		if(cnt_md1==10) bMD1=1;
;     483 		}
;     484 
;     485 	}
;     486 else
;     487 	{
;     488 	if(cnt_md1)
;     489 		{
;     490 		cnt_md1--;
;     491 		if(cnt_md1==0) bMD1=0;
;     492 		}
;     493 
;     494 	}
;     495 
;     496 if(!(in_word&(1<<MD2)))
;     497 	{
;     498 	if(cnt_md2<10)
;     499 		{
;     500 		cnt_md2++;
;     501 		if(cnt_md2==10) bMD2=1;
;     502 		}
;     503 
;     504 	}
;     505 else
;     506 	{
;     507 	if(cnt_md2)
;     508 		{
;     509 		cnt_md2--;
;     510 		if(cnt_md2==0) bMD2=0;
;     511 		}
;     512 
;     513 	}
;     514 
;     515 if(!(in_word&(1<<MD3)))
;     516 	{
;     517 	if(cnt_md3<10)
;     518 		{
;     519 		cnt_md3++;
;     520 		if(cnt_md3==10) bMD3=1;
;     521 		}
;     522 
;     523 	}
;     524 else
;     525 	{
;     526 	if(cnt_md3)
;     527 		{
;     528 		cnt_md3--;
;     529 		if(cnt_md3==0) bMD3=0;
;     530 		}
;     531 
;     532 	}
;     533 
;     534 if(!(in_word&(1<<VR)))
;     535 	{
;     536 	if(cnt_vr<10)
;     537 		{
;     538 		cnt_vr++;
;     539 		if(cnt_vr==10) bVR=1;
;     540 		}
;     541 
;     542 	}
;     543 else
;     544 	{
;     545 	if(cnt_vr)
;     546 		{
;     547 		cnt_vr--;
;     548 		if(cnt_vr==0) bVR=0;
;     549 		}
;     550 
;     551 	}
;     552 } 
;     553 
;     554 #ifdef P380
;     555 //-----------------------------------------------
;     556 void step_contr(void)
;     557 {
;     558 char temp=0;
;     559 DDRB=0xFF;
;     560 
;     561 if(step==sOFF)
;     562 	{
;     563 	temp=0;
;     564 	}
;     565 
;     566 else if(prog==p1)
;     567 	{
;     568 	if(step==s1)
;     569 		{
;     570 		temp|=(1<<PP1)|(1<<PP2);
;     571 
;     572 		cnt_del--;
;     573 		if(cnt_del==0)
;     574 			{
;     575 			if(ee_vacuum_mode==evmOFF)
;     576 				{
;     577 				goto lbl_0001;
;     578 				}
;     579 			else step=s2;
;     580 			}
;     581 		}
;     582 
;     583 	else if(step==s2)
;     584 		{
;     585 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     586 
;     587           if(!bVR)goto step_contr_end;
;     588 lbl_0001:
;     589 #ifndef BIG_CAM
;     590 		cnt_del=30;
;     591 #endif
;     592 
;     593 #ifdef BIG_CAM
;     594 		cnt_del=100;
;     595 #endif
;     596 		step=s3;
;     597 		}
;     598 
;     599 	else if(step==s3)
;     600 		{
;     601 		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     602 		cnt_del--;
;     603 		if(cnt_del==0)
;     604 			{
;     605 			step=s4;
;     606 			}
;     607           }
;     608 	else if(step==s4)
;     609 		{
;     610 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     611 
;     612           if(!bMD1)goto step_contr_end;
;     613 
;     614 		cnt_del=30;
;     615 		step=s5;
;     616 		}
;     617 	else if(step==s5)
;     618 		{
;     619 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     620 
;     621 		cnt_del--;
;     622 		if(cnt_del==0)
;     623 			{
;     624 			step=s6;
;     625 			}
;     626 		}
;     627 	else if(step==s6)
;     628 		{
;     629 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     630 
;     631          	if(!bMD2)goto step_contr_end;
;     632           cnt_del=30;
;     633 		step=s7;
;     634 		}
;     635 	else if(step==s7)
;     636 		{
;     637 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;     638 
;     639 		cnt_del--;
;     640 		if(cnt_del==0)
;     641 			{
;     642 			step=s8;
;     643 			cnt_del=30;
;     644 			}
;     645 		}
;     646 	else if(step==s8)
;     647 		{
;     648 		temp|=(1<<PP1)|(1<<PP3);
;     649 
;     650 		cnt_del--;
;     651 		if(cnt_del==0)
;     652 			{
;     653 			step=s9;
;     654 #ifndef BIG_CAM
;     655 		cnt_del=150;
;     656 #endif
;     657 
;     658 #ifdef BIG_CAM
;     659 		cnt_del=200;
;     660 #endif
;     661 			}
;     662 		}
;     663 	else if(step==s9)
;     664 		{
;     665 		temp|=(1<<PP1)|(1<<PP2);
;     666 
;     667 		cnt_del--;
;     668 		if(cnt_del==0)
;     669 			{
;     670 			step=s10;
;     671 			cnt_del=30;
;     672 			}
;     673 		}
;     674 	else if(step==s10)
;     675 		{
;     676 		temp|=(1<<PP2);
;     677 		cnt_del--;
;     678 		if(cnt_del==0)
;     679 			{
;     680 			step=sOFF;
;     681 			}
;     682 		}
;     683 	}
;     684 
;     685 if(prog==p2)
;     686 	{
;     687 
;     688 	if(step==s1)
;     689 		{
;     690 		temp|=(1<<PP1)|(1<<PP2);
;     691 
;     692 		cnt_del--;
;     693 		if(cnt_del==0)
;     694 			{
;     695 			if(ee_vacuum_mode==evmOFF)
;     696 				{
;     697 				goto lbl_0002;
;     698 				}
;     699 			else step=s2;
;     700 			}
;     701 		}
;     702 
;     703 	else if(step==s2)
;     704 		{
;     705 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     706 
;     707           if(!bVR)goto step_contr_end;
;     708 lbl_0002:
;     709 #ifndef BIG_CAM
;     710 		cnt_del=30;
;     711 #endif
;     712 
;     713 #ifdef BIG_CAM
;     714 		cnt_del=100;
;     715 #endif
;     716 		step=s3;
;     717 		}
;     718 
;     719 	else if(step==s3)
;     720 		{
;     721 		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     722 
;     723 		cnt_del--;
;     724 		if(cnt_del==0)
;     725 			{
;     726 			step=s4;
;     727 			}
;     728 		}
;     729 
;     730 	else if(step==s4)
;     731 		{
;     732 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     733 
;     734           if(!bMD1)goto step_contr_end;
;     735          	cnt_del=30;
;     736 		step=s5;
;     737 		}
;     738 
;     739 	else if(step==s5)
;     740 		{
;     741 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     742 
;     743 		cnt_del--;
;     744 		if(cnt_del==0)
;     745 			{
;     746 			step=s6;
;     747 			cnt_del=30;
;     748 			}
;     749 		}
;     750 
;     751 	else if(step==s6)
;     752 		{
;     753 		temp|=(1<<PP1)|(1<<PP3);
;     754 
;     755 		cnt_del--;
;     756 		if(cnt_del==0)
;     757 			{
;     758 			step=s7;
;     759 #ifndef BIG_CAM
;     760 		cnt_del=150;
;     761 #endif
;     762 
;     763 #ifdef BIG_CAM
;     764 		cnt_del=200;
;     765 #endif
;     766 			}
;     767 		}
;     768 
;     769 	else if(step==s7)
;     770 		{
;     771 		temp|=(1<<PP1)|(1<<PP2);
;     772 
;     773 		cnt_del--;
;     774 		if(cnt_del==0)
;     775 			{
;     776 			step=s8;
;     777 			cnt_del=30;
;     778 			}
;     779 		}
;     780 	else if(step==s8)
;     781 		{
;     782 		temp|=(1<<PP2);
;     783 
;     784 		cnt_del--;
;     785 		if(cnt_del==0)
;     786 			{
;     787 			step=sOFF;
;     788 			}
;     789 		}
;     790 	}
;     791 
;     792 if(prog==p3)
;     793 	{
;     794 
;     795 	if(step==s1)
;     796 		{
;     797 		temp|=(1<<PP1)|(1<<PP2);
;     798 
;     799 		cnt_del--;
;     800 		if(cnt_del==0)
;     801 			{
;     802 			if(ee_vacuum_mode==evmOFF)
;     803 				{
;     804 				goto lbl_0003;
;     805 				}
;     806 			else step=s2;
;     807 			}
;     808 		}
;     809 
;     810 	else if(step==s2)
;     811 		{
;     812 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     813 
;     814           if(!bVR)goto step_contr_end;
;     815 lbl_0003:
;     816 #ifndef BIG_CAM
;     817 		cnt_del=80;
;     818 #endif
;     819 
;     820 #ifdef BIG_CAM
;     821 		cnt_del=100;
;     822 #endif
;     823 		step=s3;
;     824 		}
;     825 
;     826 	else if(step==s3)
;     827 		{
;     828 		temp|=(1<<PP1)|(1<<PP3);
;     829 
;     830 		cnt_del--;
;     831 		if(cnt_del==0)
;     832 			{
;     833 			step=s4;
;     834 			cnt_del=120;
;     835 			}
;     836 		}
;     837 
;     838 	else if(step==s4)
;     839 		{
;     840 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<PP5);
;     841 
;     842 		cnt_del--;
;     843 		if(cnt_del==0)
;     844 			{
;     845 			step=s5;
;     846 
;     847 		
;     848 #ifndef BIG_CAM
;     849 		cnt_del=150;
;     850 #endif
;     851 
;     852 #ifdef BIG_CAM
;     853 		cnt_del=200;
;     854 #endif
;     855 	//	step=s5;
;     856 	}
;     857 		}
;     858 
;     859 	else if(step==s5)
;     860 		{
;     861 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<PP5);
;     862 
;     863 		cnt_del--;
;     864 		if(cnt_del==0)
;     865 			{
;     866 			step=s6;
;     867 			cnt_del=30;
;     868 			}
;     869 		}
;     870 
;     871 	else if(step==s6)
;     872 		{
;     873 		temp|=(1<<PP2)|(1<<PP4)|(1<<PP5);
;     874 
;     875 		cnt_del--;
;     876 		if(cnt_del==0)
;     877 			{
;     878 			step=s7;
;     879 			cnt_del=30;
;     880 			}
;     881 		}
;     882 
;     883 	else if(step==s7)
;     884 		{
;     885 		temp|=(1<<PP2);
;     886 
;     887 		cnt_del--;
;     888 		if(cnt_del==0)
;     889 			{
;     890 			step=sOFF;
;     891 			}
;     892 		}
;     893 
;     894 	}
;     895 step_contr_end:
;     896 
;     897 if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;     898 
;     899 PORTB=~temp;
;     900 }
;     901 #endif
;     902 #ifdef I380
;     903 //-----------------------------------------------
;     904 void step_contr(void)
;     905 {
;     906 char temp=0;
;     907 DDRB=0xFF;
;     908 
;     909 if(step==sOFF)goto step_contr_end;
;     910 
;     911 else if(prog==p1)
;     912 	{
;     913 	if(step==s1)    //жесть
;     914 		{
;     915 		temp|=(1<<PP1);
;     916           if(!bMD1)goto step_contr_end;
;     917 
;     918 		}
;     919 
;     920 	else if(step==s2)
;     921 		{
;     922 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;     923           if(!bVR)goto step_contr_end;
;     924 lbl_0001:
;     925 
;     926           step=s100;
;     927 		cnt_del=40;
;     928           }
;     929 	else if(step==s100)
;     930 		{
;     931 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;     932           cnt_del--;
;     933           if(cnt_del==0)
;     934 			{
;     935           	step=s3;
;     936           	cnt_del=50;
;     937 			}
;     938 		}
;     939 
;     940 	else if(step==s3)
;     941 		{
;     942 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     943           cnt_del--;
;     944           if(cnt_del==0)
;     945 			{
;     946           	step=s4;
;     947 			}
;     948 		}
;     949 	else if(step==s4)
;     950 		{
;     951 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;     952           if(!bMD2)goto step_contr_end;
;     953           step=s5;
;     954           cnt_del=20;
;     955 		}
;     956 	else if(step==s5)
;     957 		{
;     958 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;     959           cnt_del--;
;     960           if(cnt_del==0)
;     961 			{
;     962           	step=s6;
;     963 			}
;     964           }
;     965 	else if(step==s6)
;     966 		{
;     967 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
;     968           if(!bMD3)goto step_contr_end;
;     969           step=s7;
;     970           cnt_del=20;
;     971 		}
;     972 
;     973 
;     974 	else if(step==s8)
;     975 		{
;     976 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;     977           cnt_del--;
;     978           if(cnt_del==0)
;     979 			{
;     980           	step=s9;
;     981           	cnt_del=20;
;     982 			}
;     983           }
;     984 	else if(step==s9)
;     985 		{
;     986 		temp|=(1<<PP1);
;     987           cnt_del--;
;     988           if(cnt_del==0)
;     989 			{
;     990           	step=sOFF;
;     991           	}
;     992           }
;     993 	}
;     994 
;     995 else if(prog==p2)  //ско
;     996 	{
;     997 	if(step==s1)
;     998 		{
;     999 		temp|=(1<<PP1);
;    1000           if(!bMD1)goto step_contr_end;
;    1001 
;    1002 
;    1003           //step=s2;
;    1004 		}
;    1005 
;    1006 	else if(step==s2)
;    1007 		{
;    1008 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1009           if(!bVR)goto step_contr_end;
;    1010 
;    1011 lbl_0002:
;    1012           step=s100;
;    1013 		cnt_del=40;
;    1014           }
;    1015 	else if(step==s100)
;    1016 		{
;    1017 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;    1018           cnt_del--;
;    1019           if(cnt_del==0)
;    1020 			{
;    1021           	step=s3;
;    1022           	cnt_del=50;
;    1023 			}
;    1024 		}
;    1025 	else if(step==s3)
;    1026 		{
;    1027 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;    1028           cnt_del--;
;    1029           if(cnt_del==0)
;    1030 			{
;    1031           	step=s4;
;    1032 			}
;    1033 		}
;    1034 	else if(step==s4)
;    1035 		{
;    1036 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;    1037           if(!bMD2)goto step_contr_end;
;    1038           step=s5;
;    1039           cnt_del=20;
;    1040 		}
;    1041 	else if(step==s6)
;    1042 		{
;    1043 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1044           cnt_del--;
;    1045           if(cnt_del==0)
;    1046 			{
;    1047           	step=s7;
;    1048           	cnt_del=20;
;    1049 			}
;    1050           }
;    1051 	else if(step==s7)
;    1052 		{
;    1053 		temp|=(1<<PP1);
;    1054           cnt_del--;
;    1055           if(cnt_del==0)
;    1056 			{
;    1057           	step=sOFF;
;    1058           	}
;    1059           }
;    1060 	}
;    1061 
;    1062 else if(prog==p3)   //твист
;    1063 	{
;    1064 	if(step==s1)
;    1065 		{
;    1066 		temp|=(1<<PP1);
;    1067           if(!bMD1)goto step_contr_end;
;    1068 
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
;    1083 
;    1084 	else if(step==s4)
;    1085 		{
;    1086 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;    1087 		cnt_del--;
;    1088  		}
;    1089 
;    1090 	else if(step==s5)
;    1091 		{
;    1092 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;    1093 		cnt_del--;
;    1094 		if(cnt_del==0)
;    1095 			{
;    1096 			step=s6;
;    1097 			cnt_del=20;
;    1098 			}
;    1099 		}
;    1100 
;    1101 	else if(step==s6)
;    1102 		{
;    1103 		temp|=(1<<PP1);
;    1104   		cnt_del--;
;    1105 		if(cnt_del==0)
;    1106 			{
;    1107 			step=sOFF;
;    1108 			}
;    1109 		}
;    1110 
;    1111 	}
;    1112 
;    1113 else if(prog==p4)      //замок
;    1114 	{
;    1115 	if(step==s1)
;    1116 		{
;    1117 		temp|=(1<<PP1);
;    1118           if(!bMD1)goto step_contr_end;
;    1119 
;    1120           //step=s2;
;    1121 		}
;    1122 
;    1123 	else if(step==s2)
;    1124 		{
;    1125 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;    1126           if(!bVR)goto step_contr_end;
;    1127 lbl_0004:
;    1128           step=s3;
;    1129 		cnt_del=50;
;    1130           }
;    1131 
;    1132 
;    1133 
;    1134    	else if(step==s4)
;    1135 		{
;    1136 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;    1137 		cnt_del--;
;    1138 		if(cnt_del==0)
;    1139 			{
;    1140 			step=s5;
;    1141 			cnt_del=30;
;    1142 			}
;    1143 		}
;    1144 
;    1145 	else if(step==s5)
;    1146 		{
;    1147 		temp|=(1<<PP1)|(1<<PP4);
;    1148 		cnt_del--;
;    1149 		if(cnt_del==0)
;    1150 			{
;    1151 			step=s6;
;    1152 			}
;    1153 		}
;    1154 
;    1155 	else if(step==s6)
;    1156 		{
;    1157 		temp|=(1<<PP4);
;    1158 		cnt_del--;
;    1159 		if(cnt_del==0)
;    1160 			{
;    1161 			step=sOFF;
;    1162 			}
;    1163 		}
;    1164 
;    1165 	}
;    1166 	
;    1167 step_contr_end:
;    1168 
;    1169 
;    1170 PORTB=~temp;
;    1171 //PORTB=0x55;
;    1172 }
;    1173 #endif
;    1174 
;    1175 
;    1176 //-----------------------------------------------
;    1177 void bin2bcd_int(unsigned int in)
;    1178 {
_bin2bcd_int:
;    1179 char i;
;    1180 for(i=3;i>0;i--)
	ST   -Y,R16
;	in -> Y+1
;	i -> R16
	LDI  R16,LOW(3)
_0x8E:
	LDI  R30,LOW(0)
	CP   R30,R16
	BRSH _0x8F
;    1181 	{
;    1182 	dig[i]=in%10;
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
;    1183 	in/=10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
;    1184 	}   
	SUBI R16,1
	RJMP _0x8E
_0x8F:
;    1185 }
	LDD  R16,Y+0
	RJMP _0x12E
;    1186 
;    1187 //-----------------------------------------------
;    1188 void bcd2ind(char s)
;    1189 {
_bcd2ind:
;    1190 char i;
;    1191 bZ=1;
	ST   -Y,R16
;	s -> Y+1
;	i -> R16
	SET
	BLD  R2,3
;    1192 for (i=0;i<5;i++)
	LDI  R16,LOW(0)
_0x91:
	CPI  R16,5
	BRLO PC+3
	JMP _0x92
;    1193 	{
;    1194 	if(bZ&&(!dig[i-1])&&(i<4))
	SBRS R2,3
	RJMP _0x94
	CALL SUBOPT_0x4
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	CPI  R30,0
	BRNE _0x94
	CPI  R16,4
	BRLO _0x95
_0x94:
	RJMP _0x93
_0x95:
;    1195 		{
;    1196 		if((4-i)>s)
	LDI  R30,LOW(4)
	SUB  R30,R16
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
	BRSH _0x96
;    1197 			{
;    1198 			ind_out[i-1]=DIGISYM[10];
	CALL SUBOPT_0x4
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	POP  R26
	POP  R27
	RJMP _0x130
;    1199 			}
;    1200 		else ind_out[i-1]=DIGISYM[0];	
_0x96:
	CALL SUBOPT_0x4
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
;    1201 		}
;    1202 	else
	RJMP _0x98
_0x93:
;    1203 		{
;    1204 		ind_out[i-1]=DIGISYM[dig[i-1]];
	CALL SUBOPT_0x4
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	POP  R26
	POP  R27
	CALL SUBOPT_0x5
	POP  R26
	POP  R27
	ST   X,R30
;    1205 		bZ=0;
	CLT
	BLD  R2,3
;    1206 		}                   
_0x98:
;    1207 
;    1208 	if(s)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x99
;    1209 		{
;    1210 		ind_out[3-s]&=0b01111111;
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
;    1211 		}	
;    1212  
;    1213 	}
_0x99:
	SUBI R16,-1
	RJMP _0x91
_0x92:
;    1214 }            
	LDD  R16,Y+0
	ADIW R28,2
	RET
;    1215 //-----------------------------------------------
;    1216 void int2ind(unsigned int in,char s)
;    1217 {
_int2ind:
;    1218 bin2bcd_int(in);
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _bin2bcd_int
;    1219 bcd2ind(s);
	LD   R30,Y
	ST   -Y,R30
	CALL _bcd2ind
;    1220 
;    1221 } 
_0x12E:
	ADIW R28,3
	RET
;    1222 
;    1223 //-----------------------------------------------
;    1224 void uart_in_an(void)
;    1225 {
_uart_in_an:
;    1226 state[rx_buffer[0]-1]=rx_buffer[1];
	LDS  R30,_rx_buffer
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_state)
	SBCI R31,HIGH(-_state)
	PUSH R31
	PUSH R30
	__GETB1MN _rx_buffer,1
	POP  R26
	POP  R27
	ST   X,R30
;    1227 
;    1228 /*state_new=rx_buffer[2];
;    1229 if(state_new==state_old)
;    1230 	{
;    1231 	if(state_cnt<4)
;    1232 		{
;    1233 		state_cnt++;
;    1234 		if(state_cnt>=4)
;    1235 			{                  
;    1236 			if((state_new&0x7f)!=state)
;    1237 				{
;    1238 				state=state_new&0x7f;
;    1239 				state_an();
;    1240 				}
;    1241 			}         
;    1242 		}	
;    1243 	}		
;    1244 else state_cnt=0;
;    1245 state_old=state_new;*/
;    1246 	 
;    1247 /*state=rx_buffer[2];
;    1248 state_an();*/					
;    1249 	
;    1250 }
	RET
;    1251 
;    1252 
;    1253 //-----------------------------------------------
;    1254 void mathemat(void)
;    1255 {
_mathemat:
;    1256 timer1_delay=ee_timer1_delay*31;
	LDI  R26,LOW(_ee_timer1_delay)
	LDI  R27,HIGH(_ee_timer1_delay)
	CALL __EEPROMRDW
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	CALL __MULW12U
	STS  _timer1_delay,R30
	STS  _timer1_delay+1,R31
;    1257 }
	RET
;    1258 
;    1259 //-----------------------------------------------
;    1260 void ind_hndl(void)
;    1261 {
_ind_hndl:
;    1262 if(ind==iMn)
	LDS  R30,_ind
	CPI  R30,0
	BRNE _0x9A
;    1263 	{
;    1264 //int2ind(ee_delay[prog,sub_ind],1);  
;    1265 //ind_out[0]=0xff;//DIGISYM[0];
;    1266 //ind_out[1]=0xff;//DIGISYM[1];
;    1267 //ind_out[2]=DIGISYM[2];//0xff;
;    1268 //ind_out[0]=DIGISYM[7]; 
;    1269 
;    1270 //ind_out[0]=DIGISYM[sub_ind+1];
;    1271 
;    1272 	int2ind(step_main,0);
	LDS  R30,_step_main
	LDI  R31,0
	CALL SUBOPT_0x6
;    1273 	//int2ind(stop_cnt,0);
;    1274 	} 
;    1275 else if(ind==iSet_sel)
	RJMP _0x9B
_0x9A:
	LDS  R26,_ind
	CPI  R26,LOW(0x2)
	BREQ PC+3
	JMP _0x9C
;    1276 	{
;    1277 	if(sub_ind==0)
	LDS  R30,_sub_ind
	CPI  R30,0
	BRNE _0x9D
;    1278 		{
;    1279 		if(ch_on[0]==coON)
	CALL SUBOPT_0x2
	BRNE _0x9E
;    1280 			{
;    1281 			ind_out[3]=SYMn;
	LDI  R30,LOW(171)
	__PUTB1MN _ind_out,3
;    1282 			ind_out[2]=SYMo;
	LDI  R30,LOW(163)
	__PUTB1MN _ind_out,2
;    1283 			ind_out[1]=SYM;
	LDI  R30,LOW(255)
	__PUTB1MN _ind_out,1
;    1284 			}
;    1285 		else 
	RJMP _0x9F
_0x9E:
;    1286 			{
;    1287 			ind_out[3]=SYMf;
	LDI  R30,LOW(142)
	__PUTB1MN _ind_out,3
;    1288 			ind_out[2]=SYMf;
	__PUTB1MN _ind_out,2
;    1289 			ind_out[1]=SYMo;
	LDI  R30,LOW(163)
	__PUTB1MN _ind_out,1
;    1290 			}			
_0x9F:
;    1291 		}
;    1292 	else if(sub_ind==1)
	RJMP _0xA0
_0x9D:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x1)
	BRNE _0xA1
;    1293 		{
;    1294 		if(ch_on[1]==coON)
	__POINTW2MN _ch_on,1
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BRNE _0xA2
;    1295 			{
;    1296 			ind_out[3]=SYMn;
	LDI  R30,LOW(171)
	__PUTB1MN _ind_out,3
;    1297 			ind_out[2]=SYMo;
	LDI  R30,LOW(163)
	__PUTB1MN _ind_out,2
;    1298 			ind_out[1]=SYM;
	LDI  R30,LOW(255)
	__PUTB1MN _ind_out,1
;    1299 			}
;    1300 		else 
	RJMP _0xA3
_0xA2:
;    1301 			{
;    1302 			ind_out[3]=SYMf;
	LDI  R30,LOW(142)
	__PUTB1MN _ind_out,3
;    1303 			ind_out[2]=SYMf;
	__PUTB1MN _ind_out,2
;    1304 			ind_out[1]=SYMo;
	LDI  R30,LOW(163)
	__PUTB1MN _ind_out,1
;    1305 			}			
_0xA3:
;    1306 		} 
;    1307 		
;    1308 	else if(sub_ind==2)
	RJMP _0xA4
_0xA1:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x2)
	BRNE _0xA5
;    1309 		{
;    1310 		if(ch_on[2]==coON)
	__POINTW2MN _ch_on,2
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BRNE _0xA6
;    1311 			{
;    1312 			ind_out[3]=SYMn;
	LDI  R30,LOW(171)
	__PUTB1MN _ind_out,3
;    1313 			ind_out[2]=SYMo;
	LDI  R30,LOW(163)
	__PUTB1MN _ind_out,2
;    1314 			ind_out[1]=SYM;
	LDI  R30,LOW(255)
	__PUTB1MN _ind_out,1
;    1315 			}
;    1316 		else 
	RJMP _0xA7
_0xA6:
;    1317 			{
;    1318 			ind_out[3]=SYMf;
	LDI  R30,LOW(142)
	__PUTB1MN _ind_out,3
;    1319 			ind_out[2]=SYMf;
	__PUTB1MN _ind_out,2
;    1320 			ind_out[1]=SYMo;
	LDI  R30,LOW(163)
	__PUTB1MN _ind_out,1
;    1321 			}			
_0xA7:
;    1322 		}	
;    1323 		
;    1324 	else if(sub_ind==3)
	RJMP _0xA8
_0xA5:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x3)
	BRNE _0xA9
;    1325 		{
;    1326 		if(ch_on[3]==coON)
	__POINTW2MN _ch_on,3
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BRNE _0xAA
;    1327 			{
;    1328 			ind_out[3]=SYMn;
	LDI  R30,LOW(171)
	__PUTB1MN _ind_out,3
;    1329 			ind_out[2]=SYMo;
	LDI  R30,LOW(163)
	__PUTB1MN _ind_out,2
;    1330 			ind_out[1]=SYM;
	LDI  R30,LOW(255)
	__PUTB1MN _ind_out,1
;    1331 			}
;    1332 		else 
	RJMP _0xAB
_0xAA:
;    1333 			{
;    1334 			ind_out[3]=SYMf;
	LDI  R30,LOW(142)
	__PUTB1MN _ind_out,3
;    1335 			ind_out[2]=SYMf;
	__PUTB1MN _ind_out,2
;    1336 			ind_out[1]=SYMo;
	LDI  R30,LOW(163)
	__PUTB1MN _ind_out,1
;    1337 			}			
_0xAB:
;    1338 		}	
;    1339 		
;    1340 	else if(sub_ind==4)
	RJMP _0xAC
_0xA9:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x4)
	BRNE _0xAD
;    1341 		{
;    1342 		if(ch_on[4]==coON)
	__POINTW2MN _ch_on,4
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BRNE _0xAE
;    1343 			{
;    1344 			ind_out[3]=SYMn;
	LDI  R30,LOW(171)
	__PUTB1MN _ind_out,3
;    1345 			ind_out[2]=SYMo;
	LDI  R30,LOW(163)
	__PUTB1MN _ind_out,2
;    1346 			ind_out[1]=SYM;
	LDI  R30,LOW(255)
	__PUTB1MN _ind_out,1
;    1347 			}
;    1348 		else 
	RJMP _0xAF
_0xAE:
;    1349 			{
;    1350 			ind_out[3]=SYMf;
	LDI  R30,LOW(142)
	__PUTB1MN _ind_out,3
;    1351 			ind_out[2]=SYMf;
	__PUTB1MN _ind_out,2
;    1352 			ind_out[1]=SYMo;
	LDI  R30,LOW(163)
	__PUTB1MN _ind_out,1
;    1353 			}			
_0xAF:
;    1354 		}	
;    1355 		
;    1356 	else if(sub_ind==5)
	RJMP _0xB0
_0xAD:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x5)
	BRNE _0xB1
;    1357 		{
;    1358 		if(ch_on[5]==coON)
	__POINTW2MN _ch_on,5
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	BRNE _0xB2
;    1359 			{
;    1360 			ind_out[3]=SYMn;
	LDI  R30,LOW(171)
	__PUTB1MN _ind_out,3
;    1361 			ind_out[2]=SYMo;
	LDI  R30,LOW(163)
	__PUTB1MN _ind_out,2
;    1362 			ind_out[1]=SYM;
	LDI  R30,LOW(255)
	__PUTB1MN _ind_out,1
;    1363 			}
;    1364 		else 
	RJMP _0xB3
_0xB2:
;    1365 			{
;    1366 			ind_out[3]=SYMf;
	LDI  R30,LOW(142)
	__PUTB1MN _ind_out,3
;    1367 			ind_out[2]=SYMf;
	__PUTB1MN _ind_out,2
;    1368 			ind_out[1]=SYMo;
	LDI  R30,LOW(163)
	__PUTB1MN _ind_out,1
;    1369 			}			
_0xB3:
;    1370 		}
;    1371 
;    1372 	else if(sub_ind==6)
	RJMP _0xB4
_0xB1:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x6)
	BRNE _0xB5
;    1373 		{
;    1374 		int2ind(ee_timer1_delay,0);		
	LDI  R26,LOW(_ee_timer1_delay)
	LDI  R27,HIGH(_ee_timer1_delay)
	CALL __EEPROMRDW
	CALL SUBOPT_0x6
;    1375 		}
;    1376 	else if(sub_ind==7)
	RJMP _0xB6
_0xB5:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x7)
	BRNE _0xB7
;    1377 		{
;    1378 		ind_out[3]=SYMt;
	LDI  R30,LOW(135)
	__PUTB1MN _ind_out,3
;    1379 		ind_out[2]=SYMu;
	LDI  R30,LOW(227)
	__PUTB1MN _ind_out,2
;    1380 		ind_out[1]=SYMo;
	LDI  R30,LOW(163)
	__PUTB1MN _ind_out,1
;    1381 		}															
;    1382 	if(sub_ind!=7)ind_out[0]=DIGISYM[sub_ind+1];
_0xB7:
_0xB6:
_0xB4:
_0xB0:
_0xAC:
_0xA8:
_0xA4:
_0xA0:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x7)
	BREQ _0xB8
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	PUSH R31
	PUSH R30
	LDS  R30,_sub_ind
	SUBI R30,-LOW(1)
	POP  R26
	POP  R27
	CALL SUBOPT_0x5
	RJMP _0x131
;    1383 	else ind_out[0]=SYM;
_0xB8:
	LDI  R30,LOW(255)
_0x131:
	STS  _ind_out,R30
;    1384 	if(bFL5)ind_out[0]=SYM;		
	SBRS R3,0
	RJMP _0xBA
	LDI  R30,LOW(255)
	STS  _ind_out,R30
;    1385 	} 
_0xBA:
;    1386 	
;    1387 else if(ind==iCh_on)
	RJMP _0xBB
_0x9C:
	LDS  R26,_ind
	CPI  R26,LOW(0x4)
	BRNE _0xBC
;    1388 	{
;    1389 	ind_out[0]=SYM;
	LDI  R30,LOW(255)
	STS  _ind_out,R30
;    1390 	if(ch_on[sub_ind]==coON)	
	CALL SUBOPT_0x7
	BRNE _0xBD
;    1391 		{
;    1392 		ind_out[3]=SYMn;
	LDI  R30,LOW(171)
	__PUTB1MN _ind_out,3
;    1393 		ind_out[2]=SYMo;
	LDI  R30,LOW(163)
	__PUTB1MN _ind_out,2
;    1394 		ind_out[1]=SYM;
	LDI  R30,LOW(255)
	__PUTB1MN _ind_out,1
;    1395 		}
;    1396     	else 
	RJMP _0xBE
_0xBD:
;    1397     		{
;    1398     		ind_out[3]=SYMf;
	LDI  R30,LOW(142)
	__PUTB1MN _ind_out,3
;    1399 		ind_out[2]=SYMf;
	__PUTB1MN _ind_out,2
;    1400 		ind_out[1]=SYMo;
	LDI  R30,LOW(163)
	__PUTB1MN _ind_out,1
;    1401 		}
_0xBE:
;    1402 	if(bFL5)
	SBRS R3,0
	RJMP _0xBF
;    1403 		{
;    1404 		ind_out[3]=SYM;
	LDI  R30,LOW(255)
	__PUTB1MN _ind_out,3
;    1405 		ind_out[2]=SYM;
	__PUTB1MN _ind_out,2
;    1406 		ind_out[1]=SYM;
	__PUTB1MN _ind_out,1
;    1407 		}
;    1408 	}		 
_0xBF:
;    1409 	
;    1410 else if(ind==iSet_delay)
	RJMP _0xC0
_0xBC:
	LDS  R26,_ind
	CPI  R26,LOW(0x3)
	BRNE _0xC1
;    1411 	{
;    1412 	ind_out[0]=SYM;
	LDI  R30,LOW(255)
	STS  _ind_out,R30
;    1413 	int2ind(ee_timer1_delay,0);
	LDI  R26,LOW(_ee_timer1_delay)
	LDI  R27,HIGH(_ee_timer1_delay)
	CALL __EEPROMRDW
	CALL SUBOPT_0x6
;    1414 	if(bFL5)
	SBRS R3,0
	RJMP _0xC2
;    1415 		{
;    1416 		ind_out[3]=SYM;
	LDI  R30,LOW(255)
	__PUTB1MN _ind_out,3
;    1417 		ind_out[2]=SYM;
	__PUTB1MN _ind_out,2
;    1418 		ind_out[1]=SYM;
	__PUTB1MN _ind_out,1
;    1419 		}
;    1420 	}			
_0xC2:
;    1421 }
_0xC1:
_0xC0:
_0xBB:
_0x9B:
	RET
;    1422 
;    1423 //-----------------------------------------------
;    1424 void led_hndl(void)
;    1425 {
_led_hndl:
;    1426 ind_out[4]=DIGISYM[10]; 
	__POINTW1FN _DIGISYM,10
	LPM  R30,Z
	__PUTB1MN _ind_out,4
;    1427 
;    1428 ind_out[4]&=~(1<<LED_POW_ON); 
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xDF
	POP  R26
	POP  R27
	ST   X,R30
;    1429 
;    1430 if(step_main!=sOFF)
	LDS  R30,_step_main
	CPI  R30,0
	BREQ _0xC3
;    1431 	{
;    1432 	ind_out[4]&=~(1<<LED_WRK);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xBF
	POP  R26
	POP  R27
	RJMP _0x132
;    1433 	}
;    1434 else ind_out[4]|=(1<<LED_WRK);
_0xC3:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x40
	POP  R26
	POP  R27
_0x132:
	ST   X,R30
;    1435 
;    1436 
;    1437 if(step_main==sOFF)
	LDS  R30,_step_main
	CPI  R30,0
	BRNE _0xC5
;    1438 	{
;    1439  	if(bERR)
	SBRS R3,1
	RJMP _0xC6
;    1440 		{
;    1441 		ind_out[4]&=~(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFE
	POP  R26
	POP  R27
	RJMP _0x133
;    1442 		}
;    1443 	else
_0xC6:
;    1444 		{
;    1445 		ind_out[4]|=(1<<LED_ERROR);
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
_0x133:
	ST   X,R30
;    1446 		}
;    1447      }
;    1448 else ind_out[4]|=(1<<LED_ERROR);
	RJMP _0xC8
_0xC5:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
	ST   X,R30
_0xC8:
;    1449 
;    1450 
;    1451 //if(bERR)ind_out[4]&=~(1<<LED_ERROR);
;    1452 if(avtom_mode==amON)ind_out[4]&=~(1<<LED_AVTOM);
	LDS  R26,_avtom_mode
	CPI  R26,LOW(0x55)
	BRNE _0xC9
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0x7F
	POP  R26
	POP  R27
	RJMP _0x134
;    1453 else ind_out[4]|=(1<<LED_AVTOM);
_0xC9:
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x80
	POP  R26
	POP  R27
_0x134:
	ST   X,R30
;    1454 
;    1455 if(ind==iSet_delay)
	LDS  R26,_ind
	CPI  R26,LOW(0x3)
	BRNE _0xCB
;    1456 	{
;    1457 	if(bFL5)ind_out[4]&=~(1<<LED_PROG4);
	SBRS R3,0
	RJMP _0xCC
	__POINTW1MN _ind_out,4
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,0xFD
	POP  R26
	POP  R27
	ST   X,R30
;    1458      }
_0xCC:
;    1459 }
_0xCB:
	RET
;    1460 
;    1461 //-----------------------------------------------
;    1462 // Подпрограмма драйва до 7 кнопок одного порта, 
;    1463 // различает короткое и длинное нажатие,
;    1464 // срабатывает на отпускание кнопки, возможность
;    1465 // ускорения перебора при длинном нажатии...
;    1466 #define but_port PORTC
;    1467 #define but_dir  DDRC
;    1468 #define but_pin  PINC
;    1469 #define but_mask 0b01101010
;    1470 #define no_but   0b11111111
;    1471 #define but_on   5
;    1472 #define but_onL  20
;    1473 
;    1474 
;    1475 
;    1476 
;    1477 void but_drv(void)
;    1478 { 
_but_drv:
;    1479 DDRD&=0b00000111;
	IN   R30,0x11
	ANDI R30,LOW(0x7)
	CALL SUBOPT_0x8
;    1480 PORTD|=0b11111000;
;    1481 
;    1482 but_port|=(but_mask^0xff);
	CALL SUBOPT_0x9
;    1483 but_dir&=but_mask;
;    1484 #asm
;    1485 nop
nop
;    1486 nop
nop
;    1487 nop
nop
;    1488 nop
nop
;    1489 nop
nop
;    1490 nop
nop
;    1491 nop
nop
;    1492 #endasm

;    1493 
;    1494 but_n=but_pin|but_mask; 
	IN   R30,0x13
	ORI  R30,LOW(0x6A)
	STS  _but_n_G1,R30
;    1495 
;    1496 if((but_n==no_but)||(but_n!=but_s))
	LDS  R26,_but_n_G1
	CPI  R26,LOW(0xFF)
	BREQ _0xCE
	RCALL SUBOPT_0xA
	BREQ _0xCD
_0xCE:
;    1497  	{
;    1498  	speed=0;
	CLT
	BLD  R2,6
;    1499    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRSH _0xD1
	LDS  R26,_but1_cnt_G1
	CPI  R26,LOW(0x0)
	BREQ _0xD3
_0xD1:
	SBRS R2,4
	RJMP _0xD4
_0xD3:
	RJMP _0xD0
_0xD4:
;    1500   		{
;    1501    	     n_but=1;
	SET
	BLD  R2,5
;    1502           but=but_s;
	LDS  R13,_but_s_G1
;    1503           }
;    1504    	if (but1_cnt>=but_onL_temp)
_0xD0:
	RCALL SUBOPT_0xB
	BRLO _0xD5
;    1505   		{
;    1506    	     n_but=1;
	SET
	BLD  R2,5
;    1507           but=but_s&0b11111101;
	RCALL SUBOPT_0xC
;    1508           }
;    1509     	l_but=0;
_0xD5:
	CLT
	BLD  R2,4
;    1510    	but_onL_temp=but_onL;
	LDI  R30,LOW(20)
	STS  _but_onL_temp_G1,R30
;    1511     	but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    1512   	but1_cnt=0;          
	STS  _but1_cnt_G1,R30
;    1513      goto but_drv_out;
	RJMP _0xD6
;    1514   	}  
;    1515   	
;    1516 if(but_n==but_s)
_0xCD:
	RCALL SUBOPT_0xA
	BRNE _0xD7
;    1517  	{
;    1518   	but0_cnt++;
	LDS  R30,_but0_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but0_cnt_G1,R30
;    1519   	if(but0_cnt>=but_on)
	LDS  R26,_but0_cnt_G1
	CPI  R26,LOW(0x5)
	BRLO _0xD8
;    1520   		{
;    1521    		but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G1,R30
;    1522    		but1_cnt++;
	LDS  R30,_but1_cnt_G1
	SUBI R30,-LOW(1)
	STS  _but1_cnt_G1,R30
;    1523    		if(but1_cnt>=but_onL_temp)
	RCALL SUBOPT_0xB
	BRLO _0xD9
;    1524    			{              
;    1525     			but=but_s&0b11111101;
	RCALL SUBOPT_0xC
;    1526     			but1_cnt=0;
	LDI  R30,LOW(0)
	STS  _but1_cnt_G1,R30
;    1527     			n_but=1;
	SET
	BLD  R2,5
;    1528     			l_but=1;
	SET
	BLD  R2,4
;    1529 			if(speed)
	SBRS R2,6
	RJMP _0xDA
;    1530 				{
;    1531     				but_onL_temp=but_onL_temp>>1;
	LDS  R30,_but_onL_temp_G1
	LSR  R30
	STS  _but_onL_temp_G1,R30
;    1532         			if(but_onL_temp<=2) but_onL_temp=2;
	LDS  R26,_but_onL_temp_G1
	LDI  R30,LOW(2)
	CP   R30,R26
	BRLO _0xDB
	STS  _but_onL_temp_G1,R30
;    1533 				}    
_0xDB:
;    1534    			}
_0xDA:
;    1535   		} 
_0xD9:
;    1536  	}
_0xD8:
;    1537 but_drv_out:
_0xD7:
_0xD6:
;    1538 but_s=but_n;
	LDS  R30,_but_n_G1
	STS  _but_s_G1,R30
;    1539 but_port|=(but_mask^0xff);
	RCALL SUBOPT_0x9
;    1540 but_dir&=but_mask;
;    1541 }    
	RET
;    1542 
;    1543 #define butA	239
;    1544 #define butA_	237
;    1545 #define butP	251
;    1546 #define butP_	249
;    1547 #define butR	127
;    1548 #define butR_	125
;    1549 #define butL	254
;    1550 #define butL_	252
;    1551 #define butLR	126
;    1552 #define butLR_	124
;    1553 //-----------------------------------------------
;    1554 void but_an(void)
;    1555 {
_but_an:
;    1556 
;    1557 if(!(in_word&0x10)) //старт
	LDS  R30,_in_word
	ANDI R30,LOW(0x10)
	BRNE _0xDC
;    1558 	{
;    1559      if(ind==iSet_delay)	
	LDS  R26,_ind
	CPI  R26,LOW(0x3)
	BRNE _0xDD
;    1560      	{
;    1561      	if(motor_state!=msON)
	LDS  R26,_motor_state
	CPI  R26,LOW(0x55)
	BREQ _0xDE
;    1562      		{
;    1563      		motor_state=msON;
	LDI  R30,LOW(85)
	STS  _motor_state,R30
;    1564      		//start_cnt=20;
;    1565      		bDel=0;
	CLT
	BLD  R3,7
;    1566      		}
;    1567      	}
_0xDE:
;    1568      else if(ind==iMn)
	RJMP _0xDF
_0xDD:
	LDS  R30,_ind
	CPI  R30,0
	BRNE _0xE0
;    1569      	{
;    1570      	if((step_main==sOFF)&&(!bERR))step_main=s1;
	LDS  R26,_step_main
	CPI  R26,LOW(0x0)
	BRNE _0xE2
	SBRS R3,1
	RJMP _0xE3
_0xE2:
	RJMP _0xE1
_0xE3:
	LDI  R30,LOW(1)
	STS  _step_main,R30
;    1571      	}	
_0xE1:
;    1572 	}
_0xE0:
_0xDF:
;    1573 if(!(in_word&0x80)) //стоп
_0xDC:
	LDS  R30,_in_word
	ANDI R30,LOW(0x80)
	BRNE _0xE4
;    1574 	{
;    1575      if(ind==iSet_delay)	
	LDS  R26,_ind
	CPI  R26,LOW(0x3)
	BRNE _0xE5
;    1576      	{
;    1577      	if(motor_state==msON)
	LDS  R26,_motor_state
	CPI  R26,LOW(0x55)
	BRNE _0xE6
;    1578      		{
;    1579      		motor_state=msOFF;
	LDI  R30,LOW(170)
	STS  _motor_state,R30
;    1580      		stop_cnt=100;
	LDI  R30,LOW(100)
	STS  _stop_cnt,R30
;    1581      		}
;    1582      	}
_0xE6:
;    1583       else if(ind==iMn)
	RJMP _0xE7
_0xE5:
	LDS  R30,_ind
	CPI  R30,0
	BRNE _0xE8
;    1584      	{
;    1585      	if(step_main!=sOFF)
	LDS  R30,_step_main
	CPI  R30,0
	BREQ _0xE9
;    1586      		{
;    1587      		step_main=sOFF;
	LDI  R30,LOW(0)
	STS  _step_main,R30
;    1588      		}
;    1589      	if(motor_state!=msOFF)
_0xE9:
	LDS  R26,_motor_state
	CPI  R26,LOW(0xAA)
	BREQ _0xEA
;    1590      		{
;    1591      		motor_state=msOFF;
	LDI  R30,LOW(170)
	STS  _motor_state,R30
;    1592      		stop_cnt=200;
	LDI  R30,LOW(200)
	STS  _stop_cnt,R30
;    1593      		}
;    1594      	}				
_0xEA:
;    1595 
;    1596 	}
_0xE8:
_0xE7:
;    1597 
;    1598 if (!n_but) goto but_an_end;
_0xE4:
	SBRS R2,5
	RJMP _0xEC
;    1599 
;    1600 if(but==butA_)
	LDI  R30,LOW(237)
	CP   R30,R13
	BRNE _0xED
;    1601 	{
;    1602 	if(ee_avtom_mode==eamON)ee_avtom_mode=eamOFF;
	LDI  R26,LOW(_ee_avtom_mode)
	LDI  R27,HIGH(_ee_avtom_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0xEE
	LDI  R30,LOW(170)
	RJMP _0x135
;    1603 	else ee_avtom_mode=eamON;
_0xEE:
	LDI  R30,LOW(85)
_0x135:
	LDI  R26,LOW(_ee_avtom_mode)
	LDI  R27,HIGH(_ee_avtom_mode)
	CALL __EEPROMWRB
;    1604 	}
;    1605 	
;    1606 if(ind==iMn)
_0xED:
	LDS  R30,_ind
	CPI  R30,0
	BRNE _0xF0
;    1607 	{
;    1608 	if(but==butP_)
	LDI  R30,LOW(249)
	CP   R30,R13
	BRNE _0xF1
;    1609 		{
;    1610 		ind=iSet_sel;
	LDI  R30,LOW(2)
	STS  _ind,R30
;    1611 		sub_ind=0;
	LDI  R30,LOW(0)
	STS  _sub_ind,R30
;    1612 		}
;    1613 	} 
_0xF1:
;    1614 	
;    1615 else if(ind==iSet_sel)
	RJMP _0xF2
_0xF0:
	LDS  R26,_ind
	CPI  R26,LOW(0x2)
	BREQ PC+3
	JMP _0xF3
;    1616 	{
;    1617 	if(but==butP_)ind=iMn;
	LDI  R30,LOW(249)
	CP   R30,R13
	BRNE _0xF4
	LDI  R30,LOW(0)
	STS  _ind,R30
;    1618 	if(but==butP)
_0xF4:
	LDI  R30,LOW(251)
	CP   R30,R13
	BRNE _0xF5
;    1619 		{
;    1620 		if((sub_ind>=0)&&(sub_ind<=5))
	LDS  R26,_sub_ind
	CPI  R26,0
	BRLO _0xF7
	LDI  R30,LOW(5)
	CP   R30,R26
	BRSH _0xF8
_0xF7:
	RJMP _0xF6
_0xF8:
;    1621 			{
;    1622 			ind=iCh_on;
	LDI  R30,LOW(4)
	STS  _ind,R30
;    1623 			}
;    1624 		else if(sub_ind==6)
	RJMP _0xF9
_0xF6:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x6)
	BRNE _0xFA
;    1625 			{
;    1626 			ind=iSet_delay;
	LDI  R30,LOW(3)
	STS  _ind,R30
;    1627 			}
;    1628 		else if(sub_ind==7)
	RJMP _0xFB
_0xFA:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x7)
	BRNE _0xFC
;    1629 			{
;    1630 			ind=iMn;
	LDI  R30,LOW(0)
	STS  _ind,R30
;    1631 			}
;    1632 		}
_0xFC:
_0xFB:
_0xF9:
;    1633 	
;    1634 	if(but==butR)
_0xF5:
	LDI  R30,LOW(127)
	CP   R30,R13
	BRNE _0xFD
;    1635 		{
;    1636 		sub_ind++;
	LDS  R30,_sub_ind
	SUBI R30,-LOW(1)
	STS  _sub_ind,R30
;    1637 		if(sub_ind>=7)sub_ind=7;
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x7)
	BRLO _0xFE
	LDI  R30,LOW(7)
	STS  _sub_ind,R30
;    1638 		}
_0xFE:
;    1639 
;    1640 	if(but==butL)
_0xFD:
	LDI  R30,LOW(254)
	CP   R30,R13
	BRNE _0xFF
;    1641 		{
;    1642 		if(sub_ind)sub_ind--;
	LDS  R30,_sub_ind
	CPI  R30,0
	BREQ _0x100
	SUBI R30,LOW(1)
	STS  _sub_ind,R30
;    1643 		if(sub_ind<=0)sub_ind=0;
_0x100:
	LDS  R26,_sub_ind
	CPI  R26,0
	BRNE _0x101
	LDI  R30,LOW(0)
	STS  _sub_ind,R30
;    1644 		}	
_0x101:
;    1645 	} 
_0xFF:
;    1646 else if(ind==iSet_delay)
	RJMP _0x102
_0xF3:
	LDS  R26,_ind
	CPI  R26,LOW(0x3)
	BREQ PC+3
	JMP _0x103
;    1647 	{
;    1648 	if((but==butR)||(but==butR_)) 
	LDI  R30,LOW(127)
	CP   R30,R13
	BREQ _0x105
	LDI  R30,LOW(125)
	CP   R30,R13
	BRNE _0x104
_0x105:
;    1649 		{
;    1650 		speed=1;
	SET
	BLD  R2,6
;    1651 		ee_timer1_delay++;
	LDI  R26,LOW(_ee_timer1_delay)
	LDI  R27,HIGH(_ee_timer1_delay)
	CALL __EEPROMRDW
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
;    1652 		if((ee_timer1_delay<=10)||(ee_timer1_delay>=500))ee_timer1_delay=500;
	RCALL SUBOPT_0xD
	BRSH _0x108
	LDI  R26,LOW(_ee_timer1_delay)
	LDI  R27,HIGH(_ee_timer1_delay)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x1F4)
	LDI  R26,HIGH(0x1F4)
	CPC  R31,R26
	BRLO _0x107
_0x108:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	LDI  R26,LOW(_ee_timer1_delay)
	LDI  R27,HIGH(_ee_timer1_delay)
	CALL __EEPROMWRW
;    1653 		} 
_0x107:
;    1654 	else if((but==butL)||(but==butL_)) 
	RJMP _0x10A
_0x104:
	LDI  R30,LOW(254)
	CP   R30,R13
	BREQ _0x10C
	LDI  R30,LOW(252)
	CP   R30,R13
	BRNE _0x10B
_0x10C:
;    1655 		{
;    1656 		speed=1;
	SET
	BLD  R2,6
;    1657 		ee_timer1_delay--;
	LDI  R26,LOW(_ee_timer1_delay)
	LDI  R27,HIGH(_ee_timer1_delay)
	CALL __EEPROMRDW
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
;    1658 		if((ee_timer1_delay<=10)||(ee_timer1_delay>=500))ee_timer1_delay=0;
	RCALL SUBOPT_0xD
	BRSH _0x10F
	LDI  R26,LOW(_ee_timer1_delay)
	LDI  R27,HIGH(_ee_timer1_delay)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x1F4)
	LDI  R26,HIGH(0x1F4)
	CPC  R31,R26
	BRLO _0x10E
_0x10F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	LDI  R26,LOW(_ee_timer1_delay)
	LDI  R27,HIGH(_ee_timer1_delay)
	CALL __EEPROMWRW
;    1659 		}
_0x10E:
;    1660 	else if(but==butP)
	RJMP _0x111
_0x10B:
	LDI  R30,LOW(251)
	CP   R30,R13
	BRNE _0x112
;    1661 		{
;    1662 		ind=iSet_sel;
	LDI  R30,LOW(2)
	STS  _ind,R30
;    1663 		sub_ind=6;
	LDI  R30,LOW(6)
	STS  _sub_ind,R30
;    1664 		}		
;    1665 	}
_0x112:
_0x111:
_0x10A:
;    1666 else if(ind==iCh_on)
	RJMP _0x113
_0x103:
	LDS  R26,_ind
	CPI  R26,LOW(0x4)
	BRNE _0x114
;    1667 	{
;    1668 	if((but==butR)||(but==butR_)||(but==butL)||(but==butL_))
	LDI  R30,LOW(127)
	CP   R30,R13
	BREQ _0x116
	LDI  R30,LOW(125)
	CP   R30,R13
	BREQ _0x116
	LDI  R30,LOW(254)
	CP   R30,R13
	BREQ _0x116
	LDI  R30,LOW(252)
	CP   R30,R13
	BRNE _0x115
_0x116:
;    1669 		{
;    1670 		if(ch_on[sub_ind]==coON)ch_on[sub_ind]=coOFF;
	RCALL SUBOPT_0x7
	BRNE _0x118
	RCALL SUBOPT_0xE
	LDI  R30,LOW(85)
	RJMP _0x136
;    1671 		else ch_on[sub_ind]=coON;
_0x118:
	RCALL SUBOPT_0xE
	LDI  R30,LOW(170)
_0x136:
	CALL __EEPROMWRB
;    1672 		}
;    1673 	else if(but==butP)
	RJMP _0x11A
_0x115:
	LDI  R30,LOW(251)
	CP   R30,R13
	BRNE _0x11B
;    1674 		{
;    1675 		ind=iSet_sel;
	LDI  R30,LOW(2)
	STS  _ind,R30
;    1676 		}
;    1677 	}	
_0x11B:
_0x11A:
;    1678 
;    1679 but_an_end:
_0x114:
_0x113:
_0x102:
_0xF2:
_0xEC:
;    1680 n_but=0;
	CLT
	BLD  R2,5
;    1681 }
	RET
;    1682 
;    1683 //-----------------------------------------------
;    1684 void ind_drv(void)
;    1685 {
_ind_drv:
;    1686 if(++ind_cnt>=6)ind_cnt=0;
	INC  R12
	LDI  R30,LOW(6)
	CP   R12,R30
	BRLO _0x11C
	CLR  R12
;    1687 
;    1688 if(ind_cnt<5)
_0x11C:
	LDI  R30,LOW(5)
	CP   R12,R30
	BRSH _0x11D
;    1689 	{
;    1690 	DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
;    1691 	PORTC=0xFF;
	OUT  0x15,R30
;    1692 	DDRD|=0b11111000;
	IN   R30,0x11
	ORI  R30,LOW(0xF8)
	RCALL SUBOPT_0x8
;    1693 	PORTD|=0b11111000;
;    1694 	PORTD&=IND_STROB[ind_cnt];
	IN   R30,0x12
	PUSH R30
	LDI  R26,LOW(_IND_STROB*2)
	LDI  R27,HIGH(_IND_STROB*2)
	MOV  R30,R12
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	POP  R26
	AND  R30,R26
	OUT  0x12,R30
;    1695 	PORTC=ind_out[ind_cnt];
	MOV  R30,R12
	LDI  R31,0
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	LD   R30,Z
	OUT  0x15,R30
;    1696 	}
;    1697 else but_drv();
	RJMP _0x11E
_0x11D:
	CALL _but_drv
_0x11E:
;    1698 }
	RET
;    1699 
;    1700 //***********************************************
;    1701 //***********************************************
;    1702 //***********************************************
;    1703 //***********************************************
;    1704 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;    1705 {
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
;    1706 TCCR0=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
;    1707 TCNT0=-96;
	LDI  R30,LOW(160)
	RCALL SUBOPT_0xF
;    1708 OCR0=0x00;
;    1709 
;    1710 if((!PINA.3)&&(opto_angle_old)&&(motor_state==msON)&&(!bDel))
	SBIC 0x19,3
	RJMP _0x120
	SBRS R3,6
	RJMP _0x120
	LDS  R26,_motor_state
	CPI  R26,LOW(0x55)
	BRNE _0x120
	SBRS R3,7
	RJMP _0x121
_0x120:
	RJMP _0x11F
_0x121:
;    1711 	{
;    1712 	
;    1713  	TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;    1714 	TCCR1B=0x04;
	LDI  R30,LOW(4)
	OUT  0x2E,R30
;    1715 	TCNT1=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
;    1716 	OCR1A=timer1_delay;
	LDS  R30,_timer1_delay
	LDS  R31,_timer1_delay+1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
;    1717 	bDel=1;
	SET
	BLD  R3,7
;    1718 	TIMSK|=0x10;  
	IN   R30,0x39
	ORI  R30,0x10
	OUT  0x39,R30
;    1719 	
;    1720 /*	DDRB.6=0;
;    1721 PORTB.6=0;
;    1722 stop_cnt=20;
;    1723 motor_state=msOFF;  */
;    1724 	}
;    1725 	
;    1726 opto_angle_old=PINA.3;
_0x11F:
	CLT
	SBIC 0x19,3
	SET
	BLD  R3,6
;    1727 DDRA.3=0;
	CBI  0x1A,3
;    1728 PORTA.3=1;
	SBI  0x1B,3
;    1729 
;    1730 if(++t0_cnt0_>=16)
	INC  R7
	LDI  R30,LOW(16)
	CP   R7,R30
	BRLO _0x122
;    1731 	{
;    1732 	t0_cnt0_=0;
	CLR  R7
;    1733 	
;    1734 	b600Hz=1;
	SET
	BLD  R2,0
;    1735 	ind_drv();
	RCALL _ind_drv
;    1736 	if(++t0_cnt0>=6)
	INC  R8
	LDI  R30,LOW(6)
	CP   R8,R30
	BRLO _0x123
;    1737 		{
;    1738 		t0_cnt0=0;
	CLR  R8
;    1739     		b100Hz=1;
	SET
	BLD  R2,1
;    1740     		}
;    1741 
;    1742 	if(++t0_cnt1>=60)
_0x123:
	INC  R9
	LDI  R30,LOW(60)
	CP   R9,R30
	BRLO _0x124
;    1743 		{
;    1744 		t0_cnt1=0;
	CLR  R9
;    1745 		b10Hz=1;
	SET
	BLD  R2,2
;    1746 	
;    1747 		if(++t0_cnt2>=2)
	INC  R10
	LDI  R30,LOW(2)
	CP   R10,R30
	BRLO _0x125
;    1748 			{
;    1749 			t0_cnt2=0;
	CLR  R10
;    1750 			bFL5=!bFL5;
	LDI  R30,LOW(1)
	EOR  R3,R30
;    1751 			}
;    1752 		
;    1753 		if(++t0_cnt3>=5)
_0x125:
	INC  R11
	LDI  R30,LOW(5)
	CP   R11,R30
	BRLO _0x126
;    1754 			{
;    1755 			t0_cnt3=0;
	CLR  R11
;    1756 			bFL2=!bFL2;
	LDI  R30,LOW(128)
	EOR  R2,R30
;    1757 			}
;    1758 		}		
_0x126:
;    1759 	}
_0x124:
;    1760 }
_0x122:
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
;    1761 
;    1762 //***********************************************
;    1763 // Timer 1 output compare A interrupt service routine
;    1764 interrupt [TIM1_COMPA] void timer1_compa_isr(void)
;    1765 {
_timer1_compa_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;    1766 TCCR1A=0x00;
	RCALL SUBOPT_0x10
;    1767 TCCR1B=0x00;
;    1768 TIMSK&=0xef;
	IN   R30,0x39
	ANDI R30,0xEF
	OUT  0x39,R30
;    1769 
;    1770 DDRB.6=0;
	CBI  0x17,6
;    1771 PORTB.6=0; 
	CBI  0x18,6
;    1772 
;    1773 DDRB.7=0;
	CBI  0x17,7
;    1774 PORTB.7=1;
	SBI  0x18,7
;    1775 
;    1776 stop_cnt=20;
	LDI  R30,LOW(20)
	STS  _stop_cnt,R30
;    1777 motor_state=msOFF;
	LDI  R30,LOW(170)
	STS  _motor_state,R30
;    1778 bDel=0; 
	CLT
	BLD  R3,7
;    1779 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;    1780 
;    1781 
;    1782 //===============================================
;    1783 //===============================================
;    1784 //===============================================
;    1785 //===============================================
;    1786 
;    1787 void main(void)
;    1788 {
_main:
;    1789 
;    1790 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
;    1791 DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
;    1792 
;    1793 PORTB=0x00;
	OUT  0x18,R30
;    1794 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
;    1795 
;    1796 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;    1797 DDRC=0x00;
	OUT  0x14,R30
;    1798 
;    1799 
;    1800 PORTD=0x00;
	OUT  0x12,R30
;    1801 DDRD=0x00;
	OUT  0x11,R30
;    1802 
;    1803 
;    1804 TCCR0=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
;    1805 TCNT0=-99;
	LDI  R30,LOW(157)
	RCALL SUBOPT_0xF
;    1806 OCR0=0x00;
;    1807 
;    1808 TCCR1A=0x00;
	RCALL SUBOPT_0x10
;    1809 TCCR1B=0x00;
;    1810 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
;    1811 TCNT1L=0x00;
	OUT  0x2C,R30
;    1812 ICR1H=0x00;
	OUT  0x27,R30
;    1813 ICR1L=0x00;
	OUT  0x26,R30
;    1814 OCR1AH=0x00;
	OUT  0x2B,R30
;    1815 OCR1AL=0x00;
	OUT  0x2A,R30
;    1816 OCR1BH=0x00;
	OUT  0x29,R30
;    1817 OCR1BL=0x00;
	OUT  0x28,R30
;    1818 
;    1819 
;    1820 ASSR=0x00;
	OUT  0x22,R30
;    1821 TCCR2=0x00;
	OUT  0x25,R30
;    1822 TCNT2=0x00;
	OUT  0x24,R30
;    1823 OCR2=0x00;
	OUT  0x23,R30
;    1824 
;    1825 // USART initialization
;    1826 // Communication Parameters: 8 Data, 1 Stop, No Parity
;    1827 // USART Receiver: On
;    1828 // USART Transmitter: On
;    1829 // USART Mode: Asynchronous
;    1830 // USART Baud rate: 19200
;    1831 UCSRA=0x00;
	OUT  0xB,R30
;    1832 UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
;    1833 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
;    1834 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;    1835 UBRRL=0x19;
	LDI  R30,LOW(25)
	OUT  0x9,R30
;    1836 
;    1837 MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
;    1838 MCUCSR=0x00;
	OUT  0x34,R30
;    1839 
;    1840 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;    1841 
;    1842 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;    1843 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;    1844 
;    1845 #asm("sei")
	sei
;    1846 ind=iMn;
	STS  _ind,R30
;    1847 ind_hndl();
	CALL _ind_hndl
;    1848 led_hndl();
	CALL _led_hndl
;    1849 
;    1850 //ee_avtom_mode=eamOFF; 
;    1851 //ind=iSet_delay;
;    1852 while (1)
_0x127:
;    1853       {
;    1854       if(b600Hz)
	SBRS R2,0
	RJMP _0x12A
;    1855 		{
;    1856 		b600Hz=0; 
	CLT
	BLD  R2,0
;    1857           
;    1858 		}         
;    1859       if(b100Hz)
_0x12A:
	SBRS R2,1
	RJMP _0x12B
;    1860 		{        
;    1861 		b100Hz=0; 
	CLT
	BLD  R2,1
;    1862 		but_an();
	RCALL _but_an
;    1863 	    	in_drv();
	CALL _in_drv
;    1864           //mdvr_drv();
;    1865           step_main_contr();
	CALL _step_main_contr
;    1866           out_drv();
	CALL _out_drv
;    1867           err_drv();
	CALL _err_drv
;    1868           net_drv();
	CALL _net_drv
;    1869           //out_usart(4,0x01,0x85,0x86,0x87,0,0,0,0,0); 
;    1870           od_drv();
	CALL _od_drv
;    1871           avtom_mode_drv();
	CALL _avtom_mode_drv
;    1872 		}   
;    1873 	if(b10Hz)
_0x12B:
	SBRS R2,2
	RJMP _0x12C
;    1874 		{
;    1875 		b10Hz=0;
	CLT
	BLD  R2,2
;    1876 		
;    1877     	     ind_hndl();
	CALL _ind_hndl
;    1878           led_hndl();
	CALL _led_hndl
;    1879           mathemat();
	CALL _mathemat
;    1880           }
;    1881 
;    1882       };
_0x12C:
	RJMP _0x127
;    1883 }
_0x12D:
	RJMP _0x12D
;    1884 
;    1885 
;    1886 
;    1887 

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	STS  _step_main,R30
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	STS  _cnt_del_main,R30
	STS  _cnt_del_main+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	LDI  R30,LOW(51)
	STS  _cmnd_byte,R30
	LDS  R30,_cnt_del_main
	LDS  R31,_cnt_del_main+1
	SBIW R30,1
	STS  _cnt_del_main,R30
	STS  _cnt_del_main+1,R31
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x2:
	LDI  R26,LOW(_ch_on)
	LDI  R27,HIGH(_ch_on)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x4:
	MOV  R30,R16
	SUBI R30,LOW(1)
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x6:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _int2ind

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7:
	LDS  R26,_sub_ind
	LDI  R27,0
	SUBI R26,LOW(-_ch_on)
	SBCI R27,HIGH(-_ch_on)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8:
	OUT  0x11,R30
	IN   R30,0x12
	ORI  R30,LOW(0xF8)
	OUT  0x12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x9:
	IN   R30,0x15
	ORI  R30,LOW(0x95)
	OUT  0x15,R30
	IN   R30,0x14
	ANDI R30,LOW(0x6A)
	OUT  0x14,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA:
	LDS  R30,_but_s_G1
	LDS  R26,_but_n_G1
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xB:
	LDS  R30,_but_onL_temp_G1
	LDS  R26,_but1_cnt_G1
	CP   R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xC:
	LDS  R30,_but_s_G1
	ANDI R30,0xFD
	MOV  R13,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD:
	LDI  R26,LOW(_ee_timer1_delay)
	LDI  R27,HIGH(_ee_timer1_delay)
	CALL __EEPROMRDW
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE:
	LDS  R26,_sub_ind
	LDI  R27,0
	SUBI R26,LOW(-_ch_on)
	SBCI R27,HIGH(-_ch_on)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF:
	OUT  0x32,R30
	LDI  R30,LOW(0)
	OUT  0x3C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10:
	LDI  R30,LOW(0)
	OUT  0x2F,R30
	OUT  0x2E,R30
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

