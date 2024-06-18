{ Compute a square root by Newton's method  -- file passqrt.pas }

program graph1(output);
var  s, x: real; i: integer;
begin
   s := 3.0;
   x := 1.0;
   for i:=1 to 5 do
       x := 0.5 * (x + s/x);
   writelnf(x)
end.
