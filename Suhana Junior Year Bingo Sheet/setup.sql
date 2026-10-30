create table if not exists public.bingo_squares (
  player_name text not null default 'Subaba',
  id integer not null check (id between 0 and 24),
  text text not null,
  checked boolean not null default false,
  check (id <> 12 or checked),
  primary key (player_name, id)
);

alter table public.bingo_squares
  add column if not exists player_name text not null default 'Subaba';

alter table public.bingo_squares
  drop constraint if exists bingo_squares_player_name_check;

alter table public.bingo_squares
  add constraint bingo_squares_player_name_check
  check (player_name in ('Subaba', 'Tabya'));

do $$
declare
  primary_key_name text;
begin
  select conname
  into primary_key_name
  from pg_constraint
  where conrelid = 'public.bingo_squares'::regclass
    and contype = 'p';

  if primary_key_name is not null then
    execute format('alter table public.bingo_squares drop constraint %I', primary_key_name);
  end if;

  alter table public.bingo_squares
    add constraint bingo_squares_pkey primary key (player_name, id);
end;
$$;

alter table public.bingo_squares
  drop constraint if exists bingo_squares_text_check;

alter table public.bingo_squares
  drop constraint if exists bingo_squares_text_length_check;

alter table public.bingo_squares
  add constraint bingo_squares_text_length_check check (char_length(text) <= 100);

alter table public.bingo_squares enable row level security;

insert into public.bingo_squares (player_name, id, text, checked) values
  ('Subaba', 0, 'Get a new FAV♡RITE teacher 🍎', false),
  ('Subaba', 1, 'Have a perfect-fit day 👚', false),
  ('Subaba', 2, 'Make a new friend 𖠋𖠋', false),
  ('Subaba', 3, 'Tardy to class (5+ min) 😟', false),
  ('Subaba', 4, 'Try a new drink 🍹', false),
  ('Subaba', 5, '💯 on a test', false),
  ('Subaba', 6, 'Pick up a new hobby 🛹', false),
  ('Subaba', 7, 'Take a picture you love', false),
  ('Subaba', 8, 'Fail a test 😬', false),
  ('Subaba', 9, 'School supplies break ✏🥀', false),
  ('Subaba', 10, 'Make weekend plans (with me!) 💙💖', false),
  ('Subaba', 11, 'Forget to charge your phone overnight 😕', false),
  ('Subaba', 12, 'FREE SPACE', true),
  ('Subaba', 13, 'Book date! Find a book you end up LOVING 📖', false),
  ('Subaba', 14, 'Try a new recipe (baking, cooking, etc.) 🍲', false),
  ('Subaba', 15, 'Make a core memory 🧠', false),
  ('Subaba', 16, 'Go to a fun event 🪩', false),
  ('Subaba', 17, 'Have a really good lunch 😋', false),
  ('Subaba', 18, 'Finish a big assignment 🥳', false),
  ('Subaba', 19, 'Give someone a compliment 😊', false),
  ('Subaba', 20, 'Laugh till you cry (but not actually) 🤣', false),
  ('Subaba', 21, 'Have a no-stress morning 😌', false),
  ('Subaba', 22, 'Do something outside your comfort zone 🫨', false),
  ('Subaba', 23, 'Make it through finals week 📚😰', false),
  ('Subaba', 24, 'Celebrate a little win 👏', false)
on conflict (player_name, id) do nothing;

insert into public.bingo_squares (player_name, id, text, checked)
select 'Tabya', id, text, id = 12
from public.bingo_squares
where player_name = 'Subaba'
on conflict (player_name, id) do update
  set text = excluded.text;

drop policy if exists "Anyone can read the board" on public.bingo_squares;
create policy "Anyone can read the board"
  on public.bingo_squares for select
  to anon, authenticated
  using (true);

drop policy if exists "Anyone can check squares" on public.bingo_squares;
create policy "Anyone can check squares"
  on public.bingo_squares for update
  to anon
  using (true)
  with check (true);

drop policy if exists "Only the owner can edit prompts" on public.bingo_squares;
create policy "Only the owner can edit prompts"
  on public.bingo_squares for update
  to authenticated
  using (lower(auth.jwt() ->> 'email') = lower('ts9877@pleasantonusd.net'))
  with check (lower(auth.jwt() ->> 'email') = lower('ts9877@pleasantonusd.net'));

revoke all on public.bingo_squares from anon, authenticated;
grant select on public.bingo_squares to anon, authenticated;
grant update (checked, text) on public.bingo_squares to anon;
grant update (checked, text) on public.bingo_squares to authenticated;

