/* token.h           token definitions          09 Feb 00  */

/* Copyright (c) 2000 Gordon S. Novak Jr. and
   The University of Texas at Austin. */

/* This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License (file gpl.text) for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA. */

                                 /* token data structure */
typedef struct tokn {
  int    tokentype;  /* OPERATOR, DELIMITER, RESERVED, etc */
  int    datatype;   /* INTEGER, REAL, STRINGTYPE, or BOOLETYPE */
  struct symtbr * symtype;
  struct symtbr * symentry;
  struct tokn * operands;
  struct tokn * link;
  union { char  tokenstring[16];   /* values of different types, overlapped */
          int   which;
          long  intnum;
          double realnum; } tokenval;
  } *TOKEN;

/* The following alternative kinds of values share storage in the token
   record.  Only one of the following can be present in a given token.  */
#define whichval  tokenval.which
#define intval    tokenval.intnum
#define realval   tokenval.realnum
#define stringval tokenval.tokenstring

#define OPERATOR       0         /* token types */
#define DELIMITER      1
#define RESERVED       2
#define IDENTIFIERTOK  3
#define STRINGTOK      4
#define NUMBERTOK      5

#define PLUSOP         1         /* operator numbers */
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
#define IFOP          20
#define GOTOOP        21
#define PROGNOP       22
#define LABELOP       23
#define FUNCALLOP     24
#define AREFOP        25
#define PROGRAMOP     26
#define FLOATOP       27
#define FIXOP         28

#define INTEGER    0             /* number types */
#define REAL       1
#define STRINGTYPE 2
#define BOOLETYPE  3

#define IDENTIFIER 257          /* token types for use with YACC */
#define STRING 258
#define NUMBER 259

   /* subtract OPERATOR_BIAS from the following to get operator numbers */
#define PLUS 260
#define OPERATOR_BIAS  (PLUS - 1)    /* added to Operators */
#define MINUS 261
#define TIMES 262
#define DIVIDE 263
#define ASSIGN 264
#define EQ 265
#define NE 266
#define LT 267
#define LE 268
#define GE 269
#define GT 270
#define POINT 271
#define DOT 272
#define AND 273
#define OR 274
#define NOT 275
#define DIV 276
#define MOD 277
#define IN 278

   /* subtract DELIMITER_BIAS from the following to get delimiter numbers */
#define COMMA 279
#define DELIMITER_BIAS (COMMA - 1)   /* added to Delimiters */
#define SEMICOLON 280
#define COLON 281
#define LPAREN 282
#define RPAREN 283
#define LBRACKET 284
#define RBRACKET 285
#define DOTDOT 286

   /* subtract RESERVED_BIAS from the following to get reserved word numbers */
#define ARRAY 287
#define RESERVED_BIAS  (ARRAY - 1)   /* added to reserved words */
#define BEGINBEGIN 288               /* begin */
#define CASE 289
#define CONST 290
#define DO 291
#define DOWNTO 292
#define ELSE 293
#define END 294
#define FILEFILE 295                 /* file */
#define FOR 296
#define FUNCTION 297
#define GOTO 298
#define IF 299
#define LABEL 300
#define NIL 301
#define OF 302
#define PACKED 303
#define PROCEDURE 304
#define PROGRAM 305
#define RECORD 306
#define REPEAT 307
#define SET 308
#define THEN 309
#define TO 310
#define TYPE 311
#define UNTIL 312
#define VAR 313
#define WHILE 314
#define WITH 315

