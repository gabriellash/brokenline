# BrokenLine.io

Real-time multiplayer AI Telephone game. Players pass sentences through a free AI artist — each person only sees the drawing, never the original words.

## Setup (5 minutes)

### 1. Create a free Supabase project

1. Go to [supabase.com](https://supabase.com) and sign in (free tier is fine)
2. Click **New project**, pick a name and region, wait ~1 min for it to spin up
3. In your project sidebar go to **Settings → API**
4. Copy **Project URL** and **anon public** key

### 2. Add your credentials

Open `config.js` and replace the placeholders:

```js
const SUPABASE_URL = 'https://xxxxxxxxxxxx.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJ...';
```

### 3. Run the SQL schema

1. In Supabase sidebar click **SQL Editor**
2. Paste the entire contents of `supabase.sql`
3. Click **Run**

This creates two tables: `rooms` and `game_steps`.

### 4. Deploy to Vercel (free)

1. Push this folder to a GitHub repo (or use Vercel CLI)
2. Go to [vercel.com](https://vercel.com), import the repo
3. No build settings needed — just deploy as static files
4. Done! Share your URL.

---

## Local development

Just open `index.html` in a browser. No build step needed.  
Make sure `config.js` has your real credentials — Supabase calls go directly from the browser.

---

## How to play

1. **Host** clicks **Create Room**, enters a nickname
2. A 4-letter code appears — share it with friends
3. **Friends** click **Join Room**, enter the code + a nickname
4. Host clicks **Start Game** (min 2 players, max 8)
5. First player writes a sentence → AI draws it
6. Next player describes the AI drawing → AI draws that → repeat
7. After all turns, everyone sees the full chain reveal

---

## File structure

```
index.html    — full frontend (all screens, game logic)
config.js     — Supabase credentials (fill this in)
supabase.sql  — database schema
README.md     — this file
```

---

## Tech used

- **Frontend**: Plain HTML + CSS + vanilla JS, zero dependencies besides Supabase client
- **Realtime**: [Supabase Realtime](https://supabase.com/docs/guides/realtime) — postgres_changes subscriptions
- **AI images**: [Pollinations.ai](https://pollinations.ai) — completely free, no API key
- **Hosting**: [Vercel](https://vercel.com) free tier

---

## Supabase table overview

**rooms**
| column | type | notes |
|---|---|---|
| id | uuid | primary key |
| code | text | 4-letter room code, unique |
| host_id | text | player id of creator |
| player_count | int | denormalized count |
| current_step | int | which turn is active |
| status | text | lobby / playing / finished |
| players | jsonb | array of {id, name, isHost} |

**game_steps**
| column | type | notes |
|---|---|---|
| id | uuid | primary key |
| room_id | uuid | FK → rooms |
| step_number | int | 0-indexed turn |
| type | text | sentence or description |
| content | text | the text submitted |
| player_name | text | who submitted it |
