// Прокачка скважины, полчаса работаем, полчаса стоим.

#include <tiny13.h>  
char cnt_imp; 
unsigned int one_cnt,zero_cnt;
bit bIN_OLD,bREADY;
int out_cnt,out_out_cnt;
int opto_err_cnt;
bit bOPTO_ERR; 
char stat; 
char t0_cnt0;
signed short val_cnt,metka_cnt;
signed long pause_cnt,wrk_cnt;
#pragma savereg-
//***********************************************
//***********************************************
//***********************************************
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
TCNT0=-16;

/*if(wrk_cnt)
	{
	pause_cnt=0;
	wrk_cnt--;
	if(!wrk_cnt)
		{
		//pause_cnt=530000L;
		pause_cnt=400000L;
		ee_stat=0;
		}
	}

if(pause_cnt)
	{
	wrk_cnt=0;
	pause_cnt--;
	if(!pause_cnt)
		{
		//wrk_cnt=265000L;
		wrk_cnt=800000L;
		ee_stat=1;
		}
	}*/

if(PINB.3)	//вал
	{
	if(val_cnt<10)
		{
		val_cnt++;
		if(val_cnt>=10)
			{
			//metka_cnt=0;
			stat=1;
			}
		}
	}
else 
	{
	val_cnt=0;	
	}	

if(!PINB.1)	//метка
	{
	if(metka_cnt<10)
		{
		metka_cnt++;
		if(metka_cnt>=10)
			{
			stat=0;
			//val_cnt=0;
			}
		}
	}
else 
	{
	metka_cnt=0;	
	}	

/*DDRB.4=1;
PORTB.4=0;

//cnt_imp++;
//if(cnt_imp>=10)cnt_imp=0;
//if(cnt_imp<5)PORTB.4=0; 

DDRB.0=1;
if(out_cnt)
	{
	out_cnt--;
	PORTB.0=0;
	} 	  
else if(!bOPTO_ERR)
	{
	if(out_out_cnt)out_out_cnt--;
	else
		{
		out_out_cnt=100;
		PORTB.0=!PORTB.0;
		}
	}  */

/*DDRB.4=1;
PORTB.4=1;
DDRB.4=1;
PORTB.4=0;*/	
t0_cnt0++;
if(t0_cnt0>=100)
	{
	t0_cnt0=0;

	}
	if(stat)PORTB.0=1;
	else PORTB.0=0;
/*	if(ee_stat1)PORTB.0=1;
	else PORTB.0=0;*/

}
#pragma savereg+
/*#pragma savereg-
//***********************************************
interrupt [TIM0_COMPA] void timer0_compa_isr(void)
{
PORTB.4=1;

if(!PINB.3)
	{
	if(bIN_OLD)
		{
		if((one_cnt>20)&&(one_cnt<310)&&bREADY&&(!out_cnt))out_cnt=4000;
	    	
		}
	
	if(zero_cnt<30000)
		{
		zero_cnt++;
		bREADY=0;
		}
	else bREADY=1;
	one_cnt=0;
	
	//bREADY=0;
	opto_err_cnt=0;
	bOPTO_ERR=0;
	bIN_OLD=0;
	}
if(PINB.3)
	{
	
	if(one_cnt<30000)
		{
		one_cnt++;
		
		}
	
	zero_cnt=0;
	
	
	if((opto_err_cnt<5000))//(opto_err_cnt)&&
		{
		bOPTO_ERR=0;
		opto_err_cnt++;
	     }
	else bOPTO_ERR=1; 
	
	
	bIN_OLD=1;    
	}
DDRB.3=0;
PORTB.3=1;
}
#pragma savereg+ */
//-----------------------------------------------
//-----------------------------------------------
//-----------------------------------------------
//-----------------------------------------------

void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
CLKPR=0x80;
CLKPR=0x00;

// Input/Output Ports initialization
// Port B initialization
// Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State5=T State4=T State3=T State2=T State1=T State0=T 
//DDRB=0xf0;
//PORTB=0x0A;
DDRB.0=1;
DDRB.4=1;
DDRB.1=0;
DDRB.3=0;
PORTB.1=1;
PORTB.3=0;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 0,500 kHz
// Mode: Normal top=FFh
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x02;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// External Interrupt(s) initialization
// INT0: Off
// Interrupt on any change on pins PCINT0-5: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=0x02;
TCNT0=-50;
//OCR0A=-120;
// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Output: Off
ACSR=0x80;
ADCSRB=0x00;

stat=0;
//pause_cnt=530000L;
//wrk_cnt=0;

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here

      };
}
