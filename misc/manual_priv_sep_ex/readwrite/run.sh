#!/bin/bash

rm pipe1
rm pipe2

echo "Creating Named Pipes .."

mkfifo "pipe1"
mkfifo "pipe2"

fpc readwrite.pas < dev/null
fpc writeread.pas < dev/null

echo "Running Programs ..."

./readwrite &

./writeread &

echo "Execution Complete ..."

echo "Removing Pipes ..."

rm pipe1
rm pipe2