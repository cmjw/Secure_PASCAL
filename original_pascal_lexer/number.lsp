; number.lsp           Gordon S. Novak Jr.              20 Jan 95

; Simple number conversion.  Use with scanner.lsp and tokendefs.lsp .
; To test:
;   (setq *lines* '("357"))
;   (test-scanner)

; Parse an integer and convert to machine binary form.
(defun parse-number ()
  (let (num c charval)
    (setq num 0)
    (while (and (setq c (peekchar))
		(eql (charclass c) *numeric*))
      (setq c (getchar))
      (setq charval (- (char-code c) (char-code #\0)))
      (setq num (+ (* num 10) charval)) )
    (talloc 'numbertok num 'integer) ))
