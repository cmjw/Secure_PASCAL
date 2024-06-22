%{
/* Secure Pascal Lexer - Charlotte White 
*/

#include "lexer.h"
#include "token.h"

#define DEBUG 1

int make_token(int tokentype, int whichtoken);
int make_identifier();
int make_string();
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

{id}         {return(make_identifier());}

{string}     {return(make_string());}

{intnumber}  {return(make_int());}
{fnumber}    {return(make_float());}

%%

/* Make a token */
int make_token(int tokentype, int whichtoken) {
    yyval = (TOKEN) talloc();
    yyval->tokentype = tokentype;

    // reserved keyword
    if (tokentype == RESERVED) {
        yyval->whichval = whichtoken - RESERVED_BIAS;
    }

    return whichtoken;
}

/* Make an identifier */
int make_identifier() {
    yyval = (TOKEN) talloc();
    yyval->tokentype = IDENTIFIERTOK;

    /* max length of 15*/
    int n = yyleng;
    if (n > 15) { n = 15; }

    int ch;
    for (int i = 0; i < n; i++) {
        ch = yytext[i];
        yyval->stringval[i] = ch;
    }

    yyval->stringval[n] = '\0';

    return IDENTIFIER;
}

/* Make a string */
int make_string() {
    yyval = (TOKEN) talloc();
    yyval->tokentype = STRINGTOK;
    int n = yyleng;

    char str[n];
    int ch, s = 0;

    for (int i = 0; i < n; i++) {
        ch = yytext[i];
        if (i == 0 || i == (n-1)) {
            /* ignore quote marks */
        } else {
            str[s] = ch;
            s++;

            if (ch == '\'') {
                i++;
            }
        }
    }

    if (s > 15) { s = 15; } /* max length 15 */

    str[s] = '\0';
    strcpy(yyval->stringval, str);

    return STRING;
}

/* Make a integer */
int make_int() {
    yyval = (TOKEN) talloc();
    yyval->tokentype = NUMBERTOK;
    yyval->basicdt = INTEGER;

    int num;
    sscanf(yytext, "%d", &num);
    yyval->intval = num;

    return NUMBER;
}

/* Make a floating point number */
int make_float() {
    yyval = (TOKEN) talloc();
    yyval->tokentype = NUMBERTOK;
    yyval->basicdt = REAL;

    float num;
    sscanf(yytext, "%f", &num);
    yyval->realval = num;

    return NUMBER;
}

/* lex may need this. */
int yywrap() {  return(1);  }   