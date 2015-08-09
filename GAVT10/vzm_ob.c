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

bit bPP1;
bit bPP2;

#define PP1	4
#define PP2	3
#define PP1_1	7
#define PP1_2	6
#define PP1_3	5
#define PP1_4	4
#define PP2_1	0
#define PP2_2	1
#define PP2_3	2
#define PP2_4	3

#define START	6
#define STOP	5
#define MD		13

#define MD1		0
#define VR1		2
#define MD2		15
#define VR2		14
//5 слева вход - маска (1<<0)	  //// Мгнитный датчик первого плеча	
//4 слева вход - маска (1<<1) оптрон не запаян
//6 слева вход - маска (1<<2)     	
//3 слева вход - маска (1<<3) оптрон не запаян
//2 слева вход - маска (1<<5)     ////СТОП
//1 слева вход - маска (1<<6)	  ////СТАРТ
//13 слева вход - маска (1<<8)    ////тумблер 2плечо
//12 слева вход - маска (1<<9)	  ////тумблер 1плечо	
//14 слева вход - маска (1<<10)   ////тумблер цикл/ручной
//11 слева вход - маска (1<<11)	  ////
//10 слева вход - маска (1<<12)
//9 слева вход - маска (1<<13)    //// Мгнитный датчик главного цикла//// Вакуумное реле второго плеча	
//8 слева вход - маска (1<<14)	  //// Вакуумное реле второго плеча
//7 слева вход - маска (1<<15)	  //// Мгнитный датчик второго плеча
//#define VR	0  кнопка старт
//#define VR	2  кнопка стоп

#define PROG1	10
//#define PROG1	11
#define PROG2	8
#define PROG3	9

#define BIG_CAM


__CONFIG (0x3d7a);


//char adc_cnt;
//char tmr1_init;
bit bit_100Hz;
bit bit_10Hz;
bit bit_1Hz;
bit bVR1,bVR2;
bit bMD,bMD1,bMD2;
bit bERR;
/*bit bV1;
bit bV0;*/

unsigned int in_word;



unsigned but_n;
unsigned but_s;
unsigned but/*,but_but*/;
char enum{sOFF,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16}step1=sOFF,step2=sOFF,step_main=sOFF;
char enum{p1,p2,p3,pOFF}prog=p1;
char but0_cnt,but1_cnt;
char but_onL_temp;
signed char cnt_del1,cnt_del2,cnt_del_main;

char cnt_md,cnt_md1,cnt_md2,cnt_vr1,cnt_vr2;


bit l_but;		//идет длинное нажатие на кнопку
bit n_but;          //произошло нажатие
bit speed;		//разрешение ускорения перебора




char cnt0,cnt1,temper,temp,vol_l,vol_i;
char cnt_but_START,cnt_but_STOP;

bit bON_START,bON_STOP;

signed char sw1_cnt,sw2_cnt,sw_loop_cnt;
enum {lsON,lsOFF}loop_stat;
enum {mON,mOFF}mode1,mode2;
signed char od1_cnt,od2_cnt;
enum {odON,odOFF}od1,od2;


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
void tumbler_drv(void)
{
if(!(in_word&(1<<9)))
	{
	if(sw1_cnt<30)sw1_cnt++;
	}
else
	{
	if(sw1_cnt)sw1_cnt--;
	} 

if(!(in_word&(1<<8)))
	{
	if(sw2_cnt<30)sw2_cnt++;
	}
else
	{
	if(sw2_cnt)sw2_cnt--;
	}

if(!(in_word&(1<<10)))
	{
	if(sw_loop_cnt<30)sw_loop_cnt++;
	}
else
	{
	if(sw_loop_cnt)sw_loop_cnt--;
	}  


if(sw_loop_cnt>=25)loop_stat=lsON;
else if(sw_loop_cnt<=5)loop_stat=lsOFF;

if(sw1_cnt>=25)mode1=mON;
else if(sw1_cnt<=5)mode1=mOFF;

if(sw2_cnt>=25)mode2=mON;
else if(sw2_cnt<=5)mode2=mOFF;
}


//-----------------------------------------------
void od_drv(void)
{
#define OD1	7
#define OD2	6

if(!(PORTC&(1<<OD1)))
	{
	if(od1_cnt<10)od1_cnt++;
	}
else
	{
	if(od1_cnt>0)od1_cnt--;
	} 

if(!(PORTC&(1<<OD2)))
	{
	if(od2_cnt<10)od2_cnt++;
	}
else
	{
	if(od2_cnt>0)od2_cnt--;
	} 

if(od1_cnt>=9)od1=odON;
else if(od1_cnt<=1)od1=odOFF;

if(od2_cnt>=9)od2=odON;
else if(od2_cnt<=1)od2=odOFF;

TRISC&=((1<<OD1)||(1<<OD2))^0xff;
}

