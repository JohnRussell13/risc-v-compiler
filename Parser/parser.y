%{
    #include <stdio.h>
    #include "definitions.h"
    #include "symtab.h"

    int yyparse(void);
    int yylex(void);
    int yyerror(char *s);
    void warning(char *s);
    extern int yylineno;
    int error_count;
    int warning_count;
    int num_exp_cnt = 0; // not in use now, but needed to make deep nested expresions possible; also needed for rel
    int lab_cnt = 0;
    int func_ind = 0;
    int args = 1;

    /* SYM_TAB HELPER VARIABLES */
    char tab_name[SYMBOL_TABLE_LENGTH];
    int tab_ind;
    int tab_type;
    int tab_kind;
    unsigned tab_array_count;
    SYMBOL_ENTRY *head;
%}

/* POSSIBLE TYPES */
%union {
    int i;
    char *s;
    int pp[2];
    unsigned ar[MAX_DIM];
    enum ops a;
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
%type <i> type literal data function_call // index
%type <pp> possible_pointer // index AND is it new
%type <a> ar_op log_op helper_exp helper_cond helper_cond_simp // operation
%type <ar> array_member_definition array_member // dimension
%type <i> array_param // value?
%type <pp> exp // index AND which rule

/* SPECIAL RULES */
%nonassoc ONLY_IF   /* NOT ALWAYS; JUST IN THE CASE THAT THERE IS NO ELSE (HENCE NO _ - ONLY_IF IS NOT A TOKEN) */
%nonassoc _ELSE

%start program

%%

/* SYMBOL TABLE AFTER MAIN IS MAPPED DIRECTLY TO THE DATA MEMORY */
/* WE MUST CLEAR SYM_TAB AFTER END OF A FUNCTION IN ORDER TO ALLOW NAME RECYCLING */
/* WHEN WE CALL THE FUNCTION, WE MUST ADD DATA TO THE TOP OF THE DATA MEMORY */
/* ONLY variable AND assignment CAN CHANGE THE DATA MEMORY (LWI SWI) */

/* WHOLE PROGRAM */
/* INIT SYM_TAB */
program
    : function_list
        {
            printf("start:\n");
            printf("addi gp, x0, %d\n", 4*(1+lookup_function_size(&head, lookup_symbol(&head, "main"))));
            printf("addi s11, gp, 0\n");
            printf("addi tp, x0, 0\n");
            printf("jal main\n");
            printf("end: nop\n");
        }
    ;
/* LIST OF FUNCTIONS -- RECURSIVE RULE */
/* NO ACTION */
function_list
    : function
    | function_list function
    ;
/* FUNCTION DEFINITION */
/* CHECK IF THE NAME IS FREE AND ADD IT TO THE SYM_TAB; CHECK  */
function
    : type _ID
        {
            tab_ind = lookup_symbol(&head, $2);
            if(tab_ind == -1){
                tab_ind = insert_symbol(&head, $2, FUN, $1);
            }
            else{
                printf("ERROR: redefinition of a function '%s'\n", $2);
            }

        }
        _LPAREN parameter_list _RPAREN 
        {
            printf("%s:\n", $2);
            printf("sw ra, 0, s11\n");
        } 
        body
        {
            //tab_ind = lookup_symbol(&head, $2);
            //tab_ind = get_param(&head);
            //printf("%d\n", tab_ind);
            //print_symtab(&head);

            //clear_symbols(&head, tab_ind+1); // CLEAR PARAMS

            printf("jalr ra\n");
        }
    ;
/* NUMBER */
/* RETURN THE VALUE OF A GIVEN NUMBER */
literal
    : _INT_NUMBER
        {
            tab_ind = insert_symbol(&head, $1, LIT, INT);
            $$ = tab_ind;
        }
    | _UINT_NUMBER
        {
            tab_ind = insert_symbol(&head, $1, LIT, UINT);
            $$ = tab_ind;
        }
    | _HEX_NUMBER
        {
            tab_ind = insert_symbol(&head, $1, LIT, HEX_NUMBER);
            $$ = tab_ind;
        }
    ;
/* TYPE */
/* RETURN TYPE */ /* MAYBE EXPAND WITH CONST */
type
    : _TYPE
        {
            $$ = $1;
        }
    ;
/* ID OF SOME PAR OR VAR */
/* RETURN INDEX AND IS IT NEW */
possible_pointer
    : _ID
        {
            strcpy(tab_name, $1);
            func_ind = get_func(&head);
            tab_ind = lookup_symbol_func(&head, tab_name, func_ind);
            if(tab_ind == -1){ //new or new in this function
                tab_ind = insert_symbol(&head, tab_name, 0, 0); // JUST SET THE NAME
                
                $$[0] = tab_ind - func_ind;
                $$[1] = 1;
            }
            else{
                $$[0] = tab_ind - func_ind;
                $$[1] = 0;
            }
        }
    | _STAR _ID
        {
            strcpy(tab_name, $2);
            func_ind = get_func(&head);
            tab_ind = lookup_symbol_func(&head, tab_name, func_ind);
            if(tab_ind == -1){
                tab_ind = insert_symbol(&head, tab_name, 0, 0);
                set_pointer(&head, tab_ind + func_ind);
                $$[0] = tab_ind - func_ind;
                $$[1] = 1;
            }
            else{
                $$[0] = tab_ind - func_ind;
                $$[1] = 0;
            }
        }
    ;
/* NO PARAMETERS OR LIST OF FUNCTIONS PARAMETERS */
/* NO ACTION */
parameter_list
    : /* empty */
    | parameter
/* LIST OF FUNCTIONS PARAMETERS */
/* CHEK IF THE NAME IS FREE AND MAKE A NEW SYM_TAB ENTRY */
parameter
    : parameter _COMMA type possible_pointer
        {
            func_ind = get_func(&head);
            strcpy(tab_name, get_name(&head, $4[0]));
            if($4[1]){
                set_type(&head, $4[0] + func_ind, $3);
                set_kind(&head, $4[0] + func_ind, PAR); // PAR or VAR? is PAR needed? yes - PAR can't be changed
            }
            else{
                printf("ERROR: PARAM ISSUE: redefinition of a ID '%s'\n", tab_name);
            }
        }
    | type possible_pointer
        {
            func_ind = get_func(&head);
            strcpy(tab_name, get_name(&head, $2[0]));
            if($1 == VOID){
                printf("ERROR: PARAM DEF ISSUE: parameter '%s' can not be of VOID type\n",tab_name);
            }
            if($2[1]){
                set_type(&head, $2[0] + func_ind, $1);
                set_kind(&head, $2[0] + func_ind, PAR);
            }
            else{
                printf("ERROR: PARAM ISSUE: redefinition of a ID '%s'\n", tab_name);
            }
        }
    ;
/* BODY OF A FUNCTION */
/* NO ACTION */
body
    : _LBRACKET variable_list statement_list _RBRACKET
    ;
/* LIST OF VARIABLE DECLARATIONS */
/* NO ACTION */
variable_list
    : /* empty */
    | variable_list variable
    ;
/* VARIABLE DECLARATION */ /* MAYBE ADD DEFINTIONS AS WELL -- int x = 5; */
/* CHEK IF THE NAME IS FREE AND MAKE A NEW SYM_TAB ENTRY */
variable
    : type possible_pointer _SEMICOLON
        {
            func_ind = get_func(&head);
            strcpy(tab_name, get_name(&head, $2[0]));
            if($1 == VOID){
                printf("ERROR: VAR DEF ISSUE: variable '%s' can not be of VOID type\n",tab_name);
            }
            if($2[1]){
                set_type(&head, $2[0] + func_ind, $1);
                set_kind(&head, $2[0] + func_ind, VAR);
            }
            else{
                printf("ERROR: VAR DECL ISSUE: redefinition of a ID '%s'\n", tab_name);
            }
        }
    | type possible_pointer
        {
            func_ind = get_func(&head);
            strcpy(tab_name, get_name(&head, $2[0]));
            if($2[1]){
                set_type(&head, $2[0] + func_ind, $1);
                set_kind(&head, $2[0] + func_ind, VAR);
                tab_array_count = 0;
            }
            else{
                printf("ERROR: VAR DECL ISSUE: redefinition of a ID '%s'\n", tab_name);
            }
        }
        array_member_definition _SEMICOLON
            {
                func_ind = get_func(&head);
                set_dimension(&head, $2[0] + func_ind, $4, tab_array_count);
            }
    ;
/* ARRAY PART IN A DECLARATION */
/* ARRAYS SHOULD BE DEALT WITH -- LAST [] IS THE DIM = 0 */
array_member_definition
    : array_member_definition _LSQBRACK array_param _RSQBRACK
        {
            if(tab_array_count >= MAX_DIM){
                printf("ERROR: ARRAY SIZE ISSUE: too many dimensions\n");
            }
            $$[tab_array_count++] = $3;
        }
    | _LSQBRACK array_param _RSQBRACK
        {
            if(tab_array_count >= MAX_DIM){
                printf("ERROR: ARRAY SIZE ISSUE: too many dimensions\n");
            }
            $$[tab_array_count++] = $2;
        }
    ;
/* ALLOWED PARAMETERS TYPES OF AN ARRAY */
/* ARRAYS SHOULD BE DEALT WITH */ /* MAYBE ADD MACRO */
array_param
    : literal
        {
            $$ = atoi(get_name(&head, $1));
        }
    ;
/* LIST OF STATEMENTS */
/* NO ACTION */
statement_list
    : /* empty */
    | statement_list statement
    ;
/* POSSIBLE STATEMENTS -- NO RETURN VALUE */
/* NO ACTION */
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

/* COMPOUND STATMENT -- {} BLOCK */
/* NO ACTION */
compound_statement
    : _LBRACKET statement_list _RBRACKET
    ;
/* ASSIGNMENT -- x = 5;*/
/* PRINT ASSEMBLY CODE */
/* TO BE DELT WITH -- i++ vs ++i */
assignment_statement
    : data _ASSIGN num_exp _SEMICOLON
        {
            printf("add t0, x0, t1\n"); // PUT num_exp ON t1
            printf("sw t0, %d, tp\n", 4*$1); // 4*$1 IS A SIMPLE MAP: SYM_TAB -> DATA MEMORY
        }
    | data _ASSIGN _AMP data _SEMICOLON
        {
            printf("addi t0, x0, %d\n", 4*$1);
            printf("sw t0, %d, tp\n", 4*$1);
        }
    | data _ITER _SEMICOLON
        {
            if($2 == INC){
                printf("addi t0, t0, 1\n");
            }
            else{
                printf("addi t1, x0, 1\n");
                printf("sub t0, t0, t1\n");
            }
            printf("sw t0, %d, tp\n", 4*$1);
        }
    | _ITER data _SEMICOLON
        {
            if($1 == INC){
                printf("addi t0, t0, 1\n");
            }
            else{
                printf("addi t1, x0, 1\n");
                printf("sub t0, t0, t1\n");
            }
            printf("sw t0, %d, tp\n", 4*$2);
        }
    ;
/* possible_pointer OR array of possible_pointer */
/* CHECK IF IT EXISTS AND RETURN ITS INDEX */
data
    : possible_pointer
        {
            strcpy(tab_name, get_name(&head, $1[0]));
            tab_kind = get_kind(&head, $1[0]);
            if($1[1]){
                printf("ERROR: DATA ISSUE: non-existing ID '%s'\n", tab_name);
            }
            else{
                if(tab_kind != VAR && tab_kind != PAR){
                    printf("ERROR: DATA ISSUE: ID of a non-VAR and non-PAR kind'%s'\n", tab_name);
                }
                else{
                    $$ = $1[0];
                }
            }
        }
    | possible_pointer array_member
        {
            strcpy(tab_name, get_name(&head, $1[0]));
            tab_kind = get_kind(&head, $1[0]);
            if($1[1]){
                printf("ERROR: DATA ISSUE: non-existing ID '%s'\n", tab_name);
            }
            else{
                if(tab_kind != VAR && tab_kind != PAR){
                    printf("ERROR: DATA ISSUE: ID of a non-VAR and non-PAR kind'%s'\n", tab_name);
                }
                else{
                    $$ = $1[0];
                }
            }
        }
    ;
/* ARRAY PARAMETERS */
/* PRINT ASSEMBLY CODE */ /* BE CAREFULL WITH function_call MUSN'T BE VOID*/
array_member
    : array_member _LSQBRACK num_exp _RSQBRACK
        {
        }
    | _LSQBRACK num_exp _RSQBRACK
        {
        }
    ;
/* ARITHMETICAL OPERATIONS */
/* RETURN WHAT OPERATION IS USED */
ar_op
    : _PLUS
        {
            $$ = PLUS;
        }
    | _MINUS
        {
            $$ = MINUS;
        }
    | _STAR
        {
            $$ = STAR;
        }
    | _DIV
        {
            $$ = DIV;
        }
    | _MOD
        {
            $$ = MOD;
        }
    | _SR
        {
            $$ = SR;
        }
    | _SL
        {
            $$ = SL;
        }
    | _AMP
        {
            $$ = AMP;
        }
    | _BOR
        {
            $$ = BOR;
        }
    | _BXOR
        {
            $$ = BXOR;
        }
    ;
/* LOGIAL OPERATION */
/* RETURN WHAT OPERATION IS USED */
log_op
    : _AND
        {
            $$ = AND;
        }
    | _OR
        {
            $$ = OR;
        }
    ;
/* NUMERICAL EXPRESSION -- (x+7)*sq(3) */
/* PRINT ASSEMBLY CODE BY STORING THE INTERMEDIATE RESULTS */
/* RESULTS ARE KEPT IN t1 AND t2 */
/* TO BE DELT WITH0 - *, /, FUNCTIONS */
num_exp
    : exp
        {
            switch($1[1]){
                case 0:
                    printf("addi t1, x0, %d\n", atoi(get_name(&head, $1[0])));
                    break;
                case 1:
                    printf("lw t1, %d, tp\n", 4*$1[0]);
                    break;
                case 2:
                    /* DEAL WITH FUNCTION RETURN */
                    break;
            }
        }
    | exp ar_op exp
        {
            switch($1[1]){
                case 0:
                    printf("addi t1, x0, %d\n", atoi(get_name(&head, $1[0])));
                    break;
                case 1:
                    printf("lw t1, %d, tp\n", 4*$1[0]);
                    break;
                case 2:
                    /* DEAL WITH FUNCTION RETURN */
                    break;
            }
            switch($3[1]){
                case 0:
                    printf("addi t2, tp, %d\n", atoi(get_name(&head, $3[0])));
                    break;
                case 1:
                    printf("lw t2, %d, tp\n", 4*$3[0]);
                    break;
                case 2:
                    /* DEAL WITH FUNCTION RETURN */
                    break;
            }
            switch($2){
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
                    //printf("ERROR: NUM EXPR ISSUE: dividing with zero\n");
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
                    //printf("ERROR: NUM EXPR ISSUE: modular with a negative\n");
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
                    //printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
                    printf("srl t1, t1, t2\n");
                    break;
                case SL:
                    //printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
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
    | exp ar_op _LPAREN num_exp _RPAREN
        {
            printf("add t2, x0, t1\n");
            switch($1[1]){
                case 0:
                    printf("addi t1, x0, %d\n", atoi(get_name(&head, $1[0])));
                    break;
                case 1:
                    printf("lw t1, %d, tp\n", 4*$1[0]);
                    break;
                case 2:
                    /* DEAL WITH FUNCTION RETURN */
                    break;
            }
            switch($2){
                case PLUS:
                    printf("add t1, t1, t2\n");
                    break;
                case MINUS:
                    printf("sub t1, t1, t2\n");
                    break;
                case STAR:
                    //printf("mul t1, t1, t2\n"); //IMPLEMENT MULTIPLICATION

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
                    //printf("ERROR: NUM EXPR ISSUE: dividing with zero\n");
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
                    //printf("ERROR: NUM EXPR ISSUE: modular with a negative\n");
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
                    //printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
                    printf("srl t1, t1, t2\n");
                    break;
                case SL:
                    //printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
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
    | helper_exp exp
        {
            printf("add t2, x0, t1\n");
            printf("add t1, x0, t3\n");
            switch($2[1]){
                case 0:
                    printf("addi t2, x0, %d\n", atoi(get_name(&head, $2[0])));
                    break;
                case 1:
                    printf("lw t2, %d, tp\n", 4*$2[0]);
                    break;
                case 2:
                    /* DEAL WITH FUNCTION RETURN */
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
                    //printf("mul t1, t1, t2\n"); //IMPLEMENT MULTIPLICATION

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
                    //printf("ERROR: NUM EXPR ISSUE: dividing with zero\n");
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
                    //printf("ERROR: NUM EXPR ISSUE: modular with a negative\n");
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
                    //printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
                    printf("srl t1, t1, t2\n");
                    break;
                case SL:
                    //printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
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
    | helper_exp _LPAREN num_exp _RPAREN
        {
            printf("add t2, x0, t1\n");
            printf("add t1, x0, t3\n");
            switch($1){
                case PLUS:
                    printf("add t1, t1, t2\n");
                    break;
                case MINUS:
                    printf("sub t1, t1, t2\n");
                    break;
                case STAR:
                    //printf("mul t1, t1, t2\n"); //IMPLEMENT MULTIPLICATION

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
                    //printf("ERROR: NUM EXPR ISSUE: dividing with zero\n");
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
                    //printf("ERROR: NUM EXPR ISSUE: modular with a negative\n");
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
                    //printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
                    printf("srl t1, t1, t2\n");
                    break;
                case SL:
                    //printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
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
    | _PLUS exp /* ONLY FOR +- IN CASE OF -5 */
        {
            switch($2[1]){
                case 0:
                    printf("addi t1, x0, %d\n", atoi(get_name(&head, $2[0])));
                    break;
                case 1:
                    printf("lw t1, %d, tp\n", 4*$2[0]);
                    break;
                case 2:
                    /* DEAL WITH FUNCTION RETURN */
                    break;
            }
        }
    | _MINUS exp /* ONLY FOR +- IN CASE OF -5 */
        {
            switch($2[1]){
                case 0:
                    printf("addi t1, x0, %d\n", atoi(get_name(&head, $2[0])));
                    break;
                case 1:
                    printf("lw t1, %d, tp\n", 4*$2[0]);
                    break;
                case 2:
                    /* DEAL WITH FUNCTION RETURN */
                    break;
            }
            printf("sub t1, x0, t1\n");
        }
    | data _ITER
        {
            printf("lw t1, %d, tp\n", 4*$1);
            if($2 == INC){
                printf("addi t2, t1, 1\n");
            }
            else{
                printf("addi t2, x0, 1\n"); //NO SUBI ...
                printf("sub t0, t1, t2\n");
            }
            printf("sw t0, %d, tp\n", 4*$1);
        }
    | _ITER data
        {
            printf("lw t1, %d, tp\n", 4*$2);
            if($1 == INC){
                printf("addi t1, t1, 1\n");
            }
            else{
                printf("addi t2, x0, 1\n");
                printf("sub t1, t1, t2\n");
            }
            printf("sw t0, %d, tp\n", 4*$2);
        }
    ;
/* HELPER */
/* copy t1 into t3, which will go to t2 when there are two num_exp*/
helper_exp
    : _LPAREN num_exp _RPAREN ar_op
        {
            printf("add t3, x0, t1\n");
            $$ = $4;
        }
    ;
/* ALLOWED PARTS OF num_exp */
/* RETURN THE INDEX */
exp
    : literal
        {
            $$[0] = $1;
            $$[1] = 0;
        }
    | data
        {
            /*!!! custom map() sym_tab -> memory location !!!*/
            tab_kind = get_kind(&head, $1);
            if(tab_kind == VAR || tab_kind == PAR){
                $$[0] = $1;
                $$[1] = 1;
            }
            else{
                printf("ERROR: EXPRESSION ISSUE: no value of a non-VAR and non-PAR kind\n");
            }
        }
    | function_call
        {
            /*!!! custom map() sym_tab -> label !!!*/
            tab_kind = get_kind(&head, $1);
            if(tab_kind == VOID){
                printf("ERROR: FUNC CALL ISSUE: no return value of a void kind\n");
            }
            else{
                $$[0] = $1;
                $$[1] = 2;
            }
        }
    ;
/* FUNCTION CALL (THAT RETURNS A VALUE -- INSIDE A num_exp) */
/* CHECK IF EXISTING FUNC IS CALLED AND RETURN ITS INDEX */
function_call
    : _ID _LPAREN argument_list _RPAREN /* possible_pointer */
        {
            args = 1;
            /* CAREFULL WITH x1 (ra) */
            tab_ind = lookup_symbol(&head, $1);
            if(tab_ind == -1){ // CHECK IF OFF BY ONE
                printf("ERROR: FUNC CALL ISSUE: non-existing ID '%s'\n", $1);
            }

            /* SET NEW INFO */
            //gp stores parent (current) function data size (stack depth)
            //tp stores grandparent function begining
            //s11 stores child function begining
            printf("add s11, tp, gp\n"); //update child's beginig
            //printf("sw tp, 0, s11\n"); //set parent's begining in child
            printf("add tp, tp, gp\n"); //update current function begining
            printf("addi gp, gp, %d\n", 4*(1+lookup_function_size(&head, tab_ind))); //update current size

            /* JUMP */
            printf("jal %s\n", $1);
            $$ = tab_ind;

            printf("lw ra, 0, s11\n");
        }
    ;
/* ARGUMENTS OF A FUNCTION CALL */
/* NO ACTION */
argument_list
    : /* empty */
    | argument
    ;
/* ARGUMENTS OF A FUNCTION CALL */
/* TO BE DELT WITH -- MAP TO THE DATA MEMORY*/
argument
    : argument _COMMA num_exp
        {
            printf("sw t1, %d, s11\n", 4*args);
            args++;
        }
    | num_exp
        {
            printf("sw t1, %d, s11\n", 4*args);
            args++;
        }
    ;
/* IF STATEMENT */
/* PRINT ALL jmps */
if_statement
    : helper_if %prec ONLY_IF
        {
            printf("l%db:\n", lab_cnt++);
        }
    |  helper_if _ELSE statement
        {
            printf("l%db:\n", lab_cnt++);
        }
    ;
/* HELPER */
/* AS BEFORE */
helper_if
    : _IF _LPAREN condition _RPAREN {printf("beq t1, x0, l%da\n", lab_cnt);} statement
        {
            printf("beq x0, x0, l%db\n", lab_cnt); //always branch -- skip else after if is done
            printf("l%da:\n", lab_cnt);
        }
    ;
/* IF CONDTITIONS */
condition
    : rel_exp
    | cond_cplx
    ;

cond_cplx
    : helper_cond_simp rel_exp
        {
            printf("addi t2, t1, x0\n");
            printf("addi t1, t3, x0\n");
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
    | helper_cond_simp _LPAREN cond_cplx _RPAREN
        {
            printf("addi t2, t1, x0\n");
            printf("addi t1, t3, x0\n");
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
    | helper_cond rel_exp
        {
            printf("addi t2, t1, x0\n");
            printf("addi t1, t3, x0\n");
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
    | helper_cond _LPAREN cond_cplx _RPAREN
        {
            printf("addi t2, t1, x0\n");
            printf("addi t1, t3, x0\n");
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
/* HELPER */
/* AS BEFORE */
helper_cond_simp
    : rel_exp log_op
        {
            printf("addi t3, t1, x0\n");
            $$ = $2;
        } 
    ;
/* HELPER */
/* AS BEFORE */
helper_cond
    : _LPAREN cond_cplx _RPAREN log_op
        {
            printf("addi t3, t1, x0\n");
            $$ = $4;
        }
    ;
/* REALATIONAL EXPRESSION */
/* PRINT ASSEMBLY CODE 1 OR 0 IN t1 DEPENDING ON THE OUTCOME OF THE EXPRESSION */
rel_exp
    : num_exp _RELOP {printf("add t4, x0, t1\n");} num_exp
        {
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
    ;
/* RETURN STATMENT -- EITHER retur x; OR return; */
/* CHECK IF RETURN TYPE IS CORRECT AND SET THE VALUE OF A FUNCTION */
return_statement
    : _RETURN num_exp _SEMICOLON
        {
            /* WRITE VAL TO THE REGISTER/DATA MEMORY JUMP BACK */
            tab_ind = get_func(&head);
            tab_type = get_type(&head, tab_ind);
            if(tab_type == VOID){
                printf("ERROR: RETURN ISSUE: value in a void type\n");
            }
            else{
                //set_value(&head, tab_ind, $2);
            }
        }
    | _RETURN _SEMICOLON /* FOR VOID ONLY */
        {
            /* ALWAYS NEEDED OR NOT? */

            /* JUMP BACK */
            tab_ind = get_func(&head);
            tab_type = get_type(&head, tab_ind);
            if(tab_type != VOID){
                printf("ERROR: RETURN ISSUE: missing value in non-void type\n");
            }
        }
    ;
/* WHILE STATEMENT */
/* TO BE DELT WITH -- NO ACTION ON SYM_TAB (ONLY statement CHANGES SYM_TAB) */
while_statement
    : _WHILE {printf("l%dw:\n", lab_cnt);} _LPAREN condition _RPAREN {printf("beq t1, x0, l%dw\n", lab_cnt+1);}  statement
        {
            printf("beq x0, x0, l%dw\n", lab_cnt);
            printf("l%dw:\n", ++lab_cnt);
        }
    ;
/* SWITCH STATEMENT */
/* TO BE DELT WITH -- NO ACTION ON SYM_TAB (ONLY statement CHANGES SYM_TAB) */
/*
switch_statement
    : _SWITCH _LPAREN num_exp _RPAREN _LBRACKET case_list _RBRACKET
        {
        }
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
/* FOR STATEMENT */
/* TO BE DELT WITH -- NO ACTION ON SYM_TAB (ONLY statement CHANGES SYM_TAB) */
/* for_statement
    : _FOR _LPAREN assignment_statement {
        printf("l%df:\n", lab_cnt);
    } condition {
        printf("beq t1, x0, l%df\n", lab_cnt+1);
    } _SEMICOLON change_statement _RPAREN statement {
        printf("beq x0 x0, l%df\n", lab_cnt);
        printf("l%df:\n", ++lab_cnt);
    }
    ; */
for_start
    : _FOR _LPAREN assignment_statement {
        printf("l%df:\n", lab_cnt);
    } condition {
        printf("beq t1, x0, l%df\n", lab_cnt+1);
    } _SEMICOLON
    ;

for_statement 
    : for_start data _ASSIGN num_exp _RPAREN statement
        {
            printf("lw t0, %d, tp\n", 4*$2);
            printf("add t0, x0, t1\n"); // PUT num_exp ON t1
            printf("sw t0, %d, tp\n", 4*$2); // 4*$1 IS A SIMPLE MAP: SYM_TAB -> DATA MEMORY

            printf("beq x0 x0, l%df\n", lab_cnt);
            printf("l%df:\n", ++lab_cnt);
        }
    | for_start data _ASSIGN _AMP data _RPAREN statement
        {
            printf("lw t0, %d, tp\n", 4*$2);
            printf("addi t0, x0, %d\n", 4*$2);
            printf("sw t0, %d, tp\n", 4*$2);

            printf("beq x0 x0, l%df\n", lab_cnt);
            printf("l%df:\n", ++lab_cnt);
        }
    | for_start data _ITER _RPAREN statement
        {
            printf("lw t0, %d, tp\n", 4*$2);
            if($3 == INC){
                printf("addi t0, t0, 1\n");
            }
            else{
                printf("addi t1, x0, 1\n");
                printf("sub t0, t0, t1\n");
            }
            printf("sw t0, %d, tp\n", 4*$2);

            printf("beq x0 x0, l%df\n", lab_cnt);
            printf("l%df:\n", ++lab_cnt);
        }
    | for_start _ITER data _RPAREN statement
        {
            printf("lw t0, %d, tp\n", 4*$2);
            if($2 == INC){
                printf("addi t0, t0, 1\n");
            }
            else{
                printf("addi t1, x0, 1\n");
                printf("sub t0, t0, t1\n");
            }
            printf("sw t0, %d, tp\n", 4*$3);

            printf("beq x0 x0, l%df\n", lab_cnt);
            printf("l%df:\n", ++lab_cnt);
        }
    ;

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

void warning(char *s){
	fprintf(stderr,"\nline %d: WARNING: %s\n",yylineno,s);
	warning_count++;
}
int main(){
    int syntax_error;
    SYMBOL_ENTRY *head;
    
    init_symtab(&head);
    
    printf("jal start\n");

    syntax_error = yyparse();
    
    // print_symtab(&head);
    
    clear_symbols(&head,0);
    
    if(warning_count)
        printf("\n%d warning(s).\n",warning_count);
    if(error_count)
        printf("\n%d error(s).\n",error_count);

    if(syntax_error)
        return -1;
    else
        return error_count;
}
    
