# Group Scholar Intro Call Registry

Common Lisp CLI to log scholar intro calls, track follow-ups, and summarize outcomes for Group Scholar outreach workflows.

## Features
- Create schema and tables for intro call tracking
- Add new intro call records with follow-up dates and notes
- List recent calls and summarize outcomes
- Show upcoming follow-ups within a configurable window

## Tech
- Common Lisp (SBCL)
- Postgres (production database)
- Postmodern + Quicklisp

## Setup
1. Install SBCL (already available via Homebrew).
2. Install Quicklisp:
   - `curl -O https://beta.quicklisp.org/quicklisp.lisp`
   - `sbcl --load quicklisp.lisp --eval '(quicklisp-quickstart:install)' --eval '(ql:add-to-init-file)' --quit`
3. Set environment variables:
   - `GSICR_DB_HOST`, `GSICR_DB_PORT`, `GSICR_DB_NAME`, `GSICR_DB_USER`, `GSICR_DB_PASSWORD`
   - Optional: `GSICR_DB_SCHEMA` (default `gs_intro_call_registry`), `GSICR_DB_SSLMODE` (default `disable`)

## Usage
Run from the repo root:

```
./bin/gsicr init-db
./bin/gsicr seed
./bin/gsicr add --scholar "Ava Torres" --partner "FirstGen Alliance" --call-date 2026-02-05 --outcome attended --follow-up 2026-02-12 --notes "Needs FAFSA support."
./bin/gsicr list --limit 10
./bin/gsicr summary
./bin/gsicr follow-ups --days 21
```

## Tests
```
sbcl --non-interactive \
  --eval '(require :asdf)' \
  --eval '(require :quicklisp)' \
  --eval '(push #P"/Users/ralph/projects/groupscholar-intro-call-registry/" asdf:*central-registry*)' \
  --eval '(ql:quickload :groupscholar-intro-call-registry/tests)' \
  --eval '(gsicr-tests:run-tests)'
```

## Notes
- Production database credentials are required for runtime operations.
- Schema definition is in `sql/schema.sql`.
