/* Driver lexer program */

#include <stdio.h>
#include <ctype.h>
// keep include order
#include "token.h"
#include "lexer.h"


TOKEN yylval;

int main() {
    int result, done = 0;

    printf("Begin lexer input (CTRL+C / CTRL+D to end)\n");

    while (!done) {
        result = yylex();

        if (result != 0) {
            printf("yylex() = %4d    ", result);
            printtoken(yylval);
        } else {
            done = 1;
        }
    }
    return 0;
}