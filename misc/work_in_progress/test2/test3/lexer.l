%{
#include <stdio.h>
#include "parser.tab.h" 
%}

%option noyywrap

%%

[ \t\n]            ; // skip whitespace
[0-9]+             { yylval.ival = atoi(yytext); return T_INT; }
"+"                { return T_PLUS; }
"-"                { return T_MINUS; }
";"                { return T_END; }

.                  { printf("Unexpected character: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}
