%{
/* Secure Pascal Lexer - Charlotte White 
*/

#include "lexer.h"

#define DEBUG 1

int make_token();
int make_identifier();
int make_int();
int make_float();

int yywrap();

/* lexer result type */
TOKEN yyval;

%}

/* regular definitions */

delim       [ \t\n]
whitespace  {delim}+
letter      [A-Za-z]
digit       [0-9]
id          {letter}({letter}|{digit})*
intnumber   {digit}+
fnumber     {digit}+(\.{digit}+)?([eE][+\-]?{digit}+)?
string      '(.*?)'

%%

{whitespace} { /* do nothing */ }



%%