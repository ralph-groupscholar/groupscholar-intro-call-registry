(in-package #:gsicr)

(defun main ()
  (handler-case
      (multiple-value-bind (command options)
          (parse-args (command-line-arguments))
        (handle-command command options))
    (error (err)
      (format t "Error: ~a~%" err)
      (usage)
      (uiop:quit 1))))
