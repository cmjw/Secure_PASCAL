%{     /* pars1.y    Pascal Parser      Gordon S. Novak Jr.  ; 13 Nov 23   */

/* Charlotte White cmw4856 */

/* Copyright (c) 2023 Gordon S. Novak Jr. and
   The University of Texas at Austin. */

/* 14 Feb 01; 01 Oct 04; 02 Mar 07; 27 Feb 08; 24 Jul 09; 02 Aug 12;
   30 Jul 13; 25 Jul 19 ; 28 Feb 22; 08 Jul 22 */

/*
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.

; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

; You should have received a copy of the GNU General Public License
; along with this program; if not, see <http://www.gnu.org/licenses/>.
  */

/* Yacc reports 1 shift/reduce conflict, due to the ELSE part of
  the IF statement, but Yacc's default resolves it in the right way.*/

#include <stdio.h>
#include <assert.h>
#include <ctype.h>
#include <string.h>
#include "token.h"
#include "lexer.h"
#include "symtab.h"
#include "pprint.h"
#include "parse.h"
#include "codegen.h"

/* define the type of the Yacc stack element to be TOKEN */
#define YYSTYPE TOKEN

/* For debugging parser */
#define YYDEBUG 1
extern int yydebug;

TOKEN parseresult;

%}

%define parse.error verbose

/* Order of tokens corresponds to tokendefs.c; do not change */

%token IDENTIFIER STRING NUMBER   /* token types */

%token PLUS MINUS TIMES DIVIDE    /* Operators */
%token ASSIGN EQ NE LT LE GE GT POINT DOT AND OR NOT DIV MOD IN DOUBLECOLON

%token COMMA                      /* Delimiters */
%token SEMICOLON COLON LPAREN RPAREN LBRACKET RBRACKET DOTDOT

%token ARRAY BEGINBEGIN           /* Lex uses BEGIN */
%token CASE CONST DO DOWNTO ELSE END FILEFILE FOR FUNCTION GOTO IF LABEL NIL
%token OF PACKED PROCEDURE PROGRAM RECORD REPEAT SET THEN TO TYPE UNTIL
%token VAR WHILE WITH PRIV 

%right thenthen ELSE // Same precedence, but "shift" wins.

