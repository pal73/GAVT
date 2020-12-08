
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega16A
;Program type           : Application
;Clock frequency        : 1.000000 MHz
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

	#pragma AVRPART ADMIN PART_NAME ATmega16A
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
	.DEF _t0_cnt0=R5
	.DEF _t0_cnt1=R4
	.DEF _t0_cnt2=R7
	.DEF _t0_cnt3=R6
	.DEF _ind_cnt=R9
	.DEF _but=R8
	.DEF _prog=R11
	.DEF _step=R10
	.DEF _ind=R13
	.DEF _sub_ind=R12

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

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0

_0x3:
	.DB  0x55,0x55,0x55,0x55,0x55

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  0x0A
	.DW  __REG_VARS*2

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
;#define LED_PROG4	1
;#define LED_PROG2	2
;#define LED_PROG3	3
;#define LED_PROG1	4
;#define LED_ERROR	0
;#define LED_WRK	6
;#define LED_VACUUM	7
;
;#define GAVT3
;
;#define P380
;//#define I380
;//#define I220
;//#define P380_MINI
;//#define TVIST_SKO
;//#define I380_WI
;//#define I220_WI
;//#define DV3KL2MD
;//#define  I380_WI_GAZ
;
;#define MD1	2
;#define MD2	3
;#define VR	4
;#define MD3	5
;#define VR2	7
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
;#ifdef P380_MINI
;#define MINPROG 1
;#define MAXPROG 1
;#ifdef GAVT3
;#define DV	2
;#endif
;#define PP3	3
;#endif
;
;#ifdef P380
;#define MINPROG 1
;#define MAXPROG 3
;#ifdef GAVT3
;#define DV	2
;#endif
;#endif
;
;#ifdef I380
;#define MINPROG 1
;#define MAXPROG 4
;#endif
;
;#ifdef I380_WI
;#define MINPROG 1
;#define MAXPROG 4
;#endif
;
;#ifdef I220
;#define MINPROG 3
;#define MAXPROG 4
;#endif
;
;
;#ifdef I220_WI
;#define MINPROG 3
;#define MAXPROG 4
;#endif
;
;#ifdef TVIST_SKO
;#define MINPROG 2
;#define MAXPROG 3
;#define DV	2
;#endif
;
;#ifdef DV3KL2MD
;
;#define PP1	6
;#define PP2	7
;#define PP3	3
;//#define PP4	4
;//#define PP5	3
;#define DV	2
;
;#define MINPROG 2
;#define MAXPROG 3
;
;#endif
;
;
;#ifdef I380_WI_GAZ
;
;#define PP1	6
;#define PP2	7
;#define PP3	5
;#define PP4	4
;#define PP5	3
;#define PP6	2
;#define PP7	1
;#define PP8	0
;
;#define DV	8
;
;#define MINPROG 1
;#define MAXPROG 4
;
;#endif
;
;bit b600Hz;
;
;bit b100Hz;
;bit b10Hz;
;char t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3;
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
;bit speed;		//разрешение ускорения перебора
;bit bFL2;
;bit bFL5;
;eeprom enum{evmON=0x55,evmOFF=0xaa}ee_vacuum_mode;
;eeprom char ee_program[2];
;enum {p1=1,p2=2,p3=3,p4=4}prog;
;enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}step=sOFF;
;enum {iMn,iPr_sel,iVr} ind;
;char sub_ind;
;char in_word,in_word_old,in_word_new,in_word_cnt;
;bit bERR;
;signed int cnt_del=0;
;
;char bVR;
;char bMD1;
;bit bMD2;
;bit bMD3;
;bit bVR2;
;char cnt_md1,cnt_md2,cnt_vr,cnt_md3,cnt_vr2;
;
;eeprom unsigned ee_delay[4][2];
;eeprom char ee_vr_log;
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
;//#include <mega32.h>
;//-----------------------------------------------
;void prog_drv(void)
; 0000 00A1 {

	.CSEG
_prog_drv:
; .FSTART _prog_drv
; 0000 00A2 char temp,temp1,temp2;
; 0000 00A3 
; 0000 00A4 temp=ee_program[0];
	CALL __SAVELOCR4
;	temp -> R17
;	temp1 -> R16
;	temp2 -> R19
	LDI  R26,LOW(_ee_program)
	LDI  R27,HIGH(_ee_program)
	CALL __EEPROMRDB
	MOV  R17,R30
; 0000 00A5 temp1=ee_program[1];
	__POINTW2MN _ee_program,1
	CALL __EEPROMRDB
	MOV  R16,R30
; 0000 00A6 temp2=ee_program[2];
	__POINTW2MN _ee_program,2
	CALL __EEPROMRDB
	MOV  R19,R30
; 0000 00A7 
; 0000 00A8 if((temp==temp1)&&(temp==temp2))
	CP   R16,R17
	BRNE _0x5
	CP   R19,R17
	BREQ _0x6
_0x5:
	RJMP _0x4
_0x6:
; 0000 00A9 	{
; 0000 00AA 	}
; 0000 00AB else if((temp==temp1)&&(temp!=temp2))
	RJMP _0x7
_0x4:
	CP   R16,R17
	BRNE _0x9
	CP   R19,R17
	BRNE _0xA
_0x9:
	RJMP _0x8
_0xA:
; 0000 00AC 	{
; 0000 00AD 	temp2=temp;
	MOV  R19,R17
; 0000 00AE 	}
; 0000 00AF else if((temp!=temp1)&&(temp==temp2))
	RJMP _0xB
_0x8:
	CP   R16,R17
	BREQ _0xD
	CP   R19,R17
	BREQ _0xE
_0xD:
	RJMP _0xC
_0xE:
; 0000 00B0 	{
; 0000 00B1 	temp1=temp;
	MOV  R16,R17
; 0000 00B2 	}
; 0000 00B3 else if((temp!=temp1)&&(temp1==temp2))
	RJMP _0xF
_0xC:
	CP   R16,R17
	BREQ _0x11
	CP   R19,R16
	BREQ _0x12
_0x11:
	RJMP _0x10
_0x12:
; 0000 00B4 	{
; 0000 00B5 	temp=temp1;
	MOV  R17,R16
; 0000 00B6 	}
; 0000 00B7 else if((temp!=temp1)&&(temp!=temp2))
	RJMP _0x13
_0x10:
	CP   R16,R17
	BREQ _0x15
	CP   R19,R17
	BRNE _0x16
_0x15:
	RJMP _0x14
_0x16:
; 0000 00B8 	{
; 0000 00B9 	temp=MINPROG;
	LDI  R17,LOW(1)
; 0000 00BA 	temp1=MINPROG;
	LDI  R16,LOW(1)
; 0000 00BB 	temp2=MINPROG;
	LDI  R19,LOW(1)
; 0000 00BC 	}
; 0000 00BD 
; 0000 00BE if(!((temp<=MAXPROG)&&(temp>=MINPROG)))
_0x14:
_0x13:
_0xF:
_0xB:
_0x7:
	CPI  R17,4
	BRSH _0x18
	CPI  R17,1
	BRSH _0x17
_0x18:
; 0000 00BF 	{
; 0000 00C0 	temp=MINPROG;
	LDI  R17,LOW(1)
; 0000 00C1 	}
; 0000 00C2 
; 0000 00C3 if(temp!=ee_program[0])ee_program[0]=temp;
_0x17:
	LDI  R26,LOW(_ee_program)
	LDI  R27,HIGH(_ee_program)
	CALL __EEPROMRDB
	CP   R30,R17
	BREQ _0x1A
	MOV  R30,R17
	RCALL SUBOPT_0x0
; 0000 00C4 if(temp!=ee_program[1])ee_program[1]=temp;
_0x1A:
	__POINTW2MN _ee_program,1
	CALL __EEPROMRDB
	CP   R30,R17
	BREQ _0x1B
	__POINTW2MN _ee_program,1
	MOV  R30,R17
	CALL __EEPROMWRB
; 0000 00C5 if(temp!=ee_program[2])ee_program[2]=temp;
_0x1B:
	__POINTW2MN _ee_program,2
	CALL __EEPROMRDB
	CP   R30,R17
	BREQ _0x1C
	__POINTW2MN _ee_program,2
	MOV  R30,R17
	CALL __EEPROMWRB
; 0000 00C6 
; 0000 00C7 prog=temp;
_0x1C:
	MOV  R11,R17
; 0000 00C8 }
	RJMP _0x2000002
