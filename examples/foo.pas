program simple(ouput); 
{ must have output for now }

var i : integer;

begin
    i := 1; { last statement has no end semicolon }
end { no dot }

function foo(jo : integer;): integer;
var result : integer;
begin
    jo := 0;
end;

priv::function bar(jo : integer;): integer;
var result : integer;
begin
    jo := 0;
end;
