(* 
 * Example program 1 
 *
 * Privilege level : STRICT (compilation will fail at STRICTER/STRICTEST)
 * 
 * Communication of global variables across privilege levels
*)


program ex1(ouput); 

var i : integer;

begin
    i := 1;

    priv::begin
        writeln(i); {"1"}
        i := i + 1;
        writeln(i); {"2"}
    end;

    i := 10;
    writeln(i); {"10"}
end.