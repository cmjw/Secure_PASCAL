program Privfunction(ouput); 
{ must have output for now }

var i, r : integer;

function privfunct(n : integer): priv::function;
var result: unpriv::integer

begin
    result := n mod 2;
end;

begin
    i := 1; 

    r := privfunct(i); { priv function call }

    writeln(r);
end.