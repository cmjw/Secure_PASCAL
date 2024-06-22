#!/bin.bash

GREEN="\e[33m"
WHITE="\e[0m"

echo -e "${GREEN}Building lexer (./lexer)${WHITE}"
bison -d parser.y
flex lexer.l

make lexer

echo -e "${GREEN}Building parser (./parser)${WHITE}"



make parser

echo "TBD"

echo -e "${GREEN}Building codegen${WHITE}"

echo "TBD"