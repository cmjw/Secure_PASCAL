(* 
 * Example program 0 
 * Simple privileged block, "privblock"
*)

program ex0(ouput); 

var i : integer;

begin
    i := 1;

    priv::begin
        writeln(i); {"1"}
    end;
end.