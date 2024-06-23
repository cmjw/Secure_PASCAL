# Make lexer from lexan.l
lexer:  lex.yy.o driver.o printtoken.o token.o token.h lexer.h
	cc -o lexer lex.yy.o driver.o token.o printtoken.o

# Make support from lexanl.c
driver.o: driver.c token.h lexer.h
	cc -c driver.c

# Token.c
token.o: token.c token.h
	cc -c token.c

clean: 
	rm *.o lexer lex.yy.c