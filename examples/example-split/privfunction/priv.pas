program Priv(param); 

var i, r, output : integer;

function privfunct(n : integer): priv::function;
var result: unpriv::integer

begin
    result := n mod 2;
end;

begin
    { wait for signal from user }

    { recieve i }
    i := { signal from user }

    output := privfunct(i);

    { send output to user }
end.