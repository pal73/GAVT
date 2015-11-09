/*****************************************************
This program was produced by the
CodeWizardAVR V1.24.1d Standard
Automatic Program Generator
© Copyright 1998-2004 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.ro
e-mail:office@hpinfotech.ro

Project : 
Version : 
Date    : 07.11.2015
Author  : PAL                             
Company : HOME                            
Comments: 


Chip type           : ATtiny13
Clock frequency     : 0,128000 MHz
Memory model        : Tiny
External SRAM size  : 0
Data Stack size     : 16
*****************************************************/

#include <tiny13.h>

short t0_cnt0;
bit b1Hz;
bit b10Hz;
short time_cnt;
short time_stamp;
short rele_cnt;
short in_cnt;
bit bIN;
bit bIN_OLD;

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
TCNT0=-50;
t0_cnt0++;

b10Hz=1;

if(t0_cnt0>10)
	{
	t0_cnt0=0;
	b1Hz=1;
	}

}

#define ADC_VREF_TYPE 0x00
// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input|ADC_VREF_TYPE;
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}

// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
CLKPR=0x80;
CLKPR=0x00;

// Input/Output Ports initialization
// Port B initialization
// Func5=In Func4=In Func3=In Func2=In Func1=In Func0=Out 
// State5=T State4=T State3=T State2=T State1=T State0=0 
PORTB=0x00;
DDRB=0x01;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 0,500 kHz
// Mode: Normal top=FFh
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x04;
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

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Output: Off
ACSR=0x80;
ADCSRB=0x00;

// ADC initialization
// ADC Clock frequency: 32,000 kHz
// ADC Bandgap Voltage Reference: Off
// ADC Auto Trigger Source: Free Running
// Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On,
// ADC4: On
DIDR0=0x00;
ADMUX=ADC_VREF_TYPE;
ADCSRA=0x82;
ADCSRB&=0xF8;

// Global enable interrupts
#asm("sei")

while (1)
      {
      if(b10Hz)
      	{
      	b10Hz=0;
      	time_stamp=((read_adc(3)-350)/15)+5; 
      //	time_stamp=10;
      	/*time_cnt++;
      	if(time_cnt>time_stamp)
      		{
      		time_cnt=0;
      		PORTB.0=!PORTB.0;
      		}*/
      		
      	if((rele_cnt)&&(rele_cnt<time_stamp))
      		{
      		rele_cnt++;
      		if(rele_cnt>=time_stamp)rele_cnt=0;
      		}	                                          
      		
      	if((rele_cnt>=5)&&(rele_cnt<=time_stamp)) PORTB.0=1;
      	else 							  PORTB.0=0;
      		
      	}
      if(b1Hz)
      	{
      	b1Hz=0;
      	//

      	}
      if(PINB.1)
      	{ 
      	if(in_cnt<200)in_cnt++;
      	}
      else
      	{
      	if(in_cnt)in_cnt--;
      	} 
      if(in_cnt>=199)bIN=1;
      if(in_cnt<=1)bIN=0;
      
      if(bIN && !bIN_OLD)
      	{
      	if(rele_cnt==0)
      		{
      		rele_cnt=1;
      		}
      	}
      bIN_OLD=bIN;		 	
      	
      	       
/*      	if(in_cnt<200)
      		{
      		in_cnt++;
      		if(in_cnt>=200)
      			{

      			}
      		}*/
   /*   	}
      else 
      	{
      	in_cnt=0;
      	} */		
      };
}
