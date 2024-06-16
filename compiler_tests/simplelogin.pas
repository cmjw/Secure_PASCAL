program SimpleLogin;

const   
  {privileged} PASSWORD = 'pascal'; 

var
  inputPassword: string;
  attempts: integer;
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
    {  }
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
