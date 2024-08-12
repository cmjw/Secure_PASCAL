# Documentation

## Introduction

The Secure Pascal Project is written primarily in C, using bison and flex.

The goal of the project is to demonstrate the mechanics and benefits of automated privilege separation, specifically in the context of Pascal programming. Pascal is the language of choice for this project because it is a strongly-typed language with less ambiguity in its syntax and semantics.

In this demonstration of privilege separation, the desired function is to provide one annotated Pascal program, and receive two unannotated, standard Pascal programs: one "user" and one "privileged" program. 

The input file is lexed and parsed as an annotated Pascal file, and the resulting AST is used to generate two standard Pascal output files.

### Dependencies

gcc 9.5.0
bison 
flex

## Build Instructions

[See Build Section](build.md)

## Lexer Documentation

The lexer is written in flex/lex. Input tokens are identified as TOKENs. More detailed information can be found in the documentation of the lexer files, listed below.

[See Lexer Section](lexer.md)

## Parser Documentation

The parser is written in bison/yacc in C. The parser was built referencing standard Pascal syntax, with some modifications for user annotations.

### Annotations

The Pascal program used as an input to be processed should be annotated by the user. A user may mark a symbol or section of code as "priv" or "unpriv". This explicitly tells the compiler to treat a symbol or section as privileged or unprivileged, respectively.

### Appended Syntax Rules

An explicity marked "priv" symbol or section may not be referenced in an explicitly "unpriv" or implicitly unprivileged section of code, or be assigned to an unpriviliged symbol. 

An exception to this rule is if a user-defined explicilty "priv" function returns an explicily "unpriv" result, an unprivileged section or symbol may access this data.

[See Parser Section](parser.md)