#include <stdio.h>
#include "symtab.h"

/* gcc test.c symtab.c */

/* WORKING FINE */
int main(){
    SYMBOL_ENTRY **head;
    init_symtab(head);
    destroy_list(head);
}