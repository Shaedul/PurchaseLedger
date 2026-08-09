# Purchase Ledger — Setup & Deploy Guide

A free, installable app for logging daily vendor purchases, shared live across
everyone who uses it, with a monthly total report.

This version is fully independent of Claude — once deployed, it runs on your
own free hosting and free database, forever, with no Claude account needed.

---

## What you need (both free, no credit card)

1. A **Supabase** account — [supabase.com](https://supabase.com) (open-source
   database platform, generous free tier)
2. A **GitHub** account — [github.com](https://github.com) (to host the app
   files for free via GitHub Pages)

---

## Step 1 — Create your database (Supabase)

1. Go to [supabase.com](https://supabase.com), sign up free, click **New Project**.
2. Pick any name/region, set a database password (save it somewhere), wait ~2 minutes for it to spin up.
3. In the left sidebar, open **SQL Editor** → **New query**.
4. Open `supabase-schema.sql` (included in this folder), copy all of it, paste into the editor, click **Run**.
   This creates your `items`, `entries`, and `last_seen` tables and turns on live sync.
5. In the left sidebar, open **Project Settings → API**. You'll see:
   - **Project URL** (looks like `https://xxxxxxxx.supabase.co`)
   - **anon public** key (a long string)

   Keep this tab open — you'll need both in the next step.

---

## Step 2 — Connect the app to your database

1. Open `config.js` (included in this folder) in any text editor.
2. Replace the two placeholder lines with your real values from Step 1:
   ```js
   window.SUPABASE_URL = "https://xxxxxxxx.supabase.co";
   window.SUPABASE_ANON_KEY = "your-long-anon-key-here";
   ```
3. Save the file.

---

## Step 3 — Put it online (GitHub Pages, free)

1. Create a new **public** repository on GitHub, e.g. `purchase-ledger`.
2. Upload all the files from this folder into it:
   - `index.html`
   - `config.js` (with your real values from Step 2)
   - `manifest.json`
   - `service-worker.js`
   - `icons/icon-192.png`
   - `icons/icon-512.png`
   (You don't need to upload `supabase-schema.sql` or this README — they're just setup helpers.)
3. In the repo, go to **Settings → Pages**.
4. Under **Source**, choose the `main` branch and `/ (root)` folder, click **Save**.
5. After a minute, GitHub shows your live URL — something like:
   `https://yourusername.github.io/purchase-ledger/`

That URL is your app. Share it with anyone on your team.

> Any free static host works the same way if you'd rather use one of these
> instead of GitHub Pages: **Netlify**, **Vercel**, or **Cloudflare Pages** —
> all support drag-and-drop deploy of this same folder.

---

## Step 4 — Install it on a phone

**Android (Chrome):**
Open the URL → tap the **⋮** menu → **Install app** (or **Add to Home screen**).

**iPhone (Safari — must be Safari, not Chrome):**
Open the URL → tap the **Share** icon → **Add to Home Screen**.

It'll appear as a normal app icon and open full-screen, no browser bar.

---

## How data & notifications work now

- All data lives in your Supabase database — anyone who opens the app can add,
  edit, or delete entries, and changes sync **instantly** to everyone else who
  has it open (no more waiting/refreshing).
- The bell icon shows a badge for entries added by others since you last checked.
- This "instant sync" only reaches devices where the app is currently **open**.
  It is not the same as a phone notification banner when the app is closed —
  that needs one more layer (Web Push), described below.

---

## Optional next step: real push notifications (even when the app is closed)

This needs:
- Generating a VAPID key pair
- Adding push-subscription handling to the service worker
- A small serverless function (a Supabase Edge Function works well) that
  fires a push whenever a new row is inserted into `entries`

It's a bigger, separate piece of work — happy to build it whenever you're
ready to add it.

---

## Security note

There's no real login (no password, no OTP) — name and phone number are just
labels people type in, not verified. Anyone who has your app's URL, and your
Supabase URL + anon key (which live in `config.js`, visible in the page
source), can read and write your data. This matches how the app has worked
from the start — fine for a small trusted team, not meant for public/sensitive use.
