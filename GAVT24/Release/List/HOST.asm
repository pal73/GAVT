
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8,000000 MHz
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
	.DEF _t0_cnt0_=R8
	.DEF _t0_cnt0=R7
	.DEF _t0_cnt1=R10
	.DEF _t0_cnt2=R9
	.DEF _t0_cnt3=R12
	.DEF _ind_cnt=R11
	.DEF _but=R14
	.DEF _prog=R13

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
	JMP  _timer1_compa_isr
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _uart_rx_isr
	JMP  0x00
	JMP  _uart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_IND_STROB:
	.DB  0xBF,0xDF,0xEF,0xF7,0x7F
_DIGISYM:
	.DB  0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8
	.DB  0x80,0x90,0xFF
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000
	.DW  0x0000

_0x3:
	.DB  0x55,0x55,0x55,0x55,0x55
_0x16:
	.DB  0xAA

__GLOBAL_INI_TBL:
	.DW  0x03
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x05
	.DW  _ind_out
	.DW  _0x3*2

	.DW  0x01
	.DW  _avtom_mode
	.DW  _0x16*2

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
;#define SLAVE_MESS_LEN	4
;
;#define LED_POW_ON	5
;#define LED_PROG4	1
;#define LED_PROG2	2
;#define LED_PROG3	3
;#define LED_PROG1	4
;#define LED_ERROR	0
;#define LED_WRK	6
;#define LED_AVTOM	7
;
;
;
;#define MD1	2
;#define MD2	3
;#define VR	4
;#define MD3	5
;
;#define PP1	6
;#define PP2	7
;#define PP3	5
;#define PP4	4
;#define PP5	3
;#define DV	0
;
;#define PP7	2
;
;
;
;bit b600Hz;
;bit b100Hz;
;bit b10Hz;
;char t0_cnt0_,t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3;
;char ind_cnt;
;flash char IND_STROB[]={0b10111111,0b11011111,0b11101111,0b11110111,0b01111111};
;flash char DIGISYM[]={0b11000000,0b11111001,0b10100100,0b10110000,0b10011001,0b10010010,0b10000010,0b11111000,0b10000000 ...
;#define SYMn 0b10101011
;#define SYMo 0b10100011
;#define SYMf 0b10001110
;#define SYMu 0b11100011
;#define SYMt 0b10000111
;#define SYM  0b11111111
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
;bit speed;		//разрешение ускорения перебора
;bit bFL2;
;bit bFL5;
;eeprom enum{eamON=0x55,eamOFF=0xaa}ee_avtom_mode;
;enum {p1=1,p2=2,p3=3,p4=4}prog;
;//enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s100}step=sOFF;
;enum {iMn,iPr_sel,iSet_sel,iSet_delay,iCh_on} ind;
;char sub_ind;
;char in_word,in_word_old,in_word_new,in_word_cnt;
;bit bERR;
;signed int cnt_del=0;
;bit bVR;
;bit bMD1;
;bit bMD2;
;bit bMD3;
;char cnt_md1,cnt_md2,cnt_vr,cnt_md3;
;
;eeprom enum {coOFF=0x55,coON=0xaa}ch_on[6];
;eeprom unsigned ee_timer1_delay;
;bit opto_angle_old;
;enum {msON=0x55,msOFF=0xAA}motor_state;
;unsigned timer1_delay;
;
;char stop_cnt/*,start_cnt*/;
;char cnt_net_drv,cnt_drv;
;char cmnd_byte,state_byte,crc_byte;
;signed char od_cnt;
;enum {odON=55,odOFF=77}od;
;char state[3];
;enum{sOFF,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16}step_main=sOFF;
;char plazma;
;signed cnt_del_main;
;bit bDel;
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
;#include <stdio.h>
;#include "usart_host.c"
;#define RXB8 1
;#define TXB8 0
;#define UPE 2
;#define OVR 3
;#define FE 4
;#define UDRE 5
;#define RXC 7
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<OVR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;extern void uart_in_an(void);
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 50
;bit bRXIN;
;char UIB[10]={0,0,0,0,0,0,0,0,0,0};
;char flag;
;char rx_buffer[RX_BUFFER_SIZE];
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;#pragma savereg-
;interrupt [USART_RXC] void uart_rx_isr(void)
; 0000 0059 {

	.CSEG
_uart_rx_isr:
; .FSTART _uart_rx_isr
;char status,data;
;#asm
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
    push r26
    push r27
    push r30
    push r31
    in   r26,sreg
    push r26
;
;status=UCSRA;
	IN   R17,11
;data=UDR;
	IN   R16,12
;if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x4
;   {
;
;   if((data&0b11111000)==0)rx_wr_index=0;
	MOV  R30,R16
	ANDI R30,LOW(0xF8)
	BRNE _0x5
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
;   rx_buffer[rx_wr_index]=data;
_0x5:
	LDS  R30,_rx_wr_index
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
;   if (++rx_wr_index >= SLAVE_MESS_LEN)
	LDS  R26,_rx_wr_index
	SUBI R26,-LOW(1)
	STS  _rx_wr_index,R26
	CPI  R26,LOW(0x4)
	BRLO _0x6
;   	{
;   	if((((rx_buffer[0]^rx_buffer[1])^(rx_buffer[2]^rx_buffer[3]))&0b01111111)==0)
	__GETB1MN _rx_buffer,1
	LDS  R26,_rx_buffer
	EOR  R30,R26
	MOV  R0,R30
	__GETB2MN _rx_buffer,2
	__GETB1MN _rx_buffer,3
	EOR  R30,R26
	MOV  R26,R0
	EOR  R26,R30
	ANDI R26,LOW(0x7F)
	BRNE _0x7
;   		{
;   		uart_in_an();plazma++;
	CALL _uart_in_an
	LDS  R30,_plazma
	SUBI R30,-LOW(1)
	STS  _plazma,R30
;   		}
;     }
_0x7:
;   };
_0x6:
_0x4:
;#asm
    pop  r26
    out  sreg,r26
    pop  r31
    pop  r30
    pop  r27
    pop  r26
;}
	LD   R16,Y+
	LD   R17,Y+
	RETI
; .FEND
;#pragma savereg+
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
;{
;char data;
;while (rx_counter==0);
;	data -> R17
;data=rx_buffer[rx_rd_index];
;if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
;#asm("cli")
;--rx_counter;
;#asm("sei")
;return data;
;}
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 100
;char tx_buffer[TX_BUFFER_SIZE];
;unsigned char tx_wr_index,tx_rd_index,tx_counter;
;
;// USART Transmitter interrupt service routine
;#pragma savereg-
;interrupt [USART_TXC] void uart_tx_isr(void)
;{
_uart_tx_isr:
; .FSTART _uart_tx_isr
;#asm
    push r26
    push r27
    push r30
    push r31
    in   r26,sreg
    push r26
;if (tx_counter)
	LDS  R30,_tx_counter
	CPI  R30,0
	BREQ _0xC
;   {
;   --tx_counter;
	SUBI R30,LOW(1)
	STS  _tx_counter,R30
;   UDR=tx_buffer[tx_rd_index];
	LDS  R30,_tx_rd_index
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
;   if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDS  R26,_tx_rd_index
	SUBI R26,-LOW(1)
	STS  _tx_rd_index,R26
	CPI  R26,LOW(0x64)
	BRNE _0xD
	LDI  R30,LOW(0)
	STS  _tx_rd_index,R30
;   };
_0xD:
_0xC:
;#asm
    pop  r26
    out  sreg,r26
    pop  r31
    pop  r30
    pop  r27
    pop  r26
;}
	RETI
; .FEND
;#pragma savereg+
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
;{
_putchar:
; .FSTART _putchar
;while (tx_counter == TX_BUFFER_SIZE);
	ST   -Y,R26
;	c -> Y+0
_0xE:
	LDS  R26,_tx_counter
	CPI  R26,LOW(0x64)
	BREQ _0xE
;#asm("cli")
	cli
;if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter
	CPI  R30,0
	BRNE _0x12
	SBIC 0xB,5
	RJMP _0x11
_0x12:
;   {
;   tx_buffer[tx_wr_index]=c;
	LDS  R30,_tx_wr_index
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
;   if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDS  R26,_tx_wr_index
	SUBI R26,-LOW(1)
	STS  _tx_wr_index,R26
	CPI  R26,LOW(0x64)
	BRNE _0x14
	LDI  R30,LOW(0)
	STS  _tx_wr_index,R30
;   ++tx_counter;
_0x14:
	LDS  R30,_tx_counter
	SUBI R30,-LOW(1)
	STS  _tx_counter,R30
;   }
;else UDR=c;
	RJMP _0x15
_0x11:
	LD   R30,Y
	OUT  0xC,R30
;#asm("sei")
_0x15:
	sei
;}
	ADIW R28,1
	RET
; .FEND
;#pragma used-
;#endif
;enum{amON=0x55,amOFF=0xaa}avtom_mode=amOFF;

	.DSEG
;char avtom_mode_cnt;
;
;//-----------------------------------------------
;void od_drv(void)
; 0000 005F {

	.CSEG
_od_drv:
; .FSTART _od_drv
; 0000 0060 
; 0000 0061 if(!PINA.1)
	SBIC 0x19,1
	RJMP _0x17
; 0000 0062 	{
; 0000 0063 	if(od_cnt<10)od_cnt++;
	LDS  R26,_od_cnt
	CPI  R26,LOW(0xA)
	BRGE _0x18
	LDS  R30,_od_cnt
	SUBI R30,-LOW(1)
	STS  _od_cnt,R30
; 0000 0064 	}
_0x18:
; 0000 0065 else
	RJMP _0x19
_0x17:
; 0000 0066 	{
; 0000 0067 	if(od_cnt>0)od_cnt--;
	LDS  R26,_od_cnt
	CPI  R26,LOW(0x1)
	BRLT _0x1A
	LDS  R30,_od_cnt
	SUBI R30,LOW(1)
	STS  _od_cnt,R30
; 0000 0068 	}
_0x1A:
_0x19:
; 0000 0069 
; 0000 006A if(od_cnt>=9)od=odON;
	LDS  R26,_od_cnt
	CPI  R26,LOW(0x9)
	BRLT _0x1B
	LDI  R30,LOW(55)
	RJMP _0x146
; 0000 006B else if(od_cnt<=1)od=odOFF;
_0x1B:
	LDS  R26,_od_cnt
	CPI  R26,LOW(0x2)
	BRGE _0x1D
	LDI  R30,LOW(77)
_0x146:
	STS  _od,R30
; 0000 006C 
; 0000 006D DDRA.1=0;
_0x1D:
	CBI  0x1A,1
; 0000 006E PORTA.1=1;
	SBI  0x1B,1
; 0000 006F 
; 0000 0070 }
	RET
; .FEND
;
;//-----------------------------------------------
;void avtom_mode_drv(void)
; 0000 0074 {
_avtom_mode_drv:
; .FSTART _avtom_mode_drv
; 0000 0075 if(in_word&(1<<5))
	LDS  R30,_in_word
	ANDI R30,LOW(0x20)
	BREQ _0x22
; 0000 0076 	{
; 0000 0077 	if(avtom_mode_cnt) avtom_mode_cnt--;
	LDS  R30,_avtom_mode_cnt
	CPI  R30,0
	BREQ _0x23
	SUBI R30,LOW(1)
	STS  _avtom_mode_cnt,R30
; 0000 0078 	}
_0x23:
; 0000 0079 
; 0000 007A else
	RJMP _0x24
_0x22:
; 0000 007B 	{
; 0000 007C 	if(avtom_mode_cnt<100) avtom_mode_cnt++;
	LDS  R26,_avtom_mode_cnt
	CPI  R26,LOW(0x64)
	BRSH _0x25
	LDS  R30,_avtom_mode_cnt
	SUBI R30,-LOW(1)
	STS  _avtom_mode_cnt,R30
; 0000 007D 	}
_0x25:
_0x24:
; 0000 007E 
; 0000 007F if(avtom_mode_cnt>90)avtom_mode=amON;
	LDS  R26,_avtom_mode_cnt
	CPI  R26,LOW(0x5B)
	BRLO _0x26
	LDI  R30,LOW(85)
	RJMP _0x147
; 0000 0080 else if(avtom_mode_cnt<10)avtom_mode=amOFF;
_0x26:
	LDS  R26,_avtom_mode_cnt
	CPI  R26,LOW(0xA)
	BRSH _0x28
	LDI  R30,LOW(170)
_0x147:
	STS  _avtom_mode,R30
; 0000 0081 }
_0x28:
	RET
; .FEND
;
;//-----------------------------------------------
;void out_drv(void)
; 0000 0085 {
_out_drv:
; .FSTART _out_drv
; 0000 0086 DDRB|=0xc0;
	IN   R30,0x17
	ORI  R30,LOW(0xC0)
	OUT  0x17,R30
; 0000 0087 if(stop_cnt)
	LDS  R30,_stop_cnt
	CPI  R30,0
	BREQ _0x29
; 0000 0088 	{
; 0000 0089 	stop_cnt--;
	SUBI R30,LOW(1)
	STS  _stop_cnt,R30
; 0000 008A 	PORTB.6=0;
	CBI  0x18,6
; 0000 008B 	}
; 0000 008C else PORTB.6=1;
	RJMP _0x2C
_0x29:
	SBI  0x18,6
; 0000 008D 
; 0000 008E if(motor_state==msON)
_0x2C:
	LDS  R26,_motor_state
	CPI  R26,LOW(0x55)
	BRNE _0x2F
; 0000 008F 	{
; 0000 0090 	//start_cnt--;
; 0000 0091 	PORTB.7=0;
	CBI  0x18,7
; 0000 0092 	}
; 0000 0093 else PORTB.7=1;
	RJMP _0x32
_0x2F:
	SBI  0x18,7
; 0000 0094 }
_0x32:
	RET
; .FEND
;
;
;//-----------------------------------------------
;void step_main_contr(void)
; 0000 0099 {
_step_main_contr:
; .FSTART _step_main_contr
; 0000 009A 
; 0000 009B if(step_main==sOFF)
	LDS  R30,_step_main
	CPI  R30,0
	BRNE _0x35
; 0000 009C 	{
; 0000 009D 	cmnd_byte=0x33;
	LDI  R30,LOW(51)
	STS  _cmnd_byte,R30
; 0000 009E 	}
; 0000 009F else if(step_main==s1)
	RJMP _0x36
_0x35:
	LDS  R26,_step_main
	CPI  R26,LOW(0x1)
	BRNE _0x37
; 0000 00A0 	{
; 0000 00A1 	cmnd_byte=0x33;
	LDI  R30,LOW(51)
	STS  _cmnd_byte,R30
; 0000 00A2 	if(od==odON)
	LDS  R26,_od
	CPI  R26,LOW(0x37)
	BRNE _0x38
; 0000 00A3 		{
; 0000 00A4 		step_main=s2;
	LDI  R30,LOW(2)
	CALL SUBOPT_0x0
; 0000 00A5 		cnt_del_main=30;
; 0000 00A6 		}
; 0000 00A7 	}
_0x38:
; 0000 00A8 else if(step_main==s2)
	RJMP _0x39
_0x37:
	LDS  R26,_step_main
	CPI  R26,LOW(0x2)
	BRNE _0x3A
; 0000 00A9 	{
; 0000 00AA 	cmnd_byte=0x33;
	CALL SUBOPT_0x1
; 0000 00AB 	cnt_del_main--;
; 0000 00AC 	if(cnt_del_main==0)
	BRNE _0x3B
; 0000 00AD 		{
; 0000 00AE   		motor_state=msON;
	LDI  R30,LOW(85)
	STS  _motor_state,R30
; 0000 00AF      	//start_cnt=20;
; 0000 00B0 		step_main=s3;
	LDI  R30,LOW(3)
	STS  _step_main,R30
; 0000 00B1 		bDel=0;
	CLT
	BLD  R3,7
; 0000 00B2 		}
; 0000 00B3 	}
_0x3B:
; 0000 00B4 else if(step_main==s3)
	RJMP _0x3C
_0x3A:
	LDS  R26,_step_main
	CPI  R26,LOW(0x3)
	BRNE _0x3D
; 0000 00B5 	{
; 0000 00B6 	cmnd_byte=0x33;
	LDI  R30,LOW(51)
	STS  _cmnd_byte,R30
; 0000 00B7 	if(motor_state==msOFF)
	LDS  R26,_motor_state
	CPI  R26,LOW(0xAA)
	BRNE _0x3E
; 0000 00B8 		{
; 0000 00B9 		step_main=s4;
	LDI  R30,LOW(4)
	CALL SUBOPT_0x0
; 0000 00BA 		cnt_del_main=30;
; 0000 00BB 		}
; 0000 00BC 
; 0000 00BD 	}
_0x3E:
; 0000 00BE else if(step_main==s4)
	RJMP _0x3F
_0x3D:
	LDS  R26,_step_main
	CPI  R26,LOW(0x4)
	BRNE _0x40
; 0000 00BF 	{
; 0000 00C0 	cmnd_byte=0x33;
	CALL SUBOPT_0x1
; 0000 00C1 	cnt_del_main--;
; 0000 00C2 	if(cnt_del_main==0)
	BRNE _0x41
; 0000 00C3 		{
; 0000 00C4 		step_main=s5;
	LDI  R30,LOW(5)
	STS  _step_main,R30
; 0000 00C5 		cnt_del_main=100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _cnt_del_main,R30
	STS  _cnt_del_main+1,R31
; 0000 00C6 		}
; 0000 00C7 	}
_0x41:
; 0000 00C8 else if(step_main==s5)
	RJMP _0x42
_0x40:
	LDS  R26,_step_main
	CPI  R26,LOW(0x5)
	BRNE _0x43
; 0000 00C9 	{
; 0000 00CA 	cmnd_byte=0x55;
	LDI  R30,LOW(85)
	STS  _cmnd_byte,R30
; 0000 00CB 	cnt_del_main--;
	LDI  R26,LOW(_cnt_del_main)
	LDI  R27,HIGH(_cnt_del_main)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 00CC 	if(cnt_del_main==0)
	LDS  R30,_cnt_del_main
	LDS  R31,_cnt_del_main+1
	SBIW R30,0
	BRNE _0x44
; 0000 00CD 		{
; 0000 00CE 		step_main=s6;
	LDI  R30,LOW(6)
	STS  _step_main,R30
; 0000 00CF 		}
; 0000 00D0 	}
_0x44:
; 0000 00D1 else if(step_main==s6)
	RJMP _0x45
_0x43:
	LDS  R26,_step_main
	CPI  R26,LOW(0x6)
	BRNE _0x46
; 0000 00D2 	{
; 0000 00D3 	cmnd_byte=0x55;
	LDI  R30,LOW(85)
	STS  _cmnd_byte,R30
; 0000 00D4 	if((((state[0]&0b00000100)==0)||(ch_on[0]!=coON))
; 0000 00D5 		&&(((state[0]&0b00100000)==0)||(ch_on[1]!=coON))
; 0000 00D6 		&&(((state[1]&0b00000100)==0)||(ch_on[2]!=coON))
; 0000 00D7 		&&(((state[1]&0b00100000)==0)||(ch_on[3]!=coON))
; 0000 00D8 		&&(((state[2]&0b00000100)==0)||(ch_on[4]!=coON))
; 0000 00D9 		&&(((state[2]&0b00100000)==0)||(ch_on[5]!=coON)))step_main=s7;
	LDS  R30,_state
	ANDI R30,LOW(0x4)
	BREQ _0x48
	CALL SUBOPT_0x2
	BREQ _0x4A
_0x48:
	LDS  R30,_state
	ANDI R30,LOW(0x20)
	BREQ _0x4B
	CALL SUBOPT_0x3
	BREQ _0x4A
_0x4B:
	__GETB1MN _state,1
	ANDI R30,LOW(0x4)
	BREQ _0x4D
	CALL SUBOPT_0x4
	BREQ _0x4A
_0x4D:
	__GETB1MN _state,1
	ANDI R30,LOW(0x20)
	BREQ _0x4F
	CALL SUBOPT_0x5
	BREQ _0x4A
_0x4F:
	__GETB1MN _state,2
	ANDI R30,LOW(0x4)
	BREQ _0x51
	CALL SUBOPT_0x6
	BREQ _0x4A
_0x51:
	__GETB1MN _state,2
	ANDI R30,LOW(0x20)
	BREQ _0x53
	CALL SUBOPT_0x7
	BREQ _0x4A
_0x53:
	RJMP _0x55
_0x4A:
	RJMP _0x47
_0x55:
	LDI  R30,LOW(7)
	STS  _step_main,R30
; 0000 00DA 	}
_0x47:
; 0000 00DB else if(step_main==s7)
	RJMP _0x56
_0x46:
	LDS  R26,_step_main
	CPI  R26,LOW(0x7)
	BRNE _0x57
; 0000 00DC 	{
; 0000 00DD 	cmnd_byte=0x33;
	LDI  R30,LOW(51)
	STS  _cmnd_byte,R30
; 0000 00DE 	if(avtom_mode==amON)step_main=s1;
	LDS  R26,_avtom_mode
	CPI  R26,LOW(0x55)
	BRNE _0x58
	LDI  R30,LOW(1)
	RJMP _0x148
; 0000 00DF 	else step_main=sOFF;
_0x58:
	LDI  R30,LOW(0)
_0x148:
	STS  _step_main,R30
; 0000 00E0 	}
; 0000 00E1 
; 0000 00E2 }
_0x57:
_0x56:
_0x45:
_0x42:
_0x3F:
_0x3C:
_0x39:
_0x36:
	RET
; .FEND
;
;
;
;//-----------------------------------------------
;void out_usart (char num,char data0,char data1,char data2,char data3,char data4,char data5,char data6,char data7,char da ...
; 0000 00E8 {
_out_usart:
; .FSTART _out_usart
; 0000 00E9 char i,t=0;
; 0000 00EA 
; 0000 00EB char UOB[12];
; 0000 00EC UOB[0]=data0;
	ST   -Y,R26
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
;	i -> R17
;	t -> R16
;	UOB -> Y+2
	LDI  R16,0
	LDD  R30,Y+22
	STD  Y+2,R30
; 0000 00ED UOB[1]=data1;
	LDD  R30,Y+21
	STD  Y+3,R30
; 0000 00EE UOB[2]=data2;
	LDD  R30,Y+20
	STD  Y+4,R30
; 0000 00EF UOB[3]=data3;
	LDD  R30,Y+19
	STD  Y+5,R30
; 0000 00F0 UOB[4]=data4;
	LDD  R30,Y+18
	STD  Y+6,R30
; 0000 00F1 UOB[5]=data5;
	LDD  R30,Y+17
	STD  Y+7,R30
; 0000 00F2 UOB[6]=data6;
	LDD  R30,Y+16
	STD  Y+8,R30
; 0000 00F3 UOB[7]=data7;
	LDD  R30,Y+15
	STD  Y+9,R30
; 0000 00F4 UOB[8]=data8;
	LDD  R30,Y+14
	STD  Y+10,R30
; 0000 00F5 
; 0000 00F6 for (i=0;i<num;i++)
	LDI  R17,LOW(0)
_0x5B:
	LDD  R30,Y+23
	CP   R17,R30
	BRSH _0x5C
; 0000 00F7 	{
; 0000 00F8 	putchar(UOB[i]);
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _putchar
; 0000 00F9 	}
	SUBI R17,-1
	RJMP _0x5B
_0x5C:
; 0000 00FA }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,24
	RET
; .FEND
;
;//-----------------------------------------------
;void byte_drv(void)
; 0000 00FE {
; 0000 00FF cmnd_byte|=0x80;
; 0000 0100 state_byte=0xff;
; 0000 0101 
; 0000 0102 if(ch_on[0]!=coON)state_byte&=~(1<<0);
; 0000 0103 if(ch_on[1]!=coON)state_byte&=~(1<<1);
; 0000 0104 if(ch_on[2]!=coON)state_byte&=~(1<<2);
; 0000 0105 if(ch_on[3]!=coON)state_byte&=~(1<<3);
; 0000 0106 if(ch_on[4]!=coON)state_byte&=~(1<<4);
; 0000 0107 if(ch_on[5]!=coON)state_byte&=~(1<<5);
; 0000 0108 
; 0000 0109 crc_byte=cmnd_byte^state_byte;
; 0000 010A }
;
;//-----------------------------------------------
;void net_drv(void)
; 0000 010E {
_net_drv:
; .FSTART _net_drv
; 0000 010F if(++cnt_net_drv>=3)
	LDS  R26,_cnt_net_drv
	SUBI R26,-LOW(1)
	STS  _cnt_net_drv,R26
	CPI  R26,LOW(0x3)
	BRSH PC+2
	RJMP _0x63
; 0000 0110 	{
; 0000 0111 	cnt_net_drv=0;
	LDI  R30,LOW(0)
	STS  _cnt_net_drv,R30
; 0000 0112 	if(++cnt_drv>=4)
	LDS  R26,_cnt_drv
	SUBI R26,-LOW(1)
	STS  _cnt_drv,R26
	CPI  R26,LOW(0x4)
	BRLO _0x64
; 0000 0113 		{
; 0000 0114 		cnt_drv=1;
	LDI  R30,LOW(1)
	STS  _cnt_drv,R30
; 0000 0115 		}
; 0000 0116 
; 0000 0117 	cmnd_byte|=0x80;
_0x64:
	LDS  R30,_cmnd_byte
	ORI  R30,0x80
	STS  _cmnd_byte,R30
; 0000 0118 	state_byte=0xff;
	LDI  R30,LOW(255)
	STS  _state_byte,R30
; 0000 0119 
; 0000 011A 	if(ch_on[0]!=coON)state_byte&=~(1<<0);
	CALL SUBOPT_0x2
	BREQ _0x65
	LDS  R30,_state_byte
	ANDI R30,0xFE
	STS  _state_byte,R30
; 0000 011B 	if(ch_on[1]!=coON)state_byte&=~(1<<1);
_0x65:
	CALL SUBOPT_0x3
	BREQ _0x66
	LDS  R30,_state_byte
	ANDI R30,0xFD
	STS  _state_byte,R30
; 0000 011C 	if(ch_on[2]!=coON)state_byte&=~(1<<2);
_0x66:
	CALL SUBOPT_0x4
	BREQ _0x67
	LDS  R30,_state_byte
	ANDI R30,0xFB
	STS  _state_byte,R30
; 0000 011D 	if(ch_on[3]!=coON)state_byte&=~(1<<3);
_0x67:
	CALL SUBOPT_0x5
	BREQ _0x68
	LDS  R30,_state_byte
	ANDI R30,0XF7
	STS  _state_byte,R30
; 0000 011E 	if(ch_on[4]!=coON)state_byte&=~(1<<4);
_0x68:
	CALL SUBOPT_0x6
	BREQ _0x69
	LDS  R30,_state_byte
	ANDI R30,0xEF
	STS  _state_byte,R30
; 0000 011F 	if(ch_on[5]!=coON)state_byte&=~(1<<5);
_0x69:
	CALL SUBOPT_0x7
	BREQ _0x6A
	LDS  R30,_state_byte
	ANDI R30,0xDF
	STS  _state_byte,R30
; 0000 0120 
; 0000 0121 	crc_byte=cmnd_byte^state_byte;
_0x6A:
	LDS  R30,_state_byte
	LDS  R26,_cmnd_byte
	EOR  R30,R26
	STS  _crc_byte,R30
; 0000 0122 	crc_byte=crc_byte^cnt_drv;
	LDS  R30,_cnt_drv
	LDS  R26,_crc_byte
	EOR  R30,R26
	STS  _crc_byte,R30
; 0000 0123 	crc_byte|=0x80;
	ORI  R30,0x80
	STS  _crc_byte,R30
; 0000 0124 
; 0000 0125 	out_usart(4,cnt_drv,cmnd_byte,state_byte,crc_byte,0,0,0,0,0);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDS  R30,_cnt_drv
	ST   -Y,R30
	LDS  R30,_cmnd_byte
	ST   -Y,R30
	LDS  R30,_state_byte
	ST   -Y,R30
	LDS  R30,_crc_byte
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _out_usart
; 0000 0126 	}
; 0000 0127 }
_0x63:
	RET
; .FEND
;//-----------------------------------------------
;void in_drv(void)
; 0000 012A {
_in_drv:
; .FSTART _in_drv
; 0000 012B char i,temp;
; 0000 012C unsigned int tempUI;
; 0000 012D DDRA&=0x00;
	CALL __SAVELOCR4
;	i -> R17
;	temp -> R16
;	tempUI -> R18,R19
	IN   R30,0x1A
	ANDI R30,LOW(0x0)
	OUT  0x1A,R30
; 0000 012E PORTA|=0xff;
	IN   R30,0x1B
	ORI  R30,LOW(0xFF)
	OUT  0x1B,R30
; 0000 012F in_word_new=PINA;
	IN   R30,0x19
	STS  _in_word_new,R30
; 0000 0130 if(in_word_old==in_word_new)
	LDS  R26,_in_word_old
	CP   R30,R26
	BRNE _0x6B
; 0000 0131 	{
; 0000 0132 	if(in_word_cnt<10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRSH _0x6C
; 0000 0133 		{
; 0000 0134 		in_word_cnt++;
	LDS  R30,_in_word_cnt
	SUBI R30,-LOW(1)
	STS  _in_word_cnt,R30
; 0000 0135 		if(in_word_cnt>=10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRLO _0x6D
; 0000 0136 			{
; 0000 0137 			in_word=in_word_old;
	LDS  R30,_in_word_old
	STS  _in_word,R30
; 0000 0138 			}
; 0000 0139 		}
_0x6D:
; 0000 013A 	}
_0x6C:
; 0000 013B else in_word_cnt=0;
	RJMP _0x6E
_0x6B:
	LDI  R30,LOW(0)
	STS  _in_word_cnt,R30
; 0000 013C 
; 0000 013D 
; 0000 013E in_word_old=in_word_new;
_0x6E:
	LDS  R30,_in_word_new
	STS  _in_word_old,R30
; 0000 013F }
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;
;//-----------------------------------------------
;void err_drv(void)
; 0000 0143 {
_err_drv:
; .FSTART _err_drv
; 0000 0144 if(step_main==sOFF)
	LDS  R30,_step_main
	CPI  R30,0
	BRNE _0x6F
; 0000 0145 	{
; 0000 0146 	if((((state[0]&0b00000011)!=0b00000010)&&(ch_on[0]==coON))
; 0000 0147 		||(((state[0]&0b00011000)!=0b00010000)&&(ch_on[1]==coON))
; 0000 0148 		||(((state[1]&0b00000011)!=0b00000010)&&(ch_on[2]==coON))
; 0000 0149 		||(((state[1]&0b00011000)!=0b00010000)&&(ch_on[3]==coON))
; 0000 014A 		||(((state[2]&0b00000011)!=0b00000010)&&(ch_on[4]==coON))
; 0000 014B 		||(((state[2]&0b00011000)!=0b00010000)&&(ch_on[5]==coON))) bERR=1;
	LDS  R30,_state
	ANDI R30,LOW(0x3)
	CPI  R30,LOW(0x2)
	BREQ _0x71
	CALL SUBOPT_0x2
	BREQ _0x73
_0x71:
	LDS  R30,_state
	ANDI R30,LOW(0x18)
	CPI  R30,LOW(0x10)
	BREQ _0x74
	CALL SUBOPT_0x3
	BREQ _0x73
_0x74:
	__GETB1MN _state,1
	ANDI R30,LOW(0x3)
	CPI  R30,LOW(0x2)
	BREQ _0x76
	CALL SUBOPT_0x4
	BREQ _0x73
_0x76:
	__GETB1MN _state,1
	ANDI R30,LOW(0x18)
	CPI  R30,LOW(0x10)
	BREQ _0x78
	CALL SUBOPT_0x5
	BREQ _0x73
_0x78:
	__GETB1MN _state,2
	ANDI R30,LOW(0x3)
	CPI  R30,LOW(0x2)
	BREQ _0x7A
	CALL SUBOPT_0x6
	BREQ _0x73
_0x7A:
	__GETB1MN _state,2
	ANDI R30,LOW(0x18)
	CPI  R30,LOW(0x10)
	BREQ _0x7C
	CALL SUBOPT_0x7
	BREQ _0x73
_0x7C:
	RJMP _0x70
_0x73:
	SET
	RJMP _0x149
; 0000 014C 	else bERR=0;
_0x70:
	CLT
_0x149:
	BLD  R3,1
; 0000 014D 	}
; 0000 014E else bERR=0;
	RJMP _0x80
_0x6F:
	CLT
	BLD  R3,1
; 0000 014F 
; 0000 0150 }
_0x80:
	RET
; .FEND
;
;//-----------------------------------------------
;void mdvr_drv(void)
; 0000 0154 {
; 0000 0155 if(!(in_word&(1<<MD1)))
; 0000 0156 	{
; 0000 0157 	if(cnt_md1<10)
; 0000 0158 		{
; 0000 0159 		cnt_md1++;
; 0000 015A 		if(cnt_md1==10) bMD1=1;
; 0000 015B 		}
; 0000 015C 
; 0000 015D 	}
; 0000 015E else
; 0000 015F 	{
; 0000 0160 	if(cnt_md1)
; 0000 0161 		{
; 0000 0162 		cnt_md1--;
; 0000 0163 		if(cnt_md1==0) bMD1=0;
; 0000 0164 		}
; 0000 0165 
; 0000 0166 	}
; 0000 0167 
; 0000 0168 if(!(in_word&(1<<MD2)))
; 0000 0169 	{
; 0000 016A 	if(cnt_md2<10)
; 0000 016B 		{
; 0000 016C 		cnt_md2++;
; 0000 016D 		if(cnt_md2==10) bMD2=1;
; 0000 016E 		}
; 0000 016F 
; 0000 0170 	}
; 0000 0171 else
; 0000 0172 	{
; 0000 0173 	if(cnt_md2)
; 0000 0174 		{
; 0000 0175 		cnt_md2--;
; 0000 0176 		if(cnt_md2==0) bMD2=0;
; 0000 0177 		}
; 0000 0178 
; 0000 0179 	}
; 0000 017A 
; 0000 017B if(!(in_word&(1<<MD3)))
; 0000 017C 	{
; 0000 017D 	if(cnt_md3<10)
; 0000 017E 		{
; 0000 017F 		cnt_md3++;
; 0000 0180 		if(cnt_md3==10) bMD3=1;
; 0000 0181 		}
; 0000 0182 
; 0000 0183 	}
; 0000 0184 else
; 0000 0185 	{
; 0000 0186 	if(cnt_md3)
; 0000 0187 		{
; 0000 0188 		cnt_md3--;
; 0000 0189 		if(cnt_md3==0) bMD3=0;
; 0000 018A 		}
; 0000 018B 
; 0000 018C 	}
; 0000 018D 
; 0000 018E if(!(in_word&(1<<VR)))
; 0000 018F 	{
; 0000 0190 	if(cnt_vr<10)
; 0000 0191 		{
; 0000 0192 		cnt_vr++;
; 0000 0193 		if(cnt_vr==10) bVR=1;
; 0000 0194 		}
; 0000 0195 
; 0000 0196 	}
; 0000 0197 else
; 0000 0198 	{
; 0000 0199 	if(cnt_vr)
; 0000 019A 		{
; 0000 019B 		cnt_vr--;
; 0000 019C 		if(cnt_vr==0) bVR=0;
; 0000 019D 		}
; 0000 019E 
; 0000 019F 	}
; 0000 01A0 }
;
;#ifdef P380
;//-----------------------------------------------
;void step_contr(void)
;{
;char temp=0;
;DDRB=0xFF;
;
;if(step==sOFF)
;	{
;	temp=0;
;	}
;
;else if(prog==p1)
;	{
;	if(step==s1)
;		{
;		temp|=(1<<PP1)|(1<<PP2);
;
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			if(ee_vacuum_mode==evmOFF)
;				{
;				goto lbl_0001;
;				}
;			else step=s2;
;			}
;		}
;
;	else if(step==s2)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;
;          if(!bVR)goto step_contr_end;
;lbl_0001:
;#ifndef BIG_CAM
;		cnt_del=30;
;#endif
;
;#ifdef BIG_CAM
;		cnt_del=100;
;#endif
;		step=s3;
;		}
;
;	else if(step==s3)
;		{
;		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=s4;
;			}
;          }
;	else if(step==s4)
;		{
;		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;
;          if(!bMD1)goto step_contr_end;
;
;		cnt_del=30;
;		step=s5;
;		}
;	else if(step==s5)
;		{
;		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=s6;
;			}
;		}
;	else if(step==s6)
;		{
;		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;
;         	if(!bMD2)goto step_contr_end;
;          cnt_del=30;
;		step=s7;
;		}
;	else if(step==s7)
;		{
;		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
;
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=s8;
;			cnt_del=30;
;			}
;		}
;	else if(step==s8)
;		{
;		temp|=(1<<PP1)|(1<<PP3);
;
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=s9;
;#ifndef BIG_CAM
;		cnt_del=150;
;#endif
;
;#ifdef BIG_CAM
;		cnt_del=200;
;#endif
;			}
;		}
;	else if(step==s9)
;		{
;		temp|=(1<<PP1)|(1<<PP2);
;
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=s10;
;			cnt_del=30;
;			}
;		}
;	else if(step==s10)
;		{
;		temp|=(1<<PP2);
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=sOFF;
;			}
;		}
;	}
;
;if(prog==p2)
;	{
;
;	if(step==s1)
;		{
;		temp|=(1<<PP1)|(1<<PP2);
;
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			if(ee_vacuum_mode==evmOFF)
;				{
;				goto lbl_0002;
;				}
;			else step=s2;
;			}
;		}
;
;	else if(step==s2)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;
;          if(!bVR)goto step_contr_end;
;lbl_0002:
;#ifndef BIG_CAM
;		cnt_del=30;
;#endif
;
;#ifdef BIG_CAM
;		cnt_del=100;
;#endif
;		step=s3;
;		}
;
;	else if(step==s3)
;		{
;		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=s4;
;			}
;		}
;
;	else if(step==s4)
;		{
;		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;
;          if(!bMD1)goto step_contr_end;
;         	cnt_del=30;
;		step=s5;
;		}
;
;	else if(step==s5)
;		{
;		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
;
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=s6;
;			cnt_del=30;
;			}
;		}
;
;	else if(step==s6)
;		{
;		temp|=(1<<PP1)|(1<<PP3);
;
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=s7;
;#ifndef BIG_CAM
;		cnt_del=150;
;#endif
;
;#ifdef BIG_CAM
;		cnt_del=200;
;#endif
;			}
;		}
;
;	else if(step==s7)
;		{
;		temp|=(1<<PP1)|(1<<PP2);
;
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=s8;
;			cnt_del=30;
;			}
;		}
;	else if(step==s8)
;		{
;		temp|=(1<<PP2);
;
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=sOFF;
;			}
;		}
;	}
;
;if(prog==p3)
;	{
;
;	if(step==s1)
;		{
;		temp|=(1<<PP1)|(1<<PP2);
;
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			if(ee_vacuum_mode==evmOFF)
;				{
;				goto lbl_0003;
;				}
;			else step=s2;
;			}
;		}
;
;	else if(step==s2)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;
;          if(!bVR)goto step_contr_end;
;lbl_0003:
;#ifndef BIG_CAM
;		cnt_del=80;
;#endif
;
;#ifdef BIG_CAM
;		cnt_del=100;
;#endif
;		step=s3;
;		}
;
;	else if(step==s3)
;		{
;		temp|=(1<<PP1)|(1<<PP3);
;
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=s4;
;			cnt_del=120;
;			}
;		}
;
;	else if(step==s4)
;		{
;		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<PP5);
;
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=s5;
;
;
;#ifndef BIG_CAM
;		cnt_del=150;
;#endif
;
;#ifdef BIG_CAM
;		cnt_del=200;
;#endif
;	//	step=s5;
;	}
;		}
;
;	else if(step==s5)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<PP5);
;
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=s6;
;			cnt_del=30;
;			}
;		}
;
;	else if(step==s6)
;		{
;		temp|=(1<<PP2)|(1<<PP4)|(1<<PP5);
;
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=s7;
;			cnt_del=30;
;			}
;		}
;
;	else if(step==s7)
;		{
;		temp|=(1<<PP2);
;
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=sOFF;
;			}
;		}
;
;	}
;step_contr_end:
;
;if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;
;PORTB=~temp;
;}
;#endif
;#ifdef I380
;//-----------------------------------------------
;void step_contr(void)
;{
;char temp=0;
;DDRB=0xFF;
;
;if(step==sOFF)goto step_contr_end;
;
;else if(prog==p1)
;	{
;	if(step==s1)    //жесть
;		{
;		temp|=(1<<PP1);
;          if(!bMD1)goto step_contr_end;
;
;		}
;
;	else if(step==s2)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;          if(!bVR)goto step_contr_end;
;lbl_0001:
;
;          step=s100;
;		cnt_del=40;
;          }
;	else if(step==s100)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s3;
;          	cnt_del=50;
;			}
;		}
;
;	else if(step==s3)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s4;
;			}
;		}
;	else if(step==s4)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;          if(!bMD2)goto step_contr_end;
;          step=s5;
;          cnt_del=20;
;		}
;	else if(step==s5)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s6;
;			}
;          }
;	else if(step==s6)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
;          if(!bMD3)goto step_contr_end;
;          step=s7;
;          cnt_del=20;
;		}
;
;
;	else if(step==s8)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s9;
;          	cnt_del=20;
;			}
;          }
;	else if(step==s9)
;		{
;		temp|=(1<<PP1);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=sOFF;
;          	}
;          }
;	}
;
;else if(prog==p2)  //ско
;	{
;	if(step==s1)
;		{
;		temp|=(1<<PP1);
;          if(!bMD1)goto step_contr_end;
;
;
;          //step=s2;
;		}
;
;	else if(step==s2)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;          if(!bVR)goto step_contr_end;
;
;lbl_0002:
;          step=s100;
;		cnt_del=40;
;          }
;	else if(step==s100)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s3;
;          	cnt_del=50;
;			}
;		}
;	else if(step==s3)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s4;
;			}
;		}
;	else if(step==s4)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;          if(!bMD2)goto step_contr_end;
;          step=s5;
;          cnt_del=20;
;		}
;	else if(step==s6)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s7;
;          	cnt_del=20;
;			}
;          }
;	else if(step==s7)
;		{
;		temp|=(1<<PP1);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=sOFF;
;          	}
;          }
;	}
;
;else if(prog==p3)   //твист
;	{
;	if(step==s1)
;		{
;		temp|=(1<<PP1);
;          if(!bMD1)goto step_contr_end;
;
;
;          //step=s2;
;		}
;
;	else if(step==s2)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;          if(!bVR)goto step_contr_end;
;lbl_0003:
;          cnt_del=50;
;		step=s3;
;		}
;
;
;
;	else if(step==s4)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;		cnt_del--;
; 		}
;
;	else if(step==s5)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=s6;
;			cnt_del=20;
;			}
;		}
;
;	else if(step==s6)
;		{
;		temp|=(1<<PP1);
;  		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=sOFF;
;			}
;		}
;
;	}
;
;else if(prog==p4)      //замок
;	{
;	if(step==s1)
;		{
;		temp|=(1<<PP1);
;          if(!bMD1)goto step_contr_end;
;
;          //step=s2;
;		}
;
;	else if(step==s2)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;          if(!bVR)goto step_contr_end;
;lbl_0004:
;          step=s3;
;		cnt_del=50;
;          }
;
;
;
;   	else if(step==s4)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=s5;
;			cnt_del=30;
;			}
;		}
;
;	else if(step==s5)
;		{
;		temp|=(1<<PP1)|(1<<PP4);
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=s6;
;			}
;		}
;
;	else if(step==s6)
;		{
;		temp|=(1<<PP4);
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=sOFF;
;			}
;		}
;
;	}
;
;step_contr_end:
;
;
;PORTB=~temp;
;//PORTB=0x55;
;}
;#endif
;
;
;//-----------------------------------------------
;void bin2bcd_int(unsigned int in)
; 0000 0412 {
_bin2bcd_int:
; .FSTART _bin2bcd_int
; 0000 0413 char i;
; 0000 0414 for(i=3;i>0;i--)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	in -> Y+1
;	i -> R17
	LDI  R17,LOW(3)
_0x9A:
	CPI  R17,1
	BRLO _0x9B
; 0000 0415 	{
; 0000 0416 	dig[i]=in%10;
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	MOVW R22,R30
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	MOVW R26,R22
	ST   X,R30
; 0000 0417 	in/=10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
; 0000 0418 	}
	SUBI R17,1
	RJMP _0x9A
_0x9B:
; 0000 0419 }
	LDD  R17,Y+0
	RJMP _0x2060001
