%{
    #include <stdio.h>
    #include "definitions.h"
    #include "symtab.h"
    #include "stack.h"

    /* FLEX/BISON REQUIRED */
    int yyparse(void);
    int yylex(void);
    int yyerror(char *s);
    extern int yylineno;
    int error_count;

    /* USED VARIABLES */
    int lab_cnt = 0; // LABEL COUNTER
    int for_depth = 0; // FOR LABEL
    int for_layer[LOOP_DEPTH];  // FOR LABEL
    int while_depth = 0; // WHILE LABEL
    int while_layer[LOOP_DEPTH]; // WHILE LABEL
    int if_depth = 0; // WHILE LABEL
    int if_layer[LOOP_DEPTH]; // WHILE LABEL
    int args = 1; // FUNCTION ARGUMENTS COUNTE
    int sq_arg = 0; // ARRAY DIM INDEXR
    int sq_mem = 0; // ARRAY DIM INDEX
    int sq_subarg = 0; // ARRAY DIM INDEX
    int sq_mul = 0; // ARRAY DIM PRODUCT
    unsigned sq_size; // ARRAY SIZE
    unsigned *dims; // ARRAY
    int stack[STACK_DEPTH];
    int sp = 0;

    /* SYM_TAB HELPER VARIABLES */
    char tab_name[LOOP_DEPTH];
    int tab_ind; // INDEX
    int tab_type; // TYPE
    int tab_kind; // KIND
    int func_ind = 0; // FUNCTION INDEX
    SYMBOL_ENTRY *head; // TABLE POINTER
%}

/* POSSIBLE TYPES */
%union {
    int i;
    char *s;
    int ii[2];
    int iii[3];
    unsigned d[MAX_DIM];
}

/* TOKENS */
%token _IF
%token _ELSE
%token _SWITCH
%token _CASE
%token _DEFAULT
%token _BREAK
%token _CONTINUE
%token _RETURN
%token _WHILE
%token _DO
%token _FOR

%token _DEF
%token _NULL
%token _CONST

%token <i> _TYPE

%token _LPAREN
%token _RPAREN
%token _LSQBRACK
%token _RSQBRACK
%token _LBRACKET
%token _RBRACKET
%token _SEMICOLON
%token _COMMA
%token _COLON
%token _ASSIGN

%token _PLUS
%token _MINUS
%token _DIV
%token _MOD
%token _SR
%token _SL
%token _BOR
%token _BXOR
%token _AND
%token _OR

%token _STAR
%token _AMP

%token <i> _ITER
%token <i> _RELOP

%token <s> _ID

%token <s> _INT_NUMBER
%token <s> _UINT_NUMBER
%token <s> _HEX_NUMBER

/* TYPE OF VALUE THAT A GIVEN RULE HAS TO RETURN */
/* POSSIBLE TYPES ARE GIVEN IN THE %union ABOVE */
/* $$ IS USED TO SET A VALUE */
%type <i> type literal function_call ar_op log_op num_exp helper_num_exp helper_cond helper_cond_simp mem_map data helper_assign
%type <ii> exp
%type <iii> helper_exp
%type <d> array_member_definition

/* SPECIAL RULES */
%nonassoc ONLY_IF   /* NOT ALWAYS; JUST IN THE CASE THAT THERE IS NO ELSE (HENCE NO _ - ONLY_IF IS NOT A TOKEN) */
%nonassoc _ELSE

%start program

%%
/*
*   USED REGS:
*       ra  -  RETURN ADDRESS FOR JUMPING BACK FROM FUNCTION
*       sp  -  STACK POINTER
*       t0  -  FOR MEMORY STORE
*       t1  -  FOR VALUE OF SOME NUMERICAL EXPRESSION
*       tn  -  TEMP REGS
*       t5  -  ARRAY DIMENSION SIZE
*       t6  -  MAIN START
*       s0  -  FUNCTION RETURN VALUE LOCATION
*       sn  -  TEMP REGS FOR ARRAY MANIPULATION
*       s4  -  SYMBOL POINTER
*       s5  -  TEMP REG FOR POINTER ASSIGNMENT
*       an  -  TEMP REG FOR ARRAY DIMENSIONS
*       s11 -  NEXT CALLED FUNCTION MEMORY BEGINING
*       tp  -  CURRENT FUNCTION MEMORY BEGINING
*       gp  -  CURRENT FUNCTION MEMORY SIZE
*/

/*
*   MEMORY STRUCTURE:
*       tp + 0   -  RETURN ADDRESS
*       tp + 4*n -  DATA
*       tp + gp  -  FUNCTION MEMORY SIZE
*/

/*    WHOLE PROGRAM    */
/* INITIAL REGS CONFIG */
program
    : function_list {
            printf("start:\n");
            printf("jal count\n");
            printf("count:\n");
            printf("addi gp, x0, %d\n", function_map(&head, lookup_symbol(&head, "main")));
            printf("addi tp, ra, 24\n"); //these lines are 4*6
            printf("add t6, tp, x0\n");
            printf("add s11, tp, gp\n"); //update child's beginig  
            printf("jal main\n");
            printf("end: nop\n");
            // print_symtab(&head);
        }
    ;
/*  LIST OF FUNCTIONS  */
/* RECURSION */
function_list
    : function
    | function_list function
    ;
/*    FUNCTION DEFINITION    */
/* CHECK IF NAME IS FREE, ADD TO SYM_TAB AND JUMP BACK */
function
    : type _ID {
            tab_ind = lookup_symbol(&head, $2);
            if(tab_ind == -1){
                tab_ind = insert_symbol(&head, $2, FUN, $1);
            }
            else{
                printf("ERROR: redefinition of a function '%s'\n", $2);
            }
        } _LPAREN parameter_list _RPAREN {
            printf("%s:\n", $2);
            printf("sw ra, 0, tp\n"); //save where to return
            printf("sw gp, -4, s11\n"); //save data size of parent function
        } body {
            printf("jalr ra\n");
        }
    ;
/*  NUMBER  */
/* RETURN INDEX AND IS IT NEW */
literal
    : _INT_NUMBER {
            tab_ind = insert_symbol(&head, $1, LIT, INT);
            $$ = tab_ind;
        }
    | _UINT_NUMBER {
            tab_ind = insert_symbol(&head, $1, LIT, UINT);
            $$ = tab_ind;
        }
    | _HEX_NUMBER {
            tab_ind = insert_symbol(&head, $1, LIT, HEX_NUMBER);
            $$ = tab_ind;
        }
    ;
/* TYPE */
/* RETURN TYPE */ 
/* MAYBE EXPAND WITH CONST? */
type
    : _TYPE {
            $$ = $1;
        }
    ;
/*  NO PARAMETERS OR LIST OF FUNCTIONS PARAMETERS  */
parameter_list
    : /* empty */
    | parameter
/*  LIST OF FUNCTIONS PARAMETERS  */
/* RECURSION, CHEK IF NAME IS FREE AND MAKE NEW SYM_TAB ENTRY */
parameter
    : parameter _COMMA parameter_decl
    | parameter_decl
    ;
