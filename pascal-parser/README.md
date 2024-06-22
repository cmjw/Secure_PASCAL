# Pascal Parser

A parser written using yacc/bison and lexan.l lexer.

The output should show one 1 shift/reduce conflict, which is normal.

# To Build

Run build.sh

# To Run

$ ./parser

Provide an input .pas file (optional)

$ ./parse < <file.pas>

# Example

$ ./parser < ./tests/graph1.pas