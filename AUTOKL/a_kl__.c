#define CH1_ON		DDRC.2=1;PORTC.2=1;
#define CH1_OFF	DDRC.2=1;PORTC.2=0;

#define CH2_ON		DDRC.3=1;PORTC.3=1;
#define CH2_OFF	DDRC.3=1;PORTC.3=0;

#define CH3_ON		DDRC.0=1;PORTC.0=1;
#define CH3_OFF	DDRC.0=1;PORTC.0=0;

#define CH4_ON		DDRC.1=1;PORTC.1=1;
#define CH4_OFF	DDRC.1=1;PORTC.1=0;

#define LCD_SIZE 40

#include <mega32.h>
#include <delay.h>
#include <stdio.h> 
#include <Lcd_4+2.h>
#include <spi.h>
#include <math.h>    
#include "gran.c"
//-----------------------------------------------
void gran_ring_char(signed char *adr, signed char min, signed char max)
{
if (*adr<min) *adr=max;
if (*adr>max) *adr=min; 
} 
 
//-----------------------------------------------
void gran_char(signed char *adr, signed char min, signed char max)
{
if (*adr<min) *adr=min;
if (*adr>max) *adr=max; 
} 

//-----------------------------------------------
void gran_char_ee(eeprom signed char  *adr, signed char min, signed char max)
{
if (*adr<min) *adr=min;
if (*adr>max) *adr=max; 
}

//-----------------------------------------------
void gran_ring(signed int *adr, signed int min, signed int max)
{
if (*adr<min) *adr=max;
if (*adr>max) *adr=min; 
} 

//-----------------------------------------------
void gran_ring_ee(eeprom signed int *adr, signed int min, signed int max)
{
if (*adr<min) *adr=max;
if (*adr>max) *adr=min; 
} 
//-----------------------------------------------
void gran(signed int *adr, signed int min, signed int max)
{
if (*adr<min) *adr=min;
if (*adr>max) *adr=max; 
} 


//-----------------------------------------------
void gran_ee(eeprom signed int  *adr, signed int min, signed int max)
{
if (*adr<min) *adr=min;
if (*adr>max) *adr=max; 
}
#include "ruslcd.c"
#ifndef  _rus_lcd_INCLUDED_
#define _rus_lcd_INCLUDED_ 
/*  ������� ������������
�����	������	�����	������	�����	������	�����	������	�����������
33	!	34	"	35	#	36	$	37	%
38	&	39	'	40	(	41	)	42	*
43	+	44	,	45	-	46	.	47	/
48	0	49	1	50	2	51	3	52	4
53	5	54	6	55	7	56	8	57	9
58	:	59	;	60	<	61	=	62	>
63	?	64	@	65	A	66	B	67	C
68	D	69	E	70	F	71	G	72	H
73	I	74	J	75	K	76	L	77	M
78	N	79	O	80	P	81	Q	82	R
83	S	84	T	85	U	86	V	87	W
88	X	89	Y	90	Z	91	[	92	\
93	]	94	^	95	_	96	`	97	a
98	b	99	c	100	d	101	e	102	f
103	g	104	h	105	I	106	j	107	k
108	l	109	m	110	n	111	o	112	p
113	q	114	r	115	s	116	t	117	u
118	v	119	w	120	x	121	y	122	z
123	{	124	|	125	}	126	~	132	"
133	�	145	'	146	'	147	"	148	"
149	o	150	-	151	-	153	�	166	�
167	�	168	�	169	�	171	"	172	   
174	�	176	�	177	�	178	�	179	�
182		183	�	184	�	185	�	187	"
192	�	193	�	194	�	195	�	196	�
197	�	198	�	199	�	200	�	201	�
202	�	203	�	204	�	205	�	206	�
207	�	208	�	209	�	210	�	211	�
212	�	213	�	214	�	215	�	216	�
217	�	218	�	219	�	220	�	221	�
222	�	223	�	224	�	225	�	226	�
227	�	228	�	229	�	230	�	231	�
232	�	233	�	234	�	235	�	236	�
237	�	238	�	239	�	240	�	241	�
242	�	243	�	244	�	245	�	246	�
247	�	248	�	249	�	250	�	251	�
252	�	253	�	254	�	255	�	-	-
*/
const unsigned char rus_buff[]={                             // ��� ����� 
0xFD,0xa2,255 ,                                     //167-169
170 ,0xc8,172 ,173 ,174 ,175 ,176 ,177 ,0xd7,0x69,  //170-179
180 ,181 ,0xfe,0xdf,0xb5,0xcc,186 ,0xc9,188 ,189 ,  //180-189
190 ,191 ,0x41,0xa0,0x42,0xa1,0xe0,0x45,0xa3,0xa4,  //190-199
0xa5,0xa6,0x4b,0xa7,0x4d,0x48,0x4f,0xa8,0x50,0x43,  //200-209
0x54,0xa9,0xaa,0x58,0xe1,0xab,0xac,0xe2,0xad,0xae,  //210-219
0xc4,0xaf,0xb0,0xb1,0x61,0xb2,0xb3,0xb4,0xe3,0x65,  //220-229
0xb6,0xb7,0xb8,0xb9,0xba,0xbb,0xbc,0xbd,0x6f,0xbe,  //230-239
0x70,0x63,0xbf,0x79,0xaa,0x78,0xe5,0xc0,0xc1,0xe6,  //240-249
0xc2,0xc3,0xc4,0xc5,0xc6,0xc7};                     //250-255
//�������������� ������� ���������� � 167 �������
//���������� ����� � ������-��� �� �������, ������� ���������� ���������� �� ���. 
//�� ����� ��������� �� ������ ����������.
//��������, ������ (�� ����) ������ �� ���������� @ (��� 169) �� ��� ����� ������������ 
//������ ���������� (��� 0�FF (255��������.) )
/*
@- 0�FF

*/
void ruslcd (unsigned char *buff){
unsigned char i;
i=0;
while ( buff[i]!=0 ) {
	if(buff[i]>166) buff[i]=rus_buff[buff[i]-167];
	i=i+1;}
	
/*	buff[0]=0x61;
	buff[1]=rus_buff[buff[1]-167];//0xb2;//rus_buff[buff[1]-167];
	buff[2]=0xb3;
	buff[3]=0xb4;*/

}//end void  
#endif
#asm
	.equ __lcd_port=0x15
	.equ __lcd_cntr_port=0x12
 	.equ __lcd_rs=6
  	.equ __lcd_en=7
#endasm 


//***********************************************
//���������
char 		*ptr_ram;
int 			*ptr_ram_int;
char flash 	*ptr_flash;
int eeprom	*ptr_eeprom_int;
unsigned int 	*adc_out;

bit b100Hz,b10Hz,b5Hz,b2Hz,b1Hz;
bit l_but;		//���� ������� ������� �� ������
bit n_but;          //��������� �������
bit speed;		//���������� ��������� ��������
bit zero_on;
bit bit_minus;
bit bAB;
bit bAN;
bit bAS1;
bit bAS2;
bit bFL2;
bit bFL__;
bit bI;

enum char {iMn,iMn_,iCh,iSet,iBat,iSrc,iS2,iSetprl,iKprl,iDnd,iK,
	iSpcprl,iSpc,Grdy,Prdy,Iwrk,Gwrk,Pwrk,k,Crash_0,Crash_1,iKednd,
	iLoad,iSpc_prl_vz,iDeb,iKe,iVz,iAVAR,iStr,iVrs,iTstprl,iTst,iDebug,iDefault,iSet_st_prl}ind;




