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

%nonassoc ONLY_IF   /* NOT ALWAYS; JUST IN THE CASE THAT THERE IS NO ELSE (HENCE NO _ - ONLY_IF IS NOT A TOKEN) */
%nonassoc _ELSE

%start program

%%

program
    : definition_list function_list
    ;
definition_list
    : /* empty */
    | _DEF _ID _INT_NUMBER /* SHOULD BE EXPANDED */
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
parameter
    : /* empty */
    | parameter _COMMA type _ID
    | type _ID
    | parameter _COMMA type _AROP _ID /* _AROP IS ONLT _STAR !! */
    | type _AROP _ID /* _AROP IS ONLT _STAR !! */
    ;
body
    : _LBRACKET variable_list statement_list _RBRACKET
    ;
variable_list
    : /* empty */
    | variable_list variable
    ;
variable
    : type _ID _SEMICOLON
    | type _ID array_member_definition _SEMICOLON /* EXPAND TO ACCENPT NOT JUST literal */
    | type _AROP _ID _SEMICOLON /* ADD EVERY POSSIBILITY */ /* AROP ONLY _STAR !! */
    ;
array_member_definition
    : array_member_definition _LSQBRACK literal _RSQBRACK
    | _LSQBRACK literal _RSQBRACK
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
    : _ID
    | _ID array_member
    | _AROP _ID /* ONLY FOR STAR */
    ;
array_member
    : array_member _LSQBRACK num_exp _RSQBRACK /* BE CAREFULL WITH function_call */
    | _LSQBRACK num_exp _RSQBRACK
    ;
num_exp
    : exp
    | num_exp _AROP exp
    | exp _ITER
    ;
exp
    : literal
    | _ID
    | function_call
    | _LPAREN num_exp _RPAREN
    | _ID array_member
    | _AROP _ID /* ONLY FOR STAR, BAND */
    | _AROP _ID array_member /* ONLY FOR STAR, BAND */
    | _NULL
    ;
literal
    : _INT_NUMBER
    | _UINT_NUMBER
    ;
function_call
    : _ID _LPAREN argument _RPAREN
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
for_statement
    : _FOR for_cond statement
    ;
for_cond
    : _LPAREN assignment_statement rel_exp _SEMICOLON change_statement _RPAREN
    ;
change_statement
    : _ID _ASSIGN num_exp
    | _ID _ITER
    ;
%%

int yyerror(char *s){
    fprintf(stderr, "\nline %d: ERROR: %s", yylineno, s);
    return 0;
}

int main(){
    return yyparse();
}