/*    PARAM DECLARATION    */
/* CHEK IF NAME IS FREE AND MAKE NEW SYM_TAB ENTRY */
/* TO DO - _STAR _STAR */
parameter_decl
    : type _ID {
            strcpy(tab_name, $2);
            func_ind = get_func(&head);
            tab_ind = lookup_symbol_func(&head, tab_name, func_ind);
            if(tab_ind == -1){ //new or new in this function
                tab_ind = insert_symbol(&head, tab_name, PAR, $1);
            }
            else{
                printf("ERROR: PARAM ISSUE: redefinition of a ID '%s'\n", tab_name);
            }
            if($1 == VOID){
                printf("ERROR: PARAM DEF ISSUE: parameter '%s' can not be of VOID type\n",tab_name);
            }
        }
    | type _STAR _ID {
            strcpy(tab_name, $3);
            func_ind = get_func(&head);
            tab_ind = lookup_symbol_func(&head, tab_name, func_ind);
            if(tab_ind == -1){ //new or new in this function
                tab_ind = insert_symbol(&head, tab_name, PAR, $1);
            }
            else{
                printf("ERROR: PARAM ISSUE: redefinition of a ID '%s'\n", tab_name);
            }

            if($1 == VOID){
                printf("ERROR: PARAM DEF ISSUE: parameter '%s' can not be of VOID type\n",tab_name);
            }
            set_pointer(&head, tab_ind);
        }
    | type _ID array_member_definition {
            strcpy(tab_name, $2);
            func_ind = get_func(&head);
            tab_ind = lookup_symbol_func(&head, tab_name, func_ind);
            if(tab_ind == -1){ //new or new in this function
                tab_ind = insert_symbol(&head, tab_name, PAR, $1);
            }
            else{
                printf("ERROR: PARAM ISSUE: redefinition of a ID '%s'\n", tab_name);
            }

            if($1 == VOID){
                printf("ERROR: PARAM DEF ISSUE: parameter '%s' can not be of VOID type\n",tab_name);
            }
            set_pointer(&head, tab_ind);
            set_dimension(&head, tab_ind, $3, sq_size);
        }
    | type _STAR _ID array_member_definition {
            strcpy(tab_name, $3);
            func_ind = get_func(&head);
            tab_ind = lookup_symbol_func(&head, tab_name, func_ind);
            if(tab_ind == -1){ //new or new in this function
                tab_ind = insert_symbol(&head, tab_name, PAR, $1);
            }
            else{
                printf("ERROR: PARAM ISSUE: redefinition of a ID '%s'\n", tab_name);
            }

            if($1 == VOID){
                printf("ERROR: PARAM DEF ISSUE: parameter '%s' can not be of VOID type\n",tab_name);
            }
            set_pointer(&head, tab_ind);
            set_dimension(&head, tab_ind, $4, sq_size);
        }
    ;
/*    BODY OF A FUNCTION    */
body
    : _LBRACKET variable_list statement_list _RBRACKET
    ;
/*  LIST OF VARIABLE DECLARATIONS  */
/* RECURSION */
variable_list
    : /* empty */
    | variable_list variable_decl_line
    ;
/*    VARIABLE DECLARATION LINE   */
/* MORE VARS IN ONE LINE */
variable_decl_line
    : type {
        tab_type = $1;
    } variable_decls _SEMICOLON
    ;
/*    VARIABLE DECLARATIONS   */
/* MORE VARS IN ONE LINE */
variable_decls
    : variable_decls _COMMA variable_decl
    | variable_decl
    ;
/*    VARIABLE DECLARATION    */
/* CHEK IF NAME IS FREE AND MAKE NEW SYM_TAB ENTRY */
/* TO DO - MORE IN ONE LINE */
variable_decl
    : _ID {
            strcpy(tab_name, $1);
            func_ind = get_func(&head);
            tab_ind = lookup_symbol_func(&head, tab_name, func_ind);
            if(tab_ind == -1){ //new or new in this function
                tab_ind = insert_symbol(&head, tab_name, VAR, tab_type);
            }
            else{
                printf("ERROR: DECL ISSUE: redefinition of a ID '%s'\n", tab_name);
            }
            if(tab_type == VOID){
                printf("ERROR: DECL DEF ISSUE: parameter '%s' can not be of VOID type\n",tab_name);
            }
        }
    | _STAR _ID {
            strcpy(tab_name, $2);
            func_ind = get_func(&head);
            tab_ind = lookup_symbol_func(&head, tab_name, func_ind);
            if(tab_ind == -1){ //new or new in this function
                tab_ind = insert_symbol(&head, tab_name, VAR, tab_type);
            }
            else{
                printf("ERROR: DECL ISSUE: redefinition of a ID '%s'\n", tab_name);
            }

            if(tab_type == VOID){
                printf("ERROR: DECL DEF ISSUE: parameter '%s' can not be of VOID type\n",tab_name);
            }
            set_pointer(&head, tab_ind);
        }
    | _ID array_member_definition {
            strcpy(tab_name, $1);
            func_ind = get_func(&head);
            tab_ind = lookup_symbol_func(&head, tab_name, func_ind);
            if(tab_ind == -1){ //new or new in this function
                tab_ind = insert_symbol(&head, tab_name, VAR, tab_type);
            }
            else{
                printf("ERROR: DECL ISSUE: redefinition of a ID '%s'\n", tab_name);
            }

            if(tab_type == VOID){
                printf("ERROR: DECL DEF ISSUE: parameter '%s' can not be of VOID type\n",tab_name);
            }
            set_dimension(&head, tab_ind, $2, sq_size);
        }
    | _STAR _ID array_member_definition {
            strcpy(tab_name, $2);
            func_ind = get_func(&head);
            tab_ind = lookup_symbol_func(&head, tab_name, func_ind);
            if(tab_ind == -1){ //new or new in this function
                tab_ind = insert_symbol(&head, tab_name, VAR, tab_type);
            }
            else{
                printf("ERROR: DECL ISSUE: redefinition of a ID '%s'\n", tab_name);
            }

            if(tab_type == VOID){
                printf("ERROR: DECL DEF ISSUE: parameter '%s' can not be of VOID type\n",tab_name);
            }
            set_pointer(&head, tab_ind);
            set_dimension(&head, tab_ind, $3, sq_size);
        }
    ;
/*  ARRAY PART IN A DECLARATION  */
/* RETURN DIMENSIONS */
array_member_definition
    : array_member_definition _LSQBRACK literal _RSQBRACK {
            if(sq_size >= MAX_DIM){
                printf("ERROR: ARRAY SIZE ISSUE: too many dimensions\n");
            }
            $$[sq_size++] = atoi(get_name(&head, $3));
        }
    | _LSQBRACK literal _RSQBRACK {
            sq_size = 0;
            $$[sq_size++] = atoi(get_name(&head, $2));
        }
    ;
/*  LIST OF STATEMENTS  */
/* RECURSION */
statement_list
    : /* empty */
    | statement_list statement
    ;
/*    POSSIBLE STATEMENTS    */
statement
    : compound_statement
    | assignment_statement
    | if_statement
    | return_statement
    | while_statement
    | for_statement
    | function_call _SEMICOLON /* FOR VOID FUNCTIONS */
    ;
//    | _CONTINUE _SEMICOLON
//    | _BREAK _SEMICOLON    
//    | do_while_statement
//    | switch_statement

/*    COMPOUND STATMENT    */
compound_statement
    : _LBRACKET statement_list _RBRACKET
    ;