; .FEND
;
;//-----------------------------------------------
;void bcd2ind(char s)
; 0000 041D {
_bcd2ind:
; .FSTART _bcd2ind
; 0000 041E char i;
; 0000 041F bZ=1;
	ST   -Y,R26
	ST   -Y,R17
;	s -> Y+1
;	i -> R17
	SET
	BLD  R2,3
; 0000 0420 for (i=0;i<5;i++)
	LDI  R17,LOW(0)
_0x9D:
	CPI  R17,5
	BRLO PC+2
	RJMP _0x9E
; 0000 0421 	{
; 0000 0422 	if(bZ&&(!dig[i-1])&&(i<4))
	SBRS R2,3
	RJMP _0xA0
	MOV  R30,R17
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	CPI  R30,0
	BRNE _0xA0
	CPI  R17,4
	BRLO _0xA1
_0xA0:
	RJMP _0x9F
_0xA1:
; 0000 0423 		{
; 0000 0424 		if((4-i)>s)
	LDI  R30,LOW(4)
	SUB  R30,R17
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
	BRSH _0xA2
; 0000 0425 			{
; 0000 0426 			ind_out[i-1]=DIGISYM[10];
	CALL SUBOPT_0x8
	__POINTW1FN _DIGISYM,10
	RJMP _0x14A
; 0000 0427 			}
; 0000 0428 		else ind_out[i-1]=DIGISYM[0];
_0xA2:
	CALL SUBOPT_0x8
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
_0x14A:
	LPM  R30,Z
	ST   X,R30
; 0000 0429 		}
; 0000 042A 	else
	RJMP _0xA4
_0x9F:
; 0000 042B 		{
; 0000 042C 		ind_out[i-1]=DIGISYM[dig[i-1]];
	MOV  R30,R17
	SUBI R30,LOW(1)
	LDI  R31,0
	MOVW R0,R30
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	MOVW R26,R30
	MOVW R30,R0
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	LDI  R31,0
	SUBI R30,LOW(-_DIGISYM*2)
	SBCI R31,HIGH(-_DIGISYM*2)
	LPM  R30,Z
	ST   X,R30
; 0000 042D 		bZ=0;
	CLT
	BLD  R2,3
; 0000 042E 		}
_0xA4:
; 0000 042F 
; 0000 0430 	if(s)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0xA5
; 0000 0431 		{
; 0000 0432 		ind_out[3-s]&=0b01111111;
	LDD  R26,Y+1
	LDI  R30,LOW(3)
	SUB  R30,R26
	LDI  R31,0
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	MOVW R26,R30
	LD   R30,X
	ANDI R30,0x7F
	ST   X,R30
; 0000 0433 		}
; 0000 0434 
; 0000 0435 	}
_0xA5:
	SUBI R17,-1
	RJMP _0x9D
_0x9E:
; 0000 0436 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
; .FEND
;//-----------------------------------------------
;void int2ind(unsigned int in,char s)
; 0000 0439 {
_int2ind:
; .FSTART _int2ind
; 0000 043A bin2bcd_int(in);
	ST   -Y,R26
;	in -> Y+1
;	s -> Y+0
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL _bin2bcd_int
; 0000 043B bcd2ind(s);
	LD   R26,Y
	RCALL _bcd2ind
; 0000 043C 
; 0000 043D }
_0x2060001:
	ADIW R28,3
	RET
; .FEND
;
;//-----------------------------------------------
;void uart_in_an(void)
; 0000 0441 {
_uart_in_an:
; .FSTART _uart_in_an
; 0000 0442 state[rx_buffer[0]-1]=rx_buffer[1];
	LDS  R30,_rx_buffer
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_state)
	SBCI R31,HIGH(-_state)
	__GETB2MN _rx_buffer,1
	STD  Z+0,R26
; 0000 0443 
; 0000 0444 /*state_new=rx_buffer[2];
; 0000 0445 if(state_new==state_old)
; 0000 0446 	{
; 0000 0447 	if(state_cnt<4)
; 0000 0448 		{
; 0000 0449 		state_cnt++;
; 0000 044A 		if(state_cnt>=4)
; 0000 044B 			{
; 0000 044C 			if((state_new&0x7f)!=state)
; 0000 044D 				{
; 0000 044E 				state=state_new&0x7f;
; 0000 044F 				state_an();
; 0000 0450 				}
; 0000 0451 			}
; 0000 0452 		}
; 0000 0453 	}
; 0000 0454 else state_cnt=0;
; 0000 0455 state_old=state_new;*/
; 0000 0456 
; 0000 0457 /*state=rx_buffer[2];
; 0000 0458 state_an();*/
; 0000 0459 
; 0000 045A }
	RET