//-----------------------------------------------
void step_main_contr(void)
{
bPP1=0;
bPP2=0;

if(step_main==sOFF)
	{
	}
else if(step_main==s1)
	{
	if(((od1==odON)||(mode1!=mON))&&((od2==odON)||(mode2!=mON)))
		{
		step_main=s2;
		cnt_del_main=30;
		}
	}
else if(step_main==s2)
	{
	bPP1=1;
	cnt_del_main--;
	if(cnt_del_main==0)
		{
		step_main=s3;
		}
	}
else if(step_main==s3)
	{
	bPP1=1;
	bPP2=1;
	if(bMD)
		{
		step_main=s4;
		cnt_del_main=30;
		}
	
	}
else if(step_main==s4)
	{
	bPP2=1;
	cnt_del_main--;
	if(cnt_del_main==0)
		{
		step_main=s5;
		}
	}
else if(step_main==s5)
	{
	if(mode1==mON) step1=s1;
	if(mode2==mON) step2=s1;
	step_main=s6;
	}
else if(step_main==s6)
	{
	if(((step1==sOFF)||(mode1!=mON))&&((step2==sOFF)||(mode2!=mON)))
		{
		if(loop_stat==lsON)step_main=s1;
		else step_main=sOFF;
		}
	}
	
TRISC4=0;
if(bPP1)PORTC|=(1<<4);
else PORTC&=~(1<<4);
TRISC5=0;
if(bPP2)PORTC|=(1<<5);
else PORTC&=~(1<<5);

}

//-----------------------------------------------
void step1_contr(void)
{
char temp;
temp=0;
if((step_main==sOFF)||(mode1==mOFF))step1=sOFF;

if(step1==sOFF)
	{
	
	}
else if(step1==s1)
	{
	cnt_del1=20;
	step1=s2;
	}
else if(step1==s2)
	{
	cnt_del1--;
	if(cnt_del1==0)
		{
		cnt_del1=20;
		step1=s3;
		}
	}
else if(step1==s3)
	{
	temp|=(1<<PP1_1);
	cnt_del1--;
	if(cnt_del1==0)
		{
		step1=s4;
		}
	
	}
else if(step1==s4)
	{
	temp|=(1<<PP1_1)|(1<<PP1_2);
	if(bVR1)
		{
		step1=s5;
		cnt_del1=50;
		}
	}
else if(step1==s5)
	{
	temp|=(1<<PP1_1)|(1<<PP1_2)|(1<<PP1_3);
	cnt_del1--;
	if(cnt_del1==0)
		{
		cnt_del1=80;
		step1=s6;
		}
	}
else if(step1==s6)
	{
	temp|=(1<<PP1_1)|(1<<PP1_2)|(1<<PP1_3)|(1<<PP1_4);
	cnt_del1--;
	if(cnt_del1==0)
		{
		cnt_del1=60;
		step1=s7;
		}
	}
else if(step1==s7)
	{
	temp|=(1<<PP1_1)|(1<<PP1_4);
	cnt_del1--;
	if(cnt_del1==0)
		{
		cnt_del1=20;
		step1=s8;
		}
	}
else if(step1==s8)
	{
	temp|=(1<<PP1_4);
	cnt_del1--;
	if(cnt_del1==0)
		{
		step1=s9;
		}
	}
else if(step1==s9)
	{
	if(bMD1)
		{
		step1=sOFF;
		}
	}

PORTB&=(0xff^((1<<PP1_1)|(1<<PP1_2)|(1<<PP1_3)|(1<<PP1_4)));
PORTB|=temp;
}

