# Junior Year Bingo

A pink, interactive bingo board for Suhana's junior year. GitHub Pages hosts the site and Supabase stores one shared board, so check-offs appear for everyone with the link. The board text can only be changed by the owner email configured in Supabase's row-level security policy.

## One-time setup

### 1. Create the shared board in Supabase

1. Create a free project at [supabase.com](https://supabase.com/).
2. Open **SQL Editor**, create a query, paste in [`setup.sql`](./setup.sql), and replace both instances of `YOUR_EMAIL@example.com` with the email address that will own the board. Run the query.
3. In **Project Settings → API**, copy the Project URL and the public/anon API key. Never use or publish a `service_role` or secret key in this website.
4. Open [`config.js`](./config.js) and replace `YOUR_PROJECT_ID`, `YOUR_SUPABASE_PUBLIC_KEY`, and `YOUR_EMAIL@example.com` with the project URL, public/anon key, and the same owner email.

### 2. Allow the website to sign in its owner

After the site has its GitHub Pages URL:

1. In Supabase, open **Authentication → URL Configuration**.
2. Set **Site URL** to the Pages URL below and add that same URL to **Redirect URLs**:
   `https://coconutcream14.github.io/All-Projects-Repository/Suhana%20Junior%20Year%20Bingo%20Sheet/`
3. Make sure email sign-in is enabled under **Authentication → Providers → Email**.

The owner selects **Owner sign in**, enters the configured email, and follows the one-time link sent by email. Supabase checks the owner email in the database policy; the UI alone does not grant edit permission.

### 3. Publish with GitHub Pages

1. Save and push these repository changes to the `main` branch.
2. On GitHub, open **Settings → Pages** and select **GitHub Actions** as the build and deployment source.
3. The included workflow deploys the bingo folder. After its first successful run, open:
   [https://coconutcream14.github.io/All-Projects-Repository/Suhana%20Junior%20Year%20Bingo%20Sheet/](https://coconutcream14.github.io/All-Projects-Repository/Suhana%20Junior%20Year%20Bingo%20Sheet/)
4. Send that link to your friend. The Pages site and Supabase database stay online without your computer or a local development server running.

GitHub Pages is available for public repositories on GitHub Free. If this repository is private, use a hosting plan that supports private-repository Pages or deploy the folder to another static host.

## Using the board

- Anyone with the link can check or uncheck squares; changes are saved in Supabase and sync to other visitors.
- Only the configured owner email can edit square text. Changes save to the shared board for everyone.
- **Pick a square** chooses an unchecked prompt. **Start fresh** clears check-offs but keeps custom prompts.
- The database uses row-level security and column-level grants: the public role can update only `checked`, while prompt edits require the configured owner account.
