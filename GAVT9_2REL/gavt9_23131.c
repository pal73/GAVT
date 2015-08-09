#include <tiny2313.h>

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
// Place your code here
TCNT0=-78;


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
// Declare your local variables here

// Crystal Oscillator division factor: 1
CLKPR=0x80;
CLKPR=0x00;

// Input/Output Ports initialization
// Port A initialization
// Func2=In Func1=In Func0=In
// State2=T State1=T State0=T
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTB=0x00;
DDRB=0x00;

// Port D initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTD=0x00;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 7,813 kHz
// Mode: Normal top=FFh
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x05;
TCNT0=-78;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer 1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
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

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x02;

// Universal Serial Interface initialization
// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
// Analog Comparator Output: Off
ACSR=0x80;

main_cnt=30;
// Global enable interrupts
#asm("sei")

while (1)
      {
while (1)
	{
	if(b100Hz)
		{
		b100Hz=0;

		if(!PIND.6)
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
			
			
		DDRD.6=0;
		PORTD.6=1; 

		}             
	if(b10Hz)
		{
		b10Hz=0; 
	
		DDRD|=0b00110000;
          if(main_cnt<30)main_cnt++;
          if((main_cnt>0)&&(main_cnt<=13))
          	{
          	PORTD.5=1;
          	}
          else PORTD.5=0;
          
          if((main_cnt>5)&&(main_cnt<=13))
          	{
          	PORTD.4=1;
          	}
          else PORTD.4=0;          	
          
		}
	if(b5Hz)
		{

		} 
    	if(b1Hz)
		{
		b1Hz=0;
/*DDRD.5=1;
PORTD.5=!PORTD.5;*/

		}
     #asm("wdr")	
	}
      };
}
