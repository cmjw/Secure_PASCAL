program simple(ouput); 
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