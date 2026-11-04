# Supabase learning-data sync design (proposal only)

Status: design proposal; **not deployed** and does not change the current local-only behavior.

## Current implementation verified

`lib/services/learning_progress.dart` uses `shared_preferences`. It stores the following locally:

- Completed lesson IDs and per-lesson attempt counters.
- Learned word IDs, recall streaks, and next-review timestamps.
- Quiz aggregates and up to 100 quiz-history entries.
- Missed-question prompts and detailed review cards.
- Per-level best scores and up to 100 level-assessment attempts.
- Up to 400 local calendar activity dates.
- Up to 100 offline conversation-practice results.

No remote sync is implemented by this service today. The app should remain usable offline.

## Proposed relational model

Use Supabase Auth as the identity source. Every learner-owned row carries `user_id` referencing `auth.users(id)`; do not accept a user ID supplied by the client as proof of ownership.

| Table | Purpose | Natural uniqueness |
|---|---|---|
| `learner_settings` | Minimal sync preferences (locale, timezone) | `user_id` |
| `lesson_progress` | Completion and attempt count per lesson | `user_id, lesson_id` |
| `learned_words` | Learned vocabulary IDs | `user_id, word_id` |
| `word_reviews` | Recall streak and next review timestamp | `user_id, word_id` |
| `quiz_attempts` | Individual quiz results | `user_id, client_event_id` |
| `level_assessment_attempts` | Placement/level assessment results | `user_id, client_event_id` |
| `conversation_attempts` | Offline scenario practice results | `user_id, client_event_id` |
| `missed_questions` | User's mistake-review cards | `user_id, client_event_id` |
| `learning_activity_days` | Local calendar activity dates | `user_id, activity_date` |

Use UUID `client_event_id` values generated once on the device for append-only attempts. Retrying an upload then uses the same ID and cannot create duplicate attempts. Keep content/catalog data (lessons, questions, answer keys) separate from learner records; never upload answer keys or lesson-bank content as user progress.

## Proposed SQL

This SQL is a reviewable starting point, not a migration to apply to an unknown project. Run it only after confirming the dedicated Turkishly Supabase project and reviewing the schema in a development environment.

