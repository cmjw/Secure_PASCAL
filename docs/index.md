# Documentation

## Introduction

The Secure Pascal Project is written primarily in C, using bison and flex.

The goal of the project is to demonstrate the mechanics and benefits of automated privilege separation, specifically in the context of Pascal programming. Pascal is the language of choice for this project because it is a strongly-typed language with less ambiguity in its syntax and semantics.

In this demonstration of privilege separation, the desired function is to provide one annotated Pascal program, and receive two unannotated, standard Pascal programs: one "user" and one "privileged" program. 

### Dependencies

gcc 9.5.0
bison 
flex

## Build Instructions

[See Build Section](build.md)

## Lexer Documentation

[See Lexer Section](lexer.md)
