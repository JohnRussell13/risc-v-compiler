%{
    #include <stdio.h>
    #include "definitions.h"
    #include "symtab.h"

    int yyparse(void);
    int yylex(void);
    int yyerror(char *s);
    extern int yylineno;
%}

%union {
    int i;
    char *s;
}

%{    
    int tab_ind = -1;
    int tab_val;
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
%type <i> type parameter possible_pointer literal //mac_exp mac_num_exp

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
    | define
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
                printf("ERROR: redefinition of a MACRO '%s'", $2);
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
            tab_ind = lookup_symbol(&head, $2);
            if(tab_ind == -1){
                init_attr(tab_attr);
                tab_ind = insert_symbol(&head, $2, FUN, $1, 0, tab_attr);
            }
            else{
                printf("ERROR: redefinition of a function '%s'", $2);
            }

        }
        _LPAREN parameter _RPAREN 
        {
            set_attr(&head, tab_ind, tab_attr);
        }
        body
        {
            clear_symbols(&head, tab_ind+1);
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
            tab_val = lookup_symbol(&head, $1);
            $$ = tab_val;
        }
    | _STAR _ID
        {
            tab_val = lookup_symbol(&head, $2);
            $$ = tab_val;
        }
    ;
parameter
    : /* empty */
        {
            $$ = 0;
        }
    | parameter _COMMA type possible_pointer
        {
            $$ = 0;
        }
    | type possible_pointer
        {
            $$ = 0;
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
    : type possible_pointer _SEMICOLON
    | type possible_pointer array_member_definition _SEMICOLON 
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
    | data _ASSIGN _AMP exp _SEMICOLON
    | data _ITER _SEMICOLON
    ;
data
    : possible_pointer
    | possible_pointer array_member
    ;
array_member
    : array_member _LSQBRACK num_exp _RSQBRACK /* BE CAREFULL WITH function_call MUSN'T BE VOID*/
    | _LSQBRACK num_exp _RSQBRACK
    ;
ar_op
    : _PLUS
    | _MINUS
    | _STAR
    | _DIV
    | _MOD
    | _SR
    | _SL
    | _AMP
    | _BOR
    | _BXOR
    ;
log_op
    : _AND
    | _OR
    ;
num_exp
    : exp
    | exp ar_op exp
    | _LPAREN num_exp _RPAREN ar_op exp
    | exp ar_op _LPAREN num_exp _RPAREN
    | _LPAREN num_exp _RPAREN ar_op _LPAREN num_exp _RPAREN
    | _PLUS exp /* ONLY FOR +- IN CASE OF -5 */
    | _MINUS exp /* ONLY FOR +- IN CASE OF -5 */
    | exp _ITER
    ;
exp
    : literal
    | data
    | function_call
    ;
function_call
    : _ID _LPAREN argument _RPAREN /* possible_pointer */
    ;
argument
    : /* empty */
    | argument _COMMA num_exp
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
    fprintf(stderr, "\nline %d: ERROR: %s", yylineno, s);
    return 0;
}

int main(){
    return yyparse();
}
    