%%
  program : PROGRAM IDENTIFIER LPAREN id_list RPAREN SEMICOLON lblock DOT 
            { parseresult = makeprogram($2, $4, $7); } ;

  unsigned_constant : NUMBER | NIL | STRING ;

  sign : PLUS | MINUS ;

  constant : sign IDENTIFIER    { $$ = unaryop($1, $2); }
           |  IDENTIFIER 
           |  sign NUMBER       { $$ = unaryop($1, $2); }
           |  NUMBER
           |  STRING
           ;

  id_list :  IDENTIFIER COMMA id_list    { $$ = cons($1, $3); }
          |  IDENTIFIER                  { $$ = $1; }
          ;

  numlist    :  NUMBER COMMA numlist    { instlabel($1); } 
             |  NUMBER                  { instlabel($1); }
             ;

  cdef       :  IDENTIFIER EQ constant    { instconst($1, $3); } 
             ; 

  cdef_list  :  cdef SEMICOLON cdef_list    
             |  cdef SEMICOLON          
             ;  

  tdef       :  IDENTIFIER EQ type    { insttype($1, $3); }
             ;

  tdef_list  :  tdef SEMICOLON tdef_list
             |  tdef SEMICOLON
             ;

  statement_list : statement SEMICOLON statement_list    { $$ = cons($1, $3); }
                 | statement                             { $$ = cons($1, NULL); }
                 ;

  fields : id_list COLON type    { $$ = instfields($1, $3); }
         ;

  field_list : fields SEMICOLON field_list    { $$ = nconc($1, $3); }
             | fields
             ;

  label : NUMBER COLON statement    { $$ = dolabel($1, $2, $3); }
        ;

  lblock : LABEL numlist SEMICOLON cblock    { $$ = $4; }
         |  cblock
         ;

  cblock : CONST cdef_list tblock    { $$ = $3; }
         |  tblock
         ;

  tblock : TYPE tdef_list vblock    { $$ = $3; }
         |  vblock
         ;

  vblock : VAR vdef_list block    { $$ = $3; }
         | block
         ;

  vdef_list : vdef SEMICOLON vdef_list   
            | vdef SEMICOLON            
            ;

  vdef : id_list COLON type    { instvars($1, $3); }
       ;

  type : simple_type
       | ARRAY LBRACKET simple_type_list RBRACKET OF type   { $$ = instarray($3, $6); } 
       | RECORD field_list END                               { $$ = instrec($1, $2); }
       | POINT IDENTIFIER                                    { $$ = instpoint($1, $2); }
       ;

  simple_type_list : simple_type COMMA simple_type_list   { $$ = cons($1, $3); }
                   | simple_type                          { $$ = cons($1, NULL); }
                   ;

  simple_type : IDENTIFIER                   { $$ = findtype($1); }
              | LPAREN id_list RPAREN       { $$ = instenum($2); }
              | constant DOTDOT constant    { $$ = instdotdot($1, $2, $3);}
              ;

  block : BEGINBEGIN statement endpart    { $$ = makeprogn($1,cons($2, $3)); } 
        | privblock
        ;

  privblock : PRIV DOUBLECOLON BEGINBEGIN statement endpart { $$ = makeprogn($3,cons($4, $5)); }

  statement  :  BEGINBEGIN statement endpart         { $$ = makeprogn($1,cons($2, $3)); }
             |  IF expression THEN statement endif   { $$ = makeif($1, $2, $4, $5); }
             |  assignment
             |  funcall
             |  WHILE expression DO statement                 { $$ = makewhile($1, $2, $3, $4); }
             |  FOR assignment TO expression DO statement     { $$ = makefor(1, $1, $2, $3, $4, $5, $6); }
             |  REPEAT statement_list UNTIL expression        { $$ = makerepeat($1, $2, $3, $4); } 
             |  GOTO NUMBER                                   { $$ = dogoto($1, $2); }
             |  label
             ;
             
  funcall    :  IDENTIFIER LPAREN expr_list RPAREN    { $$ = makefuncall($2, $1, $3); }
             ;

  endpart    :  SEMICOLON statement endpart    { $$ = cons($2, $3); }
             |  SEMICOLON END                  { $$ = NULL; }
             |  END                            { $$ = NULL; }
             |  PRIV DOUBLECOLON END           { $$ = NULL; }
             |  SEMICOLON PRIV DOUBLECOLON END { $$ = NULL; }
             ;

  endif      :  ELSE statement                 { $$ = $2; }
             |  /* empty */                    { $$ = NULL; }
             ;

  assignment :  variable ASSIGN expression     { $$ = binop($2, $1, $3); }
             ;

  variable   :  IDENTIFIER                             { $$ = findid($1); }
             |  variable LBRACKET expr_list RBRACKET   { $$ = arrayref($1, $2, $3, $4); }
             |  variable DOT IDENTIFIER                { $$ = reducedot($1, $2, $3); }
             |  variable POINT                         { $$ = dopoint($1, $2); } 

             /*| IDENTIFIER DOUBLECOLON IDENTIFIER       { $$ = scoperef($1, $2, $3); } /* scope operator */
             ;

  plus_op : PLUS | MINUS | OR ;

  compare_op : EQ | LT | GT | NE | LE | GE | IN ;

  times_op : TIMES | DIVIDE | DIV | MOD | AND ;

  simple_expression : sign term    { $$ = unaryop($1, $2); }
                    | term 
                    | simple_expression plus_op term    { $$ = binop($2, $1, $3); }
                    ;

  expression : expression compare_op simple_expression    { $$ = binop($2, $1, $3); }
             | simple_expression 
             ;

  expr_list  :  expression COMMA expr_list    { $$ = cons($1, $3); }
             |  expression                    { $$ = cons($1, NULL); }
             ;

  term       :  term times_op factor   { $$ = binop($2, $1, $3); }
             |  factor
             ;
             
  factor     :  unsigned_constant
             |  variable
             |  LPAREN expression RPAREN     { $$ = $2; }       
             |  funcall
             |  NOT factor                   { $$ = unaryop($1, $2); }
             ;  
  

%%


#define DEBUG        0             /* set bits here for debugging, 0 = off  */
#define DB_CONS       0             /* bit to trace cons */
#define DB_BINOP      2             /* bit to trace binop */
#define DB_MAKEIF     4             /* bit to trace makeif */
#define DB_MAKEPROGN  8             /* bit to trace makeprogn */
#define DB_PARSERES  16             /* bit to trace parseresult */
#define DB_MAKEREPEAT 1
#define DB_NCONC      1
#define DB_DOLABEL    1
#define DB_INSTCONST  0

int labelnumber = 0;  /* sequential counter for internal label numbers */
int labels[50];



void *scoperef(void *scope, void *operator, void *identifier) {
    // TODO
}


/* arrayref processes an array reference a[i]
   subs is a list of subscript expressions.
   tok and tokb are (now) unused tokens that are recycled. */
TOKEN arrayref(TOKEN arr, TOKEN tok, TOKEN subs, TOKEN tokb) {
  /* if (DEBUG) {
    printf("#### in arrayref ###\n");
    dbugprinttok(arr);
    dbugprinttok(tok);
    dbugprinttok(subs);
    dbugprinttok(tokb);
  } */

  SYMBOL arraysym = searchst(arr->stringval);
  SYMBOL typesym = arraysym->datatype->datatype->basicdt;

  // 1D array
  if (!subs->link) {
    if (DEBUG) {
      printf("1D array\n");
    }

    int low = arr->symtype->lowbound;
    int high = arr->symtype->highbound;
    int size = arr->symtype->size / (low + high + 1);

    int datasize = subs->intval;

    int offsize = size;

    // calculate offset
    TOKEN offs = makeintc(size*datasize - offsize);

    return makearef(arr, offs, tokb);
  }

  // 2D array
  else { }
}

