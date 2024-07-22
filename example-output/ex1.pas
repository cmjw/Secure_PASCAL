program simple(ouput); 
{ must have output for now }

var i : integer;

begin
    i := 1;

    priv::begin
        writeln(i);
        writeln(i);
        writeln('*');
    end;
end.