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
#define DEBUGGEN 1

int nextlabel;    /* Next available label number */
int stkframesize;   /* total stack frame size */

FILE *userProg;
FILE *privProg;

void gencode(TOKEN pcode, int varsize, int maxlabel) {  
    printf("print gencode\n");

    userProg = fopen("user.pas", "w");
    if (!userProg) {
        perror("Failed to open user.pas");
        return;
    }

    privProg = fopen("priv.pas", "w");
    if (!privProg) {
        perror("Failed to open priv.pas");
        return;
    }

    TOKEN name, code;
    name = pcode->operands;
    code = name->link->link;
    
    genc(code);
}


/* Traverse the AST */
void genc(TOKEN code) {  
  TOKEN tok, lhs, rhs;
  int reg, offs;
  SYMBOL sym;

  if (DEBUGGEN) { 
    printf("genc\n");
	  dbugprinttok(code);
  }
  
  if (code->tokentype != OPERATOR) { 
    printf("Bad code token");
	  dbugprinttok(code);
	}
  
  switch (code->whichval) { 
    case PROGNOP:
	  tok = code->operands;
	  
    while (tok != NULL) {  
      genc(tok);
		  tok = tok->link;
	  }
	  break;

	  case ASSIGNOP:            
      if (DEBUGGEN) {
        printf("ASSIGNOP: \n");
      }      

      lhs = code->operands;
      rhs = lhs->link;

      // generate rhs logic recursively
      reg = genarith(rhs);              /* generate rhs into a register */

      sym = lhs->symentry;              /* assumes lhs is a simple var  */
      offs = sym->offset - stkframesize; /* net offset of the var   */
        switch (code->basicdt) {          /* store value into lhs  */  
          case INTEGER:
            //asmst(MOVL, reg, offs, lhs->stringval);
            break;
          /* ...  */
        }
      break;

    case FUNCALLOP:
      if (DEBUGGEN) {
        printf("FUNCALLOP: ");
      } 
      /*     ***** fix this *****   */
      break;

    case GOTOOP:
      if (DEBUGGEN) {
        printf("GOTOOP: ");
      } 
      /*     ***** fix this *****   */
      break;

    case LABELOP:
      if (DEBUGGEN) {
        printf("LABELOP: ");
      } 
      /*     ***** fix this *****   */
      break;

    case IFOP:
      if (DEBUGGEN) {
        printf("IFOP: ");
      } 
      /*     ***** fix this *****   */
      break;
    }
}

int genarith(TOKEN code) {   
  int num, reg;
  if (DEBUGGEN) { 
    printf("genarith\n");
	  dbugprinttok(code);
  }
  
  switch (code->tokentype) { 
    case NUMBERTOK:

      switch (code->basicdt) {
        case INTEGER:
		      num = code->intval;
          //reg = getreg(WORD);
          if (num >= MINIMMEDIATE && num <= MAXIMMEDIATE)
            //asmimmed(MOVL, num, reg);
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
  }
  return reg;
}


/* Split operator */
void gen_operator(TOKEN node) {

}

