	IMPORT	postDelay
	IMPORT	osStack

    IMPORT	init_Stack

	IMPORT	post_initGpio
	IMPORT	post_initMem
	IMPORT	post_initKey
	IMPORT	dummyOs
	IMPORT  IRQ_Handler
	
	IMPORT  ICMR
	IMPORT  init_ICMR
	
	IMPORT  PSSR
	
	
	AREA boot ,CODE ,READONLY

	ENTRY
	
	B Reset_Handler
	B Undefined_Handler
	B SWI_Handler
	B Prefetch_Handler
	B DataAbort_Handler
	NOP
	B IRQ_Handler 
	B FIQ_Handler



Undefined_Handler	
	B	Undefined_Handler
	
SWI_Handler 
	B	SWI_Handler
	
Prefetch_Handler
	B	Prefetch_Handler
	

DataAbort_Handler
	B	DataAbort_Handler


FIQ_Handler
	B	FIQ_Handler			;Defined by yourself


Reset_Handler	
	
	;*************************
	;Check if run in the SDRAM
	;*************************
	MOV	R0,PC
	CMP R0,#0x00000040
	BNE Stack	
	
	;**************************
    ;Init Memory
    ;**************************            
	mov r14,pc
	ldr pc,=post_initMem

	;**************************
	;Init Stack
	;**************************
Stack
	mov r14,pc
	ldr pc,=init_Stack
	
	;**************************
	;Init GPIO
	;**************************	
	mov r14,pc
	ldr pc,=post_initGpio
    
    
 	;***************************
	;Enable & Set Interrupt
	;***************************
	mrs  r1, CPSR
	bic  r1, r1,#0x80
	msr  CPSR_c, r1
			
	ldr  r1, =ICMR
	ldr  r2, =init_ICMR
	str  r2,[r1]         ;Enable keyboard interrupt and ban all others
    
     
    ;**************************
    ;Init Key
    ;**************************
	mov r14,pc
	ldr pc,=post_initKey

	;**************************
	;Loop
	;**************************
	ldr r0,=postDelay
postLoop	
	sub r0,r0,#0x1
	cmp r0,#0x0
	bne postLoop


	;***************************
	;Turn on the light of board
	;***************************
	MOV	R0,	#0xa000000
	LDR	R2,	=0xCFFF
	STRH	R2,	[R0,#0]	


	ldr pc,=dummyOs
	END



