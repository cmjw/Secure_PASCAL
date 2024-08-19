program Example1(ouput); 
{ must have output for now }

var i : integer;

begin
    i := 1; 

    priv::begin
        i := 0;
    priv::end; 

end.