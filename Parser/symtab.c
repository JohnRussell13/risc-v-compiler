#include <stdio.h>
#include <stdlib.h>
#include "symtab.h"
#include "definitions.h"

int insert_symbol(char *name,unsigned kind, unsigned type,unsigned attr1, unsigned attr2){

}

int insert_literal(char *str, unsigned type);

int lookup_symbol(char *name, unsigned kind){
	//Check if symbol type exists
	int idx;

	switch(kind){
		case(NO_KIND):{
			idx = get_kind(NO_KIND);
			break;
		}
		case(REG):{
			idx = get_kind(REG);
			break;
		}
		case(LIT):{
			idx = get_kind(LIT);
			break;
		}
		case(FUN):{
			idx = get_kind(FUN);
			break;
		}
		case(VAR):{
			idx = get_kind(VAR);
			break;
		}
		case(PAR):{
			idx = get_kind(PAR);
			break;
		}
		default:
			return -1;
	}
	return idx;
}

int lookup_literal(char *name, unsigned type);

void set_name(int index, char *name);
char* get_name(int index);
void set_kind(int index, unsigned kind);
unsigned get_kind(int index);
void set_type(int index, unsigned type);
unsigned get_type(int index);
void set_attr1(int index, unsigned attr1);
unsigned get_attr1(int index);
void set_attr2(int index, unsigned attr2);
unsigned get_attr2(int index);

void clear_symbols(unsigned begin_index);

void print_symtab(void);

void init_symtab(void);

void clear_symtab(void);
