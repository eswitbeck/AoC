(def input (with-open [rdr (clojure.java.io/reader "input1")]
  (reduce conj '() (line-seq rdr))))

(def inputRemap (map (fn [x] (if (= "" x) x (read-string x))) input))

(defn walk [list] 
  (loop [car (first list) cdr (rest list) count 0 max 0]
    (if (not car)
      (println max)
        (recur
          (first cdr)
          (rest cdr)
          (if (string? car)
            0
            (+ count car ))
          (if (> max count)
            max
            count)))))

(walk inputRemap)
