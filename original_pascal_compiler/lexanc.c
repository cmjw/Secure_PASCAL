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
static char *operators[] = {"+", "-", "*", "/", ":=", "=", "!=", "<", "<=",
                             ">=", ">", "^", ".", "&", "||", "!", "div",
                             "mod", "in"};

static char *delimiters[] = {",", ";", ":", "(", ")", "[", "]", ".."};

static char *reserved[] = {"array", "begin", "case", "const", "do", "downto", 
  "else", "end", "file", "for", "function", "goto", "if", "label", "nil" ,"of", 
  "packed", "procedure", "program", "record", "repeat", "set", "then", "to", 
  "type", "until", "var", "while", "with"};

static double powers[] = {1e0, 1e1, 1e2, 1e3, 1e4, 1e5, 1e6, 1e7, 1e8, 1e9, 1e10, 1e11,
  1e12, 1e13, 1e14, 1e15, 1e16, 1e17, 1e18, 1e19, 1e20, 1e21, 1e22, 1e23, 1e24, 1e25,
  1e26, 1e27, 1e28, 1e29, 1e30, 1e31, 1e32, 1e33, 1e34, 1e35, 1e36, 1e37, 1e38, 1e39};

// debug
bool debugflag = false;

/* This file will work as given with an input file consisting only
   of integers separated by blanks:
   make lex1
   lex1
   12345 123    345  357
   */

/* Skip blanks and whitespace.  Expand this function to skip comments too. */
void skipblanks () {
  int c;
  bool comment = false;

    while ((c = peekchar()) != EOF
      && (c == ' ' || c == '\n' || c == '\t' || c == '{' || comment || c == '}'
       || (c == '(' && peek2char() == '*') )) {

        getchar();

        if (c == '{') { 
          comment = true; 
          if (debugflag) {printf("(debug) comment on\n"); } 
        }
        if (c == '}') { 
          comment = false; 
          if (debugflag) {printf("(debug) comment off\n"); } 
        }

        if (c == '(' && peekchar() == '*') {
          if (debugflag) {printf("(debug) comment on\n"); } 
          comment = true;
          getchar();
        }
        if (c == '*' && peekchar() == ')') {
          if (debugflag) {printf("(debug) comment off\n"); } 
          comment = false;
          getchar();
        }

        
    }
}

/* Get identifiers and reserved words */
TOKEN identifier (TOKEN tok) {
  if (debugflag) { printf("(debug) identifier()\n"); }

  char str[15] = {'\0'};

  int c, charval;
  int numChars = 0;

  while ((c = peekchar()) != EOF && 
    ((CHARCLASS[c] == ALPHA) || ((CHARCLASS[c] == NUMERIC) && (numChars > 0)) )) {

    c = getchar();

    if (numChars < 15) {
      //if (debugflag) { printf("(debug) c is %c\n", c); }
      
      strncat(str, &c, 1);

      //if (debugflag) { printf("(debug) ASCII: %d\n(debug)str: %s\n", c, str); }
    }

    numChars++;
  }

  //if (debugflag) { printf("(debug) after while in identifier\n"); }

  int reserved_num = lookupReserved(str);

  if (debugflag) { printf("(debug) index: %d\n", reserved_num); }

  if (reserved_num == -1) { // not a reserved word -> is identifier
      // TODO
    tok->tokentype = IDENTIFIERTOK;

    

    strcpy(tok->stringval, str);
  } else {
    tok->tokentype = RESERVED;
    tok->whichval = reserved_num;
  }
  return tok;
}

TOKEN getstring (TOKEN tok) {
  if (debugflag) { printf("(debug) string\n"); }

  char str[16] = {'\0'};
  char c; 
  int numChars = 0;
  char next;

  bool strng = true;
    
  // consume '
  getchar();

  while ((c = peekchar()) != EOF && strng) {
    c = getchar();
    numChars++;

    if (debugflag) {
      printf("(debug) c is %c\n", c);
    }

    if (c == '\'') {
      if (peekchar() == '\'') {
        // ' character
        c = getchar();

        if (numChars <= 15) {
          strncat(str, &c, 1);
        }
      } else {
        // end string
        strng = false;
      }
    }

    else if (numChars <= 15) {
      strncat(str, &c, 1);
    }

  }

  if (debugflag) { printf("(debug) str = %s\n", str); }

  tok->tokentype = STRINGTOK;
  strcpy(tok->stringval, str);
    
    // char res[numChars+1];
    // strcpy(res, str);

    // tok->tokentype = STRINGTOK;
    // strcpy(tok->stringval, res);

  return tok;
    
} 

