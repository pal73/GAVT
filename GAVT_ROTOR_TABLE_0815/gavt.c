#define LED_POW_ON	5
#define LED_PROG4	1
#define LED_PROG2	2
#define LED_PROG3	3
#define LED_PROG1	4 
#define LED_ERROR	0 
#define LED_WRK	6
#define LED_LOOP_AUTO	7

#define GAVT3

//#define P380
//#define I380
//#define I220
//#define P380_MINI
//#define TVIST_SKO
//#define I380_WI
//#define I220_WI
#define DV3KL2MD

#define BD1	7
#define BD2	4
#define DM	1
#define START	0
#define STOP	2
#define MD1	3
#define MD2	5

#define MD1	2
#define MD2	3
#define VR	4
#define MD3	5

#define PP1	6
#define PP2	7
#define PP3	5
#define PP4	4
#define PP5	3
#define DV	0 

#define PP7	2

#ifdef P380_MINI
#define MINPROG 1
#define MAXPROG 1 
#ifdef GAVT3
#define DV	2
#endif
#define PP3	3
#endif 

#ifdef P380
#define MINPROG 1
#define MAXPROG 3 
#ifdef GAVT3
#define DV	2
#endif
#endif 

#ifdef I380
#define MINPROG 1
#define MAXPROG 4
#endif

#ifdef I380_WI
#define MINPROG 1
#define MAXPROG 4
#endif

#ifdef I220
#define MINPROG 3
#define MAXPROG 4
#endif


#ifdef I220_WI
#define MINPROG 3
#define MAXPROG 4
#endif

#ifdef TVIST_SKO
#define MINPROG 2
#define MAXPROG 3
#define DV	2
#endif

#ifdef DV3KL2MD

#define PP1	6
#define PP2	7
#define PP3	3
//#define PP4	4
//#define PP5	3
#define DV	2 

#define MINPROG 2
#define MAXPROG 3

#endif

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
eeprom char ee_program[2];
enum {p1=1,p2=2,p3=3,p4=4}prog;
enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}step=sOFF;
enum {iMn,iPr_sel,iVr} ind;
char sub_ind;
char in_word,in_word_old,in_word_new,in_word_cnt;
bit bERR;
signed int cnt_del=0;

bit bMD1,bMD2,bBD1,bBD2,bDM,bSTART,bSTOP;

char cnt_md1,cnt_md2,cnt_bd1,cnt_bd2,cnt_dm,cnt_start,cnt_stop;

eeprom unsigned ee_delay[4,2];
eeprom char ee_vr_log;
#include <mega16.h>
//#include <mega8535.h>  

bit bPP1,bPP2,bPP3,bPP4,bPP5,bPP6,bPP7,bPP8;

enum{sOFF=0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s54,s55,s100}payka_step=sOFF,napoln_step=sOFF,main_loop_step=sOFF;
enum{cmdOFF=0,cmdSTART,cmdSTOP}payka_cmd=cmdOFF,napoln_cmd=cmdOFF,main_loop_cmd=cmdOFF;
signed short payka_cnt_del,napoln_cnt_del;
eeprom signed short ee_temp1,ee_temp2;

bit bPAYKA_COMPLETE=0,bNAPOLN_COMPLETE=0;

//-----------------------------------------------
void prog_drv(void)
{
char temp,temp1,temp2;

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

prog=temp;
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
if(step==sOFF)
	{
    	if(prog==p2)	
    		{
       		if(bMD1) bERR=1;
       		else bERR=0;
		}
	}
else bERR=0;
}
  

//-----------------------------------------------
void in_an(void)
{
DDRA=0x00;
PORTA=0xff;
in_word=PINA;

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

if(!(in_word&(1<<BD1)))
	{
	if(cnt_bd1<10)
		{
		cnt_bd1++;
		if(cnt_bd1==10) bBD1=1;
		}

	}
else
	{
	if(cnt_bd1)
		{
		cnt_bd1--;
		if(cnt_bd1==0) bBD1=0;
		}

	}

if(!(in_word&(1<<BD2)))
	{
	if(cnt_bd2<10)
		{
		cnt_bd2++;
		if(cnt_bd2==10) bBD2=1;
		}

	}
else
	{
	if(cnt_bd2)
		{
		cnt_bd2--;
		if(cnt_bd2==0) bBD2=0;
		}

	}

if(!(in_word&(1<<DM)))
	{
	if(cnt_dm<10)
		{
		cnt_dm++;
		if(cnt_dm==10) bDM=1;
		}
	}
else
	{
	if(cnt_dm)
		{
		cnt_dm--;
		if(cnt_dm==0) bDM=0;
		}
	}

if(!(in_word&(1<<START)))
	{
	if(cnt_start<10)
		{
		cnt_start++;
		if(cnt_start==10) 
			{
			bSTART=1;
			main_loop_cmd==cmdSTART;
			}
		}
	}
else
	{
	if(cnt_start)
		{
		cnt_start--;
		if(cnt_start==0) bSTART=0;
		}
	} 

if(!(in_word&(1<<STOP)))
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
} 

