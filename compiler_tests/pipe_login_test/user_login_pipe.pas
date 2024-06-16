program UserProgram;



var
  inputPassword: string;
  pipe: Text;
  
begin
  writeln('User Program');
  writeln('Please enter your password:');
  
  write('Password: ');
  readln(inputPassword);
  
  // Write the password to a pipe
  assign(pipe, 'pipe_to_privileged');
  rewrite(pipe);
  writeln(pipe, inputPassword);
  close(pipe);
  
  writeln('Password sent for verification.');
end.