flash char char0[8]=
{
0b0001000,
0b0001100,
0b0001110,
0b0001111,
0b0001110,
0b0001100,
0b0001000,
0b0000000};

flash char char1[8]=
{
0b0000110,
0b0001001,
0b0001001,
0b0000110,
0b0000000,
0b0000000,
0b0000000,
0b0000000};


flash char char2[8]=
{
0b00000,
0b00010,
0b00111,
0b01111,
0b11111,
0b11111,
0b01110,
0b00000};

flash char char2_[8]=
{
0b00000,
0b00100,
0b01110,
0b11111,
0b11111,
0b11111,
0b01110,
0b00000};

flash char char2__[8]=
{
0b00000,
0b01000,
0b11100,
0b11110,
0b11111,
0b11111,
0b01110,
0b00000};

flash char char3[8]=
{
0b0000100,
0b0001110,
0b0011111,
0b0000000,
0b0000000,
0b0000000,
0b0000000,
0b0000000};

flash char char4[8]=
{
0b00000,
0b00000,
0b01111,
0b01000,
0b01000,
0b01000,
0b01111,
0b00000};

flash char char5[8]=
{
0b10000,
0b11000,
0b11111,
0b11001,
0b10001,
0b00001,
0b11111,
0b00000};


char but;
unsigned char parol[3];
char dig[5];

char adc_cnt,adc_cnt1;

enum {tstOFF,tstON,tstU} tst_state[10];



signed char sub_ind,sub_ind1,index_set;

char cnt_ibat,cnt_ubat;
unsigned Fnet;
bit bFF,bFF_;
int Hz_out,Hz_cnt;
char t0cnt0_;
unsigned long cnt_vz_sec,cnt_vz_sec_; 
signed zar_cnt;
char cnt_ind;

char sound_pic,sound_tic,sound_cnt;
unsigned int av_beep,av_rele,av_stat;
//0 - ����
//1 - �������
//2 - ���1 ������
//3 - ���1 ������
//4 - ���1 ����������� 
//5 - ���2 ������
//6 - ���3 ������
//7 - ���4 ����������� 


char lcd_buffer[LCD_SIZE]={""};
char dumm2[40];
char cnt_alias_blok;
char star_cnt;





#include "ret.c"
char retind,retsub,retindsec;
int retcnt,retcntsec;
//-----------------------------------------------
void ret_ind(char r_i,char r_s,int r_c)
{
retcnt=r_c;
retind=r_i;
retsub=r_s;
}    

//-----------------------------------------------
void ret_ind_hndl(void)
{
if(retcnt)
	{
	if((--retcnt)==0)
		{
 		ind=retind;
   		sub_ind=retsub;
   		index_set=sub_ind;
	 	}
     }
}  


 
//---------------------------------------------
void ret_ind_sec(char r_i,int r_c)
{
retcntsec=r_c;
retindsec=r_i;
}

//-----------------------------------------------
void ret_ind_sec_hndl(void)
{
if(retcntsec)
 	{
	if((--retcntsec)==0)
	 	{
 		ind=retindsec;
 		sub_ind=0;

	 	}
   	}		
}   

char bmm_cnt,bmp_cnt;
bit bS=1;
eeprom signed int K_t[4]={1000,1050,1100,1150};
eeprom signed int ee_wrk_time[4]={1000,1050,1100,1150};
eeprom signed int ee_time_mode[4]={1000,1050,1100,1150}; 
eeprom enum {wsOFF,wsON}wrk_state[4]={wsOFF,wsOFF,wsOFF,wsOFF}; 
eeprom signed int ee_wrk_time_cnt_5[4];
eeprom signed int t_ust[4];
signed int wrk_time_cnt[4]={0,0,0,0};
signed int wrk_time_cnt_sec[4]={0,0,0,0};
signed int wrk_time_cnt_flag[4]={0,0,0,0};
signed nakal_cnt;
signed Un,In;
eeprom unsigned char ee_pwm;
//eeprom signed ee_nagrev_time,ee_wrk_time,ee_ostiv_time;

signed wrk_cnt;
eeprom signed Ku,Ki;
eeprom enum {im_1,im_2}ind_mode;
eeprom signed TIME_ust[4];
signed time_wrks[4]; 
char ind_cnt;
signed int temper[4]; 


flash signed int temper_table[21]={5102,5614,6156,6747,7368,
							8028,
							8727,9466,10244,11062,11909,
							12805,13731,14696,15701,16745,
							17828,18942,20104,20961,22015};

unsigned int adc_bank_[10];
flash char const_of_adc[4]={0,3,2,1};
char nd[4]={0,0,0,0}; 
char out_st[4]={0,0,0,0};  
char out_st_old[4]={0,0,0,0};
char cnt_block[4]={0,0,0,0};
char def_char_cnt; 

unsigned int adc_bank[10,4];
char cnt_ind_nd; 
//-----------------------------------------------
void start_process(char in)
{
wrk_state[in]=wsON;
if(ee_time_mode[in]==0)wrk_time_cnt_flag[in]=1;
else wrk_time_cnt_flag[in]=0;

wrk_time_cnt[in]=ee_wrk_time[in];
gran(&wrk_time_cnt[in],1,720);
wrk_time_cnt_sec[in]=120;

ee_wrk_time_cnt_5[in]=wrk_time_cnt[in]; 

cnt_block[in]=0;
}

//-----------------------------------------------
void stop_process(char in)
{
wrk_state[in]=wsOFF; 

wrk_time_cnt[in]=0;
wrk_time_cnt_sec[in]=0;
}

//-----------------------------------------------
void restart_process(char in)
{
if(wrk_state[in]==wsON)
	{
	if(ee_time_mode[in]=0)wrk_time_cnt_flag[in]=1;
	else wrk_time_cnt_flag[in]=0;
	
	wrk_time_cnt[in]=ee_wrk_time_cnt_5[in];
	wrk_time_cnt_sec[in]=120;
	}
}

//-----------------------------------------------
void wrk_process(char in)
{
if(cnt_block[in])cnt_block[in]--;
if(wrk_state[in]==wsON)
	{
	if(temper[in]<(t_ust[in]))
		{
		if(!cnt_block[in])
			{
			out_st[in]=1;
			}
		}
	else if(temper[in]>=(t_ust[in]))
		{
		if(!cnt_block[in])
			{
			out_st[in]=0;
			}
		wrk_time_cnt_flag[in]=1;
		}		
	}
else out_st[in]=0; 

if(out_st[in]!=out_st_old[in])cnt_block[in]=20;

out_st_old[in]=out_st[in];


if((ee_time_mode[in]==0)||(wrk_time_cnt_flag[in]==1))
	{
	if(wrk_time_cnt_sec[in])
		{
		wrk_time_cnt_sec[in]--;
		if(wrk_time_cnt_sec[in]==0)
			{
			if(wrk_time_cnt[in])
				{
				wrk_time_cnt_sec[in]=120;
				wrk_time_cnt[in]--;
				if((wrk_time_cnt[in]%5)==0)
					{
					ee_wrk_time_cnt_5[in]=wrk_time_cnt[in];
					} 
				if(wrk_time_cnt[in]==0)
					{
					
					}					
				}
			else 
				{
				stop_process(in);
				}
			}
		}
	}

}

