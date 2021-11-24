%option noyywrap yylineno
%{
    /* VALUES */
    union {
        int i;
        char *s ;
    } yylval ;

    /* TOKENS (_IF = 1 IN ORDER TO MAKE tokens START FROM 1, INSTEAD OF 0, BECAUSE token_string[0] = "NONE") */
    enum tokens {   _IF = 1, _ELSE, _SWITCH, _BREAK, _CONTINUE, _RETURN, _WHILE, _DO, _FOR,
                    _DEF, _CONST,
                    _TYPE,
                    _LPAREN, _RPAREN, _LSQBRACK, _RSQBRACK, _LBRACKET, _RBRACKET, _SEMICOLON, _COMMA, _COLON, _ASSIGN, 
                    _AROP, _ITER, _RELOP, 
                    _ID,
                    _INT_NUMBER, _UINT_NUMBER };

    /* TOKEN NAMES */
    char *token_strings[] = { "NONE", "_IF", "_ELSE", "_SWITCH", "_BREAK", "_CONTINUE", "_RETURN", "_WHILE", "_DO", "_FOR",
                                "_DEF", "_CONST",
                                "_TYPE", 
                                "_LPAREN", "_RPAREN", "_LSQBRACK", "_RSQBRACK", "_LBRACKET", "_RBRACKET", "_SEMICOLON", "_COMMA", "_COLON", "_ASSIGN", 
                                "_AROP", "_ITER", "_RELOP", 
                                "_ID",
                                "_INT_NUMBER", "_UINT_NUMBER"};
    /* OPERATIONS */
    enum values {   ADD, SUB, STAR, DIV, MOD,
                    SL, SR, BAND, BOR, BXOR,
                    AND, OR,
                    INC, DEC,
                    LT, LEQ, GT, GEQ, EQ, 
                    INT, UINT, VOID};

    /* OPERATION NAMES */
    char *value_strings[] = { "ADD", "SUB", "STAR", "DIV", "MOD",
                                "SL", "SR", "BAND", "BOR", "BXOR",
                                "AND", "OR",
                                "INC", "DEC",
                                "LT", "LEQ", "GT", "GEQ", "EQ",
                                "INT", "UINT", "VOID"};
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
"#define"|"#DEFINE"    { return _DEF; }
"const"                { return _CONST;}

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

int main (){
    int tok;
    while(tok = yylex ()){
        printf("%s", token_strings[tok]);
        switch(tok){
            /* STRING TYPE OF VALUE */
            case _ID:
            case _INT_NUMBER:
            case _UINT_NUMBER:
                printf(": %s", yylval.s); break;
            /* INT TYPE OF VALUE */
            case _AROP:
            case _RELOP:
            case _TYPE:
            printf(": %s", value_strings[yylval.i]); break;
        }
        printf ("\n");
    }
}