; .FEND
;
;//-----------------------------------------------
;void in_drv(void)
; 0000 00CC {
_in_drv:
; .FSTART _in_drv
; 0000 00CD char i,temp;
; 0000 00CE unsigned int tempUI;
; 0000 00CF DDRA=0x00;
	CALL __SAVELOCR4
;	i -> R17
;	temp -> R16
;	tempUI -> R18,R19
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 00D0 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 00D1 in_word_new=PINA;
	IN   R30,0x19
	STS  _in_word_new,R30
; 0000 00D2 if(in_word_old==in_word_new)
	LDS  R26,_in_word_old
	CP   R30,R26
	BRNE _0x1D
; 0000 00D3 	{
; 0000 00D4 	if(in_word_cnt<10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRSH _0x1E
; 0000 00D5 		{
; 0000 00D6 		in_word_cnt++;
	LDS  R30,_in_word_cnt
	SUBI R30,-LOW(1)
	STS  _in_word_cnt,R30
; 0000 00D7 		if(in_word_cnt>=10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRLO _0x1F
; 0000 00D8 			{
; 0000 00D9 			in_word=in_word_old;
	LDS  R30,_in_word_old
	STS  _in_word,R30
; 0000 00DA 			}
; 0000 00DB 		}
_0x1F:
; 0000 00DC 	}
_0x1E:
; 0000 00DD else in_word_cnt=0;
	RJMP _0x20
_0x1D:
	LDI  R30,LOW(0)
	STS  _in_word_cnt,R30
; 0000 00DE 
; 0000 00DF 
; 0000 00E0 in_word_old=in_word_new;
_0x20:
	LDS  R30,_in_word_new
	STS  _in_word_old,R30
; 0000 00E1 }
_0x2000002:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;
;#ifdef TVIST_SKO
;//-----------------------------------------------
;void err_drv(void)
;{
;if(step==sOFF)
;	{
;    	if(prog==p2)
;    		{
;       		if(bMD1) bERR=1;
;       		else bERR=0;
;		}
;	}
;else bERR=0;
;}
;#else
;#ifdef I380_WI_GAZ
;//-----------------------------------------------
;void err_drv(void)
;{
;if(step==sOFF)
;	{
;	if((bMD1)||(bMD2)||(bVR)||(bMD3)||(bVR2)) bERR=1;
;	else bERR=0;
;	}
;else bERR=0;
;}
;#else
;
;//-----------------------------------------------
;void err_drv(void)
; 0000 0101 {
_err_drv:
; .FSTART _err_drv
; 0000 0102 if(step==sOFF)
	TST  R10
	BRNE _0x21
; 0000 0103 	{
; 0000 0104 	if((bMD1)||(bMD2)||(bVR)||(bMD3)) bERR=1;
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
	RJMP _0x111
; 0000 0105 	else bERR=0;
_0x22:
	CLT
_0x111:
	BLD  R3,1
; 0000 0106 	}
; 0000 0107 else bERR=0;
	RJMP _0x26
_0x21:
	CLT
	BLD  R3,1
; 0000 0108 }
_0x26:
	RET
; .FEND
;#endif
;#endif
;
;//-----------------------------------------------
;void mdvr_drv(void)
; 0000 010E {
_mdvr_drv:
; .FSTART _mdvr_drv
; 0000 010F if(!(in_word&(1<<MD1)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x4)
	BRNE _0x27
; 0000 0110 	{
; 0000 0111 	if(cnt_md1<10)
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRSH _0x28
; 0000 0112 		{
; 0000 0113 		cnt_md1++;
	LDS  R30,_cnt_md1
	SUBI R30,-LOW(1)
	STS  _cnt_md1,R30
; 0000 0114 		if(cnt_md1==10) bMD1=1;
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRNE _0x29
	LDI  R30,LOW(1)
	STS  _bMD1,R30
; 0000 0115 		}
_0x29:
; 0000 0116 
; 0000 0117 	}
_0x28:
; 0000 0118 else
	RJMP _0x2A
_0x27:
; 0000 0119 	{
; 0000 011A 	if(cnt_md1)
	LDS  R30,_cnt_md1
	CPI  R30,0
	BREQ _0x2B
; 0000 011B 		{
; 0000 011C 		cnt_md1--;
	SUBI R30,LOW(1)
	STS  _cnt_md1,R30
; 0000 011D 		if(cnt_md1==0) bMD1=0;
	CPI  R30,0
	BRNE _0x2C
	LDI  R30,LOW(0)
	STS  _bMD1,R30
; 0000 011E 		}
_0x2C:
; 0000 011F 
; 0000 0120 	}
_0x2B:
_0x2A:
; 0000 0121 
; 0000 0122 if(!(in_word&(1<<MD2)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x8)
	BRNE _0x2D
; 0000 0123 	{
; 0000 0124 	if(cnt_md2<10)
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRSH _0x2E
; 0000 0125 		{
; 0000 0126 		cnt_md2++;
	LDS  R30,_cnt_md2
	SUBI R30,-LOW(1)
	STS  _cnt_md2,R30
; 0000 0127 		if(cnt_md2==10) bMD2=1;
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRNE _0x2F
	SET
	BLD  R3,2
; 0000 0128 		}
_0x2F:
; 0000 0129 
; 0000 012A 	}
_0x2E:
; 0000 012B else
	RJMP _0x30
_0x2D:
; 0000 012C 	{
; 0000 012D 	if(cnt_md2)
	LDS  R30,_cnt_md2
	CPI  R30,0
	BREQ _0x31
; 0000 012E 		{
; 0000 012F 		cnt_md2--;
	SUBI R30,LOW(1)
	STS  _cnt_md2,R30
; 0000 0130 		if(cnt_md2==0) bMD2=0;
	CPI  R30,0
	BRNE _0x32
	CLT
	BLD  R3,2
; 0000 0131 		}
_0x32:
; 0000 0132 
; 0000 0133 	}
_0x31:
_0x30:
; 0000 0134 
; 0000 0135 if(!(in_word&(1<<MD3)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x20)
	BRNE _0x33
; 0000 0136 	{
; 0000 0137 	if(cnt_md3<10)
	LDS  R26,_cnt_md3
	CPI  R26,LOW(0xA)
	BRSH _0x34
; 0000 0138 		{
; 0000 0139 		cnt_md3++;
	LDS  R30,_cnt_md3
	SUBI R30,-LOW(1)
	STS  _cnt_md3,R30
; 0000 013A 		if(cnt_md3==10) bMD3=1;
	LDS  R26,_cnt_md3
	CPI  R26,LOW(0xA)
	BRNE _0x35
	SET
	BLD  R3,3
; 0000 013B 		}
_0x35:
; 0000 013C 
; 0000 013D 	}
_0x34:
; 0000 013E else
	RJMP _0x36
_0x33:
; 0000 013F 	{
; 0000 0140 	if(cnt_md3)
	LDS  R30,_cnt_md3
	CPI  R30,0
	BREQ _0x37
; 0000 0141 		{
; 0000 0142 		cnt_md3--;
	SUBI R30,LOW(1)
	STS  _cnt_md3,R30
; 0000 0143 		if(cnt_md3==0) bMD3=0;
	CPI  R30,0
	BRNE _0x38
	CLT
	BLD  R3,3
; 0000 0144 		}
_0x38:
; 0000 0145 
; 0000 0146 	}
_0x37:
_0x36:
; 0000 0147 
; 0000 0148 if(((!(in_word&(1<<VR)))/*&&(ee_vr_log)*/) /*|| (((in_word&(1<<VR)))&&(!ee_vr_log))*/)
	LDS  R30,_in_word
	ANDI R30,LOW(0x10)
	BRNE _0x39
; 0000 0149 	{
; 0000 014A 	if(cnt_vr<10)
	LDS  R26,_cnt_vr
	CPI  R26,LOW(0xA)
	BRSH _0x3A
; 0000 014B 		{
; 0000 014C 		cnt_vr++;
	LDS  R30,_cnt_vr
	SUBI R30,-LOW(1)
	STS  _cnt_vr,R30
; 0000 014D 		if(cnt_vr==10) bVR=1;
	LDS  R26,_cnt_vr
	CPI  R26,LOW(0xA)
	BRNE _0x3B
	LDI  R30,LOW(1)
	STS  _bVR,R30
; 0000 014E 		}
_0x3B:
; 0000 014F 
; 0000 0150 	}
_0x3A:
; 0000 0151 else
	RJMP _0x3C
_0x39:
; 0000 0152 	{
; 0000 0153 	if(cnt_vr)
	LDS  R30,_cnt_vr
	CPI  R30,0
	BREQ _0x3D
; 0000 0154 		{
; 0000 0155 		cnt_vr--;
	SUBI R30,LOW(1)
	STS  _cnt_vr,R30
; 0000 0156 		if(cnt_vr==0) bVR=0;
	CPI  R30,0
	BRNE _0x3E
	LDI  R30,LOW(0)
	STS  _bVR,R30
; 0000 0157 		}
_0x3E:
; 0000 0158 
; 0000 0159 	}
_0x3D:
_0x3C:
; 0000 015A 
; 0000 015B if(((!(in_word&(1<<VR2)))/*&&(ee_vr_log)*/) /*|| (((in_word&(1<<VR2)))&&(!ee_vr_log))*/)
	LDS  R30,_in_word
	ANDI R30,LOW(0x80)
	BRNE _0x3F
; 0000 015C 	{
; 0000 015D 	if(cnt_vr2<10)
	LDS  R26,_cnt_vr2
	CPI  R26,LOW(0xA)
	BRSH _0x40
; 0000 015E 		{
; 0000 015F 		cnt_vr2++;
	LDS  R30,_cnt_vr2
	SUBI R30,-LOW(1)
	STS  _cnt_vr2,R30
; 0000 0160 		if(cnt_vr2==10) bVR2=1;
	LDS  R26,_cnt_vr2
	CPI  R26,LOW(0xA)
	BRNE _0x41
	SET
	BLD  R3,4
; 0000 0161 		}
_0x41:
; 0000 0162 
; 0000 0163 	}
_0x40:
; 0000 0164 else
	RJMP _0x42
_0x3F:
; 0000 0165 	{
; 0000 0166 	if(cnt_vr2)
	LDS  R30,_cnt_vr2
	CPI  R30,0
	BREQ _0x43
; 0000 0167 		{
; 0000 0168 		cnt_vr2--;
	SUBI R30,LOW(1)
	STS  _cnt_vr2,R30
; 0000 0169 		if(cnt_vr2==0) bVR2=0;
	CPI  R30,0
	BRNE _0x44
	CLT
	BLD  R3,4
; 0000 016A 		}
_0x44:
; 0000 016B 
; 0000 016C 	}
_0x43:
_0x42:
; 0000 016D }
	RET
; .FEND
;
;#ifdef DV3KL2MD
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
;else if(step==s1)
;	{
;	temp|=(1<<PP1);
;
;	cnt_del--;
;	if(cnt_del==0)
;		{
;		step=s2;
;		cnt_del=20;
;		}
;	}
;
;
;else if(step==s2)
;	{
;	temp|=(1<<PP1)|(1<<DV);
;
;	cnt_del--;
;	if(cnt_del==0)
;		{
;		step=s3;
;		}
;	}
;
;else if(step==s3)
;	{
;	temp|=(1<<PP1)|(1<<PP2)|(1<<DV);
;     if(!bMD1)goto step_contr_end;
;     step=s4;
;     }
;else if(step==s4)
;	{
;     temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     if(!bMD2)goto step_contr_end;
;     step=s5;
;     cnt_del=50;
;     }
;else if(step==s5)
;	{
;	temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;
;	cnt_del--;
;	if(cnt_del==0)
;		{
;		step=s6;
;		cnt_del=50;
;		}
;	}
;/*else if(step==s6)
;	{
;	temp|=(1<<PP1)|(1<<DV);
;
;	cnt_del--;
;	if(cnt_del==0)
;		{
;		step=s6;
;		cnt_del=70;
;		}
;	}*/
;else if(step==s6)
;		{
;	temp|=(1<<PP1);
;	cnt_del--;
;	if(cnt_del==0)
;		{
;		step=sOFF;
;          }
;     }
;
;step_contr_end:
;
;PORTB=~temp;
;}
;#endif
;
;#ifdef P380_MINI
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
;else if(step==s1)
;	{
;	temp|=(1<<PP1);
;
;	cnt_del--;
;	if(cnt_del==0)
;		{
;		step=s2;
;		}
;	}
;
;else if(step==s2)
;	{
;	temp|=(1<<PP1)|(1<<PP2)|(1<<DV);
;     if(!bMD1)goto step_contr_end;
;     step=s3;
;     }
;else if(step==s3)
;	{
;     temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
;     if(!bMD2)goto step_contr_end;
;     step=s4;
;     cnt_del=50;
;     }
;else if(step==s4)
;		{
;	temp|=(1<<PP1);
;	cnt_del--;
;	if(cnt_del==0)
;		{
;		step=sOFF;
;          }
;     }
;
;step_contr_end:
;
;PORTB=~temp;
;}
;#endif
;
;#ifdef P380
;//-----------------------------------------------
;void step_contr(void)
; 0000 01FD {
_step_contr:
; .FSTART _step_contr
; 0000 01FE char temp=0;
; 0000 01FF DDRB=0xFF;
	ST   -Y,R17
;	temp -> R17
	LDI  R17,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0200 
; 0000 0201 if(step==sOFF)
	TST  R10
	BRNE _0x45
; 0000 0202 	{
; 0000 0203 	temp=0;
	LDI  R17,LOW(0)
; 0000 0204 	}
; 0000 0205 
; 0000 0206 else if(prog==p1)
	RJMP _0x46
_0x45:
	LDI  R30,LOW(1)
	CP   R30,R11
	BREQ PC+2
	RJMP _0x47
; 0000 0207 	{
; 0000 0208 	if(step==s1)
	CP   R30,R10
	BRNE _0x48
; 0000 0209 		{
; 0000 020A 		temp|=(1<<PP1)|(1<<PP2);
	RCALL SUBOPT_0x1
; 0000 020B 
; 0000 020C 		cnt_del--;
; 0000 020D 		if(cnt_del==0)
	BRNE _0x49
; 0000 020E 			{
; 0000 020F 			if(ee_vacuum_mode==evmOFF)
	RCALL SUBOPT_0x2
	BREQ _0x4B
; 0000 0210 				{
; 0000 0211 				goto lbl_0001;
; 0000 0212 				}
; 0000 0213 			else step=s2;
	LDI  R30,LOW(2)
	MOV  R10,R30
; 0000 0214 			}
; 0000 0215 		}
_0x49:
; 0000 0216 
; 0000 0217 	else if(step==s2)
	RJMP _0x4D
_0x48:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x4E
; 0000 0218 		{
; 0000 0219 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	RCALL SUBOPT_0x3
; 0000 021A 
; 0000 021B           if(!bVR)goto step_contr_end;
	BRNE _0x4F
	RJMP _0x50
; 0000 021C lbl_0001:
_0x4F:
_0x4B:
; 0000 021D #ifndef BIG_CAM
; 0000 021E 		cnt_del=30;
	RCALL SUBOPT_0x4
; 0000 021F #endif
; 0000 0220 
; 0000 0221 #ifdef BIG_CAM
; 0000 0222 		cnt_del=100;
; 0000 0223 #endif
; 0000 0224 		step=s3;
	LDI  R30,LOW(3)
	MOV  R10,R30
; 0000 0225 		}
; 0000 0226 
; 0000 0227 	else if(step==s3)
	RJMP _0x51
_0x4E:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x52
; 0000 0228 		{
; 0000 0229 		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
	RCALL SUBOPT_0x5
; 0000 022A 		cnt_del--;
; 0000 022B 		if(cnt_del==0)
	BRNE _0x53
; 0000 022C 			{
; 0000 022D 			step=s4;
	LDI  R30,LOW(4)
	MOV  R10,R30
; 0000 022E 			}
; 0000 022F           }
_0x53:
; 0000 0230 	else if(step==s4)
	RJMP _0x54
_0x52:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0x55
; 0000 0231 		{
; 0000 0232 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R17,LOW(116)
; 0000 0233 
; 0000 0234           if(!bMD1)goto step_contr_end;
	LDS  R30,_bMD1
	CPI  R30,0
	BRNE _0x56
	RJMP _0x50
; 0000 0235 
; 0000 0236 		cnt_del=40;
_0x56:
	RCALL SUBOPT_0x6
; 0000 0237 		step=s5;
	LDI  R30,LOW(5)
	MOV  R10,R30
; 0000 0238 		}
; 0000 0239 	else if(step==s5)
	RJMP _0x57
_0x55:
	LDI  R30,LOW(5)
	CP   R30,R10
	BRNE _0x58
; 0000 023A 		{
; 0000 023B 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
	RCALL SUBOPT_0x7
; 0000 023C 
; 0000 023D 		cnt_del--;
; 0000 023E 		if(cnt_del==0)
	BRNE _0x59
; 0000 023F 			{
; 0000 0240 			step=s6;
	LDI  R30,LOW(6)
	MOV  R10,R30
; 0000 0241 			}
; 0000 0242 		}
_0x59:
; 0000 0243 	else if(step==s6)
	RJMP _0x5A
_0x58:
	LDI  R30,LOW(6)
	CP   R30,R10
	BRNE _0x5B
; 0000 0244 		{
; 0000 0245 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
	ORI  R17,LOW(108)
; 0000 0246 
; 0000 0247          	if(!bMD2)goto step_contr_end;
	SBRS R3,2
	RJMP _0x50
; 0000 0248           cnt_del=40;
	RCALL SUBOPT_0x6
; 0000 0249 		//step=s7;
; 0000 024A 
; 0000 024B           step=s55;
	LDI  R30,LOW(18)
	MOV  R10,R30
; 0000 024C           cnt_del=40;
	RCALL SUBOPT_0x6
; 0000 024D 		}
; 0000 024E 	else if(step==s55)
	RJMP _0x5D
_0x5B:
	LDI  R30,LOW(18)
	CP   R30,R10
	BRNE _0x5E
; 0000 024F 		{
; 0000 0250 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
	RCALL SUBOPT_0x8
; 0000 0251           cnt_del--;
; 0000 0252           if(cnt_del==0)
	BRNE _0x5F
; 0000 0253 			{
; 0000 0254           	step=s7;
	LDI  R30,LOW(7)
	MOV  R10,R30
; 0000 0255           	cnt_del=20;
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x9
; 0000 0256 			}
; 0000 0257 
; 0000 0258 		}
_0x5F:
; 0000 0259 	else if(step==s7)
	RJMP _0x60
_0x5E:
	LDI  R30,LOW(7)
	CP   R30,R10
	BRNE _0x61
; 0000 025A 		{
; 0000 025B 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
	RCALL SUBOPT_0x8
; 0000 025C 
; 0000 025D 		cnt_del--;
; 0000 025E 		if(cnt_del==0)
	BRNE _0x62
; 0000 025F 			{
; 0000 0260 			step=s8;
	LDI  R30,LOW(8)
	MOV  R10,R30
; 0000 0261 			cnt_del=30;
	RCALL SUBOPT_0x4
; 0000 0262 			}
; 0000 0263 		}
_0x62:
; 0000 0264 	else if(step==s8)
	RJMP _0x63
_0x61:
	LDI  R30,LOW(8)
	CP   R30,R10
	BRNE _0x64
; 0000 0265 		{
; 0000 0266 		temp|=(1<<PP1)|(1<<PP3);
	RCALL SUBOPT_0xA
; 0000 0267 
; 0000 0268 		cnt_del--;
; 0000 0269 		if(cnt_del==0)
	BRNE _0x65
; 0000 026A 			{
; 0000 026B 			step=s9;
	LDI  R30,LOW(9)
	RCALL SUBOPT_0xB
; 0000 026C #ifndef BIG_CAM
; 0000 026D 		cnt_del=150;
; 0000 026E #endif
; 0000 026F 
; 0000 0270 #ifdef BIG_CAM
; 0000 0271 		cnt_del=200;
; 0000 0272 #endif
; 0000 0273 			}
; 0000 0274 		}
_0x65:
; 0000 0275 	else if(step==s9)
	RJMP _0x66
_0x64:
	LDI  R30,LOW(9)
	CP   R30,R10
	BRNE _0x67
; 0000 0276 		{
; 0000 0277 		temp|=(1<<PP1)|(1<<PP2);
	RCALL SUBOPT_0x1
; 0000 0278 
; 0000 0279 		cnt_del--;
; 0000 027A 		if(cnt_del==0)
	BRNE _0x68
; 0000 027B 			{
; 0000 027C 			step=s10;
	LDI  R30,LOW(10)
	MOV  R10,R30
; 0000 027D 			cnt_del=30;
	RCALL SUBOPT_0x4
; 0000 027E 			}
; 0000 027F 		}
_0x68:
; 0000 0280 	else if(step==s10)
	RJMP _0x69
_0x67:
	LDI  R30,LOW(10)
	CP   R30,R10
	BRNE _0x6A
; 0000 0281 		{
; 0000 0282 		temp|=(1<<PP2);
	RCALL SUBOPT_0xC
; 0000 0283 		cnt_del--;
; 0000 0284 		if(cnt_del==0)
	BRNE _0x6B
; 0000 0285 			{
; 0000 0286 			step=sOFF;
	CLR  R10
; 0000 0287 			}
; 0000 0288 		}
_0x6B:
; 0000 0289 	}
_0x6A:
_0x69:
_0x66:
_0x63:
_0x60:
_0x5D:
_0x5A:
_0x57:
_0x54:
_0x51:
_0x4D:
; 0000 028A 
; 0000 028B if(prog==p2)
_0x47:
_0x46:
	LDI  R30,LOW(2)
	CP   R30,R11
	BREQ PC+2
	RJMP _0x6C
; 0000 028C 	{
; 0000 028D 
; 0000 028E 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x6D
; 0000 028F 		{
; 0000 0290 		temp|=(1<<PP1)|(1<<PP2);
	RCALL SUBOPT_0x1
; 0000 0291 
; 0000 0292 		cnt_del--;
; 0000 0293 		if(cnt_del==0)
	BRNE _0x6E
; 0000 0294 			{
; 0000 0295 			if(ee_vacuum_mode==evmOFF)
	RCALL SUBOPT_0x2
	BREQ _0x70
; 0000 0296 				{
; 0000 0297 				goto lbl_0002;
; 0000 0298 				}
; 0000 0299 			else step=s2;
	LDI  R30,LOW(2)
	MOV  R10,R30
; 0000 029A 			}
; 0000 029B 		}
_0x6E:
; 0000 029C 
; 0000 029D 	else if(step==s2)
	RJMP _0x72
_0x6D:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x73
; 0000 029E 		{
; 0000 029F 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	RCALL SUBOPT_0x3
; 0000 02A0 
; 0000 02A1           if(!bVR)goto step_contr_end;
	BRNE _0x74
	RJMP _0x50
; 0000 02A2 lbl_0002:
_0x74:
_0x70:
; 0000 02A3 #ifndef BIG_CAM
; 0000 02A4 		cnt_del=30;
	RCALL SUBOPT_0x4
; 0000 02A5 #endif
; 0000 02A6 
; 0000 02A7 #ifdef BIG_CAM
; 0000 02A8 		cnt_del=100;
; 0000 02A9 #endif
; 0000 02AA 		step=s3;
	LDI  R30,LOW(3)
	MOV  R10,R30
; 0000 02AB 		}
; 0000 02AC 
; 0000 02AD 	else if(step==s3)
	RJMP _0x75
_0x73:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x76
; 0000 02AE 		{
; 0000 02AF 		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
	RCALL SUBOPT_0x5
; 0000 02B0 
; 0000 02B1 		cnt_del--;
; 0000 02B2 		if(cnt_del==0)
	BRNE _0x77
; 0000 02B3 			{
; 0000 02B4 			step=s4;
	LDI  R30,LOW(4)
	MOV  R10,R30
; 0000 02B5 			}
; 0000 02B6 		}
_0x77:
; 0000 02B7 
; 0000 02B8 	else if(step==s4)
	RJMP _0x78
_0x76:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0x79
; 0000 02B9 		{
; 0000 02BA 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
	ORI  R17,LOW(116)
; 0000 02BB 
; 0000 02BC           if(!bMD1)goto step_contr_end;
	LDS  R30,_bMD1
	CPI  R30,0
	BRNE _0x7A
	RJMP _0x50
; 0000 02BD          	cnt_del=30;
_0x7A:
	RCALL SUBOPT_0x4
; 0000 02BE 		step=s5;
	LDI  R30,LOW(5)
	MOV  R10,R30
; 0000 02BF 		}
; 0000 02C0 
; 0000 02C1 	else if(step==s5)
	RJMP _0x7B
_0x79:
	LDI  R30,LOW(5)
	CP   R30,R10
	BRNE _0x7C
; 0000 02C2 		{
; 0000 02C3 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
	RCALL SUBOPT_0x7
; 0000 02C4 
; 0000 02C5 		cnt_del--;
; 0000 02C6 		if(cnt_del==0)
	BRNE _0x7D
; 0000 02C7 			{
; 0000 02C8 			step=s6;
	LDI  R30,LOW(6)
	MOV  R10,R30
; 0000 02C9 			cnt_del=30;
	RCALL SUBOPT_0x4
; 0000 02CA 			}
; 0000 02CB 		}
_0x7D:
; 0000 02CC 
; 0000 02CD 	else if(step==s6)
	RJMP _0x7E
_0x7C:
	LDI  R30,LOW(6)
	CP   R30,R10
	BRNE _0x7F
; 0000 02CE 		{
; 0000 02CF 		temp|=(1<<PP1)|(1<<PP3);
	RCALL SUBOPT_0xA
; 0000 02D0 
; 0000 02D1 		cnt_del--;
; 0000 02D2 		if(cnt_del==0)
	BRNE _0x80
; 0000 02D3 			{
; 0000 02D4 			step=s7;
	LDI  R30,LOW(7)
	RCALL SUBOPT_0xB
; 0000 02D5 #ifndef BIG_CAM
; 0000 02D6 		cnt_del=150;
; 0000 02D7 #endif
; 0000 02D8 
; 0000 02D9 #ifdef BIG_CAM
; 0000 02DA 		cnt_del=200;
; 0000 02DB #endif
; 0000 02DC 			}
; 0000 02DD 		}
_0x80:
; 0000 02DE 
; 0000 02DF 	else if(step==s7)
	RJMP _0x81
_0x7F:
	LDI  R30,LOW(7)
	CP   R30,R10
	BRNE _0x82
; 0000 02E0 		{
; 0000 02E1 		temp|=(1<<PP1)|(1<<PP2);
	RCALL SUBOPT_0x1
; 0000 02E2 
; 0000 02E3 		cnt_del--;
; 0000 02E4 		if(cnt_del==0)
	BRNE _0x83
; 0000 02E5 			{
; 0000 02E6 			step=s8;
	LDI  R30,LOW(8)
	MOV  R10,R30
; 0000 02E7 			cnt_del=30;
	RCALL SUBOPT_0x4
; 0000 02E8 			}
; 0000 02E9 		}
_0x83:
; 0000 02EA 	else if(step==s8)
	RJMP _0x84
_0x82:
	LDI  R30,LOW(8)
	CP   R30,R10
	BRNE _0x85
; 0000 02EB 		{
; 0000 02EC 		temp|=(1<<PP2);
	RCALL SUBOPT_0xC
; 0000 02ED 
; 0000 02EE 		cnt_del--;
; 0000 02EF 		if(cnt_del==0)
	BRNE _0x86
; 0000 02F0 			{
; 0000 02F1 			step=sOFF;
	CLR  R10
; 0000 02F2 			}
; 0000 02F3 		}
_0x86:
; 0000 02F4 	}
_0x85:
_0x84:
_0x81:
_0x7E:
_0x7B:
_0x78:
_0x75:
_0x72:
; 0000 02F5 
; 0000 02F6 if(prog==p3)
_0x6C:
	LDI  R30,LOW(3)
	CP   R30,R11
	BREQ PC+2
	RJMP _0x87
; 0000 02F7 	{
; 0000 02F8 
; 0000 02F9 	if(step==s1)
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x88
; 0000 02FA 		{
; 0000 02FB 		temp|=(1<<PP1)|(1<<PP2);
	RCALL SUBOPT_0x1
; 0000 02FC 
; 0000 02FD 		cnt_del--;
; 0000 02FE 		if(cnt_del==0)
	BRNE _0x89
; 0000 02FF 			{
; 0000 0300 			if(ee_vacuum_mode==evmOFF)
	RCALL SUBOPT_0x2
	BREQ _0x8B
; 0000 0301 				{
; 0000 0302 				goto lbl_0003;
; 0000 0303 				}
; 0000 0304 			else step=s2;
	LDI  R30,LOW(2)
	MOV  R10,R30
; 0000 0305 			}
; 0000 0306 		}
_0x89:
; 0000 0307 
; 0000 0308 	else if(step==s2)
	RJMP _0x8D
_0x88:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x8E
; 0000 0309 		{
; 0000 030A 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
	RCALL SUBOPT_0x3
; 0000 030B 
; 0000 030C           if(!bVR)goto step_contr_end;
	BREQ _0x50
; 0000 030D lbl_0003:
_0x8B:
; 0000 030E #ifndef BIG_CAM
; 0000 030F 		cnt_del=80;
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RCALL SUBOPT_0x9
; 0000 0310 #endif
; 0000 0311 
; 0000 0312 #ifdef BIG_CAM
; 0000 0313 		cnt_del=100;
; 0000 0314 #endif
; 0000 0315 		step=s3;
	LDI  R30,LOW(3)
	MOV  R10,R30
; 0000 0316 		}
; 0000 0317 
; 0000 0318 	else if(step==s3)
	RJMP _0x90
_0x8E:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x91
; 0000 0319 		{
; 0000 031A 		temp|=(1<<PP1)|(1<<PP3);
	RCALL SUBOPT_0xA
; 0000 031B 
; 0000 031C 		cnt_del--;
; 0000 031D 		if(cnt_del==0)
	BRNE _0x92
; 0000 031E 			{
; 0000 031F 			step=s4;
	LDI  R30,LOW(4)
	MOV  R10,R30
; 0000 0320 			cnt_del=120;
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	RCALL SUBOPT_0x9
; 0000 0321 			}
; 0000 0322 		}
_0x92:
; 0000 0323 
; 0000 0324 	else if(step==s4)
	RJMP _0x93
_0x91:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0x94
; 0000 0325 		{
; 0000 0326 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<PP5);
	ORI  R17,LOW(120)
; 0000 0327 
; 0000 0328 		cnt_del--;
	RCALL SUBOPT_0xD
; 0000 0329 		if(cnt_del==0)
	BRNE _0x95
; 0000 032A 			{
; 0000 032B 			step=s5;
	LDI  R30,LOW(5)
	RCALL SUBOPT_0xB
; 0000 032C 
; 0000 032D 
; 0000 032E #ifndef BIG_CAM
; 0000 032F 		cnt_del=150;
; 0000 0330 #endif
; 0000 0331 
; 0000 0332 #ifdef BIG_CAM
; 0000 0333 		cnt_del=200;
; 0000 0334 #endif
; 0000 0335 	//	step=s5;
; 0000 0336 	}
; 0000 0337 		}
_0x95:
; 0000 0338 
; 0000 0339 	else if(step==s5)
	RJMP _0x96
_0x94:
	LDI  R30,LOW(5)
	CP   R30,R10
	BRNE _0x97
; 0000 033A 		{
; 0000 033B 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<PP5);
	ORI  R17,LOW(216)
; 0000 033C 
; 0000 033D 		cnt_del--;
	RCALL SUBOPT_0xD
; 0000 033E 		if(cnt_del==0)
	BRNE _0x98
; 0000 033F 			{
; 0000 0340 			step=s6;
	LDI  R30,LOW(6)
	MOV  R10,R30
; 0000 0341 			cnt_del=30;
	RCALL SUBOPT_0x4
; 0000 0342 			}
; 0000 0343 		}
_0x98:
; 0000 0344 
; 0000 0345 	else if(step==s6)
	RJMP _0x99
_0x97:
	LDI  R30,LOW(6)
	CP   R30,R10
	BRNE _0x9A
; 0000 0346 		{
; 0000 0347 		temp|=(1<<PP2)|(1<<PP4)|(1<<PP5);
	ORI  R17,LOW(152)
; 0000 0348 
; 0000 0349 		cnt_del--;
	RCALL SUBOPT_0xD
; 0000 034A 		if(cnt_del==0)
	BRNE _0x9B
; 0000 034B 			{
; 0000 034C 			step=s7;
	LDI  R30,LOW(7)
	MOV  R10,R30
; 0000 034D 			cnt_del=30;
	RCALL SUBOPT_0x4
; 0000 034E 			}
; 0000 034F 		}
_0x9B:
; 0000 0350 
; 0000 0351 	else if(step==s7)
	RJMP _0x9C
_0x9A:
	LDI  R30,LOW(7)
	CP   R30,R10
	BRNE _0x9D
; 0000 0352 		{
; 0000 0353 		temp|=(1<<PP2);
	RCALL SUBOPT_0xC
; 0000 0354 
; 0000 0355 		cnt_del--;
; 0000 0356 		if(cnt_del==0)
	BRNE _0x9E
; 0000 0357 			{
; 0000 0358 			step=sOFF;
	CLR  R10
; 0000 0359 			}
; 0000 035A 		}
_0x9E:
; 0000 035B 
; 0000 035C 	}
_0x9D:
_0x9C:
_0x99:
_0x96:
_0x93:
_0x90:
_0x8D:
; 0000 035D step_contr_end:
_0x87:
_0x50:
; 0000 035E 
; 0000 035F if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
	RCALL SUBOPT_0x2
	BRNE _0x9F
	ANDI R17,LOW(223)
; 0000 0360 
; 0000 0361 PORTB=~temp;
_0x9F:
	MOV  R30,R17
	COM  R30
	OUT  0x18,R30
; 0000 0362 }
	LD   R17,Y+
	RET
; .FEND
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
;			if(ee_vacuum_mode==evmOFF)
;				{
;				goto lbl_0001;
;				}
;			else step=s2;
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
;	else if(step==s7)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s8;
;          	cnt_del=ee_delay[prog,0]*10U;;
;			}
;          }
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
;			if(ee_vacuum_mode==evmOFF)
;				{
;				goto lbl_0002;
;				}
;			else step=s2;
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
;	else if(step==s5)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s6;
;          	cnt_del=ee_delay[prog,0]*10U;
;			}
;          }
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
;			if(ee_vacuum_mode==evmOFF)
;				{
;				goto lbl_0003;
;				}
;			else step=s2;
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
;	else	if(step==s3)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			cnt_del=ee_delay[prog,0]*10U;
;			step=s4;
;			}
;          }
;	else if(step==s4)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;		cnt_del--;
; 		if(cnt_del==0)
;			{
;			cnt_del=ee_delay[prog,1]*10U;
;			step=s5;
;			}
;		}
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
;			if(ee_vacuum_mode==evmOFF)
;				{
;				goto lbl_0004;
;				}
;			else step=s2;
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
;	else if(step==s3)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s4;
;			cnt_del=ee_delay[prog,0]*10U;
;			}
;          }
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
;			cnt_del=ee_delay[prog,1]*10U;
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
;if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;
;PORTB=~temp;
;//PORTB=0x55;
;}
;#endif
;
;#ifdef I220_WI
;//-----------------------------------------------
;void step_contr(void)
;{
;char temp=0;
;DDRB=0xFF;
;
;if(step==sOFF)goto step_contr_end;
;
;else if(prog==p3)   //твист
;	{
;	if(step==s1)
;		{
;		temp|=(1<<PP1);
;          if(!bMD1)goto step_contr_end;
;
;			if(ee_vacuum_mode==evmOFF)
;				{
;				goto lbl_0003;
;				}
;			else step=s2;
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
;	else	if(step==s3)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			cnt_del=90;
;			step=s4;
;			}
;          }
;	else if(step==s4)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;		cnt_del--;
; 		if(cnt_del==0)
;			{
;			cnt_del=130;
;			step=s5;
;			}
;		}
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
;			if(ee_vacuum_mode==evmOFF)
;				{
;				goto lbl_0004;
;				}
;			else step=s2;
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
;	else if(step==s3)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s4;
;			cnt_del=120;
;			}
;          }
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
;			cnt_del=120;
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
;if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;
;PORTB=~temp;
;//PORTB=0x55;
;}
;#endif
;
;#ifdef I380_WI
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
;			if(ee_vacuum_mode==evmOFF)
;				{
;				goto lbl_0001;
;				}
;			else step=s2;
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
;          step=s54;
;          cnt_del=20;
;		}
;	else if(step==s54)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s5;
;          	cnt_del=20;
;			}
;          }
;
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
;          step=s55;
;          cnt_del=40;
;		}
;	else if(step==s55)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s7;
;          	cnt_del=20;
;			}
;          }
;	else if(step==s7)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s8;
;          	cnt_del=130;
;			}
;          }
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
;			if(ee_vacuum_mode==evmOFF)
;				{
;				goto lbl_0002;
;				}
;			else step=s2;
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
;	else if(step==s5)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s6;
;          	cnt_del=130;
;			}
;          }
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
;			if(ee_vacuum_mode==evmOFF)
;				{
;				goto lbl_0003;
;				}
;			else step=s2;
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
;	else	if(step==s3)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			cnt_del=90;
;			step=s4;
;			}
;          }
;	else if(step==s4)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;		cnt_del--;
; 		if(cnt_del==0)
;			{
;			cnt_del=130;
;			step=s5;
;			}
;		}
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
;			if(ee_vacuum_mode==evmOFF)
;				{
;				goto lbl_0004;
;				}
;			else step=s2;
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
;	else if(step==s3)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s4;
;			cnt_del=120U;
;			}
;          }
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
;			cnt_del=120U;
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
;if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;
;PORTB=~temp;
;//PORTB=0x55;
;}
;#endif
;
;#ifdef I220
;//-----------------------------------------------
;void step_contr(void)
;{
;char temp=0;
;DDRB=0xFF;
;
;if(step==sOFF)goto step_contr_end;
;
;else if(prog==p3)   //твист
;	{
;	if(step==s1)
;		{
;		temp|=(1<<PP1);
;          if(!bMD1)goto step_contr_end;
;
;			if(ee_vacuum_mode==evmOFF)
;				{
;				goto lbl_0003;
;				}
;			else step=s2;
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
;	else	if(step==s3)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			cnt_del=ee_delay[prog,0]*10U;
;			step=s4;
;			}
;          }
;	else if(step==s4)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
;		cnt_del--;
; 		if(cnt_del==0)
;			{
;			cnt_del=ee_delay[prog,1]*10U;
;			step=s5;
;			}
;		}
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
;			if(ee_vacuum_mode==evmOFF)
;				{
;				goto lbl_0004;
;				}
;			else step=s2;
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
;	else if(step==s3)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s4;
;			cnt_del=ee_delay[prog,0]*10U;
;			}
;          }
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
;			cnt_del=ee_delay[prog,1]*10U;
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
;if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
;
;PORTB=~temp;
;//PORTB=0x55;
;}
;#endif
;
;#ifdef TVIST_SKO
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
;if(prog==p2) //СКО
;	{
;	if(step==s1)
;		{
;		temp|=(1<<PP1);
;
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=s2;
;			cnt_del=30;
;			}
;		}
;
;	else if(step==s2)
;		{
;		temp|=(1<<PP1)|(1<<DV);
;
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=s3;
;			}
;		}
;
;
;	else if(step==s3)
;		{
;		temp|=(1<<PP1)|(1<<DV)|(1<<PP2);
;
;               	if(bMD1)//goto step_contr_end;
;               		{
;               		cnt_del=100;
;	       		step=s4;
;	       		}
;	       	}
;
;	else if(step==s4)
;		{
;		temp|=(1<<PP1);
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=sOFF;
;			}
;		}
;
;	}
;
;if(prog==p3)
;	{
;	if(step==s1)
;		{
;		temp|=(1<<PP1);
;
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=s2;
;			cnt_del=100;
;			}
;		}
;
;	else if(step==s2)
;		{
;		temp|=(1<<PP1)|(1<<PP2);
;
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=s3;
;			cnt_del=50;
;			}
;		}
;
;
;	else if(step==s3)
;		{
;		temp|=(1<<PP2);
;
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			step=sOFF;
;			}
;               	}
;	}
;step_contr_end:
;
;PORTB=~temp;
;}
;#endif
;
;#ifdef I380_WI_GAZ
;//-----------------------------------------------
;void step_contr(void)
;{
;short temp=0;
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
;			if(ee_vacuum_mode==evmOFF)
;				{
;				goto lbl_0001;
;				}
;			else step=s2;
;		}
;
;	else if(step==s2)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP7);
;          if(!bVR)goto step_contr_end;
;lbl_0001:
;
;          step=s3;
;		cnt_del=10;
;          }
;	else if(step==s3)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s4;
;			}
;		}
;
;	else if(step==s4)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP8);
;          if(bVR2)goto step_contr_end;
;          step=s5;
;          cnt_del=40;
;		}
;
;	else if(step==s5)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s6;
;          	cnt_del=50;
;			}
;		}
;	else if(step==s6)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<DV);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s7;
;			}
;		}
;	else if(step==s7)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<PP5)|(1<<DV);
;          if(!bMD2)goto step_contr_end;
;          step=s8;
;          cnt_del=30;
;		}
;	else if(step==s8)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<PP5)|(1<<DV);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s9;
;          	cnt_del=20;
;			}
;          }
;
;	else if(step==s9)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<DV);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s10;
;			}
;          }
;	else if(step==s10)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<DV)|(1<<PP6);
;          if(!bMD3)goto step_contr_end;
;          step=s11;
;          cnt_del=40;
;		}
;	else if(step==s11)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<DV)|(1<<PP6);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s12;
;          	cnt_del=20;
;			}
;          }
;	else if(step==s12)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP7);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s13;
;          	cnt_del=130;
;			}
;          }
;	else if(step==s13)
;		{
;		temp|=(1<<PP1)|(1<<PP2);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s14;
;          	cnt_del=20;
;			}
;          }
;	else if(step==s14)
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
;
;else if(prog==p2)
;	{
;	if(step==s1)    //жесть без газа
;		{
;		temp|=(1<<PP1);
;          if(!bMD1)goto step_contr_end;
;
;			if(ee_vacuum_mode==evmOFF)
;				{
;				goto lbl_0002;
;				}
;			else step=s2;
;		}
;
;	else if(step==s2)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP7);
;          if(!bVR)goto step_contr_end;
;lbl_0002:
;
;          step=s100;
;		cnt_del=40;
;          }
;	else if(step==s100)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP7);
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
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s4;
;			}
;		}
;	else if(step==s4)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV)|(1<<PP7);
;          if(!bMD2)goto step_contr_end;
;          step=s54;
;          cnt_del=20;
;		}
;	else if(step==s54)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV)|(1<<PP7);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s5;
;          	cnt_del=20;
;			}
;          }
;
;	else if(step==s5)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP7)|(1<<DV);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s6;
;			}
;          }
;	else if(step==s6)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP6)|(1<<PP7);
;          if(!bMD3)goto step_contr_end;
;          step=s55;
;          cnt_del=40;
;		}
;	else if(step==s55)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP6)|(1<<PP7);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s7;
;          	cnt_del=20;
;			}
;          }
;	else if(step==s7)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s8;
;          	cnt_del=200UL;
;			}
;          }
;	else if(step==s8)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<PP7);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s9;
;          	cnt_del=20;
;			}
;          }
;	else if(step==s9)
;		{
;		temp|=(1<<PP1)|(1<<PP7);
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
;			if(ee_vacuum_mode==evmOFF)
;				{
;				goto lbl_0003;
;				}
;			else step=s2;
;
;          //step=s2;
;		}
;
;	else if(step==s2)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP7);
;          if(!bVR)goto step_contr_end;
;lbl_0003:
;          cnt_del=50;
;		step=s3;
;		}
;
;
;	else	if(step==s3)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP7);
;		cnt_del--;
;		if(cnt_del==0)
;			{
;			cnt_del=90;
;			step=s4;
;			}
;          }
;	else if(step==s4)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP6)|(1<<PP7);
;		cnt_del--;
; 		if(cnt_del==0)
;			{
;			cnt_del=200UL;
;			step=s5;
;			}
;		}
;
;	else if(step==s5)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP6)|(1<<PP7);
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
;		temp|=(1<<PP1)|(1<<PP7);
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
;			if(ee_vacuum_mode==evmOFF)
;				{
;				goto lbl_0004;
;				}
;			else step=s2;
;          //step=s2;
;		}
;
;	else if(step==s2)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP7);
;          if(!bVR)goto step_contr_end;
;lbl_0004:
;          step=s3;
;		cnt_del=50;
;          }
;
;	else if(step==s3)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP7);
;          cnt_del--;
;          if(cnt_del==0)
;			{
;          	step=s4;
;			cnt_del=160U;
;			}
;          }
;
;   	else if(step==s4)
;		{
;		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<PP7);
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
;			cnt_del=200U;
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
;if(ee_vacuum_mode==evmOFF)
;	{
;	temp&=~(1<<PP3);
;	temp&=~(1<<PP7);
;	}
;
;//temp=0;
;//temp|=(1<<DV);
;
;PORTB=~((char)temp);
;//PORTB=0x55;
;
;DDRD.1=1;
;if(temp&(1<<DV))PORTD.1=0;
;else PORTD.1=1;
;}
;#endif
;
;
;//-----------------------------------------------
;void bin2bcd_int(unsigned int in)
; 0000 0966 {
_bin2bcd_int:
; .FSTART _bin2bcd_int
; 0000 0967 char i;
; 0000 0968 for(i=3;i>0;i--)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	in -> Y+1
;	i -> R17
	LDI  R17,LOW(3)
_0xA1:
	CPI  R17,1
	BRLO _0xA2
; 0000 0969 	{
; 0000 096A 	dig[i]=in%10;
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
; 0000 096B 	in/=10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
; 0000 096C 	}
	SUBI R17,1
	RJMP _0xA1
_0xA2:
; 0000 096D }
	LDD  R17,Y+0
	RJMP _0x2000001
