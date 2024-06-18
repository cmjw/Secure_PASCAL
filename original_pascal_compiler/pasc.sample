Example output for small test file pasc.pas:            07 Jun 94


program test(output);
type complex = record re, im: real end;
     color = (red, white, blue);
var c,d: complex; x: real; i: color;
begin
  x := c.re;
  d.re := c.im;
  i := blue
end.


Symbol table level 1

 537242376     complex  TYPE   typ 537242296  lvl  1  siz    16  off     0
(RECORD (re real)
        (im real))
 537242984         red  CONST  typ INTEGER  val             0
 537243064       white  CONST  typ INTEGER  val             1
 537243144        blue  CONST  typ INTEGER  val             2
 537243304       color  TYPE   typ 537243224  lvl  1  siz     4  off     0
  0 ..   2
 537243768           c  VAR    typ 537242296  lvl  1  siz    16  off     0
(RECORD (re real)
        (im real))
 537243848           d  VAR    typ 537242296  lvl  1  siz    16  off    16
(RECORD (re real)
        (im real))
 537244120           x  VAR    typ    real  lvl  1  siz     8  off    32
 537244392           i  VAR    typ 537243224  lvl  1  siz     4  off    40
  0 ..   2


 token 537245432  OP       program  dtype  0  link      0  operands 537241416

(program test (progn output)
              (progn (:= x (aref c 0))
                     (:= (aref d 0)
                         (aref c 8))
                     (:= i 2)))
