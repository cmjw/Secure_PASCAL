#!/bin/bash

COLOR="\e[34m"
WHITE="\e[0m"

echo "Input: $1";

echo -e "${COLOR}Begin lexer${WHITE}"

./lexer < $1

echo -e "${COLOR}End lexer${WHITE}"

COLOR="\e[35m"

echo -e "${COLOR}Begin parser${WHITE}"

./parser < $1

echo -e "${COLOR}End parser${WHITE}"