create table if not exists public.heart_counters (
  counter_id text primary key check (counter_id in ('to_best_friend', 'from_best_friend')),
  heart_count bigint not null default 0 check (heart_count >= 0)
);

insert into public.heart_counters (counter_id, heart_count) values
  ('to_best_friend', 0),
  ('from_best_friend', 0)
on conflict (counter_id) do nothing;

alter table public.heart_counters enable row level security;
revoke all on public.heart_counters from public, anon, authenticated;

create or replace function public.get_heart_counters()
returns table (counter_id text, heart_count text)
language sql
stable
security definer
set search_path = ''
as $$
  select counters.counter_id, counters.heart_count::text
  from public.heart_counters as counters
  order by counters.counter_id;
$$;

revoke all on function public.get_heart_counters() from public, anon, authenticated;
grant execute on function public.get_heart_counters() to anon, authenticated;

create or replace function public.increment_heart_counter(p_counter_id text)
returns table (counter_id text, heart_count text)
language plpgsql
security definer
set search_path = ''
as $$
declare
  new_heart_count text;
begin
  if p_counter_id is null or p_counter_id not in ('to_best_friend', 'from_best_friend') then
    raise exception 'Invalid heart counter.';
  end if;

  update public.heart_counters as counters
  set heart_count = counters.heart_count + 1
  where counters.counter_id = p_counter_id
  returning counters.heart_count::text into new_heart_count;

  if new_heart_count is null then
    raise exception 'Heart counter could not be updated.';
  end if;

  return query select p_counter_id, new_heart_count;
end;
$$;

revoke all on function public.increment_heart_counter(text) from public, anon, authenticated;
grant execute on function public.increment_heart_counter(text) to anon, authenticated;

create table if not exists public.minigame_records (
  player_name text not null default 'Subaba' check (player_name in ('Subaba', 'Tabya')),
  game_id text not null check (game_id in ('catcher', 'memory', 'bunny', 'treats')),
  best_score integer not null,
  completion_count integer not null default 0,
  updated_at timestamptz not null default now(),
  primary key (player_name, game_id),
  check (
    (game_id = 'memory' and best_score between 8 and 10000) or
    (game_id = 'treats' and best_score = 15) or
    (game_id in ('catcher', 'bunny') and best_score between 0 and 10000)
  )
);

alter table public.minigame_records
  add column if not exists completion_count integer not null default 0;

alter table public.minigame_records
  add column if not exists player_name text not null default 'Subaba';

alter table public.minigame_records
  drop constraint if exists minigame_records_player_name_check;

alter table public.minigame_records
  add constraint minigame_records_player_name_check
  check (player_name in ('Subaba', 'Tabya'));

do $$
begin
  if exists (
    select 1
    from pg_constraint
    where conrelid = 'public.minigame_records'::regclass
      and conname = 'minigame_records_check'
  ) then
    delete from public.minigame_records where game_id in ('memory', 'treats');
    alter table public.minigame_records drop constraint minigame_records_check;
  end if;
end;
$$;

do $$
declare
  primary_key_name text;
begin
  select conname
  into primary_key_name
  from pg_constraint
  where conrelid = 'public.minigame_records'::regclass
    and contype = 'p';

  if primary_key_name is not null then
    execute format('alter table public.minigame_records drop constraint %I', primary_key_name);
  end if;

  alter table public.minigame_records
    add constraint minigame_records_pkey primary key (player_name, game_id);
end;
$$;

alter table public.minigame_records
  drop constraint if exists minigame_records_difficulty_check;

alter table public.minigame_records
  add constraint minigame_records_difficulty_check check (
    (game_id = 'memory' and best_score between 8 and 10000) or
    (game_id = 'treats' and best_score = 15) or
    (game_id in ('catcher', 'bunny') and best_score between 0 and 10000)
  );

alter table public.minigame_records enable row level security;

drop policy if exists "Anyone can read mini-game records" on public.minigame_records;
create policy "Anyone can read mini-game records"
  on public.minigame_records for select
  to anon, authenticated
  using (true);

revoke all on public.minigame_records from public, anon, authenticated;
grant select on public.minigame_records to anon, authenticated;

drop function if exists public.record_minigame_best(text, integer);

create or replace function public.record_minigame_best(
  p_player_name text,
  p_game_id text,
  p_score integer
)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  score_improved boolean := false;
  inserted_rows integer;
  previous_best integer;
