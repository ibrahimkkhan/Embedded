@;myDataOps.S wmh 2021-09-07 : ARM data instruction examples

@; --- characterize target syntax, processor
	.syntax unified				@; ARM Unified Assembler Language (UAL). 
								@; Code written using UAL can be assembled 
								@; for ARM, Thumb-2, or pre-Thumb-2 Thumb
	.thumb						@; but here we'll use thumb instructions only

@; --- constant definitions (locally symbol macros -- these do not use storage)
	.equ SILLY,0x12345678
	
@; --- _initialized_ RAM data in .data	(startup initializes these values)				
	.data						@; keyword '.data' starts the _initialized_ RAM data section
	.align 2					@; .align's argument is power of 2, so this pads memory to a word boundary
	.global Myword				@; makes variable 'myword' visible everywhere in the program (C and asm sources) 
Myword: .word  SILLY   			@; Myword is 32-bits which contains the value SILLY defined above 
var1: .word 74566
var2: .word 10
Myhalf:	.hword 0xABCD       	@; Myhalf is 16-bits and local to this source file
Mybyte: .byte  0x55   			@; Mybyte is 8-bits and local to this source file  
  
 @; --- _uninitialized_ RAM data in .bss (set to 0 on startup)	
	.bss						@; keyword 'bss' starts the _uninitialized_ RAM data section				 
	.align	2					@; pad to word-boundary
global_bss_begin:				@; marker for start of  global .bss variables
	.comm	Garray,256			@; 256 bytes of static storage starting at global label 'Garray'
	.comm	Gword,4				@; 4 bytes of static storage starting at global label 'Gword'
	.comm	Ghalf,2				@; 2 bytes of static storage starting at global label 'Ghalf'
	.comm	Gbyte,1				@; 1 byte of static storage starting at global label 'Gbyte'
	
	.align	2					@; pad to word-boundary
local_bss_begin:				@; marker for start of  local .bss variables
	.lcomm	Larray,256			@; 256 bytes of static storage starting at local label 'Larray'
	.lcomm	Lword,4				@; 4 bytes of static storage starting at local label 'L
	.lcomm	Lhalf,2				@; 2 bytes of static storage starting at local label 'L
	.lcomm	Lbyte,1				@; 1 byte of static storage starting at local label 'L
	
	
@; --- program memory and constant data
	.text						@;keyword '.text' starts the code section (in ROM)
	

	.global MywordAddress		@; uint32_t *MywordAddress(void); // C equivalent is a function returing a pointer
	.thumb_func 				@; make this function thumb-compatible
MywordAddress:	@;we are a 'leaf function' with no local variables, so don't need to save lr
	movw r0,#:lower16:Myword	@; get 32-bit _address_ of Myword in r0
	movt r0,#:upper16:Myword	@; ..
	bx lr						@; return to caller with Myword's address in r0



	.global getMywordContents 	@; uint32_t getMywordContents(); 
	.thumb_func					
