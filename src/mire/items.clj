(ns mire.items
  (:require [clojure.java.io :as io]))

(def all-items (ref #{}))
(def all-recipes (ref {}))

;; Item loading logic

(defn load-items [items file]
  (let [items-contained (read-string (slurp (.getAbsolutePath file)))]
    (into items items-contained)))

(defn add-items [dir]
  (let [file (io/file dir)]
    (dosync
      (alter all-items load-items file))))

;; Recipe control logic

(defn load-recipes [file] 
  (read-string (slurp (.getAbsolutePath file))))

(defn add-recipes [dir]
  (let [file (io/file dir)]
    (dosync
     (alter all-recipes merge (load-recipes file)))))

(defn get-recipe [item]
  (let [item-keyword (keyword item)]
    (get @all-recipes item-keyword)))

(defn can-craft? [inventory recipe]
  (every? #(contains? inventory %) recipe))

(defn craft-item [inventory-ref item]
  (if-let [recipe (get-recipe item)]
    (let [inventory @inventory-ref]
      
      (if (can-craft? inventory recipe)
        (dosync
         (alter inventory-ref #(reduce disj % recipe))
         (alter inventory-ref conj item)
         ;; return
         {:success true :item item})
        ;; return
        {:success false :message "Unknown recipe!"}))
    ;; return
    {:success false :message "Not enough resources!"}))

(defn get-available-recipes [inventory]
  (filter (fn [[item recipe ]]
            (can-craft? inventory recipe))
          @all-recipes))