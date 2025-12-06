(ns mire.spawner
  (:require [clojure.java.io :as io]))

(def items (ref #{}))

(defn load-items [items file]
  (let [items-contained (read-string (slurp (.getAbsolutePath file)))]
    (into items items-contained)))

(defn add-items [dir]
  (let [file (io/file dir)]
    (dosync
      (alter items load-items file))))