//#define MOSKOW_CAN
//#define MOSKOW_RS232
//#define MOSKOW
//#define MIKRAN_CAN
//#define MIKRAN
//#define PAROL_ALL_ZERO
// CodeVisionAVR C Compiler
// (C) 1998-2004 Pavel Haiduc, HP InfoTech S.R.L.
// I/O registers definitions for the ATmega32
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      // 16 bit access
sfrb ADCSRA=6;
sfrb ADCSR=6;     // for compatibility with older code
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   // 16 bit access
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  // 16 bit access
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  // 16 bit access
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  // 16 bit access
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb OCR0=0X3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-
// Interrupt vectors definitions
// CodeVisionAVR C Compiler
// (C) 1998-2000 Pavel Haiduc, HP InfoTech S.R.L.
#pragma used+
void delay_us(unsigned int n);
void delay_ms(unsigned int n);
#pragma used-
// CodeVisionAVR C Compiler
// (C) 1998-2006 Pavel Haiduc, HP InfoTech S.R.L.
// Prototypes for standard I/O functions
// CodeVisionAVR C Compiler
// (C) 1998-2002 Pavel Haiduc, HP InfoTech S.R.L.
// Variable length argument list macros
typedef char *va_list;
#pragma used+
char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);
char *gets(char *str,unsigned int len);
void printf(char flash *fmtstr,...);
void sprintf(char *str, char flash *fmtstr,...);
void snprintf(char *str, unsigned int size, char flash *fmtstr,...);
void vprintf (char flash * fmtstr, va_list argptr);
void vsprintf (char *str, char flash * fmtstr, va_list argptr);
void vsnprintf (char *str, unsigned int size, char flash * fmtstr, va_list argptr);
signed char scanf(char flash *fmtstr,...);
signed char sscanf(char *str, char flash *fmtstr,...);
                                               #pragma used-
#pragma library stdio.lib
/* Головной файл для использования LCD
по схеме 4данные+2управление с возможностью 
подключения данных и управления через различные
порты МК (данные должны быть обязательно подключены к
четырём старшим выводам порта).Перед использованием
 данного файла необходимо объявить следующие величины:

#asm
	.equ __lcd_port=0x15		;порт данных
	.equ __lcd_cntr_port=0x12    	;порт упр.сигналов
 	.equ __lcd_rs=5                 ;вывод порта упр.сигналов работающий как RS
	.equ __lcd_en=7			;вывод порта упр.сигналов работающий как EN
#endasm

*/
#pragma used+
void _lcd_ready(void);
void _lcd_write_data(unsigned char data);
// write a byte to the LCD character generator or display RAM
void lcd_write_byte(unsigned char addr, unsigned char data);
// read a byte from the LCD character generator or display RAM
unsigned char lcd_read_byte(unsigned char addr);
// set the LCD display position  x=0..39 y=0..3
void lcd_gotoxy(unsigned char x, unsigned char y);
// clear the LCD
void lcd_clear(void);
void lcd_putchar(char c);
// write the string str located in SRAM to the LCD
void lcd_puts(char *str);
// write the string str located in FLASH to the LCD
void lcd_putsf(char flash *str);
// initialize the LCD controller
void lcd_init(unsigned char lcd_columns);
#pragma used-
#pragma library lcd_4+2.lib
/*
  CodeVisionAVR C Compiler
  (C) 1998-2004 Pavel Haiduc, HP InfoTech S.R.L.

  Prototype for SPI access function */
  #pragma used+
unsigned char spi(unsigned char data);
#pragma used-
#pragma library spi.lib
/*
CodeVisionAVR C Compiler
Prototypes for mathematical functions

Portions (C) 1998-2001 Pavel Haiduc, HP InfoTech S.R.L.
Portions (C) 2000-2001 Yuri G. Salov
*/
#pragma used+
unsigned char cabs(signed char x);
unsigned int abs(int x);
unsigned long labs(long x);
float fabs(float x);
signed char cmax(signed char a,signed char b);
int max(int a,int b);
long lmax(long a,long b);
float fmax(float a,float b);
signed char cmin(signed char a,signed char b);
int min(int a,int b);
long lmin(long a,long b);
float fmin(float a,float b);
signed char csign(signed char x);
signed char sign(int x);
signed char lsign(long x);
signed char fsign(float x);
unsigned char isqrt(unsigned int x);
unsigned int lsqrt(unsigned long x);
float sqrt(float x);
float floor(float x);
float ceil(float x);
float fmod(float x,float y);
float modf(float x,float *ipart);
float ldexp(float x,int expon);
float frexp(float x,int *expon);
float exp(float x);
float log(float x);
float log10(float x);
float pow(float x,float y);
float sin(float x);
float cos(float x);
float tan(float x);
float sinh(float x);
float cosh(float x);
float tanh(float x);
float asin(float x);
float acos(float x);
float atan(float x);
float atan2(float y,float x);
#pragma used-
#pragma library math.lib
//-----------------------------------------------
void gran_ring_char(signed char *adr, signed char min, signed char max)
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
                      //***********************************************
//Указатели
char 		*ptr_ram;
int 			*ptr_ram_int;
char flash 	*ptr_flash;
int eeprom	*ptr_eeprom_int;
unsigned int 	*adc_out;
bit b100Hz,b10Hz,b5Hz,b2Hz,b1Hz;
bit l_but;		//идет длинное нажатие на кнопку
bit n_but;          //произошло нажатие
bit speed;		//разрешение ускорения перебора
bit zero_on;
bit bit_minus;
bit bAB;
bit bAN;
bit bAS1;
bit bAS2;
bit bFL_;
bit bFL__;
bit bI;
enum char {iMn,iSrv_sl,iNet,iSet,iBat,iSrc,iS2,iSetprl,iKprl,iDnd,iK,
	iSpcprl,iSpc,Grdy,Prdy,Iwrk,Gwrk,Pwrk,k,Crash_0,Crash_1,iKednd,
	iLoad,iSpc_prl_vz,iSpc_prl_ke,iKe,iVz,iAVAR,iStr,iVrs,iTstprl,iTst,iDebug,iDefault,iSet_st_prl}ind;
