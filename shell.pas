program Shell;

uses
    SysUtils, BaseUnix;

var
    input: string;
    command: string;
    args: string;


// Split a command line
procedure Split_Line(input: string; var command: string; var args: string);
var
    spacePos: Integer;
begin
    spacePos := Pos(' ', input);

    // no spaces, i.e. no args
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

// Execute a command
procedure Execute_Command(command: string; args: string);
var
    fullCommand: string;
begin
    if command = 'exit' then
    begin
        writeln('Exiting...');
        Halt(0);
    end

    else if command = 'cd' then
    begin 
        if FpChdir(args) = 0 then
            writeln('Directory changed to ', GetCurrentDir)
        else
            writeln('Error');
    end

    else
    begin
        fullCommand := command;
        if args <> '' then
            fullCommand := fullCommand + ' ' + args;

        if ExecuteProcess('/bin/sh', ['-c', fullCommand]) <> 0 then
            Writeln('Error');
    end
end;

// Entry point
begin
    writeln('One-program shell.');
    writeln('Type "help" for options.');
    writeln('');

    while True do
    begin
        //SysUtils.Beep();
        write('~ ');
        ReadLn(input);
        Split_Line(input, command, args);
        Execute_Command(command, args);
    end;
end.