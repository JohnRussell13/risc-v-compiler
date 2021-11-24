%option noyywrap yylineno
%{
    #include "parser.tab.h"
    #include "definitions.h"
%}

%%

    /* SKIP SPACES AND COMMENTS */
[ \t\n]+            { /* skip */ }
"//".*\n            { /* skip */ }
"/*"(.|\n)*"*/"     { /* skip */ }  // WORKS

    /* BUILT-IN FUNCTIONS */
"if"        { return _IF; }
"else"      { return _ELSE; }
"switch"    { return _SWITCH; }
"continue"  { return _CONTINUE; }
"break"     { return _BREAK; }
"while"     { return _WHILE; }
"do"        { return _DO; }
"for"       { return _FOR; }
"return"    { return _RETURN; }

    /* SPECIAL KEYWORDS */
"#define"|"#DEFINE"     { return _DEF; }
"const"                 { return _CONST;}
"NULL"|"null"           { return _NULL;}

    /* DATA TYPES */
"int"       { yylval.i = INT;  return _TYPE; }
"unsigned"  { yylval.i = UINT; return _TYPE; }
"void"      { yylval.i = VOID; return _TYPE; }

    /* SPECIAL SYMBOLS */
"("         { return _LPAREN; }
")"         { return _RPAREN; }
"["         { return _LSQBRACK; }
"]"         { return _RSQBRACK; }
"{"         { return _LBRACKET; }
"}"         { return _RBRACKET; }
";"         { return _SEMICOLON; }
","         { return _COMMA; }
":"         { return _COLON; }
"="         { return _ASSIGN; }

    /* ARITHMETIC OPERATIONS */
"+"         { yylval.i = ADD;  return _AROP; }
"-"         { yylval.i = SUB;  return _AROP; }
"*"         { yylval.i = STAR; return _AROP; } /* STAR INSTEAD OF MUL SINCE IT CAN DENOTE A POINTER */
"/"         { yylval.i = DIV;  return _AROP; }
"%"         { yylval.i = MOD;  return _AROP; }
">>"        { yylval.i = SR;   return _AROP; }
"<<"        { yylval.i = SL;   return _AROP; }
"&"         { yylval.i = BAND; return _AROP; } /* CAN DENOTE ADDRES AS WELL */
"|"         { yylval.i = BOR;  return _AROP; }
"~"         { yylval.i = BXOR; return _AROP; }
"&&"        { yylval.i = AND;  return _AROP; }
"||"        { yylval.i = OR;   return _AROP; }

"++"        { yylval.i = INC;  return _ITER; }
"--"        { yylval.i = DEC;  return _ITER; }

    /* RELATION OPERATIONS */
"<"         { yylval.i = LT;  return _RELOP; }
"<="        { yylval.i = LEQ; return _RELOP; }
">"         { yylval.i = GT;  return _RELOP; }
">="        { yylval.i = GEQ; return _RELOP; }
"=="        { yylval.i = EQ;  return _RELOP; }

    /* NAMES AND VALUES */
[a-zA-Z][a-zA-Z0-9_]*   { yylval.s = yytext; return _ID; }
[+-]?[0-9]{1,10}        { yylval.s = yytext; return _INT_NUMBER; }
[0-9]{1,10}[uU]         { yylval.s = yytext; return _UINT_NUMBER; }

    /* OTHER */
.           { printf("line %d: LEXICAL ERROR on char %c\n", yylineno, *yytext); }

%%
