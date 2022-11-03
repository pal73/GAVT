#define NUM_OF_SLAVE	3

#define HOST_MESS_LEN	5



#define MD1	3
#define MD2	7
#define VR1	2
#define VR2	6

#define PP1_1	6
#define PP1_2	7
#define PP1_3	5
#define PP1_4	4
#define PP2_1	3
#define PP2_2	2
#define PP2_3	1
#define PP2_4	0


bit b600Hz;
bit b100Hz;
bit b10Hz;
bit b1Hz;
char t0_cnt0_,t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3,t0_cnt4;
char ind_cnt;

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
eeprom enum{eamON=0x55,eamOFF=0xaa}ee_avtom_mode;
enum {p1=1,p2=2,p3=3,p4=4}prog;
//enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s100}step=sOFF;

char sub_ind;
char in_word,in_word_old,in_word_new,in_word_cnt;
bit bERR;
signed int cnt_del=0;

char cnt_md1,cnt_md2,cnt_vr1,cnt_vr2;

eeprom enum {coOFF=0x55,coON=0xaa}ch_on[6];
eeprom unsigned ee_timer1_delay;
bit opto_angle_old;
enum {msON=0x55,msOFF=0xAA}motor_state;
unsigned timer1_delay;

char stop_cnt,start_cnt;
char cnt_net_drv,cnt_drv;
char cmnd_byte,state_byte,crc_byte;

enum{sOFF,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16}step1=sOFF,step2=sOFF;
enum {mON='O',mOFF='F',mTST='T'}mode1=mOFF,mode2=mOFF;
signed char cnt_del1,cnt_del2;
char mode_new[2], mode_old[2];
char mode_cnt[2];

bit bVR1,bVR2;
bit bMD1,bMD2;
char out_stat,out_stat1,out_stat2; 
char cmnd_new,cmnd_old,cmnd,cmnd_cnt; 
char state_new,state_old,state,state_cnt;
char tst_new,tst_old,tst,tst_cnt;
char tst_step_cnt;

#include <mega16.h>
#include <stdio.h>
#include "usart_slave.c"


//-----------------------------------------------
void out_drv(void)
{
DDRB=0xff;
out_stat=out_stat1|out_stat2; 
PORTB=~out_stat; 
//PORTB=~step2;
}



//-----------------------------------------------
void out_usart (char num,char data0,char data1,char data2,char data3,char data4,char data5,char data6,char data7,char data8)
{
char i,t=0;

char UOB[12]; 
UOB[0]=data0;
UOB[1]=data1;
UOB[2]=data2;
UOB[3]=data3;
UOB[4]=data4;
UOB[5]=data5;
UOB[6]=data6;
UOB[7]=data7;
UOB[8]=data8;

for (i=0;i<num;i++)
	{
	putchar(UOB[i]);
	}   	
}

//-----------------------------------------------
void byte_drv(void)
{
cmnd_byte|=0x80;
state_byte=0xff;

if(ch_on[0]!=coON)state_byte&=~(1<<0);
if(ch_on[1]!=coON)state_byte&=~(1<<1);
if(ch_on[2]!=coON)state_byte&=~(1<<2);
if(ch_on[3]!=coON)state_byte&=~(1<<3);
if(ch_on[4]!=coON)state_byte&=~(1<<4);
if(ch_on[5]!=coON)state_byte&=~(1<<5);


}


