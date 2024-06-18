(* input_test.pas -- file testing the reserved words, dlimiters, and operators *)
(* written by Billy Do; inputtest.txt has expected results. *)

{ reserved words -- toktype(2), val(1..29) }
array
begin
case
const
do
downto
else
end
file
for
function
goto
if
label
nil
of
packed
procedure
program
record
repeat
set
then
to
type
until
var
while
with

{ operators toktype(0), val(1..19)}
+ - * / := = <> < <= >= > ^ . and or not div mod in

{ delimers toktype(1), val(1..8) }
, ; : ( ) [ ] ..
