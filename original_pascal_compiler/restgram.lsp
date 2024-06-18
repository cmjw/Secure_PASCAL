; restgram.lsp     Gordon S. Novak Jr.          ; 08 Nov 04

; Natural Language Access to Restaurant Database

; To run:
; (load "/projects/cs381k/atn.lsp")          ; ATN functions
; (load "/projects/cs381k/restdb.lsp")       ; database
; (load "/projects/cs381k/gramcom.lsp")      ; grammar compiler
; (load "/projects/cs381k/restlex.lsp")      ; lexicon
; (load "/projects/cs381k/restgram.lsp")     ; grammar: this file
; (load "/projects/cs381k/restqueries.lsp")  ; example queries

; (askr '(show me a good italian restaurant in palo alto))
; (askr '(where can i get ice cream in berkeley))
; (askr '(show me chinese restaurants rated above 2.5 in los altos))

; Note: lexicon parts-of-speech must be disjoint from grammar nonterminals.

; The lexicon restlex.lsp defines: restaurant kindfood city county area street

(deflexicon
 '((a/an     (a an some))
   (i/you    (i you one))
   (get      (get find obtain))
   (quality  ((good 2.5) ))
   (restword (restaurant (restaurants restaurant)))
   ))

; Define grammar after defining lexicon.
; upper-case and lower-case are the same to Lisp.

(defgrammar

  (s -> ((command) (a/an)? (qual)? (type)? (restword) (qualb)? (loc)?)
        (combine (retrieve 'restaurant) (retrieve 'streetno)
		 (retrieve 'street) $3 $4 $6 $7))
  (s -> (where can (i/you) (get) (qual)? (type)? food ? (loc)?)
        (combine (retrieve 'restaurant) (retrieve 'streetno)
		 (retrieve 'street) $5 $6 $8))
  (command -> (show me) t)
  (command -> (tell me) t)
  (command -> (what is) t)
  (qual    -> ((quality))      (restrictb '>= 'rating $1))
  (qualb   -> (rated above (number))   (restrictb '>= 'rating $3))
  (type    -> ((kindfood))     (restrict 'foodtype $1))
  (loc     -> (in (city))      (restrict 'city $2))
  (loc     -> (in (county))    (restrict 'county $2))
  )
