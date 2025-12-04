(load (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname)))
(ql:quickload :uiop)
(ql:quickload :cl-ppcre)

(defparameter *f* (uiop:read-file-lines "./input"))

(defparameter *pair-strings* (cl-ppcre:split "," (car *f*)))

(defun split-str (s)
  (mapcar (lambda (n) (parse-integer n))
          (cl-ppcre:split "-" s)))

(defparameter *pairs* (mapcar #'split-str *pair-strings*))


(defun palindrome-p (n)
  (let* ((str (format nil "~d" n))
         (len (length str))
         (is-even (and (not (eq 1 len)) (eq 0 (mod len 2))))
         (mid (/ len 2)))
    (if is-even (string= (subseq str 0 mid) (subseq str mid)) nil)))

(let ((sum 0))
  (loop for p in *pairs*
        do (loop for i from (car p) to (cadr p)
              do 
              (when (palindrome-p i)
                (setf sum (+ sum i)))))
  (format t "part 1: ~a~%" sum))


(defun divides (n div)
    (eq 0 (mod n div)))

;; presumes divides evenly
(defun substrs-all-equal-p (str len)
  (let ((sub (subseq str 0 len)))
    (loop for i from len to (- (length str) len) by len
          unless (string= sub (subseq str i (+ i len)))
            return nil
          finally (return t))))

(defun includes-pair-p (n)
  (let* ((str (format nil "~d" n))
         (len (length str)))
    (loop for i from 1 to (/ len 2)
          when (and (divides len i)
                    (substrs-all-equal-p str i))
          return t
          finally (return nil))))

(let ((sum 0))
  (loop for p in *pairs*
        do (loop for i from (car p) to (cadr p)
              do 
              (when (includes-pair-p i)
                (setf sum (+ sum i)))))
  (format t "part 2: ~a~%" sum))
