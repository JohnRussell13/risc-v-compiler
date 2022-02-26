#include "stack.h"

void push(char *reg, int size){
	printf("sw %s, 0, sp\n", reg);
	printf("addi sp, sp, -%d\n", 4*size);
}

void pop(char *reg, int size){
	printf("addi sp, sp, %d\n", 4*size);
	printf("lw %s, 0, sp\n", reg);
}