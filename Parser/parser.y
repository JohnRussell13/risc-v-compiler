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
%}

%union {
    int i;
    char *s;
    int pp[2];
    enum ops a;
}
%{    
    char tab_name[SYMBOL_TABLE_LENGTH];
    int tab_ind = -1;
    int tab_fun_ind;
    int tab_val;
    int tab_val2;
    int tab_attr[MAX_PARAMS];
    SYMBOL_ENTRY *head; //something still not right
    /* GIVES SEGMENTATION FAULT (CORE DUMPED) ERROR WHEN USED */
%}

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
%type <i> num_exp // VALUE, NOT INDEX
%type <i> rel_exp
%type <pp> possible_pointer
%type <a> ar_op log_op

/* SPECIAL RULES */
%nonassoc ONLY_IF   /* NOT ALWAYS; JUST IN THE CASE THAT THERE IS NO ELSE (HENCE NO _ - ONLY_IF IS NOT A TOKEN) */
%nonassoc _ELSE

%start program

%%

program
    : function_list //: define_list function_list /* NO INCLUDE */
        {
            init_symtab(&head);
        }
    ;
/* MACRO DEFINITION -- HUGE ISSUE SINCE IT NEEDS \n */
/*define_list
    : // empty
    | define_list define
    ;*/
/*define
    : _DEF _ID mac_num_exp // NOT ALL num_exp
        {
            tab_ind = lookup_symbol(&head, $2);
            if(tab_ind == -1){
                init_attr(tab_attr);
                tab_val = $3;
                tab_ind = insert_symbol(&head, $2, MAC, _INT_NUMBER, tab_val, tab_attr); // FIXED TYPE TO INT -- THIS SHOULD BE CHANGED
            }
            else{
                printf("ERROR: redefinition of a MACRO '%s'\n", $2);
            }

            clear_symbols(&head, tab_ind+1);
        }
    ;*/
/* EXPRESSION USED TO DEFINE A MACRO */
/*mac_num_exp
    : mac_exp
        {
            $$ = $1;
        }
    | mac_exp ar_op mac_exp
        {
            //arith($1, $2, $3);
            $$ = 0;
        }
    | _LPAREN mac_num_exp _RPAREN ar_op mac_exp
        {
            //arith($1, $2, $3);
            $$ = 0;
        }
    | mac_exp ar_op _LPAREN mac_num_exp _RPAREN
        {
            //arith($1, $2, $3);
            $$ = 0;
        }
    | _LPAREN mac_num_exp _RPAREN ar_op _LPAREN mac_num_exp _RPAREN
        {
            //arith($1, $2, $3);
            $$ = 0;
        }
    | _PLUS mac_exp // ONLY FOR +- IN CASE OF -5 
        {
            $$ = $2;
        }
    | _MINUS mac_exp // ONLY FOR +- IN CASE OF -5 
        {
            $$ = $2;
        }
    | mac_exp _ITER
        {
            //iteration($1, $2);
            $$ = 0;
        }
    ;*/
/* MACRO ALOOWED TYPES */
/*mac_exp
    : literal
        {
            $$ = $1;
        }
    | _ID // SOME PREVIOUS MACRO 
        {
            tab_val = lookup_symbol(&head, $1);
            $$ = tab_val;
        }
    ;*/
/* NUMBER */
literal
    : _INT_NUMBER
        {
            $$ = atoi($1);
        }
    | _UINT_NUMBER
        {
            $$ = atoi($1);
        }
    ;
/* LIST OF FUNCTIONS -- RECURSIVE RULE */
function_list
    : function
    | function_list function
    ;
/* FUNCTION DEFINITION */
function
    : type _ID
        {
            tab_fun_ind = lookup_symbol(&head, $2);
            if(tab_fun_ind == -1){
                init_attr(tab_attr);
                tab_fun_ind = insert_symbol(&head, $2, FUN, $1, 0, tab_attr);
                //printf("%d\n", tab_fun_ind);
            }
            else{
                printf("ERROR: redefinition of a function '%s'\n", $2);
            }

        }
        _LPAREN parameter _RPAREN 
        {
            set_attr(&head, tab_fun_ind, tab_attr);
        }
        body
        {
            print_symtab(&head);
            clear_symbols(&head, tab_fun_ind+1); // CLEAR PARAMS
        }
    ;
