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
    | _DEF _ID mac_num_exp /* NOT ALL num_exp */
    ;
mac_num_exp
    : mac_exp
    | mac_exp ar_op mac_exp
    | _LPAREN mac_num_exp _RPAREN ar_op mac_exp
    | mac_exp ar_op _LPAREN mac_num_exp _RPAREN
    | _LPAREN mac_num_exp _RPAREN ar_op _LPAREN mac_num_exp _RPAREN
    | _PLUS mac_exp /* ONLY FOR +- IN CASE OF -5 */
    | _MINUS mac_exp /* ONLY FOR +- IN CASE OF -5 */
    | mac_exp _ITER
    ;
mac_exp
    : literal
    | _ID /* SOME PREVIOUS MACRO */
    ;
function_list
    : function
    | function_list function
    ;
function
    : type _ID _LPAREN parameter _RPAREN body
    ;
type
    : _TYPE /* MAYBE EXPAND WITH CONST */
    ;
possible_pointer
    : _ID
    | _STAR _ID
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
++ SWITCH
++ BREAK
++ CONTINUE
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
    