/* binop links a binary operator op to two operands, lhs and rhs. */
TOKEN binop(TOKEN op, TOKEN lhs, TOKEN rhs)        /* reduce binary operator */ { 
  if (DEBUG && DB_BINOP) {
    printf("(DEBUG) in binop()\n");
  }

  // handle NIL
  if (rhs->whichval == (NIL - RESERVED_BIAS)) {
    rhs = makeintc(0);
    op->operands = lhs;          /* link operands to operator       */
    lhs->link = rhs;             /* link second operand to first    */
    rhs->link = NULL;            /* terminate operand list          */
  }
  
  // both integer 
  op->operands = lhs;
  lhs->link = rhs;
  rhs->link = NULL;

  // both real
  if (lhs->basicdt == REAL && rhs->basicdt == REAL) {
    op->basicdt = REAL;
  }

  // int OP real : fix rhs
  else if (lhs->basicdt == INTEGER && rhs->basicdt == REAL) {

    // fix rhs for assign
    if (op->whichval == ASSIGNOP) {
      op->basicdt = INTEGER;
      TOKEN rhsFixed = makefix(rhs);
      lhs->link = rhsFixed;
    }

    // float lhs
    else {
      op->basicdt = REAL;
      TOKEN lhsFloated = makefloat(lhs);
      lhsFloated->link = rhs;
    }
  }

  // real OP int : float rhs
  else if (lhs->basicdt == REAL && rhs->basicdt == INTEGER) {
    op->basicdt = REAL;
    TOKEN rhsFloated = makefloat(rhs);
    lhs->link = rhsFloated; // floated rhs
  }

  
  if (DEBUG & DB_BINOP) { 
    printf("binop\n");
    dbugprinttok(op);
    dbugprinttok(lhs);
    dbugprinttok(rhs);
  };
  
  return op;
}


TOKEN cons(TOKEN item, TOKEN list)           /* add item to front of list */ { 
  item->link = list;
  if (DEBUG & DB_CONS) { 
    printf("(DEBUG) in cons()\n");
    dbugprinttok(item);
    dbugprinttok(list);
  };
  
  return item;
}


/* Make a new token that is a copy of the given token */
TOKEN copytok(TOKEN origtok) {  
  TOKEN tok; int i;
  tok = (TOKEN) talloc();
  tok->tokentype = origtok->tokentype;
  tok->basicdt  = origtok->basicdt;
  tok->symtype   = origtok->symtype;
  tok->symentry  = origtok->symentry;
  for (i=0; i<16; i++)
    tok->stringval[i] = origtok->stringval[i];
  return tok;
}


/* dogoto is the action for a goto statement.
   tok is a (now) unused token that is recycled. */
TOKEN dogoto(TOKEN tok, TOKEN labeltok) {
  if (DEBUG) {
    printf("(DEBUG) in dogoto()\n");
  }

  int internalLabelNum = getInternalLabel(labeltok->intval);
  
  if (internalLabelNum < 0) {
    printf("(DEBUG) INVALID LABEL NUMBER\n");
    return NULL;
  }  

  tok = makegoto(internalLabelNum);

  if (DEBUG) {
    printf("(DEBUG) end of dogoto()\n");
  }

  return tok;
}


/* dolabel is the action for a label of the form   <number>: <statement>
   tok is a (now) unused token that is recycled. */
TOKEN dolabel(TOKEN labeltok, TOKEN tok, TOKEN statement) {
  if (DEBUG && DB_DOLABEL) {
    printf("(DEBUG) in dolabel()\n");
  }

  int internalLabelNum = getInternalLabel(labeltok->intval);

  if (internalLabelNum == -1) {
    printf("(DEBUG) NO LABEL FOUND\n");
    return NULL;
  }

  labeltok = makeop(LABELOP);
  labeltok->link = statement;

  TOKEN labelNum = makeintc(internalLabelNum);

  labeltok->operands=labelNum;
    
  tok = makeprogn(tok, labeltok);

  if (DEBUG && DB_DOLABEL) {
    printf("(DEBUG) end of dolabel()\nDoLabel token: \n");
    dbugprinttok(tok);
  }

  return tok;
}


/* dopoint handles a ^ operator.
   tok is a (now) unused token that is recycled. */
TOKEN dopoint(TOKEN var, TOKEN tok) {
  if (DEBUG) {
    printf("(DEBUG) in dopoint()\n");

  }
  tok->symentry = var->symentry->datatype->datatype;
  tok->operands = var;

  return tok;
}


