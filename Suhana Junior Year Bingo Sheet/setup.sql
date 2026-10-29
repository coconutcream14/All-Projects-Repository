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
  (0, 'get a new FAV♡RITE teacher 🍎', false),
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
  (14, 'Try a new recipe (baking, cooking, whatever your 💗 desires) 🍲', false),
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
