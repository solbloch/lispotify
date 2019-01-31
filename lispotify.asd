(asdf:defsystem #:lispotify
  :description "spotify common lisp wrapper"
  :author "sol bloch"
  :license  "uhhhhhhhhh"
  :version "0.0.1"
  :serial t
  :depends-on (#:jsown
               #:quri
               #:dexador
               #:cl-base64
               #:cl-ppcre)
  :components ((:file "package")
               (:file "id")
               (:file "tokens")
               (:file "lispotify")
               (:file "dbus")))
