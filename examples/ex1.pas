(* 
 * Example program 1
 * 
 * Privilege level : STRICT (compilation will fail at STRICTEST)
 * 
 * Write global variables from privileged section
*)

program ex1(ouput); 

var i : integer;

begin
    i := 0;

    priv::begin
        if i = 0 then
            writeln(i); { "0" }
    end;
end.