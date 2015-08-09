#include <tiny13.h>

char t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3,t0_cnt4,t0_cnt5,t0_cnt6;
//***********************************************
//Битовые переменные
bit b200Hz;
bit b100Hz;
bit b10Hz;
bit b5Hz;
bit b2Hz;
bit b1Hz;
bit zero_on;
bit bFl;
bit bT;
bit bFl_;

int in_cnt,main_cnt;

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
TCCR0A=0x00;
TCCR0B=0x05;
TCNT0=-47;


b100Hz=1;

if(++t0_cnt1>=10)
	{
	t0_cnt1=0;
	b10Hz=1;
	
	if(++t0_cnt3>=10)
		{
		t0_cnt3=0;
		b1Hz=1;
		} 
	if(++t0_cnt4>=5)
		{
		t0_cnt4=0;
		b2Hz=1;
		}	
	} 
if(++t0_cnt2>=20)
	{
	t0_cnt2=0;
	b5Hz=1;
	
	
	} 

}

// Declare your global variables here

void main(void)
{
// Crystal Oscillator division factor: 1
CLKPR=0x80;
CLKPR=0x00;

// Input/Output Ports initialization
// Port B initialization
// Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State5=T State4=T State3=T State2=T State1=T State0=T
PORTB=0x00;
DDRB=0xfd;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 4,688 kHz
// Mode: Normal top=FFh
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x05;
TCNT0=-47;
OCR0A=0x00;
OCR0B=0x00;

// External Interrupt(s) initialization
// INT0: Off
// Interrupt on any change on pins PCINT0-5: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=0x02;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Output: Off
ACSR=0x80;
ADCSRB=0x00;

// Global enable interrupts

main_cnt=30;
// Global enable interrupts
#asm("sei")

while (1)
	{
	DDRB=0xfd;
	if(b100Hz)
		{
		b100Hz=0;

		if(!PINB.1)
			{
			if(in_cnt<5)
				{
				in_cnt++;
				if(in_cnt==5)
					{
					main_cnt=0;
					}          
				}
			}
		else
			{
			in_cnt=0;
			}			
			
			
		DDRB.1=0;
		PORTB.1=1; 

		}             
	if(b10Hz)
		{
		b10Hz=0; 
		DDRB|=0b00000101;
		
          if(main_cnt<30)main_cnt++;
          if((main_cnt>0)&&(main_cnt<=13))
          	{
          	PORTB.2=1;
          	}
          else PORTB.2=0;
          
          if((main_cnt>5)&&(main_cnt<=13))
          	{
          	PORTB.0=1;
          	}
          else PORTB.0=0;          	
          
		}
	if(b5Hz)
		{

		} 
    	if(b1Hz)
		{
		b1Hz=0;
          //PORTB^=0b00000101;
		}
     #asm("wdr")	
	}

}
