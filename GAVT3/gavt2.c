#define RX_BUFFER_SIZE 12
#define TX_BUFFER_SIZE 12

#define XTAL_FREQ 4MHZ
#include <pic.h>
#include "delay.h"

#include "sci.c"
#include "Cmd.c"

#define but_mask	0b1111111111111010
#define but_on		3
#define but_onL	10
#define no_but		0b1111111111111111

#define led_NET  3
#define led_WORK 2
#define led_ERR  1

#define PP1	4
#define PP2	3
#define PP3	2
#define PP4	1
#define PP5	0
#define PP6	5
#define PP7	1
#define NET	5
#define NET_REZ 7

#define MD1	15
#define MD2	14
#define MD3	12
#define VR	13

//#define VR	0  кнопка старт
//#define VR	2  кнопка стоп

#define PROG1	10
#define PROG2	8
#define PROG3	9

//#define DELAY 10
#define DELAY1 14
#define DELAY2 18
#define DELAY3 22
#define DELAY4 26

bank1 char rx_buffer[RX_BUFFER_SIZE];
bank1 volatile unsigned char rx_wr_index,rx_rd_index,rx_counter,rx_cnt;
//bit rx_buffer_overflow;
bank1 char tx_buffer[TX_BUFFER_SIZE];
 volatile unsigned char tx_wr_index,tx_rd_index,tx_counter;

char UIB[10]={0,0,0,0,0,0,0,0,0,0};
char ccc=128;

__CONFIG (0x3d7a);


//char adc_cnt;
//char tmr1_init;
bit bit_100Hz;
bit bit_10Hz;
bit bit_1Hz;
bit bVR;
bit bMD1;
bit bMD2;
bit bMD3;

bit bERR;
bit bRXIN;
/*bit bV1;
bit bV0;*/

unsigned int in_word;



unsigned but_n;
unsigned but_s;
unsigned but/*,but_but*/;
char enum{sOFF,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16}step=sOFF;
char enum{p1,p2,p3,pOFF}prog=p1;
char but0_cnt,but1_cnt;
char but_onL_temp;
signed int cnt_del=0;

char cnt_md1,cnt_md2,cnt_md3,cnt_vr;


bit l_but;		//идет длинное нажатие на кнопку
bit n_but;          //произошло нажатие
bit speed;		//разрешение ускорения перебора




char cnt0,cnt1,temper,temp,vol_l,vol_i;
char cnt_but_START,cnt_but_STOP;

bit bON_START,bON_STOP;

//**********************************************
//Задержки
void DelayMs(unsigned char cnt)
{
unsigned char	i;
	do {
		i = 4;
		do {
			DelayUs(250);
		} while(--i);
	} while(--cnt);

}

//-----------------------------------------------
void eeprom_write(unsigned char addr, unsigned char value)
{
EEPROM_WRITE(addr,value);
}

//-----------------------------------------------
unsigned char eeprom_read(unsigned char addr)
{
return EEPROM_READ(addr);
}


//-----------------------------------------------
void in_read(void)
{
char i,temp;
unsigned int tempUI;
TRISA&=0xf0;
TRISA4=1;

for(i=0;i<16;i++)
	{
	temp=PORTA;
	temp&=0xf0;
	temp+=i;
	PORTA=temp;
	tempUI<<=1;
	DelayUs(200);
	if(RA4)tempUI|=0x0001;
	else tempUI&=0xfffe;
	}
in_word=tempUI;
}

//-----------------------------------------------
void sci_init(void)
{
	BRGH = 1;	/* high baud rate */
//	SPBRG = 129;	/* set the baud rate 9600*/
//	SPBRG = 64;	/* set the baud rate 19200*/
	SPBRG = 25;	/* set the baud rate 9600@4000000*/
//	SPBRG = 12;	/* set the baud rate 38400*/
//	SPBRG = 8;	/* set the baud rate 57600*/
//	SPBRG = 6;	/* set the baud rate 76800*/
	SYNC = 0;	/* asynchronous */
	SPEN = 1;	/* enable serial port pins */
	TRISC6=1;
	TRISC7=1;
	CREN = 1;	/* enable reception */
//	SREN = 0;	/* no effect */
	TXIE = 0;	/* enable tx interrupts */
	RCIE = 1;	/* enable rx interrupts */
	TX9  = 0;	/* 9-bit transmission */
	RX9  = 0;	/* 9-bit reception */
	TXEN = 1;	/* enable the transmitter */
	GIE=1;
	PEIE=1;

}

//-----------------------------------------------
void puts(char* ptr,char len)
{
char i,n;

for(i=0;i<len;i++)
	{
	tx_buffer[tx_wr_index]=ptr[i];
	if(++tx_wr_index>=TX_BUFFER_SIZE) tx_wr_index=0;
	}

TXIE=1;
}

