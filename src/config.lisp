(in-package #:gsicr)

(defstruct db-config
  host
  port
  name
  user
  password
  sslmode
  schema)

(defun require-env (key)
  (let ((value (getenv key)))
    (when (or (null value) (string= value ""))
      (error "Missing required environment variable: ~a" key))
    value))

(defun safe-identifier (value)
  (unless (and value
               (every (lambda (ch)
                        (or (alphanumericp ch) (char= ch #\_)))
                      value))
    (error "Unsafe identifier: ~a" value))
  value)

(defun load-db-config ()
  (make-db-config
   :host (require-env "GSICR_DB_HOST")
   :port (parse-integer (require-env "GSICR_DB_PORT"))
   :name (require-env "GSICR_DB_NAME")
   :user (require-env "GSICR_DB_USER")
   :password (require-env "GSICR_DB_PASSWORD")
   :sslmode (or (getenv "GSICR_DB_SSLMODE") "disable")
   :schema (safe-identifier (or (getenv "GSICR_DB_SCHEMA")
                                "gs_intro_call_registry"))))
