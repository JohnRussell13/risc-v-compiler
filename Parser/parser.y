%{
    #include <stdio.h>
    #include "definitions.h"

    int yyparse(void);
    int yylex(void);
    int yyerror(char *s);
    extern int yylineno;
%}

%union {
    int i;
    char *s;
}

/* TOKENS */
%token _IF
%token _ELSE
%token _SWITCH
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

%token <i> _AROP
%token <i> _ITER
%token <i> _RELOP

%token <s> _ID

%token <s> _INT_NUMBER
%token <s> _UINT_NUMBER

/* SPECIAL RULES */
%nonassoc ONLY_IF   /* NOT ALWAYS; JUST IN THE CASE THAT THERE IS NO ELSE (HENCE NO _ - ONLY_IF IS NOT A TOKEN) */
%nonassoc _ELSE

%start program

%%

program
    : define_list function_list /* NO INCLUDE */
    ;
define_list
    : /* empty */
    | _DEF _ID macro_num_exp
    ;
function_list
    : function
    | function_list function
    ;
function
    : type _ID _LPAREN parameter _RPAREN body /* possible_pointer */
    ;
type
    : _TYPE /* MAYBE EXPAND WITH CONST */
    ;
possible_pointer
    : _ID
    | _AROP possible_pointer /* _AROP IS ONLT _STAR !! */
    ;
parameter
    : /* empty */
    | parameter _COMMA type possible_pointer
    | type possible_pointer
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
    | _LSQBRACK literal _RSQBRACK
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
    ;
compound_statement
    : _LBRACKET statement_list _RBRACKET
    ;
assignment_statement
    : data _ASSIGN num_exp _SEMICOLON
    | data _ITER _SEMICOLON
    ;
data
    : possible_pointer
    | possible_pointer array_member
    ;
array_member
    : array_member _LSQBRACK num_exp _RSQBRACK /* BE CAREFULL WITH function_call */
    | _LSQBRACK num_exp _RSQBRACK
    ;
macro_num_exp
    : macro_exp
    | macro_num_exp _AROP macro_exp
    | _AROP macro_exp /* ONLY FOR +- IN CASE OF -5 */
    ;
macro_exp
    : literal
    | _ID
    | _LPAREN macro_num_exp _RPAREN
    ;
num_exp
    : exp
    | num_exp _AROP exp
    | _AROP exp /* ONLY FOR +- IN CASE OF -5 */
    | exp _ITER
    ;
exp
    : literal
    | data
    | function_call
    | _LPAREN num_exp _RPAREN
    | _NULL
    ;
literal
    : _INT_NUMBER
    | _UINT_NUMBER
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
    : _IF _LPAREN rel_exp _RPAREN statement
    ;
rel_exp
    : rel_exp _RELOP rel_exp
    | _LPAREN rel_exp _RPAREN
    | num_exp
    ;
return_statement
    : _RETURN num_exp _SEMICOLON
    | _RETURN _SEMICOLON /* FOR VOID ONLY */
    ;
while_statement
    : _WHILE _LPAREN rel_exp _RPAREN statement
    ;
do_while_statement
    : _DO _LBRACKET statement _RBRACKET _WHILE _LPAREN rel_exp _RPAREN
    ;
for_statement
    : _FOR for_cond statement
    ;
for_cond
    : _LPAREN assignment_statement rel_exp _SEMICOLON change_statement _RPAREN
    ;
change_statement
    : possible_pointer _ASSIGN num_exp
    | possible_pointer _ITER
    ;
%%

int yyerror(char *s){
    fprintf(stderr, "\nline %d: ERROR: %s", yylineno, s);
    return 0;
}

int main(){
    return yyparse();
}
