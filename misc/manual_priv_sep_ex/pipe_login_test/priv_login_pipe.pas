program PrivilegedProgram;

const
  PASSWORD = 'pascal'; 

var
  inputPassword: string;
  outputPipe, inputPipe: Text;
  outputName, inputName: string;
  res: string;

begin
  inputName := 'pipe_to_privileged';
  outputName := 'pipe_to_user';

  writeln('Privileged Program');
  
  // Read the password from the pipe
  assign(inputPipe, inputName);
  reset(inputPipe);
  readln(inputPipe, inputPassword);
  close(inputPipe);

  assign(outputPipe, outputName);
  rewrite(outputPipe);
  writeln(outputPipe, 'msg');
  close(outputPipe);

  if inputPassword = PASSWORD then
  begin
    writeln('Access granted!');
  end
  else
  begin

    writeln('Access denied!');
  end;


end.
