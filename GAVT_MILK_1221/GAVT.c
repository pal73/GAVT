#define LED_POW_ON	5
#define LED_MAIN_LOOP	1

#define LED_NAPOLN	2 
#define LED_PAYKA	3
#define LED_ERROR	0 
#define LED_WRK	6
#define LED_LOOP_AUTO	7
#define LED_PROG4	1
#define LED_PROG2	2
#define LED_PROG3	3
#define LED_PROG1	4 
#define MAXPROG	1

#define PIN_START   0
#define PIN_STOP    1
#define PIN_MD1     2
#define PIN_BOTL    3
#define PIN_PUMP    4
#define PIN_AVT     5

//#define SW1	6
//#define SW2	7

#define PP1	6
#define PP2	7


bit b600Hz;

bit b100Hz;
bit b10Hz;
bit b1Hz;
char t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3;
short t0_cnt4;
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
bit speed;		//разрешение ускорени€ перебора 
bit bFL2; 
bit bFL5;
eeprom enum{elmAUTO=0x55,elmMNL=0xaa}ee_loop_mode;
//eeprom char ee_program[2];
eeprom enum {p1=1,p2=2,p3=3,p4=4}ee_prog;
enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}step=sOFF;
enum {iMn,iPr_sel,iSet} ind;
char sub_ind;
char in_word,in_word_old,in_word_new,in_word_cnt;
bit bERR;
signed int cnt_del=0;

//bit bSW1,bSW2;

bit bSTART, bSTOP, bMD1, bBOTL, bBOTL_OLD, bBOTL_CH, bPUMP, bPUMP_OFF, bPUMP_OLD, bAVT, bSTOP_PROCESS, bSTOP_LONG;    
//char cnt_sw1,cnt_sw2;

//eeprom unsigned ee_delay[4,2];
//eeprom char ee_vr_log;
#include <mega16.h>
//#include <mega8535.h>  

bit bPP1,bPP2,bPP3,bPP4,bPP5,bPP6,bPP7,bPP8;

//enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}payka_step=sOFF,napoln_step=sOFF,orient_step=sOFF,main_loop_step=sOFF;
enum{cmdOFF=0,cmdSTART,cmdSTOP}payka_cmd=cmdOFF,napoln_cmd=cmdOFF,orient_cmd=cmdOFF,main_loop_cmd=cmdOFF;
signed short payka_cnt_del,napoln_cnt_del,orient_cnt_del,main_loop_cnt_del;
eeprom signed short ee_temp1,ee_temp2;

bit bPAYKA_COMPLETE=0,bNAPOLN_COMPLETE=0,bORIENT_COMPLETE=0;

eeprom signed short ee_temp3,ee_temp4;

#define EE_PROG_FULL		0
#define EE_PROG_ONLY_ORIENT 	1
#define EE_PROG_ONLY_NAPOLN	2
#define EE_PROG_ONLY_PAYKA	3
#define EE_PROG_ONLY_MAIN_LOOP 	4 

short time_cnt;
short adc_output;

#define FIRST_ADC_INPUT 2
#define LAST_ADC_INPUT 2
unsigned int adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
#define ADC_VREF_TYPE 0x40
// ADC interrupt service routine
// with auto input scanning

short pump_cntrl_cnt;

short cnt_start, cnt_stop, cnt_md1, cnt_botl, cnt_pump, cnt_avt, cnt_stop_long;

bit bLED_G, bLED_Y;

short stop_process_cnt;
short step_max_cnt;
//-----------------------------------------------
void prog_drv(void)
{
char temp,temp1,temp2;

///temp=ee_program[0];
///temp1=ee_program[1];
///temp2=ee_program[2];

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
////	temp=MINPROG;
////	temp1=MINPROG;
////	temp2=MINPROG;
	}

////if(!((temp<=MAXPROG)&&(temp>=MINPROG)))
////	{
////	temp=MINPROG;
////	}

