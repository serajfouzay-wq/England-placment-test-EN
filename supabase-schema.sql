-- ============================================================
-- EXCEL ENGLISH CENTRE — EXAM SYSTEM SCHEMA
-- Run this in Supabase SQL Editor
-- ============================================================

-- SECTION CONFIG (controls order, time limits, active state)
create table if not exists section_config (
  id           uuid primary key default gen_random_uuid(),
  section_key  text unique not null, -- 'listening' | 'reading' | 'speaking' | 'writing'
  label        text not null,
  icon         text not null,
  sort_order   int  not null default 0,
  is_active    boolean default true,
  time_limit   int  default 0, -- seconds, 0 = no limit
  instructions text,
  created_at   timestamptz default now()
);

-- Insert defaults
insert into section_config (section_key, label, icon, sort_order, instructions) values
  ('listening', 'Listening', '🎧', 1, 'Listen to the audio clip carefully, then choose the correct answer.'),
  ('reading',   'Reading',   '📖', 2, 'Read the passage or question carefully and select the best answer.'),
  ('speaking',  'Speaking',  '🎤', 3, 'Record yourself answering the question. You have one attempt. Speak clearly.'),
  ('writing',   'Writing',   '✍️', 4, 'Write your answer in full sentences. Your response will be automatically scored.')
on conflict (section_key) do nothing;

-- QUESTIONS
create table if not exists questions (
  id            uuid primary key default gen_random_uuid(),
  section_key   text not null references section_config(section_key) on delete cascade,
  sort_order    int  not null default 0,
  question_text text not null,
  image_url     text,          -- optional image for reading/writing
  audio_url     text,          -- required for listening questions
  question_type text not null default 'mcq', -- 'mcq' | 'written'
  options       jsonb,         -- ["Option A", "Option B", "Option C", "Option D"]
  correct_index int,           -- 0-based index of correct option (mcq)
  answer_keywords jsonb,       -- ["keyword1","keyword2"] for writing auto-score
  score_threshold int default 60, -- % of keywords needed to pass writing q
  points        int  default 1,
  is_active     boolean default true,
  created_at    timestamptz default now()
);

-- TEST SESSIONS (one per student attempt)
create table if not exists test_sessions (
  id              uuid primary key default gen_random_uuid(),
  full_name       text not null,
  email           text not null,
  phone           text not null,
  consent_given   boolean default false,
  started_at      timestamptz default now(),
  completed_at    timestamptz,
  total_score     int,
  max_score       int,
  cefr_level      text,
  section_scores  jsonb, -- { listening: {score,max}, reading: {score,max}, ... }
  source_url      text,
  flagged         boolean default false, -- anti-cheat flag
  flag_reason     text
);

-- ANSWERS (one row per question per session)
create table if not exists answers (
  id              uuid primary key default gen_random_uuid(),
  session_id      uuid not null references test_sessions(id) on delete cascade,
  question_id     uuid not null references questions(id) on delete cascade,
  section_key     text not null,
  question_text   text,
  student_answer  text,        -- chosen option text or written response
  chosen_index    int,         -- for MCQ
  is_correct      boolean,
  auto_score      int,         -- 0-100 for writing
  speaking_url    text,        -- Supabase storage URL for speaking recording
  answered_at     timestamptz default now()
);

-- ADMIN USERS (simple, hashed password)
create table if not exists admin_users (
  id           uuid primary key default gen_random_uuid(),
  username     text unique not null,
  password_hash text not null,
  created_at   timestamptz default now()
);

-- ── ROW LEVEL SECURITY ─────────────────────────────────────

alter table section_config  enable row level security;
alter table questions        enable row level security;
alter table test_sessions    enable row level security;
alter table answers          enable row level security;
alter table admin_users      enable row level security;

-- Public can read active sections and questions (for the exam)
create policy "public read sections"  on section_config for select using (is_active = true);
create policy "public read questions" on questions      for select using (is_active = true);

-- Public can insert sessions and answers (submitting exam)
create policy "public insert sessions" on test_sessions for insert with check (true);
create policy "public insert answers"  on answers       for insert with check (true);

-- IMPORTANT: service_role key bypasses RLS (use in admin panel only)
-- The anon key cannot read other users' sessions or admin_users

-- ── STORAGE BUCKETS ────────────────────────────────────────
-- Run these in Supabase Dashboard → Storage → New Bucket:
--   1. "audio-questions" (public: true)   — teacher uploads question audio
--   2. "speaking-videos" (public: false)  — student video recordings
--   3. "question-images" (public: true)   — images attached to questions

-- Storage policies for public upload of speaking videos:
-- (run in SQL editor)
-- insert into storage.buckets (id, name, public) values ('speaking-videos', 'speaking-videos', false);
-- insert into storage.buckets (id, name, public) values ('audio-questions', 'audio-questions', true);
-- insert into storage.buckets (id, name, public) values ('question-images', 'question-images', true);

-- Allow anon to upload to speaking-videos
create policy "anon upload speaking"
  on storage.objects for insert
  with check (bucket_id = 'speaking-videos');

-- Allow public to read audio and images
create policy "public read audio"
  on storage.objects for select
  using (bucket_id in ('audio-questions', 'question-images'));