//-----------------------------------------------
void step2_contr(void)
{
char temp;
temp=0;
if((step_main==sOFF)||(mode2==mOFF))step2=sOFF;

if(step2==sOFF)
	{
	
	}
else if(step2==s1)
	{
	cnt_del2=20;
	step2=s2;
	}
else if(step2==s2)
	{
	cnt_del2--;
	if(cnt_del2==0)
		{
		cnt_del2=20;
		step2=s3;
		}
	}
else if(step2==s3)
	{
	temp|=(1<<PP2_1);
	cnt_del2--;
	if(cnt_del2==0)
		{
		step2=s4;
		}
	
	}
else if(step2==s4)
	{
	temp|=(1<<PP2_1)|(1<<PP2_2);
	if(bVR2)
		{
		step2=s5;
		cnt_del2=50;
		}
	}
else if(step2==s5)
	{
	temp|=(1<<PP2_1)|(1<<PP2_2)|(1<<PP2_3);
	cnt_del2--;
	if(cnt_del2==0)
		{
		cnt_del2=80;
		step2=s6;
		}
	}
else if(step2==s6)
	{
	temp|=(1<<PP2_1)|(1<<PP2_2)|(1<<PP2_3)|(1<<PP2_4);
	cnt_del2--;
	if(cnt_del2==0)
		{
		cnt_del2=60;
		step2=s7;
		}
	}
else if(step2==s7)
	{
	temp|=(1<<PP2_1)|(1<<PP2_4);
	cnt_del2--;
	if(cnt_del2==0)
		{
		cnt_del2=20;
		step2=s8;
		}
	}
else if(step2==s8)
	{
	temp|=(1<<PP2_4);
	cnt_del2--;
	if(cnt_del2==0)
		{
		step2=s9;
		}
	}
else if(step2==s9)
	{
	if(bMD2)
		{
		step2=sOFF;
		}
	}

PORTB&=(0xff^((1<<PP2_1)|(1<<PP2_2)|(1<<PP2_3)|(1<<PP2_4)));
PORTB|=temp;
}



//-----------------------------------------------
void led_out(void)
{
char temp=0;
TRISC&=0xF0;

temp&=~(1<<led_NET);

if((step1==sOFF)&&(step2==sOFF)&&(step_main==sOFF))
	{
	temp|=(1<<led_WORK);
	}
else temp&=~(1<<led_WORK);

temp|=(1<<led_ERR);

if((step_main==sOFF)&&(bMD))
	{
	temp&=~(1<<led_ERR);
	}
if((mode1==mON)&&(step1==sOFF)&&(bMD1||bVR1))
	{
	temp&=~(1<<led_ERR);
	}
if((mode2==mON)&&(step2==sOFF)&&(bMD2||bVR2))
	{
	temp&=~(1<<led_ERR);
	}

PORTC=(PORTC|0b00001111)&(temp|0b11110000);
//bON_START=0;
//bON_STOP=0;
}

//-----------------------------------------------
void mdvr_drv(void)
{
if(!(in_word&(1<<MD)))
	{
	if(cnt_md<10)
		{
		cnt_md++;
		if(cnt_md==10) bMD=1;
		}

	}
else
	{
	if(cnt_md)
		{
		cnt_md--;
		if(cnt_md==0) bMD=0;
		}

	}

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

if(!(in_word&(1<<VR1)))
	{
	if(cnt_vr1<10)
		{
		cnt_vr1++;
		if(cnt_vr1==10) bVR1=1;
		}

	}
else
	{
	if(cnt_vr1)
		{
		cnt_vr1--;
		if(cnt_vr1==0) bVR1=0;
		}

	}

if(!(in_word&(1<<VR2)))
	{
	if(cnt_vr2<10)
		{
		cnt_vr2++;
		if(cnt_vr2==10) bVR2=1;
		}

	}
else
	{
	if(cnt_vr2)
		{
		cnt_vr2--;
		if(cnt_vr2==0) bVR2=0;
		}

	}
}

//-----------------------------------------------
void err_drv(void)
{
/*if(step==sOFF)
	{
	if((bMD1)||(bMD2)||(bVR1)) bERR=1;
	else bERR=0;
	}
else bERR=0;*/
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
else if((!(in_word&(1<<PROG3)))&&(in_word&(1<<PROG2))&&(in_word&(1<<PROG1)))
	{
	prog=p3;
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
if(!(in_word&(1<<START)))
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

if(!(in_word&(1<<STOP)))
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
	if((step_main==sOFF)&&(step2==sOFF)&&(step2==sOFF)&&(!bERR))
		{
		step_main=s1;
		}
	}
if(bON_STOP)
	{
	step_main=sOFF;
	step1=sOFF;
	step2=sOFF;
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
//TMR0=-40; // 4mgz
//TMR0=-80;  //8mgz
TMR0=-100;  //10mgz
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



PEIE=1;







TRISB=0x00;
PORTB=0x00;


TRISC4=0;
PORTC&=~(1<<4);
TRISC5=0;
PORTC&=~(1<<5);
ei();
while (1)
	{
	if(bit_100Hz)
		{
		bit_100Hz=0;

        in_read();
          
        mdvr_drv();
		step_main_contr();
		step1_contr();
		step2_contr();
		but_drv();
		but_an();
		tumbler_drv();
		od_drv();
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

