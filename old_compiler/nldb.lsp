;   nldb.lsp             Gordon S. Novak Jr.           ; 14 Apr 04

;   Load atn.lsp for ATN functions, db.lsp for database.

; 12 Nov 03; 15 Jan 04

;   Now we define a lexicon and grammar for this application.
(deflexicon
 '((part     (pliers tire (tires tire) blimp (blimps blimp)
	      widget (widgets widget)))
   (supplier (sears acme goodyear))
   (customer (ut hp mcc))
   (city     (austin dallas el-paso ((el paso) el-paso)))
   (month    ((january 1) (jan 1) (february 2) (feb 2) (march 3) (mar 3)
	      (april 4) (apr 4) (may 5) (june 6) (jun 6) (july 7) (jul 7)
	      (august 8) (aug 8) (september 9) (sept 9) (sep 9)
	      (october 10) (oct 10) (november 11) (nov 11) (december 12)
	      (dec 12)))   ))

(proclaim '(special *retrieve* *restrict*))

;   *retrieve* is a list of things to retrieve from the database
;   *restrict* is a list of restrictions on the database query

;   Main function: ASK
;   
;   (ASK '(WHAT CUSTOMERS IN AUSTIN ORDERED WIDGETS IN APRIL))
;
(defun ask (question)
  (let (*restrict* *retrieve*)
    (parser question)
    (querydb 'orderdb
	     (cons 'and *restrict*)
	     (cons 'list (nreverse *retrieve*)))  ))

;   add a restriction to the query
(defun addrestrict (r) (push r *restrict*))

;   add a retrieval request
(defun addretrieve (r) (push r *retrieve*))

;   Quote something if needed.
(defun kwote (x) (if (constantp x) x (list 'quote x) ) )

;   make a database access call
(defun dbaccess (field) (list 'getdb (kwote field)))

;   parsing function.  The sentence is parsed; phrases in the
;   question are converted to internal database form and added
;   to either the *restrict*ions or retrieval requests for the
;   database query.
(defun parser (sent)
  (let ()
    (setq *sent* sent)
    (setq *savesent* nil)
    (setword)
    (if (eq *word* 'what) (next))
    (cond ((member *word* '(customer customers))
             (next)
	     (addretrieve (dbaccess 'customer))
	     (loc)
	     (if (eq *word* 'ordered) (next))
	     (part)
	     (supplier)
	     (datespec))
          ((eq *word* 'who)
             (next)
	     (addretrieve (dbaccess 'customer))
	     (loc)
	     (if (eq *word* 'ordered) (next))
	     (part)
	     (supplier)
	     (datespec)))
;   (format t "*retrieve* = ~s" *retrieve*) (terpri) ; for trace
;   (format t "*restrict* = ~s" *restrict*) (terpri) ; for trace
    (if *sent* (error "words left over! ~s" *sent*))  ))

;   parse a location
(defun loc ()
  (let (locname)
    (saveptr)
    (if (and (eq *word* 'in) (next)
	     (setq locname (cat 'city)) (next))
	(progn (addrestrict (list 'equal
				  (dbaccess 'customer-city)
				  (kwote locname)))
	       (success))
        (fail) ) ))

;   parse a part specification
(defun part ()
  (let (partname)
    (saveptr)
    (if (and (setq partname (cat 'part)) (next))
	(progn (addrestrict (list 'equal
				  (dbaccess 'part)
				  (kwote partname)))
	       (success))
        (fail)) ))

;   parse a date spec
(defun datespec ()
  (let (prep month)
    (saveptr)
    (if (and (setq prep (assoc *word*
			       '((in equal) (before <) (after >))))
	     (next)
	     (setq month (cat 'month)) (next))
	(progn (addrestrict (list (cadr prep)
				  (dbaccess 'date-month)
				  month))
	       (success))
        (fail)) ))

;   parse a supplier spec
(defun supplier ()
  (let (suppname)
    (saveptr)
    (if (and (eq *word* 'from) (next)
	     (setq suppname (cat 'supplier)) (next))
	(progn (addrestrict (list 'equal
				  (dbaccess 'supplier)
				  (kwote suppname)))
	       (success))
        (fail)) ))
