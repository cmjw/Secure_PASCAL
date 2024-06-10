program SysCallHandler;

uses
  SysUtils, BaseUnix, Unix, UnixType;

var
  buffer: array[0..1023] of char;
  bytesRead: ssize_t;
  pipeIn, pipeOut: array[0..1] of cint;

procedure ExecuteCommand(fullCommand: string);
var
  output: string;
begin
  if fullCommand = '' then Exit;

  // Handling 'cd' separately since it is not an external command
  if Pos('cd ', fullCommand) = 1 then
  begin
    Delete(fullCommand, 1, 3);
    if FpChdir(Trim(fullCommand)) = 0 then
      output := 'Directory changed to ' + GetCurrentDir
    else
      output := 'Error: Directory not found';
  end
  else
  begin
    // Execute the command using the shell
    output := fpSystem(fullCommand);
  end;

  // Write the result to the output pipe
  fpWrite(pipeOut[1], output[1], Length(output) + 1);
end;

begin
  // Assuming that the pipes are already created and passed via fork-exec mechanism
  // fd 3 and fd 4 are used for communication
  pipeIn[0] := 3;
  pipeOut[1] := 4;

  while True do
  begin
    // Read the command from the input pipe
    bytesRead := fpRead(pipeIn[0], buffer, SizeOf(buffer));
    if bytesRead > 0 then
    begin
      ExecuteCommand(PChar(@buffer));
    end;
  end;
end.
