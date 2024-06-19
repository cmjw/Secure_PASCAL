#!/bin/bash

echo "Build Secure Pascal project"

bison -d parser.y
flex lexer.l

gcc -o lexer lex.yy.c -lfl