; .FEND
;
;
;//-----------------------------------------------
;void mathemat(void)
; 0000 045F {
_mathemat:
; .FSTART _mathemat
; 0000 0460 timer1_delay=ee_timer1_delay*31;
	CALL SUBOPT_0x9
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	CALL __MULW12U
	STS  _timer1_delay,R30
	STS  _timer1_delay+1,R31
; 0000 0461 }
	RET
; .FEND
;
;//-----------------------------------------------
;void ind_hndl(void)
; 0000 0465 {
_ind_hndl:
; .FSTART _ind_hndl
; 0000 0466 if(ind==iMn)
	LDS  R30,_ind
	CPI  R30,0
	BRNE _0xA6
; 0000 0467 	{
; 0000 0468 //int2ind(ee_delay[prog,sub_ind],1);
; 0000 0469 //ind_out[0]=0xff;//DIGISYM[0];
; 0000 046A //ind_out[1]=0xff;//DIGISYM[1];
; 0000 046B //ind_out[2]=DIGISYM[2];//0xff;
; 0000 046C //ind_out[0]=DIGISYM[7];
; 0000 046D 
; 0000 046E //ind_out[0]=DIGISYM[sub_ind+1];
; 0000 046F 
; 0000 0470 	int2ind(step_main,0);
	LDS  R30,_step_main
	LDI  R31,0
	CALL SUBOPT_0xA
; 0000 0471 	//int2ind(stop_cnt,0);
; 0000 0472 	}
; 0000 0473 else if(ind==iSet_sel)
	RJMP _0xA7
_0xA6:
	LDS  R26,_ind
	CPI  R26,LOW(0x2)
	BREQ PC+2
	RJMP _0xA8
; 0000 0474 	{
; 0000 0475 	if(sub_ind==0)
	LDS  R30,_sub_ind
	CPI  R30,0
	BRNE _0xA9
; 0000 0476 		{
; 0000 0477 		if(ch_on[0]==coON)
	CALL SUBOPT_0x2
	BRNE _0xAA
; 0000 0478 			{
; 0000 0479 			ind_out[3]=SYMn;
	CALL SUBOPT_0xB
; 0000 047A 			ind_out[2]=SYMo;
; 0000 047B 			ind_out[1]=SYM;
	RJMP _0x14B
; 0000 047C 			}
; 0000 047D 		else
_0xAA:
; 0000 047E 			{
; 0000 047F 			ind_out[3]=SYMf;
	CALL SUBOPT_0xC
; 0000 0480 			ind_out[2]=SYMf;
; 0000 0481 			ind_out[1]=SYMo;
_0x14B:
	__PUTB1MN _ind_out,1
; 0000 0482 			}
; 0000 0483 		}
; 0000 0484 	else if(sub_ind==1)
	RJMP _0xAC
_0xA9:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x1)
	BRNE _0xAD
; 0000 0485 		{
; 0000 0486 		if(ch_on[1]==coON)
	CALL SUBOPT_0x3
	BRNE _0xAE
; 0000 0487 			{
; 0000 0488 			ind_out[3]=SYMn;
	CALL SUBOPT_0xB
; 0000 0489 			ind_out[2]=SYMo;
; 0000 048A 			ind_out[1]=SYM;
	RJMP _0x14C
; 0000 048B 			}
; 0000 048C 		else
_0xAE:
; 0000 048D 			{
; 0000 048E 			ind_out[3]=SYMf;
	CALL SUBOPT_0xC
; 0000 048F 			ind_out[2]=SYMf;
; 0000 0490 			ind_out[1]=SYMo;
_0x14C:
	__PUTB1MN _ind_out,1
; 0000 0491 			}
; 0000 0492 		}
; 0000 0493 
; 0000 0494 	else if(sub_ind==2)
	RJMP _0xB0
_0xAD:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x2)
	BRNE _0xB1
