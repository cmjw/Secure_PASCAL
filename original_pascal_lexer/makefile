# makefile - Used to make CS 375 compiler in C
#   21 Sep 04; 07 Feb 17; 11 Jan 18; 06 Oct 21
#
# Gordon S. Novak Jr.
#
# token.h is assumed to be a local file because on some machines
# or yacc versions tokenb.h must be used instead (renamed token.h).

# To compile starter file lex1.c --> lex1
# 
lex1:   lexandr.o lex1.o scanner.o printtoken.o token.h lexan.h
	cc -o lex1 lexandr.o lex1.o scanner.o printtoken.o -lm

# To compile your file lexanc.c --> lexanc
# 
lexanc:  lexandr.o lexanc.o scanner.o printtoken.o token.h lexan.h
	cc -o lexanc lexandr.o lexanc.o scanner.o printtoken.o -lm

# To compile your file lexan.l --> lexer
# 
lexer:  lex.yy.o lexanl.o printtoken.o token.h lexan.h
	cc -o lexer lex.yy.o lexanl.o printtoken.o

# To compile starter file lex2.l --> lex2
# 
lex2:   lex2.yy.o lexanl.o printtoken.o token.h lexan.h
	cc -o lex2 lex2.yy.o lexanl.o printtoken.o

# To compile starter file lexasu.l --> lexasu
# 
lexasu:   lexasu.o
	cc -o lexasu lexasu.o -ll

# To compile starter file pars1.c --> pars1c
#     using your file lexanc.c
pars1c: pars1c.o lexanc.o scanner.o printtoken.o pprint.o symtab.o
	cc -o pars1c pars1c.o lexanc.o scanner.o printtoken.o pprint.o symtab.o

# To compile your file parsc.c --> parsec
#     using your file lexanc.c
parsec: parsc.o lexanc.o scanner.o printtoken.o pprint.o symtab.o
	cc -o parsec parsc.o lexanc.o scanner.o printtoken.o pprint.o symtab.o

# To compile starter file pars1.y --> pars1y
#      using your file lexan.l
pars1y: pars1.tab.o lex.yy.o printtoken.o pprint.o symtab.o
	cc -o pars1y pars1.tab.o lex.yy.o printtoken.o pprint.o symtab.o -ll

# To compile your file parse.y --> parser
#      using your file lexan.l
parser: y.tab.o lex.yy.o printtoken.o pprint.o symtab.o
	cc -o parser y.tab.o lex.yy.o printtoken.o pprint.o symtab.o -ll

# To compile starter file codgen.c --> comp1y
#      using your files lexan.l and parse.y
comp1y: y.tab.o lex.yy.o printtoken.o pprint.o symtab.o codgen.o genasm.o
	cc -o comp1y y.tab.o lex.yy.o printtoken.o pprint.o symtab.o codgen.o \
            genasm.o

# To compile your file codegen.c --> compiler
#      using your files lexan.l and parse.y
compiler: y.tab.o lex.yy.o printtoken.o pprint.o symtab.o codegen.o genasm.o
	cc -o compiler y.tab.o lex.yy.o printtoken.o pprint.o symtab.o \
             codegen.o genasm.o

# To compile starter file codgen.c --> comp1c
#      using your files lexanc.c and parsc.c
comp1c: parsc.o lexanc.o scanner.o printtoken.o pprint.o symtab.o codgen.o \
           genasm.o
	cc -o comp1c parsc.o lexanc.o scanner.o printtoken.o pprint.o \
           symtab.o codgen.o genasm.o

# To compile your file codegen.c --> compc
#      using your files lexanc.c and parsc.c
compc: parsc.o lexanc.o scanner.o printtoken.o pprint.o symtab.o codegen.o \
           genasm.o
	cc -o compc parsc.o lexanc.o scanner.o printtoken.o pprint.o \
              symtab.o codegen.o genasm.o

# To compile your file codegenb.c --> compb
#      using your files lexan.l and parse.y
compb: y.tab.o lex.yy.o printtoken.o pprint.o symtab.o codegenb.o  genasm.o
	cc -o compy y.tab.o lex.yy.o printtoken.o pprint.o symtab.o \
           codegenb.o genasm.o

lexandr.o: lexandr.c token.h lexan.h
	cc -c lexandr.c

lexanl.o: lexanl.c token.h lexan.h
	cc -c lexanl.c

lex1.o: lex1.c token.h lexan.h
	cc -c lex1.c

lexanc.o: lexanc.c token.h lexan.h
	cc -c lexanc.c

scanner.o: scanner.c token.h lexan.h
	cc -c scanner.c

printtoken.o: printtoken.c token.h
	cc -c printtoken.c

symtab.o: symtab.c token.h symtab.h
	cc -c symtab.c

pars1c.o: pars1c.c lexan.h token.h symtab.h parse.h
	cc -c pars1c.c -o pars1c.o

parsc.o: parsc.c lexan.h token.h symtab.h parse.h
	cc -c parsc.c

pprint.o: pprint.c token.h
	cc -c pprint.c

genasm.o: genasm.c token.h symtab.h genasm.h
	cc -c genasm.c

codgen.o: codgen.c token.h symtab.h genasm.h
	cc -c codgen.c

codegen.o: codegen.c token.h symtab.h genasm.h
	cc -c codegen.c

codegenb.o: codegenb.c token.h symtab.h genasm.h
	cc -c codegenb.c

lex.yy.o: lex.yy.c
	cc -c lex.yy.c

lex.yy.c: lexan.l token.h
	lex lexan.l

lex2.yy.o: lex2.yy.c
	cc -c lex2.yy.c

lex2.yy.c: lex2.l token.h lexan.h
	lex -t lex2.l | cat >lex2.yy.c

y.tab.c: parse.y token.h parse.h symtab.h lexan.h
	yacc parse.y

y.tab.o: y.tab.c
	cc -c y.tab.c

pars1.tab.c: pars1.y token.h parse.h symtab.h lexan.h
	yacc -b pars1 pars1.y

pars1.tab.o: pars1.tab.c
	cc -c pars1.tab.c