//-----------------------------------------------
void OUT (char num,char data0,char data1,char data2,char data3,char data4,char data5)
{

char i,t=0;
char UOB[8];

UOB[0]=data0;
UOB[1]=data1;
UOB[2]=data2;
UOB[3]=data3;
UOB[4]=data4;
UOB[5]=data5;
for (i=0;i<num;i++)
	{
	t^=UOB[i];
	}
UOB[num]=num;
t^=UOB[num];
UOB[num+1]=t;
UOB[num+2]=END;


puts(UOB,num+3);


}
//-----------------------------------------------
void step_contr(void)
{
char temp=0;
TRISB=0x00;

if(step==sOFF)goto step_contr_end;
else if(prog==p1)
	{
	if(step==s1)
		{
		temp|=(1<<PP1);
          if(!bMD1)goto step_contr_end;
          step=s2;
		}

	else if(step==s2)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
          if(!bVR)goto step_contr_end;
          cnt_del=50;
		step=s3;
		}


	else	if(step==s3)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
		cnt_del--;
		if(cnt_del==0)
			{
			cnt_del=eeprom_read(DELAY1)*10U;
			step=s4;
			}
          }
	else if(step==s4)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5);
		cnt_del--;
 		if(cnt_del==0)
			{
			cnt_del=eeprom_read(DELAY2)*10U;
			step=s5;
			}
		}

	else if(step==s5)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5);
		cnt_del--;
		if(cnt_del==0)
			{
			step=s6;
			cnt_del=20;
			}
		}

	else if(step==s6)
		{
		temp|=(1<<PP1);
  		cnt_del--;
		if(cnt_del==0)
			{
			step=sOFF;
			}
		}

	}

else if(prog==p2)
	{
	if(step==s1)
		{
		temp|=(1<<PP1);
          if(!bMD1)goto step_contr_end;
          step=s2;
		}

	else if(step==s2)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
          if(!bVR)goto step_contr_end;
          step=s3;
		cnt_del=eeprom_read(DELAY3)*10U;
          }

   	else if(step==s3)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
		cnt_del--;
		if(cnt_del==0)
			{
			step=s4;
			cnt_del=30;
			}
		}

	else if(step==s4)
		{
		temp|=(1<<PP1)|(1<<PP4);
		cnt_del--;
		if(cnt_del==0)
			{
			step=s5;
			cnt_del=eeprom_read(DELAY4)*10U;
			}
		}

	else if(step==s5)
		{
		temp|=(1<<PP4);
		cnt_del--;
		if(cnt_del==0)
			{
			step=sOFF;
			}
		}

	}


step_contr_end:
asm("nop");
PORTB=temp;
}

//-----------------------------------------------
void out_out(void)
{
char temp=0;
TRISB=0x00;
if(prog==p1)
	{
	if(step==sOFF)
		{
		temp=0;
		}

	else	if(step==s1)
		{
		temp|=(1<<PP1);
		}

	else if(step==s2)
		{
 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
		}

	else if(step==s3)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
		}

	else if((step==s4))
		{
         	temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5);
		}

	else if((step==s5))
		{
		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5);
		}

	else if(step==s6)
		{
          temp|=(1<<PP1);
		}

	}

if(prog==p2)
	{
	if(step==sOFF)
		{
		temp=0;
		}

	else	if(step==s1)
		{
		temp|=(1<<PP1);
		}

	else if(step==s2)
		{
 		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
		}

	else if(step==s3)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
		}

	else if((step==s4))
		{
         	temp|=(1<<PP1)|(1<<PP3)|(1<<PP4);
		}

	else if(step==s5)
		{
        	temp|=(1<<PP1)|(1<<PP4);
		}

	else if(step==s6)
		{
        	temp|=(1<<PP4);
        	}

	}


PORTB=temp;

}

//-----------------------------------------------
void led_out(void)
{
char temp=0;
TRISC=0xF0;

temp&=~(1<<led_NET);

if(step!=sOFF)
	{
	temp&=~(1<<led_WORK);
	}
else temp|=(1<<led_WORK);


if(step==sOFF)
	{
	if(bERR)
		{
		temp&=~(1<<led_ERR);
		}
	else
		{
		temp|=(1<<led_ERR);
		}

	}
else temp|=(1<<led_ERR);



PORTC=(PORTC|0b00001111)&temp;
}

