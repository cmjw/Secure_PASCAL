#!/bin/bash

GREEN="\e[33m"
COLOR="\e[37m"
WHITE="\e[0m"


echo -e "${GREEN}Building lexer${WHITE}"
echo -e "${GREEN}Run ./lexer${WHITE}"

make clean

echo -e "${GREEN}Build parser (yacc/bison)${WHITE}"
bison -t -v -d parse.y

echo -e "${GREEN}Build lexer (flex)${WHITE}"
flex lexer.l

echo -e "${GREEN}Make lexer${WHITE}"
make lexer

echo -e "${GREEN}Building parser${WHITE}"
echo -e "${GREEN}Run ./parser${WHITE}"

echo -e "${GREEN}Make parser${WHITE}"
make parser


echo -e "${GREEN}Building codegen${WHITE}"

echo "TBD"