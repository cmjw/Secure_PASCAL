program Example1(ouput); 
{ must have output for now }

var i : integer;

begin
    i := 1; 
    i := 1; { last statement has no end semicolon }

    priv::begin
        i := 1; 
    priv::end.
end.