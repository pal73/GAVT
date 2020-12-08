
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
;#define D_1	5
;//Датчик нижний
;#define D_2	 0
;//Главная клавиша, включает рабочий цикл
;#define KL_MAIN	6
;//Вторая клавиша, включает ручную перекачку
;#define KL1	2
;
;#define PP1	0
;#define PP2	1
;#define LED_PRON	6
;#define DV	7
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
;enum{sOFF=0,sUP1,sUP2,sDN1,sDN2,sUP1m,sUP2m,sDN1m,sDN2m}step=sOFF;
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
; 0000 0090 if(!(in_word&(1<<D_1)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x20)
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
; 0000 00A3 if(!(in_word&(1<<D_2)))
	LDS  R30,_in_word
	ANDI R30,LOW(0x1)
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
	ANDI R30,LOW(0x40)
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
	ANDI R30,LOW(0x4)
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
; 0000 00E3 static char temp;
; 0000 00E4 //temp=0;
; 0000 00E5 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 00E6 
; 0000 00E7 
; 0000 00E8 if(!bKL_MAIN)
	LDS  R30,_bKL_MAIN
	CPI  R30,0
	BREQ PC+2
	RJMP _0x20
; 0000 00E9     {
; 0000 00EA     temp=0;
	LDI  R30,LOW(0)
	STS  _temp_S0000003000,R30
; 0000 00EB     if(step==sOFF)
	TST  R10
	BRNE _0x21
; 0000 00EC         {
; 0000 00ED         if((!bD1)&&(!bD2))
	LDS  R30,_bD1
	CPI  R30,0
	BRNE _0x23
	SBRS R3,2
	RJMP _0x24
_0x23:
	RJMP _0x22
_0x24:
; 0000 00EE             {
; 0000 00EF             step=sDN1;
	RCALL SUBOPT_0x0
; 0000 00F0             cnt_del=20;
; 0000 00F1             }
; 0000 00F2         if((bD1)&&(bD2))
_0x22:
	LDS  R30,_bD1
	CPI  R30,0
	BREQ _0x26
	SBRC R3,2
	RJMP _0x27
_0x26:
	RJMP _0x25
_0x27:
; 0000 00F3             {
; 0000 00F4             step=sUP1;
	RCALL SUBOPT_0x1
; 0000 00F5             cnt_del=20;
; 0000 00F6             }
; 0000 00F7         }
_0x25:
; 0000 00F8     else if(step==sUP1)
	RJMP _0x28
_0x21:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x29
; 0000 00F9         {
; 0000 00FA         temp|=(1<<PP1);
	RCALL SUBOPT_0x2
; 0000 00FB         cnt_del--;
; 0000 00FC 		if(cnt_del==0)
	BRNE _0x2A
; 0000 00FD             {
; 0000 00FE             step=sUP2;
	LDI  R30,LOW(2)
	MOV  R10,R30
; 0000 00FF             }
; 0000 0100         }
_0x2A:
; 0000 0101     else if(step==sUP2)
	RJMP _0x2B
_0x29:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x2C
; 0000 0102         {
; 0000 0103         if((!bD1)&&(!bD2))
	LDS  R30,_bD1
	CPI  R30,0
	BRNE _0x2E
	SBRS R3,2
	RJMP _0x2F
_0x2E:
	RJMP _0x2D
_0x2F:
; 0000 0104             {
; 0000 0105             step=sDN1;
	RCALL SUBOPT_0x0
; 0000 0106             cnt_del=20;
; 0000 0107             }
; 0000 0108         }
_0x2D:
; 0000 0109     else if(step==sDN1)
	RJMP _0x30
_0x2C:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x31
; 0000 010A         {
; 0000 010B         temp|=(1<<PP1);
	RCALL SUBOPT_0x2
; 0000 010C         cnt_del--;
; 0000 010D 		if(cnt_del==0)
	BRNE _0x32
; 0000 010E             {
; 0000 010F             step=sDN2;
	LDI  R30,LOW(4)
	MOV  R10,R30
; 0000 0110             }
; 0000 0111         }
_0x32:
; 0000 0112     else if(step==sDN2)
	RJMP _0x33
_0x31:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0x34
; 0000 0113         {
; 0000 0114         temp|=(1<<PP1)|(1<<DV);
	LDS  R30,_temp_S0000003000
	ORI  R30,LOW(0x81)
	STS  _temp_S0000003000,R30
; 0000 0115         if((bD1)&&(bD2))
	LDS  R30,_bD1
	CPI  R30,0
	BREQ _0x36
	SBRC R3,2
	RJMP _0x37
_0x36:
	RJMP _0x35
_0x37:
; 0000 0116             {
; 0000 0117             step=sUP1;
	RCALL SUBOPT_0x1
; 0000 0118             cnt_del=20;
; 0000 0119             }
; 0000 011A         }
_0x35:
; 0000 011B     else if(step==sUP1m)
	RJMP _0x38
_0x34:
	LDI  R30,LOW(5)
	CP   R30,R10
	BRNE _0x39
; 0000 011C         {
; 0000 011D         temp|=(1<<PP2);
	RCALL SUBOPT_0x3
; 0000 011E         if(cnt_del==0)cnt_del=20;
	BRNE _0x3A
	RCALL SUBOPT_0x4
; 0000 011F         cnt_del--;
_0x3A:
	RCALL SUBOPT_0x5
; 0000 0120 		if(cnt_del==0)
	BRNE _0x3B
; 0000 0121             {
; 0000 0122             step=sOFF;
	CLR  R10
; 0000 0123             }
; 0000 0124         }
_0x3B:
; 0000 0125     else if(step==sDN1m)
	RJMP _0x3C
_0x39:
	LDI  R30,LOW(7)
	CP   R30,R10
	BRNE _0x3D
; 0000 0126         {
; 0000 0127         temp|=(1<<PP2);
	RCALL SUBOPT_0x3
; 0000 0128         if(cnt_del==0)cnt_del=20;
	BRNE _0x3E
	RCALL SUBOPT_0x4
; 0000 0129         cnt_del--;
_0x3E:
	RCALL SUBOPT_0x5
; 0000 012A 		if(cnt_del==0)
	BRNE _0x3F
; 0000 012B             {
; 0000 012C             step=sOFF;
	CLR  R10
; 0000 012D             }
; 0000 012E         }
_0x3F:
; 0000 012F     else if(step==sDN2m)
	RJMP _0x40
_0x3D:
	LDI  R30,LOW(8)
	CP   R30,R10
	BRNE _0x41
; 0000 0130         {
; 0000 0131         temp|=(1<<PP2)|(1<<DV);
	LDS  R30,_temp_S0000003000
	ORI  R30,LOW(0x82)
	RCALL SUBOPT_0x6
; 0000 0132         if(cnt_del==0)cnt_del=20;
	BRNE _0x42
	RCALL SUBOPT_0x4
; 0000 0133         cnt_del--;
_0x42:
	RCALL SUBOPT_0x5
; 0000 0134 		if(cnt_del==0)
	BRNE _0x43
; 0000 0135             {
; 0000 0136             step=sUP1m;
	LDI  R30,LOW(5)
	MOV  R10,R30
; 0000 0137             cnt_del=20;
	RCALL SUBOPT_0x4
; 0000 0138             }
; 0000 0139         }
_0x43:
; 0000 013A     temp|=(1<<LED_PRON);
_0x41:
_0x40:
_0x3C:
_0x38:
_0x33:
_0x30:
_0x2B:
_0x28:
	LDS  R30,_temp_S0000003000
	ORI  R30,0x40
	STS  _temp_S0000003000,R30
; 0000 013B 
; 0000 013C     //temp=~temp;
; 0000 013D    // temp^=(1<<PP1);
; 0000 013E    //if(bD1)temp=0xff;
; 0000 013F    //else temp=0x00;
; 0000 0140     }
; 0000 0141 else
	RJMP _0x44
_0x20:
; 0000 0142     {
; 0000 0143     temp=0;
	LDI  R30,LOW(0)
	STS  _temp_S0000003000,R30
; 0000 0144     if(step==sOFF)
	TST  R10
	BRNE _0x45
; 0000 0145         {
; 0000 0146         if(bKL1)
	SBRS R3,3
	RJMP _0x46
; 0000 0147             {
; 0000 0148             step=sDN1m;
	LDI  R30,LOW(7)
	MOV  R10,R30
; 0000 0149             cnt_del=20;
	RCALL SUBOPT_0x4
; 0000 014A             }
; 0000 014B         }
_0x46:
; 0000 014C     else if(step==sUP1m)
	RJMP _0x47
_0x45:
	LDI  R30,LOW(5)
	CP   R30,R10
	BRNE _0x48
; 0000 014D         {
; 0000 014E         temp|=(1<<PP2);
	RCALL SUBOPT_0x7
; 0000 014F         cnt_del--;
; 0000 0150 		if(cnt_del==0)
	BRNE _0x49
; 0000 0151             {
; 0000 0152             step=sUP2m;
	LDI  R30,LOW(6)
	MOV  R10,R30
; 0000 0153             }
; 0000 0154         }
_0x49:
; 0000 0155     else if(step==sUP2m)
	RJMP _0x4A
_0x48:
	LDI  R30,LOW(6)
	CP   R30,R10
	BRNE _0x4B
; 0000 0156         {
; 0000 0157         if(bKL1)
	SBRS R3,3
	RJMP _0x4C
; 0000 0158             {
; 0000 0159             step=sDN1m;
	LDI  R30,LOW(7)
	MOV  R10,R30
; 0000 015A             cnt_del=20;
	RCALL SUBOPT_0x4
; 0000 015B             }
; 0000 015C         }
_0x4C:
; 0000 015D     else if(step==sDN1m)
	RJMP _0x4D
_0x4B:
	LDI  R30,LOW(7)
	CP   R30,R10
	BRNE _0x4E
; 0000 015E         {
; 0000 015F         temp|=(1<<PP2);
	RCALL SUBOPT_0x7
; 0000 0160         cnt_del--;
; 0000 0161 		if(cnt_del==0)
	BRNE _0x4F
; 0000 0162             {
; 0000 0163             step=sDN2m;
	LDI  R30,LOW(8)
	MOV  R10,R30
; 0000 0164             }
; 0000 0165         }
_0x4F:
; 0000 0166     else if(step==sDN2m)
	RJMP _0x50
_0x4E:
	LDI  R30,LOW(8)
	CP   R30,R10
	BRNE _0x51
; 0000 0167         {
; 0000 0168         temp|=(1<<PP2)|(1<<DV);
	LDS  R30,_temp_S0000003000
	ORI  R30,LOW(0x82)
	STS  _temp_S0000003000,R30
; 0000 0169         if(!bKL1)
	SBRC R3,3
	RJMP _0x52
; 0000 016A             {
; 0000 016B             step=sUP1m;
	LDI  R30,LOW(5)
	MOV  R10,R30
; 0000 016C             cnt_del=20;
	RCALL SUBOPT_0x4
; 0000 016D             }
; 0000 016E         }
_0x52:
; 0000 016F     else if(step==sUP1)
	RJMP _0x53
_0x51:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x54
; 0000 0170         {
; 0000 0171         temp|=(1<<PP1);
	LDS  R30,_temp_S0000003000
	ORI  R30,1
	RCALL SUBOPT_0x6
; 0000 0172         if(cnt_del==0)cnt_del=20;
	BRNE _0x55
	RCALL SUBOPT_0x4
; 0000 0173         cnt_del--;
_0x55:
	RCALL SUBOPT_0x5
; 0000 0174 		if(cnt_del==0)
	BRNE _0x56
; 0000 0175             {
; 0000 0176             step=sOFF;
	CLR  R10
; 0000 0177             }
; 0000 0178         }
_0x56:
; 0000 0179     else if(step==sDN1)
	RJMP _0x57
_0x54:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x58
; 0000 017A         {
; 0000 017B         temp|=(1<<PP1);
	LDS  R30,_temp_S0000003000
	ORI  R30,1
	RCALL SUBOPT_0x6
; 0000 017C         if(cnt_del==0)cnt_del=20;
	BRNE _0x59
	RCALL SUBOPT_0x4
; 0000 017D         cnt_del--;
_0x59:
	RCALL SUBOPT_0x5
; 0000 017E 		if(cnt_del==0)
	BRNE _0x5A
; 0000 017F             {
; 0000 0180             step=sOFF;
	CLR  R10
; 0000 0181             }
; 0000 0182         }
_0x5A:
; 0000 0183     else if(step==sDN2)
	RJMP _0x5B
_0x58:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0x5C
; 0000 0184         {
; 0000 0185         temp|=(1<<PP1)|(1<<DV);
	LDS  R30,_temp_S0000003000
	ORI  R30,LOW(0x81)
	RCALL SUBOPT_0x6
; 0000 0186         if(cnt_del==0)cnt_del=20;
	BRNE _0x5D
	RCALL SUBOPT_0x4
; 0000 0187         cnt_del--;
_0x5D:
	RCALL SUBOPT_0x5
; 0000 0188 		if(cnt_del==0)
	BRNE _0x5E
; 0000 0189             {
; 0000 018A             step=sUP1;
	RCALL SUBOPT_0x1
; 0000 018B             cnt_del=20;
; 0000 018C             }
; 0000 018D         }
_0x5E:
; 0000 018E     //    temp^=(1<<PP2);
; 0000 018F     }
_0x5C:
_0x5B:
_0x57:
_0x53:
_0x50:
_0x4D:
_0x4A:
_0x47:
_0x44:
; 0000 0190 
; 0000 0191 
; 0000 0192 //temp|=(1<<PP2);
; 0000 0193 
; 0000 0194 PORTB=~temp;
	LDS  R30,_temp_S0000003000
	COM  R30
	OUT  0x18,R30
; 0000 0195 //PORTB=~PORTB;
; 0000 0196 }
	RET
