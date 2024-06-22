program UserProgram;

var
  inputPassword: string;
  res: string;
  outputPipe, inputPipe: Text;
  outputName, inputName: string;
  
begin
  outputName := 'pipe_to_privileged';
  inputName := 'pipe_to_user';

  writeln('User Program');
  writeln('Please enter your password:');
  
  write('Password: ');
  readln(inputPassword);
  
  // Write the password to a pipe
  assign(outputPipe, outputName);
  rewrite(outputPipe);
  writeln(outputPipe, inputPassword);
  close(outputPipe);
  
  writeln('Password sent for verification.');
  
  assign(inputPipe, inputName);
  reset(inputPipe);
  readln(inputPipe, res);
  close(inputPipe);

  writeln('Received ', res);

end.