/* get internal label number, helper for dolabel() */
int getInternalLabel(int num) {
  for (int i = 0; i < labelnumber; i++) {
    if (labels[i] == num) {
      if (DEBUG) {
        printf("(DEBUG) in getInternalLabel()\n");
        printf("(DEBUG) found label %d\n", i);
      }
      return i;
    }
  }
  printf("(DEBUG) INTERNAL LABEL NOT FOUND\n");
  return -1;
}


/* fillintc smashes tok, making it into an INTEGER constant with value num */
TOKEN fillintc(TOKEN tok, int num) {
  tok->basicdt = INTEGER;
  tok->tokentype = NUMBERTOK;
  tok->intval = num;

  return tok;
}


TOKEN findid(TOKEN tok) { /* the ID token */
  if (DEBUG) {
    printf("(DEBUG) in findid()\n");
  }

  SYMBOL sym = searchst(tok->stringval);
  tok->symentry = sym;

  SYMBOL typ = sym->datatype;
  tok->symtype = typ;

  if (sym->kind == CONSTSYM) {   // smash constant tokens
    if (DEBUG) {
      printf ("(DEBUG) =================== constant in FINDID()\n");
    }

    // real
    if (sym->basicdt == REAL) {
      tok->tokentype = NUMBERTOK;
      tok->basicdt = REAL;
      tok->realval = sym->constval.realnum;
    }

    // integer
    if (sym->basicdt == INTEGER) {
      tok->tokentype = NUMBERTOK;
      tok->basicdt = INTEGER;
      tok->realval = sym->constval.realnum;
    }
  } else {
    if (typ->kind == BASICTYPE || typ->kind == POINTERSYM) {
      tok->basicdt = typ->basicdt;
    }
  }
  
  
  //if (typ->kind == BASICTYPE || typ->kind == POINTERSYM) {
  //  tok->basicdt = typ->basicdt;
  //}
  

  if (DEBUG) {
    printf("(DEBUG) In findid()\n");
    dbugprinttok((struct tokn *) tok);
    dbugprinttok((struct tokn *) sym);
    printf("(DEBUG) end of findid()\n");
  }

  return tok;
}


/* instarray installs an array declaration into the symbol table.
   bounds points to a SUBRANGE symbol table entry.
   The symbol table pointer is returned in token typetok. */
TOKEN instarray(TOKEN bounds, TOKEN typetok) {
  if (DEBUG) {
    printf("(DEBUG) *********** in instarray()\n");
  }
  
  if (bounds->link) {
    typetok = instarray(bounds->link, typetok);
  } 

  SYMBOL arraysym = symalloc();
  SYMBOL subrangesym = bounds->symtype;
  SYMBOL typeSym = typetok->symtype;
  
  arraysym->datatype = typeSym;
  arraysym->kind = ARRAYSYM;
  
  arraysym->lowbound = subrangesym->lowbound;
  arraysym->highbound = subrangesym->highbound;
  arraysym->size = (arraysym->highbound - arraysym->lowbound +  1) * (typeSym->size);

  if (bounds->link) {
    arraysym->size = (arraysym->lowbound + arraysym->highbound - 1) * (typeSym->size);
  }

  typetok->symtype = arraysym;

  return typetok;
}


/* findtype looks up a type name in the symbol table, puts the pointer
   to its type into tok->symtype, returns tok. */
TOKEN findtype(TOKEN tok) {
  SYMBOL s = searchst(tok->stringval);
  if (s->kind == TYPESYM) {
    s = s->datatype;
  }

  tok->symtype = s;
  if (DEBUG) {

  }
  return tok;
}


/* instconst installs a constant in the symbol table */
void  instconst(TOKEN idtok, TOKEN consttok) {
  if (DEBUG && DB_INSTCONST) {
    printf("(DEBUG) begin instconst()\n");
  }

  SYMBOL sym = insertsym(idtok->stringval);
  sym->kind = CONSTSYM;
  sym->basicdt = consttok->basicdt;

  if (sym->basicdt == INTEGER) {
    sym->constval.intnum = consttok->intval;
  }

  if (sym->basicdt == REAL) {
    sym->constval.realnum = consttok->realval;
  }

  if (DEBUG && DB_INSTCONST) {
    printf("(DEBUG) end of instconst()\n");
    dbugprinttok(sym);
  }
}

/* instdotdot installs a .. subrange in the symbol table.
   dottok is a (now) unused token that is recycled. */
TOKEN instdotdot(TOKEN lowtok, TOKEN dottok, TOKEN hightok) {
  if (DEBUG) {
    printf("(DEBUG) in instdotdot()\n");
  }

  int low = lowtok->intval;
  int high = hightok->intval;

  TOKEN tok = makesubrange(dottok, low, high);
  printf("*********** subrange **********\n");
  dbugprinttok(tok);
  return tok;

}