; .FEND
;
;
;//-----------------------------------------------
;void bin2bcd_int(unsigned int in)
; 0000 019B {
; 0000 019C char i;
; 0000 019D for(i=3;i>0;i--)
;	in -> Y+1
;	i -> R17
; 0000 019E 	{
; 0000 019F 	dig[i]=in%10;
; 0000 01A0 	in/=10;
; 0000 01A1 	}
; 0000 01A2 }
;
;//-----------------------------------------------
;void bcd2ind(char s)
; 0000 01A6 {
; 0000 01A7 char i;
; 0000 01A8 bZ=1;
;	s -> Y+1
;	i -> R17
; 0000 01A9 for (i=0;i<5;i++)
; 0000 01AA 	{
; 0000 01AB 	if(bZ&&(!dig[i-1])&&(i<4))
; 0000 01AC 		{
; 0000 01AD 		if((4-i)>s)
; 0000 01AE 			{
; 0000 01AF 			ind_out[i-1]=DIGISYM[10];
; 0000 01B0 			}
; 0000 01B1 		else ind_out[i-1]=DIGISYM[0];
; 0000 01B2 		}
; 0000 01B3 	else
; 0000 01B4 		{
; 0000 01B5 		ind_out[i-1]=DIGISYM[dig[i-1]];
; 0000 01B6 		bZ=0;
; 0000 01B7 		}
; 0000 01B8 
; 0000 01B9 	if(s)
; 0000 01BA 		{
; 0000 01BB 		ind_out[3-s]&=0b01111111;
; 0000 01BC 		}
; 0000 01BD 
; 0000 01BE 	}
; 0000 01BF }
;//-----------------------------------------------
;void int2ind(unsigned int in,char s)
; 0000 01C2 {
; 0000 01C3 bin2bcd_int(in);
;	in -> Y+1
;	s -> Y+0
; 0000 01C4 bcd2ind(s);
; 0000 01C5 
; 0000 01C6 }
;
;
;//-----------------------------------------------
;void led_hndl(void)
; 0000 01CB {
_led_hndl:
; .FSTART _led_hndl
; 0000 01CC DDRC=0xff;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 01CD PORTC.3=!bD1;
	LDS  R30,_bD1
	CPI  R30,0
	BREQ _0x6C
	CBI  0x15,3
	RJMP _0x6D
_0x6C:
	SBI  0x15,3
_0x6D:
; 0000 01CE PORTC.2=!bD2;
	SBRS R3,2
	RJMP _0x6E
	CBI  0x15,2
	RJMP _0x6F
_0x6E:
	SBI  0x15,2
_0x6F:
; 0000 01CF }
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
; 0000 01E2 {
; 0000 01E3 DDRD&=0b00000111;
; 0000 01E4 PORTD|=0b11111000;
; 0000 01E5 
; 0000 01E6 but_port|=(but_mask^0xff);
; 0000 01E7 but_dir&=but_mask;
; 0000 01E8 #asm
; 0000 01E9 nop
; 0000 01EA nop
; 0000 01EB nop
; 0000 01EC nop
; 0000 01ED #endasm
; 0000 01EE 
; 0000 01EF but_n=but_pin|but_mask;
; 0000 01F0 
; 0000 01F1 if((but_n==no_but)||(but_n!=but_s))
; 0000 01F2  	{
; 0000 01F3  	speed=0;
; 0000 01F4    	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
; 0000 01F5   		{
; 0000 01F6    	     n_but=1;
; 0000 01F7           but=but_s;
; 0000 01F8           }
; 0000 01F9    	if (but1_cnt>=but_onL_temp)
; 0000 01FA   		{
; 0000 01FB    	     n_but=1;
; 0000 01FC           but=but_s&0b11111101;
; 0000 01FD           }
; 0000 01FE     	l_but=0;
; 0000 01FF    	but_onL_temp=but_onL;
; 0000 0200     	but0_cnt=0;
; 0000 0201   	but1_cnt=0;
; 0000 0202      goto but_drv_out;
; 0000 0203   	}
; 0000 0204 
; 0000 0205 if(but_n==but_s)
; 0000 0206  	{
; 0000 0207   	but0_cnt++;
; 0000 0208   	if(but0_cnt>=but_on)
; 0000 0209   		{
; 0000 020A    		but0_cnt=0;
; 0000 020B    		but1_cnt++;
; 0000 020C    		if(but1_cnt>=but_onL_temp)
; 0000 020D    			{
; 0000 020E     			but=but_s&0b11111101;
; 0000 020F     			but1_cnt=0;
; 0000 0210     			n_but=1;
; 0000 0211     			l_but=1;
; 0000 0212 			if(speed)
; 0000 0213 				{
; 0000 0214     				but_onL_temp=but_onL_temp>>1;
; 0000 0215         			if(but_onL_temp<=2) but_onL_temp=2;
; 0000 0216 				}
; 0000 0217    			}
; 0000 0218   		}
; 0000 0219  	}
; 0000 021A but_drv_out:
; 0000 021B but_s=but_n;
; 0000 021C but_port|=(but_mask^0xff);
; 0000 021D but_dir&=but_mask;
; 0000 021E }
;
;
;//***********************************************
;//***********************************************
;//***********************************************
;//***********************************************
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0226 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0227 TCCR0=0x02;
	RCALL SUBOPT_0x8