; 0000 0495 		{
; 0000 0496 		if(ch_on[2]==coON)
	CALL SUBOPT_0x4
	BRNE _0xB2
; 0000 0497 			{
; 0000 0498 			ind_out[3]=SYMn;
	CALL SUBOPT_0xB
; 0000 0499 			ind_out[2]=SYMo;
; 0000 049A 			ind_out[1]=SYM;
	RJMP _0x14D
; 0000 049B 			}
; 0000 049C 		else
_0xB2:
; 0000 049D 			{
; 0000 049E 			ind_out[3]=SYMf;
	CALL SUBOPT_0xC
; 0000 049F 			ind_out[2]=SYMf;
; 0000 04A0 			ind_out[1]=SYMo;
_0x14D:
	__PUTB1MN _ind_out,1
; 0000 04A1 			}
; 0000 04A2 		}
; 0000 04A3 
; 0000 04A4 	else if(sub_ind==3)
	RJMP _0xB4
_0xB1:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x3)
	BRNE _0xB5
; 0000 04A5 		{
; 0000 04A6 		if(ch_on[3]==coON)
	CALL SUBOPT_0x5
	BRNE _0xB6
; 0000 04A7 			{
; 0000 04A8 			ind_out[3]=SYMn;
	CALL SUBOPT_0xB
; 0000 04A9 			ind_out[2]=SYMo;
; 0000 04AA 			ind_out[1]=SYM;
	RJMP _0x14E
; 0000 04AB 			}
; 0000 04AC 		else
_0xB6:
; 0000 04AD 			{
; 0000 04AE 			ind_out[3]=SYMf;
	CALL SUBOPT_0xC
; 0000 04AF 			ind_out[2]=SYMf;
; 0000 04B0 			ind_out[1]=SYMo;
_0x14E:
	__PUTB1MN _ind_out,1
; 0000 04B1 			}
; 0000 04B2 		}
; 0000 04B3 
; 0000 04B4 	else if(sub_ind==4)
	RJMP _0xB8