/*    ASSIGNMENT    */
/* SAVE IN MEMORY */
/* TO DO -- VAR vs PAR */
assignment_statement
    : helper_assign num_exp _SEMICOLON {
            if($2 == 1){
                printf("ERROR: DATA ISSUE: Using address value in a numerical expression\n");
            }
            if($1 > 0){
                printf("ERROR: DATA ISSUE: Assigning numerical expression to a pointer\n");
            }
            pop("s4", 1);
            printf("add t0, x0, t1\n"); // PUT num_exp ON t1
            printf("sw t0, 0, s4\n");
        }
    | helper_assign _AMP mem_map _SEMICOLON {
        if($1 == 0){
            printf("ERROR: DATA ISSUE: Non-pointer can't recieve an addess\n");
        }
        printf("addi t1, s4, 0\n");
        printf("add t0, x0, t1\n");
        pop("s4", 1);
        printf("sw t0, 0, s4\n");
    }
    | data _ITER _SEMICOLON {
            if($1 > 0){
                printf("ERROR: DATA ISSUE: Itterating pointer\n");
            }
            printf("lw t0, 0, s4\n");
            if($2 == INC){
                printf("addi t0, t0, 1\n");
            }
            else{
                printf("addi t0, t0, -1\n");
            }
            printf("sw t0, 0, s4\n");
        }
    | _ITER data _SEMICOLON {
            if($2 > 0){
                printf("ERROR: DATA ISSUE: Itterating pointer\n");
            }
            printf("lw t0, 0, s4\n");
            if($1 == INC){
                printf("addi t0, t0, 1\n");
            }
            else{
                printf("addi t0, t0, -1\n");
            }
            printf("sw t0, 0, s4\n");
        }
    ;
helper_assign
    : data _ASSIGN {
            $$ = $1;
            push("s4", 1);
        }
    ;
/*  MEMORY MAP  */
/* CHECK IF EXISTS AND RETURN ITS MEMORY_MAP */
mem_map
    : _ID array_member {
            strcpy(tab_name, $1);
            func_ind = get_func(&head);
            tab_ind = lookup_symbol_func(&head, tab_name, func_ind);
            if(tab_ind == -1){ //new or new in this function
                printf("ERROR: DATA ISSUE: non-existing ID '%s'\n", tab_name);
            }
            tab_kind = get_kind(&head, tab_ind);
            if(tab_kind != VAR && tab_kind != PAR){
                printf("ERROR: DATA ISSUE: ID of a non-VAR and non-PAR kind - '%s'\n", tab_name);
            }

            dims = get_dimension(&head, tab_ind);

            printf("add s4, x0, x0\n");

            for(sq_arg = 0; sq_arg < MAX_DIM && dims[sq_arg] > 0; sq_arg++){
            }

            if((get_pointer(&head, tab_ind) > 0 && sq_mem == 0) || (sq_mem < sq_arg)){
                $$ = 1;
            }
            else{
                $$ = 0;

                for(sq_arg = 0; sq_arg < MAX_DIM && dims[sq_arg] > 0; sq_arg++){
                    sq_mul = 1;
                    printf("add s1, a%d, x0\n", sq_arg);
                    for(sq_subarg = sq_arg + 1; sq_subarg < MAX_DIM && dims[sq_subarg] > 0; sq_subarg++){
                        sq_mul = sq_mul * dims[sq_subarg];
                    }
                    printf("addi s2, x0, %d\n", sq_mul);

                    // should use MUL and DIV which are in RISC-V
                    printf("addi s3, x0, 0\n");
                    printf("blt s2, x0, l%ds2q%d\n", lab_cnt, sq_arg);
                    printf("l%dsq%d:\n", lab_cnt, sq_arg);
                    printf("beq s2, x0, l%ds1q%d\n", lab_cnt, sq_arg);
                    printf("addi s2, s2, -1\n");
                    printf("add s3, s3, s1\n");
                    printf("beq x0, x0, l%dsq%d\n", lab_cnt, sq_arg);
                    printf("l%ds2q%d:\n", lab_cnt, sq_arg);
                    printf("beq s2, x0, l%ds1q%d\n", lab_cnt, sq_arg);
                    printf("addi s2, s2, 1\n");
                    printf("sub s3, s3, s1\n");
                    printf("beq x0, x0, l%ds2q%d\n", lab_cnt, sq_arg);
                    printf("l%ds1q%d:\n", lab_cnt, sq_arg);
                    printf("add s4, s4, s3\n");
                }
                lab_cnt++;
            }

            // s4 = 4 * s4
            printf("add s4, s4, s4\n");
            printf("add s4, s4, s4\n");

            printf("add s4, s4, tp\n");
            printf("addi s4, s4, %d\n", memory_map(&head, tab_name, func_ind));

            c_pop(stack, &sp, &sq_mem);
        }
data
    : mem_map{
            $$ = $1;
        }
    | _STAR _ID array_member {
            $$ = 0;
            strcpy(tab_name, $2);
            func_ind = get_func(&head);
            tab_ind = lookup_symbol_func(&head, tab_name, func_ind);
            if(tab_ind == -1){ //new or new in this function
                printf("ERROR: DATA ISSUE: non-existing ID '%s'\n", tab_name);
            }
            tab_kind = get_kind(&head, tab_ind);
            if(tab_kind != VAR && tab_kind != PAR){
                printf("ERROR: DATA ISSUE: ID of a non-VAR and non-PAR kind - '%s'\n", tab_name);
            }
            if(get_pointer(&head, tab_ind) < 1){
                printf("ERROR: DATA ISSUE: ID of a non-pointer type - '%s'\n", tab_name);
            }

            dims = get_dimension(&head, tab_ind);

            printf("add s4, x0, x0\n");

            for(sq_arg = 0; sq_arg < MAX_DIM && dims[sq_arg] > 0; sq_arg++){
                sq_mul = 1;
                printf("add s1, a%d, x0\n", sq_arg);
                for(sq_subarg = sq_arg + 1; sq_subarg < MAX_DIM && dims[sq_subarg] > 0; sq_subarg++){
                    sq_mul = sq_mul * dims[sq_subarg];
                }
                printf("addi s2, x0, %d\n", sq_mul);

                // should use MUL and DIV which are in RISC-V
                printf("addi s3, x0, 0\n");
                printf("blt s2, x0, l%ds2q%d\n", lab_cnt, sq_arg);
                printf("l%dsq%d:\n", lab_cnt, sq_arg);
                printf("beq s2, x0, l%ds1q%d\n", lab_cnt, sq_arg);
                printf("addi s2, s2, -1\n");
                printf("add s3, s3, s1\n");
                printf("beq x0, x0, l%dsq%d\n", lab_cnt, sq_arg);
                printf("l%ds2q%d:\n", lab_cnt, sq_arg);
                printf("beq s2, x0, l%ds1q%d\n", lab_cnt, sq_arg);
                printf("addi s2, s2, 1\n");
                printf("sub s3, s3, s1\n");
                printf("beq x0, x0, l%ds2q%d\n", lab_cnt, sq_arg);
                printf("l%ds1q%d:\n", lab_cnt, sq_arg);
                printf("add s4, s4, s3\n");
            }
            lab_cnt++;

            // s4 = 4 * s4
            printf("add s4, s4, s4\n");
            printf("add s4, s4, s4\n");

            printf("add s4, s4, tp\n");
            printf("addi s4, s4, %d\n", memory_map(&head, tab_name, func_ind));

            printf("lw s4, 0, s4\n"); //pointer

            c_pop(stack, &sp, &sq_mem);
        }
    ;
/*  ARRAY PARAMETERS  */
/* STORE IN a LOCATION */
/* TO DO -- BE CAREFULL WITH function_call: MUSN'T BE VOID*/
array_member
    : /* empty */ {
        c_push(stack, &sp, sq_mem);
        sq_mem = 0;
    }
    | array_mem
    ;
array_mem
    : array_mem _LSQBRACK num_exp _RSQBRACK {
            if($3 == 1){
                printf("ERROR: DATA ISSUE: Using address value in a numerical expression\n");
            }
            printf("add a%d, t1, x0\n", sq_mem++);
        }
    | _LSQBRACK num_exp _RSQBRACK {
            if($2 == 1){
                printf("ERROR: DATA ISSUE: Using address value in a numerical expression\n");
            }
            c_push(stack, &sp, sq_mem);
            sq_mem = 0;
            printf("add a%d, t1, x0\n", sq_mem++);
        }
    ;
