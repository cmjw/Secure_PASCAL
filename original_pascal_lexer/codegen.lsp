; codegen.lsp       Gordon S. Novak Jr.      27 Nov 00; 03 Aug 22

; simplified code gen for expressions
; (genarith '(* (+ a b) 3))

(defun op  (x) (car x))
(defun lhs (x) (cadr x))
(defun rhs (x) (caddr x))

(defvar registers)
(setq registers '(eax ebx ecx edx))

(defun getreg () (pop registers))

(defun genarith (x)
  (if (atom x)              ; if leaf,
      (genload x (getreg))  ;   load
      (genop (op x)         ; else op
             (genarith (lhs x))
             (genarith (rhs x))) ) )

(defun genop (op lhsr rhsr)   ; op S D for x86
  (format t "   ~A   ~D,~D~%"
    (cadr (assoc op '((+ addl) (* imull) (/ ldiv) (- subl))))
    rhsr lhsr)
  lhsr)

(defun genload (x r)
  (format t "   MOVL  ~A,~D~%" x r)
  r)
