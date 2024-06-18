/*  pprint.c                Gordon S. Novak Jr.          ; -7 Nov 22  */

/*  Pretty-print a token expression tree in Lisp-like prefix form    */

/* Copyright (c) 2022 Gordon S. Novak Jr. and
   The University of Texas at Austin. */

/*  This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/ */

/*  For PROGRAM, the code should look like:
     PROGRAM
       /
     GRAPH1---->PROGN---->code
                  /
               OUTPUT                  */

/* 09 Feb 01; 17 May 13  */

#include <ctype.h>
#include <stdio.h>
#include "token.h"
#include "lexan.h"
#include "pprint.h"

#define PRINTEXPRDEBUG 0     /* Set to 1 to print each node in printexpr */

char* opprint[]  = {" ", "+", "-", "*", "/", ":=", "=", "<>", "<", "<=",
                      ">=", ">",  "^", ".", "and", "or", "not", "div", "mod",
                      "in", "if", "goto", "progn", "label", "funcall",
                      "aref", "program", "float", "fix"};
int opsize[] = {1, 1, 1, 1, 1, 2, 1, 2, 1, 2,
                  2, 1, 1, 1, 3, 2, 3, 3, 3,
                  2, 2, 4, 5, 5, 7,
                  4, 7, 5, 3 };

void debugprinttok(TOKEN tok)           /* print a token for debugging */
  { if (tok == NULL)
       printf(" token NULL%ld\n", (long)tok);
     else printf(
      " token %ld  typ %2d  whic %3d  dty %3d  sty %ld lnk %ld  opnds %ld\n",
      (long)tok, tok->tokentype, tok->whichval, tok->basicdt,
      (long)tok->symtype, (long)tok->link, (long)tok->operands);
  }

int strlength(char str[])           /* find length of a string */
  {  int i, n;
     n = 16;
     for (i = 0; i < 16; i++)
         if ( str[i] == '\0' && n == 16 ) n = i;
     return n;
   }

void printtok(TOKEN tok)             /* print a token in abbreviated form */
  { switch (tok->tokentype)
	{case IDENTIFIERTOK:
           printf ("%s", tok->stringval);
           break;
         case STRINGTOK:
           printf ("'%s'", tok->stringval);
           break;
         case NUMBERTOK:
           switch (tok->basicdt)
             {case INTEGER: case POINTER:
                printf ("%d", tok->intval);
                break;
	      case REAL:
                printf ("%e", tok->realval);
                break; };
           break;
        case OPERATOR:
          printf ("%s", opprint[tok->whichval]);
          break;
        case DELIMITER:
          printf ("del %d", tok->whichval);
          break;
        case RESERVED:
          printf ("res %d", tok->whichval);
          break;
	 }
  }

void dbugprinttok(TOKEN tok)  /* print a token in 'nice' debugging form */
  { if (tok == NULL)
       printf(" token %ld  NULL\n", (long)tok);
       else switch (tok->tokentype)
	     { case IDENTIFIERTOK:
	              printf(" token %ld  ID  %12s  dtype %2d  link %ld\n",
                             (long)tok, tok->stringval, tok->basicdt,
                             (long)tok->link);
		      break;
	       case STRINGTOK:
	              printf(" token %ld  STR %12s  dtype %2d  link %ld\n",
                     (long)tok, tok->stringval, tok->basicdt, (long)tok->link);
		      break;
	       case NUMBERTOK:
		 switch (tok->basicdt)
		   {case INTEGER: case POINTER:
		      printf(" token %ld  NUM %12d  dtype %2d  link %ld\n",
                      (long)tok, tok->intval, tok->basicdt, (long)tok->link);
		      break;
		    case REAL:
		      printf(" token %ld  NUM %12e  dtype %2d  link %ld\n",
                      (long)tok, tok->realval, tok->basicdt, (long)tok->link);
		      break; };
                      break;
		    case OPERATOR:
	     printf(" token %ld  OP  %12s  dtype %2d  link %ld  operands %ld\n",
                      (long)tok, opprint[tok->whichval], tok->basicdt,
                      (long)tok->link, (long)tok->operands);
		      break;
		    case DELIMITER: case RESERVED:
		      debugprinttok(tok);
		      break;
	 }
  }

void printexpr(TOKEN tok, int col)     /* print an expression in prefix form */
  { TOKEN opnds; int nextcol, start, i;
    if (PRINTEXPRDEBUG != 0)
      { printf ("printexpr: col %d\n", col);
        dbugprinttok(tok);
      };
    if (tok->tokentype == OPERATOR)
      { printf ("(%s", opprint[tok->whichval]);
        nextcol = col + 2 + opsize[tok->whichval];
        opnds = tok->operands;
	start = 0;
	while (opnds != NULL)
	  { if (start == 0) 
	       printf(" ");
	       else { printf("\n");
		      for (i = 0; i < nextcol; i++) printf(" ");
		    }
	    printexpr(opnds, nextcol);
	    if ( opnds->tokentype == IDENTIFIERTOK && nextcol < 60 )
	       nextcol = nextcol + 1 + strlength(opnds->stringval);
	       else start = 1;
	    opnds = opnds->link;
	  }
        printf (")");
      }
      else printtok(tok);
  }

void ppexpr(TOKEN tok)       /* pretty-print an expression in prefix form */
  { if ( (long) tok <= 0 )
      { printf("ppexpr called with bad pointer %ld\n", (long)tok);
	return; };
    printexpr(tok, 0);
    printf("\n");
  }

TOKEN debugtoken = NULL;    /* dummy op for printing a list */

void pplist(TOKEN tok)              /* pretty-print a list in prefix form */
  { if ( debugtoken == NULL )
      { debugtoken = talloc();
        debugtoken->whichval = 0; }  /* will print as blank */
    debugtoken->operands = tok;
    ppexpr(debugtoken);
  }

void dbugplist(TOKEN tok)           /* print a list of tokens for debugging */
  { while (tok != NULL)
      { dbugprinttok(tok);
        tok = tok->link;
      };
  }

void dbugbplist(TOKEN tok)           /* print a list of tokens for debugging */
  { while (tok != NULL)
      { dbugprinttok(tok);
        dbugbprinttok(tok);
        tok = tok->link;
      };
  }

void dbugbprinttok(TOKEN tok)    /* print rest of token for debugging */
  { if (tok != NULL)
      printf("  toktyp %6d  which  %6d  symtyp %ld  syment %ld  opnds %ld\n",
	     tok->tokentype, tok->whichval, (long)tok->symtype,
             (long)tok->symentry, (long)tok->operands);
  }

void dbugprintexpr(TOKEN tok) /* print an expression in 'nice' debugging form */
  { TOKEN opnds;
    dbugprinttok(tok);
    if (tok->tokentype == OPERATOR)
      { opnds = tok->operands;
	while (opnds != NULL)
	      { dbugprintexpr(opnds);
		opnds = opnds->link;
	      }
      }
  }
