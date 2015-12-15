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


#define SW1	6
#define SW2	7

#define PP1	6
#define PP2	7


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
eeprom enum{elmAUTO=0x55,elmMNL=0xaa}ee_loop_mode;
//eeprom char ee_program[2];
eeprom enum {p1=1,p2=2,p3=3,p4=4}ee_prog;
enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}step=sOFF;
enum {iMn,iPr_sel,iSet} ind;
char sub_ind;
char in_word,in_word_old,in_word_new,in_word_cnt;
bit bERR;
signed int cnt_del=0;

bit bSW1,bSW2;

char cnt_sw1,cnt_sw2;

//eeprom unsigned ee_delay[4,2];
//eeprom char ee_vr_log;
#include <mega16.h>
//#include <mega8535.h>  

bit bPP1,bPP2,bPP3,bPP4,bPP5,bPP6,bPP7,bPP8;

enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}payka_step=sOFF,napoln_step=sOFF,orient_step=sOFF,main_loop_step=sOFF;
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
if(ee_prog==p1)	
	{
     if(bSW1^bSW2) bERR=1;
 	else bERR=0;
	}
else bERR=0;
}
  

//-----------------------------------------------
void in_an(void)
{
DDRA=0x00;
PORTA=0xff;
in_word=PINA;

if(!(in_word&(1<<SW1)))
	{
	if(cnt_sw1<10)
		{
		cnt_sw1++;
		if(cnt_sw1==10) bSW1=1;
		}

	}
else
	{
	if(cnt_sw1)
		{
		cnt_sw1--;
		if(cnt_sw1==0) bSW1=0;
		}

	}

if(!(in_word&(1<<SW2)))
	{
	if(cnt_sw2<10)
		{
		cnt_sw2++;
		if(cnt_sw2==10) bSW2=1;
		}

	}
else
	{
	if(cnt_sw2)
		{
		cnt_sw2--;
		if(cnt_sw2==0) bSW2=0;
		}

	}


} 

//-----------------------------------------------
void main_loop_hndl(void)
{
	 
}



//-----------------------------------------------
void out_drv(void)
{
char temp=0;
DDRB=0xFF;

if(bPP1) temp|=(1<<PP1);
if(bPP2) temp|=(1<<PP2);

PORTB=~temp;
//PORTB=0x55;
}

//-----------------------------------------------
void step_contr(void)
{
char temp=0;
DDRB=0xFF;

if(ee_prog==p1)
	{
     if(bSW1&&bSW2)step=s1;
     else step=sOFF;
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

PORTB=~temp;
//PORTB=0x55;
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
if(ind==iMn)
	{
	if(ee_prog==EE_PROG_FULL)
		{
		}
	else if(ee_prog==EE_PROG_ONLY_ORIENT)
		{
		int2ind(orient_step,0);
		}
	else if(ee_prog==EE_PROG_ONLY_NAPOLN)
		{
		int2ind(napoln_step,0);                              
		}			                
	else if(ee_prog==EE_PROG_ONLY_PAYKA)
		{
		int2ind(payka_step,0);
		}
	else if(ee_prog==EE_PROG_ONLY_MAIN_LOOP)
		{
		int2ind(main_loop_step,0);
		}			
	
	//int2ind(bDM,0);
	//int2ind(in_word,0);
	//int2ind(cnt_dm,0);
	
	//int2ind(bDM,0);
	//int2ind(ee_delay[prog,sub_ind],1);  
	//ind_out[0]=0xff;//DIGISYM[0];
	//ind_out[1]=0xff;//DIGISYM[1];
	//ind_out[2]=DIGISYM[2];//0xff;
	//ind_out[0]=DIGISYM[7]; 

	//ind_out[0]=DIGISYM[sub_ind+1];
	}
else if(ind==iSet)
	{
     if(sub_ind==0)int2ind(ee_prog,0);
	else if(sub_ind==1)int2ind(ee_temp1,1);
	else if(sub_ind==2)int2ind(ee_temp2,1);
	else if(sub_ind==3)int2ind(ee_temp3,1);
	else if(sub_ind==4)int2ind(ee_temp4,1);
		
	if(bFL5)ind_out[0]=DIGISYM[sub_ind+1];
	else    ind_out[0]=DIGISYM[10];
	}
}

//-----------------------------------------------
void led_hndl(void)
{
ind_out[4]=DIGISYM[10]; 

ind_out[4]&=~(1<<LED_POW_ON); 

if(step!=sOFF)
	{
	ind_out[4]&=~(1<<LED_WRK);
	}
else ind_out[4]|=(1<<LED_WRK);


if(step==sOFF)
	{
 	if(bERR)
		{
		ind_out[4]&=~(1<<LED_ERROR);
		}
	else
		{
		ind_out[4]|=(1<<LED_ERROR);
		}
     }
else ind_out[4]|=(1<<LED_ERROR);

/* 	if(bMD1)
		{
		ind_out[4]&=~(1<<LED_ERROR);
		}
	else
		{
		ind_out[4]|=(1<<LED_ERROR);
		} */

//if(bERR)ind_out[4]&=~(1<<LED_ERROR);
ind_out[4]|=(1<<LED_LOOP_AUTO);

/*if(prog==p1) ind_out[4]&=~(1<<LED_PROG1);
else if(prog==p2) ind_out[4]&=~(1<<LED_PROG2);
else if(prog==p3) ind_out[4]&=~(1<<LED_PROG3);
else if(prog==p4) ind_out[4]&=~(1<<LED_PROG4); */

/*if(ind==iPr_sel)
	{
	if(bFL5)ind_out[4]|=(1<<LED_PROG1)|(1<<LED_PROG2)|(1<<LED_PROG3)|(1<<LED_PROG4);
	}*/ 
	 
/*if(ind==iVr)
	{
	if(bFL5)ind_out[4]|=(1<<LED_POW_ON);
	} */
if(ee_prog==p1) ind_out[4]&=~(1<<LED_PROG1);
else if(ee_prog==p2) ind_out[4]&=~(1<<LED_PROG2);
else if(ee_prog==p3) ind_out[4]&=~(1<<LED_PROG3);
else if(ee_prog==p4) ind_out[4]&=~(1<<LED_PROG4);	
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
if(++ind_cnt>=6)ind_cnt=0;

if(ind_cnt<5)
	{
	DDRC=0xFF;
	PORTC=0xFF;
	DDRD|=0b11111000;
	PORTD|=0b11111000;
	PORTD&=IND_STROB[ind_cnt];
	PORTC=ind_out[ind_cnt];
	}
else but_drv();
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
ind=iMn;
prog_drv();
ind_hndl();
led_hndl();


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
		but_an();
	    	//in_drv();
          ind_hndl();
          step_contr();
          
          main_loop_hndl();

          out_drv();
		}   
	if(b10Hz)
		{
		b10Hz=0;
		prog_drv();
		err_drv();
		
    	     
          led_hndl();
          
          }

      };
}