/* instenum installs an enumerated subrange in the symbol table,
   e.g., type color = (red, white, blue)
   by calling makesubrange and returning the token it returns. */
TOKEN instenum(TOKEN idlist) {
  if (DEBUG) {
    printf("(DEBUG) in instenum()\n");
  }

  int count = 0;
  TOKEN temp = idlist;

  while (temp) {
    instconst(temp, makeintc(count));
    temp = temp->link;

    count++;
  }

  TOKEN tok = makesubrange(idlist, 0, count-1);

  if (DEBUG) {
    printf("(DEBUG) end of instenum()\n");
  }

  return tok;
}


/* instfields will install type in a list idlist of field name tokens:
   re, im: real    put the pointer to REAL in the RE, IM tokens.
   typetok is a token whose symtype is a symbol table pointer.
   Note that nconc() can be used to combine these lists after instrec() */
TOKEN instfields(TOKEN idlist, TOKEN typetok) {
  if (DEBUG) {
    printf("(DEBUG) in instfields()\n");
  }

  SYMBOL typesym = typetok->symtype;
  TOKEN temp = idlist;

  while (temp) {
    temp->symtype = typesym;     
    temp = temp->link;
  }

  if (DEBUG) {
    printf("(DEBUG) end of instfields()\n");
  }

  return idlist;
}


/* instlabel installs a user label into the label table */
void  instlabel (TOKEN num) {
  if (DEBUG) {
    printf("(DEBUG) in instlabel()\n");
  }

  labels[labelnumber++] = num->intval;  
}


/* instpoint will install a pointer type in symbol table */
TOKEN instpoint(TOKEN tok, TOKEN typename) {
  if (DEBUG) {
    printf("(DEBUG) in instpoint()\n");
  }

  SYMBOL pointSym = symalloc();
  SYMBOL pointType = searchins(typename->stringval);

  pointSym->basicdt = POINTER;
  pointSym->datatype = pointType;
  pointSym->kind = POINTERSYM;
  pointSym->size = basicsizes[POINTER];

  tok->symtype = pointSym;

  if (DEBUG) {
    printf("(DEBUG) end of instpoint\n");
  }

  return tok;
}


/* instrec will install a record definition.  Each token in the linked list
   argstok has a pointer its type.  rectok is just a trash token to be
   used to return the result in its symtype */
TOKEN instrec(TOKEN rectok, TOKEN argstok) {
  if (DEBUG) {
    printf("(DEBUG) in instrec()\n");
  }
  int count = 0;
  int next = 0;

  SYMBOL recSym = symalloc();
  recSym->kind = RECORDSYM;

  SYMBOL prev = NULL;
  TOKEN temp = argstok;

  while (temp) {
    int align = alignsize(temp->symtype);

    SYMBOL currFieldTok = makesym(temp->stringval);
    currFieldTok->datatype = temp->symtype;
    currFieldTok->offset = wordaddress(next, align);
    currFieldTok->size = temp->symtype->size;

    next = currFieldTok->offset + currFieldTok->size;
    currFieldTok->link = NULL;

    if (count == 0) { // first case
      recSym->datatype = currFieldTok;
      prev = currFieldTok;
    } else {
      prev->link = currFieldTok;
      prev = currFieldTok;
    }

    temp = temp->link;
    count++;
  }

  recSym->size = wordaddress(next, 16); 
  rectok->symtype = recSym;

  if (DEBUG) {
    printf("(DEBUG) end of instrec()\n");
    printf("Record Size: %d\n", recSym->size);
    printf("Record Token: \n");
    dbugprinttok(rectok);
  }
  return rectok;
}


/* insttype will install a type name in symbol table.
   typetok is a token containing symbol table pointers. */
void insttype(TOKEN typename, TOKEN typetok) {
	if (DEBUG) {
		printf("(DEBUG) in insttype()\n");
		dbugprinttok(typename);
	}

	SYMBOL typesym = searchins(typename->stringval);
  typesym->kind = TYPESYM;
  typesym->datatype = typetok->symtype;
  typesym->size = typetok->symtype->size;

  if (DEBUG) {
		printf("(DEBUG) end of insttype()\n");
	}
}


/* install variables in symbol table */
void instvars(TOKEN idlist, TOKEN typetok) {  
  SYMBOL sym, typesym; int align;
  typesym = typetok->symtype;
  align = alignsize(typesym);
  while ( idlist != NULL )   /* for each id */ {  
    sym = insertsym(idlist->stringval);
    sym->kind = VARSYM;
    sym->offset =     /* "next" */
              wordaddress(blockoffs[blocknumber],
                          align);
    sym->size = typesym->size;
    blockoffs[blocknumber] =   /* "next" */
                         sym->offset + sym->size;
    sym->datatype = typesym;
    sym->basicdt = typesym->basicdt;
    idlist = idlist->link;
  };
}