/*  ARITHMETICAL OPERATIONS  */
/* RETURN OPERATION TYPE */
ar_op
    : _PLUS {
            $$ = PLUS;
        }
    | _MINUS {
            $$ = MINUS;
        }
    | _STAR {
            $$ = STAR;
        }
    | _DIV {
            $$ = DIV;
        }
    | _MOD {
            $$ = MOD;
        }
    | _SR {
            $$ = SR;
        }
    | _SL {
            $$ = SL;
        }
    | _AMP {
            $$ = AMP;
        }
    | _BOR {
            $$ = BOR;
        }
    | _BXOR {
            $$ = BXOR;
        }
    ;
/*  LOGIAL OPERATION  */
/* RETURN OPERATION TYPE */
log_op
    : _AND {
            $$ = AND;
        }
    | _OR {
            $$ = OR;
        }
    ;
/*  NUMERICAL EXPRESSION  */
/* PUT RESULT IN t1 */
num_exp
    : exp {
            switch($1[1]){
                case 0:
                    printf("addi t1, x0, %d\n", $1[0]);
                    break;
                case 1:
                    printf("lw t1, 0, s4\n");
                    break;
                case 2:
                    printf("lw t1, 0, s0\n");
                    break;
            }
            $$ = $1[0];
        }
    | helper_exp exp {
            $$ = 0;
            switch($2[1]){
                case 0:
                    printf("addi t2, x0, %d\n", $2[0]);
                    break;
                case 1:
                    if($2[0] == 1){
                        printf("ERROR: DATA ISSUE: Using address value in a numerical expression\n");
                    }
                    printf("lw t2, 0, s4\n");
                    break;
                case 2:
                    printf("lw t2, 0, s0\n");
                    break;
            }
            switch($1[1]){
                case 0:
                    printf("addi t1, x0, %d\n", $1[0]);
                    break;
                case 1:
                    pop("s4", 1);
                    printf("lw t1, 0, s4\n");
                    break;
                case 2:
                    pop("s0", 1);
                    printf("lw t1, 0, s0\n");
                    break;
            }
            switch($1[2]){
                case PLUS:
                    printf("add t1, t1, t2\n");
                    break;
                case MINUS:
                    printf("sub t1, t1, t2\n");
                    break;
                case STAR:
                    // should use MUL and DIV which are in RISC-V
                    printf("addi t3, x0, 0\n");
                    printf("blt t2, x0, l%dm2\n", lab_cnt);
                    printf("l%dm:\n", lab_cnt);
                    printf("beq t2, x0, l%dm1\n", lab_cnt);
                    printf("addi t2, t2, -1\n");
                    printf("add t3, t3, t1\n");
                    printf("beq x0, x0, l%dm\n", lab_cnt);
                    printf("l%dm2:\n", lab_cnt);
                    printf("beq t2, x0, l%dm1\n", lab_cnt);
                    printf("addi t2, t2, 1\n");
                    printf("sub t3, t3, t1\n");
                    printf("beq x0, x0, l%dm2\n", lab_cnt);
                    printf("l%dm1:\n", lab_cnt++);
                    printf("add t1, t3, x0\n");

                    break;
                case DIV:
                    printf("beq t2, x0, end\n"); //error

                    printf("addi t4, x0, -1\n");
                    printf("bge t1, x0, l%dd1\n", lab_cnt);
                    printf("sub t1, x0, t1\n");
                    printf("addi t4, t4, 1\n");
                    printf("l%dd1:\n", lab_cnt);
                    printf("bge t2, x0, l%dd2\n", lab_cnt);
                    printf("sub t2, x0, t2\n");
                    printf("addi t4, t4, 1\n");
                    printf("l%dd2:\n", lab_cnt);
                    printf("addi t3, x0, 0\n");
                    printf("l%dd3:\n", lab_cnt);
                    printf("sub t1, t1, t2\n");
                    printf("blt t1, x0, l%dd4\n", lab_cnt);
                    printf("addi t3, t3, 1\n");
                    printf("beq x0, x0, l%dd3\n", lab_cnt);
                    printf("l%dd4:\n", lab_cnt);
                    printf("add t1, t3, x0\n");
                    printf("bne t4, x0, l%dd5\n", lab_cnt);
                    printf("sub t1, x0, t1\n");
                    printf("l%dd5:\n", lab_cnt++);
                    break;
                case MOD:
                    printf("beq t2, x0, end\n"); //error

                    printf("addi t4, x0, -1\n");
                    printf("bge t1, x0, l%dd1\n", lab_cnt);
                    printf("sub t1, x0, t1\n");
                    printf("addi t4, t4, 1\n");
                    printf("l%dd1:\n", lab_cnt);
                    printf("bge t2, x0, l%dd2\n", lab_cnt);
                    printf("sub t2, x0, t2\n");
                    printf("addi t4, t4, 1\n");
                    printf("l%dd2:\n", lab_cnt);
                    printf("addi t3, x0, 0\n");
                    printf("l%dd3:\n", lab_cnt);
                    printf("sub t1, t1, t2\n");
                    printf("blt t1, x0, l%dd4\n", lab_cnt);
                    printf("add t3, t1, x0\n");
                    printf("beq x0, x0, l%dd3\n", lab_cnt);
                    printf("l%dd4:\n", lab_cnt);
                    printf("add t1, t3, x0\n");
                    printf("bne t4, x0, l%dd5\n", lab_cnt);
                    printf("sub t1, x0, t1\n");
                    printf("l%dd5:\n", lab_cnt++);
                    break;
                case SR:
                    printf("srl t1, t1, t2\n");
                    break;
                case SL:
                    printf("sll t1, t1, t2\n");
                    break;
                case AMP:
                    printf("and t1, t1, t2\n");
                    break;
                case BOR:
                    printf("or t1, t1, t2\n");
                    break;
                case BXOR:
                    printf("xor t1, t1, t2\n");
                    break;
                default:
                    printf("ERROR: NUM EXPR ISSUE: wrong operator\n");
                    break;
            }
        }
    | helper_exp _LPAREN num_exp _RPAREN {
            if($3 == 1){
                printf("ERROR: DATA ISSUE: Using address value in a numerical expression\n");
            }
            $$ = 0;
            printf("add t2, x0, t1\n");
            switch($1[1]){
                case 0:
                    printf("addi t1, x0, %d\n", $1[0]);
                    break;
                case 1:
                    pop("s4", 1);
                    printf("lw t1, 0, s4\n");
                    break;
                case 2:
                    pop("s0", 1);
                    printf("lw t1, 0, s0\n");
                    break;
            }
            switch($1[2]){
                case PLUS:
                    printf("add t1, t1, t2\n");
                    break;
                case MINUS:
                    printf("sub t1, t1, t2\n");
                    break;
                case STAR:
                    printf("addi t3, x0, 0\n");
                    printf("blt t2, x0, l%dm2\n", lab_cnt);
                    printf("l%dm:\n", lab_cnt);
                    printf("beq t2, x0, l%dm1\n", lab_cnt);
                    printf("addi t2, t2, -1\n");
                    printf("add t3, t3, t1\n");
                    printf("beq x0, x0, l%dm\n", lab_cnt);
                    printf("l%dm2:\n", lab_cnt);
                    printf("beq t2, x0, l%dm1\n", lab_cnt);
                    printf("addi t2, t2, 1\n");
                    printf("sub t3, t3, t1\n");
                    printf("beq x0, x0, l%dm2\n", lab_cnt);
                    printf("l%dm1:\n", lab_cnt++);
                    printf("add t1, t3, x0\n");
                    break;
                case DIV:
                    printf("beq t2, x0, end\n"); //error

                    printf("addi t4, x0, -1\n");
                    printf("bge t1, x0, l%dd1\n", lab_cnt);
                    printf("sub t1, x0, t1\n");
                    printf("addi t4, t4, 1\n");
                    printf("l%dd1:\n", lab_cnt);
                    printf("bge t2, x0, l%dd2\n", lab_cnt);
                    printf("sub t2, x0, t2\n");
                    printf("addi t4, t4, 1\n");
                    printf("l%dd2:\n", lab_cnt);
                    printf("addi t3, x0, 0\n");
                    printf("l%dd3:\n", lab_cnt);
                    printf("sub t1, t1, t2\n");
                    printf("blt t1, x0, l%dd4\n", lab_cnt);
                    printf("addi t3, t3, 1\n");
                    printf("beq x0, x0, l%dd3\n", lab_cnt);
                    printf("l%dd4:\n", lab_cnt);
                    printf("add t1, t3, x0\n");
                    printf("bne t4, x0, l%dd5\n", lab_cnt);
                    printf("sub t1, x0, t1\n");
                    printf("l%dd5:\n", lab_cnt++);
                    break;
                case MOD:
                    printf("beq t2, x0, end\n"); //error

                    printf("addi t4, x0, -1\n");
                    printf("bge t1, x0, l%dd1\n", lab_cnt);
                    printf("sub t1, x0, t1\n");
                    printf("addi t4, t4, 1\n");
                    printf("l%dd1:\n", lab_cnt);
                    printf("bge t2, x0, l%dd2\n", lab_cnt);
                    printf("sub t2, x0, t2\n");
                    printf("addi t4, t4, 1\n");
                    printf("l%dd2:\n", lab_cnt);
                    printf("addi t3, x0, 0\n");
                    printf("l%dd3:\n", lab_cnt);
                    printf("sub t1, t1, t2\n");
                    printf("blt t1, x0, l%dd4\n", lab_cnt);
                    printf("add t3, t1, x0\n");
                    printf("beq x0, x0, l%dd3\n", lab_cnt);
                    printf("l%dd4:\n", lab_cnt);
                    printf("add t1, t3, x0\n");
                    printf("bne t4, x0, l%dd5\n", lab_cnt);
                    printf("sub t1, x0, t1\n");
                    printf("l%dd5:\n", lab_cnt++);
                    break;
                case SR:
                    printf("srl t1, t1, t2\n");
                    break;
                case SL:
                    printf("sll t1, t1, t2\n");
                    break;
                case AMP:
                    printf("and t1, t1, t2\n");
                    break;
                case BOR:
                    printf("or t1, t1, t2\n");
                    break;
                case BXOR:
                    printf("xor t1, t1, t2\n");
                    break;
                default:
                    printf("ERROR: NUM EXPR ISSUE: wrong operator\n");
                    break;
            }
        }
    | helper_num_exp exp {
            $$ = 0;
            pop("t1", 1);
            switch($2[1]){
                case 0:
                    printf("addi t2, x0, %d\n", $2[0]);
                    break;
                case 1:
                    if($2[0] == 1){
                        printf("ERROR: DATA ISSUE: Using address value in a numerical expression\n");
                    }
                    printf("lw t2, 0, s4\n");
                    break;
                case 2:
                    printf("lw t2, 0, s0\n");
                    break;
            }
            switch($1){
                case PLUS:
                    printf("add t1, t1, t2\n");
                    break;
                case MINUS:
                    printf("sub t1, t1, t2\n");
                    break;
                case STAR:
                    printf("addi t3, x0, 0\n");
                    printf("blt t2, x0, l%dm2\n", lab_cnt);
                    printf("l%dm:\n", lab_cnt);
                    printf("beq t2, x0, l%dm1\n", lab_cnt);
                    printf("addi t2, t2, -1\n");
                    printf("add t3, t3, t1\n");
                    printf("beq x0, x0, l%dm\n", lab_cnt);
                    printf("l%dm2:\n", lab_cnt);
                    printf("beq t2, x0, l%dm1\n", lab_cnt);
                    printf("addi t2, t2, 1\n");
                    printf("sub t3, t3, t1\n");
                    printf("beq x0, x0, l%dm2\n", lab_cnt);
                    printf("l%dm1:\n", lab_cnt++);
                    printf("add t1, t3, x0\n");
                    break;
                case DIV:
                    printf("beq t2, x0, end\n"); //error

                    printf("addi t4, x0, -1\n");
                    printf("bge t1, x0, l%dd1\n", lab_cnt);
                    printf("sub t1, x0, t1\n");
                    printf("addi t4, t4, 1\n");
                    printf("l%dd1:\n", lab_cnt);
                    printf("bge t2, x0, l%dd2\n", lab_cnt);
                    printf("sub t2, x0, t2\n");
                    printf("addi t4, t4, 1\n");
                    printf("l%dd2:\n", lab_cnt);
                    printf("addi t3, x0, 0\n");
                    printf("l%dd3:\n", lab_cnt);
                    printf("sub t1, t1, t2\n");
                    printf("blt t1, x0, l%dd4\n", lab_cnt);
                    printf("addi t3, t3, 1\n");
                    printf("beq x0, x0, l%dd3\n", lab_cnt);
                    printf("l%dd4:\n", lab_cnt);
                    printf("add t1, t3, x0\n");
                    printf("bne t4, x0, l%dd5\n", lab_cnt);
                    printf("sub t1, x0, t1\n");
                    printf("l%dd5:\n", lab_cnt++);
                    break;
                case MOD:
                    printf("beq t2, x0, end\n"); //error

                    printf("addi t4, x0, -1\n");
                    printf("bge t1, x0, l%dd1\n", lab_cnt);
                    printf("sub t1, x0, t1\n");
                    printf("addi t4, t4, 1\n");
                    printf("l%dd1:\n", lab_cnt);
                    printf("bge t2, x0, l%dd2\n", lab_cnt);
                    printf("sub t2, x0, t2\n");
                    printf("addi t4, t4, 1\n");
                    printf("l%dd2:\n", lab_cnt);
                    printf("addi t3, x0, 0\n");
                    printf("l%dd3:\n", lab_cnt);
                    printf("sub t1, t1, t2\n");
                    printf("blt t1, x0, l%dd4\n", lab_cnt);
                    printf("add t3, t1, x0\n");
                    printf("beq x0, x0, l%dd3\n", lab_cnt);
                    printf("l%dd4:\n", lab_cnt);
                    printf("add t1, t3, x0\n");
                    printf("bne t4, x0, l%dd5\n", lab_cnt);
                    printf("sub t1, x0, t1\n");
                    printf("l%dd5:\n", lab_cnt++);
                    break;
                case SR:
                    printf("srl t1, t1, t2\n");
                    break;
                case SL:
                    printf("sll t1, t1, t2\n");
                    break;
                case AMP:
                    printf("and t1, t1, t2\n");
                    break;
                case BOR:
                    printf("or t1, t1, t2\n");
                    break;
                case BXOR:
                    printf("xor t1, t1, t2\n");
                    break;
                default:
                    printf("ERROR: NUM EXPR ISSUE: wrong operator\n");
                    break;
            }
        }
    | helper_num_exp _LPAREN num_exp _RPAREN {
            if($3 == 1){
                printf("ERROR: DATA ISSUE: Using address value in a numerical expression\n");
            }
            $$ = 0;
            printf("add t2, x0, t1\n");
            pop("t1", 1);
            switch($1){
                case PLUS:
                    printf("add t1, t1, t2\n");
                    break;
                case MINUS:
                    printf("sub t1, t1, t2\n");
                    break;
                case STAR:
                    printf("addi t3, x0, 0\n");
                    printf("blt t2, x0, l%dm2\n", lab_cnt);
                    printf("l%dm:\n", lab_cnt);
                    printf("beq t2, x0, l%dm1\n", lab_cnt);
                    printf("addi t2, t2, -1\n");
                    printf("add t3, t3, t1\n");
                    printf("beq x0, x0, l%dm\n", lab_cnt);
                    printf("l%dm2:\n", lab_cnt);
                    printf("beq t2, x0, l%dm1\n", lab_cnt);
                    printf("addi t2, t2, 1\n");
                    printf("sub t3, t3, t1\n");
                    printf("beq x0, x0, l%dm2\n", lab_cnt);
                    printf("l%dm1:\n", lab_cnt++);
                    printf("add t1, t3, x0\n");
                    break;
                case DIV:
                    printf("beq t2, x0, end\n"); //error

                    printf("addi t4, x0, -1\n");
                    printf("bge t1, x0, l%dd1\n", lab_cnt);
                    printf("sub t1, x0, t1\n");
                    printf("addi t4, t4, 1\n");
                    printf("l%dd1:\n", lab_cnt);
                    printf("bge t2, x0, l%dd2\n", lab_cnt);
                    printf("sub t2, x0, t2\n");
                    printf("addi t4, t4, 1\n");
                    printf("l%dd2:\n", lab_cnt);
                    printf("addi t3, x0, 0\n");
                    printf("l%dd3:\n", lab_cnt);
                    printf("sub t1, t1, t2\n");
                    printf("blt t1, x0, l%dd4\n", lab_cnt);
                    printf("addi t3, t3, 1\n");
                    printf("beq x0, x0, l%dd3\n", lab_cnt);
                    printf("l%dd4:\n", lab_cnt);
                    printf("add t1, t3, x0\n");
                    printf("bne t4, x0, l%dd5\n", lab_cnt);
                    printf("sub t1, x0, t1\n");
                    printf("l%dd5:\n", lab_cnt++);
                    break;
                case MOD:
                    printf("beq t2, x0, end\n"); //error

                    printf("addi t4, x0, -1\n");
                    printf("bge t1, x0, l%dd1\n", lab_cnt);
                    printf("sub t1, x0, t1\n");
                    printf("addi t4, t4, 1\n");
                    printf("l%dd1:\n", lab_cnt);
                    printf("bge t2, x0, l%dd2\n", lab_cnt);
                    printf("sub t2, x0, t2\n");
                    printf("addi t4, t4, 1\n");
                    printf("l%dd2:\n", lab_cnt);
                    printf("addi t3, x0, 0\n");
                    printf("l%dd3:\n", lab_cnt);
                    printf("sub t1, t1, t2\n");
                    printf("blt t1, x0, l%dd4\n", lab_cnt);
                    printf("add t3, t1, x0\n");
                    printf("beq x0, x0, l%dd3\n", lab_cnt);
                    printf("l%dd4:\n", lab_cnt);
                    printf("add t1, t3, x0\n");
                    printf("bne t4, x0, l%dd5\n", lab_cnt);
                    printf("sub t1, x0, t1\n");
                    printf("l%dd5:\n", lab_cnt++);
                    break;
                case SR:
                    printf("srl t1, t1, t2\n");
                    break;
                case SL:
                    printf("sll t1, t1, t2\n");
                    break;
                case AMP:
                    printf("and t1, t1, t2\n");
                    break;
                case BOR:
                    printf("or t1, t1, t2\n");
                    break;
                case BXOR:
                    printf("xor t1, t1, t2\n");
                    break;
                default:
                    printf("ERROR: NUM EXPR ISSUE: wrong operator\n");
                    break;
            }
        }
    | _PLUS exp {
            $$ = 0;
            switch($2[1]){
                case 0:
                    printf("addi t1, x0, %d\n", $2[0]);
                    break;
                case 1:
                    if($2[0] == 1){
                        printf("ERROR: DATA ISSUE: Using address value in a numerical expression\n");
                    }
                    printf("lw t1, 0, s4\n");
                    break;
                case 2:
                    printf("lw t1, 0, s0\n");
                    break;
            }
        }
    | _MINUS exp {
            $$ = 0;
            switch($2[1]){
                case 0:
                    printf("addi t1, x0, %d\n", $2[0]);
                    break;
                case 1:
                    if($2[0] == 1){
                        printf("ERROR: DATA ISSUE: Using address value in a numerical expression\n");
                    }
                    printf("lw t1, 0, s4\n");
                    break;
                case 2:
                    printf("lw t1, 0, s0\n");
                    break;
            }
            printf("sub t1, x0, t1\n");
        }
    | data _ITER {
            if($1 == 1){
                printf("ERROR: DATA ISSUE: Using address value in a numerical expression\n");
            }
            $$ = 0;
            if($1 > 0){
                printf("ERROR: DATA ISSUE: Itterating pointer\n");
            }
            printf("lw t1, 0, s4\n");
            if($2 == INC){
                printf("addi t2, t1, 1\n");
            }
            else{
                printf("addi t2, x0, -1\n"); //NO SUBI
            }
            printf("sw t2, 0, s4\n");
        }
    | _ITER data {
            if($2 == 1){
                printf("ERROR: DATA ISSUE: Using address value in a numerical expression\n");
            }
            $$ = 0;
            if($2 > 0){
                printf("ERROR: DATA ISSUE: Itterating pointer\n");
            }
            printf("lw t1, 0, s4\n");
            if($1 == INC){
                printf("addi t1, t1, 1\n");
            }
            else{
                printf("addi t1, x0, -1\n");
            }
            printf("sw t1, 0, s4\n");
        }
    ;
