#!/bin/bash

echo "Building Lexer"
echo "..."

flex lexer.l
gcc -o lexer lex.yy.c -lfl


echo "Run ./lexer"