create schema if not exists gs_intro_call_registry;

create table if not exists gs_intro_call_registry.intro_calls (
  id bigserial primary key,
  scholar_name text not null,
  partner_org text not null,
  call_date date not null,
  outcome text not null,
  follow_up_date date,
  notes text,
  created_at timestamptz not null default now()
);
