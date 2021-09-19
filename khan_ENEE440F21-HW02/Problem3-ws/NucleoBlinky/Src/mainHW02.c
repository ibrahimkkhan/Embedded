//mainHW02.c wmh 2021-09-07 : prototype for '440 HW02 (data access exercise)

#include "stdint-gcc.h"	//for uint8_t, uint16_t, uint32_t  etc. 


//definitions in myDataOps.S
uint32_t *MywordAddress(void);	//returns pointer to variable 'Myword' defined in myDataOps.S
uint32_t getMywordContents(void);
//uint32_t loadConstant01(void);
//uint32_t loadConstant02(void);
//uint32_t loadConstant03(void);
//uint32_t loadConstant04(void);
//uint32_t loadConstant05(void);
//uint32_t loadConstant06(void);
//uint32_t loadConstant07(void);
//uint32_t loadVariable01(void);
//uint32_t loadVariable02(void);
//uint32_t loadVariable03(void);
//uint32_t loadVariable04(void);
uint32_t storeVariable01(void);
uint32_t storeVariable02(void);
uint32_t storeVariable03(void);




void addToMywordContents(int32_t addend);	//adds value 'addend' to value stored in variable 'Myword' defined in myDataOps.S

//definitions in userLED.S
void initGPIOA5();		//configures port bit PE8 (green LED) as GPIO output
void togglePA5();		//flips port bit PE8 (green LED) to its opposite state

void SWdelay(uint32_t delaycount)
{
	int i;
	for(i=0;i<delaycount;i++);
}

int main(void)
{
	uint32_t worddata,*pworddata, store_var_01, store_var_02, store_var_03;			//C values we can watch in main()

	//HW - Problem 3
	// In the debug perspective, you can observe the value I am loading in the r0 for verification of a successful store using STR instruction.
	// First I load both address of both var_1 and var_2 into r0 and r1, respectively.
	// I then load the value found at address stored in r0(var_1) into r2.
	// I then store that value into into the address found in r1(var_2).
	//Finally, I load the value found at address stored at r1(var_2) and that value is now the same as var_1 being the hex 0x12346 or decimal 74566
	store_var_01 = storeVariable01();

	// In the debug perspective, you can observe the value I am loading in the r0 register for verification of a successful store using STRB instruction.
	// I am changing the value stored in var_1 at adr_var1 to 74610 by storing only a byte of decimal value (114).
	// I load only (LDRB) from the address to verify the successful storing.
	store_var_02 = storeVariable02();

	// In the debug perspective, you can observe the value I am loading in the r3 register for verification of a successful store using STRH instruction.
	// I am changing the value stored in var_1 at adr_var1 to 65906 by storing only a half word of decimal value (370).
	// I load only (LDRH) from the address to verify the successful storing.
	store_var_03 = storeVariable03();

	pworddata=MywordAddress();
	worddata=getMywordContents();
	addToMywordContents(0xFFFFFFFF);
	initGPIOA5();
	while (1)
	{
		SWdelay(100000);
		togglePA5();
	}

}


