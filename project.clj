(defproject mire "0.13.1"
  :description "A multiuser text adventure game/learning project."
  :main ^:skip-aot mire.server
  :dependencies [[org.clojure/clojure "1.10.3"]
                 [server-socket "1.0.0"]
                 [org.jpl7/jpl7 "4.0.0"]])
