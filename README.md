# The Kitchen

Personal recipe app. React + Vite + Supabase + Vercel.

## Setup

### 1. Supabase

1. Create a new Supabase project at https://supabase.com
2. Go to **SQL Editor** and paste + run the contents of `supabase/seed.sql`
   - This creates the `recipes` table, disables RLS, seeds all 35 recipes, and creates the `recipe-photos` storage bucket
3. Copy your project URL and anon key from **Settings → API**

### 2. Environment variables

Copy `.env.example` to `.env.local` and fill in:

```
VITE_SUPABASE_URL=https://xxxx.supabase.co
VITE_SUPABASE_ANON_KEY=your_anon_key
VITE_PASSPHRASE=kitchen
ANTHROPIC_API_KEY=your_anthropic_api_key
```

### 3. Local dev

```bash
npm install
npm run dev
```

### 4. Deploy to Vercel

1. Push to GitHub
2. Import repo in Vercel
3. Add the same environment variables in **Vercel → Settings → Environment Variables**
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
   - `VITE_PASSPHRASE`
   - `ANTHROPIC_API_KEY` (used by `/api/autofill.js` serverless function)
4. Deploy

## Stack

- **React + Vite** — UI
- **Supabase** — PostgreSQL database + Storage for photos
- **Vercel** — Hosting + serverless functions
- **Anthropic API** — AI autofill (text and photo)

## Photo storage

Photos are uploaded to a public Supabase Storage bucket (`recipe-photos`). The `photo_url` (public CDN URL) and `photo_path` (for deletion) are stored on the recipe row.

## Data model

```sql
recipes (
  id, created_at, name, category, author,
  tags text[],
  servings int,
  ing_groups jsonb,   -- [{label, items: [{amt, item}]}]
  steps jsonb,        -- [{text, subs: []}]
  notes text,
  photo_url text,
  photo_path text,
  want_try boolean
)
```