```sql
create table if not exists public.learner_settings (
  user_id uuid primary key references auth.users(id) on delete cascade,
  locale text not null default 'ar',
  timezone text,
  updated_at timestamptz not null default now()
);

create table if not exists public.lesson_progress (
  user_id uuid not null references auth.users(id) on delete cascade,
  lesson_id text not null,
  attempt_count integer not null default 0 check (attempt_count >= 0),
  completed_at timestamptz,
  updated_at timestamptz not null default now(),
  primary key (user_id, lesson_id)
);

create table if not exists public.learned_words (
  user_id uuid not null references auth.users(id) on delete cascade,
  word_id text not null,
  learned_at timestamptz not null default now(),
  primary key (user_id, word_id)
);

create table if not exists public.word_reviews (
  user_id uuid not null references auth.users(id) on delete cascade,
  word_id text not null,
  recall_streak integer not null default 0 check (recall_streak >= 0),
  due_at timestamptz,
  updated_at timestamptz not null default now(),
  primary key (user_id, word_id)
);

create table if not exists public.quiz_attempts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  client_event_id uuid not null,
  score integer not null check (score >= 0),
  total integer not null check (total >= 0 and score <= total),
  percent integer not null check (percent between 0 and 100),
  source text not null default 'quiz',
  completed_at timestamptz not null,
  created_at timestamptz not null default now(),
  unique (user_id, client_event_id)
);

create table if not exists public.level_assessment_attempts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  client_event_id uuid not null,
  level text not null check (level in ('A1','A2','B1','B2','C1','C2')),
  score integer not null check (score >= 0),
  total integer not null check (total >= 0 and score <= total),
  percent integer not null check (percent between 0 and 100),
  completed_at timestamptz not null,
  created_at timestamptz not null default now(),
  unique (user_id, client_event_id)
);

create table if not exists public.conversation_attempts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  client_event_id uuid not null,
  scenario_id text not null,
  title text not null,
  level text not null check (level in ('A1','A2','B1','B2','C1','C2')),
  score integer not null check (score >= 0),
  total integer not null check (total >= 0 and score <= total),
  percent integer not null check (percent between 0 and 100),
  completed_at timestamptz not null,
  created_at timestamptz not null default now(),
  unique (user_id, client_event_id)
);

create table if not exists public.missed_questions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  client_event_id uuid not null,
  prompt text not null,
  selected_answer text,
  correct_answer text,
  explanation text,
  topic text,
  unit_id text,
  lesson_number integer check (lesson_number is null or lesson_number > 0),
  lesson_title text,
  source text,
  updated_at timestamptz not null default now(),
  unique (user_id, client_event_id)
);

create table if not exists public.learning_activity_days (
  user_id uuid not null references auth.users(id) on delete cascade,
  activity_date date not null,
  created_at timestamptz not null default now(),
  primary key (user_id, activity_date)
);

-- Enable row-level security on every table exposed through the Data API.
alter table public.learner_settings enable row level security;
alter table public.lesson_progress enable row level security;
alter table public.learned_words enable row level security;
alter table public.word_reviews enable row level security;
alter table public.quiz_attempts enable row level security;
alter table public.level_assessment_attempts enable row level security;
alter table public.conversation_attempts enable row level security;
alter table public.missed_questions enable row level security;
alter table public.learning_activity_days enable row level security;

-- A learner can read and mutate only rows owned by their authenticated UID.
create policy "learner owns settings" on public.learner_settings
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "learner owns lesson progress" on public.lesson_progress
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "learner owns learned words" on public.learned_words
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "learner owns word reviews" on public.word_reviews
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "learner owns quiz attempts" on public.quiz_attempts
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "learner owns level assessments" on public.level_assessment_attempts
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "learner owns conversation attempts" on public.conversation_attempts
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "learner owns missed questions" on public.missed_questions
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "learner owns activity days" on public.learning_activity_days
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create index if not exists quiz_attempts_user_completed_idx
  on public.quiz_attempts (user_id, completed_at desc);
create index if not exists level_assessment_user_completed_idx
  on public.level_assessment_attempts (user_id, completed_at desc);
create index if not exists conversation_attempts_user_completed_idx
  on public.conversation_attempts (user_id, completed_at desc);
create index if not exists missed_questions_user_updated_idx
  on public.missed_questions (user_id, updated_at desc);
```

## Sync and migration rules

1. Keep `shared_preferences` as the offline cache; remote sync is an opt-in capability after sign-in.
2. Never upload until the learner is authenticated and has consented to cloud sync.
3. On first sync, map legacy local IDs to rows owned by the signed-in UID. Preserve timestamps where present; generate a stable `client_event_id` once per local attempt and persist it locally before upload.
4. Upsert state tables using their natural keys. Insert attempt/history tables using `client_event_id` for idempotency.
5. Do not resolve conflicts by blindly overwriting newer data. Compare `updated_at`; for counters, use a deliberate merge rule rather than max-by-accident.
6. Keep sync retryable and queue pending changes locally while offline. Never put a Supabase service-role/secret key in the Flutter app.
7. Provide account export and deletion flows. Auth user deletion cascades these learner rows; local data should be retained or cleared according to an explicit user choice.
8. Confirm Data API grants/settings separately. RLS protects rows but does not itself grant table access.

## Required implementation phases

- Phase 1: provision a dedicated Turkishly Supabase project and configure Auth providers/redirect URLs.
- Phase 2: review and apply a versioned migration in a development database; run security and performance advisors.
- Phase 3: add pinned Flutter Supabase dependencies and environment configuration (publishable key only in client).
- Phase 4: implement sign-in, consent, local outbox, idempotent sync, conflict handling, and sign-out.
- Phase 5: test two accounts for cross-user isolation, offline/online retries, restore, deletion, and migration of existing local backups.

## Explicit non-actions

No Supabase project was created or modified. The currently connected Supabase account exposes a project named "Meteorology Science Academy"; it is not assumed to belong to Turkishly and must not be repurposed. This proposal must not be deployed there.
