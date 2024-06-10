; Use the following 'while' macro if your Lisp does not provide it.

(defmacro while (test &rest forms)
  `(loop (unless ,test (return)) ,@forms) )
