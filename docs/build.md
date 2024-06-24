# Build Instructions

## Dependencies

lex/flex

yacc/bison

## Build Everything

To build everything, navigate to /src and run 

> bash ./build.sh

Then run either

> ./lexer 

or

> ./parser

## Build Manually

To build manually without using the build script, run:

> bison -d parse.y

> flex lexer.l

> make lexer

> make parser