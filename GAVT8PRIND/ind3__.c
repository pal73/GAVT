//��������� ��� ����� ��������� "������� �����������"(3 ��������)

#define UART_RX_BUFFER 16
#define UART_TX_BUFFER 16 

#include <90s2313.h>
#include <delay.h>
#include <stdio.h>
#include <math.h>
#include "uart.c"
#define RXB8 1
#define TXB8 0
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7

#define FRAMING_ERROR (1<<FE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

char UIB[10]={0,0,0,0,0,0,0,0,0,0}; 
bit bRXIN;
// UART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];
unsigned char rx_wr_index,rx_rd_index,rx_counter;
// This flag is set on UART Receiver buffer overflow
bit rx_buffer_overflow;

// UART Receiver interrupt service routine
interrupt [UART_RXC] void uart_rx_isr(void)
{
char status,data;
status=USR;
data=UDR;
if ((status & (FRAMING_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index]=data; 
   bRXIN=1;
   if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      };
   };
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the UART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index];
if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// UART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];
unsigned char tx_wr_index,tx_rd_index,tx_counter;

// UART Transmitter interrupt service routine
interrupt [UART_TXC] void uart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index];
   if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
   };
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the UART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((USR & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index]=c;
   if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif
#include "cmd.c"
//-----------------------------------------------
// ������� �������
#define REGU 0xf5
#define REGI 0xf6
#define GetTemp 0xfc
#define TVOL0 0x75
#define TVOL1 0x76
#define TVOL2 0x77
#define TTEMPER	0x7c
#define CSTART  0x1a
#define CMND	0x16
#define Blok_flip	0x57
#define END 	0x0A
#define QWEST	0x25
#define IM	0x52
#define Add_kf 0x60
#define Sub_kf 0x61
#define Zero_kf0 0x63
#define Zero_kf2 0x64
#define Mem_kf 0x62
#define BLKON 0x80
#define BLKOFF 0x81
#define Put_reg 0x90


#define but_on	 25
#define on	 0
#define off	 1


bit b100Hz;
bit b10Hz;
bit b5Hz;
bit b1Hz;
bit bFL;
bit bZ;
bit speed=0;

char t0_cnt,t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3;
char ind_cnt;
char ind_out[5];
char dig[4];
flash char STROB[]={0b11111011,0b11110111,0b11101111,0b11011111,0b10111111,0b11111111};
flash char DIGISYM[]={0b01001000,0b01111011,0b00101100,0b00101001,0b00011011,0b10001001,0b10001000,0b01101011,0b00001000,0b00001001,0b11111111};								
						

char but_pr_LD_if,but_pr_LD_get,but_pr_imp_v,delay,but_pr_CAN_vozb;
bit n_but_LD_if,n_but_LD_get,n_but_imp_v,delay_on,n_but_CAN_vozb;
int cnt;
int ccc1,ccc2,ccc3;

char but_cnt0,but_cnt1,but_cnt01;
bit b0,b0L,b1,b1L,b01,b01L;

enum {iCcc1,iCcc2,iCcc3} ind;

//-----------------------------------------------
void t0_init(void)
{
TCCR0=0x03;
TCNT0=-62;
} 

//-----------------------------------------------
void port_init(void)
{
PORTB=0x1B;
DDRB=0x1F;


PORTD=0x7B;
DDRD=0x6F;
} 

//-----------------------------------------------
char index_offset (signed char index,signed char offset)
{
index=index+offset;
if(index>=RX_BUFFER_SIZE) index-=RX_BUFFER_SIZE; 
if(index<0) index+=RX_BUFFER_SIZE;
return index;
}

//-----------------------------------------------
char control_check(char index)
{
char i=0,ii=0,iii;

if(rx_buffer[index]!=END) goto error_cc;
//else OUT(0x0b,0,0,0,0,0);
ii=rx_buffer[index_offset(index,-2)];
iii=0;
for(i=0;i<=ii;i++)
	{
	iii^=rx_buffer[index_offset(index,-2-ii+i)];
	}
if (iii!=rx_buffer[index_offset(index,-1)]) goto error_cc;	


success_cc:
return 1;
goto end_cc;
error_cc:
return 0;
goto end_cc;

end_cc:
}
//-----------------------------------------------
void UART_IN_AN(void)
{
char temp_char;
int temp_int;
signed long int temp_intL;
if(UIB[0]==CMND)
	{
     ccc1=UIB[1];
     ccc2=UIB[2];
     ccc3=UIB[3];
	}
}	

//-----------------------------------------------
void UART_IN(void)
{
//static char flag;
char temp,i,count;
//int temp_int;
#asm("cli")
//char* ptr;
//char i=0,t=0;
//int it=0;
//signed long int char_int;
//if(!bRXIN) goto UART_IN_end;
//bRXIN=0;
//count=rx_counter;
//OUT(0x01,0,0,0,0,0);
if(rx_buffer_overflow)
	{
	rx_wr_index=0;
	rx_rd_index=0;
	rx_counter=0;
	rx_buffer_overflow=0;
	}    
	
if(rx_counter&&(rx_buffer[index_offset(rx_wr_index,-1)])==END)
	{
     temp=rx_buffer[index_offset(rx_wr_index,-3)];
    	if(temp<10) 
    		{
    		if(control_check(index_offset(rx_wr_index,-1)))
    			{
    			rx_rd_index=index_offset(rx_wr_index,-3-temp);
    			for(i=0;i<temp;i++)
				{
				UIB[i]=rx_buffer[index_offset(rx_rd_index,i)];
				} 
			rx_rd_index=rx_wr_index;
			rx_counter=0;
			UART_IN_AN();

    			}
 	
    		} 
    	}	

UART_IN_end:
#asm("sei")     
} 

//-----------------------------------------------
void OUT (char num,char data0,char data1,char data2,char data3,char data4,char data5)
{
char i,t=0;
char UOB[10]; 
UOB[0]=data0;
UOB[1]=data1;
UOB[2]=data2;
UOB[3]=data3;
UOB[4]=data4;
UOB[5]=data5;
UOB[6]=0;
UOB[7]=0;
UOB[8]=0;
UOB[9]=0;
for (i=0;i<num;i++)
	{
	t^=UOB[i];
	}    
UOB[num]=num;
t^=UOB[num];
UOB[num+1]=t;
UOB[num+2]=END;

for (i=0;i<num+3;i++)
	{
	putchar(UOB[i]);
	}   	

}
 
//-----------------------------------------------
void bin2bcd_int(unsigned int in)
{
char i;
for(i=3;i>0;i--)
	{
	dig[i]=in%10;
	in/=10;
	}   
}

//-----------------------------------------------
void bcd2ind(char s)
{
char i;
bZ=1;
for (i=0;i<5;i++)
	{
	if(bZ&&(!dig[i-1])&&(i<4))
		{
		if((4-i)>s)
			{
			ind_out[i-1]=DIGISYM[10];
			}
		else ind_out[i-1]=DIGISYM[0];	
		}
	else
		{
		ind_out[i-1]=DIGISYM[dig[i-1]];
		bZ=0;
		}                   

	if(s)
		{
		ind_out[3-s]&=0b11110111;
		}	
 
	}
}                         
             
//-----------------------------------------------
void int2ind(unsigned int in,char s)
{
bin2bcd_int(in);
bcd2ind(s);

} 

//-----------------------------------------------
void ind_hndl(void)
{
/*if(ind==iCcc1)
	{  */
	int2ind(ccc1,1);
	ind_out[0]=DIGISYM[ccc2];
/*	}
else  if(ind==iCcc2)
	{
	int2ind(ccc2,1);
	ind_out[0]=DIGISYM[2];
	} 
else  if(ind==iCcc3)
	{
	int2ind(ccc3,1);
	ind_out[0]=DIGISYM[3];
	}*/		

} 


//-----------------------------------------------
void but_drv(void)
{
DDRB&=0b11111100;
PORTB|=0b00000011;
#asm("nop")
if((!PINB.0)&&(PINB.1))
	{
	if(but_cnt0<200)
		{
		but_cnt0++;
		if(but_cnt0==20) b0=1;
		if(but_cnt0==200)
			{
			b0L=1;
			but_cnt0=150;
			}
		}	
	}     
else 
	{
	but_cnt0=0;
	}	

if((PINB.0)&&(!PINB.1))
	{
	if(but_cnt1<200)
		{
		but_cnt1++;
		if(but_cnt1==20) b1=1;
		if(but_cnt1==200)
			{
			b1L=1;
			but_cnt1=150;
			}
		}	
	}     
else 
	{
	but_cnt1=0;
	}	

if((!PINB.0)&&(!PINB.1))
	{
	if(but_cnt01<200)
		{
		but_cnt01++;
		if(but_cnt01==20) b01=1;
		if(but_cnt01==200)
			{
			b01L=1;
			but_cnt01=150;
			}
		}	
	}     
else 
	{
	but_cnt01=0;
	}	

} 

//-----------------------------------------------
void but_an(void)
{
if(b0)
	{
	b0=0;
	OUT(3,CMND,5,6,0,0,0);
	}
else if(b1)
	{
	b1=0;
	OUT(3,CMND,7,8,0,0,0);
	}
else if(b0L)
	{
	b0L=0;
	OUT(3,CMND,5,6,0,0,0);
	}
else if(b1L)
	{
	b1L=0;
	OUT(3,CMND,7,8,0,0,0);
	}
else if(b01)
	{
	b01=0;
	OUT(3,CMND,9,10,0,0,0);
	}				
}

//***********************************************
//***********************************************
//***********************************************
//***********************************************
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
t0_init();
if(++ind_cnt>5) ind_cnt=0;
DDRB=0xff;
PORTB=0xff;
DDRD|=0b11111100;
PORTD=(PORTD|0b11111100)&STROB[ind_cnt];
if(ind_cnt!=5) PORTB=ind_out[ind_cnt];
else 
	{
	but_drv();
	}

if(++t0_cnt>=20) 
	{
	t0_cnt=0;
	b100Hz=1;
	if(++t0_cnt0>=10)
		{
		t0_cnt0=0;
		b10Hz=1;

		} 
	if(++t0_cnt1>=20)
		{
		t0_cnt1=0;
		b5Hz=1;
     	bFL=!bFL;
		}
	if(++t0_cnt2>=100)
		{
		t0_cnt2=0;
		b1Hz=1;
	     }
	}		

}

//===============================================
//===============================================
//===============================================
//===============================================
void main(void)
{

t0_init();
port_init();

TIMSK=0x02;
#asm("sei")

UCR=0xD8;
UBRR=0x33;

while (1)
	{
	if(bRXIN) 
		{
		bRXIN=0;
		UART_IN();
		}
	if(b100Hz)
		{
		b100Hz=0;

		}             
	if(b10Hz)
		{
		b10Hz=0;
   	     but_an();
		}
	if(b5Hz)
		{
		b5Hz=0;
		ind_hndl();
		} 
    	if(b1Hz)
		{
		b1Hz=0;


		}
     #asm("wdr")	
	}
}
