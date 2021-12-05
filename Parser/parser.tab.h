/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    _IF = 258,
    _ELSE = 259,
    _SWITCH = 260,
    _CASE = 261,
    _DEFAULT = 262,
    _BREAK = 263,
    _CONTINUE = 264,
    _RETURN = 265,
    _WHILE = 266,
    _DO = 267,
    _FOR = 268,
    _DEF = 269,
    _NULL = 270,
    _CONST = 271,
    _TYPE = 272,
    _LPAREN = 273,
    _RPAREN = 274,
    _LSQBRACK = 275,
    _RSQBRACK = 276,
    _LBRACKET = 277,
    _RBRACKET = 278,
    _SEMICOLON = 279,
    _COMMA = 280,
    _COLON = 281,
    _ASSIGN = 282,
    _PLUS = 283,
    _MINUS = 284,
    _DIV = 285,
    _MOD = 286,
    _SR = 287,
    _SL = 288,
    _BOR = 289,
    _BXOR = 290,
    _AND = 291,
    _OR = 292,
    _STAR = 293,
    _AMP = 294,
    _ITER = 295,
    _RELOP = 296,
    _ID = 297,
    _INT_NUMBER = 298,
    _UINT_NUMBER = 299,
    ONLY_IF = 300
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 24 "parser.y"

    int i;
    char *s;
    int pp[2];
    unsigned ar[MAX_DIM];
    enum ops a;

#line 111 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
