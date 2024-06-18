/* program 4.9 from Jensen & Wirth  -- file pastst.pas ==> pastst.c  */
/* cc driver.c pastst.c -lm       */

#include <math.h>

void write(char * s);
void writeln(char * s);

void graph1()
  { double x,y; int i,n;
   for ( i = 0; i <= 32; i++ )
      {  x = 0.0625 * i;
	 y = exp(-x) * sin(6.28318 * x);
     	 n = round( 32.0 * y) + 34;
      	 do { write(" ");
	      n = n-1;
	    }
            while ( n > 0 );
         writeln("*");
  	};
  }