//-----------------------------------------------
void out_drv(void)
{
if(out_st[0])
	{
	CH1_ON
	}
else 
	{
	CH1_OFF
	}	
	
if(out_st[1])
	{
	CH2_ON
	}
else 
	{
	CH2_OFF
	}	
	
if(out_st[2])
	{
	CH3_ON
	}
else 
	{
	CH3_OFF
	}	
	
if(out_st[3])
	{
	CH4_ON
	}
else 
	{
	CH4_OFF
	}				
}
		
//-----------------------------------------------
void adc_drv(void)
{
char i;
char temp;
unsigned int tempUI,tempUI_;

tempUI=ADCW;

for (i=0;i<4;i++)
	{
	adc_bank[adc_cnt,i]+=tempUI;
	}   


if((adc_cnt1&0x03)==0)  
	{
  	temp=(adc_cnt1&0x0c)>>2;
    	adc_bank_[adc_cnt]=(adc_bank[adc_cnt,temp])/16;
     adc_bank[adc_cnt,temp]=0;
   	} 		
        
if((++adc_cnt)>=4)
	{
	adc_cnt=0;
	if((++adc_cnt1)>=16)
		{
  		adc_cnt1=0;
  		}   
	}         

DDRA&=0b00001111;
PORTA&=0b00001111;

ADMUX=0b01000000|(4+adc_cnt);
SFIOR&=0b00011111;
ADCSRA=0b10100110;
ADCSRA|=0b01000000;  
    
}

//-----------------------------------------------
void define_char(char flash *pc,char ch_c)
{
char i,aaaa;
aaaa=(ch_c<<3)|0x40;
for (i=0; i<8; i++) lcd_write_byte(aaaa++,*pc++);
}

//-----------------------------------------------
void simbol_define(void)
{
#asm("cli")
//PORTD|=0b11111010;
//DDRD|=0b11111010;
delay_us(10);
define_char(char0,1);
define_char(char1,2);
if(def_char_cnt==0)define_char(char2,3);
else if(def_char_cnt==1)define_char(char2_,3);
else if(def_char_cnt==2)define_char(char2__,3);
else if(def_char_cnt==3)define_char(char2_,3);
else if(def_char_cnt==4)define_char(char2,3);
else if(def_char_cnt==5)define_char(char2_,3);
else if(def_char_cnt==6)define_char(char2,3);
else if(def_char_cnt==7)define_char(char2__,3);
else if(def_char_cnt==8)define_char(char2_,3);
else if(def_char_cnt==9)define_char(char2,3);
define_char(char3,4); 
define_char(char4,5);
define_char(char5,6); 
delay_us(10);
//PORTD|=0b11111010;
//DDRD|=0b11111010;
#asm("sei")
}

//-----------------------------------------------
void lcd_out(void)
{
#asm("cli")
//PORTD|=0b11111010;
//DDRD|=0b11111010;
delay_us(10);
lcd_gotoxy(0,0);
lcd_puts(lcd_buffer);
delay_us(10);
//PORTD|=0b11111010;
//DDRD|=0b11111010;
#asm("sei")
}

//-----------------------------------------------
void out_out(void)
{ 

}

//-----------------------------------------------
void parol_init(void)
{
parol[0]=0;
parol[1]=0;
parol[2]=0;
sub_ind=0;
}

//-----------------------------------------------
int Imat(int in,int k0,int k1)
{
signed long int temp;
temp= in-k0;
if(temp<0) temp=0;
temp*=k1;
temp/=100L;
return (int)temp;
}

//-----------------------------------------------
int Ibmat(int in,int k0,int k1)
{
signed long int temp;
temp= in-k0;
if(temp<0)
	{ 
	temp=-temp;
	bit_minus=1;
	}
else bit_minus=0;	
temp*=k1;
temp/=160L;
return (int)temp;
}


//-----------------------------------------------
void matemat(void)
{ 
signed long int temp_SL,temp_SL1;
char temp,i,ii;

/*for(i=0;i<4;i++)
	{ 
	temp_SL=(signed long)adc_bank_[const_of_adc[i]];
	
	if((temp_SL<200)||(temp_SL>800))nd[i]=1;
	else nd[i]=0;
	
	temp_SL*=(signed long)(10000+K_t[i]);
	
	temp_SL1=10240000L-temp_SL;
	
	temp_SL1/=10000;
	
	temp_SL/=temp_SL1;
	
	if((signed)temp_SL<=temper_table[0])
		{
		temper[i]=-50;
		break;
		}
	else if((signed)temp_SL>=temper_table[20])
		{
		temper[i]=150;
		break;		
		}
	else 
		{
	    	for(ii=0;ii<20;ii++)
			{
			if(((signed)temp_SL>=temper_table[ii])&&((signed)temp_SL<=temper_table[ii+1]))break;
			}
		temp_SL1=(signed long)temper_table[ii+1]-(signed long)temper_table[ii];		
		temp_SL-=(signed long)temper_table[ii];
		temp_SL*=10;
		temp_SL/=temp_SL1;
		
		temp_SL+=(signed long)(ii*10);
		temp_SL-=50L;
	    //	temper[i]=-50;
	    //	temper[i]+=(ii*10);
		//temper[i]=(signed)temp_SL;
		  
		temper[i]=(signed)temp_SL;
		}
			
	}
*/

temp_SL=(signed long)adc_bank_[0];
	
if((temp_SL<200)||(temp_SL>800))nd[0]=1;
else nd[0]=0;
	
temp_SL*=(signed long)(10000+K_t[0]);
	
temp_SL1=10240000L-temp_SL;
	
temp_SL1/=10000;
	
temp_SL/=temp_SL1;
	
if((signed)temp_SL<=temper_table[0])
	{
	temper[0]=-50;
	}
else if((signed)temp_SL>=temper_table[20])
	{
	temper[0]=150;
	}
else 
	{
	for(ii=0;ii<20;ii++)
		{
		if(((signed)temp_SL>=temper_table[ii])&&((signed)temp_SL<=temper_table[ii+1]))break;
		}
	temp_SL1=(signed long)temper_table[ii+1]-(signed long)temper_table[ii];		
	temp_SL-=(signed long)temper_table[ii];
	temp_SL*=10;
	temp_SL/=temp_SL1;
		
	temp_SL+=(signed long)(ii*10);
	temp_SL-=50L;
		  
	temper[0]=(signed)temp_SL;
     }



temp_SL=(signed long)adc_bank_[3];
	
if((temp_SL<200)||(temp_SL>800))nd[1]=1;
else nd[1]=0;
	
temp_SL*=(signed long)(10000+K_t[1]);
	
temp_SL1=10240000L-temp_SL;
	
temp_SL1/=10000;
	
temp_SL/=temp_SL1;
	
if((signed)temp_SL<=temper_table[0])
	{
	temper[1]=-50;
	}
else if((signed)temp_SL>=temper_table[20])
	{
	temper[1]=150;
	}
else 
	{
	for(ii=0;ii<20;ii++)
		{
		if(((signed)temp_SL>=temper_table[ii])&&((signed)temp_SL<=temper_table[ii+1]))break;
		}
	temp_SL1=(signed long)temper_table[ii+1]-(signed long)temper_table[ii];		
	temp_SL-=(signed long)temper_table[ii];
	temp_SL*=10;
	temp_SL/=temp_SL1;
		
	temp_SL+=(signed long)(ii*10);
	temp_SL-=50L;
		  
	temper[1]=(signed)temp_SL;
     }




temp_SL=(signed long)adc_bank_[2];
	
if((temp_SL<200)||(temp_SL>800))nd[2]=1;
else nd[2]=0;
	
temp_SL*=(signed long)(10000+K_t[2]);
	
temp_SL1=10240000L-temp_SL;
	
temp_SL1/=10000;
	
temp_SL/=temp_SL1;
	
if((signed)temp_SL<=temper_table[0])
	{
	temper[2]=-50;
	}
else if((signed)temp_SL>=temper_table[20])
	{
	temper[2]=150;
	}
else 
	{
	for(ii=0;ii<20;ii++)
		{
		if(((signed)temp_SL>=temper_table[ii])&&((signed)temp_SL<=temper_table[ii+1]))break;
		}
	temp_SL1=(signed long)temper_table[ii+1]-(signed long)temper_table[ii];		
	temp_SL-=(signed long)temper_table[ii];
	temp_SL*=10;
	temp_SL/=temp_SL1;
		
	temp_SL+=(signed long)(ii*10);
	temp_SL-=50L;
		  
	temper[2]=(signed)temp_SL;
     }
     



temp_SL=(signed long)adc_bank_[1];
	
if((temp_SL<200)||(temp_SL>800))nd[3]=1;
else nd[3]=0;
	
temp_SL*=(signed long)(10000+K_t[3]);
	
temp_SL1=10240000L-temp_SL;
	
temp_SL1/=10000;
	
temp_SL/=temp_SL1;
	
if((signed)temp_SL<=temper_table[0])
	{
	temper[3]=-50;
	}
else if((signed)temp_SL>=temper_table[20])
	{
	temper[3]=150;
	}
else 
	{
	for(ii=0;ii<20;ii++)
		{
		if(((signed)temp_SL>=temper_table[ii])&&((signed)temp_SL<=temper_table[ii+1]))break;
		}
	temp_SL1=(signed long)temper_table[ii+1]-(signed long)temper_table[ii];		
	temp_SL-=(signed long)temper_table[ii];
	temp_SL*=10;
	temp_SL/=temp_SL1;
		
	temp_SL+=(signed long)(ii*10);
	temp_SL-=50L;
		  
	temper[3]=(signed)temp_SL;
     }     
//Us[0]=Umat(adc_bank_[0],K_[kui1])/5;	
//Us[1]=Umat(adc_bank_[1],K_[kui2])/5;
//Ubat=Umat(adc_bank_[9]/4,K_[kub])/5;
//adc_out_temp=(signed long)adc_bank_[0];
//adc_out_temp*=(signed long)Ku;
//adc_out_temp/=200L; 
//Un=(signed)adc_out_temp;
//adc_out_temp=(signed long)adc_bank_[2];
//adc_out_temp*=(signed long)Ki;
//adc_out_temp/=100L;
//In=(signed)adc_out_temp;
//Un=(adc_bank_[0]*Ku)/200;
//In=(adc_bank_[2]*Ki)/200;



}

 
//-----------------------------------------------
char find(char xy)
{
char i=-1;
do i++;
while ((lcd_buffer[i]!=xy)&&(i<LCD_SIZE));
if(i>(33)) i=255;
return i;
}


