(* 
 * Example program 2
 * 
 * Privilege level : STRICT (compilation will fail at STRICTER/STRICTEST)
 * 
 * Write global variables from privileged section
*)


program ex2(ouput); 
{ must have output for now }

var i : integer;

begin
    i := 1;

    priv::begin
        writeln(i);
        i := 10;
        i := 10 + 1;
        writeln(i);
    end;
end.