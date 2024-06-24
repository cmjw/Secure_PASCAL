/* token.h           token definitions         ; 11 Jan 18  */

/* Copyright (c) 2018 Gordon S. Novak Jr. and
   The University of Texas at Austin. */

/* Token structure and constant definitions, assuming Bison token numbers */

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

/* 09 Feb 00; 06 Jul 12; 01 Aug 12; 24 Dec 12
 */

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>


/* token data structure */
typedef struct tokn {
   int tokentype; 
   /* OPERATOR, DELIMITER, RESERVED, etc */
   int basicdt;   
   /* INTEGER, REAL, STRINGTYPE, BOOLETYPE, or POINTER */

   struct symtbr *symtype;
   struct symtbr *symentry;
   struct tokn *operands;
   struct tokn *link;

   union { 
      char  tokenstring[16];   /* values of different types, overlapped */
      int   which;
      int   intnum;
      double realnum; 
   } tokenval;
} *TOKEN;


/* Function declarations */
TOKEN talloc();

void printtoken(TOKEN tok);


/* The following alternative kinds of values share storage in the token
   record.  Only one of the following can be present in a given token.  */
#define whichval  tokenval.which
#define intval    tokenval.intnum
#define realval   tokenval.realnum
#define stringval tokenval.tokenstring

 /* token types */
#define OPERATOR       0        
#define DELIMITER      1
#define RESERVED       2
#define IDENTIFIERTOK  3
#define STRINGTOK      4
#define NUMBERTOK      5

/* operator numbers */
#define PLUSOP         1         
#define MINUSOP        2
#define TIMESOP        3
#define DIVIDEOP       4
#define ASSIGNOP       5
#define EQOP           6
#define NEOP           7
#define LTOP           8
#define LEOP           9
#define GEOP          10
#define GTOP          11
#define POINTEROP     12
#define DOTOP         13
#define ANDOP         14
#define OROP          15
#define NOTOP         16
#define DIVOP         17
#define MODOP         18
#define INOP          19
#define SCOPEOP       20   /* double colon scope operator */
/* end of operator bias */
#define IFOP          21
#define GOTOOP        22
#define PROGNOP       23
#define LABELOP       24
#define FUNCALLOP     25
#define AREFOP        26
#define PROGRAMOP     27
#define FLOATOP       28
#define FIXOP         29


/* number types */
#define INTEGER    0             
#define REAL       1
#define STRINGTYPE 2
#define BOOLETYPE  3
#define POINTER    4

/* record size must be a multiple of this */
#define RECORDALIGN 16        

/* token types for use with YACC */
#define IDENTIFIER 258          
#define STRING     259
#define NUMBER     260

/* subtract OPERATOR_BIAS from the following to get operator numbers */
#define PLUS        261
#define OPERATOR_BIAS  (PLUS - 1)    /* added to Operators */
#define MINUS       262
#define TIMES       263
#define DIVIDE      264
#define ASSIGN      265
#define EQ          266
#define NE          267
#define LT          268
#define LE          269
#define GE          270
#define GT          271
#define POINT       272
#define DOT         273
#define AND         274
#define OR          275
#define NOT         276
#define DIV         277
#define MOD         278
#define IN          279
#define DOUBLECOLON 280

/* subtract DELIMITER_BIAS from the following to get delimiter numbers */
#define COMMA       281
#define DELIMITER_BIAS (COMMA - 1)   /* added to Delimiters */
#define SEMICOLON   282
#define COLON       283
#define LPAREN      284
#define RPAREN      285
#define LBRACKET    286
#define RBRACKET    287
#define DOTDOT      288


/* subtract RESERVED_BIAS from the following to get reserved word numbers */
#define ARRAY       289
#define RESERVED_BIAS  (ARRAY - 1)   /* added to reserved words */
#define BEGINBEGIN  290              /* begin */
#define CASE        291
#define CONST       292
#define DO          293
#define DOWNTO      294
#define ELSE        295
#define END         296
#define FILEFILE    297                 /* file */
#define FOR         298
#define FUNCTION    299
#define GOTO        300
#define IF          301
#define LABEL       302
#define NIL         303
#define OF          304
#define PACKED      305
#define PROCEDURE   306
#define PROGRAM     307
#define RECORD      308
#define REPEAT      309
#define SET         310
#define THEN        311
#define TO          312
#define TYPE        313
#define UNTIL       314
#define VAR         315
#define WHILE       316
#define WITH        317
#define PRIV        318
//#define UNPRIV      319

#define YYTOKENTYPE 0