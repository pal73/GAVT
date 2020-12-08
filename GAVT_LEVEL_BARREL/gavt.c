#define LED_POW_ON	5
#define LED_PROG4	1
#define LED_PROG2	2
#define LED_PROG3	3
#define LED_PROG1	4 
#define LED_ERROR	0 
#define LED_WRK	6
#define LED_VACUUM	7

#define GAVT3

//Датчик верхний
#define D_1	5
//Датчик нижний
#define D_2	 0
//Главная клавиша, включает рабочий цикл
#define KL_MAIN	6
//Вторая клавиша, включает ручную перекачку
#define KL1	2

#define PP1	0
#define PP2	1
#define LED_PRON	6
#define DV	7 

bit b600Hz;

bit b100Hz;
bit b10Hz;
char t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3;
char ind_cnt;
flash char IND_STROB[]={0b10111111,0b11011111,0b11101111,0b11110111,0b01111111};
flash char DIGISYM[]={0b11000000,0b11111001,0b10100100,0b10110000,0b10011001,0b10010010,0b10000010,0b11111000,0b10000000,0b10010000,0b11111111};								

char ind_out[5]={0x255,0x255,0x255,0x255,0x255};
char dig[4];
bit bZ;    
char but;
static char but_n;
static char but_s;
static char but0_cnt;
static char but1_cnt;
static char but_onL_temp;
bit l_but;		//идет длинное нажатие на кнопку
bit n_but;          //произошло нажатие
bit speed;		//разрешение ускорения перебора 
bit bFL2; 
bit bFL5;
eeprom enum{evmON=0x55,evmOFF=0xaa}ee_vacuum_mode;
eeprom char ee_program[2];
enum {p1=1,p2=2,p3=3,p4=4}prog;
enum{sOFF=0,sUP1,sUP2,sDN1,sDN2,sUP1m,sUP2m,sDN1m,sDN2m}step=sOFF;
enum {iMn,iPr_sel,iVr} ind;
char sub_ind;
char in_word,in_word_old,in_word_new,in_word_cnt;
bit bERR;
signed int cnt_del=0;

char bKL_MAIN;      //если 1 то включен главный цикл, если 0 то ручная перекачка
char bD1;           //уровень выше верхней метки
bit bD2;            //уровень выше нижней метки
bit bKL1;           //инициализация ручной перекачки
//bit bVR2;
char cnt_d1,cnt_d2,cnt_kl_main,cnt_kl1,cnt_vr2;

eeprom unsigned ee_delay[4][2];
eeprom char ee_vr_log;
//#include <mega16.h>
//#include <mega8535.h>
#include <mega32.h>
//-----------------------------------------------
void prog_drv(void)
{
/*char temp,temp1,temp2;

temp=ee_program[0];
temp1=ee_program[1];
temp2=ee_program[2];

if((temp==temp1)&&(temp==temp2))
	{
	}
else if((temp==temp1)&&(temp!=temp2))
	{
	temp2=temp;
	}
else if((temp!=temp1)&&(temp==temp2))
	{
	temp1=temp;
	}
else if((temp!=temp1)&&(temp1==temp2))
	{
	temp=temp1;
	}
else if((temp!=temp1)&&(temp!=temp2))
	{
	temp=MINPROG;
	temp1=MINPROG;
	temp2=MINPROG;
	}

if(!((temp<=MAXPROG)&&(temp>=MINPROG)))
	{
	temp=MINPROG;
	}

if(temp!=ee_program[0])ee_program[0]=temp;
if(temp!=ee_program[1])ee_program[1]=temp;
if(temp!=ee_program[2])ee_program[2]=temp;

prog=temp; */
}

//-----------------------------------------------
void in_drv(void)
{
char i,temp;
unsigned int tempUI;
DDRA=0x00;
PORTA=0xff;
in_word_new=PINA;
if(in_word_old==in_word_new)
	{
	if(in_word_cnt<10)
		{
		in_word_cnt++;
		if(in_word_cnt>=10)
			{
			in_word=in_word_old;
			}
		}
	}
else in_word_cnt=0;


in_word_old=in_word_new;
}   



