/* STRUCTURE OF THE SYMBOL TABLE ELEMENTS */
typedef struct sym_entry{
	//int index; //not really needed
	char *name; //name of symbol
	unsigned kind; //type of symbol
	unsigned type; //type of value of symbol
	unsigned attr1; //additional attributes of symbol
	unsigned attr2; //additional attributes of symbol
	struct sym_entry *next;
} SYMBOL_ENTRY;

/* INT TABLE */
void init_symtab(SYMBOL_ENTRY **head);
/* INSERT A SYMBOL INTO THE TABLE */
int insert_symbol(SYMBOL_ENTRY **head, char *name, unsigned kind, unsigned type, unsigned attr1, unsigned attr2);

/* FUNCTION FOR SEARCHING FOR SYMBOL IN SYMBOL TABLE */
int lookup_symbol(SYMBOL_ENTRY **head, char *name);

/* METHODS FOR UPDATING ELEMENTS IN SYMBOL TABLE */
void set_name(SYMBOL_ENTRY **head, int index, char *name);
char* get_name(SYMBOL_ENTRY **head, int index);
void set_kind(SYMBOL_ENTRY **head, int index, unsigned kind);
unsigned get_kind(SYMBOL_ENTRY **head, int index);
void set_type(SYMBOL_ENTRY **head, int index, unsigned type);
unsigned get_type(SYMBOL_ENTRY **head, int index);
void set_attr1(SYMBOL_ENTRY **head, int index, unsigned attr1);
unsigned get_attr1(SYMBOL_ENTRY **head, int index);
void set_attr2(SYMBOL_ENTRY **head, int index, unsigned attr2);
unsigned get_attr2(SYMBOL_ENTRY **head, int index);


/* REMOVE SUBTABLE -- DELETES EVERYTHING AFTER begin_index */
void clear_symbols(SYMBOL_ENTRY **head, unsigned begin_index);

/* DISPLAY SYMBOL TABLE */
void print_symtab(SYMBOL_ENTRY **head);

/* DELETE TABLE -- DELETES EVERYTHING BELOVE head */
void destroy_list(SYMBOL_ENTRY **head);