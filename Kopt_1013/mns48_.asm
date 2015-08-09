;CodeVisionAVR C Compiler V1.24.1d Standard
;(C) Copyright 1998-2004 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.ro
;e-mail:office@hpinfotech.ro

;Chip type           : ATmega48
;Clock frequency     : 1,000000 MHz
;Memory model        : Small
;Optimize for        : Size
;(s)printf features  : int, width
;(s)scanf features   : long, width
;External SRAM size  : 0
;Data Stack size     : 128 byte(s)
;Heap size           : 0 byte(s)
;Promote char to int : No
;char is unsigned    : Yes
;8 bit enums         : Yes
;Enhanced core instructions    : On
;Automatic register allocation : On

	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E
	.EQU GPIOR1=0x2A
	.EQU GPIOR2=0x2B

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

	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C

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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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

	.INCLUDE "mns48_.vec"
	.INCLUDE "mns48_.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	IN   R26,MCUSR
	OUT  MCUSR,R30
	STS  WDTCSR,R31
	STS  WDTCSR,R30
	OUT  MCUSR,R26

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x200)
	LDI  R25,HIGH(0x200)
	LDI  R26,LOW(0x100)
	LDI  R27,HIGH(0x100)
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

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	LDI  R30,__GPIOR1_INIT
	OUT  GPIOR1,R30
	LDI  R30,__GPIOR2_INIT
	OUT  GPIOR2,R30

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x2FF)
	OUT  SPL,R30
	LDI  R30,HIGH(0x2FF)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x180)
	LDI  R29,HIGH(0x180)

	RJMP _main

	.ESEG
	.ORG 0
	.DB  0 ; FIRST EEPROM LOCATION NOT USED, SEE ATMEL ERRATA SHEETS

	.DSEG
	.ORG 0x180
;       1 //#define DEBUG
;       2 #define RELEASE
;       3 #define MIN_U	100
;       4 
;       5 #include <Mega8.h>
;       6 #include <delay.h> 
;       7 
;       8 #ifdef DEBUG
;       9 #include "usart.c"
;      10 #include "cmd.c"
;      11 #include <stdio.h>
;      12 #endif
;      13 
;      14 
;      15 #ifdef DEBUG
;      16 #define LED_NET PORTB.0
;      17 #define LED_PER PORTB.1
;      18 #define LED_DEL PORTB.2
;      19 #define KL1 PORTB.7
;      20 #define KL2 PORTB.6
;      21 #endif
;      22 
;      23 #ifdef RELEASE
;      24 #define LED_NET PORTD.0
;      25 #define LED_PER PORTD.1
;      26 #define LED_DEL PORTD.2
;      27 #define KL2 PORTD.3
;      28 #define KL1 PORTD.4
;      29 #endif
;      30 
;      31 bit bT0;
;      32 bit b100Hz;
;      33 bit b10Hz;
;      34 bit b5Hz;
;      35 bit b2Hz;
;      36 bit b1Hz;
;      37 //bit n_but;
;      38 
;      39 char t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3/*,t0_cnt4*/;
;      40 unsigned int bankA,bankB,bankC;
;      41 unsigned int adc_bankU[3][25]/*,ADCU*/,adc_bankU_[3];
_adc_bankU:
	.BYTE 0x96
_adc_bankU_:
	.BYTE 0x6
;      42 unsigned int del_cnt;
_del_cnt:
	.BYTE 0x2
;      43 char flags;
_flags:
	.BYTE 0x1
;      44 char deltas;
_deltas:
	.BYTE 0x1
;      45 char adc_cntA,adc_cntB,adc_cntC;
_adc_cntA:
	.BYTE 0x1
_adc_cntB:
	.BYTE 0x1
_adc_cntC:
	.BYTE 0x1
;      46 bit bA_,bB_,bC_;
;      47 bit bA,bB,bC;
;      48 unsigned int adc_data;
_adc_data:
	.BYTE 0x2
;      49 char cnt_x;
_cnt_x:
	.BYTE 0x1
;      50 char cher[3]={5,6,7};
_cher:
	.BYTE 0x3
;      51 int cher_cnt=25; 
_cher_cnt:
	.BYTE 0x2
;      52 //char reset_cnt=25;
;      53 char pcnt[3];
_pcnt:
	.BYTE 0x3
;      54 bit bPER,bPER_,bCHER_;
;      55 bit bNN,bNN_;
;      56 enum char {iMn,iSet}ind;
_ind:
	.BYTE 0x1
;      57 bit bFl;
;      58 eeprom char delta; 

	.ESEG
_delta:
	.DB  0x0
;      59 char cnt_butS,cnt_butR; 

	.DSEG
_cnt_butS:
	.BYTE 0x1
_cnt_butR:
	.BYTE 0x1
;      60 bit butR,butS;
;      61 flash char DF[]={0,10,15,20,25,30,35};

	.CSEG
;      62 char per_cnt;

	.DSEG
_per_cnt:
	.BYTE 0x1
;      63 char nn_cnt;
_nn_cnt:
	.BYTE 0x1
;      64 //-----------------------------------------------
;      65 void t0_init(void)
;      66 {

	.CSEG
_t0_init:
;      67 /*
;      68 TCCR0=0x03;
;      69 TCNT0=-78;
;      70 TIMSK|=0b00000001; */
;      71 TCCR0A=0x00;
	LDI  R30,LOW(0)
;      72 TCCR0B=0x04;
	LDI  R30,LOW(4)
;      73 TCNT0=-39;
	LDI  R30,LOW(217)
	OUT  0x32,R30
;      74 OCR0A=0x00;
	RCALL SUBOPT_0x0
;      75 OCR0B=0x00;
;      76 } 
	RET
