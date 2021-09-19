@; userLED.S wmh 2021-08-19 : functions to initialize and control the green LED at port pin PA5 on the Nucleo-L476 board
@; uppercase 'S' file extension tells gcc to interpret both assembler ('.equ' etc) and C ('#define' etc) preprocessor definitions  

	@;constants derived from those defined in the STM32L476 manual rev9 June 2021 (RM0351, en.DM00083560.pdf)
	.equ	RCC_BASE,0x40021000 	@;origin of RCC register struct (pg 79 of the manual)
	.equ 	RCC_AHB2ENR,0x4C		@;peripheral clock enable register offset (pg 251 of the manual)
	.equ	GPIOAEN,0				@;GPIOA peripheral clock enable bit offset (pg 251 of the manual)

	.equ	GPIOA_BASE,0x48000000	@;origin of GPIOA register struct (pg 78 of the manual)
	.equ	MODER,	0x00			@;GPIOA configuration register offsets (pg 312 of the manual)      
	.equ	OTYPER,	0x04	    	@; .. 
	.equ	OSPEEDR,0x08	    	@; .. 
	.equ	OPUPDR,	0x0C	    	@; .. 	
	.equ	IDR,	0x10	    	@; .. 	      
	.equ	ODR,	0x14	    	@; .. 	
	.equ	BSRR,	0x18	    	@; .. 	      
	.equ	LCKR,	0x1C	    	@; .. 	
	.equ	AFRL,	0x20	    	@; .. 	
	.equ	AFRH,	0x24	    	@; .. 	
	.equ	BRR,	0x28	    	@; .. 
	.equ	ASCR,	0x2C	    	@; .. 

	.equ	PA5,	5				@; bit offset to PA5 (LD2 LED control)
	
	.syntax unified				@; ARM Unified Assembler Language (UAL) is allowed 
	.thumb						@; we're using thumb instructions only

	.text
	.global initGPIOA5			@; make function visible everywhere
	.thumb_func					@; make sure bit 0 is set in any absolute indirect references to this function
initGPIOA5: @;configure port bit PA5 as GPIO output with high-speed push/pull drivers and no pu/pd. 
	@; set port clock enable bit in RCC_AHB2ENR (pg 252 of the manual)
	ldr r3,=RCC_BASE			@;load RCC struct address
	ldr r2,[r3,#RCC_AHB2ENR]	@;get current values of device enables
	orr r2,#(1<<GPIOAEN)		@;enable port
	str r2,[r3,#RCC_AHB2ENR]	@; ..
	
	@; configure PA5 as an output (pg 304 of the manual)
	ldr r3,=GPIOA_BASE			@;load GPIOA struct address
	ldr r2,[r3,#MODER]			@;get current mode values of port
	bic r2,#(3<<(2*PA5))		@;clear current mode value of port bit
	orr	r2,#(1<<(2*PA5))		@;set new mode value of port bit to general purpose output
	str r2,[r3,#MODER]			@; ..
	
	@; configure output as push/pull (pg 304 of the manual)
	ldr r2,[r3,#OTYPER]			@;get current push/pull settings of port
	bic r2,#(1<<(1*PA5))		@;clear current control value of port bit (make output push/pull) 
	str r2,[r3,#OTYPER]			@; ..

	@; configure output as high speed (pg 304 of the manual)
	ldr r2,[r3,#OSPEEDR]		@;get current speed values of port
	bic r2,#(3<<(2*PA5))		@;clear current speed value of port bit
	orr	r2,#(2<<(2*PA5))		@;set new speed of port bit as high speed
	str r2,[r3,#OSPEEDR]		@; ..

	@; configure output as no pullup, pulldown (pg 305 of the manual)
	ldr r2,[r3,#OPUPDR]			@;get current pu/pd settings of port
	bic r2,#(3<<(2*PA5))		@;clear current pupd value of port bit (=no pu/pd)
	str r2,[r3,#OPUPDR]			@; ..

	bx lr						@; return to caller (leaf function does not require stack frame save/restore) 

	
	.global togglePA5
	.thumb_func
togglePA5: @;flip PA5 to its opposite state
	ldr r3,=GPIOA_BASE			@;load GPIOA struct address
	ldr r2,[r3,#IDR]			@;get current port values
	eor r2,r2,#(1<<(1*PA5))		@;toggle port bit 
	str r2,[r3,#ODR]			@;update port values
	
	bx lr						@; return to caller
