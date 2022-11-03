#define SLAVE_MESS_LEN	4

#define LED_POW_ON	5
#define LED_PROG4	1
#define LED_PROG2	2
#define LED_PROG3	3
#define LED_PROG1	4 
#define LED_ERROR	0 
#define LED_WRK	6
#define LED_AVTOM	7



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



bit b600Hz;
bit b100Hz;
bit b10Hz;
char t0_cnt0_,t0_cnt0,t0_cnt1,t0_cnt2,t0_cnt3;
char ind_cnt;
flash char IND_STROB[]={0b10111111,0b11011111,0b11101111,0b11110111,0b01111111};
flash char DIGISYM[]={0b11000000,0b11111001,0b10100100,0b10110000,0b10011001,0b10010010,0b10000010,0b11111000,0b10000000,0b10010000,0b11111111};								
#define SYMn 0b10101011
#define SYMo 0b10100011
#define SYMf 0b10001110
#define SYMu 0b11100011
#define SYMt 0b10000111
#define SYMs 0b10010010
#define SYM  0b11111111
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
enum {iMn,iPr_sel,iSet_sel,iSet_delay,iCh_on} ind;
char sub_ind;
char in_word,in_word_old,in_word_new,in_word_cnt;
bit bERR;
signed int cnt_del=0;
bit bVR;
bit bMD1;
bit bMD2;
bit bMD3;
char cnt_md1,cnt_md2,cnt_vr,cnt_md3;

eeprom enum {coOFF='F',coON='O',coTST='T'}ch_on[6];
eeprom unsigned ee_timer1_delay;
bit opto_angle_old;
enum {msON=0x55,msOFF=0xAA}motor_state;
unsigned timer1_delay;

char stop_cnt/*,start_cnt*/;
char cnt_net_drv,cnt_drv;
char cmnd_byte,state_byte,crc_byte,tst_byte;
signed char od_cnt;
enum {odON=55,odOFF=77}od;
char state[3];
enum{sOFF,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16}step_main=sOFF;
char plazma;
signed cnt_del_main;
bit bDel;
#include <mega32.h>
#include <stdio.h>
#include "usart_host.c"  
enum{amON=0x55,amOFF=0xaa}avtom_mode=amOFF; 
char avtom_mode_cnt;

//-----------------------------------------------
void od_drv(void)
{

if(!PINA.1)
	{
	if(od_cnt<10)od_cnt++;
	}
else
	{
	if(od_cnt>0)od_cnt--;
	} 

if(od_cnt>=9)od=odON;
else if(od_cnt<=1)od=odOFF;

DDRA.1=0;
PORTA.1=1;

}
 
//-----------------------------------------------
void avtom_mode_drv(void)
{
if(in_word&(1<<2))
	{
	if(avtom_mode_cnt) avtom_mode_cnt--;
	}
	
else 
	{
	if(avtom_mode_cnt<100) avtom_mode_cnt++;
	}

if(avtom_mode_cnt>90)avtom_mode=amON;
else if(avtom_mode_cnt<10)avtom_mode=amOFF; 		
}

//-----------------------------------------------
void out_drv(void)
{
DDRB|=0xff;
if(stop_cnt)
	{
	stop_cnt--;
	PORTB&=0xf0;
	}
else PORTB|=0x0f;

if(motor_state==msON)
	{
	//start_cnt--;
	PORTB&=0x0f;
	}
else PORTB|=0xf0;
}


//-----------------------------------------------
void step_main_contr(void)
{

if(step_main==sOFF)
	{
	cmnd_byte=0x33;
	}
else if(step_main==s1)
	{
	cmnd_byte=0x33;
	//if(od==odON)
		{
		step_main=s2;
		cnt_del_main=30;
		}
	}
else if(step_main==s2)
	{
	cmnd_byte=0x33;
	cnt_del_main--;
	if(cnt_del_main==0)
		{
  		motor_state=msON;
     	//start_cnt=20;
		step_main=s3;
		bDel=0;
		}
	}
else if(step_main==s3)
	{
	cmnd_byte=0x33;
	if(motor_state==msOFF)
		{
		step_main=s4;
		cnt_del_main=30;
		}
	
	}
else if(step_main==s4)
	{              
	cmnd_byte=0x33;
	cnt_del_main--;
	if(cnt_del_main==0)
		{
		step_main=s5;
		cnt_del_main=100;
		}
	}   
else if(step_main==s5)
	{              
	cmnd_byte=0x55;
	cnt_del_main--;
	if(cnt_del_main==0)
		{
		step_main=s6;
		}
	}	
else if(step_main==s6)
	{              
	cmnd_byte=0x55;
	if((((state[0]&0b00000100)==0)||(ch_on[0]!=coON))
		&&(((state[0]&0b00100000)==0)||(ch_on[1]!=coON))
		&&(((state[1]&0b00000100)==0)||(ch_on[2]!=coON))
		&&(((state[1]&0b00100000)==0)||(ch_on[3]!=coON))
		&&(((state[2]&0b00000100)==0)||(ch_on[4]!=coON))
		&&(((state[2]&0b00100000)==0)||(ch_on[5]!=coON)))step_main=s7;
	}
else if(step_main==s7)
	{
	cmnd_byte=0x33;
	if(avtom_mode==amON)step_main=s1;
	else step_main=sOFF;
	}
	
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

crc_byte=cmnd_byte^state_byte;
}

