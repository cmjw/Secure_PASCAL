# Build

>$ build.sh

# Run

>$ run.sh <input .pas>

# Example

>$ bash build.sh

>$ bash run.sh ../examples/simple.pas

## Lexer Only

>$ flex ./lexer.l

>$ make lexer

## Parser Only

>$ bash ./build.sh

Provide an input .pas file (optional)

>$ ./parse < <file.pas>

## Common Issues

#### WSL2 Line-Ending Issue

"$'\r': command not found"

>$ dos2unix ./build.sh

>$ dos2unix ./run.sh
