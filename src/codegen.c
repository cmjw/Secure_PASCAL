#include "token.h"
#include "symtab.h"
#include "lexer.h"
#include "genasm.h"
#include "pprint.h"
#include "codegen.h"
#include "stdbool.h"

void genc(TOKEN code, int scope);

char* ops[]  = {" ", "+", "-", "*", "/", ":=", "=", "<>", "<", "<=",
                      ">=", ">",  "^", ".", "and", "or", "not", "div", "mod",
                      "in", "if", "goto", "progn", "label", "funcall",
                      "aref", "program", "float", "fix"};

/* Set DEBUGGEN to 1 for debug printouts of code generation */
#define DEBUGGEN 1

int nextlabel;    /* Next available label number */
int stkframesize;   /* total stack frame size */

FILE *runProg;


/* Generate code for main function */
void gencode(TOKEN pcode, int varsize, int maxlabel) {  
  printf("print gencode\n");

  SYMBOL sym;
  sym = symtab[1];

  initOutputFiles();

  insertVarBlock();

  insertConstBlock();

  TOKEN name, code;
  name = pcode->operands;
  code = name->link->link;

  printf("Debug: ");
  printtok(code);

  /* Begin main and RPC logic for user */
  writeToUser("begin\n");

  writeToUser("{ initialize vars for interprocess communication }\n");
  writeToUser("inputName := 'pipe_to_priv';\n");
  writeToUser("outputName := 'pipe_to_user';\n\n");

  /* Begin main and RPC logic for priv */
  writeToPriv("begin\n");

  writeToPriv("{ initialize vars for interprocess communication }\n");
  writeToPriv("inputName := 'pipe_to_user';\n");
  writeToPriv("outputName := 'pipe_to_priv';\n\n");
    
  genc(code, UNPRIV_SCOPE);

  writeToPriv("writeln('priv: done');\n");
  writeToUser("writeln('user: done');\n");

  fprintf(userProg, "end.");
  fprintf(privProg, "end.");

  writeFunctionDefinitions();

  fclose(userProg);
  fclose(privProg);

  createRunScript();
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

/* Create the script to run the final pas files */
void createRunScript() {
  runProg = fopen("run_me.sh", "w");
  if (!runProg) {
    perror("Failed to open run_me.sh\n");
    exit(1);
  }
  writeToFile(runProg, "#!/bin/bash\n\n");

  writeToFile(runProg, "rm pipe_to_priv\n");
  writeToFile(runProg, "rm pipe_to_user\n");

  writeToFile(runProg, "rm priv\n");
  writeToFile(runProg, "rm user\n");

  writeToFile(runProg, "echo \"Creating Named Pipes ...\"\n");
  writeToFile(runProg, "mkfifo \"pipe_to_priv\"\n");
  writeToFile(runProg, "mkfifo \"pipe_to_user\"\n\n");

  writeToFile(runProg, "echo \"Compiling Final Priv/User Progs ...\"\n");

  writeToFile(runProg, "fpc priv.pas\n");
  writeToFile(runProg, "fpc user.pas\n");

  writeToFile(runProg, "echo \"Running Priv Program ...\"\n");

  writeToFile(runProg, "./priv &\n");
  writeToFile(runProg, "./user &\n");

  writeToFile(runProg, "echo \"Running User Program ...\"\n");

  writeToFile(runProg, "echo \"Removing Named Pipes ...\"\n");
  writeToFile(runProg, "rm pipe_to_priv\n");
  writeToFile(runProg, "rm pipe_to_user\n");
}

/* Initialize VAR blocks in output programs */
void insertVarBlock() {
  SYMBOL sym = symtab[1];
  
  writeToUser("var ");
  writeToPriv("var ");

  /* Todo put into array, then sort by type */

  while (sym) {
    switch (sym->kind) {
      case VARSYM: /* Var */
        if (sym->datatype->kind == BASICTYPE) {
          //printf("FOUND a basic sym\n");
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

  // VAR block pipe declarations
  writeToUser("outputPipe, inputPipe: Text; ");
  writeToUser("outputName, inputName: string; ");

  writeToPriv("outputPipe, inputPipe: Text; ");
  writeToPriv("outputName, inputName: string; ");

  writeToUser("\n\n");
  writeToPriv("\n\n");
}

/* Insert cblock into user and priv programs, if applicable */
void insertConstBlock() {
  SYMBOL sym = symtab[1];
  
  int count = 0;

  while (sym) {
    if (sym->kind == CONSTSYM) {
      count++;
      if (count == 1) {
        writeToUser("const\n");
        writeToPriv("const\n");
      }
      if (sym->scope == PRIV_SCOPE) {
        writeConstEntry(privProg, sym);
        writeToPriv("{ privileged const }\n");
      } else {
        /* write const to both */
        writeConstEntry(privProg, sym);
        writeToPriv("\n");
        writeConstEntry(userProg, sym);
        writeToUser("\n");
      }
    }
    sym = sym->link;
  }

  if (count > 0) {
    writeToUser("\n\n");
    writeToPriv("\n\n");
  }
}

/* Insert function definitions */
void writeFunctionDefinitions() {
  SYMBOL sym = symtab[1];

  writeToUser("{Func test}\n");

  while (sym) {
    if (sym->kind == FUNCTIONSYM) {
      if (sym->scope == PRIV_SCOPE) {
        writeConstEntry(privProg, sym);
        writeToPriv("{ privileged const }\n");
      } else {
        /* write const to both */
        writeConstEntry(privProg, sym);
        writeToPriv("\n");
        writeConstEntry(userProg, sym);
        writeToUser("\n");
      }
    }
    sym = sym->link;
  }
}

/* Write var entry to a file */
void writeVarEntry(FILE* file, SYMBOL sym) {
  writeToFile(file, sym->namestring);
  writeToFile(file, " : ");
  writeToFile(file, sym->datatype->namestring);
  writeToFile(file, "; ");
}

/* Write const entry to a file */
void writeConstEntry(FILE* file, SYMBOL sym) {
  writeToFile(file, sym->namestring);
  writeToFile(file, " = ");
  switch (sym->basicdt) {
    case INTEGER:
      fprintf(file, "%d", sym->constval.intnum);
      break;
    case REAL:
      fprintf(file, "%f", sym->constval.realnum);
      break;
    case STRINGTYPE:
      writeToFile(file, sym->constval.stringconst);
      break;
  }
  writeToFile(file, "; ");
}

/* Insert read logic */
void insertReadRPC(FILE* file, char* id, bool str) {
  writeToFile(file, "assign(inputPipe, inputName);\n");
  writeToFile(file, "reset(inputPipe);\n");
  /* Print as string */
  if (str) {
    fprintf(file, "readln(inputPipe, '%s');\n", id);
  } else {
    fprintf(file, "readln(inputPipe, %s);\n", id);
  }
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
      gen_ifop(code, scope);
      break;

    // case PLUSOP:
    //   if (DEBUGGEN) {
    //     printf("PLUSOP: ");
    //   }
    //   break;
  }  

  if (code->whichval >= PLUSOP && code->whichval <= DIVIDEOP) {
    gen_arith_op(code, scope);
  }
}

/* Generate code for if/then (else) */
void gen_ifop(TOKEN code, int scope) {
  int next_scope = (code->scope ? PRIV_SCOPE : UNPRIV_SCOPE) || scope;

  FILE *outFile = next_scope ? privProg : userProg;

  TOKEN expr = code->operands;

  TOKEN thenpart = expr->link;

  writeToFile(outFile, "if ");
  /* condition */
  gen_expression(expr, scope);
  writeToFile(outFile, " then\n");

  /* statement(s) */
  genc(thenpart, scope);

  writeToFile(outFile, "\n");
}

/* Write condition */
void gen_expression(TOKEN tok, int scope) {
  printf("gen expr\n");
  //printtok(tok);
  if (tok->tokentype == OPERATOR) {
    printf("operatortok\n");
  }

  gen_arith_op(tok, scope);
}

/* Generate code for arirthmetic operators */
void gen_arith_op(TOKEN code, int scope) {
  TOKEN tok, lhs, rhs;
  SYMBOL sym;

  int next_scope = (code->scope ? PRIV_SCOPE : UNPRIV_SCOPE) || scope;

  FILE *outFile = next_scope ? privProg : userProg;

  lhs = code->operands;
  rhs = lhs->link;
  //char* id = lhs->stringval;

  
  // get string value of rhs and lhs
  // get array to print operator
  printVal(outFile, lhs);
  writeToFile(outFile, " ");
  writeToFile(outFile, ops[code->whichval]);
  writeToFile(outFile, " ");
  printVal(outFile, rhs);
  //writeToFile(outFile, ";\n");
}

/* Return string value of a token */
void printVal(FILE* file, TOKEN tok) {
  if (tok->tokentype == OPERATOR) {
    printf("parsing error\n");
    //gencode(tok,0,0);
    return;
  }

  char* id;
  
  // some issue seg faulting here
  
  switch (tok->tokentype) {
    case STRINGTOK:
      writeToFile(file, tok->stringval);
      break;


    case IDENTIFIERTOK:
      id = tok->stringval;

      SYMBOL idsym = searchst(id);
      if (idsym) {
        writeToFile(file, tok->stringval);
      } else {
        ferror("Unrecognized symbol\n");
        exit(1);
      }

      break;

    case NUMBERTOK:
      switch (tok->basicdt) {
        case INTEGER: 
          fprintf(file, "%d", tok->intval); break;
        case REAL:
          fprintf(file, "%f", tok->realval); break;
          break;
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
    bool str = false; 

    sym = searchst(argId);
    if (!sym) {
      printf("Arg not found in symbol table\n");
      printf("Assuming string: %s", argId);

      // TODO:  I broke strings in named pipes at some point.

      //exit(1);
    }

    /* RPC logic to send arg value */
    else if (scope == PRIV_SCOPE && sym->scope == UNPRIV_SCOPE) {
      /* priv: wait for value of id */
      fprintf(privProg, "{ Wait for value of %s from UserProg }\n", argId);
      insertReadRPC(privProg, argId, str);

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