//-----------------------------------------------
void net_drv(void)
{
if(++cnt_net_drv>=3)
	{
	cnt_net_drv=0;
	if(++cnt_drv>=4)
		{
		cnt_drv=1;
		} 
		
	cmnd_byte|=0x80;
	state_byte=ch_on[(cnt_drv-1)*2];//0xff;
    tst_byte=ch_on[((cnt_drv-1)*2)+1];//0xff;
/*
	if(ch_on[0]!=coON)state_byte&=~(1<<0);
	if(ch_on[1]!=coON)state_byte&=~(1<<1);
	if(ch_on[2]!=coON)state_byte&=~(1<<2);
	if(ch_on[3]!=coON)state_byte&=~(1<<3);
	if(ch_on[4]!=coON)state_byte&=~(1<<4);
	if(ch_on[5]!=coON)state_byte&=~(1<<5);

	if(ch_on[0]==coTST)tst_byte&=~(1<<0);
	if(ch_on[1]==coTST)tst_byte&=~(1<<1);
	if(ch_on[2]==coTST)tst_byte&=~(1<<2);
	if(ch_on[3]==coTST)tst_byte&=~(1<<3);
	if(ch_on[4]==coTST)tst_byte&=~(1<<4);
	if(ch_on[5]==coTST)tst_byte&=~(1<<5);  */
    
	crc_byte=cmnd_byte^state_byte;
    crc_byte=crc_byte^tst_byte;
	crc_byte=crc_byte^cnt_drv;
	crc_byte|=0x80;
		            
	out_usart(5,cnt_drv,cmnd_byte,state_byte,tst_byte,crc_byte,0,0,0,0);	
	}
}
//-----------------------------------------------
void in_drv(void)
{
char i,temp;
unsigned int tempUI;
DDRA&=0x00;
PORTA|=0xff;
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
if(step_main==sOFF)
	{
	if((((state[0]&0b00000011)!=0b00000010)&&(ch_on[0]==coON))
		||(((state[0]&0b00011000)!=0b00010000)&&(ch_on[1]==coON))
		||(((state[1]&0b00000011)!=0b00000010)&&(ch_on[2]==coON))
		||(((state[1]&0b00011000)!=0b00010000)&&(ch_on[3]==coON))
		||(((state[2]&0b00000011)!=0b00000010)&&(ch_on[4]==coON))
		||(((state[2]&0b00011000)!=0b00010000)&&(ch_on[5]==coON))) bERR=1;
	else bERR=0;
	}
else bERR=0;

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

if(!(in_word&(1<<MD3)))
	{
	if(cnt_md3<10)
		{
		cnt_md3++;
		if(cnt_md3==10) bMD3=1;
		}

	}
else
	{
	if(cnt_md3)
		{
		cnt_md3--;
		if(cnt_md3==0) bMD3=0;
		}

	}

if(!(in_word&(1<<VR)))
	{
	if(cnt_vr<10)
		{
		cnt_vr++;
		if(cnt_vr==10) bVR=1;
		}

	}
else
	{
	if(cnt_vr)
		{
		cnt_vr--;
		if(cnt_vr==0) bVR=0;
		}

	}
} 

