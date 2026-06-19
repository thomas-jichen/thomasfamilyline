# Thomas Family Line · 托马斯家庭礼物专线

A shared, bilingual family gift wishlist. Each family member has a "line" of
wish *tickets*; anyone in the family can add wishes, mark a "most-wanted" one,
and **claim** an item ("I'll get this") so two people don't buy the same gift.

Built from the Claude Design prototype (`Family Gifts App.dc.html`), recreated
as a single static page and wired to **Supabase** for shared, realtime state —
everyone who opens the link sees the same list, and claims update live.

## Files

| File | What it is |
|---|---|
| `index.html` | The whole app — UI + logic, no build step. |
| `config.js` | Your Supabase URL + anon key. The one file you edit. |
| `supabase-schema.sql` | Run once in Supabase to create the shared `items` table. |

## How state works

- **Configured** (`config.js` filled in): reads/writes a shared Supabase `items`
  table, subscribes to realtime changes → everyone sees the same data live.
- **Not configured**: falls back to `localStorage` on the one device, seeded with
  the 20 sample wishes — handy for previewing, but **not** shared.

A small pill at the top of the screen shows the mode: `LIVE · 实时同步`,
`LOCAL ONLY · 仅本机`, or `OFFLINE · 离线`.

The 7 family members (`m1`–`m7`: 丁丁 / 妈妈 / 爸爸 / 大姨 / 姑姑 / 阿公 / 爷爷) are
defined in `index.html`; gift items live in Supabase.

---

## Setup (one time, ~5 min)

### 1. Create a free Supabase project
1. Go to <https://supabase.com> → sign in → **New project**.
2. Pick a name (e.g. `family-line`), set a database password (save it somewhere),
   choose the nearest region, and create. Free tier is plenty for a family.

### 2. Create the table
1. In the project, open **SQL Editor → New query**.
2. Paste the entire contents of `supabase-schema.sql` and click **Run**.
   - This creates the `items` table, enables anon read/write, turns on realtime,
     and seeds the 20 sample wishes. (Skip the seed block at the bottom if you'd
     rather start empty.)

### 3. Wire up config.js
1. In Supabase: **Project Settings → API**.
2. Copy **Project URL** and the **`anon` `public`** key.
3. Open `config.js` and paste them in:
   ```js
   window.APP_CONFIG = {
     SUPABASE_URL: "https://abcd1234.supabase.co",
     SUPABASE_ANON_KEY: "eyJhbGci...the-long-anon-key...",
   };
   ```
   The anon key is meant to be public — RLS in the schema controls what it can do.

### 4. Try it locally
From this folder:
```bash
python3 -m http.server 8000
```
Open <http://localhost:8000>. The top pill should say **LIVE · 实时同步**.
Open it in two browser windows and claim an item in one — it should update in
the other within a second.

---

## Deploy to Vercel (free)

The app is fully static, so deployment is just hosting these files.

**Option A — drag & drop (no Git):**
1. Go to <https://vercel.com> → sign in.
2. **Add New… → Project → Deploy a static folder**, or use the Vercel
   "drop a folder" page and drag this `FamilyLine` folder in.
3. Done — you get a `*.vercel.app` URL to send to the family.

**Option B — from Git:**
1. Push this folder to a GitHub repo.
2. In Vercel: **Add New… → Project → Import** the repo.
3. Framework preset: **Other**. No build command, output dir = root.
4. Deploy.

Either way, `config.js` ships with the site (the anon key is safe to publish).
To rotate keys or point at a different project later, edit `config.js` and redeploy.

> Custom domain: in the Vercel project → **Settings → Domains**.

---

## Notes / etiquette

- This is an **authless, shared** list — security is "don't share the link
  outside the family." Anyone with the link can add/edit/claim/delete.
- "Claim" is advisory: it shows *who* is preparing a gift so it stays a surprise
  for the recipient and avoids duplicates.
- To start over, run `delete from public.items;` in the SQL Editor (then re-run
  the seed block if you want the samples back).
# thomasfamilyline