; .FEND
;
;//-----------------------------------------------
;void bcd2ind(char s)
; 0000 0971 {
_bcd2ind:
; .FSTART _bcd2ind
; 0000 0972 char i;
; 0000 0973 bZ=1;
	ST   -Y,R26
	ST   -Y,R17
;	s -> Y+1
;	i -> R17
	SET
	BLD  R2,3
; 0000 0974 for (i=0;i<5;i++)
	LDI  R17,LOW(0)
_0xA4:
	CPI  R17,5
	BRSH _0xA5
; 0000 0975 	{
; 0000 0976 	if(bZ&&(!dig[i-1])&&(i<4))
	SBRS R2,3
	RJMP _0xA7
	MOV  R30,R17
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_dig)
	SBCI R31,HIGH(-_dig)
	LD   R30,Z
	CPI  R30,0
	BRNE _0xA7
	CPI  R17,4
	BRLO _0xA8
_0xA7:
	RJMP _0xA6
_0xA8:
; 0000 0977 		{
; 0000 0978 		if((4-i)>s)
	LDI  R30,LOW(4)
	SUB  R30,R17
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
	BRSH _0xA9
; 0000 0979 			{
; 0000 097A 			ind_out[i-1]=DIGISYM[10];
	RCALL SUBOPT_0xE
	__POINTW1FN _DIGISYM,10
	RJMP _0x112
; 0000 097B 			}
; 0000 097C 		else ind_out[i-1]=DIGISYM[0];
_0xA9:
	RCALL SUBOPT_0xE
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
_0x112:
	LPM  R30,Z
	ST   X,R30
; 0000 097D 		}
; 0000 097E 	else
	RJMP _0xAB
_0xA6:
; 0000 097F 		{
; 0000 0980 		ind_out[i-1]=DIGISYM[dig[i-1]];
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
; 0000 0981 		bZ=0;
	CLT
	BLD  R2,3
; 0000 0982 		}
_0xAB:
; 0000 0983 
; 0000 0984 	if(s)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0xAC
; 0000 0985 		{
; 0000 0986 		ind_out[3-s]&=0b01111111;
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
; 0000 0987 		}
; 0000 0988 
; 0000 0989 	}
_0xAC:
	SUBI R17,-1
	RJMP _0xA4
