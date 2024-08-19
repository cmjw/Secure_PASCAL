# About

Secure Pascal is a privilege-separating compiler for Pascal programs. Compilation of one annotated Pascal program will generate two privilege-separated Pascal programs: a user-level program (user.pas), and a privileged program (priv.pas).

For more in-depth documentation and instructions, see https://cmjw.github.io/Secure_PASCAL/.

# Build

Requires gcc 9.5.0

The build script assumes the environment has the executables `gcc-9` and `g++-9`, differentiated from `gcc`.

>$ cd src
>$ bash build.sh

# Example Usage

>$ cd src

>$ bash build.sh

>$ bash run.sh ../examples/ex0.pas

# Examples

The examples directory contains sample .pas files.
