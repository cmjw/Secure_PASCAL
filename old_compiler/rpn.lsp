; rpn.lsp            Gordon S. Novak Jr.            16 Apr 91

; Copyright (c) 1991 by The University of Texas System.

; Reverse Polish Notation for arithmetic expressions.


; Convert a tree in the usual Lisp form into reverse polish.
; e.g. (tree-to-polish '(+ (* a b) c))
(defun tree-to-polish (exp) (nreverse (tree-to-p exp nil)))

(defun tree-to-p (exp result)
  (if (atom exp)
      (cons exp result)
      (progn
        (mapc #'(lambda (opnd)
                  (setq result
                        (tree-to-p opnd
                                   result)))
                  (rest exp))
        (cons (first exp) result))))

(setq testx '(/ (+ (minus b)
                   (sqrt (- (expt b 2)
                            (* 4 (* a c)))))
                (* 2 a)))

; (tree-to-polish testx) = (B MINUS B 2 EXPT 4 A C * * - SQRT + 2 A * /)

; convert a reverse polish expression to Lisp tree form
; e.g (polish-to-tree '(3 4 + 5 *))
(defun polish-to-tree (rpn)
  (let (stack rhs)
    (dolist (item rpn)
      (if (operatorp item)
          (progn (setq rhs (pop stack))
                 (push (if (unaryp item)
                           (list item rhs)
                           (list item
				 (pop stack)
				 rhs))
                       stack))
	  (push item stack)))
    (pop stack) ))

; execute a reverse polish expression consisting of numbers and operators
; e.g (execute-rpn '(3 4 + 5 *))
(defun execute-rpn (rpn)
  (let (stack rhs)
    (dolist (item rpn)
      (if (numberp item)
          (push item stack)
          (progn (setq rhs (pop stack))
                 (push (if (unaryp item)
                           (funcall item rhs)
                           (funcall item
                                    (pop stack)
                                    rhs))
                       stack))))
    (pop stack) ))

(defun operatorp (x) (member x '(+ - * / minus sqrt expt)))
(defun unaryp (x) (member x '(minus sqrt)))

(defun minus (x) (- x))

; (execute-rpn (sublis '((a . 1) (b . -3) (c . 2)) (tree-to-polish testx)))
