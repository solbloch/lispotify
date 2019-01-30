(asdf:defsystem #:lispotify
  :description "spotify common lisp wrapper"
  :author "sol bloch"
  :license  "uhhhhhhhhh"
  :version "0.0.1"
  :serial t
  :depends-on (#:jsown
               #:dexador
               #:cl-base64
               #:cl-ppcre)
  :components ((:file "package")
               (:file "tokens")
               (:file "lispotify")))
