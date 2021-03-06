//��������� ��� ����� ��������� "������� �����������"(3 ��������)


#include <90s2313.h>
#include <delay.h>
#include <stdio.h>
#include <math.h>



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

enum {iMn,iSet} ind;
eeprom int delay_ee;
int delay_cnt;
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
void granee(eeprom signed int *adr, signed int min, signed int max)
{
if (*adr<min) *adr=min;
if (*adr>max) *adr=max; 
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
void int2ind(unsigned int in,char s,char fl)
{
bin2bcd_int(in);
bcd2ind(s);
if(fl)
	{
	if(bFL)
		{
		ind_out[0]=0b11111111;
		ind_out[1]=0b11111111;
		ind_out[2]=0b11111111;
		ind_out[3]=0b11111111;
		}
	}
} 

//-----------------------------------------------
void ind_hndl(void)
{
if(ind==iMn)
	{  
	int2ind(delay_ee,1,0);
	}
else  if(ind==iSet)
	{
	int2ind(delay_ee,1,1);
	} 
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
if(ind==iMn)
	{
	if(b0)
		{
		b0=0;
	     delay_cnt=delay_ee;
	     
		}
	else if(b1)
		{
    		b1=0;
	     delay_cnt=delay_ee;
		}
	else if(b0L)
		{
    		b0L=0;
	
		}
	else if(b1L)
		{
		b1L=0;
	
		}
	else if(b01)
		{
    		b01=0;
          ind=iSet;
		}
	}	 
if(ind==iSet)
	{
	if(b0)
		{
		b0=0;
	     delay_ee++;
		}
	else if(b1)
		{
    		b1=0;
	     delay_ee--;
		}
	else if(b0L)
		{
    		b0L=0;
	     delay_ee+=10;
		}
	else if(b1L)
		{
		b1L=0;
	     delay_ee-=10;
		}
	else if(b01)
		{
    		b01=0;
          ind=iMn;
		}
	granee(&delay_ee,1,100);
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


ind=iMn;
while (1)
	{

	if(b100Hz)
		{
		b100Hz=0;

		}             
	if(b10Hz)
		{
		b10Hz=0;
   	     but_an();
   	     if(delay_cnt)
   	     	{
   	     	DDRD.1=1;
   	     	PORTD.1=1;
   	     	delay_cnt--;
   	     	}
   	     else PORTD.1=0;	
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