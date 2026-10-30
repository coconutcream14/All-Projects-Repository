# Junior Year Bingo

A pastel best-friend website for Subaba's junior year. GitHub Pages hosts it, and Supabase saves the shared board and feature content so updates appear for everyone. Its pages include bingo, mini-games, a photo memory wall, milestone badges, a daily question, and a compliment jar.

## One-time setup

### 1. Create the shared board in Supabase

1. Create a free project at [supabase.com](https://supabase.com/).
2. Open **SQL Editor**, create a query, paste in [`setup.sql`](./setup.sql), and replace both instances of `YOUR_EMAIL@example.com` with the email address that will own the board. Run the query.
3. In **Project Settings → API**, copy the Project URL and the public/anon API key. Use the Project URL exactly as shown (it should end in `.supabase.co`); do not add `/rest/v1/`. Never use or publish a `service_role` or secret key in this website.
4. Open [`config.js`](./config.js) and replace `YOUR_PROJECT_ID` and `YOUR_SUPABASE_PUBLIC_KEY` with the Project URL and public/anon key.

### 2. Set up and edit shared features

Run the **entire latest** [`setup.sql`](./setup.sql) file in your Supabase project's **SQL Editor**. It creates or updates both bingo boards, separate Subaba and Tabya mini-game leaderboards, heart counters, memory wall, personal and shared badge records, daily questions and answers, and compliment jar. Re-running it preserves existing check-offs, prompts, scores, hearts, memories, answers, compliments, and earned badges. Existing bingo and mini-game progress is assigned to Subaba; Tabya's new board starts with the same prompts and its free space checked.

Use **Subaba's board** and **Tabya's board** to switch between separate progress on the same prompts. Edit bingo prompts in **Edit bingo prompts** below the board; updates are shared by both boards. The Memory Wall lets either visitor add, edit, or delete entries and photos, with the author chosen from Subaba and Tabya. The question page lets visitors edit the question jar and their daily answers. The Compliments page lets visitors edit the shared compliment jar and send saved messages. Mini-game records and each person's bingo and mini-game achievements save separately; shared badges unlock when both boards reach the same milestone.

The website's new shared tables allow public read/write access so both friends can edit without signing in. The website and its content are public: do not add private information or photos unless everyone pictured agrees to share them. Photos are resized and stored in the Supabase database; each uploaded image is limited to about 640 KB.

The setup file also updates mini-game score rules and the score-saving function. If Kitty Memory or Puppy Treat Tap records already exist from the earlier game goals, their best scores and completion counts are cleared once; Paw Catcher and Bunny Hop records remain intact and are assigned to Subaba. Heart counters start at zero when first created, and subsequent setup runs preserve their totals.

### Reset the mini-game leaderboard

The public website does not have a clear button, so visitors cannot erase the shared scores. To remove your test scores before sharing the link, open the Supabase project's **SQL Editor** and run this as the project owner:

```sql
delete from public.minigame_records;
```

This clears all four games' best scores and Puppy Treat Tap completion counts. Afterward, new Puppy Treat Tap finishes will be counted normally.
If scores already existed before the completion counter was added, their count starts at zero because earlier finishes were not tracked.

### Reset the heart counters

The heart counts normally only increase, and rerunning `setup.sql` preserves them. To correct a mistaken test tap or start both at zero, open Supabase **SQL Editor** and run this as the project owner:

```sql
update public.heart_counters
set heart_count = 0
where counter_id in ('to_best_friend', 'from_best_friend');
```

This reset is not available on the public website. Page taps can add hearts again after the reset.

### Reset the compliment jar and sent history

To clear test compliments and sent-message history while restoring the original starter messages, run this one time in the Supabase project's **SQL Editor** as the project owner. This is intentionally separate from `setup.sql`, so future setup runs will not erase shared content.

```sql
begin;

delete from public.compliment_history;
delete from public.compliment_messages;

insert into public.compliment_messages (message) values
  ('You make ordinary days feel special.'),
  ('I am so lucky to have you in my corner.'),
  ('You make people feel seen and loved.'),
  ('Your laugh is one of my favorite sounds.'),
  ('You are stronger than you give yourself credit for.'),
  ('Being your best friend is one of my favorite things.'),
  ('You make hard days a little easier.'),
  ('You deserve every good thing coming your way.');

commit;
```

The public website cannot clear sent history; its anonymous access intentionally does not allow deleting history rows.

### Reset the memory wall

To permanently remove every shared memory and uploaded photo, run this as the project owner in Supabase **SQL Editor**:

```sql
delete from public.memory_wall_entries;
```

This cannot be undone, and the website intentionally has no public clear-all control.

### Reset badges and achievements

Achievements are automatically re-earned when their requirements are still met. To clear all personal and shared badges and start earning them again, reset the bingo progress and mini-game records in the same transaction:

```sql
begin;

update public.bingo_squares
set checked = (id = 12);

delete from public.minigame_records;
delete from public.bingo_badges;
delete from public.shared_bingo_achievements;

commit;
```

This keeps both boards' prompts but unchecks their squares (the free space remains checked), clears mini-game scores and finish counts, and deletes personal and shared badges. It is not reversible. The website intentionally has no public clear-all control.

### Reset the question-of-the-day jar and answers

To clear all questions and saved answers and restore the original starter questions, run this one time as the project owner in Supabase **SQL Editor**. This reset is separate from `setup.sql`, so future setup runs will not erase QOTD content.

```sql
begin;

delete from public.daily_answers;
delete from public.daily_questions;

insert into public.daily_questions (question) values
  ('What is one tiny thing that made you smile today?'),
  ('What song feels like our friendship right now?'),
  ('What is a memory of us that always makes you laugh?'),
  ('What is something you are excited to do together?'),
  ('What is one thing you admire about your best friend?'),
  ('If today had a theme song, what would it be?'),
  ('What is a little win you want to celebrate this week?'),
  ('What would our perfect best-friend day look like?');

commit;
```

This permanently removes both people's saved answers as well as edited questions.

### 3. Add your own animal pictures (optional)

Click any baby animal around the board to open its picture popup. To add a photo:

1. Create an `animals` folder beside `index.html` inside `Suhana Junior Year Bingo Sheet`.
2. Add your pictures to that folder with these exact names:
   - `baby-chick.jpg`
   - `baby-bunny.jpg`
   - `baby-bear.jpg`
   - `baby-cat.jpg`
   - `baby-puppy.jpg`
3. Use your own photos or images you have permission to share. If you have a PNG or WebP instead, either save it as the listed `.jpg` filename or update that animal's `data-photo` in `index.html` to match the real filename.
4. Commit/push the pictures along with your changes. Until a picture exists, its popup shows the animal emoji and tells you which filename to add.

### 4. Publish with GitHub Pages

1. Save and push these repository changes to the `main` branch.
2. On GitHub, open **Settings → Pages** and select **GitHub Actions** as the build and deployment source.
3. The included workflow publishes the *contents* of the bingo folder at the repository's Pages root. After its first successful run, open:
   [https://coconutcream14.github.io/All-Projects-Repository/](https://coconutcream14.github.io/All-Projects-Repository/)
4. Send that link to your friend. The Pages site and Supabase database stay online without your computer or a local development server running.

GitHub Pages is available for public repositories on GitHub Free. If this repository is private, use a hosting plan that supports private-repository Pages or deploy the folder to another static host.

## Using the board

- The navigation tabs open full pages for the bingo board, mini-games, memory wall, badges, question of the day, and compliments.
- Use **Twilight mode** beside **Sound on/off** in the board header to switch between the original palette and a starry dark theme. The choice is saved in this browser.
- The “I made you a bingo card” note sits alongside the full **Whose junior year?** board-picker block, above the board and timeline; the mini-games are opened from the **Mini-games** navigation tab.
- Anyone with the link can check or uncheck squares and edit the prompts; changes are saved in Supabase and sync to other visitors.
- **Pick a square** chooses an unchecked prompt, scrolls it into view, and highlights it with a paw marker for a few seconds.
- The two **Our hearts** buttons keep shared totals. At the start of each visit, select either **Subaba's hearts** (🩷) or **Tabya's hearts** (🩵); that choice is highlighted. Page taps that make floating hearts—including taps on an opened animal picture—then increment the selected shared counter. Select the other counter to switch where future taps are counted, or tap the selected counter again to deselect it. With no counter selected, floating hearts still appear but do not change either total. The choice lasts for the current page visit; the totals are saved to Supabase and remain between visits.
- The included [`deep_thought.mp3`](./deep_thought.mp3) plays whenever someone makes a floating heart. It is bundled with the website, so visitors do not need to choose the file on each device. The other gentle synthesized effects accompany board actions and mini-games. Use **Sound on/off** in the board header to mute or restore all sound effects.
- Clicking a baby animal opens its photo popup. Tap an animal (including its opened photo) to send up a pink ribbon heart (💝); tapping empty page space sends up a different colored heart each time. Buttons and bingo squares keep their normal actions. Completing a row, column, or diagonal gets its own animal reaction and colorful celebration.
- **Mini-games** is a full page with two shared leaderboards and four games, all separate from the bingo board. Choose **Subaba** or **Tabya** before picking a game; only that player's scores and completion counts are updated. Each game has a rechargeable power with an on-screen energy bar: Paw Catcher's paw magnet (M) pulls animals toward the basket; Kitty Memory's peek (P) briefly reveals unmatched cards; Puppy Treat Tap's time-freeze (F) pauses treat timers; and Bunny Hop has a carrot dash (→ or Shift) that speeds up hazards but doubles carrots, plus a separate invincibility shield (X) that blocks puddle penalties. Bunny Hop powers each have their own bar. Paw Catcher gets faster as the round goes on, Kitty Memory has 8 pairs, Bunny Hop has a quicker obstacle pace in its 30-second run, and Puppy Treat Tap has a 15-treat goal with a quicker spawn pace and only two treats visible at once. Each player's leaderboard saves their own best for every game: most caught animals or carrots, fewest Kitty Memory moves, and Puppy Treat Tap's completion count.
- **Memory wall** saves and displays shared photos, notes, titles, and author names. Entries can be added, edited, and deleted from the website.
- **Badges** unlock and save bingo milestones and mini-game achievements separately for Subaba and Tabya, plus shared badges when both reach a bingo milestone. Mini-game badges include playing all four games, catching 10 animals, solving Kitty Memory in 20 moves or fewer, collecting 25 Bunny Hop carrots, and finishing Puppy Treat Tap five times. New badges get a full-page celebration with a shortcut to this page. Earned badges stay saved even if squares are later unchecked.
- **Question of the day** picks a shared question each day from an editable question jar. Both friends can save and update their own answer for that question and date.
- **Compliments** lets either person send a random message from the editable shared jar. Sent messages are saved in a shared history.
- Shared feature content, board prompts, heart totals, mini-game scores, and badge unlocks are stored in Supabase. Row-level security is enabled, but the public site has no sign-in: anyone who can reach the site can edit its shared content and submit gameplay data. Heart totals can only be incremented through the site, but they are for fun—not a tamper-proof record.
