
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 1,000000 MHz
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
	.ORG 0x260

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
;//Датчик верхний
;#define D1	2
;//Датчик нижний
;#define D2	3
;//Главная клавиша, включает рабочий цикл
;#define KL_MAIN	4
;//Вторая клавиша, включает ручную перекачку
;#define KL1	5
;
;#define PP1	7
;#define PP2	6
;#define LED_PRON	0
;#define DV	1
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
;enum{sOFF=0,sUP1,sUP2,sDN1,sDN2}step=sOFF;
;enum {iMn,iPr_sel,iVr} ind;
;char sub_ind;
;char in_word,in_word_old,in_word_new,in_word_cnt;
;bit bERR;
;signed int cnt_del=0;
;
;char bKL_MAIN;      //если 1 то включен главный цикл, если 0 то ручная перекачка
;char bD1;           //уровень выше верхней метки
;bit bD2;            //уровень выше нижней метки
;bit bKL1;           //инициализация ручной перекачки
;//bit bVR2;
;char cnt_d1,cnt_d2,cnt_kl_main,cnt_kl1,cnt_vr2;
;
;eeprom unsigned ee_delay[4][2];
;eeprom char ee_vr_log;
;//#include <mega16.h>
;//#include <mega8535.h>
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
;//-----------------------------------------------
;void prog_drv(void)
; 0000 0049 {

	.CSEG
_prog_drv:
; .FSTART _prog_drv
; 0000 004A /*char temp,temp1,temp2;
; 0000 004B 
; 0000 004C temp=ee_program[0];
; 0000 004D temp1=ee_program[1];
; 0000 004E temp2=ee_program[2];
; 0000 004F 
; 0000 0050 if((temp==temp1)&&(temp==temp2))
; 0000 0051 	{
; 0000 0052 	}
; 0000 0053 else if((temp==temp1)&&(temp!=temp2))
; 0000 0054 	{
; 0000 0055 	temp2=temp;
; 0000 0056 	}
; 0000 0057 else if((temp!=temp1)&&(temp==temp2))
; 0000 0058 	{
; 0000 0059 	temp1=temp;
; 0000 005A 	}
; 0000 005B else if((temp!=temp1)&&(temp1==temp2))
; 0000 005C 	{
; 0000 005D 	temp=temp1;
; 0000 005E 	}
; 0000 005F else if((temp!=temp1)&&(temp!=temp2))
; 0000 0060 	{
; 0000 0061 	temp=MINPROG;
; 0000 0062 	temp1=MINPROG;
; 0000 0063 	temp2=MINPROG;
; 0000 0064 	}
; 0000 0065 
; 0000 0066 if(!((temp<=MAXPROG)&&(temp>=MINPROG)))
; 0000 0067 	{
; 0000 0068 	temp=MINPROG;
; 0000 0069 	}
; 0000 006A 
; 0000 006B if(temp!=ee_program[0])ee_program[0]=temp;
; 0000 006C if(temp!=ee_program[1])ee_program[1]=temp;
; 0000 006D if(temp!=ee_program[2])ee_program[2]=temp;
; 0000 006E 
; 0000 006F prog=temp; */
; 0000 0070 }
	RET
