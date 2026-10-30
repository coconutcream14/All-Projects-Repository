create table if not exists public.bingo_squares (
  id integer primary key check (id between 0 and 24),
  text text not null,
  checked boolean not null default false,
  check (id <> 12 or checked)
);

alter table public.bingo_squares
  drop constraint if exists bingo_squares_text_check;

alter table public.bingo_squares
  drop constraint if exists bingo_squares_text_length_check;

alter table public.bingo_squares
  add constraint bingo_squares_text_length_check check (char_length(text) <= 100);

alter table public.bingo_squares enable row level security;

insert into public.bingo_squares (id, text, checked) values
  (0, 'Get a new FAV♡RITE teacher 🍎', false),
  (1, 'Have a perfect-fit day 👚', false),
  (2, 'Make a new friend 𖠋𖠋', false),
  (3, 'Tardy to class (5+ min) 😟', false),
  (4, 'Try a new drink 🍹', false),
  (5, '💯 on a test', false),
  (6, 'Pick up a new hobby 🛹', false),
  (7, 'Take a picture you love', false),
  (8, 'Fail a test 😬', false),
  (9, 'School supplies break ✏🥀', false),
  (10, 'Make weekend plans (with me!) 💙💖', false),
  (11, 'Forget to charge your phone overnight 😕', false),
  (12, 'FREE SPACE', true),
  (13, 'Book date! Find a book you end up LOVING 📖', false),
  (14, 'Try a new recipe (baking, cooking, etc.) 🍲', false),
  (15, 'Make a core memory 🧠', false),
  (16, 'Go to a fun event 🪩', false),
  (17, 'Have a really good lunch 😋', false),
  (18, 'Finish a big assignment 🥳', false),
  (19, 'Give someone a compliment 😊', false),
  (20, 'Laugh till you cry (but not actually) 🤣', false),
  (21, 'Have a no-stress morning 😌', false),
  (22, 'Do something outside your comfort zone 🫨', false),
  (23, 'Make it through finals week 📚😰', false),
  (24, 'Celebrate a little win 👏', false)
on conflict (id) do update
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
grant update (checked) on public.bingo_squares to anon;
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
  game_id text primary key check (game_id in ('catcher', 'memory', 'bunny', 'treats')),
  best_score integer not null,
  completion_count integer not null default 0,
  updated_at timestamptz not null default now(),
  check (
    (game_id = 'memory' and best_score between 8 and 10000) or
    (game_id = 'treats' and best_score = 15) or
    (game_id in ('catcher', 'bunny') and best_score between 0 and 10000)
  )
);

alter table public.minigame_records
  add column if not exists completion_count integer not null default 0;

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

create or replace function public.record_minigame_best(p_game_id text, p_score integer)
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
  if p_game_id is null or p_score is null or p_game_id not in ('catcher', 'memory', 'bunny', 'treats') then
    raise exception 'Invalid mini-game score.';
  end if;

  if p_score < 0 or p_score > 10000
    or (p_game_id = 'memory' and p_score < 8)
    or (p_game_id = 'treats' and p_score <> 15) then
    raise exception 'Mini-game score is outside the allowed range.';
  end if;

  insert into public.minigame_records (game_id, best_score, completion_count, updated_at)
  values (p_game_id, p_score, 1, now())
  on conflict (game_id) do nothing;
  get diagnostics inserted_rows = row_count;

  if inserted_rows = 1 then
    return true;
  end if;

  select best_score into previous_best
  from public.minigame_records
  where game_id = p_game_id
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
  where game_id = p_game_id;

  return score_improved;
end;
$$;

revoke all on function public.record_minigame_best(text, integer) from public, anon, authenticated;
grant execute on function public.record_minigame_best(text, integer) to anon, authenticated;
