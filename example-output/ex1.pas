program simple(ouput); 
{ must have output for now }

var i : integer;

begin
    i := 1;

    priv::begin
        writeln(i);
        i := i * 10;
        writeln(i);
    end;
end.