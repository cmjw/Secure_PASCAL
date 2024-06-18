; /projects/cs375/expenglish.lsp  ; 22 Apr 05; 28 Apr 06

; Convert a prefix expression to English

; (exp->english 'x)
; (exp->english '(+ x y))
; (exp->english '(+ (sin x) (* y (cos z))))

(defun op  (x) (first x))
(defun lhs (x) (second x))
(defun rhs (x) (third x))

; convert an operator:  + -> (the sum of)
(defun op->english (op)
  (list 'the
        (second (assoc op '((+ sum)
			    (- difference)
			    (* product)
                            (/ quotient)
			    (sin sine)
			    (cos cosine))))
        'of))

; given an expression, return a list of words describing the expression.
(defun exp->english (x)
  (if (consp x)                 ; is it an interior node (operator) ?
      (append                     ; operator
        (op->english (op x))      ; preorder: op "of" lhs "and" rhs
	(exp->english (lhs x))
	(if (null (cddr x))  ; unary?
	    '()
	    (cons 'and
		  (exp->english (rhs x)) ) ) )
      (list x) ) )                ; leaf node: operand
