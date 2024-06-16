program ReaderWriter;

uses
  SysUtils;

var
  pipeName1, pipeName2: string;
  f1, f2: TextFile;
  message: string;
begin
  pipeName1 := 'mypipe1';
  pipeName2 := 'mypipe2';
  

  
  // Wait to receive data from the first named pipe
  Assign(f1, pipeName1);
  Reset(f1);
  Readln(f1, message);
  Close(f1);
  Writeln('Received from WriterReader: ', message);
  
  // Send a response to the second named pipe
  Assign(f2, pipeName2);
  Rewrite(f2);
  message := 'Hello from ReaderWriter!';
  Writeln(f2, message);
  Close(f2);
  Writeln('Sent to WriterReader: ', message);
end.
