#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"
#include "definitions.h"

void init_symtab(SYMBOL_ENTRY **head){
	*head = NULL;
}

int insert_symbol(SYMBOL_ENTRY **head, char *name, unsigned kind, unsigned type, unsigned attr1, unsigned attr2){
	int i = 0;
	SYMBOL_ENTRY **temp;
	temp = head;
    SYMBOL_ENTRY *new = (SYMBOL_ENTRY *)malloc(sizeof(SYMBOL_ENTRY));
    if (new == NULL) {
        printf("Not enough RAM!\n");
        exit(1);
    }

	strcpy(new->name, name);
	new->kind = kind;
	new->type = type;
	new->attr1 = attr1;
	new->attr2 = attr2;
	new->next = NULL;

	while(*temp != NULL){
		temp = &((*temp)->next);
		i++;
	}
	*temp = new;
	
	return i;
}

int lookup_symbol(SYMBOL_ENTRY **head, char *name){
	int i = 0;
	SYMBOL_ENTRY **temp;
	temp = head;
	while(1){
		if(*temp == NULL){
			return -1;
		}
		if(strcmp((*temp)->name, name) == 0){
			return i;
		}
		temp = &((*temp)->next);
		i++;
	}

	return i;
}

/* WHEN IS THIS NEEDED??? */
void set_name(SYMBOL_ENTRY **head, int index, char *name){
	int i;
	SYMBOL_ENTRY **temp;
	temp = head;

	for(i = 0; i < index; i++){
		temp = &((*temp)->next);
	}
	(*temp)->name = name;
}
char* get_name(SYMBOL_ENTRY **head, int index){
	int i;
	SYMBOL_ENTRY **temp;
	temp = head;

	for(i = 0; i < index; i++){
		temp = &((*temp)->next);
	}
	return (*temp)->name;
}
void set_kind(SYMBOL_ENTRY **head, int index, unsigned kind){
	int i;
	SYMBOL_ENTRY **temp;
	temp = head;

	for(i = 0; i < index; i++){
		temp = &((*temp)->next);
	}
	(*temp)->kind = kind;
}
unsigned get_kind(SYMBOL_ENTRY **head, int index){
	int i;
	SYMBOL_ENTRY **temp;
	temp = head;

	for(i = 0; i < index; i++){
		temp = &((*temp)->next);
	}
	return (*temp)->kind;
}
void set_type(SYMBOL_ENTRY **head, int index, unsigned type){
	int i;
	SYMBOL_ENTRY **temp;
	temp = head;

	for(i = 0; i < index; i++){
		temp = &((*temp)->next);
	}
	(*temp)->type = type;
}
unsigned get_type(SYMBOL_ENTRY **head, int index){
	int i;
	SYMBOL_ENTRY **temp;
	temp = head;

	for(i = 0; i < index; i++){
		temp = &((*temp)->next);
	}
	return (*temp)->type;
}
void set_attr1(SYMBOL_ENTRY **head, int index, unsigned attr1){
	int i;
	SYMBOL_ENTRY **temp;
	temp = head;

	for(i = 0; i < index; i++){
		temp = &((*temp)->next);
	}
	(*temp)->attr1 = attr1;
}
unsigned get_attr1(SYMBOL_ENTRY **head, int index){
	int i;
	SYMBOL_ENTRY **temp;
	temp = head;

	for(i = 0; i < index; i++){
		temp = &((*temp)->next);
	}
	return (*temp)->attr1;
}
void set_attr2(SYMBOL_ENTRY **head, int index, unsigned attr2){
	int i;
	SYMBOL_ENTRY **temp;
	temp = head;

	for(i = 0; i < index; i++){
		temp = &((*temp)->next);
	}
	(*temp)->attr2 = attr2;

}
unsigned get_attr2(SYMBOL_ENTRY **head, int index){
	int i;
	SYMBOL_ENTRY **temp;
	temp = head;

	for(i = 0; i < index; i++){
		temp = &((*temp)->next);
	}
	return (*temp)->attr2;
}

void clear_symbols(SYMBOL_ENTRY **head, unsigned begin_index){
	int i;
	SYMBOL_ENTRY **temp;
	temp = head;

	for(i = 0; i < index; i++){
		temp = &((*temp)->next);
	}
	
	destroy_list(temp);
}

void print_symtab(SYMBOL_ENTRY **head){
	int i = 0;
	SYMBOL_ENTRY **temp;
	temp = head;
	while(*temp != NULL){
		printf("INDEX: %d;\tNAME: %s;\tKIND: %d;\t", i, (*temp)->name, (*temp)->kind);
		printf("TYPE %d;\tATTR1: %d;\tATTR2: %d\n", (*temp)->type, (*temp)->attr1, (*temp)->attr2);

		temp = &((*temp)->next);
	}
}

/* DON"T KNOW REALLY HOW TO AVOID RECURSION IN THIS ONE... MAYBE TWO WAY LIST? IS IT WORTH IT? */
void destroy_list(SYMBOL_ENTRY **head){
    if(*head != NULL) {
        destroy_list(&((*head)->next));
        free(*head);
        *head = NULL;
    }
}