//-----------------------------------------------
void main_loop_hndl(void)
{
if(main_loop_cmd==cmdSTART)
	{
	payka_cmd=cmdSTART;
	main_loop_cmd=cmdOFF;
	}                      
else if(main_loop_cmd==cmdSTOP)
	{

	}
	 
}

//-----------------------------------------------
void payka_hndl(void)
{
if(payka_cmd==cmdSTART)
	{
	payka_step=s1;
	payka_cnt_del=ee_temp1;
	bPAYKA_COMPLETE=0;
	payka_cmd=cmdOFF;
	}                      
else if(payka_cmd==cmdSTOP)
	{
	payka_step=sOFF;
	payka_cmd=cmdOFF;
	} 
		
if(payka_step==sOFF)
	{
	bPP6=0;
	bPP7=0;
	}      
else if(payka_step==s1)
	{
	bPP6=1;
	bPP7=0;
	payka_cnt_del--;
	if(payka_cnt_del==0)
		{
		payka_step=s2;
		payka_cnt_del=20;
		}                	
	}	
else if(payka_step==s2)
	{
	bPP6=0;
	bPP7=0;
	payka_cnt_del--;
	if(payka_cnt_del==0)
		{
		payka_step=s3;
		payka_cnt_del=ee_temp2;
		}                	
	}		  
else if(payka_step==s3)
	{
	bPP6=0;
	bPP7=1;
	payka_cnt_del--;
	if(payka_cnt_del==0)
		{
		payka_step=sOFF;
		bPAYKA_COMPLETE=1;
		}                	
	}			
}

//-----------------------------------------------
void napoln_hndl(void)
{
if(napoln_cmd==cmdSTART)
	{
	napoln_step=s1;
	napoln_cnt_del=0;
	bNAPOLN_COMPLETE=0;
	
	napoln_cmd=cmdOFF;
	}                      
else if(napoln_cmd==cmdSTOP)
	{
	napoln_step=sOFF;
	napoln_cmd=cmdOFF;
	} 
		
if(napoln_step==sOFF)
	{
	bPP4=0;
	bPP5=0;
	}      
else if(napoln_step==s1)
	{
	bPP4=0;
	bPP5=0;
	if(BD2)
		{
		napoln_step=s2;
		napoln_cnt_del=20;
		}
	}	
else if(napoln_step==s2)
	{
	bPP4=1;
	bPP5=0;
	napoln_cnt_del--;
	if(napoln_cnt_del==0)
		{
		napoln_step=s3;
		}                	
	}		  
else if(napoln_step==s3)
	{
	bPP4=1;
	bPP5=1;
	napoln_cnt_del--;
	if(bMD2)
		{
		napoln_step=sOFF;
		bNAPOLN_COMPLETE=1;
		}                	
	}			
}
//-----------------------------------------------
void step_contr(void)
{
char temp=0;
DDRB=0xFF;

if(step==sOFF)goto step_contr_end;

else if(prog==p1)
	{
	if(step==s1)    //жесть
		{
		temp|=(1<<PP1);
          if(!bMD1)goto step_contr_end;

			//if(ee_vacuum_mode==evmOFF)
				{
				//goto lbl_0001;
				}
			//else step=s2;
		}

	else if(step==s2)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
 //         if(!bVR)goto step_contr_end;
lbl_0001:

          step=s100;
		cnt_del=40;
          }
	else if(step==s100)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
          cnt_del--;
          if(cnt_del==0)
			{
          	step=s3;
          	cnt_del=50;
			}
		}

	else if(step==s3)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
          cnt_del--;
          if(cnt_del==0)
			{
          	step=s4;
			}
		}
	else if(step==s4)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
          if(!bMD2)goto step_contr_end;
          step=s5;
          cnt_del=20;
		}
	else if(step==s5)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
          cnt_del--;
          if(cnt_del==0)
			{
          	step=s6;
			}
          }
	else if(step==s6)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV)|(1<<PP7);
 //         if(!bMD3)goto step_contr_end;
          step=s7;
          cnt_del=20;
		}

	else if(step==s7)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
          cnt_del--;
          if(cnt_del==0)
			{
          	step=s8;
          	cnt_del=ee_delay[prog,0]*10U;;
			}
          }
	else if(step==s8)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
          cnt_del--;
          if(cnt_del==0)
			{
          	step=s9;
          	cnt_del=20;
			}
          }
	else if(step==s9)
		{
		temp|=(1<<PP1);
          cnt_del--;
          if(cnt_del==0)
			{
          	step=sOFF;
          	}
          }
	}

