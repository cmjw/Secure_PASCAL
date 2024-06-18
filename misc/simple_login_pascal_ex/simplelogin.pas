program SimpleLogin;

const   
  {privileged} PASSWORD = 'pascal'; 
  { moved entirely to priv program}

var
  inputPassword: string;
  authenticated: boolean;

begin
  authenticated := false;

  writeln('Simple Password Login Program');
  writeln('---------------------------------');

  while (not authenticated) do
  begin
    write('Enter your password: ');
    readln(inputPassword);

    { move to privileged function that returns bool }
    { inputPassword is a privileged constant }
    { this expression is bool := logical expression: [unpriv string] = [priv string] }
    { two options: 1. send password to priv to check, send back answer; 2. send, auth is done in priv}
    { if (...) then becomes }
    { if (bool received from priv) then }
    { and priv program gets line checking input from unpriv, and sends back bool } 
    if inputPassword = PASSWORD then
    begin
      authenticated := true;
      writeln('Access granted!');
    end
    else
    begin
      writeln('Incorrect password.');
    end;
  end;

  readln;
end.
