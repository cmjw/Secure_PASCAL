# To Build

bison -d parser.y
flex lexer.l

OR 

bash ./build.sh

# Build Lexer Only

flex lexer.l
gcc -o lexer lex.yy.c -lfl