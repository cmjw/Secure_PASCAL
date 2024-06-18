; tokendefs.lsp                  Gordon S. Novak Jr.          13 Feb 98

; 07 April 95; 04 Feb 98

; Token definitions and code for Lisp version of CS 375 exercises

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

(in-package :user)

; Macros for access to parts of a token structure.
; These can also be used with SETF, e.g. (setf (datatype tok) 'integer)
(defmacro tokentype (x) `(first ,x))        ; OPERATOR etc.
(defmacro tokenval  (x) `(second ,x))       ; value of the token
(defmacro datatype  (x) `(third ,x))        ; INTEGER REAL STRINGTYPE BOOLETYPE
(defmacro operands  (x) `(fourth ,x))       ; pointer to operand tokens
(defmacro link      (x) `(fifth ,x))        ; pointer to token at same level
(defmacro symtype   (x) `(sixth ,x))        ; pointer to type in symbol table
(defmacro symentry  (x) `(seventh ,x))      ; pointer to symbol table entry

; Print values for operators
(defvar *op-print*
  (make-array 29 :initial-contents
	         `(nil |+| |-| |*| |/| |:=| |=| |<>| |<| |<=|
		   |>=| |>|  |^| |.| and or not div mod
		   in if goto progn label funcall
		   aref program float fix)))

(defvar *reserved-print*
  (make-array 30 :initial-contents
	         '(nil array begin case const do downto else end file for
		       function goto if label nil of packed procedure program
		       record repeat set then to type until var while with)))
(defvar *delim-print*
  (make-array 9 :initial-contents '(nil "," ";" ":" "(" ")" "[" "]" "..")))

; 12 Jan 95
; Allocate storage for a token and optionally fill some slots
(defun talloc (&optional tokentype tokenval datatype)
  (list tokentype tokenval datatype nil nil nil nil))

; 12 Jan 95; 15 Jan 95
; Translate a code tree into a form for pretty-printing
(defun code-to-pp (code)
  (case (tokentype code)
    (operator (cons (aref *op-print* (tokenval code))
		    (args-to-pp (operands code))))
    (identifiertok (intern (string-upcase (tokenval code)))) ; avoids print ""
    ((stringtok numbertok) (tokenval code))
    (t 'error)) )

; 12 Jan 95
; Map argument list using code-to-pp and link
(defun args-to-pp (code)
  (if code
      (cons (code-to-pp code)
	    (args-to-pp (link code)) ) ) )

; 12 Jan 95
; Pretty-print an expression
(defun ppexpr (code) (pprint (code-to-pp code)))

; 12 Jan 95; 04 Feb 98
; Print a single token.  Use this for the lexical analyzer assignment.
(defun printtoken (tok)
  (case (tokentype tok)
    (operator (format t "~A~20T~2D  ~A~%" (tokentype tok) (tokenval tok)
		      (aref *op-print* (tokenval tok))))
    (delimiter (format t "~A~20T~2D  ~A~%" (tokentype tok) (tokenval tok)
		       (aref *delim-print* (tokenval tok))))
    (reserved (format t "~A~20T~2D  ~A~%" (tokentype tok) (tokenval tok)
		        (aref *reserved-print* (tokenval tok))))
    (identifiertok (format t "~A ~22T  ~A~%" (tokentype tok) (tokenval tok)))
    (stringtok (format t "~A ~22T  ~S~%" (tokentype tok) (tokenval tok)))
    (numbertok (if (eq (datatype tok) 'integer)
		(format t "~A~15T~A  ~D~%" (tokentype tok)
			(datatype tok) (tokenval tok))
	        (if (eq (datatype tok) 'real)
		    (format t "~A~18T~A  ~14,8E~%" (tokentype tok)
			    (datatype tok) (tokenval tok))
		    (format t "~A    ~A~%" 'error tok))))
    (t (format t "Bad token type:  ~A~%" tok)) ) )

; operators in intermediate code
(defvar *plusop*         1)
(defvar *minusop*        2)
(defvar *timesop*        3)
(defvar *divideop*       4)
(defvar *assignop*       5)
(defvar *eqop*           6)
(defvar *neop*           7)
(defvar *ltop*           8)
(defvar *leop*           9)
(defvar *geop*          10)
(defvar *gtop*          11)
(defvar *pointerop*     12)
(defvar *dotop*         13)
(defvar *andop*         14)
(defvar *orop*          15)
(defvar *notop*         16)
(defvar *divop*         17)
(defvar *modop*         18)
(defvar *inop*          19)
(defvar *ifop*          20)
(defvar *gotoop*        21)
(defvar *prognop*       22)
(defvar *labelop*       23)
(defvar *funcallop*     24)
(defvar *arefop*        25)
(defvar *programop*     26)
(defvar *floatop*       27)
(defvar *fixop*         28)

; operators
(defvar *plus*   1)
(defvar *minus*  2)
(defvar *times*  3)
(defvar *divide* 4)
(defvar *assign* 5)
(defvar *eq*     6)
(defvar *ne*     7)
(defvar *lt*     8)
(defvar *le*     9)
(defvar *ge*    10)
(defvar *gt*    11)
(defvar *point* 12)
(defvar *dot*   13)
(defvar *and*   14)
(defvar *or*    15)
(defvar *not*   16)
(defvar *div*   17)
(defvar *mod*   18)
(defvar *in*    19)

; delimiters
(defvar *comma*     1)
(defvar *semicolon* 2)
(defvar *colon*     3)
(defvar *lparen*    4)
(defvar *rparen*    5)
(defvar *lbracket*  6)
(defvar *rbracket*  7)
(defvar *dotdot*    8)

; reserved words
(defvar *array*      1)
(defvar *begin*      2)
(defvar *case*       3)
(defvar *const*      4)
(defvar *do*         5)
(defvar *downto*     6)
(defvar *else*       7)
(defvar *end*        8)
(defvar *file*       9)
(defvar *for*       10)
(defvar *function*  11)
(defvar *goto*      12)
(defvar *if*        13)
(defvar *label*     14)
(defvar *nil*       15)
(defvar *of*        16)
(defvar *packed*    17)
(defvar *procedure* 18)
(defvar *program*   19)
(defvar *record*    20)
(defvar *repeat*    21)
(defvar *set*       22)
(defvar *then*      23)
(defvar *to*        24)
(defvar *type*      25)
(defvar *until*     26)
(defvar *var*       27)
(defvar *while*     28)
(defvar *with*      29)
