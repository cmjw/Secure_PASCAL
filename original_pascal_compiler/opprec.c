/* opprec.c            Gordon S. Novak Jr.                 28 Dec 00   */

/* Copyright (c) 2001 Gordon S. Novak Jr. and The University of Texas at Austin
   All rights reserved. */

/* C version of operator precedence parser.  Calls gettoken as a subroutine. */

/* 10 Jan 94 */

/* To use:
     1. Use a main function as follows to call it:
          main()
          {   lineno = 1;
              EOFFLG = 0;
              init_charclass();
              printf("Started operator precedence test.\n");
              testopprec();
          }
     2. Set DEBUG below to 1 if you want to observe individual actions
        of the parser.
     3. After starting the program, type in expressions followed by ;
        You can type in one item per line to see individual actions.   */

TOKEN opstack, opndstack;

/* Note -- this is a typical ordering but is not Pascal's ordering. */
int opprec[20] = { 0, 6, 6, 7, 7, 1, 5, 5, 5, 5, 5, 5, 9, 10, 3, 2, 4, 0, 0,0};
    /*                +  -  *  /  := =  <> <  <= >= >  ^   . and or not */
#define LPARENTHESIS 4
#define RPARENTHESIS 5
#define DEBUG  0   /* set to 1 to print individual actions */

TOKEN popop ()                   /* pop operator from stack */
  { TOKEN tok;
    tok = opstack;
    opstack = tok->link;
    if (DEBUG) printf("Pop operator\n");
    return(tok);
   }

/* Basic operator precedence parser.  Binary operations only.  */
/* Note that this version eats the delimiter at the end of the expression. */
TOKEN expr ()
  {   int done;
      TOKEN tok;
      done = 0;
      opstack = NULL;
      opndstack = NULL;
      while (done == 0)
        {
          tok = gettoken();
          if (EOFFLG == 0)
            switch (tok->tokentype)
              {  case IDENTIFIERTOK: case STRINGTOK: case NUMBERTOK:
                   pushopnd (tok);     /* always push operand on stack */
                   break;
	         case DELIMITER:
                   if (tok->whichval == LPARENTHESIS)
                      pushop(tok);         /* push left paren on op stack */
		   else if (tok->whichval == RPARENTHESIS)
		     {  while (opstack->whichval != LPARENTHESIS) reduceop();
		        popop(); }         /* pop to ( and discard */
                   else done = 1;
                   break;
	         case RESERVED:
                   done = 1;
                   break;
	         case OPERATOR:
                   while ( prec(tok) <= prec(opstack) ) reduceop();
                   pushop(tok);         /* push operator on stack */
                   break;
	         }
	  else done = 1;
	}
      while (opstack != NULL) reduceop();    /* reduce any remaining ops */
      return (opndstack);
    }

void pushopnd (TOKEN tok)        /* push operand onto stack */
  { tok->link = opndstack;
    opndstack = tok;
    if (DEBUG) printf("Push operand\n");
  }

TOKEN popopnd ()                 /* pop operand from stack */
  {  TOKEN tok;
     tok = opndstack;
     opndstack = tok->link;
     if (DEBUG) printf("Pop operand\n");
     return(tok);
      }

void pushop (TOKEN tok)          /* push operator onto stack */
  {  tok->link = opstack;
     opstack = tok;
     if (DEBUG) printf("Push operator\n");
  }

int prec (TOKEN tok)      /* Precedence value of an operator token */
  { if (tok == NULL)      /* e.g. empty stack */
       return(-1);
       else if (tok->tokentype == OPERATOR)
               return(opprec[tok->whichval]);
               else return(-1);                 /* e.g. for left paren */
  }

reduceop ()                      /* reduce a binary operator        */
  { TOKEN op, lhs, rhs;
    if (DEBUG) printf("Reduceop\n");
    rhs = popopnd();             /* right-hand side: top of stack   */
    lhs = popopnd();             /* left-hand side: next on stack   */
    op = popop();                /* pop operator from stack         */
    op->operands = lhs;          /* link operands to operator       */
    lhs->link = rhs;             /* link second operand to first    */
    rhs->link = NULL;            /* terminate operand list          */
    pushopnd(op);                /* push subtree onto operand stack */
  }

/* Call expr and print result */
testopprec()
  { TOKEN tok;
    while (EOFFLG == 0)
      {  tok = expr();
         printf("Expr = %6d\n", tok);
         if (EOFFLG == 0) ppexpr(tok);
      }
    exit(0);
  }
