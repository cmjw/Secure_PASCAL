program UserProgram;

var
  inputPassword: string;
  res: string;
  outputPipe, inputPipe: Text;
  
begin
  writeln('User Program');
  writeln('Please enter your password:');
  
  write('Password: ');
  readln(inputPassword);
  
  // Write the password to a pipe
  assign(outputPipe, 'pipe_to_privileged');
  rewrite(outputPipe);
  writeln(outputPipe, inputPassword);
  close(outputPipe);
  
  writeln('Password sent for verification.');
  reset(inputPipe);

  assign(inputPipe, 'pipe_to_user');
  readln(inputPipe, res);
  writeln(res);

end.
