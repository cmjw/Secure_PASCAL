#include <stdio.h>
#include "ast.h"

AstNode *root = NULL;

extern int yyparse();
extern FILE *yyin;

int main() {
    yyin = stdin;

    while (1) {
        printf("Enter expression: ");
        yyparse();

        if (root != NULL) {
            printf("AST:\n");
            print_ast(root, 0);
           
            printf("Result: %d\n", evaluate_ast(root));
        } else {
            printf("No valid expression parsed.\n");
        }
    }

    return 0;
}

int evaluate_ast(AstNode *node) {
    if (node == NULL) return 0;

    switch (node->type) {
        case AST_INTEGER:
            return node->data.int_value;
        case AST_BINARY_OP:
            switch (node->data.binary_op.operator) {
                case '+':
                    return evaluate_ast(node->data.binary_op.left) + evaluate_ast(node->data.binary_op.right);
                case '-':
                    return evaluate_ast(node->data.binary_op.left) - evaluate_ast(node->data.binary_op.right);
                default:
                    fprintf(stderr, "Unknown operator %c\n", node->data.binary_op.operator);
                    return 0;
            }
        default:
            fprintf(stderr, "Unknown node type\n");
            return 0;
    }
}