;      77 
;      78 /*//-----------------------------------------------
;      79 void t2_init(void)
;      80 {
;      81 //TIFR|=0b01000000;
;      82 TCNT2=-97;
;      83 TCCR2=0x07;
;      84 OCR2=-80;
;      85 TIMSK|=0b11000000;
;      86 }  */
;      87 
;      88 //-----------------------------------------------
;      89 void del_init(void)
;      90 {
_del_init:
;      91 if(!del_cnt) del_cnt=300;
	LDS  R30,_del_cnt
	LDS  R31,_del_cnt+1
	SBIW R30,0
	BRNE _0x5
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	STS  _del_cnt,R30
	STS  _del_cnt+1,R31
;      92 } 
_0x5:
	RET
;      93 
;      94 //-----------------------------------------------
;      95 void del_hndl(void)
;      96 {
;      97 if((del_cnt)&&(!bCHER_)) del_cnt--;
;      98 } 
;      99 
;     100 //-----------------------------------------------
;     101 void ind_hndl(void)
;     102 {
;     103 #ifdef DEBUG
;     104 DDRB|=0x07;
;     105 #endif
;     106 
;     107 #ifdef RELEASE
;     108 DDRD|=0x07;   
;     109 #endif
;     110  
;     111 if(ind==iMn)
;     112 	{
;     113 	if(bCHER_)
;     114 		{
;     115 		LED_NET=bFl;
;     116 		}
;     117 	else LED_NET=0;
;     118 	
;     119 	if(del_cnt||bCHER_)
;     120 		{
;     121 		LED_DEL=0;
;     122 		}
;     123 	else LED_DEL=1;
;     124 
;     125 	if(bNN_)
;     126 		{
;     127 		LED_PER=bFl;
;     128 		}
;     129 
;     130 	else if(bPER)
;     131 		{
;     132 		LED_PER=0;
;     133 		}		
;     134 
;     135 	else LED_PER=1;	
;     136 				
;     137 	}
;     138 else if(ind==iSet)
;     139 	{
;     140 	#ifdef DEBUG 
;     141 	if(bFl) PORTB|=0x07;
;     142 	else PORTB&=(delta^0xff)|0xf8;
;     143 	#endif
;     144 	
;     145 	#ifdef RELEASE 
;     146 	if(bFl) PORTD|=0x07;
;     147 	else PORTD&=(delta^0xff)|0xf8;
;     148 	#endif
;     149 	
;     150 	}	
;     151 }
;     152 
;     153 //-----------------------------------------------
;     154 void out_out(void)
;     155 {
;     156 #ifdef DEBUG
;     157 DDRB|=0xc0;   
;     158 #endif
;     159 
;     160 #ifdef RELEASE
;     161 DDRD|=0x18;   
;     162 #endif    
;     163 
;     164 if((!del_cnt)&&(!bPER_)&&(!bCHER_)&&(!bNN_))
;     165 	{
;     166 	KL1=1;
;     167 	flags|=0x02;
;     168 	}
;     169 else 
;     170 	{
;     171 	KL1=0;
;     172 	flags&=0xfD;
;     173 	}	
;     174 	
;     175 if((!bPER_)&&(!bCHER_)&&(!bNN_))
;     176 	{
;     177 	KL2=1;
;     178 	flags|=0x08;
;     179 	}
;     180 else 
;     181 	{
;     182 	KL2=0;
;     183 	flags&=0xf7;
;     184 	}		
;     185 }
;     186 
;     187 //-----------------------------------------------
;     188 void per_drv(void)
;     189 {
;     190 char max_,min_;
;     191 signed long temp_SL;
;     192 if((adc_bankU_[0]>=adc_bankU_[1])&&(adc_bankU_[0]>=adc_bankU_[2])) max_=0; 
;	max_ -> R16
;	min_ -> R17
;	temp_SL -> Y+2
;     193 else if(adc_bankU_[1]>=adc_bankU_[2]) max_=1; 
;     194 else max_=2;  
;     195 
;     196 if((adc_bankU_[0]<=adc_bankU_[1])&&(adc_bankU_[0]<=adc_bankU_[2])) min_=0; 
;     197 else if(adc_bankU_[1]<=adc_bankU_[2]) min_=1; 
;     198 else min_=2; 
;     199 
;     200 temp_SL=adc_bankU_[max_]*(long)DF[delta]/100;
;     201 if((adc_bankU_[max_]-adc_bankU_[min_])>=(int)temp_SL)
;     202 	{
;     203 	bPER=1;
;     204 
;     205 	flags|=0x01;
;     206 	}      
;     207 else
;     208 	{
;     209 	bPER=0;   
;     210 
;     211 	flags&=0xfe;
;     212 	}
;     213 //	bPER=0;	
;     214 }
;     215 
;     216 //-----------------------------------------------
;     217 void nn_drv(void)
;     218 {
;     219 if((adc_bankU_[0]<=MIN_U)&&(adc_bankU_[1]<=MIN_U)&&(adc_bankU_[2]<=MIN_U))
;     220 	{
;     221 	bNN=1;
;     222 	}      
;     223 else
;     224 	{
;     225 	bNN=0;   
;     226 	}
;     227 }
;     228 
;     229 //-----------------------------------------------
;     230 void per_hndl(void)
;     231 {
;     232 if(!bPER)
;     233 	{
;     234 	per_cnt=0;
;     235 	bPER_=0;
;     236 	flags&=0xfB;
;     237 	}
;     238 else
;     239 	{
;     240 	if(per_cnt<5)
;     241 		{
;     242 		if(++per_cnt>=5)
;     243 			{
;     244 			bPER_=1;
;     245 			flags|=0x04;
;     246 			del_init();
;     247 			}
;     248 		}
;     249 	}	
;     250 }
;     251 
;     252 //-----------------------------------------------
;     253 void nn_hndl(void)
;     254 {
;     255 if(!bNN)
;     256 	{
;     257 	nn_cnt=0;
;     258 	bNN_=0;
;     259 	
;     260 	}
;     261 else
;     262 	{
;     263 	if(nn_cnt<5)
;     264 		{
;     265 		if(++nn_cnt>=5)
;     266 			{
;     267 			bNN_=1;
;     268 			del_init();
;     269 			}
;     270 		}
;     271 	}	
;     272 }
;     273 
;     274 //-----------------------------------------------
;     275 void pcnt_hndl(void)
;     276 {
;     277 if(pcnt[0])
;     278 	{
;     279 	pcnt[0]--;
;     280 	if(pcnt[0]==0) adc_bankU_[0]=0;
;     281 	}
;     282 if(pcnt[1])
;     283 	{
;     284 	pcnt[1]--;
;     285 	if(pcnt[1]==0) adc_bankU_[1]=0;
;     286 	}
;     287 if(pcnt[2])
;     288 	{
;     289 	pcnt[2]--;
;     290 	if(pcnt[2]==0) adc_bankU_[2]=0;
;     291 	}		
;     292 }
;     293 
;     294 /*//-----------------------------------------------
;     295 void gran_char(signed char *adr, signed char min, signed char max)
;     296 {
;     297 if (*adr<min) *adr=min;
;     298 if (*adr>max) *adr=max; 
;     299 } */
;     300 
;     301 
;     302 #ifdef DEBUG
;     303 
;     304 
;     305 
;     306 //-----------------------------------------------
;     307 char index_offset (signed char index,signed char offset)
;     308 {
;     309 index=index+offset;
;     310 if(index>=RX_BUFFER_SIZE) index-=RX_BUFFER_SIZE; 
;     311 if(index<0) index+=RX_BUFFER_SIZE;
;     312 return index;
;     313 }
;     314 
;     315 //-----------------------------------------------
;     316 char control_check(char index)
;     317 {
;     318 char i=0,ii=0,iii;
;     319 
;     320 if(rx_buffer[index]!=END) goto error_cc;
;     321 
;     322 ii=rx_buffer[index_offset(index,-2)];
;     323 iii=0;
;     324 for(i=0;i<=ii;i++)
;     325 	{
;     326 	iii^=rx_buffer[index_offset(index,-2-ii+i)];
;     327 	}
;     328 if (iii!=rx_buffer[index_offset(index,-1)]) goto error_cc;	
;     329 
;     330 
;     331 success_cc:
;     332 return 1;
;     333 goto end_cc;
;     334 error_cc:
;     335 return 0;
;     336 goto end_cc;
;     337 
;     338 end_cc:
;     339 }
;     340 
;     341 
;     342 //-----------------------------------------------
;     343 void OUT (char num,char data0,char data1,char data2,char data3,char data4,char data5)
;     344 {
;     345 char i,t=0;
;     346 //char *ptr=&data1;
;     347 char UOB[6]; 
;     348 UOB[0]=data0;
;     349 UOB[1]=data1;
;     350 UOB[2]=data2;
;     351 UOB[3]=data3;
;     352 UOB[4]=data4;
;     353 UOB[5]=data5;
;     354 for (i=0;i<num;i++)
;     355 	{
;     356 	t^=UOB[i];
;     357 	}    
;     358 UOB[num]=num;
;     359 t^=UOB[num];
;     360 UOB[num+1]=t;
;     361 UOB[num+2]=END;
;     362 
;     363 for (i=0;i<num+3;i++)
;     364 	{
;     365 	putchar(UOB[i]);
;     366 	}   	
;     367 }
;     368 
;     369 //-----------------------------------------------
;     370 void OUT_adr (char *ptr, char len)
;     371 {
;     372 char UOB[20]={0,0,0,0,0,0,0,0,0,0};
;     373 char i,t=0;
;     374 
;     375 for(i=0;i<len;i++)
;     376 	{
;     377 	UOB[i]=ptr[i];
;     378 	t^=UOB[i];
;     379 	}
;     380 //if(!t)t=0xff;
;     381 UOB[len]=len;
;     382 t^=len;	
;     383 UOB[len+1]=t;	
;     384 UOB[len+2]=END;
;     385 //UOB[0]=i+1;
;     386 //UOB[i]=t^UOB[0];
;     387 //UOB[i+1]=END;
;     388 	
;     389 //puts(UOB); 
;     390 for (i=0;i<len+3;i++)
;     391 	{
;     392 	putchar(UOB[i]);
;     393 	}   
;     394 }
;     395 
;     396 //-----------------------------------------------
;     397 void UART_IN_AN(void)
;     398 {
;     399 char temp_char;
;     400 int temp_int;
;     401 signed long int temp_intL;
;     402 
;     403 if((UIB[0]==CMND)&&(UIB[1]==QWEST))
;     404 	{
;     405 
;     406 	}
;     407 else if((UIB[0]==CMND)&&(UIB[1]==GETID))
;     408 	{
;     409 
;     410           
;     411 	}	
;     412 
;     413 }
;     414 
;     415 //-----------------------------------------------
;     416 void UART_IN(void)
;     417 {
;     418 //static char flag;
;     419 char temp,i,count;
;     420 if(!bRXIN) goto UART_IN_end;
;     421 #asm("cli")
;     422 //char* ptr;
;     423 //char i=0,t=0;
;     424 //int it=0;
;     425 //signed long int char_int;
;     426 //if(!bRXIN) goto UART_IN_end;
;     427 //bRXIN=0;
;     428 //count=rx_counter;
;     429 //OUT(0x01,0,0,0,0,0);
;     430 if(rx_buffer_overflow)
;     431 	{
;     432 	rx_wr_index=0;
;     433 	rx_rd_index=0;
;     434 	rx_counter=0;
;     435 	rx_buffer_overflow=0;
;     436 	}    
;     437 	
;     438 if(rx_counter&&(rx_buffer[index_offset(rx_wr_index,-1)])==END)
;     439 	{
;     440      temp=rx_buffer[index_offset(rx_wr_index,-3)];
;     441     	if(temp<10) 
;     442     		{
;     443     		if(control_check(index_offset(rx_wr_index,-1)))
;     444     			{
;     445     			rx_rd_index=index_offset(rx_wr_index,-3-temp);
;     446     			for(i=0;i<temp;i++)
;     447 				{
;     448 				UIB[i]=rx_buffer[index_offset(rx_rd_index,i)];
;     449 				} 
;     450 			rx_rd_index=rx_wr_index;
;     451 			rx_counter=0;
;     452 			UART_IN_AN();
;     453 
;     454     			}
;     455  	
;     456     		} 
;     457     	}	
;     458 
;     459 UART_IN_end:
;     460 bRXIN=0;
;     461 #asm("sei")     
;     462 } 
;     463 
;     464 #endif
;     465 
;     466     
;     467  
;     468 
;     469 
;     470 
;     471 
;     472 
;     473 
;     474 //-----------------------------------------------
;     475 void but_drv(void)
;     476 {
;     477 #ifdef DEBUG
;     478 #define PINR PIND.2
;     479 #define PORTR PORTD.2
;     480 #define DDR DDRD.2
;     481 
;     482 #define PINS PIND.3
;     483 #define PORTS PORTD.3
;     484 #define DDS DDRD.3
;     485 #endif
;     486 
;     487 #ifdef RELEASE
;     488 #define PINR PINC.4
;     489 #define PORTR PORTC.4
;     490 #define DDR DDRC.4
;     491 
;     492 #define PINS PINC.5
;     493 #define PORTS PORTC.5
;     494 #define DDS DDRC.5
;     495 #endif
;     496 
;     497 
;     498 DDR=0;
;     499 DDS=0;
;     500 PORTR=1;
;     501 PORTS=1; 
;     502       
;     503 if(!PINR)
;     504 	{
;     505 	if(cnt_butR<10)
;     506 		{
;     507 		if(++cnt_butR>=10)
;     508 			{
;     509 			butR=1;
;     510 			}
;     511 		}
;     512 	}                 
;     513 else 
;     514 	{
;     515 	cnt_butR=0;
;     516 	butR=0;
;     517 	}	 
;     518 	
;     519 if(!PINS)
;     520 	{
;     521 	if(cnt_butS<200)
;     522 		{
;     523 		if(++cnt_butS>=200)
;     524 			{
;     525 			butS=1;
;     526 			}
;     527 		}
;     528 	}                 
;     529 else 
;     530 	{
;     531 	cnt_butS=0;
;     532 	butS=0;
;     533 	}		
;     534 	           
;     535 }
;     536 
;     537 //-----------------------------------------------
;     538 void but_an(void)
;     539 {
;     540 if(ind==iMn)
;     541 	{
;     542 	if(butS) ind=iSet;
;     543 	if(butR)
;     544 		{
;     545 		if(del_cnt) del_cnt=0;
;     546 		}
;     547 	}
;     548 else if(ind==iSet)
;     549 	{            
;     550 	if(butR)
;     551 		{
;     552 		if(delta<6) delta++;
;     553 		else delta=1;
;     554 		}
;     555 	if(butS) ind=iMn;	
;     556 	}
;     557 but_an_end:
;     558 butR=0;
;     559 butS=0;
;     560 }
;     561 
;     562 
;     563 
;     564 
;     565 
;     566 
;     567 
;     568 
;     569 
;     570 
;     571 
;     572 //***********************************************
;     573 //***********************************************
;     574 //***********************************************
;     575 //***********************************************
;     576 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;     577 {
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
;     578 t0_init();
	RCALL _t0_init
;     579 bT0=!bT0;
	CLT
	SBIS 0x1E,0
	SET
	IN   R30,0x1E
	BLD  R30,0
	OUT  0x1E,R30
;     580 
;     581 if(!bT0) goto lbl_000;
	SBIS 0x1E,0
	RJMP _0x54
;     582 b100Hz=1;
	SBI  0x1E,1
;     583 if(++t0_cnt0>=10)
	INC  R5
	LDI  R30,LOW(10)
	CP   R5,R30
	BRLO _0x55
;     584 	{
;     585 	t0_cnt0=0;
	CLR  R5
;     586 	b10Hz=1;
	SBI  0x1E,2
;     587 	bFl=!bFl;
	CLT
	SBIS 0x2B,1
	SET
	IN   R30,0x2B
	BLD  R30,1
	OUT  0x2B,R30
;     588 
;     589 	} 
;     590 if(++t0_cnt1>=20)
_0x55:
	INC  R6
	LDI  R30,LOW(20)
	CP   R6,R30
	BRLO _0x56
;     591 	{
;     592 	t0_cnt1=0;
	CLR  R6
;     593 	b5Hz=1;
	SBI  0x1E,3
;     594 
;     595 	}
;     596 if(++t0_cnt2>=50)
_0x56:
	INC  R7
	LDI  R30,LOW(50)
	CP   R7,R30
	BRLO _0x57
;     597 	{
;     598 	t0_cnt2=0;
	CLR  R7
;     599 	b2Hz=1;
	SBI  0x1E,4
;     600 	}	
;     601 		
;     602 if(++t0_cnt3>=100)
_0x57:
	INC  R8
	LDI  R30,LOW(100)
	CP   R8,R30
	BRLO _0x58
;     603 	{
;     604 	t0_cnt3=0;
	CLR  R8
;     605 	b1Hz=1;
	SBI  0x1E,5
;     606 	}		
;     607 lbl_000:
_0x58:
_0x54:
;     608 }
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
;     609 /*
;     610 //-----------------------------------------------
;     611 // Timer 2 output compare interrupt service routine
;     612 interrupt [TIM2_OVF] void timer2_ovf_isr(void)
;     613 {
;     614 t2_init();
;     615 
;     616 
;     617 
;     618 }
;     619 
;     620 //-----------------------------------------------
;     621 // Timer 2 output compare interrupt service routine
;     622 interrupt [TIM2_COMP] void timer2_comp_isr(void)
;     623 {
;     624 
;     625 	
;     626 
;     627 } 
;     628 */
;     629 
;     630 //-----------------------------------------------
;     631 //#pragma savereg-
;     632 interrupt [ADC_INT] void adc_isr(void)
;     633 {
_adc_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     634 
;     635 register static unsigned char input_index=0;

	.DSEG
_input_index_SD:
	.BYTE 0x1

	.CSEG
;     636 // Read the AD conversion result
;     637 adc_data=ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	STS  _adc_data,R30
	STS  _adc_data+1,R31
;     638 
;     639 if (++input_index > 2)
	LDS  R26,_input_index_SD
	SUBI R26,-LOW(1)
	STS  _input_index_SD,R26
	LDI  R30,LOW(2)
	CP   R30,R26
	BRSH _0x59
;     640    input_index=0;
	LDI  R30,LOW(0)
	STS  _input_index_SD,R30
;     641 #ifdef DEBUG
;     642 ADMUX=(0b01000011)+input_index;
;     643 #endif
;     644 #ifdef RELEASE
;     645 ADMUX=0b01000000+input_index;
_0x59:
	LDS  R30,_input_index_SD
	SUBI R30,-LOW(64)
	OUT  0x7,R30
;     646 #endif
;     647 
;     648 // Start the AD conversion
;     649 ADCSRA|=0x40;
	SBI  0x6,6
;     650 
;     651 if(input_index==1)
	LDS  R26,_input_index_SD
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x5A
;     652 	{
;     653  	if((adc_data>100)&&!bA_)
	RCALL SUBOPT_0x1
	BRSH _0x5C
	SBIS 0x1E,6
	RJMP _0x5D
_0x5C:
	RJMP _0x5B
_0x5D:
;     654     		{
;     655     		bA_=1;
	SBI  0x1E,6
;     656     		cnt_x++;
	RCALL SUBOPT_0x2
;     657     		}
;     658     	if((adc_data<100)&&bA_)
_0x5B:
	RCALL SUBOPT_0x3
	BRSH _0x5F
	SBIC 0x1E,6
	RJMP _0x60
_0x5F:
	RJMP _0x5E
_0x60:
;     659     		{
;     660     		bA_=0;
	CBI  0x1E,6
;     661     		}			
;     662 //	adc_data
;     663 	if(adc_data>10U)
_0x5E:
	RCALL SUBOPT_0x4
	BRSH _0x61
;     664 		{
;     665 		bankA+=adc_data;
	LDS  R30,_adc_data
	LDS  R31,_adc_data+1
	__ADDWRR 9,10,30,31
;     666 		bA=1;
	SBI  0x2A,1
;     667 		pcnt[0]=10;
	LDI  R30,LOW(10)
	STS  _pcnt,R30
;     668 		}
;     669 	else if((adc_data<=10U)&&bA)
	RJMP _0x62
_0x61:
	RCALL SUBOPT_0x4
	BRLO _0x64
	SBIC 0x2A,1
	RJMP _0x65
_0x64:
	RJMP _0x63
_0x65:
;     670 		{
;     671 		bA=0;
	CBI  0x2A,1
;     672 		
;     673 		adc_bankU[0,adc_cntA]=bankA/10;
	LDS  R30,_adc_cntA
	RCALL SUBOPT_0x5
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	__GETW2R 9,10
	RCALL SUBOPT_0x6
	POP  R26
	POP  R27
	RCALL __PUTWP1
;     674 		bankA=0;
	CLR  R9
	CLR  R10
;     675 		if(++adc_cntA>=25) 
	LDS  R26,_adc_cntA
	SUBI R26,-LOW(1)
	STS  _adc_cntA,R26
	CPI  R26,LOW(0x19)
	BRLO _0x66
;     676 			{
;     677 			char i;
;     678 			adc_cntA=0;
	RCALL SUBOPT_0x7
;	i -> Y+0
	STS  _adc_cntA,R30
;     679 			adc_bankU_[0]=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _adc_bankU_,R30
	STS  _adc_bankU_+1,R31
;     680 			for(i=0;i<25;i++)
	RCALL SUBOPT_0x8
_0x68:
	RCALL SUBOPT_0x9
	BRSH _0x69
;     681 				{
;     682 				adc_bankU_[0]+=adc_bankU[0,i];
	LDI  R26,LOW(_adc_bankU_)
	LDI  R27,HIGH(_adc_bankU_)
	PUSH R27
	PUSH R26
	RCALL __GETW1P
	PUSH R31
	PUSH R30
	LD   R30,Y
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0xA
	POP  R26
	POP  R27
	ADD  R30,R26
	ADC  R31,R27
	POP  R26
	POP  R27
	RCALL __PUTWP1
;     683 				}
	RCALL SUBOPT_0xB
	RJMP _0x68
_0x69:
;     684 			adc_bankU_[0]/=25;	
	LDI  R26,LOW(_adc_bankU_)
	LDI  R27,HIGH(_adc_bankU_)
	PUSH R27
	PUSH R26
	RCALL SUBOPT_0xC
	POP  R26
	POP  R27
	RCALL SUBOPT_0xD
;     685 			}	
;     686 		}
_0x66:
;     687 	//adc_bankU_[0]		          
;     688 	}  
_0x63:
_0x62:
;     689 if(input_index==2)
_0x5A:
	LDS  R26,_input_index_SD
	CPI  R26,LOW(0x2)
	BREQ PC+2
	RJMP _0x6A
;     690 	{
;     691  	if((adc_data>100)&&!bB_)
	RCALL SUBOPT_0x1
	BRSH _0x6C
	SBIS 0x1E,7
	RJMP _0x6D
_0x6C:
	RJMP _0x6B
_0x6D:
;     692     		{
;     693     		bB_=1;
	SBI  0x1E,7
;     694     		cnt_x++;
	RCALL SUBOPT_0x2
;     695     		cher[0]=cnt_x;
	LDS  R30,_cnt_x
	STS  _cher,R30
;     696    // 		cnt_x=2;
;     697     		if(cnt_x==2)
	LDS  R26,_cnt_x
	CPI  R26,LOW(0x2)
	BRNE _0x6E
;     698     			{
;     699     			if(cher_cnt<50)
	RCALL SUBOPT_0xE
	BRGE _0x6F
;     700 				{
;     701 				cher_cnt++;
	LDS  R30,_cher_cnt
	LDS  R31,_cher_cnt+1
	ADIW R30,1
	STS  _cher_cnt,R30
	STS  _cher_cnt+1,R31
;     702 				if((cher_cnt>=50)/*&&reset_cnt*/) bCHER_=1;//cher_alarm(0);
	RCALL SUBOPT_0xE
	BRLT _0x70
	SBI  0x2A,6
;     703 		     	}
_0x70:
;     704     			}
_0x6F:
;     705     		else
	RJMP _0x71
_0x6E:
;     706     			{
;     707     			if(cher_cnt)
	RCALL SUBOPT_0xF
	BREQ _0x72
;     708 				{
;     709 				cher_cnt--;
	LDS  R30,_cher_cnt
	LDS  R31,_cher_cnt+1
	SBIW R30,1
	STS  _cher_cnt,R30
	STS  _cher_cnt+1,R31
;     710 				if((cher_cnt==0)/*&&reset_cnt*/) bCHER_=0;//cher_alarm(1);
	RCALL SUBOPT_0xF
	BRNE _0x73
	CBI  0x2A,6
;     711 		     	}
_0x73:
;     712     			}
_0x72:
_0x71:
;     713   //  		bCHER_=0;			 
;     714     		}
;     715     	if((adc_data<100)&&bB_)
_0x6B:
	RCALL SUBOPT_0x3
	BRSH _0x75
	SBIC 0x1E,7
	RJMP _0x76
_0x75:
	RJMP _0x74
_0x76:
;     716     		{
;     717     		bB_=0;
	CBI  0x1E,7
;     718     		}	
;     719 	
;     720  	if(adc_data>10)
_0x74:
	RCALL SUBOPT_0x4
	BRSH _0x77
;     721 		{
;     722 		bankB+=adc_data;
	LDS  R30,_adc_data
	LDS  R31,_adc_data+1
	__ADDWRR 11,12,30,31
;     723 		pcnt[1]=10;
	LDI  R30,LOW(10)
	__PUTB1MN _pcnt,1
;     724 		bB=1;
	SBI  0x2A,2
;     725 		}
;     726 	else if((adc_data<=30)&&bB)
	RJMP _0x78
_0x77:
	RCALL SUBOPT_0x10
	BRLO _0x7A
	SBIC 0x2A,2
	RJMP _0x7B
_0x7A:
	RJMP _0x79
_0x7B:
;     727 		{
;     728 		bB=0;
	CBI  0x2A,2
;     729 		adc_bankU[1,adc_cntB]=bankB/10;
	__POINTW2MN _adc_bankU,50
	LDS  R30,_adc_cntB
	RCALL SUBOPT_0x11
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	__GETW2R 11,12
	RCALL SUBOPT_0x6
	POP  R26
	POP  R27
	RCALL __PUTWP1
;     730 		bankB=0;
	CLR  R11
	CLR  R12
;     731 		if(++adc_cntB>=25) 
	LDS  R26,_adc_cntB
	SUBI R26,-LOW(1)
	STS  _adc_cntB,R26
	CPI  R26,LOW(0x19)
	BRLO _0x7C
;     732 			{
;     733 			char i;
;     734 			adc_cntB=0;
	RCALL SUBOPT_0x7
;	i -> Y+0
	STS  _adc_cntB,R30
;     735 			adc_bankU_[1]=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _adc_bankU_,2
;     736 			for(i=0;i<25;i++)
	RCALL SUBOPT_0x8
_0x7E:
	RCALL SUBOPT_0x9
	BRSH _0x7F
;     737 				{
;     738 				adc_bankU_[1]+=adc_bankU[1,i];
	__POINTW2MN _adc_bankU_,2
	PUSH R27
	PUSH R26
	RCALL __GETW1P
	PUSH R31
	PUSH R30
	__POINTW2MN _adc_bankU,50
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0xA
	POP  R26
	POP  R27
	ADD  R30,R26
	ADC  R31,R27
	POP  R26
	POP  R27
	RCALL __PUTWP1
;     739 				}
	RCALL SUBOPT_0xB
	RJMP _0x7E
_0x7F:
;     740 			adc_bankU_[1]/=25;	
	__POINTW2MN _adc_bankU_,2
	PUSH R27
	PUSH R26
	RCALL SUBOPT_0xC
	POP  R26
	POP  R27
	RCALL SUBOPT_0xD
;     741 			}	
;     742 		}	
_0x7C:
;     743 	} 
_0x79:
_0x78:
;     744 		
;     745 if(input_index==0)
_0x6A:
	LDS  R30,_input_index_SD
	CPI  R30,0
	BREQ PC+2
	RJMP _0x80
;     746 	{
;     747 	if((adc_data>100)&&!bC_)
	RCALL SUBOPT_0x1
	BRSH _0x82
	SBIS 0x2A,0
	RJMP _0x83
_0x82:
	RJMP _0x81
_0x83:
;     748     			{
;     749     			bC_=1;
	SBI  0x2A,0
;     750     			cnt_x=0;
	LDI  R30,LOW(0)
	STS  _cnt_x,R30
;     751     			}
;     752     		if((adc_data<100)&&bC_)
_0x81:
	RCALL SUBOPT_0x3
	BRSH _0x85
	SBIC 0x2A,0
	RJMP _0x86
_0x85:
	RJMP _0x84
_0x86:
;     753     			{
;     754     			bC_=0;
	CBI  0x2A,0
;     755     			}	
;     756 	
;     757 	if(adc_data>30)
_0x84:
	RCALL SUBOPT_0x10
	BRSH _0x87
;     758 		{
;     759 		bankC+=adc_data;
	LDS  R30,_adc_data
	LDS  R31,_adc_data+1
	__ADDWRR 13,14,30,31
;     760 		pcnt[2]=10;
	LDI  R30,LOW(10)
	__PUTB1MN _pcnt,2
;     761 		bC=1;
	SBI  0x2A,3
;     762 		}
;     763 	else if((adc_data<=30)&&bC)
	RJMP _0x88
_0x87:
	RCALL SUBOPT_0x10
	BRLO _0x8A
	SBIC 0x2A,3
	RJMP _0x8B
_0x8A:
	RJMP _0x89
_0x8B:
;     764 		{
;     765 		bC=0;
	CBI  0x2A,3
;     766 		adc_bankU[2,adc_cntC]=bankC/10;
	__POINTW2MN _adc_bankU,100
	LDS  R30,_adc_cntC
	RCALL SUBOPT_0x11
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	__GETW2R 13,14
	RCALL SUBOPT_0x6
	POP  R26
	POP  R27
	RCALL __PUTWP1
;     767 		bankC=0;
	CLR  R13
	CLR  R14
;     768 		if(++adc_cntC>=25) 
	LDS  R26,_adc_cntC
	SUBI R26,-LOW(1)
	STS  _adc_cntC,R26
	CPI  R26,LOW(0x19)
	BRLO _0x8C
;     769 			{
;     770 			char i;
;     771 			adc_cntC=0;
	RCALL SUBOPT_0x7
;	i -> Y+0
	STS  _adc_cntC,R30
;     772 			adc_bankU_[2]=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _adc_bankU_,4
;     773 			for(i=0;i<25;i++)
	RCALL SUBOPT_0x8
_0x8E:
	RCALL SUBOPT_0x9
	BRSH _0x8F
;     774 				{
;     775 				adc_bankU_[2]+=adc_bankU[2,i];
	__POINTW2MN _adc_bankU_,4
	PUSH R27
	PUSH R26
	RCALL __GETW1P
	PUSH R31
	PUSH R30
	__POINTW2MN _adc_bankU,100
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0xA
	POP  R26
	POP  R27
	ADD  R30,R26
	ADC  R31,R27
	POP  R26
	POP  R27
	RCALL __PUTWP1
;     776 				}
	RCALL SUBOPT_0xB
	RJMP _0x8E
_0x8F:
;     777 			adc_bankU_[2]/=25;	
	__POINTW2MN _adc_bankU_,4
	PUSH R27
	PUSH R26
	RCALL SUBOPT_0xC
	POP  R26
	POP  R27
	RCALL SUBOPT_0xD
;     778 			}	
;     779 		}	
_0x8C:
;     780 	}
_0x89:
_0x88:
;     781 
;     782 #asm("sei")
_0x80:
	sei
;     783 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;     784 
;     785 //===============================================
;     786 //===============================================
;     787 //===============================================
;     788 //===============================================
;     789 void main(void)
;     790 {
_main:
;     791 // Crystal Oscillator division factor: 8
;     792 CLKPR=0x80;
	LDI  R30,LOW(128)
;     793 CLKPR=0x03;
	LDI  R30,LOW(3)
;     794 
;     795 /*PORTC=0;
;     796 DDRC&=0xFE;*/
;     797 /*#ifdef DEBUG
;     798 UCSRA=0x02;
;     799 UCSRB=0xD8;
;     800 UCSRC=0x86;
;     801 UBRRH=0x00;
;     802 UBRRL=0x18; 
;     803 #endif  */
;     804 /*
;     805 #ifdef RELEASE
;     806 UCSRA=0x00;
;     807 UCSRB=0xD0;
;     808 UCSRC=0x00;
;     809 UBRRH=0x00;
;     810 UBRRL=0x00; 
;     811 #endif
;     812 */
;     813 #ifdef DEBUG
;     814 PORTB=0x00;
;     815 DDRB=0xB0;
;     816 DDRB|=0b00101100;
;     817 
;     818 PORTC=0x00;
;     819 DDRC=0x00;
;     820 
;     821 PORTD=0x00;
;     822 DDRD=0x02;
;     823 #endif 
;     824 
;     825 #ifdef RELEASE
;     826 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;     827 DDRC=0x00;
	OUT  0x14,R30
;     828 
;     829 PORTD=0x00;
	OUT  0x12,R30
;     830 DDRD=0x02;
	LDI  R30,LOW(2)
	OUT  0x11,R30
;     831 #endif 
;     832 /*
;     833 ASSR=0;
;     834 OCR2=0;*/
;     835 
;     836 // ADC initialization
;     837 
;     838 ADMUX=0b01000011;
	LDI  R30,LOW(67)
	OUT  0x7,R30
;     839 ADCSRA=0xCC;
	LDI  R30,LOW(204)
	OUT  0x6,R30
;     840 
;     841 t0_init();
	RCALL _t0_init
;     842 //t2_init(); 
;     843 del_init();
	RCALL _del_init
;     844 
;     845 // Timer/Counter 0 Interrupt(s) initialization
;     846 TIMSK0=0x02;
	LDI  R30,LOW(2)
;     847 // Timer/Counter 1 Interrupt(s) initialization
;     848 TIMSK1=0x00;
	RCALL SUBOPT_0x0
;     849 // Timer/Counter 2 Interrupt(s) initialization
;     850 TIMSK2=0x00;
;     851 
;     852 #asm("sei")
	sei
;     853 
;     854 bCHER_=0;
	CBI  0x2A,6
;     855 ind=iMn;
	LDI  R30,LOW(0)
	STS  _ind,R30
;     856 
;     857 while (1)
_0x90:
;     858 	{
;     859 #ifdef DEBUG
;     860 	UART_IN();
;     861 #endif
;     862 	if(b100Hz)
	SBIS 0x1E,1
	RJMP _0x93
;     863 		{
;     864 		b100Hz=0;
	CBI  0x1E,1
;     865 
;     866 /*		but_drv();
;     867 		but_an();
;     868 		pcnt_hndl();*/
;     869 		}   
;     870 	if(b10Hz)
_0x93:
	SBIS 0x1E,2
	RJMP _0x94
;     871 		{
;     872 		b10Hz=0;
	CBI  0x1E,2
;     873 /*		ind_hndl();
;     874 
;     875 	 	out_out(); */
;     876 		}
;     877 	if(b5Hz)
_0x94:
	SBIS 0x1E,3
	RJMP _0x95
;     878 		{
;     879 		b5Hz=0;
	CBI  0x1E,3
;     880 /*	  	per_drv();
;     881 	  	nn_drv();
;     882 
;     883 	  	
;     884 		deltas=delta;   */
;     885 			
;     886 		}
;     887 	if(b2Hz)
_0x95:
	SBIS 0x1E,4
	RJMP _0x96
;     888 		{
;     889 		b2Hz=0;
	CBI  0x1E,4
;     890 		}		 
;     891     	if(b1Hz)
_0x96:
	SBIS 0x1E,5
	RJMP _0x97
;     892 		{
;     893 		b1Hz=0;
	CBI  0x1E,5
;     894 /*		del_hndl();
;     895 		per_hndl();
;     896 		nn_hndl(); */ 
;     897      	}
;     898      #asm("wdr")	
_0x97:
	wdr
;     899 	}
	RJMP _0x90
;     900 }
_0x98:
	RJMP _0x98

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x1:
	LDS  R26,_adc_data
	LDS  R27,_adc_data+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2:
	LDS  R30,_cnt_x
	SUBI R30,-LOW(1)
	STS  _cnt_x,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x3:
	LDS  R26,_adc_data
	LDS  R27,_adc_data+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x4:
	LDS  R26,_adc_data
	LDS  R27,_adc_data+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5:
	LDI  R26,LOW(_adc_bankU)
	LDI  R27,HIGH(_adc_bankU)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x6:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x7:
	SBIW R28,1
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x8:
	LDI  R30,LOW(0)
	ST   Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x9:
	LD   R26,Y
	CPI  R26,LOW(0x19)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xA:
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xB:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xC:
	RCALL __GETW1P
	MOVW R26,R30
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	RCALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xD:
	RCALL __PUTWP1
	ADIW R28,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE:
	LDS  R26,_cher_cnt
	LDS  R27,_cher_cnt+1
	CPI  R26,LOW(0x32)
	LDI  R30,HIGH(0x32)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF:
	LDS  R30,_cher_cnt
	LDS  R31,_cher_cnt+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x10:
	LDS  R26,_adc_data
	LDS  R27,_adc_data+1
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x11:
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x12:
	LD   R30,Y
	RJMP SUBOPT_0x11

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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__PUTWP1:
	ST   X+,R30
	ST   X,R31
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