_0xB5:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x4)
	BRNE _0xB9
; 0000 04B5 		{
; 0000 04B6 		if(ch_on[4]==coON)
	CALL SUBOPT_0x6
	BRNE _0xBA
; 0000 04B7 			{
; 0000 04B8 			ind_out[3]=SYMn;
	CALL SUBOPT_0xB
; 0000 04B9 			ind_out[2]=SYMo;
; 0000 04BA 			ind_out[1]=SYM;
	RJMP _0x14F
; 0000 04BB 			}
; 0000 04BC 		else
_0xBA:
; 0000 04BD 			{
; 0000 04BE 			ind_out[3]=SYMf;
	CALL SUBOPT_0xC
; 0000 04BF 			ind_out[2]=SYMf;
; 0000 04C0 			ind_out[1]=SYMo;
_0x14F:
	__PUTB1MN _ind_out,1
; 0000 04C1 			}
; 0000 04C2 		}
; 0000 04C3 
; 0000 04C4 	else if(sub_ind==5)
	RJMP _0xBC
_0xB9:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x5)
	BRNE _0xBD
; 0000 04C5 		{
; 0000 04C6 		if(ch_on[5]==coON)
	CALL SUBOPT_0x7
	BRNE _0xBE
; 0000 04C7 			{
; 0000 04C8 			ind_out[3]=SYMn;
	CALL SUBOPT_0xB
; 0000 04C9 			ind_out[2]=SYMo;
; 0000 04CA 			ind_out[1]=SYM;
	RJMP _0x150
; 0000 04CB 			}
; 0000 04CC 		else
_0xBE:
; 0000 04CD 			{
; 0000 04CE 			ind_out[3]=SYMf;
	CALL SUBOPT_0xC
; 0000 04CF 			ind_out[2]=SYMf;
; 0000 04D0 			ind_out[1]=SYMo;
_0x150:
	__PUTB1MN _ind_out,1
; 0000 04D1 			}
; 0000 04D2 		}
; 0000 04D3 
; 0000 04D4 	else if(sub_ind==6)
	RJMP _0xC0
_0xBD:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x6)
	BRNE _0xC1
; 0000 04D5 		{
; 0000 04D6 		int2ind(ee_timer1_delay,0);
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
; 0000 04D7 		}
; 0000 04D8 	else if(sub_ind==7)
	RJMP _0xC2
_0xC1:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x7)
	BRNE _0xC3
; 0000 04D9 		{
; 0000 04DA 		ind_out[3]=SYMt;
	LDI  R30,LOW(135)
	__PUTB1MN _ind_out,3
; 0000 04DB 		ind_out[2]=SYMu;
	LDI  R30,LOW(227)
	__PUTB1MN _ind_out,2
; 0000 04DC 		ind_out[1]=SYMo;
	LDI  R30,LOW(163)
	__PUTB1MN _ind_out,1
; 0000 04DD 		}
; 0000 04DE 	if(sub_ind!=7)ind_out[0]=DIGISYM[sub_ind+1];
_0xC3:
_0xC2:
_0xC0:
_0xBC:
_0xB8:
_0xB4:
_0xB0:
_0xAC:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x7)
	BREQ _0xC4
	LDS  R30,_sub_ind
	LDI  R31,0
	__ADDW1FN _DIGISYM,1
	LPM  R0,Z
	STS  _ind_out,R0
; 0000 04DF 	else ind_out[0]=SYM;
	RJMP _0xC5
_0xC4:
	LDI  R30,LOW(255)
	STS  _ind_out,R30
; 0000 04E0 	if(bFL5)ind_out[0]=SYM;
_0xC5:
	SBRS R3,0
	RJMP _0xC6
	LDI  R30,LOW(255)
	STS  _ind_out,R30
; 0000 04E1 	}
_0xC6:
; 0000 04E2 
; 0000 04E3 else if(ind==iCh_on)
	RJMP _0xC7
_0xA8:
	LDS  R26,_ind
	CPI  R26,LOW(0x4)
	BRNE _0xC8
; 0000 04E4 	{
; 0000 04E5 	ind_out[0]=SYM;
	LDI  R30,LOW(255)
	STS  _ind_out,R30
; 0000 04E6 	if(ch_on[sub_ind]==coON)
	CALL SUBOPT_0xD
	BRNE _0xC9
; 0000 04E7 		{
; 0000 04E8 		ind_out[3]=SYMn;
	CALL SUBOPT_0xB
; 0000 04E9 		ind_out[2]=SYMo;
; 0000 04EA 		ind_out[1]=SYM;
	RJMP _0x151
; 0000 04EB 		}
; 0000 04EC     	else
_0xC9:
; 0000 04ED     		{
; 0000 04EE     		ind_out[3]=SYMf;
	CALL SUBOPT_0xC
; 0000 04EF 		ind_out[2]=SYMf;
; 0000 04F0 		ind_out[1]=SYMo;
_0x151:
	__PUTB1MN _ind_out,1
; 0000 04F1 		}
; 0000 04F2 	if(bFL5)
	SBRS R3,0
	RJMP _0xCB
; 0000 04F3 		{
; 0000 04F4 		ind_out[3]=SYM;
	CALL SUBOPT_0xE
; 0000 04F5 		ind_out[2]=SYM;
; 0000 04F6 		ind_out[1]=SYM;
; 0000 04F7 		}
; 0000 04F8 	}
_0xCB:
; 0000 04F9 
; 0000 04FA else if(ind==iSet_delay)
	RJMP _0xCC
_0xC8:
	LDS  R26,_ind
	CPI  R26,LOW(0x3)
	BRNE _0xCD
; 0000 04FB 	{
; 0000 04FC 	ind_out[0]=SYM;
	LDI  R30,LOW(255)
	STS  _ind_out,R30
; 0000 04FD 	int2ind(ee_timer1_delay,0);
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
; 0000 04FE 	if(bFL5)
	SBRS R3,0
	RJMP _0xCE
; 0000 04FF 		{
; 0000 0500 		ind_out[3]=SYM;
	CALL SUBOPT_0xE
; 0000 0501 		ind_out[2]=SYM;
; 0000 0502 		ind_out[1]=SYM;
; 0000 0503 		}
; 0000 0504 	}
_0xCE:
; 0000 0505 }
_0xCD:
_0xCC:
_0xC7:
_0xA7:
	RET
