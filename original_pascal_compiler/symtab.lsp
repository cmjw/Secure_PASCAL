; symtab.lsp            Gordon S. Novak Jr.               ; 03 Mar 16
; 17 Mar 95; 23 May 97; 09 Aug 99; 01 Aug 07; 05 Mar 08
; 14-Apr-1997: Added writei, writef, and writelni to the list of predefined
;              symbols. - Bobby Don Bryant <bdbryant@cs.utexas.edu>
; 09 Aug 99: fix for printing record fields - Shawn Manley
; 01 Aug 07: change symbol representation to proplist
; 03 Apr 15
;
; Symbol Table Code and Data for Pascal Compiler

; See the documentation file, symtab.txt        

; Copyright (c) 2007 Gordon S. Novak Jr. and
; The University of Texas at Austin.

; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.

; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

; To use:  1. Call (initsyms) once to initialize basic symbols.

;          2. Call (insertsym string) to insert a new symbol,
;                e.g. (insertsym (tokenval tok))
;                returns a symbol table pointer, of type SYMBOL.

;	   3. Call (searchst string) to search for a symbol,
;                e.g. (searchst (tokenval tok))
;                returns a symbol table pointer, of type SYMBOL.

;          4. (symalloc namestring kind) may be used to allocate a
;                symbol table entry without inserting it into the table.

