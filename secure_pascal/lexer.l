/* Charlotte White */
/* Secure Pascal Lexer */

%{


#define DEBUG 1

%}

/* Regular Definitions */

delim      [ \t\n]
whitespace {delim}+
letter     [A-Za-z]
digit      [0-9]
id         {letter}({letter}|{digit})*
intnumber  {digit}+
fnumber    {digit}+(\.{digit}+)?([eE][+\-]?{digit}+)?
string     '(.*?)'


%%

{whitespace} {
    /* do nothing */
}

{letter} {
    if (DEBUG) {
        printf("(lexer) letter\n");
    }
}

{digit} {
    if (DEBUG) {
        printf("(lexer) digit\n");
    }
}

{id} {
    if (DEBUG) {
        printf("(lexer) id\n");
    }
}

{string} {
    if (DEBUG) {
        printf("(lexer) string\n");
    }
}


{intnumber} {
    if (DEBUG) {
        printf("(lexer) intnumber\n");
    }
}

{fnumber} {
    if (DEBUG) {
        printf("(lexer) fnumber\n");
    }
}



%%



int yywrap() {  return(1);  }       /* lex may need this. */