; .FEND
;
;//-----------------------------------------------
;void led_hndl(void)
; 0000 0509 {
_led_hndl:
; .FSTART _led_hndl
; 0000 050A ind_out[4]=DIGISYM[10];
	__POINTW1FN _DIGISYM,10
	LPM  R0,Z
	__PUTBR0MN _ind_out,4
; 0000 050B 
; 0000 050C ind_out[4]&=~(1<<LED_POW_ON);
	__POINTW2MN _ind_out,4
	LD   R30,X
	ANDI R30,0xDF
	ST   X,R30
; 0000 050D 
; 0000 050E if(step_main!=sOFF)
	LDS  R30,_step_main
	CPI  R30,0
	BREQ _0xCF
; 0000 050F 	{
; 0000 0510 	ind_out[4]&=~(1<<LED_WRK);
	__POINTW2MN _ind_out,4
	LD   R30,X
	ANDI R30,0xBF
	RJMP _0x152
; 0000 0511 	}
; 0000 0512 else ind_out[4]|=(1<<LED_WRK);
_0xCF:
	__POINTW2MN _ind_out,4
	LD   R30,X
	ORI  R30,0x40
_0x152:
	ST   X,R30
; 0000 0513 
; 0000 0514 
; 0000 0515 if(step_main==sOFF)
	LDS  R30,_step_main
	CPI  R30,0
	BRNE _0xD1
; 0000 0516 	{
; 0000 0517  	if(bERR)
	SBRS R3,1
	RJMP _0xD2
; 0000 0518 		{
; 0000 0519 		ind_out[4]&=~(1<<LED_ERROR);
	__POINTW2MN _ind_out,4
	LD   R30,X
	ANDI R30,0xFE
	RJMP _0x153
; 0000 051A 		}
; 0000 051B 	else
_0xD2:
; 0000 051C 		{
; 0000 051D 		ind_out[4]|=(1<<LED_ERROR);
	__POINTW2MN _ind_out,4
	LD   R30,X
	ORI  R30,1
_0x153:
	ST   X,R30
; 0000 051E 		}
; 0000 051F      }
; 0000 0520 else ind_out[4]|=(1<<LED_ERROR);
	RJMP _0xD4
_0xD1:
	__POINTW2MN _ind_out,4
	LD   R30,X
	ORI  R30,1
	ST   X,R30
; 0000 0521 
; 0000 0522 
; 0000 0523 //if(bERR)ind_out[4]&=~(1<<LED_ERROR);
; 0000 0524 if(avtom_mode==amON)ind_out[4]&=~(1<<LED_AVTOM);
_0xD4:
	LDS  R26,_avtom_mode
	CPI  R26,LOW(0x55)
	BRNE _0xD5
	__POINTW2MN _ind_out,4
	LD   R30,X
	ANDI R30,0x7F
	RJMP _0x154
; 0000 0525 else ind_out[4]|=(1<<LED_AVTOM);
_0xD5:
	__POINTW2MN _ind_out,4
	LD   R30,X
	ORI  R30,0x80
_0x154:
	ST   X,R30
; 0000 0526 
; 0000 0527 if(ind==iSet_delay)
	LDS  R26,_ind
	CPI  R26,LOW(0x3)
	BRNE _0xD7
; 0000 0528 	{
; 0000 0529 	if(bFL5)ind_out[4]&=~(1<<LED_PROG4);
	SBRS R3,0
	RJMP _0xD8
	__POINTW2MN _ind_out,4
	LD   R30,X
	ANDI R30,0xFD
	ST   X,R30
; 0000 052A      }
_0xD8:
; 0000 052B }
_0xD7:
	RET
; .FEND
;
;//-----------------------------------------------
;// Подпрограмма драйва до 7 кнопок одного порта,
;// различает короткое и длинное нажатие,
;// срабатывает на отпускание кнопки, возможность
;// ускорения перебора при длинном нажатии...
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
; 0000 053E {
_but_drv:
; .FSTART _but_drv
; 0000 053F DDRD&=0b00000111;
	IN   R30,0x11
	ANDI R30,LOW(0x7)
	OUT  0x11,R30
; 0000 0540 PORTD|=0b11111000;
	IN   R30,0x12
	ORI  R30,LOW(0xF8)
	OUT  0x12,R30
; 0000 0541 
; 0000 0542 but_port|=(but_mask^0xff);
	CALL SUBOPT_0xF
; 0000 0543 but_dir&=but_mask;
; 0000 0544 #asm
; 0000 0545 nop
nop
; 0000 0546 nop
nop
; 0000 0547 nop
nop
; 0000 0548 nop
nop
; 0000 0549 nop
nop
; 0000 054A nop
nop
; 0000 054B nop
nop
; 0000 054C 

; 0000 054D 

; 0000 054E #endasm
; 0000 054F 
; 0000 0550 but_n=but_pin|but_mask;
	IN   R30,0x13
	ORI  R30,LOW(0x6A)
	STS  _but_n_G000,R30
; 0000 0551 
; 0000 0552 if((but_n==no_but)||(but_n!=but_s))
	LDS  R26,_but_n_G000
	CPI  R26,LOW(0xFF)
	BREQ _0xDA
	LDS  R30,_but_s_G000
	CP   R30,R26
	BREQ _0xD9
_0xDA:
; 0000 0553  	{
; 0000 0554  	speed=0;
	CLT
	BLD  R2,6
; 0000 0555    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
	LDS  R26,_but0_cnt_G000
	CPI  R26,LOW(0x5)
	BRSH _0xDD
	LDS  R26,_but1_cnt_G000
	CPI  R26,LOW(0x0)
	BREQ _0xDF
_0xDD:
	SBRS R2,4
	RJMP _0xE0
_0xDF:
	RJMP _0xDC
_0xE0:
; 0000 0556   		{
; 0000 0557    	     n_but=1;
	SET
	BLD  R2,5
; 0000 0558           but=but_s;
	LDS  R14,_but_s_G000
; 0000 0559           }
; 0000 055A    	if (but1_cnt>=but_onL_temp)
_0xDC:
	LDS  R30,_but_onL_temp_G000
	LDS  R26,_but1_cnt_G000
	CP   R26,R30
	BRLO _0xE1
; 0000 055B   		{
; 0000 055C    	     n_but=1;
	SET
	BLD  R2,5
; 0000 055D           but=but_s&0b11111101;
	LDS  R30,_but_s_G000
	ANDI R30,0xFD
	MOV  R14,R30
; 0000 055E           }
; 0000 055F     	l_but=0;
_0xE1:
	CLT
	BLD  R2,4
; 0000 0560    	but_onL_temp=but_onL;
	LDI  R30,LOW(20)
	STS  _but_onL_temp_G000,R30
; 0000 0561     	but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G000,R30
; 0000 0562   	but1_cnt=0;
	STS  _but1_cnt_G000,R30
; 0000 0563      goto but_drv_out;
	RJMP _0xE2
; 0000 0564   	}
; 0000 0565 
; 0000 0566 if(but_n==but_s)
_0xD9:
	LDS  R30,_but_s_G000
	LDS  R26,_but_n_G000
	CP   R30,R26
	BRNE _0xE3
; 0000 0567  	{
; 0000 0568   	but0_cnt++;
	LDS  R30,_but0_cnt_G000
	SUBI R30,-LOW(1)
	STS  _but0_cnt_G000,R30
; 0000 0569   	if(but0_cnt>=but_on)
	LDS  R26,_but0_cnt_G000
	CPI  R26,LOW(0x5)
	BRLO _0xE4
; 0000 056A   		{
; 0000 056B    		but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G000,R30
; 0000 056C    		but1_cnt++;
	LDS  R30,_but1_cnt_G000
	SUBI R30,-LOW(1)
	STS  _but1_cnt_G000,R30
; 0000 056D    		if(but1_cnt>=but_onL_temp)
	LDS  R30,_but_onL_temp_G000
	LDS  R26,_but1_cnt_G000
	CP   R26,R30
	BRLO _0xE5
; 0000 056E    			{
; 0000 056F     			but=but_s&0b11111101;
	LDS  R30,_but_s_G000
	ANDI R30,0xFD
	MOV  R14,R30
; 0000 0570     			but1_cnt=0;
	LDI  R30,LOW(0)
	STS  _but1_cnt_G000,R30
; 0000 0571     			n_but=1;
	SET
	BLD  R2,5
; 0000 0572     			l_but=1;
	BLD  R2,4
; 0000 0573 			if(speed)
	SBRS R2,6
	RJMP _0xE6
; 0000 0574 				{
; 0000 0575     				but_onL_temp=but_onL_temp>>1;
	LDS  R30,_but_onL_temp_G000
	LSR  R30
	STS  _but_onL_temp_G000,R30
; 0000 0576         			if(but_onL_temp<=2) but_onL_temp=2;
	LDS  R26,_but_onL_temp_G000
	CPI  R26,LOW(0x3)
	BRSH _0xE7
	LDI  R30,LOW(2)
	STS  _but_onL_temp_G000,R30
; 0000 0577 				}
_0xE7:
; 0000 0578    			}
_0xE6:
; 0000 0579   		}
_0xE5:
; 0000 057A  	}
_0xE4:
; 0000 057B but_drv_out:
_0xE3:
_0xE2:
; 0000 057C but_s=but_n;
	LDS  R30,_but_n_G000
	STS  _but_s_G000,R30
; 0000 057D but_port|=(but_mask^0xff);
	CALL SUBOPT_0xF
; 0000 057E but_dir&=but_mask;
; 0000 057F }
	RET
