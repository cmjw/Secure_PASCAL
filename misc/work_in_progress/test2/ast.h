#ifndef AST_H
#define AST_H

typedef enum {
    AST_INTEGER,
    AST_FLOAT,
    AST_BINARY_OP,
    AST_PARENTHESES
} NodeType;

typedef struct AstNode {
    NodeType type;
    union {
        int int_value;
        float float_value;
        struct {
            struct AstNode *left;
            struct AstNode *right;
            int operator;
        } op;
    } data;
} AstNode;

#endif /* AST_H */
