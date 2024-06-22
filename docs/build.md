# Build Instructions

## Build Everything

To build everything, navigate to /secure_pascal and run 

bash ./build.sh

Then run either

./lexer or ./parser

## Build Manually

To build manually without using the build script, run:

bison -d parser.y

flex lexer.l

make lexer

make parser