/* makearef makes an array reference operation.
   off is be an integer constant token
   tok (if not NULL) is a (now) unused token that is recycled. */
TOKEN makearef(TOKEN var, TOKEN off, TOKEN tok) {
  if (DEBUG) {
    printf("(DEBUG) in makearef()\n");
    dbugprinttok(var);
    dbugprinttok(off);
    dbugprinttok(tok);
  }

  // nested AREF, dont need to make another
  if (var->whichval == AREFOP) {
    if (DEBUG) {
      printf("*** AREF case 1\n");
      dbugprinttok(off);
      dbugprinttok(var->operands->link);
      printf("VAL %d\n", var->operands->link->intval);
    }

    var->operands->link->intval += off->intval;

    if (DEBUG) {
      printf("##### result AREF tok1 \n");
      debugprinttok(var);
      debugprinttok(var->operands);
    }

    return var;
  } 

  else {
    if (DEBUG) {
      printf("AREF case 2\n");
    }

    tok = makeop(AREFOP);
    var->link = off;

    tok->basicdt = var->symentry->datatype;
    tok->operands = var;
    tok->symentry = var->symentry;
  }

  if (DEBUG) {
    printf("##### result AREF tok 2 \n");
    debugprinttok(tok);
    debugprinttok(var->operands);
  }

  return tok;
}


/* makefix forces the item tok to be integer, by truncating a constant
   or by inserting a FIXOP operator */
TOKEN makefix(TOKEN tok) {
  if (tok->tokentype == NUMBERTOK) {
    tok->basicdt = INTEGER;
    tok->intval = (int) tok->realval;
    return tok;

  } else { 
    TOKEN fixop = makeop(FIXOP);
    fixop->operands = tok;
    return fixop;
  }
}


/* makefloat forces the item tok to be floating, by floating a constant
   or by inserting a FLOATOP operator */
TOKEN makefloat(TOKEN tok) {
  if (tok->tokentype == NUMBERTOK) {
    tok->basicdt = REAL;
    tok->realval = (double) tok->intval;
    return tok;

  } else {
    TOKEN floatop = makeop(FLOATOP);
    floatop->operands = tok;
    return floatop;
  }
}


/* makefor makes structures for a for statement.
   sign is 1 for normal loop, -1 for downto.
   asg is an assignment statement, e.g. (:= i 1)
   endexpr is the end expression
   tok, tokb and tokc are (now) unused tokens that are recycled. */
TOKEN makefor(int sign, TOKEN tok, TOKEN asg, TOKEN tokb, TOKEN endexpr,
              TOKEN tokc, TOKEN statement) {

  tok = makeprogn(tok, asg);

  int currentLabel = labelnumber;
  TOKEN label = makelabel();
  
  TOKEN gototok = makegoto(currentLabel);

  asg->link = label;

  TOKEN ifStatement = tokb;
  TOKEN bodyStatement = tokc;
  bodyStatement = makeprogn(bodyStatement, statement);

  TOKEN testStatement = makeop(LEOP);

  ifStatement = makeif(ifStatement, testStatement, bodyStatement, NULL);

  TOKEN tok1 = copytok(asg->operands);
  TOKEN tok2 = copytok(tok1);
  TOKEN tok3 = copytok(tok2);

  tok1->link = endexpr;
  testStatement->operands = tok1;

  TOKEN assignmentStatement = makeop(ASSIGNOP);
  TOKEN increment = makeop(PLUSOP);

  int inc = 1;
  tok3->link=makeintc(inc);

  increment->operands=tok3;
  tok2->link=increment;
  assignmentStatement->operands=tok2;

  assignmentStatement->link = gototok;
  statement->link = assignmentStatement;

  testStatement->link = bodyStatement;
  ifStatement->operands = testStatement;
  label->link = ifStatement;

  if (DEBUG ) {
    printf("makefor\n");
    dbugprinttok(tok);
  }

  return tok;
}


/* makefuncall makes a FUNCALL operator and links it to the fn and args.
   tok is a (now) unused token that is recycled. */