//-----------------------------------------------
void in_drv(void)
{
char i,temp;
unsigned int tempUI;
DDRA&=0x33;
PORTA|=0xcc;
in_word_new=PINA|0x33;
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
void step1_contr(void)
{

out_stat1=0;
if(mode1==mOFF)step1=sOFF;

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
	out_stat1|=(1<<PP1_1);
	cnt_del1--;
	if(cnt_del1==0)
		{
		step1=s4;
		}
	
	}
else if(step1==s4)
	{
	out_stat1|=(1<<PP1_1)|(1<<PP1_2);
	if(bVR1)
		{
		step1=s5;
		cnt_del1=50;
		}
	}
else if(step1==s5)
	{
	out_stat1|=(1<<PP1_1)|(1<<PP1_2)|(1<<PP1_3);
	cnt_del1--;
	if(cnt_del1==0)
		{
		cnt_del1=80;
		step1=s6;
		}
	}
else if(step1==s6)
	{
	out_stat1|=(1<<PP1_1)|(1<<PP1_2)|(1<<PP1_3)|(1<<PP1_4);
	cnt_del1--;
	if(cnt_del1==0)
		{
		cnt_del1=60;
		step1=s7;
		}
	}
else if(step1==s7)
	{
	out_stat1|=(1<<PP1_1)|(1<<PP1_4);
	cnt_del1--;
	if(cnt_del1==0)
		{
		cnt_del1=20;
		step1=s8;
		}
	}
else if(step1==s8)
	{
	out_stat1|=(1<<PP1_4);
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
    
if(mode1==mTST)
    {
    out_stat1=0;

    if(tst_step_cnt==1)out_stat1|=(1<<PP1_1);
    else if(tst_step_cnt==2)out_stat1|=(1<<PP1_2);
    else if(tst_step_cnt==3)out_stat1|=(1<<PP1_3);
    else if(tst_step_cnt==4)out_stat1|=(1<<PP1_4);

    }
}

//-----------------------------------------------
void step2_contr(void)
{
out_stat2=0;
if(mode2==mOFF)step2=sOFF;

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
	out_stat2|=(1<<PP2_1);
	cnt_del2--;
	if(cnt_del2==0)
		{
		step2=s4;
		}
	
	}
else if(step2==s4)
	{
	out_stat2|=(1<<PP2_1)|(1<<PP2_2);
	if(bVR2)
		{
		step2=s5;
		cnt_del2=50;
		}
	}
else if(step2==s5)
	{
	out_stat2|=(1<<PP2_1)|(1<<PP2_2)|(1<<PP2_3);
	cnt_del2--;
	if(cnt_del2==0)
		{
		cnt_del2=80;
		step2=s6;
		}
	}
else if(step2==s6)
	{
	out_stat2|=(1<<PP2_1)|(1<<PP2_2)|(1<<PP2_3)|(1<<PP2_4);
	cnt_del2--;
	if(cnt_del2==0)
		{
		cnt_del2=60;
		step2=s7;
		}
	}
else if(step2==s7)
	{
	out_stat2|=(1<<PP2_1)|(1<<PP2_4);
	cnt_del2--;
	if(cnt_del2==0)
		{
		cnt_del2=20;
		step2=s8;
		}
	}
else if(step2==s8)
	{
	out_stat2|=(1<<PP2_4);
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

if(mode2==mTST)
    {
    out_stat1=0;

    if(tst_step_cnt==1)out_stat1|=(1<<PP2_1);
    else if(tst_step_cnt==2)out_stat1|=(1<<PP2_2);
    else if(tst_step_cnt==3)out_stat1|=(1<<PP2_3);
    else if(tst_step_cnt==4)out_stat1|=(1<<PP2_4);

    }
}

//-----------------------------------------------
void step1_contr_new_(void)
{

out_stat1=0;
if(mode1==mOFF)step1=sOFF;

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
		//cnt_del1=20;
		step1=s4;
		}
	}
    /*
else if(step1==s3)
	{
	out_stat1|=(1<<PP1_1);
	cnt_del1--;
	if(cnt_del1==0)
		{
		step1=s4;
		}
	
	}*/
else if(step1==s4)
	{
	out_stat1|=(1<<PP1_1)|(1<<PP1_2);
	if(bVR1)
		{
		step1=s5;
		cnt_del1=30;
		}
	}     
    
else if(step1==s5)
	{
	out_stat1|=(1<<PP1_1)|(1<<PP1_2)|(1<<PP1_3);
	cnt_del1--;
	if(cnt_del1==0)
		{
		cnt_del1=30;
		step1=s6;
		}
	}
