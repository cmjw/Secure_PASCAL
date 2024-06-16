program PrivilegedProgram;

uses
  SysUtils;

const
  PASSWORD = 'pascal'; 

var
  inputPassword: string;
  pipe: Text;

begin
  writeln('Privileged Program');
  
  // Read the password from the pipe
  assign(pipe, 'pipe_to_privileged');
  reset(pipe);
  readln(pipe, inputPassword);
  close(pipe);
  
  if inputPassword = PASSWORD then
  begin
    writeln('Access granted!');
  end
  else
  begin
    writeln('Access denied!');
  end;
end.
