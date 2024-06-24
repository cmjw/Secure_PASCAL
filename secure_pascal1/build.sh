#!/bin/bash


GREEN="\e[33m"
WHITE="\e[0m"

echo -e "${GREEN}Building lexer (./lexer)${WHITE}"

flex lexer.l

make lexer

echo -e "${GREEN}Building parser (./parser)${WHITE}"

echo "TBD"

echo -e "${GREEN}Building codegen${WHITE}"

echo "TBD"