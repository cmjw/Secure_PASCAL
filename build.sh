#!/bin/bash
echo "================================="
date
echo "Compiling shell.pas"
echo "Using Free Pascal Compiler (fpc)"
echo "================================="
echo ""
fpc shell.pas
fpc user_shell
fpc sys_call_handler

#named pipes
mkfifo pipeIn
mkfifo pipeOut

./syscallhandler < pipeIn > pipeOut &

./usershell

rm pipeIn pipeOut
