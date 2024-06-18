; pars1.lsp                  Gordon S. Novak Jr.             23 Feb 95

(in-package :user)

; Starter file for parser assignment

; Copyright (c) 1998 Gordon S. Novak Jr. and
; The University of Texas at Austin.

; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.

; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License (file gpl.text) for more details.

; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

; To test:
; (setq *lines* '("i:=j ."))
; (testparse)
; (setq *lines* '("begin i:=j; if i+j then x:=a+b*c else x:=a*b+c; k:=i end."))
; (testparse)
; (setq *lines* '("if x+y then if y+z then i:=j else k:=2."))
; (testparse)

(defvar *debugparse* nil)     ; set to T to trace parsing functions
(defvar *savedtoken* nil)     ; used by gettok/peektok
(defvar *errorbreak* nil)     ; set to T to call Lisp error on parsing error

; Reduce a binary operator.
; args are: operator, left-hand side, right-hand side
; result:       op             which prints as:    (op lhs rhs)
;              /
;            lhs --- rhs                       
(defun binop (op lhs rhs)
  (setf (link rhs) nil)      ; for safety
  (setf (link lhs) rhs)
  (setf (operands op) lhs)
  op)

; add item to front of list
; similar to cons, but works on existing tokens
(defun tokcons (item list)
  (setf (link item) list)
  item)

; destrunctive reversal for token list; cf. nreverse
(defun toknreverse (list)
  (toknreverseb list nil))

(defun toknreverseb (list answer)
  (if list
      (toknreverseb (link list) (tokcons list answer))
      answer) )

; smash a token and make it into an operator with specified args
(defun makeop (tok opnumber args)
  (setf (tokentype tok) 'operator)
  (setf (tokenval tok) opnumber)
  (setf (operands tok) args)
  (setf (link tok) nil)        ; for safety
  tok)

; get the next token.  Works with peektok
(defun gettok ()
  (let (tok)
    (if *savedtoken*
	(progn (setq tok *savedtoken*)
	       (setq *savedtoken* nil)
	       tok)
        (gettoken)) ))

; Peek at the next token
(defun peektok ()
  (or *savedtoken*
      (setq *savedtoken* (gettoken)) ) )

; Test for a particular type of token
(defun toktest (tok type n)
  (and (eq (tokentype tok) type)
       (= (tokenval tok) n)))

; 16 Jan 95
; verify that the next token is what it must be, else print error message
(defun mustbe (type n msg)
  (let (tok)
    (setq tok (gettok))
    (unless (toktest tok type n)
      (parseerror msg)) ))

; 16 Jan 95; 23 Feb 95
(defun parseerror (msg &rest args)
  (apply #'format (cons t (cons msg args)))
  (if *errorbreak* (error "Lisp break due to parsing error.")) )

; 14 Jan 95
; Test for a specified kind of token.
; If found, consume the token and return it, else return nil.
(defun testfor (type n)
  (let (tok)
    (setq tok (peektok))
    (if (toktest tok type n)
	(gettok)) ))

; 16 Jan 95; 22 Feb 95
; Print a debug message and results if *debugparse* is T.  Returns tok.
(defun traceparse (fn tok)
  (when *debugparse*
    (format t "Result of ~A:~%" fn)
    (ppexpr tok)
    (terpri))
  tok )

; 14 Jan 95; 16 Jan 95
(defun statement ()
  (let (tok result)
    (setq tok (gettok))
    (setq result
	  (if (eq (tokentype tok) 'reserved)
	      (cond ((eq (tokenval tok) *begin*) (parsebegin tok))
		    ((eq (tokenval tok) *if*) (parseif tok))
		    (t (parseerror "~A not implemented.~%" tok)) )
	      (if (eq (tokentype tok) 'identifiertok)
		  (parseassign tok)
		  (parseerror "~A appears improperly~%" tok)) ))
    (traceparse 'statement result) ))

; 14 Jan 95; 16 Jan 95
; Parse a begin ... end group
(defun parsebegin (tok)
  (let (statements done)
    (while (not done)
      (setq statements (tokcons (statement) statements))
      (if (testfor 'reserved *end*)
	  (setq done t)
	  (if (not (testfor 'delimiter *semicolon*))
	      (parseerror "Bad stuff in begin-end~%"))) )
    (traceparse 'parsebegin (makeop tok *prognop* (toknreverse statements))) ))

; 14 Jan 95; 16 Jan 95
; Parse an if ... then ... else statement
(defun parseif (tok)
  (let (expr thenpart elsepart)
    (setq expr (parseexpr))
    (mustbe 'reserved *then* "THEN expected.~%")
    (setq thenpart (statement))
    (if (testfor 'reserved *else*)
	(setq elsepart (statement)))
    (traceparse 'parseif (makeop tok *ifop*
			(tokcons expr (tokcons thenpart elsepart)))) ))

; 14 Jan 95; 16 Jan 95
; Parse an assignment statement, lhs := rhs
(defun parseassign (lhs)
  (let (tok rhs)
    (if (not (setq tok (testfor 'operator *assignop*)))
	(parseerror "Unrecognized statement~%"))   ; but could be procedure call
    (setq rhs (parseexpr))
    (traceparse 'parseassign (makeop tok *assignop* (tokcons lhs rhs))) ))

; Define the precedence of operators
; partial implementation  -- handles +, *
(defvar *precedence*
  (make-array 30 :initial-contents '(0 1 0 3 0 0 0 0 0 0
				     0 0 0 0 0 0 0 0 0 0
				     0 0 0 0 0 0 0 0 0 0)) )
(defvar *opstack*)     ; operator stack
(defvar *opndstack*)   ; operand stack

; 14 Jan 95; 16 Jan 95
; Parse an arithmetic expression.
(defun parseexpr ()
  (let (tok op lhs rhs state done)
    (setq *opstack* nil)
    (setq *opndstack* nil)
    (while (not done)
      (setq tok (peektok))
      (case (tokentype tok)
	((identifiertok numbertok)
	  (setq tok (gettok))
	  (setq *opndstack* (tokcons tok *opndstack*)) )
	(delimiter
	  (if (= (tokenval tok) *lparen*)
	      (setq *opstack* (tokcons (gettok) *opstack*))
	      (if (= (tokenval tok) *rparen*)
		  (progn
		    (setq tok (gettok))
		    (while (not (and (eq (tokentype *opstack*) 'delimiter)
				     (= (tokenval *opstack*) *lparen*)))
		      (reduce-expr))
		    (setq *opstack* (link *opstack*)) )
		  (setq done t))))
	(operator
	  (if (= (tokenval tok) *dotop*)   ; special case for now
	      (setq done t)
	      (progn (setq tok (gettok))
		     (while (and *opstack*
				 (eq (tokentype *opstack*) 'operator)
				 (>= (aref *precedence* (tokenval *opstack*))
				     (aref *precedence* (tokenval tok))) )
		       (reduce-expr))
		     (setq *opstack* (tokcons tok *opstack*)) ) ) )
	(t (setq done t)) ) )
    (while *opstack* (reduce-expr))
    (traceparse 'parseexpr *opndstack*) ))

; 15 Jan 95
; Reduce operands from stacks
(defun reduce-expr ()
  (let (lhs rhs op res)
    (setq op *opstack*)
    (setq *opstack* (link *opstack*))
    (setq rhs *opndstack*)
    (setq lhs (link rhs))
    (setq *opndstack* (link lhs))
    (setq res (binop op lhs rhs))
    (setf (link res) *opndstack*)
    (setq *opndstack* res) ))

; 15 Jan 95
(defun parse-program ()
  (let (result)
    (setq result (statement))
    (mustbe 'operator *dot* "No period at end of program~%")
    (traceparse 'parse-program result)))

; 14 Jan 95
; Test the parser
(defun testparse ()
  (init-file)
  (ppexpr (parse-program)) )
