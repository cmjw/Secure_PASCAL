#!/bin/bash

GREEN="\e[33m"
COLOR="\e[37m"
WHITE="\e[0m"


echo -e "${GREEN}Building lexer${WHITE}"
echo -e "${GREEN}Run ./lexer${WHITE}"

make clean

echo -e "${GREEN}Build parser (yacc/bison)${WHITE}"
bison -d parse.y

echo -e "${GREEN}Build lexer (flex)${WHITE}"
flex lexer.l

echo -e "${GREEN}Make lexer${WHITE}"
make CC=gcc-9 lexer

echo -e "${GREEN}Building parser${WHITE}"
echo -e "${GREEN}Run ./parser${WHITE}"

echo -e "${GREEN}Make parser${WHITE}"
make CC=gcc-9 parser

echo -e "${GREEN}Building codegen${WHITE}"

echo -e "${GREEN}USAGE: ${WHITE}"
echo -e "${GREEN}bash ./run.sh <input .pas>${WHITE}"
