; codgen.lsp       Generate Assembly Code for X86          22 Apr 15

; Starter file for CS 375 Code Generation assignment.  See also genasm.lsp

; Copyright (c) 2015 Gordon S. Novak Jr. and
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

(defvar *debuggen*  t)     ; for debug printouts in code generation
(defvar *nextlabel* 0)     ; Next available label number
(defvar *stackoff*  0)     ; Offset on stack of variables

; 17 Jan 95; 24 Apr 95
; Top-level entry for code generator.
;   pcode    = pointer to code:  (program foo (output) (progn ...))
;   varsize  = size of local storage in bytes
;   maxlabel = maximum label number used so far        
(defun gencode (pcode varsize maxlabel)
  (let (name code)
     (setq name (operands pcode))
     (setq code (link (link name)))
     (setq *nextlabel* (1+ maxlabel))
     (setq *stackoff* 0)                   ; was -varsize on M68020
     (asmentry (tokenval name) varsize)
     (genc code)
     (asmexit (tokenval name)) ))

; Trivial version: always returns RBASE + 0
; Get a register
(defun getreg () RBASE)

; 17 Jan 95; 25 Apr 01; 18 Apr 03; 22 Apr 15
; Trivial version
; Generate arithmetic expression, return a register number
(defun genarith (code)
  (let (num reg)
    (when *debuggen*
      (format t "genarith:~%")
      (ppexpr code))
    (case (tokentype code)
      (numbertok
        (case (datatype code)
	  (integer
	    (setq num (tokenval code))
	    (setq reg (getreg))
	    (if (and (>= num MINIMMEDIATE)
		     (<= num MAXIMMEDIATE))
	        (asmimmed MOVL num reg)) ) ) ) )
    reg))

; 17 Jan 95; 24 Apr 95; 25 Apr 01
; Generate code from an intermediate-code form
(defun genc (code)
  (let (tok lhs rhs reg offs sym)
    (when *debuggen*
      (format t "genc:~%")
      (ppexpr code))
    (unless (eq (tokentype code) 'operator)
      (format t "Bad code token~%")
      (ppexpr code))
    (case (tokenval code)
      (22               ; = *prognop*
        (setq tok (operands code))
	(while tok
	  (genc tok)
	  (setq tok (link tok)) ) )
      (5                ; = *assignop*      ; Trivial version: handles (:= I e)
        (setq lhs (operands code))
	(setq rhs (link lhs))
	(setq reg (genarith rhs))                 ; generate rhs into a register
	(setq sym (symentry lhs))                 ; assumes lhs is a simple var
	(setq offs (- (+ *stackoff* (offset sym) (size sym))))
                                                  ; net offset of the variable
	(asmst 'movl reg offs (tokenval lhs)) ) ) ))  ; store value into lhs