//-----------------------------------------------
void bin2bcd_int(unsigned int in)
{
char i=5;
for(i=0;i<5;i++)
	{
	dig[i]=in%10;
	in/=10;
	}   
}

//-----------------------------------------------
void bcd2lcd_zero(char sig)
{
char i;
zero_on=1;
for (i=5;i>0;i--)
	{
	if(zero_on&&(!dig[i-1])&&(i>sig))
		{
		dig[i-1]=0x20;
		}
	else
		{
		dig[i-1]=dig[i-1]+0x30;
		zero_on=0;
		}	
	}
}    

//-----------------------------------------------
void int2lcd(unsigned int in,char xy,char des)
{
char i;
char n;

bin2bcd_int(in);
bcd2lcd_zero(des+1);
i=find(xy);
for (n=0;n<5;n++)
	{
   	if(!des&&(dig[n]!=' '))
   		{
   		lcd_buffer[i]=dig[n];	 
   		}
   	else 
   		{
   		if(n<des)lcd_buffer[i]=dig[n];
   		else if (n==des)
   			{
   			lcd_buffer[i]='.';
   			lcd_buffer[i-1]=dig[n];
   			} 
   		else if ((n>des)&&(dig[n]!=' ')) lcd_buffer[i-1]=dig[n];   		
   		}  
		
	i--;	
	}
}

//-----------------------------------------------
void int2lcdxy(unsigned int in,char xy,char des)
{
char i;
char n;
bin2bcd_int(in);
bcd2lcd_zero(des+1);
i=((xy&0b00000011)*16)+((xy&0b11110000)>>4);
if ((xy&0b00000011)>=2) i++;
if ((xy&0b00000011)==3) i++;
for (n=0;n<5;n++)
	{ 
	if(n<des)
		{
		lcd_buffer[i]=dig[n];
		}   
	if((n>=des)&&(dig[n]!=0x20))
		{
		if(!des)lcd_buffer[i]=dig[n];	
		else lcd_buffer[i-1]=dig[n];
   		}   
	i--;	
	}
}

//-----------------------------------------------
void int2lcd_mm(signed int in,char xy,char des)
{
char i;
char n;
char minus='+';
if(in<0)
	{
	in=abs(in);
	minus='-';
	}
bin2bcd_int(in);
bcd2lcd_zero(des+1);
i=find(xy);
for (n=0;n<5;n++)
	{
   	if(!des&&(dig[n]!=' '))
   		{
   		if((dig[n+1]==' ')&&(minus=='-'))lcd_buffer[i-1]='-';
   		lcd_buffer[i]=dig[n];	 
   		}
   	else 
   		{
   		if(n<des)lcd_buffer[i]=dig[n];
   		else if (n==des)
   			{
   			lcd_buffer[i]='.';
   			lcd_buffer[i-1]=dig[n];
   			} 
   		else if ((n>des)&&(dig[n]!=' ')) lcd_buffer[i-1]=dig[n]; 
   		else if ((minus=='-')&&(n>des)&&(dig[n]!=' ')&&(dig[n+1]==' ')) lcd_buffer[i]='-';  		
   		}  
		
	i--;	
	}
}

//-----------------------------------------------
void sint2lcdxy(signed int in,char xy,char des)
{
char i;
char n;
char sign;
sign=0;
if(in<0)
	{
	in=-in;
	sign=1;
	}
bin2bcd_int(in);
bcd2lcd_zero(des+1);
i=((xy&0b00000011)*16)+((xy&0b11110000)>>4);
if ((xy&0b00000011)>=2) i++;
if ((xy&0b00000011)==3) i++;
for (n=0;n<5;n++)
	{ 
	if(n<des)
		{
		lcd_buffer[i]=dig[n];
		}   
	if((n>=des)&&(dig[n]!=0x20))
		{
		if(!des)lcd_buffer[i]=dig[n];	
		else lcd_buffer[i-1]=dig[n];
   		}   
	i--;	
	}
}

//-----------------------------------------------
void sub_bgnd(char flash *adr,char xy,signed char offset)
{
char temp;
temp=find(xy);

//ptr_ram=&lcd_buffer[find(xy)];
if(temp!=255)
while (*adr)
	{
	lcd_buffer[temp+offset]=*adr++;
	temp++;
    	}
}