#ifdef P380
//-----------------------------------------------
void step_contr(void)
{
char temp=0;
DDRB=0xFF;

if(step==sOFF)
	{
	temp=0;
	}

else if(prog==p1)
	{
	if(step==s1)
		{
		temp|=(1<<PP1)|(1<<PP2);

		cnt_del--;
		if(cnt_del==0)
			{
			if(ee_vacuum_mode==evmOFF)
				{
				goto lbl_0001;
				}
			else step=s2;
			}
		}

	else if(step==s2)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);

          if(!bVR)goto step_contr_end;
lbl_0001:
#ifndef BIG_CAM
		cnt_del=30;
#endif

#ifdef BIG_CAM
		cnt_del=100;
#endif
		step=s3;
		}

	else if(step==s3)
		{
		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);
		cnt_del--;
		if(cnt_del==0)
			{
			step=s4;
			}
          }
	else if(step==s4)
		{
		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);

          if(!bMD1)goto step_contr_end;

		cnt_del=30;
		step=s5;
		}
	else if(step==s5)
		{
		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);

		cnt_del--;
		if(cnt_del==0)
			{
			step=s6;
			}
		}
	else if(step==s6)
		{
		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);

         	if(!bMD2)goto step_contr_end;
          cnt_del=30;
		step=s7;
		}
	else if(step==s7)
		{
		temp|=(1<<PP1)|(1<<PP3)|(1<<PP5)|(1<<DV);

		cnt_del--;
		if(cnt_del==0)
			{
			step=s8;
			cnt_del=30;
			}
		}
	else if(step==s8)
		{
		temp|=(1<<PP1)|(1<<PP3);

		cnt_del--;
		if(cnt_del==0)
			{
			step=s9;
#ifndef BIG_CAM
		cnt_del=150;
#endif

#ifdef BIG_CAM
		cnt_del=200;
#endif
			}
		}
	else if(step==s9)
		{
		temp|=(1<<PP1)|(1<<PP2);

		cnt_del--;
		if(cnt_del==0)
			{
			step=s10;
			cnt_del=30;
			}
		}
	else if(step==s10)
		{
		temp|=(1<<PP2);
		cnt_del--;
		if(cnt_del==0)
			{
			step=sOFF;
			}
		}
	}

if(prog==p2)
	{

	if(step==s1)
		{
		temp|=(1<<PP1)|(1<<PP2);

		cnt_del--;
		if(cnt_del==0)
			{
			if(ee_vacuum_mode==evmOFF)
				{
				goto lbl_0002;
				}
			else step=s2;
			}
		}

	else if(step==s2)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);

          if(!bVR)goto step_contr_end;
lbl_0002:
#ifndef BIG_CAM
		cnt_del=30;
#endif

#ifdef BIG_CAM
		cnt_del=100;
#endif
		step=s3;
		}

	else if(step==s3)
		{
		temp|=(1<<PP1)|(1<<PP3)|(1<<DV);

		cnt_del--;
		if(cnt_del==0)
			{
			step=s4;
			}
		}

	else if(step==s4)
		{
		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);

          if(!bMD1)goto step_contr_end;
         	cnt_del=30;
		step=s5;
		}

	else if(step==s5)
		{
		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<DV);

		cnt_del--;
		if(cnt_del==0)
			{
			step=s6;
			cnt_del=30;
			}
		}

	else if(step==s6)
		{
		temp|=(1<<PP1)|(1<<PP3);

		cnt_del--;
		if(cnt_del==0)
			{
			step=s7;
#ifndef BIG_CAM
		cnt_del=150;
#endif

#ifdef BIG_CAM
		cnt_del=200;
#endif
			}
		}

	else if(step==s7)
		{
		temp|=(1<<PP1)|(1<<PP2);

		cnt_del--;
		if(cnt_del==0)
			{
			step=s8;
			cnt_del=30;
			}
		}
	else if(step==s8)
		{
		temp|=(1<<PP2);

		cnt_del--;
		if(cnt_del==0)
			{
			step=sOFF;
			}
		}
	}

if(prog==p3)
	{

	if(step==s1)
		{
		temp|=(1<<PP1)|(1<<PP2);

		cnt_del--;
		if(cnt_del==0)
			{
			if(ee_vacuum_mode==evmOFF)
				{
				goto lbl_0003;
				}
			else step=s2;
			}
		}

	else if(step==s2)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);

          if(!bVR)goto step_contr_end;
lbl_0003:
#ifndef BIG_CAM
		cnt_del=80;
#endif

#ifdef BIG_CAM
		cnt_del=100;
