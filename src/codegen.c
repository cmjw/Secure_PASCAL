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

void gencode(TOKEN pcode, int varsize, int maxlabel) {  
    printf("print gencode\n");
    // TOKEN name, code;
    //  name = pcode->operands;
    //  code = name->link->link;
    //  nextlabel = maxlabel + 1;
    //  stkframesize = asmentry(name->stringval,varsize);
    //  genc(code);
    //  asmexit(name->stringval);

    TOKEN name, code;
    name = pcode->operands;
    code = name->link->link;
    
    genc(code);
}


/* Generate code from a statement */
void genc(TOKEN code) {
    TOKEN tok, lhs, rhs;
    SYMBOL sym;

    if (DEBUGGEN) {
      printf("genc\n");
      printtok(code);
      printf("\n");
    }
}