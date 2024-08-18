# Parser Documentation

The parser follows Pascal syntax, using the Pascal ISO 7185:1990 standard, with some minor changes.

Additionally, the parser follows the syntax of Secure Pascal annotations using the `priv` and `unpriv` keywords.

## Annotations

A user may mark a symbol (variable, constant, function name) or section of code as `priv` or `unpriv`. This explicitly tells the compiler to treat a symbol or section as privileged or unprivileged, respectively.

## Other Syntax Changes