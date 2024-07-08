program privProg(output);

uses
  Sockets;

var 
  listenerSock, clientSock: TSocket;
  addr: TInetSockAddr;
  outputName, inputName: string;
  func1_input: integer;
  func1_result: integer;
  func2_input: integer;
  func2_result: integer;

{ privileged functions }
function func1(i: integer): integer;
var 
  result: integer;
begin

end;

function func2(i: integer): integer;
var 
  result: integer;
begin
  
end;

{ main }
begin
  inputName := '127.0.0.1';
  outputName := '127.0.0.1';

  // listener socket
  listenerSock := Socket(AF_INET, SOCK_STREAM, 0);
  addr.sin_family := AF_INET;
  addr.sin_port := htons(12345); 
  addr.sin_addr.s_addr := INADDR_ANY;

  Bind(listenerSock, @addr, SizeOf(addr));
  Listen(listenerSock, 1);

  // Wait for connection from UserProg
  clientSock := Accept(listenerSock, nil, nil);

  // wait for func1 argument
  Recv(clientSock, @func1_input, SizeOf(func1_input), 0);

  // Execute func1
  func1_result := func1(func1_input);

  // communicate func1 result
  Send(clientSock, @func1_result, SizeOf(func1_result), 0);

  // Receive func2 argument
  Recv(clientSock, @func2_input, SizeOf(func2_input), 0);

  // Execute func2
  func2_result := func2(func2_input);

  // Send func2 result
  Send(clientSock, @func2_result, SizeOf(func2_result), 0);

  CloseSocket(clientSock);
  CloseSocket(listenerSock);
end.


{ ############################################ }

program privProg(output);

uses
  Sockets; // fpc

var 
  listenerSock, clientSock: TSocket;
  addr: TInetSockAddr;
  outputName, inputName: string;
  func1_input: integer;
  func1_result: integer;
  func2_input: integer;
  func2_result: integer;

{ privileged functions }
function func1(i: integer): integer;
var 
  result: integer;
begin

end;

function func2(i: integer): integer;
var 
  result: integer;
begin

end;

{ main }
begin
  inputName := '127.0.0.1'; 
  outputName := '127.0.0.1';

  // listener socket
  listenerSock := Socket(AF_INET, SOCK_STREAM, 0);
  addr.sin_family := AF_INET;
  addr.sin_port := htons(12345);
  addr.sin_addr.s_addr := INADDR_ANY;

  Bind(listenerSock, @addr, SizeOf(addr));
  Listen(listenerSock, 1);

  // connection from UserProg
  clientSock := Accept(listenerSock, nil, nil);

  // wait for func1 argument
  Recv(clientSock, @func1_input, SizeOf(func1_input), 0);

  // execute func1
  func1_result := func1(func1_input);

  // send func1 result
  Send(clientSock, @func1_result, SizeOf(func1_result), 0);

  // wait for func2 argument
  Recv(clientSock, @func2_input, SizeOf(func2_input), 0);

  // execute func2
  func2_result := func2(func2_input);

  // communicate func2 result
  Send(clientSock, @func2_result, SizeOf(func2_result), 0);

  CloseSocket(clientSock);
  CloseSocket(listenerSock);
end.
