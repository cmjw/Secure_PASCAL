/* codgen.c       Generate Assembly Code for x86         07 May 18   */

/* Copyright (c) 2018 Gordon S. Novak Jr. and The University of Texas at Austin
    */

/* Written by Gordon S. Novak Jr.                  */

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

#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include "token.h"
#include "symtab.h"
#include "lexer.h"
#include "genasm.h"
#include "codegen.h"
#include "pprint.h"

void genc(TOKEN code);

/* Set DEBUGGEN to 1 for debug printouts of code generation */
#define DEBUGGEN 0

int nextlabel;    /* Next available label number */
int stkframesize;   /* total stack frame size */

/* Top-level entry for code generator.
   pcode    = pointer to code:  (program foo (output) (progn ...))
   varsize  = size of local storage in bytes
   maxlabel = maximum label number used so far

Add this line to the end of your main program:
    gencode(parseresult, blockoffs[blocknumber], labelnumber);
The generated code is printed out; use a text editor to extract it for
your .s file.
         */

void gencode(TOKEN pcode, int varsize, int maxlabel)
  {  TOKEN name, code;
     name = pcode->operands;
     code = name->link->link;
     nextlabel = maxlabel + 1;
     stkframesize = asmentry(name->stringval,varsize);
     genc(code);
     asmexit(name->stringval);
  }

/* Trivial version */
/* Generate code for arithmetic expression, return a register number */
int genarith(TOKEN code)
  {   int num, reg;
     if (DEBUGGEN)
       { printf("genarith\n");
	 dbugprinttok(code);
       };
      switch ( code->tokentype )
       { case NUMBERTOK:
           switch (code->basicdt)
             { case INTEGER:
		 num = code->intval;
		 reg = getreg(WORD);
		 if ( num >= MINIMMEDIATE && num <= MAXIMMEDIATE )
		   asmimmed(MOVL, num, reg);
		 break;
	       case REAL:
    /*     ***** fix this *****   */
		 break;
	       }
	   break;
       case IDENTIFIERTOK:
    /*     ***** fix this *****   */
	   break;
       case OPERATOR:
    /*     ***** fix this *****   */
	   break;
       };
     return reg;
    }


/* Generate code for a Statement from an intermediate-code form */
void genc(TOKEN code)
  {  TOKEN tok, lhs, rhs;
     int reg, offs;
     SYMBOL sym;
     if (DEBUGGEN)
       { printf("genc\n");
	 dbugprinttok(code);
       };
     if ( code->tokentype != OPERATOR )
        { printf("Bad code token");
	  dbugprinttok(code);
	};
     switch ( code->whichval )
       { case PROGNOP:
	   tok = code->operands;
	   while ( tok != NULL )
	     {  genc(tok);
		tok = tok->link;
	      };
	   break;
	 case ASSIGNOP:                   /* Trivial version: handles I := e */
	   lhs = code->operands;
	   rhs = lhs->link;
	   reg = genarith(rhs);              /* generate rhs into a register */
	   sym = lhs->symentry;              /* assumes lhs is a simple var  */
	   offs = sym->offset - stkframesize; /* net offset of the var   */
           switch (code->basicdt)            /* store value into lhs  */
             { case INTEGER:
                 asmst(MOVL, reg, offs, lhs->stringval);
                 break;
                 /* ...  */
             };
           break;
	 case FUNCALLOP:
    /*     ***** fix this *****   */
	   break;
	 case GOTOOP:
    /*     ***** fix this *****   */
	   break;
	 case LABELOP:
    /*     ***** fix this *****   */
	   break;
	 case IFOP:
    /*     ***** fix this *****   */
	   break;
	 };
  }
