program WriterReader;

uses
  SysUtils;

var
  pipeName1, pipeName2: string;
  f1, f2: TextFile;
  message: string;
begin
  pipeName1 := 'mypipe1';
  pipeName2 := 'mypipe2';
  
  // Send data to the first named pipe
  Assign(f1, pipeName1);
  Rewrite(f1);
  message := 'Hello from WriterReader!';
  Writeln(f1, message);
  Close(f1);
  Writeln('Sent to ReaderWriter: ', message);
  
  // Wait to receive a response from the second named pipe
  Assign(f2, pipeName2);
  Reset(f2);
  Readln(f2, message);
  Close(f2);
  Writeln('Received from ReaderWriter: ', message);
end.