; .FEND
;
;#define butA	239
;#define butA_	237
;#define butP	251
;#define butP_	249
;#define butR	127
;#define butR_	125
;#define butL	254
;#define butL_	252
;#define butLR	126
;#define butLR_	124
;//-----------------------------------------------
;void but_an(void)
; 0000 058D {
_but_an:
; .FSTART _but_an
; 0000 058E 
; 0000 058F if(!(in_word&0x10)) //старт
	LDS  R30,_in_word
	ANDI R30,LOW(0x10)
	BRNE _0xE8
; 0000 0590 	{
; 0000 0591      if(ind==iSet_delay)
	LDS  R26,_ind
	CPI  R26,LOW(0x3)
	BRNE _0xE9
; 0000 0592      	{
; 0000 0593      	if(motor_state!=msON)
	LDS  R26,_motor_state
	CPI  R26,LOW(0x55)
	BREQ _0xEA
; 0000 0594      		{
; 0000 0595      		motor_state=msON;
	LDI  R30,LOW(85)
	STS  _motor_state,R30
; 0000 0596      		//start_cnt=20;
; 0000 0597      		bDel=0;
	CLT
	BLD  R3,7
; 0000 0598      		}
; 0000 0599      	}
_0xEA:
; 0000 059A      else if(ind==iMn)
	RJMP _0xEB
_0xE9:
	LDS  R30,_ind
	CPI  R30,0
	BRNE _0xEC
; 0000 059B      	{
; 0000 059C      	if((step_main==sOFF)&&(!bERR))step_main=s1;
	LDS  R26,_step_main
	CPI  R26,LOW(0x0)
	BRNE _0xEE
	SBRS R3,1
	RJMP _0xEF
_0xEE:
	RJMP _0xED
_0xEF:
	LDI  R30,LOW(1)
	STS  _step_main,R30
; 0000 059D      	}
_0xED:
; 0000 059E 	}
_0xEC:
_0xEB:
; 0000 059F if(!(in_word&0x80)) //стоп
_0xE8:
	LDS  R30,_in_word
	ANDI R30,LOW(0x80)
	BRNE _0xF0
; 0000 05A0 	{
; 0000 05A1      if(ind==iSet_delay)
	LDS  R26,_ind
	CPI  R26,LOW(0x3)
	BRNE _0xF1
; 0000 05A2      	{
; 0000 05A3      	if(motor_state==msON)
	LDS  R26,_motor_state
	CPI  R26,LOW(0x55)
	BRNE _0xF2
; 0000 05A4      		{
; 0000 05A5      		motor_state=msOFF;
	LDI  R30,LOW(170)
	STS  _motor_state,R30
; 0000 05A6      		stop_cnt=100;
	LDI  R30,LOW(100)
	STS  _stop_cnt,R30
; 0000 05A7      		}
; 0000 05A8      	}
_0xF2:
; 0000 05A9       else if(ind==iMn)
	RJMP _0xF3
_0xF1:
	LDS  R30,_ind
	CPI  R30,0
	BRNE _0xF4
; 0000 05AA      	{
; 0000 05AB      	if(step_main!=sOFF)
	LDS  R30,_step_main
	CPI  R30,0
	BREQ _0xF5
; 0000 05AC      		{
; 0000 05AD      		step_main=sOFF;
	LDI  R30,LOW(0)
	STS  _step_main,R30
; 0000 05AE      		}
; 0000 05AF      	if(motor_state!=msOFF)
_0xF5:
	LDS  R26,_motor_state
	CPI  R26,LOW(0xAA)
	BREQ _0xF6
; 0000 05B0      		{
; 0000 05B1      		motor_state=msOFF;
	LDI  R30,LOW(170)
	STS  _motor_state,R30
; 0000 05B2      		stop_cnt=200;
	LDI  R30,LOW(200)
	STS  _stop_cnt,R30
; 0000 05B3      		}
; 0000 05B4      	}
_0xF6:
; 0000 05B5 
; 0000 05B6 	}
_0xF4:
_0xF3:
; 0000 05B7 
; 0000 05B8 if (!n_but) goto but_an_end;
_0xF0:
	SBRS R2,5
	RJMP _0xF8
; 0000 05B9 
; 0000 05BA if(but==butA_)
	LDI  R30,LOW(237)
	CP   R30,R14
	BRNE _0xF9
; 0000 05BB 	{
; 0000 05BC 	if(ee_avtom_mode==eamON)ee_avtom_mode=eamOFF;
	LDI  R26,LOW(_ee_avtom_mode)
	LDI  R27,HIGH(_ee_avtom_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0xFA
	LDI  R26,LOW(_ee_avtom_mode)
	LDI  R27,HIGH(_ee_avtom_mode)
	LDI  R30,LOW(170)
	RJMP _0x155
; 0000 05BD 	else ee_avtom_mode=eamON;
_0xFA:
	LDI  R26,LOW(_ee_avtom_mode)
	LDI  R27,HIGH(_ee_avtom_mode)
	LDI  R30,LOW(85)
_0x155:
	CALL __EEPROMWRB
; 0000 05BE 	}
; 0000 05BF 
; 0000 05C0 if(ind==iMn)
_0xF9:
	LDS  R30,_ind
	CPI  R30,0
	BRNE _0xFC
; 0000 05C1 	{
; 0000 05C2 	if(but==butP_)
	LDI  R30,LOW(249)
	CP   R30,R14
	BRNE _0xFD
; 0000 05C3 		{
; 0000 05C4 		ind=iSet_sel;
	LDI  R30,LOW(2)
	STS  _ind,R30
; 0000 05C5 		sub_ind=0;
	LDI  R30,LOW(0)
	STS  _sub_ind,R30
; 0000 05C6 		}
; 0000 05C7 	}
_0xFD:
; 0000 05C8 
; 0000 05C9 else if(ind==iSet_sel)
	RJMP _0xFE
_0xFC:
	LDS  R26,_ind
	CPI  R26,LOW(0x2)
	BREQ PC+2
	RJMP _0xFF
; 0000 05CA 	{
; 0000 05CB 	if(but==butP_)ind=iMn;
	LDI  R30,LOW(249)
	CP   R30,R14
	BRNE _0x100
	LDI  R30,LOW(0)
	STS  _ind,R30
; 0000 05CC 	if(but==butP)
_0x100:
	LDI  R30,LOW(251)
	CP   R30,R14
	BRNE _0x101
; 0000 05CD 		{
; 0000 05CE 		if((sub_ind>=0)&&(sub_ind<=5))
	LDS  R26,_sub_ind
	CPI  R26,0
	BRLO _0x103
	CPI  R26,LOW(0x6)
	BRLO _0x104
_0x103:
	RJMP _0x102
_0x104:
; 0000 05CF 			{
; 0000 05D0 			ind=iCh_on;
	LDI  R30,LOW(4)
	RJMP _0x156
; 0000 05D1 			}
; 0000 05D2 		else if(sub_ind==6)
_0x102:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x6)
	BRNE _0x106
; 0000 05D3 			{
; 0000 05D4 			ind=iSet_delay;
	LDI  R30,LOW(3)
	RJMP _0x156
; 0000 05D5 			}
; 0000 05D6 		else if(sub_ind==7)
_0x106:
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x7)
	BRNE _0x108
; 0000 05D7 			{
; 0000 05D8 			ind=iMn;
	LDI  R30,LOW(0)
_0x156:
	STS  _ind,R30
; 0000 05D9 			}
; 0000 05DA 		}
_0x108:
; 0000 05DB 
; 0000 05DC 	if(but==butR)
_0x101:
	LDI  R30,LOW(127)
	CP   R30,R14
	BRNE _0x109
; 0000 05DD 		{
; 0000 05DE 		sub_ind++;
	LDS  R30,_sub_ind
	SUBI R30,-LOW(1)
	STS  _sub_ind,R30
; 0000 05DF 		if(sub_ind>=7)sub_ind=7;
	LDS  R26,_sub_ind
	CPI  R26,LOW(0x7)
	BRLO _0x10A
	LDI  R30,LOW(7)
	STS  _sub_ind,R30
; 0000 05E0 		}
_0x10A:
; 0000 05E1 
; 0000 05E2 	if(but==butL)
_0x109:
	LDI  R30,LOW(254)
	CP   R30,R14
	BRNE _0x10B
; 0000 05E3 		{
; 0000 05E4 		if(sub_ind)sub_ind--;
	LDS  R30,_sub_ind
	CPI  R30,0
	BREQ _0x10C
	SUBI R30,LOW(1)
	STS  _sub_ind,R30
; 0000 05E5 		if(sub_ind<=0)sub_ind=0;
_0x10C:
	LDS  R26,_sub_ind
	CPI  R26,0
	BRNE _0x10D
	LDI  R30,LOW(0)
	STS  _sub_ind,R30
; 0000 05E6 		}
_0x10D:
; 0000 05E7 	}
_0x10B:
; 0000 05E8 else if(ind==iSet_delay)
	RJMP _0x10E
_0xFF:
	LDS  R26,_ind
	CPI  R26,LOW(0x3)
	BREQ PC+2
	RJMP _0x10F
; 0000 05E9 	{
; 0000 05EA 	if((but==butR)||(but==butR_))
	LDI  R30,LOW(127)
	CP   R30,R14
	BREQ _0x111
	LDI  R30,LOW(125)
	CP   R30,R14
	BRNE _0x110
_0x111:
; 0000 05EB 		{
; 0000 05EC 		speed=1;
	SET
	BLD  R2,6
; 0000 05ED 		ee_timer1_delay++;
	CALL SUBOPT_0x9
	ADIW R30,1
	CALL __EEPROMWRW
; 0000 05EE 		if((ee_timer1_delay<=10)||(ee_timer1_delay>=500))ee_timer1_delay=500;
	CALL SUBOPT_0x9
	MOVW R26,R30
	SBIW R30,11
	BRLO _0x114
	MOVW R30,R26
	CPI  R30,LOW(0x1F4)
	LDI  R26,HIGH(0x1F4)
	CPC  R31,R26
	BRLO _0x113
_0x114:
	LDI  R26,LOW(_ee_timer1_delay)
	LDI  R27,HIGH(_ee_timer1_delay)
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL __EEPROMWRW
; 0000 05EF 		}
_0x113:
; 0000 05F0 	else if((but==butL)||(but==butL_))
	RJMP _0x116
_0x110:
	LDI  R30,LOW(254)
	CP   R30,R14
	BREQ _0x118
	LDI  R30,LOW(252)
	CP   R30,R14
	BRNE _0x117
_0x118:
; 0000 05F1 		{
; 0000 05F2 		speed=1;
	SET
	BLD  R2,6
; 0000 05F3 		ee_timer1_delay--;
	CALL SUBOPT_0x9
	SBIW R30,1
	CALL __EEPROMWRW
; 0000 05F4 		if((ee_timer1_delay<=10)||(ee_timer1_delay>=500))ee_timer1_delay=0;
	CALL SUBOPT_0x9
	MOVW R26,R30
	SBIW R30,11
	BRLO _0x11B
	MOVW R30,R26
	CPI  R30,LOW(0x1F4)
	LDI  R26,HIGH(0x1F4)
	CPC  R31,R26
	BRLO _0x11A
_0x11B:
	LDI  R26,LOW(_ee_timer1_delay)
	LDI  R27,HIGH(_ee_timer1_delay)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
; 0000 05F5 		}
_0x11A:
; 0000 05F6 	else if(but==butP)
	RJMP _0x11D
_0x117:
	LDI  R30,LOW(251)
	CP   R30,R14
	BRNE _0x11E
; 0000 05F7 		{
; 0000 05F8 		ind=iSet_sel;
	LDI  R30,LOW(2)
	STS  _ind,R30
; 0000 05F9 		sub_ind=6;
	LDI  R30,LOW(6)
	STS  _sub_ind,R30
; 0000 05FA 		}
; 0000 05FB 	}
_0x11E:
_0x11D:
_0x116:
; 0000 05FC else if(ind==iCh_on)
	RJMP _0x11F
_0x10F:
	LDS  R26,_ind
	CPI  R26,LOW(0x4)
	BRNE _0x120
; 0000 05FD 	{
; 0000 05FE 	if((but==butR)||(but==butR_)||(but==butL)||(but==butL_))
	LDI  R30,LOW(127)
	CP   R30,R14
	BREQ _0x122
	LDI  R30,LOW(125)
	CP   R30,R14
	BREQ _0x122
	LDI  R30,LOW(254)
	CP   R30,R14
	BREQ _0x122
	LDI  R30,LOW(252)
	CP   R30,R14
	BRNE _0x121
_0x122:
; 0000 05FF 		{
; 0000 0600 		if(ch_on[sub_ind]==coON)ch_on[sub_ind]=coOFF;
	CALL SUBOPT_0xD
	BRNE _0x124
	LDS  R26,_sub_ind
	LDI  R27,0
	SUBI R26,LOW(-_ch_on)
	SBCI R27,HIGH(-_ch_on)
	LDI  R30,LOW(85)
	RJMP _0x157
; 0000 0601 		else ch_on[sub_ind]=coON;
_0x124:
	LDS  R26,_sub_ind
	LDI  R27,0
	SUBI R26,LOW(-_ch_on)
	SBCI R27,HIGH(-_ch_on)
	LDI  R30,LOW(170)
_0x157:
	CALL __EEPROMWRB
; 0000 0602 		}
; 0000 0603 	else if(but==butP)
	RJMP _0x126
_0x121:
	LDI  R30,LOW(251)
	CP   R30,R14
	BRNE _0x127
; 0000 0604 		{
; 0000 0605 		ind=iSet_sel;
	LDI  R30,LOW(2)
	STS  _ind,R30
; 0000 0606 		}
; 0000 0607 	}
_0x127:
_0x126:
; 0000 0608 
; 0000 0609 but_an_end:
_0x120:
_0x11F:
_0x10E:
_0xFE:
_0xF8:
; 0000 060A n_but=0;
	CLT
	BLD  R2,5
; 0000 060B }
	RET
; .FEND
;
;//-----------------------------------------------
;void ind_drv(void)
; 0000 060F {
_ind_drv:
; .FSTART _ind_drv
; 0000 0610 if(++ind_cnt>=6)ind_cnt=0;
	INC  R11
	LDI  R30,LOW(6)
	CP   R11,R30
	BRLO _0x128
	CLR  R11
; 0000 0611 
; 0000 0612 if(ind_cnt<5)
_0x128:
	LDI  R30,LOW(5)
	CP   R11,R30
	BRSH _0x129
; 0000 0613 	{
; 0000 0614 	DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0615 	PORTC=0xFF;
	OUT  0x15,R30
; 0000 0616 	DDRD|=0b11111000;
	IN   R30,0x11
	ORI  R30,LOW(0xF8)
	OUT  0x11,R30
; 0000 0617 	PORTD|=0b11111000;
	IN   R30,0x12
	ORI  R30,LOW(0xF8)
	OUT  0x12,R30
; 0000 0618 	PORTD&=IND_STROB[ind_cnt];
	IN   R30,0x12
	MOV  R26,R30
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-_IND_STROB*2)
	SBCI R31,HIGH(-_IND_STROB*2)
	LPM  R30,Z
	AND  R30,R26
	OUT  0x12,R30
; 0000 0619 	PORTC=ind_out[ind_cnt];
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	LD   R30,Z
	OUT  0x15,R30
; 0000 061A 	}
; 0000 061B else but_drv();
	RJMP _0x12A
_0x129:
	RCALL _but_drv
; 0000 061C }
_0x12A:
	RET
