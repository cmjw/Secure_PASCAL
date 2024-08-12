program simple(ouput); 
{ must have output for now }

var i : integer;

const priv::secret = 12;

begin
    i := 1; 

    foo(i);
end 

function foo(j : integer;): integer;
var result : integer;
begin
    j = j + 1;

    bar(j);
end;

priv::function bar(k : integer;): integer;
var result : integer;
begin
    k := k * secret;

    if k > 10 then  
        writeln(i);
end;

{++++++++++++++++++++++++++++++++++++++++++++++++}

{priv.pas}

var i : integer;

const secret = 12;

begin
    {because foo in user calls bar, recieve value of k}
    {recieve k from user}
    bar(k);
end.

function bar(k : integer;): integer;
var result : integer;
begin
    {receive i}
    k := k * secret;

    if k > 10 then  
        writeln(k);
end;

{++++++++++++++++++++++++++++++++++++++++++++++++}

{user.pas}

var i : integer;

begin
    i := 1; 

    foo(i);
end.

function foo(j : integer;): integer;
var result : integer;
begin
    j = j + 1;

    bar(j); {call to priv}
    {communicate j to priv}
end;


{NOTE if foo had been called by bar (priv) or in a priv block, this unpriv
function would be placed also in the priv program}