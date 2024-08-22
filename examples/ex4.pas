(* 
 * Example program 4
 * 
 * Security policy level : STRICT or above
 * Safe list: empty
 *
 * Invalid function name
*)

program ex4(ouput); 

var i : integer;

begin
    example1(i); { will not fail }
    priv::begin
        i := 1;
        priv::example2(i); { compiler will fail here }
    end;
end.