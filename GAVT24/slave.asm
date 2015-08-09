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

	.INCLUDE "slave.vec"
	.INCLUDE "slave.inc"

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
;       1 #define NUM_OF_SLAVE	2
;       2 
;       3 #define HOST_MESS_LEN	4
;       4 
;       5 
;       6 
;       7 #define MD1	3
;       8 #define MD2	7
;       9 #define VR1	2
;      10 #define VR2	6
;      11 
;      12 #define PP1_1	6
;      13 #define PP1_2	7
;      14 #define PP1_3	5
;      15 #define PP1_4	4
;      16 #define PP2_1	3
;      17 #define PP2_2	2
;      18 #define PP2_3	1
;      19 #define PP2_4	0
;      20 
;      21 
;      22 bit b600Hz;
;      23 bit b100Hz;
;      24 bit b10Hz;
;      25 char t0_cnt0_,t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3;
;      26 char ind_cnt;
;      27 
;      28 char ind_out[5]={0x255,0x255,0x255,0x255,0x255};
_ind_out:
	.BYTE 0x5
;      29 char dig[4];
_dig:
	.BYTE 0x4
;      30 bit bZ;    
;      31 char but;
;      32 static char but_n;
_but_n_G1:
	.BYTE 0x1
;      33 static char but_s;
_but_s_G1:
	.BYTE 0x1
;      34 static char but0_cnt;
_but0_cnt_G1:
	.BYTE 0x1
;      35 static char but1_cnt;
_but1_cnt_G1:
	.BYTE 0x1
;      36 static char but_onL_temp;
_but_onL_temp_G1:
	.BYTE 0x1
;      37 bit l_but;		//идет длинное нажатие на кнопку
;      38 bit n_but;          //произошло нажатие
;      39 bit speed;		//разрешение ускорения перебора 
;      40 bit bFL2; 
;      41 bit bFL5;
;      42 eeprom enum{eamON=0x55,eamOFF=0xaa}ee_avtom_mode;

	.ESEG
_ee_avtom_mode:
	.DB  0x0
;      43 enum {p1=1,p2=2,p3=3,p4=4}prog;

	.DSEG
_prog:
	.BYTE 0x1
;      44 enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s100}step=sOFF;
_step:
	.BYTE 0x1
;      45 
;      46 char sub_ind;
_sub_ind:
	.BYTE 0x1
;      47 char in_word,in_word_old,in_word_new,in_word_cnt;
_in_word:
	.BYTE 0x1
_in_word_old:
	.BYTE 0x1
_in_word_new:
	.BYTE 0x1
_in_word_cnt:
	.BYTE 0x1
;      48 bit bERR;
;      49 signed int cnt_del=0;
_cnt_del:
	.BYTE 0x2
;      50 
;      51 char cnt_md1,cnt_md2,cnt_vr1,cnt_vr2;
_cnt_md1:
	.BYTE 0x1
_cnt_md2:
	.BYTE 0x1
_cnt_vr1:
	.BYTE 0x1
_cnt_vr2:
	.BYTE 0x1
;      52 
;      53 eeprom enum {coOFF=0x55,coON=0xaa}ch_on[6];

	.ESEG
_ch_on:
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
;      54 eeprom unsigned ee_timer1_delay;
_ee_timer1_delay:
	.DW  0x0
;      55 bit opto_angle_old;
;      56 enum {msON=0x55,msOFF=0xAA}motor_state;

	.DSEG
_motor_state:
	.BYTE 0x1
;      57 unsigned timer1_delay;
_timer1_delay:
	.BYTE 0x2
;      58 
;      59 char stop_cnt,start_cnt;
_stop_cnt:
	.BYTE 0x1
_start_cnt:
	.BYTE 0x1
;      60 char cnt_net_drv,cnt_drv;
_cnt_net_drv:
	.BYTE 0x1
_cnt_drv:
	.BYTE 0x1
;      61 char cmnd_byte,state_byte,crc_byte;
_cmnd_byte:
	.BYTE 0x1
_state_byte:
	.BYTE 0x1
_crc_byte:
	.BYTE 0x1
;      62 
;      63 enum{sOFF,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16}step1=sOFF,step2=sOFF;
_step1:
	.BYTE 0x1
_step2:
	.BYTE 0x1
;      64 enum {mON,mOFF}mode1,mode2;
_mode1:
	.BYTE 0x1
_mode2:
	.BYTE 0x1
;      65 signed char cnt_del1,cnt_del2;
_cnt_del1:
	.BYTE 0x1
_cnt_del2:
	.BYTE 0x1
;      66 
;      67 bit bVR1,bVR2;
;      68 bit bMD1,bMD2;
;      69 char out_stat,out_stat1,out_stat2; 
_out_stat:
	.BYTE 0x1
_out_stat1:
	.BYTE 0x1
_out_stat2:
	.BYTE 0x1
;      70 char cmnd_new,cmnd_old,cmnd,cmnd_cnt; 
_cmnd_new:
	.BYTE 0x1
_cmnd_old:
	.BYTE 0x1
_cmnd:
	.BYTE 0x1
_cmnd_cnt:
	.BYTE 0x1
;      71 char state_new,state_old,state,state_cnt;
_state_new:
	.BYTE 0x1
_state_old:
	.BYTE 0x1
_state:
	.BYTE 0x1
_state_cnt:
	.BYTE 0x1
;      72 
;      73 #include <mega16.h>
;      74 #include <stdio.h>
;      75 #include "usart_slave.c"
;      76 #define RXB8 1
;      77 #define TXB8 0
;      78 #define UPE 2
;      79 #define OVR 3
;      80 #define FE 4
;      81 #define UDRE 5
;      82 #define RXC 7
;      83 
;      84 #define FRAMING_ERROR (1<<FE)
;      85 #define PARITY_ERROR (1<<UPE)
;      86 #define DATA_OVERRUN (1<<OVR)
;      87 #define DATA_REGISTER_EMPTY (1<<UDRE)
;      88 #define RX_COMPLETE (1<<RXC)
;      89 
;      90 extern void uart_in_an(void);
;      91 
;      92 // USART Receiver buffer
;      93 #define RX_BUFFER_SIZE 50
;      94 bit bRXIN;
;      95 char UIB[10]={0,0,0,0,0,0,0,0,0,0};
_UIB:
	.BYTE 0xA
;      96 char flag;
_flag:
	.BYTE 0x1
;      97 char rx_buffer[RX_BUFFER_SIZE];
_rx_buffer:
	.BYTE 0x32
;      98 unsigned char rx_wr_index,rx_rd_index,rx_counter;
_rx_wr_index:
	.BYTE 0x1
_rx_rd_index:
	.BYTE 0x1
_rx_counter:
	.BYTE 0x1