else if(step1==s6)
	{
	out_stat1|=(1<<PP1_1)|(1<<PP1_2)|(1<<PP1_3)|(1<<PP1_4);
	cnt_del1--;
	if(cnt_del1==0)
		{
		cnt_del1=30;
		step1=s7;
		}
	}
else if(step1==s7)
	{
	out_stat1|=(1<<PP1_1)|(1<<PP1_2)|(1<<PP1_4);
	cnt_del1--;
	if(cnt_del1==0)
		{
		cnt_del1=20;
		step1=s8;
		}
	}
else if(step1==s8)
	{
	out_stat1|=(1<<PP1_1);
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

if(mode1==mTST)
    {
    out_stat1=0;
    if(tst_cnt==1)out_stat1|=(1<<PP1_1);
    else if(tst_cnt==2)out_stat1|=(1<<PP1_2);
    else if(tst_cnt==3)out_stat1|=(1<<PP1_3);
    else if(tst_cnt==4)out_stat1|=(1<<PP1_4);
    }
}

//-----------------------------------------------
void cmnd_an(void)
{  
/*DDRD.2=1;
PORTD.2=!PORTD.2;*/ 
if(cmnd==0x55)
	{
	if(mode1==mON)step1=s1;
	if(mode2==mON)
		{
		step2=s1;
		/*PORTD.2=!PORTD.2; */
		}
	}
else if(cmnd==0x33)
	{
	if(mode1==mON)step1=sOFF;
	if(mode2==mON)step2=sOFF;
	}	
	
}

//-----------------------------------------------
void state_an(void)
{  
#if(NUM_OF_SLAVE==1)
if(state&0x01)mode1=mON;
else if(!(tst&0x01))mode1=mTST;
else mode1=mOFF;

if(state&0x02)mode2=mON;
else if(!(tst&0x02))mode2=mTST;
else mode2=mOFF;

#elif(NUM_OF_SLAVE==2)
if(state&0x04)mode1=mON;
else if(!(tst&0x04))mode1=mTST;
else mode1=mOFF;

if(state&0x08)mode2=mON;
else if(!(tst&0x08))mode2=mTST;
else mode2=mOFF;

#elif(NUM_OF_SLAVE==3)
if(state&0x10)mode1=mON;
else if(!(tst&0x10))mode1=mTST;
else mode1=mOFF;

if(state&0x20)mode2=mON;
else if(!(tst&0x20))mode2=mTST;
else mode2=mOFF;
#endif	
}

