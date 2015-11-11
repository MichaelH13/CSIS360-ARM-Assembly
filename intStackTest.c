#include <stdio.h>

extern int isFull();
extern int isEmpty();
extern void push(int i);

int main()
{	
	printf("isEmpty: %d\n", isFull());
	printf("isFull: %d\n", isEmpty());
	push(1);
	printf("isEmpty: %d\n", isFull());
	printf("isFull: %d\n", isEmpty());

	return 0;
}