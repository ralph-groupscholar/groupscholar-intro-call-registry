(asdf:defsystem #:groupscholar-intro-call-registry
  :description "Intro call registry CLI for Group Scholar"
  :author "Ralph"
  :license "MIT"
  :serial t
  :depends-on (#:postmodern #:uiop)
  :components ((:file "src/package")
               (:file "src/config")
               (:file "src/db")
               (:file "src/cli")
               (:file "src/main")))

(asdf:defsystem #:groupscholar-intro-call-registry/tests
  :description "Tests for groupscholar-intro-call-registry"
  :author "Ralph"
  :license "MIT"
  :serial t
  :depends-on (#:fiveam #:groupscholar-intro-call-registry)
  :components ((:file "tests/gsicr-tests")))