///if(temp!=ee_program[0])ee_program[0]=temp;
///if(temp!=ee_program[1])ee_program[1]=temp;
///if(temp!=ee_program[2])ee_program[2]=temp;


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
void err_drv(void)
{
/*if(ee_prog==p1)	
	{
     if(bSW1^bSW2) bERR=1;
 	else bERR=0;
	}
else bERR=0;*/
}
  

//-----------------------------------------------
void in_an(void)
{
DDRA=0x00;
PORTA=0xff;
in_word=PINA;



if(!(in_word&(1<<PIN_START)))
	{
	if(cnt_start<10)
		{
		cnt_start++;
		if(cnt_start==10) bSTART=1;
		}
    //bSTART=1;
	}
else
	{
	if(cnt_start)
		{
		cnt_start--;
		if(cnt_start==0) bSTART=0;
		}
    //bSTART=0;
	}    



if(!(in_word&(1<<PIN_STOP)))
	{
	if(cnt_stop<10)
		{
		cnt_stop++;
		if(cnt_stop==10) bSTOP=1;
		}

	}
else
	{
	if(cnt_stop)
		{
		cnt_stop--;
		if(cnt_stop==0) bSTOP=0;
		}

	}

if(!(in_word&(1<<PIN_STOP)))
	{
	if(cnt_stop_long<2400)
		{
		cnt_stop_long++;
		if(cnt_stop_long==2400) bSTOP_LONG=1;
		}

	}
else
	{
	if(cnt_stop_long)
		{
		cnt_stop_long--;
		if(cnt_stop_long==0) bSTOP_LONG=0;
		}

	}

if(!(in_word&(1<<PIN_MD1)))
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

if(!(in_word&(1<<PIN_BOTL)))
	{
	if(cnt_botl<10)
		{
		cnt_botl++;
		if(cnt_botl==10) bBOTL=1;
		}

	}
else
	{
	if(cnt_botl)
		{
		cnt_botl--;
		if(cnt_botl==0) bBOTL=0;
		}

	}

if((bBOTL_OLD!=bBOTL) && (bBOTL))
    {
    bBOTL_CH=1;
    }
bBOTL_OLD=bBOTL;

if(!(in_word&(1<<PIN_PUMP)))
	{
	if(cnt_pump<5)
		{
		cnt_pump++;
		if(cnt_pump==5) bPUMP=1;
		}

	}
else
	{
	if(cnt_pump)
		{
		cnt_pump--;
		if(cnt_pump==0) bPUMP=0;
		}

	}

if((bPUMP_OLD!=bPUMP) && (!bPUMP))
    {
    bPUMP_OFF=1;
    }
bPUMP_OLD=bPUMP;

if(!(in_word&(1<<PIN_AVT)))
	{
	if(cnt_avt<100)
		{
		cnt_avt++;
		if(cnt_avt==100) bAVT=1;
		}

	}
else
	{
	if(cnt_avt)
		{
		cnt_avt--;
		if(cnt_avt==0) bAVT=0;
		}

	}

} 

//-----------------------------------------------
void main_loop_hndl(void)
{
	 
}

//-----------------------------------------------
void pump_cntrl_drv(void)
{
DDRB|=0xf0;
if(pump_cntrl_cnt)
    {
    pump_cntrl_cnt--;
    PORTB&=0x0f;    
    }
else 
    {
    PORTB|=0xF0;
    }
}


//-----------------------------------------------
void out_drv(void)
{
char temp=0;
//DDRB|=0xF0;

if(bPP1) temp|=(1<<PP1);
if(bPP2) temp|=(1<<PP2);

if(pump_cntrl_cnt)
    {
    //pump_cntrl_cnt--;
    temp|=(1<<5)|(1<<4);    
    }


DDRB|=0xF0;

PORTB=((PORTB|0xf0)&(~temp));
//PORTB=0x55;
}

//-----------------------------------------------
void stop_process(void)
{
if(pump_cntrl_cnt) bSTOP_PROCESS=1;
else
    {
    if(bPUMP)pump_cntrl_cnt=10;
    step=sOFF;
    stop_process_cnt=0;
    }

}



