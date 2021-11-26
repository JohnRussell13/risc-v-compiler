/* STRUCTURE OF THE SYMBOL TABLE ELEMENTS */
typedef struct sym_entry{
	char *name; //name of symbol
	unsigned kind; //type of symbol
	unsigned type; //type of value of symbol
	unsigned attr1; //additional attributes of symbol
	unsigned attr2; //additional attributes of symbol
}SYMBOL_ENTRY;

/* FUNCTIONS TO WORK WITH SYMBOL TABLE */
/* FUNCTION TO INSERT SYMBOL IN SYMBOL TABLE */
int insert_symbol(char *name,unsigned kind, unsigned type,unsigned attr1, unsigned attr2);

/* FUNCTION TO INSERT NEW LITERAL IN SYMBOL TABLE */
int insert_literal(char *str, unsigned type);

/* FUNCTION FOR SEARCHING FOR SYMBOL IN SYMBOL TABLE */
int lookup_symbol(char *name, unsigned kind);

/*FUNCTION FOR SEARCHING LITERAL IN SYMBOL TABLE */
int lookup_literal(char *name, unsigned type);

/* METHODS FOR UPDATING ELEMENTS IN SYMBOL TABLE */
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

/* REMOVE SYMBOL FROM SYMBOL TABLE */
void clear_symbols(unsigned begin_index);

/* DISPLAY SYMBOL TABLE */
void print_symtab(void);

/* INIT SYMBOL TABLE */
void init_symtab(void);

/* REMOVE ALL ELEMENTS FROM SYMBOL TABLE */
void clear_symtab(void);
