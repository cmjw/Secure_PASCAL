; gramcom.lsp          Gordon S. Novak Jr.             ; 08 Nov 04

; Simple grammar compiler.  See the file gram.lsp for an example.

; Copyright (c) 2004 Gordon S. Novak Jr. and The University of Texas at Austin.

; 18 Nov 03; 15 Jan 04; 03 Feb 04; 13 Apr 04; 14 Apr 04; 19 Apr 04; 26 Apr 04
; 28 Apr 04; 05 Nov 04
(or (fboundp 'while)
 (defmacro while (test &rest forms) `(loop (unless ,test (return)) ,@forms) ) )

(defvar *tracenl*)
(setq *tracenl* nil)

; Define the lexicon first using deflexicon before defining grammar.
; Grammar rules are defined by:   (defgrammar rule1 rule2 ... rulen)
; Grammar rules are of the form:
;   (nonterminal  ->  pattern    semantics)
; e.g.   (LOC  -> (in (city))  (restrict 'customer-city $2))
; nonterminal is the name of the production; it must not be the same
;    as a part-of-speech category used in deflexicon.
; pattern is a list of items.  Each item may be:
;    word         exactly the word that is specified.
;    (category)   category may be a part-of-speech used in deflexicon,
;                 or a nonterminal.
;    an item may be followed by ?, in which case it is optional.
;    If the item is a symbol, a space must separate it from a ? .
; semantics is Lisp code that is executed when the rule is satisfied.
;    Items are referenced by $i variables, e.g. $2 in the above example
;    refers to the second item, (city).
;    The first item is $1
;    Optional items (but not the ? symbol) count for item numbering.
;    If semantics returns nil, the rule is considered to fail.
; Left recursion, (X -> ((X) ...)), will cause an infinite loop.
; Rules are tried in the order specified to defgrammar.

; compile one rule to a Lisp function.  Returns defun code.
(defun rulecom (rule)
  (let ((lhs (first rule)) (rhs (third rule)) dolvar al code fn vars item cod
	(dolvars '($1 $2 $3 $4 $5 $6 $7 $8 $9 $10
		   $11 $12 $13 $14 $15 $16 $17 $18 $19 $20)) )
    (while rhs
      (setq item (pop rhs))
      (when (not (eq item '?))
	(setq dolvar (pop dolvars))
	(push dolvar vars)
	(setq al (list (cons 'item item) (cons 'dolvar dolvar)))
	(setq cod
	 (if (or (symbolp item) (numberp item))
	     (sublis al '(and (eql (setq dolvar *word*) 'item)
			      (next)))
	     (if (consp item)
	       (if (or (part-of-speech (car item))
		       (eq (car item) 'unk))
		   (sublis (cons (cons 'pos (car item)) al)
			   '(and (setq dolvar (cat 'pos))
				 (next)))
		   (sublis al '(setq dolvar item)))
	       (error "Bad item ~A in rule ~A~%" item rule))))
	(push (if (eq (car rhs) '?)
		  (list 'or cod t)
		  cod)
	      code) ))
    (setq fn (gentemp (symbol-name lhs)))
    (setq al (list (cons 'code (nreverse code))
		   (cons 'semantics (fourth rule))
		   (cons 'fn fn)
		   (cons 'vars (nreverse vars))))
    (sublis al '(defun fn ()
		  (tracenl (quote fn) *word* *sent*
		    (let vars
		      (saveptr)
		      (if (and . code)
			  (progn (success) semantics)
		          (fail)) ) ) ) ) ))

(defmacro defgrammar (&rest rules) `(defgrammarfn ',rules))

(defun defgrammarfn (rules)
  (let (alist code lst)
    (dolist (rule rules)
      (setq code (rulecom rule))
      (eval code)
      (or (setq lst (assoc (car rule) alist))
	  (progn (push (list (car rule)) alist)
		 (setq lst (car alist))))
      (push (list (cadr code)) (cdr lst)) )
    (dolist (z alist)
      (eval (list 'defun (car z) nil (cons 'or (reverse (cdr z)))))) ))

; Make a (list of) a retrieval request
(defun retrieve (field) (list (list (dbaccess field)) nil))

; Make a (list of) a restriction
(defun restrict (field value)
  (list nil (list (list 'equal (dbaccess field) (kwote value)))))

; Make a (list of) a restriction
(defun restrictb (predicate field value)
  (list nil (list (list predicate (dbaccess field) (kwote value)))))

;   Quote something if needed.
(defun kwote (x) (if (constantp x) x (list 'quote x) ) )

;   make a database access call
(defun dbaccess (field) (list 'getdb (kwote field)))

; Combine access lists: ((retrievals) (restrictions))
(defun combine (&rest lists) (combineb lists))
(defun combineb (lists)
  (if (null (cdr lists))
      (car lists)
      (combine2 (car lists) (combineb (cdr lists))) ) )
 
; Combine two access lists: ((retrievals) (restrictions))
(defun combine2 (access1 access2)
  (if (null access1)
      access2
     (if (null access2)
	 access1
         (list (append (car access1) (car access2))
	       (append (cadr access1) (cadr access2))))))

; Top-level query: (askb '(who ordered widgets in april))
(defun askb (question)
  (let (result)
    (setq result (parse question))
    (if (and result (not *sent*))
	(querydb 'orderdb
		 (cons 'and (cadr result))
		 (cons 'list (car result)))
        "parsing failed") ))

; Top-level query: (askr '(show me a good italian restaurant in palo alto))
(defun askr (question)
  (let (result)
    (setq result (parse question))
    (if (and result (not *sent*))
	(querydb 'restdb
		 (cons 'and (cadr result))
		 (cons 'list (car result)))
        "parsing failed") ))

(defun parse (sent &optional (nonterminal 's))
  (setq *sent* sent)
  (setq *savesent* nil)
  (setword)
  (funcall nonterminal) )

; Use pp to examine grammar functions, e.g. (pp s)
(defmacro pp (fn) `(and (fboundp ',fn) (symbol-function ',fn)))

; This allows use of (integer) as a category.
(defun integer () (let ((n *word*)) (and (integerp n) (next) n)))
(defun number ()  (let ((n *word*)) (and (numberp n) (next) n)))
(defun stringz ()  (let ((n *word*)) (and (stringp n) (next) n)))

; limit a list for printing
(defun limitlist (lst)
  (if (> (length lst) 4)
      (list (car lst) (cadr lst) (caddr lst) "...")
      lst))

(defun tracenl (fn word sent result)
  (if *tracenl*
      (format t "~A word: ~A sent: ~A = ~A~%" fn word (limitlist sent) result))
  result)
