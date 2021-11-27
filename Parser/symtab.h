#ifndef _SYMTAB_H
#define _SYMTAB_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "definitions.h"

/* STRUCTURE OF THE SYMBOL TABLE ELEMENTS */
typedef struct sym_entry{
	//int index; //not really needed
	char name[SYMBOL_TABLE_LENGTH]; //name of symbol
	unsigned kind; //type of symbol
	unsigned type; //type of value of symbol
	unsigned value;
	unsigned attr[MAX_PARAMS]; //additional attributes of symbol
	struct sym_entry *next;
} SYMBOL_ENTRY;

int init_attr(int *attr);

/* INT TABLE */
void init_symtab(SYMBOL_ENTRY **head);
/* INSERT A SYMBOL INTO THE TABLE */
int insert_symbol(SYMBOL_ENTRY **head, char *name, unsigned kind, unsigned type, unsigned value, unsigned attr[]);

/* FUNCTION FOR SEARCHING FOR SYMBOL IN SYMBOL TABLE */
int lookup_symbol(SYMBOL_ENTRY **head, char *name);

/* METHODS FOR UPDATING ELEMENTS IN SYMBOL TABLE */
void set_name(SYMBOL_ENTRY **head, int index, char *name);
char* get_name(SYMBOL_ENTRY **head, int index);
void set_kind(SYMBOL_ENTRY **head, int index, unsigned kind);
unsigned get_kind(SYMBOL_ENTRY **head, int index);
void set_type(SYMBOL_ENTRY **head, int index, unsigned type);
unsigned get_type(SYMBOL_ENTRY **head, int index);
void set_value(SYMBOL_ENTRY **head, int index, unsigned value);
unsigned get_value(SYMBOL_ENTRY **head, int index);
void set_attr(SYMBOL_ENTRY **head, int index, unsigned attr[]);
unsigned *get_attr(SYMBOL_ENTRY **head, int index);

/* TOTAL NUMBER OF SYMBOLS */
unsigned get_total(SYMBOL_ENTRY **head);


/* REMOVE SUBTABLE -- DELETES EVERYTHING AFTER begin_index */
void clear_symbols(SYMBOL_ENTRY **head, unsigned begin_index);

/* DISPLAY SYMBOL TABLE */
void print_symtab(SYMBOL_ENTRY **head);

/* DELETE TABLE -- DELETES EVERYTHING BELOVE head */
void destroy_list(SYMBOL_ENTRY **head);

#endif