; .FEND
;
;//-----------------------------------------------
;void in_drv(void)
; 0000 0074 {
_in_drv:
; .FSTART _in_drv
; 0000 0075 char i,temp;
; 0000 0076 unsigned int tempUI;
; 0000 0077 DDRA=0x00;
	CALL __SAVELOCR4
;	i -> R17
;	temp -> R16
;	tempUI -> R18,R19
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0078 PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 0079 in_word_new=PINA;
	IN   R30,0x19
	STS  _in_word_new,R30
; 0000 007A if(in_word_old==in_word_new)
	LDS  R26,_in_word_old
	CP   R30,R26
	BRNE _0x4
; 0000 007B 	{
; 0000 007C 	if(in_word_cnt<10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRSH _0x5
; 0000 007D 		{
; 0000 007E 		in_word_cnt++;
	LDS  R30,_in_word_cnt
	SUBI R30,-LOW(1)
	STS  _in_word_cnt,R30
; 0000 007F 		if(in_word_cnt>=10)
	LDS  R26,_in_word_cnt
	CPI  R26,LOW(0xA)
	BRLO _0x6
; 0000 0080 			{
; 0000 0081 			in_word=in_word_old;
	LDS  R30,_in_word_old
	STS  _in_word,R30
; 0000 0082 			}
; 0000 0083 		}
_0x6:
; 0000 0084 	}
_0x5:
; 0000 0085 else in_word_cnt=0;
	RJMP _0x7
_0x4:
	LDI  R30,LOW(0)
	STS  _in_word_cnt,R30
; 0000 0086 
; 0000 0087 
; 0000 0088 in_word_old=in_word_new;
_0x7:
	LDS  R30,_in_word_new
	STS  _in_word_old,R30
; 0000 0089 }
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;
;
;
;//-----------------------------------------------
;void mdvr_drv(void)
; 0000 008F {
_mdvr_drv:
; .FSTART _mdvr_drv
; 0000 0090 if(!(in_word&(1<D1)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x1)
	BRNE _0x8
; 0000 0091 	{
; 0000 0092 	if(cnt_d1<10)
	LDS  R26,_cnt_d1
	CPI  R26,LOW(0xA)
	BRSH _0x9
; 0000 0093 		{
; 0000 0094 		cnt_d1++;
	LDS  R30,_cnt_d1
	SUBI R30,-LOW(1)
	STS  _cnt_d1,R30
; 0000 0095 		if(cnt_d1==10) bD1=1;
	LDS  R26,_cnt_d1
	CPI  R26,LOW(0xA)
	BRNE _0xA
	LDI  R30,LOW(1)
	STS  _bD1,R30
; 0000 0096 		}
_0xA:
; 0000 0097 
; 0000 0098 	}
_0x9:
; 0000 0099 else
	RJMP _0xB
_0x8:
; 0000 009A 	{
; 0000 009B 	if(cnt_d1)
	LDS  R30,_cnt_d1
	CPI  R30,0
	BREQ _0xC
; 0000 009C 		{
; 0000 009D 		cnt_d1--;
	SUBI R30,LOW(1)
	STS  _cnt_d1,R30
; 0000 009E 		if(cnt_d1==0) bD1=0;
	CPI  R30,0
	BRNE _0xD
	LDI  R30,LOW(0)
	STS  _bD1,R30
; 0000 009F 		}
_0xD:
; 0000 00A0 
; 0000 00A1 	}
_0xC:
_0xB:
; 0000 00A2 
; 0000 00A3 if(!(in_word&(1<<D2)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x8)
	BRNE _0xE
; 0000 00A4 	{
; 0000 00A5 	if(cnt_d2<10)
	LDS  R26,_cnt_d2
	CPI  R26,LOW(0xA)
	BRSH _0xF
; 0000 00A6 		{
; 0000 00A7 		cnt_d2++;
	LDS  R30,_cnt_d2
	SUBI R30,-LOW(1)
	STS  _cnt_d2,R30
; 0000 00A8 		if(cnt_d2==10) bD2=1;
	LDS  R26,_cnt_d2
	CPI  R26,LOW(0xA)
	BRNE _0x10
	SET
	BLD  R3,2
; 0000 00A9 		}
_0x10:
; 0000 00AA 
; 0000 00AB 	}
_0xF:
; 0000 00AC else
	RJMP _0x11
_0xE:
; 0000 00AD 	{
; 0000 00AE 	if(cnt_d2)
	LDS  R30,_cnt_d2
	CPI  R30,0
	BREQ _0x12
; 0000 00AF 		{
; 0000 00B0 		cnt_d2--;
	SUBI R30,LOW(1)
	STS  _cnt_d2,R30
; 0000 00B1 		if(cnt_d2==0) bD2=0;
	CPI  R30,0
	BRNE _0x13
	CLT
	BLD  R3,2
; 0000 00B2 		}
_0x13:
; 0000 00B3 
; 0000 00B4 	}
_0x12:
_0x11:
; 0000 00B5 
; 0000 00B6 if(!(in_word&(1<<KL_MAIN)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x10)
	BRNE _0x14
; 0000 00B7 	{
; 0000 00B8 	if(cnt_kl_main<10)
	LDS  R26,_cnt_kl_main
	CPI  R26,LOW(0xA)
	BRSH _0x15
; 0000 00B9 		{
; 0000 00BA 		cnt_kl_main++;
	LDS  R30,_cnt_kl_main
	SUBI R30,-LOW(1)
	STS  _cnt_kl_main,R30
; 0000 00BB 		if(cnt_kl_main==10) bKL_MAIN=1;
	LDS  R26,_cnt_kl_main
	CPI  R26,LOW(0xA)
	BRNE _0x16
	LDI  R30,LOW(1)
	STS  _bKL_MAIN,R30
; 0000 00BC 		}
_0x16:
; 0000 00BD 
; 0000 00BE 	}
_0x15:
; 0000 00BF else
	RJMP _0x17
_0x14:
; 0000 00C0 	{
; 0000 00C1 	if(cnt_kl_main)
	LDS  R30,_cnt_kl_main
	CPI  R30,0
	BREQ _0x18
; 0000 00C2 		{
; 0000 00C3 		cnt_kl_main--;
	SUBI R30,LOW(1)
	STS  _cnt_kl_main,R30
; 0000 00C4 		if(cnt_kl_main==0) bKL_MAIN=0;
	CPI  R30,0
	BRNE _0x19
	LDI  R30,LOW(0)
	STS  _bKL_MAIN,R30
; 0000 00C5 		}
_0x19:
; 0000 00C6 
; 0000 00C7 	}
_0x18:
_0x17:
; 0000 00C8 
; 0000 00C9 if(!(in_word&(1<<KL1)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x20)
	BRNE _0x1A
; 0000 00CA 	{
; 0000 00CB 	if(cnt_kl1<10)
	LDS  R26,_cnt_kl1
	CPI  R26,LOW(0xA)
	BRSH _0x1B
; 0000 00CC 		{
; 0000 00CD 		cnt_kl1++;
	LDS  R30,_cnt_kl1
	SUBI R30,-LOW(1)
	STS  _cnt_kl1,R30
; 0000 00CE 		if(cnt_kl1==10) bKL1=1;
	LDS  R26,_cnt_kl1
	CPI  R26,LOW(0xA)
	BRNE _0x1C
	SET
	BLD  R3,3
; 0000 00CF 		}
_0x1C:
; 0000 00D0 
; 0000 00D1 	}
_0x1B:
; 0000 00D2 else
	RJMP _0x1D
_0x1A:
; 0000 00D3 	{
; 0000 00D4 	if(cnt_kl1)
	LDS  R30,_cnt_kl1
	CPI  R30,0
	BREQ _0x1E
; 0000 00D5 		{
; 0000 00D6 		cnt_kl1--;
	SUBI R30,LOW(1)
	STS  _cnt_kl1,R30
; 0000 00D7 		if(cnt_kl1==0) bKL1=0;
	CPI  R30,0
	BRNE _0x1F
	CLT
	BLD  R3,3
; 0000 00D8 		}
_0x1F:
; 0000 00D9 
; 0000 00DA 	}
_0x1E:
_0x1D:
; 0000 00DB }
	RET
; .FEND
;
;
;
;
;//-----------------------------------------------
;void step_contr(void)
; 0000 00E2 {
_step_contr:
; .FSTART _step_contr
; 0000 00E3 char temp=0;
; 0000 00E4 DDRB=0xFF;
	ST   -Y,R17
;	temp -> R17
	LDI  R17,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 00E5 
; 0000 00E6 
; 0000 00E7 if(bKL_MAIN)
	LDS  R30,_bKL_MAIN
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20
; 0000 00E8     {
; 0000 00E9     if(step==sOFF)
	TST  R10
	BRNE _0x21
; 0000 00EA         {
; 0000 00EB         if((!bD1)&&(!bD2))
	LDS  R30,_bD1
	CPI  R30,0
	BRNE _0x23
	SBRS R3,2
	RJMP _0x24
_0x23:
	RJMP _0x22
_0x24:
; 0000 00EC             {
; 0000 00ED             step=sDN1;
	RCALL SUBOPT_0x0
; 0000 00EE             cnt_del=20;
; 0000 00EF             }
; 0000 00F0         if((bD1)&&(bD2))
_0x22:
	LDS  R30,_bD1
	CPI  R30,0
	BREQ _0x26
	SBRC R3,2
	RJMP _0x27
_0x26:
	RJMP _0x25
_0x27:
; 0000 00F1             {
; 0000 00F2             step=sUP1;
	RCALL SUBOPT_0x1
; 0000 00F3             cnt_del=20;
; 0000 00F4             }
; 0000 00F5         }
_0x25:
; 0000 00F6     else if(step==sUP1)
	RJMP _0x28
_0x21:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x29
; 0000 00F7         {
; 0000 00F8         temp|=(1<<PP1);
	ORI  R17,LOW(128)
; 0000 00F9         cnt_del--;
	RCALL SUBOPT_0x2
; 0000 00FA 		if(cnt_del==0)
	BRNE _0x2A
; 0000 00FB             {
; 0000 00FC             step=sUP2;
	LDI  R30,LOW(2)
	MOV  R10,R30
; 0000 00FD             }
; 0000 00FE         }
_0x2A:
; 0000 00FF     else if(step==sUP2)
	RJMP _0x2B
_0x29:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x2C
; 0000 0100         {
; 0000 0101         if((!bD1)&&(!bD2))
	LDS  R30,_bD1
	CPI  R30,0
	BRNE _0x2E
	SBRS R3,2
	RJMP _0x2F
_0x2E:
	RJMP _0x2D
_0x2F:
; 0000 0102             {
; 0000 0103             step=sDN1;
	RCALL SUBOPT_0x0
; 0000 0104             cnt_del=20;
; 0000 0105             }
; 0000 0106         }
_0x2D:
; 0000 0107     else if(step==sDN1)
	RJMP _0x30
_0x2C:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x31
; 0000 0108         {
; 0000 0109         temp|=(1<<PP1);
	ORI  R17,LOW(128)
; 0000 010A 		if(cnt_del==0)
	LDS  R30,_cnt_del
	LDS  R31,_cnt_del+1
	SBIW R30,0
	BRNE _0x32
; 0000 010B             {
; 0000 010C             step=sDN2;
	LDI  R30,LOW(4)
	MOV  R10,R30
; 0000 010D             }
; 0000 010E         }
_0x32:
; 0000 010F     else if(step==sDN2)
	RJMP _0x33
_0x31:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0x34
; 0000 0110         {
; 0000 0111         temp|=(1<<PP1)|(1<<DV);
	ORI  R17,LOW(130)
; 0000 0112         if((bD1)&&(bD2))
	LDS  R30,_bD1
	CPI  R30,0
	BREQ _0x36
	SBRC R3,2
	RJMP _0x37
_0x36:
	RJMP _0x35
_0x37:
; 0000 0113             {
; 0000 0114             step=sUP1;
	RCALL SUBOPT_0x1
; 0000 0115             cnt_del=20;
; 0000 0116             }
; 0000 0117         }
_0x35:
; 0000 0118     temp|=(1<<LED_PRON);
_0x34:
_0x33:
_0x30:
_0x2B:
_0x28:
	ORI  R17,LOW(1)
; 0000 0119     }
; 0000 011A else
	RJMP _0x38
_0x20:
; 0000 011B     {
; 0000 011C     if(step==sOFF)
	TST  R10
	BRNE _0x39
; 0000 011D         {
; 0000 011E         if(bKL1)
	SBRC R3,3
; 0000 011F             {
; 0000 0120             step=sDN1;
	RCALL SUBOPT_0x0
; 0000 0121             cnt_del=20;
; 0000 0122             }
; 0000 0123         }
; 0000 0124     else if(step==sUP1)
	RJMP _0x3B
_0x39:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x3C
; 0000 0125         {
; 0000 0126         temp|=(1<<PP2);
	ORI  R17,LOW(64)
; 0000 0127         cnt_del--;
	RCALL SUBOPT_0x2
; 0000 0128 		if(cnt_del==0)
	BRNE _0x3D
; 0000 0129             {
; 0000 012A             step=sUP2;
	LDI  R30,LOW(2)
	MOV  R10,R30
; 0000 012B             }
; 0000 012C         }
_0x3D:
; 0000 012D     else if(step==sUP2)
	RJMP _0x3E
_0x3C:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x3F
; 0000 012E         {
; 0000 012F         if(bKL1)
	SBRC R3,3
; 0000 0130             {
; 0000 0131             step=sDN1;
	RCALL SUBOPT_0x0
; 0000 0132             cnt_del=20;
; 0000 0133             }
; 0000 0134         }
; 0000 0135     else if(step==sDN1)
	RJMP _0x41
_0x3F:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x42
; 0000 0136         {
; 0000 0137         temp|=(1<<PP2);
	ORI  R17,LOW(64)
; 0000 0138 		if(cnt_del==0)
	LDS  R30,_cnt_del
	LDS  R31,_cnt_del+1
	SBIW R30,0
	BRNE _0x43
; 0000 0139             {
; 0000 013A             step=sDN2;
	LDI  R30,LOW(4)
	MOV  R10,R30
; 0000 013B             }
; 0000 013C         }
_0x43:
; 0000 013D     else if(step==sDN2)
	RJMP _0x44
_0x42:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0x45
; 0000 013E         {
; 0000 013F         temp|=(1<<PP2)|(1<<DV);
	ORI  R17,LOW(66)
; 0000 0140         if(!bKL1)
	SBRS R3,3
; 0000 0141             {
; 0000 0142             step=sUP1;
	RCALL SUBOPT_0x1
; 0000 0143             cnt_del=20;
; 0000 0144             }
; 0000 0145         }
; 0000 0146     }
_0x45:
_0x44:
_0x41:
_0x3E:
_0x3B:
_0x38:
; 0000 0147 
; 0000 0148 /*
; 0000 0149 if(step==sOFF)
; 0000 014A 	{
; 0000 014B 	temp=0;
; 0000 014C 	}
; 0000 014D 
; 0000 014E else if(prog==p1)
; 0000 014F 	{
; 0000 0150 	if(step==s1)
; 0000 0151 		{
; 0000 0152 		temp|=(1<<PP1)|(1<<PP2);
; 0000 0153 
; 0000 0154 		cnt_del--;
; 0000 0155 		if(cnt_del==0)
; 0000 0156 			{
; 0000 0157 			if(ee_vacuum_mode==evmOFF)
; 0000 0158 				{
; 0000 0159 				goto lbl_0001;
; 0000 015A 				}
; 0000 015B 			else step=s2;
; 0000 015C 			}
; 0000 015D 		}
; 0000 015E 
; 0000 015F 	else if(step==s2)
; 0000 0160 		{
; 0000 0161 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
; 0000 0162 
; 0000 0163           if(!bVR)goto step_contr_end;
; 0000 0164 lbl_0001:
; 0000 0165 
; 0000 0166 		cnt_del=30;
; 0000 0167 
; 0000 0168 
; 0000 0169 	step=s3;
; 0000 016A 		}
; 0000 016B 
; 0000 016C 	else if(step==s3)
; 0000 016D 		{
; 0000 016E 		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
; 0000 016F 		cnt_del--;
; 0000 0170 		if(cnt_del==0)
; 0000 0171 			{
; 0000 0172 			step=s4;
; 0000 0173 			}
; 0000 0174           }
; 0000 0175 	else if(step==s4)
; 0000 0176 		{
; 0000 0177 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
; 0000 0178 
; 0000 0179           if(!bMD1)goto step_contr_end;
; 0000 017A 
; 0000 017B 		cnt_del=40;
; 0000 017C 		step=s5;
; 0000 017D 		}
; 0000 017E 	else if(step==s5)
; 0000 017F 		{
; 0000 0180 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
; 0000 0181 
; 0000 0182 		cnt_del--;
; 0000 0183 		if(cnt_del==0)
; 0000 0184 			{
; 0000 0185 			step=s6;
; 0000 0186 			}
; 0000 0187 		}
; 0000 0188 	else if(step==s6)
; 0000 0189 		{
; 0000 018A 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
; 0000 018B 
; 0000 018C          	if(!bMD2)goto step_contr_end;
; 0000 018D           cnt_del=40;
; 0000 018E 		//step=s7;
; 0000 018F 
; 0000 0190           step=s55;
; 0000 0191           cnt_del=40;
; 0000 0192 		}
; 0000 0193 	else if(step==s55)
; 0000 0194 		{
; 0000 0195 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
; 0000 0196           cnt_del--;
; 0000 0197           if(cnt_del==0)
; 0000 0198 			{
; 0000 0199           	step=s7;
; 0000 019A           	cnt_del=20;
; 0000 019B 			}
; 0000 019C 
; 0000 019D 		}
; 0000 019E 	else if(step==s7)
; 0000 019F 		{
; 0000 01A0 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);
; 0000 01A1 
; 0000 01A2 		cnt_del--;
; 0000 01A3 		if(cnt_del==0)
; 0000 01A4 			{
; 0000 01A5 			step=s8;
; 0000 01A6 			cnt_del=30;
; 0000 01A7 			}
; 0000 01A8 		}
; 0000 01A9 	else if(step==s8)
; 0000 01AA 		{
; 0000 01AB 		temp|=(1<<PP1)|(1<<PP3);
; 0000 01AC 
; 0000 01AD 		cnt_del--;
; 0000 01AE 		if(cnt_del==0)
; 0000 01AF 			{
; 0000 01B0 			step=s9;
; 0000 01B1 
; 0000 01B2 		cnt_del=150;
; 0000 01B3 
; 0000 01B4 
; 0000 01B5 			}
; 0000 01B6 		}
; 0000 01B7 	else if(step==s9)
; 0000 01B8 		{
; 0000 01B9 		temp|=(1<<PP1)|(1<<PP2);
; 0000 01BA 
; 0000 01BB 		cnt_del--;
; 0000 01BC 		if(cnt_del==0)
; 0000 01BD 			{
; 0000 01BE 			step=s10;
; 0000 01BF 			cnt_del=30;
; 0000 01C0 			}
; 0000 01C1 		}
; 0000 01C2 	else if(step==s10)
; 0000 01C3 		{
; 0000 01C4 		temp|=(1<<PP2);
; 0000 01C5 		cnt_del--;
; 0000 01C6 		if(cnt_del==0)
; 0000 01C7 			{
; 0000 01C8 			step=sOFF;
; 0000 01C9 			}
; 0000 01CA 		}
; 0000 01CB 	}
; 0000 01CC 
; 0000 01CD if(prog==p2)
; 0000 01CE 	{
; 0000 01CF 
; 0000 01D0 	if(step==s1)
; 0000 01D1 		{
; 0000 01D2 		temp|=(1<<PP1)|(1<<PP2);
; 0000 01D3 
; 0000 01D4 		cnt_del--;
; 0000 01D5 		if(cnt_del==0)
; 0000 01D6 			{
; 0000 01D7 			if(ee_vacuum_mode==evmOFF)
; 0000 01D8 				{
; 0000 01D9 				goto lbl_0002;
; 0000 01DA 				}
; 0000 01DB 			else step=s2;
; 0000 01DC 			}
; 0000 01DD 		}
; 0000 01DE 
; 0000 01DF 	else if(step==s2)
; 0000 01E0 		{
; 0000 01E1 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
; 0000 01E2 
; 0000 01E3           if(!bVR)goto step_contr_end;
; 0000 01E4 lbl_0002:
; 0000 01E5 
; 0000 01E6 		cnt_del=30;
; 0000 01E7 
; 0000 01E8 
; 0000 01E9 		step=s3;
; 0000 01EA 		}
; 0000 01EB 
; 0000 01EC 	else if(step==s3)
; 0000 01ED 		{
; 0000 01EE 		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
; 0000 01EF 
; 0000 01F0 		cnt_del--;
; 0000 01F1 		if(cnt_del==0)
; 0000 01F2 			{
; 0000 01F3 			step=s4;
; 0000 01F4 			}
; 0000 01F5 		}
; 0000 01F6 
; 0000 01F7 	else if(step==s4)
; 0000 01F8 		{
; 0000 01F9 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
; 0000 01FA 
; 0000 01FB           if(!bMD1)goto step_contr_end;
; 0000 01FC          	cnt_del=30;
; 0000 01FD 		step=s5;
; 0000 01FE 		}
; 0000 01FF 
; 0000 0200 	else if(step==s5)
; 0000 0201 		{
; 0000 0202 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);
; 0000 0203 
; 0000 0204 		cnt_del--;
; 0000 0205 		if(cnt_del==0)
; 0000 0206 			{
; 0000 0207 			step=s6;
; 0000 0208 			cnt_del=30;
; 0000 0209 			}
; 0000 020A 		}
; 0000 020B 
; 0000 020C 	else if(step==s6)
; 0000 020D 		{
; 0000 020E 		temp|=(1<<PP1)|(1<<PP3);
; 0000 020F 
; 0000 0210 		cnt_del--;
; 0000 0211 		if(cnt_del==0)
; 0000 0212 			{
; 0000 0213 			step=s7;
; 0000 0214 
; 0000 0215 		cnt_del=150;
; 0000 0216 
; 0000 0217 
; 0000 0218 			}
; 0000 0219 		}
; 0000 021A 
; 0000 021B 	else if(step==s7)
; 0000 021C 		{
; 0000 021D 		temp|=(1<<PP1)|(1<<PP2);
; 0000 021E 
; 0000 021F 		cnt_del--;
; 0000 0220 		if(cnt_del==0)
; 0000 0221 			{
; 0000 0222 			step=s8;
; 0000 0223 			cnt_del=30;
; 0000 0224 			}
; 0000 0225 		}
; 0000 0226 	else if(step==s8)
; 0000 0227 		{
; 0000 0228 		temp|=(1<<PP2);
; 0000 0229 
; 0000 022A 		cnt_del--;
; 0000 022B 		if(cnt_del==0)
; 0000 022C 			{
; 0000 022D 			step=sOFF;
; 0000 022E 			}
; 0000 022F 		}
; 0000 0230 	}
; 0000 0231 
; 0000 0232 if(prog==p3)
; 0000 0233 	{
; 0000 0234 
; 0000 0235 	if(step==s1)
; 0000 0236 		{
; 0000 0237 		temp|=(1<<PP1)|(1<<PP2);
; 0000 0238 
; 0000 0239 		cnt_del--;
; 0000 023A 		if(cnt_del==0)
; 0000 023B 			{
; 0000 023C 			if(ee_vacuum_mode==evmOFF)
; 0000 023D 				{
; 0000 023E 				goto lbl_0003;
; 0000 023F 				}
; 0000 0240 			else step=s2;
; 0000 0241 			}
; 0000 0242 		}
; 0000 0243 
; 0000 0244 	else if(step==s2)
; 0000 0245 		{
; 0000 0246 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
; 0000 0247 
; 0000 0248           if(!bVR)goto step_contr_end;
; 0000 0249 lbl_0003:
; 0000 024A 
; 0000 024B 		cnt_del=80;
; 0000 024C 
; 0000 024D 		step=s3;
; 0000 024E 		}
; 0000 024F 
; 0000 0250 	else if(step==s3)
; 0000 0251 		{
; 0000 0252 		temp|=(1<<PP1)|(1<<PP3);
; 0000 0253 
; 0000 0254 		cnt_del--;
; 0000 0255 		if(cnt_del==0)
; 0000 0256 			{
; 0000 0257 			step=s4;
; 0000 0258 			cnt_del=120;
; 0000 0259 			}
; 0000 025A 		}
; 0000 025B 
; 0000 025C 	else if(step==s4)
; 0000 025D 		{
; 0000 025E 		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<PP5);
; 0000 025F 
; 0000 0260 		cnt_del--;
; 0000 0261 		if(cnt_del==0)
; 0000 0262 			{
; 0000 0263 			step=s5;
; 0000 0264 
; 0000 0265 
; 0000 0266 
; 0000 0267 		cnt_del=150;
; 0000 0268 
; 0000 0269 	//	step=s5;
; 0000 026A 	}
; 0000 026B 		}
; 0000 026C 
; 0000 026D 	else if(step==s5)
; 0000 026E 		{
; 0000 026F 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<PP5);
; 0000 0270 
; 0000 0271 		cnt_del--;
; 0000 0272 		if(cnt_del==0)
; 0000 0273 			{
; 0000 0274 			step=s6;
; 0000 0275 			cnt_del=30;
; 0000 0276 			}
; 0000 0277 		}
; 0000 0278 
; 0000 0279 	else if(step==s6)
; 0000 027A 		{
; 0000 027B 		temp|=(1<<PP2)|(1<<PP4)|(1<<PP5);
; 0000 027C 
; 0000 027D 		cnt_del--;
; 0000 027E 		if(cnt_del==0)
; 0000 027F 			{
; 0000 0280 			step=s7;
; 0000 0281 			cnt_del=30;
; 0000 0282 			}
; 0000 0283 		}
; 0000 0284 
; 0000 0285 	else if(step==s7)
; 0000 0286 		{
; 0000 0287 		temp|=(1<<PP2);
; 0000 0288 
; 0000 0289 		cnt_del--;
; 0000 028A 		if(cnt_del==0)
; 0000 028B 			{
; 0000 028C 			step=sOFF;
; 0000 028D 			}
; 0000 028E 		}
; 0000 028F 
; 0000 0290 	}
; 0000 0291 */
; 0000 0292 step_contr_end:
; 0000 0293 
; 0000 0294 PORTB=~temp;
	MOV  R30,R17
	COM  R30
	OUT  0x18,R30
; 0000 0295 }
	LD   R17,Y+
	RET
; .FEND
;
;
;//-----------------------------------------------
;void bin2bcd_int(unsigned int in)
; 0000 029A {
; 0000 029B char i;
; 0000 029C for(i=3;i>0;i--)
;	in -> Y+1
;	i -> R17
; 0000 029D 	{
; 0000 029E 	dig[i]=in%10;
; 0000 029F 	in/=10;
; 0000 02A0 	}
; 0000 02A1 }
;
;//-----------------------------------------------
;void bcd2ind(char s)
; 0000 02A5 {
; 0000 02A6 char i;
; 0000 02A7 bZ=1;
;	s -> Y+1
;	i -> R17
; 0000 02A8 for (i=0;i<5;i++)
; 0000 02A9 	{
; 0000 02AA 	if(bZ&&(!dig[i-1])&&(i<4))
; 0000 02AB 		{
; 0000 02AC 		if((4-i)>s)
; 0000 02AD 			{
; 0000 02AE 			ind_out[i-1]=DIGISYM[10];
; 0000 02AF 			}
; 0000 02B0 		else ind_out[i-1]=DIGISYM[0];
; 0000 02B1 		}
; 0000 02B2 	else
; 0000 02B3 		{
; 0000 02B4 		ind_out[i-1]=DIGISYM[dig[i-1]];
; 0000 02B5 		bZ=0;
; 0000 02B6 		}
; 0000 02B7 
; 0000 02B8 	if(s)
; 0000 02B9 		{
; 0000 02BA 		ind_out[3-s]&=0b01111111;
; 0000 02BB 		}
; 0000 02BC 
; 0000 02BD 	}
; 0000 02BE }
;//-----------------------------------------------
;void int2ind(unsigned int in,char s)
; 0000 02C1 {
; 0000 02C2 bin2bcd_int(in);
;	in -> Y+1
;	s -> Y+0
; 0000 02C3 bcd2ind(s);
; 0000 02C4 
; 0000 02C5 }
;
;
;//-----------------------------------------------
;void led_hndl(void)
; 0000 02CA {
_led_hndl:
; .FSTART _led_hndl
; 0000 02CB ind_out[4]=DIGISYM[10];
	__POINTW1FN _DIGISYM,10
	LPM  R0,Z
	__PUTBR0MN _ind_out,4
; 0000 02CC 
; 0000 02CD ind_out[4]&=~(1<<LED_POW_ON);
	__POINTW2MN _ind_out,4
	LD   R30,X
	ANDI R30,0xDF
	ST   X,R30
; 0000 02CE 
; 0000 02CF if(step!=sOFF)
	TST  R10
	BREQ _0x55
; 0000 02D0 	{
; 0000 02D1 	ind_out[4]&=~(1<<LED_WRK);
	__POINTW2MN _ind_out,4
	LD   R30,X
	ANDI R30,0xBF
	RJMP _0x87
; 0000 02D2 	}
; 0000 02D3 else ind_out[4]|=(1<<LED_WRK);
_0x55:
	__POINTW2MN _ind_out,4
	LD   R30,X
	ORI  R30,0x40
_0x87:
	ST   X,R30
; 0000 02D4 
; 0000 02D5 
; 0000 02D6 if(step==sOFF)
	TST  R10
	BRNE _0x57
; 0000 02D7 	{
; 0000 02D8  	if(bERR)
	SBRS R3,1
	RJMP _0x58
; 0000 02D9 		{
; 0000 02DA 		ind_out[4]&=~(1<<LED_ERROR);
	__POINTW2MN _ind_out,4
	LD   R30,X
	ANDI R30,0xFE
	RJMP _0x88
; 0000 02DB 		}
; 0000 02DC 	else
_0x58:
; 0000 02DD 		{
; 0000 02DE 		ind_out[4]|=(1<<LED_ERROR);
	__POINTW2MN _ind_out,4
	LD   R30,X
	ORI  R30,1
_0x88:
	ST   X,R30
; 0000 02DF 		}
; 0000 02E0      }
; 0000 02E1 else ind_out[4]|=(1<<LED_ERROR);
	RJMP _0x5A
_0x57:
	__POINTW2MN _ind_out,4
	LD   R30,X
	ORI  R30,1
	ST   X,R30
; 0000 02E2 
; 0000 02E3 /* 	if(bMD1)
; 0000 02E4 		{
; 0000 02E5 		ind_out[4]&=~(1<<LED_ERROR);
; 0000 02E6 		}
; 0000 02E7 	else
; 0000 02E8 		{
; 0000 02E9 		ind_out[4]|=(1<<LED_ERROR);
; 0000 02EA 		} */
; 0000 02EB 
; 0000 02EC //if(bERR)ind_out[4]&=~(1<<LED_ERROR);
; 0000 02ED if(ee_vacuum_mode==evmON)ind_out[4]&=~(1<<LED_VACUUM);
_0x5A:
	LDI  R26,LOW(_ee_vacuum_mode)
	LDI  R27,HIGH(_ee_vacuum_mode)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x55)
	BRNE _0x5B
	__POINTW2MN _ind_out,4
	LD   R30,X
	ANDI R30,0x7F
	RJMP _0x89
; 0000 02EE else ind_out[4]|=(1<<LED_VACUUM);
_0x5B:
	__POINTW2MN _ind_out,4
	LD   R30,X
	ORI  R30,0x80
_0x89:
	ST   X,R30
; 0000 02EF 
; 0000 02F0 if(prog==p1) ind_out[4]&=~(1<<LED_PROG1);
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x5D
	__POINTW2MN _ind_out,4
	LD   R30,X
	ANDI R30,0xEF
	RJMP _0x8A
; 0000 02F1 else if(prog==p2) ind_out[4]&=~(1<<LED_PROG2);
_0x5D:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x5F
	__POINTW2MN _ind_out,4
	LD   R30,X
	ANDI R30,0xFB
	RJMP _0x8A
; 0000 02F2 else if(prog==p3) ind_out[4]&=~(1<<LED_PROG3);
_0x5F:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0x61
	__POINTW2MN _ind_out,4
	LD   R30,X
	ANDI R30,0XF7
	RJMP _0x8A
; 0000 02F3 else if(prog==p4) ind_out[4]&=~(1<<LED_PROG4);
_0x61:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0x63
	__POINTW2MN _ind_out,4
	LD   R30,X
	ANDI R30,0xFD
_0x8A:
	ST   X,R30
; 0000 02F4 
; 0000 02F5 if(ind==iPr_sel)
_0x63:
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0x64
; 0000 02F6 	{
; 0000 02F7 	if(bFL5)ind_out[4]|=(1<<LED_PROG1)|(1<<LED_PROG2)|(1<<LED_PROG3)|(1<<LED_PROG4);
	SBRS R3,0
	RJMP _0x65
	__POINTW2MN _ind_out,4
	LD   R30,X
	ORI  R30,LOW(0x1E)
	ST   X,R30
; 0000 02F8 	}
_0x65:
; 0000 02F9 
; 0000 02FA if(ind==iVr)
_0x64:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0x66
; 0000 02FB 	{
; 0000 02FC 	if(bFL5)ind_out[4]|=(1<<LED_POW_ON);
	SBRS R3,0
	RJMP _0x67
	__POINTW2MN _ind_out,4
	LD   R30,X
	ORI  R30,0x20
	ST   X,R30
; 0000 02FD 	}
_0x67:
; 0000 02FE }
_0x66:
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
; 0000 0311 {
; 0000 0312 DDRD&=0b00000111;
; 0000 0313 PORTD|=0b11111000;
; 0000 0314 
; 0000 0315 but_port|=(but_mask^0xff);
; 0000 0316 but_dir&=but_mask;
; 0000 0317 #asm
; 0000 0318 nop
; 0000 0319 nop
; 0000 031A nop
; 0000 031B nop
; 0000 031C #endasm
; 0000 031D 
; 0000 031E but_n=but_pin|but_mask;
; 0000 031F 
; 0000 0320 if((but_n==no_but)||(but_n!=but_s))
; 0000 0321  	{
; 0000 0322  	speed=0;
; 0000 0323    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
; 0000 0324   		{
; 0000 0325    	     n_but=1;
; 0000 0326           but=but_s;
; 0000 0327           }
; 0000 0328    	if (but1_cnt>=but_onL_temp)
; 0000 0329   		{
; 0000 032A    	     n_but=1;
; 0000 032B           but=but_s&0b11111101;
; 0000 032C           }
; 0000 032D     	l_but=0;
; 0000 032E    	but_onL_temp=but_onL;
; 0000 032F     	but0_cnt=0;
; 0000 0330   	but1_cnt=0;
; 0000 0331      goto but_drv_out;
; 0000 0332   	}
; 0000 0333 
; 0000 0334 if(but_n==but_s)
; 0000 0335  	{
; 0000 0336   	but0_cnt++;
; 0000 0337   	if(but0_cnt>=but_on)
; 0000 0338   		{
; 0000 0339    		but0_cnt=0;
; 0000 033A    		but1_cnt++;
; 0000 033B    		if(but1_cnt>=but_onL_temp)
; 0000 033C    			{
; 0000 033D     			but=but_s&0b11111101;
; 0000 033E     			but1_cnt=0;
; 0000 033F     			n_but=1;
; 0000 0340     			l_but=1;
; 0000 0341 			if(speed)
; 0000 0342 				{
; 0000 0343     				but_onL_temp=but_onL_temp>>1;
; 0000 0344         			if(but_onL_temp<=2) but_onL_temp=2;
; 0000 0345 				}
; 0000 0346    			}
; 0000 0347   		}
; 0000 0348  	}
; 0000 0349 but_drv_out:
; 0000 034A but_s=but_n;
; 0000 034B but_port|=(but_mask^0xff);
; 0000 034C but_dir&=but_mask;
; 0000 034D }
;
;
;//***********************************************
;//***********************************************
;//***********************************************
;//***********************************************
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0355 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0356 TCCR0=0x02;
	RCALL SUBOPT_0x3
; 0000 0357 TCNT0=-208;
; 0000 0358 OCR0=0x00;
; 0000 0359 
; 0000 035A 
; 0000 035B b600Hz=1;
	SET
	BLD  R2,0
; 0000 035C if(++t0_cnt0>=6)
	INC  R5
	LDI  R30,LOW(6)
	CP   R5,R30
	BRLO _0x77
; 0000 035D 	{
; 0000 035E 	t0_cnt0=0;
	CLR  R5
; 0000 035F 	b100Hz=1;
	BLD  R2,1
; 0000 0360 	}
; 0000 0361 
; 0000 0362 if(++t0_cnt1>=60)
_0x77:
	INC  R4
	LDI  R30,LOW(60)
	CP   R4,R30
	BRLO _0x78
; 0000 0363 	{
; 0000 0364 	t0_cnt1=0;
	CLR  R4
; 0000 0365 	b10Hz=1;
	SET
	BLD  R2,2
; 0000 0366 
; 0000 0367 	if(++t0_cnt2>=2)
	INC  R7
	LDI  R30,LOW(2)
	CP   R7,R30
	BRLO _0x79
; 0000 0368 		{
; 0000 0369 		t0_cnt2=0;
	CLR  R7
; 0000 036A 		bFL5=!bFL5;
	LDI  R30,LOW(1)
	EOR  R3,R30
; 0000 036B 		}
; 0000 036C 
; 0000 036D 	if(++t0_cnt3>=5)
_0x79:
	INC  R6
	LDI  R30,LOW(5)
	CP   R6,R30
	BRLO _0x7A
; 0000 036E 		{
; 0000 036F 		t0_cnt3=0;
	CLR  R6
; 0000 0370 		bFL2=!bFL2;
	LDI  R30,LOW(128)
	EOR  R2,R30
; 0000 0371 		}
; 0000 0372 	}
_0x7A:
; 0000 0373 }
_0x78:
	LD   R30,Y+
	OUT  SREG,R30
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
; 0000 037B {
_main:
; .FSTART _main
; 0000 037C 
; 0000 037D PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 037E DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 037F 
; 0000 0380 PORTB=0xff;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0381 DDRB=0xFF;
	OUT  0x17,R30
; 0000 0382 
; 0000 0383 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0384 DDRC=0x00;
	OUT  0x14,R30
; 0000 0385 
; 0000 0386 
; 0000 0387 PORTD=0x00;
	OUT  0x12,R30
; 0000 0388 DDRD=0x00;
	OUT  0x11,R30
; 0000 0389 
; 0000 038A 
; 0000 038B TCCR0=0x02;
	RCALL SUBOPT_0x3
; 0000 038C TCNT0=-208;
; 0000 038D OCR0=0x00;
; 0000 038E 
; 0000 038F TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0390 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0391 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0392 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0393 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0394 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0395 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0396 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0397 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0398 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0399 
; 0000 039A 
; 0000 039B ASSR=0x00;
	OUT  0x22,R30
; 0000 039C TCCR2=0x00;
	OUT  0x25,R30
; 0000 039D TCNT2=0x00;
	OUT  0x24,R30
; 0000 039E OCR2=0x00;
	OUT  0x23,R30
; 0000 039F 
; 0000 03A0 MCUCR=0x00;
	OUT  0x35,R30
; 0000 03A1 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 03A2 
; 0000 03A3 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 03A4 
; 0000 03A5 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 03A6 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 03A7 
; 0000 03A8 #asm("sei")
	sei
; 0000 03A9 PORTB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 03AA DDRB=0xFF;
	OUT  0x17,R30
; 0000 03AB DDRD.1=1;
	SBI  0x11,1
; 0000 03AC PORTD.1=1;
	SBI  0x12,1
; 0000 03AD 
; 0000 03AE ind=iMn;
	CLR  R13
; 0000 03AF prog_drv();
	RCALL _prog_drv
; 0000 03B0 led_hndl();
	RCALL _led_hndl
; 0000 03B1 while (1)
_0x7F:
; 0000 03B2       {
; 0000 03B3       if(b600Hz)
	SBRS R2,0
	RJMP _0x82
; 0000 03B4 		{
; 0000 03B5 		b600Hz=0;
	CLT
	BLD  R2,0
; 0000 03B6 
; 0000 03B7 		}
; 0000 03B8       if(b100Hz)
_0x82:
	SBRS R2,1
	RJMP _0x83
; 0000 03B9 		{
; 0000 03BA 		b100Hz=0;
	CLT
	BLD  R2,1
; 0000 03BB 	    	in_drv();
	RCALL _in_drv
; 0000 03BC           mdvr_drv();
	RCALL _mdvr_drv
; 0000 03BD           step_contr();
	RCALL _step_contr
; 0000 03BE 		}
; 0000 03BF 	if(b10Hz)
_0x83:
	SBRS R2,2
	RJMP _0x84
; 0000 03C0 		{
; 0000 03C1 		b10Hz=0;
	CLT
	BLD  R2,2
; 0000 03C2 		prog_drv();
	RCALL _prog_drv
; 0000 03C3 
; 0000 03C4           led_hndl();
	RCALL _led_hndl
; 0000 03C5 
; 0000 03C6           }
; 0000 03C7 
; 0000 03C8       };
_0x84:
	RJMP _0x7F
; 0000 03C9 }
_0x85:
	RJMP _0x85
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
_bKL_MAIN:
	.BYTE 0x1
_bD1:
	.BYTE 0x1
_cnt_d1:
	.BYTE 0x1
_cnt_d2:
	.BYTE 0x1
_cnt_kl_main:
	.BYTE 0x1
_cnt_kl1:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(3)
	MOV  R10,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(1)
	MOV  R10,R30
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
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
SUBOPT_0x3:
	LDI  R30,LOW(2)
	OUT  0x33,R30
	LDI  R30,LOW(48)
	OUT  0x32,R30
	LDI  R30,LOW(0)
	OUT  0x3C,R30
	RET


	.CSEG
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
