; opprec.lsp            Gordon S. Novak Jr.            15 Feb 91

; Copyright (c) 1991 by The University of Texas System.

; Operator Precedence Parser for arithmetic expressions.
; This version uses (gettoken) to get tokens from the input.

(in-package :user)

(defmacro token-type    (token) `(first  ,token))
(defmacro token-subtype (token) `(second ,token))
(defmacro operands      (token) `(fourth ,token))
(defmacro side-link     (token) `(fifth  ,token))

(defvar *prec-table* (make-array 20 :initial-contents    ; not Pascal precedence
    ;      +  -  *  /  := =  <> <  <= >= >  ^   . and or not
     '( 0  6  6  7  7  1  5  5  5  5  5  5  9  10  4  3   5  0 0 0)))

(defvar *op-stack*)
(defvar *opnd-stack*)

; Parse an expression.
(defun expr ()
  (prog (token)
    (setq *op-stack*   nil)
    (setq *opnd-stack* nil)
lp  (or (setq token (gettoken)) (go out))
lpb (case (token-type token)
       ((identifier number string) (push token *opnd-stack*) (go lp))
       (operator
	 (if (< (prec (first *op-stack*))
		(prec token))
	     (progn (push token *op-stack*) (go lp))
	     (progn (reducex) (go lpb))))
       (delimiter
	 (case (token-subtype token)
	   (4 (push token *op-stack*) (go lp))  ; left paren:  push onto stack
	   (5 (while                            ; right paren: pop to left paren
		  (or (not (eq (token-type (first *op-stack*)) 'delimiter))
		      (not (eql (token-subtype (first *op-stack*)) 4)))
		(reducex))
	      (pop *op-stack*)                  ; get rid of left paren
	      (go lp))
	   (t )))
       (t ))        ; fall out for other cases
out (when *op-stack* (reducex) (go out))         ; reduce remaining ops
    (return (pop *opnd-stack*)) ))

; Reduce top part of stacks, replace on operand stack.
(defun reducex ()
  (let (n end op)
    (setq n 2)     ; assumes binary op
    (dotimes (i n)
      (setf (side-link (first *opnd-stack*)) end)
      (setq end (pop *opnd-stack*)) )
    (setq op (pop *op-stack*))
    (setf (operands op) end)
    (push op *opnd-stack*) ) )

(defun prec (token)
  (if (or (null token)
	  (not (eq (token-type token) 'operator)))
      -1
      (aref *prec-table* (token-subtype token))) )
