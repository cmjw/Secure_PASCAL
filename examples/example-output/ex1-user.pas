{ Secure Pascal : Generated User Program }
program UserProgam(ouput);

var i : integer; outputPipe, inputPipe: Text; outputName, inputName: string; 

begin
{ initialize vars for interprocess communication }
inputName := 'pipe_to_privileged';
outputName := 'pipe_to_user';

i := 1;

{ Send value of i to PrivProg }
assign(outputPipe, outputName);
rewrite(outputPipe);
write(outputPipe, i);
close(outputPipe);
end.