else if(prog==p2)  //ско
	{
	if(step==s1)
		{
		temp|=(1<<PP1);
          if(!bMD1)goto step_contr_end;

		/*	if(ee_vacuum_mode==evmOFF)
				{
				goto lbl_0002;
				}
			else step=s2; */

          //step=s2;
		}

	else if(step==s2)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
 //         if(!bVR)goto step_contr_end;

lbl_0002:
          step=s100;
		cnt_del=40;
          }
	else if(step==s100)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
          cnt_del--;
          if(cnt_del==0)
			{
          	step=s3;
          	cnt_del=50;
			}
		}
	else if(step==s3)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
          cnt_del--;
          if(cnt_del==0)
			{
          	step=s4;
			}
		}
	else if(step==s4)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<DV);
          if(!bMD2)goto step_contr_end;
          step=s5;
          cnt_del=20;
		}
	else if(step==s5)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<DV);
          cnt_del--;
          if(cnt_del==0)
			{
          	step=s6;
          	cnt_del=ee_delay[prog,0]*10U;
			}
          }
	else if(step==s6)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
          cnt_del--;
          if(cnt_del==0)
			{
          	step=s7;
          	cnt_del=20;
			}
          }
	else if(step==s7)
		{
		temp|=(1<<PP1);
          cnt_del--;
          if(cnt_del==0)
			{
          	step=sOFF;
          	}
          }
	}

else if(prog==p3)   //твист
	{
	if(step==s1)
		{
		temp|=(1<<PP1);
          if(!bMD1)goto step_contr_end;

		/*	if(ee_vacuum_mode==evmOFF)
				{
				goto lbl_0003;
				}
			else step=s2;*/

          //step=s2;
		}

	else if(step==s2)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
 //         if(!bVR)goto step_contr_end;
lbl_0003:
          cnt_del=50;
		step=s3;
		}


	else	if(step==s3)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
		cnt_del--;
		if(cnt_del==0)
			{
			cnt_del=ee_delay[prog,0]*10U;
			step=s4;
			}
          }
	else if(step==s4)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
		cnt_del--;
 		if(cnt_del==0)
			{
			cnt_del=ee_delay[prog,1]*10U;
			step=s5;
			}
		}

	else if(step==s5)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP5)|(1<<PP7);
		cnt_del--;
		if(cnt_del==0)
			{
			step=s6;
			cnt_del=20;
			}
		}

	else if(step==s6)
		{
		temp|=(1<<PP1);
  		cnt_del--;
		if(cnt_del==0)
			{
			step=sOFF;
			}
		}

	}

else if(prog==p4)      //замок
	{
	if(step==s1)
		{
		temp|=(1<<PP1);
          if(!bMD1)goto step_contr_end;

		 /*	if(ee_vacuum_mode==evmOFF)
				{
				goto lbl_0004;
				}
			else step=s2;*/
          //step=s2;
		}

	else if(step==s2)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
 //         if(!bVR)goto step_contr_end;
lbl_0004:
          step=s3;
		cnt_del=50;
          }

	else if(step==s3)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4);
          cnt_del--;
          if(cnt_del==0)
			{
          	step=s4;
			cnt_del=ee_delay[prog,0]*10U;
			}
          }

   	else if(step==s4)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4);
		cnt_del--;
		if(cnt_del==0)
			{
			step=s5;
			cnt_del=30;
			}
		}

	else if(step==s5)
		{
		temp|=(1<<PP1)|(1<<PP4);
		cnt_del--;
		if(cnt_del==0)
			{
			step=s6;
			cnt_del=ee_delay[prog,1]*10U;
			}
		}

	else if(step==s6)
		{
		temp|=(1<<PP4);
		cnt_del--;
		if(cnt_del==0)
			{
			step=sOFF;
			}
		}

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
int2ind(bDM,0);
//int2ind(ee_delay[prog,sub_ind],1);  
//ind_out[0]=0xff;//DIGISYM[0];
//ind_out[1]=0xff;//DIGISYM[1];
//ind_out[2]=DIGISYM[2];//0xff;
//ind_out[0]=DIGISYM[7]; 