/* VARIABLE TYPE */
type
    : _TYPE /* MAYBE EXPAND WITH CONST */
        {
            $$ = $1;
        }
    ;
possible_pointer
    : _ID
        {
            //printf("%s\n", $1);
            strcpy(tab_name, $1);
            tab_ind = lookup_symbol(&head, tab_name);
            if(tab_ind == -1){
                init_attr(tab_attr);
                tab_ind = insert_symbol(&head, tab_name, 0, 0, 0, tab_attr); // JUST SET THE NAME
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
                init_attr(tab_attr);
                tab_ind = insert_symbol(&head, tab_name, 0, 0, 0, tab_attr);
                $$[0] = tab_ind;
                $$[1] = 1;
            }
            else{
                $$[0] = tab_ind;
                $$[1] = 0;
            }
        }
    ;
parameter
    : /* empty */
        {
            /* empty */
        }
    | parameter _COMMA type possible_pointer
        {
            strcpy(tab_name, get_name(&head, $4[0]));
            if($4[1]){ // CHECK IF OFF BY ONE
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
            if($2[1]){ // CHECK IF OFF BY ONE
                set_type(&head, $2[0], $1);
                set_kind(&head, $2[0], PAR);
            }
            else{
                printf("ERROR: PARAM ISSUE: redefinition of a ID '%s'\n", tab_name);
            }
        }
    ;
body
    : _LBRACKET variable_list statement_list _RBRACKET
    ;
variable_list
    : /* empty */
    | variable_list variable
    ;
variable
    : type possible_pointer 
        {
            strcpy(tab_name, get_name(&head, $2[0]));
            if($2[1]){ // CHECK IF OFF BY ONE
                set_type(&head, $2[0], $1);
                set_kind(&head, $2[0], VAR);
            }
            else{
                printf("ERROR: VAR DECL ISSUE: redefinition of a ID '%s'\n", tab_name);
            }
        }
        _SEMICOLON
    | type possible_pointer
        {
            strcpy(tab_name, get_name(&head, $2[0]));
            if($2[1]){ // CHECK IF OFF BY ONE
                set_type(&head, $2[0], $1);
                set_kind(&head, $2[0], VAR);
            }
            else{
                printf("ERROR: VAR DECL ISSUE: redefinition of a ID '%s'\n", tab_name);
            }
        }
        array_member_definition _SEMICOLON
    ;
array_member_definition
    : array_member_definition _LSQBRACK array_param _RSQBRACK /* CHECK IF ITS MACRO */
    | _LSQBRACK array_param _RSQBRACK
    ;
array_param
    : literal
    | _ID
    ;
statement_list
    : /* empty */
    | statement_list statement
    ;
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
compound_statement
    : _LBRACKET statement_list _RBRACKET
    ;
assignment_statement
    : data _ASSIGN num_exp _SEMICOLON
        {
            set_value(&head, $1, $3);
            //print_symtab(&head);
        }
    | data _ASSIGN _AMP data _SEMICOLON
        {
            set_value(&head, $1, $4);
            //print_symtab(&head);
        }
    | data _ITER _SEMICOLON
        {
            tab_val = get_value(&head, $1);
            if($2 == INC){
                tab_val++;
            }
            else{
                tab_val--;
            }
            set_value(&head, $1, tab_val);
            //print_symtab(&head);
        }
    ;
data
    : possible_pointer
        {
            strcpy(tab_name, get_name(&head, $1[0]));
            if($1[1]){ // CHECK IF OFF BY ONE
                printf("ERROR: DATA ISSUE: non-existing ID '%s'\n", tab_name);
            }
            else{
                $$ = $1[0];
            }
        }
    | possible_pointer array_member
        {
            strcpy(tab_name, get_name(&head, $1[0]));
            if($1[1]){ // CHECK IF OFF BY ONE
                printf("ERROR: DATA ISSUE: non-existing ID '%s'\n", tab_name);
            }
            else{
                $$ = $1[0];
            }
        }
    ;
array_member
    : array_member _LSQBRACK num_exp _RSQBRACK /* BE CAREFULL WITH function_call MUSN'T BE VOID*/
    | _LSQBRACK num_exp _RSQBRACK
    ;
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
num_exp
    : exp
        {
            $$ = $1;
        }
    | exp ar_op exp
        {
            switch($2){
                case PLUS:
                    tab_val = $1 + $3;
                    break;
                case MINUS:
                    tab_val = $1 - $3;
                    break;
                case STAR:
                    tab_val = $1 * $3;
                    break;
                case DIV:
                    if($3 == 0){
                        printf("ERROR: NUM EXPR ISSUE: dividing with zero\n");
                    }
                    else{
                        tab_val = $1 / $3;
                    }
                    break;
                case MOD:
                    if($3 <= 0){
                        printf("ERROR: NUM EXPR ISSUE: modular with a negative\n");
                    }
                    else{
                        tab_val = $1 % $3;
                    }
                    break;
                case SR:
                    if($3 < 0){
                        printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
                    }
                    else{
                        tab_val = $1 >> $3;
                    }
                    break;
                case SL:
                    if(tab_val2 < 0){
                        printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
                    }
                    else{
                        tab_val = $1 << $3;
                    }
                    break;
                case AMP:
                    tab_val = $1 & $3;
                    break;
                case BOR:
                    tab_val = $1 | $3;
                    break;
                case BXOR:
                    tab_val = $1 ^ $3;
                    break;
                default:
                    printf("ERROR: NUM EXPR ISSUE: wrong operator\n");
                    break;
            }
            $$ = tab_val;
        }
    | _LPAREN num_exp _RPAREN ar_op exp
        {
            switch($4){
                case PLUS:
                    tab_val = $2 + $5;
                    break;
                case MINUS:
                    tab_val = $2 - $5;
                    break;
                case STAR:
                    tab_val = $2 * $5;
                    break;
                case DIV:
                    if($5 == 0){
                        printf("ERROR: NUM EXPR ISSUE: dividing with zero\n");
                    }
                    else{
                        tab_val = $2 / $5;
                    }
                    break;
                case MOD:
                    if($5 <= 0){
                        printf("ERROR: NUM EXPR ISSUE: modular with a negative\n");
                    }
                    else{
                        tab_val = $2 % $5;
                    }
                    break;
                case SR:
                    if($5 <= 0){
                        printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
                    }
                    else{
                        tab_val = $2 >> $5;
                    }
                    break;
                case SL:
                    if($5 <= 0){
                        printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
                    }
                    else{
                        tab_val = $2 << $5;
                    }
                    break;
                case AMP:
                    tab_val = $2 & $5;
                    break;
                case BOR:
                    tab_val = $2 | $5;
                    break;
                case BXOR:
                    tab_val = $2 ^ $5;
                    break;
                default:
                    printf("ERROR: NUM EXPR ISSUE: wrong operator\n");
                    break;
            }
            $$ = tab_val;
        }
    | exp ar_op _LPAREN num_exp _RPAREN
        {
            switch($2){
                case PLUS:
                    tab_val = $1 + $4;
                    break;
                case MINUS:
                    tab_val = $1 - $4;
                    break;
                case STAR:
                    tab_val = $1 * $4;
                    break;
                case DIV:
                    if($4 == 0){
                        printf("ERROR: NUM EXPR ISSUE: dividing with zero\n");
                    }
                    else{
                        tab_val = $1 / $4;
                    }
                    break;
                case MOD:
                    if($4 <= 0){
                        printf("ERROR: NUM EXPR ISSUE: modular with a negative\n");
                    }
                    else{
                        tab_val = $1 % $4;
                    }
                    break;
                case SR:
                    if($4 <= 0){
                        printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
                    }
                    else{
                        tab_val = $1 >> $4;
                    }
                    break;
                case SL:
                    if($4 <= 0){
                        printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
                    }
                    else{
                        tab_val = $1 << $4;
                    }
                    break;
                case AMP:
                    tab_val = $1 & $4;
                    break;
                case BOR:
                    tab_val = $1 | $4;
                    break;
                case BXOR:
                    tab_val = $1 ^ $4;
                    break;
                default:
                    printf("ERROR: NUM EXPR ISSUE: wrong operator\n");
                    break;
            }
            $$ = tab_val;
        }
    | _LPAREN num_exp _RPAREN ar_op _LPAREN num_exp _RPAREN
        {
            switch($4){
                case PLUS:
                    tab_val = $2 + $6;
                    break;
                case MINUS:
                    tab_val = $2 - $6;
                    break;
                case STAR:
                    tab_val = $2 * $6;
                    break;
                case DIV:
                    if($6 == 0){
                        printf("ERROR: NUM EXPR ISSUE: dividing with zero\n");
                    }
                    else{
                        tab_val = $2 / $6;
                    }
                    break;
                case MOD:
                    if($6 <= 0){
                        printf("ERROR: NUM EXPR ISSUE: modular with a negative\n");
                    }
                    else{
                        tab_val = $2 % $6;
                    }
                    break;
                case SR:
                    if($6 <= 0){
                        printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
                    }
                    else{
                        tab_val = $2 >> $6;
                    }
                    break;
                case SL:
                    if($6 <= 0){
                        printf("ERROR: NUM EXPR ISSUE: shifting with a negative\n");
                    }
                    else{
                        tab_val = $2 << $6;
                    }
                    break;
                case AMP:
                    tab_val = $2 & $6;
                    break;
                case BOR:
                    tab_val = $2 | $6;
                    break;
                case BXOR:
                    tab_val = $2 ^ $6;
                    break;
                default:
                    printf("ERROR: NUM EXPR ISSUE: wrong operator\n");
                    break;
            }
            $$ = tab_val;
        }
    | _PLUS exp /* ONLY FOR +- IN CASE OF -5 */
        {
            $$ = $2;
        }
    | _MINUS exp /* ONLY FOR +- IN CASE OF -5 */
        {
            $$ = -$2;
        }
    | data _ITER
        {
            tab_val = get_value(&head, $1);
            if($2 == INC){
                set_value(&head, $2, ++tab_val);
            }
            else{
                set_value(&head, $2, --tab_val);
            }
            $$ = tab_val;
        }
    ;
exp
    : literal
        {
            $$ = $1;
        }
    | data
        {
            $$ = get_value(&head, $1);
        }
    | function_call
        {
            $$ = $1;
        }
    ;
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
argument_list
    : /* empty */
    | argument
    ;
argument
    : argument _COMMA num_exp
    | num_exp
    ;
if_statement
    : if_part %prec ONLY_IF
    | if_part _ELSE statement
    ;
if_part
    : _IF _LPAREN condition _RPAREN statement
    ;
condition
    : rel_exp
    | _LPAREN condition _RPAREN log_op _LPAREN condition _RPAREN
    | rel_exp log_op rel_exp
    ;
rel_exp
    : num_exp _RELOP num_exp
    {
            switch($2){
            	case(LT): {
            		if($1 < $3)
            			$$ = 1;
            		else 
            			$$ = 0;
            		break;
           	}
           	case(LEQ): {
            		if($1 <= $3)
            			$$ = 1;
            		else 
            			$$ = 0;
            		break;
           	}
           	case(GT): {
            		if($1 > $3)
            			$$ = 1;
            		else 
            			$$ = 0;
            		break;
           	}
           	case(GEQ): {
            		if($1 >= $3)
            			$$ = 1;
            		else 
            			$$ = 0;
            		break;
           	}
           	case(EQ): {
            		if($1 == $3)
            			$$ = 1;
            		else 
            			$$ = 0;
            		break;
           	}
           	printf("ERROR: REL OP ISSUE: wrong operator\n");
                    break;
           }
    }
    ;
return_statement
    : _RETURN num_exp _SEMICOLON
    | _RETURN _SEMICOLON /* FOR VOID ONLY */
    ;
while_statement
    : _WHILE _LPAREN condition _RPAREN statement
    ;
switch_statement
    : _SWITCH _LPAREN num_exp _RPAREN _LBRACKET case_list _RBRACKET
    ;
case_list
    : case_list case_statement
    | case_statement
    ;
case_statement
    : _CASE num_exp _COLON case_block
    | _DEFAULT _COLON case_block
    ;
case_block
    : case_block case_state
    | case_state
    ;
case_state
    : assignment_statement
    | function_call _SEMICOLON /* FOR VOID FUNCTIONS */
    | _CONTINUE _SEMICOLON
    | _BREAK _SEMICOLON
    ;
do_while_statement
    : _DO statement _WHILE _LPAREN condition _RPAREN _SEMICOLON
    ;
for_statement
    : _FOR for_cond statement
    ;
for_cond
    : _LPAREN assignment_statement condition _SEMICOLON change_statement _RPAREN
    ;
change_statement
    : possible_pointer _ASSIGN num_exp
    | possible_pointer _ITER
    ;
/* TO BE ADDED */
/*
++ a+b*c
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
    
