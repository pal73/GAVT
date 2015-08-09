/*****************************************************
This program was produced by the
CodeWizardAVR V1.24.1d Standard
Automatic Program Generator
© Copyright 1998-2004 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.ro
e-mail:office@hpinfotech.ro

Project : 
Version : 
Date    : 22.09.2005
Author  : PAL                             
Company : HOME                            
Comments: 


Chip type           : ATmega48
Clock frequency     : 1,000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 128 


*****************************************************/  
#define SIBHOLOD
//#define TRIADA

#define RELEASE
#define LED_NET PORTD.0
#define LED_PER PORTD.1
#define LED_DEL PORTD.2
#define KL2 PORTD.3
#define KL1 PORTD.4

#include <mega48.h>
#define MIN_U	100 

bit bT0;
bit b100Hz;
bit b10Hz;
bit b5Hz;
bit b2Hz;
bit b1Hz;
bit bFl;
bit butR;
char butS;
char bNN,bNN_;
char bPER,bPER_,bCHER_;
char t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3,t0_cnt4; 
eeprom char delta; 
char cnt_butS,cnt_butR; 

enum char {iMn,iSet}ind; 
unsigned int del_cnt;
char pcnt[3];
unsigned int adc_bankU[3][25],ADCU,adc_bankU_[3];
char per_cnt;
char flags;
char nn_cnt;
flash char DF[]={0,10,15,20,25,30,35};
char deltas;
unsigned int adc_data;
char bA_,bB_,bC_;
char bA,bB,bC; 
char cnt_x;
unsigned int bankA,bankB,bankC;
char adc_cntA,adc_cntB,adc_cntC;
short proc_cnt_l=-20,proc_cnt_h=0;
char kl1_stat,kl2_stat;
//-----------------------------------------------
void t0_init(void)
{
// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 3,906 kHz
// Mode: Normal top=FFh
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x03;
TCNT0=-78;
OCR0A=0x00;
OCR0B=0x00;
}

//-----------------------------------------------
void ind_hndl(void)
{

DDRD|=0x07;   


if(kl1_stat)LED_DEL=0;
else LED_DEL=1;
 
if(kl2_stat)LED_PER=0;
else LED_PER=1; 

if((proc_cnt_h<=9) || (bFl))LED_NET=0;
else LED_NET=1;

}

//-----------------------------------------------
void out_out(void)
{

DDRD|=0x18;   
  

if(kl1_stat==1)
	{
	KL1=1;
	}
else 
	{
	KL1=0;
	}	
	
if(kl2_stat==1)
	{
	KL2=1;
	}
else 
	{
	KL2=0;
	}		
}

//-----------------------------------------------
void proc_hndl(void)
{
proc_cnt_l++;
if(proc_cnt_l>=1800)
	{
	proc_cnt_l=0;
	proc_cnt_h++;
	if(proc_cnt_h>20)proc_cnt_h=0;
	}
	
if ((((proc_cnt_l>=-20)&&(proc_cnt_l<=20))	|| ((proc_cnt_l>=880)&&(proc_cnt_l<=920)) || ((proc_cnt_l>=1780)&&(proc_cnt_l<=1800))) && (proc_cnt_h<=9)) kl1_stat=0;
else kl1_stat=1;

if ( (proc_cnt_l>=0)&&(proc_cnt_l<=900) && (proc_cnt_h<=9)) kl2_stat=1;
else kl2_stat=0;
}





//-----------------------------------------------
void but_drv(void)
{

#define PINR PINC.4
#define PORTR PORTC.4
#define DDR DDRC.4

#define PINS PINC.5
#define PORTS PORTC.5
#define DDS DDRC.5



DDR=0;
DDS=0;
PORTR=1;
PORTS=1; 
      
if(!PINR)
	{
	if(cnt_butR<10)
		{
		if(++cnt_butR>=10)
			{
			butR=1;
			}
		}
	}                 
else 
	{
	cnt_butR=0;
	butR=0;
	}	 
	
if(!PINS)
	{
	if(cnt_butS<200)
		{
		if(++cnt_butS>=200)
			{
			butS=1;
			}
		}
	}                 
else 
	{
	cnt_butS=0;
	butS=0;
	}		
	           
}

//-----------------------------------------------
void but_an(void)
{
if(ind==iMn)
	{
	if(butS) ind=iSet;
	if(butR)
		{
		if(del_cnt) del_cnt=0;
		}
	}
else if(ind==iSet)
	{            
	if(butR)
		{
		if(delta<6) delta++;
		else delta=1;
		}
	if(butS) ind=iMn;	
	}
but_an_end:
butR=0;
butS=0;
}






