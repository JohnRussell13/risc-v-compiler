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
    int for_depth = 0;
    int for_layer[CHAR_BUFFER_LENGTH]; 
    int while_depth = 0;
    int while_layer[CHAR_BUFFER_LENGTH]; 
    int func_ind = 0;
    int args = 1;
    int sq_arg = 0;
    int sq_subarg = 0;
    int sq_mul = 0;
    unsigned *dims;

    /* SYM_TAB HELPER VARIABLES */
    char tab_name[LOOP_DEPTH];
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
    int ppp[3];
    enum ops a;
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
%type <i> type literal data function_call // index
%type <pp> possible_pointer // index AND is it new
%type <a> ar_op log_op helper_num_exp helper_cond helper_cond_simp // operation
%type <i> array_param // value?
%type <pp> exp // index AND which rule
%type <ppp> helper_exp // index, which rule AND which op
%type <d> array_member_definition

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
            printf("jal count\n");
            printf("count:\n");
            printf("addi gp, x0, %d\n", function_map(&head, lookup_symbol(&head, "main")));
            printf("addi tp, ra, 20\n"); //these lines are 4*5
            printf("add s11, tp, gp\n"); //update child's beginig  
            printf("jal main\n");
            printf("end: nop\n");
            //print_symtab(&head);
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
            printf("sw ra, 0, tp\n"); //save where to return
            printf("sw gp, -4, s11\n"); //save data size of parent function
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
            strcpy(tab_name, get_name(&head, $4[0] + func_ind));
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
            strcpy(tab_name, get_name(&head, $2[0] + func_ind));
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
            strcpy(tab_name, get_name(&head, $2[0] + func_ind));
            if($1 == VOID){
                printf("ERROR: VAR DEF ISSUE: variable '%s' can not be of VOID type\n", tab_name);
            }
            if($2[1]){
                set_type(&head, $2[0] + func_ind, $1);
                set_kind(&head, $2[0] + func_ind, VAR);
            }
            else{
                printf("ERROR: VAR DECL ISSUE: redefinition of a ID '%s'\n", tab_name);
            }
        }
    | type possible_pointer array_member_definition _SEMICOLON
        {
            func_ind = get_func(&head);
            strcpy(tab_name, get_name(&head, $2[0] + func_ind));
            if($2[1]){
                set_type(&head, $2[0] + func_ind, $1);
                set_kind(&head, $2[0] + func_ind, VAR);
            }
            else{
                printf("ERROR: VAR DECL ISSUE: redefinition of a ID '%s'\n", tab_name);
            }
            func_ind = get_func(&head);
            set_dimension(&head, $2[0] + func_ind, $3, tab_array_count);
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
            tab_array_count = 0;
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
/* TO BE DELT WITH -- VAR vs PAR */
assignment_statement
    : data _ASSIGN
        {
            push("s4", 1);
        }
        num_exp _SEMICOLON
        {
            pop("s4", 1);
            printf("add t0, x0, t1\n"); // PUT num_exp ON t1
            printf("sw t0, 0, s4\n");
        }
    | data _ASSIGN _AMP {
            printf("add s5, s4, x0\n");
        } data _SEMICOLON {
            printf("add t0, s4, x0\n");
            printf("sw t0, 0, s5\n");
        }
    | data _ITER _SEMICOLON {
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
/* possible_pointer OR array of possible_pointer */
/* USED AS MEMORY MAP */
/* CHECK IF IT EXISTS AND RETURN ITS INDEX */ /* ASSING, NUM_EXP, EXP, FOR */
data
    : possible_pointer
        {
            func_ind = get_func(&head);
            strcpy(tab_name, get_name(&head, $1[0] + func_ind));
            tab_kind = get_kind(&head, $1[0] + func_ind);
            if($1[1]){
                printf("ERROR: DATA ISSUE: non-existing ID '%s'\n", tab_name);
            }
            if(tab_kind != VAR && tab_kind != PAR){
                printf("ERROR: DATA ISSUE: ID of a non-VAR and non-PAR kind - '%s'\n", tab_name);
            }
            $$ = $1[0] + func_ind;

            printf("addi s4, tp, %d\n", memory_map(&head, tab_name, func_ind));
        }
    | possible_pointer array_member
        {
            func_ind = get_func(&head);
            strcpy(tab_name, get_name(&head, $1[0] + func_ind));
            tab_kind = get_kind(&head, $1[0] + func_ind);
            if($1[1]){
                printf("ERROR: DATA ISSUE: non-existing ID '%s'\n", tab_name);
            }
            if(tab_kind != VAR && tab_kind != PAR){
                printf("ERROR: DATA ISSUE: ID of a non-VAR and non-PAR kind - '%s'\n", tab_name);
            }
            $$ = $1[0] + func_ind;

            dims = get_dimension(&head, $1[0] + get_func(&head));

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

        }
    ;
/* ARRAY PARAMETERS */
/* PRINT ASSEMBLY CODE */ /* BE CAREFULL WITH function_call MUSN'T BE VOID*/
array_member
    : array_member _LSQBRACK num_exp _RSQBRACK
        {
            sq_arg++;
            printf("add a%d, t1, x0\n", sq_arg);
        }
    | _LSQBRACK num_exp _RSQBRACK
        {
            sq_arg = 0;
            printf("add a%d, t1, x0\n", sq_arg);
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
num_exp
    : exp
        {
            switch($1[1]){
                case 0:
                    printf("addi t1, x0, %d\n", $1[0]);
                    break;
                case 1:
                    printf("lw t1, 0, s4\n");
                    break;
                case 2:
                    /* DEAL WITH FUNCTION RETURN */
                    printf("lw t1, 0, s0\n");
                    break;
            }
        }
    | helper_exp exp
        {
            switch($2[1]){
                case 0:
                    printf("addi t2, x0, %d\n", $2[0]);
                    break;
                case 1:
                    printf("lw t2, 0, s4\n");
                    break;
                case 2:
                    /* DEAL WITH FUNCTION RETURN */
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
                    /* DEAL WITH FUNCTION RETURN */
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
    | helper_num_exp exp
        {
            pop("t1", 1);
            switch($2[1]){
                case 0:
                    printf("addi t2, x0, %d\n", $2[0]);
                    break;
                case 1:
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
    | helper_num_exp _LPAREN num_exp _RPAREN
        {
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
                    printf("addi t1, x0, %d\n", $2[0]);
                    break;
                case 1:
                    printf("lw t1, 0, s4\n");
                    break;
                case 2:
                    printf("lw t1, 0, s0\n");
                    break;
            }
        }
    | _MINUS exp /* ONLY FOR +- IN CASE OF -5 */
        {
            switch($2[1]){
                case 0:
                    printf("addi t1, x0, %d\n", $2[0]);
                    break;
                case 1:
                    printf("lw t1, 0, s4\n");
                    break;
                case 2:
                    printf("lw t1, 0, s0\n");
                    break;
            }
            printf("sub t1, x0, t1\n");
        }
    | data _ITER
        {
            printf("lw t1, 0, s4\n");
            if($2 == INC){
                printf("addi t2, t1, 1\n");
            }
            else{
                printf("addi t2, x0, -1\n"); //NO SUBI
            }
            printf("sw t2, 0, s4\n");
        }
    | _ITER data
        {
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
/* put on stack s4 and s0 */
helper_exp
    : exp ar_op
        {
            switch($1[1]){
                case 1:
                    push("s4", 1);
                    break;
                case 2:
                    push("s0", 1);
                    break;
            }
            
            $$[0] = $1[0];
            $$[1] = $1[1];
            $$[2] = $2;
        }
    ;
/* HELPER */
/* copy t1 into t3, which will go to t2 when there are two num_exp */
helper_num_exp
    : _LPAREN num_exp _RPAREN ar_op
        {
            push("t1", 1);
            $$ = $4;
        }
    ;
/* ALLOWED PARTS OF num_exp */
/* RETURN THE INDEX */
exp
    : literal
        {
            $$[0] = atoi(get_name(&head, $1));
            $$[1] = 0;
        }
    | data
        {
            /*!!! custom map() sym_tab -> memory location !!!*/
            tab_kind = get_kind(&head, $1);
            if(tab_kind != VAR && tab_kind != PAR){
                printf("ERROR: EXPRESSION ISSUE: no value of a non-VAR and non-PAR kind\n");
            }
            $$[0] = $1;
            $$[1] = 1;
        }
    | function_call
        {
            /*!!! custom map() sym_tab -> label !!!*/
            tab_kind = get_kind(&head, $1);
            if(tab_kind == VOID){
                printf("ERROR: FUNC CALL ISSUE: no return value of a void kind\n");
            }
            $$[0] = $1;
            $$[1] = 2;
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
            printf("add tp, tp, gp\n"); //update current function begining
            //printf("add s10, gp, x0\n"); //temp
            printf("addi gp, x0, %d\n", function_map(&head, tab_ind)); //update current size
            printf("add s11, s11, gp\n"); //update child's beginig

            /* JUMP */
            printf("jal %s\n", $1);
            $$ = tab_ind;

            printf("sub s11, s11, gp\n"); //update child's beginig
            printf("lw gp, -4, s11\n");
            //printf("add gp, s10, x0\n"); //update current size
            printf("sub tp, tp, gp\n"); //update current function begining

            printf("lw ra, 0, tp\n");
        }
    ;
/* ARGUMENTS OF A FUNCTION CALL */
/* NO ACTION */
argument_list
    : /* empty */
    | argument
    ;
/* ARGUMENTS OF A FUNCTION CALL */
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
            // printf("add s0, tp, gp\n");
            // printf("addi s0, s0, -8\n");
            // printf("sw t1, 0, s0\n");

            printf("addi s0, tp, 4\n");
            printf("sw t1, 0, s0\n");

            printf("jalr ra\n");
        }
    | _RETURN _SEMICOLON /* FOR VOID ONLY */
        {
            /* JUMP BACK */
            tab_ind = get_func(&head);
            tab_type = get_type(&head, tab_ind);
            if(tab_type != VOID){
                printf("ERROR: RETURN ISSUE: missing value in non-void type\n");
            }

            printf("jalr ra\n");
        }
    ;
/* WHILE STATEMENT */
/* TO BE DELT WITH -- NO ACTION ON SYM_TAB (ONLY statement CHANGES SYM_TAB) - ??? */
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
/* TO BE DELT WITH -- NESTED LABELS */
for_start
    : _FOR _LPAREN assignment_statement {
            for_depth++;
            printf("l%df0l%d:\n", for_depth, for_layer[for_depth]);
        } condition {
            printf("beq t1, x0, l%df1l%d\n", for_depth, for_layer[for_depth]);
        } _SEMICOLON
    ;

for_statement 
    : for_start data _ASSIGN {
            push("s4", 1);
        } num_exp _RPAREN statement {
            pop("s4", 1);
            printf("add t0, x0, t1\n"); //PUT num_exp ON t1
            printf("sw t0, 0, s4\n");

            printf("beq x0 x0, l%df0l%d\n", for_depth, for_layer[for_depth]);
            printf("l%df1l%d:\n", for_depth, for_layer[for_depth]);

            for_layer[for_depth]++;
            for_depth--;
        }
    | for_start data {
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
    /* | for_start data _ASSIGN _AMP {
            printf("add s5, s4, x0\n");
        } data _RPAREN statement {
            printf("add t0, s4, x0\n");
            printf("sw t0, 0, s5\n");

            printf("beq x0 x0, l%df\n", lab_for_cnt);
            printf("l%df:\n", ++lab_for_cnt);
        } */
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

    /* INIT LOOP LABELS */
    for(for_depth = 0; for_depth < LOOP_DEPTH; for_depth++){
        for_layer[for_depth] = 0;
    }
    for_depth = 0;

    for(while_depth = 0; while_depth < LOOP_DEPTH; while_depth++){
        while_layer[while_depth] = 0;
    }
    while_depth = 0;

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
    
