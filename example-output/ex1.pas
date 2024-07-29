program simple(ouput); 
{ must have output for now }

var i : integer;

begin
    i := 1;

    priv::begin
        writeln(i); {"1"}
        i := 10;
        writeln(i); {"10"}
    end;
end.