;CodeVisionAVR C Compiler V1.24.1d Standard
;(C) Copyright 1998-2004 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.ro
;e-mail:office@hpinfotech.ro

;Chip type           : AT90S2313
;Clock frequency     : 8,000000 MHz
;Memory model        : Tiny
;Optimize for        : Size
;(s)printf features  : int, width
;(s)scanf features   : long, width
;External SRAM size  : 0
;Data Stack size     : 50 byte(s)
;Heap size           : 0 byte(s)
;Promote char to int : No
;char is unsigned    : Yes
;8 bit enums         : Yes
;Automatic register allocation : On

	.DEVICE AT90S2313
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
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
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

	.EQU __se_bit=0x20
	.EQU __sm_mask=0x10

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
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETW1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOV  R30,R0
	MOV  R31,R1
	.ENDM

	.MACRO __GETB2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOV  R26,R0
	MOV  R27,R1
	.ENDM

	.MACRO __GETBRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTBSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOV  R26,R28
	MOV  R27,R29
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
	MOV  R26,R28
	MOV  R27,R29
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
	MOV  R26,R28
	MOV  R27,R29
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

	.CSEG
	.ORG 0

	.INCLUDE "ind3.vec"
	.INCLUDE "ind3.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x80)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM
	ADIW R30,1
	MOV  R24,R0
	LPM
	ADIW R30,1
	MOV  R25,R0
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM
	ADIW R30,1
	MOV  R26,R0
	LPM
	ADIW R30,1
	MOV  R27,R0
	LPM
	ADIW R30,1
	MOV  R1,R0
	LPM
	ADIW R30,1
	MOV  R22,R30
	MOV  R23,R31
	MOV  R31,R0
	MOV  R30,R1
__GLOBAL_INI_LOOP:
	LPM
	ADIW R30,1
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOV  R30,R22
	MOV  R31,R23
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0xDF)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x92)
	LDI  R29,HIGH(0x92)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x92
;       1 //Программа для платы индикации "Пакетик полуавтомат"(3 задержки)
;       2 
;       3 #define UART_RX_BUFFER 16
;       4 #define UART_TX_BUFFER 16 
;       5 
;       6 #include <90s2313.h>
;       7 #include <delay.h>
;       8 #include <stdio.h>
;       9 #include <math.h>
;      10 #include "uart.c"
;      11 #define RXB8 1
;      12 #define TXB8 0
;      13 #define OVR 3
;      14 #define FE 4
;      15 #define UDRE 5
;      16 #define RXC 7
;      17 
;      18 #define FRAMING_ERROR (1<<FE)
;      19 #define DATA_OVERRUN (1<<OVR)
;      20 #define DATA_REGISTER_EMPTY (1<<UDRE)
;      21 #define RX_COMPLETE (1<<RXC)
;      22 
;      23 char UIB[10]={0,0,0,0,0,0,0,0,0,0}; 
_UIB:
	.BYTE 0xA
;      24 bit bRXIN;
;      25 // UART Receiver buffer
;      26 #define RX_BUFFER_SIZE 8
;      27 char rx_buffer[RX_BUFFER_SIZE];
_rx_buffer:
	.BYTE 0x8
