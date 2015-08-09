#define XTAL_FREQ 4MHZ
#include <pic.h>
#include "delay.h"

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
#define VR	13

//#define VR	0  ������ �����
//#define VR	2  ������ ����

#define PROG1	10
#define PROG2	8
#define PROG3	9




__CONFIG (0x3d7a);


//char adc_cnt;
//char tmr1_init;
bit bit_100Hz;
bit bit_10Hz;
bit bit_1Hz;
bit bVR;
bit bMD1;
bit bMD2;
bit bERR;
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
signed char cnt_del=0;

char cnt_md1,cnt_md2,cnt_vr;


bit l_but;		//���� ������� ������� �� ������
bit n_but;          //��������� �������
bit speed;		//���������� ��������� ��������




char cnt0,cnt1,temper,temp,vol_l,vol_i;
char cnt_but_START,cnt_but_STOP;

bit bON_START,bON_STOP;

//**********************************************
//��������
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
void step_contr(void)
{
char temp=0;
TRISB=0x00;
if(step==sOFF)
	{
	temp=0;
	}

if(prog==p1)
	{
	if(step==s1)
		{
		temp|=(1<<PP1);

		cnt_del--;
		if(cnt_del==0)
			{
			step=s2;
			}
		}

	else if(step==s2)
		{
		temp|=(1<<PP1)|(1<<PP2);

          	if(!bMD1)goto step_contr_end;

                cnt_del=10;
		step=s3;
		}

	else if(step==s3)
		{
		temp|=(1<<PP1);
		cnt_del--;
		if(cnt_del==0)
			{
			step=s4;
			}
		}

	else if(step==s4)
		{
		temp|=(1<<PP1)|(1<<PP3);

          	if(!bMD2)goto step_contr_end;


		step=sOFF;
		}
	}

if(prog==p2)
	{

	if(step==s1)
		{
		temp|=(1<<PP1);

		cnt_del--;
		if(cnt_del==0)
			{
			step=s2;
			}
		}

	else if(step==s2)
		{
		temp|=(1<<PP1)|(1<<PP2);

          	if(!bMD1)goto step_contr_end;

               	step=sOFF;
		}
 	}


step_contr_end:



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
//if(!(in_word&(1<<6)))
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
if(!(in_word&(1<<PROG1)))
	{
	prog=p1;
	}
else if((in_word&(1<<PROG2)))
	{
	prog=p2;
	}

else prog=pOFF;
}

//-----------------------------------------------
// ������������ ������ �� 16 ������
// ��������� �������� � ������� �������,
// ����������� �� ���������� ������, �����������
// ��������� �������� ��� ������� �������...
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
		if(prog==p1) cnt_del=30;
		else if(prog==p2) cnt_del=30;


		}
	}
if(bON_STOP)
	{
	step=sOFF;

	}

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
//

while (1)
	{
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

         	led_out();
         	err_drv();
          	prog_drv();


		}
	if(bit_1Hz)
		{
		bit_1Hz=0;
		}


	}
}