#endif
		step=s3;
		}

	else if(step==s3)
		{
		temp|=(1<<PP1)|(1<<PP3);

		cnt_del--;
		if(cnt_del==0)
			{
			step=s4;
			cnt_del=120;
			}
		}

	else if(step==s4)
		{
		temp|=(1<<PP1)|(1<<PP3)|(1<<PP4)|(1<<PP5);

		cnt_del--;
		if(cnt_del==0)
			{
			step=s5;

		
#ifndef BIG_CAM
		cnt_del=150;
#endif

#ifdef BIG_CAM
		cnt_del=200;
#endif
	//	step=s5;
	}
		}

	else if(step==s5)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP4)|(1<<PP5);

		cnt_del--;
		if(cnt_del==0)
			{
			step=s6;
			cnt_del=30;
			}
		}

	else if(step==s6)
		{
		temp|=(1<<PP2)|(1<<PP4)|(1<<PP5);

		cnt_del--;
		if(cnt_del==0)
			{
			step=s7;
			cnt_del=30;
			}
		}

	else if(step==s7)
		{
		temp|=(1<<PP2);

		cnt_del--;
		if(cnt_del==0)
			{
			step=sOFF;
			}
		}

	}
step_contr_end:

if(ee_vacuum_mode==evmOFF) temp&=~(1<<PP3);

PORTB=~temp;
}
#endif
#ifdef I380
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

		}

	else if(step==s2)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
          if(!bVR)goto step_contr_end;
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
          if(!bMD3)goto step_contr_end;
          step=s7;
          cnt_del=20;
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


          //step=s2;
		}

	else if(step==s2)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
          if(!bVR)goto step_contr_end;

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


          //step=s2;
		}

	else if(step==s2)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
          if(!bVR)goto step_contr_end;
lbl_0003:
          cnt_del=50;
		step=s3;
		}



	else if(step==s4)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3)|(1<<PP4)|(1<<PP5)|(1<<PP7);
		cnt_del--;
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

          //step=s2;
		}

	else if(step==s2)
		{
		temp|=(1<<PP1)|(1<<PP2)|(1<<PP3);
          if(!bVR)goto step_contr_end;
lbl_0004:
          step=s3;
		cnt_del=50;
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


PORTB=~temp;
//PORTB=0x55;
}
#endif


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
void uart_in_an(void)
{
state[rx_buffer[0]-1]=rx_buffer[1];

/*state_new=rx_buffer[2];
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
				state_an();
				}
			}         
		}	
	}		
else state_cnt=0;
state_old=state_new;*/
	 
/*state=rx_buffer[2];
state_an();*/					
	
}


//-----------------------------------------------
void mathemat(void)
{
timer1_delay=ee_timer1_delay*31;
}