//-----------------------------------------------
void bgnd_par(char flash *ptr0,char flash *ptr1)
{
char i;
for (i=0;i<LCD_SIZE;i++)
	{
	lcd_buffer[i]=0x20;
	}
ptr_ram=lcd_buffer;
while (*ptr0)
	{
	*ptr_ram++=*ptr0++;
   	}
while (*ptr1)
	{
	*ptr_ram++=*ptr1++;
   	}
} 


//-----------------------------------------------
void ind_hndl(void)
{
/* 
flash char sm0_0[]	={" ���. �� ��� N] "};
flash char sm0_1[]	={" ���. �� N1 � N2"}; 
flash char sm0_2[]	={" ���. �� �������"};
flash char sm0_3[]	={" ��.N[   ���.N] "}; */

signed int temp;
flash char* ptrs[11];
char temp_;
if(cnt_ind_nd)cnt_ind_nd--;

if (ind==iMn)
	{
	if(ind_mode==im_1)
		{
		if(++ind_cnt>=40)ind_cnt=0;
		
		bgnd_par(	"!       @       ",
 				"#       $       "); 
                    
     	if((ind_cnt>=0)&&(ind_cnt<=20))
     		{
     		sub_bgnd("1   !gC",'!',0);
     		if(nd[0])sub_bgnd("�.�.",'!',-1);
     		else int2lcd_mm(temper[0],'!',0);
     		}
     	else 
     		{
     		sub_bgnd("1  #@0!",'!',0);
     		if(wrk_state[0])
     			{
     			//int2lcd(wrk_time_cnt,'1',0); 
     			int2lcd(wrk_time_cnt[0]%60,'!',0);
				int2lcd(wrk_time_cnt[0]/60,'#',0); 
				
				if((ee_time_mode[0]==0)||(wrk_time_cnt_flag[0]==1))
					{
					if(bFL2)lcd_buffer[find('@')]=':';
					else lcd_buffer[find('@')]=' ';
					} 
				else lcd_buffer[find('@')]=':';
     			}
			else sub_bgnd("����.",'!',-4);     			
     		}	
     	lcd_buffer[find('g')]=2;
     	
     	if(out_st[0])lcd_buffer[1]=3; 
     	
     	
     	if((ind_cnt>=15)&&(ind_cnt<=35))
     		{
     		sub_bgnd("2   !gC",'@',0);
     		if(nd[1])sub_bgnd("�.�.",'!',-1);
     		else int2lcd_mm(temper[1],'!',0);
     		}
     	else 
     		{
     		sub_bgnd("2  #@0!",'@',0);
     		if(wrk_state[1])
     			{
     			//int2lcd(wrk_time_cnt,'1',0); 
     			int2lcd(wrk_time_cnt[1]%60,'!',0);
				int2lcd(wrk_time_cnt[1]/60,'#',0); 
				
				if((ee_time_mode[1]==0)||(wrk_time_cnt_flag[1]==1))
					{
					if(bFL2)lcd_buffer[find('@')]=':';
					else lcd_buffer[find('@')]=' ';
					} 
				else lcd_buffer[find('@')]=':';
     			}
			else sub_bgnd("����.",'!',-4);     			
     		}	
     	lcd_buffer[find('g')]=2;
     	
     	if(out_st[1])lcd_buffer[9]=3;     	
 
      	if((ind_cnt>=10)&&(ind_cnt<=30))
     		{
     		sub_bgnd("3   !gC",'#',0);
     		if(nd[2])sub_bgnd("�.�.",'!',-1);
     		else int2lcd_mm(temper[2],'!',0);
     		}
     	else 
     		{
     		sub_bgnd("3  #@0!",'#',0);
     		if(wrk_state[2])
     			{
         			int2lcd(wrk_time_cnt[2]%60,'!',0);
				int2lcd(wrk_time_cnt[2]/60,'#',0); 
				
				if((ee_time_mode[2]==0)||(wrk_time_cnt_flag[2]==1))
					{
					if(bFL2)lcd_buffer[find('@')]=':';
					else lcd_buffer[find('@')]=' ';
					} 
				else lcd_buffer[find('@')]=':';
     			}
			else sub_bgnd("����.",'!',-4);     			
     		}	
     	lcd_buffer[find('g')]=2;
     	
     	if(out_st[2])lcd_buffer[17]=3;     	
 
     	if((ind_cnt>=5)&&(ind_cnt<=25))
     		{
     		sub_bgnd("4   !gC",'$',0);
     		if(nd[3])sub_bgnd("�.�.",'!',-1);
     		else int2lcd_mm(temper[3],'!',0);
     		}
     	else 
     		{
     		sub_bgnd("4  #@0!",'$',0);
     		if(wrk_state[3])
     			{
         			int2lcd(wrk_time_cnt[3]%60,'!',0);
				int2lcd(wrk_time_cnt[3]/60,'#',0); 
				
				if((ee_time_mode[3]==0)||(wrk_time_cnt_flag[3]==1))
					{
					if(bFL2)lcd_buffer[find('@')]=':';
					else lcd_buffer[find('@')]=' ';
					} 
				else lcd_buffer[find('@')]=':';
     			}
			else sub_bgnd("����.",'!',-4);     			
     		}	
     	lcd_buffer[find('g')]=2;
     	
     	if(out_st[3])lcd_buffer[25]=3;     	     	
		}
	else if(ind_mode==im_2)
		{
		bgnd_par(	"1       2       ",
 				"3       4       "); 
          }	     
	} 
	
else if(ind==iDeb)
	{
	bgnd_par(	"       !       @",
 			"       #       $");
	int2lcdxy(adc_bank_[0],0x30,0);	
	int2lcdxy(adc_bank_[1],0xb0,0);
	int2lcdxy(adc_bank_[2],0x31,0);
	int2lcdxy(adc_bank_[3],0xb1,0); 
	
	int2lcd_mm(temper[0],'!',0);	
	int2lcd_mm(temper[1],'@',0);
	int2lcd_mm(temper[2],'#',0);
	int2lcd_mm(temper[3],'$',0);	
	} 

else if(ind==iMn_)
	{
	ptrs[0]=" �����1    !    ";
	ptrs[1]=" �����2    @    ";
	ptrs[2]=" �����3    #    ";
	ptrs[3]=" �����4    $    ";
	ptrs[4]=" �����          ";
	
	if(index_set>sub_ind)index_set=sub_ind;
	else if(index_set<(sub_ind-1)) index_set=sub_ind-1;
	
	bgnd_par(ptrs[index_set],ptrs[index_set+1]);
	
	if(index_set==sub_ind) lcd_buffer[0]=1;
	else if(index_set==(sub_ind-1)) lcd_buffer[16]=1;

	if(wrk_state[0]==wsON)sub_bgnd("���.",'!',0);
	else sub_bgnd("����.",'!',0);  
	
	if(wrk_state[1]==wsON)sub_bgnd("���.",'@',0);
	else sub_bgnd("����.",'@',0);
	
	if(wrk_state[2]==wsON)sub_bgnd("���.",'#',0);
	else sub_bgnd("����.",'#',0);
	
	if(wrk_state[3]==wsON)sub_bgnd("���.",'$',0);
	else sub_bgnd("����.",'$',0);			
	}	
	
else if(ind==iCh)
	{
	ptrs[0]=" ��!   o   @    ";
	ptrs[1]="     #gC   $%0^ ";
	ptrs[2]=" T���.       >gC";
	ptrs[3]=" �����:    (�0)�"; 
	ptrs[4]=" ����� ������� <";
	if(wrk_state[sub_ind1]==wsON)ptrs[5]=" ����           "; 
	else ptrs[5]=" �����          ";	
	ptrs[6]=" �����          ";
	ptrs[7]=" ����������     "; 
	if(index_set>sub_ind)index_set=sub_ind;
	else if(index_set<(sub_ind-1))index_set=sub_ind-1;

	bgnd_par(ptrs[index_set],ptrs[index_set+1]);
	int2lcd(sub_ind1+1,'!',0);
	int2lcd(t_ust[sub_ind1],'>',0);
	if(wrk_state[sub_ind1]==wsON)
		{
		sub_bgnd("���.",'@',0);
		int2lcd(wrk_time_cnt[sub_ind1]%60,'^',0);
		int2lcd(wrk_time_cnt[sub_ind1]/60,'$',0);
		if((ee_time_mode[sub_ind1]==0)||(wrk_time_cnt_flag[sub_ind1]==1))
			{
			if(bFL2)lcd_buffer[find('%')]=':';
			else lcd_buffer[find('%')]=' ';
			} 
		else lcd_buffer[find('%')]=':';
		}
	else 
		{
		sub_bgnd("����.",'@',0);
		sub_bgnd("    ",'^',-3);
		}
	if(index_set)
		{
		if((sub_ind-index_set)==1)lcd_buffer[16]=1; 
		else if(sub_ind==index_set)lcd_buffer[0]=1;
		} 
	int2lcd(ee_wrk_time[sub_ind1]/60,'(',0);
	int2lcd(ee_wrk_time[sub_ind1]%60,')',0);
	if(ee_time_mode[sub_ind1]==0)int2lcd(1,'<',0);
	else int2lcd(2,'<',0); 
	if(nd[sub_ind1])sub_bgnd("�.�. ",'#',-2);
	else 
		{
		int2lcd(temper[sub_ind1],'#',0);
		lcd_buffer[find('g')]=2;
		}
	lcd_buffer[find('g')]=2;	
	
	if(out_st[sub_ind1])lcd_buffer[find('o')]=3;	
	else lcd_buffer[find('o')]=' ';
 /*	int2lcdxy(adc_bank_[const_of_adc[sub_ind1]],0xf0,0);
	int2lcdxy(nd[0],0x70,0);
	int2lcdxy(nd[1],0x80,0);
	int2lcdxy(nd[2],0x90,0);
	int2lcdxy(nd[3],0xa0,0);*/
	}
	
else if(ind==iK)
	{
	ptrs[0]=" T!      @gC    ";
	ptrs[1]=" �����          ";
	bgnd_par("   ����������   ",ptrs[sub_ind]);
	int2lcd(sub_ind1+1,'!',0); 
	if(nd[sub_ind1])sub_bgnd("�.�. ",'@',-2);
	else 
		{
		int2lcd(temper[sub_ind1],'@',0);
		lcd_buffer[find('g')]=2; 
		}	
			

	if(sub_ind)lcd_buffer[16]=1;
	
    /*	int2lcdxy(adc_bank_[const_of_adc[sub_ind1]],0x50,0);
	int2lcdxy(K_t[sub_ind1],0xc0,0); */
	}
		


if(cnt_ind_nd) 	
	{
	bgnd_par(		"     ������     ",
 				"   ����������   ");
 	}		
			 	
/*bgnd(mess_Zero);
int2lcdxy(adc_bank_[0],0x30,0);
int2lcdxy(adc_bank_[1],0x70,0);
int2lcdxy(adc_bank_[2],0xb0,0);
int2lcdxy(adc_bank_[3],0xf0,0); 
int2lcdxy(adc_bank_[4],0x31,0);
int2lcdxy(adc_bank_[5],0x71,0);*/
//int2lcdxy(adc_bank_[5],0xb0,0);
//int2lcdxy(adc_bank_[6],0xf0,0);		
/*//int2lcdxy(ind,0x30,0);
//int2lcdxy(av_,0x70,0);
//int2lcdxy(but,0xb0,0);
//	int2lcdxy(temper_cnt1,0xe0,0);
//	int2lcdxy(St,0x20,0);
//	int2lcdxy(St1,0x50,0);
//int2lcdxy(ctrl_stat,0x00,0); 
/*int2lcdxy(St1,0xf0,0);
int2lcdxy(St2,0xf1,0);
int2lcdxy(St,0x20,0);*/
/*int2lcdxy(K[ist],0x10,0); 
int2lcdxy(St1,0x21,0);
int2lcdxy(St2,0x51,0); */
/*int2lcdxy(u_necc,0xa0,0);   
int2lcdxy(u_necc,0xa0,0);*/
//int2lcdxy(cntrl_stat,0x20,0);
//int2lcdxy(cnt_blok,0x60,0); 
//int2lcdxy(Ibat_p,0x70,0);
//int2lcdxy(Ibat_mp,0xB0,0);
//int2lcdxy(St,0xf0,0);

//int2lcdxy(kb_cnt,0xa0,0);


/*
int2lcdxy(tzas_cnt,0xa0,0);
int2lcdxy(cntrl_stat,0x20,0);*/

//int2lcdxy(St_[1],0xf1,0);
//int2lcdxy(St_[0],0xf0,0);

//int2lcdxy(OFFBP1,0x10,0);
//int2lcdxy(cnt_av_umin[0],0x30,0);
//int2lcdxy(cnt_ubat,0xf0,0); 
//int2lcdxy(cnt_ibat,0xc0,0); 

//int2lcdxy(av_rele,0x20,0);
//int2lcdxy(av_beep,0x50,0);
//int2lcdxy(hour_apv_cnt,0xa0,0); 

//int2lcdxy(main_apv_cnt,0xf0,0);
//int2lcdxy(hour_apv_cnt,0xd0,0);


//int2lcdxy(sub_ind,0x20,0);

//int2lcdxy(OFFBP2,0xf0,0);
//int2lcdxy(OFFBP1,0xe0,0);
//int2lcdxy(St_[1],0xc0,0);
//int2lcdxy(St_[0],0x90,0);
//int2lcdxy(tzas_cnt,0x60,0);
//int2lcdxy(num_necc,0x30,0);
//int2lcdxy(adc_bank_[0],0x21,0); 

/**/
/*int2lcdxy(reset_apv_cnt,0xf0,0);
int2lcdxy(main_apv_cnt,0x20,0);
int2lcdxy(apv_cnt_1,0x70,0);
int2lcdxy(hour_apv_cnt,0x21,0);*/

/*int2lcdxy(cntrl_stat1,0x30,0);
int2lcdxy(cntrl_stat2,0x31,0);
int2lcdxy(Is[1],0xf1,0);
int2lcdxy(Is[0],0xf0,0); */
ruslcd(lcd_buffer);
}


