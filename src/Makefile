
# Make lexer from lexan.l
lexer:  lex.yy.o driver.o printtoken.o token.h lexer.h
	gcc -o lexer lex.yy.o driver.o printtoken.o

# Make support from driver.c
driver.o: driver.c token.h lexer.h
	gcc -c driver.c

# Make parser from parse.y
parser: y.tab.o lex.yy.o printtoken.o pprint.o symtab.o codegen.o genasm.o
	gcc -o parser y.tab.o lex.yy.o printtoken.o pprint.o symtab.o -ll \
             codegen.o genasm.o

# codegen.c
codegen.o: codegen.c token.h symtab.h genasm.h codegen-utils.h
	gcc -c codegen.c

# codegen-utils.c
codegen-utils.o: codegen-utils.c token.h symtab.h genasm.h
	gcc -c codegen-utils.c

# genasm.c
genasm.o: genasm.c token.h symtab.h genasm.h
	gcc -c genasm.c

# bison files
pars1.tab.o: pars1.tab.c
	gcc -c pars1.tab.c

# pprint.c
pprint.o: pprint.c token.h
	gcc -c pprint.c

# symtab.c
symtab.o: symtab.c token.h symtab.h
	gcc -c symtab.c

# lexer files
y.tab.c: parse.y token.h parse.h symtab.h lexer.h
	yacc parse.y
y.tab.o: y.tab.c
	gcc -c y.tab.c

clean: 
	rm *.o lexer parser y.tab.c lex.yy.c parse.tab.c parse.tab.h
