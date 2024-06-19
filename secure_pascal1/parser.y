%{
    
/* Charlotte White */
/* Secure Pascal Parser */

#include <stdio.h>
#include <stdlib.h>
#include "token.h"
#include "ast.h"

int yylex();

%}


%token T_IF T_ELSE

/* Tokens */

/* Token Types */

/* Operators */

/* Delimiters */

/* Program Control */


%%

program : if | else;


if : T_IF {
    printf("if\n");
    exit(0);
};

else : T_ELSE {
    printf("else\n");
    exit(0);
}

%%