;   db.lsp            Tiny Database Program        12 Nov 03
;   Gordon Novak     CS Dept   Univ. of Texas at Austin 78712

;   The following is probably the world's smallest Relational DBMS
;   (thanks to Lisp, which does most of the work).

(proclaim '(special *dbname* *dbrel*))
;   Function to define a database.  Args are name of the database,
;   a list of the names of the fields, and the data, which is a list
;   of tuples, each of which is a list of the data values in order.
(defun defdb (dbname props data)
  (let ((n 0))
    (dolist (prop props) (setf (get dbname prop) n) (incf n))
    (setf (get dbname 'data) data) ))

;   Get the value of a field from the current tuple.
;   The argument is an unquoted field name.
(defun getdb (prop)
  (let (n) (and (numberp (setq n (get *dbname* prop)))
	        (nth n *dbrel*) ) ))

;   Perform a database query.  Args are the name of the database,
;   the condition to be satisfied by the tuples that are desired,
;   and the action to be performed for each satisfied tuple.
(defun querydb (*dbname* condition action)
  (mapcan #'(lambda (*dbrel*)
	      (if (eval condition) (list (eval action))))
	  (get *dbname* 'data)))

;  The following functions are examples to illustrate the
;  proper form of calls to the database functions.

(defun dbexample1 nil              ; "WHO ORDERED WIDGETS IN APRIL" 
(querydb 'orderdb
	 '(and (equal (getdb (quote part))
		      (quote widget))
	       (equal (getdb (quote date-month))
		      4))
	 '(list (getdb (quote customer)))))

(defun dbexample2 nil  ; "WHAT CUSTOMERS IN AUSTIN ORDERED WIDGETS FROM ACME" 
(querydb 'orderdb
	 '(and (equal (getdb (quote part))
		      (quote widget))
	       (equal (getdb (quote supplier))
		      (quote acme))
	       (equal (getdb (quote customer-city))
		      (quote austin)))
	 '(list (getdb (quote customer)))))

;  The following makes a tiny database for testing.
(defdb 'orderdb
       '(order-number date-day date-month date-year part
		      supplier customer customer-city)
       '((101  1  4 2003 widget acme     mcc austin)
	 (102  1  1 2003 pliers sears    ut  austin)
	 (103  5  3 2003 tire   sears    hp  dallas)
	 (104 19  4 2003 tire   sears    ut  el-paso)
	 (105 25  4 2003 tire   goodyear mcc austin)
	 (106 22  2 2003 blimp  goodyear ut  dallas)
	 (107 25 12 2002 tire   goodyear ut  austin)
	 (108 11 11 2002 pliers acme     hp  austin)
	 (109  7  4 2003 widget acme     ut  dallas)
	 (110  9  4 2003 widget sears    mcc austin)))