;      28 unsigned char rx_wr_index,rx_rd_index,rx_counter;
;      29 // This flag is set on UART Receiver buffer overflow
;      30 bit rx_buffer_overflow;
;      31 
;      32 // UART Receiver interrupt service routine
;      33 interrupt [UART_RXC] void uart_rx_isr(void)
;      34 {

	.CSEG
_uart_rx_isr:
	RCALL SUBOPT_0x0
;      35 char status,data;
;      36 status=USR;
	RCALL __SAVELOCR2
;	status -> R16
;	data -> R17
	IN   R16,11
;      37 data=UDR;
	IN   R17,12
;      38 if ((status & (FRAMING_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R16
	ANDI R30,LOW(0x18)
	BRNE _0x3
;      39    {
;      40    rx_buffer[rx_wr_index]=data; 
	MOV  R30,R5
	SUBI R30,-LOW(_rx_buffer)
	MOV  R26,R30
	ST   X,R17
;      41    bRXIN=1;
	SET
	BLD  R2,0
;      42    if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	INC  R5
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x4
	CLR  R5
;      43    if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x5
;      44       {
;      45       rx_counter=0;
	CLR  R7
;      46       rx_buffer_overflow=1;
	SET
	BLD  R2,1
;      47       };
_0x5:
;      48    };
_0x3:
;      49 }
	RCALL __LOADLOCR2P
	RCALL SUBOPT_0x1
	RETI
;      50 
;      51 #ifndef _DEBUG_TERMINAL_IO_
;      52 // Get a character from the UART Receiver buffer
;      53 #define _ALTERNATE_GETCHAR_
;      54 #pragma used+
;      55 char getchar(void)
;      56 {
;      57 char data;
;      58 while (rx_counter==0);
;	data -> R16
;      59 data=rx_buffer[rx_rd_index];
;      60 if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
;      61 #asm("cli")
	cli
;      62 --rx_counter;
;      63 #asm("sei")
	sei
;      64 return data;
;      65 }
;      66 #pragma used-
;      67 #endif
;      68 
;      69 // UART Transmitter buffer
;      70 #define TX_BUFFER_SIZE 8
;      71 char tx_buffer[TX_BUFFER_SIZE];

	.DSEG
_tx_buffer:
	.BYTE 0x8
;      72 unsigned char tx_wr_index,tx_rd_index,tx_counter;
;      73 
;      74 // UART Transmitter interrupt service routine
;      75 interrupt [UART_TXC] void uart_tx_isr(void)
;      76 {

	.CSEG
_uart_tx_isr:
	RCALL SUBOPT_0x0
;      77 if (tx_counter)
	TST  R10
	BREQ _0xA
;      78    {
;      79    --tx_counter;
	DEC  R10
;      80    UDR=tx_buffer[tx_rd_index];
	LDI  R26,LOW(_tx_buffer)
	ADD  R26,R9
	LD   R30,X
	OUT  0xC,R30
;      81    if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	INC  R9
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0xB
	CLR  R9
;      82    };
_0xB:
_0xA:
;      83 }
	RCALL SUBOPT_0x1
	RETI
;      84 
;      85 #ifndef _DEBUG_TERMINAL_IO_
;      86 // Write a character to the UART Transmitter buffer
;      87 #define _ALTERNATE_PUTCHAR_
;      88 #pragma used+
;      89 void putchar(char c)
;      90 {
_putchar:
;      91 while (tx_counter == TX_BUFFER_SIZE);
_0xC:
	LDI  R30,LOW(8)
	CP   R30,R10
	BREQ _0xC
;      92 #asm("cli")
	cli
;      93 if (tx_counter || ((USR & DATA_REGISTER_EMPTY)==0))
	TST  R10
	BRNE _0x10
	SBIC 0xB,5
	RJMP _0xF
_0x10:
;      94    {
;      95    tx_buffer[tx_wr_index]=c;
	MOV  R30,R8
	SUBI R30,-LOW(_tx_buffer)
	MOV  R26,R30
	LD   R30,Y
	ST   X,R30
;      96    if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	INC  R8
	LDI  R30,LOW(8)
	CP   R30,R8
	BRNE _0x12
	CLR  R8
;      97    ++tx_counter;
_0x12:
	INC  R10
;      98    }
;      99 else
	RJMP _0x13
_0xF:
;     100    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
_0x13:
;     101 #asm("sei")
	sei
;     102 }
	ADIW R28,1
	RET
;     103 #pragma used-
;     104 #endif
;     105 #include "cmd.c"
;     106 //-----------------------------------------------
;     107 // Символы передач
;     108 #define REGU 0xf5
;     109 #define REGI 0xf6
;     110 #define GetTemp 0xfc
;     111 #define TVOL0 0x75
;     112 #define TVOL1 0x76
;     113 #define TVOL2 0x77
;     114 #define TTEMPER	0x7c
;     115 #define CSTART  0x1a
;     116 #define CMND	0x16
;     117 #define Blok_flip	0x57
;     118 #define END 	0x0A
;     119 #define QWEST	0x25
;     120 #define IM	0x52
;     121 #define Add_kf 0x60
;     122 #define Sub_kf 0x61
;     123 #define Zero_kf0 0x63
;     124 #define Zero_kf2 0x64
;     125 #define Mem_kf 0x62
;     126 #define BLKON 0x80
;     127 #define BLKOFF 0x81
;     128 #define Put_reg 0x90
;     129 
;     130 
;     131 #define but_on	 25
;     132 #define on	 0
;     133 #define off	 1
;     134 
;     135 
;     136 bit b100Hz;
;     137 bit b10Hz;
;     138 bit b5Hz;
;     139 bit b1Hz;
;     140 bit bFL;
;     141 bit bZ;
;     142 bit speed=0;
;     143 
;     144 char t0_cnt,t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3;

	.DSEG
_t0_cnt3:
	.BYTE 0x1
;     145 char ind_cnt;
_ind_cnt:
	.BYTE 0x1
;     146 char ind_out[5];
_ind_out:
	.BYTE 0x5
;     147 char dig[4];
_dig:
	.BYTE 0x4
;     148 flash char STROB[]={0b11111011,0b11110111,0b11101111,0b11011111,0b10111111,0b11111111};

	.CSEG
;     149 flash char DIGISYM[]={0b01001000,0b01111011,0b00101100,0b00101001,0b00011011,0b10001001,0b10001000,0b01101011,0b00001000,0b00001001,0b11111111};								
;     150 						
;     151 
;     152 char but_pr_LD_if,but_pr_LD_get,but_pr_imp_v,delay,but_pr_CAN_vozb;

	.DSEG
_but_pr_LD_if:
	.BYTE 0x1
_but_pr_LD_get:
	.BYTE 0x1
_but_pr_imp_v:
	.BYTE 0x1
_delay:
	.BYTE 0x1
_but_pr_CAN_vozb:
	.BYTE 0x1
;     153 bit n_but_LD_if,n_but_LD_get,n_but_imp_v,delay_on,n_but_CAN_vozb;
;     154 int cnt;
_cnt:
	.BYTE 0x2
;     155 int ccc1,ccc2,ccc3;
_ccc1:
	.BYTE 0x2
_ccc2:
	.BYTE 0x2
_ccc3:
	.BYTE 0x2
;     156 
;     157 char but_cnt0,but_cnt1,but_cnt01;
_but_cnt0:
	.BYTE 0x1
_but_cnt1:
	.BYTE 0x1
_but_cnt01:
	.BYTE 0x1
;     158 bit b0,b0L,b1,b1L,b01,b01L;
;     159 
;     160 enum {iCcc1,iCcc2,iCcc3} ind;
_ind:
	.BYTE 0x1
;     161 
;     162 //-----------------------------------------------
;     163 void t0_init(void)
;     164 {

	.CSEG
_t0_init:
;     165 TCCR0=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
;     166 TCNT0=-62;
	LDI  R30,LOW(194)
	OUT  0x32,R30
;     167 } 
	RET
;     168 
;     169 //-----------------------------------------------
;     170 void port_init(void)
;     171 {
_port_init:
;     172 PORTB=0x1B;
	LDI  R30,LOW(27)
	OUT  0x18,R30
;     173 DDRB=0x1F;
	LDI  R30,LOW(31)
	OUT  0x17,R30
;     174 
;     175 
;     176 PORTD=0x7B;
	LDI  R30,LOW(123)
	OUT  0x12,R30
;     177 DDRD=0x6F;
	LDI  R30,LOW(111)
	OUT  0x11,R30
;     178 } 
	RET
;     179 
;     180 //-----------------------------------------------
;     181 char index_offset (signed char index,signed char offset)
;     182 {
_index_offset:
;     183 index=index+offset;
	LD   R30,Y
	LDD  R26,Y+1
	ADD  R30,R26
	STD  Y+1,R30
;     184 if(index>=RX_BUFFER_SIZE) index-=RX_BUFFER_SIZE; 
	LDD  R26,Y+1
	CPI  R26,LOW(0x8)
	BRLT _0x14
	SUBI R30,LOW(8)
	STD  Y+1,R30
;     185 if(index<0) index+=RX_BUFFER_SIZE;
_0x14:
	LDD  R26,Y+1
	CPI  R26,0
	BRGE _0x15
	LDD  R30,Y+1
	SUBI R30,-LOW(8)
	STD  Y+1,R30
;     186 return index;
_0x15:
	LDD  R30,Y+1
	ADIW R28,2
	RET
;     187 }
;     188 
;     189 //-----------------------------------------------
;     190 char control_check(char index)
;     191 {
_control_check:
;     192 char i=0,ii=0,iii;
;     193 
;     194 if(rx_buffer[index]!=END) goto error_cc;
	RCALL __SAVELOCR3
;	index -> Y+3
;	i -> R16
;	ii -> R17
;	iii -> R18
	LDI  R16,0
	LDI  R17,0
	LDD  R30,Y+3
	RCALL SUBOPT_0x2
	CPI  R30,LOW(0xA)
	BRNE _0x17
;     195 //else OUT(0x0b,0,0,0,0,0);
;     196 ii=rx_buffer[index_offset(index,-2)];
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	SUBI R30,-LOW(_rx_buffer)
	LD   R17,Z
;     197 iii=0;
	LDI  R18,LOW(0)
;     198 for(i=0;i<=ii;i++)
	LDI  R16,LOW(0)
_0x19:
	CP   R17,R16
	BRLO _0x1A
;     199 	{
;     200 	iii^=rx_buffer[index_offset(index,-2-ii+i)];
	RCALL SUBOPT_0x3
	SUB  R30,R17
	ADD  R30,R16
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x2
	EOR  R18,R30
;     201 	}
	SUBI R16,-1
	RJMP _0x19
_0x1A:
;     202 if (iii!=rx_buffer[index_offset(index,-1)]) goto error_cc;	
	LDD  R30,Y+3
	ST   -Y,R30
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x2
	CP   R30,R18
	BRNE _0x17
;     203 
;     204 
;     205 success_cc:
;     206 return 1;
	LDI  R30,LOW(1)
	RJMP _0x66
;     207 goto end_cc;
;     208 error_cc:
_0x17:
;     209 return 0;
	LDI  R30,LOW(0)
;     210 goto end_cc;
;     211 
;     212 end_cc:
;     213 }
_0x66:
	RCALL __LOADLOCR3
	ADIW R28,4
	RET
;     214 //-----------------------------------------------
;     215 void UART_IN_AN(void)
;     216 {
_UART_IN_AN:
;     217 char temp_char;
;     218 int temp_int;
;     219 signed long int temp_intL;
;     220 if(UIB[0]==CMND)
	SBIW R28,4
	RCALL __SAVELOCR3
;	temp_char -> R16
;	temp_int -> R17,R18
;	temp_intL -> Y+3
	LDS  R26,_UIB
	CPI  R26,LOW(0x16)
	BRNE _0x1E
;     221 	{
;     222      ccc1=UIB[1];
	__GETB1MN _UIB,1
	LDI  R31,0
	STS  _ccc1,R30
	STS  _ccc1+1,R31
;     223      ccc2=UIB[2];
	__GETB1MN _UIB,2
	LDI  R31,0
	STS  _ccc2,R30
	STS  _ccc2+1,R31
;     224      ccc3=UIB[3];
	__GETB1MN _UIB,3
	LDI  R31,0
	STS  _ccc3,R30
	STS  _ccc3+1,R31
;     225 	}
;     226 }	
_0x1E:
	RCALL __LOADLOCR3
	ADIW R28,7
	RET
;     227 
;     228 //-----------------------------------------------
;     229 void UART_IN(void)
;     230 {
_UART_IN:
;     231 //static char flag;
;     232 char temp,i,count;
;     233 //int temp_int;
;     234 #asm("cli")
	RCALL __SAVELOCR3
;	temp -> R16
;	i -> R17
;	count -> R18
	cli
;     235 //char* ptr;
;     236 //char i=0,t=0;
;     237 //int it=0;
;     238 //signed long int char_int;
;     239 //if(!bRXIN) goto UART_IN_end;
;     240 //bRXIN=0;
;     241 //count=rx_counter;
;     242 //OUT(0x01,0,0,0,0,0);
;     243 if(rx_buffer_overflow)
	SBRS R2,1
	RJMP _0x1F
;     244 	{
;     245 	rx_wr_index=0;
	CLR  R5
;     246 	rx_rd_index=0;
	CLR  R6
;     247 	rx_counter=0;
	CLR  R7
;     248 	rx_buffer_overflow=0;
	CLT
	BLD  R2,1
;     249 	}    
;     250 	
;     251 if(rx_counter&&(rx_buffer[index_offset(rx_wr_index,-1)])==END)
_0x1F:
	TST  R7
	BREQ _0x21
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x2
	CPI  R30,LOW(0xA)
	BREQ _0x22
_0x21:
	RJMP _0x20
_0x22:
;     252 	{
;     253      temp=rx_buffer[index_offset(rx_wr_index,-3)];
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x4
	SUBI R30,-LOW(_rx_buffer)
	LD   R16,Z
;     254     	if(temp<10) 
	CPI  R16,10
	BRSH _0x23
;     255     		{
;     256     		if(control_check(index_offset(rx_wr_index,-1)))
	RCALL SUBOPT_0x6
	ST   -Y,R30
	RCALL _control_check
	CPI  R30,0
	BREQ _0x24
;     257     			{
;     258     			rx_rd_index=index_offset(rx_wr_index,-3-temp);
	RCALL SUBOPT_0x7
	SUB  R30,R16
	RCALL SUBOPT_0x4
	MOV  R6,R30
;     259     			for(i=0;i<temp;i++)
	LDI  R17,LOW(0)
_0x26:
	CP   R17,R16
	BRSH _0x27
;     260 				{
;     261 				UIB[i]=rx_buffer[index_offset(rx_rd_index,i)];
	MOV  R30,R17
	SUBI R30,-LOW(_UIB)
	PUSH R30
	ST   -Y,R6
	ST   -Y,R17
	RCALL _index_offset
	RCALL SUBOPT_0x2
	POP  R26
	ST   X,R30
;     262 				} 
	SUBI R17,-1
	RJMP _0x26
_0x27:
;     263 			rx_rd_index=rx_wr_index;
	MOV  R6,R5
;     264 			rx_counter=0;
	CLR  R7
;     265 			UART_IN_AN();
	RCALL _UART_IN_AN
;     266 
;     267     			}
;     268  	
;     269     		} 
_0x24:
;     270     	}	
_0x23:
;     271 
;     272 UART_IN_end:
_0x20:
;     273 #asm("sei")     
	sei
;     274 } 
	RCALL __LOADLOCR3
	RJMP _0x65
;     275 
;     276 //-----------------------------------------------
;     277 void OUT (char num,char data0,char data1,char data2,char data3,char data4,char data5)
;     278 {
_OUT:
;     279 char i,t=0;
;     280 char UOB[10]; 
;     281 UOB[0]=data0;
	SBIW R28,10
	RCALL __SAVELOCR2
;	num -> Y+18
;	data0 -> Y+17
;	data1 -> Y+16
;	data2 -> Y+15
;	data3 -> Y+14
;	data4 -> Y+13
;	data5 -> Y+12
;	i -> R16
;	t -> R17
;	UOB -> Y+2
	LDI  R17,0
	LDD  R30,Y+17
	STD  Y+2,R30
;     282 UOB[1]=data1;
	LDD  R30,Y+16
	STD  Y+3,R30
;     283 UOB[2]=data2;
	LDD  R30,Y+15
	STD  Y+4,R30
;     284 UOB[3]=data3;
	LDD  R30,Y+14
	STD  Y+5,R30
;     285 UOB[4]=data4;
	LDD  R30,Y+13
	STD  Y+6,R30
;     286 UOB[5]=data5;
	LDD  R30,Y+12
	STD  Y+7,R30
;     287 UOB[6]=0;
	LDI  R30,LOW(0)
	STD  Y+8,R30
;     288 UOB[7]=0;
	STD  Y+9,R30
;     289 UOB[8]=0;
	STD  Y+10,R30
;     290 UOB[9]=0;
	STD  Y+11,R30
;     291 for (i=0;i<num;i++)
	LDI  R16,LOW(0)
_0x2A:
	LDD  R30,Y+18
	CP   R16,R30
	BRSH _0x2B
;     292 	{
;     293 	t^=UOB[i];
	RCALL SUBOPT_0x8
	EOR  R17,R30
;     294 	}    
	SUBI R16,-1
	RJMP _0x2A
_0x2B:
;     295 UOB[num]=num;
	RCALL SUBOPT_0x9
	ADD  R26,R30
	LDD  R30,Y+18
	ST   X,R30
;     296 t^=UOB[num];
	RCALL SUBOPT_0x9
	ADD  R26,R30
	LD   R30,X
	EOR  R17,R30
;     297 UOB[num+1]=t;
	LDD  R30,Y+18
	SUBI R30,-LOW(1)
	MOV  R26,R28
	SUBI R26,-(2)
	ADD  R26,R30
	ST   X,R17
;     298 UOB[num+2]=END;
	LDD  R30,Y+18
	SUBI R30,-LOW(2)
	MOV  R26,R28
	SUBI R26,-(2)
	ADD  R26,R30
	LDI  R30,LOW(10)
	ST   X,R30
;     299 
;     300 for (i=0;i<num+3;i++)
	LDI  R16,LOW(0)
_0x2D:
	LDD  R30,Y+18
	SUBI R30,-LOW(3)
	CP   R16,R30
	BRSH _0x2E
;     301 	{
;     302 	putchar(UOB[i]);
	RCALL SUBOPT_0x8
	ST   -Y,R30
	RCALL _putchar
;     303 	}   	
	SUBI R16,-1
	RJMP _0x2D
_0x2E:
;     304 
;     305 }
	RCALL __LOADLOCR2
	ADIW R28,19
	RET
;     306  
;     307 //-----------------------------------------------
;     308 void bin2bcd_int(unsigned int in)
;     309 {
_bin2bcd_int:
;     310 char i;
;     311 for(i=3;i>0;i--)
	ST   -Y,R16
;	in -> Y+1
;	i -> R16
	LDI  R16,LOW(3)
_0x30:
	LDI  R30,LOW(0)
	CP   R30,R16
	BRSH _0x31
;     312 	{
;     313 	dig[i]=in%10;
	MOV  R30,R16
	SUBI R30,-LOW(_dig)
	PUSH R30
	RCALL SUBOPT_0xA
	RCALL __MODW21U
	POP  R26
	ST   X,R30
;     314 	in/=10;
	RCALL SUBOPT_0xA
	RCALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
;     315 	}   
	SUBI R16,1
	RJMP _0x30
_0x31:
;     316 }
	LDD  R16,Y+0
	RJMP _0x65
;     317 
;     318 //-----------------------------------------------
;     319 void bcd2ind(char s)
;     320 {
_bcd2ind:
;     321 char i;
;     322 bZ=1;
	ST   -Y,R16
;	s -> Y+1
;	i -> R16
	SET
	BLD  R2,7
;     323 for (i=0;i<5;i++)
	LDI  R16,LOW(0)
_0x33:
	CPI  R16,5
	BRLO PC+2
	RJMP _0x34
;     324 	{
;     325 	if(bZ&&(!dig[i-1])&&(i<4))
	SBRS R2,7
	RJMP _0x36
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
	CPI  R30,0
	BRNE _0x36
	CPI  R16,4
	BRLO _0x37
_0x36:
	RJMP _0x35
_0x37:
;     326 		{
;     327 		if((4-i)>s)
	LDI  R30,LOW(4)
	SUB  R30,R16
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
	BRSH _0x38
;     328 			{
;     329 			ind_out[i-1]=DIGISYM[10];
	RCALL SUBOPT_0xB
	SUBI R30,-LOW(_ind_out)
	PUSH R30
	__POINTW1FN _DIGISYM,10
	LPM
	MOV  R30,R0
	POP  R26
	RJMP _0x67
;     330 			}
;     331 		else ind_out[i-1]=DIGISYM[0];	
_0x38:
	RCALL SUBOPT_0xB
	SUBI R30,-LOW(_ind_out)
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	LPM
	MOV  R30,R0
	POP  R26
_0x67:
	ST   X,R30
;     332 		}
;     333 	else
	RJMP _0x3A
_0x35:
;     334 		{
;     335 		ind_out[i-1]=DIGISYM[dig[i-1]];
	RCALL SUBOPT_0xB
	SUBI R30,-LOW(_ind_out)
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
	POP  R26
	POP  R27
	RCALL SUBOPT_0xD
	LPM
	MOV  R30,R0
	POP  R26
	ST   X,R30
;     336 		bZ=0;
	CLT
	BLD  R2,7
;     337 		}                   
_0x3A:
;     338 
;     339 	if(s)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x3B
;     340 		{
;     341 		ind_out[3-s]&=0b11110111;
	LDD  R26,Y+1
	LDI  R30,LOW(3)
	SUB  R30,R26
	SUBI R30,-LOW(_ind_out)
	PUSH R30
	LD   R30,Z
	ANDI R30,0XF7
	POP  R26
	ST   X,R30
;     342 		}	
;     343  
;     344 	}
_0x3B:
	SUBI R16,-1
	RJMP _0x33
_0x34:
;     345 }                         
	LDD  R16,Y+0
	ADIW R28,2
	RET
;     346              
;     347 //-----------------------------------------------
;     348 void int2ind(unsigned int in,char s)
;     349 {
_int2ind:
;     350 bin2bcd_int(in);
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _bin2bcd_int
;     351 bcd2ind(s);
	LD   R30,Y
	ST   -Y,R30
	RCALL _bcd2ind
;     352 
;     353 } 
_0x65:
	ADIW R28,3
	RET
;     354 
;     355 //-----------------------------------------------
;     356 void ind_hndl(void)
;     357 {
_ind_hndl:
;     358 /*if(ind==iCcc1)
;     359 	{  */
;     360 	int2ind(ccc1,1);
	LDS  R30,_ccc1
	LDS  R31,_ccc1+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _int2ind
;     361 /*	ind_out[0]=DIGISYM[1];
;     362 	}
;     363 else  if(ind==iCcc2)
;     364 	{
;     365 	int2ind(ccc2,1);
;     366 	ind_out[0]=DIGISYM[2];
;     367 	} 
;     368 else  if(ind==iCcc3)
;     369 	{
;     370 	int2ind(ccc3,1);
;     371 	ind_out[0]=DIGISYM[3];
;     372 	}*/		
;     373 
;     374 } 
	RET
;     375 
;     376 
;     377 //-----------------------------------------------
;     378 void but_drv(void)
;     379 {
_but_drv:
;     380 DDRB&=0b11111100;
	IN   R30,0x17
	ANDI R30,LOW(0xFC)
	OUT  0x17,R30
;     381 PORTB|=0b00000011;
	IN   R30,0x18
	ORI  R30,LOW(0x3)
	OUT  0x18,R30
;     382 #asm("nop")
	nop
;     383 if((!PINB.0)&&(PINB.1))
	SBIC 0x16,0
	RJMP _0x3D
	SBIC 0x16,1
	RJMP _0x3E
_0x3D:
	RJMP _0x3C
_0x3E:
;     384 	{
;     385 	if(but_cnt0<200)
	RCALL SUBOPT_0xE
	BRSH _0x3F
;     386 		{
;     387 		but_cnt0++;
	LDS  R30,_but_cnt0
	SUBI R30,-LOW(1)
	STS  _but_cnt0,R30
;     388 		if(but_cnt0==20) b0=1;
	LDS  R26,_but_cnt0
	CPI  R26,LOW(0x14)
	BRNE _0x40
	SET
	BLD  R3,6
;     389 		if(but_cnt0==200)
_0x40:
	RCALL SUBOPT_0xE
	BRNE _0x41
;     390 			{
;     391 			b0L=1;
	SET
	BLD  R3,7
;     392 			but_cnt0=150;
	LDI  R30,LOW(150)
	STS  _but_cnt0,R30
;     393 			}
;     394 		}	
_0x41:
;     395 	}     
_0x3F:
;     396 else 
	RJMP _0x42
_0x3C:
;     397 	{
;     398 	but_cnt0=0;
	LDI  R30,LOW(0)
	STS  _but_cnt0,R30
;     399 	}	
_0x42:
;     400 
;     401 if((PINB.0)&&(!PINB.1))
	SBIS 0x16,0
	RJMP _0x44
	SBIS 0x16,1
	RJMP _0x45
_0x44:
	RJMP _0x43
_0x45:
;     402 	{
;     403 	if(but_cnt1<200)
	RCALL SUBOPT_0xF
	BRSH _0x46
;     404 		{
;     405 		but_cnt1++;
	LDS  R30,_but_cnt1
	SUBI R30,-LOW(1)
	STS  _but_cnt1,R30
;     406 		if(but_cnt1==20) b1=1;
	LDS  R26,_but_cnt1
	CPI  R26,LOW(0x14)
	BRNE _0x47
	SET
	BLD  R4,0
;     407 		if(but_cnt1==200)
_0x47:
	RCALL SUBOPT_0xF
	BRNE _0x48
;     408 			{
;     409 			b1L=1;
	SET
	BLD  R4,1
;     410 			but_cnt1=150;
	LDI  R30,LOW(150)
	STS  _but_cnt1,R30
;     411 			}
;     412 		}	
_0x48:
;     413 	}     
_0x46:
;     414 else 
	RJMP _0x49
_0x43:
;     415 	{
;     416 	but_cnt1=0;
	LDI  R30,LOW(0)
	STS  _but_cnt1,R30
;     417 	}	
_0x49:
;     418 
;     419 if((!PINB.0)&&(!PINB.1))
	SBIC 0x16,0
	RJMP _0x4B
	SBIS 0x16,1
	RJMP _0x4C
_0x4B:
	RJMP _0x4A
_0x4C:
;     420 	{
;     421 	if(but_cnt01<200)
	RCALL SUBOPT_0x10
	BRSH _0x4D
;     422 		{
;     423 		but_cnt01++;
	LDS  R30,_but_cnt01
	SUBI R30,-LOW(1)
	STS  _but_cnt01,R30
;     424 		if(but_cnt01==20) b01=1;
	LDS  R26,_but_cnt01
	CPI  R26,LOW(0x14)
	BRNE _0x4E
	SET
	BLD  R4,2
;     425 		if(but_cnt01==200)
_0x4E:
	RCALL SUBOPT_0x10
	BRNE _0x4F
;     426 			{
;     427 			b01L=1;
	SET
	BLD  R4,3
;     428 			but_cnt01=150;
	LDI  R30,LOW(150)
	STS  _but_cnt01,R30
;     429 			}
;     430 		}	
_0x4F:
;     431 	}     
_0x4D:
;     432 else 
	RJMP _0x50
_0x4A:
;     433 	{
;     434 	but_cnt01=0;
	LDI  R30,LOW(0)
	STS  _but_cnt01,R30
;     435 	}	
_0x50:
;     436 
;     437 } 
	RET
;     438 
;     439 //-----------------------------------------------
;     440 void but_an(void)
;     441 {
_but_an:
;     442 /*if(ind==iCcc1)
;     443 	{      */
;     444 	if(b0)
	SBRS R3,6
	RJMP _0x51
;     445 		{
;     446     		b0=0;
	CLT
	BLD  R3,6
;     447 		OUT(3,CMND,5,6,0,0,0);
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x12
;     448 		}
;     449 	if(b1)
_0x51:
	SBRS R4,0
	RJMP _0x52
;     450 		{
;     451     		b1=0;
	CLT
	BLD  R4,0
;     452 		OUT(3,CMND,7,8,0,0,0);
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x13
;     453 		}
;     454 	if(b0L)
_0x52:
	SBRS R3,7
	RJMP _0x53
;     455 		{
;     456 		b0L=0;
	CLT
	BLD  R3,7
;     457 		OUT(3,CMND,5,6,0,0,0);
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x12
;     458 		}
;     459 	if(b1L)
_0x53:
	SBRS R4,1
	RJMP _0x54
;     460 		{
;     461     		b1L=0;
	CLT
	BLD  R4,1
;     462 		OUT(3,CMND,7,8,0,0,0);
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x13
;     463 		}
;     464 /*	if(b01)
;     465 		{
;     466     		b01=0;
;     467 		ind=iCcc2;
;     468 		}		
;     469 	} 
;     470 else if(ind==iCcc2)
;     471 	{
;     472 	if(b0)
;     473 		{
;     474     		b0=0;
;     475 		OUT(3,CMND,9,10,0,0,0);
;     476 		}
;     477 	if(b1)
;     478 		{
;     479     		b1=0;
;     480 		OUT(3,CMND,11,12,0,0,0);
;     481 		}
;     482 	if(b0L)
;     483 		{
;     484 		b0L=0;
;     485 		OUT(3,CMND,9,10,0,0,0);
;     486 		}
;     487 	if(b1L)
;     488 		{
;     489     		b1L=0;
;     490 		OUT(3,CMND,11,12,0,0,0);
;     491 		}
;     492 	if(b01)
;     493 		{
;     494     		b01=0;
;     495 		ind=iCcc3;
;     496 		}		
;     497 	}				
;     498 	
;     499 else if(ind==iCcc3)
;     500 	{
;     501 	if(b0)
;     502 		{
;     503     		b0=0;
;     504 		OUT(3,CMND,13,14,0,0,0);
;     505 		}
;     506 	if(b1)
;     507 		{
;     508     		b1=0;
;     509 		OUT(3,CMND,15,16,0,0,0);
;     510 		}
;     511 	if(b0L)
;     512 		{
;     513 		b0L=0;
;     514 		OUT(3,CMND,13,14,0,0,0);
;     515 		}
;     516 	if(b1L)
;     517 		{
;     518     		b1L=0;
;     519 		OUT(3,CMND,15,16,0,0,0);
;     520 		}
;     521 	if(b01)
;     522 		{
;     523     		b01=0;
;     524 		ind=iCcc1;
;     525 		}		
;     526 	}	    */				
;     527 }
_0x54:
	RET
;     528 
;     529 //***********************************************
;     530 //***********************************************
;     531 //***********************************************
;     532 //***********************************************
;     533 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;     534 {
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
;     535 t0_init();
	RCALL _t0_init
;     536 if(++ind_cnt>5) ind_cnt=0;
	LDS  R26,_ind_cnt
	SUBI R26,-LOW(1)
	STS  _ind_cnt,R26
	LDI  R30,LOW(5)
	CP   R30,R26
	BRSH _0x55
	LDI  R30,LOW(0)
	STS  _ind_cnt,R30
;     537 DDRB=0xff;
_0x55:
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     538 PORTB=0xff;
	OUT  0x18,R30
;     539 DDRD|=0b11111100;
	IN   R30,0x11
	ORI  R30,LOW(0xFC)
	OUT  0x11,R30
;     540 PORTD=(PORTD|0b11111100)&STROB[ind_cnt];
	IN   R30,0x12
	ORI  R30,LOW(0xFC)
	PUSH R30
	LDI  R26,LOW(_STROB*2)
	LDI  R27,HIGH(_STROB*2)
	LDS  R30,_ind_cnt
	RCALL SUBOPT_0xD
	LPM
	MOV  R30,R0
	POP  R26
	AND  R30,R26
	OUT  0x12,R30
;     541 if(ind_cnt!=5) PORTB=ind_out[ind_cnt];
	LDS  R26,_ind_cnt
	CPI  R26,LOW(0x5)
	BREQ _0x56
	LDS  R30,_ind_cnt
	SUBI R30,-LOW(_ind_out)
	LD   R30,Z
	OUT  0x18,R30
;     542 else 
	RJMP _0x57
_0x56:
;     543 	{
;     544 	but_drv();
	RCALL _but_drv
;     545 	}
_0x57:
;     546 
;     547 if(++t0_cnt>=20) 
	INC  R11
	LDI  R30,LOW(20)
	CP   R11,R30
	BRLO _0x58
;     548 	{
;     549 	t0_cnt=0;
	CLR  R11
;     550 	b100Hz=1;
	SET
	BLD  R2,2
;     551 	if(++t0_cnt0>=10)
	INC  R12
	LDI  R30,LOW(10)
	CP   R12,R30
	BRLO _0x59
;     552 		{
;     553 		t0_cnt0=0;
	CLR  R12
;     554 		b10Hz=1;
	SET
	BLD  R2,3
;     555 
;     556 		} 
;     557 	if(++t0_cnt1>=20)
_0x59:
	INC  R13
	LDI  R30,LOW(20)
	CP   R13,R30
	BRLO _0x5A
;     558 		{
;     559 		t0_cnt1=0;
	CLR  R13
;     560 		b5Hz=1;
	SET
	BLD  R2,4
;     561      	bFL=!bFL;
	LDI  R30,LOW(64)
	EOR  R2,R30
;     562 		}
;     563 	if(++t0_cnt2>=100)
_0x5A:
	INC  R14
	LDI  R30,LOW(100)
	CP   R14,R30
	BRLO _0x5B
;     564 		{
;     565 		t0_cnt2=0;
	CLR  R14
;     566 		b1Hz=1;
	SET
	BLD  R2,5
;     567 	     }
;     568 	}		
_0x5B:
;     569 
;     570 }
_0x58:
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
;     571 
;     572 //===============================================
;     573 //===============================================
;     574 //===============================================
;     575 //===============================================
;     576 void main(void)
;     577 {
_main:
;     578 
;     579 t0_init();
	RCALL _t0_init
;     580 port_init();
	RCALL _port_init
;     581 
;     582 TIMSK=0x02;
	LDI  R30,LOW(2)
	OUT  0x39,R30
;     583 #asm("sei")
	sei
;     584 
;     585 UCR=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
;     586 UBRR=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
;     587 
;     588 while (1)
_0x5C:
;     589 	{
;     590 	if(bRXIN) 
	SBRS R2,0
	RJMP _0x5F
;     591 		{
;     592 		bRXIN=0;
	CLT
	BLD  R2,0
;     593 		UART_IN();
	RCALL _UART_IN
;     594 		}
;     595 	if(b100Hz)
_0x5F:
	SBRS R2,2
	RJMP _0x60
;     596 		{
;     597 		b100Hz=0;
	CLT
	BLD  R2,2
;     598 
;     599 		}             
;     600 	if(b10Hz)
_0x60:
	SBRS R2,3
	RJMP _0x61
;     601 		{
;     602 		b10Hz=0;
	CLT
	BLD  R2,3
;     603    	     but_an();
	RCALL _but_an
;     604 		}
;     605 	if(b5Hz)
_0x61:
	SBRS R2,4
	RJMP _0x62
;     606 		{
;     607 		b5Hz=0;
	CLT
	BLD  R2,4
;     608 		ind_hndl();
	RCALL _ind_hndl
;     609         // cnt;
;     610          	//OUT(3,4,5,6,0,0,0);
;     611 		} 
;     612     	if(b1Hz)
_0x62:
	SBRS R2,5
	RJMP _0x63
;     613 		{
;     614 		b1Hz=0;
	CLT
	BLD  R2,5
;     615 
;     616 
;     617 		}
;     618      #asm("wdr")	
_0x63:
	wdr
;     619 	}
	RJMP _0x5C
;     620 }
_0x64:
	RJMP _0x64

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x2:
	SUBI R30,-LOW(_rx_buffer)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3:
	LDD  R30,Y+3
	ST   -Y,R30
	LDI  R30,LOW(254)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES
SUBOPT_0x4:
	ST   -Y,R30
	RJMP _index_offset

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x5:
	LDI  R30,LOW(255)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x6:
	ST   -Y,R5
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x7:
	ST   -Y,R5
	LDI  R30,LOW(253)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x8:
	MOV  R26,R28
	SUBI R26,-(2)
	ADD  R26,R16
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x9:
	LDD  R30,Y+18
	MOV  R26,R28
	SUBI R26,-(2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xA:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0xB:
	MOV  R30,R16
	SUBI R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xC:
	SUBI R30,-LOW(_dig)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xD:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xE:
	LDS  R26,_but_cnt0
	CPI  R26,LOW(0xC8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF:
	LDS  R26,_but_cnt1
	CPI  R26,LOW(0xC8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10:
	LDS  R26,_but_cnt01
	CPI  R26,LOW(0xC8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x11:
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(22)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x12:
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	RJMP _OUT

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x13:
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	RJMP _OUT

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
	MOV  R30,R26
	MOV  R31,R27
	MOV  R26,R0
	MOV  R27,R1
	RET

__MODW21U:
	RCALL __DIVW21U
	MOV  R30,R26
	MOV  R31,R27
	RET

__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

