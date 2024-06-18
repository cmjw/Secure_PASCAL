/* number.c           Gordon S. Novak Jr.              21 Jan 00       */

/* Simple number conversion. */
/* 10 Jan 94  */

/* Convert an integer to binary form and store in tok */
void number (TOKEN tok)
  { long num;
    int  c, charval;
    num = 0;
    while ( (c = peekchar()) != EOF
            && CHARCLASS[c] == NUMERIC)
      {   c = getchar();
	  charval = (c - '0');
	  num = num * 10 + charval;
	}
    tok->tokentype = NUMBERTOK;
    tok->datatype = INTEGER;
    tok->intval = num;
  }
