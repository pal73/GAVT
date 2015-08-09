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

	.INCLUDE "ind.vec"
	.INCLUDE "ind.inc"

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
;       1 #define UART_RX_BUFFER 16
;       2 #define UART_TX_BUFFER 16 
;       3 
;       4 #include <90s2313.h>
;       5 #include <delay.h>
;       6 #include <stdio.h>
;       7 #include <math.h>
;       8 #include "uart.c"
;       9 #define RXB8 1
;      10 #define TXB8 0
;      11 #define OVR 3
;      12 #define FE 4
;      13 #define UDRE 5
;      14 #define RXC 7
;      15 
;      16 #define FRAMING_ERROR (1<<FE)
;      17 #define DATA_OVERRUN (1<<OVR)
;      18 #define DATA_REGISTER_EMPTY (1<<UDRE)
;      19 #define RX_COMPLETE (1<<RXC)
;      20 
;      21 char UIB[10]={0,0,0,0,0,0,0,0,0,0}; 
_UIB:
	.BYTE 0xA
;      22 bit bRXIN;
;      23 // UART Receiver buffer
;      24 #define RX_BUFFER_SIZE 8
;      25 char rx_buffer[RX_BUFFER_SIZE];
_rx_buffer:
	.BYTE 0x8
;      26 unsigned char rx_wr_index,rx_rd_index,rx_counter;
;      27 // This flag is set on UART Receiver buffer overflow
;      28 bit rx_buffer_overflow;
;      29 
;      30 // UART Receiver interrupt service routine
;      31 interrupt [UART_RXC] void uart_rx_isr(void)
;      32 {

	.CSEG
_uart_rx_isr:
	RCALL SUBOPT_0x0
;      33 char status,data;
;      34 status=USR;
	RCALL __SAVELOCR2
;	status -> R16
;	data -> R17
	IN   R16,11
;      35 data=UDR;
	IN   R17,12
;      36 if ((status & (FRAMING_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R16
	ANDI R30,LOW(0x18)
	BRNE _0x3
;      37    {
;      38    rx_buffer[rx_wr_index]=data; 
	MOV  R30,R5
	SUBI R30,-LOW(_rx_buffer)
	MOV  R26,R30
	ST   X,R17
;      39    bRXIN=1;
	SET
	BLD  R2,0
;      40    if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	INC  R5
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x4
	CLR  R5
;      41    if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x5
;      42       {
;      43       rx_counter=0;
	CLR  R7
;      44       rx_buffer_overflow=1;
	SET
	BLD  R2,1
;      45       };
_0x5:
;      46    };
_0x3:
;      47 }
	RCALL __LOADLOCR2P
	RCALL SUBOPT_0x1
	RETI
;      48 
;      49 #ifndef _DEBUG_TERMINAL_IO_
;      50 // Get a character from the UART Receiver buffer
;      51 #define _ALTERNATE_GETCHAR_
;      52 #pragma used+
;      53 char getchar(void)
;      54 {
;      55 char data;
;      56 while (rx_counter==0);
;	data -> R16
;      57 data=rx_buffer[rx_rd_index];
;      58 if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
;      59 #asm("cli")
	cli
;      60 --rx_counter;
;      61 #asm("sei")
	sei
;      62 return data;
;      63 }
;      64 #pragma used-
;      65 #endif
;      66 
;      67 // UART Transmitter buffer
;      68 #define TX_BUFFER_SIZE 8
;      69 char tx_buffer[TX_BUFFER_SIZE];

	.DSEG
_tx_buffer:
	.BYTE 0x8
;      70 unsigned char tx_wr_index,tx_rd_index,tx_counter;
;      71 
;      72 // UART Transmitter interrupt service routine
;      73 interrupt [UART_TXC] void uart_tx_isr(void)
;      74 {

	.CSEG
_uart_tx_isr:
	RCALL SUBOPT_0x0
;      75 if (tx_counter)
	TST  R10
	BREQ _0xA
;      76    {
;      77    --tx_counter;
	DEC  R10
;      78    UDR=tx_buffer[tx_rd_index];
	LDI  R26,LOW(_tx_buffer)
	ADD  R26,R9
	LD   R30,X
	OUT  0xC,R30
;      79    if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	INC  R9
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0xB
	CLR  R9
;      80    };
_0xB:
_0xA:
;      81 }
	RCALL SUBOPT_0x1
	RETI
;      82 
;      83 #ifndef _DEBUG_TERMINAL_IO_
;      84 // Write a character to the UART Transmitter buffer
;      85 #define _ALTERNATE_PUTCHAR_
;      86 #pragma used+
;      87 void putchar(char c)
;      88 {
_putchar:
;      89 while (tx_counter == TX_BUFFER_SIZE);
_0xC:
	LDI  R30,LOW(8)
	CP   R30,R10
	BREQ _0xC
;      90 #asm("cli")
	cli
;      91 if (tx_counter || ((USR & DATA_REGISTER_EMPTY)==0))
	TST  R10
	BRNE _0x10
	SBIC 0xB,5
	RJMP _0xF
_0x10:
;      92    {
;      93    tx_buffer[tx_wr_index]=c;
	MOV  R30,R8
	SUBI R30,-LOW(_tx_buffer)
	MOV  R26,R30
	LD   R30,Y
	ST   X,R30
;      94    if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	INC  R8
	LDI  R30,LOW(8)
	CP   R30,R8
	BRNE _0x12
	CLR  R8
;      95    ++tx_counter;
_0x12:
	INC  R10
;      96    }
;      97 else
	RJMP _0x13
_0xF:
;      98    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
_0x13:
;      99 #asm("sei")
	sei
;     100 }
	ADIW R28,1
	RET
;     101 #pragma used-
;     102 #endif
;     103 #include "cmd.c"
;     104 //-----------------------------------------------
;     105 // Символы передач
;     106 #define REGU 0xf5
;     107 #define REGI 0xf6
;     108 #define GetTemp 0xfc
;     109 #define TVOL0 0x75
;     110 #define TVOL1 0x76
;     111 #define TVOL2 0x77
;     112 #define TTEMPER	0x7c
;     113 #define CSTART  0x1a
;     114 #define CMND	0x16
;     115 #define Blok_flip	0x57
;     116 #define END 	0x0A
;     117 #define QWEST	0x25
;     118 #define IM	0x52
;     119 #define Add_kf 0x60
;     120 #define Sub_kf 0x61
;     121 #define Zero_kf0 0x63
;     122 #define Zero_kf2 0x64
;     123 #define Mem_kf 0x62
;     124 #define BLKON 0x80
;     125 #define BLKOFF 0x81
;     126 #define Put_reg 0x90
;     127 
;     128 
;     129 #define but_on	 25
;     130 #define on	 0
;     131 #define off	 1
;     132 
;     133 
;     134 bit b100Hz;
;     135 bit b10Hz;
;     136 bit b5Hz;
;     137 bit b1Hz;
;     138 bit bFL;
;     139 bit bZ;
;     140 bit speed=0;
;     141 
;     142 char t0_cnt,t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3;

	.DSEG
_t0_cnt3:
	.BYTE 0x1
;     143 char ind_cnt;
_ind_cnt:
	.BYTE 0x1
;     144 char ind_out[5];
_ind_out:
	.BYTE 0x5
;     145 char dig[4];
_dig:
	.BYTE 0x4
;     146 flash char STROB[]={0b11111011,0b11110111,0b11101111,0b11011111,0b10111111,0b11111111};

	.CSEG
;     147 flash char DIGISYM[]={0b01001000,0b01111011,0b00101100,0b00101001,0b00011011,0b10001001,0b10001000,0b01101011,0b00001000,0b00001001,0b11111111};								
;     148 						
;     149 
;     150 char but_pr_LD_if,but_pr_LD_get,but_pr_imp_v,delay,but_pr_CAN_vozb;

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
;     151 bit n_but_LD_if,n_but_LD_get,n_but_imp_v,delay_on,n_but_CAN_vozb;
;     152 int cnt;
_cnt:
	.BYTE 0x2
;     153 int ccc1,ccc2;
_ccc1:
	.BYTE 0x2
_ccc2:
	.BYTE 0x2
;     154 
;     155 char but_cnt0,but_cnt1,but_cnt01;
_but_cnt0:
	.BYTE 0x1
_but_cnt1:
	.BYTE 0x1
_but_cnt01:
	.BYTE 0x1
;     156 bit b0,b0L,b1,b1L,b01,b01L;
;     157 
;     158 enum {iCcc1,iCcc2} ind;
_ind:
	.BYTE 0x1
;     159 
;     160 //-----------------------------------------------
;     161 void t0_init(void)
;     162 {

	.CSEG
_t0_init:
;     163 TCCR0=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
;     164 TCNT0=-62;
	LDI  R30,LOW(194)
	OUT  0x32,R30
;     165 } 
	RET
;     166 
;     167 //-----------------------------------------------
;     168 void port_init(void)
;     169 {
_port_init:
;     170 PORTB=0x1B;
	LDI  R30,LOW(27)
	OUT  0x18,R30
;     171 DDRB=0x1F;
	LDI  R30,LOW(31)
	OUT  0x17,R30
;     172 
;     173 
;     174 PORTD=0x7B;
	LDI  R30,LOW(123)
	OUT  0x12,R30
;     175 DDRD=0x6F;
	LDI  R30,LOW(111)
	OUT  0x11,R30
;     176 } 
	RET
;     177 
;     178 //-----------------------------------------------
;     179 char index_offset (signed char index,signed char offset)
;     180 {
_index_offset:
;     181 index=index+offset;
	LD   R30,Y
	LDD  R26,Y+1
	ADD  R30,R26
	STD  Y+1,R30
;     182 if(index>=RX_BUFFER_SIZE) index-=RX_BUFFER_SIZE; 
	LDD  R26,Y+1
	CPI  R26,LOW(0x8)
	BRLT _0x14
	SUBI R30,LOW(8)
	STD  Y+1,R30
;     183 if(index<0) index+=RX_BUFFER_SIZE;
_0x14:
	LDD  R26,Y+1
	CPI  R26,0
	BRGE _0x15
	LDD  R30,Y+1
	SUBI R30,-LOW(8)
	STD  Y+1,R30
;     184 return index;
_0x15:
	LDD  R30,Y+1
	ADIW R28,2
	RET
;     185 }
;     186 
;     187 //-----------------------------------------------
;     188 char control_check(char index)
;     189 {
_control_check:
;     190 char i=0,ii=0,iii;
;     191 
;     192 if(rx_buffer[index]!=END) goto error_cc;
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
;     193 //else OUT(0x0b,0,0,0,0,0);
;     194 ii=rx_buffer[index_offset(index,-2)];
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	SUBI R30,-LOW(_rx_buffer)
	LD   R17,Z
;     195 iii=0;
	LDI  R18,LOW(0)
;     196 for(i=0;i<=ii;i++)
	LDI  R16,LOW(0)
_0x19:
	CP   R17,R16
	BRLO _0x1A
;     197 	{
;     198 	iii^=rx_buffer[index_offset(index,-2-ii+i)];
	RCALL SUBOPT_0x3
	SUB  R30,R17
	ADD  R30,R16
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x2
	EOR  R18,R30
;     199 	}
	SUBI R16,-1
	RJMP _0x19
_0x1A:
;     200 if (iii!=rx_buffer[index_offset(index,-1)]) goto error_cc;	
	LDD  R30,Y+3
	ST   -Y,R30
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x2
	CP   R30,R18
	BRNE _0x17
;     201 
;     202 
;     203 success_cc:
;     204 return 1;
	LDI  R30,LOW(1)
	RJMP _0x72
;     205 goto end_cc;
;     206 error_cc:
_0x17:
;     207 return 0;
	LDI  R30,LOW(0)
;     208 goto end_cc;
;     209 
;     210 end_cc:
;     211 }
_0x72:
	RCALL __LOADLOCR3
	ADIW R28,4
	RET
;     212 //-----------------------------------------------
;     213 void UART_IN_AN(void)
;     214 {
_UART_IN_AN:
;     215 char temp_char;
;     216 int temp_int;
;     217 signed long int temp_intL;
;     218 if(UIB[0]==CMND)
	SBIW R28,4
	RCALL __SAVELOCR3
;	temp_char -> R16
;	temp_int -> R17,R18
;	temp_intL -> Y+3
	LDS  R26,_UIB
	CPI  R26,LOW(0x16)
	BRNE _0x1E
;     219 	{
;     220      ccc1=UIB[1];
	__GETB1MN _UIB,1
	LDI  R31,0
	STS  _ccc1,R30
	STS  _ccc1+1,R31
;     221      ccc2=UIB[2];
	__GETB1MN _UIB,2
	LDI  R31,0
	STS  _ccc2,R30
	STS  _ccc2+1,R31
;     222 	}
;     223 }	
_0x1E:
	RCALL __LOADLOCR3
	ADIW R28,7
	RET
;     224 
;     225 //-----------------------------------------------
;     226 void UART_IN(void)
;     227 {
_UART_IN:
;     228 //static char flag;
;     229 char temp,i,count;
;     230 //int temp_int;
;     231 #asm("cli")
	RCALL __SAVELOCR3
;	temp -> R16
;	i -> R17
;	count -> R18
	cli
;     232 //char* ptr;
;     233 //char i=0,t=0;
;     234 //int it=0;
;     235 //signed long int char_int;
;     236 //if(!bRXIN) goto UART_IN_end;
;     237 //bRXIN=0;
;     238 //count=rx_counter;
;     239 //OUT(0x01,0,0,0,0,0);
;     240 if(rx_buffer_overflow)
	SBRS R2,1
	RJMP _0x1F
;     241 	{
;     242 	rx_wr_index=0;
	CLR  R5
;     243 	rx_rd_index=0;
	CLR  R6
;     244 	rx_counter=0;
	CLR  R7
;     245 	rx_buffer_overflow=0;
	CLT
	BLD  R2,1
;     246 	}    
;     247 	
;     248 if(rx_counter&&(rx_buffer[index_offset(rx_wr_index,-1)])==END)
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
;     249 	{
;     250      temp=rx_buffer[index_offset(rx_wr_index,-3)];
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x4
	SUBI R30,-LOW(_rx_buffer)
	LD   R16,Z
;     251     	if(temp<10) 
	CPI  R16,10
	BRSH _0x23
;     252     		{
;     253     		if(control_check(index_offset(rx_wr_index,-1)))
	RCALL SUBOPT_0x6
	ST   -Y,R30
	RCALL _control_check
	CPI  R30,0
	BREQ _0x24
;     254     			{
;     255     			rx_rd_index=index_offset(rx_wr_index,-3-temp);
	RCALL SUBOPT_0x7
	SUB  R30,R16
	RCALL SUBOPT_0x4
	MOV  R6,R30
;     256     			for(i=0;i<temp;i++)
	LDI  R17,LOW(0)
_0x26:
	CP   R17,R16
	BRSH _0x27
;     257 				{
;     258 				UIB[i]=rx_buffer[index_offset(rx_rd_index,i)];
	MOV  R30,R17
	SUBI R30,-LOW(_UIB)
	PUSH R30
	ST   -Y,R6
	ST   -Y,R17
	RCALL _index_offset
	RCALL SUBOPT_0x2
	POP  R26
	ST   X,R30
;     259 				} 
	SUBI R17,-1
	RJMP _0x26
_0x27:
;     260 			rx_rd_index=rx_wr_index;
	MOV  R6,R5
;     261 			rx_counter=0;
	CLR  R7
;     262 			UART_IN_AN();
	RCALL _UART_IN_AN
;     263 
;     264     			}
;     265  	
;     266     		} 
_0x24:
;     267     	}	
_0x23:
;     268 
;     269 UART_IN_end:
_0x20:
;     270 #asm("sei")     
	sei
;     271 } 
	RCALL __LOADLOCR3
	RJMP _0x71
;     272 
;     273 //-----------------------------------------------
;     274 void OUT (char num,char data0,char data1,char data2,char data3,char data4,char data5)
;     275 {
_OUT:
;     276 char i,t=0;
;     277 char UOB[10]; 
;     278 UOB[0]=data0;
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
;     279 UOB[1]=data1;
	LDD  R30,Y+16
	STD  Y+3,R30
;     280 UOB[2]=data2;
	LDD  R30,Y+15
	STD  Y+4,R30
;     281 UOB[3]=data3;
	LDD  R30,Y+14
	STD  Y+5,R30
;     282 UOB[4]=data4;
	LDD  R30,Y+13
	STD  Y+6,R30
;     283 UOB[5]=data5;
	LDD  R30,Y+12
	STD  Y+7,R30
;     284 UOB[6]=0;
	LDI  R30,LOW(0)
	STD  Y+8,R30
;     285 UOB[7]=0;
	STD  Y+9,R30
;     286 UOB[8]=0;
	STD  Y+10,R30
;     287 UOB[9]=0;
	STD  Y+11,R30
;     288 for (i=0;i<num;i++)
	LDI  R16,LOW(0)
_0x2A:
	LDD  R30,Y+18
	CP   R16,R30
	BRSH _0x2B
;     289 	{
;     290 	t^=UOB[i];
	RCALL SUBOPT_0x8
	EOR  R17,R30
;     291 	}    
	SUBI R16,-1
	RJMP _0x2A
_0x2B:
;     292 UOB[num]=num;
	RCALL SUBOPT_0x9
	ADD  R26,R30
	LDD  R30,Y+18
	ST   X,R30
;     293 t^=UOB[num];
	RCALL SUBOPT_0x9
	ADD  R26,R30
	LD   R30,X
	EOR  R17,R30
;     294 UOB[num+1]=t;
	LDD  R30,Y+18
	SUBI R30,-LOW(1)
	MOV  R26,R28
	SUBI R26,-(2)
	ADD  R26,R30
	ST   X,R17
;     295 UOB[num+2]=END;
	LDD  R30,Y+18
	SUBI R30,-LOW(2)
	MOV  R26,R28
	SUBI R26,-(2)
	ADD  R26,R30
	LDI  R30,LOW(10)
	ST   X,R30
;     296 
;     297 for (i=0;i<num+3;i++)
	LDI  R16,LOW(0)
_0x2D:
	LDD  R30,Y+18
	SUBI R30,-LOW(3)
	CP   R16,R30
	BRSH _0x2E
;     298 	{
;     299 	putchar(UOB[i]);
	RCALL SUBOPT_0x8
	ST   -Y,R30
	RCALL _putchar
;     300 	}   	
	SUBI R16,-1
	RJMP _0x2D
_0x2E:
;     301 
;     302 }
	RCALL __LOADLOCR2
	ADIW R28,19
	RET
;     303  
;     304 //-----------------------------------------------
;     305 void bin2bcd_int(unsigned int in)
;     306 {
_bin2bcd_int:
;     307 char i;
;     308 for(i=3;i>0;i--)
	ST   -Y,R16
;	in -> Y+1
;	i -> R16
	LDI  R16,LOW(3)
_0x30:
	LDI  R30,LOW(0)
	CP   R30,R16
	BRSH _0x31
;     309 	{
;     310 	dig[i]=in%10;
	MOV  R30,R16
	SUBI R30,-LOW(_dig)
	PUSH R30
	RCALL SUBOPT_0xA
	RCALL __MODW21U
	POP  R26
	ST   X,R30
;     311 	in/=10;
	RCALL SUBOPT_0xA
	RCALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
;     312 	}   
	SUBI R16,1
	RJMP _0x30
_0x31:
;     313 }
	LDD  R16,Y+0
	RJMP _0x71
;     314 
;     315 //-----------------------------------------------
;     316 void bcd2ind(char s)
;     317 {
_bcd2ind:
;     318 char i;
;     319 bZ=1;
	ST   -Y,R16
;	s -> Y+1
;	i -> R16
	SET
	BLD  R2,7
;     320 for (i=0;i<5;i++)
	LDI  R16,LOW(0)
_0x33:
	CPI  R16,5
	BRLO PC+2
	RJMP _0x34
;     321 	{
;     322 	if(bZ&&(!dig[i-1])&&(i<4))
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
;     323 		{
;     324 		if((4-i)>s)
	LDI  R30,LOW(4)
	SUB  R30,R16
	MOV  R26,R30
	LDD  R30,Y+1
	CP   R30,R26
	BRSH _0x38
;     325 			{
;     326 			ind_out[i-1]=DIGISYM[10];
	RCALL SUBOPT_0xB
	SUBI R30,-LOW(_ind_out)
	PUSH R30
	__POINTW1FN _DIGISYM,10
	LPM
	MOV  R30,R0
	POP  R26
	RJMP _0x73
;     327 			}
;     328 		else ind_out[i-1]=DIGISYM[0];	
_0x38:
	RCALL SUBOPT_0xB
	SUBI R30,-LOW(_ind_out)
	PUSH R30
	LDI  R30,LOW(_DIGISYM*2)
	LDI  R31,HIGH(_DIGISYM*2)
	LPM
	MOV  R30,R0
	POP  R26
_0x73:
	ST   X,R30
;     329 		}
;     330 	else
	RJMP _0x3A
_0x35:
;     331 		{
;     332 		ind_out[i-1]=DIGISYM[dig[i-1]];
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
;     333 		bZ=0;
	CLT
	BLD  R2,7
;     334 		}                   
_0x3A:
;     335 
;     336 	if(s)
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x3B
;     337 		{
;     338 		ind_out[3-s]&=0b11110111;
	LDD  R26,Y+1
	LDI  R30,LOW(3)
	SUB  R30,R26
	SUBI R30,-LOW(_ind_out)
	PUSH R30
	LD   R30,Z
	ANDI R30,0XF7
	POP  R26
	ST   X,R30
;     339 		}	
;     340  
;     341 	}
_0x3B:
	SUBI R16,-1
	RJMP _0x33
_0x34:
;     342 }                         
	LDD  R16,Y+0
	ADIW R28,2
	RET
;     343              
;     344 //-----------------------------------------------
;     345 void int2ind(unsigned int in,char s)
;     346 {
_int2ind:
;     347 bin2bcd_int(in);
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _bin2bcd_int
;     348 bcd2ind(s);
	LD   R30,Y
	ST   -Y,R30
	RCALL _bcd2ind
;     349 
;     350 } 
_0x71:
	ADIW R28,3
	RET
;     351 
;     352 //-----------------------------------------------
;     353 void ind_hndl(void)
;     354 {
_ind_hndl:
;     355 if(ind==iCcc1)
	RCALL SUBOPT_0xE
	BRNE _0x3C
;     356 	{
;     357 	int2ind(ccc1,1);
	LDS  R30,_ccc1
	LDS  R31,_ccc1+1
	RCALL SUBOPT_0xF
;     358 	ind_out[3]=DIGISYM[1];
	__POINTW1FN _DIGISYM,1
	LPM
	MOV  R30,R0
	__PUTB1MN _ind_out,3
;     359 	}
;     360 else  if(ind==iCcc2)
	RJMP _0x3D
_0x3C:
	RCALL SUBOPT_0x10
	BRNE _0x3E
;     361 	{
;     362 	int2ind(ccc2,1);
	LDS  R30,_ccc2
	LDS  R31,_ccc2+1
	RCALL SUBOPT_0xF
;     363 	ind_out[3]=DIGISYM[2];
	__POINTW1FN _DIGISYM,2
	LPM
	MOV  R30,R0
	__PUTB1MN _ind_out,3
;     364 	}	
;     365 
;     366 } 
_0x3E:
_0x3D:
	RET
;     367 
;     368 
;     369 //-----------------------------------------------
;     370 void but_drv(void)
;     371 {
_but_drv:
;     372 DDRB&=0b11111100;
	IN   R30,0x17
	ANDI R30,LOW(0xFC)
	OUT  0x17,R30
;     373 PORTB|=0b00000011;
	IN   R30,0x18
	ORI  R30,LOW(0x3)
	OUT  0x18,R30
;     374 #asm("nop")
	nop
;     375 if((!PINB.0)&&(PINB.1))
	SBIC 0x16,0
	RJMP _0x40
	SBIC 0x16,1
	RJMP _0x41
_0x40:
	RJMP _0x3F
_0x41:
;     376 	{
;     377 	if(but_cnt0<200)
	RCALL SUBOPT_0x11
	BRSH _0x42
;     378 		{
;     379 		but_cnt0++;
	LDS  R30,_but_cnt0
	SUBI R30,-LOW(1)
	STS  _but_cnt0,R30
;     380 		if(but_cnt0==20) b0=1;
	LDS  R26,_but_cnt0
	CPI  R26,LOW(0x14)
	BRNE _0x43
	SET
	BLD  R3,6
;     381 		if(but_cnt0==200)
_0x43:
	RCALL SUBOPT_0x11
	BRNE _0x44
;     382 			{
;     383 			b0L=1;
	SET
	BLD  R3,7
;     384 			but_cnt0=150;
	LDI  R30,LOW(150)
	STS  _but_cnt0,R30
;     385 			}
;     386 		}	
_0x44:
;     387 	}     
_0x42:
;     388 else 
	RJMP _0x45
_0x3F:
;     389 	{
;     390 	but_cnt0=0;
	LDI  R30,LOW(0)
	STS  _but_cnt0,R30
;     391 	}	
_0x45:
;     392 
;     393 if((PINB.0)&&(!PINB.1))
	SBIS 0x16,0
	RJMP _0x47
	SBIS 0x16,1
	RJMP _0x48
_0x47:
	RJMP _0x46
_0x48:
;     394 	{
;     395 	if(but_cnt1<200)
	RCALL SUBOPT_0x12
	BRSH _0x49
;     396 		{
;     397 		but_cnt1++;
	LDS  R30,_but_cnt1
	SUBI R30,-LOW(1)
	STS  _but_cnt1,R30
;     398 		if(but_cnt1==20) b1=1;
	LDS  R26,_but_cnt1
	CPI  R26,LOW(0x14)
	BRNE _0x4A
	SET
	BLD  R4,0
;     399 		if(but_cnt1==200)
_0x4A:
	RCALL SUBOPT_0x12
	BRNE _0x4B
;     400 			{
;     401 			b1L=1;
	SET
	BLD  R4,1
;     402 			but_cnt1=150;
	LDI  R30,LOW(150)
	STS  _but_cnt1,R30
;     403 			}
;     404 		}	
_0x4B:
;     405 	}     
_0x49:
;     406 else 
	RJMP _0x4C
_0x46:
;     407 	{
;     408 	but_cnt1=0;
	LDI  R30,LOW(0)
	STS  _but_cnt1,R30
;     409 	}	
_0x4C:
;     410 
;     411 if((!PINB.0)&&(!PINB.1))
	SBIC 0x16,0
	RJMP _0x4E
	SBIS 0x16,1
	RJMP _0x4F
_0x4E:
	RJMP _0x4D
_0x4F:
;     412 	{
;     413 	if(but_cnt01<200)
	RCALL SUBOPT_0x13
	BRSH _0x50
;     414 		{
;     415 		but_cnt01++;
	LDS  R30,_but_cnt01
	SUBI R30,-LOW(1)
	STS  _but_cnt01,R30
;     416 		if(but_cnt01==20) b01=1;
	LDS  R26,_but_cnt01
	CPI  R26,LOW(0x14)
	BRNE _0x51
	SET
	BLD  R4,2
;     417 		if(but_cnt01==200)
_0x51:
	RCALL SUBOPT_0x13
	BRNE _0x52
;     418 			{
;     419 			b01L=1;
	SET
	BLD  R4,3
;     420 			but_cnt01=150;
	LDI  R30,LOW(150)
	STS  _but_cnt01,R30
;     421 			}
;     422 		}	
_0x52:
;     423 	}     
_0x50:
;     424 else 
	RJMP _0x53
_0x4D:
;     425 	{
;     426 	but_cnt01=0;
	LDI  R30,LOW(0)
	STS  _but_cnt01,R30
;     427 	}	
_0x53:
;     428 
;     429 } 
	RET
;     430 
;     431 //-----------------------------------------------
;     432 void but_an(void)
;     433 {
_but_an:
;     434 if(ind==iCcc1)
	RCALL SUBOPT_0xE
	BRNE _0x54
;     435 	{
;     436 	if(b0)
	SBRS R3,6
	RJMP _0x55
;     437 		{
;     438     		b0=0;
	CLT
	BLD  R3,6
;     439 		OUT(3,CMND,5,6,0,0,0);
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
;     440 		}
;     441 	if(b1)
_0x55:
	SBRS R4,0
	RJMP _0x56
;     442 		{
;     443     		b1=0;
	CLT
	BLD  R4,0
;     444 		OUT(3,CMND,7,8,0,0,0);
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x16
;     445 		}
;     446 	if(b0L)
_0x56:
	SBRS R3,7
	RJMP _0x57
;     447 		{
;     448 		b0L=0;
	CLT
	BLD  R3,7
;     449 		OUT(3,CMND,5,6,0,0,0);
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
;     450 		}
;     451 	if(b1L)
_0x57:
	SBRS R4,1
	RJMP _0x58
;     452 		{
;     453     		b1L=0;
	CLT
	BLD  R4,1
;     454 		OUT(3,CMND,7,8,0,0,0);
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x16
;     455 		}
;     456 	if(b01L)
_0x58:
	SBRS R4,3
	RJMP _0x59
;     457 		{
;     458     		b01L=0;
	CLT
	BLD  R4,3
;     459 		ind=iCcc2;
	LDI  R30,LOW(1)
	STS  _ind,R30
;     460 		}		
;     461 	} 
_0x59:
;     462 else if(ind==iCcc2)
	RJMP _0x5A
_0x54:
	RCALL SUBOPT_0x10
	BRNE _0x5B
;     463 	{
;     464 	if(b0)
	SBRS R3,6
	RJMP _0x5C
;     465 		{
;     466     		b0=0;
	CLT
	BLD  R3,6
;     467 		OUT(3,CMND,9,10,0,0,0);
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x17
;     468 		}
;     469 	if(b1)
_0x5C:
	SBRS R4,0
	RJMP _0x5D
;     470 		{
;     471     		b1=0;
	CLT
	BLD  R4,0
;     472 		OUT(3,CMND,11,12,0,0,0);
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x18
;     473 		}
;     474 	if(b0L)
_0x5D:
	SBRS R3,7
	RJMP _0x5E
;     475 		{
;     476 		b0L=0;
	CLT
	BLD  R3,7
;     477 		OUT(3,CMND,9,10,0,0,0);
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x17
;     478 		}
;     479 	if(b1L)
_0x5E:
	SBRS R4,1
	RJMP _0x5F
;     480 		{
;     481     		b1L=0;
	CLT
	BLD  R4,1
;     482 		OUT(3,CMND,11,12,0,0,0);
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x18
;     483 		}
;     484 	if(b01L)
_0x5F:
	SBRS R4,3
	RJMP _0x60
;     485 		{
;     486     		b01L=0;
	CLT
	BLD  R4,3
;     487 		ind=iCcc1;
	LDI  R30,LOW(0)
	STS  _ind,R30
;     488 		}		
;     489 	}				
_0x60:
;     490 }
_0x5B:
_0x5A:
	RET
;     491 
;     492 //***********************************************
;     493 //***********************************************
;     494 //***********************************************
;     495 //***********************************************
;     496 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;     497 {
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
;     498 t0_init();
	RCALL _t0_init
;     499 if(++ind_cnt>5) ind_cnt=0;
	LDS  R26,_ind_cnt
	SUBI R26,-LOW(1)
	STS  _ind_cnt,R26
	LDI  R30,LOW(5)
	CP   R30,R26
	BRSH _0x61
	LDI  R30,LOW(0)
	STS  _ind_cnt,R30
;     500 DDRB=0xff;
_0x61:
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     501 PORTB=0xff;
	OUT  0x18,R30
;     502 DDRD|=0b11111100;
	IN   R30,0x11
	ORI  R30,LOW(0xFC)
	OUT  0x11,R30
;     503 PORTD=(PORTD|0b11111100)&STROB[ind_cnt];
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
;     504 if(ind_cnt!=5) PORTB=ind_out[ind_cnt];
	LDS  R26,_ind_cnt
	CPI  R26,LOW(0x5)
	BREQ _0x62
	LDS  R30,_ind_cnt
	SUBI R30,-LOW(_ind_out)
	LD   R30,Z
	OUT  0x18,R30
;     505 else 
	RJMP _0x63
_0x62:
;     506 	{
;     507 	but_drv();
	RCALL _but_drv
;     508 	}
_0x63:
;     509 
;     510 if(++t0_cnt>=20) 
	INC  R11
	LDI  R30,LOW(20)
	CP   R11,R30
	BRLO _0x64
;     511 	{
;     512 	t0_cnt=0;
	CLR  R11
;     513 	b100Hz=1;
	SET
	BLD  R2,2
;     514 	if(++t0_cnt0>=10)
	INC  R12
	LDI  R30,LOW(10)
	CP   R12,R30
	BRLO _0x65
;     515 		{
;     516 		t0_cnt0=0;
	CLR  R12
;     517 		b10Hz=1;
	SET
	BLD  R2,3
;     518 
;     519 		} 
;     520 	if(++t0_cnt1>=20)
_0x65:
	INC  R13
	LDI  R30,LOW(20)
	CP   R13,R30
	BRLO _0x66
;     521 		{
;     522 		t0_cnt1=0;
	CLR  R13
;     523 		b5Hz=1;
	SET
	BLD  R2,4
;     524      	bFL=!bFL;
	LDI  R30,LOW(64)
	EOR  R2,R30
;     525 		}
;     526 	if(++t0_cnt2>=100)
_0x66:
	INC  R14
	LDI  R30,LOW(100)
	CP   R14,R30
	BRLO _0x67
;     527 		{
;     528 		t0_cnt2=0;
	CLR  R14
;     529 		b1Hz=1;
	SET
	BLD  R2,5
;     530 	     }
;     531 	}		
_0x67:
;     532 
;     533 }
_0x64:
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
;     534 
;     535 //===============================================
;     536 //===============================================
;     537 //===============================================
;     538 //===============================================
;     539 void main(void)
;     540 {
_main:
;     541 
;     542 t0_init();
	RCALL _t0_init
;     543 port_init();
	RCALL _port_init
;     544 
;     545 TIMSK=0x02;
	LDI  R30,LOW(2)
	OUT  0x39,R30
;     546 #asm("sei")
	sei
;     547 
;     548 UCR=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
;     549 UBRR=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
;     550 
;     551 while (1)
_0x68:
;     552 	{
;     553 	if(bRXIN) 
	SBRS R2,0
	RJMP _0x6B
;     554 		{
;     555 		bRXIN=0;
	CLT
	BLD  R2,0
;     556 		UART_IN();
	RCALL _UART_IN
;     557 		}
;     558 	if(b100Hz)
_0x6B:
	SBRS R2,2
	RJMP _0x6C
;     559 		{
;     560 		b100Hz=0;
	CLT
	BLD  R2,2
;     561 
;     562 		}             
;     563 	if(b10Hz)
_0x6C:
	SBRS R2,3
	RJMP _0x6D
;     564 		{
;     565 		b10Hz=0;
	CLT
	BLD  R2,3
;     566    	     but_an();
	RCALL _but_an
;     567 		}
;     568 	if(b5Hz)
_0x6D:
	SBRS R2,4
	RJMP _0x6E
;     569 		{
;     570 		b5Hz=0;
	CLT
	BLD  R2,4
;     571 		ind_hndl();
	RCALL _ind_hndl
;     572          cnt;
	LDS  R30,_cnt
	LDS  R31,_cnt+1
;     573          	//OUT(3,4,5,6,0,0,0);
;     574 		} 
;     575     	if(b1Hz)
_0x6E:
	SBRS R2,5
	RJMP _0x6F
;     576 		{
;     577 		b1Hz=0;
	CLT
	BLD  R2,5
;     578 
;     579 
;     580 		}
;     581      #asm("wdr")	
_0x6F:
	wdr
;     582 	}
	RJMP _0x68
;     583 }
_0x70:
	RJMP _0x70

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
	LDS  R30,_ind
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0xF:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RJMP _int2ind

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x10:
	LDS  R26,_ind
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x11:
	LDS  R26,_but_cnt0
	CPI  R26,LOW(0xC8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x12:
	LDS  R26,_but_cnt1
	CPI  R26,LOW(0xC8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x13:
	LDS  R26,_but_cnt01
	CPI  R26,LOW(0xC8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES
SUBOPT_0x14:
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(22)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x15:
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
SUBOPT_0x16:
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	RJMP _OUT

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x17:
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	RJMP _OUT

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x18:
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R30,LOW(12)
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

