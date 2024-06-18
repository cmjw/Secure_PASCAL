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
#line 1 "parse.y"
     /* pars1.y    Pascal Parser      Gordon S. Novak Jr.  ; 13 Nov 23   */

/* Charlotte White cmw4856 */

/* Copyright (c) 2023 Gordon S. Novak Jr. and
   The University of Texas at Austin. */

/* 14 Feb 01; 01 Oct 04; 02 Mar 07; 27 Feb 08; 24 Jul 09; 02 Aug 12;
   30 Jul 13; 25 Jul 19 ; 28 Feb 22; 08 Jul 22 */

/*
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.

; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

; You should have received a copy of the GNU General Public License
; along with this program; if not, see <http://www.gnu.org/licenses/>.
  */


/* NOTE:   Copy your lexan.l lexical analyzer to this directory.      */

       /* To use:
                     make pars1y              has 1 shift/reduce conflict
                     pars1y                   execute the parser
                     i:=j .
                     ^D                       control-D to end input

                     pars1y                   execute the parser
                     begin i:=j; if i+j then x:=a+b*c else x:=a*b+c; k:=i end.
                     ^D

                     pars1y                   execute the parser
                     if x+y then if y+z then i:=j else k:=2.
                     ^D

           You may copy pars1.y to be parse.y and extend it for your
           assignment.  Then use   make parser   as above.
        */

        /* Yacc reports 1 shift/reduce conflict, due to the ELSE part of
           the IF statement, but Yacc's default resolves it in the right way.*/

#include <stdio.h>
#include <assert.h>
#include <ctype.h>
#include <string.h>
#include "token.h"
#include "lexan.h"
#include "symtab.h"
#include "pprint.h"
#include "parse.h"
#include "codegen.h"

        /* define the type of the Yacc stack element to be TOKEN */

#define YYSTYPE TOKEN

TOKEN parseresult;


#line 138 "parse.tab.c"

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
#ifndef YY_YY_PARSE_TAB_H_INCLUDED
# define YY_YY_PARSE_TAB_H_INCLUDED
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
    IDENTIFIER = 258,
    STRING = 259,
    NUMBER = 260,
    PLUS = 261,
    MINUS = 262,
    TIMES = 263,
    DIVIDE = 264,
    ASSIGN = 265,
    EQ = 266,
    NE = 267,
    LT = 268,
    LE = 269,
    GE = 270,
    GT = 271,
    POINT = 272,
    DOT = 273,
    AND = 274,
    OR = 275,
    NOT = 276,
    DIV = 277,
    MOD = 278,
    IN = 279,
    COMMA = 280,
    SEMICOLON = 281,
    COLON = 282,
    LPAREN = 283,
    RPAREN = 284,
    LBRACKET = 285,
    RBRACKET = 286,
    DOTDOT = 287,
    ARRAY = 288,
    BEGINBEGIN = 289,
    CASE = 290,
    CONST = 291,
    DO = 292,
    DOWNTO = 293,
    ELSE = 294,
    END = 295,
    FILEFILE = 296,
    FOR = 297,
    FUNCTION = 298,
    GOTO = 299,
    IF = 300,
    LABEL = 301,
    NIL = 302,
    OF = 303,
    PACKED = 304,
    PROCEDURE = 305,
    PROGRAM = 306,
    RECORD = 307,
    REPEAT = 308,
    SET = 309,
    THEN = 310,
    TO = 311,
    TYPE = 312,
    UNTIL = 313,
    VAR = 314,
    WHILE = 315,
    WITH = 316,
    thenthen = 317
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSE_TAB_H_INCLUDED  */



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
#define YYFINAL  4
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   240

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  63
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  39
/* YYNRULES -- Number of rules.  */
#define YYNRULES  97
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  184

#define YYUNDEFTOK  2
#define YYMAXUTOK   317


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
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint8 yyrline[] =
{
       0,    87,    87,    90,    90,    90,    92,    92,    94,    95,
      96,    97,    98,   101,   102,   105,   106,   109,   112,   113,
     116,   119,   120,   123,   124,   127,   130,   131,   134,   137,
     138,   141,   142,   145,   146,   149,   150,   153,   154,   157,
     161,   162,   163,   164,   167,   168,   171,   172,   173,   176,
     179,   180,   181,   182,   183,   184,   185,   186,   187,   190,
     193,   194,   197,   198,   201,   205,   206,   207,   208,   211,
     211,   211,   213,   213,   213,   213,   213,   213,   213,   215,
     215,   215,   215,   215,   217,   218,   219,   222,   223,   226,
     227,   230,   231,   234,   235,   236,   237,   238
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "IDENTIFIER", "STRING", "NUMBER", "PLUS",
  "MINUS", "TIMES", "DIVIDE", "ASSIGN", "EQ", "NE", "LT", "LE", "GE", "GT",
  "POINT", "DOT", "AND", "OR", "NOT", "DIV", "MOD", "IN", "COMMA",
  "SEMICOLON", "COLON", "LPAREN", "RPAREN", "LBRACKET", "RBRACKET",
  "DOTDOT", "ARRAY", "BEGINBEGIN", "CASE", "CONST", "DO", "DOWNTO", "ELSE",
  "END", "FILEFILE", "FOR", "FUNCTION", "GOTO", "IF", "LABEL", "NIL", "OF",
  "PACKED", "PROCEDURE", "PROGRAM", "RECORD", "REPEAT", "SET", "THEN",
  "TO", "TYPE", "UNTIL", "VAR", "WHILE", "WITH", "thenthen", "$accept",
  "program", "unsigned_constant", "sign", "constant", "id_list", "numlist",
  "cdef", "cdef_list", "tdef", "tdef_list", "statement_list", "fields",
  "field_list", "label", "lblock", "cblock", "tblock", "vblock",
  "vdef_list", "vdef", "type", "simple_type_list", "simple_type", "block",
  "statement", "funcall", "endpart", "endif", "assignment", "variable",
  "plus_op", "compare_op", "times_op", "simple_expression", "expression",
  "expr_list", "term", "factor", YY_NULLPTR
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
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310,   311,   312,   313,   314,
     315,   316,   317
};
# endif

#define YYPACT_NINF (-141)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-10)