_0xA5:
; 0000 098A }
	LDD  R17,Y+0
	ADIW R28,2
	RET
; .FEND
;//-----------------------------------------------
;void int2ind(unsigned int in,char s)
; 0000 098D {
_int2ind:
; .FSTART _int2ind
; 0000 098E bin2bcd_int(in);
	ST   -Y,R26
;	in -> Y+1
;	s -> Y+0
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL _bin2bcd_int
; 0000 098F bcd2ind(s);
	LD   R26,Y
	RCALL _bcd2ind
; 0000 0990 
; 0000 0991 }
_0x2000001:
	ADIW R28,3
	RET
; .FEND
;
;//-----------------------------------------------
;void ind_hndl(void)
; 0000 0995 {
_ind_hndl:
; .FSTART _ind_hndl
; 0000 0996 int2ind(ee_delay[prog][sub_ind],1);
	RCALL SUBOPT_0xF
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _int2ind
; 0000 0997 //ind_out[0]=0xff;//DIGISYM[0];
; 0000 0998 //ind_out[1]=0xff;//DIGISYM[1];
; 0000 0999 //ind_out[2]=DIGISYM[2];//0xff;
; 0000 099A //ind_out[0]=DIGISYM[7];
; 0000 099B 
; 0000 099C ind_out[0]=DIGISYM[sub_ind+1];
	MOV  R30,R12
	LDI  R31,0
	__ADDW1FN _DIGISYM,1
	LPM  R0,Z
	STS  _ind_out,R0
; 0000 099D }
	RET
