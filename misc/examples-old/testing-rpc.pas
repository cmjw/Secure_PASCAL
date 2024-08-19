program simple(ouput); 
{ must have output for now }

var i : integer;

begin
    i := 1; { last statement has no end semicolon }

    priv::begin
        writelni(i);
    end;
end.