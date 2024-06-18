; opprecc.lsp            Gordon S. Novak Jr.            02 Sep 93

; Copyright (c) 1993 The University of Texas at Austin.  All rights reserved.

; Operator Precedence Parser for arithmetic expressions

; (expr '(a + b) )             ; ==>  (+ A B)
; (expr '(x \:= a + b * c) )   ; ==>  (|:=| X (+ A (* B C)))
; (expr '(x \:= a * b + c) )   ; ==>  (|:=| X (+ (* A B) C))
; (expr '(x \:= (a + b) * (c + d * e) + f))
;                              ;  ==>  (|:=| X (+ (* (+ A B) (+ C (* D E))) F))
; (unparse '(|:=| X (* A (+ B C))))  ; X := A * (B + C)

(in-package :user)

(defmacro while (test &rest forms)
  `(loop (unless ,test (return)) ,@forms) )

; This precedence ordering is different from that of Pascal.
(defvar *op-table*
     '((+ 6) (- 6) (* 7) (/ 7) (\:= 1) (= 5) (<> 5) (< 5) (<= 5) (>= 5)
       (> 5) (^ 9) (\. 10) (and 3) (or 2) (not 4)))

(proclaim '(special *op-stack* *opnd-stack*))

; Parse an expression.
(defun expr (inp)
  (let (token *op-stack* *opnd-stack*)
    (while inp
      (setq token (pop inp))
      (if (consp token)
	  (push (expr token) *opnd-stack*)         ; (subexpression)
          (if (operatorp token)
	      (progn
		(while (>= (prec (first *op-stack*))
			   (prec token))
		  (reducex))
		(push token *op-stack*))
	      (push token *opnd-stack*))))         ; operand
    (while *op-stack* (reducex))                   ; reduce remaining ops
    (pop *opnd-stack*) ))

; Reduce top part of stacks, replace on operand stack.
(defun reducex ()
  (let ((rhs (pop *opnd-stack*)))
    (push (list (pop *op-stack*)    ; op
		(pop *opnd-stack*)  ; lhs
		rhs)                ; rhs
	  *opnd-stack*) ))

; Test for an operator and look it up
(defun operatorp (op) (assoc op *op-table*))

; Precedence of an operator
(defun prec (op) (or (second (operatorp op)) -1))

; Convert a Lisp expression to infix form and print
(defun unparse (exp) (unparseb exp -1) (terpri))
(defun unparseb (exp expprec)
  (let (subprec)
    (if (atom exp)
        (princ exp)
	(progn (setq subprec (prec (first exp)))
	       (if (< subprec expprec) (princ "("))
	       (unparseb (second exp) subprec)
	       (princ " ") (princ (first exp)) (princ " ")
	       (unparseb (third exp) subprec)
	       (if (< subprec expprec) (princ ")")) ) ) ))