; .FEND
;
;//-----------------------------------------------
;void led_hndl(void)
; 0000 09A1 {
_led_hndl:
; .FSTART _led_hndl
; 0000 09A2 ind_out[4]=DIGISYM[10];
	__POINTW1FN _DIGISYM,10
	LPM  R0,Z
	__PUTBR0MN _ind_out,4
; 0000 09A3 
; 0000 09A4 ind_out[4]&=~(1<<LED_POW_ON);
	__POINTW2MN _ind_out,4
	LD   R30,X
	ANDI R30,0xDF
	ST   X,R30
; 0000 09A5 
; 0000 09A6 if(step!=sOFF)
	TST  R10
	BREQ _0xAD
; 0000 09A7 	{
; 0000 09A8 	ind_out[4]&=~(1<<LED_WRK);
	__POINTW2MN _ind_out,4
	LD   R30,X
	ANDI R30,0xBF
	RJMP _0x113
; 0000 09A9 	}
; 0000 09AA else ind_out[4]|=(1<<LED_WRK);
_0xAD:
	__POINTW2MN _ind_out,4
	LD   R30,X
	ORI  R30,0x40
_0x113:
	ST   X,R30
; 0000 09AB 
; 0000 09AC 
; 0000 09AD if(step==sOFF)
	TST  R10
	BRNE _0xAF
; 0000 09AE 	{
; 0000 09AF  	if(bERR)
	SBRS R3,1
	RJMP _0xB0
; 0000 09B0 		{
; 0000 09B1 		ind_out[4]&=~(1<<LED_ERROR);
	__POINTW2MN _ind_out,4
	LD   R30,X
	ANDI R30,0xFE
	RJMP _0x114
; 0000 09B2 		}
; 0000 09B3 	else
_0xB0:
; 0000 09B4 		{
; 0000 09B5 		ind_out[4]|=(1<<LED_ERROR);
	__POINTW2MN _ind_out,4
	LD   R30,X
	ORI  R30,1
_0x114:
	ST   X,R30
; 0000 09B6 		}
; 0000 09B7      }
; 0000 09B8 else ind_out[4]|=(1<<LED_ERROR);
	RJMP _0xB2
_0xAF:
	__POINTW2MN _ind_out,4
	LD   R30,X
	ORI  R30,1
	ST   X,R30
; 0000 09B9 
; 0000 09BA /* 	if(bMD1)
; 0000 09BB 		{
; 0000 09BC 		ind_out[4]&=~(1<<LED_ERROR);
; 0000 09BD 		}
; 0000 09BE 	else
; 0000 09BF 		{
; 0000 09C0 		ind_out[4]|=(1<<LED_ERROR);
; 0000 09C1 		} */
; 0000 09C2 
; 0000 09C3 //if(bERR)ind_out[4]&=~(1<<LED_ERROR);
; 0000 09C4 if(ee_vacuum_mode==evmON)ind_out[4]&=~(1<<LED_VACUUM);
_0xB2:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0xB3
	__POINTW2MN _ind_out,4
	LD   R30,X
	ANDI R30,0x7F
	RJMP _0x115
; 0000 09C5 else ind_out[4]|=(1<<LED_VACUUM);
_0xB3:
	__POINTW2MN _ind_out,4
	LD   R30,X
	ORI  R30,0x80
_0x115:
	ST   X,R30
; 0000 09C6 
; 0000 09C7 if(prog==p1) ind_out[4]&=~(1<<LED_PROG1);
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0xB5
	__POINTW2MN _ind_out,4
	LD   R30,X
	ANDI R30,0xEF
	RJMP _0x116
; 0000 09C8 else if(prog==p2) ind_out[4]&=~(1<<LED_PROG2);
_0xB5:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0xB7
	__POINTW2MN _ind_out,4
	LD   R30,X
	ANDI R30,0xFB
	RJMP _0x116
; 0000 09C9 else if(prog==p3) ind_out[4]&=~(1<<LED_PROG3);
_0xB7:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0xB9
	__POINTW2MN _ind_out,4
	LD   R30,X
	ANDI R30,0XF7
	RJMP _0x116
; 0000 09CA else if(prog==p4) ind_out[4]&=~(1<<LED_PROG4);
_0xB9:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0xBB
	__POINTW2MN _ind_out,4
	LD   R30,X
	ANDI R30,0xFD
_0x116:
	ST   X,R30
; 0000 09CB 
; 0000 09CC if(ind==iPr_sel)
_0xBB:
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0xBC
; 0000 09CD 	{
; 0000 09CE 	if(bFL5)ind_out[4]|=(1<<LED_PROG1)|(1<<LED_PROG2)|(1<<LED_PROG3)|(1<<LED_PROG4);
	SBRS R3,0
	RJMP _0xBD
	__POINTW2MN _ind_out,4
	LD   R30,X
	ORI  R30,LOW(0x1E)
	ST   X,R30
; 0000 09CF 	}
_0xBD:
; 0000 09D0 
; 0000 09D1 if(ind==iVr)
_0xBC:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0xBE
; 0000 09D2 	{
; 0000 09D3 	if(bFL5)ind_out[4]|=(1<<LED_POW_ON);
	SBRS R3,0
	RJMP _0xBF
	__POINTW2MN _ind_out,4
	LD   R30,X
	ORI  R30,0x20
	ST   X,R30
; 0000 09D4 	}
_0xBF:
; 0000 09D5 }
_0xBE:
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
; 0000 09E8 {
_but_drv:
; .FSTART _but_drv
; 0000 09E9 DDRD&=0b00000111;
	IN   R30,0x11
	ANDI R30,LOW(0x7)
	OUT  0x11,R30
; 0000 09EA PORTD|=0b11111000;
	IN   R30,0x12
	ORI  R30,LOW(0xF8)
	OUT  0x12,R30
; 0000 09EB 
; 0000 09EC but_port|=(but_mask^0xff);
	RCALL SUBOPT_0x10
; 0000 09ED but_dir&=but_mask;
; 0000 09EE #asm
; 0000 09EF nop
nop
; 0000 09F0 nop
nop
; 0000 09F1 nop
nop
; 0000 09F2 nop
nop
; 0000 09F3 #endasm
; 0000 09F4 
; 0000 09F5 but_n=but_pin|but_mask;
	IN   R30,0x13
	ORI  R30,LOW(0x6A)
	STS  _but_n_G000,R30
; 0000 09F6 
; 0000 09F7 if((but_n==no_but)||(but_n!=but_s))
	LDS  R26,_but_n_G000
	CPI  R26,LOW(0xFF)
	BREQ _0xC1
	LDS  R30,_but_s_G000
	CP   R30,R26
	BREQ _0xC0
_0xC1:
; 0000 09F8  	{
; 0000 09F9  	speed=0;
	CLT
	BLD  R2,6
; 0000 09FA    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
	LDS  R26,_but0_cnt_G000
	CPI  R26,LOW(0x5)
	BRSH _0xC4
	LDS  R26,_but1_cnt_G000
	CPI  R26,LOW(0x0)
	BREQ _0xC6
_0xC4:
	SBRS R2,4
	RJMP _0xC7
_0xC6:
	RJMP _0xC3
_0xC7:
; 0000 09FB   		{
; 0000 09FC    	     n_but=1;
	SET
	BLD  R2,5
; 0000 09FD           but=but_s;
	LDS  R8,_but_s_G000
; 0000 09FE           }
; 0000 09FF    	if (but1_cnt>=but_onL_temp)
_0xC3:
	LDS  R30,_but_onL_temp_G000
	LDS  R26,_but1_cnt_G000
	CP   R26,R30
	BRLO _0xC8
; 0000 0A00   		{
; 0000 0A01    	     n_but=1;
	SET
	BLD  R2,5
; 0000 0A02           but=but_s&0b11111101;
	LDS  R30,_but_s_G000
	ANDI R30,0xFD
	MOV  R8,R30
; 0000 0A03           }
; 0000 0A04     	l_but=0;
_0xC8:
	CLT
	BLD  R2,4
; 0000 0A05    	but_onL_temp=but_onL;
	LDI  R30,LOW(20)
	STS  _but_onL_temp_G000,R30
; 0000 0A06     	but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G000,R30
; 0000 0A07   	but1_cnt=0;
	STS  _but1_cnt_G000,R30
; 0000 0A08      goto but_drv_out;
	RJMP _0xC9
; 0000 0A09   	}
; 0000 0A0A 
; 0000 0A0B if(but_n==but_s)
_0xC0:
	LDS  R30,_but_s_G000
	LDS  R26,_but_n_G000
	CP   R30,R26
	BRNE _0xCA
; 0000 0A0C  	{
; 0000 0A0D   	but0_cnt++;
	LDS  R30,_but0_cnt_G000
	SUBI R30,-LOW(1)
	STS  _but0_cnt_G000,R30
; 0000 0A0E   	if(but0_cnt>=but_on)
	LDS  R26,_but0_cnt_G000
	CPI  R26,LOW(0x5)
	BRLO _0xCB
; 0000 0A0F   		{
; 0000 0A10    		but0_cnt=0;
	LDI  R30,LOW(0)
	STS  _but0_cnt_G000,R30
; 0000 0A11    		but1_cnt++;
	LDS  R30,_but1_cnt_G000
	SUBI R30,-LOW(1)
	STS  _but1_cnt_G000,R30
; 0000 0A12    		if(but1_cnt>=but_onL_temp)
	LDS  R30,_but_onL_temp_G000
	LDS  R26,_but1_cnt_G000
	CP   R26,R30
	BRLO _0xCC
; 0000 0A13    			{
; 0000 0A14     			but=but_s&0b11111101;
	LDS  R30,_but_s_G000
	ANDI R30,0xFD
	MOV  R8,R30
; 0000 0A15     			but1_cnt=0;
	LDI  R30,LOW(0)
	STS  _but1_cnt_G000,R30
; 0000 0A16     			n_but=1;
	SET
	BLD  R2,5
; 0000 0A17     			l_but=1;
	BLD  R2,4
; 0000 0A18 			if(speed)
	SBRS R2,6
	RJMP _0xCD
; 0000 0A19 				{
; 0000 0A1A     				but_onL_temp=but_onL_temp>>1;
	LDS  R30,_but_onL_temp_G000
	LSR  R30
	STS  _but_onL_temp_G000,R30
; 0000 0A1B         			if(but_onL_temp<=2) but_onL_temp=2;
	LDS  R26,_but_onL_temp_G000
	CPI  R26,LOW(0x3)
	BRSH _0xCE
	LDI  R30,LOW(2)
	STS  _but_onL_temp_G000,R30
; 0000 0A1C 				}
_0xCE:
; 0000 0A1D    			}
_0xCD:
; 0000 0A1E   		}
_0xCC:
; 0000 0A1F  	}
_0xCB:
; 0000 0A20 but_drv_out:
_0xCA:
_0xC9:
; 0000 0A21 but_s=but_n;
	LDS  R30,_but_n_G000
	STS  _but_s_G000,R30
; 0000 0A22 but_port|=(but_mask^0xff);
	RCALL SUBOPT_0x10
; 0000 0A23 but_dir&=but_mask;
; 0000 0A24 }
	RET
