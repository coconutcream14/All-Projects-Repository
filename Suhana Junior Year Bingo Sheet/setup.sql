create table if not exists public.bingo_squares (
  id integer primary key check (id between 0 and 24),
  text text not null check (char_length(text) <= 46),
  checked boolean not null default false,
  check (id <> 12 or checked)
);

alter table public.bingo_squares enable row level security;

insert into public.bingo_squares (id, text, checked) values
  (0, 'Find a new favorite song', false),
  (1, 'Have a perfect-fit outfit day', false),
  (2, 'Make a new friend', false),
  (3, 'Laugh until you cry', false),
  (4, 'Try a new drink', false),
  (5, 'Get a teacher shout-out', false),
  (6, 'Have a cute study date', false),
  (7, 'Take a picture you love', false),
  (8, 'Win a game or competition', false),
  (9, 'Have a main-character moment', false),
  (10, 'Make weekend plans', false),
  (11, 'Ace a test you studied for', false),
  (12, 'FREE SPACE', true),
  (13, 'Have a hallway catch-up', false),
  (14, 'Try a new hairstyle', false),
  (15, 'Make a core memory', false),
  (16, 'Go to a school event', false),
  (17, 'Have a really good lunch', false),
  (18, 'Finish a big assignment', false),
  (19, 'Give someone a compliment', false),
  (20, 'Get the whole group laughing', false),
  (21, 'Have a no-stress morning', false),
  (22, 'Do something outside your comfort zone', false),
  (23, 'Make it through finals week', false),
  (24, 'Celebrate a little win', false)
on conflict (id) do nothing;

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
