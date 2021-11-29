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

/* TYPE OF VALUE THAT A GIVEN RULE HAS TO RETURN */
/* POSSIBLE TYPES ARE GIVEN IN THE %union ABOVE */
/* $$ IS USED TO SET A VALUE */
%type <i> type literal data exp function_call //mac_exp mac_num_exp
%type <pp> possible_pointer
%type <a> ar_op log_op
%type <ar> array_member_definition array_member
%type <i> array_param //value

/* SPECIAL RULES */
%nonassoc ONLY_IF   /* NOT ALWAYS; JUST IN THE CASE THAT THERE IS NO ELSE (HENCE NO _ - ONLY_IF IS NOT A TOKEN) */
%nonassoc _ELSE

%start program

%%

/* WHOLE PROGRAM */
/* INIT SYM_TAB */
program
    : function_list //: define_list function_list /* NO INCLUDE */
        {
            init_symtab(&head);
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
            tab_ind = lookup_symbol(&head, $2); //ALSO OK TO USE tab_func_ind
            if(tab_ind == -1){
                tab_ind = insert_symbol(&head, $2, FUN, $1);
                //printf("%d\n", tab_ind);
            }
            else{
                printf("ERROR: redefinition of a function '%s'\n", $2);
            }

        }
        _LPAREN parameter_list _RPAREN body
        {
            tab_ind = lookup_symbol(&head, $2);
            print_symtab(&head);
            clear_symbols(&head, tab_ind+1); // CLEAR PARAMS
        }
    ;
/* TYPE */
/* RETURN TYPE */
type
    : _TYPE /* MAYBE EXPAND WITH CONST */
        {
            $$ = $1;
        }
    ;