TOKEN makefuncall(TOKEN tok, TOKEN fn, TOKEN args) {
  // make tok into funcall token
  //TOKEN funcTok = makeop(FUNCALLOP);

  // set basicdt based on args to avoid floating

  //tok = binop(funcTok, fn, args);

  if (DEBUG) {
    printf("(DEBUG) in makefuncall ===========\n" );
    dbugprinttok(tok);
  }

  // handle writeln
  if (strcmp(fn->stringval, "writeln") == 0) {
    if (args->basicdt == REAL) {
      strcpy(fn->stringval, "writelnf");
      tok->basicdt = REAL;
    } else if (args->tokentype == STRINGTOK) {
      strcpy(fn->stringval, "writeln");
      tok->basicdt = STRING;
    } else {
      strcpy(fn->stringval, "writelni");
      tok->basicdt = INTEGER;
    } 
  } 


  else if (strcmp(fn->stringval, "new") == 0) {
    SYMBOL typeSym = searchst(args->stringval);
    if (!typeSym) {
			printf("TYPE NOT FOUND\n");
      return NULL;
		}

    TOKEN funcTok = makeop(FUNCALLOP);

		tok = makeop(ASSIGNOP); 
		tok->operands = args;

		args->link = funcTok;
		funcTok->operands = fn;

		fn->link = makeintc(typeSym->datatype->datatype->datatype->size);

    return tok;
	}
  
  
  else {
    //tok->basicdt = args->basicdt;
    SYMBOL funct = searchst(fn->stringval);

    if (!funct) {
      return NULL;
    }
    if (DEBUG) {
      printf("(DEBUG) symbol +++++++++++++++\n");
      dbugprinttok(funct);
    }
    tok->basicdt = funct->datatype->basicdt;
    //tok->symtype = funct;
  }

  //tok->basicdt = args->basicdt;
  tok->whichval = FUNCALLOP;
  tok->tokentype = OPERATOR;
  tok->operands = fn;
  fn->link = args;

  if (DEBUG) {
    printf("(DEBUG) end of makefuncall\n");
    debugprinttok(tok);
    printf("(DEBUG) *************\n");
  }

	return tok;
}


/* makegoto makes a GOTO operator to go to the specified label.
   The label number is put into a number token. */
TOKEN makegoto(int label) {
  TOKEN tok = talloc();
  tok->tokentype = OPERATOR;
  tok->whichval = GOTOOP;
  tok->operands = makeintc(label);

  return tok;
}


TOKEN makeif(TOKEN tok, TOKEN exp, TOKEN thenpart, TOKEN elsepart) {  
  tok->tokentype = OPERATOR;  /* Make it look like an operator   */
  tok->whichval = IFOP;
  if (elsepart != NULL) elsepart->link = NULL;
  thenpart->link = elsepart;
  exp->link = thenpart;
  tok->operands = exp;
  if (DEBUG & DB_MAKEIF) { 
    printf("makeif\n");
    dbugprinttok(tok);
    dbugprinttok(exp);
    dbugprinttok(thenpart);
    dbugprinttok(elsepart);
  };
  
  return tok;
}


/* makeintc makes a new integer number token with num as its value */
TOKEN makeintc(int num) {
  TOKEN tok = talloc();
  fillintc(tok, num);
  
  return tok;
}


/* makelabel makes a new label, using labelnumber++ */
TOKEN makelabel() {
  TOKEN label = makeop(LABELOP);
  TOKEN num = makeintc(labelnumber);
  labelnumber++;

  return unaryop(label, num);
}


/* Make an operator token */
TOKEN makeop(int op) {  
  TOKEN tok;
  tok = (TOKEN) talloc();
  tok->tokentype = OPERATOR;
  tok->link = NULL;
  tok->operands = NULL;
  tok->whichval = op;

  if (DEBUG) {
    debugprinttok(tok);
  }
  return tok;
}


TOKEN makeprogn(TOKEN tok, TOKEN statements) {  
  tok->tokentype = OPERATOR;
  tok->whichval = PROGNOP;
  tok->operands = statements;
  if (DEBUG & DB_MAKEPROGN) { 
    printf("makeprogn\n");
    dbugprinttok(tok);
    dbugprinttok(statements);
  };
  
  return tok;
}


/* makeprogram makes the tree structures for the top-level program */
TOKEN makeprogram(TOKEN name, TOKEN args, TOKEN statements) {
  TOKEN tok = talloc();

  tok->tokentype = OPERATOR;
  tok->whichval = PROGRAMOP;
  tok->operands = name;

  TOKEN progargs = talloc();

  progargs = makeprogn(progargs, args);

  name->link = progargs;
  progargs->link = statements;

  if (DEBUG) {
    printf("(DEBUG) makeprogram()\n");
    dbugprinttok(tok);
    dbugprinttok(progargs);
  }

  return tok;
}


/* makerepeat makes structures for a repeat statement.
   tok and tokb are (now) unused tokens that are recycled. */
TOKEN makerepeat(TOKEN tok, TOKEN statements, TOKEN tokb, TOKEN expr) {
  if (DEBUG && DB_MAKEREPEAT) {
    printf("(DEBUG) makerepeat()\n");
  }

  TOKEN gototok = makegoto(labelnumber);
  TOKEN label = makelabel();

  tok = makeprogn(tok, label);
  TOKEN body = makeprogn(tokb, statements);
  label->link = body;

  TOKEN thenTok = makeprogn((TOKEN) talloc(), NULL);
  thenTok->link = gototok;

  TOKEN ifToken = talloc();
  ifToken = makeif(ifToken, expr, thenTok, gototok);

  body->link = ifToken;

  if (DEBUG && DB_MAKEREPEAT) {
    printf("(DEBUG) end of makerepeat()\n");
    dbugprinttok(tok);
  }

  return tok;  
}


