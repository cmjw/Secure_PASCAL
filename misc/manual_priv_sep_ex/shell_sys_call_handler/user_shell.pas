program UserShell;

uses
  SysUtils, BaseUnix, Unix;

var
  input: string;
  command, args: string;
  pipeIn: array[0..1] of cint;
  pipeOut: array[0..1] of cint;
  pid: TPid;

procedure SplitCommand(input: string; var command: string; var args: string);
var
  spacePos: Integer;
begin
  spacePos := Pos(' ', input);
  if spacePos = 0 then
  begin
    command := input;
    args := '';
  end
  else
  begin
    command := Copy(input, 1, spacePos - 1);
    args := Copy(input, spacePos + 1, Length(input) - spacePos);
  end;
end;

procedure ExecuteCommand(command: string; args: string);
var
  fullCommand: string;
  buffer: array[0..1023] of char;
  bytesRead: ssize_t;
begin
  fullCommand := command;
  if args <> '' then
    fullCommand := fullCommand + ' ' + args;

  // write the command to the pipe
  fpWrite(pipeOut[1], fullCommand[1], Length(fullCommand) + 1);

  // Read the result from the pipe
  bytesRead := fpRead(pipeIn[0], buffer, SizeOf(buffer));
  if bytesRead > 0 then
    //Writeln('Result: ', PChar(@buffer));
    Writeln('Received data');
end;

begin
  // Create pipes
  if fpPipe(pipeIn) <> 0 then
  begin
    Writeln('Error creating input pipe');
    Halt(1);
  end;
  if fpPipe(pipeOut) <> 0 then
  begin
    Writeln('Error creating output pipe');
    Halt(1);
  end;

  pid := fpFork;
  if pid = 0 then
  begin
    // Child process: SysCallHandler


    // Redirect pipes
    fpClose(pipeIn[1]);
    fpClose(pipeOut[0]);

    fpDup2(pipeIn[0], 3);
    fpDup2(pipeOut[1], 4);

    fpClose(pipeIn[0]);
    fpClose(pipeOut[1]);

    // Execute SysCallHandler

    // Expected AnsiString
    fpExecLP('./syscallhandler', ['./syscallhandler', nil]);
    Halt(1); // If exec fails
  end
  else if pid > 0 then
  begin
    // Parent process: UserShell
    fpClose(pipeIn[0]);
    fpClose(pipeOut[1]);

    Writeln('Type "exit" to quit.');
    while True do
    begin
      Write('> ');
      ReadLn(input);
      SplitCommand(input, command, args);

      if command = 'exit' then
      begin
        Writeln('Exiting...');
        Halt(0);
      end;

      ExecuteCommand(command, args);
    end;
  end
  else
  begin
    Writeln('Fork failed');
    Halt(1);
  end;
end.