//-----------------------------------------------
void mdvr_drv(void)
{
if(!(in_word&(1<<D_1)))
	{
	if(cnt_d1<10)
		{
		cnt_d1++;
		if(cnt_d1==10) bD1=1;
		}

	}
else
	{
	if(cnt_d1)
		{
		cnt_d1--;
		if(cnt_d1==0) bD1=0;
		}

	}

if(!(in_word&(1<<D_2)))
	{
	if(cnt_d2<10)
		{
		cnt_d2++;
		if(cnt_d2==10) bD2=1;
		}

	}
else
	{
	if(cnt_d2)
		{
		cnt_d2--;
		if(cnt_d2==0) bD2=0;
		}

	}

if(!(in_word&(1<<KL_MAIN)))
	{
	if(cnt_kl_main<10)
		{
		cnt_kl_main++;
		if(cnt_kl_main==10) bKL_MAIN=1;
		}

	}
else
	{
	if(cnt_kl_main)
		{
		cnt_kl_main--;
		if(cnt_kl_main==0) bKL_MAIN=0;
		}

	}

if(!(in_word&(1<<KL1)))
	{
	if(cnt_kl1<10)
		{
		cnt_kl1++;
		if(cnt_kl1==10) bKL1=1;
		}

	}
else
	{
	if(cnt_kl1)
		{
		cnt_kl1--;
		if(cnt_kl1==0) bKL1=0;
		}

	}	
} 




//-----------------------------------------------
void step_contr(void)
{
static char temp;
//temp=0;
DDRB=0xFF;


if(!bKL_MAIN)
    { 
    temp=0;
    if(step==sOFF)
        {
        if((!bD1)&&(!bD2))
            {
            step=sDN1;
            cnt_del=20;
            } 
        if((bD1)&&(bD2))
            {
            step=sUP1;
            cnt_del=20;
            }            
        }
    else if(step==sUP1)
        {
        temp|=(1<<PP1);
        cnt_del--;
		if(cnt_del==0)
            {
            step=sUP2;
            }
        }
    else if(step==sUP2)
        {
        if((!bD1)&&(!bD2))
            {
            step=sDN1;
            cnt_del=20;
            } 
        }
    else if(step==sDN1)
        { 
        temp|=(1<<PP1);
        cnt_del--;
		if(cnt_del==0)
            {
            step=sDN2;
            }        
        }
    else if(step==sDN2)
        {
        temp|=(1<<PP1)|(1<<DV);
        if((bD1)&&(bD2))
            {
            step=sUP1;
            cnt_del=20;
            } 
        } 
    else if(step==sUP1m)
        {
        temp|=(1<<PP2); 
        if(cnt_del==0)cnt_del=20;
        cnt_del--;
		if(cnt_del==0)
            {
            step=sOFF;
            }
        } 
    else if(step==sDN1m)
        { 
        temp|=(1<<PP2);
        if(cnt_del==0)cnt_del=20;
        cnt_del--; 
		if(cnt_del==0)
            {
            step=sOFF;
            }        
        } 
    else if(step==sDN2m)
        {
        temp|=(1<<PP2)|(1<<DV);
        if(cnt_del==0)cnt_del=20;
        cnt_del--; 
		if(cnt_del==0)
            {
            step=sUP1m;
            cnt_del=20;
            }  
        }                        
    temp|=(1<<LED_PRON); 
    
    //temp=~temp;
   // temp^=(1<<PP1);
   //if(bD1)temp=0xff;
   //else temp=0x00;           
    }
else
    {
    temp=0; 
    if(step==sOFF)
        {
        if(bKL1)
            {
            step=sDN1m;
            cnt_del=20;
            }            
        }
    else if(step==sUP1m)
        {
        temp|=(1<<PP2);
        cnt_del--;
		if(cnt_del==0)
            {
            step=sUP2m;
            }
        }
    else if(step==sUP2m)
        {
        if(bKL1)
            {
            step=sDN1m;
            cnt_del=20;
            } 
        }
    else if(step==sDN1m)
        { 
        temp|=(1<<PP2);
        cnt_del--;
		if(cnt_del==0)
            {
            step=sDN2m;
            }        
        }
    else if(step==sDN2m)
        {
        temp|=(1<<PP2)|(1<<DV);
        if(!bKL1)
            {
            step=sUP1m;
            cnt_del=20;
            } 
        } 
    else if(step==sUP1)
        {
        temp|=(1<<PP1); 
        if(cnt_del==0)cnt_del=20;
        cnt_del--;
		if(cnt_del==0)
            {
            step=sOFF;
            }
        } 
    else if(step==sDN1)
        { 
        temp|=(1<<PP1);
        if(cnt_del==0)cnt_del=20;
        cnt_del--; 
		if(cnt_del==0)
            {
            step=sOFF;
            }        
        } 
    else if(step==sDN2)
        {
        temp|=(1<<PP1)|(1<<DV);
        if(cnt_del==0)cnt_del=20;
        cnt_del--; 
		if(cnt_del==0)
            {
            step=sUP1;
            cnt_del=20;
            }  
        }                         
    //    temp^=(1<<PP2);           
    }


//temp|=(1<<PP2);

PORTB=~temp;
//PORTB=~PORTB;
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
		ind_out[3-s]&=0b01111111;
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
void led_hndl(void)
{
DDRC=0xff;
PORTC.3=!bD1;
PORTC.2=!bD2;
}

//-----------------------------------------------
// Подпрограмма драйва до 7 кнопок одного порта, 
// различает короткое и длинное нажатие,
// срабатывает на отпускание кнопки, возможность
// ускорения перебора при длинном нажатии...
#define but_port PORTC
#define but_dir  DDRC
#define but_pin  PINC
#define but_mask 0b01101010
#define no_but   0b11111111
#define but_on   5
#define but_onL  20




void but_drv(void)
{ 
DDRD&=0b00000111;
PORTD|=0b11111000;

but_port|=(but_mask^0xff);
but_dir&=but_mask;
#asm
nop
nop
nop
nop
#endasm

but_n=but_pin|but_mask; 

if((but_n==no_but)||(but_n!=but_s))
 	{
 	speed=0;
   	if (((but0_cnt>=but_on)||(but1_cnt!=0))&&(!l_but))
  		{
   	     n_but=1;
          but=but_s;
          }
   	if (but1_cnt>=but_onL_temp)
  		{
   	     n_but=1;
          but=but_s&0b11111101;
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
    			but=but_s&0b11111101;
    			but1_cnt=0;
    			n_but=1;
    			l_but=1;
			if(speed)
				{
    				but_onL_temp=but_onL_temp>>1;
        			if(but_onL_temp<=2) but_onL_temp=2;
				}    
   			}
  		} 
 	}
but_drv_out:
but_s=but_n;
but_port|=(but_mask^0xff);
but_dir&=but_mask;
}    


