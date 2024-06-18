#ifndef AST_H
#define AST_H

typedef enum {
    AST_INTEGER,
    AST_BINARY_OP
} NodeType;

typedef struct AstNode {
    NodeType type;
    union {
        int int_value;
        struct {
            struct AstNode *left;
            struct AstNode *right;
            char operator;
        } binary_op;
    } data;
} AstNode;

#endif
