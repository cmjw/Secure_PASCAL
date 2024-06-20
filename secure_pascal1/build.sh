#!/bin.bash

GREEN="\e[33m"
WHITE="\e[0m"

echo -e "${GREEN}Building Secure Pascal lexer${WHITE}"

flex lexer.l

make lexer

echo -e "${GREEN}Building Secure Pascal parser${WHITE}"

echo "TBD"

echo -e "${GREEN}Building Secure Pascal codegen${WHITE}"

echo "TBD"