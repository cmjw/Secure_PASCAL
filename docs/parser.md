# Parser Documentation

The parser follows Pascal syntax, using the Pascal ISO 7185:1990 standard, with some minor changes.

Additionally, the parser follows the syntax of Secure Pascal annotations using the `priv` and `unpriv` keywords.

## Annotations

A user may mark a symbol (variable, constant, function name) or section of code as `priv` or `unpriv`. This explicitly tells the compiler to treat a symbol or section as privileged or unprivileged, respectively.

## Other Syntax Changes

1. The program name must be formatted as: program Example(ouput); - the output parameter list is required even if it is empty.

2. The program must follow this order: label block, constant block, type definition block, variable block, main function block, function definitions. All blocks are optional except main block.

3. The last statement in a block may optionally end with a semicolon.
