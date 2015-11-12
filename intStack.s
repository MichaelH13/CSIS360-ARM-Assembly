/* -- intStack.s */
/* r0: Used for params/returns. */
/* r1: Used for storing the address of the array. */
/* r2: Used to keep track of the current count of elements. */

.data

/* Skip 1024 * 4 bytes so we have enough room to store */
/* 1024 32-bit integers. */
.balign 4
the_stack: .skip 4096

.balign 4
size_of_stack: .word 0

.text

/* Addresses of variables */
address_of_stack: .word the_stack
address_size_of_stack: .word size_of_stack


/* Function Delcarations */
.global isEmpty
.global isFull
.global push
.global pop
.global top
.global size


/* Helper function to reduce code size. */
/* Takes r1 as an argument to compare stack size to. */
.func compareStack
compareStack:
    /* Get the address_size_of_stack and load the value into r2. */
	ldr r2, address_size_of_stack
	ldr r2, [r2]
	
	/* Compare r0 and r2. */
	cmp r0, r2
	
	/* If equal put 1 in r0, otherwise put 0 in r0. */
	moveq r0, #1
	movne r0, #0
	
	/* Return */
	bx lr 
.endfunc


/* Returns a comparision for equality between the size_of_stack and 0. */
/* Returns true if size_of_stack == 0, 1 otherwise. */
.func isEmpty
isEmpty:
    /* Load immediate 0 into r0. */
	ldr r0, =0
	
	/* Save lr, call compareStack, restore lr. */
	push {lr}
	bl compareStack
	pop {lr}
	
	/* Return */
	bx lr
.endfunc


/* Returns a comparision for equality between the size_of_stack and 1024. */
/* Returns true if size_of_stack == 1024, 1 otherwise. */
.func isFull
isFull:
	/* Load immediate 1024 into r0. */
	ldr r0, =1024
	
	/* Save lr, call compareStack, restore lr. */
	push {lr}
	bl compareStack
	pop {lr}
	
	/* Return */
	bx lr
.endfunc


/* Expects r0 to hold the integer to push to the stack. */
.func push
push: 
	/* Load address_of_stack into r1. */
	ldr r1, address_of_stack
	
	/* Get the address_size_of_stack and load the value into r2. */
	ldr r3, address_size_of_stack
	ldr r2, [r3]
	
	/* Skip the size of our stack (r2 * 4). */
	/* Then add the address of our stack to the result. */
	/* Place the result in r1. */
	add r1, r1, r2, LSL #2  /* r1 ← r1 + (r2*4) */
	
	/* Put the int in r0 at the new top of our stack. */
	str r0, [r1] /* *r1 ← r0 */
	
	/* Increment the stack. */
	/*ldr r2, address_size_of_stack*/
	/*ldr r2, [r2]*/
	/*mov r3, #1*/
	/*add r3, r2*/
	add r2, #1
	/*ldr r3, address_size_of_stack*/
	str r2, [r3]
	
	/* Return */
	bx lr
.endfunc


/* Remove top element, load into r0, and decrement size_of_stack. */
.func pop
pop:
	/* Load address_of_stack into r1. */
	ldr r1, address_of_stack
	
	/* Load the value at address_size_of_stack into r2. */
	ldr r3, address_size_of_stack
	ldr r2, [r3]
	
	/* Decrement the size_of_stack by one since we have "removed" the value. */
	sub r2, #1
	
	/* Skip the size of our stack (r2 * 4). */
	/* Then add the address of our stack to the result. */
	/* Place the result in r1. */
	add r1, r1, r2, LSL #2          /* r1 ← r1 + (r2*4) */
	ldr r0, [r1]                    /* r0 ← *r1 */
	
	/* Store the address of the stack in r3, */
	/* then store the value of r2 at [r3]. */
	/*ldr r3, address_size_of_stack*/
	str r2, [r3]
	
	/* Return */
	bx lr 
.endfunc


/* Load top element into r0. */
.func top
top:
	/* Load address_of_stack into r1. */
	ldr r1, address_of_stack
	
	/* Load the value at address_size_of_stack into r2. */
	ldr r2, address_size_of_stack
	ldr r2, [r2]
	sub r2, #1
	
	/* First, skip the size of our stack in r2 */
	/* Then add the address of our stack to the result */
	/* And finally place the result in r1 */
	add r1, r1, r2, LSL #2  /* r1 ← r1 + (r2 * 4) */
	ldr r0, [r1] /* r0 ← *r1 */
	
	/* Return */
	bx lr
.endfunc


/* Load stack size into r0. */
.func size
size:
	/* Load the value at address_size_of_stack into r0. */
	ldr r2, address_size_of_stack
	ldr r0, [r2] /* r0 <- *r2 */
	
	/* Return */
	bx lr
.endfunc

