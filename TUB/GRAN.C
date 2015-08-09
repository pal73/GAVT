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