ind_out[0]=DIGISYM[sub_ind+1];
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
if(ee_loop_mode==elmAUTO)ind_out[4]&=~(1<<LED_LOOP_AUTO);
else ind_out[4]|=(1<<LED_LOOP_AUTO);

if(prog==p1) ind_out[4]&=~(1<<LED_PROG1);
else if(prog==p2) ind_out[4]&=~(1<<LED_PROG2);
else if(prog==p3) ind_out[4]&=~(1<<LED_PROG3);
else if(prog==p4) ind_out[4]&=~(1<<LED_PROG4);

if(ind==iPr_sel)
	{
	if(bFL5)ind_out[4]|=(1<<LED_PROG1)|(1<<LED_PROG2)|(1<<LED_PROG3)|(1<<LED_PROG4);
	} 
	 
if(ind==iVr)
	{
	if(bFL5)ind_out[4]|=(1<<LED_POW_ON);
	}	
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
/*
if(!(in_word&0x01))
	{
	#ifdef TVIST_SKO
	if((step==sOFF)&&(!bERR))
		{
		step=s1;
		if(prog==p2) cnt_del=70;
		else if(prog==p3) cnt_del=100;
		}
	#endif
	#ifdef DV3KL2MD
	if((step==sOFF)&&(!bERR))
		{
		step=s1;
		cnt_del=70;
		}
	#endif	
	#ifndef TVIST_SKO
	if((step==sOFF)&&(!bERR))
		{
		step=s1;
		if(prog==p1) cnt_del=50;
		else if(prog==p2) cnt_del=50;
		else if(prog==p3) cnt_del=50;
          #ifdef P380_MINI
  		cnt_del=100;
  		#endif
		}
	#endif
	}
if(!(in_word&0x02))
	{
	step=sOFF;

	} */

if (!n_but) goto but_an_end;

if(but==butV_)
	{
	if(ee_loop_mode!=elmAUTO)ee_loop_mode=elmAUTO;
	else ee_loop_mode=elmMNL;
	}

if(but==butVP_)
	{
	if(ind!=iVr)ind=iVr;
	else ind=iMn;
	}

	
if(ind==iMn)
	{
	if(but==butP_)ind=iPr_sel;
	if(but==butLR)	
		{
		if((prog==p3)||(prog==p4))
			{ 
			if(sub_ind==0)sub_ind=1;
			else sub_ind=0;
			}
    		else sub_ind=0;
		}	 
	if((but==butR)||(but==butR_))	
		{  
		speed=1;
		ee_delay[prog,sub_ind]++;
		}   
	
	else if((but==butL)||(but==butL_))	
		{  
    		speed=1;
    		ee_delay[prog,sub_ind]--;
    		}		
	} 
	
else if(ind==iPr_sel)
	{
	if(but==butP_)ind=iMn;
	if(but==butP)
		{
		prog++;
		if(prog>MAXPROG)prog=MINPROG;
		ee_program[0]=prog;
		ee_program[1]=prog;
		ee_program[2]=prog;
		}
	
	if(but==butR)
		{
		prog++;
		if(prog>MAXPROG)prog=MINPROG;
		ee_program[0]=prog;
		ee_program[1]=prog;
		ee_program[2]=prog;
		}

	if(but==butL)
		{
		prog--;
		if(prog>MAXPROG)prog=MINPROG;
		ee_program[0]=prog;
		ee_program[1]=prog;
		ee_program[2]=prog;
		}	
	} 

else if(ind==iVr)
	{
	if(but==butP_)
		{
		if(ee_vr_log)ee_vr_log=0;
		else ee_vr_log=1;
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

ee_temp1=10;
ee_temp2=10;
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
          payka_hndl();
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