begin
  if p_player_name is null or p_player_name not in ('Subaba', 'Tabya')
    or p_game_id is null or p_score is null
    or p_game_id not in ('catcher', 'memory', 'bunny', 'treats') then
    raise exception 'Invalid mini-game score.';
  end if;

  if p_score < 0 or p_score > 10000
    or (p_game_id = 'memory' and p_score < 8)
    or (p_game_id = 'treats' and p_score <> 15) then
    raise exception 'Mini-game score is outside the allowed range.';
  end if;

  insert into public.minigame_records (player_name, game_id, best_score, completion_count, updated_at)
  values (p_player_name, p_game_id, p_score, 1, now())
  on conflict (player_name, game_id) do nothing;
  get diagnostics inserted_rows = row_count;

  if inserted_rows = 1 then
    return true;
  end if;

  select best_score into previous_best
  from public.minigame_records
  where player_name = p_player_name and game_id = p_game_id
  for update;

  if previous_best is null then
    raise exception 'Mini-game record could not be loaded.';
  end if;

  score_improved := (p_game_id = 'memory' and p_score < previous_best)
    or (p_game_id <> 'memory' and p_score > previous_best);

  update public.minigame_records
  set best_score = case when score_improved then p_score else previous_best end,
      completion_count = completion_count + 1,
      updated_at = now()
  where player_name = p_player_name and game_id = p_game_id;

  return score_improved;
end;
$$;

revoke all on function public.record_minigame_best(text, text, integer) from public, anon, authenticated;
grant execute on function public.record_minigame_best(text, text, integer) to anon, authenticated;

create table if not exists public.memory_wall_entries (
  id uuid primary key default gen_random_uuid(),
  author text not null check (char_length(btrim(author)) between 1 and 40),
  title text not null check (char_length(btrim(title)) between 1 and 100),
  note text not null default '' check (char_length(note) <= 2000),
  photo_data text,
  created_at timestamptz not null default now(),
  check (
    photo_data is null or (
      char_length(photo_data) <= 850000 and
      photo_data ~ '^data:image/jpeg;base64,[A-Za-z0-9+/=]+$'
    )
  )
);

alter table public.memory_wall_entries enable row level security;
revoke all on public.memory_wall_entries from public, anon, authenticated;
grant select, insert, update, delete on public.memory_wall_entries to anon, authenticated;
drop policy if exists "Anyone can manage shared memory wall" on public.memory_wall_entries;
create policy "Anyone can manage shared memory wall"
  on public.memory_wall_entries for all
  to anon, authenticated
  using (true)
  with check (true);

create table if not exists public.daily_questions (
  id uuid primary key default gen_random_uuid(),
  question text not null unique check (char_length(btrim(question)) between 1 and 280),
  created_at timestamptz not null default now()
);

insert into public.daily_questions (question) values
  ('What is one tiny thing that made you smile today?'),
  ('What song feels like our friendship right now?'),
  ('What is a memory of us that always makes you laugh?'),
  ('What is something you are excited to do together?'),
  ('What is one thing you admire about your best friend?'),
  ('If today had a theme song, what would it be?'),
  ('What is a little win you want to celebrate this week?'),
  ('What would our perfect best-friend day look like?')
on conflict (question) do nothing;

alter table public.daily_questions enable row level security;
revoke all on public.daily_questions from public, anon, authenticated;
grant select, insert, update, delete on public.daily_questions to anon, authenticated;
drop policy if exists "Anyone can manage shared daily questions" on public.daily_questions;
create policy "Anyone can manage shared daily questions"
  on public.daily_questions for all
  to anon, authenticated
  using (true)
  with check (true);

create table if not exists public.daily_answers (
  question_id uuid not null references public.daily_questions(id) on delete cascade,
  question_date date not null,
  player_name text not null check (player_name in ('Subaba', 'Tabya')),
  answer text not null check (char_length(btrim(answer)) between 1 and 1000),
  updated_at timestamptz not null default now(),
  primary key (question_id, question_date, player_name)
);

alter table public.daily_answers enable row level security;
revoke all on public.daily_answers from public, anon, authenticated;
grant select, insert, update, delete on public.daily_answers to anon, authenticated;
drop policy if exists "Anyone can manage shared daily answers" on public.daily_answers;
create policy "Anyone can manage shared daily answers"
  on public.daily_answers for all
  to anon, authenticated
  using (true)
  with check (true);