; Symbol Table Record
(defmacro symname     (x) `(get ,x 'symname))     ; print name
(defmacro kind        (x) `(get ,x 'kind))        ; kind of symbol: VARSYM etc.
(defmacro basicdt     (x) `(get ,x 'basicdt))     ; INTEGER etc.
(defmacro symdatatype (x) `(get ,x 'symdatatype)) ; pointer to data type
(defmacro blocklevel  (x) `(get ,x 'blocklevel))  ; symbol table block level
(defmacro size        (x) `(get ,x 'size))        ; size in storage units (bytes)
(defmacro offset      (x) `(get ,x 'offset))      ; offset from data area base
(defmacro constval    (x) `(get ,x 'constval))    ; value for constant symbols
(defmacro lowbound    (x) `(get ,x 'lowbound))    ; low bound for subrange
(defmacro highbound   (x) `(get ,x 'highbound))   ; high bound for subrange
(defmacro symlink     (x) `(get ,x 'symlink))     ; link to next entry

; The kind field should be one of these:
; ARGSYM BASICTYPE CONSTSYM VARSYM SUBRANGE FUNCTIONSYM ARRAYSYM RECORDSYM
; TYPESYM POINTERSYM

(defvar *symdebug* nil)

(defvar *maxblocks*  10)       ; max number of program blocks
(defvar *blocknumber* 0)       ; number of current block being compiled

; containing block for block
(defvar *contblock* (make-array *maxblocks* :initial-element 0))
; storage offsets for block
(defvar *blockoffs* (make-array *maxblocks* :initial-element 0))
; symbol chain for block
(defvar *symtab*    (make-array *maxblocks* :initial-element nil))
; end of symbol chain for block
(defvar *symend*    (make-array *maxblocks* :initial-element nil))

; Sizes of basic types
(defvar *basicsizes* '((integer 4) (real 8) (char 1) (boolean 4) (pointer 8)))

; (defvar *symprint* (make-array 10)  = {" ", "BASIC", "CONST", "VAR", "SUBRANGE",
;                        "FUNCTION", "ARRAY", "RECORD", "TYPE", "POINTER"};
; int symsize[10] = { 1, 5, 5, 3, 8, 8, 5, 6, 4, 7 };

; 17 Jan 95; 01 Aug 07
; allocate a new symbol record
(defun symalloc (&optional symnm knd)
  (let (sym)
    (setq sym (intern (symbol-name (gensym "SYM"))))
    (if symnm (setf (symname sym) symnm))
    (if knd   (setf (kind sym) knd))
    sym))

; 17 Jan 95; 22 Feb 95
; Insert a name in the symbol table at current value of *blocknumber*
; Returns pointer to the new symbol table entry, which is empty
; except for the name.
(defun insertsym (name &optional kind)
  (let (sym syml)
    (setq sym (symalloc name kind))
    (setq syml (list sym))
    (if (aref *symtab* *blocknumber*)  ; Insert in 2-pointer queue
        (setf (cdr (aref *symend* *blocknumber*)) syml)
        (setf (aref *symtab* *blocknumber*) syml))
    (setf (aref *symend* *blocknumber*) syml)
    (setf (blocklevel sym) *blocknumber*)
    (if *symdebug* (format t "insertsym ~A~%" name))
    sym))

; 18 Jan 95; 01 Aug 07; 05 Mar 08
; Search all levels of the symbol table for the given name.       
; Result is a pointer to the symbol table entry or NIL
; Example: (searchst "real")
(defun searchst (name)
  (let (sym level)
    (setq level *blocknumber*)
    (while (and (null sym) (>= level 0))
      (setq sym (some #'(lambda (x)
                          (and (string-equal (symname x) name) x))
                      (aref *symtab* level)))
      (setq level (aref *contblock* level)) )      ; try containing block
    sym))

; 17 Jan 95
; Print all entries in the symbol table
(defun printst ()
  (dotimes (level *maxblocks*)
    (if (aref *symtab* level) (format t "~%Level ~d:~%" level))
    (dolist (sym (aref *symtab* level)) (printsymbol sym)) ) )

; 22 Feb 95; 17 Mar 95
; Print one symbol table entry      
(defun printsymbol (sym)
  (format t "~10s  ~11a  lvl ~2d  "
	  (symname sym) (kind sym) (blocklevel sym))
  (case (kind sym)
    ((ARRAYSYM RECORDSYM POINTERSYM)
      (format t "  siz ~5d" (size sym))
      (ppsym sym))
    (FUNCTIONSYM (ppsym sym))
    (VARSYM
      (if (eq (kind (symdatatype sym)) 'BASICTYPE)
	  (format t "  siz ~5d  off ~5d  typ ~A~%"
                  (size sym) (offset sym) (basicdt sym))
	  (progn (format t "  siz ~5d  off ~5d  typ:" (size sym) (offset sym))
		 (ppsym (symdatatype sym))) ) )
    (TYPESYM (format t "  siz ~5d" (size sym))
	     (if (eq (kind (symdatatype sym)) 'BASICTYPE)
		 (format t "  ~A~%" (basicdt (symdatatype sym)))  ; Jim Bednar
		 (ppsym (symdatatype sym))) )
    (BASICTYPE (format t "  siz ~5d~%" (size sym)) )
    (SUBRANGE (format t "  siz ~5d  val ~5d .. ~5d~%"
		      (size sym) (lowbound sym) (highbound sym)) )
    (CONSTSYM
      (case (basicdt sym)
	(INTEGER (format t "  ~10a  val  ~12d~%" (basicdt sym) (constval sym)))
	(REAL    (format t "  ~10a  val  ~12e~%" (basicdt sym) (constval sym)))
	(STRINGTYPE (format t "  ~10a  val  ~12s~%"
			    (basicdt sym) (constval sym)) ) ) ) ) )


; 22 Feb 95
; print a type expression in prefix form
(defun ppsym (sym)
  (pprint (prettysym sym))
  (terpri) )

; 22 Feb 95; 09 Aug 99
; Translate a symbol structure into a Lisp tree for pretty-printing
(defun prettysym (sym)
  (case (kind sym)
    (BASICTYPE (basicdt sym))     ; INTEGER, REAL, etc.
    (SUBRANGE (list '|..| (lowbound sym) (highbound sym)))
    (POINTERSYM (list '^ (symname (symdatatype sym))))
    (FUNCTIONSYM (cons 'function (prettylist (symdatatype sym))))
    (RECORDSYM (cons 'record (prettylist (symdatatype sym))))
    (ARRAYSYM (list 'array (list (lowbound sym) (highbound sym))
		    (prettysym (symdatatype sym))))
    (CONSTSYM (list 'constant (constval sym)))
    (VARSYM (list 'var (symname sym) (prettysym (symdatatype sym))))
    (TYPESYM (list 'type (prettysym (symdatatype sym))))
    (ARGSYM (prettysym (symdatatype sym)))
            ; record field -- fix by Shawn Manley
    (t      (cons (symname sym) (prettylist (symdatatype sym)))) ) )

; 22 Feb 95
; Translate a list of symbol structures into a Lisp list for pretty-printing
(defun prettylist (sym)
  (if sym
      (cons (prettysym sym)
	    (prettylist (symlink sym))) ) )

; 18 Jan 95
; Insert a basic type into the symbol table
(defun insertbt (name basictp siz)
  (let (sym)
    (setq sym (insertsym name 'BASICTYPE))
    (setf (basicdt sym) basictp)
    (setf (size sym) siz)
    sym))

; 18 Jan 95
; Insert a one-argument function in the symbol table.
; Linked to the function symbol are result type followed by arg types. 
(defun insertfn (name resulttp argtp)
  (let (sym res arg)
    (setq sym (insertsym name 'FUNCTIONSYM))
    (setq res (symalloc))
    (setf (kind res) 'ARGSYM)
    (setf (symdatatype res) resulttp)
    (if resulttp (setf (basicdt res) (basicdt resulttp)))
    (setq arg (symalloc nil 'ARGSYM))
    (setf (symdatatype arg) argtp)
    (if argtp (setf (basicdt arg) (basicdt argtp)))
    (setf (symlink arg) nil)
    (setf (symlink res) arg)
    (setf (symdatatype sym) res)
    sym))

; 18 Jan 95; 22 Feb 95
; Call this to initialize symbols provided by the compiler
(defun initsyms ()
  (let (realsym intsym stringsym boolsym)
    (setq *blocknumber* 0)               ; Put compiler symbols in block 0
    (dotimes (i *maxblocks*)
      (setf (aref *symtab* i) nil)
      (setf (aref *symend* i) nil)
      (setf (aref *blockoffs* i) 0))
    (setq realsym   (insertbt "real"    'REAL       8))
    (setq intsym    (insertbt "integer" 'INTEGER    4))
    (setq stringsym (insertbt "char"    'STRINGTYPE 1))
    (setq boolsym   (insertbt "boolean" 'BOOLETYPE  4))
    (insertfn "exp"   realsym realsym)
    (insertfn "sin"   realsym realsym)
    (insertfn "cos"   realsym realsym)
    (insertfn "sqrt"  realsym realsym)
    (insertfn "round" realsym realsym)
    (insertfn "ord"   intsym intsym)
    (insertfn "write"  nil nil)
    (insertfn "writei" nil intsym)
    (insertfn "writef" nil realsym)
    (insertfn "writeln"  nil nil)
    (insertfn "writelni" nil intsym)
    (insertfn "writelnf" nil realsym)
    (insertfn "read"   nil   nil)
    (insertfn "readln" nil   nil)
    (insertfn "eof"  boolsym nil)
    (setq *blocknumber* 1)             ; Start the user program in block 1
    (setf (aref *contblock* 0) -1)
    (setf (aref *contblock* 1) 0) ))
