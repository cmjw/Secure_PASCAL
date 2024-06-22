# Make lexer from lexer.l
lexer:  lex.yy.o driver.o printtoken.o token.o token.h lexer.h
	cc -o lexer lex.yy.o driver.o token.o printtoken.o

# Make driver
driver.o: driver.c token.h lexer.h
	cc -c driver.c

# Token.c
token.o: token.c token.h
	cc -c token.c

# Make parser from parser.y
parser: y.tab.o lex.yy.o printtoken.o pprint.o symtab.o token.o
	cc -o parser y.tab.o lex.yy.o printtoken.o pprint.o symtab.o token.o -ll

# pprint
pprint.o: pprint.c token.h
	cc -c pprint.c

# symtab.c
symtab.o: symtab.c token.h symtab.h
	cc -c symtab.c

# y.tab.c
y.tab.c: parser.y token.h parser.h symtab.h lexer.h
	yacc parser.y

y.tab.o: y.tab.c
	cc -c y.tab.c
        
clean: 
	rm *.o lexer lex.yy.c