//-----------------------------------------------
void mdvr_drv(void)
{
if(!(in_word&(1<<MD1)))
	{
	if(cnt_md1<10)
		{
		cnt_md1++;
		if(cnt_md1==10) bMD1=1;
		}

	}
else
	{
	if(cnt_md1)
		{
		cnt_md1--;
		if(cnt_md1==0) bMD1=0;
		}

	}

if(!(in_word&(1<<MD2)))
	{
	if(cnt_md2<10)
		{
		cnt_md2++;
		if(cnt_md2==10) bMD2=1;
		}

	}
else
	{
	if(cnt_md2)
		{
		cnt_md2--;
		if(cnt_md2==0) bMD2=0;
		}

	}

if(!(in_word&(1<<MD3)))
	{
	if(cnt_md3<10)
		{
		cnt_md3++;
		if(cnt_md3==10) bMD3=1;
		}

	}
else
	{
	if(cnt_md3)
		{
		cnt_md3--;
		if(cnt_md3==0) bMD3=0;
		}

	}

if(!(in_word&(1<<VR)))
	{
	if(cnt_vr<10)
		{
		cnt_vr++;
		if(cnt_vr==10) bVR=1;
		}

	}
else
	{
	if(cnt_vr)
		{
		cnt_vr--;
		if(cnt_vr==0) bVR=0;
		}

	}
}

//-----------------------------------------------
void err_drv(void)
{
if(step==sOFF)
	{
	if((bMD1)||(bMD2)||(bVR)) bERR=1;
	else bERR=0;
	}
else bERR=0;
}

//-----------------------------------------------
void prog_drv(void)
{
if((!(in_word&(1<<PROG1)))&&(in_word&(1<<PROG2))&&(in_word&(1<<PROG3)))
	{
	prog=p1;
	}
else if((!(in_word&(1<<PROG2)))&&(in_word&(1<<PROG1))&&(in_word&(1<<PROG3)))
	{
	prog=p2;
	}

else prog=pOFF;
}

//-----------------------------------------------
// Подпрограмма драйва до 16 входов
// различает короткое и длинное нажатие,
// срабатывает на отпускание кнопки, возможность
// ускорения перебора при длинном нажатии...
void but_drv(void)
{
if(!(in_word&0x0001))
	{
	if(cnt_but_START<but_on)
		{
		cnt_but_START++;
		if(cnt_but_START>=but_on)
			{
			bON_START=1;
			}
		}
	}
else
	{
     cnt_but_START=0;
	}

if(!(in_word&0x0004))
	{
	if(cnt_but_STOP<but_on)
		{
		cnt_but_STOP++;
		if(cnt_but_STOP>=but_on)
			{
			bON_STOP=1;
			}
		}
	}
else
	{
     cnt_but_STOP=0;
	}
/*but_n=in_word|but_mask;
if(but_n==no_but||but_n!=but_s)
 	{
 	speed=0;
  	n_but=0;
   	but=no_but;
   	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
  		{
   	     n_but=1;
          but=but_s;
          }
   	if (but1_cnt>=but_onL_temp)
  		{
   	     n_but=1;
          but=but_s&0b01111111;
          }
    	l_but=0;
   	but_onL_temp=but_onL;
    	but0_cnt=0;
  	but1_cnt=0;
     goto but_drv_out;
  	}
if(but_n==but_s)
 	{
  	but0_cnt++;
  	if(but0_cnt>=but_on)
  		{
   		but0_cnt=0;
   		but1_cnt++;
   		if(but1_cnt>=but_onL_temp)
   			{
    			but=but_s&0b01111111;
    			but1_cnt=0;
    			n_but=1;
    			l_but=1;
			if(speed)
				{
    				but_onL_temp=but_onL_temp=2;
        			if(but_onL_temp<=2) but_onL_temp=2;
				}
   			}
  		}
 	}
but_drv_out:
but_s=but_n;
*/
}

#define butSTART 0b1111111111111110
#define butSTOP  0b1111111111111011
//-----------------------------------------------
void but_an(void)
{
if(bON_START)
	{
	if((step==sOFF)&&(!bERR))
		{
		step=s1;
		if(prog==p1) cnt_del=50;
		else if(prog==p2) cnt_del=50;
		else if(prog==p3) cnt_del=50;

		}
	}
if(bON_STOP)
	{
	step=sOFF;

	}
//if (!n_but) goto but_an_end;
/*
if(but==butSTART)
	{
	if(step==sOFF)
		{
		step=s1;
		if(prog==p1) cnt_del=50;
		else if(prog==p2) cnt_del=50;
		else if(prog==p3) cnt_del=50;
		}
	}
else if(but==butSTOP)
	{
	step=sOFF;
	}

but_an_end:
asm("nop");
*/
bON_START=0;
bON_STOP=0;
}

//-----------------------------------------------
void t0_init(void)
{
OPTION=0x07;
T0IE=1;
PEIE=1;
TMR0=-40;
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
asm("nop");
}

