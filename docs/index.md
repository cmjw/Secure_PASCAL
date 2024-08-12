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

The Pascal program used as an input to be processed should be annotated by the user. A user may mark a symbol or section of code as `priv` or `unpriv`. This explicitly tells the compiler to treat a symbol or section as privileged or unprivileged, respectively.

### Appended Syntax Rules

An explicity marked `priv` symbol or section may not be referenced in an explicitly `unpriv` or implicitly unprivileged section of code, or be assigned to an unpriviliged symbol. 

An exception to this rule is if a user-defined explicilty `priv` function returns an explicily `unpriv` result, an unprivileged section or symbol may access this data.

### Security Policy Levels

In addition to the modified syntax roles imposed by privilege annotation, the user may specify a security policy level for the parser to follow. The default is strict. 

There are four security policy levels:
1. `NONE` 
* No cross-privilege restrictions. 
* Privileged data may be accessed from any lower privilege level. 
* Global data may be written or read from any privilege level.

2. `STRICT`  
* Privileged data **may not** be read or written from a lower privilege level. This excludes explicitly `unpriv` return vaues. 
* Global data **may** be read or written from any privilege level. This means global variables are shared across the two files. 
* If a file is **optionally** provided, privileged code may only reference a user-provided list of "safe" functions - all other function calls from privileged sections are disallowed.

3. `STRICTER` 
* Privileged data **may not** be read or written from a lower privilege level. This excludes explicitly `unpriv` return vaues. 
* Global data **may** be read from privileged sections of code, but **may not** be written from privileged sections. 
* If a file is **optionally** provided, privileged code may only reference a user-provided list of "safe" functions - all other function calls from privileged sections are disallowed.

4. `STRICTEST` 
* Privileged data **may not** be read or written from a lower privilege level. This excludes explicitly `unpriv` return vaues. 
* Global data **may not** be read **or** written from privileged sections or symbols. 
* The user **must** provide a file that defines a list of "safe" or "allowed" privileged functions. Privileged code may only reference a user-provided list of "safe" functions - all other function calls from privileged sections are disallowed. These "safe" functions may be user defined, in the standard library, or from an arbitrary library.

[See Parser Section](parser.md)