// ��������� ��������� ������
#define butL 		0b10111111
#define butR 		0b01111111
#define butU 		0b11101111
#define butD 		0b11011111
#define butE   	0b11110111
#define butL_ 		0b10111110
#define butR_ 		0b01111110
#define butU_ 		0b11101110
#define butD_ 		0b11011110
#define butE_   	0b11110110
#define butLR 		0b00111111 
#define butLR_ 	0b00111110
#define butUD 		0b11001111
#define butS 		0b11111101


//-----------------------------------------------
// ������������ ������ �� 7 ������ ������ �����, 
// ��������� �������� � ������� �������,
// ����������� �� ���������� ������, �����������
// ��������� �������� ��� ������� �������...
#define but_port PORTB
#define but_dir  DDRB
#define but_pin  PINB
#define but_mask 0b00000111
#define no_but   0b11111111
#define but_on   5
#define but_onL  20

static char but_n;
static char but_s;
static char but0_cnt;
static char but1_cnt;
static char but_onL_temp;


void but_drv(void)
{ 



but_port|=(but_mask^0xff);
but_dir/*&=but_mask*/=0b00100110;
#asm
nop
nop
nop
nop
#endasm

but_n=but_pin|but_mask; 

but_port|=(but_mask^0xff);
but_dir/*&=but_mask*/=0b11011110;
#asm
nop
nop
nop
nop
#endasm

but_n&=(but_pin|0b11011111); 


//plazma=but_pin;

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
          but=but_s&0b11111110;
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
    			but=but_s&0b11111110;
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

//-----------------------------------------------
void but_an(void)
{
char temp;
int tempU;

if (!n_but) goto but_an_end;
   
if (ind==iMn)
	{
	if(but==butD)
		{
		ind=iMn_;
		sub_ind=0;
		index_set=0;
		}
		
	else if(but==butUD)
		{
		ind=iDeb;
		}		
		
	}   

else if (ind==iMn_)
	{
	if(but==butU)
		{
		sub_ind--;
		gran_char(&sub_ind,0,4);
		}

	else if(but==butD)
		{
		sub_ind++;
		gran_char(&sub_ind,0,4);
		}

	else if(but==butL)
		{
		ind=iMn;
		sub_ind=0;
		}
				
	else if(but==butE_)
		{
		if(sub_ind<4)
			{
			if(wrk_state[sub_ind]==wsOFF)
				{
				if(!nd[sub_ind])start_process(sub_ind);
				else cnt_ind_nd=20;
				}
			else stop_process(sub_ind);
			}
		} 
	else if(but==butE)
		{
		if(sub_ind<4)
			{
			ind=iCh;
			sub_ind1=sub_ind;
			sub_ind=0;
			}         
		else
			{
			ind=iMn;
			sub_ind=0;
			}	
		}		

	}
else if(ind==iDeb)
	{
	if(but==butUD)
		{
		ind=iMn;
		}
	} 

else if(ind==iCh)
	{
	if(but==butU)
		{
		sub_ind--;
		if(sub_ind==1)sub_ind=0;
		gran_char(&sub_ind,0,7);
		}

	else if(but==butD)
		{
		sub_ind++;
		if(sub_ind==1)sub_ind=2;
		gran_char(&sub_ind,0,7);
		}

	else if(sub_ind==2)
		{
		if(but==butR)
			{
			speed=1;
			t_ust[sub_ind1]++;
			gran_ee(&t_ust[sub_ind1],30,140);
			} 
		else if(but==butR_)
			{
			speed=1;
			t_ust[sub_ind1]+=2;
			gran_ee(&t_ust[sub_ind1],30,140);
			}			
		else if(but==butL)
			{
			speed=1;
			t_ust[sub_ind1]--;
			gran_ee(&t_ust[sub_ind1],30,140);
			} 
		else if(but==butL_)
			{
			speed=1;
			t_ust[sub_ind1]-=2;
			gran_ee(&t_ust[sub_ind1],30,140);
			}			
		}
		
	else if(sub_ind==3)
		{
		if(but==butR)
			{
			speed=1;
			ee_wrk_time[sub_ind1]++;
			gran_ee(&ee_wrk_time[sub_ind1],1,720);
			} 
		else if(but==butR_)
			{
			speed=1;
			ee_wrk_time[sub_ind1]=((ee_wrk_time[sub_ind1]/10)+1)*10;
			gran_ee(&ee_wrk_time[sub_ind1],1,720);
			}			
		else if(but==butL)
			{
			speed=1;
			ee_wrk_time[sub_ind1]--;
			gran_ee(&ee_wrk_time[sub_ind1],1,720);
			} 
		else if(but==butL_)
			{
			speed=1;
			ee_wrk_time[sub_ind1]=((ee_wrk_time[sub_ind1]/10)-1)*10;
			gran_ee(&ee_wrk_time[sub_ind1],1,720);
			}			
		}
	else if(sub_ind==4)
		{
		if((but==butR)||(but==butR_))
			{
			ee_time_mode[sub_ind1]=1;
			} 
		else if((but==butL)||(but==butL_))
			{
			ee_time_mode[sub_ind1]=0;
			} 		
		}  
		
	else if(sub_ind==5)
		{
		if(but==butE_)
			{
			if(wrk_state[sub_ind1]==wsON)stop_process(sub_ind1); 
			else 
				{
				if(!nd[sub_ind1])start_process(sub_ind1);
				else cnt_ind_nd=20;
				}
               }
          }
	else if(sub_ind==6)
		{
		if(but==butE)
			{
			ind=iMn_;
			sub_ind=0;
			} 		
		}		
					
	else if(sub_ind==7)
		{
		if(but==butE_)
			{
			ind=iK;
			sub_ind=0;
			} 		
		}												
	}
else if(ind==iK)
	{ 
	if(but==butU)
		{
		sub_ind=0;
		}         
	else if(but==butD)
		{
		sub_ind=1;
		} 
	else if(sub_ind==0)
		{              
		if(but==butR)
			{
			speed=1;
			K_t[sub_ind1]++;
			gran_ee(&K_t[sub_ind1],-1000,1000);
			} 
		else if(but==butR_)
			{
			speed=1;
			K_t[sub_ind1]+=10;
			gran_ee(&K_t[sub_ind1],-1000,1000);
			}
		else if(but==butL)
			{ 
			speed=1;
			K_t[sub_ind1]--;
			gran_ee(&K_t[sub_ind1],-1000,1000);
			}
		else if(but==butL_)
			{
			speed=1;
			K_t[sub_ind1]-=10;
			gran_ee(&K_t[sub_ind1],-1000,1000);
			}									
		}
	else if(sub_ind==1)
		{
		if(but==butE)
			{   
			ind=iCh;
			sub_ind=6;
			}
		}		  			
	}	
		
else if(ind==iSet)
	{
	if(sub_ind==0)
		{
	//	if(but==butR)ee_mode=emAVT;
    //		else if(but==butL)ee_mode=emMNL;
	//	else if(but==butE)
	 //		{
	 //		if(ee_mode==emMNL)ee_mode=emAVT;
	 //		else ee_mode=emMNL;
	 //		}
	 //	else if(but==butD)
	 //		{
	 //		sub_ind=1;
	 //		}
		}
	else if(sub_ind==1)
		{
		if((but==butR)||(but==butR_))
			{
			speed=1;
			if(!nakal_cnt)nakal_cnt=300;
			else if((nakal_cnt>=200)&&(nakal_cnt<300))
				{
				ee_pwm++;
				
				//gran_char_ee(&ee_pwm,5,250);
				}
			}
		else if((but==butL)||(but==butL_))
			{
			speed=1;
			if(!nakal_cnt)nakal_cnt=300;
			else if((nakal_cnt>=200)&&(nakal_cnt<300))
				{
				ee_pwm--;
				//gran_char_ee(&ee_pwm,5,250);
				}
			}
		else if(but==butD)
			{
			sub_ind=2;
			}
		if(ee_pwm>250)ee_pwm=250;
		if(ee_pwm<5)ee_pwm=5;		
		}
			
	else if(sub_ind==2)
		{
		if((but==butR)||(but==butR_))
			{
			speed=1;
			//ee_nagrev_time++;
		//	gran_ee(&ee_nagrev_time,10,1000);
			}
		else if((but==butL)||(but==butL_))
			{
			speed=1;
			//ee_nagrev_time--;
			//gran_ee(&ee_nagrev_time,10,1000);
			}
		else if(but==butD)
			{
			sub_ind=3;
			}
		else if(but==butU)
			{
			sub_ind=1;
			}					
		}		
	else if(sub_ind==3)
		{
		if((but==butR)||(but==butR_))
			{
			speed=1;
			//ee_wrk_time++;
			//gran_ee(&ee_wrk_time,10,1000);
			}
		else if((but==butL)||(but==butL_))
			{
			speed=1;
			//ee_wrk_time--;
			//gran_ee(&ee_wrk_time,10,1000);
			}
		else if(but==butD)
			{
			sub_ind=4;
			}
		else if(but==butU)
			{
			sub_ind=2;
			}					
		}
	else if(sub_ind==4)
		{
		if((but==butR)||(but==butR_))
			{
			speed=1;
			//ee_ostiv_time++;
			//gran_ee(&ee_ostiv_time,10,1000);
			}
		else if((but==butL)||(but==butL_))
			{
			speed=1;
			//ee_ostiv_time--;
			//gran_ee(&ee_ostiv_time,10,1000);
			}
		else if(but==butD)
			{
			sub_ind=5;
			}
		else if(but==butU)
			{
			sub_ind=3;
			}					
		}			  
	else if(sub_ind==5)
		{
		if(but==butE)
			{
			ind=iMn;
			sub_ind=0;
			nakal_cnt=0;
			//wrk_state=wsOFF;			
			}
		else if(but==butD)
			{
			sub_ind=6;
			}
		else if(but==butU)
			{
			sub_ind=4;
			}					
		}
	else if(sub_ind==6)
		{
		if(but==butE)
			{
			ind=iK;
			sub_ind=0;
			nakal_cnt=0;
			}
		else if(but==butU)
			{
			sub_ind=5;
			}	
		}														
	}
	
else if(ind==iK)
	{
	if(sub_ind==0)
		{
		if((but==butR)||(but==butR_))
			{
			speed=1;              
			if(!nakal_cnt)nakal_cnt=300;
			else if((nakal_cnt>=200)&&(nakal_cnt<300))
				{
				Ku++;
				}
			gran_ee(&Ku,100,200);
			}
		else if((but==butL)||(but==butL_))
			{
			speed=1;                    
			if(!nakal_cnt)nakal_cnt=300;
			else if((nakal_cnt>=200)&&(nakal_cnt<300))
				{
				Ku--;
				}
			gran_ee(&Ku,100,200);
			}
		else if(but==butD)
			{
			sub_ind=1;
			}
		}
	else if(sub_ind==1)
		{
		if((but==butR)||(but==butR_))
			{
			speed=1;                    
			if(!nakal_cnt)nakal_cnt=300;
			else if((nakal_cnt>=200)&&(nakal_cnt<300))
				{
				Ki++;
				}
			gran_ee(&Ki,100,200);
			}
		else if((but==butL)||(but==butL_))
			{
			speed=1;                    
			if(!nakal_cnt)nakal_cnt=300;
			else if((nakal_cnt>=200)&&(nakal_cnt<300))
				{
				Ki--;
				}
			gran_ee(&Ki,100,200);
			}
		else if(but==butD)
			{
			sub_ind=2;
			}
		else if(but==butU)
			{
			sub_ind=0;
			}	    
		}		 		                         
	else if(sub_ind==2)
		{
		if(but==butE)
			{
			ind=iMn;
			sub_ind=0;
			nakal_cnt=0;
			//wrk_state=wsOFF;			
			}
		else if(but==butU)
			{
			sub_ind=1;
			}	  					
		}		

	}		  			  				
but_an_end:
n_but=0;           
}	   


//***********************************************
//***********************************************
//***********************************************
//***********************************************
//***********************************************


//***********************************************
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
static char t0cnt0,t0cnt1,t0cnt2,t0cnt3,t0cnt4,/*t0cnt5,*/t0cnt6;
char temp;

TCNT0=-208; 

#ifdef MIKRAN
bFF=PINB.0;
if(bFF!=bFF_)
	{
	Hz_out++;
	}        
bFF_=bFF;    
#endif

if(++t0cnt0_>=6)
	{
	t0cnt0_=0;
	}
else goto timer1_ovf_isr_end;



b100Hz=1;

Hz_cnt++;
if(Hz_cnt>=978)
	{	
	Hz_cnt=0;
	Fnet=Hz_out/2;
	Hz_out=0;
	}


#ifdef _CAN_
CANst=spi_read_status();
if(CANst)
	{
	bCAN=1;
	}  
#endif

if(++t0cnt0>=10)
	{
	t0cnt0=0;
	b10Hz=1;
	if(++def_char_cnt>=10)def_char_cnt=0;
	}

if(++t0cnt1>=20)
	{
	t0cnt1=0;
	b5Hz=1;
	
	}

if(++t0cnt2>=50)
	{
	t0cnt2=0;
	b2Hz=1;
	bFL2=!bFL2;
	}         

if(++t0cnt3>=100)
	{
	t0cnt3=0;
	b1Hz=1;
	}
timer1_ovf_isr_end:
}

