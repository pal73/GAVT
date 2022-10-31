
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 1,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': No
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

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

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
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

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
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

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
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

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
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

	.MACRO __PUTBSR
	STD  Y+@1,R@0
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
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
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

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
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
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
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

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
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
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _t0_cnt0=R8
	.DEF _t0_cnt1=R7
	.DEF _t0_cnt2=R10
	.DEF _t0_cnt3=R9
	.DEF _t0_cnt4=R11
	.DEF _t0_cnt4_msb=R12
	.DEF _ind_cnt=R14
	.DEF _but=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _adc_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_DIGISYM:
	.DB  0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8
	.DB  0x80,0x90,0xFF

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000
	.DW  0x0000
	.DW  0x0000

_0x3:
	.DB  0x55,0x55,0x55,0x55,0x55

__GLOBAL_INI_TBL:
	.DW  0x05
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x05
	.DW  _ind_out
	.DW  _0x3*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

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
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
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

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#define LED_POW_ON	5
;#define LED_MAIN_LOOP	1
;
;#define LED_NAPOLN	2
;#define LED_PAYKA	3
;#define LED_ERROR	0
;#define LED_WRK	6
;#define LED_LOOP_AUTO	7
;#define LED_PROG4	1
;#define LED_PROG2	2
;#define LED_PROG3	3
;#define LED_PROG1	4
;#define MAXPROG	1
;
;#define PIN_START   0
;#define PIN_STOP    1
;#define PIN_MD1     2
;#define PIN_BOTL    3
;#define PIN_PUMP    4
;#define PIN_AVT     5
;
;//#define SW1	6
;//#define SW2	7
;
;#define PP1	6
;#define PP2	7
;
;
;bit b600Hz;
;
;bit b100Hz;
;bit b10Hz;
;bit b1Hz;
;char t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3;
;short t0_cnt4;
;char ind_cnt;
;flash char IND_STROB[]={0b10111111,0b11011111,0b11101111,0b11110111,0b01111111};
;flash char DIGISYM[]={0b11000000,0b11111001,0b10100100,0b10110000,0b10011001,0b10010010,0b10000010,0b11111000,0b10000000 ...
;
;char ind_out[5]={0x255,0x255,0x255,0x255,0x255};

	.DSEG
;char dig[4];
;bit bZ;
;char but;
;static char but_n;
;static char but_s;
;static char but0_cnt;
;static char but1_cnt;
;static char but_onL_temp;
;bit l_but;		//идет длинное нажатие на кнопку
;bit n_but;          //произошло нажатие
;bit speed;		//разрешение ускорени€ перебора
;bit bFL2;
;bit bFL5;
;eeprom enum{elmAUTO=0x55,elmMNL=0xaa}ee_loop_mode;
;//eeprom char ee_program[2];
;eeprom enum {p1=1,p2=2,p3=3,p4=4}ee_prog;
;enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}step=sOFF;
;enum {iMn,iPr_sel,iSet} ind;
;char sub_ind;
;char in_word,in_word_old,in_word_new,in_word_cnt;
;bit bERR;
;signed int cnt_del=0;
;
;//bit bSW1,bSW2;
;
;bit bSTART, bSTOP, bMD1, bBOTL, bBOTL_OLD, bBOTL_CH, bPUMP, bPUMP_OFF, bPUMP_OLD, bAVT, bSTOP_PROCESS, bSTOP_LONG;
;//char cnt_sw1,cnt_sw2;
;
;//eeprom unsigned ee_delay[4,2];
;//eeprom char ee_vr_log;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;//#include <mega8535.h>
;
;bit bPP1,bPP2,bPP3,bPP4,bPP5,bPP6,bPP7,bPP8;
;
;//enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}payka_step=sOFF,napoln_step=sOFF,orien ...
;enum{cmdOFF=0,cmdSTART,cmdSTOP}payka_cmd=cmdOFF,napoln_cmd=cmdOFF,orient_cmd=cmdOFF,main_loop_cmd=cmdOFF;
;signed short payka_cnt_del,napoln_cnt_del,orient_cnt_del,main_loop_cnt_del;
;eeprom signed short ee_temp1,ee_temp2;
;
;bit bPAYKA_COMPLETE=0,bNAPOLN_COMPLETE=0,bORIENT_COMPLETE=0;
;
;eeprom signed short ee_temp3,ee_temp4;
;
;#define EE_PROG_FULL		0
;#define EE_PROG_ONLY_ORIENT 	1
;#define EE_PROG_ONLY_NAPOLN	2
;#define EE_PROG_ONLY_PAYKA	3
;#define EE_PROG_ONLY_MAIN_LOOP 	4
;
;short time_cnt;
;short adc_output;
;
;#define FIRST_ADC_INPUT 2
;#define LAST_ADC_INPUT 2
;unsigned int adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
;#define ADC_VREF_TYPE 0x40
;// ADC interrupt service routine
;// with auto input scanning
;
;short pump_cntrl_cnt;
;
;short cnt_start, cnt_stop, cnt_md1, cnt_botl, cnt_pump, cnt_avt, cnt_stop_long;
;
;bit bLED_G, bLED_Y;
;
;short stop_process_cnt;
;short step_max_cnt;
;//-----------------------------------------------
;void prog_drv(void)
; 0000 006F {

	.CSEG
_prog_drv:
; .FSTART _prog_drv
; 0000 0070 char temp,temp1,temp2;
; 0000 0071 
; 0000 0072 ///temp=ee_program[0];
; 0000 0073 ///temp1=ee_program[1];
; 0000 0074 ///temp2=ee_program[2];
; 0000 0075 
; 0000 0076 if((temp==temp1)&&(temp==temp2))
	CALL __SAVELOCR4
;	temp -> R17
;	temp1 -> R16
;	temp2 -> R19
	CP   R16,R17
	BRNE _0x5
	CP   R19,R17
	BREQ _0x6
_0x5:
	RJMP _0x4
_0x6:
; 0000 0077 	{
; 0000 0078 	}
; 0000 0079 else if((temp==temp1)&&(temp!=temp2))
	RJMP _0x7
_0x4:
	CP   R16,R17
	BRNE _0x9
	CP   R19,R17
	BRNE _0xA
_0x9:
	RJMP _0x8
_0xA:
; 0000 007A 	{
; 0000 007B 	temp2=temp;
	MOV  R19,R17
; 0000 007C 	}
; 0000 007D else if((temp!=temp1)&&(temp==temp2))
	RJMP _0xB
_0x8:
	CP   R16,R17
	BREQ _0xD
	CP   R19,R17
	BREQ _0xE
_0xD:
	RJMP _0xC
_0xE:
; 0000 007E 	{
; 0000 007F 	temp1=temp;
	MOV  R16,R17
; 0000 0080 	}
; 0000 0081 else if((temp!=temp1)&&(temp1==temp2))
	RJMP _0xF
_0xC:
	CP   R16,R17
	BREQ _0x11
	CP   R19,R16
	BREQ _0x12
_0x11:
	RJMP _0x10
_0x12:
; 0000 0082 	{
; 0000 0083 	temp=temp1;
	MOV  R17,R16
; 0000 0084 	}
; 0000 0085 else if((temp!=temp1)&&(temp!=temp2))
_0x10:
; 0000 0086 	{
; 0000 0087 ////	temp=MINPROG;
; 0000 0088 ////	temp1=MINPROG;
; 0000 0089 ////	temp2=MINPROG;
; 0000 008A 	}
; 0000 008B 
; 0000 008C ////if(!((temp<=MAXPROG)&&(temp>=MINPROG)))
; 0000 008D ////	{
; 0000 008E ////	temp=MINPROG;
; 0000 008F ////	}
; 0000 0090 
; 0000 0091 ///if(temp!=ee_program[0])ee_program[0]=temp;
; 0000 0092 ///if(temp!=ee_program[1])ee_program[1]=temp;
; 0000 0093 ///if(temp!=ee_program[2])ee_program[2]=temp;
; 0000 0094 
; 0000 0095 
; 0000 0096 }
_0x13:
_0xF:
_0xB:
_0x7:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;
;//-----------------------------------------------
;void in_drv(void)
; 0000 009A {
; 0000 009B char i,temp;
; 0000 009C unsigned int tempUI;
; 0000 009D DDRA=0x00;
;	i -> R17
;	temp -> R16
;	tempUI -> R18,R19
; 0000 009E PORTA=0xff;
; 0000 009F in_word_new=PINA;
; 0000 00A0 if(in_word_old==in_word_new)
; 0000 00A1 	{
; 0000 00A2 	if(in_word_cnt<10)
; 0000 00A3 		{
; 0000 00A4 		in_word_cnt++;
; 0000 00A5 		if(in_word_cnt>=10)
; 0000 00A6 			{
; 0000 00A7 			in_word=in_word_old;
; 0000 00A8 			}
; 0000 00A9 		}
; 0000 00AA 	}
; 0000 00AB else in_word_cnt=0;
; 0000 00AC 
; 0000 00AD 
; 0000 00AE in_word_old=in_word_new;
; 0000 00AF }
;
;//-----------------------------------------------
;void err_drv(void)
; 0000 00B3 {
; 0000 00B4 /*if(ee_prog==p1)
; 0000 00B5 	{
; 0000 00B6      if(bSW1^bSW2) bERR=1;
; 0000 00B7  	else bERR=0;
; 0000 00B8 	}
; 0000 00B9 else bERR=0;*/
; 0000 00BA }
;
;
;//-----------------------------------------------
;void in_an(void)
; 0000 00BF {
_in_an:
; .FSTART _in_an
; 0000 00C0 DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 00C1 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 00C2 in_word=PINA;
	IN   R30,0x19
	STS  _in_word,R30
; 0000 00C3 
; 0000 00C4 
; 0000 00C5 
; 0000 00C6 if(!(in_word&(1<<PIN_START)))
	ANDI R30,LOW(0x1)
	BRNE _0x1B
; 0000 00C7 	{
; 0000 00C8 	if(cnt_start<10)
	LDS  R26,_cnt_start
	LDS  R27,_cnt_start+1
	SBIW R26,10
	BRGE _0x1C
; 0000 00C9 		{
; 0000 00CA 		cnt_start++;
	LDI  R26,LOW(_cnt_start)
	LDI  R27,HIGH(_cnt_start)
	RCALL SUBOPT_0x0
; 0000 00CB 		if(cnt_start==10) bSTART=1;
	LDS  R26,_cnt_start
	LDS  R27,_cnt_start+1
	SBIW R26,10
	BRNE _0x1D
	SET
	BLD  R3,3
; 0000 00CC 		}
_0x1D:
; 0000 00CD     //bSTART=1;
; 0000 00CE 	}
_0x1C:
; 0000 00CF else
	RJMP _0x1E
_0x1B:
; 0000 00D0 	{
; 0000 00D1 	if(cnt_start)
	LDS  R30,_cnt_start
	LDS  R31,_cnt_start+1
	SBIW R30,0
	BREQ _0x1F
; 0000 00D2 		{
; 0000 00D3 		cnt_start--;
	LDI  R26,LOW(_cnt_start)
	LDI  R27,HIGH(_cnt_start)
	RCALL SUBOPT_0x1
; 0000 00D4 		if(cnt_start==0) bSTART=0;
	LDS  R30,_cnt_start
	LDS  R31,_cnt_start+1
	SBIW R30,0
	BRNE _0x20
	CLT
	BLD  R3,3
; 0000 00D5 		}
_0x20:
; 0000 00D6     //bSTART=0;
; 0000 00D7 	}
_0x1F:
_0x1E:
; 0000 00D8 
; 0000 00D9 
; 0000 00DA 
; 0000 00DB if(!(in_word&(1<<PIN_STOP)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x2)
	BRNE _0x21
; 0000 00DC 	{
; 0000 00DD 	if(cnt_stop<10)
	LDS  R26,_cnt_stop
	LDS  R27,_cnt_stop+1
	SBIW R26,10
	BRGE _0x22
; 0000 00DE 		{
; 0000 00DF 		cnt_stop++;
	LDI  R26,LOW(_cnt_stop)
	LDI  R27,HIGH(_cnt_stop)
	RCALL SUBOPT_0x0
; 0000 00E0 		if(cnt_stop==10) bSTOP=1;
	LDS  R26,_cnt_stop
	LDS  R27,_cnt_stop+1
	SBIW R26,10
	BRNE _0x23
	SET
	BLD  R3,4
; 0000 00E1 		}
_0x23:
; 0000 00E2 
; 0000 00E3 	}
_0x22:
; 0000 00E4 else
	RJMP _0x24
_0x21:
; 0000 00E5 	{
; 0000 00E6 	if(cnt_stop)
	LDS  R30,_cnt_stop
	LDS  R31,_cnt_stop+1
	SBIW R30,0
	BREQ _0x25
; 0000 00E7 		{
; 0000 00E8 		cnt_stop--;
	LDI  R26,LOW(_cnt_stop)
	LDI  R27,HIGH(_cnt_stop)
	RCALL SUBOPT_0x1
; 0000 00E9 		if(cnt_stop==0) bSTOP=0;
	LDS  R30,_cnt_stop
	LDS  R31,_cnt_stop+1
	SBIW R30,0
	BRNE _0x26
	CLT
	BLD  R3,4
; 0000 00EA 		}
_0x26:
; 0000 00EB 
; 0000 00EC 	}
_0x25:
_0x24:
; 0000 00ED 
; 0000 00EE if(!(in_word&(1<<PIN_STOP)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x2)
	BRNE _0x27
; 0000 00EF 	{
; 0000 00F0 	if(cnt_stop_long<2400)
	RCALL SUBOPT_0x2
	BRGE _0x28
; 0000 00F1 		{
; 0000 00F2 		cnt_stop_long++;
	LDI  R26,LOW(_cnt_stop_long)
	LDI  R27,HIGH(_cnt_stop_long)
	RCALL SUBOPT_0x0
; 0000 00F3 		if(cnt_stop_long==2400) bSTOP_LONG=1;
	RCALL SUBOPT_0x2
	BRNE _0x29
	SET
	BLD  R4,6
; 0000 00F4 		}
_0x29:
; 0000 00F5 
; 0000 00F6 	}
_0x28:
; 0000 00F7 else
	RJMP _0x2A
_0x27:
; 0000 00F8 	{
; 0000 00F9 	if(cnt_stop_long)
	LDS  R30,_cnt_stop_long
	LDS  R31,_cnt_stop_long+1
	SBIW R30,0
	BREQ _0x2B
; 0000 00FA 		{
; 0000 00FB 		cnt_stop_long--;
	LDI  R26,LOW(_cnt_stop_long)
	LDI  R27,HIGH(_cnt_stop_long)
	RCALL SUBOPT_0x1
; 0000 00FC 		if(cnt_stop_long==0) bSTOP_LONG=0;
	LDS  R30,_cnt_stop_long
	LDS  R31,_cnt_stop_long+1
	SBIW R30,0
	BRNE _0x2C
	CLT
	BLD  R4,6
; 0000 00FD 		}
_0x2C:
; 0000 00FE 
; 0000 00FF 	}
_0x2B:
_0x2A:
; 0000 0100 
; 0000 0101 if(!(in_word&(1<<PIN_MD1)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x4)
	BRNE _0x2D
; 0000 0102 	{
; 0000 0103 	if(cnt_md1<10)
	LDS  R26,_cnt_md1
	LDS  R27,_cnt_md1+1
	SBIW R26,10
	BRGE _0x2E
; 0000 0104 		{
; 0000 0105 		cnt_md1++;
	LDI  R26,LOW(_cnt_md1)
	LDI  R27,HIGH(_cnt_md1)
	RCALL SUBOPT_0x0
; 0000 0106 		if(cnt_md1==10) bMD1=1;
	LDS  R26,_cnt_md1
	LDS  R27,_cnt_md1+1
	SBIW R26,10
	BRNE _0x2F
	SET
	BLD  R3,5
; 0000 0107 		}
_0x2F:
; 0000 0108 
; 0000 0109 	}
_0x2E:
; 0000 010A else
	RJMP _0x30
_0x2D:
; 0000 010B 	{
; 0000 010C 	if(cnt_md1)
	LDS  R30,_cnt_md1
	LDS  R31,_cnt_md1+1
	SBIW R30,0
	BREQ _0x31
; 0000 010D 		{
; 0000 010E 		cnt_md1--;
	LDI  R26,LOW(_cnt_md1)
	LDI  R27,HIGH(_cnt_md1)
	RCALL SUBOPT_0x1
; 0000 010F 		if(cnt_md1==0) bMD1=0;
	LDS  R30,_cnt_md1
	LDS  R31,_cnt_md1+1
	SBIW R30,0
	BRNE _0x32
	CLT
	BLD  R3,5
; 0000 0110 		}
_0x32:
; 0000 0111 
; 0000 0112 	}
_0x31:
_0x30:
; 0000 0113 
; 0000 0114 if(!(in_word&(1<<PIN_BOTL)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x8)
	BRNE _0x33
; 0000 0115 	{
; 0000 0116 	if(cnt_botl<10)
	LDS  R26,_cnt_botl
	LDS  R27,_cnt_botl+1
	SBIW R26,10
	BRGE _0x34
; 0000 0117 		{
; 0000 0118 		cnt_botl++;
	LDI  R26,LOW(_cnt_botl)
	LDI  R27,HIGH(_cnt_botl)
	RCALL SUBOPT_0x0
; 0000 0119 		if(cnt_botl==10) bBOTL=1;
	LDS  R26,_cnt_botl
	LDS  R27,_cnt_botl+1
	SBIW R26,10
	BRNE _0x35
	SET
	BLD  R3,6
; 0000 011A 		}
_0x35:
; 0000 011B 
; 0000 011C 	}
_0x34:
; 0000 011D else
	RJMP _0x36
_0x33:
; 0000 011E 	{
; 0000 011F 	if(cnt_botl)
	LDS  R30,_cnt_botl
	LDS  R31,_cnt_botl+1
	SBIW R30,0
	BREQ _0x37
; 0000 0120 		{
; 0000 0121 		cnt_botl--;
	LDI  R26,LOW(_cnt_botl)
	LDI  R27,HIGH(_cnt_botl)
	RCALL SUBOPT_0x1
; 0000 0122 		if(cnt_botl==0) bBOTL=0;
	LDS  R30,_cnt_botl
	LDS  R31,_cnt_botl+1
	SBIW R30,0
	BRNE _0x38
	CLT
	BLD  R3,6
; 0000 0123 		}
_0x38:
; 0000 0124 
; 0000 0125 	}
_0x37:
_0x36:
; 0000 0126 
; 0000 0127 if((bBOTL_OLD!=bBOTL) && (bBOTL))
	LDI  R26,0
	SBRC R3,7
	LDI  R26,1
	LDI  R30,0
	SBRC R3,6
	LDI  R30,1
	CP   R30,R26
	BREQ _0x3A
	SBRC R3,6
	RJMP _0x3B
_0x3A:
	RJMP _0x39
_0x3B:
; 0000 0128     {
; 0000 0129     bBOTL_CH=1;
	SET
	BLD  R4,0
; 0000 012A     }
; 0000 012B bBOTL_OLD=bBOTL;
_0x39:
	BST  R3,6
	BLD  R3,7
; 0000 012C 
; 0000 012D if(!(in_word&(1<<PIN_PUMP)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x10)
	BRNE _0x3C
; 0000 012E 	{
; 0000 012F 	if(cnt_pump<5)
	LDS  R26,_cnt_pump
	LDS  R27,_cnt_pump+1
	SBIW R26,5
	BRGE _0x3D
; 0000 0130 		{
; 0000 0131 		cnt_pump++;
	LDI  R26,LOW(_cnt_pump)
	LDI  R27,HIGH(_cnt_pump)
	RCALL SUBOPT_0x0
; 0000 0132 		if(cnt_pump==5) bPUMP=1;
	LDS  R26,_cnt_pump
	LDS  R27,_cnt_pump+1
	SBIW R26,5
	BRNE _0x3E
	SET
	BLD  R4,1
; 0000 0133 		}
_0x3E:
; 0000 0134 
; 0000 0135 	}
_0x3D:
; 0000 0136 else
	RJMP _0x3F
_0x3C:
; 0000 0137 	{
; 0000 0138 	if(cnt_pump)
	LDS  R30,_cnt_pump
	LDS  R31,_cnt_pump+1
	SBIW R30,0
	BREQ _0x40
; 0000 0139 		{
; 0000 013A 		cnt_pump--;
	LDI  R26,LOW(_cnt_pump)
	LDI  R27,HIGH(_cnt_pump)
	RCALL SUBOPT_0x1
; 0000 013B 		if(cnt_pump==0) bPUMP=0;
	LDS  R30,_cnt_pump
	LDS  R31,_cnt_pump+1
	SBIW R30,0
	BRNE _0x41
	CLT
	BLD  R4,1
; 0000 013C 		}
_0x41:
; 0000 013D 
; 0000 013E 	}
_0x40:
_0x3F:
; 0000 013F 
; 0000 0140 if((bPUMP_OLD!=bPUMP) && (!bPUMP))
	LDI  R26,0
	SBRC R4,3
	LDI  R26,1
	LDI  R30,0
	SBRC R4,1
	LDI  R30,1
	CP   R30,R26
	BREQ _0x43
	SBRS R4,1
	RJMP _0x44
_0x43:
	RJMP _0x42
_0x44:
; 0000 0141     {
; 0000 0142     bPUMP_OFF=1;
	SET
	BLD  R4,2
; 0000 0143     }
; 0000 0144 bPUMP_OLD=bPUMP;
_0x42:
	BST  R4,1
	BLD  R4,3
; 0000 0145 
; 0000 0146 if(!(in_word&(1<<PIN_AVT)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x20)
	BRNE _0x45
; 0000 0147 	{
; 0000 0148 	if(cnt_avt<100)
	RCALL SUBOPT_0x3
	BRGE _0x46
; 0000 0149 		{
; 0000 014A 		cnt_avt++;
	LDI  R26,LOW(_cnt_avt)
	LDI  R27,HIGH(_cnt_avt)
	RCALL SUBOPT_0x0
; 0000 014B 		if(cnt_avt==100) bAVT=1;
	RCALL SUBOPT_0x3
	BRNE _0x47
	SET
	BLD  R4,4
; 0000 014C 		}
_0x47:
; 0000 014D 
; 0000 014E 	}
_0x46:
; 0000 014F else
	RJMP _0x48
_0x45:
; 0000 0150 	{
; 0000 0151 	if(cnt_avt)
	LDS  R30,_cnt_avt
	LDS  R31,_cnt_avt+1
	SBIW R30,0
	BREQ _0x49
; 0000 0152 		{
; 0000 0153 		cnt_avt--;
	LDI  R26,LOW(_cnt_avt)
	LDI  R27,HIGH(_cnt_avt)
	RCALL SUBOPT_0x1
; 0000 0154 		if(cnt_avt==0) bAVT=0;
	LDS  R30,_cnt_avt
	LDS  R31,_cnt_avt+1
	SBIW R30,0
	BRNE _0x4A
	CLT
	BLD  R4,4
; 0000 0155 		}
_0x4A:
; 0000 0156 
; 0000 0157 	}
_0x49:
_0x48:
; 0000 0158 
; 0000 0159 }
	RET
; .FEND
;
;//-----------------------------------------------
;void main_loop_hndl(void)
; 0000 015D {
; 0000 015E 
; 0000 015F }
;
;//-----------------------------------------------
;void pump_cntrl_drv(void)
; 0000 0163 {
; 0000 0164 DDRB|=0xf0;
; 0000 0165 if(pump_cntrl_cnt)
; 0000 0166     {
; 0000 0167     pump_cntrl_cnt--;
; 0000 0168     PORTB&=0x0f;
; 0000 0169     }
; 0000 016A else
; 0000 016B     {
; 0000 016C     PORTB|=0xF0;
; 0000 016D     }
; 0000 016E }
;
;
;//-----------------------------------------------
;void out_drv(void)
; 0000 0173 {
_out_drv:
; .FSTART _out_drv
; 0000 0174 char temp=0;
; 0000 0175 //DDRB|=0xF0;
; 0000 0176 
; 0000 0177 if(bPP1) temp|=(1<<PP1);
	ST   -Y,R17
;	temp -> R17
	LDI  R17,0
	SBRC R4,7
	ORI  R17,LOW(64)
; 0000 0178 if(bPP2) temp|=(1<<PP2);
	SBRC R5,0
	ORI  R17,LOW(128)
; 0000 0179 
; 0000 017A if(pump_cntrl_cnt)
	RCALL SUBOPT_0x4
	BREQ _0x4F
; 0000 017B     {
; 0000 017C     //pump_cntrl_cnt--;
; 0000 017D     temp|=(1<<5)|(1<<4);
	ORI  R17,LOW(48)
; 0000 017E     }
; 0000 017F 
; 0000 0180 
; 0000 0181 DDRB|=0xF0;
_0x4F:
	IN   R30,0x17
	ORI  R30,LOW(0xF0)
	OUT  0x17,R30
; 0000 0182 
; 0000 0183 PORTB=((PORTB|0xf0)&(~temp));
	IN   R30,0x18
	ORI  R30,LOW(0xF0)
	RJMP _0x2000001
; 0000 0184 //PORTB=0x55;
; 0000 0185 }
; .FEND
;
;//-----------------------------------------------
;void stop_process(void)
; 0000 0189 {
_stop_process:
; .FSTART _stop_process
; 0000 018A if(pump_cntrl_cnt) bSTOP_PROCESS=1;
	RCALL SUBOPT_0x4
	BREQ _0x50
	SET
	BLD  R4,5
; 0000 018B else
	RJMP _0x51
_0x50:
; 0000 018C     {
; 0000 018D     if(bPUMP)pump_cntrl_cnt=10;
	SBRC R4,1
	RCALL SUBOPT_0x5
; 0000 018E     step=sOFF;
	LDI  R30,LOW(0)
	STS  _step,R30
; 0000 018F     stop_process_cnt=0;
	STS  _stop_process_cnt,R30
	STS  _stop_process_cnt+1,R30
; 0000 0190     }
_0x51:
; 0000 0191 
; 0000 0192 }
	RET
; .FEND
;
;
;
;//-----------------------------------------------
;void stop_process_drv(void)
; 0000 0198 {
_stop_process_drv:
; .FSTART _stop_process_drv
; 0000 0199 if(bSTOP_PROCESS)
	SBRS R4,5
	RJMP _0x53
; 0000 019A     {
; 0000 019B     if(pump_cntrl_cnt)
	RCALL SUBOPT_0x4
	BREQ _0x54
; 0000 019C         {
; 0000 019D         stop_process_cnt=30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	STS  _stop_process_cnt,R30
	STS  _stop_process_cnt+1,R31
; 0000 019E         return;
	RET
; 0000 019F         }
; 0000 01A0     else
_0x54:
; 0000 01A1         {
; 0000 01A2         if(stop_process_cnt)
	LDS  R30,_stop_process_cnt
	LDS  R31,_stop_process_cnt+1
	SBIW R30,0
	BREQ _0x56
; 0000 01A3             {
; 0000 01A4             stop_process_cnt--;
	LDI  R26,LOW(_stop_process_cnt)
	LDI  R27,HIGH(_stop_process_cnt)
	RCALL SUBOPT_0x1
; 0000 01A5             if(stop_process_cnt==0)
	LDS  R30,_stop_process_cnt
	LDS  R31,_stop_process_cnt+1
	SBIW R30,0
	BRNE _0x57
; 0000 01A6                 {
; 0000 01A7                 bSTOP_PROCESS=0;
	CLT
	BLD  R4,5
; 0000 01A8                 if(bPUMP)  pump_cntrl_cnt=10;
	SBRC R4,1
	RCALL SUBOPT_0x5
; 0000 01A9                 }
; 0000 01AA             }
_0x57:
; 0000 01AB         }
_0x56:
; 0000 01AC     }
; 0000 01AD 
; 0000 01AE }
_0x53:
	RET
; .FEND
;
;//-----------------------------------------------
;void step_contr(void)
; 0000 01B2 {
_step_contr:
; .FSTART _step_contr
; 0000 01B3 if(bSTOP)
	SBRS R3,4
	RJMP _0x59
; 0000 01B4     {
; 0000 01B5     stop_process();
	RCALL _stop_process
; 0000 01B6     bSTOP=0;
	CLT
	BLD  R3,4
; 0000 01B7     }
; 0000 01B8 
; 0000 01B9 if(step==sOFF)
_0x59:
	LDS  R30,_step
	CPI  R30,0
	BRNE _0x5A
; 0000 01BA     {
; 0000 01BB     bPP1=0;
	RCALL SUBOPT_0x6
; 0000 01BC     bPP2=0;
; 0000 01BD     //pump_cntrl_cnt=0;
; 0000 01BE 
; 0000 01BF     if(bSTART)
	SBRS R3,3
	RJMP _0x5B
; 0000 01C0         {
; 0000 01C1         bSTART=0;
	CLT
	BLD  R3,3
; 0000 01C2         step=s1;
	RCALL SUBOPT_0x7
; 0000 01C3         step_max_cnt=200/*100*/;
; 0000 01C4         bBOTL_CH=0;
; 0000 01C5         }
; 0000 01C6 
; 0000 01C7     if(bSTOP_LONG)
_0x5B:
	SBRS R4,6
	RJMP _0x5C
; 0000 01C8         {
; 0000 01C9         bSTOP_LONG=0;
	CLT
	BLD  R4,6
; 0000 01CA         step=s10;
	LDI  R30,LOW(10)
	STS  _step,R30
; 0000 01CB         step_max_cnt=6000;
	LDI  R30,LOW(6000)
	LDI  R31,HIGH(6000)
	RCALL SUBOPT_0x8
; 0000 01CC 
; 0000 01CD         pump_cntrl_cnt=10;
	RCALL SUBOPT_0x5
; 0000 01CE         bPUMP_OFF=0;
	CLT
	BLD  R4,2
; 0000 01CF         }
; 0000 01D0 
; 0000 01D1     if(bPUMP) bPP2=1;
_0x5C:
	SBRS R4,1
	RJMP _0x5D
	SET
	BLD  R5,0
; 0000 01D2     }
_0x5D:
; 0000 01D3 
; 0000 01D4 else if(step==s1)   //продвижение бутылки (не дольше секунды)
	RJMP _0x5E
_0x5A:
	LDS  R26,_step
	CPI  R26,LOW(0x1)
	BRNE _0x5F
; 0000 01D5     {
; 0000 01D6     bPP1=1;
	SET
	BLD  R4,7
; 0000 01D7     bPP2=0;
	CLT
	BLD  R5,0
; 0000 01D8 
; 0000 01D9     if(step_max_cnt)
	RCALL SUBOPT_0x9
	BREQ _0x60
; 0000 01DA         {
; 0000 01DB         step_max_cnt--;
	RCALL SUBOPT_0xA
; 0000 01DC         if(step_max_cnt==0)step=sOFF;
	RCALL SUBOPT_0x9
	BRNE _0x61
	LDI  R30,LOW(0)
	STS  _step,R30
; 0000 01DD         }
_0x61:
; 0000 01DE 
; 0000 01DF     if(bMD1)
_0x60:
	SBRS R3,5
	RJMP _0x62
; 0000 01E0         {
; 0000 01E1         step=s2;
	LDI  R30,LOW(2)
	STS  _step,R30
; 0000 01E2         step_max_cnt=20;//1000/*100*/;
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x8
; 0000 01E3         }
; 0000 01E4 
; 0000 01E5     bPUMP_OFF=0;
_0x62:
	CLT
	BLD  R4,2
; 0000 01E6     }
; 0000 01E7 
; 0000 01E8 else if(step==s2)   //ожидание срабатывани€ датчика смены бутылки (не дольше секунды)
	RJMP _0x63
_0x5F:
	LDS  R26,_step
	CPI  R26,LOW(0x2)
	BRNE _0x64
; 0000 01E9     {
; 0000 01EA     bPP1=0;
	RCALL SUBOPT_0x6
; 0000 01EB     bPP2=0;
; 0000 01EC 
; 0000 01ED     if(step_max_cnt)
	RCALL SUBOPT_0x9
	BREQ _0x65
; 0000 01EE         {
; 0000 01EF         step_max_cnt--;
	RCALL SUBOPT_0xA
; 0000 01F0         if(step_max_cnt==0)step=sOFF;
	RCALL SUBOPT_0x9
	BRNE _0x66
	LDI  R30,LOW(0)
	STS  _step,R30
; 0000 01F1         }
_0x66:
; 0000 01F2 
; 0000 01F3     if(bBOTL_CH)
_0x65:
	SBRS R4,0
	RJMP _0x67
; 0000 01F4         {
; 0000 01F5         step=s3;
	LDI  R30,LOW(3)
	STS  _step,R30
; 0000 01F6         //step_max_cnt=100;
; 0000 01F7         pump_cntrl_cnt=10;
	RCALL SUBOPT_0x5
; 0000 01F8         bBOTL_CH=0;
	CLT
	BLD  R4,0
; 0000 01F9         }
; 0000 01FA     }
_0x67:
; 0000 01FB 
; 0000 01FC else if(step==s3)   //излив
	RJMP _0x68
_0x64:
	LDS  R26,_step
	CPI  R26,LOW(0x3)
	BRNE _0x69
; 0000 01FD     {
; 0000 01FE     bPP1=0;
	CLT
	BLD  R4,7
; 0000 01FF     bPP2=1;
	SET
	BLD  R5,0
; 0000 0200 
; 0000 0201  /*   if(step_max_cnt)
; 0000 0202         {
; 0000 0203         step_max_cnt--;
; 0000 0204         if(step_max_cnt==0)step=sOFF;
; 0000 0205         } */
; 0000 0206 
; 0000 0207     if(bPUMP_OFF)
	SBRS R4,2
	RJMP _0x6A
; 0000 0208         {
; 0000 0209         step=s4;
	LDI  R30,LOW(4)
	STS  _step,R30
; 0000 020A         step_max_cnt=40;
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	RCALL SUBOPT_0x8
; 0000 020B         bPUMP_OFF=0;
	CLT
	BLD  R4,2
; 0000 020C         }
; 0000 020D     }
_0x6A:
; 0000 020E 
; 0000 020F else if(step==s4)   //пережим
	RJMP _0x6B
_0x69:
	LDS  R26,_step
	CPI  R26,LOW(0x4)
	BRNE _0x6C
; 0000 0210     {
; 0000 0211     bPP1=0;
	RCALL SUBOPT_0x6
; 0000 0212     bPP2=0;
; 0000 0213 
; 0000 0214     if(step_max_cnt)
	RCALL SUBOPT_0x9
	BREQ _0x6D
; 0000 0215         {
; 0000 0216         step_max_cnt--;
	RCALL SUBOPT_0xA
; 0000 0217         if(step_max_cnt==0)
	RCALL SUBOPT_0x9
	BRNE _0x6E
; 0000 0218             {
; 0000 0219             if(bAVT==1)
	SBRS R4,4
	RJMP _0x6F
; 0000 021A                 {
; 0000 021B                 step=s1;
	RCALL SUBOPT_0x7
; 0000 021C                 step_max_cnt=200;
; 0000 021D                 bBOTL_CH=0;
; 0000 021E                 }
; 0000 021F             else step=sOFF;
	RJMP _0x70
_0x6F:
	LDI  R30,LOW(0)
	STS  _step,R30
; 0000 0220             }
_0x70:
; 0000 0221         }
_0x6E:
; 0000 0222     }
_0x6D:
; 0000 0223 
; 0000 0224 else if(step==s10)   //ѕромывка
	RJMP _0x71
_0x6C:
	LDS  R26,_step
	CPI  R26,LOW(0xA)
	BRNE _0x72
; 0000 0225     {
; 0000 0226     bPP1=0;
	CLT
	BLD  R4,7
; 0000 0227     bPP2=1;
	SET
	BLD  R5,0
; 0000 0228 
; 0000 0229     if(bPUMP_OFF)
	SBRS R4,2
	RJMP _0x73
; 0000 022A         {
; 0000 022B         bPUMP_OFF=0;
	CLT
	BLD  R4,2
; 0000 022C         pump_cntrl_cnt=10;
	RCALL SUBOPT_0x5
; 0000 022D         }
; 0000 022E 
; 0000 022F     if(step_max_cnt)
_0x73:
	RCALL SUBOPT_0x9
	BREQ _0x74
; 0000 0230         {
; 0000 0231         step_max_cnt--;
	RCALL SUBOPT_0xA
; 0000 0232         if(step_max_cnt==0)
	RCALL SUBOPT_0x9
	BRNE _0x75
; 0000 0233             {
; 0000 0234             stop_process();
	RCALL _stop_process
; 0000 0235             }
; 0000 0236         }
_0x75:
; 0000 0237     }
_0x74:
; 0000 0238 /*
; 0000 0239 if(ee_prog==p1)
; 0000 023A 	{
; 0000 023B      if(bSW1&&(step==sOFF))
; 0000 023C      	{
; 0000 023D      	step=s1;
; 0000 023E      	bPP1=1;
; 0000 023F      	bPP2=1;
; 0000 0240      	time_cnt=adc_output/15;
; 0000 0241      	}
; 0000 0242      else if(step==s1)
; 0000 0243      	{
; 0000 0244      	if(time_cnt==0)
; 0000 0245      		{
; 0000 0246      		step=s2;
; 0000 0247      		bPP1=1;
; 0000 0248      		bPP2=0;
; 0000 0249      		}
; 0000 024A      	}
; 0000 024B 
; 0000 024C      if(!bSW1&&(step!=sOFF))
; 0000 024D      	{
; 0000 024E      	step=sOFF;
; 0000 024F      	bPP1=0;
; 0000 0250      	bPP2=0;
; 0000 0251      	}
; 0000 0252 	}
; 0000 0253 
; 0000 0254 else if(ee_prog==p2)  //ско
; 0000 0255 	{
; 0000 0256 
; 0000 0257 	}
; 0000 0258 
; 0000 0259 else if(ee_prog==p3)   //твист
; 0000 025A 	{
; 0000 025B 
; 0000 025C 	}
; 0000 025D 
; 0000 025E else if(ee_prog==p4)      //замок
; 0000 025F 	{
; 0000 0260 	}
; 0000 0261 
; 0000 0262 step_contr_end:
; 0000 0263 
; 0000 0264 //if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
; 0000 0265 temp=0;
; 0000 0266 PORTB&=temp;
; 0000 0267 //PORTB=0x55; */
; 0000 0268 }
_0x72:
_0x71:
_0x6B:
_0x68:
_0x63:
_0x5E:
	RET
; .FEND
;
;
;//-----------------------------------------------
;void bin2bcd_int(unsigned int in)
; 0000 026D {
; 0000 026E char i;
; 0000 026F for(i=3;i>0;i--)
;	in -> Y+1
;	i -> R17
; 0000 0270 	{
; 0000 0271 	dig[i]=in%10;
; 0000 0272 	in/=10;
; 0000 0273 	}
; 0000 0274 }
;
;//-----------------------------------------------
;void bcd2ind(char s)
; 0000 0278 {
; 0000 0279 char i;
; 0000 027A bZ=1;
;	s -> Y+1
;	i -> R17
; 0000 027B for (i=0;i<5;i++)
; 0000 027C 	{
; 0000 027D 	if(bZ&&(!dig[i-1])&&(i<4))
; 0000 027E 		{
; 0000 027F 		if((4-i)>s)
; 0000 0280 			{
; 0000 0281 			ind_out[i-1]=DIGISYM[10];
; 0000 0282 			}
; 0000 0283 		else ind_out[i-1]=DIGISYM[0];
; 0000 0284 		}
; 0000 0285 	else
; 0000 0286 		{
; 0000 0287 		ind_out[i-1]=DIGISYM[dig[i-1]];
; 0000 0288 		bZ=0;
; 0000 0289 		}
; 0000 028A 
; 0000 028B 	if(s)
; 0000 028C 		{
; 0000 028D 		ind_out[3-s]&=0b01111111;
; 0000 028E 		}
; 0000 028F 
; 0000 0290 	}
; 0000 0291 }
;//-----------------------------------------------
;void int2ind(unsigned int in,char s)
; 0000 0294 {
; 0000 0295 bin2bcd_int(in);
;	in -> Y+1
;	s -> Y+0
; 0000 0296 bcd2ind(s);
; 0000 0297 
; 0000 0298 }
;
;//-----------------------------------------------
;void ind_hndl(void)
; 0000 029C {
_ind_hndl:
; .FSTART _ind_hndl
; 0000 029D if(step==sOFF)  bLED_Y=1;
	LDS  R30,_step
	CPI  R30,0
	BRNE _0x83
	SET
	RJMP _0xAF
; 0000 029E else            bLED_Y=0;
_0x83:
	CLT
_0xAF:
	BLD  R6,3
; 0000 029F 
; 0000 02A0 //if(step==s2)    bLED_G=1;
; 0000 02A1 //else            bLED_G=0;
; 0000 02A2 
; 0000 02A3 //bLED_Y = bBOTL_CH;
; 0000 02A4 bLED_G = bPUMP_OFF;
	BST  R4,2
	BLD  R6,2
; 0000 02A5 
; 0000 02A6 /*if(bSTOP)
; 0000 02A7     {
; 0000 02A8     bBOTL_CH=0;
; 0000 02A9     }*/
; 0000 02AA }
	RET
; .FEND
;
;
;
;//-----------------------------------------------
;// ѕодпрограмма драйва до 7 кнопок одного порта,
;// различает короткое и длинное нажатие,
;// срабатывает на отпускание кнопки, возможность
;// ускорени€ перебора при длинном нажатии...
;#define but_port PORTC
;#define but_dir  DDRC
;#define but_pin  PINC
;#define but_mask 0b01101010
;#define no_but   0b11111111
;#define but_on   5
;#define but_onL  20
;
;
;
;
;void but_drv(void)
; 0000 02BF {
; 0000 02C0 DDRD&=0b00000111;
; 0000 02C1 PORTD|=0b11111000;
; 0000 02C2 
; 0000 02C3 but_port|=(but_mask^0xff);
; 0000 02C4 but_dir&=but_mask;
; 0000 02C5 #asm
; 0000 02C6 nop
; 0000 02C7 nop
; 0000 02C8 nop
; 0000 02C9 nop
; 0000 02CA #endasm
; 0000 02CB 
; 0000 02CC but_n=but_pin|but_mask;
; 0000 02CD 
; 0000 02CE if((but_n==no_but)||(but_n!=but_s))
; 0000 02CF  	{
; 0000 02D0  	speed=0;
; 0000 02D1    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
; 0000 02D2   		{
; 0000 02D3    	     n_but=1;
; 0000 02D4           but=but_s;
; 0000 02D5           }
; 0000 02D6    	if (but1_cnt>=but_onL_temp)
; 0000 02D7   		{
; 0000 02D8    	     n_but=1;
; 0000 02D9           but=but_s&0b11111101;
; 0000 02DA           }
; 0000 02DB     	l_but=0;
; 0000 02DC    	but_onL_temp=but_onL;
; 0000 02DD     	but0_cnt=0;
; 0000 02DE   	but1_cnt=0;
; 0000 02DF      goto but_drv_out;
; 0000 02E0   	}
; 0000 02E1 
; 0000 02E2 if(but_n==but_s)
; 0000 02E3  	{
; 0000 02E4   	but0_cnt++;
; 0000 02E5   	if(but0_cnt>=but_on)
; 0000 02E6   		{
; 0000 02E7    		but0_cnt=0;
; 0000 02E8    		but1_cnt++;
; 0000 02E9    		if(but1_cnt>=but_onL_temp)
; 0000 02EA    			{
; 0000 02EB     			but=but_s&0b11111101;
; 0000 02EC     			but1_cnt=0;
; 0000 02ED     			n_but=1;
; 0000 02EE     			l_but=1;
; 0000 02EF 			if(speed)
; 0000 02F0 				{
; 0000 02F1     				but_onL_temp=but_onL_temp>>1;
; 0000 02F2         			if(but_onL_temp<=2) but_onL_temp=2;
; 0000 02F3 				}
; 0000 02F4    			}
; 0000 02F5   		}
; 0000 02F6  	}
; 0000 02F7 but_drv_out:
; 0000 02F8 but_s=but_n;
; 0000 02F9 but_port|=(but_mask^0xff);
; 0000 02FA but_dir&=but_mask;
; 0000 02FB }
;
;#define butV	239
;#define butV_	237
;#define butP	251
;#define butP_	249
;#define butR	127
;#define butR_	125
;#define butL	254
;#define butL_	252
;#define butLR	126
;#define butLR_	124
;#define butVP_ 233
;//-----------------------------------------------
;void but_an(void)
; 0000 030A {
; 0000 030B if (!n_but) goto but_an_end;
; 0000 030C 
; 0000 030D if(ind==iMn)
; 0000 030E 	{
; 0000 030F 	if(but==butP_)ind=iPr_sel;
; 0000 0310 	}
; 0000 0311 
; 0000 0312 else if(ind==iPr_sel)
; 0000 0313 	{
; 0000 0314 	if(but==butP_)ind=iMn;
; 0000 0315 	if(but==butP)
; 0000 0316 		{
; 0000 0317 		ee_prog++;
; 0000 0318 		if(ee_prog>MAXPROG)ee_prog=p1;
; 0000 0319 		}
; 0000 031A 	}
; 0000 031B 
; 0000 031C but_an_end:
; 0000 031D n_but=0;
; 0000 031E }
;
;//-----------------------------------------------
;void ind_drv(void)
; 0000 0322 {
_ind_drv:
; .FSTART _ind_drv
; 0000 0323 char temp=0;
; 0000 0324 //DDRB|=0xF0;
; 0000 0325 
; 0000 0326 if(bLED_G) temp|=(1<<0);
	ST   -Y,R17
;	temp -> R17
	LDI  R17,0
	SBRC R6,2
	ORI  R17,LOW(1)
; 0000 0327 if(bLED_Y) temp|=(1<<2);
	SBRC R6,3
	ORI  R17,LOW(4)
; 0000 0328 
; 0000 0329 
; 0000 032A DDRB|=0x0F;
	IN   R30,0x17
	ORI  R30,LOW(0xF)
	OUT  0x17,R30
; 0000 032B 
; 0000 032C PORTB=((PORTB|0x0f)&(~temp));
	IN   R30,0x18
	ORI  R30,LOW(0xF)
_0x2000001:
	MOV  R26,R30
	MOV  R30,R17
	COM  R30
	AND  R30,R26
	OUT  0x18,R30
; 0000 032D //PORTB=0x55;
; 0000 032E }
	LD   R17,Y+
	RET
; .FEND
;
;//***********************************************
;//***********************************************
;//***********************************************
;//***********************************************
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0335 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
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
; 0000 0336 TCCR0=0x02;
	RCALL SUBOPT_0xB
; 0000 0337 TCNT0=-208;
; 0000 0338 OCR0=0x00;
; 0000 0339 
; 0000 033A 
; 0000 033B b600Hz=1;
	SET
	BLD  R2,0
; 0000 033C ind_drv();
	RCALL _ind_drv
; 0000 033D if(++t0_cnt0>=6)
	INC  R8
	LDI  R30,LOW(6)
	CP   R8,R30
	BRLO _0x9F
; 0000 033E 	{
; 0000 033F 	t0_cnt0=0;
	CLR  R8
; 0000 0340 	b100Hz=1;
	SET
	BLD  R2,1
; 0000 0341 
; 0000 0342     if(pump_cntrl_cnt) pump_cntrl_cnt--;
	RCALL SUBOPT_0x4
	BREQ _0xA0
	LDI  R26,LOW(_pump_cntrl_cnt)
	LDI  R27,HIGH(_pump_cntrl_cnt)
	RCALL SUBOPT_0x1
; 0000 0343 
; 0000 0344 	}
_0xA0:
; 0000 0345 
; 0000 0346 if(++t0_cnt1>=60)
_0x9F:
	INC  R7
	LDI  R30,LOW(60)
	CP   R7,R30
	BRLO _0xA1
; 0000 0347 	{
; 0000 0348 	t0_cnt1=0;
	CLR  R7
; 0000 0349 	b10Hz=1;
	SET
	BLD  R2,2
; 0000 034A 
; 0000 034B 	if(++t0_cnt2>=2)
	INC  R10
	LDI  R30,LOW(2)
	CP   R10,R30
	BRLO _0xA2
; 0000 034C 		{
; 0000 034D 		t0_cnt2=0;
	CLR  R10
; 0000 034E 		bFL5=!bFL5;
	EOR  R3,R30
; 0000 034F 		}
; 0000 0350 
; 0000 0351 	if(++t0_cnt3>=5)
_0xA2:
	INC  R9
	LDI  R30,LOW(5)
	CP   R9,R30
	BRLO _0xA3
; 0000 0352 		{
; 0000 0353 		t0_cnt3=0;
	CLR  R9
; 0000 0354 		bFL2=!bFL2;
	LDI  R30,LOW(1)
	EOR  R3,R30
; 0000 0355 		}
; 0000 0356 	}
_0xA3:
; 0000 0357 
; 0000 0358 if(++t0_cnt4>=600)
_0xA1:
	__GETW1R 11,12
	ADIW R30,1
	__PUTW1R 11,12
	CPI  R30,LOW(0x258)
	LDI  R26,HIGH(0x258)
	CPC  R31,R26
	BRLT _0xA4
; 0000 0359 	{
; 0000 035A 	t0_cnt4=0;
	CLR  R11
	CLR  R12
; 0000 035B 	b1Hz=1;
	SET
	BLD  R2,3
; 0000 035C 
; 0000 035D 
; 0000 035E 	}
; 0000 035F }
_0xA4:
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
; .FEND
;
;//***********************************************
;interrupt [ADC_INT] void adc_isr(void)
; 0000 0363 {
_adc_isr:
; .FSTART _adc_isr
	ST   -Y,R30
	ST   -Y,R31
; 0000 0364  static unsigned char input_index=0;
; 0000 0365 // Read the AD conversion result
; 0000 0366 adc_output=ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	STS  _adc_output,R30
	STS  _adc_output+1,R31
; 0000 0367 // Select next ADC input
; 0000 0368 
; 0000 0369 ADMUX=(FIRST_ADC_INPUT|ADC_VREF_TYPE);
	LDI  R30,LOW(66)
	OUT  0x7,R30
; 0000 036A 
; 0000 036B 
; 0000 036C }
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;//===============================================
;//===============================================
;//===============================================
;//===============================================
;
;void main(void)
; 0000 0374 {
_main:
; .FSTART _main
; 0000 0375 
; 0000 0376 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 0377 DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0378 
; 0000 0379 PORTB=0xff;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 037A DDRB=0xFF;
	OUT  0x17,R30
; 0000 037B 
; 0000 037C PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 037D DDRC=0x00;
	OUT  0x14,R30
; 0000 037E 
; 0000 037F 
; 0000 0380 PORTD=0x00;
	OUT  0x12,R30
; 0000 0381 DDRD=0x00;
	OUT  0x11,R30
; 0000 0382 
; 0000 0383 
; 0000 0384 TCCR0=0x02;
	RCALL SUBOPT_0xB
; 0000 0385 TCNT0=-208;
; 0000 0386 OCR0=0x00;
; 0000 0387 
; 0000 0388 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0389 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 038A TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 038B TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 038C ICR1H=0x00;
	OUT  0x27,R30
; 0000 038D ICR1L=0x00;
	OUT  0x26,R30
; 0000 038E OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 038F OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0390 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0391 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0392 
; 0000 0393 
; 0000 0394 ASSR=0x00;
	OUT  0x22,R30
; 0000 0395 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0396 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0397 OCR2=0x00;
	OUT  0x23,R30
; 0000 0398 
; 0000 0399 MCUCR=0x00;
	OUT  0x35,R30
; 0000 039A MCUCSR=0x00;
	OUT  0x34,R30
; 0000 039B 
; 0000 039C TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 039D 
; 0000 039E ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 039F SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 03A0 
; 0000 03A1 
; 0000 03A2 
; 0000 03A3 // ADC initialization
; 0000 03A4 // ADC Clock frequency: 125,000 kHz
; 0000 03A5 // ADC Voltage Reference: AVCC pin
; 0000 03A6 // ADC High Speed Mode: Off
; 0000 03A7 // ADC Auto Trigger Source: Timer0 Overflow
; 0000 03A8 ADMUX=FIRST_ADC_INPUT|ADC_VREF_TYPE;
	LDI  R30,LOW(66)
	OUT  0x7,R30
; 0000 03A9 ADCSRA=0xCB;
	LDI  R30,LOW(203)
	OUT  0x6,R30
; 0000 03AA SFIOR&=0x0F;
	IN   R30,0x30
	ANDI R30,LOW(0xF)
	OUT  0x30,R30
; 0000 03AB 
; 0000 03AC 
; 0000 03AD 
; 0000 03AE #asm("sei")
	sei
; 0000 03AF PORTB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 03B0 DDRB=0xFF;
	OUT  0x17,R30
; 0000 03B1 ind=iMn;
	LDI  R30,LOW(0)
	STS  _ind,R30
; 0000 03B2 prog_drv();
	RCALL _prog_drv
; 0000 03B3 ind_hndl();
	RCALL _ind_hndl
; 0000 03B4 //led_hndl();
; 0000 03B5 //PORTB=0x00;
; 0000 03B6 /*while (1)
; 0000 03B7 {
; 0000 03B8 }*/
; 0000 03B9 
; 0000 03BA while (1)
_0xA5:
; 0000 03BB       {
; 0000 03BC       if(b600Hz)
	SBRS R2,0
	RJMP _0xA8
; 0000 03BD 		{
; 0000 03BE 		b600Hz=0;
	CLT
	BLD  R2,0
; 0000 03BF         in_an();
	RCALL _in_an
; 0000 03C0 
; 0000 03C1 		}
; 0000 03C2       if(b100Hz)
_0xA8:
	SBRS R2,1
	RJMP _0xA9
; 0000 03C3 		{
; 0000 03C4 		b100Hz=0;
	CLT
	BLD  R2,1
; 0000 03C5 		//but_an();
; 0000 03C6         ind_hndl();
	RCALL _ind_hndl
; 0000 03C7 	    ind_drv();
	RCALL _ind_drv
; 0000 03C8 
; 0000 03C9         step_contr();
	RCALL _step_contr
; 0000 03CA 
; 0000 03CB         stop_process_drv();
	RCALL _stop_process_drv
; 0000 03CC 
; 0000 03CD         out_drv();
	RCALL _out_drv
; 0000 03CE 
; 0000 03CF        // pump_cntrl_drv();
; 0000 03D0 		}
; 0000 03D1 	if(b10Hz)
_0xA9:
	SBRS R2,2
	RJMP _0xAA
; 0000 03D2 		{
; 0000 03D3 		b10Hz=0;
	CLT
	BLD  R2,2
; 0000 03D4 		//prog_drv();
; 0000 03D5 		//err_drv();
; 0000 03D6 
; 0000 03D7     	     //if(time_cnt)time_cnt--;
; 0000 03D8           //led_hndl();
; 0000 03D9           //ADCSRA|=0x40;
; 0000 03DA          // bPP2=!bPP2;
; 0000 03DB          // bLED_G=!bPP2;
; 0000 03DC           }
; 0000 03DD 	if(b1Hz)
_0xAA:
	SBRS R2,3
	RJMP _0xAB
; 0000 03DE 		{
; 0000 03DF 		b1Hz=0;
	CLT
	BLD  R2,3
; 0000 03E0 
; 0000 03E1           //pump_cntrl_cnt=10;
; 0000 03E2           //bPP1=!bPP1;
; 0000 03E3           //bLED_Y=!bLED_Y;
; 0000 03E4         }
; 0000 03E5 
; 0000 03E6       };
_0xAB:
	RJMP _0xA5
; 0000 03E7 }
_0xAC:
	RJMP _0xAC
; .FEND

	.DSEG
_ind_out:
	.BYTE 0x5
_dig:
	.BYTE 0x4
_but_n_G000:
	.BYTE 0x1
_but_s_G000:
	.BYTE 0x1
_but0_cnt_G000:
	.BYTE 0x1
_but1_cnt_G000:
	.BYTE 0x1
_but_onL_temp_G000:
	.BYTE 0x1

	.ESEG
_ee_prog:
	.BYTE 0x1

	.DSEG
_step:
	.BYTE 0x1
_ind:
	.BYTE 0x1
_in_word:
	.BYTE 0x1
_in_word_old:
	.BYTE 0x1
_in_word_new:
	.BYTE 0x1
_in_word_cnt:
	.BYTE 0x1
_adc_output:
	.BYTE 0x2
_pump_cntrl_cnt:
	.BYTE 0x2
_cnt_start:
	.BYTE 0x2
_cnt_stop:
	.BYTE 0x2
_cnt_md1:
	.BYTE 0x2
_cnt_botl:
	.BYTE 0x2
_cnt_pump:
	.BYTE 0x2
_cnt_avt:
	.BYTE 0x2
_cnt_stop_long:
	.BYTE 0x2
_stop_process_cnt:
	.BYTE 0x2
_step_max_cnt:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x0:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x1:
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	LDS  R26,_cnt_stop_long
	LDS  R27,_cnt_stop_long+1
	CPI  R26,LOW(0x960)
	LDI  R30,HIGH(0x960)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDS  R26,_cnt_avt
	LDS  R27,_cnt_avt+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	LDS  R30,_pump_cntrl_cnt
	LDS  R31,_pump_cntrl_cnt+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	STS  _pump_cntrl_cnt,R30
	STS  _pump_cntrl_cnt+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	CLT
	BLD  R4,7
	BLD  R5,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(1)
	STS  _step,R30
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	STS  _step_max_cnt,R30
	STS  _step_max_cnt+1,R31
	CLT
	BLD  R4,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	STS  _step_max_cnt,R30
	STS  _step_max_cnt+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x9:
	LDS  R30,_step_max_cnt
	LDS  R31,_step_max_cnt+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(_step_max_cnt)
	LDI  R27,HIGH(_step_max_cnt)
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(2)
	OUT  0x33,R30
	LDI  R30,LOW(48)
	OUT  0x32,R30
	LDI  R30,LOW(0)
	OUT  0x3C,R30
	RET


	.CSEG
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

;END OF CODE MARKER
__END_OF_CODE:
