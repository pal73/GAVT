//#define DEBUG
#define RELEASE
#define MIN_U	100

//#define SIBHOLOD
#define TRIADA


#include <Mega8.h>
#include <delay.h> 

#ifdef DEBUG
#include "usart.c"
#include "cmd.c"
#include <stdio.h>
#endif


#ifdef DEBUG
#define LED_NET PORTB.0
#define LED_PER PORTB.1
#define LED_DEL PORTB.2
#define KL1 PORTB.7
#define KL2 PORTB.6
#endif

#ifdef RELEASE
#define LED_NET PORTD.0
#define LED_PER PORTD.1
#define LED_DEL PORTD.2
#define KL2 PORTD.3
#define KL1 PORTD.4
#endif

bit bT0;
bit b100Hz;
bit b10Hz;
bit b5Hz;
bit b2Hz;
bit b1Hz;
bit n_but;

char t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3,t0_cnt4;
unsigned int bankA,bankB,bankC;
unsigned int adc_bankU[3][25],ADCU,adc_bankU_[3];
unsigned int del_cnt;
char flags;
char deltas;
char adc_cntA,adc_cntB,adc_cntC;
bit bA_,bB_,bC_;
bit bA,bB,bC;
unsigned int adc_data;
char cnt_x;
char cher[3]={5,6,7};
int cher_cnt=25; 
char reset_cnt=25;
char pcnt[3];
bit bPER,bPER_,bCHER_;
bit bNN,bNN_;
enum char {iMn,iSet}ind;
bit bFl;
eeprom char delta; 
char cnt_butS,cnt_butR; 
bit butR,butS;
flash char DF[]={0,10,15,20,25,30,35};
char per_cnt;
char nn_cnt;
char main_cnt;
//-----------------------------------------------
void t0_init(void)
{
TCCR0=0x03;
TCNT0=-78;
TIMSK|=0b00000001;
} 

//-----------------------------------------------
void t2_init(void)
{
//TIFR|=0b01000000;
TCNT2=-97;
TCCR2=0x07;
OCR2=-80;
TIMSK|=0b11000000;
}  

//-----------------------------------------------
void del_init(void)
{
if(!del_cnt)
	{
#ifdef SIBHOLOD
	del_cnt=300;
#endif

#ifdef TRIADA
	del_cnt=3;
#endif
	}
} 

//-----------------------------------------------
void del_hndl(void)
{
if((del_cnt)&&(!bCHER_)) del_cnt--;
} 

//-----------------------------------------------
void ind_hndl(void)
{
#ifdef DEBUG
DDRB|=0x07;
#endif

#ifdef RELEASE
DDRD|=0x07;   
#endif
 
if(ind==iMn)
	{
	if(bCHER_)
		{
		LED_NET=bFl;
		}
	else LED_NET=0;
	
	if(del_cnt||bCHER_)
		{
		LED_DEL=0;
		}
	else LED_DEL=1;

	if(bNN_)
		{
		LED_PER=bFl;
		}

	else if(bPER)
		{
		LED_PER=0;
		}		

	else LED_PER=1;	
				
	}
else if(ind==iSet)
	{
	#ifdef DEBUG 
	if(bFl) PORTB|=0x07;
	else PORTB&=(delta^0xff)|0xf8;
	#endif
	
	#ifdef RELEASE 
	if(bFl) PORTD|=0x07;
	else PORTD&=(delta^0xff)|0xf8;
	#endif
	
	}	
}

//-----------------------------------------------
void out_out(void)
{
#ifdef DEBUG
DDRB|=0xc0;   
#endif

#ifdef RELEASE
DDRD|=0x18;   
#endif    

if((!del_cnt)&&(!bPER_)&&(!bCHER_)&&(!bNN_))
	{
	KL1=1;
	flags|=0x02;
	}
else 
	{
	KL1=0;
	flags&=0xfD;
	}	
	
if((!main_cnt)&&(!bPER_)&&(!bCHER_)&&(!bNN_))
	{
	KL2=1;
	flags|=0x08;
	}
else 
	{
	KL2=0;
	flags&=0xf7;
	}		
}

//-----------------------------------------------
void per_drv(void)
{
char max_,min_;
signed long temp_SL;
if((adc_bankU_[0]>=adc_bankU_[1])&&(adc_bankU_[0]>=adc_bankU_[2])) max_=0; 
else if(adc_bankU_[1]>=adc_bankU_[2]) max_=1; 
else max_=2;  

if((adc_bankU_[0]<=adc_bankU_[1])&&(adc_bankU_[0]<=adc_bankU_[2])) min_=0; 
else if(adc_bankU_[1]<=adc_bankU_[2]) min_=1; 
else min_=2; 

temp_SL=adc_bankU_[max_]*(long)DF[delta]/100;
if((adc_bankU_[max_]-adc_bankU_[min_])>=(int)temp_SL)
	{
	bPER=1;

	flags|=0x01;
	}      
else
	{
	bPER=0;   

	flags&=0xfe;
	}
//	bPER=0;	
}

//-----------------------------------------------
void nn_drv(void)
{
if((adc_bankU_[0]<=MIN_U)&&(adc_bankU_[1]<=MIN_U)&&(adc_bankU_[2]<=MIN_U))
	{
	bNN=1;
	}      
else
	{
	bNN=0;   
	}
}

//-----------------------------------------------
void per_hndl(void)
{
if(!bPER)
	{
	per_cnt=0;
	bPER_=0;
	flags&=0xfB;
	}
else
	{
	if(per_cnt<5)
		{
		if(++per_cnt>=5)
			{
			bPER_=1;
			flags|=0x04;
			del_init();
			}
		}
	}	
}

//-----------------------------------------------
void nn_hndl(void)
{
if(!bNN)
	{
	nn_cnt=0;
	bNN_=0;
	
	}
else
	{
	if(nn_cnt<5)
		{
		if(++nn_cnt>=5)
			{
			bNN_=1;
			del_init();
			}
		}
	}	
}

//-----------------------------------------------
void pcnt_hndl(void)
{
if(pcnt[0])
	{
	pcnt[0]--;
	if(pcnt[0]==0) adc_bankU_[0]=0;
	}
if(pcnt[1])
	{
	pcnt[1]--;
	if(pcnt[1]==0) adc_bankU_[1]=0;
	}
if(pcnt[2])
	{
	pcnt[2]--;
	if(pcnt[2]==0) adc_bankU_[2]=0;
	}		
}

//-----------------------------------------------
void gran_char(signed char *adr, signed char min, signed char max)
{
if (*adr<min) *adr=min;
if (*adr>max) *adr=max; 
} 


#ifdef DEBUG



//-----------------------------------------------
char index_offset (signed char index,signed char offset)
{
index=index+offset;
if(index>=RX_BUFFER_SIZE) index-=RX_BUFFER_SIZE; 
if(index<0) index+=RX_BUFFER_SIZE;
return index;
}

//-----------------------------------------------
char control_check(char index)
{
char i=0,ii=0,iii;

if(rx_buffer[index]!=END) goto error_cc;

ii=rx_buffer[index_offset(index,-2)];
iii=0;
for(i=0;i<=ii;i++)
	{
	iii^=rx_buffer[index_offset(index,-2-ii+i)];
	}
if (iii!=rx_buffer[index_offset(index,-1)]) goto error_cc;	


success_cc:
return 1;
goto end_cc;
error_cc:
return 0;
goto end_cc;

end_cc:
}


//-----------------------------------------------
void OUT (char num,char data0,char data1,char data2,char data3,char data4,char data5)
{
char i,t=0;
//char *ptr=&data1;
char UOB[6]; 
UOB[0]=data0;
UOB[1]=data1;
UOB[2]=data2;
UOB[3]=data3;
UOB[4]=data4;
UOB[5]=data5;
for (i=0;i<num;i++)
	{
	t^=UOB[i];
	}    
UOB[num]=num;
t^=UOB[num];
UOB[num+1]=t;
UOB[num+2]=END;

for (i=0;i<num+3;i++)
	{
	putchar(UOB[i]);
	}   	
}

//-----------------------------------------------
void OUT_adr (char *ptr, char len)
{
char UOB[20]={0,0,0,0,0,0,0,0,0,0};
char i,t=0;

for(i=0;i<len;i++)
	{
	UOB[i]=ptr[i];
	t^=UOB[i];
	}
//if(!t)t=0xff;
UOB[len]=len;
t^=len;	
UOB[len+1]=t;	
UOB[len+2]=END;
//UOB[0]=i+1;
//UOB[i]=t^UOB[0];
//UOB[i+1]=END;
	
//puts(UOB); 
for (i=0;i<len+3;i++)
	{
	putchar(UOB[i]);
	}   
}

//-----------------------------------------------
void UART_IN_AN(void)
{
char temp_char;
int temp_int;
signed long int temp_intL;

if((UIB[0]==CMND)&&(UIB[1]==QWEST))
	{

	}
else if((UIB[0]==CMND)&&(UIB[1]==GETID))
	{

          
	}	

}

//-----------------------------------------------
void UART_IN(void)
{
//static char flag;
char temp,i,count;
if(!bRXIN) goto UART_IN_end;
#asm("cli")
//char* ptr;
//char i=0,t=0;
//int it=0;
//signed long int char_int;
//if(!bRXIN) goto UART_IN_end;
//bRXIN=0;
//count=rx_counter;
//OUT(0x01,0,0,0,0,0);
if(rx_buffer_overflow)
	{
	rx_wr_index=0;
	rx_rd_index=0;
	rx_counter=0;
	rx_buffer_overflow=0;
	}    
	
if(rx_counter&&(rx_buffer[index_offset(rx_wr_index,-1)])==END)
	{
     temp=rx_buffer[index_offset(rx_wr_index,-3)];
    	if(temp<10) 
    		{
    		if(control_check(index_offset(rx_wr_index,-1)))
    			{
    			rx_rd_index=index_offset(rx_wr_index,-3-temp);
    			for(i=0;i<temp;i++)
				{
				UIB[i]=rx_buffer[index_offset(rx_rd_index,i)];
				} 
			rx_rd_index=rx_wr_index;
			rx_counter=0;
			UART_IN_AN();

    			}
 	
    		} 
    	}	

UART_IN_end:
bRXIN=0;
#asm("sei")     
} 

