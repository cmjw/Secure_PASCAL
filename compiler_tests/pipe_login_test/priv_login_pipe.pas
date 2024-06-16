program PrivilegedProgram;

const
  PASSWORD = 'pascal'; 

var
  inputPassword: string;
  outputPipe, inputPipe: Text;

begin
  writeln('Privileged Program');
  
  // Read the password from the pipe
  assign(inputPipe, 'pipe_to_privileged');
  reset(inputPipe);
  readln(inputPipe, inputPassword);
  close(inputPipe);

  assign(outputPipe, 'pipe_to_user');
  reset(outputPipe);

  if inputPassword = PASSWORD then
  begin
    writeln(outputPipe, 'granted');
    writeln('Access granted!');
  end
  else
  begin
    writeln(outputPipe, 'denied');
    writeln('Access denied!');
  end;
  close(outputPipe);
end.
