#!/bin/bash

rm pipe_to_priv
rm pipe_to_user
rm priv
rm user
echo "Creating Named Pipes ..."
mkfifo "pipe_to_priv"
mkfifo "pipe_to_user"

echo "Compiling Final Priv/User Progs ..."
fpc priv.pas
fpc user.pas
echo "Running Priv Program ..."
./priv &
./user &
echo "Running User Program ..."
echo "Removing Named Pipes ..."
rm pipe_to_priv
rm pipe_to_user