#define yytable_value_is_error(Yyn) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     -36,    18,    29,     4,  -141,    56,    37,    35,    56,    41,
    -141,    65,    36,    63,    67,    71,    56,    58,  -141,  -141,
    -141,  -141,    54,    59,    36,    80,    83,   114,    36,   114,
    -141,   -14,  -141,  -141,   172,    79,    69,    -4,    66,    87,
      94,    99,   -10,   102,    98,   105,  -141,   114,    36,   -14,
    -141,    77,  -141,  -141,  -141,  -141,  -141,    30,   114,  -141,
    -141,    30,  -141,    97,    78,   125,   143,  -141,    76,   124,
     132,    36,  -141,  -141,   114,  -141,   150,   114,   188,    63,
    -141,    67,    -9,    40,    71,  -141,    40,  -141,    56,   199,
     134,  -141,  -141,   114,  -141,   192,   143,  -141,  -141,  -141,
      30,  -141,  -141,  -141,  -141,  -141,  -141,  -141,    36,   114,
    -141,  -141,  -141,  -141,  -141,    30,   114,    36,    36,   -14,
     214,  -141,   133,  -141,  -141,  -141,    51,  -141,  -141,  -141,
    -141,   136,   173,    56,   147,    56,   146,  -141,  -141,  -141,
    -141,  -141,   114,  -141,   159,  -141,   143,   140,    78,  -141,
     214,  -141,  -141,  -141,  -141,  -141,  -141,  -141,   152,   181,
     170,   174,   158,   188,  -141,    36,    36,  -141,  -141,   168,
     176,    40,    56,  -141,  -141,  -141,  -141,   169,   181,  -141,
    -141,    40,  -141,  -141
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_int8 yydefact[] =
{
       0,     0,     0,     0,     1,     0,    14,     0,     0,     0,
      13,     0,     0,     0,     0,     0,     0,     0,    30,    32,
      34,    36,    65,     0,     0,     0,     0,     0,     0,     0,
      58,     0,    53,    52,     0,     0,     0,     0,    16,     0,
       0,     0,     0,     0,     0,     0,     2,     0,     0,     0,
      65,     0,    57,     5,     3,     6,     7,     0,     0,     4,
      93,     0,    96,    94,    88,     0,    85,    92,     0,    24,
       0,     0,    61,    49,     0,    68,     0,     0,     0,    19,
      31,     0,     0,     0,    22,    33,     0,    35,    38,    90,
       0,    28,    50,     0,    97,     0,    84,    69,    70,    71,
       0,    72,    75,    73,    76,    77,    74,    78,     0,     0,
      79,    80,    83,    81,    82,     0,     0,     0,     0,     0,
      64,    67,     0,     9,    12,    11,     0,    17,    18,    15,
      29,    46,     0,     0,     0,     0,     0,    20,    40,    21,
      39,    37,     0,    59,     0,    95,    86,    63,    87,    91,
      56,    23,    54,    60,    66,     8,    10,    43,     0,     0,
       0,    27,     0,     0,    89,     0,     0,    51,    47,     0,
      45,     0,     0,    42,    48,    55,    62,     0,     0,    25,
      26,     0,    44,    41
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -141,  -141,  -141,   -55,   -76,    -5,   137,  -141,   141,  -141,
     135,   115,  -141,    50,  -141,  -141,   149,   196,   193,   148,
    -141,   -78,    61,  -140,   190,    -6,    -8,   -40,  -141,   212,
     -11,  -141,  -141,  -141,   131,   -22,   -67,   -39,   -46
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     2,    60,    61,   136,    43,    39,    36,    37,    41,
      42,    68,   161,   162,    30,    17,    18,    19,    20,    44,
      45,   137,   169,   138,    21,    69,    62,    73,   167,    33,
      63,   100,   109,   115,    64,    89,    90,    66,    67
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
       7,    34,   127,    10,    32,    65,    31,    70,   140,    92,
     122,    94,    71,    34,    34,     1,    32,    34,    49,   170,
      32,     3,    96,   126,    12,    12,    72,    13,   126,     4,
      12,   126,     5,    22,    53,    54,    95,    34,   170,    22,
      32,    23,    91,   131,   124,   125,    55,    56,    15,    16,
      16,    57,   120,    15,   155,    16,   156,   132,    58,     6,
      34,   146,     8,    32,     9,   119,    35,    11,   133,   149,
      24,   144,    38,   134,    40,   164,    46,    59,    25,   153,
      26,    27,    47,    50,    97,    98,    48,   174,    52,    28,
      78,    81,   135,   179,   150,    79,    29,    34,    99,    12,
      32,    13,   147,   183,   126,    83,    34,    34,   126,    32,
      32,    14,   152,    82,    75,    76,   126,    22,    53,    54,
      55,    56,    15,   126,    16,    84,   126,    77,   158,    86,
     160,    88,    12,    93,   116,    57,   101,   102,   103,   104,
     105,   106,    58,   101,   102,   103,   104,   105,   106,   107,
     117,   110,   111,   121,    34,    34,   107,    32,    32,   175,
     176,    59,   112,   143,   154,   113,   114,   160,    -9,   118,
     101,   102,   103,   104,   105,   106,   157,   159,   163,   166,
     108,   168,    74,   107,   131,   124,   125,    55,    56,    75,
      76,   123,   124,   125,    55,    56,   165,   171,   173,   177,
     172,   178,    77,   101,   102,   103,   104,   105,   106,   133,
     101,   102,   103,   104,   105,   106,   107,   181,   129,   139,
     128,   145,   180,   107,   142,   101,   102,   103,   104,   105,
     106,   130,   151,    80,    87,    85,   141,    51,   107,   182,
     148
};

