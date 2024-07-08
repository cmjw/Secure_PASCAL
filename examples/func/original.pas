program prog(ouput);

var result1, result2: integer;

{ privileged function, unpriv return }
priv::function func1(i : integer): unpriv::integer;

var result: integer;

begin
 {}
end;

{ privileged function, unpriv return }
priv::function func2(i : integer): unpriv::integer;

var result: integer;

begin
 {}
end;

{ main }
begin
    result1 = func1(1);

    result2 = func2(0);

    writeln("Result 1: ", result1);
    writeln("Result 2: ", result2);
end.


{ ################################################### }

program privProg(ouput);

var 
outputPipe, inputPipe: Text;
outputName, inputName: string;
func1_input: integer;  { for simplicity - add correct dt var to decls for each called function }
func1_result: integer;
func2_input: integer;
func2_result: integer;

{ privileged functions }
priv::function func1(i : integer): unpriv::integer;
var result: integer;
begin
 {}
end;

priv::function func2(i : integer): unpriv::integer;
var result: integer;
begin
 {}
end;


{ main }
begin
    inputName := 'pipe_to_privileged';
    outputName := 'pipe_to_user';

    { wait to read func1 arg }
    assign(inputPipe, inputName);
    reset(inputPipe);
    readln(inputPipe, func1_input);
    close(inputPipe);

    { execute func1 }
    func1_result = func1(func1_input);

    { send back func1 result }
    assign(outputPipe, outputName);
    rewrite(outputPipe);
    writeln(outputPipe, func1_result);
    close(outputPipe);

    { wait to read func2 arg }
    assign(inputPipe, inputName);
    reset(inputPipe);
    readln(inputPipe, func2_input);
    close(inputPipe);

    func2_result = func2(func2_input);

    { send back func2 result }
    assign(outputPipe, outputName);
    rewrite(outputPipe);
    writeln(outputPipe, func2_result);
    close(outputPipe);
end.

{ ################################################### }

program UserProg(ouput);

{ all original vars except priv scoped }
var i ...
    outputPipe, inputPipe: Text;
    outputName, inputName: string;
    func1_result: integer;
    func2_result: integer; { also here too }

{ main }
begin 
    outputName := 'pipe_to_privileged';
    inputName := 'pipe_to_user';

    { send func1 arg }
    assign(outputPipe, outputName);
    rewrite(outputPipe);
    writeln(outputPipe, 1); { funcall operand } { loop through all links to communicate each arg }
    close(outputPipe);

    { wait for func1 result }
    assign(inputPipe, inputName);
    reset(inputPipe);
    readln(inputPipe, func1_result);
    close(inputPipe);

    { send func2 arg }
    assign(outputPipe, outputName);
    rewrite(outputPipe);
    writeln(outputPipe, 0); { funcall operand 0 } 
    close(outputPipe);

    { wait for func2 result }
    assign(inputPipe, inputName);
    reset(inputPipe);
    readln(inputPipe, func2_result);
    close(inputPipe);

    writeln("Result 1: ", result1);
    writeln("Result 2: ", result2);
end.


{ void }
{ wait for result = 0 }