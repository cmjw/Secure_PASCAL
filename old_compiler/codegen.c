/* codgen.c       Generate Assembly Code for x86         07 May 18   */

/* Copyright (c) 2018 Gordon S. Novak Jr. and The University of Texas at Austin
    */

/* Starter file for CS 375 Code Generation assignment.           */
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
#include "lexan.h"
#include "genasm.h"
#include "codegen.h"
#include "pprint.h"

void genc(TOKEN code);

/* Set DEBUGGEN to 1 for debug printouts of code generation */
#define DEBUGGEN 0

#define REGISTERS 32
#define INT_REGISTER 0
#define FLOAT_REGISTER 1
#define UNUSED_REGISTER 0
#define USED_REGISTER 1

#define NUM_INT_OPS 20
#define NUM_REAL_OPS 20
#define NUM_PTR_OPS 20

int nextlabel;    /* Next available label number */
int stkframesize;   /* total stack frame size */

int regused[REGISTERS];
int integer_ops[NUM_INT_OPS];
int real_ops[NUM_REAL_OPS];
int pointer_ops[NUM_PTR_OPS];
int jump_ops[NUM_INT_OPS];

// lookup tables


void clear_registers();
void init_tables();



/* Top-level entry for code generator.
   pcode    = pointer to code:  (program foo (output) (progn ...))
   varsize  = size of local storage in bytes
   maxlabel = maximum label number used so far

Add this line to the end of your main program:
    gencode(parseresult, blockoffs[blocknumber], labelnumber);
The generated code is printed out; use a text editor to extract it for
your .s file.
         */

void gencode(TOKEN pcode, int varsize, int maxlabel) {

  if (DEBUGGEN) {
    printf ("DEBUG: in gencode()\n");
  }
  clear_registers();
  init_tables();
  TOKEN name, code;
  name = pcode->operands;
  code = name->link->link;
  nextlabel = maxlabel + 1;
  stkframesize = asmentry(name->stringval,varsize);
  genc(code);
  asmexit(name->stringval);
}

/* Trivial version: always returns RBASE + 0 */
/* Get a register.   */
/* Need a type parameter or two versions for INTEGER or REAL */
int getreg(int kind) {
  /*     ***** fix this *****   */
  // mark all unused at beginning of statement

  // when requested: if unused, mark used and return. else print error.
  // kind == 0: int, kind == 1: float

  if (DEBUGGEN) {
    printf ("DEBUG: in getreg() with kind %d\n", kind);
    printf("Returning ***%s*** register\n", kind==1 ? "FLOAT": "INTEGER");
  }

  int res = -1;

  // handle int (real) 
  if (kind == INT_REGISTER) {
    for (int i = RBASE; i <= RMAX; i++) {
      if (regused[i] == UNUSED_REGISTER) { // 0 for unused
        res = i;
        used(i);

        if (DEBUGGEN) {
          printf ("DEBUG: found reg %d\n", res);
        }

        return res;
      }
    }
  }

  // handle float
  else if (kind == FLOAT_REGISTER) {
    for (int i = FBASE; i <= FMAX; i++) {
      if (regused[i] == UNUSED_REGISTER) {
        res = i;
        used(i);

        if (DEBUGGEN) {
          printf ("DEBUG: found reg %d\n", res);
        }

        return res;
      }
    }
  }

  // TODO: if time simplify to one for loop with bounds adjusted

  return -1;
}

/* Clear registers */
void clear_registers() {
  for (int i = 0; i < 32; i++) {
    regused[i] = UNUSED_REGISTER;
  }
}

/* Mark a register used */
void used(int reg) {
  regused[reg] = USED_REGISTER;
}

/* Mark a register unused */
void unused(int reg) {
  regused[reg] = UNUSED_REGISTER;
}

