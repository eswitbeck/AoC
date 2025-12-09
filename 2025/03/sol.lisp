(load (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname)))
(ql:quickload :uiop)
(ql:quickload :cl-ppcre)

(defparameter *f* (uiop:read-file-lines "./input"))

(defun get-first-max (digit-list start-index end-index)
  (let ((max-num 0)
        (max-index nil))
    (loop for char in (subseq digit-list start-index end-index)
          for digit = (parse-integer char)
          for i = start-index then (+ 1 i)
          when (> digit max-num)
            do (progn 
                 (setf max-num digit)
                 (setf max-index i))
          finally (return (cons max-num max-index)))))

(defun find-max-digits (str)
  (let* ((digits-str (cl-ppcre:split "" str))
         (first-tuple (get-first-max digits-str
                                     0
                                     (- (length digits-str) 1)))
         (second-tuple (get-first-max digits-str
                                      (+ 1 (cdr first-tuple))
                                      (length digits-str))))
         (parse-integer (format nil "~d~d" (car first-tuple) (car second-tuple)))))

(format t "Part 1: ~d~%" (reduce 
                        (lambda (a b) (+ (find-max-digits b) a))
                        *f*
                        :initial-value 0))


(defun find-top-12 (str)
  (let* ((digits-str (cl-ppcre:split "" str))
        (digits-accum '())
        (prev-index 0)
        (len (length digits-str)))
    (loop for i from 12 downto 1
          do (let ((tuple (get-first-max digits-str
                                         prev-index
                                         (- len (- i 1)))))
               (push (car tuple) digits-accum)
               (setf prev-index (+ 1 (cdr tuple)))))
    (parse-integer (format nil "~{~a~}" (nreverse digits-accum)))))
          
(format t "Part 2: ~d~%" (reduce 
                        (lambda (a b) (+ (find-top-12 b) a))
                        *f*
                        :initial-value 0))
    
