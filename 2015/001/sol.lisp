(ql:quickload "esw")

;; part 1
(let ((level 0)
      (string-input (esw:string-of-file "input")))
  (loop for i from 0 below (length string-input)
        for c = (aref string-input i)
        do (cond ((char= c #\() (incf level))
                 ((char= c #\)) (decf level))
                 (t (format t "ERROR~%")))
        finally (return level)))

;; part 2
(let ((level 0)
      (string-input (esw:string-of-file "input")))
  (loop for i from 0 below (length string-input)
        for c = (aref string-input i)
        do (cond ((char= c #\() (incf level))
                 ((char= c #\)) (decf level))
                 (t (format t "ERROR~%")))
        if (= level -1) return (+ 1 i)))