; .FEND
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
; 0000 0A33 {
_but_an:
; .FSTART _but_an
; 0000 0A34 
; 0000 0A35 if(!(in_word&0x01))
	LDS  R30,_in_word
	ANDI R30,LOW(0x1)
	BRNE _0xCF
; 0000 0A36 	{
; 0000 0A37 	#ifdef TVIST_SKO
; 0000 0A38 	if((step==sOFF)&&(!bERR))
; 0000 0A39 		{
; 0000 0A3A 		step=s1;
; 0000 0A3B 		if(prog==p2) cnt_del=70;
; 0000 0A3C 		else if(prog==p3) cnt_del=100;
; 0000 0A3D 		}
; 0000 0A3E 	#endif
; 0000 0A3F 	#ifdef DV3KL2MD
; 0000 0A40 	if((step==sOFF)&&(!bERR))
; 0000 0A41 		{
; 0000 0A42 		step=s1;
; 0000 0A43 		cnt_del=70;
; 0000 0A44 		}
; 0000 0A45 	#endif
; 0000 0A46 	#ifndef TVIST_SKO
; 0000 0A47 	if((step==sOFF)&&(!bERR))
	TST  R10
	BRNE _0xD1
	SBRS R3,1
	RJMP _0xD2
_0xD1:
	RJMP _0xD0
_0xD2:
; 0000 0A48 		{
; 0000 0A49 		step=s1;
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 0A4A 		if(prog==p1) cnt_del=50;
	CP   R30,R11
	BREQ _0x117
; 0000 0A4B 		else if(prog==p2) cnt_del=50;
	LDI  R30,LOW(2)
	CP   R30,R11
	BREQ _0x117
; 0000 0A4C 		else if(prog==p3) cnt_del=50;
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0xD7
_0x117:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RCALL SUBOPT_0x9
; 0000 0A4D           #ifdef P380_MINI
; 0000 0A4E   		cnt_del=100;
; 0000 0A4F   		#endif
; 0000 0A50 		}
_0xD7:
; 0000 0A51 	#endif
; 0000 0A52 	}
_0xD0:
; 0000 0A53 if(!(in_word&0x02))
_0xCF:
	LDS  R30,_in_word
	ANDI R30,LOW(0x2)
	BRNE _0xD8
; 0000 0A54 	{
; 0000 0A55 	step=sOFF;
	CLR  R10
; 0000 0A56 
; 0000 0A57 	}
; 0000 0A58 
; 0000 0A59 if (!n_but) goto but_an_end;
_0xD8:
	SBRS R2,5
	RJMP _0xDA
; 0000 0A5A 
; 0000 0A5B if(but==butV_)
	LDI  R30,LOW(237)
	CP   R30,R8
	BRNE _0xDB
; 0000 0A5C 	{
; 0000 0A5D 	if(ee_vacuum_mode==evmON)ee_vacuum_mode=evmOFF;
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0xDC
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	LDI  R30,LOW(170)
	RJMP _0x118
; 0000 0A5E 	else ee_vacuum_mode=evmON;
_0xDC:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	LDI  R30,LOW(85)
_0x118:
	CALL __EEPROMWRB
; 0000 0A5F 	}
; 0000 0A60 
; 0000 0A61 if(but==butVP_)
_0xDB:
	LDI  R30,LOW(233)
	CP   R30,R8
	BRNE _0xDE
; 0000 0A62 	{
; 0000 0A63 	if(ind!=iVr)ind=iVr;
	LDI  R30,LOW(2)
	CP   R30,R13
	BREQ _0xDF
	MOV  R13,R30
; 0000 0A64 	else ind=iMn;
	RJMP _0xE0
_0xDF:
	CLR  R13
; 0000 0A65 	}
_0xE0:
; 0000 0A66 
; 0000 0A67 
; 0000 0A68 if(ind==iMn)
_0xDE:
	TST  R13
	BRNE _0xE1
; 0000 0A69 	{
; 0000 0A6A 	if(but==butP_)ind=iPr_sel;
	LDI  R30,LOW(249)
	CP   R30,R8
	BRNE _0xE2
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 0A6B 	if(but==butLR)
_0xE2:
	LDI  R30,LOW(126)
	CP   R30,R8
	BRNE _0xE3
; 0000 0A6C 		{
; 0000 0A6D 		if((prog==p3)||(prog==p4))
	LDI  R30,LOW(3)
	CP   R30,R11
	BREQ _0xE5
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0xE4
_0xE5:
; 0000 0A6E 			{
; 0000 0A6F 			if(sub_ind==0)sub_ind=1;
	TST  R12
	BRNE _0xE7
	LDI  R30,LOW(1)
	MOV  R12,R30
; 0000 0A70 			else sub_ind=0;
	RJMP _0xE8
_0xE7:
	CLR  R12
; 0000 0A71 			}
_0xE8:
; 0000 0A72     		else sub_ind=0;
	RJMP _0xE9
_0xE4:
	CLR  R12
; 0000 0A73 		}
_0xE9:
; 0000 0A74 	if((but==butR)||(but==butR_))
_0xE3:
	LDI  R30,LOW(127)
	CP   R30,R8
	BREQ _0xEB
	LDI  R30,LOW(125)
	CP   R30,R8
	BRNE _0xEA
_0xEB:
; 0000 0A75 		{
; 0000 0A76 		speed=1;
	SET
	BLD  R2,6
; 0000 0A77 		ee_delay[prog][sub_ind]++;
	RCALL SUBOPT_0xF
	ADIW R30,1
	RJMP _0x119
; 0000 0A78 		}
; 0000 0A79 
; 0000 0A7A 	else if((but==butL)||(but==butL_))
_0xEA:
	LDI  R30,LOW(254)
	CP   R30,R8
	BREQ _0xEF
	LDI  R30,LOW(252)
	CP   R30,R8
	BRNE _0xEE
_0xEF:
; 0000 0A7B 		{
; 0000 0A7C     		speed=1;
	SET
	BLD  R2,6
; 0000 0A7D     		ee_delay[prog][sub_ind]--;
	RCALL SUBOPT_0xF
	SBIW R30,1
_0x119:
	CALL __EEPROMWRW
; 0000 0A7E     		}
; 0000 0A7F 	}
_0xEE:
; 0000 0A80 
; 0000 0A81 else if(ind==iPr_sel)
	RJMP _0xF1
_0xE1:
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0xF2
; 0000 0A82 	{
; 0000 0A83 	if(but==butP_)ind=iMn;
	LDI  R30,LOW(249)
	CP   R30,R8
	BRNE _0xF3
	CLR  R13
; 0000 0A84 	if(but==butP)
_0xF3:
	LDI  R30,LOW(251)
	CP   R30,R8
	BRNE _0xF4
; 0000 0A85 		{
; 0000 0A86 		prog++;
	INC  R11
; 0000 0A87 		if(prog>MAXPROG)prog=MINPROG;
	LDI  R30,LOW(3)
	CP   R30,R11
	BRSH _0xF5
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 0A88 		ee_program[0]=prog;
_0xF5:
	MOV  R30,R11
	RCALL SUBOPT_0x0
; 0000 0A89 		ee_program[1]=prog;
	RCALL SUBOPT_0x11
; 0000 0A8A 		ee_program[2]=prog;
; 0000 0A8B 		}
; 0000 0A8C 
; 0000 0A8D 	if(but==butR)
_0xF4:
	LDI  R30,LOW(127)
	CP   R30,R8
	BRNE _0xF6
; 0000 0A8E 		{
; 0000 0A8F 		prog++;
	INC  R11
; 0000 0A90 		if(prog>MAXPROG)prog=MINPROG;
	LDI  R30,LOW(3)
	CP   R30,R11
	BRSH _0xF7
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 0A91 		ee_program[0]=prog;
_0xF7:
	MOV  R30,R11
	RCALL SUBOPT_0x0
; 0000 0A92 		ee_program[1]=prog;
	RCALL SUBOPT_0x11
; 0000 0A93 		ee_program[2]=prog;
; 0000 0A94 		}
; 0000 0A95 
; 0000 0A96 	if(but==butL)
_0xF6:
	LDI  R30,LOW(254)
	CP   R30,R8
	BRNE _0xF8
; 0000 0A97 		{
; 0000 0A98 		prog--;
	DEC  R11
; 0000 0A99 		if(prog>MAXPROG)prog=MINPROG;
	LDI  R30,LOW(3)
	CP   R30,R11
	BRSH _0xF9
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 0A9A 		ee_program[0]=prog;
_0xF9:
	MOV  R30,R11
	RCALL SUBOPT_0x0
; 0000 0A9B 		ee_program[1]=prog;
	RCALL SUBOPT_0x11
; 0000 0A9C 		ee_program[2]=prog;
; 0000 0A9D 		}
; 0000 0A9E 	}
_0xF8:
; 0000 0A9F 
; 0000 0AA0 else if(ind==iVr)
	RJMP _0xFA
_0xF2:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0xFB
; 0000 0AA1 	{
; 0000 0AA2 	if(but==butP_)
	LDI  R30,LOW(249)
	CP   R30,R8
	BRNE _0xFC
; 0000 0AA3 		{
; 0000 0AA4 		if(ee_vr_log)ee_vr_log=0;
	LDI  R26,LOW(_ee_vr_log)
	LDI  R27,HIGH(_ee_vr_log)
	CALL __EEPROMRDB
	CPI  R30,0
	BREQ _0xFD
	LDI  R26,LOW(_ee_vr_log)
	LDI  R27,HIGH(_ee_vr_log)
	LDI  R30,LOW(0)
	RJMP _0x11A
; 0000 0AA5 		else ee_vr_log=1;
_0xFD:
	LDI  R26,LOW(_ee_vr_log)
	LDI  R27,HIGH(_ee_vr_log)
	LDI  R30,LOW(1)
_0x11A:
	CALL __EEPROMWRB
; 0000 0AA6 		}
; 0000 0AA7 	}
_0xFC:
; 0000 0AA8 
; 0000 0AA9 but_an_end:
_0xFB:
_0xFA:
_0xF1:
_0xDA:
; 0000 0AAA n_but=0;
	CLT
	BLD  R2,5
; 0000 0AAB }
	RET