TOKEN special (TOKEN tok) {
    if (debugflag) { printf("(debug) special\n"); }

    char str[15] = {'\0'};
    int c, charval;

    while ((c = peekchar()) != EOF && CHARCLASS[c] == SPECIAL) {
      c = getchar();

      if (debugflag) { printf("(debug) c is %c\n", c); }
      
      strncat(str, &c, 1);

      // if already exists in delimiter break, dont fetch next char
      if (debugflag) { printf("(debug) lookup delim = %d\n", lookupDelimiter(str)); }
      if (lookupDelimiter(str) >= 0) { 
        if (debugflag) { printf("(debug) already found delimiter str = %s\n", str); }

        char c2 = peekchar();
        char str2[15];
        strcpy(str2, str);
        strncat(str2, &c2, 1);
        
        if (lookupOperator(str2) != -1) {
          // dont break
        } else {
          break;
        }
      }

      if (debugflag) { printf("(debug) ASCII: %d\n(debug)str: %s\n", c, str); }
    }

    if (debugflag) { printf("(debug) after while in special()\n"); }

    int operator_num = lookupOperator(str);

    if (operator_num != -1) {
      if (debugflag) { printf("(debug) index: %d\n", operator_num); }

      tok->tokentype = OPERATOR;
      tok->whichval = operator_num;
    } else {
      operator_num = lookupDelimiter(str);
      tok->tokentype = DELIMITER;
      tok->whichval = operator_num;
    }
    return tok;
}

