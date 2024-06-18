; physgram.lsp         Gordon S. Novak Jr.           ; 05 Apr 04; 14 Apr 04

; Copyright (c) 2004 Gordon S. Novak Jr. and The University of Texas at Austin.

; The following files are needed: atn.lsp gramcom.lsp solveq.lsp patmatch.lsp

(deflexicon
 '((propname (radius diameter circumference area
	      volume height velocity time
	      weight power height work speed mass))
   (a/an     (a an))
   (the/its  (the its))
   (objname  (circle sphere fall lift))
)) ; deflexicon

(defgrammar
  (s         -> (what is (property) of (object)) (list 'calculate $3 $5))
  (property  -> ((the/its)? (propname)) $2)
  (quantity  -> ((number)) $1)
  (object    -> ((a/an)? (objname) with (objprops))
                   (cons 'object (cons $2 $4)))
  (objprops  -> ((objprop) and (objprops))  (cons $1 $3))
  (objprops  -> ((objprop))  (list $1))
  (objprop   -> ((a/an)? (propname) of ? (quantity))  (cons $2 $4))
  (objprop   -> ((propname) = (quantity))  (cons $1 $3))
)

; 13 Feb 04; 18 Feb 04; 05 Apr 04
; parse and answer physics questions
(defun phys (sent)
  (let (qst obj var)
    (setq qst (parse sent))
    (if (and qst (eq (car qst) 'calculate))
	(progn (setq obj (caddr qst))
	       (setq var (cadr qst))
	       (solveqns (get (cadr obj) 'equations) var (cddr obj)) ) ) ))

(setf (get 'circle 'equations)
      '((= diameter (* 2 radius))
	(= circumference (* pi diameter))
	(= area (* pi (expt radius 2))) ) )

(setf (get 'sphere 'equations)
      '((= diameter (* 2 radius))
	(= circumference (* pi diameter))
	(= area (* 4 (* pi (expt radius 2))))
	(= volume (* (/ (* 4 pi) 3) (expt radius 3))) ))

(setf (get 'fall 'equations)
      '((= gravity 9.80665)
	(= height   (* (/ gravity 2) (expt time 2)))
	(= velocity (* gravity time)) ) )

(setf (get 'lift 'equations)
      '((= gravity  9.80665)
	(= weight      (* gravity mass))
	(= work        (* weight height))
	(= speed       (/ height time))
	(= power       (* weight speed))
	(= power       (/ work time))))