/* Trivial version */
/* Generate code for arithmetic expression, return a register number */
int genarith(TOKEN code) {

  if (DEBUGGEN) {
    printf ("DEBUG: in genarith()\nDEBUG: code:");
    dbugprinttok(code);
  }

  int num, reg, offs;
  float floatnum;
  SYMBOL sym;
  TOKEN lhs;
  TOKEN rhs;

  int reg2, reg3;

  switch ( code->tokentype ) { 

    /*case STRINGTOK:
      if (DEBUGGEN) {
        printf("DEBUG: stringtok in genarith\n");
      }

      reg = EDI;

      int nextlab = nextlabel++;
      makeblit(code->stringval, nextlab);
      asmlitarg(nextlab, EDI);

      break;*/

    case NUMBERTOK:

      switch (code->basicdt) { 
        case POINTER:
          if (DEBUGGEN) {
            printf("DEBUG: pointer in genarith numbertok\n");
          }
          break;

        case INTEGER:
		      num = code->intval;
          if (DEBUGGEN) {
            printf("DEBUG: *** getreg case 1\n");
          }
		      reg = getreg(INT_REGISTER);
		      if ( num >= MINIMMEDIATE && num <= MAXIMMEDIATE )
		        asmimmed(MOVL, num, reg);
		      break;
          
	      case REAL:
          /*   fixed  */
          if (DEBUGGEN) {
            printf("DEBUG: *** getreg case 2\n");
          }
          reg = getreg(FLOAT_REGISTER);
          int label = nextlabel++;
          floatnum = code->realval;
          makeflit(floatnum, label);
          asmldflit(MOVSD, label, reg);
		      break;

	    }
	    break;
    
    case IDENTIFIERTOK:
      /*   fixed   */
      sym = code->symentry;
      offs = sym->offset - stkframesize;

      switch(code->basicdt) {
        case INTEGER:
          if (DEBUGGEN) {
            printf("DEBUG: *** getreg case 3\n");
          }
          reg = getreg(INT_REGISTER);
          asmld(MOVL, offs, reg, code->stringval);
          break;

        case REAL:
          if (DEBUGGEN) {
            printf("DEBUG: *** getreg case 4\n");
          }
          reg = getreg(FLOAT_REGISTER);
          asmld(MOVSD, offs, reg, code->stringval);
          break;
        
        case POINTER:
          if (DEBUGGEN) {
            printf("DEBUG: *** getreg case 5\n");
          }
          reg = getreg(INT_REGISTER);
          asmld(MOVQ, offs, reg, code->stringval);
          break;
      }

	    break;
    
    case OPERATOR:

      if (code->whichval == FUNCALLOP) {
        if (DEBUGGEN) {
          printf ("DEBUG: FUNCALLOP\n");
        }
        reg = genfun(code);
      } 
      
      else if (code->whichval == AREFOP) {
        if (DEBUGGEN) {
          printf ("DEBUG: AREFOP\n");
        }
        // reg?
        reg = genaref(code, reg);
      } 
      
      else if (code->whichval == FLOATOP) {
        if (DEBUGGEN) {
          printf ("DEBUG: FLOATOP\n");
        }
        
        lhs = code->operands;
        if (DEBUGGEN) {
            printf("DEBUG: *** getreg case 6\n");
        }

        reg2 = genarith(lhs);
        reg = getreg(FLOAT_REGISTER);
        
        asmfloat(reg2, reg);
        unused(reg2);

      } 
      
      else if (code->whichval == FIXOP) {
        if (DEBUGGEN) {
          printf ("DEBUG: FIXOP\n");
        }
        
        lhs = code->operands;
        reg2 = genarith(lhs);
        reg = getreg(FLOAT_REGISTER);

        asmfix(reg2, reg);
        unused(reg2);
      }

      else if (code->whichval == MINUSOP && !rhs) {

        if (DEBUGGEN) {
          printf("DEBUG: *Unary Minus*\n");
        }

        lhs = code->operands;
        rhs = lhs->link;
        reg = genarith(lhs);

        reg2 = genarith(rhs);
        asmfneg(reg, reg2);
      }

      else if (code->basicdt == INTEGER) {
        if (DEBUGGEN) {
          printf ("DEBUG: INTEGER\n");
        }

        lhs = code->operands;
        rhs = lhs->link; // args
        reg = genarith(lhs);

        if (rhs) {
          reg2 = genarith(rhs);

          if (funcallin(rhs) == 1) {
            asmsttemp(reg);
            unused(reg);
            
            asmldtemp(reg);
          }

          asmrr(integer_ops[code->whichval], reg2, reg);
          unused(reg2);
        }

        else if (code->whichval == MINUSOP) { // no rhs -> unary minus
          if (DEBUGGEN) {
            printf("DEBUG: *** getreg case 7\n");
          }
          reg2 = getreg(INT_REGISTER);

          asmfneg(reg, reg2);
          reg = reg2;
          unused(reg2);
        }
        
      }

      else if (code->basicdt == REAL) {
        if (DEBUGGEN) {
          printf ("DEBUG: REAL\n");
        }
        
        lhs = code->operands;
        rhs = lhs->link; // args
        reg = genarith(lhs);

        if (rhs) {
          reg2 = genarith(rhs);

          if (funcallin(rhs) == 1) {
            asmsttemp(reg);
            unused(reg);
            
            asmldtemp(reg);
          }

          asmrr(real_ops[code->whichval], reg2, reg);
          unused(reg2);
        }

        else {
          if (DEBUGGEN) {
            printf("DEBUG: *** getreg case 8\n");
          }
          reg2 = getreg(FLOAT_REGISTER);
          asmfneg(reg, reg2);
          reg = reg2;
          unused(reg2);
        }
      }

      else {
        if (DEBUGGEN) {
          printf ("DEBUG: INVALID\n");
        }
        // invalid
      }

	    break;
  };

  if (DEBUGGEN) {
    printf ("DEBUG: end of genarith\n");
  }
     
  return reg;
}


