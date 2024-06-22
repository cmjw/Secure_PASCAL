/* Driver lexer program */

#include <stdio.h>
#include <ctype.h>
#include "lexer.h"
#include "token.h"

TOKEN yylval;

int main() {
    int result, done = 0;

    printf("Begin lexer\n");

    while (!done) {
        result = yylex();

        if (result != 0) {
            printf("yylex() = %4d    \n", result);
            printtoken(yylval);
        } else {
            done = 1;
        }
    }
    return 0;
}