#endif

    
 






//-----------------------------------------------
void led_hndl(void)
{

}



//-----------------------------------------------
void but_drv(void)
{
#ifdef DEBUG
#define PINR PIND.2
#define PORTR PORTD.2
#define DDR DDRD.2

#define PINS PIND.3
#define PORTS PORTD.3
#define DDS DDRD.3
#endif

#ifdef RELEASE
#define PINR PINC.4
#define PORTR PORTC.4
#define DDR DDRC.4

#define PINS PINC.5
#define PORTS PORTC.5
#define DDS DDRC.5
#endif


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
// Timer 2 output compare interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
t2_init();



}

//-----------------------------------------------
// Timer 2 output compare interrupt service routine
interrupt [TIM2_COMP] void timer2_comp_isr(void)
{

	

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
if(input_index==2)
	{
 	if((adc_data>100)&&!bB_)
    		{
    		bB_=1;
    		cnt_x++;
    		cher[0]=cnt_x;
   // 		cnt_x=2;
    		if(cnt_x==2)
    			{
    			if(cher_cnt<50)
				{
				cher_cnt++;
				if((cher_cnt>=50)/*&&reset_cnt*/) bCHER_=1;//cher_alarm(0);
		     	}
    			}
    		else
    			{
    			if(cher_cnt)
				{
				cher_cnt--;
				if((cher_cnt==0)/*&&reset_cnt*/) bCHER_=0;//cher_alarm(1);
		     	}
    			}
  //  		bCHER_=0;			 
    		}
    	if((adc_data<100)&&bB_)
    		{
    		bB_=0;
    		}	
	
 	if(adc_data>10)
		{
		bankB+=adc_data;
		pcnt[1]=10;
		bB=1;
		}
	else if((adc_data<=30)&&bB)
		{
		bB=0;
		adc_bankU[1,adc_cntB]=bankB/10;
		bankB=0;
		if(++adc_cntB>=25) 
			{
			char i;
			adc_cntB=0;
			adc_bankU_[1]=0;
			for(i=0;i<25;i++)
				{
				adc_bankU_[1]+=adc_bankU[1,i];
				}
			adc_bankU_[1]/=25;	
			}	
		}	
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
/*PORTC=0;
DDRC&=0xFE;*/
#ifdef DEBUG
UCSRA=0x02;
UCSRB=0xD8;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x18; 
#endif
/*
#ifdef RELEASE
UCSRA=0x00;
UCSRB=0xD0;
UCSRC=0x00;
UBRRH=0x00;
UBRRL=0x00; 
#endif
*/
#ifdef DEBUG
PORTB=0x00;
DDRB=0xB0;
DDRB|=0b00101100;

PORTC=0x00;
DDRC=0x00;

PORTD=0x00;
DDRD=0x02;
#endif 

#ifdef RELEASE
PORTC=0x00;
DDRC=0x00;

PORTD=0x00;
DDRD=0x02;
#endif 

ASSR=0;
OCR2=0;

// ADC initialization

ADMUX=0b01000011;
ADCSRA=0xCC;

t0_init();
t2_init(); 
del_init();
#asm("sei")

bCHER_=0;
ind=iMn;
main_cnt=40;
while (1)
	{
#ifdef DEBUG
	UART_IN();
#endif
	if(b100Hz)
		{
		b100Hz=0;

		but_drv();
		but_an();
		pcnt_hndl();
		}   
	if(b10Hz)
		{
		b10Hz=0;
		ind_hndl();
 //	DDRD^=0x07;
  //	PORTD&=0xf8;
	 	out_out();
		if(main_cnt)main_cnt--;
		}
	if(b5Hz)
		{
		b5Hz=0;
	  	per_drv();
	  	nn_drv();

	  	
#ifdef DEBUG
		OUT_adr(adc_bankU_,10);
#endif
		//OUT(3,adc_data,0,0,4,5,6);
		deltas=delta;
#ifdef DEBUG
		if(bCHER_) flags|=0x10;
		else flags&=0xef;

		if(!LED_NET) flags|=0x20;
		else flags&=0xdf;
		
		if(!LED_DEL) flags|=0x40;
		else flags&=0xbf;
		
		if(!LED_PER) flags|=0x80;
		else flags&=0x7f;
#endif								
		}
	if(b2Hz)
		{
		b2Hz=0;
		
	 	#ifdef TRIADA
	 	per_hndl();
	 	nn_hndl();
	 	#endif

		}		 
    	if(b1Hz)
		{
		b1Hz=0;
		del_hndl();
		#ifndef TRIADA
		per_hndl();
		nn_hndl(); 
		#endif
		 
         	//OUT(6,1,2,3,4,5,6);
		 
		}
     #asm("wdr")	
	}
}