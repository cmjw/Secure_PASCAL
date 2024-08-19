{ Secure Pascal : Generated Privileged Program }
program PrivProg(ouput);

var i : integer; outputPipe, inputPipe: Text; outputName, inputName: string; 

begin
{ initialize vars for interprocess communication }
inputName := 'pipe_to_user';
outputName := 'pipe_to_priv';

if i = 0 then
writeln(i);

writeln('priv: done');
end.