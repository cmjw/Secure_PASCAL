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
void genc(TOKEN node) {

}