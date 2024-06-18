;   atn.lsp              Gordon S. Novak Jr.         ; 14 Apr 04

; 10 Apr 90; 07 Nov 03; 14 Nov 03; 18 Nov 03; 04 Feb 04; 10 Feb 04; 13 Feb 04

;   cf. W.A. Woods, "Transition Network Grammars for Natural
;       Language Analysis", Communications of the ACM, Oct. 1970.

(defvar *sent*     nil)   ;  remainder of input sentence
(defvar *next*     nil)   ;  next position in input sentence
(defvar *word*     nil)   ;  current word being examined
(defvar *savesent* nil)   ;  stack of saved positions in sentence for backup
(defmacro part-of-speech (x) `(get ,x 'part-of-speech))

;   The following manipulate scanner position in the sentence.

; initialize for a new sentence
(defun init-sent (sent) (setq *sent* sent) (setword))

;   set *word* for current position
(defun setword ()
  (let (multi)
    (setq *word* (first *sent*))
    (setq *next* (rest *sent*))
    (if (and (symbolp *word*)
	     (setq multi (some #'(lambda (x)
				   (if (equalfront (car x) (rest *sent*)) x))
			       (get *word* 'multiwords))))
	(progn (setq *word* (cadr multi))
	       (setq *next* (nthcdr (1+ (length (car multi))) *sent*)))) ))

;   move to next word
(defun next    () (setq *sent* *next*) (setword) t)

;   save the current position
(defun saveptr () (push *sent* *savesent*))

;   pop the stack on success
(defun success () (pop *savesent*) t)

;   restore position on failure, return nil
(defun fail    () (setq *sent* (pop *savesent*)) (setword) nil)

;   test whether the current *word* is in a given category
(defun cat (category)
  (and (symbolp *word*)
       (or (and (eq category 'unk)
		(not (get *word* 'parts-of-speech)))
	   (get *word* category))))

;   define a lexicon.
;   Arg is a list of lists, each of which is:
;     (category (list of items))
;   Each item is either a word, a list (word value), or ((words) singleword).
;   In the last case, singleword should also be defined (possibly with a value)
;   e.g.   (animal (dog ((three blind mice) tbm) (tbm 3)))
(defun deflexicon (lst)
  (dolist (l lst)
    (let ((category (first l)))
      (setf (part-of-speech category) t)
      (dolist (item (second l))
        (if (symbolp item)
            (deflex item category item)
            (if (consp item)
		(deflex (first item) category (second item)) ) ) ) ) ) )

(defun deflex (word category value)
  (let (multi)
    (if (symbolp word)
	(progn (pushnew category (get word 'parts-of-speech))
	       (pushnew word (get category 'members))
	       (setf (get word category) value))
        (progn (pushnew category (get value 'parts-of-speech))
	       (pushnew value (get category 'members))
	       (setq multi (list (cdr word) value))
	       (or (member multi (get (car word) 'multiwords) :test #'equal)
		   (setf (get (car word) 'multiwords)
			 (sort (cons multi (get (car word) 'multiwords))
			       #'(lambda (x y) (> (length (car x))
						  (length (car y))))))))) ))

; test if front part of lst is equal to front
(defun equalfront (front lst)
  (or (null front)
      (and (eq (car front) (car lst))
	   (equalfront (cdr front) (cdr lst)))))
