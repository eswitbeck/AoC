(let [listOfCalorieLists 
      (map #(map read-string (clojure.string/split % #"\n"))
                   (clojure.string/split (slurp "input1") #"\n\n"))]
  (println 
    (apply max
           (map #(reduce + %) 
                listOfCalorieLists))))
