/* -- intStack.s */
/* r0: Used for returns */
/* r1: Used for storing the address of the array (address_of_stack) */
/* r2: Used to keep track of the current count of elements (address_size_of_stack) */

.data

/* skip 1024 * 4 bytes so we have enough room to store 
1024 32-bit integers */
.balign 4
the_stack: .skip 4096

.balign 4
size_of_stack: .word 4

.balign 4
return: .word 0

.text


/*main:*/
	/*ldr r1, address_of_return  r1 <- &address_of_return */
  	/*str lr, [r1]		     *r1 <- lr */
	/*bl isEmpty */
	/*bl putchar */
	/*ldr r1, address_of_return  r1 <- &address_of_return */
  	/*ldr lr, [r1]		     lr <- *r1 */
  	/*bx lr			     return from main */

/* Returns a comparision for equality between the sp */
/* and the bottom of the stack */
.func
isEmpty:
	ldr r1, address_of_stack
	ldr r1, [r1]
	ldr r2, address_size_of_stack
	ldr r2, [r2]
	cmp r1, r2
	bx lr 
.endfunc

/* Returns a comparision for equality between the sp and */
/* the top of the stack */
.func
isFull:
	/* Compare the current top of the stack to the address */
	/* of the stack incremented by 4096 bytes */
	ldr r1, address_of_stack
	ldr r1, [r1]
	ldr r2, address_size_of_stack
	ldr r2, [r2]
	add r2, #4096
	cmp r1, r2
	bx lr 
.endfunc

/* Expects r0 to hold the integer to push */
;push: 
	/* Iterate our address_size_of_stack */
	;ldr r1, address_of_stack
	;ldr r2, address_size_of_stack
	;add r2, #1 				/* r2 <- r2 + 1 */
	;add r1, r1, r2, LSL #2  /* r3 ← r1 + (r2*4) */
	
	/*ldr r0, [address_of_stack_top, +#4]*/
	/*str r0, address_of_stack_top */
	
	/* Put the int in r0 at the new top of our stack */
	;str r0, [r1] /* *r1 ← r0 */
	/*mov r0, [address_of_stack_top] */
	
	;bx lr
	
/* Remove top element, store in r0, and decrement stack */
;pop:
	;ldr r1, address_of_stack
	;ldr r2, address_size_of_stack
	;add r1, r1, r2, LSL #2  /* r1 ← r1 + (r2*4) */
	;str r0, [r1]
	;sub r2, #1
	;bx lr 

/* Store top element in r0 */
;top:
	/* Store top element in r0 */
	;ldr r1, address_of_stack
	;ldr r2, address_size_of_stack
	;add r1, r1, r2, LSL #2  /* r1 ← r1 + (r2*4) */
	;str r0, [r1]
	;bx lr 
	
/* Store stack size in r0 */
;size:
	;ldr r2, address_size_of_stack
	;ldr r0, [r2] /* r0 <- *r2 */
	;bx lr
	
address_of_stack: .word the_stack
address_size_of_stack: .word size_of_stack
address_of_return: .word return

.global isEmpty
.global isFull
.global putchar
.global getchar
