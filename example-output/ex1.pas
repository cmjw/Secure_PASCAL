program simple(ouput); 
{ must have output for now }

var i : integer;

begin
    i := 1;

    priv::begin
        writeln(i); {"1"}
        i := i + 1;
        writeln(i); {"2"}
    end;
end.