/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison implementation for Yacc-like parsers in C

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.5.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "parser.y"

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

#line 92 "parser.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Use api.header.include to #include this header
   instead of duplicating it here.  */
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

#line 198 "parser.tab.c"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */



#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))

/* Stored state numbers (used for stacks). */
typedef yytype_uint8 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && ! defined __ICC && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                            \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  6
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   268

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  46
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  43
/* YYNRULES -- Number of rules.  */
#define YYNRULES  100
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  201

#define YYUNDEFTOK  2
#define YYMAXUTOK   300


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,   110,   110,   115,   116,   122,   121,   142,   147,   156,
     164,   178,   197,   198,   202,   213,   231,   236,   237,   242,
     257,   256,   276,   283,   294,   302,   303,   308,   309,   310,
     311,   312,   313,   314,   315,   316,   317,   318,   323,   328,
     333,   338,   349,   364,   380,   400,   403,   410,   414,   418,
     422,   426,   430,   434,   438,   442,   446,   454,   458,   467,
     482,   547,   552,   557,   562,   577,   593,   606,   623,   629,
     641,   657,   672,   673,   678,   679,   684,   720,   744,   748,
     763,   782,   824,   838,   853,   861,   875,   876,   881,   882,
     887,   888,   893,   894,   895,   896,   901,   906,   911,   916,
     917
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "_IF", "_ELSE", "_SWITCH", "_CASE",
  "_DEFAULT", "_BREAK", "_CONTINUE", "_RETURN", "_WHILE", "_DO", "_FOR",
  "_DEF", "_NULL", "_CONST", "_TYPE", "_LPAREN", "_RPAREN", "_LSQBRACK",
  "_RSQBRACK", "_LBRACKET", "_RBRACKET", "_SEMICOLON", "_COMMA", "_COLON",
  "_ASSIGN", "_PLUS", "_MINUS", "_DIV", "_MOD", "_SR", "_SL", "_BOR",
  "_BXOR", "_AND", "_OR", "_STAR", "_AMP", "_ITER", "_RELOP", "_ID",
  "_INT_NUMBER", "_UINT_NUMBER", "ONLY_IF", "$accept", "program",
  "function_list", "function", "$@1", "literal", "type",
  "possible_pointer", "parameter_list", "parameter", "body",
  "variable_list", "variable", "$@2", "array_member_definition",
  "array_param", "statement_list", "statement", "compound_statement",
  "assignment_statement", "data", "array_member", "ar_op", "log_op",
  "num_exp", "exp", "function_call", "argument_list", "argument",
  "if_statement", "condition", "rel_exp", "return_statement",
  "while_statement", "switch_statement", "case_list", "case_statement",
  "case_block", "case_state", "do_while_statement", "for_statement",
  "for_args", "change_statement", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_int16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300
};
# endif

#define YYPACT_NINF (-114)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-1)

