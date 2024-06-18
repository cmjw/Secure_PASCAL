%{
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"

extern int yylex();
extern int yyerror(const char *s);

// simple case of integer binary op

AstNode *create_integer_node(int value);
AstNode *create_binary_op_node(AstNode *left, AstNode *right, int operator);

extern AstNode *root = NULL;  

%}

%union {
    int ival;
    AstNode *ast_node;
}

%token<ival> T_INT
%token T_PLUS T_MINUS T_END

%type<ast_node> expression

%start calculation

%%

calculation:
    | calculation expression T_END { root = $2; }
    | calculation T_END { root = NULL; }
;

expression:
      T_INT          { $$ = create_integer_node($1); }
    | expression T_PLUS expression  { $$ = create_binary_op_node($1, $3, '+'); }
    | expression T_MINUS expression { $$ = create_binary_op_node($1, $3, '-'); }
;

%%

/* AST Integer node */
AstNode *create_integer_node(int value) {
    AstNode *node = (AstNode *)malloc(sizeof(AstNode));
    node->type = AST_INTEGER;
    node->data.int_value = value;
    return node;
}

/* AST Binary Op */
AstNode *create_binary_op_node(AstNode *left, AstNode *right, int operator) {
    AstNode *node = (AstNode *)malloc(sizeof(AstNode));
    node->type = AST_BINARY_OP;
    node->data.binary_op.left = left;
    node->data.binary_op.right = right;
    node->data.binary_op.operator = operator;
    return node;
}

/* Print the whole AST */
void print_ast(AstNode *node, int indent) {
    if (node == NULL) return;

    switch (node->type) {
        case AST_INTEGER:
            printf("%*sInteger: %d\n", indent, "", node->data.int_value);
            break;
        case AST_BINARY_OP:
            printf("%*sOperator: %c\n", indent, "", node->data.binary_op.operator);
            print_ast(node->data.binary_op.left, indent + 4);
            print_ast(node->data.binary_op.right, indent + 4);
            break;
        default:
            printf("%*sUnknown node type\n", indent, "");
            break;
    }
}

/* void yyerror(const char* s) {
    fprintf(stderr, "Parse error: %s\n", s);
    exit(1);
} */
