# Dependencies

flex (2.6.4)

bison (3.5.1)


# To Build Everything (WIP)

Build parser: $ bison -d parser.y

Build lexer (flex): $ flex lexer.l

OR 

$ bash ./build.sh


# Build Lexer Only

Build lexer (flex): $ flex lexer.l

Compile lexer: $ gcc -o lexer lex.yy.c -lfl

OR 

$ bash ./build_lexer.sh