/* makesubrange makes a SUBRANGE symbol table entry, puts the pointer to it
   into tok, and returns tok. */
TOKEN makesubrange(TOKEN tok, int low, int high) {
  if (DEBUG) {
    printf("(DEBUG) in makesubrange()\n");
  }
  
  SYMBOL sym = symalloc();

  sym->basicdt = INTEGER;
  sym->kind = SUBRANGE;
  sym->lowbound = low;
  sym->highbound = high;
  sym->size = basicsizes[INTEGER];

  tok->symtype = sym;

  if (DEBUG) {
    printf("(DEBUG) end of makesubrange()\nToken:");
    dbugprinttok(tok);
  }

  return tok;
}


/* makewhile makes structures for a while statement.
   tok and tokb are (now) unused tokens that are recycled. */
TOKEN makewhile(TOKEN tok, TOKEN expr, TOKEN tokb, TOKEN statement) {
  if (DEBUG) {
    printf("(DEBUG) in makewhile()\n");
  }

  int labelNum = labelnumber;
  TOKEN gotoTok = makegoto(labelNum);
  statement->link = gotoTok;

  TOKEN label = makelabel();
  tok = makeprogn(tok, label);
  
  TOKEN bodyTok = makeprogn(tokb, statement);

  TOKEN ifTok = talloc();
  ifTok = makeif(ifTok, expr, bodyTok, NULL);

  label->link = ifTok;

  if (DEBUG) {
    printf("(DEBUG) end of makewhile()\n");
  }

  return tok;
}


/* nconc concatenates two token lists, destructively, by making the last link
   of lista point to listb.
   (nconc '(a b) '(c d e))  =  (a b c d e)  */
/* nconc is useful for putting together two fieldlist groups to
   make them into a single list in a record declaration. */
/* nconc should return lista, or listb if lista is NULL. */
TOKEN nconc(TOKEN lista, TOKEN listb) {
  if (DEBUG && DB_NCONC) {
    printf("(DEBUG) in nconc()\n");
  }

  if (!lista) {
    return listb;
  }

  TOKEN temp = lista;

  while (temp->link) {
    temp = temp->link;
  }
  temp->link = listb;

  if (DEBUG && DB_NCONC) {
    printf("(DEBUG) end of nconc()\n");
  }

  return temp;
}

/* reducedot handles a record reference.
   dot is a (now) unused token that is recycled. */
TOKEN reducedot(TOKEN var, TOKEN dot, TOKEN field) {
  if (DEBUG) {
    printf("(DEUBG) in reducedot()\n");
  }

  if (!var || !dot || !field) {
    printf("ERROR IN REDUCEDOT\n");
  }

  
  SYMBOL sym = var->symentry;
  SYMBOL temp = sym->datatype->datatype;

  int currentOffset = 0;

  while (temp) {
    if (DEBUG) {
      printf("DEBUG: in for loop in reducedot\n");
    } 

    if (strcmp(field->stringval, temp->namestring) == 0) {
      currentOffset = temp->offset;
      var->symentry = temp;

      dot = makearef(var, makeintc(currentOffset), dot);
      dot->basicdt = var->symentry->datatype->basicdt;

      if (DEBUG) {
        printf("(DEBUG) end of reducedot() in if\n");
        dbugprinttok(dot);
      }
      
      return dot;
    } 
    
    temp = temp->link;
  }

  if (DEBUG) {
    printf("DEBUG: after for loop in reducedot\n");
  }

  dot = makearef(var, makeintc(currentOffset), dot);

  if (DEBUG) {
        printf("(DEBUG) end of reducedot() in if\n");
        dbugprinttok(dot);
      }

  if (DEBUG) {
    printf("(DEBUG) end of reducedot()\n");
  }

  return dot;
}


/* unaryop links a unary operator op to one operand, lhs */
TOKEN unaryop(TOKEN op, TOKEN lhs) {
  op->operands = lhs;
  lhs->link = NULL;
  return op;
}


/* ======================================================================================== */
/* Return functions                                                                         */

int wordaddress(int n, int wordsize)
  { return ((n + wordsize - 1) / wordsize) * wordsize; }
 
void yyerror (char const *s)
{
  fprintf (stderr, "%s\n", s);
}

int main(void)          /*  */
  { 
    int res;
    initsyms();

    /* For debugging parser */
    yydebug = 1;
    
    res = yyparse();
    //printst();       /* to shorten, change to:  printstlevel(1);  */
    printstlevel(1);
    printf("yyparse result = %8d\n", res);
    if (DEBUG & DB_PARSERES) dbugprinttok(parseresult);
    ppexpr(parseresult);           /* Pretty-print the result tree */
    /* uncomment following to call code generator. */
      
    gencode(parseresult, blockoffs[blocknumber], labelnumber);
 
  }