; .FEND
;
;//***********************************************
;//***********************************************
;//***********************************************
;//***********************************************
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0623 {
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
; 0000 0624 TCCR0=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 0625 TCNT0=-96;
	LDI  R30,LOW(160)
	OUT  0x32,R30
; 0000 0626 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 0627 
; 0000 0628 if((!PINA.3)&&(opto_angle_old)&&(motor_state==msON)&&(!bDel))
	SBIC 0x19,3
	RJMP _0x12C
	SBRS R3,6
	RJMP _0x12C
	LDS  R26,_motor_state
	CPI  R26,LOW(0x55)
	BRNE _0x12C
	SBRS R3,7
	RJMP _0x12D
_0x12C:
	RJMP _0x12B
_0x12D:
; 0000 0629 	{
; 0000 062A 
; 0000 062B  	TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 062C 	TCCR1B=0x04;
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0000 062D 	TCNT1=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 062E 	OCR1A=timer1_delay;
	LDS  R30,_timer1_delay
	LDS  R31,_timer1_delay+1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 062F 	bDel=1;
	SET
	BLD  R3,7
; 0000 0630 	TIMSK|=0x10;
	IN   R30,0x39
	ORI  R30,0x10
	OUT  0x39,R30
; 0000 0631 
; 0000 0632 /*	DDRB.6=0;
; 0000 0633 PORTB.6=0;
; 0000 0634 stop_cnt=20;
; 0000 0635 motor_state=msOFF;  */
; 0000 0636 	}
; 0000 0637 
; 0000 0638 opto_angle_old=PINA.3;
_0x12B:
	CLT
	SBIC 0x19,3
	SET
	BLD  R3,6
; 0000 0639 DDRA.3=0;
	CBI  0x1A,3
; 0000 063A PORTA.3=1;
	SBI  0x1B,3
; 0000 063B 
; 0000 063C if(++t0_cnt0_>=16)
	INC  R8
	LDI  R30,LOW(16)
	CP   R8,R30
	BRLO _0x132
; 0000 063D 	{
; 0000 063E 	t0_cnt0_=0;
	CLR  R8
; 0000 063F 
; 0000 0640 	b600Hz=1;
	SET
	BLD  R2,0
; 0000 0641 	ind_drv();
	RCALL _ind_drv
; 0000 0642 	if(++t0_cnt0>=6)
	INC  R7
	LDI  R30,LOW(6)
	CP   R7,R30
	BRLO _0x133
; 0000 0643 		{
; 0000 0644 		t0_cnt0=0;
	CLR  R7
; 0000 0645     		b100Hz=1;
	SET
	BLD  R2,1
; 0000 0646     		}
; 0000 0647 
; 0000 0648 	if(++t0_cnt1>=60)
_0x133:
	INC  R10
	LDI  R30,LOW(60)
	CP   R10,R30
	BRLO _0x134
; 0000 0649 		{
; 0000 064A 		t0_cnt1=0;
	CLR  R10
; 0000 064B 		b10Hz=1;
	SET
	BLD  R2,2
; 0000 064C 
; 0000 064D 		if(++t0_cnt2>=2)
	INC  R9
	LDI  R30,LOW(2)
	CP   R9,R30
	BRLO _0x135
; 0000 064E 			{
; 0000 064F 			t0_cnt2=0;
	CLR  R9
; 0000 0650 			bFL5=!bFL5;
	LDI  R30,LOW(1)
	EOR  R3,R30
; 0000 0651 			}
; 0000 0652 
; 0000 0653 		if(++t0_cnt3>=5)
_0x135:
	INC  R12
	LDI  R30,LOW(5)
	CP   R12,R30
	BRLO _0x136
; 0000 0654 			{
; 0000 0655 			t0_cnt3=0;
	CLR  R12
; 0000 0656 			bFL2=!bFL2;
	LDI  R30,LOW(128)
	EOR  R2,R30
; 0000 0657 			}
; 0000 0658 		}
_0x136:
; 0000 0659 	}
_0x134:
; 0000 065A }
_0x132:
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
;// Timer 1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 065F {
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0660 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0661 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0662 TIMSK&=0xef;
	IN   R30,0x39
	ANDI R30,0xEF
	OUT  0x39,R30
; 0000 0663 
; 0000 0664 DDRB.6=0;
	CBI  0x17,6
; 0000 0665 PORTB.6=0;
	CBI  0x18,6
; 0000 0666 
; 0000 0667 DDRB.7=0;
	CBI  0x17,7
; 0000 0668 PORTB.7=1;
	SBI  0x18,7
; 0000 0669 
; 0000 066A stop_cnt=20;
	LDI  R30,LOW(20)
	STS  _stop_cnt,R30
; 0000 066B motor_state=msOFF;
	LDI  R30,LOW(170)
	STS  _motor_state,R30
; 0000 066C bDel=0;
	CLT
	BLD  R3,7
; 0000 066D }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;
;//===============================================
;//===============================================
;//===============================================
;//===============================================
;
;void main(void)
; 0000 0676 {
_main:
; .FSTART _main
; 0000 0677 
; 0000 0678 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 0679 DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 067A 
; 0000 067B PORTB=0x00;
	OUT  0x18,R30
; 0000 067C DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 067D 
; 0000 067E PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 067F DDRC=0x00;
	OUT  0x14,R30
; 0000 0680 
; 0000 0681 
; 0000 0682 PORTD=0x00;
	OUT  0x12,R30
; 0000 0683 DDRD=0x00;
	OUT  0x11,R30
; 0000 0684 
; 0000 0685 
; 0000 0686 TCCR0=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 0687 TCNT0=-99;
	LDI  R30,LOW(157)
	OUT  0x32,R30
; 0000 0688 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 0689 
; 0000 068A TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 068B TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 068C TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 068D TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 068E ICR1H=0x00;
	OUT  0x27,R30
; 0000 068F ICR1L=0x00;
	OUT  0x26,R30
; 0000 0690 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0691 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0692 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0693 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0694 
; 0000 0695 
; 0000 0696 ASSR=0x00;
	OUT  0x22,R30
; 0000 0697 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0698 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0699 OCR2=0x00;
	OUT  0x23,R30
; 0000 069A 
; 0000 069B // USART initialization
; 0000 069C // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 069D // USART Receiver: On
; 0000 069E // USART Transmitter: On
; 0000 069F // USART Mode: Asynchronous
; 0000 06A0 // USART Baud rate: 19200
; 0000 06A1 UCSRA=0x00;
	OUT  0xB,R30
; 0000 06A2 UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 06A3 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 06A4 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 06A5 UBRRL=0x19;
	LDI  R30,LOW(25)
	OUT  0x9,R30
; 0000 06A6 
; 0000 06A7 MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 06A8 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 06A9 
; 0000 06AA TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 06AB 
; 0000 06AC ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 06AD SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 06AE 
; 0000 06AF #asm("sei")
	sei
; 0000 06B0 ind=iMn;
	LDI  R30,LOW(0)
	STS  _ind,R30
; 0000 06B1 ind_hndl();
	RCALL _ind_hndl
; 0000 06B2 led_hndl();
	RCALL _led_hndl
; 0000 06B3 
; 0000 06B4 //ee_avtom_mode=eamOFF;
; 0000 06B5 //ind=iSet_delay;
; 0000 06B6 while (1)
_0x13F:
; 0000 06B7       {
; 0000 06B8       if(b600Hz)
	SBRS R2,0
	RJMP _0x142
; 0000 06B9 		{
; 0000 06BA 		b600Hz=0;
	CLT
	BLD  R2,0
; 0000 06BB 
; 0000 06BC 		}
; 0000 06BD       if(b100Hz)
_0x142:
	SBRS R2,1
	RJMP _0x143
; 0000 06BE 		{
; 0000 06BF 		b100Hz=0;
	CLT
	BLD  R2,1
; 0000 06C0 		but_an();
	RCALL _but_an
; 0000 06C1 	    	in_drv();
	CALL _in_drv
; 0000 06C2           //mdvr_drv();
; 0000 06C3           step_main_contr();
	CALL _step_main_contr
; 0000 06C4           out_drv();
	CALL _out_drv
; 0000 06C5           err_drv();
	CALL _err_drv
; 0000 06C6           net_drv();
	CALL _net_drv
; 0000 06C7           //out_usart(4,0x01,0x85,0x86,0x87,0,0,0,0,0);
; 0000 06C8           od_drv();
	CALL _od_drv
; 0000 06C9           avtom_mode_drv();
	CALL _avtom_mode_drv
; 0000 06CA 		}
; 0000 06CB 	if(b10Hz)
_0x143:
	SBRS R2,2
	RJMP _0x144
; 0000 06CC 		{
; 0000 06CD 		b10Hz=0;
	CLT
	BLD  R2,2
; 0000 06CE 
; 0000 06CF     	     ind_hndl();
	CALL _ind_hndl
; 0000 06D0           led_hndl();
	RCALL _led_hndl
; 0000 06D1           mathemat();
	CALL _mathemat
; 0000 06D2           }
; 0000 06D3 
; 0000 06D4       };
_0x144:
	RJMP _0x13F
; 0000 06D5 }
_0x145:
	RJMP _0x145
; .FEND
;
;
;
;
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

	.CSEG

	.CSEG

	.CSEG

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
_ee_avtom_mode:
	.BYTE 0x1

	.DSEG
_ind:
	.BYTE 0x1
_sub_ind:
	.BYTE 0x1
_in_word:
	.BYTE 0x1
_in_word_old:
	.BYTE 0x1
_in_word_new:
	.BYTE 0x1
_in_word_cnt:
	.BYTE 0x1
_cnt_md1:
	.BYTE 0x1
_cnt_md2:
	.BYTE 0x1
_cnt_vr:
	.BYTE 0x1
_cnt_md3:
	.BYTE 0x1

	.ESEG
_ch_on:
	.BYTE 0x6
_ee_timer1_delay:
	.BYTE 0x2

	.DSEG
_motor_state:
	.BYTE 0x1
_timer1_delay:
	.BYTE 0x2
_stop_cnt:
	.BYTE 0x1
_cnt_net_drv:
	.BYTE 0x1
_cnt_drv:
	.BYTE 0x1
_cmnd_byte:
	.BYTE 0x1
_state_byte:
	.BYTE 0x1
_crc_byte:
	.BYTE 0x1
_od_cnt:
	.BYTE 0x1
_od:
	.BYTE 0x1
_state:
	.BYTE 0x3
_step_main:
	.BYTE 0x1
_plazma:
	.BYTE 0x1
_cnt_del_main:
	.BYTE 0x2
_rx_buffer:
	.BYTE 0x32
_rx_wr_index:
	.BYTE 0x1
_rx_rd_index:
	.BYTE 0x1
_rx_counter:
	.BYTE 0x1
_tx_buffer:
	.BYTE 0x64
_tx_wr_index:
	.BYTE 0x1
_tx_rd_index:
	.BYTE 0x1
_tx_counter:
	.BYTE 0x1
_avtom_mode:
	.BYTE 0x1
_avtom_mode_cnt:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	STS  _step_main,R30
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	STS  _cnt_del_main,R30
	STS  _cnt_del_main+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(51)
	STS  _cmnd_byte,R30
	LDI  R26,LOW(_cnt_del_main)
	LDI  R27,HIGH(_cnt_del_main)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDS  R30,_cnt_del_main
	LDS  R31,_cnt_del_main+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_ch_on)
	LDI  R27,HIGH(_ch_on)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	__POINTW2MN _ch_on,1
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	__POINTW2MN _ch_on,2
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	__POINTW2MN _ch_on,3
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	__POINTW2MN _ch_on,4
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	__POINTW2MN _ch_on,5
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	MOV  R30,R17
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(_ee_timer1_delay)
	LDI  R27,HIGH(_ee_timer1_delay)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _int2ind

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(171)
	__PUTB1MN _ind_out,3
	LDI  R30,LOW(163)
	__PUTB1MN _ind_out,2
	LDI  R30,LOW(255)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(142)
	__PUTB1MN _ind_out,3
	__PUTB1MN _ind_out,2
	LDI  R30,LOW(163)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDS  R26,_sub_ind
	LDI  R27,0
	SUBI R26,LOW(-_ch_on)
	SBCI R27,HIGH(-_ch_on)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(255)
	__PUTB1MN _ind_out,3
	__PUTB1MN _ind_out,2
	__PUTB1MN _ind_out,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	IN   R30,0x15
	ORI  R30,LOW(0x95)
	OUT  0x15,R30
	IN   R30,0x14
	ANDI R30,LOW(0x6A)
	OUT  0x14,R30
	RET


	.CSEG
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
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
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

;END OF CODE MARKER
__END_OF_CODE:
