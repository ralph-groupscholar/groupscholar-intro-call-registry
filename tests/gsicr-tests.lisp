(defpackage #:gsicr-tests
  (:use #:cl #:fiveam)
  (:export #:run-tests))

(in-package #:gsicr-tests)

(def-suite gsicr)
(in-suite gsicr)

(test safe-identifier-accepts
  (is (string= "gs_intro_call_registry" (gsicr::safe-identifier "gs_intro_call_registry"))))

(test safe-identifier-rejects
  (signals error (gsicr::safe-identifier "bad-name;")))

(test parse-args-add
  (multiple-value-bind (command options)
      (gsicr::parse-args '("add" "--scholar" "A" "--partner" "B" "--call-date" "2026-02-01" "--outcome" "attended"))
    (is (string= "add" command))
    (is (string= "A" (gethash "--scholar" options)))
    (is (string= "B" (gethash "--partner" options)))))

(test parse-args-help
  (multiple-value-bind (command options)
      (gsicr::parse-args '("--help"))
    (declare (ignore options))
    (is (string= "help" command))))

(defun run-tests ()
  (run! 'gsicr))