//-----------------------------------------------
void UART_IN_AN(void)
{
char temp;

if(prog==p1)
	{

if((UIB[0]==CMND)&&(UIB[1]==5)&&(UIB[2]==6))
	{
	temp=eeprom_read(DELAY1);
	temp++;
	eeprom_write(DELAY1,temp);
 	}
else if((UIB[0]==CMND)&&(UIB[1]==7)&&(UIB[2]==8))
	{
	temp=eeprom_read(DELAY1);
	temp--;
	eeprom_write(DELAY1,temp);
 	}
else if((UIB[0]==CMND)&&(UIB[1]==9)&&(UIB[2]==10))
	{
	temp=eeprom_read(DELAY2);
	temp++;
	eeprom_write(DELAY2,temp);
 	}
else if((UIB[0]==CMND)&&(UIB[1]==11)&&(UIB[2]==12))
	{
	temp=eeprom_read(DELAY2);
	temp--;
	eeprom_write(DELAY2,temp);
 	}
 	}

if(prog==p2)
	{

if((UIB[0]==CMND)&&(UIB[1]==5)&&(UIB[2]==6))
	{
	temp=eeprom_read(DELAY3);
	temp++;
	eeprom_write(DELAY3,temp);
 	}
else if((UIB[0]==CMND)&&(UIB[1]==7)&&(UIB[2]==8))
	{
	temp=eeprom_read(DELAY3);
	temp--;
	eeprom_write(DELAY3,temp);
 	}
else if((UIB[0]==CMND)&&(UIB[1]==9)&&(UIB[2]==10))
	{
	temp=eeprom_read(DELAY4);
	temp++;
	eeprom_write(DELAY4,temp);
 	}
else if((UIB[0]==CMND)&&(UIB[1]==11)&&(UIB[2]==12))
	{
	temp=eeprom_read(DELAY4);
	temp--;
	eeprom_write(DELAY4,temp);
 	}
 	}
}

//-----------------------------------------------
void UART_IN(void)
{
//static char flag;
char temp,i,count,index;
//int temp_int;
di();
count=rx_counter;
index=rx_wr_index;
ei();
if(count&&(rx_buffer[index_offset(index,-1)])==END)
	{
     temp=rx_buffer[index_offset(index,-3)];
    	if(temp<10)
    		{
    		if(control_check(index_offset(index,-1)))
    			{
    			rx_rd_index=index_offset(index,-3-temp);
    			for(i=0;i<temp;i++)
				{
				UIB[i]=rx_buffer[index_offset(rx_rd_index,i)];
				}
			rx_rd_index=index;
			rx_counter-=count;
			UART_IN_AN();
    			}
    		}

	}
//UART_IN_end:
//ei();
}

//***********************************************
//***********************************************
//***********************************************
//***********************************************
void interrupt isr(void)
{

di();

if(T0IF)
	{
	t0_init();
	T0IF=0;
	bit_100Hz=1;
	if((++cnt0)==10)
		{
		cnt0=0;
		bit_10Hz=1;
		if(++cnt1==10)
			{
			cnt1=0;
			bit_1Hz=1;
			}
		}
	}
if(RCIF)
	{
	rx_buffer[rx_wr_index] = sci_GetByte();
	bRXIN=1;
	if(++rx_wr_index>=RX_BUFFER_SIZE) rx_wr_index=0;
	if(++rx_counter>=RX_BUFFER_SIZE)
		{
		rx_wr_index=0;
		rx_rd_index=0;
		rx_counter=0;
		}

	}

if(TXIF && TXIE)
	{
	char* ptr;
	if(tx_rd_index!=tx_wr_index)
		{
		ptr=tx_buffer;
		ptr+=tx_rd_index;
		sci_PutByte(*ptr);
		tx_rd_index++;
		if(tx_rd_index==TX_BUFFER_SIZE)
			{
			tx_rd_index=0;
			}
		}
	else TXIE=0;
	}

ei();
}


//===============================================
//===============================================
//===============================================
//===============================================
void main(void)
{

t0_init();


ei();
PEIE=1;

di();



ei();

TRISB=0x00;
PORTB=0x00;
PORTC|=(1<<led_ERR);
sci_init();


while (1)
	{
	if(bRXIN)
		{
		bRXIN=0;
		UART_IN();
		}
	if(bit_100Hz)
		{
		bit_100Hz=0;

          in_read();
          step_contr();
          mdvr_drv();
		but_drv();
		but_an();
		}
	if(bit_10Hz)
		{
		bit_10Hz=0;
         // out_out();
         	led_out();
         	err_drv();
          prog_drv();

        	if(prog==p1) OUT(3,CMND,eeprom_read(DELAY1),eeprom_read(DELAY2),0,0,0);
        	else if(prog==p1) OUT(3,CMND,eeprom_read(DELAY3),eeprom_read(DELAY4),0,0,0);

		}
	if(bit_1Hz)
		{
		bit_1Hz=0;




		}


	}
}