/* HELPER */
/* PUT ON STACK INDEX */
helper_exp
    : exp ar_op {
            switch($1[1]){
                case 1:
                    push("s4", 1);
                    break;
                case 2:
                    if($1[0] == 1){
                        printf("ERROR: DATA ISSUE: Using address value in a numerical expression\n");
                    }
                    push("s0", 1);
                    break;
            }
            
            $$[0] = $1[0];
            $$[1] = $1[1];
            $$[2] = $2;
        }
    ;
/* HELPER */
/* PUSH ON STACK */
helper_num_exp
    : _LPAREN num_exp _RPAREN ar_op {
            if($2 == 1){
                printf("ERROR: DATA ISSUE: Using address value in a numerical expression\n");
            }
            push("t1", 1);
            $$ = $4;
        }
    ;
/* ALLOWED ELEMENTS OF num_exp */
/* CHECK FORN TYPE AND RETURN VALUE/INDEX AND TYPE */
exp
    : literal {
            $$[0] = atoi(get_name(&head, $1));
            $$[1] = 0;
        }
    | data {
            $$[0] = 0;
            if($1 > 0){
                $$[0] = 1;
                // printf("ERROR: DATA ISSUE: Using address value in a numerical expression\n");
            }
            $$[1] = 1;
        }
    | function_call {
            tab_kind = get_kind(&head, $1);
            if(tab_kind == VOID){
                printf("ERROR: FUNC CALL ISSUE: no return value of a void kind\n");
            }
            $$[0] = $1;
            $$[1] = 2;
        }
    ;