static const yytype_uint8 yycheck[] =
{
       5,    12,    78,     8,    12,    27,    12,    29,    86,    49,
      77,    57,    26,    24,    25,    51,    24,    28,    24,   159,
      28,     3,    61,    78,    34,    34,    40,    36,    83,     0,
      34,    86,    28,     3,     4,     5,    58,    48,   178,     3,
      48,     5,    48,     3,     4,     5,     6,     7,    57,    59,
      59,    21,    74,    57,     3,    59,     5,    17,    28,     3,
      71,   100,    25,    71,    29,    71,     3,    26,    28,   115,
      34,    93,     5,    33,     3,   142,    18,    47,    42,   119,
      44,    45,    28,     3,     6,     7,    27,   163,     5,    53,
      11,    25,    52,   171,   116,    26,    60,   108,    20,    34,
     108,    36,   108,   181,   159,    11,   117,   118,   163,   117,
     118,    46,   118,    26,    17,    18,   171,     3,     4,     5,
       6,     7,    57,   178,    59,    26,   181,    30,   133,    27,
     135,    26,    34,    56,    58,    21,    11,    12,    13,    14,
      15,    16,    28,    11,    12,    13,    14,    15,    16,    24,
      26,     8,     9,     3,   165,   166,    24,   165,   166,   165,
     166,    47,    19,    29,    31,    22,    23,   172,    32,    37,
      11,    12,    13,    14,    15,    16,     3,    30,    32,    39,
      55,    29,    10,    24,     3,     4,     5,     6,     7,    17,
      18,     3,     4,     5,     6,     7,    37,    27,    40,    31,
      26,    25,    30,    11,    12,    13,    14,    15,    16,    28,
      11,    12,    13,    14,    15,    16,    24,    48,    81,    84,
      79,    29,   172,    24,    25,    11,    12,    13,    14,    15,
      16,    82,   117,    37,    44,    42,    88,    25,    24,   178,
     109
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_int8 yystos[] =
{
       0,    51,    64,     3,     0,    28,     3,    68,    25,    29,
      68,    26,    34,    36,    46,    57,    59,    78,    79,    80,
      81,    87,     3,     5,    34,    42,    44,    45,    53,    60,
      77,    88,    89,    92,    93,     3,    70,    71,     5,    69,
       3,    72,    73,    68,    82,    83,    18,    28,    27,    88,
       3,    92,     5,     4,     5,     6,     7,    21,    28,    47,
      65,    66,    89,    93,    97,    98,   100,   101,    74,    88,
      98,    26,    40,    90,    10,    17,    18,    30,    11,    26,
      80,    25,    26,    11,    26,    81,    27,    87,    26,    98,
      99,    88,    90,    56,   101,    98,   100,     6,     7,    20,
      94,    11,    12,    13,    14,    15,    16,    24,    55,    95,
       8,     9,    19,    22,    23,    96,    58,    26,    37,    88,
      98,     3,    99,     3,     4,     5,    66,    67,    71,    69,
      79,     3,    17,    28,    33,    52,    67,    84,    86,    73,
      84,    82,    25,    29,    98,    29,   100,    88,    97,   101,
      98,    74,    88,    90,    31,     3,     5,     3,    68,    30,
      68,    75,    76,    32,    99,    37,    39,    91,    29,    85,
      86,    27,    26,    40,    67,    88,    88,    31,    25,    84,
      76,    48,    85,    84
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_int8 yyr1[] =
{
       0,    63,    64,    65,    65,    65,    66,    66,    67,    67,
      67,    67,    67,    68,    68,    69,    69,    70,    71,    71,
      72,    73,    73,    74,    74,    75,    76,    76,    77,    78,
      78,    79,    79,    80,    80,    81,    81,    82,    82,    83,
      84,    84,    84,    84,    85,    85,    86,    86,    86,    87,
      88,    88,    88,    88,    88,    88,    88,    88,    88,    89,
      90,    90,    91,    91,    92,    93,    93,    93,    93,    94,
      94,    94,    95,    95,    95,    95,    95,    95,    95,    96,
      96,    96,    96,    96,    97,    97,    97,    98,    98,    99,
      99,   100,   100,   101,   101,   101,   101,   101
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     8,     1,     1,     1,     1,     1,     2,     1,
       2,     1,     1,     3,     1,     3,     1,     3,     3,     2,
       3,     3,     2,     3,     1,     3,     3,     1,     3,     4,
       1,     3,     1,     3,     1,     3,     1,     3,     2,     3,
       1,     6,     3,     2,     3,     1,     1,     3,     3,     3,
       3,     5,     1,     1,     4,     6,     4,     2,     1,     4,
       3,     1,     2,     0,     3,     1,     4,     3,     2,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     2,     1,     3,     3,     1,     3,
       1,     3,     1,     1,     1,     3,     1,     2
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
  case 2:
#line 88 "parse.y"
            { parseresult = makeprogram(yyvsp[-6], yyvsp[-4], yyvsp[-1]); }
#line 1570 "parse.tab.c"
    break;

  case 8:
#line 94 "parse.y"
                                { yyval = unaryop(yyvsp[-1], yyvsp[0]); }
#line 1576 "parse.tab.c"
    break;

  case 10:
#line 96 "parse.y"
                                { yyval = unaryop(yyvsp[-1], yyvsp[0]); }
#line 1582 "parse.tab.c"
    break;

  case 13:
#line 101 "parse.y"
                                         { yyval = cons(yyvsp[-2], yyvsp[0]); }
#line 1588 "parse.tab.c"
    break;

  case 14:
#line 102 "parse.y"
                                         { yyval = yyvsp[0]; }
#line 1594 "parse.tab.c"
    break;

  case 15:
#line 105 "parse.y"
                                        { instlabel(yyvsp[-2]); }
#line 1600 "parse.tab.c"
    break;

  case 16:
#line 106 "parse.y"
                                        { instlabel(yyvsp[0]); }
#line 1606 "parse.tab.c"
    break;

  case 17:
#line 109 "parse.y"
                                          { instconst(yyvsp[-2], yyvsp[0]); }
#line 1612 "parse.tab.c"
    break;

  case 20:
#line 116 "parse.y"
                                      { insttype(yyvsp[-2], yyvsp[0]); }
#line 1618 "parse.tab.c"
    break;

  case 23:
#line 123 "parse.y"
                                                         { yyval = cons(yyvsp[-2], yyvsp[0]); }
#line 1624 "parse.tab.c"
    break;

  case 24:
#line 124 "parse.y"
                                                         { yyval = cons(yyvsp[0], NULL); }
#line 1630 "parse.tab.c"
    break;

  case 25:
#line 127 "parse.y"
                                 { yyval = instfields(yyvsp[-2], yyvsp[0]); }
#line 1636 "parse.tab.c"
    break;

  case 26:
#line 130 "parse.y"
                                              { yyval = nconc(yyvsp[-2], yyvsp[0]); }
#line 1642 "parse.tab.c"
    break;

  case 28:
#line 134 "parse.y"
                                    { yyval = dolabel(yyvsp[-2], yyvsp[-1], yyvsp[0]); }
#line 1648 "parse.tab.c"
    break;

  case 29:
#line 137 "parse.y"
                                             { yyval = yyvsp[0]; }
#line 1654 "parse.tab.c"
    break;

  case 31:
#line 141 "parse.y"
                                     { yyval = yyvsp[0]; }
#line 1660 "parse.tab.c"
    break;

  case 33:
#line 145 "parse.y"
                                    { yyval = yyvsp[0]; }
#line 1666 "parse.tab.c"
    break;

  case 35:
#line 149 "parse.y"
                                  { yyval = yyvsp[0]; }
#line 1672 "parse.tab.c"
    break;

  case 39:
#line 157 "parse.y"
                               { instvars(yyvsp[-2], yyvsp[0]); }
#line 1678 "parse.tab.c"
    break;

  case 41:
#line 162 "parse.y"
                                                            { yyval = instarray(yyvsp[-3], yyvsp[0]); }
#line 1684 "parse.tab.c"
    break;

  case 42:
#line 163 "parse.y"
                                                             { yyval = instrec(yyvsp[-2], yyvsp[-1]); }
#line 1690 "parse.tab.c"
    break;

  case 43:
#line 164 "parse.y"
                                                             { yyval = instpoint(yyvsp[-1], yyvsp[0]); }
#line 1696 "parse.tab.c"
    break;

  case 44:
#line 167 "parse.y"
                                                          { yyval = cons(yyvsp[-2], yyvsp[0]); }
#line 1702 "parse.tab.c"
    break;

  case 45:
#line 168 "parse.y"
                                                          { yyval = cons(yyvsp[0], NULL); }
#line 1708 "parse.tab.c"
    break;

  case 46:
#line 171 "parse.y"
                                             { yyval = findtype(yyvsp[0]); }
#line 1714 "parse.tab.c"
    break;

  case 47:
#line 172 "parse.y"
                                            { yyval = instenum(yyvsp[-1]); }
#line 1720 "parse.tab.c"
    break;

  case 48:
#line 173 "parse.y"
                                            { yyval = instdotdot(yyvsp[-2], yyvsp[-1], yyvsp[0]);}
#line 1726 "parse.tab.c"
    break;

  case 49:
#line 176 "parse.y"
                                          { yyval = makeprogn(yyvsp[-2],cons(yyvsp[-1], yyvsp[0])); }
#line 1732 "parse.tab.c"
    break;

  case 50:
#line 179 "parse.y"
                                                     { yyval = makeprogn(yyvsp[-2],cons(yyvsp[-1], yyvsp[0])); }
#line 1738 "parse.tab.c"
    break;

  case 51:
#line 180 "parse.y"
                                                     { yyval = makeif(yyvsp[-4], yyvsp[-3], yyvsp[-1], yyvsp[0]); }
#line 1744 "parse.tab.c"
    break;

  case 54:
#line 183 "parse.y"
                                                              { yyval = makewhile(yyvsp[-3], yyvsp[-2], yyvsp[-1], yyvsp[0]); }
#line 1750 "parse.tab.c"
    break;

  case 55:
#line 184 "parse.y"
                                                              { yyval = makefor(1, yyvsp[-5], yyvsp[-4], yyvsp[-3], yyvsp[-2], yyvsp[-1], yyvsp[0]); }
#line 1756 "parse.tab.c"
    break;

  case 56:
#line 185 "parse.y"
                                                              { yyval = makerepeat(yyvsp[-3], yyvsp[-2], yyvsp[-1], yyvsp[0]); }
#line 1762 "parse.tab.c"
    break;

  case 57:
#line 186 "parse.y"
                                                              { yyval = dogoto(yyvsp[-1], yyvsp[0]); }
#line 1768 "parse.tab.c"
    break;

  case 59:
#line 190 "parse.y"
                                                      { yyval = makefuncall(yyvsp[-2], yyvsp[-3], yyvsp[-1]); }
#line 1774 "parse.tab.c"
    break;

  case 60:
#line 193 "parse.y"
                                               { yyval = cons(yyvsp[-1], yyvsp[0]); }
#line 1780 "parse.tab.c"
    break;

  case 61:
#line 194 "parse.y"
                                               { yyval = NULL; }
#line 1786 "parse.tab.c"
    break;

  case 62:
#line 197 "parse.y"
                                               { yyval = yyvsp[0]; }
#line 1792 "parse.tab.c"
    break;

  case 63:
#line 198 "parse.y"
                                               { yyval = NULL; }
#line 1798 "parse.tab.c"
    break;

  case 64:
#line 201 "parse.y"
                                               { yyval = binop(yyvsp[-1], yyvsp[-2], yyvsp[0]); }
#line 1804 "parse.tab.c"
    break;

  case 65:
#line 205 "parse.y"
                                                       { yyval = findid(yyvsp[0]); }
#line 1810 "parse.tab.c"
    break;

  case 66:
#line 206 "parse.y"
                                                       { yyval = arrayref(yyvsp[-3], yyvsp[-2], yyvsp[-1], yyvsp[0]); }
#line 1816 "parse.tab.c"
    break;

  case 67:
#line 207 "parse.y"
                                                       { yyval = reducedot(yyvsp[-2], yyvsp[-1], yyvsp[0]); }
#line 1822 "parse.tab.c"
    break;

  case 68:
#line 208 "parse.y"
                                                       { yyval = dopoint(yyvsp[-1], yyvsp[0]); }
#line 1828 "parse.tab.c"
    break;

  case 84:
#line 217 "parse.y"
                                   { yyval = unaryop(yyvsp[-1], yyvsp[0]); }
#line 1834 "parse.tab.c"
    break;

  case 86:
#line 219 "parse.y"
                                                        { yyval = binop(yyvsp[-1], yyvsp[-2], yyvsp[0]); }
#line 1840 "parse.tab.c"
    break;

  case 87:
#line 222 "parse.y"
                                                          { yyval = binop(yyvsp[-1], yyvsp[-2], yyvsp[0]); }
#line 1846 "parse.tab.c"
    break;

  case 89:
#line 226 "parse.y"
                                              { yyval = cons(yyvsp[-2], yyvsp[0]); }
#line 1852 "parse.tab.c"
    break;

  case 90:
#line 227 "parse.y"
                                              { yyval = cons(yyvsp[0], NULL); }
#line 1858 "parse.tab.c"
    break;

  case 91:
#line 230 "parse.y"
                                       { yyval = binop(yyvsp[-1], yyvsp[-2], yyvsp[0]); }
#line 1864 "parse.tab.c"
    break;

  case 95:
#line 236 "parse.y"
                                             { yyval = yyvsp[-1]; }
#line 1870 "parse.tab.c"
    break;

  case 97:
#line 238 "parse.y"
                                             { yyval = unaryop(yyvsp[-1], yyvsp[0]); }
#line 1876 "parse.tab.c"
    break;


#line 1880 "parse.tab.c"

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
#line 242 "parse.y"


/* You should add your own debugging flags below, and add debugging
   printouts to your programs.

   You will want to change DEBUG to turn off printouts once things
   are working.
  */

#define DEBUG        31             /* set bits here for debugging, 0 = off  */
#define DB_CONS       0             /* bit to trace cons */
#define DB_BINOP      2             /* bit to trace binop */
#define DB_MAKEIF     4             /* bit to trace makeif */
#define DB_MAKEPROGN  8             /* bit to trace makeprogn */
#define DB_PARSERES  16             /* bit to trace parseresult */
#define DB_MAKEREPEAT 1
#define DB_NCONC      1
#define DB_DOLABEL    1
#define DB_INSTCONST  0

int labelnumber = 0;  /* sequential counter for internal label numbers */
int labels[50];

   /*  Note: you should add to the above values and insert debugging
       printouts in your routines similar to those that are shown here.     */


/* arrayref processes an array reference a[i]
   subs is a list of subscript expressions.
   tok and tokb are (now) unused tokens that are recycled. */
TOKEN arrayref(TOKEN arr, TOKEN tok, TOKEN subs, TOKEN tokb) {
  if (DEBUG) {
    printf("#### in arrayref ###\n");
    dbugprinttok(arr);
    dbugprinttok(tok);
    dbugprinttok(subs);
    dbugprinttok(tokb);
  }

  SYMBOL arraysym = searchst(arr->stringval);
  SYMBOL typesym = arraysym->datatype->datatype->basicdt;

  //int twodimensions = subs->link ? 1 : 0;

  // 1D array
  if (!subs->link) {
    if (DEBUG) {
      printf("1D array\n");
    }

    int low = arr->symtype->lowbound;
    int high = arr->symtype->highbound;
    int size = arr->symtype->size / (low + high + 1);

    int datasize = subs->intval;

    int offsize = size;

    // calculate offset
    TOKEN offs = makeintc(size*datasize - offsize);

    return makearef(arr, offs, tokb);
  }

  // 2D array
  else {
    if (DEBUG) {
      printf("2D array\n");
    }

  }
}

/* binop links a binary operator op to two operands, lhs and rhs. */
TOKEN binop(TOKEN op, TOKEN lhs, TOKEN rhs)        /* reduce binary operator */ { 
  if (DEBUG && DB_BINOP) {
    printf("(DEBUG) in binop()\n");
  }

  // handle NIL
  if (rhs->whichval == (NIL - RESERVED_BIAS)) {
    rhs = makeintc(0);
    op->operands = lhs;          /* link operands to operator       */
    lhs->link = rhs;             /* link second operand to first    */
    rhs->link = NULL;            /* terminate operand list          */
  }
  
  // both integer 
  op->operands = lhs;
  lhs->link = rhs;
  rhs->link = NULL;

  // both real
  if (lhs->basicdt == REAL && rhs->basicdt == REAL) {
    op->basicdt = REAL;
  }

  // int OP real : fix rhs
  else if (lhs->basicdt == INTEGER && rhs->basicdt == REAL) {

    // fix rhs for assign
    if (op->whichval == ASSIGNOP) {
      op->basicdt = INTEGER;
      TOKEN rhsFixed = makefix(rhs);
      lhs->link = rhsFixed;
    }

    // float lhs
    else {
      op->basicdt = REAL;
      TOKEN lhsFloated = makefloat(lhs);
      lhsFloated->link = rhs;
    }
  }

  // real OP int : float rhs
  else if (lhs->basicdt == REAL && rhs->basicdt == INTEGER) {
    op->basicdt = REAL;
    TOKEN rhsFloated = makefloat(rhs);
    lhs->link = rhsFloated; // floated rhs
  }

  
  if (DEBUG & DB_BINOP) { 
    printf("binop\n");
    dbugprinttok(op);
    dbugprinttok(lhs);
    dbugprinttok(rhs);
  };
  
  return op;
}


TOKEN cons(TOKEN item, TOKEN list)           /* add item to front of list */ { 
  item->link = list;
  if (DEBUG & DB_CONS) { 
    printf("(DEBUG in cons()\n");
    dbugprinttok(item);
    dbugprinttok(list);
  };
  
  return item;
}


/* Make a new token that is a copy of the given token */
TOKEN copytok(TOKEN origtok) {  
  TOKEN tok; int i;
  tok = (TOKEN) talloc();
  tok->tokentype = origtok->tokentype;
  tok->basicdt  = origtok->basicdt;
  tok->symtype   = origtok->symtype;
  tok->symentry  = origtok->symentry;
  for (i=0; i<16; i++)
    tok->stringval[i] = origtok->stringval[i];
  return tok;
}


/* dogoto is the action for a goto statement.
   tok is a (now) unused token that is recycled. */
TOKEN dogoto(TOKEN tok, TOKEN labeltok) {
  if (DEBUG) {
    printf("(DEBUG) in dogoto()\n");
  }

  int internalLabelNum = getInternalLabel(labeltok->intval);
  
  if (internalLabelNum < 0) {
    printf("(DEBUG) INVALID LABEL NUMBER\n");
    return NULL;
  }  

  tok = makegoto(internalLabelNum);

  if (DEBUG) {
    printf("(DEBUG) end of dogoto()\n");
  }

  return tok;
}


/* dolabel is the action for a label of the form   <number>: <statement>
   tok is a (now) unused token that is recycled. */
TOKEN dolabel(TOKEN labeltok, TOKEN tok, TOKEN statement) {
  if (DEBUG && DB_DOLABEL) {
    printf("(DEBUG) in dolabel()\n");
  }

  int internalLabelNum = getInternalLabel(labeltok->intval);

  if (internalLabelNum == -1) {
    printf("(DEBUG) NO LABEL FOUND\n");
    return NULL;
  }

  labeltok = makeop(LABELOP);
  labeltok->link = statement;

  TOKEN labelNum = makeintc(internalLabelNum);

  labeltok->operands=labelNum;
    
  tok = makeprogn(tok, labeltok);

  if (DEBUG && DB_DOLABEL) {
    printf("(DEBUG) end of dolabel()\nDoLabel token: \n");
    dbugprinttok(tok);
  }

  return tok;
}


/* dopoint handles a ^ operator.
   tok is a (now) unused token that is recycled. */
TOKEN dopoint(TOKEN var, TOKEN tok) {
  if (DEBUG) {
    printf("(DEBUG) in dopoint()\n");

  }
  tok->symentry = var->symentry->datatype->datatype;
  tok->operands = var;

  return tok;
}


/* get internal label number, helper for dolabel() */
int getInternalLabel(int num) {
  for (int i = 0; i < labelnumber; i++) {
    if (labels[i] == num) {
      if (DEBUG) {
        printf("(DEBUG) in getInternalLabel()\n");
        printf("(DEBUG) found label %d\n", i);
      }
      return i;
    }
  }
  printf("(DEBUG) INTERNAL LABEL NOT FOUND\n");
  return -1;
}


/* fillintc smashes tok, making it into an INTEGER constant with value num */
TOKEN fillintc(TOKEN tok, int num) {
  tok->basicdt = INTEGER;
  tok->tokentype = NUMBERTOK;
  tok->intval = num;

  return tok;
}


TOKEN findid(TOKEN tok) { /* the ID token */
  if (DEBUG) {
    printf("(DEBUG) in findid()\n");
  }

  SYMBOL sym = searchst(tok->stringval);
  tok->symentry = sym;

  SYMBOL typ = sym->datatype;
  tok->symtype = typ;

  if (sym->kind == CONSTSYM) {   // smash constant tokens
    if (DEBUG) {
      printf ("(DEBUG) =================== constant in FINDID()\n");
    }

    // real
    if (sym->basicdt == REAL) {
      tok->tokentype = NUMBERTOK;
      tok->basicdt = REAL;
      tok->realval = sym->constval.realnum;
    }

    // integer
    if (sym->basicdt == INTEGER) {
      tok->tokentype = NUMBERTOK;
      tok->basicdt = INTEGER;
      tok->realval = sym->constval.realnum;
    }
  } else {
    if (typ->kind == BASICTYPE || typ->kind == POINTERSYM) {
      tok->basicdt = typ->basicdt;
    }
  }
  
  
  //if (typ->kind == BASICTYPE || typ->kind == POINTERSYM) {
  //  printf("************\n");
  //  tok->basicdt = typ->basicdt;
  //}
  

  if (DEBUG) {
    printf("(DEBUG) In findid()\n");
    dbugprinttok((struct tokn *) tok);
    dbugprinttok((struct tokn *) sym);
    printf("(DEBUG) end of findid()\n");
  }

  return tok;
}


/* instarray installs an array declaration into the symbol table.
   bounds points to a SUBRANGE symbol table entry.
   The symbol table pointer is returned in token typetok. */
TOKEN instarray(TOKEN bounds, TOKEN typetok) {
  if (DEBUG) {
    printf("(DEBUG) *********** in instarray()\n");
  }
  
  if (bounds->link) {

    typetok = instarray(bounds->link, typetok);

    SYMBOL subrange = bounds->symtype;
    SYMBOL typesym = typetok->symtype;
    SYMBOL arraysym = symalloc();

    arraysym->kind = ARRAYSYM;
    arraysym->datatype = typesym;
    arraysym->lowbound = subrange->lowbound;
    arraysym->highbound = subrange->highbound;
    arraysym->size = (arraysym->lowbound + arraysym->highbound - 1) * (typesym->size);
    typetok->symtype = arraysym;
    

  return typetok;


  } else {

    SYMBOL subrange = bounds->symtype;
    SYMBOL typesym = typetok->symtype;
    SYMBOL arraysym = symalloc();
    arraysym->kind = ARRAYSYM;
    arraysym->datatype = typesym;
    arraysym->lowbound = subrange->lowbound;
    arraysym->highbound = subrange->highbound;
    arraysym->size = (arraysym->highbound - arraysym->lowbound +  1) * (typesym->size);
    typetok->symtype = arraysym;
    if (DEBUG) {
      printf("install array base\n");
      dbugprinttok(typetok);
    }

    return typetok;
  }
}


/* findtype looks up a type name in the symbol table, puts the pointer
   to its type into tok->symtype, returns tok. */
TOKEN findtype(TOKEN tok) {
  SYMBOL s = searchst(tok->stringval);
  if (s->kind == TYPESYM) {
    s = s->datatype;
  }

  tok->symtype = s;
  if (DEBUG) {

  }
  return tok;
}


/* instconst installs a constant in the symbol table */
void  instconst(TOKEN idtok, TOKEN consttok) {
  if (DEBUG && DB_INSTCONST) {
    printf("(DEBUG) begin instconst()\n");
  }

  SYMBOL sym = insertsym(idtok->stringval);
  sym->kind = CONSTSYM;
  sym->basicdt = consttok->basicdt;

  if (sym->basicdt == INTEGER) {
    sym->constval.intnum = consttok->intval;
  }

  if (sym->basicdt == REAL) {
    sym->constval.realnum = consttok->realval;
  }

  if (DEBUG && DB_INSTCONST) {
    printf("(DEBUG) end of instconst()\n");
    dbugprinttok(sym);
  }
}

/* instdotdot installs a .. subrange in the symbol table.
   dottok is a (now) unused token that is recycled. */
TOKEN instdotdot(TOKEN lowtok, TOKEN dottok, TOKEN hightok) {
  if (DEBUG) {
    printf("(DEBUG) in instdotdot()\n");
  }

  int low = lowtok->intval;
  int high = hightok->intval;

  TOKEN tok = makesubrange(dottok, low, high);
  printf("*********** subrange **********\n");
  dbugprinttok(tok);
  return tok;

}


/* instenum installs an enumerated subrange in the symbol table,
   e.g., type color = (red, white, blue)
   by calling makesubrange and returning the token it returns. */
TOKEN instenum(TOKEN idlist) {
  if (DEBUG) {
    printf("(DEBUG) in instenum()\n");
  }

  int count = 0;
  TOKEN temp = idlist;

  while (temp) {
    instconst(temp, makeintc(count));
    temp = temp->link;

    count++;
  }

  TOKEN tok = makesubrange(idlist, 0, count-1);

  if (DEBUG) {
    printf("(DEBUG) end of instenum()\n");
  }

  return tok;
}


/* instfields will install type in a list idlist of field name tokens:
   re, im: real    put the pointer to REAL in the RE, IM tokens.
   typetok is a token whose symtype is a symbol table pointer.
   Note that nconc() can be used to combine these lists after instrec() */
TOKEN instfields(TOKEN idlist, TOKEN typetok) {
  if (DEBUG) {
    printf("(DEBUG) in instfields()\n");
  }

  SYMBOL typesym = typetok->symtype;
  TOKEN temp = idlist;

  while (temp) {
    temp->symtype = typesym;     
    temp = temp->link;
  }

  if (DEBUG) {
    printf("(DEBUG) end of instfields()\n");
  }

  return idlist;
}


/* instlabel installs a user label into the label table */
void  instlabel (TOKEN num) {
  if (DEBUG) {
    printf("(DEBUG) in instlabel()\n");
  }

  labels[labelnumber++] = num->intval;  

  if (DEBUG) {
    printf("install label\nCHANGE THIS LATER\n");
    printf("(DEBUG) current label table\n");
    for (int i = 0; i < labelnumber; i++) {
      printf("Label %d : %d\n", i, labels[i]);
    }
  }
}


/* instpoint will install a pointer type in symbol table */
TOKEN instpoint(TOKEN tok, TOKEN typename) {
  if (DEBUG) {
    printf("(DEBUG) in instpoint()\n");
  }

  SYMBOL pointSym = symalloc();
  SYMBOL pointType = searchins(typename->stringval);

  pointSym->basicdt = POINTER;
  pointSym->datatype = pointType;
  pointSym->kind = POINTERSYM;
  pointSym->size = basicsizes[POINTER];

  tok->symtype = pointSym;

  if (DEBUG) {
    printf("(DEBUG) end of instpoint\n");
  }

  return tok;
}


/* instrec will install a record definition.  Each token in the linked list
   argstok has a pointer its type.  rectok is just a trash token to be
   used to return the result in its symtype */
TOKEN instrec(TOKEN rectok, TOKEN argstok) {
  if (DEBUG) {
    printf("(DEBUG) in instrec()\n");
  }
  int count = 0;
  int next = 0;

  SYMBOL recSym = symalloc();
  recSym->kind = RECORDSYM;

  SYMBOL prev = NULL;
  TOKEN temp = argstok;

  while (temp) {
    int align = alignsize(temp->symtype);

    SYMBOL currFieldTok = makesym(temp->stringval);
    currFieldTok->datatype = temp->symtype;
    currFieldTok->offset = wordaddress(next, align);
    currFieldTok->size = temp->symtype->size;

    next = currFieldTok->offset + currFieldTok->size;
    currFieldTok->link = NULL;

    if (count == 0) { // first case
      recSym->datatype = currFieldTok;
      prev = currFieldTok;
    } else {
      prev->link = currFieldTok;
      prev = currFieldTok;
    }

    temp = temp->link;
    count++;
  }

  recSym->size = wordaddress(next, 16); 
  rectok->symtype = recSym;

  if (DEBUG) {
    printf("(DEBUG) end of instrec()\n");
    printf("Record Size: %d\n", recSym->size);
    printf("Record Token: \n");
    dbugprinttok(rectok);
  }
  return rectok;
}


/* insttype will install a type name in symbol table.
   typetok is a token containing symbol table pointers. */
void insttype(TOKEN typename, TOKEN typetok) {
	if (DEBUG) {
		printf("(DEBUG) in insttype()\n");
		dbugprinttok(typename);
	}

	SYMBOL typesym = searchins(typename->stringval);
  typesym->kind = TYPESYM;
  typesym->datatype = typetok->symtype;
  typesym->size = typetok->symtype->size;

  if (DEBUG) {
		printf("(DEBUG) end of insttype()\n");
	}
}


/* install variables in symbol table */
void instvars(TOKEN idlist, TOKEN typetok) {  
  SYMBOL sym, typesym; int align;
  typesym = typetok->symtype;
  align = alignsize(typesym);
  while ( idlist != NULL )   /* for each id */ {  
    sym = insertsym(idlist->stringval);
    sym->kind = VARSYM;
    sym->offset =     /* "next" */
              wordaddress(blockoffs[blocknumber],
                          align);
    sym->size = typesym->size;
    blockoffs[blocknumber] =   /* "next" */
                         sym->offset + sym->size;
    sym->datatype = typesym;
    sym->basicdt = typesym->basicdt;
    idlist = idlist->link;
  };
}


/* makearef makes an array reference operation.
   off is be an integer constant token
   tok (if not NULL) is a (now) unused token that is recycled. */
TOKEN makearef(TOKEN var, TOKEN off, TOKEN tok) {
  if (DEBUG) {
    printf("(DEBUG) in makearef()\n");
    dbugprinttok(var);
    dbugprinttok(off);
    dbugprinttok(tok);
  }

  // nested AREF, dont need to make another
  if (var->whichval == AREFOP) {
    if (DEBUG) {
      printf("*** AREF case 1\n");
      dbugprinttok(off);
      dbugprinttok(var->operands->link);
      printf("VAL %d\n", var->operands->link->intval);
    }

    var->operands->link->intval += off->intval;

    if (DEBUG) {
      printf("##### result AREF tok1 \n");
      debugprinttok(var);
      debugprinttok(var->operands);
    }

    return var;
  } 

  else {
    if (DEBUG) {
      printf("AREF case 2\n");
    }

    tok = makeop(AREFOP);
    var->link = off;

    tok->basicdt = var->symentry->datatype;
    tok->operands = var;
    tok->symentry = var->symentry;
  }

  if (DEBUG) {
    printf("##### result AREF tok 2 \n");
    debugprinttok(tok);
    debugprinttok(var->operands);
  }

  return tok;
}


/* makefix forces the item tok to be integer, by truncating a constant
   or by inserting a FIXOP operator */
TOKEN makefix(TOKEN tok) {
  if (tok->tokentype == NUMBERTOK) {
    tok->basicdt = INTEGER;
    tok->intval = (int) tok->realval;
    return tok;

  } else { 
    TOKEN fixop = makeop(FIXOP);
    fixop->operands = tok;
    return fixop;
  }
}


/* makefloat forces the item tok to be floating, by floating a constant
   or by inserting a FLOATOP operator */
TOKEN makefloat(TOKEN tok) {
  if (tok->tokentype == NUMBERTOK) {
    tok->basicdt = REAL;
    tok->realval = (double) tok->intval;
    return tok;

  } else {
    TOKEN floatop = makeop(FLOATOP);
    floatop->operands = tok;
    return floatop;
  }
}


/* makefor makes structures for a for statement.
   sign is 1 for normal loop, -1 for downto.
   asg is an assignment statement, e.g. (:= i 1)
   endexpr is the end expression
   tok, tokb and tokc are (now) unused tokens that are recycled. */
TOKEN makefor(int sign, TOKEN tok, TOKEN asg, TOKEN tokb, TOKEN endexpr,
              TOKEN tokc, TOKEN statement) {

  tok = makeprogn(tok, asg);

  int currentLabel = labelnumber;
  TOKEN label = makelabel();
  
  TOKEN gototok = makegoto(currentLabel);

  asg->link = label;

  TOKEN ifStatement = tokb;
  TOKEN bodyStatement = tokc;
  bodyStatement = makeprogn(bodyStatement, statement);

  TOKEN testStatement = makeop(LEOP);

  ifStatement = makeif(ifStatement, testStatement, bodyStatement, NULL);

  TOKEN tok1 = copytok(asg->operands);
  TOKEN tok2 = copytok(tok1);
  TOKEN tok3 = copytok(tok2);

  tok1->link = endexpr;
  testStatement->operands = tok1;

  TOKEN assignmentStatement = makeop(ASSIGNOP);
  TOKEN increment = makeop(PLUSOP);

  int inc = 1;
  tok3->link=makeintc(inc);

  increment->operands=tok3;
  tok2->link=increment;
  assignmentStatement->operands=tok2;

  assignmentStatement->link = gototok;
  statement->link = assignmentStatement;

  testStatement->link = bodyStatement;
  ifStatement->operands = testStatement;
  label->link = ifStatement;

  if (DEBUG ) {
    printf("makefor\n");
    dbugprinttok(tok);
  }

  return tok;
}


/* makefuncall makes a FUNCALL operator and links it to the fn and args.
   tok is a (now) unused token that is recycled. */
TOKEN makefuncall(TOKEN tok, TOKEN fn, TOKEN args) {
  // make tok into funcall token
  //TOKEN funcTok = makeop(FUNCALLOP);

  // set basicdt based on args to avoid floating?

  //tok = binop(funcTok, fn, args);

  if (DEBUG) {
    printf("(DEBUG) in makefuncall ===========\n" );
    dbugprinttok(tok);
  }

  // handle writeln
  if (strcmp(fn->stringval, "writeln") == 0) {
    if (args->basicdt == REAL) {
      strcpy(fn->stringval, "writelnf");
      tok->basicdt = REAL;
    } else if (args->tokentype == STRINGTOK) {
      strcpy(fn->stringval, "writeln");
      tok->basicdt = STRING;
    } else {
      strcpy(fn->stringval, "writelni");
      tok->basicdt = INTEGER;
    } 
  } 


  else if (strcmp(fn->stringval, "new") == 0) {
    SYMBOL typeSym = searchst(args->stringval);
    if (!typeSym) {
			printf("TYPE NOT FOUND\n");
      return NULL;
		}

    TOKEN funcTok = makeop(FUNCALLOP);

		tok = makeop(ASSIGNOP); 
		tok->operands = args;

		args->link = funcTok;
		funcTok->operands = fn;

		fn->link = makeintc(typeSym->datatype->datatype->datatype->size);

    return tok;
	}
  
  
  else {
    //tok->basicdt = args->basicdt;
    SYMBOL funct = searchst(fn->stringval);

    if (!funct) {
      return NULL;
    }
    if (DEBUG) {
      printf("(DEBUG) symbol +++++++++++++++\n");
      dbugprinttok(funct);
    }
    tok->basicdt = funct->datatype->basicdt;
    //tok->symtype = funct;
  }

  //tok->basicdt = args->basicdt;
  tok->whichval = FUNCALLOP;
  tok->tokentype = OPERATOR;
  tok->operands = fn;
  fn->link = args;

  if (DEBUG) {
    printf("(DEBUG) end of makefuncall\n");
    debugprinttok(tok);
    printf("(DEBUG) *************\n");
  }

	return tok;
}


/* makegoto makes a GOTO operator to go to the specified label.
   The label number is put into a number token. */
TOKEN makegoto(int label) {
  TOKEN tok = talloc();
  tok->tokentype = OPERATOR;
  tok->whichval = GOTOOP;
  tok->operands = makeintc(label);

  return tok;
}


TOKEN makeif(TOKEN tok, TOKEN exp, TOKEN thenpart, TOKEN elsepart) {  
  tok->tokentype = OPERATOR;  /* Make it look like an operator   */
  tok->whichval = IFOP;
  if (elsepart != NULL) elsepart->link = NULL;
  thenpart->link = elsepart;
  exp->link = thenpart;
  tok->operands = exp;
  if (DEBUG & DB_MAKEIF) { 
    printf("makeif\n");
    dbugprinttok(tok);
    dbugprinttok(exp);
    dbugprinttok(thenpart);
    dbugprinttok(elsepart);
  };
  
  return tok;
}


/* makeintc makes a new integer number token with num as its value */
TOKEN makeintc(int num) {
  TOKEN tok = talloc();
  fillintc(tok, num);
  
  return tok;
}


/* makelabel makes a new label, using labelnumber++ */
TOKEN makelabel() {
  TOKEN label = makeop(LABELOP);
  TOKEN num = makeintc(labelnumber);
  labelnumber++;
  return unaryop(label, num);
}


/* Make an operator token */
TOKEN makeop(int op) {  
  TOKEN tok;
  tok = (TOKEN) talloc();
  tok->tokentype = OPERATOR;
  tok->link = NULL;
  tok->operands = NULL;
  tok->whichval = op;

  if (DEBUG) {
    debugprinttok(tok);
  }
  return tok;
}


TOKEN makeprogn(TOKEN tok, TOKEN statements) {  
  tok->tokentype = OPERATOR;
  tok->whichval = PROGNOP;
  tok->operands = statements;
  if (DEBUG & DB_MAKEPROGN) { 
    printf("makeprogn\n");
    dbugprinttok(tok);
    dbugprinttok(statements);
  };
  
  return tok;
}


/* makeprogram makes the tree structures for the top-level program */
TOKEN makeprogram(TOKEN name, TOKEN args, TOKEN statements) {
  TOKEN tok = talloc();

  tok->tokentype = OPERATOR;
  tok->whichval = PROGRAMOP;
  tok->operands = name;

  TOKEN progargs = talloc();

  progargs = makeprogn(progargs, args);

  name->link = progargs;
  progargs->link = statements;

  if (DEBUG) {
    printf("(DEBUG) makeprogram()\n");
    dbugprinttok(tok);
    dbugprinttok(progargs);
  }

  return tok;
}


/* makerepeat makes structures for a repeat statement.
   tok and tokb are (now) unused tokens that are recycled. */
TOKEN makerepeat(TOKEN tok, TOKEN statements, TOKEN tokb, TOKEN expr) {
  if (DEBUG && DB_MAKEREPEAT) {
    printf("(DEBUG) makerepeat()\n");
  }

  TOKEN gototok = makegoto(labelnumber);
  TOKEN label = makelabel();

  tok = makeprogn(tok, label);
  TOKEN body = makeprogn(tokb, statements);
  label->link = body;

  TOKEN thenTok = makeprogn((TOKEN) talloc(), NULL);
  thenTok->link = gototok;

  TOKEN ifToken = talloc();
  ifToken = makeif(ifToken, expr, thenTok, gototok);

  body->link = ifToken;

  if (DEBUG && DB_MAKEREPEAT) {
    printf("(DEBUG) end of makerepeat()\n");
    dbugprinttok(tok);
  }

  return tok;  
}


/* makesubrange makes a SUBRANGE symbol table entry, puts the pointer to it
   into tok, and returns tok. */
TOKEN makesubrange(TOKEN tok, int low, int high) {
  if (DEBUG) {
    printf("(DEBUG) in makesubrange()\n");
  }
  
  SYMBOL sym = symalloc();

  sym->basicdt = INTEGER;
  sym->kind = SUBRANGE;
  sym->lowbound = low;
  sym->highbound = high;
  sym->size = basicsizes[INTEGER];

  tok->symtype = sym;

  if (DEBUG) {
    printf("(DEBUG) end of makesubrange()\nToken:");
    dbugprinttok(tok);
  }

  return tok;
}


/* makewhile makes structures for a while statement.
   tok and tokb are (now) unused tokens that are recycled. */
TOKEN makewhile(TOKEN tok, TOKEN expr, TOKEN tokb, TOKEN statement) {
  if (DEBUG) {
    printf("(DEBUG) in makewhile()\n");
  }

  int labelNum = labelnumber;
  TOKEN gotoTok = makegoto(labelNum);
  statement->link = gotoTok;

  TOKEN label = makelabel();
  tok = makeprogn(tok, label);
  
  TOKEN bodyTok = makeprogn(tokb, statement);

  TOKEN ifTok = talloc();
  ifTok = makeif(ifTok, expr, bodyTok, NULL);

  label->link = ifTok;

  if (DEBUG) {
    printf("(DEBUG) end of makewhile()\n");
  }

  return tok;
}


/* nconc concatenates two token lists, destructively, by making the last link
   of lista point to listb.
   (nconc '(a b) '(c d e))  =  (a b c d e)  */
/* nconc is useful for putting together two fieldlist groups to
   make them into a single list in a record declaration. */
/* nconc should return lista, or listb if lista is NULL. */
TOKEN nconc(TOKEN lista, TOKEN listb) {
  if (DEBUG && DB_NCONC) {
    printf("(DEBUG) in nconc()\n");
  }

  if (!lista) {
    return listb;
  }

  TOKEN temp = lista;

  while (temp->link) {
    temp = temp->link;
  }
  temp->link = listb;

  if (DEBUG && DB_NCONC) {
    printf("(DEBUG) end of nconc()\n");
  }

  return temp;
}

/* reducedot handles a record reference.
   dot is a (now) unused token that is recycled. */
TOKEN reducedot(TOKEN var, TOKEN dot, TOKEN field) {
  if (DEBUG) {
    printf("(DEUBG) in reducedot()\n");
  }

  if (!var || !dot || !field) {
    printf("ERROR IN REDUCEDOT\n");
  }

  
  SYMBOL sym = var->symentry;
  SYMBOL temp = sym->datatype->datatype;

  int currentOffset = 0;

  while (temp) {
    if (DEBUG) {
      printf("DEBUG: in for loop in reducedot\n");
    } 

    if (strcmp(field->stringval, temp->namestring) == 0) {
      currentOffset = temp->offset;
      var->symentry = temp;

      dot = makearef(var, makeintc(currentOffset), dot);
      dot->basicdt = var->symentry->datatype->basicdt;

      if (DEBUG) {
        printf("(DEBUG) end of reducedot() in if\n");
        dbugprinttok(dot);
      }
      
      return dot;
    } 
    
    temp = temp->link;
  }

  if (DEBUG) {
    printf("DEBUG: after for loop in reducedot\n");
  }

  dot = makearef(var, makeintc(currentOffset), dot);

  if (DEBUG) {
        printf("(DEBUG) end of reducedot() in if\n");
        dbugprinttok(dot);
      }

  if (DEBUG) {
    printf("(DEBUG) end of reducedot()\n");
  }

  return dot;
}


/* unaryop links a unary operator op to one operand, lhs */
TOKEN unaryop(TOKEN op, TOKEN lhs) {
  op->operands = lhs;
  lhs->link = NULL;
  return op;
}


/* ======================================================================================== */
/* Return functions                                                                         */

int wordaddress(int n, int wordsize)
  { return ((n + wordsize - 1) / wordsize) * wordsize; }
 
void yyerror (char const *s)
{
  fprintf (stderr, "%s\n", s);
}

int main(void)          /*  */
  { int res;
    initsyms();
    res = yyparse();
    //printst();       /* to shorten, change to:  printstlevel(1);  */
    printstlevel(1);
    printf("yyparse result = %8d\n", res);
    if (DEBUG & DB_PARSERES) dbugprinttok(parseresult);
    ppexpr(parseresult);           /* Pretty-print the result tree */
    /* uncomment following to call code generator. */
      
    //gencode(parseresult, blockoffs[blocknumber], labelnumber);
 
  }