flash char sm_[]	={"                "}; 
flash char sm0_0[]	={" Раб. от ист N] "};
flash char sm0_1[]	={" Раб. от N1 и N2"}; 
flash char sm0_2[]	={" Раб. от батареи"};
flash char sm0_3[]	={" Ав.N[   Раб.N] "};
flash char sm1_0[]	={"U=  .<V Iб=  .>A"};
flash char sm1_1[]	={"U=  .<V Iн=  .>A"};
flash char sm1_2[]	={" БАТАРЕЯ        "}; 
flash char sm1_3[]	={" ИСТОЧНИК N1    "}; 
flash char sm1_4[]	={" ИСТОЧНИК N2    "}; 
flash char sm1_5[]	={" СЕТ#           "}; 
flash char sm1_6[]	={" НАГРУЗКА       "};
flash char sm1_7[]	={" СПЕЦ.ФУНКЦИИ   "};
flash char sm1_8[]	={" УСТАНОВКИ      "};
flash char sm1_9[]	={" СБРОС АВАРИ@   "};
flash char sm6_1[]	={"   УСТАНОВКИ    "};
flash char sm6_[]	={" СТРУКТУРА      "};
flash char sm6_2[]	={"   СТРУКТУРА    "};
flash char sm7_0[]	={" Осн.ист.    N+ "};  
flash char sm7[]	={" Umax=      .zВ "}; 
flash char sm7_[]	={" Uб0 =      .[В "};
flash char sm7__[]	={" Uб20=      .]В "};
flash char sm8[]	={" tmax=      ZgC "}; 
flash char sm9[]	={"   t=  q C      "};
flash char sm9_[]	={" ДТ. неисправен "}; 
flash char sm10_0[]	={"    БАТАРЕЯ     "}; 
flash char sm10[]	={" Cбат=     Qа*ч "}; 
flash char sm11[]	={" Uсигн=      wВ "}; 
flash char sm11_1[]	={" Umin.сети=  /В "}; 
flash char sm11_2[]	={" Зв.сигн.   >   "}; 
flash char sm11_3[]	={" U0б =      .|В "}; //
flash char sm12[]	={" Uбат=      .zВ "}; 
flash char sm13[]	={" Iзар=     . ZA "};
flash char sm14[]	={" Iразр=    . ZA "}; 
flash char sm15[]	={" tбат=      jgC "}; 
flash char sm16[]	={" Заряд       w% "}; 
flash char sm17[]	={"  Сост.=  qа*ч  "}; 
flash char sm18[]	={"  Введите       "}; 
flash char sm19[]	={"   пароль       "}; 
flash char sm20[]	={" Калибровки     "};
flash char sm20_1[]	={"   КАЛИБРОВКИ   "};
flash char sm21[]	={" Uбат=      .zВ "};
flash char sm22[]	={" Iбат=     . ZА "};
flash char sm23[]	={" Uист1=     .]В "};
flash char sm24[]	={" Iист1=     .XА "};
flash char sm24_[]	={" tист1=     (gC "};
flash char sm25[]	={" Uист2=     .[В "};
flash char sm26[]	={" Iист2=     .QА "};
flash char sm26_[]	={" tист2=     )gC "};
flash char sm27[]	={" Uсеть=      wВ "};
flash char sm27_[]	={" tист=  	> C "}; 
flash char sm28[]	={" Выход          "};
flash char sm29_0[]	={"  СПЕЦ.ФУНКЦИИ  "};
flash char sm29[]	={" Проверка Cбат  "};
flash char sm30[]	={" Выравн. заряд  "};
//flash char sm31[]	={"  U12в=   .WВ   "};
//flash char sm32[]	={"  U12в=   .WВ   "}; 
flash char sm33[]	={" СПЕЦ.ФУНКЦИИ   "};
flash char sm34_0[]	={"    НАГРУЗКА    "};
flash char sm34[]	={" Uнагр.=   .(В  "};
flash char sm35[]	={" Iнагр.=   .)А  "};
flash char sm36[]	={" Выход          "};
flash char sm37[]	={" Время       )ч "};
flash char sm38[]	={" Выключен       "};
flash char sm39[]	={" Включен        "};
flash char sm40[]	={" ВЫРАВНИВ.ЗАРЯД "};
flash char sm41[]	={" длит.-cть    (ч"};
flash char sm42[]	={"КОНТРОЛ# ЕМКОСТИ"};
flash char sm43[]	={"    БАТАРЕИ     "};
flash char sm45[]	={" Iбк.     =0.0<А"};
flash char sm46[]	={" Kвыр.зар.= .  !"}; 
flash char sm47[]	={" Imax     =  .@A"};
flash char sm48[]	={" Kimax    =  .# "};
flash char sm50[]	={"Ист. N[ в работе"};
flash char sm51[]	={"Ист. N[ в резерв"}; 
//flash char sm51_[]	={"Ист. N1 перегрет"};
//flash char sm52[]	={"Ист. N2 в работе"};
//flash char sm53[]	={"Ист. N2 в резерв"};
//flash char sm53_[]	={"Ист. N2 перегрет"};
flash char sm54[]	={"  Uист=  .:В    "};
flash char sm55[]	={"  Iист=  .]А    "};
flash char sm56[]	={"  tист=  jgC    "}; 
flash char sm57[]	={"Авария ист. N[  "};
flash char sm58[]	={" <ВЫХОД         "};
//flash char sm59[]	={"  U12в=   .WВ   "};
flash char sm60[]	={"  Авария сети   "};
flash char sm62[]	={" Контроль Cбат  "};
flash char sm63[]	={" Выравн. заряд  "};
flash char sm66[]	={" АПВав.ист. {   "};
//flash char sm67[]	={"Ист. N2 вык. CAN"};
flash char sm68[]	={" Iз.мах.     .}А"};
flash char sm69[]	={" K.з.        .L "};
flash char sm71[]	={" Завышено Uвых. "};
flash char sm72[]	={" Занижено Uвых. "};
flash char sm73[]	={"   Перегрев     "};
flash char sm90[]	={" Батарей     [  "};
flash char sm91[]	={" Источников  ]  "};
flash char sm93[]	={" Версия ПО      "};
flash char sm99[]	={" Тест           "};
flash char sm100[]	={" ТЕСТ           "};
flash char sm101[]	={" Реле ав.   (   "};
//flash char sm102[]	={" Реле ав.бат)   "};
flash char sm103[]	={" Реле смклб.)   "};
flash char sm104[]	={" БПС1      }    "};
flash char sm105[]	={" БПС2      [    "};
flash char sm106[]	={" БПС1+БПС2 ]    "};
flash char sm107[]	={" Iбат=     , :A "};
flash char sm108[]	={" Тест           "};
flash char sm110[]	={" Tз.вкл.а.с. qс."};
flash char sm111_0[]={"      СЕТ#      "};
flash char sm111[]	={" АВАРИЯ СЕТИ!!! "};
flash char sm112[]	={" Uсети=      [V "};
flash char sm113[]	={" Fсети=     ]Гц "};
flash char sm130[]	={"     Пароль     "};
flash char sm131[]	={"   неверный!!!  "};
flash char sm150[]	={"АВАРИЯ!! Батарея"};
flash char sm151[]	={" не подключена  "};
flash char sm157[]	={"Авария ист. N1  "};
flash char sm158[]	={"Авария ист. N2  "}; 
flash char sm170[]	={" КЕ  невозможен "}; 
flash char sm171[]	={"  нет  батареи  "}; 
flash char sm172[]	={"  авария  сети  "}; 
flash char sm173[]	={"батарея разр.-ся"}; 
flash char sm174[]	={"батарея заряж-ся"}; 
flash char sm180[]	={"   Источник N2  "}; 
flash char sm181[]	={"  не подключен  "}; 
flash char sm200[]	={"Неопределeнность"};
flash char sm201[]	={" Стандартные    "};
flash char sm202[]	={"СТАНДАРТНЫЕ УСТ."};
flash char smD1[]	={"     A         B"};
flash char smD2[]	={"     C          "};
flash char smon[]	={"ВКЛ."}; 
flash char smoff[]	={"ВЫК."};
flash char smumax[]	={"Umax"}; 
flash char smumin[]	={"Umin"};
flash char smu20[]	={"U20 "}; 
flash char smVRS[]	={"МКv11RS  !.0@.0#"};
flash char* flash p_iset[]={sm6_1,sm201,sm7_0,sm7,sm7_,sm7__,sm8,sm10,sm11,sm11_1,
						sm11_2,sm45,sm46,sm47,sm48,sm66,sm68,sm11_3,sm110,sm6_,
						sm36,sm20,sm93,sm99};
//flash char* flash p_imn[]={sm1_2,sm1_3,sm1_4,sm1_5,sm1_6,sm1_7,sm1_8};
flash char* flash p_istr[]={sm6_2,sm90,sm91,sm36};
flash char* flash p_ik[]={sm20_1,sm21,sm22,sm15,sm23,sm24,sm24_,sm25,sm26,sm26_,sm27,sm28};
flash char* flash p_ik_[]={sm20_1,sm21,sm22,sm9_,sm23,sm24,sm24_,sm25,sm26,sm26_,sm27,sm28};
flash char* flash p_itst[]={sm100,sm101/*,sm102*/,sm103,sm104,sm105,sm106,sm36};
flash char* flash p_itst_[]={sm100,sm101/*,sm102*/,sm107,sm104,sm105,sm106,sm36};
flash char* flash p_ispc_[]={sm29_0,sm29,sm30,sm28};
flash char* flash p_iavar[]={sm111,sm112,sm150,sm151,sm157,sm71,sm157,sm72,sm157,sm73,sm158,sm71,sm158,sm72,sm158,sm73};
int main_cnt;
int VZ_cnt_s;             
signed char cnt_imax;
char but;
unsigned char parol[3];
char dig[5];
signed int Ubat,Ibat,Us[2],Is[2],Uload,Iload,Unet;
signed int t_i[2],t_b;
char adc_cnt,adc_cnt1;
unsigned int adc_bank[10,4],adc_bank_[10];
enum {tstOFF,tstON,tstU} tst_state[10];
char SIMAXISRC;
char offbp_cnt;
char ND[3];
char cnt_av_umax[2],cnt_av_umin[2],cnt_av_t[2];
unsigned int hour_cnt_5hz,hour_cnt_1hz;
signed cntrl_stat=600,old_cntrl_stat,cntrl_stat1,cntrl_stat2;
char cnt_blok;
signed char sub_ind,sub_ind1,index_set;
enum {iiB,iiM} Ibs=iiM,Ibso=iiM;
int u_necc,u_necc_; 
char unet_drv_cnt;
char kb_cnt[2];
eeprom char Std1,Std2;//St1,St2;
char St_[2];	
//2-U>
//3-U<
//4-temper
//5-блокир
eeprom char Std;//St; 
char St;
//0-Uсети;
//1-отсутствует батарея
//2-ток превышает Imax 
//6-перегрет весь источник 
eeprom char vz_cnt_h,vz_cnt,KEB;
eeprom signed MAIN_IST,BATNUM_,C_BAT,UMAX,UB0,UB20,TMAX,CBAT,USIGN,UMN,IKB,ZS,KVZ,IMAX,KIMAX,
			APV,IZMAX,U0B,TZAS,NUMBAT,NUMIST,VZ_HR,DUMM[19]; 
	//flash char index_bank[]={0,8,9,7,1,3,5,2,4,6,0,dumm,dumm};