/*    FUNCTION CALL    */
/* CHECK IF EXISTS, CONTEXT SWITCH, JUMP AND RETURN */
function_call
    : _ID _LPAREN argument_list _RPAREN { /* symbol */
            args = 1;
            tab_ind = lookup_symbol(&head, $1);
            if(tab_ind == -1){ // CHECK IF OFF BY ONE
                printf("ERROR: FUNC CALL ISSUE: non-existing ID '%s'\n", $1);
            }

            /* SET NEW INFO */
            printf("add tp, tp, gp\n"); //update current function begining
            printf("addi gp, x0, %d\n", function_map(&head, tab_ind)); //update current size
            printf("add s11, s11, gp\n"); //update child's beginig

            /* JUMP */
            printf("jal %s\n", $1);
            $$ = tab_ind;

            printf("sub s11, s11, gp\n"); //update child's beginig
            printf("lw gp, -4, s11\n");
            printf("sub tp, tp, gp\n"); //update current function begining

            printf("lw ra, 0, tp\n");
        }
    ;
/* ARGUMENTS OF A FUNCTION CALL */
/* RECURSION */
argument_list
    : /* empty */
    | argument
    ;
/* ARGUMENTS OF A FUNCTION CALL */
/* RECURSION */
argument
    : argument _COMMA argument_type
    | argument_type
    ;
