(in-package #:gsicr)

(defun connection-spec (cfg)
  (list (db-config-name cfg)
        (db-config-user cfg)
        (db-config-password cfg)
        (db-config-host cfg)
        :port (db-config-port cfg)
        :sslmode (db-config-sslmode cfg)))

(defmacro with-db ((cfg) &body body)
  `(postmodern:with-connection (connection-spec ,cfg)
     ,@body))

(defun ensure-schema (cfg)
  (with-db (cfg)
    (postmodern:execute
     (format nil "create schema if not exists ~a" (db-config-schema cfg)))))

(defun ensure-table (cfg)
  (with-db (cfg)
    (postmodern:execute
     (format nil
             "create table if not exists ~a.intro_calls (\n  id bigserial primary key,\n  scholar_name text not null,\n  partner_org text not null,\n  call_date date not null,\n  outcome text not null,\n  follow_up_date date,\n  notes text,\n  created_at timestamptz not null default now()\n)"
             (db-config-schema cfg)))))

(defun init-db (cfg)
  (ensure-schema cfg)
  (ensure-table cfg))

(defun seed-data (cfg)
  (with-db (cfg)
    (let ((table (format nil "~a.intro_calls" (db-config-schema cfg))))
      (postmodern:execute
       (format nil "insert into ~a (scholar_name, partner_org, call_date, outcome, follow_up_date, notes) values ($1,$2,$3,$4,$5,$6)" table)
       "Marisol Vega" "Future Scholars Network" "2026-01-12" "attended" "2026-01-19" "Interested in STEM mentorship.")
      (postmodern:execute
       (format nil "insert into ~a (scholar_name, partner_org, call_date, outcome, follow_up_date, notes) values ($1,$2,$3,$4,$5,$6)" table)
       "Nico Patel" "Bridge2College" "2026-01-20" "no-show" "2026-01-27" "Reschedule requested.")
      (postmodern:execute
       (format nil "insert into ~a (scholar_name, partner_org, call_date, outcome, follow_up_date, notes) values ($1,$2,$3,$4,$5,$6)" table)
       "Harper Kim" "Dream Scholars" "2026-02-03" "converted" "2026-02-10" "Completed intake; awaiting transcript."))))

(defun add-intro-call (cfg scholar partner call-date outcome follow-up-date notes)
  (with-db (cfg)
    (let ((table (format nil "~a.intro_calls" (db-config-schema cfg))))
      (postmodern:query
       (format nil "insert into ~a (scholar_name, partner_org, call_date, outcome, follow_up_date, notes) values ($1,$2,$3,$4,$5,$6) returning id" table)
       scholar partner call-date outcome follow-up-date notes
       :single))))

(defun list-intro-calls (cfg limit)
  (with-db (cfg)
    (let ((table (format nil "~a.intro_calls" (db-config-schema cfg))))
      (postmodern:query
       (format nil
               "select id, scholar_name, partner_org, call_date, outcome, follow_up_date, notes from ~a order by call_date desc, id desc limit $1"
               table)
       limit))))

(defun summarize-intro-calls (cfg)
  (with-db (cfg)
    (let ((table (format nil "~a.intro_calls" (db-config-schema cfg))))
      (postmodern:query
       (format nil
               "select outcome, count(*) as total, max(call_date) as last_call from ~a group by outcome order by total desc"
               table)))))

(defun partner-summary (cfg limit)
  (with-db (cfg)
    (let ((table (format nil "~a.intro_calls" (db-config-schema cfg))))
      (postmodern:query
       (format nil
               "select partner_org,\n        count(*) as total,\n        sum(case when outcome = 'attended' then 1 else 0 end) as attended,\n        sum(case when outcome = 'converted' then 1 else 0 end) as converted,\n        sum(case when outcome = 'no-show' then 1 else 0 end) as no_show,\n        max(call_date) as last_call,\n        min(follow_up_date) filter (where follow_up_date >= current_date) as next_follow_up\n  from ~a\n group by partner_org\n order by total desc, partner_org asc\n limit $1"
               table)
       limit))))

(defun upcoming-follow-ups (cfg days)
  (with-db (cfg)
    (let ((table (format nil "~a.intro_calls" (db-config-schema cfg))))
      (postmodern:query
       (format nil
               "select scholar_name, partner_org, follow_up_date, outcome from ~a where follow_up_date is not null and follow_up_date <= (current_date + $1::int) order by follow_up_date asc"
               table)
       days))))
