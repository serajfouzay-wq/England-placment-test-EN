-- Multi-centre data model for the reusable English-centre template.
-- Run this in the Supabase SQL editor, then add Auth/RLS policies appropriate to the live dashboard.
create extension if not exists pgcrypto;

create table if not exists centres (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  name text not null,
  public_settings jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create table if not exists courses (
  id uuid primary key default gen_random_uuid(),
  centre_id uuid not null references centres(id) on delete cascade,
  name text not null,
  description text,
  cefr_min text,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists placement_attempts (
  id uuid primary key default gen_random_uuid(),
  centre_id uuid not null references centres(id) on delete cascade,
  started_at timestamptz not null default now(),
  completed_at timestamptz,
  raw_score smallint,
  cefr_level text,
  focus_change_count smallint not null default 0,
  answers jsonb not null default '[]'::jsonb
);

create table if not exists leads (
  id uuid primary key default gen_random_uuid(),
  centre_id uuid not null references centres(id) on delete cascade,
  placement_attempt_id uuid references placement_attempts(id) on delete set null,
  full_name text not null,
  email text not null,
  phone text not null,
  purpose text,
  consent_given boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists leads_centre_created_idx on leads(centre_id, created_at desc);
create index if not exists attempts_centre_created_idx on placement_attempts(centre_id, started_at desc);

alter table centres enable row level security;
alter table courses enable row level security;
alter table placement_attempts enable row level security;
alter table leads enable row level security;

-- Do not use broad anonymous SELECT policies for leads or attempts.
-- Add narrowly scoped insert policies or an Edge Function after adding CAPTCHA/rate limiting.
