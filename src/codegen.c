#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include "token.h"
#include "symtab.h"
#include "lexer.h"
#include "genasm.h"
#include "codegen.h"
#include "pprint.h"

void genc(TOKEN code, int scope);

char* ops[]  = {" ", "+", "-", "*", "/", ":=", "=", "<>", "<", "<=",
                      ">=", ">",  "^", ".", "and", "or", "not", "div", "mod",
                      "in", "if", "goto", "progn", "label", "funcall",
                      "aref", "program", "float", "fix"};

/* Set DEBUGGEN to 1 for debug printouts of code generation */
#define DEBUGGEN 1

int nextlabel;    /* Next available label number */
int stkframesize;   /* total stack frame size */

FILE *userProg;
FILE *privProg;

void gencode(TOKEN pcode, int varsize, int maxlabel) {  
    printf("print gencode\n");

    initOutputFiles();

    TOKEN name, code;
    name = pcode->operands;
    code = name->link->link;

    printf("Debug: ");
    printtok(code);
    
    genc(code, UNPRIV_SCOPE);

    fprintf(userProg, "end.");
    fprintf(privProg, "end.");
}

/* Initialize the resulting split programs */
void initOutputFiles() {
  userProg = fopen("user.pas", "w");
    if (!userProg) {
        perror("Failed to open user.pas");
        return;
    }
    fprintf(userProg, "%s", "{ Generated user program }\n");
    fprintf(userProg, "%s", "program UserProg(ouput);\n\n");

    /* Vars */


    fprintf(userProg, "begin\n");

    privProg = fopen("priv.pas", "w");
    if (!privProg) {
        perror("Failed to open priv.pas");
        return;
    }
    fprintf(privProg, "%s", "{ Generated privileged program }\n");
    fprintf(privProg, "%s", "program privProg(ouput);\n\n");
    fprintf(privProg, "begin\n");
}


/* Traverse the AST */
void genc(TOKEN code, int scope) {  
  //fprintf(userProg, "%s", "{ in genc }\n");

  TOKEN tok, lhs, rhs;
  int reg, offs;
  SYMBOL sym;

  int next_scope = (code->scope ? PRIV_SCOPE : UNPRIV_SCOPE) || scope;

  if (DEBUGGEN) { 
    printf("genc\n");
	  dbugprinttok(code);
  }
  
  if (code->tokentype != OPERATOR) { 
    printf("Bad code token");
	  dbugprinttok(code);
	}

  FILE *out = !(code->scope) ? userProg : privProg;
  
  switch (code->whichval) { 
    case PROGNOP:
	  tok = code->operands;
	  
    while (tok != NULL) {  
      genc(tok, next_scope);
		  tok = tok->link;
	  }
	  break;

	  case ASSIGNOP:            
      if (DEBUGGEN) {
        printf("ASSIGNOP: \n");
      }      

      lhs = code->operands;
      rhs = lhs->link;

      fprintf(userProg, "%s := ", lhs->stringval);

      // generate code for rhs
      gen_rhs(rhs, next_scope);            

      fprintf(userProg, ";\n");

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
      int label = code->operands->intval;

      fprintf(userProg, "goto  %d;\n", label);
      break;

    case LABELOP:
      if (DEBUGGEN) {
        printf("LABELOP: ");
      } 

      fprintf(userProg, "label %d:\n", code->operands->intval);
      break;

    case IFOP:
      if (DEBUGGEN) {
        printf("IFOP: ");
      } 
      /*     ***** fix this *****   */
      break;

    case PLUSOP:
      if (DEBUGGEN) {
        printf("PLUSOP: ");
      }
      
      break;
  }  
}

void gen_rhs(TOKEN code, int scope) {   
  int num, reg;

  int next_scope = (code->scope ? PRIV_SCOPE : UNPRIV_SCOPE) || scope;
  
  if (DEBUGGEN) { 
    printf("gen rhs\n");
	  dbugprinttok(code);
  }
  
  switch (code->tokentype) { 
    case NUMBERTOK:

      switch (code->basicdt) {
        case INTEGER:
		      num = code->intval;
          fprintf(userProg, "%d", num);
          break;
	      
        case REAL:
          fprintf(userProg, "%f", code->realval);
          break;
	    }
	   break;
    
    case IDENTIFIERTOK:
      fprintf(userProg, "%s", code->stringval);
      break;

    case OPERATOR:
      genc(code, next_scope);
      break;
  }
  return reg;
}