#define yytable_value_is_error(Yyn) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     -16,  -114,    41,   -16,  -114,     3,  -114,  -114,  -114,    -3,
     -16,   -29,    35,    38,    18,  -114,  -114,    76,   -16,  -114,
    -114,  -114,   -29,   -16,  -114,   -29,  -114,   165,    79,    88,
      90,    91,    95,    44,    96,   207,   100,  -114,  -114,   -29,
     103,   104,  -114,  -114,  -114,    -7,   105,  -114,  -114,  -114,
    -114,  -114,  -114,  -114,   112,    99,   212,  -114,  -114,   212,
    -114,    32,    32,   -29,  -114,  -114,  -114,    83,   109,   229,
    -114,    99,   123,    39,   207,   186,   111,   212,   212,   120,
     193,   122,  -114,    50,     5,    99,   106,   125,    59,   129,
     134,  -114,  -114,  -114,  -114,  -114,  -114,  -114,  -114,  -114,
    -114,  -114,  -114,  -114,  -114,  -114,  -114,   -12,   135,   137,
      99,  -114,  -114,  -114,  -114,   138,   131,   139,   212,   -29,
     141,  -114,  -114,   146,    50,  -114,    -2,   143,   212,   207,
    -114,  -114,   212,   136,   229,   212,  -114,   207,    99,   148,
    -114,   212,  -114,   158,   156,  -114,  -114,   160,    59,  -114,
     178,  -114,    94,    47,   164,  -114,   166,   -29,  -114,  -114,
    -114,  -114,   168,   207,   212,   167,    21,  -114,   212,  -114,
    -114,   176,    11,   171,    99,  -114,   175,    15,  -114,  -114,
     173,  -114,   212,  -114,  -114,   183,    15,   180,   182,  -114,
     189,    15,  -114,  -114,  -114,  -114,    15,  -114,  -114,  -114,
    -114
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_int8 yydefact[] =
{
       0,     9,     0,     2,     3,     0,     1,     4,     5,     0,
      12,     0,     0,    13,     0,    10,    15,     0,     0,    11,
      17,     6,     0,    25,    14,     0,    18,     0,    20,     0,
       0,     0,     0,     0,     0,     0,     0,    25,    16,     0,
      10,    43,    26,    27,    28,     0,     0,    29,    30,    31,
      37,    32,    33,    19,     0,     0,     0,    36,    35,     0,
      83,     0,     0,     0,     7,     8,    68,    69,     0,    59,
      70,     0,     0,     0,     0,     0,     0,    72,     0,    44,
       0,     0,    34,     0,     0,     0,     0,     0,    78,     0,
       0,    69,    64,    65,    67,    66,    82,    47,    48,    50,
      51,    52,    53,    55,    56,    49,    54,     0,     0,     0,
       0,    97,    38,    42,    75,     0,    73,     0,     0,     0,
       0,    41,    24,     0,     0,    21,     0,     0,     0,     0,
      57,    58,     0,     0,     0,     0,    60,     0,     0,     0,
      71,     0,    46,     0,     0,    39,    23,     0,     0,    81,
      76,    80,     0,     0,     0,    84,     0,     0,    74,    45,
      40,    22,     0,     0,     0,     0,     0,    87,     0,    61,
      62,     0,     0,     0,     0,    77,     0,     0,    85,    86,
       0,    96,     0,   100,    98,     0,     0,     0,     0,    92,
       0,    89,    91,    63,    99,    79,    88,    95,    94,    93,
      90
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -114,  -114,  -114,   181,  -114,   -72,    46,    -6,  -114,  -114,
    -114,  -114,  -114,  -114,  -114,   101,   177,   -32,  -114,   -66,
     -27,  -114,    89,    86,   -19,   -40,   -25,  -114,  -114,  -114,
     -67,   107,  -114,  -114,  -114,  -114,    61,    52,  -113,  -114,
    -114,  -114,  -114
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     2,     3,     4,     9,    66,     5,    41,    12,    13,
      21,    23,    26,    54,    84,   123,    27,    42,    43,    44,
      67,    79,   107,   132,    86,    69,    70,   115,   116,    47,
      87,    88,    48,    49,    50,   166,   167,   191,   192,    51,
      52,    74,   173
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_uint8 yytable[] =
{
      45,     1,    46,    72,   108,    16,   135,   110,    45,    14,
      46,   122,    76,    15,    68,    10,    24,   134,   127,    28,
      80,    92,    93,   187,   188,   124,    14,   164,   165,   125,
      40,    64,    65,    81,    91,    91,    94,    89,   182,   128,
      90,     6,   111,   139,   178,     8,    45,    45,    45,    46,
      46,   183,   122,    14,    17,    39,    11,    40,   114,   117,
      19,   120,    59,    18,    22,   168,   126,   136,    60,    25,
      14,   156,    61,    62,    40,    64,    65,    14,   200,    39,
      91,    15,    14,   200,    63,    14,    40,    64,    65,    40,
      64,    65,   144,    64,    65,   130,   131,   150,    20,   143,
     164,   165,    45,    53,    46,   155,    55,   185,    56,   149,
      45,   189,    46,   169,    71,    57,   154,    85,    73,    58,
     189,    77,   158,    95,    78,   189,    91,    61,    62,    82,
     189,   175,    83,    96,   109,   113,    45,    14,    46,    63,
     118,    40,    64,    65,   129,   176,   121,   128,   133,   180,
      45,   172,   190,   134,   137,   138,   141,   140,   152,    45,
     142,   190,   148,   194,    45,   145,   190,   146,    29,    45,
      30,   190,   157,    31,    32,    33,    34,    35,    36,   159,
     160,   161,   163,   170,     7,   171,   174,    37,    38,    29,
     184,    30,   193,   177,    31,    32,    33,    34,    35,    36,
     181,   186,   195,    14,   197,    39,   198,    40,    37,   112,
      29,    59,    30,   199,    75,    31,    32,    33,    34,    35,
      36,    61,    62,   153,    14,   147,    39,   179,    40,    37,
      59,    14,   119,    63,   162,    40,    64,    65,   196,   151,
      61,    62,     0,     0,     0,    14,     0,    39,     0,    40,
      14,     0,    63,     0,    40,    64,    65,    97,    98,    99,
     100,   101,   102,   103,   104,     0,     0,   105,   106
};

static const yytype_int16 yycheck[] =
{
      27,    17,    27,    35,    71,    11,    18,    73,    35,    38,
      35,    83,    39,    42,    33,    18,    22,    19,    85,    25,
      27,    61,    62,     8,     9,    20,    38,     6,     7,    24,
      42,    43,    44,    40,    61,    62,    63,    56,    27,    41,
      59,     0,    74,   110,    23,    42,    73,    74,    75,    74,
      75,    40,   124,    38,    19,    40,    10,    42,    77,    78,
      42,    80,    18,    25,    18,    18,    85,   107,    24,    23,
      38,   138,    28,    29,    42,    43,    44,    38,   191,    40,
     107,    42,    38,   196,    40,    38,    42,    43,    44,    42,
      43,    44,   119,    43,    44,    36,    37,   129,    22,   118,
       6,     7,   129,    24,   129,   137,    18,   174,    18,   128,
     137,   177,   137,   153,    18,    24,   135,    18,    18,    24,
     186,    18,   141,    40,    20,   191,   153,    28,    29,    24,
     196,   163,    20,    24,    11,    24,   163,    38,   163,    40,
      20,    42,    43,    44,    19,   164,    24,    41,    19,   168,
     177,   157,   177,    19,    19,    18,    25,    19,    22,   186,
      21,   186,    19,   182,   191,    24,   191,    21,     3,   196,
       5,   196,    24,     8,     9,    10,    11,    12,    13,    21,
      24,    21,     4,    19,     3,    19,    18,    22,    23,     3,
      19,     5,    19,    26,     8,     9,    10,    11,    12,    13,
      24,    26,    19,    38,    24,    40,    24,    42,    22,    23,
       3,    18,     5,    24,    37,     8,     9,    10,    11,    12,
      13,    28,    29,   134,    38,   124,    40,   166,    42,    22,
      18,    38,    39,    40,   148,    42,    43,    44,   186,   132,
      28,    29,    -1,    -1,    -1,    38,    -1,    40,    -1,    42,
      38,    -1,    40,    -1,    42,    43,    44,    28,    29,    30,
      31,    32,    33,    34,    35,    -1,    -1,    38,    39
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_int8 yystos[] =
{
       0,    17,    47,    48,    49,    52,     0,    49,    42,    50,
      18,    52,    54,    55,    38,    42,    53,    19,    25,    42,
      22,    56,    52,    57,    53,    52,    58,    62,    53,     3,
       5,     8,     9,    10,    11,    12,    13,    22,    23,    40,
      42,    53,    63,    64,    65,    66,    72,    75,    78,    79,
      80,    85,    86,    24,    59,    18,    18,    24,    24,    18,
      24,    28,    29,    40,    43,    44,    51,    66,    70,    71,
      72,    18,    63,    18,    87,    62,    66,    18,    20,    67,
      27,    40,    24,    20,    60,    18,    70,    76,    77,    70,
      70,    66,    71,    71,    66,    40,    24,    28,    29,    30,
      31,    32,    33,    34,    35,    38,    39,    68,    76,    11,
      65,    63,    23,    24,    70,    73,    74,    70,    20,    39,
      70,    24,    51,    61,    20,    24,    70,    76,    41,    19,
      36,    37,    69,    19,    19,    18,    71,    19,    18,    76,
      19,    25,    21,    70,    66,    24,    21,    61,    19,    70,
      63,    77,    22,    68,    70,    63,    76,    24,    70,    21,
      24,    21,    69,     4,     6,     7,    81,    82,    18,    71,
      19,    19,    53,    88,    18,    63,    70,    26,    23,    82,
      70,    24,    27,    40,    19,    76,    26,     8,     9,    65,
      72,    83,    84,    19,    70,    19,    83,    24,    24,    24,
      84
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_int8 yyr1[] =
{
       0,    46,    47,    48,    48,    50,    49,    51,    51,    52,
      53,    53,    54,    54,    55,    55,    56,    57,    57,    58,
      59,    58,    60,    60,    61,    62,    62,    63,    63,    63,
      63,    63,    63,    63,    63,    63,    63,    63,    64,    65,
      65,    65,    65,    66,    66,    67,    67,    68,    68,    68,
      68,    68,    68,    68,    68,    68,    68,    69,    69,    70,
      70,    70,    70,    70,    70,    70,    70,    70,    71,    71,
      71,    72,    73,    73,    74,    74,    75,    75,    76,    76,
      76,    77,    78,    78,    79,    80,    81,    81,    82,    82,
      83,    83,    84,    84,    84,    84,    85,    86,    87,    88,
      88
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     1,     1,     2,     0,     7,     1,     1,     1,
       1,     2,     0,     1,     4,     2,     4,     0,     2,     3,
       0,     5,     4,     3,     1,     0,     2,     1,     1,     1,
       1,     1,     1,     1,     2,     2,     2,     1,     3,     4,
       5,     3,     3,     1,     2,     4,     3,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       3,     5,     5,     7,     2,     2,     2,     2,     1,     1,
       1,     4,     0,     1,     3,     1,     5,     7,     1,     7,
       3,     3,     3,     2,     5,     7,     2,     1,     4,     3,
       2,     1,     1,     2,     2,     2,     7,     3,     6,     3,
       2
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YYUSE (yyoutput);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyo, yytoknum[yytype], *yyvaluep);
# endif
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyo, yytype, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[+yyssp[yyi + 1 - yynrhs]],
                       &yyvsp[(yyi + 1) - (yynrhs)]
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen(S) (YY_CAST (YYPTRDIFF_T, strlen (S)))
#  else
/* Return the length of YYSTR.  */
static YYPTRDIFF_T
yystrlen (const char *yystr)
{
  YYPTRDIFF_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYPTRDIFF_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYPTRDIFF_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            else
              goto append;

          append:
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (yyres)
    return yystpcpy (yyres, yystr) - yyres;
  else
    return yystrlen (yystr);
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYPTRDIFF_T *yymsg_alloc, char **yymsg,
                yy_state_t *yyssp, int yytoken)
{
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat: reported tokens (one for the "unexpected",
     one per "expected"). */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Actual size of YYARG. */
  int yycount = 0;
  /* Cumulated lengths of YYARG.  */
  YYPTRDIFF_T yysize = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[+*yyssp];
      YYPTRDIFF_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
      yysize = yysize0;
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYPTRDIFF_T yysize1
                    = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
                    yysize = yysize1;
                  else
                    return 2;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
    default: /* Avoid compiler warnings. */
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    /* Don't count the "%s"s in the final size, but reserve room for
       the terminator.  */
    YYPTRDIFF_T yysize1 = yysize + (yystrlen (yyformat) - 2 * yycount) + 1;
    if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
      yysize = yysize1;
    else
      return 2;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          ++yyp;
          ++yyformat;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss;
    yy_state_t *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYPTRDIFF_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYPTRDIFF_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    goto yyexhaustedlab;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
# undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 5:
#line 122 "parser.y"
        {
            tab_ind = lookup_symbol(&head, (yyvsp[0].s));
            if(tab_ind == -1){
                tab_ind = insert_symbol(&head, (yyvsp[0].s), FUN, (yyvsp[-1].i));
            }
            else{
                printf("ERROR: redefinition of a function '%s'\n", (yyvsp[0].s));
            }

        }
#line 1543 "parser.tab.c"
    break;

  case 6:
#line 133 "parser.y"
        {
            tab_ind = lookup_symbol(&head, (yyvsp[-5].s));
            //print_symtab(&head);
            clear_symbols(&head, tab_ind+1); // CLEAR PARAMS
        }
#line 1553 "parser.tab.c"
    break;

  case 7:
#line 143 "parser.y"
        {
            tab_ind = insert_symbol(&head, (yyvsp[0].s), LIT, INT);
            (yyval.i) = tab_ind;
        }
#line 1562 "parser.tab.c"
    break;

  case 8:
#line 148 "parser.y"
        {
            tab_ind = insert_symbol(&head, (yyvsp[0].s), LIT, UINT);
            (yyval.i) = tab_ind;
        }
#line 1571 "parser.tab.c"
    break;

  case 9:
#line 157 "parser.y"
        {
            (yyval.i) = (yyvsp[0].i);
        }
#line 1579 "parser.tab.c"
    break;

  case 10:
#line 165 "parser.y"
        {
            strcpy(tab_name, (yyvsp[0].s));
            tab_ind = lookup_symbol(&head, tab_name);
            if(tab_ind == -1){
                tab_ind = insert_symbol(&head, tab_name, 0, 0); // JUST SET THE NAME
                (yyval.pp)[0] = tab_ind;
                (yyval.pp)[1] = 1;
            }
            else{
                (yyval.pp)[0] = tab_ind;
                (yyval.pp)[1] = 0;
            }
        }
#line 1597 "parser.tab.c"
    break;

  case 11:
#line 179 "parser.y"
        {
            strcpy(tab_name, (yyvsp[0].s));
            tab_ind = lookup_symbol(&head, tab_name);
            if(tab_ind == -1){
                tab_ind = insert_symbol(&head, tab_name, 0, 0);
                set_pointer(&head, tab_ind);
                (yyval.pp)[0] = tab_ind;
                (yyval.pp)[1] = 1;
            }
            else{
                (yyval.pp)[0] = tab_ind;
                (yyval.pp)[1] = 0;
            }
        }
#line 1616 "parser.tab.c"
    break;

  case 14:
#line 203 "parser.y"
        {
            strcpy(tab_name, get_name(&head, (yyvsp[0].pp)[0]));
            if((yyvsp[0].pp)[1]){
                set_type(&head, (yyvsp[0].pp)[0], (yyvsp[-1].i));
                set_kind(&head, (yyvsp[0].pp)[0], PAR);
            }
            else{
                printf("ERROR: PARAM ISSUE: redefinition of a ID '%s'\n", tab_name);
            }
        }
#line 1631 "parser.tab.c"
    break;

  case 15:
#line 214 "parser.y"
        {
            strcpy(tab_name, get_name(&head, (yyvsp[0].pp)[0]));
            if((yyvsp[-1].i) == VOID){
            	printf("ERROR: PARAM DEF ISSUE: parameter '%s' can not be of VOID type\n",tab_name);
            }
            if((yyvsp[0].pp)[1]){
                set_type(&head, (yyvsp[0].pp)[0], (yyvsp[-1].i));
                set_kind(&head, (yyvsp[0].pp)[0], PAR);
            }
            else{
                printf("ERROR: PARAM ISSUE: redefinition of a ID '%s'\n", tab_name);
            }
        }
#line 1649 "parser.tab.c"
    break;

  case 19:
#line 243 "parser.y"
        {
            strcpy(tab_name, get_name(&head, (yyvsp[-1].pp)[0]));
            if((yyvsp[-2].i) == VOID){
            	printf("ERROR: VAR DEF ISSUE: variable '%s' can not be of VOID type\n",tab_name);
            }
            if((yyvsp[-1].pp)[1]){
                set_type(&head, (yyvsp[-1].pp)[0], (yyvsp[-2].i));
                set_kind(&head, (yyvsp[-1].pp)[0], VAR);
            }
            else{
                printf("ERROR: VAR DECL ISSUE: redefinition of a ID '%s'\n", tab_name);
            }
        }
#line 1667 "parser.tab.c"
    break;

  case 20:
#line 257 "parser.y"
        {
            strcpy(tab_name, get_name(&head, (yyvsp[0].pp)[0]));
            if((yyvsp[0].pp)[1]){
                set_type(&head, (yyvsp[0].pp)[0], (yyvsp[-1].i));
                set_kind(&head, (yyvsp[0].pp)[0], VAR);
                tab_array_count = 0;
            }
            else{
                printf("ERROR: VAR DECL ISSUE: redefinition of a ID '%s'\n", tab_name);
            }
        }
#line 1683 "parser.tab.c"
    break;

  case 21:
#line 269 "parser.y"
            {
                set_dimension(&head, (yyvsp[-3].pp)[0], (yyvsp[-1].ar), tab_array_count);
            }
#line 1691 "parser.tab.c"
    break;

  case 22:
#line 277 "parser.y"
        {
            if(tab_array_count >= MAX_DIM){
                printf("ERROR: ARRAY SIZE ISSUE: too many dimensions\n");
            }
            (yyval.ar)[tab_array_count++] = (yyvsp[-1].i);
        }
#line 1702 "parser.tab.c"
    break;

  case 23:
#line 284 "parser.y"
        {
            if(tab_array_count >= MAX_DIM){
                printf("ERROR: ARRAY SIZE ISSUE: too many dimensions\n");
            }
            (yyval.ar)[tab_array_count++] = (yyvsp[-1].i);
        }
#line 1713 "parser.tab.c"
    break;

  case 24:
#line 295 "parser.y"
        {
            (yyval.i) = atoi(get_name(&head, (yyvsp[0].i)));
        }
#line 1721 "parser.tab.c"
    break;

  case 39:
#line 329 "parser.y"
        {
            printf("add t0, x0, t1\n"); // PUT num_exp ON t1
            printf("sw t0, %d, x0\n", 4*(yyvsp[-3].i)); // 4*$1 IS A SIMPLE MAP: SYM_TAB -> DATA MEMORY
        }
#line 1730 "parser.tab.c"
    break;

  case 40:
#line 334 "parser.y"
        {
            printf("addi t0, x0, %d\n", 4*(yyvsp[-4].i));
            printf("sw t0, %d, x0\n", 4*(yyvsp[-4].i));
        }
#line 1739 "parser.tab.c"
    break;

  case 41:
#line 339 "parser.y"
        {
            if((yyvsp[-1].i) == INC){
                printf("addi t0, t0, 1\n");
            }
            else{
                printf("addi t1, x0, 1\n");
                printf("sub t0, t0, t1\n");
            }
            printf("sw t0, %d, x0\n", 4*(yyvsp[-2].i));
        }
#line 1754 "parser.tab.c"
    break;

  case 42:
#line 350 "parser.y"
        {
            if((yyvsp[-1].i) == INC){
                printf("addi t0, t0, 1\n");
            }
            else{
                printf("addi t1, x0, 1\n");
                printf("sub t0, t0, t1\n");
            }
            printf("sw t0, %d, x0\n", 4*(yyvsp[-2].i));
        }
#line 1769 "parser.tab.c"
    break;

  case 43:
#line 365 "parser.y"
        {
            strcpy(tab_name, get_name(&head, (yyvsp[0].pp)[0]));
            tab_kind = get_kind(&head, (yyvsp[0].pp)[0]);
            if((yyvsp[0].pp)[1]){
                printf("ERROR: DATA ISSUE: non-existing ID '%s'\n", tab_name);
            }
            else{
                if(tab_kind != VAR && tab_kind != PAR){
                    printf("ERROR: DATA ISSUE: ID of a non-VAR and non-PAR kind'%s'\n", tab_name);
                }
                else{
                    (yyval.i) = (yyvsp[0].pp)[0];
                }
            }
        }
#line 1789 "parser.tab.c"
    break;

  case 44:
#line 381 "parser.y"
        {
            strcpy(tab_name, get_name(&head, (yyvsp[-1].pp)[0]));
            tab_kind = get_kind(&head, (yyvsp[-1].pp)[0]);
            if((yyvsp[-1].pp)[1]){
                printf("ERROR: DATA ISSUE: non-existing ID '%s'\n", tab_name);
            }
            else{
                if(tab_kind != VAR && tab_kind != PAR){
                    printf("ERROR: DATA ISSUE: ID of a non-VAR and non-PAR kind'%s'\n", tab_name);
                }
                else{
                    (yyval.i) = (yyvsp[-1].pp)[0];
                }
            }
        }
#line 1809 "parser.tab.c"
    break;

  case 45:
#line 401 "parser.y"
        {
        }
#line 1816 "parser.tab.c"
    break;

  case 46:
#line 404 "parser.y"
        {
        }
#line 1823 "parser.tab.c"
    break;

  case 47:
#line 411 "parser.y"
        {
            (yyval.a) = PLUS;
        }
#line 1831 "parser.tab.c"
    break;

  case 48:
#line 415 "parser.y"
        {
            (yyval.a) = MINUS;
        }
#line 1839 "parser.tab.c"
    break;

  case 49:
#line 419 "parser.y"
        {
            (yyval.a) = STAR;
        }
#line 1847 "parser.tab.c"
    break;

  case 50:
#line 423 "parser.y"
        {
            (yyval.a) = DIV;
        }
#line 1855 "parser.tab.c"
    break;

  case 51:
#line 427 "parser.y"
        {
            (yyval.a) = MOD;
        }
#line 1863 "parser.tab.c"
    break;

  case 52:
#line 431 "parser.y"
        {
            (yyval.a) = SR;
        }
#line 1871 "parser.tab.c"
    break;

  case 53:
#line 435 "parser.y"
        {
            (yyval.a) = SL;
        }
#line 1879 "parser.tab.c"
    break;

  case 54:
#line 439 "parser.y"
        {
            (yyval.a) = AMP;
        }
#line 1887 "parser.tab.c"
    break;

  case 55:
#line 443 "parser.y"
        {
            (yyval.a) = BOR;
        }
#line 1895 "parser.tab.c"
    break;

  case 56:
#line 447 "parser.y"
        {
            (yyval.a) = BXOR;
        }
#line 1903 "parser.tab.c"
    break;

  case 57:
#line 455 "parser.y"
        {
            (yyval.a) = AND;
        }
#line 1911 "parser.tab.c"
    break;

  case 58:
#line 459 "parser.y"
        {
            (yyval.a) = OR;
        }
#line 1919 "parser.tab.c"
    break;

  case 59:
#line 468 "parser.y"
        {
            switch((yyvsp[0].pp)[1]){
                case 0:
                    printf("addi t1, x0, %d\n", atoi(get_name(&head, (yyvsp[0].pp)[0])));
                    break;
                case 1:
                    printf("lw t1, %d, x0\n", 4*(yyvsp[0].pp)[0]);
                    break;
                case 2:
                    /* DEAL WITH FUNCTION RETURN */
                    break;
            }
            printf("add t2, x0, t1\n");
        }
#line 1938 "parser.tab.c"
    break;

  case 60:
#line 483 "parser.y"
        {
            switch((yyvsp[-2].pp)[1]){
                case 0:
                    printf("addi t1, x0, %d\n", atoi(get_name(&head, (yyvsp[-2].pp)[0])));
                    break;
                case 1:
                    printf("lw t1, %d, x0\n", 4*(yyvsp[-2].pp)[0]);
                    break;
                case 2:
                    /* DEAL WITH FUNCTION RETURN */
                    break;
            }
            switch((yyvsp[0].pp)[1]){
                case 0:
                    printf("addi t2, x0, %d\n", atoi(get_name(&head, (yyvsp[0].pp)[0])));
                    break;
                case 1:
                    printf("lw t2, %d, x0\n", 4*(yyvsp[0].pp)[0]);
                    break;
                case 2:
                    /* DEAL WITH FUNCTION RETURN */
                    break;
            }
            switch((yyvsp[-1].a)){
                case PLUS:
                    printf("add t1, t1, t2\n");
                    break;
                case MINUS:
                    printf("sub t1, t1, t2\n");
                    break;
                case STAR:
                    printf("add t1, t1, t2\n"); //IMPLEMENT MULTIPLICATION
                    break;
                case DIV:
                    //printf("ERROR: NUM EXPR ISSUE: dividing with zero\n");
                    printf("add t1, t1, t2\n"); //IMPLEMENT DIVISION
                    break;
                case MOD:
                    //printf("ERROR: NUM EXPR ISSUE: modular with a negative\n");
                    printf("add t1, t1, t2\n"); //IMPLEMENT MODULAR
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
            printf("add t2, x0, t1\n");
        }
#line 2007 "parser.tab.c"
    break;

  case 61:
#line 548 "parser.y"
        {
            // ...
            printf("add t2, x0, t1\n");
        }
#line 2016 "parser.tab.c"
    break;

  case 62:
#line 553 "parser.y"
        {
            // ...
            printf("add t2, x0, t1\n");
        }
#line 2025 "parser.tab.c"
    break;

  case 63:
#line 558 "parser.y"
        {
            // ...
            printf("add t2, x0, t1\n"); // WRITE TO BOTH t1 AND t2 JUST FOR THIS REASON
        }
#line 2034 "parser.tab.c"
    break;

  case 64:
#line 563 "parser.y"
        {
            switch((yyvsp[0].pp)[1]){
                case 0:
                    printf("addi t1, x0, %d\n", atoi(get_name(&head, (yyvsp[0].pp)[0])));
                    break;
                case 1:
                    printf("lw t1, %d, x0\n", 4*(yyvsp[0].pp)[0]);
                    break;
                case 2:
                    /* DEAL WITH FUNCTION RETURN */
                    break;
            }
            printf("add t2, x0, t1\n");
        }
#line 2053 "parser.tab.c"
    break;

  case 65:
#line 578 "parser.y"
        {
            switch((yyvsp[0].pp)[1]){
                case 0:
                    printf("addi t1, x0, %d\n", atoi(get_name(&head, (yyvsp[0].pp)[0])));
                    break;
                case 1:
                    printf("lw t1, %d, x0\n", 4*(yyvsp[0].pp)[0]);
                    break;
                case 2:
                    /* DEAL WITH FUNCTION RETURN */
                    break;
            }
            printf("sub t1, x0, t1\n");
            printf("add t2, x0, t1\n");
        }
#line 2073 "parser.tab.c"
    break;

  case 66:
#line 594 "parser.y"
        {
            printf("lw t1, %d, x0\n", 4*(yyvsp[-1].i));
            printf("add t2, x0, t1\n");
            if((yyvsp[0].i) == INC){
                printf("addi t3, t1, 1\n");
            }
            else{
                printf("addi t3, x0, 1\n");
                printf("sub t0, t1, t3\n");
            }
            printf("sw t0, %d, x0\n", 4*(yyvsp[-1].i));
        }
#line 2090 "parser.tab.c"
    break;

  case 67:
#line 607 "parser.y"
        {
            printf("lw t1, %d, x0\n", 4*(yyvsp[-1].i));
            if((yyvsp[0].i) == INC){
                printf("addi t1, t1, 1\n");
            }
            else{
                printf("addi t2, x0, 1\n");
                printf("sub t1, t1, t2\n");
            }
            printf("add t2, x0, t1\n");
            printf("sw t0, %d, x0\n", 4*(yyvsp[-1].i));
        }
#line 2107 "parser.tab.c"
    break;

  case 68:
#line 624 "parser.y"
        {
            /*!!! atoi() !!!*/
            (yyval.pp)[0] = (yyvsp[0].i);
            (yyval.pp)[1] = 0;
        }
#line 2117 "parser.tab.c"
    break;

  case 69:
#line 630 "parser.y"
        {
            /*!!! custom map() sym_tab -> memory location !!!*/
            tab_kind = get_kind(&head, (yyvsp[0].i));
            if(tab_kind == VAR || tab_kind == PAR){
                (yyval.pp)[0] = (yyvsp[0].i);
                (yyval.pp)[1] = 1;
            }
            else{
                printf("ERROR: EXPRESSION ISSUE: no value of a non-VAR and non-PAR kind\n");
            }
        }
#line 2133 "parser.tab.c"
    break;

  case 70:
#line 642 "parser.y"
        {
            /*!!! custom map() sym_tab -> label !!!*/
            tab_kind = get_kind(&head, (yyvsp[0].i));
            if(tab_kind == VOID){
                printf("ERROR: FUNC CALL ISSUE: no return value of a void kind\n");
            }
            else{
                (yyval.pp)[0] = (yyvsp[0].i);
                (yyval.pp)[1] = 2;
            }
        }
#line 2149 "parser.tab.c"
    break;

  case 71:
#line 658 "parser.y"
        {
            /* CAREFULL WITH x1 (ra) */
            tab_ind = lookup_symbol(&head, (yyvsp[-3].s));
            if(tab_ind == -1){ // CHECK IF OFF BY ONE
                printf("ERROR: FUNC CALL ISSUE: non-existing ID '%s'\n", (yyvsp[-3].s));
            }
            else{
                (yyval.i) = tab_ind;
            }
        }
#line 2164 "parser.tab.c"
    break;

  case 76:
#line 685 "parser.y"
        {/*
            if( a != b )

            bne x1, x2, LABEL1

            ... ELSE ...

            jal jump LABEL2

            LABEL1:

            ... IF ...

            LABEL2

            -- LABEL MAKER: IFA1, IFB1... we need an if_counter

            if($3 == 1){
                // DO THE STATEMENT
            }
            else{
                // DON'T DO IT
            }
            if0:
            	lw t0 $3
            	//printf("lw t0, %d, x0\n", 4*$1[0]);
            	bne t0 1 false0
            true0:
            	sw $5,t1
            	//printf("sw t1, %d, x0\n", 4*$1);
            	JMP exit0
            false0:
            	JMP exit0
            exit0:*/
        }
#line 2204 "parser.tab.c"
    break;

  case 77:
#line 721 "parser.y"
        {/*
                if($3 == 1){
                    // DO THE STATEMENT $5
                }
                else{
                    // DO THE STATEMENT $7
                }
                if0:
            		lw t0 $3
            		//printf("lw t0, %d, x0\n", 4*$1[0]);
            		bne t0 1 false0
            	true0:
            		sw $5,t1
            		//printf("sw t1, %d, x0\n", 4*$1);
            		JMP exit0
            	false0:
            		JMP exit0
            	exit0: */
        }
#line 2228 "parser.tab.c"
    break;

  case 78:
#line 745 "parser.y"
        {
            //$$ = $1;
        }
#line 2236 "parser.tab.c"
    break;

  case 79:
#line 749 "parser.y"
        {
            switch((yyvsp[-3].a)){
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
#line 2255 "parser.tab.c"
    break;

  case 80:
#line 764 "parser.y"
        {
            switch((yyvsp[-1].a)){
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
#line 2274 "parser.tab.c"
    break;

  case 81:
#line 783 "parser.y"
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
#line 2316 "parser.tab.c"
    break;

  case 82:
#line 825 "parser.y"
        {
            /* WRITE VAL TO THE REGISTER/DATA MEMORY JUMP BACK */
            tab_ind = get_func(&head);
            tab_type = get_type(&head, tab_ind);
            if(tab_type == VOID){
                printf("ERROR: RETURN ISSUE: value in a void type\n");
            }/*
            else if(tab_type != ){
                	printf("ERROR: RETURN ISSUE: incompatible types in return\n");
            }else{
                //set_value(&head, tab_ind, $2);
            }*/
        }
#line 2334 "parser.tab.c"
    break;

  case 83:
#line 839 "parser.y"
        {
            /* ALWAYS NEEDED OR NOT? */

            /* JUMP BACK */
            tab_ind = get_func(&head);
            tab_type = get_type(&head, tab_ind);
            if(tab_type != VOID){
                printf("ERROR: RETURN ISSUE: missing value in non-void type\n");
            }
        }
#line 2349 "parser.tab.c"
    break;

  case 84:
#line 854 "parser.y"
        {
            /* LIKE IF */
        }
#line 2357 "parser.tab.c"
    break;

  case 85:
#line 862 "parser.y"
        {
            /* LIKE IF */
            /*
            switch_var_index = lookup_symbol($3,VAR);
            if(switch_var_index == -1_){
            	printf("SWITCH STATEMENT ERR: variable '%s' is not defined\n",tab_name);
            }
            */
        }
#line 2371 "parser.tab.c"
    break;


#line 2375 "parser.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = YY_CAST (char *, YYSTACK_ALLOC (YY_CAST (YYSIZE_T, yymsg_alloc)));
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;


#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif


/*-----------------------------------------------------.
| yyreturn -- parsing is finished, return the result.  |
`-----------------------------------------------------*/
yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[+*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 930 "parser.y"


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
    