; .FEND
;
;//-----------------------------------------------
;void ind_drv(void)
; 0000 0AAF {
_ind_drv:
; .FSTART _ind_drv
; 0000 0AB0 if(++ind_cnt>=6)ind_cnt=0;
	INC  R9
	LDI  R30,LOW(6)
	CP   R9,R30
	BRLO _0xFF
	CLR  R9
; 0000 0AB1 
; 0000 0AB2 if(ind_cnt<5)
_0xFF:
	LDI  R30,LOW(5)
	CP   R9,R30
	BRSH _0x100
; 0000 0AB3 	{
; 0000 0AB4 	DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0AB5 	PORTC=0xFF;
	OUT  0x15,R30
; 0000 0AB6 	DDRD|=0b11111000;
	IN   R30,0x11
	ORI  R30,LOW(0xF8)
	OUT  0x11,R30
; 0000 0AB7 	PORTD|=0b11111000;
	IN   R30,0x12
	ORI  R30,LOW(0xF8)
	OUT  0x12,R30
; 0000 0AB8 	PORTD&=IND_STROB[ind_cnt];
	IN   R30,0x12
	MOV  R26,R30
	MOV  R30,R9
	LDI  R31,0
	SUBI R30,LOW(-_IND_STROB*2)
	SBCI R31,HIGH(-_IND_STROB*2)
	LPM  R30,Z
	AND  R30,R26
	OUT  0x12,R30
; 0000 0AB9 	PORTC=ind_out[ind_cnt];
	MOV  R30,R9
	LDI  R31,0
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	LD   R30,Z
	OUT  0x15,R30
; 0000 0ABA 	}
; 0000 0ABB else but_drv();
	RJMP _0x101
_0x100:
	RCALL _but_drv
; 0000 0ABC }
_0x101:
	RET
