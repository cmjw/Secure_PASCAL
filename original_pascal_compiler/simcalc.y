%{     /* simcalc.y  -- Simple Desk Calculator           25 Feb 91    */
       /* Aho, Sethi, and Ullman, Compilers, Fig. 4.56 */
       /* To use:    yacc simcalc.y
                     cc y.tab.c
                     ./a.out
                     3+4*5        single-character numbers, +, *, ()
                     ^D           must have EOF between entries
                     3*7+5*6
                     ^D
                     (3+4)*(5+6)
                     ^C           to stop.       */
#include <ctype.h>
#include <stdio.h>
%}

%token DIGIT

%%
line   :  expr '\n'             { printf("%d\n", $1); }
       ;
expr   :  expr '+' term         { $$ = $1 + $3; }
       |  term
       ;
term   :  term '*' factor       { $$ = $1 * $3; }
       |  factor
       ;
factor :  '(' expr ')'          { $$ = $2; }
       |  DIGIT
       ;
%%
yylex() {
    int c;
    c = getchar();
    if (isdigit(c)) {
       yylval = c - '0' ;
       return DIGIT;
    }
    return c;
  }

yyerror(s)
  char * s;
  { 
  fputs(s,stderr), putc('\n',stderr);
  }

main()          /* Call yylex repeatedly to test */
  { int res;
    while (1)
      { res = yyparse();
        /*  printf("yyparse result = %8d\n", res);  */
      }
    }
