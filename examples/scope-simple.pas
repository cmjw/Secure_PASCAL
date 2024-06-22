program Simple;

{ priv, privileged, prv, p }
{ unpriv, unprivileged, unprv, up }
{ don't want confusion with "private"/ "priv" }

var i : priv::integer;

begin
    i := 1;
end;

{ in this case the entire program -> privileged program, since nothing
can be execute in user mode }