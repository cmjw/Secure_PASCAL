
typedef struct dtoi {
union {double dbl; long iarr[2]; } val; } Dtoi;

Dtoi dtoitmp;

/* Get half words of a double float */
long lefth(d)
  double d;
  {  dtoitmp.val.dbl = d;
     return ( dtoitmp.val.iarr[0]); }

long righth(d)
  double d;
  {  dtoitmp.val.dbl = d;
     return ( dtoitmp.val.iarr[1]); }

