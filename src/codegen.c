#include "token.h"
#include "symtab.h"
#include "lexer.h"
#include "genasm.h"
#include "pprint.h"
#include "codegen.h"

void genc(TOKEN code, int scope);

char* ops[]  = {" ", "+", "-", "*", "/", ":=", "=", "<>", "<", "<=",
                      ">=", ">",  "^", ".", "and", "or", "not", "div", "mod",
                      "in", "if", "goto", "progn", "label", "funcall",
                      "aref", "program", "float", "fix"};

/* Set DEBUGGEN to 1 for debug printouts of code generation */
#define DEBUGGEN 1

int nextlabel;    /* Next available label number */
int stkframesize;   /* total stack frame size */


/* Generate code */
void gencode(TOKEN pcode, int varsize, int maxlabel) {  
  printf("print gencode\n");

  SYMBOL sym;
  sym = symtab[1];

  initOutputFiles();

  initSymbolTable();

  TOKEN name, code;
  name = pcode->operands;
  code = name->link->link;

  printf("Debug: ");
  printtok(code);

  fprintf(userProg, "begin\n");
  fprintf(privProg, "begin\n");
    
  genc(code, UNPRIV_SCOPE);

  fprintf(userProg, "end.");
  fprintf(privProg, "end.");

  fclose(userProg);
  fclose(privProg);
}

/* Write line to user program */
void writeToUser(char* str) {
  fprintf(userProg, "%s", str);
}

/* Write line to priv program */
void writeToPriv(char* str) {
  fprintf(privProg, "%s", str);
}

/* Write to a file */
void writeToFile(FILE* file, char* str) {
  fprintf(file, "%s", str);
}

/* Initialize the resulting split programs */
void initOutputFiles() {
  // User program
  userProg = fopen("user.pas", "w");
  if (!userProg) {
    perror("Failed to open user.pas");
    return;
  }

  writeToUser("{ Secure Pascal : Generated User Program }\n");
  writeToUser("program UserProgam(ouput);\n\n");

  // Priviledged program
  privProg = fopen("priv.pas", "w");
  if (!privProg) {
    perror("Failed to open priv.pas");
    return;
  }

  writeToPriv("{ Secure Pascal : Generated Privileged Program }\n");
  writeToPriv("program privProg(ouput);\n\n");
}

/* Initialize VAR blocks in output programs */
void initSymbolTable() {
  SYMBOL sym = symtab[1];
  
  writeToUser("var ");
  writeToPriv("var ");

  /* Todo put into array, then sort by type */

  while (sym) {
    switch (sym->kind) {
      case VARSYM: /* Var */
        if (sym->datatype->kind == BASICTYPE) {
          printf("FOUND a basic sym\n");
          writeVarEntry(userProg, sym);
        }
        break;
    }
    sym = sym->link;
  }

  writeToUser("\n\n");
  writeToPriv("\n\n");
}

/* Write var entry to a file */
void writeVarEntry(FILE* file, SYMBOL sym) {
  writeToUser(sym->namestring);
  writeToUser(" : ");
  writeToUser(sym->datatype->namestring);
  writeToUser("; ");
}

/* Traverse the AST */
void genc(TOKEN code, int scope) {  
  //fprintf(userProg, "%s", "{ in genc }\n");

  TOKEN tok, lhs, rhs;
  int reg, offs;
  SYMBOL sym;

  int next_scope = (code->scope ? PRIV_SCOPE : UNPRIV_SCOPE) || scope;

  FILE *outFile = next_scope ? privProg : userProg;

  if (DEBUGGEN) { 
    printf("genc\n");
	  dbugprinttok(code);
  }
  
  if (code->tokentype != OPERATOR) { 
    printf("Bad code token");
	  dbugprinttok(code);
	}

  if (DEBUGGEN) {
    printf("genc file scope: %d %d\n", scope, next_scope);
  }
  

  switch (code->whichval) { 
    /* Block */
    case PROGNOP:
	    tok = code->operands;
	  
      while (tok != NULL) {  
        genc(tok, next_scope);
        tok = tok->link;
      }
      break;

    /* Assignment operator */
	  case ASSIGNOP:           
      if (DEBUGGEN) {
        printf("ASSIGNOP: \n");
      }      

      lhs = code->operands;
      rhs = lhs->link;

      /* identifier and assignment */
      fprintf(outFile, "\t%s := ", lhs->stringval);

      // generate code for rhs
      gen_rhs(rhs, next_scope);            

      writeToFile(outFile, ";\n");

      break;

    case FUNCALLOP:
      if (DEBUGGEN) {
        printf("FUNCALLOP: \n");

        dbugbprinttok(code);
        if(code->operands) {
          dbugbprinttok(code->operands);
        }
        if(code->link) {
          dbugbprinttok(code->link);
        }
      } 
      
      /*     ***** fix this *****   */
      break;

    case GOTOOP:
      if (DEBUGGEN) {
        printf("GOTOOP: ");
      } 
      int label = code->operands->intval;

      fprintf(outFile, "goto  %d;\n", label);
      break;

    case LABELOP:
      if (DEBUGGEN) {
        printf("LABELOP: ");
      } 

      fprintf(outFile, "label %d:\n", code->operands->intval);
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

/* Generate Pascal code for the RHS of a statement from the parse tree */
/* TOKEN rhs is the rhs */
void gen_rhs(TOKEN rhs, int scope) {   
  int num, reg;
  int next_scope = (rhs->scope ? PRIV_SCOPE : UNPRIV_SCOPE) || scope;

  FILE *outFile = next_scope ? privProg : userProg;

  if (DEBUGGEN) {
    printf("gen_rhs file scope: %d %d\n", scope, next_scope);
  }
  
  if (DEBUGGEN) { 
    printf("gen rhs\n");
	  dbugprinttok(rhs);
  }
  
  switch (rhs->tokentype) { 
    case NUMBERTOK:

      switch (rhs->basicdt) {
        case INTEGER:
		      num = rhs->intval;
          fprintf(outFile, "%d", num);
          break;
	      
        case REAL:
          fprintf(outFile, "%f", rhs->realval);
          break;
	    }
	   break;
    
    case IDENTIFIERTOK:
      fprintf(outFile, "%s", rhs->stringval);
      break;

    case OPERATOR:
      genc(rhs, next_scope);
      break;
  }
}