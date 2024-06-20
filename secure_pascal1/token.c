/* Token functions */

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include "token.h"

/* Allocate a new token record */
TOKEN talloc() { 
    TOKEN tok;
    tok = (TOKEN) calloc(1,sizeof(struct tokn));
    if ( tok != NULL ) return (tok);
       else printf("talloc failed.");
}