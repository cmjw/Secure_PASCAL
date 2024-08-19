program Privblocks(ouput); 
{ must have output for now }


Uses sysutils; 

var i, f, written : integer; msg: string; 

begin
    i := 1; 

    { a privblock } 
    priv::begin (i : integer) { indicate i outside of privblock }

        f := FileCreate('test.txt');

        if f = -1 then
            halt(1);
        
        msg := IntToStr(i);

        written := FileWrite(f, msg[1], length(msg));
        if written = -1 then
            halt(1);

        FileClose(f);
    priv::end 
    { or "end" }
end.