;      99 // This flag is set on USART Receiver buffer overflow
;     100 bit rx_buffer_overflow;
;     101 
;     102 // USART Receiver interrupt service routine
;     103 #pragma savereg-
;     104 interrupt [USART_RXC] void uart_rx_isr(void)
;     105 {

	.CSEG
_uart_rx_isr:
;     106 char status,data;
;     107 #asm
	ST   -Y,R17
	ST   -Y,R16
;	status -> R16
;	data -> R17
;     108     push r26
    push r26
;     109     push r27
    push r27
;     110     push r30
    push r30
;     111     push r31
    push r31
;     112     in   r26,sreg
    in   r26,sreg
;     113     push r26
    push r26
;     114 #endasm

;     115 status=UCSRA;
	IN   R16,11
;     116 data=UDR;
	IN   R17,12
;     117 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R16
	ANDI R30,LOW(0x1C)
	BRNE _0x4
;     118    { 
;     119 
;     120    if((data&0b11111000)==0)rx_wr_index=0;
	MOV  R30,R17
	ANDI R30,LOW(0xF8)
	BRNE _0x5
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
;     121    rx_buffer[rx_wr_index]=data;
_0x5:
	LDS  R26,_rx_wr_index
	LDI  R27,0
	SUBI R26,LOW(-_rx_buffer)
	SBCI R27,HIGH(-_rx_buffer)
	ST   X,R17
;     122    if (++rx_wr_index >= HOST_MESS_LEN)
	LDS  R26,_rx_wr_index
	SUBI R26,-LOW(1)
	STS  _rx_wr_index,R26
	CPI  R26,LOW(0x4)
	BRLO _0x6
;     123    	{
;     124    	if((((rx_buffer[0]^rx_buffer[1])^(rx_buffer[2]^rx_buffer[3]))&0b01111111)==0)
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
;     125    		{
;     126    		uart_in_an();
	CALL _uart_in_an
;     127    		}
;     128      }
_0x7:
;     129    if (rx_wr_index >= RX_BUFFER_SIZE) rx_wr_index=0;
_0x6:
	LDS  R26,_rx_wr_index
	CPI  R26,LOW(0x32)
	BRLO _0x8
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
;     130    };
_0x8:
_0x4:
;     131 #asm
;     132     pop  r26
    pop  r26
;     133     out  sreg,r26
    out  sreg,r26
;     134     pop  r31
    pop  r31
;     135     pop  r30
    pop  r30
;     136     pop  r27
    pop  r27
;     137     pop  r26
    pop  r26
;     138 #endasm

;     139 }
	LD   R16,Y+
	LD   R17,Y+
	RETI
;     140 #pragma savereg+
;     141 
;     142 #ifndef _DEBUG_TERMINAL_IO_
;     143 // Get a character from the USART Receiver buffer
;     144 #define _ALTERNATE_GETCHAR_
;     145 #pragma used+
;     146 char getchar(void)
;     147 {
;     148 char data;
;     149 while (rx_counter==0);
;	data -> R16
;     150 data=rx_buffer[rx_rd_index];
;     151 if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
;     152 #asm("cli")
	cli
;     153 --rx_counter;
;     154 #asm("sei")
	sei
;     155 return data;
;     156 }
;     157 #pragma used-
;     158 #endif
;     159 
;     160 // USART Transmitter buffer
;     161 #define TX_BUFFER_SIZE 100
;     162 char tx_buffer[TX_BUFFER_SIZE];

	.DSEG
_tx_buffer:
	.BYTE 0x64
;     163 unsigned char tx_wr_index,tx_rd_index,tx_counter;
_tx_wr_index:
	.BYTE 0x1
_tx_rd_index:
	.BYTE 0x1
_tx_counter:
	.BYTE 0x1
;     164 
;     165 // USART Transmitter interrupt service routine
;     166 #pragma savereg-
;     167 interrupt [USART_TXC] void uart_tx_isr(void)
;     168 {

	.CSEG
_uart_tx_isr:
;     169 #asm
;     170     push r26
    push r26
;     171     push r27
    push r27
;     172     push r30
    push r30
;     173     push r31
    push r31
;     174     in   r26,sreg
    in   r26,sreg
;     175     push r26
    push r26
;     176 #endasm

;     177 if (tx_counter)
	LDS  R30,_tx_counter
	CPI  R30,0
	BREQ _0xD
;     178    {
;     179    --tx_counter;
	SUBI R30,LOW(1)
	STS  _tx_counter,R30
;     180    UDR=tx_buffer[tx_rd_index];
	LDS  R30,_tx_rd_index
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
;     181    if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDS  R26,_tx_rd_index
	SUBI R26,-LOW(1)
	STS  _tx_rd_index,R26
	CPI  R26,LOW(0x64)
	BRNE _0xE
	LDI  R30,LOW(0)
	STS  _tx_rd_index,R30
;     182    };
_0xE:
_0xD:
;     183 #asm
;     184     pop  r26
    pop  r26
;     185     out  sreg,r26
    out  sreg,r26
;     186     pop  r31
    pop  r31
;     187     pop  r30
    pop  r30
;     188     pop  r27
    pop  r27
;     189     pop  r26
    pop  r26
;     190 #endasm

;     191 }
	RETI
;     192 #pragma savereg+
;     193 
;     194 #ifndef _DEBUG_TERMINAL_IO_
;     195 // Write a character to the USART Transmitter buffer
;     196 #define _ALTERNATE_PUTCHAR_
;     197 #pragma used+
;     198 void putchar(char c)
;     199 {
_putchar:
;     200 while (tx_counter == TX_BUFFER_SIZE);
_0xF:
	LDS  R26,_tx_counter
	CPI  R26,LOW(0x64)
	BREQ _0xF
;     201 #asm("cli")
	cli
;     202 if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter
	CPI  R30,0
	BRNE _0x13
	SBIC 0xB,5
	RJMP _0x12
_0x13:
;     203    {
;     204    tx_buffer[tx_wr_index]=c;
	LDS  R26,_tx_wr_index
	LDI  R27,0
	SUBI R26,LOW(-_tx_buffer)
	SBCI R27,HIGH(-_tx_buffer)
	LD   R30,Y
	ST   X,R30
;     205    if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDS  R26,_tx_wr_index
	SUBI R26,-LOW(1)
	STS  _tx_wr_index,R26
	CPI  R26,LOW(0x64)
	BRNE _0x15
	LDI  R30,LOW(0)
	STS  _tx_wr_index,R30
;     206    ++tx_counter;
_0x15:
	LDS  R30,_tx_counter
	SUBI R30,-LOW(1)
	STS  _tx_counter,R30
;     207    }
;     208 else UDR=c;
	RJMP _0x16
_0x12:
	LD   R30,Y
	OUT  0xC,R30
_0x16:
;     209 #asm("sei")
	sei
;     210 }
	ADIW R28,1
	RET
;     211 #pragma used-
;     212 #endif
;     213 
;     214 
;     215 //-----------------------------------------------
;     216 void out_drv(void)
;     217 {
_out_drv:
;     218 DDRB=0xff;
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     219 out_stat=out_stat1|out_stat2; 
	LDS  R30,_out_stat2
	LDS  R26,_out_stat1
	OR   R30,R26
	STS  _out_stat,R30
;     220 PORTB=~out_stat; 
	COM  R30
	OUT  0x18,R30
;     221 //PORTB=~step2;
;     222 }
	RET