create table if not exists public.compliment_messages (
  id uuid primary key default gen_random_uuid(),
  message text not null unique check (char_length(btrim(message)) between 1 and 500),
  created_at timestamptz not null default now()
);

insert into public.compliment_messages (message) values
  ('You make ordinary days feel special.'),
  ('I am so lucky to have you in my corner.'),
  ('You make people feel seen and loved.'),
  ('Your laugh is one of my favorite sounds.'),
  ('You are stronger than you give yourself credit for.'),
  ('Being your best friend is one of my favorite things.'),
  ('You make hard days a little easier.'),
  ('You deserve every good thing coming your way.')
on conflict (message) do nothing;

alter table public.compliment_messages enable row level security;
revoke all on public.compliment_messages from public, anon, authenticated;
grant select, insert, update, delete on public.compliment_messages to anon, authenticated;
drop policy if exists "Anyone can manage shared compliments" on public.compliment_messages;
create policy "Anyone can manage shared compliments"
  on public.compliment_messages for all
  to anon, authenticated
  using (true)
  with check (true);

create table if not exists public.compliment_history (
  id uuid primary key default gen_random_uuid(),
  message text not null check (char_length(btrim(message)) between 1 and 500),
  sender text not null check (sender in ('Subaba', 'Tabya')),
  recipient text not null check (recipient in ('Subaba', 'Tabya')),
  created_at timestamptz not null default now(),
  check (sender <> recipient)
);

alter table public.compliment_history enable row level security;
revoke all on public.compliment_history from public, anon, authenticated;
grant select, insert on public.compliment_history to anon, authenticated;
drop policy if exists "Anyone can read shared compliment history" on public.compliment_history;
create policy "Anyone can read shared compliment history"
  on public.compliment_history for select
  to anon, authenticated
  using (true);
drop policy if exists "Anyone can send shared compliments" on public.compliment_history;
create policy "Anyone can send shared compliments"
  on public.compliment_history for insert
  to anon, authenticated
  with check (true);

create table if not exists public.bingo_badges (
  player_name text not null default 'Subaba' check (player_name in ('Subaba', 'Tabya')),
  badge_id text not null check (badge_id in ('first_bingo', 'half_board', 'full_board')),
  primary key (player_name, badge_id),
  earned_at timestamptz not null default now()
);

alter table public.bingo_badges
  add column if not exists player_name text not null default 'Subaba';

alter table public.bingo_badges
  drop constraint if exists bingo_badges_player_name_check;

alter table public.bingo_badges
  add constraint bingo_badges_player_name_check
  check (player_name in ('Subaba', 'Tabya'));

do $$
declare
  primary_key_name text;
begin
  select conname
  into primary_key_name
  from pg_constraint
  where conrelid = 'public.bingo_badges'::regclass
    and contype = 'p';

  if primary_key_name is not null then
    execute format('alter table public.bingo_badges drop constraint %I', primary_key_name);
  end if;

  alter table public.bingo_badges
    add constraint bingo_badges_pkey primary key (player_name, badge_id);
end;
$$;

alter table public.bingo_badges enable row level security;
revoke all on public.bingo_badges from public, anon, authenticated;
grant select, insert on public.bingo_badges to anon, authenticated;
drop policy if exists "Anyone can read shared bingo badges" on public.bingo_badges;
create policy "Anyone can read shared bingo badges"
  on public.bingo_badges for select
  to anon, authenticated
  using (true);
drop policy if exists "Anyone can earn shared bingo badges" on public.bingo_badges;
create policy "Anyone can earn shared bingo badges"
  on public.bingo_badges for insert
  to anon, authenticated
  with check (true);

create table if not exists public.shared_bingo_achievements (
  achievement_id text primary key check (
    achievement_id in ('shared_first_bingo', 'shared_half_board', 'shared_full_board')
  ),
  earned_at timestamptz not null default now()
);

alter table public.shared_bingo_achievements enable row level security;
revoke all on public.shared_bingo_achievements from public, anon, authenticated;
grant select, insert on public.shared_bingo_achievements to anon, authenticated;
drop policy if exists "Anyone can read shared bingo achievements" on public.shared_bingo_achievements;
create policy "Anyone can read shared bingo achievements"
  on public.shared_bingo_achievements for select
  to anon, authenticated
  using (true);
drop policy if exists "Anyone can earn shared bingo achievements" on public.shared_bingo_achievements;
create policy "Anyone can earn shared bingo achievements"
  on public.shared_bingo_achievements for insert
  to anon, authenticated
  with check (true);
