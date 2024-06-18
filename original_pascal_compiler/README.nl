README.nl for Natural Language Interfaces                    08 Nov 04

; (setq *tracenl* t)   ; to turn on debugging traces using grammar compiler


To try the "hand-written" parts database interface:

(load "/projects/cs381k/atn.lsp")
(load "/projects/cs381k/db.lsp")
(load "/projects/cs381k/nldb.lsp")

(ask '(who ordered widgets))
(ask '(what customers in austin ordered widgets in april))
(ask '(what customers in el paso ordered tires))


To try the grammar compiler version of parts database interface:

(load "/projects/cs381k/atn.lsp")
(load "/projects/cs381k/db.lsp")
(load "/projects/cs381k/gramcom.lsp")
(load "/projects/cs381k/nldb.lsp")
(load "/projects/cs381k/gram.lsp")

(askb '(who ordered widgets))
(askb '(who ordered tires from sears))
(askb '(what customers in austin ordered widgets in april))
(askb '(what customers in el paso ordered tires))


To try the grammar compiler version of restaurant database interface:

(load "/projects/cs381k/atn.lsp")
(load "/projects/cs381k/restdb.lsp")
(load "/projects/cs381k/gramcom.lsp")
(load "/projects/cs381k/restlex.lsp")
(load "/projects/cs381k/restgram.lsp")

(askr '(show me a good chinese restaurant in los altos))
(askr '(where can i get ice cream in berkeley))
(askr '(show me chinese restaurants rated above 2.5 in los altos))


To try the grammar compiler version of algebraic solver:

(load "/projects/cs381k/atn.lsp")
(load "/projects/cs381k/gramcom.lsp")
(load "/projects/cs381k/physgram.lsp")
(load "/projects/cs381k/solveq.lsp")
(load "/projects/cs381k/patmatch.lsp")

(phys '(what is the area of a circle with radius = 2))
(phys '(what is the radius of a circle with area = 12))
(phys '(what is the height of a fall with time = 4))
(phys '(what is the power of a lift with mass = 5 and height = 10 and time = 4))
