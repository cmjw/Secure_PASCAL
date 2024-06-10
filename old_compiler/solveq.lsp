; solveq.lsp           Gordon S. Novak Jr.    06 Apr 04; 13 Apr 04; 23 Apr 04

; Copyright (c) 2004 Gordon S. Novak Jr. and the University of Texas at Austin
; derived from asg10.scm ; 16 Oct 98; 24 Oct 00

(or (fboundp 'while)
    (defmacro while (test &rest forms)
      `(loop (unless ,test (return)) ,@forms) ) )

; Find variables in a formula
; (vars '(= a b)) ; = (b a)
(defun vars (f) (reverse (varsb f '())))
; Find vars in x and add to vars if not present
(defun varsb (x vars)
  (if (symbolp x)
      (if (or (constantp x) (member x '(pi)) (member x vars))
          vars
          (cons x vars))
      (if (consp x)
          (varsl (cdr x) vars)
          vars) ) )

; Find vars in elements of a list l and add to vars
(defun varsl (l vars)
  (if (consp l)
      (varsl (cdr l) (varsb (car l) vars))
      vars))

; Evaluate an expression given values for vars
; (evalexp '(+ b a) '((a . 3) (b . 4))) ; = 7
(defun evalexp (form alist) (eval (sublis alist form)))

(defun op  (x) (car x))         ; operator of expression
(defun lhs (x) (cadr x))        ; left-hand side of expression
(defun rhs (x) (caddr x))       ; right-hand side of expression

; Substitute one formula into another
; (substin '(= s (* 0.5 (* a (expt t 2)))) '(= a (/ f m)))
(defun substin (form1 form2) (subst (rhs form2) (lhs form2) form1))

; Second solution -- using pattern matching (patmatch.scm)

(defvar  *solvepatterns*
  '( ( (= ?lhs (+ ?x ?y))   (= (- ?lhs ?x)   ?y) )
     ( (= ?lhs (+ ?x ?y))   (= (- ?lhs ?y)   ?x) )
     ( (= ?lhs (* ?x ?y))   (= (/ ?lhs ?x)   ?y) )
     ( (= ?lhs (* ?x ?y))   (= (/ ?lhs ?y)   ?x) )
     ( (= ?lhs (- ?x ?y))   (= (- ?x ?lhs)   ?y) )
     ( (= ?lhs (- ?x ?y))   (= (+ ?lhs ?y)   ?x) )
     ( (= ?lhs (/ ?x ?y))   (= (/ ?x ?lhs)   ?y) )
     ( (= ?lhs (/ ?x ?y))   (= (* ?lhs ?y)   ?x) )
     ( (= ?lhs (expt ?x 2)) (= (sqrt ?lhs)   ?x) )
     ( (= ?lhs (sqrt ?x))   (= (expt ?lhs 2) ?x) )
     ( (= ?lhs (log ?x))    (= (exp ?lhs)    ?x) )
     ( (= ?lhs (exp ?x))    (= (log ?lhs)    ?x) )
     ( (= ?lhs (- ?x))      (= (- ?lhs)      ?x) )
     ) )

; Solve a formula for a desired variable
(defun solve2 (form var)
  (if (eq (lhs form) var)
      form
      (if (eq (rhs form) var)
          (list '= (rhs form) (lhs form))
          (and (consp (rhs form))
	       (some (lambda (pats)
		       (let ((new (transf pats form)))
			 (and new (not (eq new 'match-failure))
			      (solve2 new var)) ) )
		     *solvepatterns*)) ) ) )

; Define a function to compute a variable given an equation
(defun make-fn (fn e var)
  (let* ((vars (vars e))
	 (fnvars (set-difference vars (list var)))
	 (newe (solve e var)) )
    (eval (list 'define (cons fn fnvars) (rhs newe))) ))

; 06 Apr 04
; Solve a set of equations for variable var given values alist
(defun solveqns (equations var alist)
  (let (done (progress t) v)
    (while (and (not done) progress)
      (setq progress nil)
      (dolist (eqn equations)
	(setq v (set-difference (vars eqn) (mapcar #'car alist)))
	(if (= (length v) 1)
	    (progn (setq progress t)
		   (push (cons (car v)
			       (eval (sublis alist
					     (rhs (solve2 eqn (car v))))))
			 alist))))
      (setq done (assoc var alist)) )
    (cdr (assoc var alist)) ))

