#include <GyverTimers.h>
#include <EEPROM.h>
#include "Ticker.h"


#include <AnalogKey.h>
#include <GyverButton.h>

#include "U8glib.h"

void time_grid_hndl(void);
void pin_blink_hndl(void);

//********************************************************************
//Сетка времени
char tgh_cnt0, tgh_cnt1, tgh_cnt2, tgh_cnt3, tgh_cnt4;
bool b1000Hz, b100Hz, b10Hz, b5Hz, b2Hz, b1Hz;

//********************************************************************
//Управление индикацией
short ind_cnt;

U8GLIB_SSD1306_128X32 u8g(U8G_I2C_OPT_NONE);	// I2C / TWI 
int plazma;

GButton butt_up(7), butt_dwn(6);
GButton inStart(2);    //Логический вход "Запуск"
GButton inMd(3);    //Логический вход "Магнитный датчик"


Ticker time_grid(time_grid_hndl, 10);
Ticker pin_blincker(pin_blink_hndl, 1);

//********************************************************************
//Управление процессом
short relay_cnt, delay_cnt, valve_cnt;

ISR(TIMER2_B) 
{
pinMode(11,OUTPUT);
digitalWrite(11,!digitalRead(11));
time_grid_hndl();
}

//--------------------------------------------------------------------
//Управление процессом
void wrk_hndl(void)
{
pinMode(4, OUTPUT); 
pinMode(5, OUTPUT);


if(inStart.isPress() && !relay_cnt && !delay_cnt && !valve_cnt)
  {
  valve_cnt=100;  
  }

if(inMd.isPress() && !relay_cnt && !delay_cnt && (valve_cnt==100))
  {
  delay_cnt=plazma; 
  valve_cnt=0; 
  }


if(valve_cnt)
  {
  digitalWrite(4,HIGH);  
  }
else digitalWrite(4,LOW);

if(delay_cnt)
  {
  delay_cnt--;
  if(!delay_cnt)
    {
    relay_cnt=100;  
    }
  }

if(relay_cnt)
  {
  relay_cnt--;
  digitalWrite(5,HIGH);  
  }
else digitalWrite(5,LOW);  
}
//--------------------------------------------------------------------
//Сетка времени
void pin_blink_hndl(void)
{
pinMode(11,OUTPUT);
digitalWrite(11,!digitalRead(11));
}

//--------------------------------------------------------------------
//Обработка кнопок
void but_an(void)
{
if (butt_up.isClick() || butt_up.isHold() )
  {
  plazma++;
  plazma = constrain(plazma, 3, 100);
  EEPROM.put(0, plazma);
  ind_cnt=20;
  }

if (butt_dwn.isClick() || butt_dwn.isHold()|| inMd.isPress())
  {
  plazma--;
  plazma = constrain(plazma, 3, 100);
  EEPROM.put(0, plazma);
  ind_cnt=20;
  }

//if(inStart.isPress()) valve_cnt=100; 
}

//--------------------------------------------------------------------
//Сетка времени
void time_grid_hndl(void)
{
b1000Hz=1;
if(++tgh_cnt0>=10)
  {
  tgh_cnt0=0;
  b100Hz=1;
  if(++tgh_cnt1>=10)
    {
    tgh_cnt1=0;
    b10Hz=1;
    }
  if(++tgh_cnt2>=20)
    {
    tgh_cnt2=0;
    b5Hz=1;
    }  
  if(++tgh_cnt3>=50)
    {
    tgh_cnt3=0;
    b2Hz=1;
    } 
  if(++tgh_cnt4>=100)
    {
    tgh_cnt4=0;
    b1Hz=1;
    }  
  }
}

//--------------------------------------------------------------------
//
void draw(void) 
{
if(ind_cnt)
  {
  //ind_cnt--;  
 
  // graphic commands to redraw the complete screen should be placed here  
  //u8g.setFont(u8g_font_unifont);
 u8g.setFont(u8g_font_osb21);
 u8g.setRot180();
  //u8g.drawStr( 0, 22, "Hello World!");
  //u8g.print( 0, 22, plazma);
u8g.setPrintPos(35, 29);
u8g.print(plazma/100);
u8g.setPrintPos(50, 29);
u8g.print('.');
u8g.setPrintPos(60, 29);
u8g.print((plazma/10)%10);
u8g.setPrintPos(79, 29);
u8g.print((plazma)%10);      
 }
}

void setup(void) 
{
Timer2.setPeriod(1000);
Timer2.enableISR(CHANNEL_B);
EEPROM.get(0, plazma);
//time_grid.start();
//pin_blincker.start();
// flip screen, if required
// u8g.setRot180();

// set SPI backup if required
//u8g.setHardwareBackup(u8g_backup_avr_spi);

// assign default color value
if ( u8g.getMode() == U8G_MODE_R3G3B2 ) {
  u8g.setColorIndex(255);     // white
}
else if ( u8g.getMode() == U8G_MODE_GRAY2BIT ) {
  u8g.setColorIndex(3);         // max intensity
}
else if ( u8g.getMode() == U8G_MODE_BW ) {
  u8g.setColorIndex(1);         // pixel on
}
else if ( u8g.getMode() == U8G_MODE_HICOLOR ) {
  u8g.setHiColorByRGB(255,255,255);
}

pinMode(8, OUTPUT);

butt_up.setType(HIGH_PULL);
butt_up.setDirection(NORM_OPEN);
butt_up.setDebounce(50);        // настройка антидребезга (по умолчанию 80 мс)
butt_up.setTimeout(300);        // настройка таймаута на удержание (по умолчанию 500 мс)
butt_up.setClickTimeout(600);   // настройка таймаута между кликами (по умолчанию 300 мс) 
 
butt_dwn.setType(HIGH_PULL);
butt_dwn.setDirection(NORM_OPEN);
butt_dwn.setDebounce(50);        // настройка антидребезга (по умолчанию 80 мс)
butt_dwn.setTimeout(300);        // настройка таймаута на удержание (по умолчанию 500 мс)
butt_dwn.setClickTimeout(600);   // настройка таймаута между кликами (по умолчанию 300 мс) 
  
ind_cnt=20;
}

void loop(void) 
  {
  time_grid.update(); 
  pin_blincker.update(); 
  butt_up.tick();
  butt_dwn.tick();
  inStart.tick();
  inMd.tick();

  // picture loop



  
  // rebuild the picture after some delay
  //delay(100);
if(b1000Hz)
  {
  b1000Hz=0;
  }  

if(b100Hz)
  {
  b100Hz=0;
  
  wrk_hndl();
  }

if(b10Hz)
  {
  b10Hz=0;

  if(ind_cnt)
    {
    ind_cnt--; 
    }
  but_an();
  u8g.firstPage();  
  do {
    draw();
  } while( u8g.nextPage() );
  //led_output=!led_output;
  //digitalWrite(LED_BUILTIN, led_output);
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
}
