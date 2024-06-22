# lexer.l

Consumes input, returns result as the TOKEN yylval.

## int make_token(int tokentype, int whichtoken)

Creates a general token. Handles operators, delimiters, and reserved words.

### int tokentype
Token type, defined in token.h

### int whichtoken
Which actual token, defined in token.h

## int make_identifiertok()

Make a token for an identifier.

## int make_stringtok()

Make a token for a string.

## int make_integertok()

Make a token for an integer number.

## int make_floattok()

Make a token for a floating point number.