getMywordContents:
	push {lr}					@; we are not a leaf function so we have to save the link register
	bl MywordAddress			@; get address of variable 'Myword' in r0
	ldr r0,[r0,#0]				@; read contents of memory at offset 0 from address 'Myword'
	pop {pc}					@; return to caller with contents of 'Myword' in r0

@; Homework Problem #3 -- as many ways of storing variables from register as you can devise	
@; there are only a few 'store' opcodes but there a _lot_ of addressing modes you should explore	
	.global addToMywordContents @; void addToMywordContents(int32_t addend);
	.thumb_func					
addToMywordContents:		
	push {lr}					@; we are not a leaf function so we have to save the link register
	push {r0}					@; save addend 'safely' (moving it to a scratch register is not safe --why?)
	bl MywordAddress			@; returns address of variable 'Myword' in r0
	bl getMywordContents		@; returns contents of variable 'Myword' in r0
	pop {r1}					@; get 'addend' back
	add r1,r0,r1				@; add addend to contents of 'Myword'
	bl MywordAddress			@; returns address of variable 'Myword' in r0	
	str r1,[r0,#0]				@; write incremented value at address 'Myword'
	pop {pc}					@; return to caller - we're a void function so r0 is don't-care

@; Homework Problem #1 -- as many ways of  loading constants to register as you can devise
@; here the constant is the address where the variable Myword is stored
	.global loadConstant01 		@; 
	.thumb_func					
loadConstant01: @;demo for Discussion
	push {lr}
	ldr r3, =0x12345
	pop {pc}

	.global loadConstant02 		@;
	.thumb_func
loadConstant02:
	push {lr}
	mov r2, r3
	pop {pc}

	.global loadConstant03 		@;
	.thumb_func
loadConstant03:
	push {lr}
	mvn r2, r3
	mvn r4, r2
	pop {pc}

.global loadConstant04 		@;
	.thumb_func
loadConstant04:
	push {lr}
	movt r3, #0x123
	pop {pc}



.global loadConstant05 		@;
	.thumb_func
loadConstant05:
	push {lr}
  	movw      r0, #0x5678      @ r0 = 0x00005678
    movt      r0, #0x1234      @ r0 = (r0 & 0x0000FFFF) | 0x12340000 (=0x12345678)
	pop {pc}


.global loadConstant06 		@;
	.thumb_func
loadConstant06:
	push {lr}
  	ldr r0, =0x0
  	ldr r1, =0X1
  	add r0,r1, #0x2
	pop {pc}


.global loadConstant07 		@;
	.thumb_func
loadConstant07:
	push {lr}
  	mov r0, #0x745
	pop {pc}



@; Homework Problem #2 -- as many ways of loading variables to register as you can devise
@; there are only a few 'load' opcodes but there a _lot_ of addressing modes you should explore
.global loadVariable01 		@;
	.thumb_func
loadVariable01:
	push {lr}
    ldr r0, adr_var1  @ load the memory address of var1 via label adr_var1 into R0
    ldr r0, [r0]      @ load the value at memory address found in R0 to register R0
	pop {pc}

.global loadVariable02 		@;
	.thumb_func
loadVariable02:
	push {lr}
	ldr r0, adr_var1  @ load the memory address of var1 via label adr_var1 into R0
	ldrb r1, [r0]	  @ load a byte value at memory address found in R0 to register R1

	pop {pc}

.global loadVariable03 		@;
	.thumb_func
loadVariable03:
	push {lr}
	ldr r0, adr_var1  @ load the memory address of var1 via label adr_var1 into R0
    ldr r1, adr_var2  @ load the memory address of var2 via label adr_var2 into R1
    ldr r2, [r0]      @ load the value (0x03) at memory address found in R0 to register R2
    str r2, [r1, #2]  @ address mode: offset. Store the value found in R2 (0x03) to the memory address found in R1 plus 2. Base register (R1) unmodified.
    str r2, [r1, #4]! @ address mode: pre-indexed. Store the value found in R2 (0x03) to the memory address found in R1 plus 4. Base register (R1) modified: R1 = R1+4
    ldr r3, [r1], #4  @ address mode: post-indexed. Load the value at memory address found in R1 to register R3. Base register (R1) modified: R1 = R1+4
	pop {pc}


.global loadVariable04 		@;
	.thumb_func
loadVariable04:
	push {lr}
	ldr r0, adr_var1  @ load the memory address of var1 via label adr_var1 into R0
    ldr r1, adr_var2  @ load the memory address of var2 via label adr_var2 into R1
    ldrh r5, [r0]
	pop {pc}


.global loadVariable05 		@;
	.thumb_func
loadVariable05:
	push {lr}
	ldr r0, adr_var1  @ load the memory address of var1 via label adr_var1 into R0
    ldr r1, adr_var2  @ load the memory address of var2 via label adr_var2 into R1
    ldrh r5, [r0]
	pop {pc}


@; Homework Problem #3 -- as many ways of storing variables to ROM or RAM as you can devise
.global storeVariable01 		@;
	.thumb_func
storeVariable01:
	push {lr}
	ldr r0, adr_var1  @ load the memory address of var1 via label adr_var1 into R0
    ldr r1, adr_var2  @ load the memory address of var2 via label adr_var2 into R1
    ldr r2, [r0]      @ load the value (0x123456) at memory address found in R0 to register R2
    str r2, [r1]      @ store the value found in R2 (0x123456) to the memory address found in R1
	ldr r0, [r1]      @ ldr the value found at the adr_var2 for verification
	pop {pc}

.global storeVariable02 		@;
	.thumb_func
storeVariable02:
	push {lr}
	mov r1, #370
	uxtb r3, r1
	ldr r1, adr_var1
	strb r3, [r1]
	ldrb r0, [r1]
	pop {pc}

.global storeVariable03 		@;
	.thumb_func
storeVariable03:
	push {lr}
	mov r0, #370
	ldr r1, adr_var1
	strh r0, [r1]
	ldrh r3, [r1]
	pop {pc}

adr_var1: .word var1
adr_var2: .word var2
@; --- constant data we're putting in ROM which you can access with some of your instructions

	.global	ROMdata				@; global label of target data area
	.align 2					@; pad memory if necessary to align on word boundary for word storage 
ROMdata:						@; start of test data area	
	.byte 0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F	@;bytes with contents = offset from start
	.byte 0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1A,0x1B,0x1C,0x1D,0x1E,0x1F	@;""
	.byte 0x20,0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,0x2E,0x2F	@;""
	.byte 0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F	@;""
	.byte 0x40,0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,0x4A,0x4B,0x4C,0x4D,0x4E,0x4F	@;""
	.byte 0x50,0x51,0x52,0x53,0x54,0x55,0x56,0x57,0x58,0x59,0x5A,0x5B,0x5C,0x5D,0x5E,0x5F	@;""
	.byte 0x60,0x61,0x62,0x63,0x64,0x65,0x66,0x67,0x68,0x69,0x6A,0x6B,0x6C,0x6D,0x6E,0x6F	@;""
	.byte 0x70,0x71,0x72,0x73,0x74,0x75,0x76,0x77,0x78,0x79,0x7A,0x7B,0x7C,0x7D,0x7E,0x7F	@;""
	.byte 0x80,0x81,0x82,0x83,0x84,0x85,0x86,0x87,0x88,0x89,0x8A,0x8B,0x8C,0x8D,0x8E,0x8F	@;""
	.byte 0x90,0x91,0x92,0x93,0x94,0x95,0x96,0x97,0x98,0x99,0x9A,0x9B,0x9C,0x9D,0x9E,0x9F	@;""
	.byte 0xA0,0xA1,0xA2,0xA3,0xA4,0xA5,0xA6,0xA7,0xA8,0xA9,0xAA,0xAB,0xAC,0xAD,0xAE,0xAF	@;""
	.byte 0xB0,0xB1,0xB2,0xB3,0xB4,0xB5,0xB6,0xB7,0xB8,0xB9,0xBA,0xBB,0xBC,0xBD,0xBE,0xBF	@;""
	.byte 0xC0,0xC1,0xC2,0xC3,0xC4,0xC5,0xC6,0xC7,0xC8,0xC9,0xCA,0xCB,0xCC,0xCD,0xCE,0xCF	@;""
	.byte 0xD0,0xD1,0xD2,0xD3,0xD4,0xD5,0xD6,0xD7,0xD8,0xD9,0xDA,0xDB,0xDC,0xDD,0xDE,0xDF	@;""
	.byte 0xE0,0xE1,0xE2,0xE3,0xE4,0xE5,0xE6,0xE7,0xE8,0xE9,0xEA,0xEB,0xEC,0xED,0xEE,0xEF	@;""
	.byte 0xF0,0xF1,0xF2,0xF3,0xF4,0xF5,0xF6,0xF7,0xF8,0xF9,0xFA,0xFB,0xFC,0xFD,0xFE,0xFF	@;"" , 256 bytes total
	 
	 .align 2					@;pad memory after data in ROM to align on word boundary for possible follow-on code
