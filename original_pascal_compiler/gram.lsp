; gram.lsp          Gordon S. Novak Jr.          12 Nov 03; 14 Apr 04

; Load atn.lsp for ATN functions, db.lsp for database, gramcom.lsp

; Note: lexicon parts-of-speech must be disjoint from grammar nonterminals.

; First we define a lexicon and grammar for this application.

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

; Define grammar after defining lexicon.
; upper-case and lower-case are the same to Lisp.

(defgrammar
  (S -> (what (CUST) (LOC)? ordered (PARTS)? (SUPP)? (DATE)?)
        (combine $2 $3 $5 $6 $7))
  (S -> (who (LOC)? ordered (PARTS)? (SUPP)? (DATE)?)
        (combine (retrieve 'customer) $2 $4 $5 $6))
  (CUST -> (customer)        (retrieve 'customer))
  (CUST -> (customers)       (retrieve 'customer))
  (LOC  -> (in (city))       (restrict 'customer-city $2))
  (DATE -> (in (month))      (restrictb '= 'date-month $2))
  (DATE -> (before (month))  (restrictb '< 'date-month $2))
  (DATE -> (after (month))   (restrictb '> 'date-month $2))
  (PARTS -> ((part))         (restrict 'part $1))
  (SUPP -> (from (supplier)) (restrict 'supplier $2))
  )

; (askb '(who ordered tires from sears))
