(let [input (slurp "input1")]
  (println 
    (apply max
           (map #(reduce + %) 
                (map #(map read-string (clojure.string/split % #"\n"))
                     (clojure.string/split input #"\n\n"))))))
