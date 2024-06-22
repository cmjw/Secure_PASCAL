/* Definitions */

%{
    
    
%}

/* Rules */

%%

[a-z] {
    printf("1 lowercase\n");
}

. {
    printf("Something else\n");
}

\n { return 0; } 
    
%%

yywrap() {
}

int main() {
    printf("Enter input: ");
    yylex();

    return 0;
}

