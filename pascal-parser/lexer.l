%{   
/* Copyright (c) 2013 Gordon S. Novak Jr. and The University of Texas at Austin
   */

/* This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, see <http://www.gnu.org/licenses/>. */


#include <ctype.h>
#include "token.h"
#include "lexer.h"

#define DEBUG 0

int maketoken(int type, int which);
int install_id();
int install_fnum();
int yywrap();

/* If the lex yytext buffer turns out to be too small to hold comments,
   add the following lines:
 #undef YYLMAX
 #define YYLMAX 256
 */

TOKEN yylval;     /* This is the type of the lexical analyzer result */

%}

/* regular definitions */

delim     [ \t\n]
ws        {delim}+
letter    [A-Za-z]
digit     [0-9]
id        {letter}({letter}|{digit})*
intnumber {digit}+
fnumber   {digit}+(\.{digit}+)?([eE][+\-]?{digit}+)?
string    '(.*?)'

%%

{ws}      { /* no action and no return */ }

"{"       { while (input() != '}'); }

"(*"      { jum:
            while (input() != '*');
            int c = input();
            if (c != ')'){
              unput(c);
              goto jum;
            }
          }

"+"       {return(maketoken(OPERATOR, PLUS));} /* Operators */
"-"       {return(maketoken(OPERATOR, MINUS));}
"*"       {return(maketoken(OPERATOR, TIMES));}
"/"       {return(maketoken(OPERATOR, DIVIDE));}
":="      {return(maketoken(OPERATOR, ASSIGN));}
"="       {return(maketoken(OPERATOR, EQ));}
"<>"      {return(maketoken(OPERATOR, NE));}
"<"       {return(maketoken(OPERATOR, LT));}
"<="      {return(maketoken(OPERATOR, LE));}
">="      {return(maketoken(OPERATOR, GE));}
">"       {return(maketoken(OPERATOR, GT));}
"^"       {return(maketoken(OPERATOR, POINT));}
"."       {return(maketoken(OPERATOR, DOT));}
and       {return(maketoken(OPERATOR, AND));}
or        {return(maketoken(OPERATOR, OR));}
not       {return(maketoken(OPERATOR, NOT));}
div       {return(maketoken(OPERATOR, DIV));}
mod       {return(maketoken(OPERATOR, MOD));}
in        {return(maketoken(OPERATOR, IN));}


","       {return(maketoken(DELIMITER, COMMA));} /* Delimiters */
";"       {return(maketoken(DELIMITER, SEMICOLON));}
":"       {return(maketoken(DELIMITER, COLON));}
"("       {return(maketoken(DELIMITER, LPAREN));}
")"       {return(maketoken(DELIMITER, RPAREN));}
"["       {return(maketoken(DELIMITER, LBRACKET));}
"]"       {return(maketoken(DELIMITER, RBRACKET));}
".."      {return(maketoken(DELIMITER, DOTDOT));}  


array        {return(maketoken(RESERVED, ARRAY));} /* Reserved Words */
begin        {return(maketoken(RESERVED, BEGINBEGIN));}
case         {return(maketoken(RESERVED, CASE));}
const        {return(maketoken(RESERVED, CONST));}
do           {return(maketoken(RESERVED, DO));}
downto       {return(maketoken(RESERVED, DOWNTO));}
else         {return(maketoken(RESERVED, ELSE));}
end          {return(maketoken(RESERVED, END));}
file         {return(maketoken(RESERVED, FILEFILE));}
for          {return(maketoken(RESERVED, FOR));}
function     {return(maketoken(RESERVED, FUNCTION));}
goto         {return(maketoken(RESERVED, GOTO));}
if           {return(maketoken(RESERVED, IF));}
label        {return(maketoken(RESERVED, LABEL));}
nil          {return(maketoken(RESERVED, NIL));}
of           {return(maketoken(RESERVED, OF));}
packed       {return(maketoken(RESERVED, PACKED));}
procedure    {return(maketoken(RESERVED, PROCEDURE));}
program      {return(maketoken(RESERVED, PROGRAM));}
record       {return(maketoken(RESERVED, RECORD));}
repeat       {return(maketoken(RESERVED, REPEAT));}
set          {return(maketoken(RESERVED, SET));}
then         {return(maketoken(RESERVED, THEN));}
to           {return(maketoken(RESERVED, TO));}
type         {return(maketoken(RESERVED, TYPE));}
until        {return(maketoken(RESERVED, UNTIL));}
var          {return(maketoken(RESERVED, VAR));}
while        {return(maketoken(RESERVED, WHILE));}
with         {return(maketoken(RESERVED, WITH));}

