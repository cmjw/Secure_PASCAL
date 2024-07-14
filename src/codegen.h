/* codegen.h     Gordon S. Novak Jr.    */
/* 15 Aug 13 */
#include <stdio.h>
#include <ctype.h>
#include <string.h>


FILE *userProg;
FILE *privProg;


/* */
void initOutputFiles();

void writeToUser(char* str);


/* Generate code for the RHS of an expression */
void gen_rhs(TOKEN code, int scope);

/* Generate code */
void gencode(TOKEN pcode, int varsize, int maxlabel);

/* Generate arithmetic expression, return a register number */
char* genarith(TOKEN code);

/* Generate code for a statement */
void genc(TOKEN code, int scope);




/* test if there is a function call within code: 1 if true, else 0 */
int funcallin(TOKEN code);

/* find the op number that is equivalent to named function, if any */
int findfunop(char str[]);

/* Generate code for a function call */
int genfun(TOKEN code);

/* find the correct MOV op depending on type of code */
int moveop(TOKEN code);

/* Generate code for array references and pointers */
/* In Pascal, a (^ ...) can only occur as first argument of an aref. */
/* If storereg < 0, generates a load and returns register number;
   else, generates a store from storereg. */
int genaref(TOKEN code, int storereg);