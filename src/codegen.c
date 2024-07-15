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
    exit(1);
  }

  writeToUser("{ Secure Pascal : Generated User Program }\n");
  writeToUser("program UserProgam(ouput);\n\n");

  // Priviledged program
  privProg = fopen("priv.pas", "w");
  if (!privProg) {
    perror("Failed to open priv.pas");
    exit(1);
  }

  writeToPriv("{ Secure Pascal : Generated Privileged Program }\n");
  writeToPriv("program PrivProg(ouput);\n\n");
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
          if (sym->scope == UNPRIV_SCOPE) {
            writeVarEntry(userProg, sym);
            writeVarEntry(privProg, sym);
          } else {
            writeVarEntry(privProg, sym);
          }
          
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
  writeToFile(file, sym->namestring);
  writeToFile(file, " : ");
  writeToFile(file, sym->datatype->namestring);
  writeToFile(file, "; ");
}

/* Insert read logic */
void insertReadRPC(FILE* file, char* id) {
  writeToFile(file, "assign(inputPipe, inputName);\n");
  writeToFile(file, "reset(inputPipe);\n");
  fprintf(file, "readln(inputPipe, %s);\n", id);
  writeToFile(file, "close(inputPipe);\n");
}

/* Insert write logic */
void insertWriteRPC(FILE* file, char* str) {
  writeToFile(file, "assign(outputPipe, outputName);\n");
  writeToFile(file, "rewrite(outputPipe);\n");
  fprintf(file, "write(outputPipe, %s);\n", str);
  writeToFile(file, "close(outputPipe);\n");
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
    ferror("Bad code token");
	  dbugprinttok(code);
    exit(1);
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
      gen_assign(code, scope);
      break;

    /* Function call */
    case FUNCALLOP:
      gen_funcall(code, scope);
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

/* Generate funcall */
void gen_funcall(TOKEN code, int scope) {
  TOKEN tok, lhs, rhs;
  int reg, offs;
  SYMBOL sym;

  int next_scope = (code->scope ? PRIV_SCOPE : UNPRIV_SCOPE) || scope;

  FILE *outFile = next_scope ? privProg : userProg;

  if (DEBUGGEN) {
    printf("FUNCALLOP: \n");

    dbugbprinttok(code);
        
    printf("%s\n", code->operands->stringval);
    if(code->operands) {
      dbugbprinttok(code->operands);
    }
    if(code->operands->link) {
      dbugbprinttok(code->operands->link);
      printf(code->operands->link->stringval);
    }
  } 

  TOKEN func = code->operands;
  TOKEN args = func->link;

  char* id = code->operands->stringval;
      
  /* Only one arg for now */
  char* argId = "";
  if (args) {
    argId = args->stringval;
  }  

  /* Check scope of arg */
  if (args) {
    sym = searchst(argId);
    if (!sym) {
      ferror("Arg not found in symbol table\n");
      exit(1);
    }

    /* RPC logic to send arg value */
    if (scope == PRIV_SCOPE && sym->scope == UNPRIV_SCOPE) {
      /* priv: wait for value of id */
      fprintf(privProg, "{ Wait for value of %s from UserProg }\n", argId);
      insertReadRPC(privProg, argId);

      /* user: send value of id */
      fprintf(userProg, "{ Send value of %s to PrivProg }\n", argId);
      insertWriteRPC(userProg, argId);

      writeToFile(privProg, "\n");
    }
  }

  fprintf(outFile, "%s(%s);\n", id, argId);
}

/* Generate assign */
void gen_assign(TOKEN code, int scope) {
  TOKEN tok, lhs, rhs;
  int reg, offs;
  SYMBOL sym;

  int next_scope = (code->scope ? PRIV_SCOPE : UNPRIV_SCOPE) || scope;

  FILE *outFile = next_scope ? privProg : userProg;

  if (DEBUGGEN) {
    printf("ASSIGNOP: \n");
  }      

  lhs = code->operands;
  rhs = lhs->link;
  char* id = lhs->stringval;

  SYMBOL idsym = searchst(id);
  if (idsym) {
      printsymbol(idsym);
  } else {
    ferror("Unrecognized symbol\n");
    exit(1);
  }

  /* first insert RPC logic to access id, if unpriv id */
  // if (scope == PRIV_SCOPE && idsym->scope == UNPRIV_SCOPE) { 
  //   /* priv: wait for value of id */
  //   fprintf(privProg, "{ Wait for value of %s from UserProg }\n", id);
  //   insertReadRPC(privProg, id);

  //   /* user: send value of id */
  //   fprintf(userProg, "{ Send value of %s to PrivProg }\n", id);
  //   insertWriteRPC(userProg, id);

  //   writeToFile(privProg, "\n");
  // }

  /* identifier and assignment */
  fprintf(outFile, "%s := ", id);

  // generate code for rhs
  gen_rhs(rhs, next_scope);            

  writeToFile(outFile, ";\n\n");
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