//***********************************************
//***********************************************
//***********************************************
//***********************************************
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
t0_init();
bT0=!bT0;

if(!bT0) goto lbl_000;
b100Hz=1;
if(++t0_cnt0>=10)
	{
	t0_cnt0=0;
	b10Hz=1;
	bFl=!bFl;

	} 
if(++t0_cnt1>=20)
	{
	t0_cnt1=0;
	b5Hz=1;

	}
if(++t0_cnt2>=50)
	{
	t0_cnt2=0;
	b2Hz=1;
	}	
		
if(++t0_cnt3>=100)
	{
	t0_cnt3=0;
	b1Hz=1;
	}		
lbl_000:
}

//-----------------------------------------------
//#pragma savereg-
interrupt [ADC_INT] void adc_isr(void)
{

register static unsigned char input_index=0;
// Read the AD conversion result
adc_data=ADCW;

if (++input_index > 2)
   input_index=0;
#ifdef DEBUG
ADMUX=(0b01000011)+input_index;
#endif
#ifdef RELEASE
ADMUX=0b01000000+input_index;
#endif

// Start the AD conversion
ADCSRA|=0x40;

if(input_index==1)
	{
 	if((adc_data>100)&&!bA_)
    		{
    		bA_=1;
    		cnt_x++;
    		}
    	if((adc_data<100)&&bA_)
    		{
    		bA_=0;
    		}			
//	adc_data
	if(adc_data>10U)
		{
		bankA+=adc_data;
		bA=1;
		pcnt[0]=10;
		}
	else if((adc_data<=10U)&&bA)
		{
		bA=0;
		
		adc_bankU[0,adc_cntA]=bankA/10;
		bankA=0;
		if(++adc_cntA>=25) 
			{
			char i;
			adc_cntA=0;
			adc_bankU_[0]=0;
			for(i=0;i<25;i++)
				{
				adc_bankU_[0]+=adc_bankU[0,i];
				}
			adc_bankU_[0]/=25;	
			}	
		}
	//adc_bankU_[0]		          
	}  

		
if(input_index==0)
	{
	if((adc_data>100)&&!bC_)
    			{
    			bC_=1;
    			cnt_x=0;
    			}
    		if((adc_data<100)&&bC_)
    			{
    			bC_=0;
    			}	
	
	if(adc_data>30)
		{
		bankC+=adc_data;
		pcnt[2]=10;
		bC=1;
		}
	else if((adc_data<=30)&&bC)
		{
		bC=0;
		adc_bankU[2,adc_cntC]=bankC/10;
		bankC=0;
		if(++adc_cntC>=25) 
			{
			char i;
			adc_cntC=0;
			adc_bankU_[2]=0;
			for(i=0;i<25;i++)
				{
				adc_bankU_[2]+=adc_bankU[2,i];
				}
			adc_bankU_[2]/=25;	
			}	
		}	
	}

#asm("sei")
}

//===============================================
//===============================================
//===============================================
//===============================================

void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 8
CLKPR=0x80;
CLKPR=0x03;

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;
/*
// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 1000,000 kHz
// Mode: Normal top=FFh
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x01;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;
*/

t0_init();
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

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
// OC2A output: Disconnected
// OC2B output: Disconnected
ASSR=0x00;
TCCR2A=0x00;
TCCR2B=0x00;
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
// Interrupt on any change on pins PCINT8-14: Off
// Interrupt on any change on pins PCINT16-23: Off
EICRA=0x00;
EIMSK=0x00;
PCICR=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=0x01;
// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=0x00;
// Timer/Counter 2 Interrupt(s) initialization
TIMSK2=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
// Analog Comparator Output: Off
ADCSRA=0x00;
ADCSRB=0x00;


// Global enable interrupts
#asm("sei")

while (1)
      {
	if(b100Hz)
		{
		b100Hz=0;
		but_drv();
		but_an();
	
		}   
	if(b10Hz)
		{
		b10Hz=0;
		 
		
		proc_hndl(); 
	 	out_out();
	 	ind_hndl(); 
		}
	if(b5Hz)
		{
		b5Hz=0;
			
		}
	if(b2Hz)
		{
		b2Hz=0;
		
		}		 
    	if(b1Hz)
		{
		b1Hz=0;
		 
     	}
     #asm("wdr")	
	}

}
