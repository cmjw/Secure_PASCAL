%{  /* lexasu.l -- sample lex specification  20 Jul 99; 19 Jul 01; 20 Jul 21 */
    /* Aho, Sethi, Ullman book example, adapted by G. Novak  */

#define LT 8        /* Example of use:                                       */
#define LE 9        /* lex ~cs375/lexasu.l       Use lex to compile lexasu.l */
#define EQ 6        /* cc lex.yy.c -ll             Compile lex output with C */
#define NE 7        /* a.out                       Execute C output          */
#define GT 11       /* if switch then 3.14 else 4  Test data                 */
#define GE 10       /* ^D                          Control-D for EOF to stop */
#define ID      3
#define NUMBER  5
#define OP      1   /* to avoid returning 0 */
#define IF     13
#define THEN   23
#define ELSE    7

int yylval;
int install_id();
int install_num();
int yywrap();
int main(void);

%}
        /* regular definitions */

delim   [ \t\n]
ws      {delim}+
letter  [A-Za-z]
digit   [0-9]
id      {letter}({letter}|{digit})*
number  {digit}+(\.{digit}+)?(E[+\-]?{digit}+)?

%%

{ws}     { /* no action and no return */ }
if       { return(IF); }
then     { return(THEN); }
else     { return(ELSE); }
{id}     { yylval = install_id(); return(ID); }
{number} { yylval = install_num(); return(NUMBER); }
"<"      { yylval = LT; return(OP); }
"<="     { yylval = LE; return(OP); }
"="      { yylval = EQ; return(OP); }
"<>"     { yylval = NE; return(OP); }
">"      { yylval = GT; return(OP); }
">="     { yylval = GE; return(OP); }

%%       /* C functions */

int install_id() {  printf("id  %10s   n = %4d\n",yytext,yyleng);  }

int install_num() {  printf("num %10s   n = %4d\n",yytext,yyleng);  }

int yywrap() {  return(1);  }   /* lex seems to need this. */
