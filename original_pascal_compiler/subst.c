/*     subst.c           Gordon S. Novak Jr.            10 Feb 04    */
/* This is a C version of the Lisp function subst for compiler code trees. */

#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include "token.h"
#include "printtoken.c"
#include "pprint.c"

/* Make a new token that is a copy of the given token */
TOKEN copytok(TOKEN origtok)
  {  TOKEN tok; int i;
     tok = (TOKEN) talloc();
     tok->tokentype = origtok->tokentype;
     tok->datatype  = origtok->datatype;
     tok->symtype   = origtok->symtype;
     tok->symentry  = origtok->symentry;
     for (i=0; i<16; i++)
          tok->stringval[i] = origtok->stringval[i];
     return tok;
   }

/* Substitute a new value, new, for an identifier, old, in tree */
TOKEN subst (TOKEN new, TOKEN old, TOKEN tree)
  {  TOKEN tok, last, opnd, ptr;
     if (tree == NULL) return (tree);
     if (tree->tokentype == OPERATOR)
        {  last = NULL;
           ptr = tree->operands;
           tok = copytok(tree);
           while ( ptr != NULL )              /* subst into operands */
              {  opnd = subst (new, old, ptr);
                 if (last == NULL)
                         tok->operands = opnd;
                    else last->link = opnd;    /* link copies */
                 last = opnd;
                 ptr = ptr->link;
              }
           return (tok) ;
       	  }
       else if (tree->tokentype == IDENTIFIERTOK &&
                strcmp(tree->stringval, old->stringval) == 0)
               return ( copytok(new) );
          else return ( copytok(tree) );
  }

/* The following create tokens for use in testing. */

/* Make a token into an integer constant */
TOKEN fillintc(TOKEN tok, int num) 
  {  
     tok->tokentype = NUMBERTOK;
     tok->datatype = INTEGER;
     tok->intval = num;
     tok->link = NULL;
     return tok;
   }

/* Make an integer constant token */
TOKEN makeintc(int num) { return fillintc(talloc(), num); }

/* Make an identifier token */
TOKEN makeid(char name[])
  {  TOKEN tok; int i;
     tok = (TOKEN) talloc();
     tok->tokentype = IDENTIFIERTOK;
     tok->link = NULL;
     for (i=0; i<16; i++)
          tok->stringval[i] = name[i];
     return tok;
   }

/* Make an operator token */
TOKEN makeop(int op)
  {  TOKEN tok;
     tok = (TOKEN) talloc();
     tok->tokentype = OPERATOR;
     tok->link = NULL;
     tok->operands = NULL;
     tok->whichval = op;
     return tok;
   }

/* Make the tree (+ A (* B C)), substitute 3 for B, print.  */
int main()
  {  TOKEN a, b, c, star, plus, new;
     a = makeid("a");
     b = makeid("b");
     c = makeid("c");
     star = makeop(TIMESOP);
     plus = makeop(PLUSOP);
     star->operands = b;
     b->link = c;
     a->link = star;
     plus->operands = a;
     ppexpr(plus);
     new = subst(makeintc(3), b, plus);
     ppexpr(new);
     ppexpr(plus);
    exit(0);
    }