; .FEND
;
;//***********************************************
;//***********************************************
;//***********************************************
;//***********************************************
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0AC3 {
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
; 0000 0AC4 TCCR0=0x02;
	RCALL SUBOPT_0x12
; 0000 0AC5 TCNT0=-208;
; 0000 0AC6 OCR0=0x00;
; 0000 0AC7 
; 0000 0AC8 
; 0000 0AC9 b600Hz=1;
	SET
	BLD  R2,0
; 0000 0ACA ind_drv();
	RCALL _ind_drv
; 0000 0ACB if(++t0_cnt0>=6)
	INC  R5
	LDI  R30,LOW(6)
	CP   R5,R30
	BRLO _0x102
; 0000 0ACC 	{
; 0000 0ACD 	t0_cnt0=0;
	CLR  R5
; 0000 0ACE 	b100Hz=1;
	SET
	BLD  R2,1
; 0000 0ACF 	}
; 0000 0AD0 
; 0000 0AD1 if(++t0_cnt1>=60)
_0x102:
	INC  R4
	LDI  R30,LOW(60)
	CP   R4,R30
	BRLO _0x103
; 0000 0AD2 	{
; 0000 0AD3 	t0_cnt1=0;
	CLR  R4
; 0000 0AD4 	b10Hz=1;
	SET
	BLD  R2,2
; 0000 0AD5 
; 0000 0AD6 	if(++t0_cnt2>=2)
	INC  R7
	LDI  R30,LOW(2)
	CP   R7,R30
	BRLO _0x104
; 0000 0AD7 		{
; 0000 0AD8 		t0_cnt2=0;
	CLR  R7
; 0000 0AD9 		bFL5=!bFL5;
	LDI  R30,LOW(1)
	EOR  R3,R30
; 0000 0ADA 		}
; 0000 0ADB 
; 0000 0ADC 	if(++t0_cnt3>=5)
_0x104:
	INC  R6
	LDI  R30,LOW(5)
	CP   R6,R30
	BRLO _0x105
; 0000 0ADD 		{
; 0000 0ADE 		t0_cnt3=0;
	CLR  R6
; 0000 0ADF 		bFL2=!bFL2;
	LDI  R30,LOW(128)
	EOR  R2,R30
; 0000 0AE0 		}
; 0000 0AE1 	}
_0x105:
; 0000 0AE2 }
_0x103:
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
;//===============================================
;//===============================================
;//===============================================
;//===============================================
;
;void main(void)
; 0000 0AEA {
_main:
; .FSTART _main
; 0000 0AEB 
; 0000 0AEC PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 0AED DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0AEE 
; 0000 0AEF PORTB=0xff;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0AF0 DDRB=0xFF;
	OUT  0x17,R30
; 0000 0AF1 
; 0000 0AF2 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0AF3 DDRC=0x00;
	OUT  0x14,R30
; 0000 0AF4 
; 0000 0AF5 
; 0000 0AF6 PORTD=0x00;
	OUT  0x12,R30
; 0000 0AF7 DDRD=0x00;
	OUT  0x11,R30
; 0000 0AF8 
; 0000 0AF9 
; 0000 0AFA TCCR0=0x02;
	RCALL SUBOPT_0x12
; 0000 0AFB TCNT0=-208;
; 0000 0AFC OCR0=0x00;
; 0000 0AFD 
; 0000 0AFE TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0AFF TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0B00 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0B01 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0B02 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0B03 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0B04 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0B05 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0B06 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0B07 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0B08 
; 0000 0B09 
; 0000 0B0A ASSR=0x00;
	OUT  0x22,R30
; 0000 0B0B TCCR2=0x00;
	OUT  0x25,R30
; 0000 0B0C TCNT2=0x00;
	OUT  0x24,R30
; 0000 0B0D OCR2=0x00;
	OUT  0x23,R30
; 0000 0B0E 
; 0000 0B0F MCUCR=0x00;
	OUT  0x35,R30
; 0000 0B10 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0B11 
; 0000 0B12 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0B13 
; 0000 0B14 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0B15 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0B16 
; 0000 0B17 #asm("sei")
	sei
; 0000 0B18 PORTB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0B19 DDRB=0xFF;
	OUT  0x17,R30
; 0000 0B1A DDRD.1=1;
	SBI  0x11,1
; 0000 0B1B PORTD.1=1;
	SBI  0x12,1
; 0000 0B1C 
; 0000 0B1D ind=iMn;
	CLR  R13
; 0000 0B1E prog_drv();
	RCALL _prog_drv
; 0000 0B1F ind_hndl();
	RCALL _ind_hndl
; 0000 0B20 led_hndl();
	RCALL _led_hndl
; 0000 0B21 while (1)
_0x10A:
; 0000 0B22       {
; 0000 0B23       if(b600Hz)
	SBRS R2,0
	RJMP _0x10D
; 0000 0B24 		{
; 0000 0B25 		b600Hz=0;
	CLT
	BLD  R2,0
; 0000 0B26 
; 0000 0B27 		}
; 0000 0B28       if(b100Hz)
_0x10D:
	SBRS R2,1
	RJMP _0x10E
; 0000 0B29 		{
; 0000 0B2A 		b100Hz=0;
	CLT
	BLD  R2,1
; 0000 0B2B 		but_an();
	RCALL _but_an
; 0000 0B2C 	    	in_drv();
	RCALL _in_drv
; 0000 0B2D           mdvr_drv();
	RCALL _mdvr_drv
; 0000 0B2E           step_contr();
	RCALL _step_contr
; 0000 0B2F 		}
; 0000 0B30 	if(b10Hz)
_0x10E:
	SBRS R2,2
	RJMP _0x10F
; 0000 0B31 		{
; 0000 0B32 		b10Hz=0;
	CLT
	BLD  R2,2
; 0000 0B33 		prog_drv();
	RCALL _prog_drv
; 0000 0B34 		err_drv();
	RCALL _err_drv
; 0000 0B35 
; 0000 0B36     	     ind_hndl();
	RCALL _ind_hndl
; 0000 0B37           led_hndl();
	RCALL _led_hndl
; 0000 0B38 
; 0000 0B39           }
; 0000 0B3A 
; 0000 0B3B       };
_0x10F:
	RJMP _0x10A
; 0000 0B3C }
_0x110:
	RJMP _0x110
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
_ee_vacuum_mode:
	.BYTE 0x1
_ee_program:
	.BYTE 0x2

	.DSEG
_in_word:
	.BYTE 0x1
_in_word_old:
	.BYTE 0x1
_in_word_new:
	.BYTE 0x1
_in_word_cnt:
	.BYTE 0x1
_cnt_del:
	.BYTE 0x2
_bVR:
	.BYTE 0x1
_bMD1:
	.BYTE 0x1
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

	.ESEG
_ee_delay:
	.BYTE 0x10
_ee_vr_log:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(_ee_program)
	LDI  R27,HIGH(_ee_program)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x1:
	ORI  R17,LOW(192)
	LDI  R26,LOW(_cnt_del)
	LDI  R27,HIGH(_cnt_del)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDS  R30,_cnt_del
	LDS  R31,_cnt_del+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0xAA)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ORI  R17,LOW(224)
	LDS  R30,_bVR
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x5:
	ORI  R17,LOW(100)
	LDI  R26,LOW(_cnt_del)
	LDI  R27,HIGH(_cnt_del)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDS  R30,_cnt_del
	LDS  R31,_cnt_del+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x7:
	ORI  R17,LOW(116)
	LDI  R26,LOW(_cnt_del)
	LDI  R27,HIGH(_cnt_del)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDS  R30,_cnt_del
	LDS  R31,_cnt_del+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x8:
	ORI  R17,LOW(108)
	LDI  R26,LOW(_cnt_del)
	LDI  R27,HIGH(_cnt_del)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDS  R30,_cnt_del
	LDS  R31,_cnt_del+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xA:
	ORI  R17,LOW(96)
	LDI  R26,LOW(_cnt_del)
	LDI  R27,HIGH(_cnt_del)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDS  R30,_cnt_del
	LDS  R31,_cnt_del+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	MOV  R10,R30
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xC:
	ORI  R17,LOW(128)
	LDI  R26,LOW(_cnt_del)
	LDI  R27,HIGH(_cnt_del)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDS  R30,_cnt_del
	LDS  R31,_cnt_del+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(_cnt_del)
	LDI  R27,HIGH(_cnt_del)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	LDS  R30,_cnt_del
	LDS  R31,_cnt_del+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	MOV  R30,R17
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_ind_out)
	SBCI R31,HIGH(-_ind_out)
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xF:
	MOV  R30,R11
	LDI  R26,LOW(_ee_delay)
	LDI  R27,HIGH(_ee_delay)
	LDI  R31,0
	CALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R12
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	IN   R30,0x15
	ORI  R30,LOW(0x95)
	OUT  0x15,R30
	IN   R30,0x14
	ANDI R30,LOW(0x6A)
	OUT  0x14,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x11:
	__POINTW2MN _ee_program,1
	MOV  R30,R11
	CALL __EEPROMWRB
	__POINTW2MN _ee_program,2
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(2)
	OUT  0x33,R30
	LDI  R30,LOW(48)
	OUT  0x32,R30
	LDI  R30,LOW(0)
	OUT  0x3C,R30
	RET


	.CSEG
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
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