//-----------------------------------------------
void ind_hndl(void)
{
if(ind==iMn)
	{
//int2ind(ee_delay[prog,sub_ind],1);  
//ind_out[0]=0xff;//DIGISYM[0];
//ind_out[1]=0xff;//DIGISYM[1];
//ind_out[2]=DIGISYM[2];//0xff;
//ind_out[0]=DIGISYM[7]; 

//ind_out[0]=DIGISYM[sub_ind+1];
    //int2ind(but_n,0);
	int2ind(step_main,0);
	//int2ind(stop_cnt,0);
    //int2ind(in_word,0); 
    //int2ind(state[0],1);
	} 
else if(ind==iSet_sel)
	{
	if(sub_ind==0)
		{
		if(ch_on[0]==coON)
			{
			ind_out[3]=SYMn;
			ind_out[2]=SYMo;
			ind_out[1]=SYM;
			}
        else if(ch_on[0]==coTST)
			{
			ind_out[3]=SYMt;
			ind_out[2]=SYMs;
			ind_out[1]=SYMt;
			}            
		else 
			{
			ind_out[3]=SYMf;
			ind_out[2]=SYMf;
			ind_out[1]=SYMo;
			}			
		}
	else if(sub_ind==1)
		{
		if(ch_on[1]==coON)
			{
			ind_out[3]=SYMn;
			ind_out[2]=SYMo;
			ind_out[1]=SYM;
			}
        else if(ch_on[1]==coTST)
			{
			ind_out[3]=SYMt;
			ind_out[2]=SYMs;
			ind_out[1]=SYMt;
			}                
		else 
			{
			ind_out[3]=SYMf;
			ind_out[2]=SYMf;
			ind_out[1]=SYMo;
			}			
		} 
		
	else if(sub_ind==2)
		{
		if(ch_on[2]==coON)
			{
			ind_out[3]=SYMn;
			ind_out[2]=SYMo;
			ind_out[1]=SYM;
			}
        else if(ch_on[2]==coTST)
			{
			ind_out[3]=SYMt;
			ind_out[2]=SYMs;
			ind_out[1]=SYMt;
			}                
		else 
			{
			ind_out[3]=SYMf;
			ind_out[2]=SYMf;
			ind_out[1]=SYMo;
			}			
		}	
		
	else if(sub_ind==3)
		{
		if(ch_on[3]==coON)
			{
			ind_out[3]=SYMn;
			ind_out[2]=SYMo;
			ind_out[1]=SYM;
			}
        else if(ch_on[3]==coTST)
			{
			ind_out[3]=SYMt;
			ind_out[2]=SYMs;
			ind_out[1]=SYMt;
			}                
		else 
			{
			ind_out[3]=SYMf;
			ind_out[2]=SYMf;
			ind_out[1]=SYMo;
			}			
		}	
		
	else if(sub_ind==4)
		{
		if(ch_on[4]==coON)
			{
			ind_out[3]=SYMn;
			ind_out[2]=SYMo;
			ind_out[1]=SYM;
			}
        else if(ch_on[4]==coTST)
			{
			ind_out[3]=SYMt;
			ind_out[2]=SYMs;
			ind_out[1]=SYMt;
			}                
		else 
			{
			ind_out[3]=SYMf;
			ind_out[2]=SYMf;
			ind_out[1]=SYMo;
			}			
		}	
		
	else if(sub_ind==5)
		{
		if(ch_on[5]==coON)
			{
			ind_out[3]=SYMn;
			ind_out[2]=SYMo;
			ind_out[1]=SYM;
			}  
        else if(ch_on[5]==coTST)
			{
			ind_out[3]=SYMt;
			ind_out[2]=SYMs;
			ind_out[1]=SYMt;
			}                
		else 
			{
			ind_out[3]=SYMf;
			ind_out[2]=SYMf;
			ind_out[1]=SYMo;
			}			
		}

	else if(sub_ind==6)
		{
		int2ind(ee_timer1_delay,0);		
		}
	else if(sub_ind==7)
		{
		ind_out[3]=SYMt;
		ind_out[2]=SYMu;
		ind_out[1]=SYMo;
		}															
	if(sub_ind!=7)ind_out[0]=DIGISYM[sub_ind+1];
	else ind_out[0]=SYM;
	if(bFL5)ind_out[0]=SYM;		
	} 
	
else if(ind==iCh_on)
	{
	ind_out[0]=SYM;
	if(ch_on[sub_ind]==coON)	
		{
		ind_out[3]=SYMn;
		ind_out[2]=SYMo;
		ind_out[1]=SYM;
		}
    else if(ch_on[sub_ind]==coTST)
	    {
	    ind_out[3]=SYMt;
	    ind_out[2]=SYMs;
	    ind_out[1]=SYMt;
	    }            
    else 
        {
    	ind_out[3]=SYMf;
		ind_out[2]=SYMf;
		ind_out[1]=SYMo;
		}
	if(bFL5)
		{
		ind_out[3]=SYM;
		ind_out[2]=SYM;
		ind_out[1]=SYM;
		}
	}		 
	
else if(ind==iSet_delay)
	{
	ind_out[0]=SYM;
	int2ind(ee_timer1_delay,0);
	if(bFL5)
		{
		ind_out[3]=SYM;
		ind_out[2]=SYM;
		ind_out[1]=SYM;
		}
	}			
}