//-----------------------------------------------
void uart_in_an(void)
{
if(rx_buffer[0]==NUM_OF_SLAVE)
	{
	char temp1,temp2,temp3,temp4;
	    
    mode_new[0]=rx_buffer[2];  
    if(mode_new[0]==mode_old[0])
        {
        if(mode_cnt[0]<4)
            {
            mode_cnt[0]++;
            if(mode_cnt[0]>=4)
                {                  
                if((mode_new[0]/*&0x7f*/)!=mode1)
                    {
                    mode1=mode_new[0]/*&0x7f*/; 
                    //mode1=mOFF;
                    }
                }         
            }	
        }
    else 
        {
        mode_cnt[0]=0;
        }
    mode_old[0]=mode_new[0];

    mode_new[1]=rx_buffer[3];  
    if(mode_new[1]==mode_old[1])
        {
        if(mode_cnt[1]<4)
            {
            mode_cnt[1]++;
            if(mode_cnt[1]>=4)
                {                  
                if((mode_new[1]/*&0x7f*/)!=mode2)
                    {
                    mode2=mode_new[1]/*&0x7f*/;
                    //mode2=mTST;
                    }
                }         
            }	
        }
    else 
        {
        mode_cnt[1]=0;
        }
    mode_old[1]=mode_new[1];
    
	temp1=NUM_OF_SLAVE;
	temp4=temp1;
	
	temp2=0x80;
	if(bVR1)temp2|=(1<<0);
	if(bMD1)temp2|=(1<<1);
	if(step1!=sOFF)temp2|=(1<<2);
	if(bVR2)temp2|=(1<<3);
	if(bMD2)temp2|=(1<<4);
	if(step2!=sOFF)temp2|=(1<<5);
	//temp2=0xff;
    
	temp4^=temp2;
	
	temp3=0x80;
	temp4^=temp3;
	
	temp4|=0x80;
	
	out_usart(4,temp1,temp2,temp3,temp4,0,0,0,0,0);
    //out_usart(4,1,2,3,0x55,0,0,0,0,0);	

	}

cmnd_new=rx_buffer[1];
if(cmnd_new==cmnd_old)
	{
	if(cmnd_cnt<4)
		{
		cmnd_cnt++;
		if(cmnd_cnt>=4)
			{                  
			if((cmnd_new&0x7f)!=cmnd)
				{
				cmnd=cmnd_new&0x7f;
				cmnd_an();
				}
			}         
		}	
	}		
else cmnd_cnt=0;
cmnd_old=cmnd_new;
/*
state_new=rx_buffer[2];
if(state_new==state_old)
	{
	if(state_cnt<4)
		{
		state_cnt++;
		if(state_cnt>=4)
			{                  
			if((state_new&0x7f)!=state)
				{
				state=state_new&0x7f;
				//state_an();
				}
			}         
		}	
	}		
else state_cnt=0;
state_old=state_new;

tst_new=rx_buffer[3];
if(tst_new==tst_old)
	{
	if(tst_cnt<4)
		{
		tst_cnt++;
		if(tst_cnt>=4)
			{                  
			if((tst_new&0x7f)!=tst)
				{
				tst=tst_new&0x7f;
				//state_an();
				}
			}         
		}	
	}		
else tst_cnt=0;
tst_old=tst_new;*/
	 
/*state=rx_buffer[2];
state_an();*/					
	
}

//-----------------------------------------------
void mathemat(void)
{
timer1_delay=ee_timer1_delay*31;
}


//-----------------------------------------------
void led_hndl(void)
{

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

#define butA	239
#define butA_	237
#define butP	251
#define butP_	249
#define butR	127
#define butR_	125
#define butL	254
#define butL_	252
#define butLR	126
#define butLR_	124




//***********************************************
//***********************************************
//***********************************************
//***********************************************
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
TCCR0=0x05;
TCNT0=-78;
OCR0=0x00;

b100Hz=1;

if(++t0_cnt1>=10)
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
        
	if(++t0_cnt4>=10)
		{
		t0_cnt4=0;
		b1Hz=!b1Hz;
		}        		
	}
}

//***********************************************
// Timer 1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{

}


//===============================================
//===============================================
//===============================================
//===============================================

void main(void)
{

PORTA=0xff;
DDRA=0x00;

PORTB=0x00;
DDRB=0xFF;

PORTC=0x00;
DDRC=0x00;


PORTD=0x00;
DDRD=0x00;


TCCR0=0x02;
TCNT0=-99;
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

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud rate: 19200
UCSRA=0x00;
UCSRB=0xD8;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x19;

MCUCR=0x00;
MCUCSR=0x00;

TIMSK=0x01;

ACSR=0x80;
SFIOR=0x00;

#asm("sei")
led_hndl();
ch_on[0]=coON;
//ee_avtom_mode=eamOFF; 
//ind=iSet_delay;
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
        step1_contr();
		step2_contr();
        out_drv();
    	}   
	if(b10Hz)
		{
		b10Hz=0;
		
        led_hndl();
        mathemat();
        DDRD.2=1;
        if(step2!=sOFF) PORTD.2=0;   
        else PORTD.2=1;
        
        DDRC=0xFF;
        
        }
	if(b1Hz)
		{
		b1Hz=0;
        
        if(++tst_step_cnt>=5)tst_step_cnt=0;
        }
      };
}




