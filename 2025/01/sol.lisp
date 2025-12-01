(load (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname)))
(ql:quickload :uiop)
(ql:quickload :cl-ppcre)

(defparameter *f* (uiop:read-file-lines "./input"))

(let ((start 50)
      (z-count 0))
  (loop for l in *f*
        for matches = (cl-ppcre:all-matches-as-strings
                        "\\d+"
                        l)
        for num = (parse-integer (car matches))
        for dir = (aref l 0)
        for is-right = (char= #\R dir)
        do
        (setf start 
              (if is-right
                  (mod (+ start num) 100)
                  (mod (- start num) 100)))
        (when (eq 0 start) (incf z-count)))
  (format t "part 1: ~a~%" z-count))

(let ((start 50)
      (z-count 0))
  (loop for l in *f*
        for matches = (cl-ppcre:all-matches-as-strings
                        "\\d+"
                        l)
        for num = (parse-integer (car matches))
        for dir = (aref l 0)
        for is-right = (char= #\R dir)
        do
        (setf z-count
              (+ z-count
                 (if is-right
                     (floor (/ (+ start num) 100))
                     (+ (if (and (not (eq 0 start)) (>= num start)) 1 0)
                        (floor (/ (abs (- start num)) 100))))))
        (setf start 
              (if is-right
                  (mod (+ start num) 100)
                  (mod (- start num) 100))))
    (format t "part 2: ~a~%" z-count))