/* Generate code for a Statement from an intermediate-code form */
void genc(TOKEN code) {  
  clear_registers(); 

  TOKEN tok, lhs, rhs;
  int reg, offs;
  SYMBOL sym;
  
  if (DEBUGGEN) { 
    printf("DEBUG: in genc()\nDEBUG:");
	  dbugprinttok(code);
  };
     
  if ( code->tokentype != OPERATOR ) { 
    printf("Bad code token");
	  dbugprinttok(code);
	};

  switch ( code->whichval ) { 
    case PROGNOP:
	    tok = code->operands;
	    while ( tok != NULL ) {  
        genc(tok);
		    tok = tok->link;
	    };
	    break;
	 
    case ASSIGNOP:                   /* Trivial version: handles I := e */
	    lhs = code->operands;
	    rhs = lhs->link;
	    reg = genarith(rhs);              /* generate rhs into a register */
	    sym = lhs->symentry;              /* assumes lhs is a simple var  */
	    offs = sym->offset - stkframesize; /* net offset of the var   */

      // maybe check operands datatype instead?

      
      switch (lhs->basicdt) {           /* store value into lhs  */
        case INTEGER:
          if (DEBUGGEN) {
            printf("DEBUG: assignop int movl\n");
            dbugprinttok(code);
            dbugprinttok(lhs);
            dbugprinttok(rhs);
          }
          
          asmst(MOVL, reg, offs, lhs->stringval);
          break;

        case REAL:
          asmst(MOVSD, reg, offs, lhs->stringval);
          break;

        case POINTER:
          asmst(MOVQ, reg, offs, lhs->stringval); 
          break;
          /* ...  */
      };
      break;

	  case FUNCALLOP:
      /*     ***** fix this *****   */
      genfun(code);
	    break;

	  case GOTOOP:
      /*     fixed   */
	    asmjump(JMP, code->operands->intval);
      break;

	  case LABELOP:
      /*     fixed  */
	    asmlabel(code->operands->intval);
      break;

	  case IFOP:
      /*     ***** fix this *****   */
      if (DEBUGGEN) {
        printf("DEBUG: IFOP\n");
        dbugprinttok(code);
        dbugprinttok(tok);
        dbugprinttok(lhs);
        dbugprinttok(rhs);
      }
      tok = code->operands;
      lhs = tok->link;
      rhs = lhs->link;

      reg = genarith(tok);

      int thenlabel = nextlabel++;
      
      asmjump(jump_ops[tok->whichval], thenlabel);

      // if else 
      if (rhs) {
        genc(rhs);
      }

      int elselabel = nextlabel++;

      // jump to else
      asmjump(JMP, elselabel);

      // then label
      asmlabel(thenlabel);

      // generate code for lhs
      genc(lhs);

      // else label
      asmlabel(elselabel);

	    break;
	};
}

/* Generate code for a function call */
int genfun(TOKEN code) {
  if (DEBUGGEN) {
    printf("*DEBUG: in genfun()*\nDEBUG: code:");
    dbugprinttok(code);
  }

  TOKEN tok = code->operands;
  TOKEN arg = tok->link;
  SYMBOL sym = searchst(tok->stringval);

  if (DEBUGGEN) {
    printf("DEBUG: tok->stringval %s\n", tok->stringval);
  }

  int numargs = 0;

  // gen arirth and get regs for arg(s) [MOVX]
  // this is done in the recursive part instead
  /*while (arg) {
    genarith(arg);
    arg = arg->link;
    numargs++;
  }*/
  int reg;

  // new operator
  if (strcmp(tok->stringval, "new") == 0) {
    reg = genarith(arg);
    asmrr(MOVL, reg, EDI);
    //used(EDI);
  }

  // integer write
  else if (strcmp(tok->stringval, "writelni") == 0) {
    reg = genarith(arg);
    asmrr(MOVL, reg, EDI); // edi
    //used(EDI);
  }

  else if (strcmp(tok->stringval, "writelnf") == 0) { 
    // *** TODO ****
    reg = genaref(arg, XMM0);
    used(XMM0);
  }

  else {
    reg = genarith(arg);
  }

  // string arg
  if (arg->tokentype == STRINGTOK) {
    int nextlab = nextlabel++;

    makeblit(arg->stringval, nextlab); // label
    asmlitarg(nextlab, EDI);
  }


  // call the function [call]
  asmcall(tok->stringval);

  if (DEBUGGEN) {
    printf("*DEBUG: genfun result reg: %d*\n", reg);
  }
  return reg;
}

