(ql:quickload :cl-ppcre)
(ql:quickload :esw)

(defparameter *pattern* 
  (cl-ppcre:create-scanner "\\d+"))

(defparameter *lines* (esw:get-lines "input"))

(defun get-dims (string-dims pattern)
  (let ((a (make-array 3))
       (matches (cl-ppcre:all-matches-as-strings pattern string-dims)))
  (loop for m in matches
        for i = 0 then (+ 1 i)
        do (setf (aref a i) (parse-integer m)))
  a))

(defun get-perim (a b)
  (+ (* 2 a) (* 2 b)))

;; part 1
(loop for line in *lines*
      for dims = (get-dims line *pattern*)
      for l = (aref dims 0)
      for w = (aref dims 1)
      for h = (aref dims 2)
      for a = (* l w)
      for b = (* w h)
      for c = (* h l)
      for min-side = (min a b c)
      sum (+ (* 2 a) (* 2 b) (* 2 c) min-side))

;; part 2
(loop for line in *lines*
      for dims = (get-dims line *pattern*)
      for l = (aref dims 0)
      for w = (aref dims 1)
      for h = (aref dims 2)
      for a = (get-perim l w)
      for b = (get-perim w h)
      for c = (get-perim l h)
      for min-perim = (min a b c)
      sum (+ min-perim (* l h w)))
