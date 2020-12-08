
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
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

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
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
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
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
	.DEF _t0_cnt0_=R7
	.DEF _t0_cnt0=R6
	.DEF _t0_cnt1=R9
	.DEF _t0_cnt2=R8
	.DEF _t0_cnt3=R11
	.DEF _t0_cnt4=R10
	.DEF _ind_cnt=R13
	.DEF _but=R12

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
	JMP  _timer1_compa_isr
	JMP  0x00
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

__GLOBAL_INI_TBL:
	.DW  0x03
	.DW  0x02
	.DW  __REG_BIT_VARS*2

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
	.ORG 0x260

	.CSEG
;#define NUM_OF_SLAVE	3
;
;#define HOST_MESS_LEN	5
;
;
;
;#define MD1	3
;#define MD2	7
;#define VR1	2
;#define VR2	6
;
;#define PP1_1	6
;#define PP1_2	7
;#define PP1_3	5
;#define PP1_4	4
;#define PP2_1	3
;#define PP2_2	2
;#define PP2_3	1
;#define PP2_4	0
;
;
;bit b600Hz;
;bit b100Hz;
;bit b10Hz;
;bit b1Hz;
;char t0_cnt0_,t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3,t0_cnt4;
;char ind_cnt;
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
;eeprom enum{eamON=0x55,eamOFF=0xaa}ee_avtom_mode;
;enum {p1=1,p2=2,p3=3,p4=4}prog;
;//enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s100}step=sOFF;
;
;char sub_ind;
;char in_word,in_word_old,in_word_new,in_word_cnt;
;bit bERR;
;signed int cnt_del=0;
;
;char cnt_md1,cnt_md2,cnt_vr1,cnt_vr2;
;
;eeprom enum {coOFF=0x55,coON=0xaa}ch_on[6];
;eeprom unsigned ee_timer1_delay;
;bit opto_angle_old;
;enum {msON=0x55,msOFF=0xAA}motor_state;
;unsigned timer1_delay;
;
;char stop_cnt,start_cnt;
;char cnt_net_drv,cnt_drv;
;char cmnd_byte,state_byte,crc_byte;
;
;enum{sOFF,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16}step1=sOFF,step2=sOFF;
;enum {mON,mOFF,mTST}mode1,mode2;
;signed char cnt_del1,cnt_del2;
;
;bit bVR1,bVR2;
;bit bMD1,bMD2;
;char out_stat,out_stat1,out_stat2;
;char cmnd_new,cmnd_old,cmnd,cmnd_cnt;
;char state_new,state_old,state,state_cnt;
;char tst_new,tst_old,tst,tst_cnt;
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#include "usart_slave.c"
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
;
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
; 0000 004D {

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
;   if (++rx_wr_index >= HOST_MESS_LEN)
	LDS  R26,_rx_wr_index
	SUBI R26,-LOW(1)
	STS  _rx_wr_index,R26
	CPI  R26,LOW(0x5)
	BRLO _0x6
;   	{
;   	if((((rx_buffer[0]^rx_buffer[1])^(rx_buffer[2]^rx_buffer[3]^rx_buffer[4]))&0b01111111)==0)
	__GETB1MN _rx_buffer,1
	LDS  R26,_rx_buffer
	EOR  R30,R26
	MOV  R0,R30
	__GETB2MN _rx_buffer,2
	__GETB1MN _rx_buffer,3
	EOR  R26,R30
	__GETB1MN _rx_buffer,4
	EOR  R30,R26
	MOV  R26,R0
	EOR  R26,R30
	ANDI R26,LOW(0x7F)
	BRNE _0x7
;   		{
;   		uart_in_an();
	CALL _uart_in_an
;   		}
;     }
_0x7:
;   if (rx_wr_index >= RX_BUFFER_SIZE) rx_wr_index=0;
_0x6:
	LDS  R26,_rx_wr_index
	CPI  R26,LOW(0x32)
	BRLO _0x8
	LDI  R30,LOW(0)
	STS  _rx_wr_index,R30
;   };
_0x8:
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
	BREQ _0xD
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
	BRNE _0xE
	LDI  R30,LOW(0)
	STS  _tx_rd_index,R30
;   };
_0xE:
_0xD:
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
_0xF:
	LDS  R26,_tx_counter
	CPI  R26,LOW(0x64)
	BREQ _0xF
;#asm("cli")
	cli
;if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter
	CPI  R30,0
	BRNE _0x13
	SBIC 0xB,5
	RJMP _0x12
_0x13:
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
	BRNE _0x15
	LDI  R30,LOW(0)
	STS  _tx_wr_index,R30
;   ++tx_counter;
_0x15:
	LDS  R30,_tx_counter
	SUBI R30,-LOW(1)
	STS  _tx_counter,R30
;   }
;else UDR=c;
	RJMP _0x16
_0x12:
	LD   R30,Y
	OUT  0xC,R30
;#asm("sei")
_0x16:
	sei
;}
	ADIW R28,1
	RET
; .FEND
;#pragma used-
;#endif
;
;
;//-----------------------------------------------
;void out_drv(void)
; 0000 0052 {
_out_drv:
; .FSTART _out_drv
; 0000 0053 DDRB=0xff;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0054 out_stat=out_stat1|out_stat2;
	LDS  R30,_out_stat2
	LDS  R26,_out_stat1
	OR   R30,R26
	STS  _out_stat,R30
; 0000 0055 PORTB=~out_stat;
	COM  R30
	OUT  0x18,R30
; 0000 0056 //PORTB=~step2;
; 0000 0057 }
	RET
