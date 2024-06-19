/* Charlotte White */
/* Token Declarations */

/* Token data structure */
typedef struct tok {
    int tokentype;
    int basicdt;
    struct symtbr * symtype;
    struct symtbr * symentry;
    struct tok * operands;
    struct tok * link;
    union {
        char tokenstring[16];
        int which;
        
    }
} *TOKEN;