/* Get and convert unsigned numbers of all types. */
TOKEN number (TOKEN tok) { 
  long num;
  int  c, charval;
  num = 0;

  tok->tokentype = NUMBERTOK;

  // flags
  bool floating = false;
  bool overflow = false;
  bool seenNonZero = false;

  // counters
  int decimalDigits = 0;
  int digits = 0;
  int exponent = 0;
  long prev = 0;
  long decimalVal = 0;
  bool negativeExponent = false;

  // consume 0 digits
  while ( (c = peekchar()) != EOF && c == '0') {
    getchar();
  }

  // get numerical portion before decimal point
  while ( (c = peekchar()) != EOF && CHARCLASS[c] == NUMERIC ) {   
    c = getchar();
    charval = (c - '0');

    prev = num;


    if (num >= 214748364 && charval > 7) {
      // overflow upon adding
      overflow = true;
      //num = 2147483647;
      //printf("GOPOUGYIOUYGUIOPG\n");
    }


    if (digits <= 9 && !overflow) {
      num = num * 10 + charval;
    }

  
    digits++;
  }

  if (debugflag) printf("NUM = %ld\n", num);

  // check for decimal point or exponential
  if ((c = peekchar()) != EOF && c != '.' && c != 'e' && c != '+' && c != '-') {
    // integer
    if (debugflag) { printf("(debug) integer value\n"); }

    if (overflow) {
      // show error message
      printf("Integer number out of range\n");
    }

    tok->basicdt = INTEGER;
    tok->intval = num;
    return (tok);
  }

  if ((c = peekchar()) == '.' && peek2char() == '.') {
    // .. character, not decimal point
    // return integer token and execution continues in special

    tok->basicdt = INTEGER;
    tok->intval = num;
    return (tok);
  }

  int leadingZeroes = 0;

  // check for decimal point
  if (c = peekchar() == '.') {
    if (debugflag) { printf("(debug) floating point number\n"); }

    floating = true;
    c = getchar();

    // get decimal portion
    while ( (c = peekchar()) != EOF && CHARCLASS[c] == NUMERIC ) {   
      c = getchar();
      charval = (c - '0');

      if (charval != 0) {
        seenNonZero = true;
      }

      if (charval == 0 && !seenNonZero) {
        leadingZeroes++;
      }

      if (charval != 0 || (charval == 0 && seenNonZero)) {
        decimalDigits++;
      }

      if (seenNonZero && decimalDigits <= 8 && digits <= 8) {
        num = num * 10 + charval;
        decimalVal = decimalVal * 10 + charval;
      }
      

      if (debugflag) { printf("(debug) decimal val = %ld\n", decimalVal); }

      
      
    }
  } 



  if (debugflag) {
    printf("(debug) leading zeros = %d\n", leadingZeroes);
    printf("(debug) seen non zero = %d\n", seenNonZero);
    printf("NUM = %ld\n", num);

  }

  // check for exponent
  if ((c = peekchar()) == 'e') {
    if (debugflag) { printf("(debug) has exponent\n"); }

    c = getchar();

    // check for exponent sign
    if ((c = peekchar()) == '+') {
      getchar();
    }
    if ((c = peekchar()) == '-') {
      getchar();
      negativeExponent = true;
    }

    while ( (c = peekchar()) != EOF && CHARCLASS[c] == NUMERIC) {
      c = getchar();
      charval = (c - '0');

      exponent = exponent * 10 + charval;
    }
  }

  if (debugflag) { printf("(debug) explicit exponent is %d\n", exponent); }


  // trying to account for more decimal digits than allowed
  if (decimalDigits > 8) {
    decimalDigits = 8;
    //exponent -= decimalDigits-8;
  }

  // return as integer
  if (decimalVal == 0 && exponent == 0 && !seenNonZero) {
    tok->basicdt = INTEGER;
    tok->intval = num / powers[decimalDigits];
    return tok;
  }
  
  
  // set exponent sign
  if (negativeExponent) {
    exponent *= -1;
  }

  // account for leading zeros
  // if (seenNonZero) {
  //   exponent -= leadingZeroes;
  // } else {

  // }
  exponent -= leadingZeroes;
  

  // set exponent for before decimal point
  if (digits > 8) {
    if (debugflag) { printf("(debug) set exp for extra digits bf decimal pt\n");
      printf("(debug) e is %d + %d\n", exponent, digits-8);
      printf("(debug) exponent = %d\n", exponent);
      printf("(debug) decimal value is zero = %ld\n", decimalVal);
    }

    exponent += (digits-8);
    //num *= powers[digits-8];
  }

  //printf("DEC DIGITS - %d\n", decimalDigits);

  double res = (double) num / powers[decimalDigits];

  //exponent -=

  while (res > 10.0) {
    res /= 10;
    exponent++;
    //printf("(debug) exponent = %d\n", exponent);
  }

  while (res < 1.0) {
    res *= 10;
    exponent--;
    //printf("(debug) exponent = %d\n", exponent);
  }

  if (debugflag) {printf("(debug) RES = %f\n", res);
    printf("(debug) exponent = %d\n", exponent);
  } 

  if (overflow) {
    exponent--;
    
    
  }

  // idk if this is needed
  // if (decimalVal == 0 && !seenNonZero) {
  //   exponent-=leadingZeroes;
  // }

  

  tok->basicdt = REAL;

  // check for overflow due to exponent out of range
  if (exponent > 38 || exponent < -38) {
    printf("Floating number out of range\n");
  } else if (exponent < 0) {
    //printf ("RES is %f, exponent is - %d  result is %f\n", res, exponent, res/powers[-1*exponent]);
    tok->realval = res / powers[-exponent];
  } else {
    tok->realval = res * powers[exponent];
  }

  
  
  if (debugflag) {printf("(debug) RES = %f\n", tok->realval);} 


  if (debugflag) { printf("(debug) floating num is: %ld with %d decimal digits, e = %d\n",
       num, decimalDigits, exponent); }
  
 
  return (tok);
}


/**
 * Helper functions
 */
int lookupOperator(char * str) {
  for (int i=0; i<19; i++) {
    if (strcmp(operators[i], str) == 0) {
      return i + 1;
    }
  }
  return -1;
  
}

int lookupDelimiter(char * str) {
  for (int i=0; i<8; i++) {
    if (strcmp(delimiters[i], str) == 0) {
      return i + 1;
    }
  }
  return -1;
}

int lookupReserved(char * str, char *arry[]) {
  
  for (int i=0; i<29; i++) {
    //if (debugflag) { printf("(debug) lookup reserved i=%d\n", i); }
    if (strcmp(reserved[i], str) == 0) {
      if (debugflag) { printf("(debug) compare in lookup reserved: %s, %s\n", str, reserved[i]); }
      return i + 1;
    }
  }
  if (debugflag) { printf("(debug) not found in reserved words\n"); }
  return -1;
  
}