flash char index_k0[]={0,0,1,0,0,5,0,0,7,0,0};                                                 
flash char index_k1[]={0,9,2 		,13  ,3,6,11    ,4,8,12 ,10 ,0,0}; 
eeprom signed K_[20];
eeprom enum {spc_OFF=0,spc_KEp1=33,spc_KEp2=2,spc_VZ=5}spc_stat; 
char zar_percent;
char tzas_cnt;
char num_necc;
char cnt_src[2];
char cnt_ibat,cnt_ubat;
unsigned Fnet;
bit bFF,bFF_;
int Hz_out,Hz_cnt;
char t0cnt0_;
unsigned long cnt_vz_sec,cnt_vz_sec_; 
signed zar_cnt;
char cnt_ind;
eeprom signed zar_cnt_ee,zar_cnt_ee_ke;
char sound_pic,sound_tic,sound_cnt;
unsigned int av_beep,av_rele,av_stat;
//0 - сеть
//1 - батарея
//2 - ист1 больше
//3 - ист1 меньше
//4 - ист1 температура 
//5 - ист2 больше
//6 - ист3 меньше
//7 - ист4 температура 
unsigned skb_cnt;
char dumm1[40];
char lcd_buffer[40]={""};
char dumm2[40];
char cnt_alias_blok;
char star_cnt;
char default_temp;
flash unsigned int MASK_AV_IST_UMAX[2]={0x0004U,0x0020U};
flash unsigned int MASK_AV_IST_UMAX[2]={0x0004U,0x0020U};
flash unsigned int MASK_AV_IST_UMAX[2]={0x0004U,0x0020U};
flash unsigned int MASK_AV_IST_UMIN[2]={8,64};
flash unsigned int MASK_AV_IST_TEMPER[2]={0x0010U,0x0080U};
char cnt_irazr;
bit bIrazr;  
char cnt_beep; 
bit bUrazr;
bit bUOFF,bIOFF;
unsigned main_apv_cnt,hour_apv_cnt,reset_apv_cnt;
char bmm_cnt,bmp_cnt;
bit bS=1;
char apv_cnt_1; 
char cnt_num_necc; 
char plazma;
int i_avg_max,i_avg_min; 
int avg;
bit bAVG;
char avg_cnt;  
char avg_num; 
signed int x_; 
char avg_cnt_3;   
#pragma+ ruslcd+
#pragma+ ruslcd-   
char can_init_cnt;
 		//-----------------------------------------------
void adc_drv(void)
{
char i;
char temp;
unsigned int tempUI,tempUI_;
if(adc_cnt<=7)tempUI=ADCW;
else if(adc_cnt==8) tlv2542_read(&tempUI,&tempUI_);
else if(adc_cnt==9) tlv2542_read(&tempUI_,&tempUI);
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
        if((++adc_cnt)>=10)
	{
	adc_cnt=0;
	if((++adc_cnt1)>=16)
		{
  		adc_cnt1=0;
  		}   
	}         
DDRA=0b00000000;
PORTA&=0b00000000;
if(adc_cnt<=4)
	{
	ADMUX=0b11000000|adc_cnt;
	SFIOR&=0b00011111;
	ADCSRA=0b10100110;
	ADCSRA|=0b01000000;  
     } 
else if(adc_cnt<=7)
	{
	ADMUX=0b01000000|adc_cnt;
	SFIOR&=0b00011111;
	ADCSRA=0b10100110;
	ADCSRA|=0b01000000;  
 	}
else ADMUX=0b11000000;        
}
//-----------------------------------------------
void avar_src_reset(char in)
{
cnt_av_umax[in]=0;
cnt_av_umin[in]=0;
cnt_av_t[in]=0;
St_[in]&=0b11100011;
cnt_src[0]=10;
cnt_src[1]=10;
} 
//-----------------------------------------------
void blok_src_reset(char in)
{
St_[in]&=0b11011111;
cnt_src[0]=10;
cnt_src[1]=10;
}   
//-----------------------------------------------
void avar_unet_hndl(char in)
{    
if(in) 
	{
	St|=0x01;
	av_stat|=0x0001;
	av_rele|=0x0001;
	av_beep|=0x0001;		
	tzas_cnt=5*TZAS;
			                                   	     	     			}
else if(in==0)
	{
	St&=0xfe;
	av_stat&=0xfffe;
	av_rele&=0xfffe;
	av_beep&=0xfffe; 
	avar_src_reset(0);
	blok_src_reset(0);
	avar_src_reset(1);
	blok_src_reset(1);	
			                                 	     	     		}
}
//-----------------------------------------------
void avg_hndl(void)
{ 
if(++avg_cnt_3<AVGCNTMAX)goto avg_hndl_end;
avg_cnt_3=0;
if(avg_main_cnt)
	{
	avg_main_cnt--;
	goto avg_hndl_end;
	}                 
if(!(((!(St_[0]&0b00111100))&&(!BP1ISOFF))&&((!(St_[1]&0b00111100))&&(!BP2ISOFF)))) goto avg_hndl_end;
/*	
i_avg_min=Is[0];
i_avg_max=Is[0];

if(Is[1]>Is[0])
	{
	i_avg_max=Is[1];
	}               
else		   
	{
	i_avg_min=Is[1];
	}       

if(i_avg_min==0)i_avg_min=1;

avg=i_avg_max;
avg*=100;
avg/=i_avg_min;


if(avg>150) bAVG=1;
if(avg<130) bAVG=0;*/
avg=Is[1];
avg*=100;
avg/=Is[0];
if(bAVG==1)
	{
	if(Is[1]<Is[0]) x_++;
	else if(Is[1]>Is[0]) x_--;
		}
gran(&x_,-50,50);
avg_hndl_end:
#asm("nop")
}
//-----------------------------------------------
void avar_bat_hndl(char in)
{    
if(in)
	{
	St|=0x02;
	av_stat|=0x0002;
	av_rele|=0x0002;
	av_beep|=0x0002; 
	}
else if(in==0)
	{
	St&=0xfd;
	av_stat&=0xfffd;
	av_rele&=0xfffd;
	av_beep&=0xfffd;	
	}
}
//-----------------------------------------------
void kb_start(char in) 
{
if(((St&0x02)||(abs(Ibat)<IKB))&&(spc_stat!=spc_KEp1)&&(spc_stat!=spc_KEp2)&&(!(St&0x01))&&(NUMBAT>0)&&(!St_[1]||!St_[2]))
	{
	kb_cnt[in]=30;
	}
}
//-----------------------------------------------
void cntrl_blok_hndl(void)
{
if(bmm_cnt)bmm_cnt--;
if(bmp_cnt)bmp_cnt--;
if(cnt_blok)cnt_blok--;
if(bS!=bit_minus)
	{
	if(bit_minus) 
		{
		bmm_cnt=10;
		if(bmp_cnt)cnt_blok=60;
		}
	else if(!bit_minus)
		{
		bmp_cnt=10;
		if(bmm_cnt)cnt_blok=60;
		}
	}
bS=bit_minus;
} 
//-----------------------------------------------
void bat_drv(void)
{
if(Ubat<200)
	{ 
	if(cnt_ubat<25)
		{
		cnt_ubat++;
		if(cnt_ubat>=25)
			{
			if(main_cnt<20)avar_bat_hndl(1);
			}
		}
	else if(cnt_ubat>25) cnt_ubat=0;	
	}
else if(Ubat>200)
	{ 
	if(cnt_ubat)
		{
		cnt_ubat;
		if(cnt_ubat==0)
			{
			avar_bat_hndl(1);
			}
		}
	else if(cnt_ubat>25) cnt_ubat=0;	
	}
if(abs(Ibat)>IKB)
	{ 
	if(cnt_ibat<15 )
		{
		cnt_ibat++;
		if(cnt_ibat>=15 )
			{
			avar_bat_hndl(0);
			}
		}
	else if(cnt_ibat<15 )cnt_ibat=0;	
	}
else cnt_ibat=0;	  	  
if((Ubat<=(USIGN*10))&&(NUMBAT))
	{
     bUrazr=1;
     }
else 
	{
	bUrazr=0;
	bUOFF=0;
	}     
if((bit_minus)&&(Ibat>(IKB*10)))
	{         
	if(cnt_irazr<50)
		{
		cnt_irazr++;
			}       			
	}
else 
	{
	if(cnt_irazr>5) cnt_irazr-=5;
	}	
if(cnt_irazr>48) bIrazr=1;        
else if(cnt_irazr<=5)
	{
	bIrazr=0;
	bIOFF=0;
	}   
}
//-----------------------------------------------
void samokalibr_drv(void)
{  
skb_cnt++;
if(skb_cnt>18000) skb_cnt=0;
if((skb_cnt>=50)&&(skb_cnt<=75)) 
	{
	kz_on();
	bI=1;
	}
else 
	{
	if((ind==iTst)&&(sub_ind==2))
		{
		if(tst_state[1]==tstOFF)kz_off();
		else if(tst_state[1]==tstON)kz_on();
		}
	else if(ind!=iK)
		{
		kz_off();
		bI=0;
		}
	}
if(skb_cnt==75) K_[1]=adc_bank_[8];
}
//-----------------------------------------------
void kb_drv(void)
{
static int ibat,ibat_;
char temp;
if(kb_cnt[0]) kb_cnt[0]--;
if(kb_cnt[1]) kb_cnt[1]--;
if((kb_cnt[0]==15)||(kb_cnt[1]==15))
	{
	ibat=abs(Ibat);
	}
if(kb_cnt[0]==1)
	{
	ibat_=abs(Ibat);
	if((abs(ibat)+abs(ibat_))<IKB)kb_start(1);
     else avar_bat_hndl(0);
	}	
if(kb_cnt[1]==1)
	{
	ibat_=abs(Ibat);
	if((abs(ibat)+abs(ibat_))<IKB)avar_bat_hndl(1);
	else avar_bat_hndl(0);
	}	
}
//-----------------------------------------------
void unet_drv(void)
{
if((Unet<UMN)&&(main_cnt>5))
	{
	if(unet_drv_cnt<5)
		{
		unet_drv_cnt++;
		if(unet_drv_cnt>=5)
			{
						avar_unet_hndl(1);
			}
		}
	else if(unet_drv_cnt>5) unet_drv_cnt=5;
	}
else if(Unet>UMN)
	{                 
	if(unet_drv_cnt)
		{
		unet_drv_cnt--;
		if(unet_drv_cnt==0)
			{
			avar_unet_hndl(0);
						}
		}
	}
}
//-----------------------------------------------
char ke_start(void)
{
if((St&0b00000010)||(!NUMBAT))
	{
	return 1;
//	break;
	}     
else if(St&0b00000001)
	{
	return 2;
//	break;
	}	 
else if((abs(Ibat)>(IKB*10))&&bit_minus)
	{
	return 3;
	}	  
else if((abs(Ibat)>(IKB*10))&&(!bit_minus))
	{
	return 4;
	}		
else 
	{
	spc_stat=spc_KEp1;
	zar_cnt_ee_ke=0;
	zar_cnt=0L;
	}
}
//-----------------------------------------------
void spc_drv(void)
{
static char cnt_spc_drv_ke;
if(spc_stat==spc_VZ)
	{
	cnt_vz_sec++;
	cnt_vz_sec_--;
	if(!cnt_vz_sec_)spc_stat=spc_OFF;
	}
else if(spc_stat==spc_KEp1)
	{
	if((Ubat<=(USIGN*10))&&(main_cnt>10))
		{
		cnt_spc_drv_ke++;
		if(cnt_spc_drv_ke>=10)
			{
			spc_stat=spc_OFF;
			St_[0]&=0b11000011;
			St_[1]&=0b11000011; 
			CBAT=zar_cnt_ee_ke;
			zar_cnt_ee=0;
			zar_cnt=0;
			} 
		}
	else cnt_spc_drv_ke=0;	
	}	
}
//-----------------------------------------------
void zar_drv(void)
{
unsigned int tempUI,tempUI_;
unsigned int b_zar; 
char i;
     if((abs(Ibat))<2000)
	{
	if(bit_minus)
		{
				zar_cnt-=Ibat/10;
		}
	else 
		{
		if(zar_cnt_ee<CBAT)	zar_cnt+=(signed)(((long)Ibat*95)/1000);
		}
	}		
		if(zar_cnt<=-3600L)
	{
	zar_cnt=0;
	if(zar_cnt_ee)zar_cnt_ee--;
	if(spc_stat==spc_KEp1)zar_cnt_ee_ke++;
	}
else if(zar_cnt>=3600L)
	{
	zar_cnt=0;
	if(zar_cnt_ee<CBAT)zar_cnt_ee++;
	}
	//zar_percent=(char)(((zar_cnt_ee*360L)+(zar_cnt/100L))/(CBAT*36L));
zar_percent=(char)(((zar_cnt_ee*100L)+(zar_cnt/36L))/(CBAT));
gran_char(&zar_percent,0,100);	
				}