/* ID OF SOME PAR OR VAR */
/* RETURN INDEX AND IS IT NEW */
possible_pointer
    : _ID
        {
            //printf("%s\n", $1);
            strcpy(tab_name, $1);
            tab_ind = lookup_symbol(&head, tab_name);
            if(tab_ind == -1){
                tab_ind = insert_symbol(&head, tab_name, 0, 0); // JUST SET THE NAME
                $$[0] = tab_ind;
                $$[1] = 1;
            }
            else{
                $$[0] = tab_ind;
                $$[1] = 0;
            }
        }
    | _STAR _ID
        {
            strcpy(tab_name, $2);
            tab_ind = lookup_symbol(&head, tab_name);
            if(tab_ind == -1){
                tab_ind = insert_symbol(&head, tab_name, 0, 0);
                $$[0] = tab_ind;
                $$[1] = 1;
            }
            else{
                $$[0] = tab_ind;
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
            strcpy(tab_name, get_name(&head, $4[0]));
            if($4[1]){
                set_type(&head, $4[0], $3);
                set_kind(&head, $4[0], PAR);
            }
            else{
                printf("ERROR: PARAM ISSUE: redefinition of a ID '%s'\n", tab_name);
            }
        }
    | type possible_pointer
        {
            strcpy(tab_name, get_name(&head, $2[0]));
            if($2[1]){
                set_type(&head, $2[0], $1);
                set_kind(&head, $2[0], PAR);
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
            strcpy(tab_name, get_name(&head, $2[0]));
            if($2[1]){
                set_type(&head, $2[0], $1);
                set_kind(&head, $2[0], VAR);
            }
            else{
                printf("ERROR: VAR DECL ISSUE: redefinition of a ID '%s'\n", tab_name);
            }
        }
    | type possible_pointer
        {
            strcpy(tab_name, get_name(&head, $2[0]));
            if($2[1]){
                set_type(&head, $2[0], $1);
                set_kind(&head, $2[0], VAR);
                tab_array_count = 0; //SET COUNTER TO 0
            }
            else{
                printf("ERROR: VAR DECL ISSUE: redefinition of a ID '%s'\n", tab_name);
            }
        }
        array_member_definition _SEMICOLON
            {
                set_dimension(&head, $2[0], $4, tab_array_count);
            }
    ;
/* ARRAY PART IN A DECLARATION */
/* ARRAYS SHOULD BE DEALT WITH -- LAST [] IS THE DIM = 0 */
array_member_definition
    : array_member_definition _LSQBRACK array_param _RSQBRACK
        {
            if(tab_array_count >= MAX_DIM){
                printf("ERROR: ARRAY SIZE ISSUE: too many dimensions");
            }
            $$[tab_array_count++] = $3;
        }
    | _LSQBRACK array_param _RSQBRACK
        {
            if(tab_array_count >= MAX_DIM){
                printf("ERROR: ARRAY SIZE ISSUE: too many dimensions");
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
    | do_while_statement
    | for_statement
    | function_call _SEMICOLON /* FOR VOID FUNCTIONS */
    | _CONTINUE _SEMICOLON
    | _BREAK _SEMICOLON
    | switch_statement
    ;
/* COMPOUND STATMENT -- {} BLOCK */
/* NO ACTION */
compound_statement
    : _LBRACKET statement_list _RBRACKET
    ;
/* ASSIGNMENT -- x = 5;*/
/* TO BE DELT WITH -- PRINT ASSEMBLY CODE */
assignment_statement
    : data _ASSIGN num_exp _SEMICOLON
        {
            //set_value(&head, $1, $3);
            //print_symtab(&head);
        }
    | data _ASSIGN _AMP data _SEMICOLON
        {
            //set_value(&head, $1, $4);
            //print_symtab(&head);
        }
    | data _ITER _SEMICOLON
        {
            /*tab_val = get_value(&head, $1);
            if($2 == INC){
                tab_val++;
            }
            else{
                tab_val--;
            }*/
            //set_value(&head, $1, tab_val);
            //print_symtab(&head);
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
/* TO BE DELT WITH -- PRINT ASSEMBLY CODE BY STORING THE INTERMEDIATE RESULTS */
num_exp
    : exp
        {
            //$$ = $1;
        }
    | exp ar_op exp
        {/*
            switch($2){
                case PLUS:
                    //CONSIDER:
                    //LOAD x <- $1
                    //LOAD y <- $3
                    //ADD z, x, y
                    //x, y AND z ARE REGISTERS
                    //WE WILL USE atoi(get_name($1)) FOR literal

                    //tab_val = $1 + $3;
                    break;
                case MINUS:
                    //tab_val = $1 - $3;
                    break;
                case STAR:
                    //tab_val = $1 * $3;
                    break;
                case DIV:
                    if($3 == 0){
                        printf("ERROR: NUM EXPR ISSUE: dividing with zero\n");
                    }
                    else{
                        //tab_val = $1 / $3;
                    }
                    break;
                case MOD:
                    if($3 <= 0){
                        printf("ERROR: NUM EXPR ISSUE: modular with a negative\n");
                    }
                    else{
                        //tab_val = $1 % $3;
                    }
                    break;
                case SR:
                    if($3 < 0){
                        printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
                    }
                    else{
                        //tab_val = $1 >> $3;
                    }
                    break;
                case SL:
                    if($3 < 0){
                        printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
                    }
                    else{
                        //tab_val = $1 << $3;
                    }
                    break;
                case AMP:
                    //tab_val = $1 & $3;
                    break;
                case BOR:
                    //tab_val = $1 | $3;
                    break;
                case BXOR:
                    //tab_val = $1 ^ $3;
                    break;
                default:
                    printf("ERROR: NUM EXPR ISSUE: wrong operator\n");
                    break;
            }
            //$$ = tab_val;*/
        }
    | _LPAREN num_exp _RPAREN ar_op exp
        {/*
            switch($4){
                case PLUS:
                    //tab_val = $2 + $5;
                    break;
                case MINUS:
                    //tab_val = $2 - $5;
                    break;
                case STAR:
                    //tab_val = $2 * $5;
                    break;
                case DIV:
                    if($5 == 0){
                        printf("ERROR: NUM EXPR ISSUE: dividing with zero\n");
                    }
                    else{
                        //tab_val = $2 / $5;
                    }
                    break;
                case MOD:
                    if($5 <= 0){
                        printf("ERROR: NUM EXPR ISSUE: modular with a negative\n");
                    }
                    else{
                        //tab_val = $2 % $5;
                    }
                    break;
                case SR:
                    if($5 <= 0){
                        printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
                    }
                    else{
                        //tab_val = $2 >> $5;
                    }
                    break;
                case SL:
                    if($5 <= 0){
                        printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
                    }
                    else{
                        //tab_val = $2 << $5;
                    }
                    break;
                case AMP:
                    //tab_val = $2 & $5;
                    break;
                case BOR:
                    //tab_val = $2 | $5;
                    break;
                case BXOR:
                    //tab_val = $2 ^ $5;
                    break;
                default:
                    printf("ERROR: NUM EXPR ISSUE: wrong operator\n");
                    break;
            }
            //$$ = tab_val;*/
        }
    | exp ar_op _LPAREN num_exp _RPAREN
        {/*
            switch($2){
                case PLUS:
                    //tab_val = $1 + $4;
                    break;
                case MINUS:
                    //tab_val = $1 - $4;
                    break;
                case STAR:
                    //tab_val = $1 * $4;
                    break;
                case DIV:
                    if($4 == 0){
                        printf("ERROR: NUM EXPR ISSUE: dividing with zero\n");
                    }
                    else{
                        //tab_val = $1 / $4;
                    }
                    break;
                case MOD:
                    if($4 <= 0){
                        printf("ERROR: NUM EXPR ISSUE: modular with a negative\n");
                    }
                    else{
                        //tab_val = $1 % $4;
                    }
                    break;
                case SR:
                    if($4 <= 0){
                        printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
                    }
                    else{
                        //tab_val = $1 >> $4;
                    }
                    break;
                case SL:
                    if($4 <= 0){
                        printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
                    }
                    else{
                        //tab_val = $1 << $4;
                    }
                    break;
                case AMP:
                    //tab_val = $1 & $4;
                    break;
                case BOR:
                    //tab_val = $1 | $4;
                    break;
                case BXOR:
                    //tab_val = $1 ^ $4;
                    break;
                default:
                    printf("ERROR: NUM EXPR ISSUE: wrong operator\n");
                    break;
            }
            //$$ = tab_val;*/
        }
    | _LPAREN num_exp _RPAREN ar_op _LPAREN num_exp _RPAREN
        {/*
            switch($4){
                case PLUS:
                    //tab_val = $2 + $6;
                    break;
                case MINUS:
                    //tab_val = $2 - $6;
                    break;
                case STAR:
                    //tab_val = $2 * $6;
                    break;
                case DIV:
                    if($6 == 0){
                        printf("ERROR: NUM EXPR ISSUE: dividing with zero\n");
                    }
                    else{
                        //tab_val = $2 / $6;
                    }
                    break;
                case MOD:
                    if($6 <= 0){
                        printf("ERROR: NUM EXPR ISSUE: modular with a negative\n");
                    }
                    else{
                        //tab_val = $2 % $6;
                    }
                    break;
                case SR:
                    if($6 <= 0){
                        printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
                    }
                    else{
                        //tab_val = $2 >> $6;
                    }
                    break;
                case SL:
                    if($6 <= 0){
                        printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
                    }
                    else{
                        //tab_val = $2 << $6;
                    }
                    break;
                case AMP:
                    //tab_val = $2 & $6;
                    break;
                case BOR:
                    //tab_val = $2 | $6;
                    break;
                case BXOR:
                    //tab_val = $2 ^ $6;
                    break;
                default:
                    printf("ERROR: NUM EXPR ISSUE: wrong operator\n");
                    break;
            }
            //$$ = tab_val;*/
        }
    | _PLUS exp /* ONLY FOR +- IN CASE OF -5 */
        {
            //$$ = $2;
        }
    | _MINUS exp /* ONLY FOR +- IN CASE OF -5 */
        {
            //$$ = -$2;
        }
    | data _ITER
        {
            //tab_val = get_value(&head, $1);
            if($2 == INC){
                //set_value(&head, $2, ++tab_val);
            }
            else{
                //set_value(&head, $2, --tab_val);
            }
            //$$ = tab_val;
        }
    ;
/* ALLOWED PARTS OF num_exp */
/* RETURN THE INDEX */
exp
    : literal
        {
            $$ = $1;
        }
    | data
        {
            tab_kind = get_kind(&head, $1);
            if(tab_kind == VAR || tab_kind == PAR){
                $$ = $1;
            }
            else{
                printf("ERROR: EXPRESSION ISSUE: no value of a non-VAR and non-PAR kind\n");
            }
        }
    | function_call
        {
            tab_kind = get_kind(&head, $1);
            if(tab_kind == VOID){
                printf("ERROR: FUNC CALL ISSUE: no return value of a void kind\n");
            }
            else{
                $$ = $1;
            }
        }
    ;
/* FUNCTION CALL (THAT RETURNS A VALUE -- INSIDE A num_exp) */
/* CHECK IF EXISTING FUNC IS CALLED AND RETURN ITS INDEX */
function_call
    : _ID _LPAREN argument_list _RPAREN /* possible_pointer */
        {
            tab_ind = lookup_symbol(&head, $1);
            if(tab_ind == -1){ // CHECK IF OFF BY ONE
                printf("ERROR: FUNC CALL ISSUE: non-existing ID '%s'\n", $1);
            }
            else{
                $$ = tab_ind;
            }
        }
    ;
/* ARGUMENTS OF A FUNCTION CALL */
/* NO ACTION */
argument_list
    : /* empty */
    | argument
    ;
/* ARGUMENTS OF A FUNCTION CALL */
/* TO BE DELT WITH */
argument
    : argument _COMMA num_exp
    | num_exp
    ;
/* IF STATEMENT */
/* TO BE DELT WITH -- NO ACTION ON SYM_TAB (ONLY statement CHANGES SYM_TAB) */ /* SEE HOW TO NOT MAKE THE CHANGES WHEN NOT ALLOWED */
if_statement
    : _IF _LPAREN condition _RPAREN statement %prec ONLY_IF
        {/*
            if($3 == 1){
                // DO THE STATEMENT
            }
            else{
                // DON'T DO IT
            }*/
        }
    | _IF _LPAREN condition _RPAREN statement _ELSE statement
        {/*
                if($3 == 1){
                    // DO THE STATEMENT $5
                }
                else{
                    // DO THE STATEMENT $7
                }*/
        }
    ;
/* CONDITION WHEN BRANCHING */
/* TO BE DELT WITH -- PRINT ASSEMBLY CODE 1 OR 0 DEPENDING ON THE OUTCOME OF THE EXPRESSION */
condition
    : rel_exp
        {
            //$$ = $1;
        }
    | _LPAREN condition _RPAREN log_op _LPAREN condition _RPAREN
        {
            switch($4){
                case(AND):
                    //tab_val = $2 && $6;
                    break;
                case(OR):
                    //tab_val = $2 || $6;
                    break;
           	    default:
                    printf("ERROR: COND ISSUE: wrong logical operator\n");
                    break;
            }
            //$$ = tab_val;
        }
    | rel_exp log_op rel_exp
        {
            switch($2){
                case(AND):
                    //tab_val = $1 && $3;
                    break;
                case(OR):
                    //tab_val = $1 || $3;
                    break;
           	    default:
                    printf("ERROR: COND ISSUE: wrong logical operator\n");
                    break;
            }
            //$$ = tab_val;
        }
    ;
/* REALATIONAL EXPRESSION */
/* TO BE DELT WITH -- PRINT ASSEMBLY CODE 1 OR 0 DEPENDING ON THE OUTCOME OF THE EXPRESSION */
rel_exp
    : num_exp _RELOP num_exp
        {/*
            switch($2){
            	case(LT):
            		if($1 < $3)
            			//$$ = 1;
            		else 
            			//$$ = 0;
            		break;
           	    case(LEQ):
            		if($1 <= $3)
            			//$$ = 1;
            		else 
            			//$$ = 0;
            		break;
           	    case(GT):
            		if($1 > $3)
            			//$$ = 1;
            		else 
            			//$$ = 0;
            		break;
           	    case(GEQ):
            		if($1 >= $3)
            			//$$ = 1;
            		else 
            			//$$ = 0;
            		break;
           	    case(EQ):
            		if($1 == $3)
            			//$$ = 1;
            		else 
            			//$$ = 0;
            		break;
           	    default:
                    printf("ERROR: REL OP ISSUE: wrong operator\n");
                    break;
           }*/
        }
    ;
/* RETURN STATMENT -- EITHER retur x; OR return; */
/* CHECK IF RETURN TYPE IS CORRECT AND SET THE VALUE OF A FUNCTION */
return_statement
    : _RETURN num_exp _SEMICOLON
        {
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
    : _WHILE _LPAREN condition _RPAREN statement
    ;
/* SWITCH STATEMENT */
/* TO BE DELT WITH -- NO ACTION ON SYM_TAB (ONLY statement CHANGES SYM_TAB) */
switch_statement
    : _SWITCH _LPAREN num_exp _RPAREN _LBRACKET case_list _RBRACKET
    ;
/* LIST OF CASES */
/* TO BE DELT WITH */
case_list
    : case_list case_statement
    | case_statement
    ;
/* CASE STATEMENT */
/* TO BE DELT WITH */ /* ALLOW ONLY ONE default */
case_statement
    : _CASE num_exp _COLON case_block
    | _DEFAULT _COLON case_block
    ;
/* LIST OF ALLOWED STATEMENTS INSIDE A CASE BLOCK */
/* TO BE DELT WITH */
case_block
    : case_block case_state
    | case_state
    ;
/* ALLOWED STATEMENTS INSIDE A CASE BLOCK */
/* TO BE DELT WITH */
case_state
    : assignment_statement
    | function_call _SEMICOLON /* FOR VOID FUNCTIONS */
    | _CONTINUE _SEMICOLON
    | _BREAK _SEMICOLON
    ;
/* DO WHILE STATEMENT */
/* TO BE DELT WITH -- NO ACTION ON SYM_TAB (ONLY statement CHANGES SYM_TAB) */
do_while_statement
    : _DO statement _WHILE _LPAREN condition _RPAREN _SEMICOLON
    ;
/* FOR STATEMENT */
/* TO BE DELT WITH -- NO ACTION ON SYM_TAB (ONLY statement CHANGES SYM_TAB) */
for_statement
    : _FOR for_args statement
    ;
/* ARGUMENTS OF FOR */
/* TO BE DELT WITH */
for_args
    : _LPAREN assignment_statement condition _SEMICOLON change_statement _RPAREN
    ;
/* SIMPLE ASSIGN STATEMENTS */
/* TO BE DELT WITH */
change_statement
    : possible_pointer _ASSIGN num_exp
    | possible_pointer _ITER
    ;
/* TO BE ADDED */
/*
++ a+b*c
++ += -= *= ...
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
	fprintf(stderr,"\nline %d: WARNING: %s",yylineno,s);
	warning_count++;
}
int main(){
    int syntax_error;
    SYMBOL_ENTRY *head;
    
    init_symtab(&head);
    
    syntax_error = yyparse();
    
    print_symtab(&head);
    
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
    
