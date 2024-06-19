#!/bin/bash

GREEN="\e[32m"
WHITE="\e[0m"

echo "Building all files"
echo "..."


echo -ne "${GREEN}####               (33%)${WHITE}\r"
sleep 1

echo -ne "${GREEN}########           (66%)${WHITE}\r"
sleep 1

echo -ne "                          "
echo -ne '\n'

echo "..."
echo "Lexer: ./lexer"
echo "Parser: ./parser"