; .FEND
;
;
;
;//-----------------------------------------------
;void out_usart (char num,char data0,char data1,char data2,char data3,char data4,char data5,char data6,char data7,char da ...
; 0000 005D {
_out_usart:
; .FSTART _out_usart
; 0000 005E char i,t=0;
; 0000 005F 
; 0000 0060 char UOB[12];
; 0000 0061 UOB[0]=data0;
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
; 0000 0062 UOB[1]=data1;
	LDD  R30,Y+21
	STD  Y+3,R30
; 0000 0063 UOB[2]=data2;
	LDD  R30,Y+20
	STD  Y+4,R30
; 0000 0064 UOB[3]=data3;
	LDD  R30,Y+19
	STD  Y+5,R30
; 0000 0065 UOB[4]=data4;
	LDD  R30,Y+18
	STD  Y+6,R30
; 0000 0066 UOB[5]=data5;
	LDD  R30,Y+17
	STD  Y+7,R30
; 0000 0067 UOB[6]=data6;
	LDD  R30,Y+16
	STD  Y+8,R30
; 0000 0068 UOB[7]=data7;
	LDD  R30,Y+15
	STD  Y+9,R30
; 0000 0069 UOB[8]=data8;
	LDD  R30,Y+14
	STD  Y+10,R30
; 0000 006A 
; 0000 006B for (i=0;i<num;i++)
	LDI  R17,LOW(0)
_0x18:
	LDD  R30,Y+23
	CP   R17,R30
	BRSH _0x19
; 0000 006C 	{
; 0000 006D 	putchar(UOB[i]);
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _putchar
; 0000 006E 	}
	SUBI R17,-1
	RJMP _0x18
_0x19:
; 0000 006F }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,24
	RET
; .FEND
;
;//-----------------------------------------------
;void byte_drv(void)
; 0000 0073 {
; 0000 0074 cmnd_byte|=0x80;
; 0000 0075 state_byte=0xff;
; 0000 0076 
; 0000 0077 if(ch_on[0]!=coON)state_byte&=~(1<<0);
; 0000 0078 if(ch_on[1]!=coON)state_byte&=~(1<<1);
; 0000 0079 if(ch_on[2]!=coON)state_byte&=~(1<<2);
; 0000 007A if(ch_on[3]!=coON)state_byte&=~(1<<3);
; 0000 007B if(ch_on[4]!=coON)state_byte&=~(1<<4);
; 0000 007C if(ch_on[5]!=coON)state_byte&=~(1<<5);
; 0000 007D 
; 0000 007E 
; 0000 007F }
;
;
;//-----------------------------------------------
;void in_drv(void)
; 0000 0084 {
_in_drv:
; .FSTART _in_drv
; 0000 0085 char i,temp;
; 0000 0086 unsigned int tempUI;
; 0000 0087 DDRA&=0x33;
	CALL __SAVELOCR4
;	i -> R17
;	temp -> R16
;	tempUI -> R18,R19
	IN   R30,0x1A
	ANDI R30,LOW(0x33)
	OUT  0x1A,R30
; 0000 0088 PORTA|=0xcc;
	IN   R30,0x1B
	ORI  R30,LOW(0xCC)
	OUT  0x1B,R30
; 0000 0089 in_word_new=PINA|0x33;
	IN   R30,0x19
	ORI  R30,LOW(0x33)
	STS  _in_word_new,R30
; 0000 008A if(in_word_old==in_word_new)
	LDS  R26,_in_word_old
	CP   R30,R26
	BRNE _0x20
; 0000 008B 	{
; 0000 008C 	if(in_word_cnt<10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRSH _0x21
; 0000 008D 		{
; 0000 008E 		in_word_cnt++;
	LDS  R30,_in_word_cnt
	SUBI R30,-LOW(1)
	STS  _in_word_cnt,R30
; 0000 008F 		if(in_word_cnt>=10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRLO _0x22
; 0000 0090 			{
; 0000 0091 			in_word=in_word_old;
	LDS  R30,_in_word_old
	STS  _in_word,R30
; 0000 0092 			}
; 0000 0093 		}
_0x22:
; 0000 0094 	}
_0x21:
; 0000 0095 else in_word_cnt=0;
	RJMP _0x23
_0x20:
	LDI  R30,LOW(0)
	STS  _in_word_cnt,R30
; 0000 0096 
; 0000 0097 
; 0000 0098 in_word_old=in_word_new;
_0x23:
	LDS  R30,_in_word_new
	STS  _in_word_old,R30
; 0000 0099 }
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;
;
;
;//-----------------------------------------------
;void mdvr_drv(void)
; 0000 009F {
_mdvr_drv:
; .FSTART _mdvr_drv
; 0000 00A0 if(!(in_word&(1<<MD1)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x8)
	BRNE _0x24
; 0000 00A1 	{
; 0000 00A2 	if(cnt_md1<10)
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRSH _0x25
; 0000 00A3 		{
; 0000 00A4 		cnt_md1++;
	LDS  R30,_cnt_md1
	SUBI R30,-LOW(1)
	STS  _cnt_md1,R30
; 0000 00A5 		if(cnt_md1==10) bMD1=1;
	LDS  R26,_cnt_md1
	CPI  R26,LOW(0xA)
	BRNE _0x26
	SET
	BLD  R3,6
; 0000 00A6 		}
_0x26:
; 0000 00A7 
; 0000 00A8 	}
_0x25:
; 0000 00A9 else
	RJMP _0x27
_0x24:
; 0000 00AA 	{
; 0000 00AB 	if(cnt_md1)
	LDS  R30,_cnt_md1
	CPI  R30,0
	BREQ _0x28
; 0000 00AC 		{
; 0000 00AD 		cnt_md1--;
	SUBI R30,LOW(1)
	STS  _cnt_md1,R30
; 0000 00AE 		if(cnt_md1==0) bMD1=0;
	CPI  R30,0
	BRNE _0x29
	CLT
	BLD  R3,6
; 0000 00AF 		}
_0x29:
; 0000 00B0 
; 0000 00B1 	}
_0x28:
_0x27:
; 0000 00B2 
; 0000 00B3 if(!(in_word&(1<<MD2)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x80)
	BRNE _0x2A
; 0000 00B4 	{
; 0000 00B5 	if(cnt_md2<10)
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRSH _0x2B
; 0000 00B6 		{
; 0000 00B7 		cnt_md2++;
	LDS  R30,_cnt_md2
	SUBI R30,-LOW(1)
	STS  _cnt_md2,R30
; 0000 00B8 		if(cnt_md2==10) bMD2=1;
	LDS  R26,_cnt_md2
	CPI  R26,LOW(0xA)
	BRNE _0x2C
	SET
	BLD  R3,7
; 0000 00B9 		}
_0x2C:
; 0000 00BA 
; 0000 00BB 	}
_0x2B:
; 0000 00BC else
	RJMP _0x2D
_0x2A:
; 0000 00BD 	{
; 0000 00BE 	if(cnt_md2)
	LDS  R30,_cnt_md2
	CPI  R30,0
	BREQ _0x2E
; 0000 00BF 		{
; 0000 00C0 		cnt_md2--;
	SUBI R30,LOW(1)
	STS  _cnt_md2,R30
; 0000 00C1 		if(cnt_md2==0) bMD2=0;
	CPI  R30,0
	BRNE _0x2F
	CLT
	BLD  R3,7
; 0000 00C2 		}
_0x2F:
; 0000 00C3 
; 0000 00C4 	}
_0x2E:
_0x2D:
; 0000 00C5 
; 0000 00C6 if(!(in_word&(1<<VR1)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x4)
	BRNE _0x30
; 0000 00C7 	{
; 0000 00C8 	if(cnt_vr1<10)
	LDS  R26,_cnt_vr1
	CPI  R26,LOW(0xA)
	BRSH _0x31
; 0000 00C9 		{
; 0000 00CA 		cnt_vr1++;
	LDS  R30,_cnt_vr1
	SUBI R30,-LOW(1)
	STS  _cnt_vr1,R30
; 0000 00CB 		if(cnt_vr1==10) bVR1=1;
	LDS  R26,_cnt_vr1
	CPI  R26,LOW(0xA)
	BRNE _0x32
	SET
	BLD  R3,4
; 0000 00CC 		}
_0x32:
; 0000 00CD 
; 0000 00CE 	}
_0x31:
; 0000 00CF else
	RJMP _0x33
_0x30:
; 0000 00D0 	{
; 0000 00D1 	if(cnt_vr1)
	LDS  R30,_cnt_vr1
	CPI  R30,0
	BREQ _0x34
; 0000 00D2 		{
; 0000 00D3 		cnt_vr1--;
	SUBI R30,LOW(1)
	STS  _cnt_vr1,R30
; 0000 00D4 		if(cnt_vr1==0) bVR1=0;
	CPI  R30,0
	BRNE _0x35
	CLT
	BLD  R3,4
; 0000 00D5 		}
_0x35:
; 0000 00D6 
; 0000 00D7 	}
_0x34:
_0x33:
; 0000 00D8 
; 0000 00D9 if(!(in_word&(1<<VR2)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x40)
	BRNE _0x36
; 0000 00DA 	{
; 0000 00DB 	if(cnt_vr2<10)
	LDS  R26,_cnt_vr2
	CPI  R26,LOW(0xA)
	BRSH _0x37
; 0000 00DC 		{
; 0000 00DD 		cnt_vr2++;
	LDS  R30,_cnt_vr2
	SUBI R30,-LOW(1)
	STS  _cnt_vr2,R30
; 0000 00DE 		if(cnt_vr2==10) bVR2=1;
	LDS  R26,_cnt_vr2
	CPI  R26,LOW(0xA)
	BRNE _0x38
	SET
	BLD  R3,5
; 0000 00DF 		}
_0x38:
; 0000 00E0 
; 0000 00E1 	}
_0x37:
; 0000 00E2 else
	RJMP _0x39
_0x36:
; 0000 00E3 	{
; 0000 00E4 	if(cnt_vr2)
	LDS  R30,_cnt_vr2
	CPI  R30,0
	BREQ _0x3A
; 0000 00E5 		{
; 0000 00E6 		cnt_vr2--;
	SUBI R30,LOW(1)
	STS  _cnt_vr2,R30
; 0000 00E7 		if(cnt_vr2==0) bVR2=0;
	CPI  R30,0
	BRNE _0x3B
	CLT
	BLD  R3,5
; 0000 00E8 		}
_0x3B:
; 0000 00E9 
; 0000 00EA 	}
_0x3A:
_0x39:
; 0000 00EB }
	RET
; .FEND
;
;//-----------------------------------------------
;void step1_contr(void)
; 0000 00EF {
_step1_contr:
; .FSTART _step1_contr
; 0000 00F0 
; 0000 00F1 out_stat1=0;
	LDI  R30,LOW(0)
	STS  _out_stat1,R30
; 0000 00F2 if(mode1==mOFF)step1=sOFF;
	LDS  R26,_mode1
	CPI  R26,LOW(0x1)
	BRNE _0x3C
	STS  _step1,R30
; 0000 00F3 
; 0000 00F4 if(step1==sOFF)
_0x3C:
	LDS  R30,_step1
	CPI  R30,0
	BRNE _0x3D
; 0000 00F5 	{
; 0000 00F6 
; 0000 00F7 	}
; 0000 00F8 else if(step1==s1)
	RJMP _0x3E
_0x3D:
	LDS  R26,_step1
	CPI  R26,LOW(0x1)
	BRNE _0x3F
; 0000 00F9 	{
; 0000 00FA 	cnt_del1=20;
	LDI  R30,LOW(20)
	STS  _cnt_del1,R30
; 0000 00FB 	step1=s2;
	LDI  R30,LOW(2)
	RJMP _0xEE
; 0000 00FC 	}
; 0000 00FD else if(step1==s2)
_0x3F:
	LDS  R26,_step1
	CPI  R26,LOW(0x2)
	BRNE _0x41
; 0000 00FE 	{
; 0000 00FF 	cnt_del1--;
	CALL SUBOPT_0x0
; 0000 0100 	if(cnt_del1==0)
	BRNE _0x42
; 0000 0101 		{
; 0000 0102 		cnt_del1=20;
	LDI  R30,LOW(20)
	STS  _cnt_del1,R30
; 0000 0103 		step1=s3;
	LDI  R30,LOW(3)
	STS  _step1,R30
; 0000 0104 		}
; 0000 0105 	}
_0x42:
; 0000 0106 else if(step1==s3)
	RJMP _0x43
_0x41:
	LDS  R26,_step1
	CPI  R26,LOW(0x3)
	BRNE _0x44
; 0000 0107 	{
; 0000 0108 	out_stat1|=(1<<PP1_1);
	LDS  R30,_out_stat1
	ORI  R30,0x40
	CALL SUBOPT_0x1
; 0000 0109 	cnt_del1--;
; 0000 010A 	if(cnt_del1==0)
	BRNE _0x45
; 0000 010B 		{
; 0000 010C 		step1=s4;
	LDI  R30,LOW(4)
	STS  _step1,R30
; 0000 010D 		}
; 0000 010E 
; 0000 010F 	}
_0x45:
; 0000 0110 else if(step1==s4)
	RJMP _0x46
_0x44:
	LDS  R26,_step1
	CPI  R26,LOW(0x4)
	BRNE _0x47
; 0000 0111 	{
; 0000 0112 	out_stat1|=(1<<PP1_1)|(1<<PP1_2);
	LDS  R30,_out_stat1
	ORI  R30,LOW(0xC0)
	STS  _out_stat1,R30
; 0000 0113 	if(bVR1)
	SBRS R3,4
	RJMP _0x48
; 0000 0114 		{
; 0000 0115 		step1=s5;
	LDI  R30,LOW(5)
	STS  _step1,R30
; 0000 0116 		cnt_del1=50;
	LDI  R30,LOW(50)
	STS  _cnt_del1,R30
; 0000 0117 		}
; 0000 0118 	}
_0x48:
; 0000 0119 else if(step1==s5)
	RJMP _0x49
_0x47:
	LDS  R26,_step1
	CPI  R26,LOW(0x5)
	BRNE _0x4A
; 0000 011A 	{
; 0000 011B 	out_stat1|=(1<<PP1_1)|(1<<PP1_2)|(1<<PP1_3);
	LDS  R30,_out_stat1
	ORI  R30,LOW(0xE0)
	CALL SUBOPT_0x1
; 0000 011C 	cnt_del1--;
; 0000 011D 	if(cnt_del1==0)
	BRNE _0x4B
; 0000 011E 		{
; 0000 011F 		cnt_del1=80;
	LDI  R30,LOW(80)
	STS  _cnt_del1,R30
; 0000 0120 		step1=s6;
	LDI  R30,LOW(6)
	STS  _step1,R30
; 0000 0121 		}
; 0000 0122 	}
_0x4B:
; 0000 0123 else if(step1==s6)
	RJMP _0x4C
_0x4A:
	LDS  R26,_step1
	CPI  R26,LOW(0x6)
	BRNE _0x4D
; 0000 0124 	{
; 0000 0125 	out_stat1|=(1<<PP1_1)|(1<<PP1_2)|(1<<PP1_3)|(1<<PP1_4);
	LDS  R30,_out_stat1
	ORI  R30,LOW(0xF0)
	CALL SUBOPT_0x1
; 0000 0126 	cnt_del1--;
; 0000 0127 	if(cnt_del1==0)
	BRNE _0x4E
; 0000 0128 		{
; 0000 0129 		cnt_del1=60;
	LDI  R30,LOW(60)
	STS  _cnt_del1,R30
; 0000 012A 		step1=s7;
	LDI  R30,LOW(7)
	STS  _step1,R30
; 0000 012B 		}
; 0000 012C 	}
_0x4E:
; 0000 012D else if(step1==s7)
	RJMP _0x4F
_0x4D:
	LDS  R26,_step1
	CPI  R26,LOW(0x7)
	BRNE _0x50
; 0000 012E 	{
; 0000 012F 	out_stat1|=(1<<PP1_1)|(1<<PP1_4);
	LDS  R30,_out_stat1
	ORI  R30,LOW(0x50)
	CALL SUBOPT_0x1
; 0000 0130 	cnt_del1--;
; 0000 0131 	if(cnt_del1==0)
	BRNE _0x51
; 0000 0132 		{
; 0000 0133 		cnt_del1=20;
	LDI  R30,LOW(20)
	STS  _cnt_del1,R30
; 0000 0134 		step1=s8;
	LDI  R30,LOW(8)
	STS  _step1,R30
; 0000 0135 		}
; 0000 0136 	}
_0x51:
; 0000 0137 else if(step1==s8)
	RJMP _0x52
_0x50:
	LDS  R26,_step1
	CPI  R26,LOW(0x8)
	BRNE _0x53
; 0000 0138 	{
; 0000 0139 	out_stat1|=(1<<PP1_4);
	LDS  R30,_out_stat1
	ORI  R30,0x10
	CALL SUBOPT_0x1
; 0000 013A 	cnt_del1--;
; 0000 013B 	if(cnt_del1==0)
	BRNE _0x54
; 0000 013C 		{
; 0000 013D 		step1=s9;
	LDI  R30,LOW(9)
	STS  _step1,R30
; 0000 013E 		}
; 0000 013F 	}
_0x54:
; 0000 0140 else if(step1==s9)
	RJMP _0x55
_0x53:
	LDS  R26,_step1
	CPI  R26,LOW(0x9)
	BRNE _0x56
; 0000 0141 	{
; 0000 0142 	if(bMD1)
	SBRS R3,6
	RJMP _0x57
; 0000 0143 		{
; 0000 0144 		step1=sOFF;
	LDI  R30,LOW(0)
_0xEE:
	STS  _step1,R30
; 0000 0145 		}
; 0000 0146 	}
_0x57:
; 0000 0147 
; 0000 0148 if(mode1==mTST)
_0x56:
_0x55:
_0x52:
_0x4F:
_0x4C:
_0x49:
_0x46:
_0x43:
_0x3E:
	LDS  R26,_mode1
	CPI  R26,LOW(0x2)
	BRNE _0x58
; 0000 0149     {
; 0000 014A     out_stat1=0;
	LDI  R30,LOW(0)
	STS  _out_stat1,R30
; 0000 014B     if(tst_cnt==1)out_stat1|=(1<<PP1_1);
	LDS  R26,_tst_cnt
	CPI  R26,LOW(0x1)
	BRNE _0x59
	ORI  R30,0x40
	RJMP _0xEF
; 0000 014C     else if(tst_cnt==2)out_stat1|=(1<<PP1_2);
_0x59:
	LDS  R26,_tst_cnt
	CPI  R26,LOW(0x2)
	BRNE _0x5B
	LDS  R30,_out_stat1
	ORI  R30,0x80
	RJMP _0xEF
; 0000 014D     else if(tst_cnt==3)out_stat1|=(1<<PP1_3);
_0x5B:
	LDS  R26,_tst_cnt
	CPI  R26,LOW(0x3)
	BRNE _0x5D
	LDS  R30,_out_stat1
	ORI  R30,0x20
	RJMP _0xEF
; 0000 014E     else if(tst_cnt==4)out_stat1|=(1<<PP1_4);
_0x5D:
	LDS  R26,_tst_cnt
	CPI  R26,LOW(0x4)
	BRNE _0x5F
	LDS  R30,_out_stat1
	ORI  R30,0x10
_0xEF:
	STS  _out_stat1,R30
; 0000 014F     }
_0x5F:
; 0000 0150 }
_0x58:
	RET
; .FEND
;
;//-----------------------------------------------
;void step2_contr(void)
; 0000 0154 {
_step2_contr:
; .FSTART _step2_contr
; 0000 0155 out_stat2=0;
	LDI  R30,LOW(0)
	STS  _out_stat2,R30
; 0000 0156 if(mode2==mOFF)step2=sOFF;
	LDS  R26,_mode2
	CPI  R26,LOW(0x1)
	BRNE _0x60
	STS  _step2,R30
; 0000 0157 
; 0000 0158 if(step2==sOFF)
_0x60:
	LDS  R30,_step2
	CPI  R30,0
	BRNE _0x61
; 0000 0159 	{
; 0000 015A 
; 0000 015B 	}
; 0000 015C else if(step2==s1)
	RJMP _0x62
_0x61:
	LDS  R26,_step2
	CPI  R26,LOW(0x1)
	BRNE _0x63
; 0000 015D 	{
; 0000 015E 	cnt_del2=20;
	LDI  R30,LOW(20)
	STS  _cnt_del2,R30
; 0000 015F 	step2=s2;
	LDI  R30,LOW(2)
	RJMP _0xF0
; 0000 0160 	}
; 0000 0161 else if(step2==s2)
_0x63:
	LDS  R26,_step2
	CPI  R26,LOW(0x2)
	BRNE _0x65
; 0000 0162 	{
; 0000 0163 	cnt_del2--;
	CALL SUBOPT_0x2
; 0000 0164 	if(cnt_del2==0)
	BRNE _0x66
; 0000 0165 		{
; 0000 0166 		cnt_del2=20;
	LDI  R30,LOW(20)
	STS  _cnt_del2,R30
; 0000 0167 		step2=s3;
	LDI  R30,LOW(3)
	STS  _step2,R30
; 0000 0168 		}
; 0000 0169 	}
_0x66:
; 0000 016A else if(step2==s3)
	RJMP _0x67
_0x65:
	LDS  R26,_step2
	CPI  R26,LOW(0x3)
	BRNE _0x68
; 0000 016B 	{
; 0000 016C 	out_stat2|=(1<<PP2_1);
	LDS  R30,_out_stat2
	ORI  R30,8
	CALL SUBOPT_0x3
; 0000 016D 	cnt_del2--;
; 0000 016E 	if(cnt_del2==0)
	BRNE _0x69
; 0000 016F 		{
; 0000 0170 		step2=s4;
	LDI  R30,LOW(4)
	STS  _step2,R30
; 0000 0171 		}
; 0000 0172 
; 0000 0173 	}
_0x69:
; 0000 0174 else if(step2==s4)
	RJMP _0x6A
_0x68:
	LDS  R26,_step2
	CPI  R26,LOW(0x4)
	BRNE _0x6B
; 0000 0175 	{
; 0000 0176 	out_stat2|=(1<<PP2_1)|(1<<PP2_2);
	LDS  R30,_out_stat2
	ORI  R30,LOW(0xC)
	STS  _out_stat2,R30
; 0000 0177 	if(bVR2)
	SBRS R3,5
	RJMP _0x6C
; 0000 0178 		{
; 0000 0179 		step2=s5;
	LDI  R30,LOW(5)
	STS  _step2,R30
; 0000 017A 		cnt_del2=50;
	LDI  R30,LOW(50)
	STS  _cnt_del2,R30
; 0000 017B 		}
; 0000 017C 	}
_0x6C:
; 0000 017D else if(step2==s5)
	RJMP _0x6D
_0x6B:
	LDS  R26,_step2
	CPI  R26,LOW(0x5)
	BRNE _0x6E
; 0000 017E 	{
; 0000 017F 	out_stat2|=(1<<PP2_1)|(1<<PP2_2)|(1<<PP2_3);
	LDS  R30,_out_stat2
	ORI  R30,LOW(0xE)
	CALL SUBOPT_0x3
; 0000 0180 	cnt_del2--;
; 0000 0181 	if(cnt_del2==0)
	BRNE _0x6F
; 0000 0182 		{
; 0000 0183 		cnt_del2=80;
	LDI  R30,LOW(80)
	STS  _cnt_del2,R30
; 0000 0184 		step2=s6;
	LDI  R30,LOW(6)
	STS  _step2,R30
; 0000 0185 		}
; 0000 0186 	}
_0x6F:
; 0000 0187 else if(step2==s6)
	RJMP _0x70
_0x6E:
	LDS  R26,_step2
	CPI  R26,LOW(0x6)
	BRNE _0x71
; 0000 0188 	{
; 0000 0189 	out_stat2|=(1<<PP2_1)|(1<<PP2_2)|(1<<PP2_3)|(1<<PP2_4);
	LDS  R30,_out_stat2
	ORI  R30,LOW(0xF)
	CALL SUBOPT_0x3
; 0000 018A 	cnt_del2--;
; 0000 018B 	if(cnt_del2==0)
	BRNE _0x72
; 0000 018C 		{
; 0000 018D 		cnt_del2=60;
	LDI  R30,LOW(60)
	STS  _cnt_del2,R30
; 0000 018E 		step2=s7;
	LDI  R30,LOW(7)
	STS  _step2,R30
; 0000 018F 		}
; 0000 0190 	}
_0x72:
; 0000 0191 else if(step2==s7)
	RJMP _0x73
_0x71:
	LDS  R26,_step2
	CPI  R26,LOW(0x7)
	BRNE _0x74
; 0000 0192 	{
; 0000 0193 	out_stat2|=(1<<PP2_1)|(1<<PP2_4);
	LDS  R30,_out_stat2
	ORI  R30,LOW(0x9)
	CALL SUBOPT_0x3
; 0000 0194 	cnt_del2--;
; 0000 0195 	if(cnt_del2==0)
	BRNE _0x75
; 0000 0196 		{
; 0000 0197 		cnt_del2=20;
	LDI  R30,LOW(20)
	STS  _cnt_del2,R30
; 0000 0198 		step2=s8;
	LDI  R30,LOW(8)
	STS  _step2,R30
; 0000 0199 		}
; 0000 019A 	}
_0x75:
; 0000 019B else if(step2==s8)
	RJMP _0x76
_0x74:
	LDS  R26,_step2
	CPI  R26,LOW(0x8)
	BRNE _0x77
; 0000 019C 	{
; 0000 019D 	out_stat2|=(1<<PP2_4);
	LDS  R30,_out_stat2
	ORI  R30,1
	CALL SUBOPT_0x3
; 0000 019E 	cnt_del2--;
; 0000 019F 	if(cnt_del2==0)
	BRNE _0x78
; 0000 01A0 		{
; 0000 01A1 		step2=s9;
	LDI  R30,LOW(9)
	STS  _step2,R30
; 0000 01A2 		}
; 0000 01A3 	}
_0x78:
; 0000 01A4 else if(step2==s9)
	RJMP _0x79
_0x77:
	LDS  R26,_step2
	CPI  R26,LOW(0x9)
	BRNE _0x7A
; 0000 01A5 	{
; 0000 01A6 	if(bMD2)
	SBRS R3,7
	RJMP _0x7B
; 0000 01A7 		{
; 0000 01A8 		step2=sOFF;
	LDI  R30,LOW(0)
_0xF0:
	STS  _step2,R30
; 0000 01A9 		}
; 0000 01AA 	}
_0x7B:
; 0000 01AB 
; 0000 01AC if(mode2==mTST)
_0x7A:
_0x79:
_0x76:
_0x73:
_0x70:
_0x6D:
_0x6A:
_0x67:
_0x62:
	LDS  R26,_mode2
	CPI  R26,LOW(0x2)
	BRNE _0x7C
; 0000 01AD     {
; 0000 01AE     out_stat2=0;
	LDI  R30,LOW(0)
	STS  _out_stat2,R30
; 0000 01AF     if(tst_cnt==1)out_stat2|=(1<<PP2_1);
	LDS  R26,_tst_cnt
	CPI  R26,LOW(0x1)
	BRNE _0x7D
	ORI  R30,8
	RJMP _0xF1
; 0000 01B0     else if(tst_cnt==2)out_stat2|=(1<<PP2_2);
_0x7D:
	LDS  R26,_tst_cnt
	CPI  R26,LOW(0x2)
	BRNE _0x7F
	LDS  R30,_out_stat2
	ORI  R30,4
	RJMP _0xF1
; 0000 01B1     else if(tst_cnt==3)out_stat2|=(1<<PP2_3);
_0x7F:
	LDS  R26,_tst_cnt
	CPI  R26,LOW(0x3)
	BRNE _0x81
	LDS  R30,_out_stat2
	ORI  R30,2
	RJMP _0xF1
; 0000 01B2     else if(tst_cnt==4)out_stat2|=(1<<PP2_4);
_0x81:
	LDS  R26,_tst_cnt
	CPI  R26,LOW(0x4)
	BRNE _0x83
	LDS  R30,_out_stat2
	ORI  R30,1
_0xF1:
	STS  _out_stat2,R30
; 0000 01B3     }
_0x83:
; 0000 01B4 }
_0x7C:
	RET
; .FEND
;
;//-----------------------------------------------
;void step1_contr_new(void)
; 0000 01B8 {
; 0000 01B9 
; 0000 01BA out_stat1=0;
; 0000 01BB if(mode1==mOFF)step1=sOFF;
; 0000 01BC 
; 0000 01BD if(step1==sOFF)
; 0000 01BE 	{
; 0000 01BF 
; 0000 01C0 	}
; 0000 01C1 else if(step1==s1)
; 0000 01C2 	{
; 0000 01C3 	cnt_del1=20;
; 0000 01C4 	step1=s2;
; 0000 01C5 	}
; 0000 01C6 else if(step1==s2)
; 0000 01C7 	{
; 0000 01C8 	cnt_del1--;
; 0000 01C9 	if(cnt_del1==0)
; 0000 01CA 		{
; 0000 01CB 		//cnt_del1=20;
; 0000 01CC 		step1=s4;
; 0000 01CD 		}
; 0000 01CE 	}
; 0000 01CF     /*
; 0000 01D0 else if(step1==s3)
; 0000 01D1 	{
; 0000 01D2 	out_stat1|=(1<<PP1_1);
; 0000 01D3 	cnt_del1--;
; 0000 01D4 	if(cnt_del1==0)
; 0000 01D5 		{
; 0000 01D6 		step1=s4;
; 0000 01D7 		}
; 0000 01D8 
; 0000 01D9 	}*/
; 0000 01DA else if(step1==s4)
; 0000 01DB 	{
; 0000 01DC 	out_stat1|=(1<<PP1_1)|(1<<PP1_2);
; 0000 01DD 	if(bVR1)
; 0000 01DE 		{
; 0000 01DF 		step1=s5;
; 0000 01E0 		cnt_del1=30;
; 0000 01E1 		}
; 0000 01E2 	}
; 0000 01E3 
; 0000 01E4 else if(step1==s5)
; 0000 01E5 	{
; 0000 01E6 	out_stat1|=(1<<PP1_1)|(1<<PP1_2)|(1<<PP1_3);
; 0000 01E7 	cnt_del1--;
; 0000 01E8 	if(cnt_del1==0)
; 0000 01E9 		{
; 0000 01EA 		cnt_del1=30;
; 0000 01EB 		step1=s6;
; 0000 01EC 		}
; 0000 01ED 	}
; 0000 01EE else if(step1==s6)
; 0000 01EF 	{
; 0000 01F0 	out_stat1|=(1<<PP1_1)|(1<<PP1_2)|(1<<PP1_3)|(1<<PP1_4);
; 0000 01F1 	cnt_del1--;
; 0000 01F2 	if(cnt_del1==0)
; 0000 01F3 		{
; 0000 01F4 		cnt_del1=30;
; 0000 01F5 		step1=s7;
; 0000 01F6 		}
; 0000 01F7 	}
; 0000 01F8 else if(step1==s7)
; 0000 01F9 	{
; 0000 01FA 	out_stat1|=(1<<PP1_1)|(1<<PP1_2)|(1<<PP1_4);
; 0000 01FB 	cnt_del1--;
; 0000 01FC 	if(cnt_del1==0)
; 0000 01FD 		{
; 0000 01FE 		cnt_del1=20;
; 0000 01FF 		step1=s8;
; 0000 0200 		}
; 0000 0201 	}
; 0000 0202 else if(step1==s8)
; 0000 0203 	{
; 0000 0204 	out_stat1|=(1<<PP1_1);
; 0000 0205 	cnt_del1--;
; 0000 0206 	if(cnt_del1==0)
; 0000 0207 		{
; 0000 0208 		step1=s9;
; 0000 0209 		}
; 0000 020A 	}
; 0000 020B else if(step1==s9)
; 0000 020C 	{
; 0000 020D 	if(bMD1)
; 0000 020E 		{
; 0000 020F 		step1=sOFF;
; 0000 0210 		}
; 0000 0211 	}
; 0000 0212 
; 0000 0213 if(mode1==mTST)
; 0000 0214     {
; 0000 0215     out_stat1=0;
; 0000 0216     if(tst_cnt==1)out_stat1|=(1<<PP1_1);
; 0000 0217     else if(tst_cnt==2)out_stat1|=(1<<PP1_2);
; 0000 0218     else if(tst_cnt==3)out_stat1|=(1<<PP1_3);
; 0000 0219     else if(tst_cnt==4)out_stat1|=(1<<PP1_4);
; 0000 021A     }
; 0000 021B }
;
;//-----------------------------------------------
;void cmnd_an(void)
; 0000 021F {
_cmnd_an:
; .FSTART _cmnd_an
; 0000 0220 /*DDRD.2=1;
; 0000 0221 PORTD.2=!PORTD.2;*/
; 0000 0222 if(cmnd==0x55)
	LDS  R26,_cmnd
	CPI  R26,LOW(0x55)
	BRNE _0xA5
; 0000 0223 	{
; 0000 0224 	if(mode1==mON)step1=s1;
	LDS  R30,_mode1
	CPI  R30,0
	BRNE _0xA6
	LDI  R30,LOW(1)
	STS  _step1,R30
; 0000 0225 	if(mode2==mON)
_0xA6:
	LDS  R30,_mode2
	CPI  R30,0
	BRNE _0xA7
; 0000 0226 		{
; 0000 0227 		step2=s1;
	LDI  R30,LOW(1)
	STS  _step2,R30
; 0000 0228 		/*PORTD.2=!PORTD.2; */
; 0000 0229 		}
; 0000 022A 	}
_0xA7:
; 0000 022B else if(cmnd==0x33)
	RJMP _0xA8
_0xA5:
	LDS  R26,_cmnd
	CPI  R26,LOW(0x33)
	BRNE _0xA9
; 0000 022C 	{
; 0000 022D 	if(mode1==mON)step1=sOFF;
	LDS  R30,_mode1
	CPI  R30,0
	BRNE _0xAA
	LDI  R30,LOW(0)
	STS  _step1,R30
; 0000 022E 	if(mode2==mON)step2=sOFF;
_0xAA:
	LDS  R30,_mode2
	CPI  R30,0
	BRNE _0xAB
	LDI  R30,LOW(0)
	STS  _step2,R30
; 0000 022F 	}
_0xAB:
; 0000 0230 
; 0000 0231 }
_0xA9:
_0xA8:
	RET
; .FEND
;
;//-----------------------------------------------
;void state_an(void)
; 0000 0235 {
_state_an:
; .FSTART _state_an
; 0000 0236 #if(NUM_OF_SLAVE==1)
; 0000 0237 if(state&0x01)mode1=mON;
; 0000 0238 else if(!(tst&0x01))mode1=mTST;
; 0000 0239 else mode1=mOFF;
; 0000 023A 
; 0000 023B if(state&0x02)mode2=mON;
; 0000 023C else if(!(tst&0x02))mode2=mTST;
; 0000 023D else mode2=mOFF;
; 0000 023E 
; 0000 023F #elif(NUM_OF_SLAVE==2)
; 0000 0240 if(state&0x04)mode1=mON;
; 0000 0241 else if(!(tst&0x04))mode1=mTST;
; 0000 0242 else mode1=mOFF;
; 0000 0243 
; 0000 0244 if(state&0x08)mode2=mON;
; 0000 0245 else if(!(tst&0x08))mode2=mTST;
; 0000 0246 else mode2=mOFF;
; 0000 0247 
; 0000 0248 #elif(NUM_OF_SLAVE==3)
; 0000 0249 if(state&0x10)mode1=mON;
	LDS  R30,_state
	ANDI R30,LOW(0x10)
	BREQ _0xAC
	LDI  R30,LOW(0)
	RJMP _0xF4
; 0000 024A else if(!(tst&0x10))mode1=mTST;
_0xAC:
	LDS  R30,_tst
	ANDI R30,LOW(0x10)
	BRNE _0xAE
	LDI  R30,LOW(2)
	RJMP _0xF4
; 0000 024B else mode1=mOFF;
_0xAE:
	LDI  R30,LOW(1)
_0xF4:
	STS  _mode1,R30
; 0000 024C 
; 0000 024D if(state&0x20)mode2=mON;
	LDS  R30,_state
	ANDI R30,LOW(0x20)
	BREQ _0xB0
	LDI  R30,LOW(0)
	RJMP _0xF5
; 0000 024E else if(!(tst&0x20))mode2=mTST;
_0xB0:
	LDS  R30,_tst
	ANDI R30,LOW(0x20)
	BRNE _0xB2
	LDI  R30,LOW(2)
	RJMP _0xF5
; 0000 024F else mode2=mOFF;
_0xB2:
	LDI  R30,LOW(1)
_0xF5:
	STS  _mode2,R30
; 0000 0250 #endif
; 0000 0251 }
	RET
; .FEND
;
;//-----------------------------------------------
;void uart_in_an(void)
; 0000 0255 {
_uart_in_an:
; .FSTART _uart_in_an
; 0000 0256 if(rx_buffer[0]==NUM_OF_SLAVE)
	LDS  R26,_rx_buffer
	CPI  R26,LOW(0x3)
	BREQ PC+2
	RJMP _0xB4
; 0000 0257 	{
; 0000 0258 	char temp1,temp2,temp3,temp4;
; 0000 0259 
; 0000 025A 	temp1=NUM_OF_SLAVE;
	SBIW R28,4
;	temp1 -> Y+3
;	temp2 -> Y+2
;	temp3 -> Y+1
;	temp4 -> Y+0
	LDI  R30,LOW(3)
	STD  Y+3,R30
; 0000 025B 	temp4=temp1;
	ST   Y,R30
; 0000 025C 
; 0000 025D 	temp2=0x80;
	LDI  R30,LOW(128)
	STD  Y+2,R30
; 0000 025E 	if(bVR1)temp2|=(1<<0);
	SBRS R3,4
	RJMP _0xB5
	LDD  R30,Y+2
	ORI  R30,1
	STD  Y+2,R30
; 0000 025F 	if(bMD1)temp2|=(1<<1);
_0xB5:
	SBRS R3,6
	RJMP _0xB6
	LDD  R30,Y+2
	ORI  R30,2
	STD  Y+2,R30
; 0000 0260 	if(step1!=sOFF)temp2|=(1<<2);
_0xB6:
	LDS  R30,_step1
	CPI  R30,0
	BREQ _0xB7
	LDD  R30,Y+2
	ORI  R30,4
	STD  Y+2,R30
; 0000 0261 	if(bVR2)temp2|=(1<<3);
_0xB7:
	SBRS R3,5
	RJMP _0xB8
	LDD  R30,Y+2
	ORI  R30,8
	STD  Y+2,R30
; 0000 0262 	if(bMD2)temp2|=(1<<4);
_0xB8:
	SBRS R3,7
	RJMP _0xB9
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
; 0000 0263 	if(step2!=sOFF)temp2|=(1<<5);
_0xB9:
	LDS  R30,_step2
	CPI  R30,0
	BREQ _0xBA
	LDD  R30,Y+2
	ORI  R30,0x20
	STD  Y+2,R30
; 0000 0264 	//temp2=0xff;
; 0000 0265 
; 0000 0266 	temp4^=temp2;
_0xBA:
	LDD  R30,Y+2
	LD   R26,Y
	EOR  R30,R26
	ST   Y,R30
; 0000 0267 
; 0000 0268 	temp3=0x80;
	LDI  R30,LOW(128)
	STD  Y+1,R30
; 0000 0269 	temp4^=temp3;
	LD   R26,Y
	EOR  R30,R26
	ST   Y,R30
; 0000 026A 
; 0000 026B 	temp4|=0x80;
	ORI  R30,0x80
	ST   Y,R30
; 0000 026C 
; 0000 026D 	out_usart(4,temp1,temp2,temp3,temp4,0,0,0,0,0);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R30,Y+4
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _out_usart
; 0000 026E     //out_usart(4,1,2,3,0x55,0,0,0,0,0);
; 0000 026F 
; 0000 0270 	}
	ADIW R28,4
; 0000 0271 
; 0000 0272 cmnd_new=rx_buffer[1];
_0xB4:
	__GETB1MN _rx_buffer,1
	STS  _cmnd_new,R30
; 0000 0273 if(cmnd_new==cmnd_old)
	LDS  R30,_cmnd_old
	LDS  R26,_cmnd_new
	CP   R30,R26
	BRNE _0xBB
; 0000 0274 	{
; 0000 0275 	if(cmnd_cnt<4)
	LDS  R26,_cmnd_cnt
	CPI  R26,LOW(0x4)
	BRSH _0xBC
; 0000 0276 		{
; 0000 0277 		cmnd_cnt++;
	LDS  R30,_cmnd_cnt
	SUBI R30,-LOW(1)
	STS  _cmnd_cnt,R30
; 0000 0278 		if(cmnd_cnt>=4)
	LDS  R26,_cmnd_cnt
	CPI  R26,LOW(0x4)
	BRLO _0xBD
; 0000 0279 			{
; 0000 027A 			if((cmnd_new&0x7f)!=cmnd)
	LDS  R30,_cmnd_new
	ANDI R30,0x7F
	MOV  R26,R30
	LDS  R30,_cmnd
	CP   R30,R26
	BREQ _0xBE
; 0000 027B 				{
; 0000 027C 				cmnd=cmnd_new&0x7f;
	LDS  R30,_cmnd_new
	ANDI R30,0x7F
	STS  _cmnd,R30
; 0000 027D 				cmnd_an();
	RCALL _cmnd_an
; 0000 027E 				}
; 0000 027F 			}
_0xBE:
; 0000 0280 		}
_0xBD:
; 0000 0281 	}
_0xBC:
; 0000 0282 else cmnd_cnt=0;
	RJMP _0xBF
_0xBB:
	LDI  R30,LOW(0)
	STS  _cmnd_cnt,R30
; 0000 0283 cmnd_old=cmnd_new;
_0xBF:
	LDS  R30,_cmnd_new
	STS  _cmnd_old,R30
; 0000 0284 
; 0000 0285 state_new=rx_buffer[2];
	__GETB1MN _rx_buffer,2
	STS  _state_new,R30
; 0000 0286 if(state_new==state_old)
	LDS  R30,_state_old
	LDS  R26,_state_new
	CP   R30,R26
	BRNE _0xC0
; 0000 0287 	{
; 0000 0288 	if(state_cnt<4)
	LDS  R26,_state_cnt
	CPI  R26,LOW(0x4)
	BRSH _0xC1
; 0000 0289 		{
; 0000 028A 		state_cnt++;
	LDS  R30,_state_cnt
	SUBI R30,-LOW(1)
	STS  _state_cnt,R30
; 0000 028B 		if(state_cnt>=4)
	LDS  R26,_state_cnt
	CPI  R26,LOW(0x4)
	BRLO _0xC2
; 0000 028C 			{
; 0000 028D 			if((state_new&0x7f)!=state)
	LDS  R30,_state_new
	ANDI R30,0x7F
	MOV  R26,R30
	LDS  R30,_state
	CP   R30,R26
	BREQ _0xC3
; 0000 028E 				{
; 0000 028F 				state=state_new&0x7f;
	LDS  R30,_state_new
	ANDI R30,0x7F
	STS  _state,R30
; 0000 0290 				state_an();
	RCALL _state_an
; 0000 0291 				}
; 0000 0292 			}
_0xC3:
; 0000 0293 		}
_0xC2:
; 0000 0294 	}
_0xC1:
; 0000 0295 else state_cnt=0;
	RJMP _0xC4
_0xC0:
	LDI  R30,LOW(0)
	STS  _state_cnt,R30
; 0000 0296 state_old=state_new;
_0xC4:
	LDS  R30,_state_new
	STS  _state_old,R30
; 0000 0297 
; 0000 0298 tst_new=rx_buffer[3];
	__GETB1MN _rx_buffer,3
	STS  _tst_new,R30
; 0000 0299 if(tst_new==tst_old)
	LDS  R30,_tst_old
	LDS  R26,_tst_new
	CP   R30,R26
	BRNE _0xC5
; 0000 029A 	{
; 0000 029B 	if(tst_cnt<4)
	LDS  R26,_tst_cnt
	CPI  R26,LOW(0x4)
	BRSH _0xC6
; 0000 029C 		{
; 0000 029D 		tst_cnt++;
	LDS  R30,_tst_cnt
	SUBI R30,-LOW(1)
	STS  _tst_cnt,R30
; 0000 029E 		if(tst_cnt>=4)
	LDS  R26,_tst_cnt
	CPI  R26,LOW(0x4)
	BRLO _0xC7
; 0000 029F 			{
; 0000 02A0 			if((tst_new&0x7f)!=tst)
	LDS  R30,_tst_new
	ANDI R30,0x7F
	MOV  R26,R30
	LDS  R30,_tst
	CP   R30,R26
	BREQ _0xC8
; 0000 02A1 				{
; 0000 02A2 				tst=tst_new&0x7f;
	LDS  R30,_tst_new
	ANDI R30,0x7F
	STS  _tst,R30
; 0000 02A3 				state_an();
	RCALL _state_an
; 0000 02A4 				}
; 0000 02A5 			}
_0xC8:
; 0000 02A6 		}
_0xC7:
; 0000 02A7 	}
_0xC6:
; 0000 02A8 else tst_cnt=0;
	RJMP _0xC9
_0xC5:
	LDI  R30,LOW(0)
	STS  _tst_cnt,R30
; 0000 02A9 tst_old=tst_new;
_0xC9:
	LDS  R30,_tst_new
	STS  _tst_old,R30
; 0000 02AA 
; 0000 02AB /*state=rx_buffer[2];
; 0000 02AC state_an();*/
; 0000 02AD 
; 0000 02AE }
	RET
; .FEND
;
;//-----------------------------------------------
;void mathemat(void)
; 0000 02B2 {
_mathemat:
; .FSTART _mathemat
; 0000 02B3 timer1_delay=ee_timer1_delay*31;
	LDI  R26,LOW(_ee_timer1_delay)
	LDI  R27,HIGH(_ee_timer1_delay)
	CALL __EEPROMRDW
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	CALL __MULW12U
	STS  _timer1_delay,R30
	STS  _timer1_delay+1,R31
; 0000 02B4 }
	RET
; .FEND
;
;
;//-----------------------------------------------
;void led_hndl(void)
; 0000 02B9 {
_led_hndl:
; .FSTART _led_hndl
; 0000 02BA 
; 0000 02BB }
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
; 0000 02CE {
; 0000 02CF DDRD&=0b00000111;
; 0000 02D0 PORTD|=0b11111000;
; 0000 02D1 
; 0000 02D2 but_port|=(but_mask^0xff);
; 0000 02D3 but_dir&=but_mask;
; 0000 02D4 #asm
; 0000 02D5 nop
; 0000 02D6 nop
; 0000 02D7 nop
; 0000 02D8 nop
; 0000 02D9 nop
; 0000 02DA nop
; 0000 02DB nop
; 0000 02DC 
; 0000 02DD 
; 0000 02DE #endasm
; 0000 02DF 
; 0000 02E0 but_n=but_pin|but_mask;
; 0000 02E1 
; 0000 02E2 if((but_n==no_but)||(but_n!=but_s))
; 0000 02E3  	{
; 0000 02E4  	speed=0;
; 0000 02E5    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
; 0000 02E6   		{
; 0000 02E7    	     n_but=1;
; 0000 02E8           but=but_s;
; 0000 02E9           }
; 0000 02EA    	if (but1_cnt>=but_onL_temp)
; 0000 02EB   		{
; 0000 02EC    	     n_but=1;
; 0000 02ED           but=but_s&0b11111101;
; 0000 02EE           }
; 0000 02EF     	l_but=0;
; 0000 02F0    	but_onL_temp=but_onL;
; 0000 02F1     	but0_cnt=0;
; 0000 02F2   	but1_cnt=0;
; 0000 02F3      goto but_drv_out;
; 0000 02F4   	}
; 0000 02F5 
; 0000 02F6 if(but_n==but_s)
; 0000 02F7  	{
; 0000 02F8   	but0_cnt++;
; 0000 02F9   	if(but0_cnt>=but_on)
; 0000 02FA   		{
; 0000 02FB    		but0_cnt=0;
; 0000 02FC    		but1_cnt++;
; 0000 02FD    		if(but1_cnt>=but_onL_temp)
; 0000 02FE    			{
; 0000 02FF     			but=but_s&0b11111101;
; 0000 0300     			but1_cnt=0;
; 0000 0301     			n_but=1;
; 0000 0302     			l_but=1;
; 0000 0303 			if(speed)
; 0000 0304 				{
; 0000 0305     				but_onL_temp=but_onL_temp>>1;
; 0000 0306         			if(but_onL_temp<=2) but_onL_temp=2;
; 0000 0307 				}
; 0000 0308    			}
; 0000 0309   		}
; 0000 030A  	}
; 0000 030B but_drv_out:
; 0000 030C but_s=but_n;
; 0000 030D but_port|=(but_mask^0xff);
; 0000 030E but_dir&=but_mask;
; 0000 030F }
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
;
;
;
;
;//***********************************************
;//***********************************************
;//***********************************************
;//***********************************************
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0324 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0325 TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0326 TCNT0=-78;
	LDI  R30,LOW(178)
	OUT  0x32,R30
; 0000 0327 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 0328 
; 0000 0329 b100Hz=1;
	SET
	BLD  R2,1
; 0000 032A 
; 0000 032B if(++t0_cnt1>=10)
	INC  R9
	LDI  R30,LOW(10)
	CP   R9,R30
	BRLO _0xD9
; 0000 032C 	{
; 0000 032D 	t0_cnt1=0;
	CLR  R9
; 0000 032E 	b10Hz=1;
	BLD  R2,2
; 0000 032F 
; 0000 0330 	if(++t0_cnt2>=2)
	INC  R8
	LDI  R30,LOW(2)
	CP   R8,R30
	BRLO _0xDA
; 0000 0331 		{
; 0000 0332 		t0_cnt2=0;
	CLR  R8
; 0000 0333 		bFL5=!bFL5;
	EOR  R3,R30
; 0000 0334 		}
; 0000 0335 
; 0000 0336 	if(++t0_cnt3>=5)
_0xDA:
	INC  R11
	LDI  R30,LOW(5)
	CP   R11,R30
	BRLO _0xDB
; 0000 0337 		{
; 0000 0338 		t0_cnt3=0;
	CLR  R11
; 0000 0339 		bFL2=!bFL2;
	LDI  R30,LOW(1)
	EOR  R3,R30
; 0000 033A 		}
; 0000 033B 
; 0000 033C 	if(++t0_cnt4>=10)
_0xDB:
	INC  R10
	LDI  R30,LOW(10)
	CP   R10,R30
	BRLO _0xDC
; 0000 033D 		{
; 0000 033E 		t0_cnt4=0;
	CLR  R10
; 0000 033F 		b1Hz=!b1Hz;
	LDI  R30,LOW(8)
	EOR  R2,R30
; 0000 0340 		}
; 0000 0341 	}
_0xDC:
; 0000 0342 }
_0xD9:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;//***********************************************
;// Timer 1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 0347 {
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
; 0000 0348 
; 0000 0349 }
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
; 0000 0352 {
_main:
; .FSTART _main
; 0000 0353 
; 0000 0354 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 0355 DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0356 
; 0000 0357 PORTB=0x00;
	OUT  0x18,R30
; 0000 0358 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0359 
; 0000 035A PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 035B DDRC=0x00;
	OUT  0x14,R30
; 0000 035C 
; 0000 035D 
; 0000 035E PORTD=0x00;
	OUT  0x12,R30
; 0000 035F DDRD=0x00;
	OUT  0x11,R30
; 0000 0360 
; 0000 0361 
; 0000 0362 TCCR0=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 0363 TCNT0=-99;
	LDI  R30,LOW(157)
	OUT  0x32,R30
; 0000 0364 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 0365 
; 0000 0366 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0367 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0368 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0369 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 036A ICR1H=0x00;
	OUT  0x27,R30
; 0000 036B ICR1L=0x00;
	OUT  0x26,R30
; 0000 036C OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 036D OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 036E OCR1BH=0x00;
	OUT  0x29,R30
; 0000 036F OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0370 
; 0000 0371 
; 0000 0372 ASSR=0x00;
	OUT  0x22,R30
; 0000 0373 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0374 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0375 OCR2=0x00;
	OUT  0x23,R30
; 0000 0376 
; 0000 0377 // USART initialization
; 0000 0378 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0379 // USART Receiver: On
; 0000 037A // USART Transmitter: On
; 0000 037B // USART Mode: Asynchronous
; 0000 037C // USART Baud rate: 19200
; 0000 037D UCSRA=0x00;
	OUT  0xB,R30
; 0000 037E UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 037F UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0380 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0381 UBRRL=0x19;
	LDI  R30,LOW(25)
	OUT  0x9,R30
; 0000 0382 
; 0000 0383 MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 0384 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0385 
; 0000 0386 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0387 
; 0000 0388 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0389 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 038A 
; 0000 038B #asm("sei")
	sei
; 0000 038C led_hndl();
	RCALL _led_hndl
; 0000 038D ch_on[0]=coON;
	LDI  R26,LOW(_ch_on)
	LDI  R27,HIGH(_ch_on)
	LDI  R30,LOW(170)
	CALL __EEPROMWRB
; 0000 038E //ee_avtom_mode=eamOFF;
; 0000 038F //ind=iSet_delay;
; 0000 0390 while (1)
_0xDD:
; 0000 0391       {
; 0000 0392       if(b600Hz)
	SBRS R2,0
	RJMP _0xE0
; 0000 0393 		{
; 0000 0394 		b600Hz=0;
	CLT
	BLD  R2,0
; 0000 0395 
; 0000 0396 		}
; 0000 0397       if(b100Hz)
_0xE0:
	SBRS R2,1
	RJMP _0xE1
; 0000 0398 		{
; 0000 0399 		b100Hz=0;
	CLT
	BLD  R2,1
; 0000 039A 
; 0000 039B           in_drv();
	CALL _in_drv
; 0000 039C           mdvr_drv();
	RCALL _mdvr_drv
; 0000 039D           step1_contr();
	RCALL _step1_contr
; 0000 039E 		step2_contr();
	RCALL _step2_contr
; 0000 039F           out_drv();
	CALL _out_drv
; 0000 03A0     		}
; 0000 03A1 	if(b10Hz)
_0xE1:
	SBRS R2,2
	RJMP _0xE2
; 0000 03A2 		{
; 0000 03A3 		b10Hz=0;
	CLT
	BLD  R2,2
; 0000 03A4 
; 0000 03A5         led_hndl();
	RCALL _led_hndl
; 0000 03A6         mathemat();
	RCALL _mathemat
; 0000 03A7         DDRD.2=1;
	SBI  0x11,2
; 0000 03A8         if(step2!=sOFF) PORTD.2=0;
	LDS  R30,_step2
	CPI  R30,0
	BREQ _0xE5
	CBI  0x12,2
; 0000 03A9         else PORTD.2=1;
	RJMP _0xE8
_0xE5:
	SBI  0x12,2
; 0000 03AA 
; 0000 03AB 
; 0000 03AC         }
_0xE8:
; 0000 03AD 	if(b1Hz)
_0xE2:
	SBRS R2,3
	RJMP _0xEB
; 0000 03AE 		{
; 0000 03AF 		b1Hz=0;
	CLT
	BLD  R2,3
; 0000 03B0 
; 0000 03B1         if(++tst_cnt>=5)tst_cnt=0;
	LDS  R26,_tst_cnt
	SUBI R26,-LOW(1)
	STS  _tst_cnt,R26
	CPI  R26,LOW(0x5)
	BRLO _0xEC
	LDI  R30,LOW(0)
	STS  _tst_cnt,R30
; 0000 03B2         }
_0xEC:
; 0000 03B3       };
_0xEB:
	RJMP _0xDD
; 0000 03B4 }
_0xED:
	RJMP _0xED
; .FEND
;
;
;
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
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
_cnt_vr1:
	.BYTE 0x1
_cnt_vr2:
	.BYTE 0x1

	.ESEG
_ch_on:
	.BYTE 0x6
_ee_timer1_delay:
	.BYTE 0x2

	.DSEG
_timer1_delay:
	.BYTE 0x2
_cmnd_byte:
	.BYTE 0x1
_state_byte:
	.BYTE 0x1
_step1:
	.BYTE 0x1
_step2:
	.BYTE 0x1
_mode1:
	.BYTE 0x1
_mode2:
	.BYTE 0x1
_cnt_del1:
	.BYTE 0x1
_cnt_del2:
	.BYTE 0x1
_out_stat:
	.BYTE 0x1
_out_stat1:
	.BYTE 0x1
_out_stat2:
	.BYTE 0x1
_cmnd_new:
	.BYTE 0x1
_cmnd_old:
	.BYTE 0x1
_cmnd:
	.BYTE 0x1
_cmnd_cnt:
	.BYTE 0x1
_state_new:
	.BYTE 0x1
_state_old:
	.BYTE 0x1
_state:
	.BYTE 0x1
_state_cnt:
	.BYTE 0x1
_tst_new:
	.BYTE 0x1
_tst_old:
	.BYTE 0x1
_tst:
	.BYTE 0x1
_tst_cnt:
	.BYTE 0x1
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

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x0:
	LDS  R30,_cnt_del1
	SUBI R30,LOW(1)
	STS  _cnt_del1,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	STS  _out_stat1,R30
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x2:
	LDS  R30,_cnt_del2
	SUBI R30,LOW(1)
	STS  _cnt_del2,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	STS  _out_stat2,R30
	RJMP SUBOPT_0x2


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
