#include <stdio.h>
#include "symtab.h"

int main(){
    SYMBOL_ENTRY *head;
    init_symtab(&head);

    insert_symbol(&head, "asd", 1, 1, 1, 1);

    print_symtab(&head);
    return 0;
}