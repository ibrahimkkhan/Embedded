//mainHW02.c wmh 2021-09-07 : prototype for '440 HW02 (data access exercise)

#include "stdint-gcc.h"	//for uint8_t, uint16_t, uint32_t  etc. 


//definitions in myDataOps.S
uint32_t *MywordAddress(void);	//returns pointer to variable 'Myword' defined in myDataOps.S
uint32_t getMywordContents(void);
uint32_t loadConstant01(void);
uint32_t loadConstant02(void);
uint32_t loadConstant03(void);
uint32_t loadConstant04(void);
uint32_t loadConstant05(void);
uint32_t loadConstant06(void);
uint32_t loadConstant07(void);
//uint32_t loadVariable01(void);
//uint32_t loadVariable02(void);
//uint32_t loadVariable03(void);
//uint32_t loadVariable04(void);
//uint32_t storeVariable01(void);
//uint32_t storeVariable02(void);
//uint32_t storeVariable03(void);




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
	uint32_t worddata,*pworddata, load_01, load_02, load_03, load_04,load_05, load_06, load_07;
	//load_var_01, load_var_02, load_var_03, load_var_04, store_var_01, store_var_02, store_var_03;			//C values we can watch in main()


	//HW - Problem 1
	//In the debug perspective, you can observe the value I am loading in the r3 register using LDR and the value stored is the hex 0x12345 or decimal 74565
	load_01 = loadConstant01();

	//In the debug perspective, you can observe the value I am loading in the r2 register using MOV and the value stored is the hex 0x12345 or decimal 74565
	load_02 = loadConstant02();

	//In the debug perspective, you can observe the value I am loading in the r4 register using 2 MVN instructions and the value stored is the hex 0x12345 or decimal 74565
	load_03 = loadConstant03();

	//In the debug perspective, you can observe the value I am loading in the r3 register using the MOVT instruction and the value stored is the hex 0x1232345 or decimal 19080005
	load_04 = loadConstant04();

	//In the debug perspective, you can observe the value I am loading in the r0 register using variety of MOVW and MOVT instructions and the value stored is the hex 0x12345678 or decimal 305419896
	load_05 = loadConstant05();

	//In the debug perspective, you can observe the value I am loading in the r0 register using variety of ADD and LDR instructions and the value stored is the hex 0x3 or decimal 3
	load_06 = loadConstant06();

	//In the debug perspective, you can observe the value I am loading in the r0 register using MOV instruction and the value stored is the hex 0x745 or decimal 1861
	load_07 = loadConstant07();


//	//HW - Problem 2
//	//In the debug perspective, you can observe the value I am loading in the r5 register using LDR to load the hex 0x12346 or decimal 74566 from the ROM
//	load_var_01 = loadVariable01();
//
//	//In the debug perspective, you can observe the value I am loading in the r1 register using LDRB to load the hex 0x46 or decimal 70 from the ROM
//	load_var_02 = loadVariable02();
//
//	//In the debug perspective, you can observe the value I am loading in the r2 and r3 register using variety of STR and LDR instructions and the value stored is the hex 0x12346 or decimal 74566
//	load_var_03 = loadVariable03();
//
//	//In the debug perspective, you can observe the value I am loading in the r5 register using variety of LDRH instruction and the value stored is the hex 0x2346 or decimal 9030
//	load_var_04 = loadVariable04();
//
//
//
//	//HW - Problem 3
//	// In the debug perspective, you can observe the value I am loading in the r0 for verification of a successful store using STR instruction.
//	// First I load both address of both var_1 and var_2 into r0 and r1, respectively.
//	// I then load the value found at address stored in r0(var_1) into r2.
//	// I then store that value into into the address found in r1(var_2).
//	//Finally, I load the value found at address stored at r1(var_2) and that value is now the same as var_1 being the hex 0x12346 or decimal 74566
//	store_var_01 = storeVariable01();
//
//	// In the debug perspective, you can observe the value I am loading in the r0 regiter for verification of a successful store using STRB instruction.
//	// I am changing the value stored in var_1 at adr_var1 to 74610 by storing only a byte of decimal value (114).
//	// I load only (LDRB) from the address to verify the successful storing.
//	store_var_02 = storeVariable02();
//
//	// In the debug perspective, you can observe the value I am loading in the r3 register for verification of a successful store using STRH instruction.
//	// I am changing the value stored in var_1 at adr_var1 to 65906 by storing only a half word of decimal value (370).
//	// I load only (LDRH) from the address to verify the successful storing.
//	store_var_03 = storeVariable03();

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


