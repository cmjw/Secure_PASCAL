/* lex1.c         14 Feb 01; 31 May 12; 11 Jan 18       */

/* This file contains code stubs for the lexical analyzer.
   Rename this file to be lexanc.c and fill in the stubs.    */

/* Copyright (c) 2018 Gordon S. Novak Jr. and
   The University of Texas at Austin. */

/*
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include "token.h"
#include "lexan.h"

#include <stdbool.h>

// constants
static char *specials[] = {"+", "-", "*", "/", ":=", "=", "!=", "<", "<=",
                             ">=", ">", ".", ".", "&", "||", "!", "div",
                             "mod", "in"};

// debug
bool debugflag = true;

/* This file will work as given with an input file consisting only
   of integers separated by blanks:
   make lex1
   lex1
   12345 123    345  357
   */

/* Skip blanks and whitespace.  Expand this function to skip comments too. */
void skipblanks ()
  {
      int c;
      while ((c = peekchar()) != EOF
             && (c == ' ' || c == '\n' || c == '\t'))
          getchar();
    }

/* Get identifiers and reserved words */
TOKEN identifier (TOKEN tok)
  {
    if (debugflag) { printf("identifier"); }

    }

TOKEN getstring (TOKEN tok)
  {
    if (debugflag) { printf("getstring"); }

    //
    
    
    } 

TOKEN special (TOKEN tok)
  {
    if (debugflag) { printf("(debug) special\n"); }

    char str[15] = {'\0'};

    int c, charval;
    while ((c = peekchar()) != EOF && CHARCLASS[c] == SPECIAL) {
      c = getchar();

      if (debugflag) { printf("(debug)c is %c\n", c); }

      // handle comment
      if (c == '{') {
        // ignore until see }, move cursor to that point
        if (debugflag) { printf("(debug)comment\n"); }

        return tok;
      }

      char ch[] = {(char)c, '\0'};
      
      strcat(str, &ch);

      if (debugflag) { printf("(debug) ASCII: %d\n(debug)str: %s\n", c, str); }
    }

    if (debugflag) { printf("(debug)after while\n"); }

    int operator_num = lookupSpecial(str);

    if (debugflag) { printf("(debug)index: %d\n", operator_num); }

    tok->tokentype = OPERATOR;
    tok->whichval = operator_num;

    /*
    // change to diff bt operator and delimiter
    tok->tokentype = OPERATOR;
    tok->basicdt = STRINGTYPE;
    tok->whichval = PLUS - OPERATOR_BIAS;
    return (tok); */
    }

/* Get and convert unsigned numbers of all types. */
TOKEN number (TOKEN tok)
  { long num;
    int  c, charval;
    num = 0;
    while ( (c = peekchar()) != EOF
            && CHARCLASS[c] == NUMERIC)
      {   c = getchar();
          charval = (c - '0');
          num = num * 10 + charval;
        }
    tok->tokentype = NUMBERTOK;
    tok->basicdt = INTEGER;
    tok->intval = num;
    return (tok);
  }


/**
 * Helper functions
 */
int lookupSpecial(char * str) {
  for (int i=0; i<sizeof(specials); i++) {
    if (strcmp(specials[i], str) == 0) {
      return i + 1;
    }
  }
  return -1;
  
}