; 0000 0228 TCNT0=-208;
; 0000 0229 OCR0=0x00;
; 0000 022A 
; 0000 022B 
; 0000 022C b600Hz=1;
	SET
	BLD  R2,0
; 0000 022D if(++t0_cnt0>=6)
	INC  R5
	LDI  R30,LOW(6)
	CP   R5,R30
	BRLO _0x7F
; 0000 022E 	{
; 0000 022F 	t0_cnt0=0;
	CLR  R5
; 0000 0230 	b100Hz=1;
	BLD  R2,1
; 0000 0231 	}
; 0000 0232 
; 0000 0233 if(++t0_cnt1>=60)
_0x7F:
	INC  R4
	LDI  R30,LOW(60)
	CP   R4,R30
	BRLO _0x80
; 0000 0234 	{
; 0000 0235 	t0_cnt1=0;
	CLR  R4
; 0000 0236 	b10Hz=1;
	SET
	BLD  R2,2
; 0000 0237 
; 0000 0238 	if(++t0_cnt2>=2)
	INC  R7
	LDI  R30,LOW(2)
	CP   R7,R30
	BRLO _0x81
; 0000 0239 		{
; 0000 023A 		t0_cnt2=0;
	CLR  R7
; 0000 023B 		bFL5=!bFL5;
	LDI  R30,LOW(1)
	EOR  R3,R30
; 0000 023C 		}
; 0000 023D 
; 0000 023E 	if(++t0_cnt3>=5)
_0x81:
	INC  R6
	LDI  R30,LOW(5)
	CP   R6,R30
	BRLO _0x82
; 0000 023F 		{
; 0000 0240 		t0_cnt3=0;
	CLR  R6
; 0000 0241 		bFL2=!bFL2;
	LDI  R30,LOW(128)
	EOR  R2,R30
; 0000 0242 		}
; 0000 0243 	}
_0x82:
; 0000 0244 }
_0x80:
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
; 0000 024C {
_main:
; .FSTART _main
; 0000 024D 
; 0000 024E PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 024F DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0250 
; 0000 0251 PORTB=0xff;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0252 DDRB=0xFF;
	OUT  0x17,R30
; 0000 0253 
; 0000 0254 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0255 DDRC=0x00;
	OUT  0x14,R30
; 0000 0256 
; 0000 0257 
; 0000 0258 PORTD=0x00;
	OUT  0x12,R30
; 0000 0259 DDRD=0x00;
	OUT  0x11,R30
; 0000 025A 
; 0000 025B 
; 0000 025C TCCR0=0x02;
	RCALL SUBOPT_0x8
; 0000 025D TCNT0=-208;
; 0000 025E OCR0=0x00;
; 0000 025F 
; 0000 0260 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0261 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0262 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0263 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0264 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0265 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0266 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0267 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0268 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0269 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 026A 
; 0000 026B 
; 0000 026C ASSR=0x00;
	OUT  0x22,R30
; 0000 026D TCCR2=0x00;
	OUT  0x25,R30
; 0000 026E TCNT2=0x00;
	OUT  0x24,R30
; 0000 026F OCR2=0x00;
	OUT  0x23,R30
; 0000 0270 
; 0000 0271 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0272 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0273 
; 0000 0274 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0275 
; 0000 0276 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0277 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0278 
; 0000 0279 #asm("sei")
	sei
; 0000 027A PORTB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 027B DDRB=0xFF;
	OUT  0x17,R30
; 0000 027C DDRD.1=1;
	SBI  0x11,1
; 0000 027D PORTD.1=1;
	SBI  0x12,1
; 0000 027E 
; 0000 027F ind=iMn;
	CLR  R13
; 0000 0280 prog_drv();
	RCALL _prog_drv
; 0000 0281 led_hndl();
	RCALL _led_hndl
; 0000 0282 while (1)
_0x87:
; 0000 0283       {
; 0000 0284       if(b600Hz)
	SBRS R2,0
	RJMP _0x8A
; 0000 0285 		{
; 0000 0286 		b600Hz=0;
	CLT
	BLD  R2,0
; 0000 0287 
; 0000 0288 		}
; 0000 0289       if(b100Hz)
_0x8A:
	SBRS R2,1
	RJMP _0x8B
; 0000 028A 		{
; 0000 028B 		b100Hz=0;
	CLT
	BLD  R2,1
; 0000 028C 	    in_drv();
	RCALL _in_drv
; 0000 028D         mdvr_drv();
	RCALL _mdvr_drv
; 0000 028E 
; 0000 028F 		}
; 0000 0290 	if(b10Hz)
_0x8B:
	SBRS R2,2
	RJMP _0x8C
; 0000 0291 		{
; 0000 0292 		b10Hz=0;
	CLT
	BLD  R2,2
; 0000 0293 		prog_drv();
	RCALL _prog_drv
; 0000 0294 
; 0000 0295         led_hndl();
	RCALL _led_hndl
; 0000 0296         step_contr();
	RCALL _step_contr
; 0000 0297 
; 0000 0298        // bD1=1;
; 0000 0299        // bD2=!bD2;
; 0000 029A         }
; 0000 029B 
; 0000 029C       };
_0x8C:
	RJMP _0x87
; 0000 029D }
_0x8D:
	RJMP _0x8D
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
_temp_S0000003000:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2:
	LDS  R30,_temp_S0000003000
	ORI  R30,1
	STS  _temp_S0000003000,R30
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	LDS  R30,_temp_S0000003000
	ORI  R30,2
	STS  _temp_S0000003000,R30
	LDS  R30,_cnt_del
	LDS  R31,_cnt_del+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	STS  _cnt_del,R30
	STS  _cnt_del+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x5:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x6:
	STS  _temp_S0000003000,R30
	LDS  R30,_cnt_del
	LDS  R31,_cnt_del+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	LDS  R30,_temp_S0000003000
	ORI  R30,2
	STS  _temp_S0000003000,R30
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
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