{id}         {return(install_id());}

{string}     {return(install_string());}

{intnumber}  {return(install_int());}
{fnumber}    {return(install_fnum());}




%%

/* Note that lex always returns two values:
   1. "What is it?": a small integer such as NUMBER that indicates the
      kind of item that was found; this is the return() value.
   2. The value itself.  This is yylval, which points to a TOKEN.   */


/* Make simple tokens. */
int maketoken(int type, int which) {
   yylval = (TOKEN) talloc();  /* Make new token, set yylval to point to it */
   yylval->tokentype = type;

   if (type == RESERVED)
      yylval->whichval = which - RESERVED_BIAS;
   else if (type == OPERATOR)
      yylval->whichval = which - OPERATOR_BIAS;
   else if (type == DELIMITER)
      yylval->whichval = which - DELIMITER_BIAS;
   else yylval->whichval = which;
   
   return(which);
}

int install_id() { 
   int i, c, n;
   yylval = (TOKEN) talloc();  /* Make new token, set yylval to point to it */
   yylval->tokentype = IDENTIFIERTOK;
   n = yyleng;            /* number of characters */
   
   if (n > 15) n = 15;

   for (i = 0; i < n ; i++) { 
      c = yytext[i];
          /* if (islower(c)) c = toupper(c); */ /* to raise to upper case */
     yylval->stringval[i] = c;
   }

   yylval->stringval[n] = '\0';
   
   if (DEBUG) {printf("id  %10s   n = %4d\n", yytext, n);}

   return(IDENTIFIER);
 }

int install_string() { 
   int i, c, n, s = 0;
   yylval = (TOKEN) talloc();  /* Make new token, set yylval to point to it */
   yylval->tokentype = STRINGTOK;
   n = yyleng;            /* number of characters */
   char mystring[n];

   for (i = 0; i < n ; i++) { 
      c = yytext[i];       
      if (i == 0 || i == (n - 1)) {
         /* to ignore the first quote mark */
      } else {
        mystring[s] = c;
        s++;
        if (c == '\'') i++;
      } 
  }

  if (s > 15) s = 15;

  mystring[s] = '\0';
  strcpy(yylval->stringval, mystring);

  return(STRING);
}

int install_int() {  
   int num;
   yylval = (TOKEN) talloc();   /* Make new token, set yylval to point to it */

   yylval->tokentype = NUMBERTOK;
   yylval->basicdt = INTEGER;

   if (DEBUG) {printf("num %10s   n = %4d\n",yytext,yyleng);}
   sscanf(yytext, "%d", &num);
   yylval->intval = num;

   return(NUMBER);
}

int install_fnum() {  /* Note -- you may use sscanf for this assignment. */
   float fnum;
   yylval = (TOKEN) talloc();   /* Make new token, set yylval to point to it */
   yylval->tokentype = NUMBERTOK;
   yylval->basicdt = REAL;

   if (DEBUG) {printf("num %10s   n = %4d\n",yytext,yyleng);} 
   sscanf(yytext, "%f", &fnum);
   yylval->realval = fnum;

   return(NUMBER);
}


/* lex may need this. */
int yywrap() {  return(1);  }       