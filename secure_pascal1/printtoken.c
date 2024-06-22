/* Routines to print tokens for debugging */

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include "token.h"


static char* opprnt[] = {" ", "+", "-", "*", "/", ":=", "=", "<>", "<", "<=",
  ">=", ">",  "^", ".", "and", "or", "not", "div",
  "mod", "in", "if", "goto", "progn", "label",
  "funcall", "aref", "program", "float"};

static char *delprnt[] = { "  ", " ,", " ;", " :", " (", " )", " [", " ]", ".."};

static char *resprnt[] = { " ", "array", "begin", "case", "const", "do",
  "downto", "else", "end", "file", "for",
	"function", "goto", "if", "label", "nil",
  "of", "packed", "procedure", "program", "record",
  "repeat", "set", "then", "to", "type",
	"until", "var", "while", "with" };

static char *tokentypes[] = {"operator", "delimiter", "reserved", "identifier", "string", 
  "number"};



void printtoken(TOKEN tok) {
  switch (tok->tokentype) {
    case OPERATOR:
      printf ("tokentype: %2d  which: %4d   %10s\n",
	      tok->tokentype, tok->whichval,
        opprnt[tok->whichval] );
      break;

    case DELIMITER:
      printf ("tokentype: %2d  which: %4d   %10s\n",
	      tok->tokentype, tok->whichval,
        delprnt[tok->whichval] );
      break;

    case RESERVED:
      printf ("tokentype: %2d  which: %4d   %10s\n",
	      tok->tokentype, tok->whichval,
        resprnt[tok->whichval] );
      break;

    case IDENTIFIERTOK: case STRINGTOK:
      printf ("tokentype: %2d  value:  %16s\n",
	      tok->tokentype, tok->stringval);
      break;
    
    case NUMBERTOK:
      switch (tok->basicdt) {
        case INTEGER:
          printf ("tokentype: %2d  type:  %4d %12d\n",
	          tok->tokentype, tok->basicdt, tok->intval);
          break;
	      case REAL:
          printf ("tokentype: %2d  type:  %4d %12e\n",
	          tok->tokentype, tok->basicdt, tok->realval);
          break;
	    }
	}
}
