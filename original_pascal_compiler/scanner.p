(* scanner.p              Pascal Version of Scanner             29 Jan 91

   Contains auxiliary functions for peeking and getting characters, and for
   initializing a character class array                                     *)

(* Written by Hiow-Tong Jason See and Gordon S. Novak Jr. *)

(* To execute the Pascal Version, and produce output in test.p, type
        pc scanner.p -o scanner.o
        scanner.o <pastst.pas >test.p                               *)

program scanner (input, output); 

const
   MaxCharClass = 256;           (* Maximum number of Character Classes   *)
   BufferLimit = 2;              (* Buffer Limit for  Peeking Ahead       *)

type
   chartype  = (errorchar, alpha, numeric, special);
   tokentp  = (operator, delimiter, reserved, identifier, string, number);
   charstr  = packed array[1..16] of char;
   tokenrec = record
      tokentype  : tokentp;
      subtype    : integer;
      tokstr     : charstr;
      intnum     : integer;
      realnum    : real
      end;
   token = ^tokenrec;
   
var
   charclass  : array[1..MaxCharClass] of chartype;  (* Character Class Array *)
   charbuffer : array[1..BufferLimit] of char;       (* Buffer for Peeking *)
   bufferptr  : integer;
   EOFChar    : char;

procedure initbuffer;
   var
     i : integer;
   begin
     bufferptr := 0;
     for i := 1 to BufferLimit do charbuffer[i] := ' ';
   end;

function getchar : char;
   var
      c : char;
   begin
      if bufferptr = 0 
      then
         if eof(input)
            then getchar := EOFChar
            else
              begin
                read(c);
                getchar := c
              end
      else
         begin
           getchar := charbuffer[bufferptr];
           bufferptr := bufferptr - 1
         end
   end;

procedure ungetc (c:char);
   begin
     if bufferptr = BufferLimit
     then
        writeln('Buffer Full')
     else
        begin
          bufferptr := bufferptr + 1;
          charbuffer[bufferptr] := c
        end
   end;

function peekchar : char;
   var
      c : char;
   begin
      c := getchar;
      ungetc(c);
      peekchar := c
   end;

function peek2char : char;
   var 
      c, cc : char;
   begin
      c := getchar;
      cc := getchar;
      ungetc(cc);
      ungetc(c);
      peek2char := cc
   end;

procedure initcharclass;
   var 
       i : integer;
       specchar : packed array[1..18] of char;
   begin
       for i := 1 to MaxCharClass do
           charclass[i] := errorchar;
       for i := 0 to 25 do
         begin
           charclass[ord('A') + i] := alpha;
           charclass[ord('a') + i] := alpha;
         end;          
       for i := 0 to 9 do
           charclass[ord('0') + i] := numeric;
       specchar := '+-*/:=<>^.,;()[]{}';
       for i := 1 to 18 do
           charclass[ord(specchar[i])] := special;
   end;

procedure printtoken(tok:token);
   begin
     case tok^.tokentype of
          operator, reserved:
             writeln('Token type: ', tok^.tokentype,
             	     '     subtype: ', tok^.subtype);
          delimiter:
             writeln('Token type: ', tok^.tokentype,
             	     '    subtype: ', tok^.subtype);
          identifier:
             writeln('Token type: ', tok^.tokentype,
                     '   subtype: ', tok^.subtype,
                     '    string: ', tok^.tokstr);
          string:
             writeln('Token type: ', tok^.tokentype,
                     '       subtype: ', tok^.subtype,
                     '    string: ', tok^.tokstr);
          number:
             case tok^.subtype of
                 0: writeln('Token type: ', tok^.tokentype,
                            '       subtype: ', tok^.subtype,
                            '   value:   ', tok^.intnum);

                 1: writeln('Token type: ', tok^.tokentype,
                            '       subtype: ', tok^.subtype,
                            '   value:   ', tok^.realnum);
               end
           end
   end;

function gettoken : token; forward;

procedure testscanner;
   var tok : token;
   begin
       EOFChar := chr(0);
       while not eof(input) do
         begin
           tok := gettoken;
           printtoken(tok);
         end
   end;


function gettoken : token;    (* your function here *)
   var tok: token;
   begin
     new(tok);
     gettoken := tok
   end;

begin {main}
  initcharclass;
  initbuffer;
  testscanner; 
end.
