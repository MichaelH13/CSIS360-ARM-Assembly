#include <stdio.h>
#include <stdlib.h>
extern int isEmpty();
extern int isFull();
extern void push(int anInteger);
extern int pop();
extern int top();
extern int size();

int main()
{
    int i;
    
    printf("isEmpty -- Expect 1 : %d\n", isEmpty());
    
    printf("isFull -- Expect 0 : %d\n", isFull());
    
    for (i = 0; i < 5; i = i + 1)
    {
        push(i);
    }
    
    printf("isEmpty -- Expect 0 : %d\n", isEmpty());
    
    printf("isFull -- Expect 0 : %d\n", isFull());
    
    for (i = 4; i >= 0; i = i - 1)
    {
        printf("Pop -- Expect %d : %d\n", i, pop());
    }
    
    push(42);
    printf("Top -- Expect 42 : %d\n", top());
    pop();
    
    for (i = 0; i < 1024; i = i + 1)
    {
        // printf("Size -- Expect %d : %d\n", i, size());
        push(i);
    }
    
    printf("isEmpty -- Expect 0 : %d\n", isEmpty());
    
    printf("isFull -- Expect 1 : %d\n", isFull());
    
    return 0;
}