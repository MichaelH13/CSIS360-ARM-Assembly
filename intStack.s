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
size_of_stack: .word 0

.balign 4
return: .word 0

.text

.global main
main:
	ldr r1, address_of_return 	/* r1 <- &address_of_return */
  	str lr, [r1]		   		/* *r1 <- lr */
  	
  	mov r0, #10
  	bl isEmpty
  	
  	mov r0, #5
  	bl push
  	mov r0, #10
  	bl top
  	mov r0, #10
  	bl size
  	mov r0, #10
  	bl isEmpty
  	
  	mov r0, #3
  	bl push
  	mov r0, #10
  	bl top
  	mov r0, #10
  	bl size
  	mov r0, #10
  	bl isEmpty
  	bl pop
  	mov r0, #10
  	bl top
  	mov r0, #10
  	bl pop
  	
  	bl isFull
  	bl isEmpty
  	
  	b main
  	
	ldr r1, address_of_return 	/* r1 <- &address_of_return */
  	ldr lr, [r1]		    	/* lr <- *r1 */
  	bx lr			   			/* return from main */

/* Returns a comparision for equality between the sp */
/* and the bottom of the stack */
.func
isEmpty:
	ldr r1, =0
	ldr r2, address_size_of_stack
	ldr r2, [r2]
	cmp r1, r2
	moveq r0, #1
	movne r0, #0
	bx lr 
.endfunc

/* Returns a comparision for equality between the sp and */
/* the top of the stack */
.func
isFull:
	/* Compare current address_size_of_stack to 1024 */
	/* If equal return 1, else return 0 */
	ldr r1, =1024
	ldr r2, address_size_of_stack
	ldr r2, [r2]
	cmp r1, r2
	moveq r0, #1
	movne r0, #0
	bx lr 
.endfunc

/* Expects r0 to hold the integer to push */
.func
push: 
	/* Load address_of_stack into r1 */
	ldr r1, address_of_stack
	
	/* Get the address_size_of_stack and load the value into r2 */
	ldr r2, address_size_of_stack
	ldr r2, [r2]
	
	/* First, skip the size of our stack in r2 */
	/* Then add the address of our stack to the result */
	/* And finally place the result in r1 */
	add r1, r1, r2, LSL #2  /* r3 ← r1 + (r2*4) */
	
	/* Put the int in r0 at the new top of our stack */
	str r0, [r1] /* *r1 ← r0 */
	
	/* Increment the stack */
	mov r3, #1
	add r3, r2
	ldr r2, address_size_of_stack
	str r3, [r2]
	
	bx lr
.endfunc

.func
/* Remove top element, store in r0, and decrement stack */
pop:
	/* Call top instead of rewriting code. Not faster...prettier. */
	push {lr}
	bl top
	
	/* Decrement the size_of_stack by one since we have "removed" the value */
	mov r3, #1
	sub r2, r3
	
	/* Store the address of the stack in r3, */
	/* then put the value of r2 into r3 */
	ldr r3, address_size_of_stack
	str r2, [r3]
	pop {lr}
	bx lr 
.endfunc

.func
/* Store top element in r0 */
top:
	/* Load address_of_stack into r1 */
	ldr r1, address_of_stack
	
	/* Load the value at address_size_of_stack into r2 */
	ldr r2, address_size_of_stack
	ldr r2, [r2]
	
	/* First, skip the size of our stack in r2 */
	/* Then add the address of our stack to the result */
	/* And finally place the result in r1 */
	add r1, r1, r2, LSL #2  /* r1 ← r1 + (r2*4) */
	ldr r0, [r1] /* r0 ← *r1 */
	bx lr
.endfunc

.func
/* Store stack size in r0 */
size:
	ldr r2, address_size_of_stack
	ldr r0, [r2] /* r0 <- *r2 */
	bx lr
.endfunc

address_of_stack: .word the_stack
address_size_of_stack: .word size_of_stack
address_of_return: .word return

.global isEmpty
.global isFull
.global push
.global pop
.global top
.global size
