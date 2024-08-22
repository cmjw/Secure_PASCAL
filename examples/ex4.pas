(* 
 * Example program 4
 * 
 * Security policy level : STRICT or above

 * example1 must be in library list and/or safe list.
 * example2 must be in safeist.
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