{ change name / identifier in makeprogram token }
program Priv(ouput); 

{ keep all declarations }
Uses sysutils; 

var i, f, written : integer; msg: string; 

begin
    
    { wait for signal }

    { recieve signal for user }

    i := { recieve value of i }

    { insert privblock }
    {priv::begin}

        f := FileCreate('test.txt');

        if f = -1 then
            halt(1);
        
        msg := IntToStr(i);

        written := FileWrite(f, msg[1], length(msg));
        if written = -1 then
            halt(1);

        FileClose(f);
    {priv::end} 

    { signal to user }
end.