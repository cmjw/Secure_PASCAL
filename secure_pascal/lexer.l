/* Charlotte White */
/* Secure Pascal Lexer */

/*

yylval points to a TOKEN

*/

%{

#include "parser.tab.h"

#define DEBUG 1

void dprint_lexer(char *msg);

%}

/* Regular Definitions */

delim      [ \t\n]
whitespace {delim}+
letter     [A-Za-z]
digit      [0-9]
id         {letter}({letter}|{digit})*
intnumber  {digit}+
fnumber    {digit}+(\.{digit}+)?([eE][+\-]?{digit}+)?
string     '(.*?)'


%%


{whitespace} {
    /* do nothing */
}

"{" { /* Ignore  inline comments */
    while (input() != '}');
}
"(*" { /* Ignore multi-line comments */
    dprint_lexer("multi-line comment start");

    lab:
    while (input() != '*');
        int c = input();
    if (c != ')'){
        unput(c);
        goto lab;
    }

    dprint_lexer("end"); 
}



"+" {  /* Operators */
    dprint_lexer("plus");
}
"-" {
    dprint_lexer("minus");
}
"*" {
    dprint_lexer("times");
}
"/" {  
    dprint_lexer("divide");
}
":=" {
    dprint_lexer("assign");
}
"=" {
    dprint_lexer("equals");
}
"<>" {
    dprint_lexer("<>");
}
"<" { 
    dprint_lexer("lt");
}
"<=" {
    dprint_lexer("lte");
}
">=" { 
    dprint_lexer("gte");
}
">" {
    dprint_lexer("gt");
}
"^" {
    dprint_lexer("point");
}
"." { 
    dprint_lexer("dot");
}
and { 
    dprint_lexer("and");
}
or {
    dprint_lexer("or");
}
not {
    dprint_lexer("not");
}
div {
    dprint_lexer("div");
}
mod { 
    dprint_lexer("mod");
}
in {
    dprint_lexer("in");
}


"," { /* Delimiters */
    dprint_lexer("comma");
}
";" {
    dprint_lexer("semicolon");
}
":" {
    dprint_lexer("colon");
}
"(" {
    dprint_lexer("lparen");
}
")" {
    dprint_lexer("rparen");
}
"[" {
    dprint_lexer("r=lbracket");
}
"]" {
    dprint_lexer("lbracket");
}
".." {
    dprint_lexer("dotdot");
}


array { /* Reserved words */
    dprint_lexer("array");
}
begin {
    dprint_lexer("begin");
}
case { 
    dprint_lexer("case");
}
const {
    dprint_lexer("const");
}
do {
    dprint_lexer("do");
}
downto {
    dprint_lexer("do");
}
else {
    dprint_lexer("else");
}
end {
    dprint_lexer("end");
}
file {
    dprint_lexer("file");
}
for {
    dprint_lexer("for");
    //yyval = (TOKEN) talloc();
}
function {
    dprint_lexer("function");
}
goto {
    dprint_lexer("goto");
}
if {
    dprint_lexer("if");
}
label {
    dprint_lexer("label");
}
nil {
    dprint_lexer("nil");
}
of {
    dprint_lexer("of");
}
packed {
    dprint_lexer("packed");
}
procedure {
    dprint_lexer("procedure");
}
program {
    dprint_lexer("program");
}
record {
    dprint_lexer("record");
}
repeat {
    dprint_lexer("repeat");
}
set {
    dprint_lexer("set");
}
then {
    dprint_lexer("then");
}
to {
    dprint_lexer("to");
}
type {
    dprint_lexer("type");
}
until {
    dprint_lexer("until");
}
var {
    dprint_lexer("var");
}
while {
    dprint_lexer("while");
}
with {
    dprint_lexer("with");
}



{id} {
    dprint_lexer("id");
}

{string} {
    dprint_lexer("string");
}


{intnumber} {
    dprint_lexer("int number");
}

{fnumber} {
    dprint_lexer("float");
}


%%

/* Debug print lexer */
void dprint_lexer(char *msg) {
    if (DEBUG) {
        printf("(lexer) %s\n", msg);
    }
}

int yywrap() {  return(1);  }       /* lex may need this. */