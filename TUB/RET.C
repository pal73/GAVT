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