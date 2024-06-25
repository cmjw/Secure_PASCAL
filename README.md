# Secure Pascal

The src directory contains the main project code and build instructions.

## Example Usage

>$ cd /src

>$ bash build.sh

>$ bash run.sh ../examples/simple.pas

# Examples

The examples directory contains sample .pas files to test the lexer and parser.

# Notes about Pascal

For now, Pascal input files must follow some rules in regards to format to be considered 
syntactically "correct".

1. The program name must be formatted as: program Example(ouput); - the output parameter list is required even if it is empty.
2. The header must follow this order: lblock (labels), cblock (constant declarations), tblock (type declarations), vblock (variable declarations)
3. The last statement in a block may optionally end with a semicolon

# Documentation

A work in progress.

Located at https://cmjw.github.io/Secure_PASCAL/.

# Original Pascal Compiler 

I moved these files to another repo to keep this one organized:
https://github.com/cmjw/PASCAL_Compiler_Project

All lexer and parser files/proejcts are built, and there are detailed build instructions in this repo. 
