program Privfunction(ouput); 
{ must have output for now }

var i, r : integer;

priv::function privfunct(n : integer): unpriv::integer
var result: unpriv::integer { integer }

begin
    result := n mod 2;
end;

begin
    i := 1; 

    r := privfunct(i); { priv function call }

    { syntax error if assigning to unpriv variable a priv variable }

    writeln(r);
end.