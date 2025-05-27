(ql:quickload :esw)

(defparameter *input* (esw:string-of-file "input"))

(defun get-key (x y)
  (format nil "~a,~a" x y))

;; part 1
(let ((x 0)
      (y 0)
      (hash (make-hash-table :test 'equal)))
  (setf (gethash (get-key x y) hash) 1)
  (loop for c across *input*
        do (case c
             (#\^ (decf y))
             (#\v (incf y))
             (#\< (decf x))
             (#\> (incf x)))
        do (setf
             (gethash (get-key x y) hash)
             (1+ (or (gethash (get-key x y) hash) 0))))
  (format t "~a~%" (hash-table-count hash)))

;; part 2
(let ((x1 0)
      (y1 0)
      (x2 0)
      (y2 0)
      (hash (make-hash-table :test 'equal)))
  (setf (gethash (get-key x1 y1) hash) 1)
  (loop for c across *input*
        for i = 0 then (1+ i)
        do (case c
             (#\^ (if (oddp i) (decf y1) (decf y2)))
             (#\v (if (oddp i) (incf y1) (incf y2)))
             (#\< (if (oddp i) (decf x1) (decf x2)))
             (#\> (if (oddp i) (incf x1) (incf x2))))
        do (let ((key (get-key (if (oddp i) x1 x2)
                               (if (oddp i) y1 y2))))
             (setf (gethash key hash)
                   (1+ (or (gethash key hash) 0)))))
  (format t "~a~%" (hash-table-count hash)))
