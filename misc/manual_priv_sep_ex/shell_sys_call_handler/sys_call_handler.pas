program SysCallHandler;

uses
  SysUtils, BaseUnix, Unix, UnixType;

var
  buffer: array[0..1023] of char;
  bytesRead: ssize_t;

procedure ExecuteCommand(fullCommand: string);
var
  output: string;
  outputBytes: LongInt;
begin
  if fullCommand = '' then Exit; // Halt?

  // cd 
  if Pos('cd ', fullCommand) = 1 then
  begin
    //Delete(fullCommand, 1, 3);
    if FpChdir(Trim(fullCommand)) = 0 then
      output := 'Directory changed to ' + GetCurrentDir
    else
      output := 'Error: Directory not found';
  end

  // all other commands
  else
  begin
    output := 'Command executed: ' + fullCommand;
    outputBytes := fpSystem(fullCommand);
    Str(outputBytes, output);

    if ExecuteProcess('/bin/sh', ['-c', fullCommand]) <> 0 then
      Writeln('Error');
  end;

  // Write the result to the output pipe
  fpWrite(4, output[1], Length(output) + 1);
end;

begin
  while True do
  begin
    // Read the command from the input pipe
    bytesRead := fpRead(3, buffer, SizeOf(buffer));
    if bytesRead > 0 then
    begin
      Writeln('Executing command');
      //ExecuteCommand(PChar(@buffer));
    end;
  end;
end.