//-----------------------------------------------
void stop_process_drv(void)
{
if(bSTOP_PROCESS)
    {
    if(pump_cntrl_cnt)
        {
        stop_process_cnt=30;
        return;
        }
    else
        { 
        if(stop_process_cnt)
            {
            stop_process_cnt--;
            if(stop_process_cnt==0)
                { 
                bSTOP_PROCESS=0;
                if(bPUMP)  pump_cntrl_cnt=10;
                }
            }
        }
    }

}

//-----------------------------------------------
void step_contr(void)
{
if(bSTOP)
    {
    stop_process(); 
    bSTOP=0;
    }         
    
if(step==sOFF)
    {
    bPP1=0;
    bPP2=0;
    //pump_cntrl_cnt=0;
    
    if(bSTART)
        {
        bSTART=0;
        step=s1;
        step_max_cnt=200/*100*/;
        bBOTL_CH=0;
        } 
        
    if(bSTOP_LONG)
        {
        bSTOP_LONG=0;
        step=s10;
        step_max_cnt=6000;
        
        pump_cntrl_cnt=10;
        bPUMP_OFF=0;
        }           
        
    if(bPUMP) bPP2=1;        
    }

else if(step==s1)   //продвижение бутылки (не дольше секунды)
    {
    bPP1=1;
    bPP2=0;
    
    if(step_max_cnt)
        {
        step_max_cnt--;
        if(step_max_cnt==0)step=sOFF;
        }
    
    if(bMD1)
        {
        step=s2;
        step_max_cnt=20;//1000/*100*/;
        }
    
    bPUMP_OFF=0;                   
    }

else if(step==s2)   //ожидание срабатывани€ датчика смены бутылки (не дольше секунды)
    {                                                                                
    bPP1=0;
    bPP2=0;
    
    if(step_max_cnt)
        {
        step_max_cnt--;
        if(step_max_cnt==0)step=sOFF;
        } 
        
    if(bBOTL_CH)
        {
        step=s3;
        //step_max_cnt=100;
        pump_cntrl_cnt=10;
        bBOTL_CH=0;
        }
    }

else if(step==s3)   //излив
    {                                                                                
    bPP1=0;
    bPP2=1;
    
 /*   if(step_max_cnt)
        {
        step_max_cnt--;
        if(step_max_cnt==0)step=sOFF;
        } */
        
    if(bPUMP_OFF)
        {
        step=s4;
        step_max_cnt=40;
        bPUMP_OFF=0;
        }
    }    
                
else if(step==s4)   //пережим
    {                                                                                
    bPP1=0;
    bPP2=0;
    
    if(step_max_cnt)
        {
        step_max_cnt--;
        if(step_max_cnt==0)
            {
            if(bAVT==1)
                {
                step=s1;
                step_max_cnt=200;
                bBOTL_CH=0;
                }
            else step=sOFF;
            }
        } 
    }       
    
else if(step==s10)   //ѕромывка
    {                                                                                
    bPP1=0;
    bPP2=1;
       
    if(bPUMP_OFF)
        {
        bPUMP_OFF=0;
        pump_cntrl_cnt=10;
        }
        
    if(step_max_cnt)
        {
        step_max_cnt--;
        if(step_max_cnt==0)
            {
            stop_process();
            }
        } 
    }          
/*
if(ee_prog==p1)
	{
     if(bSW1&&(step==sOFF))
     	{
     	step=s1;
     	bPP1=1;
     	bPP2=1;
     	time_cnt=adc_output/15;
     	}              
     else if(step==s1)
     	{
     	if(time_cnt==0)
     		{
     		step=s2;
     		bPP1=1;
     		bPP2=0;
     		}
     	}	
     
     if(!bSW1&&(step!=sOFF)) 
     	{
     	step=sOFF;
     	bPP1=0;
     	bPP2=0;
     	}
	}

else if(ee_prog==p2)  //ско
	{

	}

else if(ee_prog==p3)   //твист
	{

	}

else if(ee_prog==p4)      //замок
	{
	}
	
step_contr_end:

//if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);
temp=0;
PORTB&=temp;
//PORTB=0x55; */
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
void ind_hndl(void)
{
if(step==sOFF)  bLED_Y=1;
else            bLED_Y=0;

//if(step==s2)    bLED_G=1;
//else            bLED_G=0;

//bLED_Y = bBOTL_CH;
bLED_G = bPUMP_OFF;

/*if(bSTOP)
    { 
    bBOTL_CH=0;
    }*/
}



//-----------------------------------------------
// ѕодпрограмма драйва до 7 кнопок одного порта, 
// различает короткое и длинное нажатие,
// срабатывает на отпускание кнопки, возможность
// ускорени€ перебора при длинном нажатии...
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

#define butV	239
#define butV_	237
#define butP	251
#define butP_	249
#define butR	127
#define butR_	125
#define butL	254
#define butL_	252
#define butLR	126
#define butLR_	124 
#define butVP_ 233
//-----------------------------------------------
void but_an(void)
{
if (!n_but) goto but_an_end;

if(ind==iMn)
	{
	if(but==butP_)ind=iPr_sel;
	} 
	
else if(ind==iPr_sel)
	{
	if(but==butP_)ind=iMn;
	if(but==butP)
		{
		ee_prog++;
		if(ee_prog>MAXPROG)ee_prog=p1;
		}
	} 

but_an_end:
n_but=0;
}

//-----------------------------------------------
void ind_drv(void)
{
char temp=0;
//DDRB|=0xF0;

if(bLED_G) temp|=(1<<0);
if(bLED_Y) temp|=(1<<2);


DDRB|=0x0F;

PORTB=((PORTB|0x0f)&(~temp));
//PORTB=0x55;
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
ind_drv();
if(++t0_cnt0>=6)
	{
	t0_cnt0=0;
	b100Hz=1;
    
    if(pump_cntrl_cnt) pump_cntrl_cnt--;

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

if(++t0_cnt4>=600)
	{
	t0_cnt4=0;
	b1Hz=1;
	
		
	}
}

//***********************************************
interrupt [ADC_INT] void adc_isr(void)
{
 static unsigned char input_index=0;
// Read the AD conversion result
adc_output=ADCW;
// Select next ADC input

ADMUX=(FIRST_ADC_INPUT|ADC_VREF_TYPE);


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



// ADC initialization
// ADC Clock frequency: 125,000 kHz
// ADC Voltage Reference: AVCC pin
// ADC High Speed Mode: Off
// ADC Auto Trigger Source: Timer0 Overflow
ADMUX=FIRST_ADC_INPUT|ADC_VREF_TYPE;
ADCSRA=0xCB;
SFIOR&=0x0F;



#asm("sei") 
PORTB=0xFF;
DDRB=0xFF;
ind=iMn;
prog_drv();
ind_hndl();
//led_hndl();
//PORTB=0x00;
/*while (1)
{
}*/

while (1)
      {
      if(b600Hz)
		{
		b600Hz=0; 
        in_an();
          
		}         
      if(b100Hz)
		{        
		b100Hz=0; 
		//but_an();
        ind_hndl();
	    ind_drv();
          
        step_contr();
          
        stop_process_drv();

        out_drv(); 
        
       // pump_cntrl_drv();
		}   
	if(b10Hz)
		{
		b10Hz=0;
		//prog_drv();
		//err_drv();
		
    	     //if(time_cnt)time_cnt--;
          //led_hndl();
          //ADCSRA|=0x40;   
         // bPP2=!bPP2;
         // bLED_G=!bPP2;
          }
	if(b1Hz)
		{
		b1Hz=0;
 
          //pump_cntrl_cnt=10;
          //bPP1=!bPP1;
          //bLED_Y=!bLED_Y;
        }

      };
}