/* test if there is a function call within code: 1 if true, else 0 */
int funcallin(TOKEN code) {
  if (DEBUGGEN) {
    printf("DEBUG: in funcallin\n");
  }

  if (code->whichval == FUNCALLOP) {
    return 1; // funcall in code
  } 
  else if (code->link) {
    return funcallin(code->link);
  } 
  else {
    return 0;
  }
}

/* Generate code for array references and pointers */
/* In Pascal, a (^ ...) can only occur as first argument of an aref. */
/* If storereg < 0, generates a load and returns register number;
   else, generates a store from storereg. */
int genaref(TOKEN code, int storereg) {
  if (DEBUGGEN) {
    printf("DEBUG: in genaref CASE %d\n", storereg);
  }

  TOKEN aref, off;
  int res, reg2 = storereg;
  
  // AREP
  if (code->whichval == AREFOP) {
    if (DEBUGGEN) {
      printf("DEBUG: AREFOP\n");
    }

    if ((aref = code->operands)->tokentype == IDENTIFIERTOK) {
      res = genarith(aref->link);
      asmop(CLTQ);
      return res;
    }

    else {
      res = genarith(aref);
      off = aref->link;

      if (storereg < 0) {
        reg2 = getreg(INT_REGISTER);
        asmldr(MOVQ, off->intval, res, reg2, aref->stringval);
      }

      else {
        // use storereg
        asmldr(MOVSD, off->intval, res, reg2, aref->stringval);
      }

      // clear
      unused(res);
    }

  }

  // POINTER
  else if (code->whichval == POINTEROP) {
    if (DEBUGGEN) {
      printf("DEBUG: POINTER\n");
    }


  }
  
  // ERROR?
  else {
    printf("ERROR IN GENAREF\n");
  }

  return res;
}

/* initialize lookup tables */
void init_tables() {
  // integer ops
  integer_ops[PLUSOP] = ADDL;
  integer_ops[MINUSOP] = SUBL;
  integer_ops[TIMESOP] = IMULL;
  integer_ops[DIVIDEOP] = DIVL;
  integer_ops[EQOP] = CMPL;
  integer_ops[NEOP] = CMPL;
  integer_ops[LEOP] = CMPL;
  integer_ops[LTOP] = CMPL;
  integer_ops[GEOP] = CMPL;
  integer_ops[GTOP] = CMPL;
  integer_ops[ANDOP] = ANDL;
  integer_ops[OROP] = ORL;

  // real ops
  real_ops[PLUSOP] = ADDSD;
  real_ops[MINUSOP] = SUBSD;
  real_ops[TIMESOP] =  MULSD;
  real_ops[DIVIDEOP] = DIVSD;
  real_ops[EQOP] = CMPSD;
  real_ops[NEOP] = CMPSD;
  real_ops[LEOP] = CMPSD;
  real_ops[LTOP] = CMPSD;
  real_ops[GEOP] = CMPSD;
  real_ops[GTOP] = CMPSD;
  real_ops[NOTOP] = NEGSD;

  // ptr ops
  pointer_ops[PLUSOP] = ADDQ;
  pointer_ops[MINUSOP] = SUBQ;
  pointer_ops[TIMESOP] =  IMULQ;
  pointer_ops[EQOP] = CMPQ;
  pointer_ops[NEOP] = CMPQ;
  pointer_ops[LEOP] = CMPQ;
  pointer_ops[LTOP] = CMPQ;
  pointer_ops[GEOP] = CMPQ;
  pointer_ops[GTOP] = CMPQ;
  pointer_ops[NOTOP] = NEGSD;
  pointer_ops[OROP] = ORQ;
  pointer_ops[ANDOP] = ANDQ;

  // jump ops
  jump_ops[EQOP] = JE;
  jump_ops[NEOP] = JNE;
  jump_ops[LTOP] = JL;
  jump_ops[LEOP] = JLE;
  jump_ops[GTOP] = JG;
  jump_ops[GEOP] = JGE;
}