//-----------------------------------------------
void led_hndl(void)
{
ind_out[4]=DIGISYM[10]; 

ind_out[4]&=~(1<<LED_POW_ON); 

if(step_main!=sOFF)
	{
	ind_out[4]&=~(1<<LED_WRK);
	}
else ind_out[4]|=(1<<LED_WRK);


if(step_main==sOFF)
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


//if(bERR)ind_out[4]&=~(1<<LED_ERROR);
if(avtom_mode==amON)ind_out[4]&=~(1<<LED_AVTOM);
else ind_out[4]|=(1<<LED_AVTOM);

if(ind==iSet_delay)
	{
	if(bFL5)ind_out[4]&=~(1<<LED_PROG4);
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
//-----------------------------------------------
void but_an(void)
{

if(!(in_word&0x01)) //старт
	{
     if(ind==iSet_delay)	
     	{
     	if(motor_state!=msON)
     		{
     		motor_state=msON;
     		//start_cnt=20;
     		bDel=0;
     		}
     	}
     else if(ind==iMn)
     	{
     	if((step_main==sOFF)&&(!bERR))step_main=s1;
     	}	
	}
if(!(in_word&0x02)) //стоп
	{
     if(ind==iSet_delay)	
     	{
     	if(motor_state==msON)
     		{
     		motor_state=msOFF;
     		stop_cnt=100;
     		}
     	}
      else if(ind==iMn)
     	{
     	if(step_main!=sOFF)
     		{
     		step_main=sOFF;
     		}
     	if(motor_state!=msOFF)
     		{
     		motor_state=msOFF;
     		stop_cnt=200;
     		}
     	}				

	}

if (!n_but) goto but_an_end;

if(but==butA_)
	{
	if(ee_avtom_mode==eamON)ee_avtom_mode=eamOFF;
	else ee_avtom_mode=eamON;
	}
	
if(ind==iMn)
	{
	if(but==butP_)
		{
		ind=iSet_sel;
		sub_ind=0;
		}
	} 
	
else if(ind==iSet_sel)
	{
	if(but==butP_)ind=iMn;
	if(but==butP)
		{
		if((sub_ind>=0)&&(sub_ind<=5))
			{
			ind=iCh_on;
			}
		else if(sub_ind==6)
			{
			ind=iSet_delay;
			}
		else if(sub_ind==7)
			{
			ind=iMn;
			}
		}
	
	if(but==butR)
		{
		sub_ind++;
		if(sub_ind>=7)sub_ind=7;
		}

	if(but==butL)
		{
		if(sub_ind)sub_ind--;
		if(sub_ind<=0)sub_ind=0;
		}	
	} 
else if(ind==iSet_delay)
	{
	if((but==butR)||(but==butR_)) 
		{
		speed=1;
		ee_timer1_delay++;
		if((ee_timer1_delay<=10)||(ee_timer1_delay>=500))ee_timer1_delay=500;
		} 
	else if((but==butL)||(but==butL_)) 
		{
		speed=1;
		ee_timer1_delay--;
		if((ee_timer1_delay<=10)||(ee_timer1_delay>=500))ee_timer1_delay=0;
		}
	else if(but==butP)
		{
		ind=iSet_sel;
		sub_ind=6;
		}		
	}
else if(ind==iCh_on)
	{
	if((but==butR)||(but==butR_))
		{
		if(ch_on[sub_ind]==coON)ch_on[sub_ind]=coTST; 
        else if(ch_on[sub_ind]==coTST)ch_on[sub_ind]=coOFF;
		else ch_on[sub_ind]=coON;
		} 
	else if((but==butL)||(but==butL_))
		{
		if(ch_on[sub_ind]==coON)ch_on[sub_ind]=coOFF;
        if(ch_on[sub_ind]==coOFF)ch_on[sub_ind]=coTST;
		else ch_on[sub_ind]=coON;
		}        
	else if(but==butP)
		{
		ind=iSet_sel;
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
//PORTD.7=0;
}

//***********************************************
//***********************************************
//***********************************************
//***********************************************
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
TCCR0=0x02;
TCNT0=-96;
OCR0=0x00;

if((!PINA.3)&&(opto_angle_old)&&(motor_state==msON)&&(!bDel))
	{
	
 	TCCR1A=0x00;
	TCCR1B=0x04;
	TCNT1=0;
	OCR1A=timer1_delay;
	bDel=1;
	TIMSK|=0x10;  
	
/*	DDRB.6=0;
PORTB.6=0;
stop_cnt=20;
motor_state=msOFF;  */
	}
	
opto_angle_old=PINA.3;
DDRA.3=0;
PORTA.3=1;

if(++t0_cnt0_>=16)
	{
	t0_cnt0_=0;
	
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
}

//***********************************************
// Timer 1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
TCCR1A=0x00;
TCCR1B=0x00;
TIMSK&=0xef;

DDRB.6=0;
PORTB.6=0; 

DDRB.7=0;
PORTB.7=1;

stop_cnt=20;
motor_state=msOFF;
bDel=0; 
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
ind=iMn;
ind_hndl();
led_hndl();

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
		but_an();
	    	in_drv();
          //mdvr_drv();
          step_main_contr();
          out_drv();
          err_drv();
          net_drv();
          //out_usart(4,0x01,0x85,0x86,0x87,0,0,0,0,0); 
          od_drv();
          avtom_mode_drv();
		}   
	if(b10Hz)
		{
		b10Hz=0;
		
    	     ind_hndl();
          led_hndl();
          mathemat();
          }

      };
}