//===============================================
//===============================================
//===============================================
//===============================================
void main(void)
{
char temp_char;
int temp_int;

PORTA=0x00;
DDRA=0x00;

PORTB=0x10;
DDRB=0x00;

PORTC=0x00;
DDRC=0x00;

PORTD=0x00;
DDRD=0x30;




GICR=0x00;
MCUCR=0x00;
MCUCSR=0x00;
GIFR=0x00;



// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 125,000 kHz
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x03;
TCNT0=-208;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 8000,000 kHz
// Mode: Fast PWM top=03FFh
// OC1A output: Non-Inv.
// OC1B output: Non-Inv.
// Noise Canceler: Off
// Input Capture on Falling Edge
TCCR1A=0x21;
TCCR1B=0x09;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1B=700;

TIMSK=0x01;

UCSRA=0x00;
UCSRB=0x00;

matemat();

ADMUX=0x00;
ADCSR=0x86;
lcd_init(16);
simbol_define();

#asm("sei")



ind=iMn;
sub_ind=1;
sub_ind1=0;

ind_mode=im_1;

restart_process(0);
restart_process(1);
restart_process(2);
restart_process(3);


while (1)
	{
	#asm("wdr")
 	
	if(b100Hz)
		{
		b100Hz=0; 
		
		adc_drv();
          but_drv();
          but_an();
  		
		}	 
	if(b10Hz)
		{
		b10Hz=0;
          simbol_define();
          ind_hndl();
		lcd_out(); 
		//wrk_state_drv();
		
		}	
	if(b5Hz)
		{
		b5Hz=0;
		
		ret_ind_hndl();
		matemat();
		//out_out();
  
  		}
	if(b2Hz)
		{
		b2Hz=0;
  		wrk_process(0);
  		wrk_process(1);
  		wrk_process(2);
  		wrk_process(3);
  		out_drv();
		}								
	if(b1Hz)
		{
		b1Hz=0;
		
			
		}
			
     }
}
