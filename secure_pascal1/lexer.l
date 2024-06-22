%{
/* Secure Pascal Lexer - Charlotte White 
*/

#include "lexer.h"
#include "token.h"

#define DEBUG 0

int make_token(int tokentype, int whichtoken);
int make_identifiertok();
int make_stringtok();
int make_integertok();
int make_floattok();

int yywrap();

/* lexer result type */
TOKEN yylval;

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

"{"       { while (input() != '}'); }

"(*"      { jum:
            while (input() != '*');
            int c = input();
            if (c != ')'){
              unput(c);
              goto jum;
            }
          }

"+"       {return(make_token(OPERATOR, PLUS));} /* Operators */
"-"       {return(make_token(OPERATOR, MINUS));}
"*"       {return(make_token(OPERATOR, TIMES));}
"/"       {return(make_token(OPERATOR, DIVIDE));}
":="      {return(make_token(OPERATOR, ASSIGN));}
"="       {return(make_token(OPERATOR, EQ));}
"<>"      {return(make_token(OPERATOR, NE));}
"<"       {return(make_token(OPERATOR, LT));}
"<="      {return(make_token(OPERATOR, LE));}
">="      {return(make_token(OPERATOR, GE));}
">"       {return(make_token(OPERATOR, GT));}
"^"       {return(make_token(OPERATOR, POINT));}
"."       {return(make_token(OPERATOR, DOT));}
and       {return(make_token(OPERATOR, AND));}
or        {return(make_token(OPERATOR, OR));}
not       {return(make_token(OPERATOR, NOT));}
div       {return(make_token(OPERATOR, DIV));}
mod       {return(make_token(OPERATOR, MOD));}
in        {return(make_token(OPERATOR, IN));}
"::"      {return(make_token(OPERATOR, DOUBLECOLON));}


","       {return(make_token(DELIMITER, COMMA));} /* Delimiters */
";"       {return(make_token(DELIMITER, SEMICOLON));}
":"       {return(make_token(DELIMITER, COLON));}
"("       {return(make_token(DELIMITER, LPAREN));}
")"       {return(make_token(DELIMITER, RPAREN));}
"["       {return(make_token(DELIMITER, LBRACKET));}
"]"       {return(make_token(DELIMITER, RBRACKET));}
".."      {return(make_token(DELIMITER, DOTDOT));}  


array        {return(make_token(RESERVED, ARRAY));} /* Reserved Words */
begin        {return(make_token(RESERVED, BEGINBEGIN));}
case         {return(make_token(RESERVED, CASE));}
const        {return(make_token(RESERVED, CONST));}
do           {return(make_token(RESERVED, DO));}
downto       {return(make_token(RESERVED, DOWNTO));}
else         {return(make_token(RESERVED, ELSE));}
end          {return(make_token(RESERVED, END));}
file         {return(make_token(RESERVED, FILEFILE));}
for          {return(make_token(RESERVED, FOR));}
function     {return(make_token(RESERVED, FUNCTION));}
goto         {return(make_token(RESERVED, GOTO));}
if           {return(make_token(RESERVED, IF));}
label        {return(make_token(RESERVED, LABEL));}
nil          {return(make_token(RESERVED, NIL));}
of           {return(make_token(RESERVED, OF));}
packed       {return(make_token(RESERVED, PACKED));}
procedure    {return(make_token(RESERVED, PROCEDURE));}
program      {return(make_token(RESERVED, PROGRAM));}
record       {return(make_token(RESERVED, RECORD));}
repeat       {return(make_token(RESERVED, REPEAT));}
set          {return(make_token(RESERVED, SET));}
then         {return(make_token(RESERVED, THEN));}
to           {return(make_token(RESERVED, TO));}
type         {return(make_token(RESERVED, TYPE));}
until        {return(make_token(RESERVED, UNTIL));}
var          {return(make_token(RESERVED, VAR));}
while        {return(make_token(RESERVED, WHILE));}
with         {return(make_token(RESERVED, WITH));}

{id}         {return(make_identifiertok());}

{string}     {return(make_stringtok());}

{intnumber}  {return(make_integertok());}
{fnumber}    {return(make_floattok());}

%%

/* Make simple tokens. */
int make_token(int type, int which) {
    yylval = (TOKEN) talloc();
    yylval->tokentype = type;

    if (type == RESERVED)
        yylval->whichval = which - RESERVED_BIAS;
    else if (type == OPERATOR)
        yylval->whichval = which - OPERATOR_BIAS;
    else if (type == DELIMITER)
        yylval->whichval = which - DELIMITER_BIAS;
    else yylval->whichval = which;
   
    return which;
}

int make_identifiertok() { 
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

int make_stringtok() { 
    yylval = (TOKEN) talloc(); 
    yylval->tokentype = STRINGTOK;
    int len = yyleng;            
    char str[len];

    int ch, s = 0;
    for (int i = 0; i < len ; i++) { 
        ch = yytext[i];       
        if (i == 0 || i == (len - 1)) {
            /* ignore the first quote mark */
        } else {
            str[s] = ch;
            if (ch == '\'') { i++; }
            s++;
        } 
    }

    if (s > 15) { s = 15; }

    str[s] = '\0';
    strcpy(yylval->stringval, str);

    return STRING;
}

int make_integertok() {  
   int num;
   yylval = (TOKEN) talloc();   /* Make new token, set yylval to point to it */

   yylval->tokentype = NUMBERTOK;
   yylval->basicdt = INTEGER;

   if (DEBUG) {printf("num %10s   n = %4d\n",yytext,yyleng);}

   sscanf(yytext, "%d", &num);
   yylval->intval = num;

   return(NUMBER);
}

int make_floattok() {  /* Note -- you may use sscanf for this assignment. */
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