/* ARGUMENT TYPES OF A FUNCTION CALL */
argument_type
    : num_exp {
            if($1 == 1){
                printf("lw s4, 0, s4\n");
            }
            printf("sw t1, %d, s11\n", 4*args);
            args++;
        }
    | _AMP mem_map {
            if($2 == 1){
                printf("ERROR: Using an address of a pointer\n");
            }
            printf("sw s4, %d, s11\n", 4*args);
            args++;
        }
    ;
/*    IF STATEMENT    */
/* BRANCH TO LABEL */
if_statement
    : helper_if %prec ONLY_IF {
            printf("l%di1l%d:\n", if_depth, if_layer[if_depth]);
            if_layer[if_depth]++;
            if_depth--;
        }
    |  helper_if _ELSE statement {
            printf("l%di1l%d:\n", if_depth, if_layer[if_depth]);
            if_layer[if_depth]++;
            if_depth--;
        }
    ;
/* HELPER */
/* LOOP BRANCH AND EXIT LABLE */
helper_if
    : _IF _LPAREN condition _RPAREN {
            if_depth++;
            printf("beq t1, x0, l%di0l%d\n", if_depth, if_layer[if_depth]);
        } statement {
            printf("beq x0, x0, l%di1l%d\n", if_depth, if_layer[if_depth]); //always branch -- skip else after if is done
            printf("l%di0l%d:\n", if_depth, if_layer[if_depth]);
        }
    ;
/*  IF CONDTITIONS  */
condition
    : rel_exp
    | cond_cplx
    ;
/* MORE THAN ONE CONDITION */
/* SET t1 TO 1 OR 0, DEPENDING ON THE OUTCOME OF THE EXPRESSION */
cond_cplx
    : helper_cond_simp rel_exp {
            printf("add t2, t1, x0\n");
            pop("t1", 1);
            switch($1){
                case(AND):
                    printf("and t1, t1, t2\n");
                    break;
                case(OR):
                    printf("or t1, t1, t2\n");
                    break;
               default:
                    printf("ERROR: COND ISSUE: wrong logical operator\n");
                    break;
            }
        }
    | helper_cond_simp _LPAREN cond_cplx _RPAREN {
            printf("add t2, t1, x0\n");
            pop("t1", 1);
            switch($1){
                case(AND):
                    printf("and t1, t1, t2\n");
                    break;
                case(OR):
                    printf("or t1, t1, t2\n");
                    break;
               default:
                    printf("ERROR: COND ISSUE: wrong logical operator\n");
                    break;
            }
        }
    | helper_cond rel_exp {
            printf("add t2, t1, x0\n");
            pop("t1", 1);
            switch($1){
                case(AND):
                    printf("and t1, t1, t2\n");
                    break;
                case(OR):
                    printf("or t1, t1, t2\n");
                    break;
               default:
                    printf("ERROR: COND ISSUE: wrong logical operator\n");
                    break;
            }
        }
    | helper_cond _LPAREN cond_cplx _RPAREN {
            printf("add t2, t1, x0\n");
            pop("t1", 1);
            switch($1){
                case(AND):
                    printf("and t1, t1, t2\n");
                    break;
                case(OR):
                    printf("or t1, t1, t2\n");
                    break;
               default:
                    printf("ERROR: COND ISSUE: wrong logical operator\n");
                    break;
            }
        }
    ;
/*  HELPER  */
/* STORE IN TEMP REG */
helper_cond_simp
    : rel_exp log_op {
            push("t1", 1);
            $$ = $2;
        } 
    ;
/*  HELPER  */
/* STORE IN TEMP REG */
helper_cond
    : _LPAREN cond_cplx _RPAREN log_op {
            push("t1", 1);
            $$ = $4;
        }
    ;
/*   REALATIONAL EXPRESSION   */
/* SET t1 TO 1 OR 0, DEPENDING ON THE OUTCOME OF THE EXPRESSION */
rel_exp
    : num_exp _RELOP {
            printf("add t4, x0, t1\n");
        } num_exp {
            if($1 == 1 || $4 == 1){
                printf("ERROR: DATA ISSUE: Using address value in a numerical expression\n");
            }
            printf("add t2, x0, t1\n");
            printf("add t1, x0, t4\n");
            switch($2){
                case(LT):
                    printf("slt t1, t1, t2\n");
                    break;
                case(LEQ):
                    printf("slt t3, t1, t2\n");
                    printf("slt t2, t2, t1\n");
                    printf("add t1, t2, t3\n");
                    printf("addi t2, x0, 1\n");
                    printf("sub t1, t2, t1\n"); // 1 - (t1 != t2)

                    printf("add t1, t1, t3\n"); // == + <
                    break;
                case(GT):
                    printf("slt t1, t2, t1\n");
                    break;
                case(GEQ):
                    printf("slt t3, t2, t1\n");
                    printf("slt t2, t1, t2\n");
                    printf("add t1, t2, t3\n");
                    printf("addi t2, x0, 1\n");
                    printf("sub t1, t2, t1\n"); // 1 - (t1 != t2)

                    printf("add t1, t1, t3\n"); // == + >
                    break;
		        case(EQ):
                    printf("slt t3, t1, t2\n");
                    printf("slt t2, t2, t1\n");
                    printf("add t1, t2, t3\n");
                    printf("addi t2, x0, 1\n");
                    printf("sub t1, t2, t1\n"); // 1 - (t1 != t2)
                    break;
                case(NEQ):
                    printf("slt t3, t1, t2\n");
                    printf("slt t2, t2, t1\n");
                    printf("add t1, t2, t3\n");
                    break;
                default:
                    printf("ERROR: REL OP ISSUE: wrong operator\n");
                break;
           }
        }
    | num_exp {
            if($1 == 1){
                printf("ERROR: DATA ISSUE: Using address value in a numerical expression\n");
            }
            printf("slt t2, t1, x0\n");
            printf("slt t3, x0, t1\n");
            printf("add t1, t2, t3\n");
        }
    ;
/*    LOOPS    */
/*  WHILE STATEMENT  */
while_statement
    : _WHILE {
            while_depth++;
            printf("l%dw0l%d:\n", while_depth, while_layer[while_depth]);
        } _LPAREN condition _RPAREN {
            printf("beq t1, x0, l%dw1l%d\n", while_depth, while_layer[while_depth]);
        } statement {
            printf("beq x0, x0, l%dw0l%d\n", while_depth, while_layer[while_depth]);
            printf("l%dw1l%d:\n", while_depth, while_layer[while_depth]);

            while_layer[while_depth]++;
            while_depth--;
        }
    ;
