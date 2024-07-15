program simple(ouput); 
{ must have output for now }

var i : priv::integer;

begin
    i := 1; { last statement has no end semicolon }

    priv::begin
        i:=0;
    end;
end.