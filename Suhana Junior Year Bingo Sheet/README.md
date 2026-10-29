# Junior Year Bingo

A pastel, interactive bingo board for Subaba's junior year. GitHub Pages hosts the site and Supabase stores one shared board, so check-offs appear for everyone with the link. The public website is designed for playing: visitors can mark squares and pick a square, but it does not include owner sign-in, prompt-editing, or reset controls.

## One-time setup

### 1. Create the shared board in Supabase

1. Create a free project at [supabase.com](https://supabase.com/).
2. Open **SQL Editor**, create a query, paste in [`setup.sql`](./setup.sql), and replace both instances of `YOUR_EMAIL@example.com` with the email address that will own the board. Run the query.
3. In **Project Settings → API**, copy the Project URL and the public/anon API key. Use the Project URL exactly as shown (it should end in `.supabase.co`); do not add `/rest/v1/`. Never use or publish a `service_role` or secret key in this website.
4. Open [`config.js`](./config.js) and replace `YOUR_PROJECT_ID` and `YOUR_SUPABASE_PUBLIC_KEY` with the Project URL and public/anon key.

### 2. Change prompts when needed

After changing prompts in `setup.sql`, run the **entire updated file** in your Supabase project's **SQL Editor**. This inserts missing squares and updates the text of existing squares while preserving their checked-off status. Editing or pushing the file in GitHub alone does not change the Supabase board. The website intentionally has no prompt-edit or sign-in buttons.

The updated setup file also creates the shared mini-game leaderboard. Run the **latest complete version** in the SQL Editor before using the leaderboard, even if you ran an earlier version; it safely updates the score rules and replaces the score-saving function. Because Kitty Memory and Puppy Treat Tap have new goals, the migration clears their old best scores and completion counts once; Paw Catcher and Bunny Hop records stay intact.

You can also change one prompt directly in Supabase's **Table Editor** by opening `public.bingo_squares` and editing its `text` value.

### Reset the mini-game leaderboard

The public website does not have a clear button, so visitors cannot erase the shared scores. To remove your test scores before sharing the link, open the Supabase project's **SQL Editor** and run this as the project owner:

```sql
delete from public.minigame_records;
```

This clears all four games' best scores and Puppy Treat Tap completion counts. Afterward, new Puppy Treat Tap finishes will be counted normally.
If scores already existed before the completion counter was added, their count starts at zero because earlier finishes were not tracked.

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

- Anyone with the link can check or uncheck squares; changes are saved in Supabase and sync to other visitors.
- **Pick a square** chooses an unchecked prompt, scrolls it into view, and highlights it with a paw marker for a few seconds.
- Gentle synthesized sound effects accompany board taps, hearts, bingo wins, mini-game actions, powers, and completions. Use the **Sound on/off** button in the board header to mute or restore them; no audio files are downloaded.
- Clicking a baby animal opens its photo popup. Tap an animal (including its opened photo) to send up a pink ribbon heart (💝); tapping empty page space sends up a different colored heart each time. Buttons and bingo squares keep their normal actions. Completing a row, column, or diagonal gets its own animal reaction and colorful celebration.
- **Take a tiny game break** opens four cute mini-games, all separate from the shared bingo board. Each has a rechargeable power with an on-screen energy bar: Paw Catcher's paw magnet (M) pulls animals toward the basket; Kitty Memory's peek (P) briefly reveals unmatched cards; Puppy Treat Tap's time-freeze (F) pauses treat timers; and Bunny Hop has a carrot dash (→ or Shift) that speeds up hazards but doubles carrots, plus a separate invincibility shield (X) that blocks puddle penalties. Bunny Hop powers each have their own bar. Paw Catcher gets faster as the round goes on, Kitty Memory has 8 pairs, Bunny Hop has a quicker obstacle pace in its 30-second run, and Puppy Treat Tap has a 15-treat goal with a quicker spawn pace and only two treats visible at once. **Subaba's da winner!** below the game button saves the best for each completed game: most caught animals or carrots, fewest Kitty Memory moves, and Puppy Treat Tap's completion count.
- The board has no website controls for editing prompts or clearing everyone's check-offs. Change prompts through the Supabase dashboard if needed.
- The database uses row-level security and column-level grants: the public role can update only bingo `checked` status and submit mini-game scores through a score-checking function, while prompt edits require the configured owner account. Since the site has no player sign-in, visitors can submit scores to the shared leaderboard; it is intended for fun, not as a tamper-proof competition.