/*  FOR STATEMENT  */
/* LABLE START AND BRANCH */
for_start
    : _FOR _LPAREN assignment_statement {
            for_depth++;
            printf("l%df0l%d:\n", for_depth, for_layer[for_depth]);
        } condition {
            printf("beq t1, x0, l%df1l%d\n", for_depth, for_layer[for_depth]);
        } _SEMICOLON
    ;
/* ASSIGN, EXECUTE, BRANCH AND LABEL EXIT */
for_statement 
    : for_start data _ASSIGN {
            if($2 > 0){
                printf("ERROR: DATA ISSUE: Pointers not allowed in for statment header\n");
            }
            push("s4", 1);
        } num_exp _RPAREN statement {
            if($5 == 1){
                printf("ERROR: DATA ISSUE: Using address value in a numerical expression\n");
            }
            pop("s4", 1);
            printf("add t0, x0, t1\n"); //PUT num_exp ON t1
            printf("sw t0, 0, s4\n");

            printf("beq x0 x0, l%df0l%d\n", for_depth, for_layer[for_depth]);
            printf("l%df1l%d:\n", for_depth, for_layer[for_depth]);

            for_layer[for_depth]++;
            for_depth--;
        }
    | for_start data {
            if($2 > 0){
                printf("ERROR: DATA ISSUE: Pointers not allowed in for statment header\n");
            }
            push("s4", 1);
        } _ITER _RPAREN statement {
            pop("s4", 1);
            printf("lw t0, 0, s4\n");
            if($4 == INC){
                printf("addi t1, t0, 1\n");
            }
            else{
                printf("addi t1, t0, -1\n");
            }
            printf("sw t1, 0, s4\n");

            printf("beq x0 x0, l%df0l%d\n", for_depth, for_layer[for_depth]);
            printf("l%df1l%d:\n", for_depth, for_layer[for_depth]);

            for_layer[for_depth]++;
            for_depth--;
        }
    | for_start {
            push("s4", 1);
        } _ITER data _RPAREN statement {
            if($4 > 0){
                printf("ERROR: DATA ISSUE: Pointers not allowed in for statment header\n");
            }
            pop("s4", 1);
            printf("lw t0, 0, s4\n");
            if($3 == INC){
                printf("addi t0, t0, 1\n");
            }
            else{
                printf("addi t0, t0, -1\n");
            }
            printf("sw t0, 0, s4\n");

            printf("beq x0 x0, l%df0l%d\n", for_depth, for_layer[for_depth]);
            printf("l%df1l%d:\n", for_depth, for_layer[for_depth]);

            for_layer[for_depth]++;
            for_depth--;
        }
    ;
/*    RETURN STATMENT    */ 
/* EITHER retur x; OR return; */
/* CHECK TYPE, SET THE VALUE AND JUMP */
return_statement
    : _RETURN num_exp _SEMICOLON {
            if($2 == 1){
                printf("ERROR: DATA ISSUE: Using address value in a numerical expression\n");
            }
            tab_ind = get_func(&head);
            tab_type = get_type(&head, tab_ind);
            if(tab_type == VOID){
                printf("ERROR: RETURN ISSUE: value in a void type\n");
            }
            /* WRITE VAL TO THE REGISTER/DATA MEMORY JUMP BACK */
            printf("addi s0, tp, 4\n");
            printf("sw t1, 0, s0\n");

            printf("jalr ra\n");
        }
    | _RETURN _SEMICOLON { /* FOR VOID ONLY */
            tab_ind = get_func(&head);
            tab_type = get_type(&head, tab_ind);
            if(tab_type != VOID){
                printf("ERROR: RETURN ISSUE: missing value in non-void type\n");
            }

            printf("jalr ra\n"); /* JUMP BACK */
        }
    ;

/* TO BE ADDED */

/* SWITCH STATEMENT */
/* TO BE DELT WITH -- NO ACTION ON SYM_TAB (ONLY statement CHANGES SYM_TAB) */
/*
switch_statement
    : _SWITCH _LPAREN num_exp _RPAREN _LBRACKET case_list _RBRACKET
    ;
*/
/* LIST OF CASES */
/* TO BE DELT WITH */
/*
case_list
    : case_list case_statement
    | case_statement
    ;
*/
/* CASE STATEMENT */
/* TO BE DELT WITH */ /* ALLOW ONLY ONE default */
/*
case_statement
    : _CASE num_exp _COLON case_block
    | _DEFAULT _COLON case_block
    ;
*/
/* LIST OF ALLOWED STATEMENTS INSIDE A CASE BLOCK */
/* TO BE DELT WITH */
/*
case_block
    : case_block case_state
    | case_state
    ;
*/
/* ALLOWED STATEMENTS INSIDE A CASE BLOCK */
/* TO BE DELT WITH */
/*
case_state
    : assignment_statement
    | function_call _SEMICOLON // FOR VOID FUNCTIONS
    | _CONTINUE _SEMICOLON
    | _BREAK _SEMICOLON
    ;
*/
/* DO WHILE STATEMENT */
/* TO BE DELT WITH -- NO ACTION ON SYM_TAB (ONLY statement CHANGES SYM_TAB) */
/*
do_while_statement
    : _DO statement _WHILE _LPAREN condition _RPAREN _SEMICOLON
    ;
*/
/* SIMPLE ASSIGN STATEMENTS */
/* TO BE DELT WITH */
/* change_statement
    : data _ASSIGN num_exp
        {
            printf("add t0, x0, t1\n"); // PUT num_exp ON t1
            printf("sw t0, %d, x0\n", 4*$1); // 4*$1 IS A SIMPLE MAP: SYM_TAB -> DATA MEMORY
        }
    | data _ASSIGN _AMP data
        {
            printf("addi t0, x0, %d\n", 4*$1);
            printf("sw t0, %d, x0\n", 4*$1);
        }
    | data _ITER
        {
            if($2 == INC){
                printf("addi t0, t0, 1\n");
            }
            else{
                printf("addi t1, x0, 1\n");
                printf("sub t0, t0, t1\n");
            }
            printf("sw t0, %d, x0\n", 4*$1);
        }
    | _ITER data
        {
            if($1 == INC){
                printf("addi t0, t0, 1\n");
            }
            else{
                printf("addi t1, x0, 1\n");
                printf("sub t0, t0, t1\n");
            }
            printf("sw t0, %d, x0\n", 4*$2);
        }
    ; */
/* TO BE ADDED */
/*
++ a+b*c
++ += -= *= ...
++ global var
++ MACRO -- USING PREPROCESSOR, MAYBE INSIDE LEXER
++ ASSING IN DEFINITION
-- CONST
-- pointer on a pointer
-- pointer on a function
*/

%%

int yyerror(char *s){
    fprintf(stderr, "\nline %d: ERROR: %s\n", yylineno, s);
    error_count++;
    return 0;
}
int main(){
    int syntax_error;
    SYMBOL_ENTRY *head;
    
    init_symtab(&head);
    
    printf("jal start\n");

    /* INIT LOOP LABELS */
    for(for_depth = 0; for_depth < LOOP_DEPTH; for_depth++){
        for_layer[for_depth] = 0;
    }
    for_depth = 0;

    for(while_depth = 0; while_depth < LOOP_DEPTH; while_depth++){
        while_layer[while_depth] = 0;
    }
    while_depth = 0;

    for(if_depth = 0; if_depth < LOOP_DEPTH; if_depth++){
        if_layer[if_depth] = 0;
    }
    if_depth = 0;

    syntax_error = yyparse();
    
    // print_symtab(&head);
    
    destroy_list(&head);

    if(syntax_error)
        return -1;
    else
        return error_count;
}
    