//-----------------------------------------------
void apv_drv(void)
{ 
if(hour_apv_cnt)
	{
	hour_apv_cnt--;
	if(hour_apv_cnt==0)
		{
		main_apv_cnt=0;
		avar_src_reset(0);
		avar_src_reset(1);
		}
	}
if(reset_apv_cnt)
	{
	reset_apv_cnt--;
	if(reset_apv_cnt==0)
		{
		main_apv_cnt=0;
		}
	}
if(apv_cnt_1)
	{
	apv_cnt_1--;
	if(!apv_cnt_1) 
		{
		avar_src_reset(0);
		avar_src_reset(1);
		//cntrl_stat=0;
		}
	}		
}
//-----------------------------------------------
void apv_hndl(char in)
{
if((NUMIST>1)&&(APV))
	{ 
	if(main_apv_cnt<3)
		{                          
		if(in==0)
			{
			if(PORTC.3) cntrl_stat=0;
			}                        
		else if(in==1)
			{
			if(PORTC.2) cntrl_stat=0;
			}	
		avar_src_reset((~in)&0x01);
		main_apv_cnt++;
		reset_apv_cnt=600; 
		apv_cnt_1=60;
		}
	else 
		{
		//avar_src_reset((~in)&0x01);
		hour_apv_cnt=3600;
		reset_apv_cnt=0;	       
		}
	}
else if((NUMIST<2)&&(APV))
	{ 
	if(main_apv_cnt<3)
		{
		apv_cnt_1=60;
		main_apv_cnt++;
		reset_apv_cnt=600;
		cntrl_stat=0;
		}
	else 
		{
		//avar_src_reset((~in)&0x01);
		hour_apv_cnt=3600;
		reset_apv_cnt=0;	       
		}			      
	}
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
void zvuk_hndl(void)
{
if(++cnt_beep>=3)cnt_beep=0;
if((av_beep&0x00ff)&&(ind!=iK)&&(ind!=iTst)&&ZS)
	{
	zvuk(5,25);
	}
else if(bUrazr&&(!bUOFF)&&ZS) zvuk(20,1);
else if(bIrazr&&(cnt_beep==0)&&(!bIOFF)&&ZS)
	{
	zvuk(20,1);
    	}		      
	}
//-----------------------------------------------
void rele_drv(void)
{
DDRC.1=1;
if((ind==iTst)&&(sub_ind==1))//||(sub_ind==2))&&(tst_state[0]==tstON)*/)
	{
	if(tst_state[0]==tstOFF)	PORTC.1=1;
	else 	PORTC.1=0;
	//PORTC.0=0;    
     }
     else if(av_rele&0x00ff)
	{
	PORTC.1=0; 
	}
else 
	{
	PORTC.1=1; 
      }   
}
//-----------------------------------------------
void out_out(void)
{
char temp;
DDRC.2=1;
DDRC.3=1; 
if(cnt_src[0])cnt_src[0]--;
if(cnt_src[1])cnt_src[1]--;
if((tzas_cnt)&&(!(St&0x01)))tzas_cnt--;
if(BP1ISOFF) cnt_src[0]=0;
if(BP2ISOFF) cnt_src[1]=0;
if((ind==iTst)&&(sub_ind==3))
	{
	PORTC.2=BPON;
	if(cnt_src[1])PORTC.3=BPON;
	else PORTC.3=BPOFF;
	} 
else if((ind==iTst)&&(sub_ind==4))
	{           
	if(cnt_src[0])PORTC.2=BPON;
	else PORTC.2=BPOFF;
	PORTC.3=BPON;
	}
else if((ind==iTst)&&(sub_ind==5))
	{
	PORTC.2=BPON;
	PORTC.3=BPON;
	}		
else 
	{
																																			     	     																																																										 	 																}
}
//-----------------------------------------------
void time_drv(void)
{   
static char _5hz_cnt_;
hour_cnt_5hz++;
if(hour_cnt_5hz>=18000) hour_cnt_5hz=0;
_5hz_cnt_++;
if(_5hz_cnt_>=5)
	{
	_5hz_cnt_=0;
	hour_cnt_1hz++;
	if(hour_cnt_1hz>=3600)hour_cnt_1hz=0;
	if(main_cnt<200) main_cnt++;
		cnt_ind++;
	if(cnt_ind>9)cnt_ind=0;
	}  
if(hour_cnt_5hz==150) kb_start(0);
	//if(kb_cnt[in]) kb_cnt[in]--;	
}
//-----------------------------------------------
void src_drv(char in)
{        
char off_bp;
if(in==0) off_bp=BP1ISOFF;
else off_bp=BP2ISOFF;
if((in==1)&&(NUMIST<2))
	{
	St_[1]&=0b11100011;
	St_[1]|=0b00100000;
	} 
else
{
if((!off_bp)&&(!(St_[in]&0b00000100))&&(Us[in]>UMAX)&&(!(St&0x01)))
	{ 
	if(cnt_av_umax[in]<20)
		{
		cnt_av_umax[in]++;
		if(cnt_av_umax[in]>=20)
			{
			unsigned int mask;
			St_[in]|=0b00000100;
			if(in==0)mask=4;
			else if(in==1)mask=32;
		 	av_stat|=mask;//MASK_AV_IST_UMAX[in];
			av_rele|=mask;//MASK_AV_IST_UMAX[in];
			av_beep|=mask;//MASK_AV_IST_UMAX[in];
			cnt_src[in]=10;
			apv_hndl(in);
						blok_src_reset((~in)&0x01);
			}
		}
	else cnt_av_umax[in]=0;	
	}
else cnt_av_umax[in]=0;	 
if((!off_bp)&&(!(St_[in]&0b00001000))&&(Us[in]<(UMAX/2))&&(!(St&0x01))&&(main_cnt>10))
	{ 
	if(cnt_av_umin[in]<20 )
		{
		cnt_av_umin[in]++;
		if(cnt_av_umin[in]>=20 )
			{
			unsigned int mask;
			St_[in]|=0b00001000;
			if(in==0)mask=8;
			else if(in==1)mask=64;
			av_stat|=mask;//MASK_AV_IST_UMIN[in];
			av_rele|=mask;//MASK_AV_IST_UMIN[in];
		  	av_beep|=mask;//4567;//|=MASK_AV_IST_UMIN[in];  			
			cnt_src[in]=10;
			apv_hndl(in);
			//avar_src_reset((~in)&0x01);
			blok_src_reset((~in)&0x01); 
			}
		}
	else cnt_av_umin[in]=0;	
	}
else cnt_av_umin[in]=0;	  
if((t_i[in]>TMAX)&&(!ND[in]))
	{ 
	if(cnt_av_t[in]<20)
		{
		cnt_av_t[in]++;
		if(cnt_av_t[in]>=20)
			{
			unsigned int mask;
			St_[in]|=0b00010000;
			if(in==0)mask=16;
			else if(in==1)mask=128;
			av_stat|=mask;//MASK_AV_IST_TEMPER[in];
			av_rele|=mask;//MASK_AV_IST_TEMPER[in];
			av_beep|=mask;//MASK_AV_IST_TEMPER[in];			
			cnt_src[in]=10;
			//avar_src_reset((~in)&0x01);
			blok_src_reset((~in)&0x01);
			}
		}
	else if(cnt_av_t[in]>20) cnt_av_t[in]=0;
			}
	if((t_i[in]<(TMAX-5))||(ND[in]))
	{ 
	if(cnt_av_t[in])
		{
		cnt_av_t[in]--;
		if(cnt_av_t[in]==0)
			{
			unsigned int mask;
			St_[in]&=0b11101111;
			if(in==0)mask=239;
			else if(in==1)mask=127;
			av_stat&=mask;//MASK_AV_IST_TEMPER[in];
			av_rele&=mask;//MASK_AV_IST_TEMPER[in];
			av_beep&=mask;//MASK_AV_IST_TEMPER[in];
			}
		}
	}
}	  
//src_drv_end:		 
}
//-----------------------------------------------
void cntrl_drv(void)
{
gran(&cntrl_stat1,0,1013);
gran(&cntrl_stat2,0,1013);
OCR1B=cntrl_stat1;
OCR1A=cntrl_stat2;
}
//-----------------------------------------------
void u_necc_hndl(void)
{
signed long temp_L;
if(t_b<=0) temp_L=UB0;
else if(t_b>=40) temp_L=(UB20*2U)-UB0;
else
	{
	temp_L=(UB20-UB0)*10;
	temp_L*=t_b;
	temp_L/=200;
	temp_L+=UB0;
	}
	if(spc_stat==spc_VZ) 
	{
	temp_L*=KVZ;
	temp_L/=1000;
	} 
	u_necc_=(signed int)temp_L;
if((ind==iTst)&&(sub_ind==3))
	{
	if(tst_state[2]==tstOFF)u_necc=400;
	else if(tst_state[2]==tstON)u_necc=800;
	else if(tst_state[2]==tstU)u_necc=UB20;
	}
else if((ind==iTst)&&(sub_ind==4))
	{
	if(tst_state[3]==tstOFF)u_necc=400;
	else if(tst_state[3]==tstON)u_necc=800;
	else if(tst_state[3]==tstU)u_necc=UB20;
	}
else if((ind==iTst)&&(sub_ind==5))
	{
	if(tst_state[4]==tstOFF)u_necc=400;
	else if(tst_state[4]==tstON)u_necc=800;
	else if(tst_state[4]==tstU)u_necc=UB20;
	}				
else if(!NUMBAT) u_necc=U0B;	
else u_necc=u_necc_;		
     }
//-----------------------------------------------
void cntrl_hndl(void)
{
signed long temp_L;
if(St&0b00000001)
	{
	cntrl_stat=0;
     old_cntrl_stat=0;
     }
if((kb_cnt[0]>15)&&(kb_cnt[0]<=30))
	{
	cntrl_stat=old_cntrl_stat-30;
	gran(&cntrl_stat,0,1020);
	}
else if((kb_cnt[0]<=15)&&(kb_cnt[0]>0))
	{
	cntrl_stat=old_cntrl_stat+30;
	gran(&cntrl_stat,0,1020);
	} 
else if((kb_cnt[1]>15)&&(kb_cnt[1]<=30))
	{
	cntrl_stat=old_cntrl_stat-100;
	gran(&cntrl_stat,0,1020);
	}
else if((kb_cnt[1]<=15)&&(kb_cnt[1]>0))
	{
	cntrl_stat=old_cntrl_stat+100;
	gran(&cntrl_stat,0,1020);
	} 	
else if((ind==iTst)&&((sub_ind>=3)&&(sub_ind<=5)))
	{
	if(u_necc==400)
		{
		if(cntrl_stat>50)cntrl_stat-=50;
		else cntrl_stat=0;
		}
	else if(u_necc==800)
		{
		if(cntrl_stat<970)cntrl_stat+=50;
		else cntrl_stat=1020;
		}		
	else if(Uload>u_necc)
		{
		if(((Ubat-u_necc)>5)&&(cntrl_stat>0))cntrl_stat-=5;
		else if(cntrl_stat)cntrl_stat--;
		}
	else if(Uload<u_necc)
		{
		if(((u_necc-Ubat)>5)&&(cntrl_stat<1015))cntrl_stat+=5;
		else	if(cntrl_stat<1020)cntrl_stat++;
		}		
	}
else if(spc_stat==spc_KEp1)
	{
	cntrl_stat=0;
	old_cntrl_stat=0;
	} 
else 
	{ 
     if(((Ibat/10)>IZMAX)&&!bit_minus)
     	{
               	     	if((Ibat/10)>=(2*IZMAX))
     		{  
          		     		if((cntrl_stat>50)&&!cnt_blok)
     			{
     			cntrl_stat-=50;
                    }
               else if(cntrl_stat)cntrl_stat--;     
     		}     
     	else
    			{
    			Ibs=iiM;
     		if(cntrl_stat>10)
     			{
     			cntrl_stat-=10;
                    }
     		}          	 	   
     	}	
	else if(((Ibat)<((IZMAX*9)))||bit_minus)
		{
				     	if(bit_minus)
     		{
     		if((Uload<u_necc)&&((u_necc-Uload)>=((UB0-UB20)/4)))
     			{
     			if((cntrl_stat<1000)&&!cnt_blok)
     				{
     				cntrl_stat+=20;
                    	}
                    else
    					{
     				if(cntrl_stat<1020)
     					{
     					cntrl_stat++;
                    		}
     				} 	
         			}
    			else if((Uload<u_necc)&&((u_necc-Uload)<((UB0-UB20)/4)))
     			{
     			if(cntrl_stat<1020)
     				{
     				cntrl_stat++;
                    	}
         			}      
  			else if((Uload>u_necc)&&((Uload-u_necc)>=((UB0-UB20)/4)))
     			{
     			if((cntrl_stat>20)&&!cnt_blok)
     				{
     				cntrl_stat-=20;
                    	}
                    else
    					{
     				if(cntrl_stat)
     					{
     					cntrl_stat--;
                    		}
     				} 	
         			}
                    	         		    			else if((Uload>u_necc)&&((Uload-u_necc)<((UB0-UB20)/4)))
     			{
     			if(cntrl_stat)
     				{
     				cntrl_stat--;
                    	}
         			}               			   			
     		}
       		     	else 
     		{
     		if(Uload<(u_necc-1))
     			{
     			if(cntrl_stat<1020)
     				{
     				cntrl_stat++;
                    	}
     			}
    			else if(Uload>(u_necc+1))
     			{
     			if(cntrl_stat)
     				{
     				cntrl_stat--;
                    	}
     			}     			
     		}	
     	}
 	old_cntrl_stat=cntrl_stat;
     }		
Ibso=Ibs;
		cntrl_stat1=cntrl_stat;
cntrl_stat2=cntrl_stat+x_;
gran(&cntrl_stat2,0,1020);
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
int Umat(int in,int k1)
{
signed long int temp;
temp=in;
temp*=k1;
temp/=100L;
return (int)temp;
}
//-----------------------------------------------
void matemat(void)
{ 
signed long int adc_out_temp;
char temp;
Us[0]=Umat(adc_bank_[0],K_[3])/5;	
Us[1]=Umat(adc_bank_[1],K_[4])/5;
Ubat=Umat(adc_bank_[9]/4,K_[9])/5;
Unet=Umat(adc_bank_[4],K_[10 ])/5;
if(!bI) Ibat=Ibmat(adc_bank_[8],K_[1],K_[2 		]);
if(Ubat>=100) Uload=Ubat;
else if (Us[0]>=100) Uload=Us[0];
else Uload=Us[1];
if(bit_minus) Iload=Is[0]+Is[1]+(Ibat/10);
else Iload=Is[0]+Is[1]-(Ibat/10);
if(Iload<0) Iload=0;
//gran_ee(&K_[KTT],450,550);
if((adc_bank_[7]<400)||(adc_bank_[7]>800)) 
	{
	ND[2]=1;
	t_b=20;
	}
else 
	{
	ND[2]=0;
	adc_out_temp=((adc_bank_[7]*(unsigned long)K_[13  ])/1024UL)-273UL;
	if(adc_out_temp<0) adc_out_temp=0;
	t_b=(char)adc_out_temp;
	}
//gran_ee(&K_[KTT1],450,550);
if((adc_bank_[5]<400)||(adc_bank_[5]>800)) ND[0]=1;
else 
	{
	ND[0]=0;
	adc_out_temp=((adc_bank_[5]*(unsigned long)K_[11    ])/1024UL)-273UL;
	if(adc_out_temp<0) adc_out_temp=0;
	t_i[0]=(char)adc_out_temp;
     }
        //gran_ee(&K_[KTT2],450,550);
        if((adc_bank_[6]<400)||(adc_bank_[6]>800)) ND[1]=1;
else 
	{
	ND[1]=0;
	adc_out_temp=((adc_bank_[6]*(unsigned long)K_[12 ])/1024UL)-273UL;
	if(adc_out_temp<0) adc_out_temp=0;
	t_i[1]=(char)adc_out_temp;
     }
if((Is[0]+Is[1])>IMAX)
	{
	num_necc=2;
	cnt_num_necc=25;
	}
	else if(((Is[0]+Is[1])*10)<(IMAX*KIMAX))
	{
	if(cnt_num_necc)
		{
		cnt_num_necc--;
		if(cnt_num_necc==0) num_necc=1;
		}
	}	
		                                  		}
//-----------------------------------------------
void def_set(int umax__,int ub0__,int ub20__,int usign__,int imax__,int uob__)
{
NUMBAT=1;
NUMIST=2;
MAIN_IST=0;
UMAX=umax__;
UB0=ub0__;
UB20=ub20__;
TMAX=60;
CBAT=180;
USIGN=usign__;
UMN=187;
ZS=0xff;
IKB=5;
KVZ=1030;
IMAX=imax__;
KIMAX=8;
APV=0xff;
IZMAX=20;
U0B=uob__;
TZAS=3;
}
//-----------------------------------------------
void ind_hndl(void)
{
/* 
flash char sm0_0[]	={" Раб. от ист N] "};
flash char sm0_1[]	={" Раб. от N1 и N2"}; 
flash char sm0_2[]	={" Раб. от батареи"};
flash char sm0_3[]	={" Ав.N[   Раб.N] "}; */
signed int temp;
flash char* ptrs[11];
char temp_;
if (ind==iMn)
{
char tt[2];
char tempo;
ptrs[0]=sm200;
if((cnt_ind>7)&&(spc_stat==spc_VZ))
	{
	ptrs[0]=sm40;
	ptrs[1]=sm41;
	tempo=100;
	}	
else if((cnt_ind>7)&&(spc_stat==spc_KEp1))
	{
	ptrs[0]=sm42;
	ptrs[1]=sm43;
	tempo=100;
	} 
else 
	{			
	if(((St&0x01)||(/*BP1ISOFF&&BP2ISOFF*/((St_[0]&0b00111100)||(BP1ISOFF))&&((St_[1]&0b00111100)||(BP2ISOFF))))&&(NUMBAT!=0)&&(!(St&0x02)))ptrs[0]=sm0_2;
	else if(BP1ISON/*&&(!(St_[0]&0b00011100))*/&&BP2ISON&&/*(!(St_[1]&0b00011100))&&*/(!(St&0x01)))ptrs[0]=sm0_1;  
	else if(BP1ISON&&(!(St_[0]&0b00011100))&&(!(St&0x01)))
		{
		if(BP2ISOFF&&(!(St_[1]&0b00011100)))
			{
			ptrs[0]=sm0_0;
			tt[0]=1;
			}
			else if(BP2ISOFF&&((St_[1]&0b00011100)))
			{
			ptrs[0]=sm0_3;
			tt[0]=1;
			tt[1]=2;
			}		
		} 
		else if(BP2ISON&&(!(St_[1]&0b00011100))&&(!(St&0x01)))
		{
		if(BP1ISOFF&&(!(St_[0]&0b00011100)))
			{
			ptrs[0]=sm0_0;
			tt[0]=2;
			}
			else if(BP1ISOFF&&((St_[0]&0b00011100)))
			{
			ptrs[0]=sm0_3;
			tt[0]=2;
			tt[1]=1;
			}		
		}
			if(NUMBAT==0)ptrs[1]=sm1_1;
	else ptrs[1]=sm1_0;
	tempo=0;
	}
	ptrs[2]=sm1_2;
ptrs[3]=sm1_3;
ptrs[4]=sm1_4;
ptrs[5]=sm1_5;
ptrs[6]=sm1_6;
ptrs[7]=sm1_7; 
ptrs[8]=sm1_8;
ptrs[9]=sm1_9;
ptrs[10]=sm36;
if(sub_ind<index_set) index_set=sub_ind;
else if((sub_ind-index_set)>1) index_set=sub_ind-1;
bgnd_par(ptrs[index_set],ptrs[index_set+1]);
if(sub_ind>1)
	{
	if((sub_ind-index_set)==0) lcd_buffer[0]=1; 
	else if((sub_ind-index_set)==1) lcd_buffer[16]=1;
	}
	if(NUMBAT==0) int2lcd(Uload,'<',1);     
else /*if(!(St&0x02))*/ int2lcd(Ubat,'<',1);
/*else int2lcd(0,'<',1);*/
	if(NUMBAT&&(!tempo))
	{
	if(!bit_minus)
		{
		if(Ibat<999)
			{
			int2lcd(Ibat,'>',2);
			}
		else if(Ibat>=1000)
			{
			int2lcd(Ibat/10,'>',1);
			}	
		}
	else
		{		
		if(Ibat<99)
			{
			int2lcd(Ibat,'>',2);
			if(index_set==0)lcd_buffer[27]='-';
			else if(index_set==1)lcd_buffer[11]='-';
			}
		else if(Ibat>=100)
			{
			int2lcd_m(Ibat/10,'>',1);
			}	
				}     
		     }
else 
	{
	int2lcd(Iload,'>',1);
	}
int2lcd(tt[0],']',0);
int2lcd(tt[1],'[',0);
lcd_buffer[find('@')]=5;
lcd_buffer[find('#')]=3;             
int2lcd((int)(cnt_vz_sec/3600),'(',0);
//int2lcdxy(main_cnt/*St*//*hour_cnt_5hz*/,0xf0,0);
//int2lcdxy(kb_cnt[0],0x51,0);
//int2lcdxy(kb_cnt[1],0x91,0);
//int2lcdxy(cntrl_stat,0x20,0);
int2lcdxy(but,0x20,0);
	}
/*
flash char sm50[]	={"Ист. N[ в работе"};
flash char sm51[]	={"Ист. N[ в резерв"}; 
flash char sm54[]	={"  Uист=  .:В    "};
flash char sm55[]	={"  Iист=  .XА    "};
flash char sm56[]	={"  tист=  j C    "}; 
flash char sm57[]	={"Авария ист. N[  "};
flash char sm60[]	={"  Авария сети   "}
flash char sm71[]	={" Завышено Uвых. "};
flash char sm72[]	={" Занижено Uвых. "};
flash char sm73[]	={"   Перегрев     "};
*/
else if (ind==iSrc)
	{
	flash char* ppp;
	if(!sub_ind1)temp_=BP1ISOFF;
	else temp_=BP2ISOFF;
		if(ND[sub_ind1])ppp=sm9_;
	else ppp=sm56;
		if((NUMIST<2)&&(sub_ind1==1)) 
		{  
		ptrs[0]=sm180;
		ptrs[1]=sm181;
		SIMAXISRC=0;		
		} 
	else if(St&0x01) 
		{  
		ptrs[0]=sm60;
		ptrs[1]=sm54;
		ptrs[2]=sm55;
		ptrs[3]=ppp;
		ptrs[4]=sm58;
		SIMAXISRC=3;		
		} 
			else if((!(St_[sub_ind1]&0b00111100))&&(!temp_)) 
		{  
		ptrs[0]=sm50;
		ptrs[1]=sm54;
		ptrs[2]=sm55;
		ptrs[3]=ppp;
		ptrs[4]=sm58;
		SIMAXISRC=3;		
		}
		     	else if((!(St_[sub_ind1]&0b00011110))&&(temp_)) 
		{  
		ptrs[0]=sm51;
		ptrs[1]=sm54;
		ptrs[2]=sm55;
		ptrs[3]=ppp;
		ptrs[4]=sm58;
		SIMAXISRC=3;		
		} 
	else if((St_[sub_ind1]&0b00000100)/*&&(temp_)*/) 
		{ 
		ptrs[0]=sm57; 
		ptrs[1]=sm71;
		ptrs[2]=sm54;
		ptrs[3]=sm55;
		ptrs[4]=ppp;
		ptrs[5]=sm58;
		SIMAXISRC=4;		
		} 
			else if((St_[sub_ind1]&0b00001000)/*&&(temp_)*/) 
		{ 
		ptrs[0]=sm57; 
		ptrs[1]=sm72;
		ptrs[2]=sm54;
		ptrs[3]=sm55;
		ptrs[4]=ppp;
		ptrs[5]=sm58;
		SIMAXISRC=4;		
		} 
			else if((St_[sub_ind1]&0b00010000)/*&&(temp_)*/) 
		{ 
		ptrs[0]=sm57; 
		ptrs[1]=sm73;
		ptrs[2]=sm54;
		ptrs[3]=sm55;
		ptrs[4]=ppp;
		ptrs[5]=sm58;
		SIMAXISRC=4;		
		}
	else 
		{ 
		ptrs[0]=sm57; 
		ptrs[1]=sm57;
		ptrs[2]=sm54;
		ptrs[3]=sm55;
		ptrs[4]=ppp;
		ptrs[5]=sm58;
		SIMAXISRC=4;		
		}	 							
			//if(sub_ind<index_set) index_set=sub_ind;
	//else if((sub_ind-index_set)>1) index_set=sub_ind-1;
    	bgnd_par(ptrs[sub_ind],ptrs[sub_ind+1]);
		int2lcd(sub_ind1+1,'[',0);
	int2lcd(Us[sub_ind1],':',1);
	int2lcd(Is[sub_ind1],']',1);	
	int2lcd_mm(t_i[sub_ind1],'j',0);
	lcd_buffer[find('<')]=1;	
	lcd_buffer[find('g')]=2;
	//gran_char(&sub_ind,0,SIMAXISRC);
		//if(!sub_ind1)int2lcdxy(OFFBP1,0xf0,0);
	//else int2lcdxy(OFFBP2,0xf0,0);
		//int2lcdxy(St_[sub_ind1],0xa0,0);
	  //	int2lcdxy(cnt_av_t[sub_ind1],0xf0,0);
	}	
else if (ind==iNet)
	{  
																																																			} 
	 else if (ind==iLoad)
	{ 
	if(!sub_ind)
		{
		bgnd_par(sm34_0,sm34);
		}
	else if(sub_ind==1)
		{
		bgnd_par(sm34,sm35);
		}
	else 
		{
		bgnd_par(sm35,sm36);
		lcd_buffer[16]=1;
		}	
	int2lcd(Uload,'(',1);
	int2lcd(Iload,')',1);			
	}	 
else if (ind==iDefault)
	{ 
	if(sub_ind<index_set) index_set=sub_ind;
	else if((sub_ind-index_set)>1) index_set=sub_ind-1;
    	bgnd_par(p_idef[index_set],p_idef[index_set+1]);
	if((sub_ind-index_set)==0) lcd_buffer[0]=1; 
	else if((sub_ind-index_set)==1) lcd_buffer[16]=1; 
		if(default_temp<5)
		{
		if(index_set==default_temp) lcd_buffer[15]='*';
		else if((default_temp-index_set)==1) lcd_buffer[31]='*';
		}
	}
else if (ind==iSet)
	{
	if(sub_ind<index_set) index_set=sub_ind;
	else if((sub_ind-index_set)>1) index_set=sub_ind-1;
    	bgnd_par(p_iset[index_set],p_iset[index_set+1]);
	if((sub_ind-index_set)==0) lcd_buffer[0]=1; 
	else if((sub_ind-index_set)==1) lcd_buffer[16]=1; 
		int2lcd(MAIN_IST+1,'+',0);
	int2lcd(UMAX,'z',1);
	int2lcd(UB0,'[',1);
	int2lcd(UB20,']',1);		
	int2lcd(TMAX,'Z',0);	
//	int2lcd(K[dT],'q',0);
	int2lcd(CBAT,'Q',1);
	int2lcd(USIGN,'w',0);
	int2lcd(UMN,'/',0);
	if(ZS)sub_bgnd(smon,'>');
	else sub_bgnd(smoff,'>'); 
	int2lcd(IKB,'<',0);
	int2lcd(KVZ,'!',3);
	int2lcd(IMAX,'@',1);
	int2lcd(KIMAX,'#',1);   
	if(APV)sub_bgnd(smon,'{');
	else sub_bgnd(smoff,'{');		
	int2lcd(IZMAX,'}',1);	
	int2lcd(U0B,'|',1);	
     int2lcd(TZAS,'q',0);	
    /*	int2lcd(KZ,'L',1);	
	int2lcd(TZAS,'q',0);  */
				lcd_buffer[find('g')]=2;  
			/*int2lcdxy(adc_bank_[0],0xf0,0);
int2lcdxy(adc_bank_[1],0xb0,0);
int2lcdxy(adc_bank_[2],0x70,0);
int2lcdxy(adc_bank_[3],0x30,0);
int2lcdxy(adc_bank_[4],0xf1,0);
int2lcdxy(adc_bank_[5],0xb1,0);
int2lcdxy(adc_bank_[6],0x71,0);
int2lcdxy(adc_bank_[7],0x31,0);	*/
	}   
	else if (ind==iK)
	{ 
	if(sub_ind<index_set) index_set=sub_ind;
	else if((sub_ind-index_set)>1) index_set=sub_ind-1;
    	if(!ND[2])bgnd_par(p_ik[index_set],p_ik[index_set+1]);
    	else bgnd_par(p_ik_[index_set],p_ik_[index_set+1]);
	if((sub_ind-index_set)==0) lcd_buffer[0]=1; 
	else if((sub_ind-index_set)==1) lcd_buffer[16]=1; 	
		int2lcd(Ubat,'z',1);
  	int2lcd_m(Ibat,'Z',2);
  	int2lcd(Us[0],']',1);	
  	int2lcd(Is[0],'X',1);
  	int2lcd(t_i[0],'(',0);  
	int2lcd(Us[1],'[',1);
     int2lcd(Is[1],'Q',1);
	int2lcd(t_i[1],')',0);
	int2lcd(Unet,'w',0);
    	int2lcd(t_b,'j',0);
      /* 
	int2lcd(adc_bank_[9],'z',1);
  	int2lcd_m(adc_bank_[8],'Z',2);
  	int2lcd(adc_bank_[0],']',1);	
  	int2lcd(adc_bank_[2],'X',1);
  	int2lcd(adc_bank_[5],'(',0);  
	int2lcd(adc_bank_[1],'[',1);
     int2lcd(adc_bank_[3],'Q',1);
	int2lcd(adc_bank_[6],')',0);
	int2lcd(adc_bank_[4],'w',0);
    	int2lcd(adc_bank_[7],'j',0); */
    	    	    	lcd_buffer[find('g')]=2;
  	lcd_buffer[find('g')]=2;
  	  	//int2lcdxy(adc_bank_[9],0xf0,0); 
  	//int2lcdxy(K_[kun],0xb0,0);
  	//int2lcdxy(K_[kib0],0x70,0);
  	//int2lcdxy(sub_ind,0x10,0);
  	}
else if (ind==iSpc)
	{        
	if(sub_ind<index_set) index_set=sub_ind;
	else if((sub_ind-index_set)>1) index_set=sub_ind-1;
    	bgnd_par(p_ispc_[index_set],p_ispc_[index_set+1]);
	if((sub_ind-index_set)==0) lcd_buffer[0]=1; 
	else if((sub_ind-index_set)==1) lcd_buffer[16]=1; 
	}
else if (ind==iVz)
	{
	ptrs[0]=sm40;
	ptrs[1]=sm41;
	if(spc_stat==spc_VZ)ptrs[2]=sm39;
	else ptrs[2]=sm38;
	ptrs[3]=sm36;	
	if(sub_ind<index_set) index_set=sub_ind;
	else if((sub_ind-index_set)>1) index_set=sub_ind-1;
    	bgnd_par(ptrs[index_set],ptrs[index_set+1]);
	if((sub_ind-index_set)==0) lcd_buffer[0]=1; 
	else if((sub_ind-index_set)==1) lcd_buffer[16]=1; 	
     int2lcd(VZ_HR,'(',0); 
//     int2lcdxy(cnt_vz_sec,0xf0,0);
//     int2lcdxy(cnt_vz_sec_,0xa0,0);
	}	
else if (ind==iKe)
	{
	ptrs[0]=sm42;
	if(spc_stat==spc_KEp1)ptrs[1]=sm39;
	else ptrs[1]=sm38;
	ptrs[2]=sm36;
	if(sub_ind<index_set) index_set=sub_ind;
	else if((sub_ind-index_set)>1) index_set=sub_ind-1;
    	bgnd_par(ptrs[index_set],ptrs[index_set+1]);
	if((sub_ind-index_set)==0) lcd_buffer[0]=1; 
	else if((sub_ind-index_set)==1) lcd_buffer[16]=1; 
  	lcd_buffer[find('#')]=3;	                     
  //	lcd_buffer[find('<')]=5; 
	//	int2lcdxy(spc_stat,0xf0,0);
	//lcd_buffer[16]=1;	
	}		
else if (ind==iKednd)
	{
	if(sub_ind==0)
		{
		bgnd_par(sm170,sm171);
		}  
	else if(sub_ind==1)
		{
		bgnd_par(sm170,sm172);
		}	
	else if(sub_ind==2)
		{
		bgnd_par(sm170,sm173);
		}	
	else if(sub_ind==3)
		{
		bgnd_par(sm170,sm174);
		}					
	}	
else if (ind==iDnd)
	{
	bgnd_par(sm130,sm131);
	}
      					else if (ind==iBat)
	{
	if(St&0b00000010)
		{
		bgnd_par(sm150,sm151);
		}               
	else
		{
		ptrs[0]=sm10_0;
		ptrs[1]=sm12;
		if(!bit_minus)
			{
			ptrs[2]=sm13;
			}
		else ptrs[2]=sm14;	
		if(ND[2])ptrs[3]=sm9_;
		else ptrs[3]=sm15;
		ptrs[4]=sm16;
		ptrs[5]=sm10;
		ptrs[6]=sm58;
 		bgnd_par(ptrs[sub_ind],ptrs[sub_ind+1]);
			lcd_buffer[find('<')]=1;	
		lcd_buffer[find('g')]=2;	
			int2lcd(Ubat/*abs(zar_cnt)*/,'z',1);
		int2lcd(Ibat,'Z',2);
		int2lcd(t_b/*(int)(zar_cnt_ee)*/,'j',0);
		int2lcd(zar_percent,'w',0);
		int2lcd(CBAT,'Q',1); 
//		int2lcdxy(zar_cnt_ee,0x40,0);		
//		int2lcdxy(zar_cnt,0x41,0);
		}
	} 
		else if ((ind==iSetprl)||(ind==iKprl)||(ind==iSpcprl)||(ind==iSpc_prl_vz)||(ind==iSpc_prl_ke)||(ind==iTstprl)||(ind==iSet_st_prl))
	{          
     bgnd_par(sm18,sm19);
     lcd_buffer[11]=parol[0]+0x30;
     lcd_buffer[12]=parol[1]+0x30;
     lcd_buffer[13]=parol[2]+0x30; 
     lcd_buffer[27+sub_ind]=4;    
	}  
		else if (ind==iAVAR)
	{
	bgnd_par(p_iavar[sub_ind*2],p_iavar[(sub_ind*2)+1]);
	int2lcd(Unet,'[',0);
	}
else if (ind==iStr)
	{  
	if(sub_ind<index_set) index_set=sub_ind;
	else if((sub_ind-index_set)>1) index_set=sub_ind-1;
    	bgnd_par(p_istr[index_set],p_istr[index_set+1]);
	if((sub_ind-index_set)==0) lcd_buffer[0]=1; 
	else if((sub_ind-index_set)==1) lcd_buffer[16]=1; 
		int2lcd(NUMBAT,'[',0);
	int2lcd(NUMIST,']',0);	      
   	}
   	else if (ind==iVrs)
	{        
	bgnd_par(smVRS,sm_);
	int2lcd(21,'!',0);
	int2lcd(8,'@',0);	
	int2lcd(6,'#',0);
	}
	   else if (ind==iTst)
	{ 
	if(sub_ind<index_set) index_set=sub_ind;
	else if((sub_ind-index_set)>1) index_set=sub_ind-1;
    	if(bFL_)bgnd_par(p_itst_[index_set],p_itst_[index_set+1]);
	else bgnd_par(p_itst[index_set],p_itst[index_set+1]);
	if((sub_ind-index_set)==0) lcd_buffer[0]=1; 
	else if((sub_ind-index_set)==1) lcd_buffer[16]=1; 
 	if(tst_state[0]==tstOFF)sub_bgnd(smoff,'(');
	else if(tst_state[0]==tstON)sub_bgnd(smon,'(');	
     if(!bFL_)
     	{
     	if(tst_state[1]==tstOFF)sub_bgnd(smoff,')');
		else if(tst_state[1]==tstON)sub_bgnd(smon,')');
		//sub_bgnd(smoff,')');
     	     }
	else  
		{
	     int2lcd(Ibat,':',2);				
          }
 	if(tst_state[2]==tstOFF)sub_bgnd(smumin,'}');   
	else if(tst_state[2]==tstON)sub_bgnd(smumax,'}');
	else if(tst_state[2]==tstU)sub_bgnd(smu20,'}');
		if(tst_state[3]==tstOFF)sub_bgnd(smumin,'[');   
	else if(tst_state[3]==tstON)sub_bgnd(smumax,'[');
	else if(tst_state[3]==tstU)sub_bgnd(smu20,'[');			
		if(tst_state[4]==tstOFF)sub_bgnd(smumin,']');   
	else if(tst_state[4]==tstON)sub_bgnd(smumax,']');
	else if(tst_state[4]==tstU)sub_bgnd(smu20,']'); 
	 	} 
else if (ind==iDebug)
	{
	bgnd_par(smD1,smD2);
	int2lcd_mm(zar_cnt_ee,'A',0);
	int2lcd_mm(zar_cnt_ee_ke,'B',0);
	int2lcd_mm(zar_cnt,'C',0);  	 	     
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
if(star_cnt>70) lcd_buffer[0]='*';
}
// Константы состояния кнопок
