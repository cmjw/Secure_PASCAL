{ Secure Pascal : Generated Privileged Program }
program PrivProg(ouput);

var i : integer; outputPipe, inputPipe: Text; outputName, inputName: string; 

begin
{ initialize vars for interprocess communication }
inputName := 'pipe_to_user';
outputName := 'pipe_to_privileged';

{ Wait for value of i from UserProg }
assign(inputPipe, inputName);
reset(inputPipe);
readln(inputPipe, i);
close(inputPipe);

writelni(i);
end.