;     223 
;     224 
;     225 
;     226 //-----------------------------------------------
;     227 void out_usart (char num,char data0,char data1,char data2,char data3,char data4,char data5,char data6,char data7,char data8)
;     228 {
_out_usart:
;     229 char i,t=0;
;     230 
;     231 char UOB[12]; 
;     232 UOB[0]=data0;
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
;     233 UOB[1]=data1;
	LDD  R30,Y+21
	STD  Y+3,R30
;     234 UOB[2]=data2;
	LDD  R30,Y+20
	STD  Y+4,R30
;     235 UOB[3]=data3;
	LDD  R30,Y+19
	STD  Y+5,R30
;     236 UOB[4]=data4;
	LDD  R30,Y+18
	STD  Y+6,R30
;     237 UOB[5]=data5;
	LDD  R30,Y+17
	STD  Y+7,R30
;     238 UOB[6]=data6;
	LDD  R30,Y+16
	STD  Y+8,R30
;     239 UOB[7]=data7;
	LDD  R30,Y+15
	STD  Y+9,R30
;     240 UOB[8]=data8;
	LDD  R30,Y+14
	STD  Y+10,R30
;     241 
;     242 for (i=0;i<num;i++)
	LDI  R16,LOW(0)
_0x18:
	LDD  R30,Y+23
	CP   R16,R30
	BRSH _0x19
;     243 	{
;     244 	putchar(UOB[i]);
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   -Y,R30
	CALL _putchar
;     245 	}   	
	SUBI R16,-1
	RJMP _0x18
_0x19:
;     246 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,24
	RET
;     247 
;     248 //-----------------------------------------------
;     249 void byte_drv(void)
;     250 {
;     251 cmnd_byte|=0x80;
;     252 state_byte=0xff;
;     253 
;     254 if(ch_on[0]!=coON)state_byte&=~(1<<0);
;     255 if(ch_on[1]!=coON)state_byte&=~(1<<1);
;     256 if(ch_on[2]!=coON)state_byte&=~(1<<2);
;     257 if(ch_on[3]!=coON)state_byte&=~(1<<3);
;     258 if(ch_on[4]!=coON)state_byte&=~(1<<4);
;     259 if(ch_on[5]!=coON)state_byte&=~(1<<5);
;     260 
;     261 
;     262 }
;     263 
;     264 
;     265 //-----------------------------------------------
;     266 void in_drv(void)
;     267 {
_in_drv:
;     268 char i,temp;
;     269 unsigned int tempUI;
;     270 DDRA&=0x33;
	CALL __SAVELOCR4
;	i -> R16
;	temp -> R17
;	tempUI -> R18,R19
	IN   R30,0x1A
	ANDI R30,LOW(0x33)
	OUT  0x1A,R30
;     271 PORTA|=0xcc;
	IN   R30,0x1B
	ORI  R30,LOW(0xCC)
	OUT  0x1B,R30
;     272 in_word_new=PINA|0x33;
	IN   R30,0x19
	ORI  R30,LOW(0x33)
	STS  _in_word_new,R30
;     273 if(in_word_old==in_word_new)
	LDS  R26,_in_word_old
	CP   R30,R26
	BRNE _0x20
;     274 	{
;     275 	if(in_word_cnt<10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRSH _0x21
;     276 		{
;     277 		in_word_cnt++;
	LDS  R30,_in_word_cnt
	SUBI R30,-LOW(1)
	STS  _in_word_cnt,R30
;     278 		if(in_word_cnt>=10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRLO _0x22
;     279 			{
;     280 			in_word=in_word_old;
	LDS  R30,_in_word_old
	STS  _in_word,R30
;     281 			}
;     282 		}
_0x22:
;     283 	}
_0x21:
;     284 else in_word_cnt=0;
	RJMP _0x23
_0x20:
	LDI  R30,LOW(0)
	STS  _in_word_cnt,R30
_0x23:
;     285 
;     286 
;     287 in_word_old=in_word_new;
	LDS  R30,_in_word_new
	STS  _in_word_old,R30
;     288 }   
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;     289 
;     290 
;     291 
;     292 //-----------------------------------------------
;     293 void mdvr_drv(void)
;     294 {
_mdvr_drv:
;     295 if(!(in_word&(1<<MD1)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x8)
	BRNE _0x24
;     296 	{
;     297 	if(cnt_md1<10)
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRSH _0x25
;     298 		{
;     299 		cnt_md1++;
	LDS  R30,_cnt_md1
	SUBI R30,-LOW(1)
	STS  _cnt_md1,R30
;     300 		if(cnt_md1==10) bMD1=1;
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRNE _0x26
	SET
	BLD  R3,5
;     301 		}
_0x26:
;     302 
;     303 	}
_0x25:
;     304 else
	RJMP _0x27
_0x24:
;     305 	{
;     306 	if(cnt_md1)
	LDS  R30,_cnt_md1
	CPI  R30,0
	BREQ _0x28
;     307 		{
;     308 		cnt_md1--;
	SUBI R30,LOW(1)
	STS  _cnt_md1,R30
;     309 		if(cnt_md1==0) bMD1=0;
	CPI  R30,0
	BRNE _0x29
	CLT
	BLD  R3,5
;     310 		}
_0x29:
;     311 
;     312 	}
_0x28:
_0x27:
;     313 
;     314 if(!(in_word&(1<<MD2)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x80)
	BRNE _0x2A
;     315 	{
;     316 	if(cnt_md2<10)
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRSH _0x2B
;     317 		{
;     318 		cnt_md2++;
	LDS  R30,_cnt_md2
	SUBI R30,-LOW(1)
	STS  _cnt_md2,R30
;     319 		if(cnt_md2==10) bMD2=1;
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRNE _0x2C
	SET
	BLD  R3,6
;     320 		}
_0x2C:
;     321 
;     322 	}
_0x2B:
;     323 else
	RJMP _0x2D
_0x2A:
;     324 	{
;     325 	if(cnt_md2)
	LDS  R30,_cnt_md2
	CPI  R30,0
	BREQ _0x2E
;     326 		{
;     327 		cnt_md2--;
	SUBI R30,LOW(1)
	STS  _cnt_md2,R30
;     328 		if(cnt_md2==0) bMD2=0;
	CPI  R30,0
	BRNE _0x2F
	CLT
	BLD  R3,6
;     329 		}
_0x2F:
;     330 
;     331 	}
_0x2E:
_0x2D:
;     332 
;     333 if(!(in_word&(1<<VR1)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x4)
	BRNE _0x30
;     334 	{
;     335 	if(cnt_vr1<10)
	LDS  R26,_cnt_vr1
	CPI  R26,LOW(0xA)
	BRSH _0x31
;     336 		{
;     337 		cnt_vr1++;
	LDS  R30,_cnt_vr1
	SUBI R30,-LOW(1)
	STS  _cnt_vr1,R30
;     338 		if(cnt_vr1==10) bVR1=1;
	LDS  R26,_cnt_vr1
	CPI  R26,LOW(0xA)
	BRNE _0x32
	SET
	BLD  R3,3
;     339 		}
_0x32:
;     340 
;     341 	}
_0x31:
;     342 else
	RJMP _0x33
_0x30:
;     343 	{
;     344 	if(cnt_vr1)
	LDS  R30,_cnt_vr1
	CPI  R30,0
	BREQ _0x34
;     345 		{
;     346 		cnt_vr1--;
	SUBI R30,LOW(1)
	STS  _cnt_vr1,R30
;     347 		if(cnt_vr1==0) bVR1=0;
	CPI  R30,0
	BRNE _0x35
	CLT
	BLD  R3,3
;     348 		}
_0x35:
;     349 
;     350 	}
_0x34:
_0x33:
;     351 
;     352 if(!(in_word&(1<<VR2)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x40)
	BRNE _0x36
;     353 	{
;     354 	if(cnt_vr2<10)
	LDS  R26,_cnt_vr2
	CPI  R26,LOW(0xA)
	BRSH _0x37
;     355 		{
;     356 		cnt_vr2++;
	LDS  R30,_cnt_vr2
	SUBI R30,-LOW(1)
	STS  _cnt_vr2,R30
;     357 		if(cnt_vr2==10) bVR2=1;
	LDS  R26,_cnt_vr2
	CPI  R26,LOW(0xA)
	BRNE _0x38
	SET
	BLD  R3,4
;     358 		}
_0x38:
;     359 
;     360 	}
_0x37:
;     361 else
	RJMP _0x39
_0x36:
;     362 	{
;     363 	if(cnt_vr2)
	LDS  R30,_cnt_vr2
	CPI  R30,0
	BREQ _0x3A
;     364 		{
;     365 		cnt_vr2--;
	SUBI R30,LOW(1)
	STS  _cnt_vr2,R30
;     366 		if(cnt_vr2==0) bVR2=0;
	CPI  R30,0
	BRNE _0x3B
	CLT
	BLD  R3,4
;     367 		}
_0x3B:
;     368 
;     369 	}
_0x3A:
_0x39:
;     370 }
	RET
;     371 
;     372 //-----------------------------------------------
;     373 void step1_contr(void)
;     374 {
_step1_contr:
;     375 
;     376 out_stat1=0;
	LDI  R30,LOW(0)
	STS  _out_stat1,R30
;     377 if(mode1==mOFF)step1=sOFF;
	LDS  R26,_mode1
	CPI  R26,LOW(0x1)
	BRNE _0x3C
	STS  _step1,R30
;     378 
;     379 if(step1==sOFF)
_0x3C:
	LDS  R30,_step1
	CPI  R30,0
	BRNE _0x3D
;     380 	{
;     381 	
;     382 	}
;     383 else if(step1==s1)
	RJMP _0x3E
_0x3D:
	LDS  R26,_step1
	CPI  R26,LOW(0x1)
	BRNE _0x3F
;     384 	{
;     385 	cnt_del1=20;
	LDI  R30,LOW(20)
	STS  _cnt_del1,R30
;     386 	step1=s2;
	LDI  R30,LOW(2)
	STS  _step1,R30
;     387 	}
;     388 else if(step1==s2)
	RJMP _0x40
_0x3F:
	LDS  R26,_step1
	CPI  R26,LOW(0x2)
	BRNE _0x41
;     389 	{
;     390 	cnt_del1--;
	CALL SUBOPT_0x0
;     391 	if(cnt_del1==0)
	BRNE _0x42
;     392 		{
;     393 		cnt_del1=20;
	LDI  R30,LOW(20)
	STS  _cnt_del1,R30
;     394 		step1=s3;
	LDI  R30,LOW(3)
	STS  _step1,R30
;     395 		}
;     396 	}
_0x42:
;     397 else if(step1==s3)
	RJMP _0x43
_0x41:
	LDS  R26,_step1
	CPI  R26,LOW(0x3)
	BRNE _0x44
;     398 	{
;     399 	out_stat1|=(1<<PP1_1);
	LDS  R30,_out_stat1
	ORI  R30,0x40
	STS  _out_stat1,R30
;     400 	cnt_del1--;
	CALL SUBOPT_0x0
;     401 	if(cnt_del1==0)
	BRNE _0x45
;     402 		{
;     403 		step1=s4;
	LDI  R30,LOW(4)
	STS  _step1,R30
;     404 		}
;     405 	
;     406 	}
_0x45:
;     407 else if(step1==s4)
	RJMP _0x46
_0x44:
	LDS  R26,_step1
	CPI  R26,LOW(0x4)
	BRNE _0x47
;     408 	{
;     409 	out_stat1|=(1<<PP1_1)|(1<<PP1_2);
	LDS  R30,_out_stat1
	ORI  R30,LOW(0xC0)
	STS  _out_stat1,R30
;     410 	if(bVR1)
	SBRS R3,3
	RJMP _0x48
;     411 		{
;     412 		step1=s5;
	LDI  R30,LOW(5)
	STS  _step1,R30
;     413 		cnt_del1=50;
	LDI  R30,LOW(50)
	STS  _cnt_del1,R30
;     414 		}
;     415 	}
_0x48:
;     416 else if(step1==s5)
	RJMP _0x49
_0x47:
	LDS  R26,_step1
	CPI  R26,LOW(0x5)
	BRNE _0x4A
;     417 	{
;     418 	out_stat1|=(1<<PP1_1)|(1<<PP1_2)|(1<<PP1_3);
	LDS  R30,_out_stat1
	ORI  R30,LOW(0xE0)
	STS  _out_stat1,R30
;     419 	cnt_del1--;
	CALL SUBOPT_0x0
;     420 	if(cnt_del1==0)
	BRNE _0x4B
;     421 		{
;     422 		cnt_del1=80;
	LDI  R30,LOW(80)
	STS  _cnt_del1,R30
;     423 		step1=s6;
	LDI  R30,LOW(6)
	STS  _step1,R30
;     424 		}
;     425 	}
_0x4B:
;     426 else if(step1==s6)
	RJMP _0x4C
_0x4A:
	LDS  R26,_step1
	CPI  R26,LOW(0x6)
	BRNE _0x4D
;     427 	{
;     428 	out_stat1|=(1<<PP1_1)|(1<<PP1_2)|(1<<PP1_3)|(1<<PP1_4);
	LDS  R30,_out_stat1
	ORI  R30,LOW(0xF0)
	STS  _out_stat1,R30
;     429 	cnt_del1--;
	CALL SUBOPT_0x0
;     430 	if(cnt_del1==0)
	BRNE _0x4E
;     431 		{
;     432 		cnt_del1=60;
	LDI  R30,LOW(60)
	STS  _cnt_del1,R30
;     433 		step1=s7;
	LDI  R30,LOW(7)
	STS  _step1,R30
;     434 		}
;     435 	}
_0x4E:
;     436 else if(step1==s7)
	RJMP _0x4F
_0x4D:
	LDS  R26,_step1
	CPI  R26,LOW(0x7)
	BRNE _0x50
;     437 	{
;     438 	out_stat1|=(1<<PP1_1)|(1<<PP1_4);
	LDS  R30,_out_stat1
	ORI  R30,LOW(0x50)
	STS  _out_stat1,R30
;     439 	cnt_del1--;
	CALL SUBOPT_0x0
;     440 	if(cnt_del1==0)
	BRNE _0x51
;     441 		{
;     442 		cnt_del1=20;
	LDI  R30,LOW(20)
	STS  _cnt_del1,R30
;     443 		step1=s8;
	LDI  R30,LOW(8)
	STS  _step1,R30
;     444 		}
;     445 	}
_0x51:
;     446 else if(step1==s8)
	RJMP _0x52
_0x50:
	LDS  R26,_step1
	CPI  R26,LOW(0x8)
	BRNE _0x53
;     447 	{
;     448 	out_stat1|=(1<<PP1_4);
	LDS  R30,_out_stat1
	ORI  R30,0x10
	STS  _out_stat1,R30
;     449 	cnt_del1--;
	CALL SUBOPT_0x0
;     450 	if(cnt_del1==0)
	BRNE _0x54
;     451 		{
;     452 		step1=s9;
	LDI  R30,LOW(9)
	STS  _step1,R30
;     453 		}
;     454 	}
_0x54:
;     455 else if(step1==s9)
	RJMP _0x55
_0x53:
	LDS  R26,_step1
	CPI  R26,LOW(0x9)
	BRNE _0x56
;     456 	{
;     457 	if(bMD1)
	SBRS R3,5
	RJMP _0x57
;     458 		{
;     459 		step1=sOFF;
	LDI  R30,LOW(0)
	STS  _step1,R30
;     460 		}
;     461 	}
_0x57:
;     462 
;     463 
;     464 }
_0x56:
_0x55:
_0x52:
_0x4F:
_0x4C:
_0x49:
_0x46:
_0x43:
_0x40:
_0x3E:
	RET
;     465 
;     466 //-----------------------------------------------
;     467 void step2_contr(void)
;     468 {
_step2_contr:
;     469 out_stat2=0;
	LDI  R30,LOW(0)
	STS  _out_stat2,R30
;     470 if(mode2==mOFF)step2=sOFF;
	LDS  R26,_mode2
	CPI  R26,LOW(0x1)
	BRNE _0x58
	STS  _step2,R30
;     471 
;     472 if(step2==sOFF)
_0x58:
	LDS  R30,_step2
	CPI  R30,0
	BRNE _0x59
;     473 	{
;     474 	
;     475 	}
;     476 else if(step2==s1)
	RJMP _0x5A
_0x59:
	LDS  R26,_step2
	CPI  R26,LOW(0x1)
	BRNE _0x5B
;     477 	{
;     478 	cnt_del2=20;
	LDI  R30,LOW(20)
	STS  _cnt_del2,R30
;     479 	step2=s2;
	LDI  R30,LOW(2)
	STS  _step2,R30
;     480 	}
;     481 else if(step2==s2)
	RJMP _0x5C
_0x5B:
	LDS  R26,_step2
	CPI  R26,LOW(0x2)
	BRNE _0x5D
;     482 	{
;     483 	cnt_del2--;
	CALL SUBOPT_0x1
;     484 	if(cnt_del2==0)
	BRNE _0x5E
;     485 		{
;     486 		cnt_del2=20;
	LDI  R30,LOW(20)
	STS  _cnt_del2,R30
;     487 		step2=s3;
	LDI  R30,LOW(3)
	STS  _step2,R30
;     488 		}
;     489 	}
_0x5E:
;     490 else if(step2==s3)
	RJMP _0x5F
_0x5D:
	LDS  R26,_step2
	CPI  R26,LOW(0x3)
	BRNE _0x60
;     491 	{
;     492 	out_stat2|=(1<<PP2_1);
	LDS  R30,_out_stat2
	ORI  R30,8
	STS  _out_stat2,R30
;     493 	cnt_del2--;
	CALL SUBOPT_0x1
;     494 	if(cnt_del2==0)
	BRNE _0x61
;     495 		{
;     496 		step2=s4;
	LDI  R30,LOW(4)
	STS  _step2,R30
;     497 		}
;     498 	
;     499 	}
_0x61:
;     500 else if(step2==s4)
	RJMP _0x62
_0x60:
	LDS  R26,_step2
	CPI  R26,LOW(0x4)
	BRNE _0x63
;     501 	{
;     502 	out_stat2|=(1<<PP2_1)|(1<<PP2_2);
	LDS  R30,_out_stat2
	ORI  R30,LOW(0xC)
	STS  _out_stat2,R30
;     503 	if(bVR2)
	SBRS R3,4
	RJMP _0x64
;     504 		{
;     505 		step2=s5;
	LDI  R30,LOW(5)
	STS  _step2,R30
;     506 		cnt_del2=50;
	LDI  R30,LOW(50)
	STS  _cnt_del2,R30
;     507 		}
;     508 	}
_0x64:
;     509 else if(step2==s5)
	RJMP _0x65
_0x63:
	LDS  R26,_step2
	CPI  R26,LOW(0x5)
	BRNE _0x66
;     510 	{
;     511 	out_stat2|=(1<<PP2_1)|(1<<PP2_2)|(1<<PP2_3);
	LDS  R30,_out_stat2
	ORI  R30,LOW(0xE)
	STS  _out_stat2,R30
;     512 	cnt_del2--;
	CALL SUBOPT_0x1
;     513 	if(cnt_del2==0)
	BRNE _0x67
;     514 		{
;     515 		cnt_del2=80;
	LDI  R30,LOW(80)
	STS  _cnt_del2,R30
;     516 		step2=s6;
	LDI  R30,LOW(6)
	STS  _step2,R30
;     517 		}
;     518 	}
_0x67:
;     519 else if(step2==s6)
	RJMP _0x68
_0x66:
	LDS  R26,_step2
	CPI  R26,LOW(0x6)
	BRNE _0x69
;     520 	{
;     521 	out_stat2|=(1<<PP2_1)|(1<<PP2_2)|(1<<PP2_3)|(1<<PP2_4);
	LDS  R30,_out_stat2
	ORI  R30,LOW(0xF)
	STS  _out_stat2,R30
;     522 	cnt_del2--;
	CALL SUBOPT_0x1
;     523 	if(cnt_del2==0)
	BRNE _0x6A
;     524 		{
;     525 		cnt_del2=60;
	LDI  R30,LOW(60)
	STS  _cnt_del2,R30
;     526 		step2=s7;
	LDI  R30,LOW(7)
	STS  _step2,R30
;     527 		}
;     528 	}
_0x6A:
;     529 else if(step2==s7)
	RJMP _0x6B
_0x69:
	LDS  R26,_step2
	CPI  R26,LOW(0x7)
	BRNE _0x6C
;     530 	{
;     531 	out_stat2|=(1<<PP2_1)|(1<<PP2_4);
	LDS  R30,_out_stat2
	ORI  R30,LOW(0x9)
	STS  _out_stat2,R30
;     532 	cnt_del2--;
	CALL SUBOPT_0x1
;     533 	if(cnt_del2==0)
	BRNE _0x6D
;     534 		{
;     535 		cnt_del2=20;
	LDI  R30,LOW(20)
	STS  _cnt_del2,R30
;     536 		step2=s8;
	LDI  R30,LOW(8)
	STS  _step2,R30
;     537 		}
;     538 	}
_0x6D:
;     539 else if(step2==s8)
	RJMP _0x6E
_0x6C:
	LDS  R26,_step2
	CPI  R26,LOW(0x8)
	BRNE _0x6F
;     540 	{
;     541 	out_stat2|=(1<<PP2_4);
	LDS  R30,_out_stat2
	ORI  R30,1
	STS  _out_stat2,R30
;     542 	cnt_del2--;
	CALL SUBOPT_0x1
;     543 	if(cnt_del2==0)
	BRNE _0x70
;     544 		{
;     545 		step2=s9;
	LDI  R30,LOW(9)
	STS  _step2,R30
;     546 		}
;     547 	}
_0x70:
;     548 else if(step2==s9)
	RJMP _0x71
_0x6F:
	LDS  R26,_step2
	CPI  R26,LOW(0x9)
	BRNE _0x72
;     549 	{
;     550 	if(bMD2)
	SBRS R3,6
	RJMP _0x73
;     551 		{
;     552 		step2=sOFF;
	LDI  R30,LOW(0)
	STS  _step2,R30
;     553 		}
;     554 	}
_0x73:
;     555 
;     556 //out_stat2=(1<<PP2_4);
;     557 }
_0x72:
_0x71:
_0x6E:
_0x6B:
_0x68:
_0x65:
_0x62:
_0x5F:
_0x5C:
_0x5A:
	RET
;     558 
;     559 //-----------------------------------------------
;     560 void cmnd_an(void)
;     561 {  
_cmnd_an:
;     562 /*DDRD.2=1;
;     563 PORTD.2=!PORTD.2;*/ 
;     564 if(cmnd==0x55)
	LDS  R26,_cmnd
	CPI  R26,LOW(0x55)
	BRNE _0x74
;     565 	{
;     566 	if(mode1==mON)step1=s1;
	LDS  R30,_mode1
	CPI  R30,0
	BRNE _0x75
	LDI  R30,LOW(1)
	STS  _step1,R30
;     567 	if(mode2==mON)
_0x75:
	LDS  R30,_mode2
	CPI  R30,0
	BRNE _0x76
;     568 		{
;     569 		step2=s1;
	LDI  R30,LOW(1)
	STS  _step2,R30
;     570 		/*PORTD.2=!PORTD.2; */
;     571 		}
;     572 	}
_0x76:
;     573 else if(cmnd==0x33)
	RJMP _0x77
_0x74:
	LDS  R26,_cmnd
	CPI  R26,LOW(0x33)
	BRNE _0x78
;     574 	{
;     575 	if(mode1==mON)step1=sOFF;
	LDS  R30,_mode1
	CPI  R30,0
	BRNE _0x79
	LDI  R30,LOW(0)
	STS  _step1,R30
;     576 	if(mode2==mON)step2=sOFF;
_0x79:
	LDS  R30,_mode2
	CPI  R30,0
	BRNE _0x7A
	LDI  R30,LOW(0)
	STS  _step2,R30
;     577 	}	
_0x7A:
;     578 	
;     579 }
_0x78:
_0x77:
	RET
;     580 
;     581 //-----------------------------------------------
;     582 void state_an(void)
;     583 {  
_state_an:
;     584 #if(NUM_OF_SLAVE==1)
;     585 if(state&0x01)mode1=mON;
;     586 else mode1=mOFF;
;     587 if(state&0x02)mode2=mON;
;     588 else mode2=mOFF;
;     589 
;     590 #elif(NUM_OF_SLAVE==2)
;     591 if(state&0x04)mode1=mON;
	LDS  R30,_state
	ANDI R30,LOW(0x4)
	BREQ _0x7B
	LDI  R30,LOW(0)
	RJMP _0xAB
;     592 else mode1=mOFF;
_0x7B:
	LDI  R30,LOW(1)
_0xAB:
	STS  _mode1,R30
;     593 if(state&0x08)mode2=mON;
	LDS  R30,_state
	ANDI R30,LOW(0x8)
	BREQ _0x7D
	LDI  R30,LOW(0)
	RJMP _0xAC
;     594 else mode2=mOFF;
_0x7D:
	LDI  R30,LOW(1)
_0xAC:
	STS  _mode2,R30
;     595 
;     596 #elif(NUM_OF_SLAVE==3)
;     597 if(state&0x10)mode1=mON;
;     598 else mode1=mOFF;
;     599 if(state&0x20)mode2=mON;
;     600 else mode2=mOFF;
;     601 #endif	
;     602 }
	RET
;     603 
;     604 //-----------------------------------------------
;     605 void uart_in_an(void)
;     606 {
_uart_in_an:
;     607 if(rx_buffer[0]==NUM_OF_SLAVE)
	LDS  R26,_rx_buffer
	CPI  R26,LOW(0x2)
	BREQ PC+3
	JMP _0x7F
;     608 	{
;     609 	char temp1,temp2,temp3,temp4;
;     610 	
;     611 	temp1=NUM_OF_SLAVE;
	SBIW R28,4
;	temp1 -> Y+3
;	temp2 -> Y+2
;	temp3 -> Y+1
;	temp4 -> Y+0
	LDI  R30,LOW(2)
	STD  Y+3,R30
;     612 	temp4=temp1;
	ST   Y,R30
;     613 	
;     614 	temp2=0x80;
	LDI  R30,LOW(128)
	STD  Y+2,R30
;     615 	if(bVR1)temp2|=(1<<0);
	SBRS R3,3
	RJMP _0x80
	LDD  R30,Y+2
	ORI  R30,1
	STD  Y+2,R30
;     616 	if(bMD1)temp2|=(1<<1);
_0x80:
	SBRS R3,5
	RJMP _0x81
	LDD  R30,Y+2
	ORI  R30,2
	STD  Y+2,R30
;     617 	if(step1!=sOFF)temp2|=(1<<2);
_0x81:
	LDS  R30,_step1
	CPI  R30,0
	BREQ _0x82
	LDD  R30,Y+2
	ORI  R30,4
	STD  Y+2,R30
;     618 	if(bVR2)temp2|=(1<<3);
_0x82:
	SBRS R3,4
	RJMP _0x83
	LDD  R30,Y+2
	ORI  R30,8
	STD  Y+2,R30
;     619 	if(bMD2)temp2|=(1<<4);
_0x83:
	SBRS R3,6
	RJMP _0x84
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
;     620 	if(step2!=sOFF)temp2|=(1<<5);
_0x84:
	LDS  R30,_step2
	CPI  R30,0
	BREQ _0x85
	LDD  R30,Y+2
	ORI  R30,0x20
	STD  Y+2,R30
;     621 	
;     622 	temp4^=temp2;
_0x85:
	LDD  R30,Y+2
	CALL SUBOPT_0x2
;     623 	
;     624 	temp3=0x80;
	LDI  R30,LOW(128)
	STD  Y+1,R30
;     625 	temp4^=temp3;
	CALL SUBOPT_0x2
;     626 	
;     627 	temp4|=0x80;
	LD   R30,Y
	ORI  R30,0x80
	ST   Y,R30
;     628 	
;     629 	out_usart(4,temp1,temp2,temp3,temp4,0,0,0,0,0);	
	LDI  R30,LOW(4)
	CALL SUBOPT_0x3
	CALL SUBOPT_0x3
	CALL SUBOPT_0x4
	CALL SUBOPT_0x4
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _out_usart
;     630 
;     631 	}
	ADIW R28,4
;     632 
;     633 cmnd_new=rx_buffer[1];
_0x7F:
	__GETB1MN _rx_buffer,1
	STS  _cmnd_new,R30
;     634 if(cmnd_new==cmnd_old)
	LDS  R30,_cmnd_old
	LDS  R26,_cmnd_new
	CP   R30,R26
	BRNE _0x86
;     635 	{
;     636 	if(cmnd_cnt<4)
	LDS  R26,_cmnd_cnt
	CPI  R26,LOW(0x4)
	BRSH _0x87
;     637 		{
;     638 		cmnd_cnt++;
	LDS  R30,_cmnd_cnt
	SUBI R30,-LOW(1)
	STS  _cmnd_cnt,R30
;     639 		if(cmnd_cnt>=4)
	LDS  R26,_cmnd_cnt
	CPI  R26,LOW(0x4)
	BRLO _0x88
;     640 			{                  
;     641 			if((cmnd_new&0x7f)!=cmnd)
	LDS  R30,_cmnd_new
	ANDI R30,0x7F
	LDS  R26,_cmnd
	CP   R30,R26
	BREQ _0x89
;     642 				{
;     643 				cmnd=cmnd_new&0x7f;
	LDS  R30,_cmnd_new
	ANDI R30,0x7F
	STS  _cmnd,R30
;     644 				cmnd_an();
	CALL _cmnd_an
;     645 				}
;     646 			}         
_0x89:
;     647 		}	
_0x88:
;     648 	}		
_0x87:
;     649 else cmnd_cnt=0;
	RJMP _0x8A
_0x86:
	LDI  R30,LOW(0)
	STS  _cmnd_cnt,R30
_0x8A:
;     650 cmnd_old=cmnd_new;
	LDS  R30,_cmnd_new
	STS  _cmnd_old,R30
;     651 
;     652 state_new=rx_buffer[2];
	__GETB1MN _rx_buffer,2
	STS  _state_new,R30
;     653 if(state_new==state_old)
	LDS  R30,_state_old
	LDS  R26,_state_new
	CP   R30,R26
	BRNE _0x8B
;     654 	{
;     655 	if(state_cnt<4)
	LDS  R26,_state_cnt
	CPI  R26,LOW(0x4)
	BRSH _0x8C
;     656 		{
;     657 		state_cnt++;
	LDS  R30,_state_cnt
	SUBI R30,-LOW(1)
	STS  _state_cnt,R30
;     658 		if(state_cnt>=4)
	LDS  R26,_state_cnt
	CPI  R26,LOW(0x4)
	BRLO _0x8D
;     659 			{                  
;     660 			if((state_new&0x7f)!=state)
	LDS  R30,_state_new
	ANDI R30,0x7F
	LDS  R26,_state
	CP   R30,R26
	BREQ _0x8E
;     661 				{
;     662 				state=state_new&0x7f;
	LDS  R30,_state_new
	ANDI R30,0x7F
	STS  _state,R30
;     663 				state_an();
	CALL _state_an
;     664 				}
;     665 			}         
_0x8E:
;     666 		}	
_0x8D:
;     667 	}		
_0x8C:
;     668 else state_cnt=0;
	RJMP _0x8F
_0x8B:
	LDI  R30,LOW(0)
	STS  _state_cnt,R30
_0x8F:
;     669 state_old=state_new;
	LDS  R30,_state_new
	STS  _state_old,R30
;     670 	 
;     671 /*state=rx_buffer[2];
;     672 state_an();*/					
;     673 	
;     674 }
	RET
;     675 
;     676 //-----------------------------------------------
;     677 void mathemat(void)
;     678 {
_mathemat:
;     679 timer1_delay=ee_timer1_delay*31;
	LDI  R26,LOW(_ee_timer1_delay)
	LDI  R27,HIGH(_ee_timer1_delay)
	CALL __EEPROMRDW
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	CALL __MULW12U
	STS  _timer1_delay,R30
	STS  _timer1_delay+1,R31
;     680 }
	RET
;     681 
;     682 
;     683 //-----------------------------------------------
;     684 void led_hndl(void)
;     685 {
_led_hndl:
;     686 
;     687 }
	RET
;     688 
;     689 //-----------------------------------------------
;     690 // Подпрограмма драйва до 7 кнопок одного порта, 
;     691 // различает короткое и длинное нажатие,
;     692 // срабатывает на отпускание кнопки, возможность
;     693 // ускорения перебора при длинном нажатии...
;     694 #define but_port PORTC
;     695 #define but_dir  DDRC
;     696 #define but_pin  PINC
;     697 #define but_mask 0b01101010
;     698 #define no_but   0b11111111
;     699 #define but_on   5
;     700 #define but_onL  20
;     701 
;     702 
;     703 
;     704 
;     705 void but_drv(void)
;     706 { 
;     707 DDRD&=0b00000111;
;     708 PORTD|=0b11111000;
;     709 
;     710 but_port|=(but_mask^0xff);
;     711 but_dir&=but_mask;
;     712 #asm
;     713 nop
nop
;     714 nop
nop
;     715 nop
nop
;     716 nop
nop
;     717 nop
nop
;     718 nop
nop
;     719 nop
nop
;     720 #endasm

;     721 
;     722 but_n=but_pin|but_mask; 
;     723 
;     724 if((but_n==no_but)||(but_n!=but_s))
;     725  	{
;     726  	speed=0;
;     727    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
;     728   		{
;     729    	     n_but=1;
;     730           but=but_s;
;     731           }
;     732    	if (but1_cnt>=but_onL_temp)
;     733   		{
;     734    	     n_but=1;
;     735           but=but_s&0b11111101;
;     736           }
;     737     	l_but=0;
;     738    	but_onL_temp=but_onL;
;     739     	but0_cnt=0;
;     740   	but1_cnt=0;          
;     741      goto but_drv_out;
;     742   	}  
;     743   	
;     744 if(but_n==but_s)
;     745  	{
;     746   	but0_cnt++;
;     747   	if(but0_cnt>=but_on)
;     748   		{
;     749    		but0_cnt=0;
;     750    		but1_cnt++;
;     751    		if(but1_cnt>=but_onL_temp)
;     752    			{              
;     753     			but=but_s&0b11111101;
;     754     			but1_cnt=0;
;     755     			n_but=1;
;     756     			l_but=1;
;     757 			if(speed)
;     758 				{
;     759     				but_onL_temp=but_onL_temp>>1;
;     760         			if(but_onL_temp<=2) but_onL_temp=2;
;     761 				}    
;     762    			}
;     763   		} 
;     764  	}
;     765 but_drv_out:
;     766 but_s=but_n;
;     767 but_port|=(but_mask^0xff);
;     768 but_dir&=but_mask;
;     769 }    
;     770 
;     771 #define butA	239
;     772 #define butA_	237
;     773 #define butP	251
;     774 #define butP_	249
;     775 #define butR	127
;     776 #define butR_	125
;     777 #define butL	254
;     778 #define butL_	252
;     779 #define butLR	126
;     780 #define butLR_	124
;     781 
;     782 
;     783 
;     784 
;     785 //***********************************************
;     786 //***********************************************
;     787 //***********************************************
;     788 //***********************************************
;     789 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;     790 {
_timer0_ovf_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;     791 TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
;     792 TCNT0=-78;
	LDI  R30,LOW(178)
	RCALL SUBOPT_0x5
;     793 OCR0=0x00;
;     794 
;     795 b100Hz=1;
	SET
	BLD  R2,1
;     796 
;     797 if(++t0_cnt1>=10)
	INC  R10
	LDI  R30,LOW(10)
	CP   R10,R30
	BRLO _0x9F
;     798 	{
;     799 	t0_cnt1=0;
	CLR  R10
;     800 	b10Hz=1;
	SET
	BLD  R2,2
;     801 	
;     802 	if(++t0_cnt2>=2)
	INC  R11
	LDI  R30,LOW(2)
	CP   R11,R30
	BRLO _0xA0
;     803 		{
;     804 		t0_cnt2=0;
	CLR  R11
;     805 		bFL5=!bFL5;
	LDI  R30,LOW(1)
	EOR  R3,R30
;     806 		}
;     807 		
;     808 	if(++t0_cnt3>=5)
_0xA0:
	INC  R12
	LDI  R30,LOW(5)
	CP   R12,R30
	BRLO _0xA1
;     809 		{
;     810 		t0_cnt3=0;
	CLR  R12
;     811 		bFL2=!bFL2;
	LDI  R30,LOW(128)
	EOR  R2,R30
;     812 		}		
;     813 	}
_0xA1:
;     814 }
_0x9F:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;     815 
;     816 //***********************************************
;     817 // Timer 1 output compare A interrupt service routine
;     818 interrupt [TIM1_COMPA] void timer1_compa_isr(void)
;     819 {
_timer1_compa_isr:
;     820 
;     821 }
	RETI
;     822 
;     823 
;     824 //===============================================
;     825 //===============================================
;     826 //===============================================
;     827 //===============================================
;     828 
;     829 void main(void)
;     830 {
_main:
;     831 
;     832 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
;     833 DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
;     834 
;     835 PORTB=0x00;
	OUT  0x18,R30
;     836 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     837 
;     838 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;     839 DDRC=0x00;
	OUT  0x14,R30
;     840 
;     841 
;     842 PORTD=0x00;
	OUT  0x12,R30
;     843 DDRD=0x00;
	OUT  0x11,R30
;     844 
;     845 
;     846 TCCR0=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
;     847 TCNT0=-99;
	LDI  R30,LOW(157)
	RCALL SUBOPT_0x5
;     848 OCR0=0x00;
;     849 
;     850 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
;     851 TCCR1B=0x00;
	OUT  0x2E,R30
;     852 TCNT1H=0x00;
	OUT  0x2D,R30
;     853 TCNT1L=0x00;
	OUT  0x2C,R30
;     854 ICR1H=0x00;
	OUT  0x27,R30
;     855 ICR1L=0x00;
	OUT  0x26,R30
;     856 OCR1AH=0x00;
	OUT  0x2B,R30
;     857 OCR1AL=0x00;
	OUT  0x2A,R30
;     858 OCR1BH=0x00;
	OUT  0x29,R30
;     859 OCR1BL=0x00;
	OUT  0x28,R30
;     860 
;     861 
;     862 ASSR=0x00;
	OUT  0x22,R30
;     863 TCCR2=0x00;
	OUT  0x25,R30
;     864 TCNT2=0x00;
	OUT  0x24,R30
;     865 OCR2=0x00;
	OUT  0x23,R30
;     866 
;     867 // USART initialization
;     868 // Communication Parameters: 8 Data, 1 Stop, No Parity
;     869 // USART Receiver: On
;     870 // USART Transmitter: On
;     871 // USART Mode: Asynchronous
;     872 // USART Baud rate: 19200
;     873 UCSRA=0x00;
	OUT  0xB,R30
;     874 UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
;     875 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
;     876 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;     877 UBRRL=0x19;
	LDI  R30,LOW(25)
	OUT  0x9,R30
;     878 
;     879 MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
;     880 MCUCSR=0x00;
	OUT  0x34,R30
;     881 
;     882 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;     883 
;     884 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     885 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     886 
;     887 #asm("sei")
	sei
;     888 led_hndl();
	CALL _led_hndl
;     889 ch_on[0]=coON;
	LDI  R26,LOW(_ch_on)
	LDI  R27,HIGH(_ch_on)
	LDI  R30,LOW(170)
	CALL __EEPROMWRB
;     890 //ee_avtom_mode=eamOFF; 
;     891 //ind=iSet_delay;
;     892 while (1)
_0xA2:
;     893       {
;     894       if(b600Hz)
	SBRS R2,0
	RJMP _0xA5
;     895 		{
;     896 		b600Hz=0; 
	CLT
	BLD  R2,0
;     897           
;     898 		}         
;     899       if(b100Hz)
_0xA5:
	SBRS R2,1
	RJMP _0xA6
;     900 		{        
;     901 		b100Hz=0; 
	CLT
	BLD  R2,1
;     902           
;     903           in_drv();
	CALL _in_drv
;     904           mdvr_drv();
	CALL _mdvr_drv
;     905           step1_contr();
	CALL _step1_contr
;     906 		step2_contr();
	CALL _step2_contr
;     907           out_drv();
	CALL _out_drv
;     908     		}   
;     909 	if(b10Hz)
_0xA6:
	SBRS R2,2
	RJMP _0xA7
;     910 		{
;     911 		b10Hz=0;
	CLT
	BLD  R2,2
;     912 		
;     913 		
;     914 		
;     915 						
;     916           led_hndl();
	CALL _led_hndl
;     917           mathemat();
	CALL _mathemat
;     918           DDRD.2=1;
	SBI  0x11,2
;     919           if(step2!=sOFF) PORTD.2=0;   
	LDS  R30,_step2
	CPI  R30,0
	BREQ _0xA8
	CBI  0x12,2
;     920           else PORTD.2=1;
	RJMP _0xA9
_0xA8:
	SBI  0x12,2
_0xA9:
;     921           }
;     922 
;     923       };
_0xA7:
	RJMP _0xA2
;     924 }
_0xAA:
	RJMP _0xAA
;     925 
;     926 
;     927 
;     928 

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x0:
	LDS  R30,_cnt_del1
	SUBI R30,LOW(1)
	STS  _cnt_del1,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x1:
	LDS  R30,_cnt_del2
	SUBI R30,LOW(1)
	STS  _cnt_del2,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2:
	LD   R26,Y
	EOR  R30,R26
	ST   Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3:
	ST   -Y,R30
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R30,Y+4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5:
	OUT  0x32,R30
	LDI  R30,LOW(0)
	OUT  0x3C,R30
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