//***********************************************
//***********************************************
//***********************************************
//***********************************************
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
TCCR0=0x02;
TCNT0=-208;
OCR0=0x00; 


b600Hz=1;
if(++t0_cnt0>=6)
	{
	t0_cnt0=0;
	b100Hz=1;
	}

if(++t0_cnt1>=60)
	{
	t0_cnt1=0;
	b10Hz=1;
	
	if(++t0_cnt2>=2)
		{
		t0_cnt2=0;
		bFL5=!bFL5;
		}
		
	if(++t0_cnt3>=5)
		{
		t0_cnt3=0;
		bFL2=!bFL2;
		}		
	}
}

//===============================================
//===============================================
//===============================================
//===============================================

void main(void)
{

PORTA=0xff;
DDRA=0x00;

PORTB=0xff;
DDRB=0xFF;

PORTC=0x00;
DDRC=0x00;


PORTD=0x00;
DDRD=0x00;


TCCR0=0x02;
TCNT0=-208;
OCR0=0x00;

TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;


ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

MCUCR=0x00;
MCUCSR=0x00;

TIMSK=0x01;

ACSR=0x80;
SFIOR=0x00;

#asm("sei") 
PORTB=0xFF;
DDRB=0xFF;
DDRD.1=1;
PORTD.1=1;  

ind=iMn;
prog_drv();
led_hndl();
while (1)
      {
      if(b600Hz)
		{
		b600Hz=0; 
          
		}         
      if(b100Hz)
		{        
		b100Hz=0; 
	    in_drv();
        mdvr_drv();
        
		}   
	if(b10Hz)
		{
		b10Hz=0;
		prog_drv();
		
        led_hndl();
        step_contr();
        
       // bD1=1;
       // bD2=!bD2;  
        }

      };
}
